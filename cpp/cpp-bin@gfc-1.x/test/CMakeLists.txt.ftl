set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

add_executable(${app.name}_test test.cpp)

target_link_libraries(${app.name}_test gtest gtest_main pthread)

enable_testing()

add_test(NAME ${app.name}_test COMMAND ${app.name}_test)