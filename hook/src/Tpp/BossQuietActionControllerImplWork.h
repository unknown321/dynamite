#ifndef HOOK_BOSSQUIETACTIONCONTROLLERIMPLWORK_H
#define HOOK_BOSSQUIETACTIONCONTROLLERIMPLWORK_H
#include "BossQuietActionTask.h"

#include <format>
#include <string>

struct BossQuietImplActionControllerImplWork {
    BossQuietActionTask task1;
    BossQuietActionTask task2;
    uint64_t field2_0x160;
    uint64_t field3_0x168;
    uint64_t field4_0x170;
    int field5_0x178;
    unsigned short field6_0x17c;
    unsigned short field7_0x17e;
    short field8_0x180;
    char field9_0x182;
    char field10_0x183;
    uint32_t field11_0x184;
    uint32_t field12_0x188;
    char field13_0x18c;
    char field14_0x18d;
    char field15_0x18e;
    char field16_0x18f;
    uint32_t field17_0x190;
    uint32_t field18_0x194;
    uint32_t field19_0x198;
    char field20_0x19c;
    char field21_0x19d;
    char field22_0x19e;
    char field23_0x19f;
    uint64_t field24_0x1a0;
    uint64_t field25_0x1a8;
    unsigned short field26_0x1b0;
    char field27_0x1b2;
    char field28_0x1b3;
    uint32_t field29_0x1b4;
    char field30_0x1b8;
    char field31_0x1b9;
    char field32_0x1ba;
    char field33_0x1bb;
    char field34_0x1bc;
    char field35_0x1bd;
    char field36_0x1be;
    char field37_0x1bf;

    std::string ToString();
};

inline std::string BossQuietImplActionControllerImplWork::ToString() {

    return std::format("task1={},\ntask2={}\n"
        "0x178={}, 0x17e={}, 0x180={}",
        task1.ToString(),
        task2.ToString(),
        this->field5_0x178,
        this->field7_0x17e,
        this->field8_0x180);
}

#endif // HOOK_BOSSQUIETACTIONCONTROLLERIMPLWORK_H
