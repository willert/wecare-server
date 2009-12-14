package CatalystX::Meta::Attribute::Trait::Shard;
use Moose::Role;

{

  use Moose::Util::TypeConstraints;

  my $tc = subtype 'Str', where {
    my $type = "CatalystX::ShardType::$_";
    eval{ Class::MOP::load_class( $type ) };
    if ( $@ ) { warn "$@" ; return }
    return 1;
  };

  has shard_type => (
    is => 'ro',
    isa => $tc,
  );

}

no Moose::Role;

# register this as a metaclass alias ...
package # stop confusing PAUSE
    Moose::Meta::Attribute::Custom::Trait::Catalyst::Shard;

sub register_implementation {
  'CatalystX::Meta::Attribute::Trait::Shard'
}

1;

__END__

=pod

=head1 NAME

CatalystX::Meta::Attribute::Trait::Shard - Trait for shard attributes

=head1 SYNOPSIS

  package MyServer::Shards;
  use Moose;

  with 'MooseX::Getopt';

  has 'error_reporting' => (
      traits     => [ 'Catalyst::Shard' ],
      shard_type => 'ApplicationRole',
      is         => 'ro',
      isa        => 'Str',
      default    => 'MyServer::Shard::ErrorReporter',
  );

  has 'html_view' => (
      traits     => [ 'Catalyst::Shard' ],
      shard_type => 'Component',
      is         => 'ro',
      isa        => 'Str',
      default    => 'MyServer::Shard::View::Mason',
  );

=head1 DESCRIPTION

This is a custom attribute metaclass trait which can be used to
specify the type and thus the applicator of a shard attribute.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=cut
