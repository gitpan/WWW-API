package WWW::GitHub::Repo;

use WWW::API;

define_api 'https://api.github.com';

get 'repo',  '/repos/:user/:repo';
get 'repos', '/users/:user/repos' => (
	optional => ['type']
);

1;

package main;

use v5.10;

my $gh = WWW::GitHub::Repo -> new;

my $repos = $gh -> repos(
	user => 'AlexBio',
	type => 'owner'
);

foreach my $repo (@$repos) {
	say $repo -> {'name'}, ': ', $repo -> {'description'};
}
