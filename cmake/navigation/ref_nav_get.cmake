## `(<current value:<any>> ["&"]<navigation expression>)-><any>`
## navigates the specified value and returns the value the navigation expression 
## points to.  If the value does not exist nothing is returned
## 
## if the expression is prepended by an ampersand `&` the current lvalue is returned.
## 
## **Examples**<%
##  set(data_input "{a:{b:{c:3},d:[{e:4},{e:5}]}}")
##  script("${data_input}")
##  ans(data)
##  function(ref_nav_get_example )
##    set(expr ${ARGN})
##    ref_nav_get("${data}" ${expr})
##    ans(res)
##    json("${res}")
##    ans(res)
##    return("`ref_nav_get(\\\${data} ${expr}) => ${res}`")
##  endfunction()
##  set(asdas 123)
## %>
## let `${data}` be `@json(${data_input})`
## then 
## * @ref_nav_get_example(a)
## * @ref_nav_get_example(a.b.c)
## * @ref_nav_get_example(a.b.c.d)
## * @ref_nav_get_example(a.d[1].e) 
## * @ref_nav_get_example(a.d[0].e)
## * @ref_nav_get_example(a.d)
## * @ref_nav_get_example()
## * @ref_nav_get_example(&a.b.c)

function(ref_nav_get current_value)
  set(expression ${ARGN})
  if("${expression}" MATCHES "^&(.*)")
    set(return_lvalue true )
    set(expression "${CMAKE_MATCH_1}")
  else()
    set(return_lvalue false)
  endif()

  navigation_expression_parse("${expression}")
  ans(expression)

  set(current_ref)
  set(current_property)
  set(current_ranges)
  foreach(current_expression ${expression})
    if("${current_expression}" MATCHES "^[<>].*[<>]$")
      list_range_try_get(current_value "${current_expression}")
      ans(current_value)
      list(APPEND current_ranges ${current_expression})
    else()
      is_address("${current_value}")
      #map_isvalid("${current_value}")
      ans(is_ref)
      if(NOT is_ref)
        set(current_value)
        break()
      endif()
      set(current_ref "${current_value}")
      set(current_property "${current_expression}")
      set(current_ranges)

      ref_prop_get("${current_value}" "${current_expression}")
      ans(current_value)
    endif()
  endforeach()
  if(return_lvalue)
    map_capture_new(ref:current_ref property:current_property range:current_ranges value:current_value --reassign)
    return_ans()
  endif()
  return_ref(current_value)

endfunction()

## nev version supports property of range expressions
function(ref_nav_get current_value)
  set(expression ${ARGN})
  if("${expression}" MATCHES "^&(.*)")
    message(FATAL_ERROR "address '${expression}' operation is unsupported")
  elseif("${expression}" MATCHES "^%(.*)")
    set(return_lvalue true )
    set(expression "${CMAKE_MATCH_1}")
  else()
    set(return_lvalue false)
  endif()

  navigation_expression_parse("${expression}")
  ans(expression)

  set(current_ref)
  set(current_property)
  set(current_ranges)
  set(evaluated_expression)
  foreach(current_expression ${expression})
    if("${current_expression}" MATCHES "^[<>].*[<>]$")
      list_range_try_get(current_value "${current_expression}")
      ans(current_value)
      list(APPEND current_ranges ${current_expression})
    else()
      set(current_ref)
      set(current_result_value)
      foreach(current_value_i ${current_value})
        is_address("${current_value_i}")
        ans(is_ref)
        if(is_ref)
          list(APPEND current_ref "${current_value_i}")
          #set(current_ref "${current_value}")
          set(current_property "${current_expression}")
          set(current_ranges)
          ref_prop_get("${current_value_i}" "${current_expression}")
          list(APPEND current_result_value ${__ans})
        endif()
      endforeach()
      set(current_value "${current_result_value}")

      if("${current_value}_" STREQUAL "_")
        break()
      endif()
    endif()
  endforeach()
  if(return_lvalue)


    map_capture_new(ref:current_ref property:current_property range:current_ranges value:current_value --reassign)
    return_ans()    
  endif()


  return_ref(current_value)

endfunction()
