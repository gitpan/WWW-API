package WWW::API::Meta::Class;
{
  $WWW::API::Meta::Class::VERSION = '0.03'; # TRIAL
}

use strict;
use warnings;

use Moose::Role;
use WWW::API::Meta::Method;

has 'api_base_url' => (
	isa	=> 'Str',
	is	=> 'rw'
);

has 'api_headers' => (
	traits	=> ['Code'],
	isa	=> 'CodeRef',
	is	=> 'rw',
	default	=> sub { sub {} },
	handles	=> {
		headers => 'execute'
	}
);

has 'api_methods' => (
	traits	=> ['Array'],
	is	=> 'rw',
	isa	=> 'ArrayRef[Str]',
	default	=> sub { [] },
	auto_deref => 1,
	handles	=> {
		_add_api_method	=> 'push'
	}
);

=head1 NAME

WWW::API::Meta::Class - Metaclass for WWW::API based clients

=head1 VERSION

version 0.03

=cut

=for Pod::Coverage set_api_options add_api_method

=cut

sub set_api_options {
	my ($meta, $base_url, %opts) = @_;

	my $headers = $opts{headers};

	$meta -> api_base_url($base_url);
	$meta -> api_headers($headers) if $headers;
}

sub add_api_method {
	my ($meta, $name, $path, $method, %opts) = @_;

	$meta -> add_method(
		$name,
		WWW::API::Meta::Method -> wrap(
			name	=> $name,
			path	=> $path,
			method	=> $method,
			package_name => $meta -> name,
			%opts
		)
	);

	$meta -> _add_api_method($name);
}

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini <alexbio@cpan.org>.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of WWW::API::Meta::Class
