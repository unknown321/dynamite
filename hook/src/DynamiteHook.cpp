#include "DynamiteHook.h"
#include "DamageProtocol.h"
#include "Tpp/TppFOB.h"
#include "Tpp/TppMarkerType.h"
#include "mgsvtpp_func_typedefs.h"
#include "spdlog/spdlog.h"
#include "util.h"
#include <filesystem>

namespace Dynamite {
    // entry point
    void __fastcall luaL_openlibsHook(lua_State *L) {
        int Version = 1;
        luaL_openlibs(L);

        lua_pushinteger(L, Version);
        lua_setfield(L, LUA_GLOBALSINDEX, "_Dynamite");

        CreateLibs(L);
        luaState = L;

        messageDict = readMessageDictionary("messageDict.txt");

        auto luaLog = "dynamite/luaLog.txt";
        if (std::filesystem::exists(luaLog)) {
            std::ofstream ofs(luaLog, std::ios::trunc);
            ofs.close();
        }
    }

    bool IsDefenseTeamByOnlineFobLocalHook() { return false; }

    bool IsOffenseTeamByOnlineFobLocalHook() { return true; }

    unsigned int GetFobOffensePlayerInstanceIndexHook(void *) { return offensePlayerID; }

    unsigned int GetFobDefensePlayerInstanceIndexHook(void *) { return defensePlayerID; }

    unsigned int GetUiMarkerTypeFromSystemType2Hook(void *p1, void *p2) {
        auto res = GetUiMarkerTypeFromSystemType2(p1, p2);
        if (res == TppMarkerType::MARKER_TYPE_FOB_ENEMY) {
            return TppMarkerType::MARKER_TYPE_BUDDY_D_DOG;
        }

        return res;
    }

    bool SightManagerImplSetMarkerHook(void *thisPtr, unsigned short objectID, float duration) {
        // this is a player object
        if (objectID <= SESSION_CLIENTS_MAX) {
            duration = 9999999;
        }

        auto res = SightManagerImplSetMarker(thisPtr, objectID, duration);
        if (!res) {
            spdlog::error("{}: false, objectID {}, duration {}", __FUNCTION__, objectID, duration);
            return res;
        }

        auto d = NewNetworkDamage();
        d.b2 = DamageProtocolCommand::CMD_SetSightMarker;
        d.damage_type_flags = objectID;
        d.v1.x = duration;

        uint32_t playerID;
        GetLocalPlayerId(&playerID);
        auto dmgAdd = AddLocalDamageHook(DamageControllerImpl, playerID, &d);
        spdlog::info("network set sight marker: {}", dmgAdd);

        return res;
    }

    void SteamUdpSocketImplOnP2PSessionRequestHook(void *thisPtr, void *request) {
        auto clientSteamID = *(uint64_t *)(request);
        spdlog::info("{}: Connection request: {:d}", __FUNCTION__, clientSteamID);

        if (!cfg.Host)  {
            spdlog::warn("client, but there was a connection attempt?");
        }

        if ((cfg.whitelist.empty()) && (cfg.blacklist.empty())) {
            spdlog::info("{}: Connection accepted", __FUNCTION__);
            return SteamUdpSocketImplOnP2PSessionRequest(thisPtr, request);
        }

        if (!cfg.whitelist.empty()) {
            bool found = false;
            for (const auto &v : cfg.whitelist) {
                if (v == clientSteamID) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                spdlog::info("{}: Not in whitelist: {:d}", __FUNCTION__, clientSteamID);
                return;
            }

            return SteamUdpSocketImplOnP2PSessionRequest(thisPtr, request);
        }

        for (const auto &v : cfg.blacklist) {
            if (v == clientSteamID) {
                spdlog::info("{}: In blacklist: {:d}", __FUNCTION__, clientSteamID);
                return;
            }
        }

        return SteamUdpSocketImplOnP2PSessionRequest(thisPtr, request);
    }

    void SetSteamIdHook(void *param, uint64_t *steamID) {
        *steamID = cfg.HostSteamID;
        SetSteamId(param, steamID);
    }

    bool IsConnectReadyHook(void *param) { return true; }

    void UpdateClientEstablishedHook(void *param) {
        if (!sessionConnected) {
            lua_getglobal(luaState, "TppUiCommand");
            lua_getfield(luaState, -1, "AnnounceLogView");
            auto text = "Co-op connection established\0";
            lua_pushstring(luaState, text);
            lua_pcall(luaState, 1, 0, 0);

            sessionConnected = true;
            spdlog::info("{}: Co-op connection established", __FUNCTION__);
        }

        UpdateClientEstablished(param);
    }

    void *MessageBufferAddMessageHook(
        void *thisPtr, void *errCodePtr, uint32_t messageID, uint32_t param_2, uint32_t receiver, uint32_t param_4, void *messageArgs, uint32_t param_6) {
        // RouteEventFaild
        if (messageID == 0x666b8ab8) {
            return MessageBufferAddMessage(thisPtr, errCodePtr, messageID, param_2, receiver, param_4, messageArgs, param_6);
        }

        if (messageDict.size() > 0) {
            spdlog::info("Message: {} ({:x}), from: {} ({:x}), to: {} ({:x}), {} ({:x}), {} ({:x})",
                messageDict[messageID],
                messageID,
                messageDict[param_2],
                param_2,
                messageDict[receiver],
                receiver,
                messageDict[param_4],
                param_4,
                messageDict[param_6],
                param_6);
        }

        // DumpArgs(messageArgs);

        if (messageID == 0x45fdf281) { // PlayerDamaged
            //                auto params = (PlayerDamaged *)messageArgs;
            //                spdlog::info("player damaged: id: {}, attacker: {}, attackID: {}", params->playerIndex, params->playerIndex2,
            //                params->attackID);
        }

        // PutMarkerWithBinocle
        if ((messageID == 0x96544450) && (receiver == 0)) {
        }

        return MessageBufferAddMessage(thisPtr, errCodePtr, messageID, param_2, receiver, param_4, messageArgs, param_6);
    }

    bool AddLocalDamageHook(void *thisPtr, uint32_t playerIndex, PlayerDamage *Damage) {
        if (Damage != nullptr) {
//            DumpDamage(Damage, playerIndex);
        }
        return AddLocalDamage(thisPtr, playerIndex, Damage);
    }

    void DamageControllerImplInitializeHook(void *thisPtr, void *QuarkDesc) {
        DamageControllerImplInitialize(thisPtr, QuarkDesc);
        DamageControllerImpl = (char *)thisPtr + 0x20;
    }

    uint32_t SynchronizerImplGetDamageHook(void *thisPtr, uint32_t objectID, PlayerDamage *damage) {
        auto res = SynchronizerImplGetDamage(thisPtr, objectID, damage);
        if (res != 1) {
            return res;
        }

        if (damage->damageID == DamageID) {
            spdlog::info("got damage! objectID: {}, res: {}, b2 {}, {} {} {}", objectID, res, int(damage->b2), damage->v1.x, damage->v1.y, damage->v1.z);
            if (damage->b2 == DamageProtocolCommand::CMD_IgnoreMe) {
                return res;
            }

            uint32_t playerID;
            GetLocalPlayerId(&playerID);
            if (objectID == playerID) {
                spdlog::info("synchronizer, playerID {}, objectID {}", playerID, objectID);
                // do not create local markers again
                return res;
            }

            // fixed marker
            if (damage->b2 == DamageProtocolCommand::CMD_AddFixedUserMarker) {
                if (ignoreMarkerRequests) {
                    spdlog::info("ignored fixed user marker request");
                    return res;
                }

                auto vv = Vector3{
                    .x = damage->v1.x,
                    .y = damage->v1.y,
                    .z = damage->v1.z,
                };

                spdlog::info("setting fixed network marker at {} {} {}", vv.x, vv.y, vv.z);
                Marker2SystemImplPlacedUserMarkerFixed(MarkerSystemImpl, &vv);
            }

            if (damage->b2 == DamageProtocolCommand::CMD_AddFollowUserMarker) {
                if (ignoreMarkerRequests) {
                    spdlog::info("ignored follow user marker request");
                    return res;
                }

                auto vv = Vector3{
                    .x = damage->v1.x,
                    .y = damage->v1.y,
                    .z = damage->v1.z,
                };

//                DumpDamage(damage, 1);
                unsigned short objectIDMarker = damage->damage_type_flags;
                spdlog::info("adding follow network marker at {} {} {}, object id {} ({})", vv.x, vv.y, vv.z, objectIDMarker, damage->damage_type_flags);
                auto ok = Marker2SystemImplPlacedUserMarkerFollow(MarkerSystemImpl, &vv, objectIDMarker);
                spdlog::info("follow network marker: {}", ok);
            }

            if (damage->b2 == DamageProtocolCommand::CMD_RemoveUserMarker) {
                if (ignoreMarkerRequests) {
                    spdlog::info("ignored remove marker request");
                    return res;
                }

                auto markerID = int(std::round(damage->v1.x));
                spdlog::info("removing network marker, id {}", markerID);
                Marker2SystemImplRemovedUserMarker(MarkerSystemImpl, markerID);
            }

            if (damage->b2 == DamageProtocolCommand::CMD_SetSightMarker) {
                if (ignoreMarkerRequests) {
                    spdlog::info("ignored set sight marker request");
                    return res;
                }

                auto objectIDMarker = damage->damage_type_flags;
                auto duration = damage->v1.x;
                spdlog::info("adding sight marker from network, objectID {}, duration {}", objectIDMarker, duration);
                auto ok = SightManagerImplSetMarker(SightManagerImpl, objectIDMarker, duration);
                spdlog::info("sight marker from network: {}", ok);
            }
        }

        return res;
    }

    void *Marker2SystemImplHook(void *thisPtr) {
        MarkerSystemImpl = thisPtr;
        return Marker2SystemImpl(thisPtr);
    }

    void EquipHudSystemImplInitDataHook(void *thisPtr) {
        EquipHudSystemImpl = thisPtr;
        EquipHudSystemImplInitData(thisPtr);
    }

    void Marker2SystemImplRemovedUserMarkerHook(void *thisPtr, uint32_t markerID) {
        spdlog::info("removing local user marker {}", markerID);
        if (ignoreMarkerRequests) {
            spdlog::info("ignored remove local marker request");
            return;
        }

        Marker2SystemImplRemovedUserMarker(thisPtr, markerID);

        auto d = NewNetworkDamage();
        d.v1.x = markerID;
        d.b2 = DamageProtocolCommand::CMD_RemoveUserMarker;

        uint32_t playerID;
        GetLocalPlayerId(&playerID);
        auto dmgAdd = AddLocalDamageHook(DamageControllerImpl, playerID, &d);
        spdlog::info("network remove marker request: {}", dmgAdd);
    }

    void Marker2SystemImplPlacedUserMarkerFixedHook(void *thisPtr, Vector3 *pos) {
        spdlog::info("placing fixed local user marker at {} {} {}", pos->x, pos->y, pos->z);
        if (ignoreMarkerRequests) {
            spdlog::info("ignored fixed local marker request");
            return;
        }

        uint32_t playerID;
        GetLocalPlayerId(&playerID);

        auto d = new PlayerDamage();
        d->v1.x = pos->x;
        d->v1.y = pos->y;
        d->v1.z = pos->z;
        d->damage_category = 16386;
        d->lethalFlag = 1;
        d->b1 = 3;
        d->b2 = DamageProtocolCommand::CMD_AddFixedUserMarker;
        d->b3 = 0xc8;
        d->damageID = DamageID;

        Marker2SystemImplPlacedUserMarkerFixed(thisPtr, pos);

        if (DamageControllerImpl == nullptr) {
            spdlog::info("damage controller not available, not setting fixed marker over network");
            return;
        }

        auto res = AddLocalDamageHook(DamageControllerImpl, playerID, d);
        spdlog::info("network add fixed marker request: {}", res);
    }

    bool Marker2SystemImplPlacedUserMarkerFollowHook(void *thisPtr, Vector3 *pos, unsigned short objectID) {
        spdlog::info("placing follow local user marker at {} {} {}, objectID {}", pos->x, pos->y, pos->z, objectID);
        if (ignoreMarkerRequests) {
            spdlog::info("ignored follow local marker request");
            return true;
        }

        auto d = NewNetworkDamage();
        d.v1.x = pos->x;
        d.v1.y = pos->y;
        d.v1.z = pos->z;
        d.damage_type_flags = objectID;
        d.b2 = DamageProtocolCommand::CMD_AddFollowUserMarker;

        auto res = Marker2SystemImplPlacedUserMarkerFollow(thisPtr, pos, objectID);
        spdlog::info("place local follow marker for object {}: {}", d.damage_type_flags, res);

        uint32_t playerID;
        GetLocalPlayerId(&playerID);

        auto resDmg = AddLocalDamageHook(DamageControllerImpl, playerID, &d);
        spdlog::info("network add follow marker request: {}", resDmg);
//        DumpDamage(&d, 0);

        return res;
    }

    void SightManagerImplInitializeHook(void *thisPtr, void *QuarkDesc) {
        SightManagerImpl = thisPtr;
        SightManagerImplInitialize(thisPtr, QuarkDesc);
    }

    void UiControllerImplSetNoUseEquipIdHook(void *thisPtr, bool param_1, unsigned int EquipID) {
       EquipID = 9999;
       UiControllerImplSetNoUseEquipId(thisPtr, param_1, EquipID);
    }

    bool EquipCrossEvCallIsItemNoUseHook(void* thisPtr,unsigned int EquipID) {
        return false;
    }
}
