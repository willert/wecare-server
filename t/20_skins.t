#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More;
use Test::Exception;
use Test::Log4perl;

use Catalyst::Test 'SkinnedApp';

is get('/'), 'Magic moment', 'rendering via shard';

my %conf = %{ SkinnedApp->config };
is $conf{default_view}, 'HTML::Mason', 'config from shard';

ok(
  SkinnedApp->isa( 'Catalyst::Plugin::Unicode::Encoding' ),
  'plugin from shard'
);

ok(
  SkinnedApp->log->isa( 'Catalyst::Log::Log4perl' ),
  'correct logger instance'
) or diag "Logger isa: " . SkinnedApp->log;

is get('/log/error'), 'ok!', 'Calling logging action';
is (
  Log::Log4perl->appenders->{error}->buffer,
  "ERROR - LOG LEVEL ERROR\n",
  'Logging facility works'
);

done_testing;
