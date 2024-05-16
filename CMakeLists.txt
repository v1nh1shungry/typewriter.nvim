cmake_minimum_required(VERSION 3.16)
project(typewriter.nvim LANGUAGES CXX)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if (CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
    add_compile_options(-fcolor-diagnostics)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-fdiagnostics-color=always)
endif ()

include(cmake/CPM.cmake)

CPMAddPackage(
    GITHUB_REPOSITORY SFML/SFML
    GIT_TAG 2.6.1
    OPTIONS "SFML_BUILD_WINDOW OFF" "SFML_BUILD_GRAPHICS OFF" "SFML_BUILD_NETWORK OFF" "BUILD_SHARED_LIBS OFF"
)

add_library(typewriter SHARED src/typewriter.cpp)
target_link_libraries(typewriter PRIVATE sfml-audio)
target_include_directories(typewriter PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}src>)
target_compile_options(typewriter PRIVATE -Wall -Wextra)
