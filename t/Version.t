use Test::More tests => 1;
BEGIN { use_ok('Net::DNS::Version') };

my $host = "127.0.0.1";

my $scan = Net::DNS::Version->new({
	host    => $host,
	timeout => 5,
	debug   => 0
});

my $version = $scan->check;

print "$host : $version\n";

exit(0);

