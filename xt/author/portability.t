#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

BEGIN {
    if ( !-f 'MANIFEST' ) {
        print "1..0 # SKIP No MANIFEST file\n";
        exit 0;
    }
}

use Test::Portability::Files;

options( test_one_dot => 0 );
run_tests();
