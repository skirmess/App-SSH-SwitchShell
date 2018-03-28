#!perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::Pod;
use Test::Pod::No404s;

if ( exists $ENV{AUTOMATED_TESTING} ) {
    print "1..0 # SKIP these tests during AUTOMATED_TESTING\n";
    exit 0;
}

all_pod_files_ok( Test::Pod::all_pod_files( grep { -d } qw(bin lib t xt) ) );
