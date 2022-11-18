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

import java.nio.file.Path;
          
public class task37
{    
	
public static void main(String[] args) throws IOException
{
	if (Objects.equals(args[0], "--help"))
        {
        	System.out.println("Usage: java task37 URL or *.html");
      		System.out.println("Select the 100 most used words in HTML text");
    	}
    	else if (Objects.equals(args[0], "--test"))
    	{
      		ProcessBuilder pb = new ProcessBuilder("./test37.bash").inheritIO();
      		pb.start();
    	}
        else if (args.length != 1)
    	{
          	System.out.println("java task37: missing file operands");
          	System.out.println("Try 'java task37 --help' for more information");
    	}
    	else
    	{ 
		File check_arg = new File(args[0]);	
		StringBuilder sb = new StringBuilder();	
		String line;
		BufferedReader br;
		if (check_arg.exists()) 
		{
			br = new BufferedReader(new FileReader(args[0]));
		}
		else 
		{
			URL get_url = new URL(args[0]);	
			br = new BufferedReader(new InputStreamReader(get_url.openStream()));			
		}
		while ((line=br.readLine()) != null)
		{
			sb.append(line);
		}	
		String nohtml = sb.toString().replaceAll("\\<[^>]*>","");
		
		Scanner strScanner = new Scanner (nohtml);
		Map<String, Integer> words = new HashMap<String, Integer>();
	    	while(strScanner.hasNext())
	    	{
			String word = strScanner.next().toLowerCase();
			Integer count = words.get(word);
			if(count!=null)
				count++;
			else
				count=1;
			words.put(word,count);		
		}	
		final Integer LIMIT_OF_WORDS = 100;
		LinkedHashMap<String, Integer> reverseSortedMap = new LinkedHashMap<>();
				words.entrySet()
					  .stream()
					  .sorted(Map.Entry.comparingByValue(Comparator.reverseOrder())) 
					  .limit(LIMIT_OF_WORDS)
					  .forEachOrdered(x -> reverseSortedMap.put(x.getKey(), x.getValue()));
		System.out.println(reverseSortedMap);
	}		
}
}
