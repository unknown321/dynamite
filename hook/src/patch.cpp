#include "patch.h"
#include "windows.h"
#include "stdint.h"

bool Patch::Apply() {
    DWORD oldProtect;
    bool result;
    result = VirtualProtect(reinterpret_cast<LPVOID>(address), patch.size(), PAGE_EXECUTE_READWRITE, &oldProtect);
    if (!result) {
        return result;
    }

    unsigned int count = 0;
    for (auto byte : expected) {
        if (*(uint8_t *)(address + count) != byte) {
            return false;
        }
        count++;
    }

    count = 0;
    for (auto byte : patch) {
        if (byte >= 0 && byte <= 0xFF) {
            *(uint8_t *)(address + count) = (uint8_t)byte;
        }

        ++count;
    }

    result = VirtualProtect(reinterpret_cast<LPVOID>(address), patch.size(), oldProtect, &oldProtect);
    return result;
}
