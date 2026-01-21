use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Concierge-Sessions',
    VERSION_FROM     => 'lib/Concierge/Sessions.pm',
    AUTHOR           => 'Bruce Van Allen <bva@cruzio.com>',
    ABSTRACT         => 'Session management system with factory pattern and multiple backend support',
    LICENSE          => 'artistic_2',
    MIN_PERL_VERSION => '5.36',
    INSTALL_BASE     => undef,

    PREREQ_PM => {
        'Carp'       => 0,
        'DBI'        => 0,
        'DBD::SQLite' => 0,
        'JSON::PP'   => 0,
        'Time::HiRes' => 0,
        'File::Spec' => 0,
        'JSON'       => 0,
    },

    TEST_REQUIRES => {
        'Test2::V0' => 0,
    },

    EXE_FILES => [],

    PM => {
        'lib/Concierge/Sessions.pm'             => '$(INST_LIB)/Concierge/Sessions.pm',
        'lib/Concierge/Sessions/Base.pm'        => '$(INST_LIB)/Concierge/Sessions/Base.pm',
        'lib/Concierge/Sessions/Session.pm'     => '$(INST_LIB)/Concierge/Sessions/Session.pm',
        'lib/Concierge/Sessions/SQLite.pm'      => '$(INST_LIB)/Concierge/Sessions/SQLite.pm',
        'lib/Concierge/Sessions/File.pm'        => '$(INST_LIB)/Concierge/Sessions/File.pm',
    },

    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Concierge-Sessions-*' },
);
