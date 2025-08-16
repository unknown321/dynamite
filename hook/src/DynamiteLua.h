#ifndef HOOK_DYNAMITELUA_H
#define HOOK_DYNAMITELUA_H

#include "Config.h"
#include "Tpp/PlayerDamage.h"
#include "Tpp/TppNPCLifeState.h"
#include "lua/lua.h"

namespace Dynamite {
    extern Config cfg;
    extern lua_State *luaState;
    extern bool sessionCreated;
    extern bool sessionConnected;
    extern unsigned int offensePlayerID;
    extern unsigned int defensePlayerID;
    extern bool nearestEnemyThreadRunning;
    extern bool stopNearestEnemyThread;
    extern void StartNearestEnemyThread();
    extern void *DamageControllerImpl;
    extern void *MarkerSystemImpl;
    extern void *SightManagerImpl;
    extern void *EquipHudSystemImpl;
    extern bool ignoreMarkerRequests;
    extern void* fobTargetCtor;
    extern Vector3 GetPlayerPosition(int index);
    extern bool hostSessionCreated;

    extern bool AddLocalDamageHook(void *thisPtr, uint32_t playerIndex, PlayerDamage *Damage);
    extern ENPCLifeState GetSoldierLifeStatus(int objectID);

    void CreateLibs(lua_State *L);
    int l_CreateHostSession(lua_State *L);
    int l_ResetClientSessionStateWithNotification(lua_State *L);
    int l_ResetClientSessionState(lua_State *L);
    int l_CreateClientSession(lua_State *L);
    int l_StartNearestEnemyThread(lua_State *L);
    int l_StopNearestEnemyThread(lua_State *L);
    int l_IsNearestEnemyThreadRunning(lua_State *L);
    int l_GetOffensePlayerIndex(lua_State *L);
    int l_GetDefensePlayerIndex(lua_State *L);
    int l_GetSoldierLifeStatus(lua_State *L);
    int l_IsClient(lua_State *L);
    int l_IsHost(lua_State *L);
    int l_AddDamage(lua_State *L);
    int l_AddFixedMarkerNetwork(lua_State *L);
    int l_AddFixedMarker(lua_State *L);
    int l_RemoveMarker(lua_State *L);
    int l_RemoveAllUserMarkers(lua_State *L);
    int l_IgnoreMarkerRequests(lua_State *L);
    int l_AcceptMarkerRequests(lua_State *L);
}

#endif // HOOK_DYNAMITELUA_H
