#!perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::Kwalitee 'kwalitee_ok';
use Test::More 0.88;
use XT::Util;

kwalitee_ok( @{ __CONFIG__()->{tests} } );

done_testing();
