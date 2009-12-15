#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More;
use Test::Exception;

use Catalyst::Test 'SkinnedApp';

is get('/'), 'Magic moment', 'rendering via shard';

my %conf = %{ SkinnedApp->config };
is $conf{default_view}, 'HTML::Mason', 'config from shard';

ok(
  SkinnedApp->isa( 'Catalyst::Plugin::Unicode::Encoding' ),
  'plugin from shard'
);

done_testing;
