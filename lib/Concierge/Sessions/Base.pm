package Concierge::Sessions::Base v0.7.0;
use v5.36;

sub new {
    my ($class, %args) = @_;
    return bless {}, $class;
}

# Define interface methods that must be implemented by subclasses
sub create_session { die "Subclass must implement create_session" }
sub get_session_info { die "Subclass must implement get_session_info" }
sub update_session { die "Subclass must implement update_session" }
sub delete_session { die "Subclass must implement delete_session" }
sub cleanup_expired { die "Subclass must implement cleanup_expired" }
sub delete_user_sessions { die "Subclass must implement delete_user_sessions" }

# Utilities
sub generate_session_id {
    my $uuid = qx(uuidgen 2>/dev/null);
    if ($? == 0 and defined $uuid) {
        chomp $uuid;
        return lc $uuid;
    }
    # Fallback: UUID v4-like random token
    my $pseudo_uuid = sprintf(
        '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
        rand(0x10000), rand(0x10000),  # 8 hex digits
        rand(0x10000),                  # 4 hex digits
        (rand(0x10000) & 0x0fff) | 0x4000,  # 4 hex digits, version 4
        (rand(0x10000) & 0x3fff) | 0x8000,  # 4 hex digits, variant bits
        rand(0x10000), rand(0x10000), rand(0x10000)  # 12 hex digits
    );
    return lc $pseudo_uuid;
}

1;

__END__
