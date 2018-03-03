#!perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::Mojibake;

all_files_encoding_ok( grep { -d } qw( bin lib t xt ) );
