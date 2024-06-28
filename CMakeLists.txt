cmake_minimum_required(VERSION 3.20)
project(naivecgl-nvs LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_EXTENSIONS OFF)
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/null.cpp "")
include(cmake/FetchNaiveCGL.cmake)
add_library(null SHARED ${CMAKE_CURRENT_BINARY_DIR}/null.cpp)
add_dependencies(null NaiveCGL)
add_custom_command(
  TARGET null POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory
      "$<TARGET_PROPERTY:NaiveCGL,BINARY_DIR>/$<CONFIG>/"
      "$<TARGET_PROPERTY:null,SOURCE_DIR>/lib/"
  )