cmake_minimum_required(VERSION 3.10)

project(${app.name} C CXX)

set(CMAKE_C_FLAGS "${r"${"}CMAKE_C_FLAGS${r"}"}")

set(CURL    "curl-8.6.0")

add_subdirectory("3rd/${r"${"}CURL${r"}"}")

##
## include_directories
##
include_directories(
  "./include"
  "3rd/${r"${"}CURL${r"}"}/include"
  "${r"${"}CMAKE_BINARY_DIR${r"}"}/3rd/${r"${"}CURL${r"}"}/lib"
)

##
## link_directories
##

set(${app.name?upper_case}_SOURCES
  "src/${app.name}-wechat.c"
)

<#assign libname = app.name>
<#if libname?starts_with("lib")>
  <#assign libname = libname?substring(3)>
</#if>
add_library(${libname} STATIC ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
add_library(${libname}_shared SHARED ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
set_target_properties(${libname}_shared PROPERTIES OUTPUT_NAME ${libname})

add_dependencies(${libname} curl)

target_link_libraries(${libname} PRIVATE
  "${r"${"}CMAKE_BINARY_DIR${r"}"}/3rd/${r"${"}CURL${r"}"}/lib/libcurl.dylib"
)

target_link_libraries(${libname}_shared PRIVATE
  "${r"${"}CMAKE_BINARY_DIR${r"}"}/3rd/${r"${"}CURL${r"}"}/lib/libcurl.dylib"
)