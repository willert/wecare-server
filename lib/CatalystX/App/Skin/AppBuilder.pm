package CatalystX::App::Skin::AppBuilder;

use Moose;
use namespace::clean -except => 'meta';

extends 'CatalystX::AppBuilder';

=head1 NAME

CatalystX::App::Skin::AppBuilder

=head1 DESCRIPTION

B<CatalystX::App::Skin::AppBuilder> is a specialized
L<CatalystX::AppBuilder> for use with L<CatalystX::App::Skin>
classes.

=cut

use Carp;
use Scalar::Util qw/blessed/;
use List::MoreUtils qw/uniq/;
use Hash::Merge::Simple qw/merge/;
use Try::Tiny;

has skin => (
  is       => 'ro',
  isa      => 'CatalystX::App::Skin',
  required => 1,
  weak_ref => 1,
);

override _build_config => sub {
  my $self = shift;
  my $config = super(); # Get what CatalystX::AppBuilder gives you

  # printf STDERR "Building config\n", ;

  my $env = join( '::', $self->appname, 'Env' );

  my $use_env = 0;
  try {
    Class::MOP::load_class( $env );
    $use_env = 1;
  };

  my $conf = merge(
    ( map{ +{ $_->get_app_config } } $self->skin->get_shards ),
    $config,
    $use_env ? $env->config : {}
  );

  return $conf;
};

override _build_plugins => sub {
  my $self = shift;
  my @plugins; # ignore what CatalystX::AppBuilder gives you, it's braindead
  if ($self->debug) {
    unshift @plugins, '-Debug';
  }
  push @plugins, $_->get_plugins for $self->skin->get_shards;
  return [ uniq @plugins ];
};

override bootstrap => sub {
  my $self = shift;
  my @applicators = map{

    # printf STDERR "Generating pre-bootstrap applicator for %s\n",
    #   $_->meta->name;

    $_->get_pre_bootstrap_applicator( $self );
  } grep{ $_->can( 'get_pre_bootstrap_applicator' ) } $self->skin->get_shards;
  $_->( $self->appname ) for @applicators;
  return super();
};

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

