#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::RequiredMinimumDependencyVersion;
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

Test::RequiredMinimumDependencyVersion->new(
    module => {

        # the done_testing sub was added on 0.88
        'Test::More' => '0.88',

        # the skip argument was added in 0.003
        'Test::Spelling::Comment' => '0.003',

        # the version pod page "strongly urges" us to use at least 0.77
        'version' => '0.77',
    },
)->all_files_ok( grep { -d } qw(bin lib t xt) );
