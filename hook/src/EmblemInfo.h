#ifndef HOOK_EMBLEMINFO_H
#define HOOK_EMBLEMINFO_H

#include <cstdint>

struct EmblemInfo {
    uint32_t emblemTextureTag[4];
    uint32_t emblemColorL[4];
    uint32_t emblemColorH[4];
    int8_t emblemX[4];
    int8_t emblemY[4];
    int8_t emblemScale[4];
    int8_t emblemRotate[4];
};

#endif // HOOK_EMBLEMINFO_H
