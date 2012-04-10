package WWW::API::Role::Encoder::WWWFormURLEncoded;
{
  $WWW::API::Role::Encoder::WWWFormURLEncoded::VERSION = '0.03'; # TRIAL
}

use strict;
use warnings;

use HTTP::Tiny 0.014;
use Moose::Role;

=head1 NAME

WWW::API::Role::Encoder::WWWFormURLEncoded - WWW::API's www_form_urlencoded encoder role

=head1 VERSION

version 0.03

=cut

=for Pod::Coverage api_encode

=cut

sub api_encode {
	my ($self, $data) = @_;
	return HTTP::Tiny -> new -> www_form_urlencode($data);
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

1; # End of WWW::API::Role::Encoder::WWWFormURLEncoded
