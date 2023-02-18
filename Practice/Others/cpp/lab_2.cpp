#include <cctype>
#include <iostream>
#include <string>
#include <unordered_set>
#include <unordered_map>
#include <regex>
#include <fstream>
#include <vector>
#include <utility>

#define elif else if

using std::cout, std::string, std::unordered_set, std::unordered_map, std::stoi,
	  std::regex_match, std::regex_replace, std::regex, std::ifstream, std::pair, std::vector;
bool silent;

class Error
{
public:
	template<typename T>
	Error& operator<<(const T& message)
	{
		cout << message;
		return *this;
	}
	~Error()
	{
		cout << "\nTry --help for more inforamation\n";
		exit(1);
	}
};
#define error Error()
class Info
{
public:
	template<typename T>
	Info& operator<<(const T& message)
	{
		if(!silent)
			cout << message;
		return *this;
	}
};
#define info Info()


int main(int argc, const char* argv[])
{
	string help = R"(
Usage: ./lab_2.sh [OPTIONS] ... FILE

Print some number(from -n flag, default=1) of words
before and after "patriots" and "giants" from FILE

-h, --help		display this help and exit
-s, --silent	display without explaining what is being done
-n, --number	set words number(default = 1)
)";
	unordered_set<string> used_flags;
	unordered_map<string, string> cast_flags = {
		{"--help", "-h"},
		{"--silent", "-s"},
		{"--number", "-n"}
	};

	string filename;
	int words_num = 1;

	for(int i = 1; i < argc; i++)
	{
		string flag = argv[i];
		if(cast_flags.count(flag))
			flag = cast_flags[flag];


		if(flag[0] == '-')
		{
			if(used_flags.count(flag))
				error << flag << ": flag duplicate";

			elif(flag == "-h")
			{
				cout << help << '\n';
				return 0;
			}

			elif(flag == "-s")
				silent = true;

			elif(flag == "-n")
			{
				i += 1;
				if(i == argc || argv[i][0] == '-')
					error << flag << ": missing operand";
				if(!regex_match(argv[i], regex("^[0-9]+$")))
					error << argv[i] << " is not a positive number";
				words_num = stoi(argv[i]);
			}
			else
				error << flag << ": invalid flag";

			used_flags.insert(flag);
		}
		else
		{
			if(filename != "")
				error << "invalid arguments number";
			filename = flag;
		}
	}

	ifstream file(filename);
	if(!file.good())
		error << filename << " don't exist";
	string text((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
	pair<string, string> regexes[] = {{"<[^>]*>", " "}, {"[^a-zA-Z0-9 ]", " "}};
	for(auto cur_regex: regexes)
		text = regex_replace(text, regex(cur_regex.first), cur_regex.second);

	vector<string> words;
	string current_word;
	for(char c: text)
	{
		if(c == ' ')
		{
			if(current_word != "")
				words.push_back(current_word);
			current_word = "";
		}
		else
			current_word += tolower(c);
	}
	if(current_word != "")
		words.push_back(current_word);
	info << "File contains " << words.size() << " no tag words\n";
	for(int i = 0; i < words.size(); i++)
	{
		if(words[i] == "patriots" || words[i] == "giants")
		{
			info << "\nfind word " << words[i] << " at " << i << " position; "
				 << words_num << " before and after is:\n";
			for(int j = std::max(0, i - words_num); j < std::min((int)words.size(), i + words_num + 1); j++)
				if(j == i)
					cout << "|| ";
				else
					cout << words[j] << ' ';
			cout << '\n';
		}

	}
}
