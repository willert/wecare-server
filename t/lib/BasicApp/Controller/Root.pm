package BasicApp::Controller::Root;

use Moose;
use namespace::clean -except => 'meta';

BEGIN{
  extends 'Catalyst::Controller';
}

__PACKAGE__->config({ namespace => '' });

sub index : Path {
  my ( $self, $ctx ) = @_;
  $ctx->response->body( $self->{message} );
}

sub tpl : Local {
  my ( $self, $ctx ) = @_;
  $ctx->stash( template => 'message' );
  $ctx->forward( 'View::Mason' );
}

no Moose;

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Sebastian Willert, C<willert@gmail.com>

=head1 COPYRIGHT

This program soley owned by its author. Redistribution is prohibited.

=cut

