import java.io.*;
import java.nio.file.*;
import java.util.*;
class source 
{ 
	public static void findFiles(File file, ArrayList<File> files, FileFilter filter) 
	{
		File[] all = file.listFiles(filter);

		for (File f : all) 
		{
		    if (f.isDirectory()) 
		    {
		        findFiles(f,files,filter);
		    } 
		    else 
		    {
		        files.add(f);
		    }
		}
    	}
    
	public static void main(String[] args) throws Exception 
	{
		if (Objects.equals(args[0], "--help"))
		{
			System.out.println("Usage: java source DIR DIR_TO SIZE N");
		 	System.out.println("Copy first N files exceeding SIZE from DIR to DIR_TO");
			System.out.println("-h, --help show info about program");
			System.out.println("-t, --test start program with same parameters");
	    }
	    else if (Objects.equals(args[0], "--test"))
	       	{
				ProcessBuilder pb = new ProcessBuilder("./test.bash").inheritIO();
				pb.start();
	       	}
		else if (args.length != 3)
	    {
			System.out.println("java source: missing file operands");
		 	System.out.println("Try 'java source --help' for more information");
	    }
	    else
	    {  
			String dir = args[0];
			String dir_to = args[1];
			long size = Long.parseLong(args[2]);
			int n = Integer.parseInt(args[3]);
			List<Path> files = new ArrayList<>();
			Files.walk(Paths.get(dir)).filter(Files::isRegularFile).forEach(files::add);
			files.sort(Comparator.comparingLong(f -> f.toFile().length()));
			long total = 0;
			for (int i = 0; i < files.size(); i++) {
			 	if (total + files.get(i).toFile().length() > size && i >= n) {
				    	Files.move(files.get(i), Paths.get(dir_to + "/" + files.get(i).getFileName()));
			    	} else {
					total += files.get(i).toFile().length();
			    	}
			}
	 	}
	}
}

