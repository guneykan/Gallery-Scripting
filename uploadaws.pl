#!/usr/bin/perl
#Open keys.txt and setting.txt.
open KEYFILE, "keys.txt" or die $!;
open SETTINGS, "setting.txt" or die $!;
$counter = 0;
$success=1;
#Read and export Access keys.
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

$num_args=$#ARGV+1;
$i=1;
#Check paths are directory or file.
if(-d $ARGV[0]){
	#If the user tries to upload more than one directory print error message.
	if($num_args>3){
        $success=0;
		print "You can upload just one directory or multiple files at once!!It seems you try to upload more than one directory or you mixed directories and files.\n";		
		print "Usage: uploadaws.pl dir_name -o awsdir_name \n";
		print "Usage: uploadaws.pl file1 file2 ... -o awsdir_name \n";	
		}
		
	else{
		$file_names=$ARGV[0] . "\/*";
	}
}
else{
	$k=1;
	while($k<$num_args){	
		if(-d $ARGV[$k]){
			$success=0;
			print "You can upload just one directory or multiple files at once!!It seems you mixed directories and files.\n";
		print "Usage: uploadaws.pl dir_name -o awsdir_name \n";
		print "Usage: uploadaws.pl file1 file2 ... -o awsdir_name \n";	
		}
		$k=$k+1;
	}
	$file_names=$ARGV[0];
}
	#Concatanate file-names.
	while($i<$num_args-2){
		$file_names=$file_names . ' ' . $ARGV[$i];
		$i=$i+1;
}

#Get the instance id and zone.
$dir_name=$ARGV[$i+1];
my %settings;
while(<SETTINGS>){
	if(/([^\s]+)\s*=\s*(.+)/){
	$settings{$1}=$2;
	}
}
close (SETTINGS);
#Get the information of running instance.
if($success==1){

	$info=`ec2-describe-instances --region $settings{'region'} $settings{'id'}`;
}
#Get the dns of running instance.
if($info=~/(ec2-.+amazonaws\.com)/){
	$dns=$1;
}
$adress='ec2-user@' . "$dns";

$upload_command="scp -r -i $settings{privatekey} $file_names $adress:$dir_name";
if($success==1){
	#Upload the files.
	print `$upload_command`;
}


