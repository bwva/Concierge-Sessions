# Concierge - Integrated User Management Service Platform

**Version:** 0.7.0

Concierge is a cohesive suite of Perl modules for web application user management,
providing a complete service platform for authentication, user data management,
and session management.

## Current Status

**Concierge::Sessions** is the first module available in the Concierge suite.

Additional modules (Concierge::Auth, Concierge::Users) are under development.

## Installation

Standard CPAN installation:

```bash
cpanm Concierge::Sessions
# OR
perl Makefile.PL
make
make test
make install
```

## Requirements

- Perl 5.36 or later
- DBI (for SQLite backend)
- JSON::PP (core in Perl 5.14+)
- Test2::V0 (for testing)

## Concierge::Sessions - Session Management

Comprehensive session management system with:

- **Multiple backends**: SQLite (production), File (testing/fallback)
- **Sliding window expiration**: Sessions auto-extend when users are active
- **Indefinite sessions**: Application-wide sessions that never expire
- **Opaque data storage**: Application controls data structure
- **Explicit persistence**: No auto-save, changes tracked with dirty flag
- **Single-session enforcement**: One active session per user
- **Modern Perl**: v5.36+ with contemporary best practices

### Quick Start

```perl
use Concierge::Sessions;

# Create session manager
my $sessions = Concierge::Sessions->new(
    backend => 'SQLite',
    storage_dir => '/var/app/sessions',
);

# Create user session
my $result = $sessions->new_session(
    user_id => 'user123',
    data => {
        cart => [],
        preferences => { theme => 'dark' },
    },
);

if ($result->{success}) {
    my $session = $result->{session};

    # Read session data
    my $data_result = $session->get_data();
    my $data = $data_result->{value};

    # Update session data
    $data->{cart} = ['item1', 'item2'];
    $session->set_data($data);

    # Save changes (extends session timeout)
    $session->save();
}

# Retrieve session later
my $retrieved = $sessions->get_session($session_id);
```

### Features

**Sliding Window Expiration**
- Sessions automatically extend when `save()` is called
- Active users stay logged in; inactive users expire
- No special "extend session" logic needed

**Indefinite Sessions**
```perl
# Application-wide state tracking
my $app_session = $sessions->new_session(
    user_id         => 'application_main',
    session_timeout => 'indefinite',
    data            => {
        metrics    => { requests_processed => 0 },
        subsystems => { database => 'connected' },
    },
);
```

**Multiple Backends**
- **SQLite**: Default, high performance (4K-5K ops/sec)
- **File**: Simple, human-readable JSON format

### Documentation

Full API documentation is available in the module POD:
```bash
perldoc Concierge::Sessions
perldoc Concierge::Sessions::Session
```

### Testing

```bash
# Run all tests
prove -lv t/

# Run specific test file
prove -lv t/01-sessions-manager.t
```

Test coverage: 75 tests across 4 test files, all passing.

### Examples

See the `examples/` directory for usage examples:
- `04-indefinite-session.pl` - Application-wide session demonstration

### Design Philosophy

Concierge modules are designed to:

- **Work standalone** or as part of the integrated platform
- **Provide service-oriented APIs** with consistent return values
- **Use modern Perl** (v5.36+) with contemporary best practices
- **Support multiple backends** for flexibility
- **Maintain clear separation** of concerns

### Roadmap

The complete Concierge platform will provide:

- **Concierge::Auth** - Authentication services (in development)
- **Concierge::Users** - User data management (in development)
- **Concierge::Sessions** - Session management (AVAILABLE)
- **Concierge** - Unified service composer (future)

### Support & Contributing

Please report issues via the CPAN request tracker for this distribution.

### Author

Your Name

### License

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl 5 itself. See [perlartistic](https://dev.perl.org/licenses/artistic.html).

### See Also

- [Concierge::Sessions](https://metacpan.org/pod/Concierge::Sessions)
- [DBI](https://metacpan.org/pod/DBI) - Database interface
- [JSON::PP](https://metacpan.org/pod/JSON::PP) - JSON handling

## Version History

### Version 0.7.0 (Current)
- Renamed from Local::Sessions to Concierge::Sessions
- New Concierge namespace for CPAN distribution
- Sliding window session expiration
- Indefinite session support
- Multiple backend support (SQLite, File)
- 75 tests, all passing
- Production-ready

### Previous Versions
- See Local::Sessions for development history
