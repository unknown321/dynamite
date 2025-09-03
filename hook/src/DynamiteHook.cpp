#include "DynamiteHook.h"
#include "DamageProtocol.h"
#include "Tpp/TppFOB.h"
#include "Tpp/TppMarkerType.h"
#include "Tpp/TppGameStatusFlag.h"
#include "memtag.h"
#include "mgsvtpp_func_typedefs.h"
#include "spdlog/spdlog.h"
#include "util.h"
#include <filesystem>

namespace Dynamite {
    void *fobTargetCtor = nullptr;

    // entry point
    void __fastcall luaL_openlibsHook(lua_State *L) {
        int Version = 1;
        luaL_openlibs(L);

        lua_pushinteger(L, Version);
        lua_setfield(L, LUA_GLOBALSINDEX, "_Dynamite");

        CreateLibs(L);
        luaState = L;

        messageDict = readMessageDictionary("messageDict.txt");
        pathDict = readPathCodeDictionary("pathDict.txt");

        auto luaLog = "dynamite/lualog.txt";
        if (cfg.debug.luaLog) {
            if (std::filesystem::exists(luaLog)) {
                spdlog::info("truncating lualog.txt");
                std::ofstream ofs(luaLog, std::ios::trunc);
                ofs.close();
            } else {
                spdlog::info("creating lualog.txt");
                std::ofstream f(luaLog);
                f << "";
                f.close();
            }
        } else {
            spdlog::info("removed lualog.txt");
            std::filesystem::remove(luaLog);
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

        if (!cfg.Host) {
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

                spdlog::info("setting fixed network marker at {}, {}, {}", vv.x, vv.y, vv.z);
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
                spdlog::info("adding follow network marker at {}, {}, {}, object id {} ({})", vv.x, vv.y, vv.z, objectIDMarker, damage->damage_type_flags);
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
        spdlog::info("placing fixed local user marker at {}, {}, {}", pos->x, pos->y, pos->z);
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
        spdlog::info("placing follow local user marker at {}, {}, {}, objectID {}", pos->x, pos->y, pos->z, objectID);
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

    bool EquipCrossEvCallIsItemNoUseHook(void *thisPtr, unsigned int EquipID) { return false; }

    std::map<void *, uint32_t> processCount{};
    std::map<void *, std::string> blockNames{};

    // used for debugging, see docs/issue_7.md
    double FoxBlockProcessHook(void *Block, void *TaskContext, void *BlockProcessState) {
        DWORD tid = GetCurrentThreadId();
        if (processCount.contains(Block)) {
            processCount[Block]++;
        } else {
            processCount[Block] = 0;
        }
        if (processCount[Block] % 500 == 0) {
            auto blockName = blockNames[Block];
            uint32_t mem1 = *(int *)((char *)Block + 0x60);
            int32_t mem2 = *(int *)((char *)Block + 0x18);
            int32_t mem3 = *(int *)((char *)Block + 0x40);
            int32_t mem4 = *(int *)((char *)Block + 0x10);
            uint32_t mem5 = *(int *)((char *)Block + 0x148);
            spdlog::info("tid {}, process {} ({}), mem {} {} {} {} {}", tid, blockName, Block, mem1, mem2, mem3, mem4, mem5);
        }

        //        if ((uint)((*(int *)(param_1 + 0x60) - *(int *)(param_1 + 0x18)) + *(int *)(param_1 + 0x40) +
        //                   *(int *)(param_1 + 0x10)) <= *(uint *)(param_1 + 0x148)) {

        return FoxBlockProcess(Block, TaskContext, BlockProcessState);
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockReloadHook(void *Block, int32_t *param_2) {
        DWORD tid = GetCurrentThreadId();
        processCount[Block] = 0;
        auto blockName = blockNames[Block];
        spdlog::info("tid {}, reload {} ({})", tid, blockName, Block);
        return FoxBlockReload(Block, param_2);
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockUnloadHook(void *Block, int32_t *param_2) {
        DWORD tid = GetCurrentThreadId();
        processCount[Block] = 0;
        auto blockName = blockNames[Block];
        auto res = FoxBlockUnload(Block, param_2);
        spdlog::info("tid {}, unload {} ({}), res {}", tid, blockName, Block, *res);
        return res;
    }

    std::string latestGeneratedName;

    // used for debugging, see docs/issue_7.md
    void *FoxGenerateUniqueNameHook(void *sharedString, unsigned long long param_2, void *string) {
        DWORD tid = GetCurrentThreadId();
        spdlog::info("tid {}, generate name: {}", tid, *(char **)*(void **)(string));
        latestGeneratedName = std::string(*(char **)*(void **)(string));

        return FoxGenerateUniqueName(sharedString, param_2, string);
    }

    // used for debugging, see docs/issue_7.md
    void *FoxBlockHook(void *p1) {
        DWORD tid = GetCurrentThreadId();
        spdlog::info("tid {}, block: {} ({})", tid, latestGeneratedName, p1);
        blockNames[p1] = latestGeneratedName;

        return FoxBlock(p1);
    }

    // used for debugging, see docs/issue_7.md
    int32_t blockStatus(void *block) { return *(int32_t *)((char *)block + 0x80); }

    // used for debugging, see docs/issue_7.md
    int32_t blockStatus2(void *block) { return *(int32_t *)((char *)block + 0x84); }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockActivateHook(void *Block, int32_t *param_2) {
        DWORD tid = GetCurrentThreadId();
        auto blockName = blockNames[Block];
        auto q = FoxBlockActivate(Block, param_2);
        spdlog::info("tid {}, activate {} ({}), res {}", tid, blockName, Block, *q);
        spdlog::info("activate block status {} {}", blockStatus(Block), blockStatus2(Block));
        return q;
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockDeactivateHook(void *Block, int32_t *param_2) {
        spdlog::info("deactivating {}", Block);
        auto q = FoxBlockDeactivate(Block, param_2);
        DWORD tid = GetCurrentThreadId();
        auto blockName = blockNames[Block];
        spdlog::info("tid {}, deactivate {} ({}), res {}", tid, blockName, Block, *q);
        spdlog::info("deactivate block status {} {}", blockStatus(Block), blockStatus2(Block));
        return q;
    }

    // used for debugging, see docs/issue_7.md
    int *FoxBlockLoadHook(void *thisPtr, int *errorCode, uint64_t *pathID, uint32_t count) {
        DWORD tid = GetCurrentThreadId();
        auto pp = pathID;
        auto blockName = blockNames[thisPtr];
        if (pathDict.empty()) {
            spdlog::info("tid {}, block {} ({}), loading {:x} ({:d})", tid, blockName, thisPtr, *pp, count);
            return FoxBlockLoad(thisPtr, errorCode, pathID, count);
        }

        for (int i = 0; i < count; i++) {
            auto name = pathDict[*pp];
            if (name.empty()) {
                spdlog::info("tid {}, block {} ({}), loading {:x} ({:d}/{:d})", tid, blockName, thisPtr, *pp, i + 1, count);
            } else {
                spdlog::info("tid {}, block {} ({}), loading {} ({:d}/{})", tid, blockName, thisPtr, name, i + 1, count);
            }
            pp++;
        }
        auto q = FoxBlockLoad(thisPtr, errorCode, pathID, count);
        return q;
    }

    // used for debugging, see docs/issue_7.md
    void *(BlockMemoryAllocTailHook)(void *memBlock, uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag) {
        auto name = blockNames[memBlock];
        spdlog::info("alloc tail: {} ({}), size {}, align {}, category 0x{:x}", name, memBlock, sizeInBytes, alignment, categoryTag);
        return BlockMemoryAllocTail(memBlock, sizeInBytes, alignment, categoryTag);
    }

    // used for debugging, see docs/issue_7.md
    int64_t(__fastcall CreateHostSessionHook)(FobTarget *param) {
        spdlog::info("create host session {}", (void *)param);
        return CreateHostSession(param);
    }

    // issue #7, reuse FobTarget instance created by the game
    FobTarget *FobTargetCtorHook(FobTarget *p) {
        //        spdlog::info("fob target ctor: {}", (void *)p);
        fobTargetCtor = FobTargetCtor(p);
        return (FobTarget *)fobTargetCtor;
    }

    bool blockHeapAllocLoginUtilityCalled = false;

    // issue #7 workaround, force network allocations on heap when called from lua instead of current block
    // see docs/issue_7.md
    void *BlockHeapAllocHook(uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag) {
        if (!cfg.Host) {
            return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
        }

        if (categoryTag != MEMTAG_TPP_NETWORK) {
            return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
        }

        spdlog::info("alloc MEMTAG_TPP_NETWORK");
        if (blockHeapAllocLoginUtilityCalled) {
            spdlog::info("{}, alloc MEMTAG_TPP_NETWORK force on heap", __FUNCTION__);
            return BlockMemoryAllocHeap(sizeInBytes, alignment, categoryTag);
        }

        blockHeapAllocLoginUtilityCalled = true;
        spdlog::info("{}, alloc MEMTAG_TPP_NETWORK run as is", __FUNCTION__);

        return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
    }

    void *CloseSessionHook() {
        spdlog::info("{}, closing session", __FUNCTION__);
        if (cfg.Host) {
            hostSessionCreated = false;
        }
        return CloseSession();
    }

    void ScriptDeclVarsImplSetVarValueHook(void *thisPtr, uint32_t param_1, uint32_t param_2, bool param_3, ScriptVarValue value) {
        auto nameStr32 = *(uint32_t *)((char *)thisPtr + 0x18 + param_2 * 0x18);
        auto name = messageDict[nameStr32];
        spdlog::info("set var {} (0x{:x}) = {:f}, 0x{:x}, 0x{:x}, 0x{:x}", name, nameStr32, value.value, param_1, param_2, param_3);
        ScriptDeclVarsImplSetVarValue(thisPtr, param_1, param_2, param_3, value);
    }

    void SoldierRouteAiImplPreUpdateHook(void *thisPtr, uint32_t param_1, void *AiNodeUpdateContext) {
        auto qq = *((char *)AiNodeUpdateContext + 0x26);
        byte v = (byte)qq;
        spdlog::info("{}, {} {:x} {:d}", __FUNCTION__, AiNodeUpdateContext, qq, v);
        SoldierRouteAiImplPreUpdate(thisPtr, param_1, AiNodeUpdateContext);
    }

    uint32_t RouteGroupImplGetEventIdHook(void *RouteGroupImpl, unsigned short param_1, unsigned short param_2, unsigned short param_3) {
        auto res = RouteGroupImplGetEventId(RouteGroupImpl, param_1, param_2, param_3);
        auto name = messageDict[res];
        switch (res) {
        case 0xef94dd47:
        case 0xd90e0e31:
        case 0xeafe50df:
        case 0x596c1d5a:
        case 0x57c44b72:
        case 0xa6f6bf5c:
            return res;
        }
        spdlog::info("{}: {} (0x{:x}), {:d}, {:d}, {:d}", __FUNCTION__, name, res, param_1, param_2, param_3);
        return res;
    }

    fox::QuarkHandle FoxCreateQuarkHook(uint64_t param_1, fox::QuarkDesc *quarkDesc, uint64_t p3) {
        auto res = FoxCreateQuark(param_1, quarkDesc, p3);
        spdlog::info("{} {} (0x{:x}), handle 0x{:x}", __FUNCTION__, pathDict[(uint64_t)quarkDesc], (uint64_t)quarkDesc, res.value);
        quarkHandles[res.value] = pathDict[(uint64_t)quarkDesc];
        return res;
    }

    void AiControllerImplAddNodeHook(void *thisPtr, uint32_t param_2, uint64_t quarkHandle, uint32_t param_4) {
        spdlog::info("{}, p2: {:x}, handle {} (0x{:x}), p4: {:x}", __FUNCTION__, param_2, quarkHandles[quarkHandle], quarkHandle, param_4);
        AiControllerImplAddNode(thisPtr, param_2, quarkHandle, param_4);
    }

    void AiControllerImplSleepNodeHook(void *AiControllerImpl, uint32_t param_1, int param_2, int32_t SleepCause) {
        spdlog::info("{}, {:x}, {:x}, cause: {:x}", __FUNCTION__, param_1, param_2, SleepCause);
        AiControllerImplSleepNode(AiControllerImpl, param_1, param_2, SleepCause);
    }

    void AiControllerImplWakeNodeHook(void *AiControllerImpl, uint32_t param_1, int param_2, uint32_t param_3) {
        spdlog::info("{}, {:x}, {:x}, {:x}", __FUNCTION__, param_1, param_2, param_3);
        AiControllerImplWakeNode(AiControllerImpl, param_1, param_2, param_3);
    }

    unsigned short CoreAiImplGetVehicleIdHook(void *thisPtr, unsigned short *param_2, uint32_t param_3) {
        auto res = CoreAiImplGetVehicleId(thisPtr, param_2, param_3);
        if (*param_2 == 65535) {
            return res;
        }

        spdlog::info("{}: {} {} -> {}", __FUNCTION__, *param_2, param_3, res);
        return res;
    }

    unsigned char CoreAiImplGetVehicleRideStateHook(void *thisPtr, uint32_t param_1) {
        auto res = CoreAiImplGetVehicleRideState(thisPtr, param_1);
        spdlog::info("{}, {} -> {}", __FUNCTION__, param_1, static_cast<uint32_t>(res));
        return res;
    }

    bool CoreAiImplIsVehicleRetainHook(void *thisPtr, uint32_t param_1) {
        auto res = CoreAiImplIsVehicleRetain(thisPtr, param_1);
        spdlog::info("{}, {} -> {}", __FUNCTION__, param_1, res);
        return res;
    }

    bool SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStepHook(
        void *RouteAiImpl, uint32_t param_1, void *RouteAiKnowledge, bool param_3, bool param_4, bool param_5, bool param_6) {
        auto res = SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStep(RouteAiImpl, param_1, RouteAiKnowledge, param_3, param_4, param_5, param_6);
        spdlog::info("{}, p1: {}, p3: {}, p4: {}, p5: {}, p6: {}, res: {}", __FUNCTION__, param_1, param_3, param_4, param_5, param_6, res);
        return res;
    }

    bool StatusControllerImplIsSetHook(void *StatusControllerImpl, unsigned char param_1) {
        auto res = StatusControllerImplIsSet(StatusControllerImpl, param_1);
        if (param_1 == TppGameStatusFlag::S_IS_ONLINE) {
            spdlog::info("{}, {} -> {}", __FUNCTION__, "S_IS_ONLINE", res);
        }
        return res;
    }
}
