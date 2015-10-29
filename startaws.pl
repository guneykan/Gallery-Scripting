#!/usr/bin/perl
#Open keys and settings file.
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
my %settings;
#Get the instance id and zone.
while(<SETTINGS>){
	if(/([^\s]+)\s*=\s*(.+)/){
	$settings{$1}=$2;
	}
}
close (SETTINGS);
#Start the instance.
print `ec2-start-instances --region $settings{'region'} $settings{'id'}`;



 
 
