package CatalystX::ShardType::Component;

use Moose::Role;

use namespace::autoclean;

use Moose::Util::TypeConstraints;

with 'CatalystX::ShardType::Generic';

=head1 NAME

CatalystX::ShardType::Component

=head1 DESCRIPTION

B<CatalystX::ShardType::Component> is a L<Moose::Role>
that provides shards with most of the infrastructure to
be injected as a component in an Catalyst app.

=cut

{
  my $tc = subtype as 'ArrayRef[ClassName]';
  coerce $tc, from 'ArrayRef', via { Class::MOP::load_class($_) for @$_; $_ };

  has superclasses => (
    traits     => ['Array'],
    is         => 'bare',
    isa        => $tc,
    coerce     => 1,
    builder    => 'superclasses',
    handles    => {
      get_superclasses => 'elements',
    },
  );

  has roles        => (
    traits     => ['Array'],
    is         => 'bare',
    isa        => $tc,
    coerce     => 1,
    builder    => 'roles',
    handles    => {
      get_roles => 'elements',
    },
  );
}

sub superclasses { [] };
sub roles { [] }

has inject_as    => (
  is         => 'bare',
  isa        => 'Str',
  reader     => 'get_component_name',
  builder    => 'inject_as',
);

sub inject_as {
  my $self = shift;
  my ( $class ) = grep { ! $_->meta->is_anon_class }
    ( $self, $self->meta->linearized_isa );
  my $pkg = $class->meta->name;
  $pkg =~ s/^.*::Shard:://
    or die "Can't figure out default component name for $pkg";
  return $pkg;
}

sub get_shard_applicator {
  my $self = shift;

  die "Can't inject shard " . $self->meta->name .
    " with anything but one superclass\n" unless $self->get_superclasses == 1;

   $self->get_superclasses;

  return sub {
    my $app = shift;
    CatalystX::InjectComponent->inject(
      component => ( $self->get_superclasses )[0],
      into => $app, as => $self->get_component_name,
    );
  };
}

no Moose::Role;

1;

