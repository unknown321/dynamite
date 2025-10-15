#include "windows.h"
#include <iostream>

#include "dynamite.h"

#include <spdlog/spdlog.h>

HMODULE g_thisModule;
extern HMODULE origDll; // dinputproxy

#include "DynamiteHook.h"

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    if (ul_reason_for_call == DLL_PROCESS_ATTACH) {
        DisableThreadLibraryCalls(hModule);
        g_thisModule = hModule;
        Dynamite::g_hook = new Dynamite::Dynamite;

    } else if (ul_reason_for_call == DLL_PROCESS_DETACH) {
        if (origDll) {
            delete Dynamite::g_hook;
            spdlog::shutdown();
            FreeLibrary(origDll);
        }
    }

    return true;
}