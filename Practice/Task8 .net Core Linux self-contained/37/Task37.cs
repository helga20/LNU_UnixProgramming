using System;
using System.Diagnostics;
using System.Text.RegularExpressions;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;

namespace Task37 
{
    internal class Program
    {	    	
        static void Main(string[] args)
        {
        	if (!(args.Length == 1))
		{
			Console.WriteLine("Task37: invalid arguments quantity");
			Console.WriteLine("Try 'Task37 --help' for more information");
		}
		else if(Equals(args[0], "--help"))
		{
			Console.WriteLine("Usage: Task37 URL or *.html");
      			Console.WriteLine("Select the 100 most used words in HTML text");
		}
		else if(Equals(args[0], "--test"))
		{
			var psi = new ProcessStartInfo();
			psi.FileName = "./test37.bash";
			psi.UseShellExecute = false;
			psi.CreateNoWindow = true;
			using var process = Process.Start(psi);
			if (process != null) process.WaitForExit();
		}	
		else
		{
		 	string filename ="task_output.txt";
		 	StreamReader sr;
			if (File.Exists(args[0])) 
			{
				sr = new StreamReader(args[0]);
			}
			else 
			{
				string filenameurl = "taskfileurl.html";
				using (HttpClient client = new HttpClient())
				{
				   using (HttpResponseMessage response = client.GetAsync(args[0]).Result)
				   {
				      using (HttpContent content = response.Content)
				      {
					string result = content.ReadAsStringAsync().Result;
					System.IO.File.WriteAllText(filenameurl, result);
				      }
				   }
				}
				sr = new StreamReader(filenameurl);		
			}
			StreamWriter sw = new StreamWriter(filename);
			string? line;
			
			line = sr.ReadLine();
			
			while (!string.IsNullOrEmpty(line))
			{		
			    	String result = Regex.Replace(line, "<.*?>", String.Empty);
			    	sw.WriteLine(result);
				line = sr.ReadLine();
			}		    	
			sr.Close();
			sw.Close();
			
			string text = File.ReadAllText(filename);
          		Dictionary<string, int> stats = new Dictionary<string, int>();
			char[] chars = { ' ', '.', ',', ';', ':', '?', '\n', '\r' };
			string[] words = text.Split(chars);
			int minWordLength = 2;
			foreach (string word in words)
			{
			    string w = word.Trim().ToLower();
			    if (w.Length > minWordLength)
			    {
				if (!stats.ContainsKey(w))
				{
				    stats.Add(w, 1);
				}
				else
				{
				    stats[w] += 1;
				}
			    }
			}
			int n = 100;
			var orderedStats = stats.OrderByDescending(x => x.Value).Take(n);
			foreach (var pair in orderedStats)
			{
			    Console.WriteLine("{0} : {1}", pair.Key, pair.Value);
			}	
		}
        }
    }
}
