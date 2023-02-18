# !/bin/bash

get_date()
{
	echo "`date -r ${1} "+%Y-%m-%d %H:%M:%S.%N"`"
}
message()
{
	if [[ $silent != 1 ]]
	then
		echo $1
	fi
}

for arg in "$@"; do
  shift
  case "$arg" in
    '--help')
		set -- "$@" '-h';;
    '--diff_dir')
		set -- "$@" '-d';;
	'--silent')
		set == "$@" 's';;
    *)
		set -- "$@" "$arg";;
  esac
done


while getopts hd:s flag 
do
    case $flag in
		h)
			echo Usage: ./lab_1.sh [OPTIONS] ... [DIR]
			echo "remove all files from <DIR> directory, that are modified later",
			echo "than files from <DIR_DIFF>(default=\"<DIR>_diff\") directory with the same names"
			echo
			{
				echo -e "-h, --help\t description of script"
				echo -e "-s, --silent\t without prints"
				echo -e "-d, --diff_dir\t change DIFF_DIR folder"
			} | column -s $'\t' -t
			exit;;
		d) diff_dir=$OPTARG;;
		s) silent=1;;
		*)
			echo invalid arguments, Try '--help' for more information.
			exit;;
	esac
done
shift $(($OPTIND - 1))

dir=$1


if [ -z $dir ]
then
	echo invalid arguments, Try '--help' for more information.
	exit
fi

if [ -z $diff_dir ]
then
	diff_dir="${dir}_diff"
fi

if ! [ -d $diff_dir ]
then
	echo "diff directory doesn't exist"
	exit
fi

if [ `ls $dir | wc -l` -gt 0 ]
then
	for file in ${dir}/*
	do
		filename=`basename -- $file`
		diff_file="${diff_dir}/${filename}"

		message "filename: ${filename}, date: `get_date $file`"

		if [ -f $diff_file ] && [[ "`get_date $file`" < "`get_date $diff_file`" ]]
		then
			message
			message "$filename removed, because his date is `get_date $file` and $diff_file date is `get_date $diff_file`"
			rm -R $file
		fi

	done
fi
