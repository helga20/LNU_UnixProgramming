import java.io.*;
import java.util.ArrayList;
import java.nio.file.Files;
import java.util.Objects;
class task2 
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
          	System.out.println("Usage: java task2 DIR DIR_TO .EXT");
          	System.out.println("Copy all files that have EXT extention from DIR to DIR_TO");
      	}
      	else if (Objects.equals(args[0], "--test"))
      	{
      		ProcessBuilder pb = new ProcessBuilder("./test2.bash").inheritIO();
          	pb.start();
      	}
        else if (args.length != 3)
      	{
            	System.out.println("java task2: missing file operands");
            	System.out.println("Try 'java task2 --help' for more information");
      	}
      	else
      	{
		File dirFrom = new File(args[0]);
		File dirTo = new File(args[1]);

		String[] type = 
		{
		    args[2]
		};
		
		FileFilter filter = new FileTypesFilter(type);
		File f = new File(args[0]);
		ArrayList<File> files = new ArrayList<File>();
		findFiles(f, files, filter);

		for (File file : files) 
		{
		            Files.copy(file.toPath(), (new File(dirTo, file.getName())).toPath());    
		} 
	}
    }
}

class FileTypesFilter implements FileFilter 
{
    String[] types;

    FileTypesFilter(String[] types) 
    {
        this.types = types;
    }

    public boolean accept(File f) 
    {
        if (f.isDirectory()) return true;
        for (String type : types) 
        {
            if (f.getName().endsWith(type)) return true;
        }
        return false;
    }
}
