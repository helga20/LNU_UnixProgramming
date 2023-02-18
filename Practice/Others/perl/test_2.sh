#!/usr/bin/env bats

run_command="perl lab_2.pl"

setup()
{
    temp=$(mktemp -d)
	file="${temp}/test.html"
	touch $file
}
teardown()
{
    rm -R $temp
}


@test "return previos and next" {
    echo "<HTML>prev1 giants next1 prev2 patriots next2 </HTML>" >> $file


	result=(`$run_command $file`)
	expected=("prev1 || next1" "prev2 || next2")
	echo ${result[*]}

	[[ ${result[*]} == ${expected[*]} ]]

}
@test "custom number" {
    echo "<HTML>p4 p3 p2 p1 giants n1 n2 n3 n4 ||| p4 p3 p2 p1 patriots n1 n2 n3 n4 </HTML>" >> $file

	result=(`$run_command -n 3 $file`)
	expected=("p3 p2 p1 || n1 n2 n3" "p3 p2 p1 || n1 n2 n3")

	echo ${result[*]}
	[[ ${result[*]} == ${expected[*]} ]]
}

@test "ignore tags" {
    echo "<HTML>prev1 <prev1 giants next1> next1 prev2 patriots next2 </HTML>" >> $file

	result=(`$run_command $file`)
	expected=("prev2 || next2")

	echo ${result[*]}
	[[ ${result[*]} == ${expected[*]} ]]

}

@test "with obstacles" {
    echo "<HTML>prev1,   giAnts; </br> </br> </br> next1. prev2 'PaTrIOTS,next2 </HTML>" >> $file

	result=(`$run_command $file`)
	expected=("prev1 || next1" "prev2 || next2")

	echo ${result[*]}
	[[ ${result[*]} == ${expected[*]} ]]

}
