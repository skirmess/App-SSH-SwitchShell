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

use lib qw(.);

main();

sub main {
    require_ok('bin/sshss') or BAIL_OUT();

    my $script_basedir;
    my $sshss = Test::MockModule->new( 'App::SSH::SwitchShell', no_auto => 1 );
    $sshss->redefine( get_abs_script_basedir => sub { return $script_basedir } );

    my $tmpdir  = tempdir();
    my $basedir = cwd();

    note('run script not from within .ssh dir');
    {
        local $ENV{HOME} = '/home/dummy';
        $script_basedir = File::Spec->catdir( $tmpdir, 'no_dot_ssh' );
        _mkdir($script_basedir);

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_home() };
        is( $result[0], undef,         'configure_home() returns undef' );
        is( $stdout,    q{},           '... prints nothing to STDOUT' );
        is( $stderr,    q{},           '... prints nothing to STDERR' );
        is( $ENV{HOME}, '/home/dummy', '... HOME environment variable is not changed' );
        is( cwd(),      $basedir,      '... cwd is not changed' );
    }

    note('run script from within .ssh dir');
    {
        local $ENV{HOME} = '/home/dummy';
        $script_basedir = File::Spec->catdir( $tmpdir, '.ssh' );
        _mkdir($script_basedir);

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_home() };
        is( $result[0],                     undef,   'configure_home() returns undef' );
        is( $stdout,                        q{},     '... prints nothing to STDOUT' );
        is( $stderr,                        q{},     '... prints nothing to STDERR' );
        is( $ENV{HOME},                     $tmpdir, '... HOME environment variable is correctly set' );
        is( File::Spec->canonpath( cwd() ), $tmpdir, '... cwd is correctly changed' );

        _chdir($basedir);
    }

    note('feed invalid dir');
    {
        local $ENV{HOME} = '/home/dummy';
        my $not_existing_home = File::Spec->catdir( $tmpdir, 'dir_does_not_exist' );
        $script_basedir = File::Spec->catdir( $not_existing_home, '.ssh' );

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_home() };
        is( $result[0], undef, 'configure_home() returns undef' );
        is( $stdout,    q{},   '... prints nothing to STDOUT' );
        like( $stderr, "/ ^ \QCould not chdir to home '$not_existing_home':\E /xsm", '... prints that chdir() failed to STDERR' );
        is( $ENV{HOME}, $not_existing_home, '... HOME environment variable is correctly set' );
        is( cwd(),      $basedir,           '... cwd is not changed because dir does not exist' );

        _chdir($basedir);
    }

    note('HOME env variable same as script basedir');
    {
        local $ENV{HOME} = $tmpdir;
        $script_basedir = File::Spec->catdir( $tmpdir, '.ssh' );

        my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_home() };
        is( $result[0], undef,    'configure_home() returns undef' );
        is( $stdout,    q{},      '... prints nothing to STDOUT' );
        is( $stderr,    q{},      '... prints nothing to STDERR' );
        is( $ENV{HOME}, $tmpdir,  '... HOME environment variable is still correct' );
        is( cwd(),      $basedir, '... cwd is not changed because script basedir is same as HOME env variable' );

        _chdir($basedir);
    }

  SKIP: {
        {
            skip 'The symlink function is unimplemented', 1 if !eval { symlink q{}, q{}; 1 };    ## no critic (InputOutput::RequireCheckedSyscalls)
        }

        note('HOME and script basedir are reached through symlink');
        {
            my $homedir = File::Spec->catdir( $tmpdir, 'HOMEDIR' );
            _mkdir($homedir);

            my $homelnk = File::Spec->catfile( $tmpdir, 'HOMELINK' );
            _symlink( 'HOMEDIR', $homelnk );

            $script_basedir = File::Spec->catdir( $homelnk, 'abc' );
            _mkdir($script_basedir);
            $script_basedir = File::Spec->catdir( $script_basedir, '.ssh' );
            _mkdir($script_basedir);

            local $ENV{HOME} = $homelnk;

            my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_home() };
            is( $result[0], undef,                                 'configure_home() returns undef' );
            is( $stdout,    q{},                                   '... prints nothing to STDOUT' );
            is( $stderr,    q{},                                   '... prints nothing to STDERR' );
            is( $ENV{HOME}, File::Spec->catdir( $homelnk, 'abc' ), '... HOME environment variable is set correct with symlink' );
            is( cwd(),      File::Spec->catdir( $homedir, 'abc' ), '... cwd is changed correct and does not use symlink (unfortunately)' );

            _chdir($basedir);
        }

        note('HOME is reached through symlink, script basedir is not');
        {
            my $homedir = File::Spec->catdir( $tmpdir, 'HOMEDIR' );
            my $homelnk = File::Spec->catfile( $tmpdir, 'HOMELINK' );

            local $ENV{HOME} = $homelnk;
            $script_basedir = File::Spec->catdir( $homedir, 'abc', '.ssh' );

            my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_home() };
            is( $result[0], undef,                                 'configure_home() returns undef' );
            is( $stdout,    q{},                                   '... prints nothing to STDOUT' );
            is( $stderr,    q{},                                   '... prints nothing to STDERR' );
            is( $ENV{HOME}, File::Spec->catdir( $homedir, 'abc' ), '... HOME environment variable is set correct with symlink' );
            is( cwd(),      File::Spec->catdir( $homedir, 'abc' ), '... cwd is changed correct and does not use symlink (unfortunately)' );

            _chdir($basedir);
        }

        note('script basedir is reached through symlink, HOME is not');
        {
            my $homedir = File::Spec->catdir( $tmpdir, 'HOMEDIR' );
            my $homelnk = File::Spec->catfile( $tmpdir, 'HOMELINK' );

            local $ENV{HOME} = $homedir;
            $script_basedir = File::Spec->catdir( $homelnk, 'abc', '.ssh' );

            my ( $stdout, $stderr, @result ) = capture { App::SSH::SwitchShell::configure_home() };
            is( $result[0], undef,                                 'configure_home() returns undef' );
            is( $stdout,    q{},                                   '... prints nothing to STDOUT' );
            is( $stderr,    q{},                                   '... prints nothing to STDERR' );
            is( $ENV{HOME}, File::Spec->catdir( $homelnk, 'abc' ), '... HOME environment variable is set correct with symlink' );
            is( cwd(),      File::Spec->catdir( $homedir, 'abc' ), '... cwd is changed correct and does not use symlink (unfortunately)' );

            _chdir($basedir);
        }
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
