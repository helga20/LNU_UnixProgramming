#!/bin/bash

message()
{
    if [[ $silent != 1 ]]
    then
        echo $1
    fi
}


n=1
words_to_search=("patriots" "giants")

for arg in "$@"; do
  shift
  case "$arg" in
    '--help') 
        set -- "$@" '-h';;
    '--silent')
        set == "$@" 's';;
	'--number')
		set == "$@" 'n';;
    *) 
        set -- "$@" "$arg";;
  esac
done

while getopts hn:s flag 
do
    case $flag in
        h) 
            echo Usage: ./lab_2.sh [OPTIONS] ... [FILE]
            echo "print some number of words before and after 'patriots' and 'giants' from html file"
            echo
            {
                echo -e "-h, --help\t description of script"
                echo -e "-s, --silent\t without prints"
				echo -e "-n, --number\t set word number(default = 1)"
            } | column -s $'\t' -t
            exit;;
		n) 
			n=$OPTARG
			if ! [ -n $n ] || ! [ $n -eq $n ] || [ $n < 1 ]
			then
				echo "n should be positive number"
				exit
			fi;;
		s) 
			silent=1;;
        *)
            echo invalid arguments, Try '--help' for more information.
            exit;;
    esac
done
shift $(($OPTIND - 1))

file="$1"

if [ -z $file ] || ! [ -f $file ]
then
	echo invalid arguments, Try '--help' for more information.
	exit
fi

text_with_tags=`<$file`

text=(`echo $text_with_tags | sed -e 's/<[^>]*>/ /g' -e 's/[^a-zA-Z0-9 ]/ /g' -e 's/\(.*\)/\L\1/'`)


for ((i=0; i < ${#text[*]};i++))
do
	if [ ${text[$i]} == "patriots" ] || [ ${text[$i]} == "giants" ]
	then
		message
		message "find ${text[$i]} word at $i position; $n words before and after is"
		if [ $i -lt $n ]
		then
			echo "${text[*]:0:$i} || ${text[*]:$i + 1:$n}"
		else
			echo "${text[*]:${i} - ${n}:$n} || ${text[*]:$i + 1:$n}"
		fi
	fi
done
