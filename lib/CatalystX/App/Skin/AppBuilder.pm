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
  eval{ Class::MOP::load_class( $env ) };
  my $use_env = $@ ? 0 : 1;

  return merge(
    ( map{ +{ $_->get_app_config } } $self->skin->get_shards ),
    $config,
    $use_env ? $env->config : {}
  );
};

override _build_plugins => sub {
  my $self = shift;
  my $plugins = super(); # Get what CatalystX::AppBuilder gives you
  push @$plugins, $_->get_plugins for $self->skin->get_shards;
  @$plugins = uniq @$plugins;
  return $plugins;
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

