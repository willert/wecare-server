#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More;
use Test::Exception;

use Catalyst::Test 'SkinnedApp';

is( get('/'), 'Magic moment', 'Basic rendering via tasks' );

done_testing;
