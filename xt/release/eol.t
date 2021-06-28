#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::EOL;
use Test::More 0.88;
use Test::XTFiles;

for my $file ( Test::XTFiles->new->all_files() ) {
    eol_unix_ok( $file, { trailing_whitespae => 1 } );
}

done_testing();
