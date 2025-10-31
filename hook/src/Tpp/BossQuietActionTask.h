#ifndef HOOK_BOSSQUIETACTIONTASK_H
#define HOOK_BOSSQUIETACTIONTASK_H
#include "TppTypes.h"

#include <format>

struct BossQuietActionTask {
    Vector3 v1_0x0;
    Vector3 v2_0x10;
    Vector3 v3_0x20;
    Vector3 v4_0x30;
    Vector3 v5_0x40;
    Vector3 v6_0x50;
    Vector3 v7_0x60;
    Vector3 v8_0x70;
    Vector3 v9_0x80;
    Vector3 v10_0x90;
    char field10_0xa0{};
    char field11_0xa1{};
    char field12_0xa2{};
    char field13_0xa3{};
    uint32_t field14_0xa4{};
    unsigned short anotherType_0xa8{};
    unsigned char field17_0xaa{};
    char field18_0xab{};
    unsigned char actionType_0xac{};
    unsigned char field20_0xad{};
    char field21_0xae{};
    char field22_0xaf{};

    std::string ToString();
};

inline std::string BossQuietActionTask::ToString() {
    return std::format("v1 {},\nv2 {},\nv3 {},\nv4 {},\nv5 {},\nv6 {},\nv7 {},\nv8 {},\nv9 {},\nv10 {},\n"
                       "f10 0x{:x}, f11 0x{:x}, f12 0x{:x}, f13 0x{:x}, f14 0x{:x}, f15 0x{:x}, \n"
                       "f17 0x{:x}, f18 0x{:x}, f19 0x{:x}, f20 0x{:x}, f21 0x{:x}, f22 0x{:x}",
        this->v1_0x0.ToString(),
        this->v2_0x10.ToString(),
        this->v3_0x20.ToString(),
        this->v4_0x30.ToString(),
        this->v5_0x40.ToString(),
        this->v6_0x50.ToString(),
        this->v7_0x60.ToString(),
        this->v8_0x70.ToString(),
        this->v9_0x80.ToString(),
        this->v10_0x90.ToString(),

        this->field10_0xa0,
        this->field11_0xa1,
        this->field12_0xa2,
        this->field13_0xa3,
        this->field14_0xa4,
        this->anotherType_0xa8,

        this->field17_0xaa,
        this->field18_0xab,
        this->actionType_0xac,
        this->field20_0xad,
        this->field21_0xae,
        this->field22_0xaf
    );
}

#endif // HOOK_BOSSQUIETACTIONTASK_H
