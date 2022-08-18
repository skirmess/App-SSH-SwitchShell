#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::Pod::Links 0.003;

if ( exists $ENV{AUTOMATED_TESTING} ) {
    print "1..0 # SKIP these tests during AUTOMATED_TESTING\n";
    exit 0;
}

Test::Pod::Links->new->all_pod_files_ok;
