package WWW::GitHub::Repo;

use WWW::API;

with 'WWW::API::Role::Encoder::WWWFormURLEncoded';
with 'WWW::API::Role::Decoder::JSON';

define_api 'https://api.github.com';

get_api 'repo',  '/repos/:user/:repo';
get_api 'repos', '/users/:user/repos' => (
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
