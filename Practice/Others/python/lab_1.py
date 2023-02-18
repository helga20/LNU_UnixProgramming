from argparse import ArgumentParser, ArgumentTypeError
from pathlib import Path
from datetime import datetime

parser = ArgumentParser()

def dir_path(path, raise_exception=True):
    if not Path(path).is_dir():
        error = f"No such directory: '{path}'"
        if raise_exception:
            raise ArgumentTypeError(error)
        print(error)
        exit(0)
    return path

parser.add_argument("-v", action='store_true',
                    help="explain what is being done")
parser.add_argument("-d", metavar="DIFF_DIR", dest="diff_dir", type=dir_path,
                    help="set DIR_DIFF directory")

parser.add_argument("dir", type=dir_path, metavar="DIR")

parser.description = """
In the DIR directory, leave files that are "fresher" at the time of modification than files with the same name in the given directory DIR_DIFF, or are not found in DIR_DIFF
"""
args = parser.parse_args()

def info(message):
    if args.v:
        print(message)

def date(file):
    return datetime.fromtimestamp(file.stat().st_mtime);

if not args.diff_dir:
    args.diff_dir = dir_path(args.dir + "_diff", False)

dir = Path(args.dir)
diff_dir = Path(args.diff_dir)

for file in dir.glob('*'):
    if not file.is_file():
        continue
    filename = file.name
    diff_file = diff_dir / filename

    if diff_file.exists() and diff_file.stat().st_mtime > file.stat().st_mtime:
        info(f"\n{filename} removed, because his modification date is {date(file)}, and in DIFF_DIR modification date - {date(diff_file)}")

        file.unlink()

