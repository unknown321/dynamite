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
    extern std::map<uint64_t, std::string> quarkHandles;
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
        void *thisPtr, void *errCodePtr, uint32_t messageID, uint32_t sender, uint32_t receiver, uint32_t param_4, void *messageArgs, uint32_t param_6);
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
    void *CloseSessionHook();
    void ScriptDeclVarsImplSetVarValueHook(void *thisPtr, uint64_t index, uint32_t param_2, uint32_t param_3, uint32_t value);
    void SoldierRouteAiImplPreUpdateHook(void *thisPtr, uint32_t param_1, void *AiNodeUpdateContext);
    uint32_t RouteGroupImplGetEventIdHook(void *RouteGroupImpl, unsigned short param_1, unsigned short param_2, unsigned short param_3);
    fox::QuarkHandle FoxCreateQuarkHook(uint64_t param_1, fox::QuarkDesc *quarkDesc, uint64_t p3);
    void AiControllerImplAddNodeHook(void *thisPtr, uint32_t param_2, uint64_t quarkHandle, uint32_t param_4);
    void AiControllerImplSleepNodeHook(void *AiControllerImpl, uint32_t param_1, int param_2, int32_t SleepCause);
    void AiControllerImplWakeNodeHook(void *AiControllerImpl, uint32_t param_1, int param_2, uint32_t param_3);
    unsigned short CoreAiImplGetVehicleIdHook(void *thisPtr, unsigned short *param_2, uint32_t param_3);
    unsigned char CoreAiImplGetVehicleRideStateHook(void *thisPtr, uint32_t param_1);
    bool CoreAiImplIsVehicleRetainHook(void *thisPtr, uint32_t param_1);
    bool SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStepHook(
        void *RouteAiImpl, uint32_t param_1, void *RouteAiKnowledge, bool param_3, bool param_4, bool param_5, bool param_6);
    bool StatusControllerImplIsSetHook(void *StatusControllerImpl, unsigned char param_1);
    void *ScriptDeclVarsImplGetVarHandleWithVarIndexHook(void *ScriptDeclVarsImpl, void* param_1, uint32_t param_2);
    int32_t BandWidthManagerImplCalcAverageRttOfBetterHalfConnectionHook(void *thisPtr);
    int32_t BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnectionHook(void *thisPtr);
    void BandWidthManagerImplStartLimitStateHook(void *thisPtr);

    int32_t blockStatus(void *block);
    int32_t blockStatus2(void *block);
}

#endif // HOOK_DYNAMITEHOOK_H
