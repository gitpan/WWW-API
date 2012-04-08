package WWW::API::Meta::Method;
{
  $WWW::API::Meta::Method::VERSION = '0.02'; # TRIAL
}

use strict;
use warnings;

use Moose;
use HTTP::Tiny;

extends 'Moose::Meta::Method';

=head1 NAME

WWW::API::Meta::Method - Module to create API methods

=head1 VERSION

version 0.02

=cut

=for Pod::Coverage wrap

=cut

# TODO: custom error handling

sub wrap {
	my ($class, %args) = @_;

	my $code = sub {
		my ($self, %margs) = @_;

		my ($method, $content, $params, $headers);

		my $http = HTTP::Tiny -> new;

		$method = $args{method};

		# extract url params from route and build req URL
		my $route   = $args{path};

		while ($route =~ /\/:(\w+)\/?/) {
			my $param = $1;
			my $value = $margs{$1};
			$route =~ s/\/:$param/\/$value/;
		}

		my $url  = $self -> meta -> api_base_url.$route;

		# set required params
		foreach my $param (@{ $args{required} }) {
			my $value = $margs{$param};

			die "Missing required parameter '$param'"
				unless defined $value;

			$params -> {$param} = $value;
		}

		# set optional params, if provided
		foreach my $param (@{ $args{optional} }) {
			my $value = $margs{$param};
			$params -> {$param} = $value if $value;
		}

		# get headers
		if (defined $args{headers}) {
			$headers = $args{headers}($self);
		} elsif ($params) {
			$headers = $self -> meta -> headers($self);
		}

		# encode
		if (defined $args{encoder} && $params) {
			$content = $args{encoder}($self, $params);
		} elsif ($params) {
			$content = $self -> meta -> encode($self, $params);
		}

		my $options = {
			'headers' => $headers,
			'content' => $content
		};

		my $resp = $http -> request(
			$method, $url, $options
		);

		die $resp -> {'status'}
			unless $resp -> {'success'};

		return $self -> meta -> decode($self, $resp -> {'content'});
	};

	$args{body} = $code;

	$class -> SUPER::wrap(%args);
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

1; # End of WWW::API::Meta::Method
