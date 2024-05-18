cmake_minimum_required(VERSION 3.16)
project(typewriter.nvim LANGUAGES CXX)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)

if (CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    add_compile_options(-fcolor-diagnostics)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-fdiagnostics-color=always)
endif ()

find_package(SFML REQUIRED COMPONENTS audio)

add_library(typewriter SHARED src/typewriter.cpp)
target_link_libraries(typewriter PRIVATE sfml-audio)
target_compile_options(typewriter PRIVATE -Wall -Wextra)

install(TARGETS typewriter DESTINATION ${CMAKE_BINARY_DIR})
