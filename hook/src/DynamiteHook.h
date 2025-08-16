#ifndef HOOK_DYNAMITEHOOK_H
#define HOOK_DYNAMITEHOOK_H

#include "Config.h"
#include "Tpp/PlayerDamage.h"
#include "Tpp/TppTypes.h"
#include "lua/lua.h"
#include "windows.h"
#include <map>

namespace Dynamite {
    extern Config cfg;
    extern lua_State *luaState;
    extern std::map<uint32_t, std::string> messageDict;
    extern std::map<uint64_t, std::string> pathDict;
    extern bool sessionConnected;
    extern void *DamageControllerImpl;
    extern void *MarkerSystemImpl;
    extern void *SightManagerImpl;
    extern void *EquipHudSystemImpl;
    extern bool ignoreMarkerRequests;
    extern unsigned int offensePlayerID;
    extern unsigned int defensePlayerID;
    extern bool hostSessionCreated;
    extern void CreateLibs(lua_State *L);

    void __fastcall luaL_openlibsHook(lua_State *L);
    bool IsDefenseTeamByOnlineFobLocalHook();
    bool IsOffenseTeamByOnlineFobLocalHook();
    unsigned int GetFobOffensePlayerInstanceIndexHook(void *);
    unsigned int GetFobDefensePlayerInstanceIndexHook(void *);
    unsigned int GetUiMarkerTypeFromSystemType2Hook(void *p1, void *p2);
    bool SightManagerImplSetMarkerHook(void *thisPtr, unsigned short objectID, float duration);
    void SteamUdpSocketImplOnP2PSessionRequestHook(void *thisPtr, void *request);
    void SetSteamIdHook(void *param, uint64_t *steamID);
    bool IsConnectReadyHook(void *param);
    void UpdateClientEstablishedHook(void *param);
    void *MessageBufferAddMessageHook(
        void *thisPtr, void *errCodePtr, uint32_t messageID, uint32_t param_2, uint32_t receiver, uint32_t param_4, void *messageArgs, uint32_t param_6);
    bool AddLocalDamageHook(void *thisPtr, uint32_t playerIndex, PlayerDamage *Damage);
    void DamageControllerImplInitializeHook(void *thisPtr, void *QuarkDesc);
    uint32_t SynchronizerImplGetDamageHook(void *thisPtr, uint32_t objectID, PlayerDamage *damage);
    void *Marker2SystemImplHook(void *thisPtr);
    void EquipHudSystemImplInitDataHook(void *thisPtr);
    void Marker2SystemImplRemovedUserMarkerHook(void *thisPtr, uint32_t markerID);
    void Marker2SystemImplPlacedUserMarkerFixedHook(void *thisPtr, Vector3 *pos);
    bool Marker2SystemImplPlacedUserMarkerFollowHook(void *thisPtr, Vector3 *pos, unsigned short objectID);
    void SightManagerImplInitializeHook(void *thisPtr, void *QuarkDesc);
    void UiControllerImplSetNoUseEquipIdHook(void *thisPtr, bool param_1, unsigned int EquipID);
    bool EquipCrossEvCallIsItemNoUseHook(void *thisPtr, unsigned int EquipID);
    double FoxBlockProcessHook(void *Block, void *TaskContext, void *BlockProcessState);
    int32_t *FoxBlockReloadHook(void *Block, int32_t *param_2);
    int32_t *FoxBlockUnloadHook(void *Block, int32_t *param_2);
    void *FoxGenerateUniqueNameHook(void *sharedString, unsigned long long param_2, void *string);
    void *FoxBlockHook(void *p1);
    int32_t *FoxBlockActivateHook(void *Block, int32_t *param_2);
    int32_t *FoxBlockDeactivateHook(void *Block, int32_t *param_2);
    int *FoxBlockLoadHook(void *thisPtr, int *errorCode, uint64_t *pathID, uint32_t count);
    void *(BlockMemoryAllocTailHook)(void *memBlock, uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag);
    int64_t(__fastcall CreateHostSessionHook)(FobTarget *param);
    FobTarget *FobTargetCtorHook(FobTarget *p);
    void *BlockHeapAllocHook(uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag);
    void * CloseSessionHook();

    int32_t blockStatus(void *block);
    int32_t blockStatus2(void *block);
}

#endif // HOOK_DYNAMITEHOOK_H
