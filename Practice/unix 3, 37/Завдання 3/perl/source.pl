#!/usr/bin/perl
if ($ARGV[0] eq "--help")
{
        print "Usage: source.pl  DIR DIR_TO SIZE N";
        print "Move first N files exceeding SIZE from DIR to DIR_TO\n";
        print "-h, --help show info about program\n";
        print "-t, --test start program with same parameters\n";			
}
elsif ($ARGV[0] eq "--test")
{
        system("./test.bash");
}
elsif (scalar @ARGV != 4)
{
        print "source.pl: missing file operands\n";
        print "Try 'source.pl --help' for more information\n";
}
else
{
    use File::Find::Rule;
    use File::Copy;
    use File::Basename;
	use strict;
	use warnings;
	use 5.010;
 
    my @files = File::Find::Rule->file()
                                ->in($ARGV[0]);
	my $total_size = 0;
	my $count = 0;
	my @sort_files = sort { $a cmp $b } @files;
        for my $file (@sort_files)
        {
		my $size = -s $file;
		$count = $count + 1;
		$total_size = $total_size + $size;
		if ($total_size < $ARGV[2] && $count <= $ARGV[3])
		{
			move($file, $ARGV[1]) or die "Unable to move: $!";
		} 
	}
        
}

