# Gallery-Scripting
A program that synchronizes a photograph gallery data.
To run the program correctly please read the following sections.

Sections:
----------------------------------------------------------------------------------------------------
                                            Required Packages                                      -
----------------------------------------------------------------------------------------------------
To run the scripts properly cpan,CUrl and Google::Search api should be installed.
To install cpan ->sudo apt-get install cpanminus
To install Google::Search ->sudo cpanm Google::Search
Note:Google::Search api gives a warning about overloading ' '. This is about
the api not my scripts. 		
-----------------------------------------------------------------------------------------------------
			                        Usage                                               -
-----------------------------------------------------------------------------------------------------
All scripts are executable.
Usage of the scripts:  ./<script_name> <args>.
<args> are the same specified in the project description.
To change settings and keys, please read Extra Files section.

If you want to control the gallery using gallery.pl, you can specify the
number of tags and number of samples from preferences.txt.  
-----------------------------------------------------------------------------------------------------
			                        Assumptions                                         -
-----------------------------------------------------------------------------------------------------
All images should be in jpg format.
To add a directory to the gallery, directory name should not contain empty space.
If you add a directory to the gallery with command './galley.pl --add ./dir_name', when using --similar
option you should use './dir_name/image' not 'dir_name/image'.   
Perl directory should be in /usr/bin/perl.
Required packages should be installed.
If you run the system on the same image more than once the last output will be available and the previous 
ones will be overwritten.
If you upload or download an image with the same name more than once to same directory the last image 
will be available and previous one will be overwritten.
The sample files are not downloaded. Just the Url's are available.
All the files specified in Extra Files section should be in the same directory with scripts.
To run an instance id,region and private key file should be specified in the setting.txt.   
------------------------------------------------------------------------------------------------------
                                            Extra Files                                              -
------------------------------------------------------------------------------------------------------
The files below numbered up to 3 are used as database.
The files below numbered as 4,5,6 and 7 are used to keep settings and keys. 
These files should be located in the same directory with the scripts.
Also all the scripts should be located in the same directory.
1)report.txt
Stores the unique tags the gallery contains. It is used by labelimage.pl and gallery.pl.
2)report2.txt
Stores the tags and images(image paths) the gallery contains. 
It is used by labelimage.pl and gallery.pl.
3)samples.txt
Stores the samples the user created(URL'S).It is used by searchlabels.pl and gallery.pl.
4)preferences.txt
This file contains the number of samples and number of tags the user wants to create.
5)keys.txt
This file contains AWS and Imagga keys.
6)setting.txt
This file contains the information about the amazon instance. The user should
give the instance id,region and the name of private key file.
Note:Private key file should be located in the same directory with the scripts.
Note:I did not remove my own keys or settings to give an example of format of the files.


