#!/usr/bin/perl
if ($ARGV[0] eq "--help")
{
	print "Usage: task37.py Path\n";
	print "Select 100 most used words in HTML text  that you specify by path or URL\n";	
	print "-h, --help show info about program\n";	
	print "-t, --test start program with same parameters\n";	
}
elsif ($ARGV[0] eq "--test")
{
	system("./test37.bash");
}

else
{
	use strict;
	use warnings;
	use LWP::Simple qw(get);
	use HTML::Strip;
	use HTML::TokeParser::Simple;	
	my $outputfile = "outputfile.txt";
	my $arg = $ARGV[0];
 	if (-e $arg)
	{
                open file1, ">", $outputfile;
                my $p = HTML::TokeParser::Simple->new ($arg);
                while ( my $token = $p->get_token ){
                       print file1 $token->as_is if $token->is_text; }
                close (file1);
	}
	else
	{
		my $html = get $arg;
                my $hs = HTML::Strip->new();
                my $clean = $hs->parse($html);
		$hs->eof;		
		open file2, ">", $outputfile;
		print file2 $clean;
		close (file2);
	}
	my %hash;
        open my $file, '<', $outputfile;
        while (<$file>)	{ 
        	$hash{ lc $1 }++ while /(\w+)/g; }
        close $file;
        my $counter = 0;
        for my $word ( sort { $hash{$b} <=> $hash{$a} || $a cmp $b } keys %hash )
        {
		print "$counter. $word: ($hash{$word})\n" if $counter++ < 100 or !( $counter % 1000 );
        }

}
