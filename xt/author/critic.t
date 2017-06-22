#!perl

use 5.006;
use strict;
use warnings;
use autodie;

use File::Spec;

use Test::More;
use Test::Perl::Critic;

my %files_to_not_criticize = (
    't/00-report-prereqs.t'        => 1,
    'xt/author/test-version.t'     => 1,
    'xt/release/distmeta.t'        => 1,
    'xt/release/minimum-version.t' => 1,
);

sub _get_all_files {
    my ($dir) = @_;

    my $fh;
    opendir $fh, $dir;
    my @dent = map { File::Spec->catfile( $dir, $_ ) } grep { $_ ne q{.} && $_ ne q{..} } readdir $fh;
    closedir $fh;

    my @result = grep { -f $_ } @dent;
    my @dirs = grep { !-l $_ && -d _ } @dent;

    for my $dir (@dirs) {
        push @result, _get_all_files($dir);
    }

    return @result;
}

my @files_to_criticize;

if ( -d 'bin' ) {
    push @files_to_criticize, _get_all_files('bin');
}

if ( -d 'lib' ) {
    push @files_to_criticize, grep { m{ [.] pm $ }xsm } _get_all_files('lib');
}

if ( -d 't' ) {
    push @files_to_criticize, grep { m{ [.] t $ }xsm } _get_all_files('t');
}

if ( -d 'xt' ) {
    push @files_to_criticize, grep { m{ [.] t $ }xsm } _get_all_files('xt');
}

@files_to_criticize = sort grep { !exists $files_to_not_criticize{$_} } @files_to_criticize;

if ( @files_to_criticize == 0 ) {
    BAIL_OUT('no files to criticize found');
}

my $rcfile = File::Spec->catfile( 'xt', 'author', 'perlcriticrc' );
Test::Perl::Critic->import( -profile => $rcfile );
all_critic_ok(@files_to_criticize);

# vim: ts=4 sts=4 sw=4 et: syntax=perl
