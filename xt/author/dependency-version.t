#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::RequiredMinimumDependencyVersion 0.003;

Test::RequiredMinimumDependencyVersion->new(
    module => {

        # Unknown constructor arguments are ignored rather than fatal
        'Class::Tiny' => '1',

        # API change to be based on Future
        'Git::Background' => '0.003',

        # the redefine sub needs 0.14
        'Test::MockModule' => '0.14',

        # the done_testing sub was added on 0.88
        'Test::More' => '0.88',

        # the skip argument was added in 0.003
        'Test::Spelling::Comment' => '0.003',

        # the version pod page "strongly urges" us to use at least 0.77
        'version' => '0.77',
    },
)->all_files_ok;
