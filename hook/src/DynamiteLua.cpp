#include "DynamiteLua.h"
#include "DamageProtocol.h"
#include "lua/lauxlib.h"
#include "lua/lua.h"
#include "memtag.h"
#include "spdlog/spdlog.h"
#include "util.h"

namespace Dynamite {
    // TppMain.lua, called automatically on mission start
    __cdecl int l_CreateHostSession(lua_State *L) {
        spdlog::info(__FUNCTION__);
        auto ft = (FobTarget *)BlockHeapAlloc(8, 8, MEMTAG_NULL);
        ft = FobTargetCtor(ft);
        CreateHostSession(ft);
        BlockHeapFree(ft);

        lua_getglobal(luaState, "TppUiCommand");
        lua_getfield(luaState, -1, "AnnounceLogView");
        auto text = "Created host session\0";
        lua_pushstring(luaState, text);
        lua_pcall(luaState, 1, 0, 0);

        return 0;
    }

    // allow client to create session again
    // called manually
    int l_ResetClientSessionStateWithNotification(lua_State *L) {
        spdlog::info(__FUNCTION__);
        l_ResetClientSessionState(L);

        lua_getglobal(luaState, "TppUiCommand");
        lua_getfield(luaState, -1, "AnnounceLogView");
        auto text = "Session status reset\0";
        lua_pushstring(luaState, text);
        lua_pcall(luaState, 1, 0, 0);

        return 0;
    }

    // allow client to create session again
    // called on mission end
    int l_ResetClientSessionState(lua_State *L) {
        spdlog::info(__FUNCTION__);
        sessionCreated = false;
        sessionConnected = false;
        offensePlayerID = 0;

        return 0;
    }

    // called manually by client
    int l_CreateClientSession(lua_State *L) {
        spdlog::info(__FUNCTION__);
        if (cfg.Host) {
            auto text = "Attempting client connection as a host, you are not supposed to do that!\0";
            spdlog::warn(text);
            lua_pushstring(L, text);
            l_AnnounceLogView(L);
            return 1;
        }

        if (sessionCreated) {
            return 0;
        }

        // fob target and session connect info can contain any data, preferably nulls
        // targetIPCString must be set to anything > 0, crash otherwise
        // 3 just works
        // real target ip is retrieved later by Steam
        auto ff = (FobTarget *)BlockHeapAlloc(sizeof(FobTarget), 8, MEMTAG_NULL);
        auto ci = (SessionConnectInfo *)BlockHeapAlloc(sizeof(SessionConnectInfo), 8, MEMTAG_NULL);
        char test = 3;
        ff->sessionConnectInfo = ci;
        ff->sessionConnectInfo->targetIPCString = &test;
        auto res = CreateClientSession(ff, ci);
        BlockHeapFree(ff);
        BlockHeapFree(ci);

        auto text = "Establishing co-op connection...\0";
        spdlog::info(text);

        if (res == 1) {
            lua_pushstring(L, text);
            l_AnnounceLogView(L);
            sessionCreated = res;
            return 1;
        }

        text = "Failed to create co-op session, try again\0";
        spdlog::error(text);

        lua_pushstring(L, text);
        l_AnnounceLogView(L);

        sessionCreated = res;

        return 1;
    }

    // *_sequence.lua, called on mission start
    int l_StartNearestEnemyThread(lua_State *L) {
        StartNearestEnemyThread();
        return 0;
    }

    // TppMain, TppMission, called on mission end
    int l_StopNearestEnemyThread(lua_State *L) {
        spdlog::info(__FUNCTION__);
        if (nearestEnemyThreadRunning) {
            stopNearestEnemyThread = true;
        }
        return 0;
    }

    // not used in lua, but exposed just in case
    int l_IsNearestEnemyThreadRunning(lua_State *L) {
        lua_pushboolean(L, nearestEnemyThreadRunning);
        return 1;
    }

    // not used in lua, but exposed just in case
    int l_GetOffensePlayerIndex(lua_State *L) {
        lua_pushinteger(L, offensePlayerID);
        return 1;
    }

    // not used in lua, but exposed just in case
    int l_GetDefensePlayerIndex(lua_State *L) {
        lua_pushinteger(L, defensePlayerID);
        return 1;
    }

    // not used in lua, but exposed just in case
    int l_GetSoldierLifeStatus(lua_State *L) {
        int oid = luaL_checkinteger(L, 1);
        auto res = GetSoldierLifeStatus(oid);
        lua_pushinteger(L, res);
        return 1;
    }

    // called in TppMain to set IS_ONLINE flag
    int l_IsHost(lua_State *L) {
        lua_pushboolean(L, cfg.Host);
        return 1;
    }

    int l_AddDamage(lua_State *L) {
        int playerID = luaL_checkinteger(L, 1);
        unsigned short damageID = luaL_checkinteger(L, 2);
        auto d = NewNetworkDamage();
        d.v1.x = luaL_checknumber(L, 3);
        d.v1.y = luaL_checknumber(L, 4);
        d.v1.z = luaL_checknumber(L, 5);
        d.v1.w = luaL_checknumber(L, 6);
        d.damage_category = 16386;
        d.lethalFlag = 1;
        d.b1 = 3;
        d.b2 = DamageProtocolCommand::CMD_AddFixedUserMarker;
        d.b3 = 0xc8;
        d.damageID = damageID;

        if (DamageControllerImpl == nullptr) {
            spdlog::error("damage controller impl is null");
            return 0;
        }

        AddLocalDamageHook(DamageControllerImpl, playerID, &d);
        return 0;
    }

    int l_AddFixedMarkerNetwork(lua_State *L) {
        uint32_t playerID;
        GetLocalPlayerId(&playerID);
        auto d = new PlayerDamage();
        d->v1.x = luaL_checknumber(L, 1);
        d->v1.y = luaL_checknumber(L, 2);
        d->v1.z = luaL_checknumber(L, 3);
        d->v1.w = 0;
        d->damage_category = 16386;
        d->lethalFlag = 1;
        d->b1 = 3;
        d->b2 = DamageProtocolCommand::CMD_AddFixedUserMarker;
        d->b3 = 0xc8;
        d->damageID = DamageID;

        if (DamageControllerImpl == nullptr) {
            spdlog::error("damage controller impl is null");
            return 0;
        }

        AddLocalDamageHook(DamageControllerImpl, playerID, d);
        return 0;
    }

    int l_AddFixedMarker(lua_State *L) {
        auto x = luaL_checknumber(L, 1);
        auto y = luaL_checknumber(L, 2);
        auto z = luaL_checknumber(L, 3);
        auto vv = Vector3{
            .x = static_cast<float>(x),
            .y = static_cast<float>(y),
            .z = static_cast<float>(z),
        };

        Marker2SystemImplPlacedUserMarkerFixed(MarkerSystemImpl, &vv);

        return 0;
    }

    int l_RemoveMarker(lua_State *L) {
        auto i = luaL_checkinteger(L, 1);
        Marker2SystemImplRemovedUserMarker(MarkerSystemImpl, i);
        return 0;
    }

    int l_RemoveAllUserMarkers(lua_State *L) {
        spdlog::info("removing all user markers");
        Marker2SystemImplRemovedAllUserMarker(MarkerSystemImpl);
        return 0;
    }

    int l_IgnoreMarkerRequests(lua_State *L) {
        spdlog::info("ignoring marker requests");
        ignoreMarkerRequests = true;
        return 0;
    }

    int l_AcceptMarkerRequests(lua_State *L) {
        spdlog::info("accepting marker requests");
        ignoreMarkerRequests = false;
        return 0;
    }

    int l_GetPlayerPosition(lua_State *L) {
        auto i = luaL_checkinteger(L, 1);
        auto res = Dynamite::GetPlayerPosition(i);
        auto rr = Vector4 {
            .x = res.x,
            .y = res.y,
            .z = res.z,
            .w = 0,
        };
        spdlog::info("{}: {} {} {}", i, res.x, res.y, res.z);
        FoxLuaPushVector3(L, &rr);
        return 1;
    }

    void CreateLibs(lua_State *L) {
        luaL_Reg libFuncs[] = {
            {"CreateHostSession", l_CreateHostSession},
            {"CreateClientSession", l_CreateClientSession},
            {"ResetClientSessionState", l_ResetClientSessionState},
            {"ResetClientSessionStateWithNotification", l_ResetClientSessionStateWithNotification},
            {"StartNearestEnemyThread", l_StartNearestEnemyThread},
            {"StopNearestEnemyThread", l_StopNearestEnemyThread},
            {"IsNearestEnemyThreadRunning", l_IsNearestEnemyThreadRunning},
            {"GetOffensePlayerIndex", l_GetOffensePlayerIndex},
            {"GetDefensePlayerIndex", l_GetDefensePlayerIndex},
            {"GetSoldierLifeStatus", l_GetSoldierLifeStatus},
            {"AddDamage", l_AddDamage},
            {"AddFixedMarkerNetwork", l_AddFixedMarkerNetwork},
            {"AddFixedMarker", l_AddFixedMarker},
            {"RemoveMarker", l_RemoveMarker},
            {"RemoveAllUserMarkers", l_RemoveAllUserMarkers},
            {"IgnoreMarkerRequests", l_IgnoreMarkerRequests},
            {"AcceptMarkerRequests", l_AcceptMarkerRequests},
            {"IsHost", l_IsHost},
            {"GetPlayerPosition", l_GetPlayerPosition},
            {nullptr, nullptr},
        };
        luaI_openlib(L, "Dynamite", libFuncs, 0);
    }
}