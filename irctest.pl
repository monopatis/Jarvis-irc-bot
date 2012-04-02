use IO::Socket;
$srv = IO::Socket::INET->new(PeerAddr=>'irc.freenode.net',
	PeerPort=>'6667',
	Proto=>'tcp',
	Timeout=>'30')||print "Cannot wait more... 30 secs already passed ! $!\n";

print $srv "USER Botaki 8 * :Perl IRC\r\n";
print $srv "NICK PspaceEvents\r\n";
print $srv "JOIN #reprap.gr\r\n";

while($response = <$srv>)
{
	print $response;

	if (($response =~ /PRIVMSG/) && ($response =~ /PspaceEvents sleep/i))
	{
		print $srv "PRIVMSG #reprap.gr :Bye ! ;-)\r\n";
		print $srv "PRIVMSG #reprap.gr :/quit";
		exit;
	}
	if ($response =~ /^PING(.*)$/i)
	{
		print $srv "PONG".$1."\r\n";
	}
}
