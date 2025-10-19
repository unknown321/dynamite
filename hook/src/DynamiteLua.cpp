#include "DynamiteLua.h"
#include "DynamiteHook.h"
#include "dynamite.h"
#include "lua/lauxlib.h"
#include "lua/lua.h"
#include "memtag.h"
#include "spdlog/spdlog.h"

namespace Dynamite {
    // TppMain.lua, called automatically on mission start
    int l_CreateHostSession(lua_State *L) {
        spdlog::info(__PRETTY_FUNCTION__);
        if (!g_hook->cfg.Host) {
            spdlog::info("{}, client, refusing to create host session", __PRETTY_FUNCTION__);

            return 0;
        }

        if (hookState.fobTargetCtor == nullptr) {
            spdlog::info("{}, fob target ctor is null", __PRETTY_FUNCTION__);

            return 0;
        }

        if (g_hook->dynamiteCore.GetHostSessionCreated()) {
            lua_getglobal(L, "TppUiCommand");
            lua_getfield(L, -1, "AnnounceLogView");
            const auto text = "Created host session\0";
            lua_pushstring(L, text);
            lua_pcall(L, 1, 0, 0);

            spdlog::info("{}, host session already created", __PRETTY_FUNCTION__);

            return 0;
        }

        auto res = CreateHostSession((FobTarget *)hookState.fobTargetCtor);
        spdlog::info("{}, host session res: {}", __PRETTY_FUNCTION__, res);

        g_hook->dynamiteCore.SetHostSessionCreated(res > 0);

        lua_getglobal(L, "TppUiCommand");
        lua_getfield(L, -1, "AnnounceLogView");
        const auto text = "Created host session\0";
        lua_pushstring(L, text);
        lua_pcall(L, 1, 0, 0);

        return 0;
    }

    // allow client to create session again
    // called manually
    int l_ResetClientSessionStateWithNotification(lua_State *L) {
        spdlog::info(__PRETTY_FUNCTION__);
        l_ResetClientSessionState(L);

        lua_getglobal(L, "TppUiCommand");
        lua_getfield(L, -1, "AnnounceLogView");
        const auto text = "Session status reset\0";
        lua_pushstring(L, text);
        lua_pcall(L, 1, 0, 0);

        return 0;
    }

    // allow client to create session again
    // called on mission end
    int l_ResetClientSessionState(lua_State *L) {
        spdlog::info(__PRETTY_FUNCTION__);

        g_hook->dynamiteCore.ResetState();
        g_hook->dynamiteSyncImpl.Stop();

        return 0;
    }

    // called manually by client
    int l_CreateClientSession(lua_State *L) {
        spdlog::info(__PRETTY_FUNCTION__);
        if (g_hook->cfg.Host) {
            const auto text = "Attempting client connection as a host, you are not supposed to do that!\0";
            spdlog::warn(text);
            lua_pushstring(L, text);
            l_AnnounceLogView(L);

            return 1;
        }

        if (g_hook->dynamiteCore.GetSessionCreated()) {
            spdlog::info("{}, session already created", __PRETTY_FUNCTION__);

            return 0;
        }

        // fob target and session connect info can contain any data, preferably nulls
        // targetIPCString must be set to anything > 0, crash otherwise
        // 3 just works
        // real target ip is retrieved later by Steam

        // WARNING: TODO: these allocations will be made on current block
        // it works only because client clears that memory by disconnecting on mission end
        // see issue_7.md for details

        const auto ff = (FobTarget *)BlockHeapAlloc(sizeof(FobTarget), 8, MEMTAG_NULL);
        const auto connectInfo = (SessionConnectInfo *)BlockHeapAlloc(sizeof(SessionConnectInfo), 8, MEMTAG_NULL);
        char test = 3;
        ff->sessionConnectInfo = connectInfo;
        ff->sessionConnectInfo->targetIPCString = &test;
        const auto res = CreateClientSession(ff, connectInfo);
        BlockHeapFree(ff);
        BlockHeapFree(connectInfo);

        auto text = "Establishing co-op connection...\0";
        spdlog::info(text);

        if (res == 1) {
            lua_pushstring(L, text);
            l_AnnounceLogView(L);
            g_hook->dynamiteCore.SetSessionCreated(res);

            return 1;
        }

        text = "Failed to create co-op session, try again\0";
        spdlog::error(text);

        lua_pushstring(L, text);
        l_AnnounceLogView(L);

        g_hook->dynamiteCore.SetSessionCreated(res);

        return 1;
    }

    // *_sequence.lua, called on mission start
    int l_StartNearestEnemyThread(lua_State *L) {
        spdlog::info(__PRETTY_FUNCTION__);
        g_hook->dynamiteCore.StartNearestEnemyThread();

        return 0;
    }

    // TppMain, TppMission, called on mission end
    int l_StopNearestEnemyThread(lua_State *L) {
        spdlog::info(__PRETTY_FUNCTION__);
        g_hook->dynamiteCore.StopNearestEnemyThread();

        return 0;
    }

    // not used in lua, but exposed just in case
    int l_IsNearestEnemyThreadRunning(lua_State *L) {
        lua_pushboolean(L, g_hook->dynamiteCore.IsNearestEnemyThreadRunning());

        return 1;
    }

    // not used in lua, but exposed just in case
    int l_GetOffensePlayerIndex(lua_State *L) {
        lua_pushinteger(L, g_hook->dynamiteCore.GetOffensePlayerID());

        return 1;
    }

    // not used in lua, but exposed just in case
    int l_GetDefensePlayerIndex(lua_State *L) {
        lua_pushinteger(L, g_hook->dynamiteCore.GetDefensePlayerID());

        return 1;
    }

    // not used in lua, but exposed just in case
    int l_GetSoldierLifeStatus(lua_State *L) {
        const int oid = luaL_checkinteger(L, 1);
        const auto res = g_hook->dynamiteCore.GetSoldierLifeStatus(oid);
        lua_pushinteger(L, res);

        return 1;
    }

    // called in TppMain to set IS_ONLINE flag
    int l_IsHost(lua_State *L) {
        lua_pushboolean(L, g_hook->cfg.Host);

        return 1;
    }

    int l_IsClient(lua_State *L) {
        lua_pushboolean(L, !g_hook->cfg.Host);

        return 1;
    }

    int l_AddFixedMarker(lua_State *L) {
        const auto x = luaL_checknumber(L, 1);
        const auto y = luaL_checknumber(L, 2);
        const auto z = luaL_checknumber(L, 3);
        auto vv = Vector3{
            .x = static_cast<float>(x),
            .y = static_cast<float>(y),
            .z = static_cast<float>(z),
        };

        Marker2SystemImplPlacedUserMarkerFixed(hookState.markerSystemImpl, &vv);

        return 0;
    }

    int l_RemoveMarker(lua_State *L) {
        const auto i = luaL_checkinteger(L, 1);
        Marker2SystemImplRemovedUserMarker(hookState.markerSystemImpl, i);

        return 0;
    }

    int l_RemoveAllUserMarkers(lua_State *L) {
        spdlog::info("{}, removing all user markers", __PRETTY_FUNCTION__);
        Marker2SystemImplRemovedAllUserMarker(hookState.markerSystemImpl);

        return 0;
    }

    int l_IgnoreMarkerRequests(lua_State *L) {
        spdlog::info("{}, ignoring marker requests", __PRETTY_FUNCTION__);
        hookState.ignoreMarkerRequests = true;

        return 0;
    }

    int l_AcceptMarkerRequests(lua_State *L) {
        spdlog::info("{}, accepting marker requests", __PRETTY_FUNCTION__);
        hookState.ignoreMarkerRequests = false;

        return 0;
    }

    int l_GetPlayerPosition(lua_State *L) {
        auto i = luaL_checkinteger(L, 1);
        auto res = g_hook->dynamiteCore.GetPlayerPosition(i);
        auto rr = Vector4{
            .x = res.x,
            .y = res.y,
            .z = res.z,
            .w = 0,
        };
        spdlog::info("{}, {}: {} {} {}", __PRETTY_FUNCTION__, i, res.x, res.y, res.z);
        FoxLuaPushVector3(L, &rr);

        return 1;
    }

    int l_WarpToPartner(lua_State *L) {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        const auto count = g_hook->dynamiteCore.GetMemberCount();
        if (count < 2) {
            spdlog::info("{}, no player to warp to ({} players)", __PRETTY_FUNCTION__, count);

            lua_getglobal(L, "TppUiCommand");
            lua_getfield(L, -1, "AnnounceLogView");
            const auto text = "No player to warp to\0";
            lua_pushstring(L, text);
            lua_pcall(L, 1, 0, 0);

            return 0;
        }

        uint16_t partnerID = 0;
        if (g_hook->cfg.Host) {
            partnerID = 1;
        }

        auto partnerPos = g_hook->dynamiteCore.GetPlayerPosition(partnerID);

        Quat rot = {
            .x = 0,
            .y = -0.1f,
            .z = 0,
            .w = 7.0f,
        };

        auto playerID = 1;
        if (g_hook->cfg.Host) {
            playerID = 0;
        }

        auto gameObject = FindGameObjectWithID(playerID);
        if (gameObject == nullptr) {
            spdlog::info("{}, cannot find game object to warp", __PRETTY_FUNCTION__);
            return 0;
        }

        gameObject = (char *)gameObject + 0x20;

        spdlog::info("{}, player {} warping to partner {}, position {}, {}, {}", __PRETTY_FUNCTION__, playerID, partnerID, partnerPos.x, partnerPos.y, partnerPos.z);

        Player2GameObjectImplWarp(gameObject, playerID, &partnerPos, &rot, true);

        return 0;
    }

    int l_IsSynchronized(lua_State *L) {
        const auto res = g_hook->dynamiteSyncImpl.IsSynchronized();
        lua_pushboolean(L, res);
        return 1;
    }

    int l_RequestVar(lua_State *L) {
        size_t len;
        const auto name = luaL_checklstring(L, 2, &len);
        if (len < 1) {
            spdlog::error("{}, name is empty", __PRETTY_FUNCTION__);
            return 0;
        }

        const auto category = luaL_checklstring(L, 1, &len);
        if (len < 1) {
            spdlog::error("{}, category is empty", __PRETTY_FUNCTION__);
            return 0;
        }

        g_hook->dynamiteSyncImpl.RequestVar(category, name);
        return 0;
    }

    int l_Ping(lua_State *L) {
        g_hook->dynamiteSyncImpl.Ping();
        return 0;
    }

    int l_Log(lua_State *L) {
        size_t len;
        const auto str = luaL_checklstring(L, 1, &len);
        if (len < 1) {
            spdlog::error("{}, str is empty", __PRETTY_FUNCTION__);
            return 0;
        }

        spdlog::info("[lua] {}", str);

        return 0;
    }


    // int l_GetCamoRate(lua_State *L) {
    //     // wrong!
    //     // auto lvar8 = *(uint32_t *)((char *)camouflageControllerImpl + 0x38);
    //     // auto res = *(float *)lvar8;
    //     // lua_pushnumber(L, res);
    //     return 0;
    // }

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
            {"AddFixedMarker", l_AddFixedMarker},
            {"RemoveMarker", l_RemoveMarker},
            {"RemoveAllUserMarkers", l_RemoveAllUserMarkers},
            {"IgnoreMarkerRequests", l_IgnoreMarkerRequests},
            {"AcceptMarkerRequests", l_AcceptMarkerRequests},
            {"IsClient", l_IsClient},
            {"IsHost", l_IsHost},
            {"GetPlayerPosition", l_GetPlayerPosition},
            {"WarpToPartner", l_WarpToPartner},
            {"IsSynchronized", l_IsSynchronized},
            {"RequestVar", l_RequestVar},
            {"Ping", l_Ping},
            {"Log", l_Log},
            {nullptr, nullptr},
        };
        luaI_openlib(L, "Dynamite", libFuncs, 0);
    }
}