use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(

  module_name         => 'Net::Google::GData',
  license             => 'perl',
  dist_author         => 'Alan Young <alansyoungiii@gmail.com>',
  dist_version_from   => 'lib/Net/Google/GData.pm',

  build_requires => {
    'Class::ErrorHandler' => 0,
    'Test::More' => 0,
    'XML::Atom' => 0,
  },

  add_to_cleanup      => [ 'Net-Google-GData-*' ],

);

$builder->create_build_script();
