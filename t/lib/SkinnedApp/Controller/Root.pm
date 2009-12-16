package SkinnedApp::Controller::Root;

use Moose;
BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config->{namespace} = '';

sub index : Path {};

sub log : Local Args(1) {
  my ( $self, $ctx, $level ) = @_;
  $level = lc $level;
  $ctx->log->debug( 'Calling logger with log level ' . uc $level );
  $ctx->log->$level( 'LOG LEVEL ' . uc $level );
  $ctx->response->body('ok!');
};

1;

