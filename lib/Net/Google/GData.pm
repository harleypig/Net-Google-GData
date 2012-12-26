package Net::Google::GData;

# ABSTRACT: Handle basic communication with Google services

use warnings;
use strict;

# VERSION

=head1 SYNOPSIS

THIS MODULE IS NOT MAINTAINED ANYMORE

I fixed what was causing cpantesters to barf. I don't think the API this was written for is even valid anymore.

Net::Google::GData handles the basic communication details with Google services.

This module should normally only be used by modules subclassing GData.

=head1 DESCRIPTION

would go here

=cut

use Carp;
use LWP::UserAgent;

use base qw( Class::Accessor  Class::ErrorHandler Net::Google::Authenticate );

__PACKAGE__->mk_accessors( qw(

) );

=head1 FUNCTIONS

=head2 new

Typical constructor.  You can optionally pass in a hash of data to set values.  Unknown
data/value pairs will be silently ignored.

=cut

sub new {

  my ( $class, @data ) = @_;

  my $self = bless {}, ref $class || $class;

  # Set some defaults
  $self->accountType( $self->_default_accountType )
    or croak $self->errstr;

  $self->service( $self->_default_service )
    or carp $self->errstr;

  $self->source( 'Base GData Perl Package/' . $VERSION );

  for ( my $i = 0 ; $i < @data ; $i += 2 ) {

    if ( my $method = $self->can( $data[$i] ) ) {

      $self->$method( $data[ $i + 1 ] );

    }
  }

  return $self;

} ## end sub new

=head2 get

=head2 post

=head2 put

=head2 delete

=cut

sub GET    { }
sub POST   { }
sub PUT    { }
sub DELETE { }

=head1 PRIVATE FUNCTIONS

=head2 _ua

Private method that creates and holds a LWP user agent.

Does not accept any parameters.

=cut

sub _ua {

  my $self = shift;

  my $ua;

  unless ( $ua = $self->SUPER::get( '_ua' ) ) {

    $ua = LWP::UserAgent->new;

    $self->SUPER::set( '_ua', $ua );

  }

  $ua->agent( $self->source );

  $self->_auth
    ? $ua->default_header( 'Authorization' => 'GoogleLogin auth=' . $self->_auth )
    : $ua->default_headers->remove_header( 'Authorization' );

  return $ua;

} ## end sub _ua

1;  # End of Net::Google::GData
