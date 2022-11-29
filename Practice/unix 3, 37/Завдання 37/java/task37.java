import java.util.Objects;
import java.io.IOException;
import java.io.File;
import java.nio.file.Files;
import java.util.stream.Stream;
import java.nio.file.*;
import java.util.*;
import java.io.*;
import java.io.FileReader;
import java.io.Reader;
import java.io.BufferedReader;
import java.io.FileWriter;   
import java.util.Map;
import java.util.Scanner;
import java.util.HashMap;
import java.net.*;
               
public class task37
{    
	
public static void main(String[] args) throws IOException
{
	if (Objects.equals(args[0], "--help"))
        {
        	System.out.println("Usage: java task37 Path");
      		System.out.println("Select 100 most used words in HTML text  that you specify by path or URL");
      		System.out.println("-h, --help show info about program");
      		System.out.println("-t, --test start program with same parameters");					
    	}
    	else if (Objects.equals(args[0], "--test"))
    	{
      		ProcessBuilder pb = new ProcessBuilder("./test37.bash").inheritIO();
      		pb.start();
    	}
    	else
    	{ 
		File check_arg = new File(args[0]);		
		FileWriter output_file = new FileWriter("output.txt");	

		if (check_arg.exists()) 
		{
			StringBuilder sb = new StringBuilder();	
			BufferedReader br = new BufferedReader(new FileReader(args[0]));
			String line;
			while ((line=br.readLine()) != null)
			{
				sb.append(line);
			}	
			String nohtml = sb.toString().replaceAll("\\<[^>]*>","");
			output_file.write(nohtml);
			output_file.close();
		}
		else 
		{
			StringBuilder sb = new StringBuilder();	
			URL get_url = new URL(args[0]);	
			BufferedReader br = new BufferedReader(new InputStreamReader(get_url.openStream()));
			String line;
			while ((line=br.readLine()) != null)
			{
				sb.append(line);
			}
			String nohtml = sb.toString().replaceAll("\\<[^>]*>","");
			output_file.write(nohtml);
			output_file.close();		
		}
		
		Scanner file = new Scanner (new File("output.txt"));
		Map<String, Integer> words = new HashMap<String, Integer>();
	    	while(file.hasNext())
	    	{
			String word = file.next().toLowerCase();
			Integer count = words.get(word);
			if(count!=null)
				count++;
			else
				count=1;
			words.put(word,count);
			
		}	
		LinkedHashMap<String, Integer> reverseSortedMap = new LinkedHashMap<>();
				words.entrySet()
					  .stream()
					  .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder())) 
					  .limit(100)
					  .forEachOrdered(x -> reverseSortedMap.put(x.getKey(), x.getValue()));
		System.out.println(reverseSortedMap);
	}		
}
}
