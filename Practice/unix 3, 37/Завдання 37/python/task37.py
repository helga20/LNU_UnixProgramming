#!/usr/bin/python3
import requests
import sys
import os
import re
from bs4 import BeautifulSoup
from collections import Counter

def deleteTags(html):
    soup = BeautifulSoup(html, "html.parser") 
    for data in soup(['style', 'script']):
         data.decompose() 
    return ' '.join(soup.stripped_strings)

if (sys.argv[1] == "--help"):
	print("Usage: task37.py Path")
	print("Select 100 most used words in HTML text  that you specify by path or URL")
	print("-h, --help show info about program")
	print("-t, --test start program with same parameters")

elif (sys.argv[1] == "--test"):
	os.system("./test37.bash")

elif (len(sys.argv) == 2):
	arg = sys.argv[1]
	if(os.path.isfile(arg)):
		text_from_file = open(sys.argv[1], "r").read()
		open('temporfile.txt', 'w').write(deleteTags(text_from_file))
	else:		
		page = requests.get(arg)
		open ('temporfile.txt', 'w').write(deleteTags(page.content))
	words = re.findall(r'\w+', open('temporfile.txt').read().lower())
	count = Counter(words).most_common(100)
	print(count)




