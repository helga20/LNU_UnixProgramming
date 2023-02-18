import java.io.File;
import java.nio.file.*;
import java.text.SimpleDateFormat;

class HelloWorld {
	private static boolean verbose;

	private static void Error(String s)
	{
		System.out.println(s + "\nTry --help for more information");
		System.exit(1);
	}

	private static void Info(String s)
	{
		if(verbose)
			System.out.println(s);
	}

    public static void main(String[] args) {
		File diff_dir = null;
		File dir = null;
		for(int i = 0; i < args.length; i++)
		{
			String flag = args[i];

			if(flag.charAt(0) == '-')
			{
				if(flag.equals("--help"))
				{
					System.out.println(
						"""
usage: lab_1.py [--help] [--verbose] [--diff_dir DIFF_DIR] DIR

In the DIR directory, leave files that are \"fresher\" at the time of modification than files with the same name in the given directory DIR_DIFF, or are not found in DIR_DIFF

positional arguments:
  DIR

options:
  --help              show this help message and exit
  -verbose            explain what is being done
  -diff_dir DIFF_DIR  set DIR_DIFF directory
						""");
					System.exit(0);
				}

				else if(flag.equals("--verbose"))
					verbose = true;

				else if(flag.equals("--diff_dir"))
				{
					i += 1;
					if(i == args.length || args[i].charAt(0) == '-')
						Error(flag + ": missing operand");
					diff_dir = new File(args[i]);
				}
				else
					Error(flag + ": invalid flag");

			}
			else
			{
				if(dir != null)
					Error("Invalid arguments number");

				dir = new File(flag);
				if(!dir.isDirectory())
					Error(dir + ": there is no such directory");
			}
		}
		if(dir == null)
			Error("Invalid arguments number");

		if(diff_dir == null)
			diff_dir = new File(dir + "_diff");

		if(!diff_dir.isDirectory())
			Error(diff_dir + ": there is no such directory");

		SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");

		for(File file: dir.listFiles())
		{
			if(file.isDirectory())
				continue;
			File diff_file = new File(Paths.get(diff_dir.getPath(), file.getName()).toString());
			if(diff_file.exists() && diff_file.lastModified() > file.lastModified())
			{
				Info(String.format("%s removed, because his date is %s, and date in DIR_DIFF is %s", file.getName(), sdf.format(file.lastModified()), sdf.format(diff_file.lastModified())));
				file.delete();
			}
		}

    }
}
