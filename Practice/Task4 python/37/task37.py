#!/usr/bin/python3
import requests
import sys
import os
import re
from bs4 import BeautifulSoup
from collections import Counter

def remove_tags(html):
    soup = BeautifulSoup(html, "html.parser") 
    for data in soup(['style', 'script']):
         data.decompose() 
    return ' '.join(soup.stripped_strings)

if (len(sys.argv) != 2):
	print("task37.py: missing file operands")
	print("Try './task37.py --help' for more information")

elif (sys.argv[1] == "--help"):
	print("Usage: task37.py URL or *.html")
	print("Select the 100 most used words in HTML text")

elif (sys.argv[1] == "--test"):
	os.system("./test37.bash")

elif (len(sys.argv) == 2):
	if(os.path.isfile(sys.argv[1])):
		text = open(sys.argv[1], "r", encoding='utf-8').read()
		with open('output.txt', 'w') as f:
			f.write(remove_tags(text))
	else:		
		#url = 'https://www.gnu.org/software/libc/manual/html_node/Opening-and-Closing-Files.html'
		page = requests.get(sys.argv[1])
		with open ('output.txt', 'w') as file:
			file.write(remove_tags(page.content))
	words = re.findall(r'\w+', open('output.txt').read().lower())
	count = Counter(words).most_common(100)
	print(count)




