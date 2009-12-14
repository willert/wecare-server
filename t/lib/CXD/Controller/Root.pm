package CXD::Controller::Root;

use Moose;
BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config->{namespace} = '';

sub index : Local {};

1;
