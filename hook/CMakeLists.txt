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
        GIT_REPOSITORY https://github.com/TsudaKageyu/minhook.git
        GIT_TAG 565968b28583221751cc2810e09ea621745fc3a3
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
        GIT_TAG 6fa36017cfd5731d617e1a934f0e5ea9c4445b13
)
FetchContent_MakeAvailable(spdlog)

include_directories(
        src/
)

SET(LUA_COMPAT_OPENLIB 1)

add_library(dinput8 SHARED
        src/mgsvtpp_funcptr_defs.cpp
        src/mgsvtpp_funcptr_set.cpp
        src/Tpp/GameObject.cpp
        src/Tpp/TppSoldier2.cpp
        src/Config.cpp
        src/Messagebox.cpp
        src/patch.cpp
        src/Tpp/TppTypes.cpp
        src/util.cpp

        src/dynamite.cpp
        src/DynamiteLua.cpp
        src/DynamiteHook.cpp
        src/main.cpp
        src/DInputProxy.cpp
)

target_compile_options(dinput8 PUBLIC -fpermissive)
target_link_options(dinput8 PUBLIC -static)
target_link_libraries(dinput8 minhook mINI spdlog::spdlog_header_only)