#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Test::More;
use Test::Exception;

use Catalyst::Test 'BasicApp';

is( get('/'), 'Hello world!', 'Basic rendering' );
is( get('/tpl'), 'Hello Mason!', 'Basic rendering' );

done_testing;
