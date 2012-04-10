package WWW::API;
{
  $WWW::API::VERSION = '0.03'; # TRIAL
}

use strict;
use warnings;

use Moose;
use Moose::Exporter;
use Moose::Util::MetaRole;

Moose::Exporter -> setup_import_methods(
	with_meta	=> [qw/define_api get_api post_api put_api
				delete_api patch_api/],
	also		=> ['Moose']
);

=head1 NAME

WWW::API - Module for building clients for RESTful web service APIs

=head1 VERSION

version 0.03

=head1 SYNOPSIS

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

    use WWW::GitHub::Repo;

    my $gh = WWW::GitHub::Repo -> new;

    my $repos = $gh -> repos(
      user => 'AlexBio',
      type => 'owner'
    );

=head1 DESCRIPTION

B<WWW::API> is a minimal framework to build clients for RESTful web service
APIs.

=head1 SUBROUTINES

=head2 define_api $base_url, %opts

Define a new API client with base URL C<$base_url>.

Available options are:

=over 4

=item B<headers>

A custom subroutine that returns an hashref containing HTTP headers.

=back

=cut

sub define_api {
	my ($meta, $base_url, %opts) = @_;

	$meta -> set_api_options($base_url, %opts);
}

=head2 get_api $name, $path, %opts

Add a new GET API method with name C<$name> which fetches C<$path>.

Additional available options are:

See L</"OPTIONS"> for the additional options.

=cut

sub get_api {
	my ($meta, $name, $path, %opts) = @_;

	$meta -> add_api_method($name, $path, 'GET', %opts);
}

=head2 post_api $name, $path, %opts

Add a new POST API method with name C<$name> which fetches C<$path>.

See L</"OPTIONS"> for the additional options.

=cut

sub post_api {
	my ($meta, $name, $path, %opts) = @_;

	$meta -> add_api_method($name, $path, 'POST', %opts);
}

=head2 put_api $name, $path, %opts

Add a new PUT API method with name C<$name> which fetches C<$path>.

See L</"OPTIONS"> for the additional options.

=cut

sub put_api {
	my ($meta, $name, $path, %opts) = @_;

	$meta -> add_api_method($name, $path, 'PUT', %opts);
}

=head2 delete_api $name, $path, %opts

Add a new DELETE API method with name C<$name> which fetches C<$path>.

See L</"OPTIONS"> for the additional options.

=cut

sub delete_api {
	my ($meta, $name, $path, %opts) = @_;

	$meta -> add_api_method($name, $path, 'DELETE', %opts);
}

=head2 patch_api $name, $path, %opts

Add a new PATCH API method with name C<$name> which fetches C<$path>.

See L</"OPTIONS"> for the additional options.

=cut

sub patch_api {
	my ($meta, $name, $path, %opts) = @_;

	$meta -> add_api_method($name, $path, 'PATCH', %opts);
}

=for Pod::Coverage init_meta

=cut

sub init_meta {
	my ($class, %options) = @_;

	my $for = $options{'for_class'};

	Moose -> init_meta(%options);

	my $meta = Moose::Util::MetaRole::apply_metaroles(
		for		=> $for,
		class_metaroles	=> { class => ['WWW::API::Meta::Class'] },
	);
}

=head1 OPTIONS

Additional available options are:

=over

=item B<encoder>

A custom data encoding subroutine, used to serialize data sent to the web
services. By default data is encoded to www_form_urlencoded.

=item B<decoder>

A custom data decoding subroutine, use to deserialize data received from the
web services. By default data is decoded from JSON.

=item B<headers>

A custom subroutine that returns an hashref containing additional HTTP headers.

=back

=head1 AUTHOR

Alessandro Ghedini <alexbio@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2012 Alessandro Ghedini.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut

1; # End of WWW::API
