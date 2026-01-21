package Concierge v0.7.0;
use v5.36;

# ABSTRACT: Integrated user management service platform for web applications

1;

__END__

=head1 NAME

Concierge - Integrated User Management Service Platform

=head1 VERSION

version 0.7.0

=head1 DESCRIPTION

Concierge is a cohesive suite of modules for web application user management,
providing a complete service platform for authentication, user data management,
and session management.

The Concierge platform consists of:

=over 4

=item * L<Concierge::Sessions> - Session management with multiple backends

=item * L<Concierge::Auth> - Authentication services (in development)

=item * L<Concierge::Users> - User data management (in development)

=back

=head1 CURRENT STATUS

L<Concierge::Sessions> is the first module available in the Concierge suite.
It provides comprehensive session management with:

=over 4

=item * Multiple storage backends (SQLite, File)

=item * Sliding window session expiration

=item * Indefinite session support for application-wide state

=item * Opaque data storage (application controls data structure)

=item * Explicit persistence model (no auto-save)

=item * Single-session enforcement per user

=back

Additional Concierge modules (Auth, Users) are under development.

=head1 DESIGN PHILOSOPHY

Concierge modules are designed to:

=over 4

=item * Work standalone or as part of the integrated platform

=item * Provide service-oriented APIs with consistent return values

=item * Use modern Perl (v5.36+) with contemporary best practices

=item * Support multiple backend implementations for flexibility

=item * Maintain clear separation of concerns

=back

=head1 ROADMAP

The complete Concierge platform will provide:

=over 4

=item * User authentication and authorization (Concierge::Auth)

=item * User profile and data management (Concierge::Users)

=item * Session management (Concierge::Sessions) - AVAILABLE

=item * Unified service composer API - Concierge.pm itself will compose
      all three services into a single user management interface

=back

=head1 USAGE EXAMPLE

The Concierge platform is designed to simplify web application user management:

    use Concierge;
    use Concierge::Sessions;

    # Create session manager
    my $sessions = Concierge::Sessions->new(
        backend => 'SQLite',
        storage_dir => '/var/app/sessions',
    );

    # Create user session
    my $result = $sessions->new_session(
        user_id => 'user123',
        data => { cart => [], preferences => {} },
    );

    if ($result->{success}) {
        my $session = $result->{session};
        # Use session...
    }

See L<Concierge::Sessions> for complete documentation.

=head1 SUPPORT

Please report issues at the CPAN request tracker for this distribution.

=head1 AUTHOR

Your Name

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl 5 itself. See L<perlartistic>.

=head1 SEE ALSO

L<Concierge::Sessions>

=cut
