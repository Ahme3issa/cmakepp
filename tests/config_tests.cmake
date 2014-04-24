function(test)


	obj_new(config Configuration)

	obj_callmember(${config} AddConfigurationFile global "${test_dir}/conf1.json")
	obj_callmember(${config} AddConfigurationFile user "${test_dir}/conf2.json")
	obj_callmember(${config} AddConfigurationFile local "${test_dir}/conf3.json")

	obj_callmember(${config} Set "val1.val2" "1" SCOPE global)
	obj_callmember(${config} Set "val1.val2" "2" SCOPE user)
	obj_callmember(${config} Set "val1.val2" "3" SCOPE local)

	obj_callmember(${config} Set "val1.val3" "3" SCOPE global)
	obj_callmember(${config} Set "val1.val4" "3" SCOPE user)
	obj_callmember(${config} Set "val1.val5" "3" SCOPE local)
	
	obj_callmember(${config} Get  "val1.val2")
	ans(res1)
	obj_callmember(${config} Get  "val1.val3")
	ans(res2)
	obj_callmember(${config} Get  "val1.val4")
	ans(res3)
	obj_callmember(${config} Get  "val1.val5")
	ans(res4)
	set(res5 asd)
	obj_callmember(${config} Get  "nonexisting.value")
	ans(res5)
	obj_callmember(${config} Get  "val1.val2" SCOPE global)
	ans(res6)
	obj_callmember(${config} Get  "val1.val2" SCOPE user)
	ans(res7)
	obj_callmember(${config} Get "val1.val2" SCOPE local)
	ans(res8)

	assert(${res1} STREQUAL 3)
	assert(${res2} STREQUAL 3)
	assert(${res3} STREQUAL 3)
	assert(${res4} STREQUAL 3)
	assert(NOT res5)
	assert(${res6} STREQUAL 1)
	assert(${res7} STREQUAL 2)
	assert(${res8} STREQUAL 3)


endfunction()