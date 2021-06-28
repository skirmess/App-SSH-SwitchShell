#!perl

# Automatically generated file; DO NOT EDIT.

use 5.006;
use strict;
use warnings;

use Path::Tiny;
use Perl::Critic::MergeProfile;
use Perl::Critic;
use Test::Perl::Critic::XTFiles;

my $rc_file = path(__FILE__)->parent->child('perlcriticrc')->stringify;
die "File '$rc_file' not found" if !-f $rc_file;

my $critic = Test::Perl::Critic::XTFiles->new( critic => Perl::Critic->new( -profile => $rc_file ) );

if ( -f "${rc_file}-code" ) {
    my $merge = Perl::Critic::MergeProfile->new;

    $merge->read($rc_file);
    $merge->read("${rc_file}-code");

    my $profile = $merge->write_string;
    $critic->critic_module( Perl::Critic->new( -profile => \$profile ) );
    $critic->critic_script( Perl::Critic->new( -profile => \$profile ) );

}

if ( -f "${rc_file}-tests" ) {
    my $merge = Perl::Critic::MergeProfile->new;

    $merge->read($rc_file);
    $merge->read("${rc_file}-tests");

    my $profile = $merge->write_string;
    $critic->critic_test( Perl::Critic->new( -profile => \$profile ) );
}

$critic->all_files_ok();
