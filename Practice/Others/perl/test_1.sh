#!/usr/bin/env bats

run_command="perl lab_1.pl"
temp=$(mktemp -d)
dir="${temp}/test"
diff="${temp}/test_diff"

setup()
{
	mkdir $dir
	mkdir $diff
}

teardown()
{
	rm -R $temp
}


@test "create" {
	touch ${diff}/remain -d '1990-1-1'
	touch ${dir}/remain -d '1990-1-2'

	touch ${dir}/not_remain -d '1990-1-1'
	touch ${diff}/not_remain -d '1990-1-2'
	$run_command $dir
	[ -f "${dir}/remain" ]
	! [ -f "${dir}/not_remain" ]
}


@test "not exist" {
	touch ${dir}/remain -d '1990-1-2'
	touch ${diff}/other_file -d '1990-1-1'

	$run_command $dir

	[ -f "${dir}/remain" ]
}

@test "modified" {
	touch ${dir}/remain -d '1990-1-1'
	touch ${diff}/remain -d '1990-1-2'
	echo "test" >> ${dir}/remain

	touch ${diff}/not_remain -d '1990-1-1'
	touch ${dir}/not_remain -d '1990-1-2'
	echo "test" >> ${diff}/not_remain

	$run_command $dir

	[ -f "${dir}/remain" ]
	! [ -f "${dir}/not_remain" ]
}
