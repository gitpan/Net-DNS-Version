package Net::DNS::Version;

use 5.008006;
use strict;
use warnings;
use base qw(Class::Accessor::Fast);
use Carp;
use IO::Socket;

our $VERSION = '0.01';
$VERSION = eval $VERSION;

__PACKAGE__->mk_accessors( qw(host port timeout));

$| = 1;

sub check{

	my $self    = shift;
	my $host    = $self->host;
	my $port    = $self->port || '53';
	my $timeout = $self->timeout || '8';

	my $maxlen = 1024;
	my $proto  = "udp";
	my $data   = "\x65\x90\x01\x00\x00\x01\x00\x00\x00\x00" .
 	             "\x00\x00\x07\x76\x65\x72\x73\x69\x6f\x6e" .
		     "\x04\x62\x69\x6e\x64\x00\x00\x10\x00\x03";

	my $socket = IO::Socket::INET->new(
		PeerAddr => $host,
		PeerPort => $port,
		Proto    => $proto,
		Timeout  => $timeout,
	);

	$SIG{ALRM}=sub{close($socket);exit(0);};
	alarm $timeout;

	if ($socket){

		$socket->send($data);

		my $version;

		while ($socket->recv($version, $maxlen)){
			$version =~ tr/\x1F-\x7E\r//cd;
			$version =~ s/^eversionbind//;
			$version =~ s/^VERSIONBIND//;
			$version =~ s/^\///;
			$version =~ s/^\.//;
	
			return $version; 
		}

		close($socket);

	} 
}

1;
__END__

=head1 NAME

Net::DNS::Version - Perl module to grab DNS server version

=head1 SYNOPSIS

  use Net::DNS::Version;

  my $host = $ARGV[0];

  my $scan = Net::DNS::Version->new({
    host    => $host,
    timeout => 5
  });

  my $version = $scan->check;
  print "$host : $version\n";

=head1 DESCRIPTION

This module permit to grab DNS server version.

=head1 METHODS

=head2 new

The constructor. Given a host returns a L<Net::DNS::Version> object:

  my $scan = Net::DNS::Version->new({ host => "127.0.0.1" });

Optionally, you can also specify :

=over 2

=item B<port>

remote port. Default is 53 udp;

=item B<timeout>

default is 8 seconds;

=back

=head2 check

Checks the target.

  $scan->check;

=head1 SEE ALSO

man dig

=head1 AUTHOR

Matteo Cantoni, E<lt>mcantoni@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

You may distribute this module under the terms of the Artistic license.
See Copying file in the source distribution archive.

Copyright (c) 2006, Matteo Cantoni

=cut
