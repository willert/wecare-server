#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More;
use Test::Exception;

use Catalyst::Test 'CXD';

is( get('/index'), 'Magic moment', 'Basic rendering via tasks' );
is( get('/declared/test'), 'Declared moment', 'Basic rendering via CXD' );

done_testing;
