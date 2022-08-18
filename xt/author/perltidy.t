#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Path::Tiny;

use Test::PerlTidy::XTFiles;

Test::PerlTidy::XTFiles->new(
    mute       => 1,
    perltidyrc => path(__FILE__)->parent(3)->child('.perltidyrc')->stringify,
)->all_files_ok;
