#!/usr/bin/perl 
#Open keys and setting file.
open KEYFILE, "keys.txt" or die $!;
open SETTINGS, "setting.txt" or die $!;
#Export Access Keys.
while(<KEYFILE>){
        chomp;
	if(/AWS_ACCESS_KEY\s*=\s*(.+)/){
		$ENV{AWS_ACCESS_KEY} = $1;
	}
	if(/AWS_SECRET_KEY\s*=\s*(.+)/){
		$ENV{AWS_SECRET_KEY} = $1;
	}	
}
close(KEYFILE);
#Get the instance id and zone.
my %settings;
while(<SETTINGS>){
	if(/([^\s]+)\s*=\s*(.+)/){
	$settings{$1}=$2;
	}
}
close (SETTINGS);
#Stop the instance.
print `ec2-stop-instances --region $settings{'region'} $settings{'id'}`;
