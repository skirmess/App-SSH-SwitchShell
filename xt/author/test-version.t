#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::More 0.88;
use Test::Version 0.04 qw( version_ok ), {
    consistent  => 1,
    has_version => 1,
    is_strict   => 0,
    multiple    => 0,
};
use Test::XTFiles;

FILE:
for my $file ( Test::XTFiles->new->files() ) {
    next FILE if $file->is_test;
    next FILE if !$file->is_module && !$file->is_script;

    version_ok( $file->name );
}

done_testing();
