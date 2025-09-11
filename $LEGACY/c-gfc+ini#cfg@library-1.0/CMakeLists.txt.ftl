
cmake_minimum_required(VERSION 3.16)
project(${app.name} C)

set(CMAKE_C_STANDARD 11)

include_directories(src)

add_executable(${app.name}-ini-test
  src/ini.c
  test/${app.name}-ini-test.c
)