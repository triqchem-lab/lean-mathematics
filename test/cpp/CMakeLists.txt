cmake_minimum_required(VERSION 3.16)
project(user_tests CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 依赖 math 子模块的头文件 (只读依赖, 用户不改 math 本体)
add_library(sov_math INTERFACE)
target_include_directories(sov_math INTERFACE ../../math/cpp/include)

enable_testing()

# 用户自由添加 *.cpp 测试用例, 自动收集为 ctest
file(GLOB TEST_SOURCES CONFIGURE_DEPENDS *.cpp)
foreach(src ${TEST_SOURCES})
  get_filename_component(name ${src} NAME_WE)
  add_executable(${name} ${src})
  target_link_libraries(${name} PRIVATE sov_math)
  add_test(NAME ${name} COMMAND ${name})
endforeach()
