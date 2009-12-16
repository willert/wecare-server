package CatalystX::ShardType::Logger;

use Moose::Role;
use namespace::autoclean;

with 'CatalystX::ShardType::Generic';

=head1 NAME

CatalystX::ShardType::Logger

=head1 DESCRIPTION

B<CatalystX::ShardType::Logger> is a L<Moose::Role>
that provides shards with a standard interface to
instantiate a default logger for an Catalyst app.

=cut

use Try::Tiny;

with 'MooseX::Role::BuildInstanceOf' => {
  # can't use Catalyst::Log here because Catalyst itself has no requirement
  # that loggers have to be Catalyst::Log subclasses and popular loggers
  # such as Catalyst::Log::Log4perl consequently aren't ...
  target => 'UNIVERSAL',
  prefix => 'log',
};

sub _build_log_class { 'Catalyst::Log'; };

sub get_pre_bootstrap_applicator {
  my $self = shift;

  Class::MOP::load_class( $self->log_class );

  return sub {
    my $app = shift;

    # printf STDERR "Initializing logger (was: %s)\n", $app->log || 'N/A';

    $app->meta->add_around_method_modifier(
      setup_log => sub{
        my ( $orig, $class ) = ( shift, shift );
        # printf STDERR "Initializing shard logger %s\n", $self->log;
        try {
          my $log = $self->log;
          $app->log( $log );
        } catch {
          my $err = $_;
          $class->$orig( @_ );
          printf STDERR "Logger: %s Error was:%s\n", $class->log, $err;
          $class->log->error( "Error while initializing logger:\n${err}" );
        }
      }
    );
  };
}

sub BUILDARGS {
  my ( $self, @p ) = @_;
  if ( @p == 1 and ref $p[0] eq 'ARRAY' ) {
    return { log_args => $p[0] }
  } else {
    return @p;
  }
};

no Moose::Role;

1;

__END__

=head1 SEE ALSO

L<perl>, L<Moose::Role>

=head1 AUTHOR

Sebastian Willert, C<willert@gmail.com>

=head1 COPYRIGHT

This program soley owned by its author. Redistribution is prohibited.

=cut

