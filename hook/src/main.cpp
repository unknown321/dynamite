#include "windows.h"
#include <iostream>

#include "dynamite.h"

HMODULE g_thisModule;
extern HMODULE origDll; // dinputproxy
Dynamite::Dynamite *g_hook = nullptr;

BOOL APIENTRY DllMain(HMODULE hModule, DWORD ul_reason_for_call, LPVOID lpReserved) {
    if (ul_reason_for_call == DLL_PROCESS_ATTACH) {
        DisableThreadLibraryCalls(hModule);
        g_thisModule = hModule;
        g_hook = new Dynamite::Dynamite;

    } else if (ul_reason_for_call == DLL_PROCESS_DETACH) {
        if (origDll) {
            delete g_hook;
            FreeLibrary(origDll);
        }
    }

    return true;
}