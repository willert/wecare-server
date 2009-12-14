package WeCARE::Server::Shard::View::HTML::Mason;

use Moose;
use namespace::clean -except => 'meta';

with 'CatalystX::ShardType::Component';

=head1 NAME

WeCARE::Server::Shard::View::HTML::Mason

=head1 DESCRIPTION

B<WeCARE::Server::Shard::View::HTML::Mason> provides
a default mason view for Catalyst apps.

=cut

sub superclasses {[ 'Catalyst::View::HTML::Mason' ]}
sub app_config {
  my $comp = $_[0]->get_component_name;
  $comp =~ s/^V(?:iew)?:://;
  +{ default_view => $comp }
}

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

