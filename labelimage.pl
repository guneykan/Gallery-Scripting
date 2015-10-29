#!/usr/bin/perl

$path=$ARGV[1];
$N=$ARGV[0];
#Run imagesearch.pl.
$tags=`./imagesearch.pl $path`;
$tags=substr($tags,8);
my @words = split /\n/, $tags;
my %hash;
#Split the output of imagesearch.pl.
for my $word (@words) {	
	@element=split /  ->  /, $word;
	$hash{ $element[0] }=$element[1];

}
#Sort the tags according to confidentiality values.
@sorted_keys=sort ({ $hash{$b} <=> $hash{$a} } keys %hash);
$i=0;
my @crop;
for $cr (@sorted_keys){
if($i==$N){
last;
}
$crop[$i]=$cr;
$i=$i+1;
}

for $c (@crop){
print "$c\n";
}
#Open the report files.
my $filename = 'report.txt';
my $filename2 = 'report2.txt';
open(my $fh,'+<' ,$filename) or die "Could not open file '$filename' $!";
open(my $fha,'+<' ,$filename2) or die "Could not open file '$filename2' $!";
$count=0;
#Read the report files but do not read the tags of the current image.
my @temporary;
$pass=1;
while(<$fha>){
	if($_=~/Name:\s(.+)/){
		if($1 eq $path){
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
open(my $fha,'+>' ,$filename2) or die "Could not open file '$filename2' $!";

for $t (@temporary){
	print $fha "$t";
}


while(<$fh>){
	chomp;
	push(@lines,$_);
}
#Union and intersection of previous and current tags.
foreach $e (@lines) { $union{$e} = 1 }

foreach $e (@crop) {
    if ( $union{$e} ) { $isect{$e} = 1 }
    $union{$e} = 1;
}
@union = keys %union;
@isect = keys %isect;
print $fha "Name: $path\n";
#Write the unique output to the report files.
for my $rep (@crop) {	
	if($count==$N){ last;}
	if($isect{$rep}!=1){
		if($rep=~/[A-Za-z0-9]+/){
			print $fh "$rep\n";
		}
	}
	if($rep=~/[A-Za-z0-9]+/){
	print $fha "$rep\n";
		}
	$count=$count+1;
}
close $fh;
close $fha;
