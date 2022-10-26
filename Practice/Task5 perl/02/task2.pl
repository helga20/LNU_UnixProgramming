#!/usr/bin/perl
if ($ARGV[0] eq "--help")
{
	print "Usage: task2.pl DIR DIR_TO *.EXT\n";
	print "Copy all files that have EXT extention from DIR to DIR_TO\n";	
}
elsif ($ARGV[0] eq "--test")
{
	system("./test2.bash");
}
elsif (scalar @ARGV != 3)
{
	print "task2.pl: missing file operands\n";
	print "Try 'task2.pl --help' for more information\n";
}
else
{
	use File::Find::Rule;
	use File::Copy;
	my @files = File::Find::Rule->file()
                     		    ->name($ARGV[2])
                           	    ->in($ARGV[0]);
	for my $file (@files)
	{
		copy($file, $ARGV[1]) or die "Unable to copy: $!";	
	}
}
	
