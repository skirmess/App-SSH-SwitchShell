#!perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use FindBin qw($RealBin);
use Path::Tiny;
use Test::More;
use Test::PerlTidy;

my @files;
if ( -d 'bin' ) {
    my $it = path('bin')->iterator( { recurse => 1 } );

  BIN:
    while ( defined( my $file = $it->() ) ) {
        next BIN if !-f $file;

        push @files, $file->stringify;
    }
}

if ( -d 'lib' ) {
    my $it = path('lib')->iterator( { recurse => 1 } );

  LIB:
    while ( defined( my $file = $it->() ) ) {
        next LIB if !-f $file;
        next LIB if $file !~ m{ [.] pm $ }xsm;

        push @files, $file->stringify;
    }
}

for my $dir (qw(t xt)) {
    my $it = path($dir)->iterator( { recurse => 1 } );

  TEST:
    while ( defined( my $file = $it->() ) ) {
        next TEST if !-f $file;
        next TEST if $file !~ m{ [.] t $ }xsm;

        push @files, $file->stringify;
    }
}

if ( !@files ) {
    plan skip_all => 'No files found to test.';
}

plan tests => scalar @files;

my $perltidyrc = path($RealBin)->parent(2)->child('.perltidyrc')->stringify;

$Test::PerlTidy::MUTE = 1;

for my $file (@files) {
    ok( Test::PerlTidy::is_file_tidy( $file, $perltidyrc ), $file );
}
