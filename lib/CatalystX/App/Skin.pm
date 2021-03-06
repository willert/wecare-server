package CatalystX::App::Skin;

use Moose;
use namespace::autoclean 0.06;

=head1 NAME

CatalystX::App::Skin

=head1 SYNOPSIS

 use CatalystX::App::Skin;
 my $foo = CatalystX::App::Skin->new();

=head1 DESCRIPTION

B<CatalystX::App::Skin> builds a standardized Catalyst
server.

=head1 MOTIVATION

Catalyst gives you a lot of freedom with regards to the layout of your
application, the models and views used and nearly all parts of request
and configuration handling. This is all great fun, until you set up your
tenth smallish application with all the parts and tweaks and base config
you are accustomed to.

Even if you are a responsible citizen and appropiatly package all your
tools, inject them in your own local cpan mirror and keep your dependencies
up to date, this is still a major hassle. You could (in theory) create your
own static code generation faramework ala C<catalyst.pl> ...

=cut

# use Moose::Exporter;

use Carp;
use Hash::Merge::Simple qw/merge/;
use List::MoreUtils qw/first_value firstidx/;

use Class::MOP::Method::Wrapped;
use CatalystX::InjectComponent;

use CatalystX::Meta::Attribute::Trait::Shard;

use CatalystX::AppBuilder;
use Moose::Util::TypeConstraints;

use Data::Dump qw/pp/;

{
  my $tc = subtype as 'ArrayRef[Object]', where {
    ! grep{ not $_->meta->does_role('CatalystX::ShardType::Generic') } @$_
  };

  has shards => (
    traits  => ['Array'],
    is      => 'bare',
    isa     => $tc,
    lazy    => 1,
    builder => '_build_shards',
    handles => {
      get_shards => 'elements',
    },
  );
}

has shard_config => (
  traits   => ['Hash'],
  is       => 'ro',
  isa      => 'HashRef',
  handles  => {
    get_shard_config => 'get'
  }
);

has application => (
  is       => 'ro',
  isa      => 'ClassName',
  required => 1,
);

with 'MooseX::Role::BuildInstanceOf' => {
  target => 'CatalystX::App::Skin::AppBuilder',
  prefix => 'builder',
};

around 'merge_builder_args' => sub {
  my ($orig, $self) = @_;
  my @args = $self->$orig;
  return (
    skin    => $self,
    appname => $self->application,
    @args,
  );
};

sub _build_shards {
  my $self = shift;

  my @shards = grep { $_->does('CatalystX::Meta::Attribute::Trait::Shard') }
    $self->meta->get_all_attributes;

  return [ map{
    my $attr = $self->meta->get_attribute( $_->name );
    my $shard = $attr->get_value( $self );

    die "Invalid shard name '" . $attr->name . "'\n" unless $shard;

    # printf STDERR "Initializing shard %s for %s in %s\n",
    #   $shard, $attr->name, $self->meta->name;

    Class::MOP::load_class( $shard );

    my $shard_args = $self->get_shard_config( $attr->name );
    $shard->new( $shard_args ? $shard_args : () );

  } @shards ];

}

sub apply_shards {
  my ( $self, $app, $params ) = @_;

  # printf STDERR "Bootstrapping %s\n", $app;

  my $builder = $self->builder;

  my @applicators = map{
    # printf STDERR "Generating applicator for %s\n", $_->meta->name;
    $_->get_shard_applicator( $builder );
  } grep{ $_->can( 'get_shard_applicator' ) } $self->get_shards;

  my $app_meta = Moose::Util::find_meta( $app );
  $app_meta->add_method( _builder => sub{ $self });

  $app_meta->add_after_method_modifier(
    setup_components => sub {
      my $app = shift;
      $_->( $app ) for @applicators;
    }
  );

  # printf STDERR "Starting app buildes\n", ;

  $builder->bootstrap;

  return;
}


sub init_skin {
  require Sub::Exporter;
  Sub::Exporter::setup_exporter({
    into_level => 1,
    exports => [
      bootstrap => \&_build_bootstrapper,
    ],
    groups => {
      default => [qw/ bootstrap /],
    },
  });
};

sub _build_bootstrapper {
  my ( $skin_class, $method_name, $import_args, $collectors ) = @_;

  return sub {
    my ( $app, $params ) = @_;
    $params = [] unless defined $params;
    my $shard_idx = firstidx { $_ eq 'shard' } @$params;
    my $shard_conf = defined $shard_idx ? $params->[ $shard_idx + 1 ] : undef;
    $shard_conf = {} unless defined $shard_conf;

    my $skin = $skin_class->new(
      application => $app,
      shard_config => $shard_conf,
      ( defined $params ? ( builder_args => $params ) : () ),
    );

    $skin->apply_shards( $app );
  }
}


1;

__END__

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Sebastian Willert, C<willert@gmail.com>

=head1 COPYRIGHT

This program soley owned by its author. Redistribution is prohibited.

=cut

