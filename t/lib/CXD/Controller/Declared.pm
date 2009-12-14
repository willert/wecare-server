use CatalystX::Declare;
controller CXD::Controller::Declared {
  action base as '' {};
  final action test under base {
    $ctx->response->body( 'Declared moment' );
  };
}
