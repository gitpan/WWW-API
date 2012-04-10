package WWW::API::Role::Decoder::XML;
{
  $WWW::API::Role::Decoder::XML::VERSION = '0.03'; # TRIAL
}

use strict;
use warnings;

use XML::Simple;
use Moose::Role;

=head1 NAME

WWW::API::Role::Decoder::XML - WWW::API's XML decoder role

=head1 VERSION

version 0.03

=cut

=for Pod::Coverage api_decode

=cut

sub api_decode {
	my ($self, $data) = @_;
	return XMLin($data);
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

1; # End of WWW::API::Role::Decoder::XML
