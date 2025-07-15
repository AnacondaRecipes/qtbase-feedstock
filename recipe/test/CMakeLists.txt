cmake_minimum_required (VERSION 3.10)

set (CMAKE_BUILD_TYPE "Release" CACHE STRING "build type")

project (qt-main-test CXX)

find_package (Qt6 CONFIG REQUIRED COMPONENTS Core Gui OpenGL)

add_executable (hello main.cpp)
target_link_libraries (hello Qt6::Core)

add_executable (test_qmimedatabase test_qmimedatabase.cpp)
target_link_libraries (test_qmimedatabase Qt6::Core)

enable_testing ()
add_test (NAME test_qmimedatabase COMMAND test_qmimedatabase)

add_executable(test_opengl test_opengl.cpp)
target_link_libraries(test_opengl Qt6::Gui Qt6::OpenGL)
if(NOT WIN32 AND NOT APPLE)
  add_test(NAME test_opengl COMMAND test_opengl)
endif()
