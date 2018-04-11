#!perl

use 5.006;
use strict;
use warnings;

# Automatically generated file; DO NOT EDIT.

use FindBin qw($RealBin);
use Test::Perl::Critic ( -profile => "$RealBin/perlcriticrc-code" );

all_critic_ok(qw(bin lib));
