#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::Mojibake;
use Test::XTFiles;
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

all_files_encoding_ok( Test::XTFiles->new->all_perl_files() );
