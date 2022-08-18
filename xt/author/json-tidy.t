#!perl

# vim: ts=4 sts=4 sw=4 et: syntax=perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use JSON::PP ();
use Path::Tiny;
use Test2::V0;

main();

sub main {
    my $json = JSON::PP->new->pretty(1)->canonical(1);
    my $it   = path('xt')->iterator( { recurse => 1 } );

    my $test_count = 0;

  FILE:
    while ( defined( my $file = $it->() ) ) {
        next FILE if !-f $file;
        next FILE if $file !~ m { .+ [.] config $ }xsm;

        $test_count++;

        my $content         = $file->slurp;
        my $content_decoded = eval { $json->decode($content) };
        if ( !defined $content_decoded ) {
            my $json_error = $@;
            ok( 0, $file );
            diag("\n$json_error\n");
            next FILE;
        }

        my $pretty = $json->encode($content_decoded);

        ok( $content eq $pretty, $file );
    }

    if ( $test_count == 0 ) {
        skip_all('no json files found');
        exit 0;
    }

    done_testing();

    exit 0;
}

# vim: ts=4 sts=4 sw=4 et: syntax=perl
