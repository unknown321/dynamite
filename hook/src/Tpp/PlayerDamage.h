#ifndef HOOK_PLAYERDAMAGE_H
#define HOOK_PLAYERDAMAGE_H

#include "TppTypes.h"

#pragma pack(push, 1)
struct PlayerDamage {
    Vector4 v1;
    Vector4 dontUse; // will be zeroed on client side, do not store anything

    unsigned short damage_type_flags{};
    unsigned short damage_category{};
    unsigned short damageID{};
    unsigned char b1{};
    unsigned char b2{};
    unsigned char b3{};
    unsigned short skip{}; // up to 256
    unsigned char lethalFlag{};
    unsigned int skip2{}; // modified by the game
};
#pragma pack(pop)

#pragma pack(push, 1)
struct PlayerDamaged {
    uint32_t playerIndex;
    uint32_t playerIndex2;
    unsigned short attackID;
};
#pragma pack(pop)

#endif // HOOK_PLAYERDAMAGE_H
