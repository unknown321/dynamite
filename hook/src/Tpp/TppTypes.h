#ifndef HOOK_TPPTYPES_H
#define HOOK_TPPTYPES_H

#include <cstdint>

// size 0xd8
struct SessionConnectInfo {
    int64_t zeros;
    int64_t p2; // 0x142b5a040, SharedStringData
    int64_t alwaysZero;
    uint64_t setMeToZeroPlease; // set to null
    uint64_t three;             // always 3
    int64_t alwaysZero2;        // always 0
    char skip3[24];
    uint32_t eight; // always 8
    char skip4[32];
    uint32_t eight2; // always 8
    uint64_t steam_id;
    char skip6[64];
    uint64_t steam_id2;    // same id?
    uint64_t staticData1;  // a0 78 20 18 - NotImplement
    char *targetIPCString; // -> pointer to ip addr string
    uint64_t port;         // 5733
};

// size 0x80
struct FobTarget {
    char vtable[8];
    void *pt1;
    int32_t field2_0x10;
    int32_t field3_0x14; // == 4 in ctor
    uint64_t field4_0x18;
    uint64_t field5_0x20;
    uint64_t field6_0x28;
    uint64_t field7_0x30;
    uint64_t field8_0x38;
    SessionConnectInfo *sessionConnectInfo; // SessionConnectInfo, 0x40
    uint64_t field10_0x48;
    uint64_t displayName1; // DisplayName, 0x50
    uint64_t displayName2; // DisplayName, 0x58
    uint64_t commStatus;   // fox::nio::CommunicationStatus::CommunicationStatus, 0x60
    uint64_t field14_0x68;
    uint64_t field15_0x70;
    uint64_t field16_0x78;
};

#pragma pack(push, 1)
struct Vector3 {
    float x = 0;
    float y = 0;
    float z = 0;
    float w = 0;

    bool Valid();
};
#pragma pack(pop)

#pragma pack(push, 1)
struct Vector3Double {
    double x = 0;
    double y = 0;
    double z = 0;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct Vector4 {
    float x = 0;
    float y = 0;
    float z = 0;
    float w = 0;
};
#pragma pack(pop)

#pragma pack(push, 1)
struct Quat {
    float x = 0;
    float y = 0;
    float z = 0;
    float w = 0;
};
#pragma pack(pop)


#endif // HOOK_TPPTYPES_H
