package WeCARE::Server::Shard::Rendering;

use Moose;
use namespace::clean -except => 'meta';

with 'CatalystX::ShardType::Trait';

=head1 NAME

WeCARE::Server::Shard::Rendering

=head1 DESCRIPTION

B<WeCARE::Server::Shard::Rendering> applies
the C<RenderView> trait for the root controller.

=cut

sub traits   {[ 'Catalyst::TraitFor::Controller::RenderView' ]}
sub apply_to { 'Controller::Root' }

no Moose;

__PACKAGE__->meta->make_immutable;

1;
