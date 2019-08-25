#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

# CPANPLUS is used by Test::Pod::LinkCheck but is not a dependency. The
# require on CPANPLUS is only here for dzil to pick it up and add it as a
# develop dependency to the cpanfile.
require CPANPLUS;

# Test::Pod::LinkCheck checks for link targets in @INC. We have to add these
# directories to be able to find link targets in this project.
use lib qw(bin lib blib);

use Test::Pod::LinkCheck;
use Test::XTFiles;
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

if ( exists $ENV{AUTOMATED_TESTING} ) {
    print "1..0 # SKIP these tests during AUTOMATED_TESTING\n";
    exit 0;
}

Test::Pod::LinkCheck->new->all_pod_ok( Test::XTFiles->new->all_files() );
