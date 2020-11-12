cmake_minimum_required(VERSION 3.9)

if (NOT TON_SDK_VERSION)
    message(FATAL_ERROR "TON_SDK_VERSION property is required")
endif ()

set(TON_SDK_SRC "${CMAKE_CURRENT_SOURCE_DIR}/vendor/build/ton-sdk-${TON_SDK_VERSION}/src/ton-sdk")

if (TON_SDK_TARGET)
    set(TON_SDK_RELEASE_DIR "${TON_SDK_SRC}/target/${TON_SDK_TARGET}/release")
else ()
    set(TON_SDK_RELEASE_DIR "${TON_SDK_SRC}/target/release")
endif ()

set(TON_SDK_CLIENT_DIR "${TON_SDK_SRC}/ton_client/client")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules)
list(APPEND CMAKE_PREFIX_PATH "${TON_SDK_CLIENT_DIR}" "${TON_SDK_RELEASE_DIR}")

project(tonclient_dotnet_bridge VERSION ${TON_SDK_VERSION})

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

