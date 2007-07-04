package Net::Google::GData;

use warnings;
use strict;

=head1 NAME

Net::Google::GData - Handle basic communication with Google services

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Net::Google::GData handles the basic communication details with Google services.

This module should normally only be used by modules subclassing GData.

=cut

use Carp;
use LWP::UserAgent;

use base qw( Class::Accessor  Class::ErrorHandler Net::Google::Authenticate );

__PACKAGE__->mk_accessors(qw(

));

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

      $self->$method( $data[$i+1] );

    }
  }

  return $self;

}

=head2 get

=head2 post

=head2 put

=head2 delete

=cut

sub GET { }
sub POST { }
sub PUT { }
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

}

=head1 AUTHOR

Alan Young, C<< <alansyoungiii at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-net-google-gdata at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-Google-GData>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Google::GData

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Google-GData>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Net-Google-GData>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Google-GData>

=item * Search CPAN

L<http://search.cpan.org/dist/Net-Google-GData>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Alan Young, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Net::Google::GData
