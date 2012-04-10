package WWW::Gistly;

use WWW::API;

with 'WWW::API::Role::Decoder::JSON';

has 'username' => (
	isa	=> 'Str',
	is	=> 'ro'
);

has 'password' => (
	isa	=> 'Str',
	is	=> 'ro'
);

define_api 'https://api.github.com';

get_api 'show', '/gists/:gist';
get_api 'list', '/users/:user/gists';

post_api 'create', '/gists' => (
	headers  => sub {
		require MIME::Base64;

		my $self = shift;

		my $token = MIME::Base64::encode_base64(
			$self -> username.':'.$self -> password
		);

		chomp $token;

		return { 'Authorization' => "Basic $token" };
	},
	encoder  => sub {
		require JSON;

		my ($self, $data, $files) = @_;

		$data -> {'public'} = $data -> {'public'} == 1 ?
			JSON::true() : JSON::false();

		while (my ($name, $value) = each $data -> {'files'}) {
			$files -> {$name} = { 'content' => $value };
		}

		$data -> {'files'} = $files;

		return JSON::to_json($data);
	},
	optional => ['description'],
	required => ['files', 'public']
);

1;

package main;

use v5.10;

my $gistly = WWW::Gistly -> new(
	username => 'AlexBio',
	password => 's3kr1t'
);

my $gists = $gistly -> list(user => 'AlexBio');

foreach (@$gists) {
	say $_ -> {'description'} if $_ -> {'description'};
}

my $new = $gistly -> create(
	public		=> 0,
	description	=> 'prova',
	files		=> { 'name1' => 'content1' }
);

say "Created gist '".$new -> {'id'}."'";
