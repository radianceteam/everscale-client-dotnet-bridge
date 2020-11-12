cmake_minimum_required(VERSION 3.9)

if (NOT TON_SDK_VERSION)
    message(FATAL_ERROR "TON_SDK_VERSION property is required")
endif ()

project(tonclient_dotnet_bridge VERSION ${TON_SDK_VERSION})

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules)
list(APPEND CMAKE_PREFIX_PATH "${INSTALL_PREFIX}")

include_directories(include)
enable_testing()

add_subdirectory(include)
add_subdirectory(src)

if (NOT TON_SKIP_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif ()

if (TON_FIND_LEAKS)
    include(CTest)
    find_program(MEMORYCHECK_COMMAND valgrind)
    set(MEMORYCHECK_COMMAND_OPTIONS "--trace-children=yes --leak-check=full")
    set(MEMORYCHECK_SUPPRESSIONS_FILE "${PROJECT_SOURCE_DIR}/valgrind_suppress.txt")
endif ()

