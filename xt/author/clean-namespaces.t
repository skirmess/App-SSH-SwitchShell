#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Module::Info;
use Test::CleanNamespaces;
use Test::XTFiles;
use Test2::V0;
use lib ();

my @files = Test::XTFiles->new->all_module_files;
if ( !@files ) {
    skip_all('no module files found');
    exit 0;
}

for my $file (@files) {
    note("file    = $file");
    my @packages = Module::Info->new_from_file($file)->packages_inside;

  PACKAGE:
    foreach my $package (@packages) {
        note("package = $package");

        my $info = Module::Info->new_from_module($package);

        if ( !defined $info ) {
            ok( 1, "package is not a module: $package" );
            next PACKAGE;
        }

        local @INC = @INC;
        lib->import( $info->{dir} );

        namespaces_clean($package);
    }
}

done_testing();
