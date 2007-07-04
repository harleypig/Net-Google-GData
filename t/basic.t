#!/usr/bin/perl -T

use strict;
use warnings;

use Test::More;

BEGIN { use_ok( 'Net::Google::GData' ) }

diag( "Testing Net::Google::GData $Net::Google::GData::VERSION, Perl $], $^X" );
plan tests => 30;

my $gdata = Net::Google::GData->new;

isa_ok( $gdata, 'Net::Google::GData' );

my @methods = ( 

  # Doesn't make sense to check 'new' when we've just successfully created the
  # object.

  # Authentication methods
  'login', 'accountType', 'service', 'Email', 'Passwd', 'source',

  # not implemented
  # 'logintoken', 'logincaptcha',
 
  # Authentication private methods
  '_auth', '_error_code',

  # GData methods
  'GET', 'POST', 'PUT', 'DELETE',

  # GData private methods
  '_ua',

);

my @skip = qw( login GET POST PUT DELETE _ua );

can_ok( $gdata, @methods );

# Doing the checks this way will sometimes cause the number of tests to change,
# but at least we'll be testing stuff.  You'll need to check the number
# reported at the end of the test run and change the plan appropriately.

my $stuff = 'random text';

for my $method ( @methods ) {

  # skip this kind of check for these methods
  next if grep { /$method/ } @skip;

  # check defaults
  if ( my $default = $gdata->can( "_default_$method" ) ) {

    my $value = $default->();
    is( $gdata->$method, $value, "Default for $method: $value" );
    
  }

  # check possible values
  if ( my $possible = $gdata->can( "_valid_$method" ) ) {

    for my $value ( $possible->() ) {

      $gdata->$method( $value );
      is( $gdata->$method, $value, "Possible for $method: $value" );

    }
  }

  if ( $method eq 'accountType' ) {

    $gdata->$method( $stuff );
    is( $gdata->errstr, 'Invalid accountType: ' . uc $stuff, 'invalid accountType' );

  } elsif ( $method eq 'service' ) {

    $gdata->$method( $stuff );
    is( $gdata->errstr, "Unknown service code: $stuff", 'invalid service code' );

  } elsif ( $method eq '_error_code' ) {

    my %codes = $gdata->_codes;

    for my $c ( sort { $a cmp $b } keys %codes ) {

      is( $gdata->_error_code( $c ), $codes{ $c }, "error code $c" );

    }

    is( $gdata->_error_code( $stuff ), $codes{ 'Unknown' }, 'invalid error code' );

  } else {

    $gdata->$method( $stuff );
    is( $gdata->$method, $stuff, "Set $method to $stuff" );

  }
}
