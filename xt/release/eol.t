#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::EOL;
use Test::More 0.88;
use Test::XTFiles;

for my $file ( Test::XTFiles->new->all_files() ) {
    eol_unix_ok( $file, { trailing_whitespae => 1 } );
}

done_testing();
