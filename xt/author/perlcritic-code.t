#!perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use FindBin qw($RealBin $Script);

use Test::More 0.88;
use Perl::Critic::MergeProfile;

eval {
    my $merge = Perl::Critic::MergeProfile->new;

    my $rc_file = "$RealBin/perlcriticrc";
    $merge->read($rc_file);

    if ( $Script =~ m{ ^ perlcritic ( - [a-z]+ ) [.] t $ }xsm ) {
        $rc_file .= $1;
    }
    else {
        BAIL_OUT("Invalid test file name: $Script");
    }

    if ( -f $rc_file ) {
        $merge->read($rc_file);
    }

    my $profile = $merge->write_string;

    require Test::Perl::Critic;
    Test::Perl::Critic->import( -profile => \$profile );

    1;
} || do {
    my $error = $@;
    BAIL_OUT($error);
};

all_critic_ok( grep { -d } qw(bin lib) );
