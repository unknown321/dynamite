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
    extern bool sessionConnected;
    extern void *DamageControllerImpl;
    extern void *MarkerSystemImpl;
    extern void *SightManagerImpl;
    extern void *EquipHudSystemImpl;
    extern bool ignoreMarkerRequests;
    extern unsigned int offensePlayerID;
    extern unsigned int defensePlayerID;

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
}

#endif // HOOK_DYNAMITEHOOK_H
