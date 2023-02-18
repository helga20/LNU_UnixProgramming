use Getopt::Long;
use 5.010;
use File::Spec;
use File::Basename;
use File::stat;
use Time::localtime;

sub info {
	if($verbose) {
		say($_[0]);
	}
}

GetOptions ("diff_dir:s" => \$diff_dir,
            "verbose" => \$verbose,
            "help" => \$help)
or die("Error in command line arguments\n");


if($help == 1) {
	say (
"usage: lab_1.py [--help] [--verbose] [--diff_dir DIFF_DIR] DIR

In the DIR directory, leave files that are \"fresher\" at the time of modification than files with the same name in the given directory DIR_DIFF, or are not found in DIR_DIFF

positional arguments:
  DIR

options:
  --help               show this help message and exit
  --verbose            explain what is being done
  --diff_dir DIFF_DIR  set DIR_DIFF directory
");
	exit;
}

my $dir = @ARGV[0];

if(scalar(@ARGV) != 1) {
	say("Invalid count of arguments") and exit;
}

if(!$diff_dir){
	$diff_dir = "${dir}_diff";
}

if(!-d $dir) {
	say("$dir: no such directory") and exit;
}
if(!-d $diff_dir){
	say("$diff_dir: no such directory") and exit;
}

my @files = glob( $dir . '/*' );

for my $file (@files){
	if(-d $file){
		next;
	}
	my $filename = basename($file);
	my $diff_file = File::Spec->catfile($diff_dir, basename($file));
	if(-e $diff_file and stat($diff_file)->mtime > stat($file)->mtime) {
		info("@{[basename($file)]} removed, because his date is @{[ctime(stat($file)->mtime)]} and date in DIFF_DIR is @{[ctime(stat($diff_file)->mtime)]}");
		unlink($file);
	}
}
