#include <ctime>
#include <iostream>
#include <string>
#include <unordered_set>
#include <unordered_map>
#include <filesystem>
#include <chrono>

#define elif else if

using std::cout, std::string, std::unordered_set, std::unordered_map;
using std::chrono::milliseconds;
using std::filesystem::directory_iterator, std::filesystem::is_directory,
	  std::filesystem::last_write_time, std::filesystem::exists, std::filesystem::remove,
	  std::filesystem::path;

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

template <typename TP>
string to_string(TP tp)
{
    using namespace std::chrono;
    auto sctp = time_point_cast<system_clock::duration>(tp - TP::clock::now() + system_clock::now());
    auto time = system_clock::to_time_t(sctp);
	return ctime(&time);
}


int main(int argc, const char* argv[])
{
	string help = R"(
Usage: ./lab_1.sh [OPTIONS] ... DIR

Remove all files from DIR directory, that are modified later
than files from diff_dir(from -d flag, default=DIR with _diff suffix) directory with the same names


-h, --help	 	description of script
-s, --silent		without prints
-d, --diff_dir		change diff_dir folder
)";
	unordered_map<string, string> cast_flags = {
		{"--help", "-h"},
		{"--silent", "-s"},
		{"--diff_dir", "-d"}
	};

	string diff_dir, dir;
	unordered_set<string> used_flags;

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

			elif(flag == "-d")
			{
				i += 1;
				if(i == argc || argv[i][0] == '-')
					error << flag << ": missing operand";
				diff_dir = argv[i];
			}
			else
				error << flag << ": invalid flag";

			used_flags.insert(flag);
		}
		else
		{
			if(dir != "")
				error << "invalid arguments number";

			dir = flag;
			if(!is_directory(dir))
				error << "There is no \"" << dir << "\" directory";
		}

	}

	if(dir == "")
		error << "invalid arguments number";

	if(diff_dir == "")
		diff_dir = dir + "_diff";
	if(! is_directory(diff_dir))
		error << "There is no \"" << diff_dir << "\" directory";

	for(auto& file: directory_iterator(dir))
	{
		string filename = file.path().filename();
		string diff_file = path(diff_dir) / filename;
		

		auto modified_at = last_write_time(file.path());
		info << "Filename: " + filename + ", date:" + to_string(modified_at) +  '\n';
		if(exists(diff_file) && last_write_time(diff_file) > modified_at)
		{
			info << '\n' << filename << " removed, because his date is " << to_string(modified_at)
				 << ", and in " << diff_dir << " folder date is "<< to_string(last_write_time(diff_file));

			remove(file);
		}

	}


}
