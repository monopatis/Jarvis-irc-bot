#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use FindBin;
#$0 = "stealth";
my $event = 'foo';
my $string = 'Remote';
my $oldevent = 'foo';
my $message = 'foo';
my $time = '00:00';
my $url = 'http://pspace.dyndns.org/report/index.php?limit=1&nostyle';
#add # if you want to see the last event on start
#$oldevent = get("$url");
my @values = split(' ', $oldevent);
#always
while (1==1)
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
			$message = 'Card used by ' . $user ; 
		}
#		system("notify-send 'P-space is open' '$message, $time ago' -t 60  -i $FindBin::Bin/logo.png");
# 		Use this for fedora and gnome3
		system("notify-send 'P-space is open' '$message, $time ago' --hint=int:transient:1  -i $FindBin::Bin/logo.png");
	}
	sleep(15);
}
