#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use FindBin qw($RealBin $Script);
use Perl::Critic::MergeProfile;
use Test::More 0.88;
use XT::Util;

if ( __CONFIG__()->{':skip'} ) {
    print "1..0 # SKIP disabled\n";
    exit 0;
}

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
