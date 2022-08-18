#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::Mojibake;
use Test::XTFiles;

all_files_encoding_ok( Test::XTFiles->new->all_perl_files() );
