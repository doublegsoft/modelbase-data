cmake_minimum_required(VERSION 3.10)

project(teaman C CXX)

set(CMAKE_C_FLAGS "${r"${"}CMAKE_C_FLAGS${r"}"}")

set(MYSQL_INCLUDE_DIR       "/usr/local/mysql-8.0.19-macos10.15-x86_64/include")
set(MYSQL_LIBRARY_DIR       "/usr/local/mysql-8.0.19-macos10.15-x86_64/lib")

##
## include_directories
##
include_directories(
  "./include"
  "${r"${MYSQL_INCLUDE_DIR}"}"
)

link_directories(
  "${r"${MYSQL_LIBRARY_DIR}"}"
)

##
## compiling sources
##
set(${app.name?upper_case}_SOURCES
  src/${app.name}-util.c
  src/${app.name}-poco.c
  src/${app.name}-sql.c
  src/${app.name}-mysql.c
)

<#assign libname = app.name>
<#if libname?starts_with("lib")>
  <#assign libname = libname?substring(3)>
</#if>
add_library(${libname} STATIC ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
add_library(${libname}_shared SHARED ${r"${"}${app.name?upper_case}_SOURCES${r"}"})
set_target_properties(${libname}_shared PROPERTIES OUTPUT_NAME ${libname})

target_link_libraries(${libname} PRIVATE
  mysqlclient
)

target_link_libraries(${libname}_shared PRIVATE
  mysqlclient
)

add_executable(${app.name}-mysql-test 
  "test/${app.name}-mysql-test.c"
)

target_link_libraries(${app.name}-mysql-test PRIVATE
  ${libname}
)