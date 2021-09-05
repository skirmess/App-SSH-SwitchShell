#!perl

use 5.006;
use strict;
use warnings;

use Test::More 0.88;

use Cwd;
use File::Basename ();
use File::Spec     ();
use lib File::Spec->catdir( File::Basename::dirname( Cwd::abs_path __FILE__ ), 'lib' );

use Local::Test::TempDir qw(tempdir);

use Capture::Tiny qw(capture);

use lib qw(.);

main();

sub main {
    require_ok('bin/sshss') or BAIL_OUT();

    package App::SSH::SwitchShell;
    use subs 'getpwuid';

    package main;

    my $tmpdir = tempdir();

    my $shell_from_getpwuid = "$tmpdir/sh";
    open my $fh, '>', $shell_from_getpwuid or BAIL_OUT("Cannot write file $shell_from_getpwuid: $!");
    close $fh or BAIL_OUT("Cannot write file $shell_from_getpwuid: $!");

    _chmod( 0755, $shell_from_getpwuid );

    my @getpwuid_ref = ( 'username', 'x', 1000, 1000, q{}, q{}, q{}, '/tmp', $shell_from_getpwuid );

    *App::SSH::SwitchShell::getpwuid = sub {
        return @getpwuid_ref;
    };

  SKIP: {
        skip qq{File '$shell_from_getpwuid' is not executable - chmod 755 doesn't work as expected on this platform}, 1 if !-x $shell_from_getpwuid;

        local $ENV{SHELL} = '/bin/dummy';
        local @ARGV = ("$tmpdir/does_not_exist");
        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_shell() };
        is( $result[0],  $shell_from_getpwuid,                              "'$tmpdir/does_not_exist' returns shell from getpwuid()" );
        is( $ENV{SHELL}, $shell_from_getpwuid,                              '... SHELL env variable is set correctly' );
        is( $stdout,     q{},                                               '... prints nothing to STDOUT' );
        is( $stderr,     "Shell '$tmpdir/does_not_exist' does not exist\n", '... prints that non existing shell does not exist to STDERR' );
    }

    my $shell_1 = "$tmpdir/testshell";
    open $fh, '>', $shell_1 or BAIL_OUT("Cannot write file $shell_1: $!");
    close $fh or BAIL_OUT("Cannot write file $shell_1: $!");

    _chmod( 0644, $shell_1 );
  SKIP: {
        skip qq{File '$shell_1' is executable - chmod 644 doesn't work as expected on this platform}, 1 if -x $shell_1;

        local $ENV{SHELL} = '/bin/dummy';
        local @ARGV = ($shell_1);
        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_shell() };
        is( $result[0],  $shell_from_getpwuid,                   "'$shell_1' (not executable) returns shell from getpwuid()" );
        is( $ENV{SHELL}, $shell_from_getpwuid,                   '... SHELL env variable is set correctly' );
        is( $stdout,     q{},                                    '... prints nothing to STDOUT' );
        is( $stderr,     "Shell '$shell_1' is not executable\n", '... prints that shell is not executable to STDERR' );
    }

    _chmod( 0755, $shell_1 );
  SKIP: {
        skip qq{File '$shell_1' is not executable - chmod 755 doesn't work as expected on this platform}, 1 if !-x $shell_1;

        local $ENV{SHELL} = '/bin/dummy';
        local @ARGV = ($shell_1);
        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_shell() };
        is( $result[0],  $shell_1, "'$shell_1' (executable) returns '$shell_1'" );
        is( $ENV{SHELL}, $shell_1, '... SHELL env variable is set correctly' );
        is( $stdout,     q{},      '... prints nothing to STDOUT' );
        is( $stderr,     q{},      '... prints nothing to STDERR' );
    }

    {
        my $cwd = cwd();
        _chdir($tmpdir);

        local $ENV{SHELL} = '/bin/dummy';
        local @ARGV = ('testshell');
        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_shell() };
        is( $result[0],  $shell_from_getpwuid,                          q{'testshell' returns shell from getpwuid()} );
        is( $ENV{SHELL}, $shell_from_getpwuid,                          '... SHELL env variable is set correctly' );
        is( $stdout,     q{},                                           '... prints nothing to STDOUT' );
        is( $stderr,     "Shell 'testshell' is not an absolute path\n", '... prints that shell is not absolute path to STDERR' );

        _chdir($cwd);
    }

    _chmod( 0644, $shell_from_getpwuid );
  SKIP: {
        skip qq{File '$shell_from_getpwuid' is executable - chmod 644 doesn't work as expected on this platform}, 1 if -x $shell_from_getpwuid;

        local $ENV{SHELL} = '/bin/dummy';
        local @ARGV = ();
        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_shell() };
        is( $result[0],  $shell_from_getpwuid, "no shell specified as argument returns '$shell_from_getpwuid' (not executable) from getpwuid()" );
        is( $ENV{SHELL}, $shell_from_getpwuid, '... SHELL env variable is set correctly' );
        is( $stdout,     q{},                  '... prints nothing to STDOUT' );
        is( $stderr,     q{},                  '... prints nothing to STDERR' );
    }

    _chmod( 0644, $shell_1 );
  SKIP: {
        skip qq{File '$shell_1' is executable - chmod 644 doesn't work as expected on this platform}, 1 if -x $shell_1;

        local $ENV{SHELL} = '/bin/dummy';
        local @ARGV = ($shell_1);
        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_shell() };
        is( $result[0],  $shell_from_getpwuid,                   "'$shell_1' (not executbale) returns '$shell_from_getpwuid' (not executable) from getpwuid()" );
        is( $ENV{SHELL}, $shell_from_getpwuid,                   '... SHELL env variable is set correctly' );
        is( $stdout,     q{},                                    '... prints nothing to STDOUT' );
        is( $stderr,     "Shell '$shell_1' is not executable\n", "... prints that '$shell_1' is not executable to STDERR" );
    }

    {
        my $cwd = cwd();
        _chdir($tmpdir);

        local $ENV{SHELL} = '/bin/dummy';
        local @ARGV = ('testshell');
        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_shell() };
        is( $result[0],  $shell_from_getpwuid,                          "'testshell' returns '$shell_from_getpwuid' (not executable) from getpwuid()" );
        is( $ENV{SHELL}, $shell_from_getpwuid,                          '... SHELL env variable is set correctly' );
        is( $stdout,     q{},                                           '... prints nothing to STDOUT' );
        is( $stderr,     "Shell 'testshell' is not an absolute path\n", '... prints not absolute path error message to STDERR' );

        _chdir($cwd);
    }

    #
    done_testing();

    exit 0;
}

sub _chdir {
    my ($dir) = @_;

    my $rc = chdir $dir;
    BAIL_OUT("chdir $dir: $!") if !$rc;
    return $rc;
}

sub _chmod {
    my $rc = chmod @_;
    BAIL_OUT("chmod @_: $!") if !$rc;
    return $rc;
}

# vim: ts=4 sts=4 sw=4 et: syntax=perl
