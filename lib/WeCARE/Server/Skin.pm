package WeCARE::Server::Skin;

use Moose;
extends 'CatalystX::App::Skin';

=head1 NAME

WeCARE::Server::Skin

=head1 DESCRIPTION

B<WeCARE::Server::Skin> is a basic collection of shards used
by most of our webapps

=cut

use Carp;
use Scalar::Util qw/blessed/;

has html_view => (
  is         => 'ro',
  default    => 'WeCARE::Server::Shard::View::HTML::Mason',
  traits     => [ 'Catalyst::Shard' ],
  shard_type => 'Component',
);

has renderer => (
  is         => 'ro',
  default    => 'WeCARE::Server::Shard::Rendering',
  traits     => [ 'Catalyst::Shard' ],
  shard_type => 'Trait',
);

has logger => (
  is         => 'ro',
  default    => 'WeCARE::Server::Shard::Logging',
  traits     => [ 'Catalyst::Shard' ],
  shard_type => 'Logger',
);

has defaults => (
  is         => 'ro',
  default    => 'WeCARE::Server::Shard::Defaults',
  traits     => [ 'Catalyst::Shard' ],
  shard_type => 'Generic',
);

__PACKAGE__->init_skin;

1;

__END__

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Sebastian Willert, C<willert@gmail.com>

=head1 COPYRIGHT

This program soley owned by its author. Redistribution is prohibited.

=cut

