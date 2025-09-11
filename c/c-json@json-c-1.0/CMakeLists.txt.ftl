cmake_minimum_required(VERSION 3.10)

project(${app.name} C CXX)

set(CMAKE_C_FLAGS "${r"${"}CMAKE_C_FLAGS${r"}"}")

set(JSON_C        "json-c-0.17")

include_directories(

)

##
## dependent third-party libraries
##
add_subdirectory("3rd/${r"${JSON_C}"}")

##
## include_directories
##
include_directories(
  "./include"
  "3rd/${r"${JSON_C}"}"
  "${r"${CMAKE_BINARY_DIR}"}/3rd/${r"${JSON_C}"}"
)

##
## compiling sources
##
set(${app.name?upper_case}_SOURCES
  src/${app.name}-json.c
  src/${app.name}-poco.c
  src/${app.name}-sql.c
)

<#assign libname = app.name>
<#if libname?starts_with("lib")>
  <#assign libname = libname?substring(3)>
</#if>
add_library(${libname} STATIC ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
add_library(${libname}_shared SHARED ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
set_target_properties(${libname}_shared PROPERTIES OUTPUT_NAME ${libname})

target_link_libraries(${libname} PRIVATE
  json-c
)

target_link_libraries(${libname}_shared PRIVATE
  json-c
)