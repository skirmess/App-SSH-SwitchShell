#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::MinimumVersion 0.008;
use Test::XTFiles;
use XT::Files;

XT::Files->instance->bin_file('Makefile.PL');

all_minimum_version_from_metayml_ok( { paths => [ Test::XTFiles->new->all_perl_files() ] } );
