package WWW::CPAN::MetaDB;

use WWW::API;

define_api 'http://cpanmetadb.plackperl.org/v1.0' => (
	decoder	=> sub {
		require YAML;

		my ($self, $data) = @_;

		return YAML::Load($data)
	}
);

get_api 'package', '/package/:package';

1;

package main;

use v5.10;

my $cpan = WWW::CPAN::MetaDB -> new;

say $cpan -> package(package => 'Dist::Zilla') -> {'distfile'};
