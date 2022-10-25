#!/usr/bin/python3
import pathlib
import sys
import os
import shutil

if (sys.argv[1] == "--help"):
	print("Usage: task2.py DIR DIR_TO .EXT")
	print("Copy all files that have EXT extention from DIR to DIR_TO")

elif (sys.argv[1] == "--test"):
	os.system("./test2.bash")

elif (len(sys.argv) == 4):
        dir_from = sys.argv[1]
        dir_to = sys.argv[2]
        ext = sys.argv[3]
        for path, subdirs, files in os.walk(dir_from):
                for file in files:
                        if pathlib.Path(file).suffix == ext:
                                shutil.copy(os.path.join(path, file), os.path.join(dir_to, file))



