#!perl

use 5.006;
use strict;
use warnings;

use Test::More;
use Test::Kwalitee 'kwalitee_ok';

# Module::CPANTS::Analyse does not find the LICENSE in scripts that don't end in .pl
kwalitee_ok(qw{-has_license_in_source_file -has_abstract_in_pod});

done_testing;

# vim: ts=4 sts=4 sw=4 et: syntax=perl
