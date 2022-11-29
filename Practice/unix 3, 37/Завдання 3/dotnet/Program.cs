// See https://aka.ms/new-console-template for more information
using System;
using System.IO;
using System.Diagnostics;

namespace Task_7
{
	internal class Program
    	{        
        	static void Main(string[] args)
        	{
    			if(Equals(args[0], "--help"))
    			{
      				Console.WriteLine("Usage: ./MyApp  DIR DIR_TO SIZE N");
            			Console.WriteLine("Leave the first N files that do not exceed the specified number of V bytes in the specified directory DIR,");
            			Console.WriteLine(" and move the rest to the specified directory DIR_TO");
                Console.WriteLine(" -h, --help show info about program");
                Console.WriteLine(" -t, --test start program with same parameters ");
            }
    			else if(Equals(args[0], "--test"))
    			{
      				var psi = new ProcessStartInfo();
      				psi.FileName = "./test.bash";
      				psi.UseShellExecute = false;
      				psi.CreateNoWindow = true;
      				using var process = Process.Start(psi);
      				if (process != null) process.WaitForExit();
    			}	  
    			else
    			{       
    				string SourceFolderPath = args[0];
    				string DestinationFolderPath = args[1];
        			string FilePath;
        			string FileName;
        			string MSize = args[2];
        			string MCount = args[3];
        			int MaxSize = Convert.ToInt32(MSize);
        			int MaxCount = Convert.ToInt32(MCount);
        			long CurrentSize = 0;
        			long CurrentCount = 0;
        			List<long> SizeList = new List<long>(); 

        			DirectoryInfo d = new DirectoryInfo(SourceFolderPath);

        			FileInfo[] Files = d.GetFiles();
        			foreach (FileInfo file in Files)
        			{
        				SizeList.Add(file.Length);
        			}
        			SizeList.Sort();
				//foreach (int x in SizeList)
				//{
				//    Console.WriteLine(x);
				//}
        			foreach (var item in SizeList)
        			{
        				foreach (FileInfo file in Files)
        				{
        					if(file.Length == item)
        					{
        						FilePath = file.FullName;
            						//Console.WriteLine(FilePath);
            						FileName = file.Name;
							if (CurrentSize <= MaxSize && CurrentCount < MaxCount)
							{
								//Console.WriteLine("SIZE - "+CurrentSize);
								//Console.WriteLine("COUNT - "+CurrentCount);
            							CurrentSize += file.Length;
            							CurrentCount += 1;
            						}
            						else
            						{
            							//Console.WriteLine("MOVED - "+FileName);
            							File.Move(FilePath, DestinationFolderPath + "/" + FileName);
            						}
            					}
            				}
				}

        		}
        	}
	}
}
