#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::More 0.88;
use Test::NoTabs;
use Test::XTFiles;

for my $file ( Test::XTFiles->new->all_perl_files() ) {
    notabs_ok( $file, "No tabs in '$file'" );
}

done_testing();
