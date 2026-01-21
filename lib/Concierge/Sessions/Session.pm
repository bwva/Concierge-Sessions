package Concierge::Sessions::Session;
use v5.36;

# ABSTRACT: Individual session objects created by Concierge::Sessions

use Time::HiRes qw(time);
use JSON;
use Carp qw(croak);

sub new {
    my ($class, %args) = @_;

    my $backend	= $args{storage};

	my $create_result = $backend->create_session( %args );
    unless ($create_result->{success}) {
        return { success => 0, message => "new_session failure: " . $create_result->{message} };
    }

    # Retrieve the full created session info with timestamps, etc.
    my $get_result = $backend->get_session_info( $create_result->{session_id} );
    unless ($get_result->{success}) {
        return { success => 0, message => "new_session info failure: " . $get_result->{message} };
    }

    # Create Session object
    my $self = bless {
        $get_result->{info}->%*,
        storage => $backend,
    }, __PACKAGE__;

    return { success => 1, session => $self };
}

sub refresh {
    my ($self, %args) = @_;

    # Create Session object from session info prepared as %args
    my $session = bless { %args }, __PACKAGE__;

    return { success => 1, session => $session };
}

# Data access methods - work with entire data field
sub get_data {
    my ($self) = @_;

    # Return entire data field
    my $value = $self->{data};

    return { success => 1, value => $value };
}

sub set_data {
    my ($self, $value) = @_;

    # $value replaces entire data field
    $self->{data} 			= $value;

    # Mark as dirty - only changed in memory, not in storage
    $self->{status}{dirty}	= 1;

    return { success => 1 };
}

# Persistence method for app data, timestamped
sub save {
    my ($self) = @_;

    # Check if dirty
    my $dirty = $self->{status}{dirty} || 0;

    unless ($dirty) {
        return { success => 1 };  # Fine if not dirty
    }

    # Calculate new expiration time (sliding window extension)
    my $timeout = $self->{session_timeout};
    my $new_expires_at;
    if (defined $timeout && $timeout eq 'indefinite') {
        $new_expires_at = 'indefinite';
    } else {
        $new_expires_at = time() + $timeout;
    }

    # Update internal expires_at
    $self->{expires_at} = $new_expires_at;

    # Save session data changes and new expiration time
    my $result = $self->{storage}->update_session(
        $self->{session_id},
        {
            data => $self->{data},
            expires_at => $new_expires_at,
        }
    );

    unless ($result->{success}) {
        return { success => 0, message => "save: " . $result->{message} };
    }

    # Clear dirty flag
    $self->{status}{dirty} = 0;

    return { success => 1 };
}

# Read-only Status booleans
sub is_valid {
      my ($self) = @_;
      return ($self->is_active() && !$self->is_expired()) ? 1 : 0;
  }


sub is_active {
    my ($self) = @_;
    my $state	= $self->{status}{state} || '';
    return $state eq 'active' ? 1 : 0;
}

sub is_expired {
    my ($self) = @_;
	# Indefinite sessions never expire
    return 0 if $self->{expires_at} eq 'indefinite';
    return (time() > $self->{expires_at}) ? 1 : 0;
}

sub is_dirty {
    my ($self) = @_;
    return $self->{status}{dirty} || 0;
}

# Read-only system info
sub session_id {
    my ($self) = @_;
    return $self->{session_id};
}

sub storage_backend {
    my ($self) = @_;
    return ref($self->{storage});
}

sub created_at {
    my ($self) = @_;
    $self->{created_at};
}

sub expires_at {
    my ($self) = @_;
    $self->{expires_at};
}

sub last_updated {
    my ($self) = @_;
    return $self->{last_updated};
}

sub status {
    my ($self) = @_;
    return $self->{status} || { state => 'active', dirty => 0 };
}

1;

__END__
