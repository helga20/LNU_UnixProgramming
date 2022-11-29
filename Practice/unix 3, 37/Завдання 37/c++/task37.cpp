#include <iostream>
#include <fstream>
#include <regex>
#include <iterator>
#include <vector>
#include <cstring>
#include <sstream>
#include <map>
#include <algorithm>
#include <filesystem>
#include <cstdio>
#include <cstdlib>

namespace fs = std::filesystem;
using namespace std;

bool sortbysec(const pair<string, int>& a, const pair<string, int>& b) 
{
    return (a.second > b.second);
}

void wordsCount(string output)
{
	int count = 1;
	std::map<string, int> wordsMap;
	istringstream wordStream(output);
	string word;
	while(wordStream >> word)
	{
		pair<map<string, int>::iterator, bool> retrunValue;
		retrunValue = wordsMap.insert( pair<string, int>(word,count));
		if (retrunValue.second==false)
		{
			++retrunValue.first->second; 
		}     
	}
	int words_n = 100;
	map<string, int>::iterator itr;
	vector<pair <string, int> > v(0);	        
	for (itr = wordsMap.begin(); itr != wordsMap.end(); ++itr)
	{
		v.push_back(pair<string, int>(itr->first, itr->second));
	}
	if (words_n < v.size(); words_n = v.size())
	{
		sort(v.begin(), v.end(), sortbysec);
	}
	for (int i = 0; i < words_n; ++i) 
	{
		cout << v[i].first << " : " << v[i].second << endl;
	}
}

int main(int argc, char **argv)
{
	if(std::string(argv[1]) == std::string("--help"))
	{
		std::cout << "Usage ./task37 Path" << std::endl;
		std::cout << "Select 100 most used words in HTML text" << std::endl; 
		std::cout << "-h, --help show info about program" << std::endl;
		std::cout << " -t, --test start program with same parameters" << std::endl;
	}	
	else if (std::string(argv[1]) == std::string("--test"))
	{
		system("./test37.bash");
	}
	else if (argc != 2)
	{	
		std::cout << "task37: missing file operands" << std::endl;
		std::cout << "Try './task37 --help' for more information" << std::endl;
	}
	else 
	{
		std::ifstream arg_is_file(argv[1]);
		std::string output;	
		std::regex tags("<[^<]*>");
	        if(arg_is_file) 
	        { 
	        	std::ifstream myfile(argv[1]);
	        	std::istream_iterator<char> begin(myfile>>std::noskipws), end;
			std::vector<char> html(begin, end);
			std::regex_replace(std::back_inserter(output), html.begin(), html.end(), tags, " ");
	        }      
		else
		{
			std::string website = argv[1];	
			std::string command = " wget " + website + " -o file.html";
 			system(command.c_str());
 			
 			std::ifstream myfile("index.html");
 			std::istream_iterator<char> begin(myfile>>std::noskipws), end;
			std::vector<char> html(begin, end);
			std::regex_replace(std::back_inserter(output), html.begin(), html.end(), tags, " ");					
		}
		std::for_each(output.begin(), output.end(), [](char & c) { c = ::tolower(c); });
		wordsCount(output);		
	}
	return 0;
}
