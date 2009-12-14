package SkinnedApp::Controller::Root;

use Moose;
BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config->{namespace} = '';

sub index : Path {};

1;

