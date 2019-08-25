#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Pod::Wordlist;
use Test::More 0.88;
use Test::Spelling 0.12;
use Test::XTFiles;
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

if ( exists $ENV{AUTOMATED_TESTING} ) {
    print "1..0 # SKIP these tests during AUTOMATED_TESTING\n";
    exit 0;
}

add_stopwords(<DATA>);
add_stopwords( @{ __CONFIG__()->{stopwords} } );

for my $file ( Test::XTFiles->new->all_files() ) {
    pod_file_spelling_ok($file);
}

done_testing();
__DATA__
<sven.kirmess@kzone.ch>
Kirmess
Sven
