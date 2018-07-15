#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::More 0.88;
use Test::Version 0.04 qw( version_all_ok ), {
    consistent  => 1,
    has_version => 1,
    is_strict   => 0,
    multiple    => 0,
};
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

version_all_ok;
done_testing();
