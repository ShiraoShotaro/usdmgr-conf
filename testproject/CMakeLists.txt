cmake_minimum_required(VERSION 3.28)
project("testproject")

list(PREPEND CMAKE_MODULE_PATH ${PROJECT_BINARY_DIR})

find_package(openusd REQUIRED)

add_executable(${PROJECT_NAME})
target_sources(${PROJECT_NAME}
    PRIVATE
        main.cpp
)
target_link_libraries(${PROJECT_NAME} PRIVATE openusd::openusd)

if(MSVC)
set_target_properties(${PROJECT_NAME} PROPERTIES
  VS_DEBUGGER_ENVIRONMENT
    "PATH=$<$<CONFIG:Debug>:${openusd_VS_DEBUGGER_ENVIRONMENT_PATH_DEBUG}>$<$<CONFIG:Release>:${openusd_VS_DEBUGGER_ENVIRONMENT_PATH_RELEASE}>;$ENV{PATH}"
)
endif()
