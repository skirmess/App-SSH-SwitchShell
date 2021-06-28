#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::More 0.88;
use Test::NoTabs;
use Test::XTFiles;

for my $file ( Test::XTFiles->new->all_perl_files() ) {
    notabs_ok( $file, "No tabs in '$file'" );
}

done_testing();
