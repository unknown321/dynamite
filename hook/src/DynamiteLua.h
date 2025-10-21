#ifndef HOOK_DYNAMITELUA_H
#define HOOK_DYNAMITELUA_H

#include "lua/lua.h"

namespace Dynamite {
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
    int l_AddFixedMarker(lua_State *L);
    int l_RemoveMarker(lua_State *L);
    int l_RemoveAllUserMarkers(lua_State *L);
    int l_IgnoreMarkerRequests(lua_State *L);
    int l_AcceptMarkerRequests(lua_State *L);
    int l_GetPlayerPosition(lua_State *L);
    int l_WarpToPartner(lua_State *L);
    int l_IsSynchronized(lua_State *L);
    int l_RequestVar(lua_State *L);
    int l_Ping(lua_State *L);
    int l_Log(lua_State *L);
    int l_Donated(lua_State *L);
    int l_MissionComplete(lua_State *L);
    int l_GetMissionsCompleted(lua_State *L);
}

#endif // HOOK_DYNAMITELUA_H
