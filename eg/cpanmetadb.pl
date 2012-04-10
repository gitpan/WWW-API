package WWW::CPAN::MetaDB;

use WWW::API;

with 'WWW::API::Role::Decoder::YAML';

define_api 'http://cpanmetadb.plackperl.org/v1.0';

get_api 'package', '/package/:package';

1;

package main;

use v5.10;

my $cpan = WWW::CPAN::MetaDB -> new;

say $cpan -> package(package => 'Dist::Zilla') -> {'distfile'};
