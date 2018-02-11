#!perl

use 5.006;
use strict;
use warnings;

# generated by MyRepositoryBase 0.033

use Test::More;

use lib qw(.);

my @modules = qw(
  bin/sshss
);

plan tests => scalar @modules;

for my $module (@modules) {
    require_ok($module) || BAIL_OUT();
}
