#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

# CPAN is used by Test::Pod::LinkCheck but is not a dependency. The
# require on CPAN is only here for dzil to pick it up and add it as a
# develop dependency to the cpanfile.
require CPAN;

# Test::Pod::LinkCheck checks for link targets in @INC. We have to add these
# directories to be able to find link targets in this project.
use lib qw(bin lib blib);

use Test::Pod::LinkCheck;
use Test::XTFiles;

if ( exists $ENV{AUTOMATED_TESTING} ) {
    print "1..0 # SKIP these tests during AUTOMATED_TESTING\n";
    exit 0;
}

Test::Pod::LinkCheck->new(
    cpan_backend      => 'CPAN',
    cpan_backend_auto => 0,
)->all_pod_ok( Test::XTFiles->new->all_files() );
