import java.io.File;
import java.nio.file.*;
import java.text.SimpleDateFormat;
import java.util.Vector;
import java.util.regex.Pattern;
import java.util.ArrayList;

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
		int number = 1;
		File file = null;
		for(int i = 0; i < args.length; i++)
		{
			String flag = args[i];

			if(flag.charAt(0) == '-')
			{
				if(flag.equals("--help"))
				{
					System.out.println(
						"""
usage: lab_2.py [--help] [--verbose] [-number NUMBER] FILE

retrieves NUMBER(default=1) words that appear either before or after words: \"giants\", \"patriots\"

positional arguments:
  FILE

options:
  --help             show this help message and exit
  --verbose          explain what is being done
  --number NUMBER    set NUMBER of words
						""");
					System.exit(0);
				}

				else if(flag.equals("--verbose"))
					verbose = true;

				else if(flag.equals("--number"))
				{
					i += 1;
					if(i == args.length || args[i].charAt(0) == '-')
						Error(flag + ": missing operand");
					if(!Pattern.compile("^[0-9]+$").matcher(args[i]).matches())
						Error(args[i] + " is not a positive number");
					number = Integer.parseInt(args[i]);
				}
				else
					Error(flag + ": invalid flag");
			}
			else
			{
				if(file != null)
					Error("Invalid arguments number");

				file = new File(flag);
				if(!file.isFile())
					Error(file + ": there is no such file");
			}
		}
		if(file == null)
			Error("Invalid arguments number");
		String text = "";
		try
		{
			text = Files.readString(file.toPath());
		}
		catch(Exception e)
		{
			Error(file + ": is not readable");
		}
		text = text.replaceAll("<[^>]*>", " ").replaceAll("[^a-zA-Z0-9 ]", " ").toLowerCase();
		String[] words_array = text.split(" ");
		Vector<String> words = new Vector<String>();
		for(String word: words_array)
			if(!word.equals(""))
				words.add(word);

		for(int i = 0; i < words.size(); i++)
		{
			if(words.get(i).equals("patriots") || words.get(i).equals("giants"))
			{
				Info(String.format("\nFind word %s at %d position; %d before and after is:", words.get(i), i, number));
				for(int j = Integer.max(0, i - number); j < Integer.min(words.size(), i + number + 1); j++)
				{
					if(i == j)
						System.out.print("|| ");
					else
						System.out.print(words.get(j) + ' ');
				}
				System.out.println();

			}
		}
    }
}
