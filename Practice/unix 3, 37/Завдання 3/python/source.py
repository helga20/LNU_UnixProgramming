#!/usr/bin/python3
import glob
import shutil
import pathlib
import sys
import os

if(sys.argv[1] == "--help"):
	print("Usage: source.py  DIR DIR_TO SIZE N")
	print("Copy first N files exceeding SIZE from DIR to DIR_TO")
	print("-h, --help show info about program")
	print("-t, --test start program with same parameters")
elif(sys.argv[1] == "--test"):
	os.system("./test.bash")
elif(len(sys.argv) != 5):
	print("Usage: source.py --help for more information")
elif(len(sys.argv) == 5):
	dir_from = sys.argv[1]
	dir_to = sys.argv[2]
	size_MAX = int(sys.argv[3])
	counter_MAX = int(sys.argv[4])
	current_size = 0
	counter = 0
	list_of_files = os.listdir(dir_from)
	list_of_files.sort(key=lambda f: os.stat(os.path.join(dir_from, f)).st_size)
	print(list_of_files)
	for path, subdirs, files in os.walk(dir_from):
		for item in list_of_files:
			for file in files:
				if file == item:
					if current_size < size_MAX and counter < int(counter_MAX):
						current_size = current_size + int(os.stat(os.path.join(dir_from, file)).st_size)
						shutil.move(os.path.join(dir_from, item), dir_to)
						counter = counter + 1

