#!/usr/bin/perl
no warnings;
use Google::Search;
$N=$ARGV[0];
$keyword=$ARGV[1];
#Open samples.txt.
open(my $fha,'+<' ,"samples.txt") or die "Could not open file 'samples.txt' $!";
#Read the previous samples created except the ones that is created for current image.
my @temporary;
$pass=1;
while(<$fha>){
	if($_=~/LABEL:\s(.+)/){
		if($1 eq $keyword){
			$pass=0;		
		}else{
			$pass=1;
		}

	}
	if($pass==1){
	push(@temporary,$_);
	}	

}
close $fha;
#Truncate the samples.txt and merge the previous and current output.
open(my $fha,'+>' ,'samples.txt') or die "Could not open file 'samples.txt' $!";

for $t (@temporary){
	print $fha "$t";
}
#Get the url's and and write the output to the file.
my $search = Google::Search->Image( query => $keyword );
 $count=0;
print $fha "LABEL: $keyword\n";
 while ( my $result = $search->next ) {
    if($count==$N){
	last;   }
	$r=$result->rank;
	$u=$result->uri;
     	print $result->rank,'  ', $result->uri,"\n";
	print $fha "$r->$u \n";
	$count=$count+1;
   }
