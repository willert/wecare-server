package BasicApp::Env;

=head1 DESCRIPTION

B<BasicApp::Env> contains a simple config hash for basic testing

=cut

use strict;
use warnings;

sub config {+{
  'Controller::Root' => { message => 'Hello world!' }
}}


1;

__END__

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Sebastian Willert, C<willert@gmail.com>

=head1 COPYRIGHT

This program solely owned by its author. Redistribution is prohibited.

=cut

