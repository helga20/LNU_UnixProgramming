#include <cstdlib>
#include <iostream>
#include <fstream>
#include <filesystem>
namespace fs = std::filesystem;
int main(int argc, char **argv)
{
	if(std::string(argv[1]) == std::string("--help"))
	{
		std::cout << "Usage ./task2 DIR DIR_TO .EXT" << std::endl;
		std::cout << "Copy all files that have EXT extention from DIR to DIR_TO" << std::endl; 
	}	
	else if (std::string(argv[1]) == std::string("--test"))
	{
		system("./test2.bash");
	}
	else if (argc != 4)
	{	
		std::cout << "task2: missing file operands" << std::endl;
		std::cout << "Try './task2 --help' for more information" << std::endl;
	}
	else 
	{
		for (const auto & p : fs::recursive_directory_iterator(argv[1])) 
    		{	
     			fs::path fileToCopy = p; 
      			if (fileToCopy.extension() == argv[3])
  			{
      				fs::path target = argv[2] / fileToCopy.filename(); 
        			fs::copy_file(p,target,fs::copy_options::overwrite_existing); 
				//static_cast<void>(std::system("tree"));
			}
		}	
	}
	return 0;
}
