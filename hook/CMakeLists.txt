cmake_minimum_required(VERSION 3.25)
project(dinput8)

set(CMAKE_CXX_STANDARD 23)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -s")
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -s")
set(CMAKE_SHARED_LIBRARY_PREFIX "")

include(FetchContent)
FetchContent_Declare(
        minhook

        GIT_REPOSITORY https://github.com/unknown321/minhook.git
        GIT_TAG bd826f3090f665fa90500f7a860706286458a69b
)
FetchContent_MakeAvailable(minhook)

FetchContent_Declare(
        mINI
        GIT_REPOSITORY https://github.com/metayeti/mINI.git
        GIT_TAG 52b66e987cb56171dc91d96115cdf094b6e4d7a0
)
FetchContent_MakeAvailable(mINI)


FetchContent_Declare(
        spdlog
        GIT_REPOSITORY https://github.com/gabime/spdlog.git
        GIT_TAG 486b55554f11c9cccc913e11a87085b2a91f706f
)
FetchContent_MakeAvailable(spdlog)


FetchContent_Declare(
        flatbuffers
        GIT_REPOSITORY https://github.com/google/flatbuffers.git
        GIT_TAG 187240970746d00bbd26b0f5873ed54d2477f9f3
)
FetchContent_MakeAvailable(flatbuffers)

include_directories(
        src/
)

SET(LUA_COMPAT_OPENLIB 1)

if(EXISTS ${CMAKE_CURRENT_BINARY_DIR}/__header.h)
    message(FATAL_ERROR "File \"${CMAKE_CURRENT_BINARY_DIR}/__header.h\" found, \
    this should never be created, remove!")
endif()

add_custom_command(
        OUTPUT
        ${CMAKE_CURRENT_BINARY_DIR}/__header.h  # fake! ensure we run!
        COMMAND true
)

add_custom_target(version
        COMMAND rm -fv ${CMAKE_SOURCE_DIR}/src/Version.h
        COMMAND ${CMAKE_COMMAND} -D SRC=${CMAKE_SOURCE_DIR}/src/Version.h.in
        -D DST=${CMAKE_SOURCE_DIR}/src/Version.h
        -P ${CMAKE_SOURCE_DIR}/GenerateVersion.cmake
        ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/__header.h
)

add_library(${PROJECT_NAME} SHARED
        src/mgsvtpp_funcptr_defs.cpp
        src/mgsvtpp_funcptr_set.cpp
        src/Tpp/GameObject.cpp
        src/Tpp/TppSoldier2.cpp
        src/DynamiteSyncImpl/DynamiteSyncImpl.cpp
        src/Config.cpp
        src/Messagebox.cpp
        src/patch.cpp
        src/Tpp/TppTypes.cpp
        src/util.cpp

        src/dynamiteHooks.cpp
        src/dynamitePatches.cpp
        src/DynamiteCore.cpp
        src/dynamite.cpp
        src/DynamiteLua.cpp
        src/DynamiteHook.cpp
        src/main.cpp
        src/DInputProxy.cpp
)

add_dependencies(${PROJECT_NAME} version)

target_compile_options(${PROJECT_NAME} PUBLIC -fpermissive)
target_link_options(${PROJECT_NAME} PUBLIC -static)
target_link_libraries(${PROJECT_NAME} flatbuffers minhook mINI spdlog::spdlog_header_only)