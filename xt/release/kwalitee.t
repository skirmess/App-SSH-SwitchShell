#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::Kwalitee 'kwalitee_ok';
use Test::More 0.88;
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

kwalitee_ok( @{ __CONFIG__()->{tests} } );

done_testing();
