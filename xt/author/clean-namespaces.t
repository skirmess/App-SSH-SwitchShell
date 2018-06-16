#!perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use Test::More 0.88;
use Test::CleanNamespaces;

if ( !Test::CleanNamespaces->find_modules() ) {
    plan skip_all => 'No files found to test.';
}

all_namespaces_clean();
