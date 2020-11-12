include_directories(.)

find_package(TON REQUIRED)

add_library(tonclient_dotnet_bridge SHARED tonclient_dotnet_bridge.c)

set_target_properties(tonclient_dotnet_bridge PROPERTIES
        PUBLIC_HEADER "../include/tonclient_dotnet_bridge.h"
        C_VISIBILITY_PRESET hidden
        COMPILE_DEFINITIONS "TC_BRIDGE_DLL;TC_BRIDGE_DLL_EXPORTS"
        VERSION ${TON_SDK_VERSION})

target_link_libraries(tonclient_dotnet_bridge TON::Client)

install(TARGETS tonclient_dotnet_bridge
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        PUBLIC_HEADER DESTINATION include)

install(FILES "${TON_LIBRARIES}" DESTINATION lib)

if (TON_RUNTIME_LIBRARIES)
    install(FILES "${TON_RUNTIME_LIBRARIES}" DESTINATION bin)
endif ()

