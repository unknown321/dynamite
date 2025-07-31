#ifndef HOOK_HOOKMACROS_H
#define HOOK_HOOKMACROS_H

#include "MinHook.h"
#include <map>
#include <string>
#include <fstream>

namespace Dynamite {
    extern std::map<std::string, uint64_t> addressSet;
}

#define STRINGIFY(x) #x
#define TOKENPASTE(x, y) STRINGIFY(x ## y)


//TODO CULL still in the lua headers, which I can revert/comment out the hooked
#define FUNCPTRDEF(ret, name, ...)\

#define STRING(s) #s

//detour and trampoline via MH_CreateHook,
//original function is at the <name> function ptr (just like createptr)
//while the hook/detour is at <name>Hook function pointer.
//TODO: rethink, could iterate over a map if I have a lookup of name to detour function (name##Hook)
#define CREATE_HOOK(name)\
    MH_STATUS name##CreateStatus = MH_CreateHook((LPVOID*)addressSet[#name], name##Hook, (LPVOID*)&name); \
    if (name##CreateStatus != MH_OK) {                                                                    \
        spdlog::error("create hook fail {}: {}", STRING(name), STRING(name##CreateStatus));               \
        exit(1);                     \
    }                    \


/* Example use:
CREATE_HOOK(lua_newstate);
Expands to:
MH_STATUS lua_newstateCreateStatus = MH_CreateHook((LPVOID*)addressSet["lua_newstate"], lua_newstateHook, (LPVOID*)&lua_newstate);
if (lua_newstateCreateStatus != MH_OK) {
	spdlog::error("MH_CreateHook failed for {} with code {}", "lua_newstate", lua_newstateCreateStatus);\
}
//ASSUMPTION name##Addr of runtime memory address has been defined
 */


#define ENABLEHOOK(name)\
    MH_STATUS name##EnableStatus = MH_EnableHook((LPVOID*)addressSet[#name]);\
    if (name##EnableStatus != MH_OK) {\
    } else {\
    }

/*
    Example use:
    ENABLEHOOK(lua_newstate);
    Expands to:
    MH_STATUS lua_newstateEnableStatus = MH_EnableHook((LPVOID*)addressSet["lua_newstate"]);
    if (lua_newstateEnableStatus != MH_OK) {
        spdlog::error("MH_EnableHook failed for {} with code {}", "lua_newstate", lua_newstateEnableStatus);\
    }

//ASSUMES CREATEDETOUR has defined name##Addr
 */

#define DISABLEHOOK(name)\
MH_STATUS name##DisableStatus = MH_DisableHook((LPVOID*)addressSet[#name]);\
if (name##DisableStatus != MH_OK) {\
} else {\
}

/*
Example use:
ENABLEHOOK(lua_newstate);
Expands to:
MH_STATUS lua_newstateDisableStatus = MH_DisableHook((LPVOID*)addressSet["lua_newstate"]);
if (DisableStatus != MH_OK) {
	spdlog::error("MH_DisableHook failed for {} with code {}", "lua_newstate", lua_newstateDisableStatus);\
}
 */

#endif