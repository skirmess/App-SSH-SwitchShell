#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Path::Tiny;

use Test::PerlTidy::XTFiles;

Test::PerlTidy::XTFiles->new(
    mute       => 1,
    perltidyrc => path(__FILE__)->parent(3)->child('.perltidyrc')->stringify,
)->all_files_ok;
