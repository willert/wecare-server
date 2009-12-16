package SkinnedApp;

=head1 DESCRIPTION

B<SkinnedApp> is a test case for the C<WeCARE::Server> skinning infrastructure

=cut

use strict;
use warnings;

use WeCARE::Server::Skin;

my %log = (
  'log4perl.rootLogger' => 'DEBUG, debug, info, warn, error, fatal',
  map{(
    'log4perl.appender.'. lc()  => 'Log::Log4perl::Appender::TestBuffer',
    'log4perl.appender.'. lc() . '.layout'    => 'SimpleLayout',
    'log4perl.appender.'. lc() . '.Threshold' => uc(),
  )} qw/ debug info warn error fatal /
);

bootstrap( __PACKAGE__, [
  shard => { logger => [ \%log ] }
]);

1;
