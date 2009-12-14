package WeCARE::Server::Shard::Defaults;

use Moose;
use namespace::clean -except => 'meta';

with 'CatalystX::ShardType::Generic';

sub plugins {[
  'Unicode::Encoding',
  'Authentication',
  'Session',
  'Session::Store::FastMmap',
  'Session::State::Cookie',
]}

no Moose;

__PACKAGE__->meta->make_immutable;

1;
