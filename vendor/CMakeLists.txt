cmake_minimum_required(VERSION 3.9)

project(ton-client-dotnet-bridge-third-party-libs)

include(ExternalProject)

if (NOT TON_SDK_BRANCH)
    set(TON_SDK_BRANCH ${TON_SDK_VERSION})
endif ()

set(TON_SDK_PATH ${CMAKE_BINARY_DIR}/ton-sdk-${TON_SDK_VERSION})

if (TON_SDK_TARGET)
    set(TON_SDK_BUILD_COMMAND cargo +stable-${TON_SDK_TARGET} build --target=${TON_SDK_TARGET} --release)
else ()
    set(TON_SDK_BUILD_COMMAND cargo build --release)
endif ()

ExternalProject_Add(
        ton-sdk
        GIT_REPOSITORY https://github.com/tonlabs/TON-SDK.git
        GIT_TAG ${TON_SDK_BRANCH}
        PREFIX ${TON_SDK_PATH}
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ${TON_SDK_BUILD_COMMAND}
        INSTALL_COMMAND ""
        BUILD_IN_SOURCE 1
        LOG_BUILD ON)

set(TON_SDK_SRC "${TON_SDK_PATH}/src/ton-sdk")

if (TON_SDK_TARGET)
    set(TON_SDK_RELEASE_DIR "${TON_SDK_SRC}/target/${TON_SDK_TARGET}/release")
else ()
    set(TON_SDK_RELEASE_DIR "${TON_SDK_SRC}/target/release")
endif ()

set(TON_SDK_CLIENT_DIR "${TON_SDK_SRC}/ton_client/client")

install(FILES "${TON_SDK_CLIENT_DIR}/tonclient.h" DESTINATION include)

if (WIN32)
    install(FILES "${TON_SDK_RELEASE_DIR}/ton_client.dll.lib" DESTINATION lib RENAME ton_client.lib)
    install(FILES "${TON_SDK_RELEASE_DIR}/ton_client.dll" DESTINATION bin)
else ()
    install(FILES "${TON_SDK_RELEASE_DIR}/libton_client.dylib" DESTINATION lib OPTIONAL)
    install(FILES "${TON_SDK_RELEASE_DIR}/libton_client.so" DESTINATION lib OPTIONAL)
endif ()
