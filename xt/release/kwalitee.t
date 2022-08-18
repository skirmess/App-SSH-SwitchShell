#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use List::Util 1.33 qw(any);
use Test::Kwalitee  qw(kwalitee_ok);
use Test::More 0.88;
use XT::Util;

my @tests = @{ __CONFIG__()->{tests} || [] };
if ( !any { m{ \A -? has_license_in_source_file \z }xsm } @tests ) {
    push @tests, '-has_license_in_source_file';
}

kwalitee_ok(@tests);

done_testing();
