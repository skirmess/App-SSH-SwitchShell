#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl
#
# Copyright (c) 2017-2022 Sven Kirmess
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use 5.006;
use strict;
use warnings;

use Test::More 0.88;
use Test::MockModule 0.14;

use Cwd;
use File::Basename ();
use File::Spec     ();
use lib File::Spec->catdir( File::Basename::dirname( Cwd::abs_path __FILE__ ), 'lib' );

use Local::Test::TempDir qw(tempdir);

use Capture::Tiny qw(capture);
use English       qw( -no_match_vars );

use lib qw(.);

our @exec_args;
our @exit_args;

package App::SSH::SwitchShell;

use subs qw(exec exit);

sub exec (&@) {    ## no critic (Subroutines::ProhibitBuiltinHomonyms, Subroutines::ProhibitSubroutinePrototypes)
    @main::exec_args = @_;
    return;
}

sub exit {    ## no critic (Subroutines::ProhibitBuiltinHomonyms)
    @main::exit_args = @_;
    return;
}

package main;

main();

sub main {

    # $x is used to suppress warning
    # $x is used twice to shut up perlcritic
    if ( !eval { my $x = getpwuid $EUID; $x = 1; 1 } ) {
        plan skip_all => 'The getpwuid function is unimplemented';
    }

    require_ok('bin/sshss') or BAIL_OUT();

    # If this exists (for whatever strange reason), remove it.
    delete $ENV{SSH_ORIGINAL_COMMAND};

    my $tmpdir = tempdir();

    # create a dummy "shell"
    my $shell = File::Spec->catfile( $tmpdir, 'shell.pl' );
    open my $fh, '>', $shell or BAIL_OUT("open $shell: $!");
    close $fh or BAIL_OUT("close $shell: $!");
    chmod 0755, $shell or BAIL_OUT("chomd 0755, $shell: $!");

    # mock get_abs_script_basedir
    my $script_basedir;
    my $sshss = Test::MockModule->new( 'App::SSH::SwitchShell', no_auto => 1 );
    $sshss->redefine( get_abs_script_basedir => sub { return $script_basedir } );

    # Change to a different tempdir to see if the chdir functionality works
    my $basedir = tempdir();
    _chdir($basedir);

    note('login shell, script inside .ssh dir');
    {
        local $ENV{HOME}  = '/home/dummy';
        local $ENV{SHELL} = '/bin/dummy';

        $script_basedir = File::Spec->catdir( $tmpdir, '.ssh' );
        _mkdir($script_basedir);

        local @ARGV = ($shell);

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::main() };
        is( $result[0], undef, 'main() returns undef (because we mocked _exec)' );
        is( $stdout,    q{},   '... prints nothing to STDOUT' );

        # prints only the error message because the mocked exec does return
        my @stderr = split /\n/, $stderr;
        is( scalar @stderr, 1, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;
        like( $stderr[0], qr{\Q: shell.pl\E}, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;

        is( $ENV{HOME},  $tmpdir, '... HOME environment variable is correctly set' );
        is( $ENV{SHELL}, $shell,  '... SHELL environment variable is correctly set' );
        is( cwd(),       $tmpdir, '... cwd is correctly changed' );
        my $exec_file = ( shift @exec_args )->();
        is( $exec_file, $shell, '... the correct shell was run' );
        is_deeply( \@exec_args, [qw(-shell.pl)], '... with the correct arguments' );
        is_deeply( \@exit_args, [1],             '... exit 1 is called (because exec returned)' );

        _chdir($basedir);
    }

    note(q{run 'perl -v', script inside .ssh dir});
    {
        local $ENV{HOME}                 = '/home/dummy';
        local $ENV{SHELL}                = '/bin/dummy';
        local $ENV{SSH_ORIGINAL_COMMAND} = "$EXECUTABLE_NAME -v";

        $script_basedir = File::Spec->catdir( $tmpdir, '.ssh' );

        local @ARGV = ($shell);

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::main() };
        is( $result[0], undef, 'main() returns undef (because we mocked _exec)' );
        is( $stdout,    q{},   '... prints nothing to STDOUT (because we mocked _exec)' );

        # prints only the error message because the mocked exec does return
        my @stderr = split /\n/, $stderr;
        is( scalar @stderr, 1, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;
        like( $stderr[0], qr{\Q: shell.pl\E}, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;

        is( $ENV{HOME},  $tmpdir, '... HOME environment variable is correctly set' );
        is( $ENV{SHELL}, $shell,  '... SHELL environment variable is correctly set' );
        is( cwd(),       $tmpdir, '... cwd is correctly changed' );
        my $exec_file = ( shift @exec_args )->();
        is( $exec_file, $shell, '... the correct shell was run' );
        is_deeply( \@exec_args, [ 'shell.pl', '-c', "$EXECUTABLE_NAME -v" ], '... with the correct arguments' );
        is_deeply( \@exit_args, [1],                                         '... exit 1 is called (because exec returned)' );

        _chdir($basedir);
    }

    note('login shell, script in "invalid directory"');
    {
        local $ENV{HOME}  = '/home/dummy';
        local $ENV{SHELL} = '/bin/dummy';

        my $not_existing_home = File::Spec->catdir( $tmpdir, 'dir_does_not_exist' );
        $script_basedir = File::Spec->catdir( $not_existing_home, '.ssh' );

        local @ARGV = ($shell);

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::main() };
        is( $result[0], undef, 'main() returns undef (because we mocked _exec)' );
        is( $stdout,    q{},   '... prints nothing to STDOUT' );
        like( $stderr, "/ ^ \QCould not chdir to home '$not_existing_home':\E /xsm", '... prints that chdir() failed to STDERR' );
        is( $ENV{HOME},  $not_existing_home, '... HOME environment variable is correctly set' );
        is( $ENV{SHELL}, $shell,             '... SHELL environment variable is correctly set' );
        is( cwd(),       $basedir,           '... cwd is not changed because dir does not exist' );
        my $exec_file = ( shift @exec_args )->();
        is( $exec_file, $shell, '... the correct shell was run' );
        is_deeply( \@exec_args, [qw(-shell.pl)], '... with the correct arguments' );
        is_deeply( \@exit_args, [1],             '... exit 1 is called (because exec returned)' );

        _chdir($basedir);
    }

    note('login shell, script in ~/.ssh');
    {
        local $ENV{HOME}  = $tmpdir;
        local $ENV{SHELL} = '/bin/dummy';

        _chdir($tmpdir);
        $script_basedir = File::Spec->catdir( $tmpdir, '.ssh' );

        local @ARGV = ($shell);

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::main() };
        is( $result[0], undef, 'main() returns undef (because we mocked _exec)' );
        is( $stdout,    q{},   '... prints nothing to STDOUT' );

        # prints only the error message because the mocked exec does return
        my @stderr = split /\n/, $stderr;
        is( scalar @stderr, 1, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;
        like( $stderr[0], qr{\Q: shell.pl\E}, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;

        is( $ENV{HOME},  $tmpdir, '... HOME environment variable is correctly set' );
        is( $ENV{SHELL}, $shell,  '... SHELL environment variable is correctly set' );
        is( cwd(),       $tmpdir, '... cwd is correctly changed' );
        my $exec_file = ( shift @exec_args )->();
        is( $exec_file, $shell, '... the correct shell was run' );
        is_deeply( \@exec_args, [qw(-shell.pl)], '... with the correct arguments' );
        is_deeply( \@exit_args, [1],             '... exit 1 is called (because exec returned)' );

        _chdir($basedir);
    }

    note('login shell, HOME and script basedir are reached through symlink');
    {
        my $homedir = File::Spec->catdir( $tmpdir, 'HOMEDIR' );
        _mkdir($homedir);

        my $homelnk = File::Spec->catfile( $tmpdir, 'HOMELINK' );
        _symlink( 'HOMEDIR', $homelnk );

        $script_basedir = File::Spec->catdir( $homelnk, 'abc' );
        _mkdir($script_basedir);
        $script_basedir = File::Spec->catdir( $script_basedir, '.ssh' );
        _mkdir($script_basedir);

        local $ENV{HOME}  = $homelnk;
        local $ENV{SHELL} = '/bin/dummy';

        local @ARGV = ($shell);

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::main() };
        is( $result[0], undef, 'main() returns undef (because we mocked _exec)' );
        is( $stdout,    q{},   '... prints nothing to STDOUT' );

        # prints only the error message because the mocked exec does return
        my @stderr = split /\n/, $stderr;
        is( scalar @stderr, 1, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;
        like( $stderr[0], qr{\Q: shell.pl\E}, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;

        is( $ENV{HOME},  File::Spec->catdir( $homelnk, 'abc' ), '... HOME environment variable is correctly set' );
        is( $ENV{SHELL}, $shell,                                '... SHELL environment variable is correctly set' );
        is( cwd(),       File::Spec->catdir( $homedir, 'abc' ), '... cwd is correctly changed' );
        my $exec_file = ( shift @exec_args )->();
        is( $exec_file, $shell, '... the correct shell was run' );
        is_deeply( \@exec_args, [qw(-shell.pl)], '... with the correct arguments' );
        is_deeply( \@exit_args, [1],             '... exit 1 is called (because exec returned)' );

        _chdir($basedir);
    }

    note('login shell, HOME is reached through symlink, script basedir is not');
    {
        my $homedir = File::Spec->catdir( $tmpdir, 'HOMEDIR' );
        my $homelnk = File::Spec->catfile( $tmpdir, 'HOMELINK' );

        local $ENV{HOME}  = $homelnk;
        local $ENV{SHELL} = '/bin/dummy';

        $script_basedir = File::Spec->catdir( $homedir, 'abc', '.ssh' );

        local @ARGV = ($shell);

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::main() };
        is( $result[0], undef, 'main() returns undef (because we mocked _exec)' );
        is( $stdout,    q{},   '... prints nothing to STDOUT' );

        # prints only the error message because the mocked exec does return
        my @stderr = split /\n/, $stderr;
        is( scalar @stderr, 1, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;
        like( $stderr[0], qr{\Q: shell.pl\E}, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;

        is( $ENV{HOME},  File::Spec->catdir( $homedir, 'abc' ), '... HOME environment variable is correctly set' );
        is( $ENV{SHELL}, $shell,                                '... SHELL environment variable is correctly set' );
        is( cwd(),       File::Spec->catdir( $homedir, 'abc' ), '... cwd is correctly changed' );
        my $exec_file = ( shift @exec_args )->();
        is( $exec_file, $shell, '... the correct shell was run' );
        is_deeply( \@exec_args, [qw(-shell.pl)], '... with the correct arguments' );
        is_deeply( \@exit_args, [1],             '... exit 1 is called (because exec returned)' );

        _chdir($basedir);
    }

    note('login shell, script basedir is reached through symlink, HOME is not');
    {
        my $homedir = File::Spec->catdir( $tmpdir, 'HOMEDIR' );
        my $homelnk = File::Spec->catfile( $tmpdir, 'HOMELINK' );

        local $ENV{HOME}  = $homedir;
        local $ENV{SHELL} = '/bin/dummy';

        $script_basedir = File::Spec->catdir( $homelnk, 'abc', '.ssh' );

        local @ARGV = ($shell);

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::main() };
        is( $result[0], undef, 'main() returns undef (because we mocked _exec)' );
        is( $stdout,    q{},   '... prints nothing to STDOUT' );

        # prints only the error message because the mocked exec does return
        my @stderr = split /\n/, $stderr;
        is( scalar @stderr, 1, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;
        like( $stderr[0], qr{\Q: shell.pl\E}, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;

        is( $ENV{HOME},  File::Spec->catdir( $homelnk, 'abc' ), '... HOME environment variable is correctly set' );
        is( $ENV{SHELL}, $shell,                                '... SHELL environment variable is correctly set' );
        is( cwd(),       File::Spec->catdir( $homedir, 'abc' ), '... cwd is correctly changed' );
        my $exec_file = ( shift @exec_args )->();
        is( $exec_file, $shell, '... the correct shell was run' );
        is_deeply( \@exec_args, [qw(-shell.pl)], '... with the correct arguments' );
        is_deeply( \@exit_args, [1],             '... exit 1 is called (because exec returned)' );

        _chdir($basedir);
    }

    note('login shell, -h <home> <shell>');
    {
        local $ENV{HOME}  = $tmpdir;
        local $ENV{SHELL} = '/bin/dummy';

        _chdir($tmpdir);
        $script_basedir = File::Spec->catdir( $tmpdir, 'myHOME' );
        _mkdir($script_basedir);

        local @ARGV = ( '-h', $script_basedir, $shell );

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::main() };
        is( $result[0], undef, 'main() returns undef (because we mocked _exec)' );
        is( $stdout,    q{},   '... prints nothing to STDOUT' );

        # prints only the error message because the mocked exec does return
        my @stderr = split /\n/, $stderr;
        is( scalar @stderr, 1, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;
        like( $stderr[0], qr{\Q: shell.pl\E}, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;

        is( $ENV{HOME},  $script_basedir, '... HOME environment variable is correctly set' );
        is( $ENV{SHELL}, $shell,          '... SHELL environment variable is correctly set' );
        is( cwd(),       $script_basedir, '... cwd is correctly changed' );
        my $exec_file = ( shift @exec_args )->();
        is( $exec_file, $shell, '... the correct shell was run' );
        is_deeply( \@exec_args, [qw(-shell.pl)], '... with the correct arguments' );
        is_deeply( \@exit_args, [1],             '... exit 1 is called (because exec returned)' );

        _chdir($basedir);
    }

    note('login shell, -h <home> -- <shell>');
    {
        local $ENV{HOME}  = $tmpdir;
        local $ENV{SHELL} = '/bin/dummy';

        _chdir($tmpdir);
        $script_basedir = File::Spec->catdir( $tmpdir, 'myHOME' );

        local @ARGV = ( '-h', $script_basedir, q{--}, $shell );

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::main() };
        is( $result[0], undef, 'main() returns undef (because we mocked _exec)' );
        is( $stdout,    q{},   '... prints nothing to STDOUT' );

        # prints only the error message because the mocked exec does return
        my @stderr = split /\n/, $stderr;
        is( scalar @stderr, 1, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;
        like( $stderr[0], qr{\Q: shell.pl\E}, '... prints nothing to STDERR' )
          or diag 'got stderr: ', explain \@stderr;

        is( $ENV{HOME},  $script_basedir, '... HOME environment variable is correctly set' );
        is( $ENV{SHELL}, $shell,          '... SHELL environment variable is correctly set' );
        is( cwd(),       $script_basedir, '... cwd is correctly changed' );
        my $exec_file = ( shift @exec_args )->();
        is( $exec_file, $shell, '... the correct shell was run' );
        is_deeply( \@exec_args, [qw(-shell.pl)], '... with the correct arguments' );
        is_deeply( \@exit_args, [1],             '... exit 1 is called (because exec returned)' );

        _chdir($basedir);
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

sub _mkdir {
    my ($dir) = @_;

    my $rc = mkdir $dir;
    BAIL_OUT("mkdir $dir: $!") if !$rc;
    return $rc;
}

sub _symlink {
    my ( $old_name, $new_name ) = @_;

    my $rc = symlink $old_name, $new_name;
    BAIL_OUT("symlink $old_name, $new_name: $!") if !$rc;
    return $rc;
}
