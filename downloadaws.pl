#!/usr/bin/perl
#Open keys.txt and setting.txt.
open KEYFILE, "keys.txt" or die $!;
open SETTINGS, "setting.txt" or die $!;
$counter = 0;
$success=1;
#Export access keys.
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
#Get instance id and zone.
$num_args=$#ARGV+1;
my %settings;
while(<SETTINGS>){
	if(/([^\s]+)\s*=\s*(.+)/){
	$settings{$1}=$2;
	}
}
close (SETTINGS);
#Get information of running instance.
$info=`ec2-describe-instances --region $settings{'region'} $settings{'id'}`;
#Get the dns of running instance.
if($info=~/(ec2-.+amazonaws\.com)/){
$dns=$1;
}
$adress='ec2-user@' . "$dns";
$i=1;
#Check if path is directory or file.
if(-d $ARGV[0]){
	if($num_args>3){
		$success=0;
		
	print "You can download just one directory or multiple files at once!!It seems you try to download more than one directory or you mixed directories and files.\n";		
		print "Usage: downloadaws.pl awsdir_name -o dir_name \n";
		print "Usage: downloadaws.pl awsdir_name -o file1 file2 ... \n";

}
	else{
		$file_names="$adress:" . $ARGV[0] . "\/*";
	}
}
else{
	$file_names="$adress:" . $ARGV[0];
}
	#Concatanate file names.	
	while($i<$num_args-2){
	
	$file_names=$file_names . ' ' . "$adress:" . $ARGV[$i];
	$i=$i+1;
}

$dir_name=$ARGV[$i+1];
$download_command="scp -r -i key.pem $file_names $dir_name";
#Download files.
print `$download_command`;

