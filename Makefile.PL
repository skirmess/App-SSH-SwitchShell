use 5.006;
use strict;
use warnings;

use ExtUtils::MakeMaker;

my %WriteMakefileArgs = (
    ABSTRACT           => 'use your preferred shell and own home directory for shared SSH accounts',
    AUTHOR             => 'Sven Kirmess <sven.kirmess@kzone.ch>',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    DISTNAME  => 'App-SSH-SwitchShell',
    EXE_FILES => [
        'bin/sshss',
    ],
    LICENSE          => 'open_source',
    MIN_PERL_VERSION => '5.006',
    NAME             => 'App::SSH::SwitchShell',
    PREREQ_PM        => {
        Cwd            => 0,
        English        => 0,
        'File::Spec'   => 0,
        'Getopt::Long' => 0,
        strict         => 0,
        warnings       => 0,
    },
    TEST_REQUIRES => {
        'Capture::Tiny'         => 0,
        Carp                    => 0,
        Exporter                => 0,
        'File::Basename'        => 0,
        'File::Path'            => '2.07',
        'File::Spec::Functions' => 0,
        'Test::MockModule'      => '0.14',
        'Test::More'            => '0.88',
        lib                     => 0,
        subs                    => 0,
    },
    VERSION => '0.006',
    test    => {
        TESTS => 't/*.t',
    },
);

my %FallbackPrereqs = (
    'Capture::Tiny'         => 0,
    Carp                    => 0,
    Cwd                     => 0,
    English                 => 0,
    Exporter                => 0,
    'File::Basename'        => 0,
    'File::Path'            => '2.07',
    'File::Spec'            => 0,
    'File::Spec::Functions' => 0,
    'Getopt::Long'          => 0,
    'Test::MockModule'      => '0.14',
    'Test::More'            => '0.88',
    lib                     => 0,
    strict                  => 0,
    subs                    => 0,
    warnings                => 0,
);

if ( !eval { ExtUtils::MakeMaker->VERSION('6.63_03') } ) {
    delete $WriteMakefileArgs{TEST_REQUIRES};
    delete $WriteMakefileArgs{BUILD_REQUIRES};
    $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

if ( !eval { ExtUtils::MakeMaker->VERSION(6.52) } ) {
    delete $WriteMakefileArgs{CONFIGURE_REQUIRES};
}

WriteMakefile(%WriteMakefileArgs);

# vim: ts=4 sts=4 sw=4 et: syntax=perl
