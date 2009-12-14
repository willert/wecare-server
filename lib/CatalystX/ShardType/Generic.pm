package CatalystX::ShardType::Generic;

use Moose::Role;
use MooseX::Method::Signatures;

use namespace::autoclean;

=head1 NAME

CatalystX::ShardType::Generic

=head1 DESCRIPTION

B<CatalystX::ShardType::Generic> is a L<Moose::Role>
that provides common shard functionality

=cut

has app_config => (
  traits     => ['Hash'],
  is         => 'bare',
  isa        => 'HashRef',
  builder    => 'app_config',
  handles    => {
    get_app_config => 'elements',
  },
);

has plugins => (
  traits     => ['Array'],
  is         => 'bare',
  isa        => 'ArrayRef[Str]',
  builder    => 'plugins',
  handles    => {
    get_plugins => 'elements',
  },
);

sub app_config { +{} }
sub plugins    { [] }

no Moose::Role;

1;
