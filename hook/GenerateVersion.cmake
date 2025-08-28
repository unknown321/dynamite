find_package(Git)
if (GIT_EXECUTABLE)
    execute_process(
            COMMAND ${GIT_EXECUTABLE} status --porcelain
            OUTPUT_VARIABLE DIRTY_STRINGS
    )

    if (NOT DIRTY_STRINGS STREQUAL "")
        string(TIMESTAMP date "%Y-%m-%d %H:%M")
        execute_process(
                COMMAND ${GIT_EXECUTABLE} log -1 --format=%h-dirty
                OUTPUT_VARIABLE HOOK_VERSION
                RESULT_VARIABLE ERROR_CODE
                OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        string(CONCAT HOOK_VERSION ${HOOK_VERSION} ", " ${date})
    else ()
        execute_process(
                COMMAND ${GIT_EXECUTABLE} describe --tags --abbrev=0
                OUTPUT_VARIABLE HOOK_VERSION
                RESULT_VARIABLE ERROR_CODE
                OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    endif ()
endif ()


if (HOOK_VERSION STREQUAL "")
    set(HOOK_VERSION unknown)
    message(WARNING "Failed to determine version from Git tags. Using default version \"${HOOK_VERSION}\".")
endif ()

configure_file(${SRC} ${DST} @ONLY)
