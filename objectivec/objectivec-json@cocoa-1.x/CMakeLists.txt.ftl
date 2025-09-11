cmake_minimum_required(VERSION 3.10)

project(${app.name} C CXX)

set(CMAKE_C_FLAGS "${r"${"}CMAKE_C_FLAGS${r"}"} -Wno-shadow-ivar -Wno-nonnull ")

##
## include_directories
##
include_directories(
  "./include"
  "./Sources"
)

##
## link_directories
##
set(${app.name?upper_case}_SOURCES
<#list model.objects as obj>
  "Sources/POCO/${namespace!""}${objc.nameType(obj.name)}.m"
</#list>
<#list model.objects as obj>
  "Sources/JSON/${namespace!""}${objc.nameType(obj.name)}JSON.m"
</#list>
)

<#assign libname = app.name>
<#if libname?starts_with("lib")>
  <#assign libname = libname?substring(3)>
</#if>
add_library(${libname} STATIC ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
add_library(${libname}_shared SHARED ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
set_target_properties(${libname}_shared PROPERTIES OUTPUT_NAME ${libname})

target_link_libraries(${libname} PRIVATE
  "-framework foundation"
)

target_link_libraries(${libname}_shared PRIVATE
  "-framework foundation"
)