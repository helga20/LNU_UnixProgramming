#!/usr/bin/env bats

run_command="python lab_1.py"
temp=$(mktemp -d)
dir="${temp}/test"
diff="${temp}/test_diff"



create()
{
    touch $1
    sleep 0.1
}

setup()
{
	mkdir $dir
	mkdir $diff
}
teardown()
{
	rm -R $temp
}


@test "created" {
	create ${diff}/remain
	create ${dir}/remain

	create ${dir}/not_remain 
	create ${diff}/not_remain
	$run_command $dir
	[ -f "${dir}/remain" ] 
	! [ -f "${dir}/not_remain" ] 
}


@test "not exist" {
	create ${dir}/remain
	create ${diff}/other_file

	$run_command $dir

	[ -f "${dir}/remain" ]
}

@test "modified" {
	create ${dir}/remain
	create ${diff}/remain
	echo "test" >> ${dir}/remain

	create ${diff}/not_remain
	create ${dir}/not_remain
	echo "test" >> ${diff}/not_remain

	$run_command $dir

	[ -f "${dir}/remain" ] 
	! [ -f "${dir}/not_remain" ] 
	
}
