#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::MinimumVersion 0.008;
use Test::XTFiles;
use XT::Files;

XT::Files->instance->bin_file('Makefile.PL');

all_minimum_version_from_metayml_ok( { paths => [ Test::XTFiles->new->all_perl_files() ] } );
