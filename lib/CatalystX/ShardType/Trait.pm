package CatalystX::ShardType::Trait;

use Moose::Role;
use MooseX::Method::Signatures;

use namespace::autoclean;

use Moose::Util::TypeConstraints;

with 'CatalystX::ShardType::Generic';

requires 'apply_to';

=head1 NAME

CatalystX::ShardType::Trait

=head1 DESCRIPTION

B<CatalystX::ShardType::Trait> is a L<Moose::Role>
that provides shards with most of the infrastructure to
be applied to a component in an Catalyst app.

=cut

use Moose::Util;

{
  my $tc = subtype as 'ArrayRef[ClassName]';
  coerce $tc, from 'ArrayRef', via { Class::MOP::load_class($_) for @$_; $_ };

  has traits => (
    traits     => ['Array'],
    is         => 'bare',
    isa        => $tc,
    coerce     => 1,
    builder    => 'traits',
    handles    => {
      get_traits => 'elements',
    },
  );
}

sub traits { [] };

has apply_to    => (
  is         => 'bare',
  isa        => 'Str',
  reader     => 'get_target_component',
  builder    => 'apply_to',
);

sub get_shard_applicator {
  my $self = shift;

  Class::MOP::load_class( $_ ) for $self->get_traits;

  return sub {
    my $app = shift;
    my $comp = $app->component( $self->get_target_component );
    Moose::Util::apply_all_roles( $comp->meta->name, $self->get_traits );
  };
}

no Moose::Role;

1;
