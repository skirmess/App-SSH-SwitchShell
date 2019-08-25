#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::More 0.88;
use Test::NoTabs;
use Test::XTFiles;
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

for my $file ( Test::XTFiles->new->all_perl_files() ) {
    notabs_ok( $file, "No tabs in '$file'" );
}

done_testing();
