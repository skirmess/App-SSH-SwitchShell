#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use XT::Util;

BEGIN {
    if ( __CONFIG__()->{':skip'} ) {
        print "1..0 # SKIP disabled\n";
        exit 0;
    }

    if ( !-f 'MANIFEST' ) {
        print "1..0 # SKIP No MANIFEST file\n";
        exit 0;
    }
}

use Test::Portability::Files;

options( test_one_dot => 0 );
run_tests();
