#!/usr/bin/perl

use strict;
#use warnings;
use LWP::Simple;
use FindBin;
use IO::Socket;
my $srv = IO::Socket::INET->new(PeerAddr=>'irc.freenode.net',
	PeerPort=>'6667',
	Proto=>'tcp',
	Timeout=>'30')||print "Cannot wait more... 30 secs already passed ! $!\n";

print $srv "USER events 8 * :Perl IRC\r\n";
print $srv "NICK PspaceEvents\r\n";
print $srv "JOIN #p-space\r\n";
#$0 = "stealth";
my $response = 'foo';
my $ready = 0;
my $event = 'foo';
my $string = 'Remote';
my $oldevent = 'foo';
my $message = 'foo';
my $time = '00:00';
my $url = 'http://pspace.dyndns.org/report/index.php?limit=1&nostyle';
#add # if you want to see the last event on start
#$oldevent = get("$url");
my @values = split(' ', $oldevent);

while($response = <$srv>)
{
	print $response;

	if (($response =~ /PRIVMSG/) && ($response =~ /PspaceEvents who/i))
	{
#		print $srv "PRIVMSG #p-space :$message, $time ago\r\n";
	}
	if (($response =~ /PRIVMSG/) && ($response =~ /PspaceEvents sousami anoi3e/i))
	{
		$ready = 1;
	}
	if ($response =~ /^PING(.*)$/i)
	{
		print $srv "PONG".$1."\r\n";
	}
	if ($ready==1)
	{
		$event = get("$url");
		if ($oldevent ne $event){
			$oldevent = $event ; 
			@values = split(' ', $oldevent);
			my $diftime= time()-$values[0];
			my ($sec, $min, $hour, $day,$month,$year) = (gmtime($diftime))[0,1,2,3,4,5];
			$hour=$hour+($day-1)*24;
	#		print "Unix time ".$diftime." means ".$day." day, ";
	#		print " ".$hour.":".$min.":".$sec."\n";
			my $secs = sprintf("%02d", $sec);
			my $mins = sprintf("%02d", $min);
			my $hours = sprintf("%02d", $hour);
			if ($hour>0){
			
				$time = "$hour:$mins:$secs hours";
			}
			else{ 
				if ($min>0) {
					$time = "$min:$secs mins";
				}
				else {
					$time = "$sec secs"; 
				}
			}
			if ($string eq $values[1]){
				$message = "remote button pressed";
			}
			else { 
				@values = split('<', $values[1]);
				my $user = $values[0];
				$message = 'Card was used by ' . $user ; 
			}
#			'P-space is open' '$message, $time ago' 
 			print $srv "PRIVMSG #p-space :$message, $time ago\r\n";
			}
		sleep(5);
	}
}
