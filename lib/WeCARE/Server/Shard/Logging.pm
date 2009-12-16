package WeCARE::Server::Shard::Logging;

use Moose;
use namespace::clean -except => 'meta';

=head1 NAME

WeCARE::Server::Shard::Logging

=head1 DESCRIPTION

B<WeCARE::Server::Shard::Logging> initializes
a L<Catalyst::Log::Log4perl> logger for your app

=cut

sub _build_log_class { 'Catalyst::Log::Log4perl' };

sub _build_log_args {[{
  'log4perl.rootLogger'                               => 'INFO, SCREEN',
  'log4perl.appender.SCREEN'                          =>
    'Log::Log4perl::Appender::Screen',
  'log4perl.appender.SCREEN.layout'                   => 'PatternLayout',
  'log4perl.appender.SCREEN.layout.ConversionPattern' => '%c:%p %m%n',
  'log4perl.appender.SCREEN.Threshold'                => 'WARN'
}]}

with 'CatalystX::ShardType::Logger';

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

