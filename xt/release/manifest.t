#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Test::DistManifest 1.003;
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

manifest_ok();
