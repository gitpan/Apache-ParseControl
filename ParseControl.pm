package Apache::ParseControl;

require 5.005_62;
use strict;
use warnings;
use Apache::Constants qw(:common);
use Apache::File;

our $VERSION = '0.01';

sub handler {
	my $r = shift;
	my $debug;
	
	$debug = $r->dir_config('debugParseControl') eq 'on' ? 1 : 0;

	#my $flags = 'O_RDONLY';
	my $filename = $r->filename;

	$r->send_http_header;

	if ($debug == 1){
		my $host = $r->get_remote_host;
		my $ct = $r->content_type;
		my $uri = $r->uri;
		my $filetype ="";
		if (-B $filename) {
			$filetype = "binary";
			}
		else {
			$filetype = "text";
			}
		$r->print("$host\n$ct\n$uri\n$filename\n$filetype\n");
		}

	print $r->dir_config('debugNoParse');
	my $fh = Apache::File->new($filename); # thanks echo 
	$r->send_fd($fh);
	close $fh;
	return OK;
	}
	
1;

__END__

=head1 NAME

Apache::ParseControl - an apache module to control the parsing of server-side scripts

=head1 SYNOPSIS

In a VirtualHost, Location, or Directory directive

	SetHandler perl-script
	PerlHandler Apache::ParseControl

=head1 ABSTRACT

This module operates at the content handling stage of resource retrieval in Apache, returning binary files as binary and text files as text, that is, it will return the source of cgi, php, etc. instead of parsing any server-side scriping.

=head1 DESCRIPTION

The Apache web server module mod_dav facilitates the use of the WebDAV standard
within the Apache Web server.  The standard extends the Hypertext Transfer
Protocol adding request methods to PUT files up on a site, DELETE from a site,
MOVE, COPY, etc.  However, WebDAV uses the same GET request method to download files
that browsers use when reading them.  When a file is GET'ed, it is parsed by whatever handler
is assigned to it within the server. In the case of a plain html file, there is really 
no server-side parsing going on and therefore the source of the file is returned in a modifiable format.
In the case of a SSI, CGI, or PHP file, for example, the file is parsed by the default
handler for that file type and the output of that parse is returned in
response to the request.  This gives the client html source code, but not the
actual source code to the application.  This module intervenes at the content
handling stage of resource retrieval within Apache, reading the requested
filename, and bypassing its default handler, returing the file as is, with no parsing whatsoever.


=head1 AUTHOR INFORMATION

Copyright 2001, D. Anthony Patrick.  All rights reserved except as listed below.

Originally conceived and written for the College and Graduate School of Education at Kent State University.

Released with permission of The College and Graduate School of Education, Kent State University.

This library is free software;  you can distribute it and/or modify it under the same terms as Perl itself.

Check http://www.cpan.org and http://home.config.com/~dpatrick/computing/perl/
for new versions and updates.

=head1 CREDITS

=head1 BUGS

=head1 SEE ALSO

Stein & MacEachern, Writing Apache Modules with Perl and C, 1999, O'Reilly and Associates, ISBN 1-56592-567-X

WebDAV Resources Site - http://www.webdav.org

=head1 THANKS

To MDK for listening (and not listening) to my endless drone about the wonders of Perl and nature of computing today.

=cut
