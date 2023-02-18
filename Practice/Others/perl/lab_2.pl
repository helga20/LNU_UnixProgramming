use Getopt::Long;
use 5.010;
use List::Util qw( min max );

sub info {
	if($verbose) {
		say($_[0]);
	}
}

my $number = 1;

GetOptions ("number:i" => \$number,
            "verbose" => \$verbose,
            "help" => \$help)
or die("Error in command line arguments\n");

if($help == 1) {
	say ("
usage: lab_2.py [--help] [--verbose] [--number NUMBER] FILE

retrieves NUMBER(default=1) words that appear either before or after words: \"giants\", \"patriots\"

positional arguments:
  FILE

options:
  --help             show this help message and exit
  --verbose          explain what is being done
  --number NUMBER    set NUMBER of words
");
	exit;
}

my $file = @ARGV[0];

if(scalar(@ARGV) != 1) {
	say("Invalid count of arguments") and exit();
}

if(!-e $file){
	say("$file: there is no such file") and exit();
}

if($number <= 0){
	say("number should be positive") and exit();
}

my $text = do{local(@ARGV,$/)=$file;<>};

$text =~ s/<[^>]*>/ /g;
$text =~ s/[^a-zA-Z0-9 ]/ /g;

my @words = split(' ', lc($text));

for my $i (0 .. $#words){
	my $word = @words[$i];
	if($word eq "patriots" or $word eq "giants"){
		info("\nfind \'$word\' word at $i position; $number words before and after is:");
		my $before = join(' ', @words[max(0, $i - $number) .. $i - 1]);
		my $after = join(' ', @words[$i + 1 .. min($#words, $i + $number)]);
		say("$before || $after");
	}
}

