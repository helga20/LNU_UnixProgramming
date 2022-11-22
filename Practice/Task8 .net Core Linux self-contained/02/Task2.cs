using System;
using System.IO;
using System.Diagnostics;

namespace Task2
{
    internal class Program
    {	    	
        static void Main(string[] args)
        {
		if (!(args.Length == 3 || args.Length == 1))
		{
			Console.WriteLine("Task2: invalid arguments quantity");
			Console.WriteLine("Try 'Task2 --help' for more information");
		}
		else if(Equals(args[0], "--help"))
		{
			Console.WriteLine("Usage: Task2 DIR DIR_TO .EXT");
      			Console.WriteLine("Copy all files that have EXT extention from DIR to DIR_TO");
		}
		else if(Equals(args[0], "--test"))
		{
			var psi = new ProcessStartInfo();
			psi.FileName = "./test2.bash";
			psi.UseShellExecute = false;
			psi.CreateNoWindow = true;
			using var process = Process.Start(psi);
			if (process != null) process.WaitForExit();
		}	
		else
		{		 	
		 	string sourcePath = args[0];
			string targetPath =  args[1]; 
			var extensions = new[] { args[2] }; 
			var files = (from file in Directory.EnumerateFiles(sourcePath, "*", SearchOption.AllDirectories)
			where extensions.Contains(Path.GetExtension(file), StringComparer.InvariantCultureIgnoreCase) 
			select new 
			{
				Source = file, 
				Destination = Path.Combine(targetPath, Path.GetFileName(file))
			});
			foreach(var file in files)
			{
			  File.Copy(file.Source, file.Destination);
			}		
		}
        }
    }
}
