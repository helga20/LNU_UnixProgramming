#include <vector>
#include <iostream>
#include <cstring>
#include <regex>
#include <fstream>
#include <sstream>
#include <map>
#include <algorithm>
#include <filesystem>

//g++ -std=c++17 -o parsehtml.out parsehtml.cpp -lstdc++

using namespace std;
namespace fs = std::filesystem;

bool sortbysec(const pair<string, int>& a, const pair<string, int>& b) {
    return (a.second > b.second);
}

void WordsCount(string str, int words_n) {

    int count = 1;

    std::map<string, int> wordsMap;
    istringstream wordStream(str);
    string word;
    while (wordStream >> word) {
        pair<map<string, int>::iterator, bool> retrunValue;

        retrunValue = wordsMap.insert(pair<string, int>(word, count));

        if (retrunValue.second == false)
        {
            ++retrunValue.first->second;
        }
    }

    map<string, int>::iterator itr;
    vector<pair<string, int>> v(20);

    for (itr = wordsMap.begin(); itr != wordsMap.end(); ++itr) {
        v.push_back(pair<string, int>(itr->first, itr->second));
    }

    if (words_n > v.size()) words_n = v.size();
    sort(v.begin(), v.end(), sortbysec);

    for (int i = 0; i < words_n; ++i) {
        cout << v[i].second << "  " << v[i].first << endl;
    }
}

void Help() {
  cout << "Usage:   wfreq [OPTIONS] FILE LIST_LEN" << endl;
  cout << "Parse xml file and print list of LIST_LEN most frequent words" << endl << endl;
  cout << "Options:" << endl << "-h, --help\tshow help" << endl;


}


vector<string> Parser(string s) {
    int s_size = s.size();
    vector<string> result(20);
    for (int i = 0; i < s_size - 2; ++i) {
        if (s[i] == '<' && s[i + 1] == 'p' && s[i + 2] == ' ') {
            i += 2;
            while (s[i] != '>') {
                ++i;
            }
            ++i;
            string p_tag = "";

            while (s[i] != '<' || s[i + 1] != '/' || s[i + 2] != 'p') {
                p_tag.push_back(s[i]);
                ++i;
            }
            i += 2;
            result.push_back(p_tag);

        }
    }
    return result;
}



int main(int argc, char** argv) {

    for (int i = 0; i < argc; ++i) {
        if (!strcmp(argv[i], "-h")  || !strcmp(argv[i], "--help") ) {
            Help();
            return 0;
        }
    }

    fs::path p(argv[1]);
    stringstream buffer;
    if (fs::exists(p) || !(fs::is_directory(p))) {
        ifstream f(argv[1]);
        
        buffer << f.rdbuf();
    }
    else {
        cout << "File does not exists" << endl;
        return 1;
    }

    

    
    vector<string> v = Parser(buffer.str());
    string parsed_string = "";
    for (int i = 0; i < v.size(); ++i) {
        parsed_string += regex_replace(regex_replace(v[i], regex("<a(.*?)>"), ""), regex("</a>"), "");
    }

    int words_n = stoi(argv[2]);
     
    WordsCount(parsed_string, words_n);
}