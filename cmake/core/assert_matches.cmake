## fails if ARGN does not match expected value
## see map_match
function(assert_matches expected)
  assign(expected = ${expected})
  assign(actual = ${ARGN})
  map_match("${actual}" "${expected}")
  ans(result)
  if(NOT result)
    echo_append("expected: ")
    json_print(${expected})
    echo_append("actual:")
    json_print(${actual})
    _message(FATAL_ERROR "values did not match")
  endif()
endfunction()