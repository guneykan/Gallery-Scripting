#!/usr/bin/perl
use imagga;
#Open keys.txt.
open KEYFILE, "keys.txt" or die $!;
$counter = 0;
#Export Access Keys.
while(<KEYFILE>){
        chomp;
	if(/IMAGGA_ACCESS_KEY\s*=\s*(.+)/){
		$apiKey= $1;
	}
	if(/IMAGGA_SECRET_KEY\s*=\s*(.+)/){
		$apiSecret= $1;
	}	
}
close(KEYFILE);

$filePath = $ARGV[0];
        
$imagga = new imagga($apiKey, $apiSecret);

my( $err, $hash ) = $imagga->tag_image($filePath);

print "Error: ".$err."\n";

for (keys %$hash)
{
	print  $_."  ->  ".$hash->{$_}."\n";
}
      
