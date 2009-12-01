package WeCARE::Server::Builder;

use Moose;
use namespace::clean -except => 'meta';

extends 'CatalystX::AppBuilder';

=head1 NAME

WeCARE::Server::Builder

=head1 SYNOPSIS

 use WeCARE::Server::Builder;
 my $foo = WeCARE::Server::Builder->new();

=head1 DESCRIPTION

B<WeCARE::Server::Builder> builds a standardized Catalyst
server.

=cut

use Carp;
use Hash::Merge::Simple qw/merge/;
use List::MoreUtils qw/first_value/;

use Class::MOP::Method::Wrapped;
use CatalystX::InjectComponent;

around BUILDARGS => sub {
  my $orig = shift;
  my $class = shift;

  my %attr = @_ == 1 && ref $_[0] ne 'HASH' ?
    @_ == 1 && ! ref $_[0] ? ( appname => $_[0] ) : @_ : %{$_[0]};

  $class->$orig( \%attr );
};

around new => sub {
  my $orig = shift;
  my $class = shift;

  my $self = $class->$orig( @_ );
  my $meta = Class::MOP::class_of( $self->appname )
    or die $self->appname . " has no Moose metaclass\n";

  my $inject_components = sub {
    CatalystX::InjectComponent->inject(
      component => 'Catalyst::View::HTML::Mason',
      into => $self->appname, as => 'View::Mason',
    );
  };

  $meta->add_after_method_modifier( setup_components => $inject_components );
  return $self;
};

override _build_config => sub {
  my $self = shift;
  my $config = super(); # Get what CatalystX::AppBuilder gives you
  my $default_conf = {
    default_view => 'Mason',
  };
  my $env = join( '::', $self->appname, 'Env' );
  Class::MOP::load_class( $env );
  return merge( $default_conf, $config, $env->config );
};

override _build_plugins => sub {
  my $plugins = super(); # Get what CatalystX::AppBuilder gives you

  push @$plugins, (
    'Unicode::Encoding',
    'Authentication',
    'Session',
    'Session::Store::FastMmap',
    'Session::State::Cookie',
  );

  return $plugins;
};

no Moose;

__PACKAGE__->meta->make_immutable( inline_constructor => 0 );

1;

__END__

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Sebastian Willert, C<willert@gmail.com>

=head1 COPYRIGHT

This program soley owned by its author. Redistribution is prohibited.

=cut

