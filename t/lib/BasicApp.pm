package BasicApp;

=head1 DESCRIPTION

B<Basic> is a minimal test case for the C<WeCARE::Server> infrastructure

=cut

use strict;
use warnings;

use WeCARE::Server::Builder;

WeCARE::Server::Builder->new->bootstrap;


1;

__END__

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Sebastian Willert, C<willert@gmail.com>

=head1 COPYRIGHT

This program solely owned by its author. Redistribution is prohibited.

=cut

