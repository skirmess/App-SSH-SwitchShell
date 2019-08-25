#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use FindBin qw($RealBin);
use Path::Tiny;
use XT::Util;

use Test::PerlTidy::XTFiles;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

Test::PerlTidy::XTFiles->new(
    mute       => 1,
    perltidyrc => path($RealBin)->parent(2)->child('.perltidyrc')->stringify,
)->all_files_ok;
