cmake_minimum_required(VERSION 3.13)

project(${app.name} CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "${r"${"}CMAKE_CXX_FLAGS${r"}"} -std=c++17 ")

##
## include_directories
##
include_directories(
  "./include"
)

set(${app.name?upper_case}_SOURCES
<#list model.objects as obj>
  <#if obj.isLabelled("generated")><#continue></#if>
  <#if obj.isLabelled("widget")>
  "src/gux/${cpp.nameFile(obj.name)}Options.cpp"
  <#elseif obj.isLabelled("field")>
  "src/gux/${cpp.nameFile(obj.name)}.cpp"
  </#if>
</#list>  
)

<#assign libname = app.name>
<#if libname?starts_with("lib")>
  <#assign libname = libname?substring(3)>
</#if>
add_library(${libname} STATIC ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
add_library(${libname}_shared SHARED ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
set_target_properties(${libname}_shared PROPERTIES OUTPUT_NAME ${libname})