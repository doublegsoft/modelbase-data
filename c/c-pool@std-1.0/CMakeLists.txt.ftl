cmake_minimum_required(VERSION 3.10)

project(${app.name} C CXX)

set(CMAKE_C_FLAGS "${r"${"}CMAKE_C_FLAGS${r"}"}")

##
## include_directories
##
include_directories(
  "./include"
)

set(${app.name?upper_case}_SOURCES
  src/${app.name}-pool.c
)

<#assign libname = app.name>
<#if libname?starts_with("lib")>
  <#assign libname = libname?substring(3)>
</#if>
add_library(${libname} STATIC ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
add_library(${libname}_shared SHARED ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
set_target_properties(${libname}_shared PROPERTIES OUTPUT_NAME ${libname})

target_link_libraries(${libname} PRIVATE
  pthread
)

target_link_libraries(${libname}_shared PRIVATE
  pthread
)

add_executable(${app.name}-pool-test 
  "test/${app.name}-pool-test.c"
)

target_link_libraries(${app.name}-pool-test PRIVATE
  ${libname}
)