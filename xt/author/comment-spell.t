#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::Spelling::Comment 0.005;
use XT::Util;

if ( exists $ENV{AUTOMATED_TESTING} ) {
    print "1..0 # SKIP these tests during AUTOMATED_TESTING\n";
    exit 0;
}

Test::Spelling::Comment->new(
    skip => [
        '^[#] vim: .*',
        '^[#]!/.*perl$',
        '[#][#] no critic [(][^)]+[)]',
        '(?i)http(?:s)?://[^\s]+',
    ],
)->add_stopwords( <DATA>, @{ __CONFIG__()->{stopwords} } )->all_files_ok;

__DATA__
cpanfile
Kirmess
LinkCheck
Sven
TORTIOUS
