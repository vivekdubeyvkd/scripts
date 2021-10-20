my $my_dir = "/tmp"; 
@files_in_dir = ();

if (-d "$my_dir") {
	opendir (DIR, "$my_dir") || die ("Unable to open $my_dir, please check and try again\n");
	@dir_file_list = grep -f, readdir (DIR);	
	closedir(DIR);
	foreach $file (@dir_file_list) {
	    # convert filenames to lower case 
	    $file =~ tr/A-Z/a-z/;
	    @files_in_dir = (@files_in_dir, $file);
	}
} else {
     print "Directory $my_dir does not exist\n"
}
