from argparse import ArgumentParser, ArgumentTypeError
from pathlib import Path
from re import sub

parser = ArgumentParser()

def html_path(path, raise_exception=True):
    if not Path(path).is_file() or Path(path).suffix != ".html":
        error = f"No such directory: '{path}'"
        if raise_exception:
            raise ArgumentTypeError(error)
        print(error)
        exit(0)
    return path

parser.add_argument("-v", action='store_true',
                    help="explain what is being done")
parser.add_argument("-n", metavar="NUMBER", dest="number", type=int, default=1,
                    help="set NUMBER of words")

parser.add_argument("file", type=html_path, metavar="DIR", help="")

parser.description = """
retrieves NUMBER(default=1) words that appear either before or after words: "giants", "patriots"
"""
args = parser.parse_args()

def info(message):
    if args.v:
        print(message)

text = ""
with open(args.file) as file:
    text = file.read()

regexes = [("<[^>]*>", " "), ("[^a-zA-Z0-9 ]", " ")]
for old, new in regexes:
    text = sub(old, new, text)

words = text.lower().split()

info(f"File contains {len(words)} no tag words\n")

for i, word in enumerate(words):
    if word in ("patriots", "giants"):
        info(f"\nFind word {word} at {i} position; {args.number} words before and after is")
        result = []
        for j in range(max(0, i - args.number), min(len(words), i + args.number + 1)):
            if j == i:
                result.append("||")
            else:
                result.append(words[j])
        print(" ".join(result))

