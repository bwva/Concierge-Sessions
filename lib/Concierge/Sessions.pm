package Concierge::Sessions v0.7.0;
use v5.36;

# ABSTRACT: Session manager with flexible session information storage

use Carp qw/croak/;

use Concierge::Sessions::Session;
use Concierge::Sessions::SQLite;
use Concierge::Sessions::File;

# Default backend
our $DEFAULT_BACKEND 			= 'Concierge::Sessions::SQLite';
our $DEFAULT_SESSION_TIMEOUT	= 3600;

# Sessions manager
sub new {
    my ($class, %args) = @_;

    # Determine backend class (default: SQLite, can be specified as 'SQLite' or 'File')
    # SQLite creates and updates session records
    # File creates and overwrites session files as JSON
    my $backend_param = $args{backend} || $DEFAULT_BACKEND;
    my $backend_class = $backend_param =~ /^Concierge::Sessions::/
        ? $backend_param
        : "Concierge::Sessions::$backend_param";

    # Create backend instance
    my $backend;
    eval {
        $backend = $backend_class->new(%args);
    };
    if ($@) {
        croak "Failed to initialize backend $backend_class: $@";
    }

    my $self = bless {
        storage => $backend,
    }, $class;

    return $self;
}

# Session object
sub new_session {
    my ($self, %args) = @_;

    unless ($args{user_id}) {
        return { success => 0, message => "user_id required to create a new session" };
    }

    $args{session_timeout}	||= $DEFAULT_SESSION_TIMEOUT;
	$args{storage}			= $self->{storage};

    my $session_result 		= Concierge::Sessions::Session->new( %args );

	return $session_result;
}

sub get_session {
    my ($self, $session_id) = @_;

    unless ($session_id) {
        return { success => 0, message => "Session ID required to retrieve a session" };
    }

    # Load session info from backend
    my $result = $self->{storage}->get_session_info($session_id);

    unless ($result->{success}) {
        return { success => 0, message => "get_session_info: " . $result->{message} };
    }

	my %ses_args		= $result->{info}->%*;
	$ses_args{storage}	= $self->{storage};

    # Instantiate Refreshed Session object
    my $session_result = Concierge::Sessions::Session->refresh( %ses_args );
    unless ($session_result->{success}) {
        return { success => 0, message => "get_session: " . $session_result->{message} };
    }

	return $session_result;
}

# Administrative methods - handled by backends

# delete sessions that have expired
sub cleanup_expired {
    my ($self) = @_;
    return $self->{storage}->cleanup_expired();
}

# delete session by session_id
sub delete_session {
    my ($self, $session_id) = @_;

    unless ($session_id) {
        return { success => 0, message => "Session ID required to delete a session" };
    }

    return $self->{storage}->delete_session($session_id);
}

# delete session by user_id
sub delete_user_sessions {
    my ($self, $user_id) = @_;

    unless ($user_id) {
        return { success => 0, message => "user_id required to delete user sessions" };
    }

    return $self->{storage}->delete_user_sessions($user_id);
}


1;

__END__
