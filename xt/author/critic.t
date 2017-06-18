#!perl

use 5.006;
use strict;
use warnings;
use autodie;

use File::Spec;

use Test::More;
use Test::Perl::Critic;

my $rcfile = File::Spec->catfile( 'xt', 'author', 'perlcriticrc' );
Test::Perl::Critic->import( -profile => $rcfile );
all_critic_ok( 't', 'xt', 'lib', 'bin' );

# vim: ts=4 sts=4 sw=4 et: syntax=perl
