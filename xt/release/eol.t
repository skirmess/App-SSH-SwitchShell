#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::EOL;
use Test::More 0.88;
use Test::XTFiles;
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

for my $file ( Test::XTFiles->new->all_files() ) {
    eol_unix_ok( $file, { trailing_whitespae => 1 } );
}

done_testing();
