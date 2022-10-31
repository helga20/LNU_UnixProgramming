#!/usr/bin/perl
if ($ARGV[0] eq "--help")
{
	print "Usage: task37.pl URL or *.html\n";
	print "Select the 100 most used words in HTML text\n";	
}
elsif ($ARGV[0] eq "--test")
{
	system("./test37.bash");
}
elsif (scalar @ARGV != 1)
{
	print "task37.pl: missing file operands\n";
	print "Try 'task37.pl --help' for more information\n";
}
else
{
	use strict;
	use warnings;
	use LWP::Simple qw(get);
	use HTML::Strip;
	use HTML::TokeParser::Simple;
	my $out = "output.txt";

 	if (-e $ARGV[0])
	{
	
                open FH, ">", $out;
                my $p = HTML::TokeParser::Simple->new ($ARGV[0]);
                while ( my $token = $p->get_token )
                {
                       print FH $token->as_is if $token->is_text;
                }
                close (FH);
	}
	else
	{
		my $html = get $ARGV[0];
                my $hs = HTML::Strip->new();
                my $clean = $hs->parse($html);
		$hs->eof;		
		open FH, ">", $out;
		print FH $clean;
		close (FH);
	}
	my %hash;
        open my $fh, '<', $out or die $!;
        while (<$fh>)
        {
		$hash{ lc $1 }++ while /(\w+)/g;
        }
        close $fh;
        my $i = 0;
        for my $word ( sort { $hash{$b} <=> $hash{$a} || $a cmp $b } keys %hash )
        {
		print "$i. $word: ($hash{$word})\n" if $i++ < 100 or !( $i % 1000 );
        }

}
