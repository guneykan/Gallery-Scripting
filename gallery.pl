#!/usr/bin/perl

#If the user does not sepecify option print an error message.
if ($#ARGV + 1 == 0) {
    print "Missing argument: Usage gallery.pl args\n";
} else {

    #--listlabels option.
    if ($ARGV[0] eq '--listlabels') {
        #If the user gives another paramater print an error message.
        if ($#ARGV + 1 > 1) {
            print "More arguments than expected: Usage gallery.pl --listlabels\n";
        } else {
            
	#Read the output of labelimage.pl.
	open KEYFILE, "report.txt" or die $!;
	while(<KEYFILE>){
		chomp;
		print "$_\n";

	}

        }
    }
    #--listimages option.
    elsif($ARGV[0] eq '--listimages') {
	#Read the file names that the gallery contains.
         open(my $allimages,'+<' ,'files.txt') or die "Could not open file      'files.txt' $!";
        if ($#ARGV + 1 == 1) {
	   while(<$allimages>){
		print "$_";
	}
	close $allimages;
        } else {
		#Read the photos and tags of the gallery.
		$image=$ARGV[1];
		open REPORT2, "report2.txt" or die $!;
		 my %mytags;
    		 my $name;
		my @names;
		my @all_names;
		#Skip the current image and tags of that image.
		while(<REPORT2>){
				if(/^Name:\s*([^\s]+)/){
				$name=$1;
				push(@all_names,$name);
				chomp ($name);
				@mytags{$name}='';

			}else{
				chomp($_);
				if($_ eq $image){
					push(@names,$name);
				}
				$mytags{$name}=$mytags{$name} . $_ . ' ';
				}
			}

            if ($#ARGV + 1 == 2) {
		for $i (@names){
			print "$i\n" ;
		}
            }
	   #--similar option.
            elsif($#ARGV + 1 == 3) {
                if ($ARGV[1] eq '--similar') {
			$similar=$ARGV[2];
			my %check;
			@labels=split / /, $mytags{$similar};
			for $i (@labels){
				chomp($i);
				$check{$i}=1;
			}
			#Check if there is a similar image.
			for $i (@all_names){
				chomp($i);
				$boolean =0;
				if($i ne $similar){
					@tmp=split / /,$mytags{$i};
					for $j (@tmp){
						chomp($j);
						if ($check{$j}==1){
							$boolean=1;
						}
					}			
				}
				if($boolean==1){
					print "$i\n";		
				}
			}			
		
		} 
		#If the user gives unexpected option print usage.		
		else {
                    print "-Usage-1 : gallery.pl --listimages \n";
                    print "-Usage-2 : gallery.pl --listimages \"label_name\"\n";
                    print "-Usage-3  : gallery.pl --listimages --similar \"label_name\"\n";
                }
            } else {

                print "-Usage-1 : gallery.pl --listimages \n";
                print "-Usage-2 : gallery.pl --listimages \"label_name\"\n";
                print "-Usage-3  : gallery.pl --listimages --similar \"label_name\"\n";
            }
        }


    }

    #--listsamples option.
    elsif($ARGV[0] eq '--listsamples') {
        if ($#ARGV + 1 == 2) {
			#Read preferences.txt.
			#Preferences.txt contains sample number the user wants.
			open PREFERENCE, "preferences.txt" or die $!;
			my %numbers;
					
		while(<PREFERENCE>){
			chomp;
			@arr=split /=/,$_;
			$numbers{$arr[0]}=$arr[1];		
		}
		close PREFERENCE;

			#Run the searchlabels.pl.
			`./searchlabels.pl $numbers{'SampleNumber'} $ARGV[1]`;
           	open sample, "samples.txt" or die $!;
		my %samples;	
		#Read samples.txt and get the output of searchlabel.pl.
		while(<sample>){
			if(substr($_,0,5) eq 'LABEL'){	
				$labl=substr($_ ,7);
				chomp ($labl);
				$samples{$labl}='';

			}else{
				chomp($_);			
				$samples{$labl}=$samples{$labl} . $_ . ' ';
				}
			}
		#Print the samples.
		@g_samples=split/ /,$samples{$ARGV[1]};
		for $i (@g_samples){		
			print "$i\n";
		}


	
		
        } else {
            print "-Usage-1 : gallery.pl --listsamples\n";

        }

    }
	#Add a directory to the gallery.
	#The user cannot add a single file to the gallery.
    elsif($ARGV[0] eq '--add') {
        if ($#ARGV + 1 == 2) {
		#Read preferences.txt.
		#preferences.txt contains the number of tags the user wants.
	    	open PREFERENCE, "preferences.txt" or die $!;
			my %numbers;
					
		while(<PREFERENCE>){
			chomp;
			@arr=split /=/,$_;
			$numbers{$arr[0]}=$arr[1];		
		}
		close PREFERENCE;
                #Merge the previous added files and current directory.
		$file=`find $ARGV[1] -type f -name \"*.jpg\"`;
		@files=split /\n/, $file;
	#Read files.txt.
	#files.txt contains all the image names gallery contains.
    open(my $fh,'+<' ,'files.txt') or die "Could not open file      'files.txt' $!";
		my %exist;
		while(<$fh>){
			chomp;
			$exist{$_}=1;

		}

		for $f (@files){
		 `./labelimage.pl $numbers{'TagNumber'} $f\n`;
		#Write the new file names to files.txt.
			if($exist{$f}!=1){
				print $fh "$f\n";}
			}
		
		close $fh;
        } else {
            print "-Usage: gallery.pl --add \"dirname\"\n";
        }

    } else {

        print "No expected argument\n";
    }


}
