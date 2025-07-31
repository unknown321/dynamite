// DInputProxy.cpp - from CityHook
// Proxy dinput8.dll
#include "windows.h"
#include <cstdio>
#include <cstdlib>

#pragma comment(linker, "/export:DirectInput8Create=DirectInput8Create")

typedef HRESULT(WINAPI *DirectInput8Create_ptr)(HINSTANCE hinst, DWORD dwVersion, REFIID riidltf, LPVOID *ppvOut, void *punkOuter);
DirectInput8Create_ptr DirectInput8Create_Orig = nullptr;

extern HMODULE g_thisModule;
bool origLoaded = false;
HMODULE origDll = nullptr;

bool LoadProxiedDll() {
    if (origLoaded)
        return true;

    // get the filename of our DLL and try loading the DLL with the same name from system32
    WCHAR modulePath[MAX_PATH] = {0};
    if (!GetSystemDirectoryW(modulePath, _countof(modulePath))) {
        return false;
    }

    // get filename of this DLL, which should be the original DLLs filename too
    WCHAR ourModulePath[MAX_PATH] = {0};
    GetModuleFileNameW(g_thisModule, ourModulePath, _countof(ourModulePath));

    WCHAR exeName[MAX_PATH] = {0};
    WCHAR extName[MAX_PATH] = {0};
    _wsplitpath_s(ourModulePath, nullptr, 0, nullptr, 0, exeName, MAX_PATH, extName, MAX_PATH);

    swprintf_s(modulePath, MAX_PATH, L"%ws\\%ws%ws", modulePath, exeName, extName);

    // "C:\Windows\system32\DINPUT8.DLL"
    origDll = LoadLibraryW(modulePath);
    if (!origDll) {
        return false;
    }

    DirectInput8Create_Orig = (DirectInput8Create_ptr)GetProcAddress(origDll, "DirectInput8Create");

    origLoaded = true;
    return true;
}

extern "C" __declspec(dllexport) HRESULT DirectInput8Create(HINSTANCE hinst, DWORD dwVersion, REFIID riidltf, LPVOID *ppvOut, void *punkOuter) {
    if (!DirectInput8Create_Orig) {
        LoadProxiedDll();
    }

    return DirectInput8Create_Orig(hinst, dwVersion, riidltf, ppvOut, punkOuter);
}