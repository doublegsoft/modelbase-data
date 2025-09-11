
cmake_minimum_required(VERSION 3.16)
project(${app.name} C)

set(CMAKE_C_STANDARD 11)

include_directories(src)

add_executable(${app.name}-proto-test
  src/${app.name}-proto.c
  test/${app.name}-proto-test.c
)