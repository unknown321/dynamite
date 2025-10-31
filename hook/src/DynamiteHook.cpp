#include "DynamiteHook.h"

#include "BlockInfo.h"
#include "BossQuietNextActionTaskActionCondition.h"
#include "DynamiteLua.h"
#include "Tpp/TppFOB.h"
#include "Tpp/TppGameStatusFlag.h"
#include "Tpp/TppMarkerType.h"
#include "dynamite.h"
#include "memtag.h"
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
        hookState.luaState = L;

        g_hook->messageDict = readMessageDictionary("strcode32hex.txt");
        g_hook->pathDict = readPathCodeDictionary("pathfilenamecode64.txt"); // pathfilenamecode64 in HashWrangler

        auto luaLog = "dynamite/lualog.txt";
        if (g_hook->cfg.debug.luaLog) {
            if (std::filesystem::exists(luaLog)) {
                spdlog::info("{}, truncating lualog.txt", __PRETTY_FUNCTION__);
                std::ofstream ofs(luaLog, std::ios::trunc);
                ofs.close();
            } else {
                spdlog::info("{}, creating lualog.txt", __PRETTY_FUNCTION__);
                std::ofstream f(luaLog);
                f << "";
                f.close();
            }
        } else {
            spdlog::info("{}, removed lualog.txt", __PRETTY_FUNCTION__);
            std::filesystem::remove(luaLog);
        }
    }

    bool IsDefenseTeamByOnlineFobLocalHook() { return false; }

    bool IsOffenseTeamByOnlineFobLocalHook() { return true; }

    unsigned int GetFobOffensePlayerInstanceIndexHook(void *) { return g_hook->dynamiteCore.GetOffensePlayerID(); }

    unsigned int GetFobDefensePlayerInstanceIndexHook(void *) { return g_hook->dynamiteCore.GetDefensePlayerID(); }

    unsigned int GetUiMarkerTypeFromSystemType2Hook(void *p1, void *p2) {
        const auto res = GetUiMarkerTypeFromSystemType2(p1, p2);
        if (res == TppMarkerType::MARKER_TYPE_FOB_ENEMY) {
            return TppMarkerType::MARKER_TYPE_BUDDY_D_DOG;
        }

        return res;
    }

    bool SightManagerImplSetMarkerHook(void *thisPtr, unsigned short objectID, float duration) {
        spdlog::info("{}, SightManagerImpl={}, objectID={}, duration={}", __PRETTY_FUNCTION__, thisPtr, objectID, duration);
        // this is a player object
        if (objectID <= SESSION_CLIENTS_MAX) {
            duration = 9999999;
        }

        const auto res = SightManagerImplSetMarker(thisPtr, objectID, duration);
        if (!res) {
            spdlog::error("{}: false, objectID {}, duration {}", __PRETTY_FUNCTION__, objectID, duration);
            return res;
        }

        g_hook->dynamiteSyncImpl.SetSightMarker(objectID, duration);

        return res;
    }

    void SteamUdpSocketImplOnP2PSessionRequestHook(void *thisPtr, void *request) {
        auto clientSteamID = *(uint64_t *)request;
        spdlog::info("{}: Connection request: {:d}", __PRETTY_FUNCTION__, clientSteamID);

        if (!g_hook->cfg.Host) {
            spdlog::warn("client, but there was a connection attempt?");
        }

        if ((g_hook->cfg.whitelist.empty()) && (g_hook->cfg.blacklist.empty())) {
            spdlog::info("{}: Connection accepted", __PRETTY_FUNCTION__);
            SteamUdpSocketImplOnP2PSessionRequest(thisPtr, request);
            return;
        }

        if (!g_hook->cfg.whitelist.empty()) {
            bool found = false;
            for (const auto &v : g_hook->cfg.whitelist) {
                if (v == clientSteamID) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                spdlog::info("{}: Not in whitelist: {:d}", __PRETTY_FUNCTION__, clientSteamID);
                return;
            }

            SteamUdpSocketImplOnP2PSessionRequest(thisPtr, request);
            return;
        }

        for (const auto &v : g_hook->cfg.blacklist) {
            if (v == clientSteamID) {
                spdlog::info("{}: In blacklist: {:d}", __PRETTY_FUNCTION__, clientSteamID);
                return;
            }
        }

        SteamUdpSocketImplOnP2PSessionRequest(thisPtr, request);
    }

    void SetSteamIdHook(void *param, uint64_t *steamID) {
        *steamID = g_hook->cfg.HostSteamID;
        SetSteamId(param, steamID);
    }

    bool IsConnectReadyHook(void *param) { return true; }

    void UpdateClientEstablishedHook(void *param) {
        if (!g_hook->dynamiteCore.GetSessionConnected()) {
            lua_getglobal(hookState.luaState, "TppUiCommand");
            lua_getfield(hookState.luaState, -1, "AnnounceLogViewLangId");
            const auto text = "dynamite_connection_established\0";
            lua_pushstring(hookState.luaState, text);
            lua_pcall(hookState.luaState, 1, 0, 0);

            g_hook->dynamiteCore.SetSessionConnected(true);
            spdlog::info("{}: Co-op connection established", __PRETTY_FUNCTION__);

            // FIXME
            // gamesocket is deprecated
            if (g_hook->dynamiteSyncImpl.gameSocket == nullptr) {
                g_hook->dynamiteSyncImpl.Init();
                g_hook->dynamiteSyncImpl.SyncInit();
            }

            g_hook->dynamiteSyncImpl.Ping();
            g_hook->dynamiteSyncImpl.SendEmblem();
        }

        UpdateClientEstablished(param);
    }

    void *MessageBufferAddMessageHook(
        void *thisPtr, void *errCodePtr, uint32_t messageID, uint32_t sender, uint32_t receiver, uint32_t param_4, void *messageArgs, uint32_t param_6) {

        if (g_hook->messageDict.size() > 0) {
            spdlog::info("Message: {} ({:x}), from: {} ({:x}), to: {} ({:x}), {} ({:x}), {} ({:x})",
                g_hook->messageDict[messageID],
                messageID,
                g_hook->messageDict[sender],
                sender,
                g_hook->messageDict[receiver],
                receiver,
                g_hook->messageDict[param_4],
                param_4,
                g_hook->messageDict[param_6],
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

        return MessageBufferAddMessage(thisPtr, errCodePtr, messageID, sender, receiver, param_4, messageArgs, param_6);
    }

    bool AddLocalDamageHook(void *thisPtr, const uint32_t playerIndex, PlayerDamage *Damage) {
        if (Damage != nullptr) {
            //            DumpDamage(Damage, playerIndex);
        }
        return AddLocalDamage(thisPtr, playerIndex, Damage);
    }

    void DamageControllerImplInitializeHook(void *thisPtr, void *QuarkDesc) {
        DamageControllerImplInitialize(thisPtr, QuarkDesc);
        hookState.damageControllerImpl = (char *)thisPtr + 0x20;
    }

    void *Marker2SystemImplHook(void *thisPtr) {
        hookState.markerSystemImpl = thisPtr;
        return Marker2SystemImpl(thisPtr);
    }

    void EquipHudSystemImplInitDataHook(void *thisPtr) {
        hookState.equipHudSystemImpl = thisPtr;
        EquipHudSystemImplInitData(thisPtr);
    }

    void Marker2SystemImplRemovedUserMarkerHook(void *thisPtr, uint32_t markerID) {
        spdlog::info("{}: {}", __PRETTY_FUNCTION__, markerID);
        if (hookState.ignoreMarkerRequests) {
            spdlog::info("{}, ignored remove local marker request", __PRETTY_FUNCTION__);
            return;
        }

        Marker2SystemImplRemovedUserMarker(thisPtr, markerID);
        g_hook->dynamiteSyncImpl.RemoveUserMarker(markerID);
    }

    void Marker2SystemImplPlacedUserMarkerFixedHook(void *thisPtr, Vector3 *pos) {
        spdlog::info("{}, placing fixed local user marker at {}, {}, {}", __PRETTY_FUNCTION__, pos->x, pos->y, pos->z);
        if (hookState.ignoreMarkerRequests) {
            spdlog::info("{}, ignored fixed local marker request", __PRETTY_FUNCTION__);
            return;
        }

        Marker2SystemImplPlacedUserMarkerFixed(thisPtr, pos);
        g_hook->dynamiteSyncImpl.AddFixedUserMarker(pos);
    }

    bool Marker2SystemImplPlacedUserMarkerFollowHook(void *thisPtr, Vector3 *pos, unsigned short objectID) {
        spdlog::info("{}, {}, {}, {}, objectID {}", __PRETTY_FUNCTION__, pos->x, pos->y, pos->z, objectID);
        if (hookState.ignoreMarkerRequests) {
            spdlog::info("{}, ignored follow local marker request", __PRETTY_FUNCTION__);
            return true;
        }

        const auto res = Marker2SystemImplPlacedUserMarkerFollow(thisPtr, pos, objectID);
        g_hook->dynamiteSyncImpl.AddFollowUserMarker(pos, objectID);

        return res;
    }

    void SightManagerImplInitializeHook(void *thisPtr, void *QuarkDesc) {
        SightManagerImplInitialize(thisPtr, QuarkDesc);
        hookState.sightManagerImpl = thisPtr;
    }

    void UiControllerImplSetNoUseEquipIdHook(void *thisPtr, const bool param_1, unsigned int EquipID) {
        EquipID = 9999;
        UiControllerImplSetNoUseEquipId(thisPtr, param_1, EquipID);
    }

    bool EquipCrossEvCallIsItemNoUseHook(void *thisPtr, unsigned int EquipID) { return false; }

    // used for debugging, see docs/issue_7.md
    double FoxBlockProcessHook(void *Block, void *TaskContext, void *BlockProcessState) {
        DWORD tid = GetCurrentThreadId();
        if (hookState.processCounter.contains(Block)) {
            hookState.processCounter[Block].counter++;
        } else {
            hookState.processCounter[Block].counter = 0;
            hookState.processCounter[Block].blockState = 0;
        }

        uint32_t blockState = *(uint32_t *)((char *)Block + 0x84);
        if ((hookState.processCounter[Block].counter % 500 == 0) || (hookState.processCounter[Block].blockState != blockState)) {
            auto blockName = hookState.blockNames[Block];
            uint32_t mem1 = *(int *)((char *)Block + 0x60);
            int32_t mem2 = *(int *)((char *)Block + 0x18);
            int32_t mem3 = *(int *)((char *)Block + 0x40);
            int32_t mem4 = *(int *)((char *)Block + 0x10);
            uint32_t mem5 = *(int *)((char *)Block + 0x148);
            hookState.processCounter[Block].blockState = blockState;
            auto processTime = *(double *)((char *)BlockProcessState + 0x28);
            int64_t total = mem1 - mem2 + mem3 + mem4;
            spdlog::info("{}, tid {}, process {} ({}), state {}, time {}, mem {} - {} + {} + {} = {} ({})",
                __PRETTY_FUNCTION__,
                tid,
                blockName,
                Block,
                blockState,
                processTime,
                mem1,
                mem2,
                mem3,
                mem4,
                total,
                mem5);
        }

        //        if ((uint)((*(int *)(param_1 + 0x60) - *(int *)(param_1 + 0x18)) + *(int *)(param_1 + 0x40) +
        //                   *(int *)(param_1 + 0x10)) <= *(uint *)(param_1 + 0x148)) {

        return FoxBlockProcess(Block, TaskContext, BlockProcessState);
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockReloadHook(void *Block, int32_t *param_2) {
        DWORD tid = GetCurrentThreadId();
        hookState.processCounter[Block].counter = 0;
        auto blockName = hookState.blockNames[Block];
        spdlog::info("{}, tid {}, reload {} ({})", __PRETTY_FUNCTION__, tid, blockName, Block);
        return FoxBlockReload(Block, param_2);
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockUnloadHook(void *Block, int32_t *param_2) {
        DWORD tid = GetCurrentThreadId();
        hookState.processCounter[Block].counter = 0;
        auto blockName = hookState.blockNames[Block];
        auto res = FoxBlockUnload(Block, param_2);
        spdlog::info("{}, tid {}, unload {} ({}), res {}", __PRETTY_FUNCTION__, tid, blockName, Block, *res);
        return res;
    }

    // used for debugging, see docs/issue_7.md
    void *FoxGenerateUniqueNameHook(void *sharedString, unsigned long long param_2, void *string) {
        DWORD tid = GetCurrentThreadId();
        spdlog::info("{}, tid {}, generate name: {}", __PRETTY_FUNCTION__, tid, *(char **)*(void **)(string));
        hookState.latestGeneratedName = std::string(*(char **)*(void **)(string));

        return FoxGenerateUniqueName(sharedString, param_2, string);
    }

    // used for debugging, see docs/issue_7.md
    void *FoxBlockHook(void *p1) {
        DWORD tid = GetCurrentThreadId();
        spdlog::info("{}, tid {}, block: {} ({})", __PRETTY_FUNCTION__, tid, hookState.latestGeneratedName, p1);
        hookState.blockNames[p1] = hookState.latestGeneratedName;

        return FoxBlock(p1);
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockActivateHook(void *Block, int32_t *param_2) {
        DWORD tid = GetCurrentThreadId();
        auto blockName = hookState.blockNames[Block];
        auto q = FoxBlockActivate(Block, param_2);
        spdlog::info("{}, tid {}, activate {} ({}), res {}", __PRETTY_FUNCTION__, tid, blockName, Block, *q);
        spdlog::info("{}, {}, activate block status {} {}", __PRETTY_FUNCTION__, blockName, blockStatus(Block), blockStatus2(Block));
        return q;
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockDeactivateHook(void *Block, int32_t *param_2) {
        spdlog::info("{} deactivating {}", __PRETTY_FUNCTION__, Block);
        auto q = FoxBlockDeactivate(Block, param_2);
        DWORD tid = GetCurrentThreadId();
        auto blockName = hookState.blockNames[Block];
        spdlog::info(
            "{}, tid {}, deactivate {} ({}), res {}, status {} {}", __PRETTY_FUNCTION__, tid, blockName, Block, *q, blockStatus(Block), blockStatus2(Block));
        return q;
    }

    // used for debugging, see docs/issue_7.md
    int *FoxBlockLoadHook(void *thisPtr, int *errorCode, uint64_t *pathID, uint32_t count) {
        DWORD tid = GetCurrentThreadId();
        auto pp = pathID;
        auto blockName = hookState.blockNames[thisPtr];
        if (g_hook->pathDict.empty()) {
            spdlog::info("{}, tid {}, block {} ({}), loading {:x} ({:d})", __PRETTY_FUNCTION__, tid, blockName, thisPtr, *pp, count);
            return FoxBlockLoad(thisPtr, errorCode, pathID, count);
        }

        for (int i = 0; i < count; i++) {
            auto name = g_hook->pathDict[*pp];
            if (name.empty()) {
                spdlog::info("{}, tid {}, block {} ({}), loading {:x} ({:d}/{:d})", __PRETTY_FUNCTION__, tid, blockName, thisPtr, *pp, i + 1, count);
            } else {
                spdlog::info("{}, tid {}, block {} ({}), loading {} ({:d}/{})", __PRETTY_FUNCTION__, tid, blockName, thisPtr, name, i + 1, count);
            }
            pp++;
        }

        const auto res = FoxBlockLoad(thisPtr, errorCode, pathID, count);
        return res;
    }

    // used for debugging, see docs/issue_7.md
    void *BlockMemoryAllocTailHook(void *memBlock, uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag) {
        auto name = hookState.blockNames[memBlock];
        spdlog::info("alloc tail: {} ({}), size {}, align {}, category 0x{:x}", name, memBlock, sizeInBytes, alignment, categoryTag);
        return BlockMemoryAllocTail(memBlock, sizeInBytes, alignment, categoryTag);
    }

    // used for debugging, see docs/issue_7.md
    int64_t CreateHostSessionHook(FobTarget *param) {
        spdlog::info("create host session {}", (void *)param);
        return CreateHostSession(param);
    }

    // issue #7, reuse FobTarget instance created by the game
    FobTarget *FobTargetCtorHook(FobTarget *p) {
        //        spdlog::info("fob target ctor: {}", (void *)p);
        hookState.fobTargetCtor = FobTargetCtor(p);
        return (FobTarget *)hookState.fobTargetCtor;
    }

    void *BlockHeapAllocHook(const uint64_t sizeInBytes, const uint64_t alignment, const uint32_t categoryTag) {
        if (categoryTag == MEMTAG_TPP_SYSTEM2SCRIPT) {
            // spdlog::info("{}, allocating {} bytes, {} align, category MEMTAG_TPP_SYSTEM2SCRIPT", __PRETTY_FUNCTION__, sizeInBytes, alignment);
            return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
        }

        if (!g_hook->cfg.Host) {
            return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
        }

        if (categoryTag == MEMTAG_NETWORK_NT_SYSTEM) {
            // spdlog::info("{}, allocating {} bytes, {} align, category MEMTAG_NETWORK_NT_SYSTEM", __PRETTY_FUNCTION__, sizeInBytes, alignment);
            return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
        }

        if (categoryTag != MEMTAG_TPP_NETWORK) {
            return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
        }

        // issue #7 workaround, force network allocations on heap when called from lua instead of current block
        // see docs/issue_7.md
        if (hookState.blockHeapAllocLoginUtilityCalled) {
            spdlog::info("{}, alloc MEMTAG_TPP_NETWORK force on heap", __PRETTY_FUNCTION__);
            return BlockMemoryAllocHeap(sizeInBytes, alignment, categoryTag);
        }

        hookState.blockHeapAllocLoginUtilityCalled = true;
        spdlog::info("{}, alloc MEMTAG_TPP_NETWORK run as is", __PRETTY_FUNCTION__);

        return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
    }

    void *CloseSessionHook() {
        spdlog::info("{}, closing session", __PRETTY_FUNCTION__);
        if (g_hook->cfg.Host) {
            g_hook->dynamiteCore.SetHostSessionCreated(false);
        }

        g_hook->dynamiteSyncImpl.Stop();
        g_hook->dynamiteCore.SetEmblemCreated(false);

        return CloseSession();
    }

    void ScriptDeclVarsImplSetVarValueHook(void *thisPtr, uint64_t index, uint32_t param_2, uint32_t param_3, uint32_t value) {
        const auto tp = (char *)thisPtr + 0x18;
        auto hash = *(uint32_t *)(*(char **)tp + 0xc + index * 0x18 + -0x4);

        spdlog::info("{} {} (0x{:x}) = p1 = 0x{:x}, p2 = 0x{:x}, p3 = 0x{:x}, value = 0x{:x}",
            __PRETTY_FUNCTION__,
            g_hook->messageDict[hash],
            hash,
            index,
            param_2,
            param_3,
            value);

        ScriptDeclVarsImplSetVarValue(thisPtr, index, param_2, param_3, value);
    }

    void SoldierRouteAiImplPreUpdateHook(void *thisPtr, const uint32_t param_1, void *AiNodeUpdateContext) {
        auto qq = *((char *)AiNodeUpdateContext + 0x26);
        auto v = (unsigned char)qq;
        spdlog::info("{}, {} {:x} {:d}", __PRETTY_FUNCTION__, AiNodeUpdateContext, qq, v);
        SoldierRouteAiImplPreUpdate(thisPtr, param_1, AiNodeUpdateContext);
    }

    uint32_t RouteGroupImplGetEventIdHook(void *RouteGroupImpl, unsigned short param_1, unsigned short param_2, unsigned short param_3) {
        auto res = RouteGroupImplGetEventId(RouteGroupImpl, param_1, param_2, param_3);
        switch (res) {
        case 0xef94dd47: // RelaxedIdleAct
        case 0xd90e0e31: // RelaxedStandWalkAct
        case 0xeafe50df: // RelaxedStandIdle
        case 0x596c1d5a: // RelaxedWalk
        case 0x57c44b72: // RelaxedWalkAct
        case 0xa6f6bf5c: // RelaxedRun
            return res;
        default:
            break;
        }

        auto name = g_hook->messageDict[res];
        spdlog::info("{}: {} (0x{:x}), {:d}, {:d}, {:d}", __PRETTY_FUNCTION__, name, res, param_1, param_2, param_3);

        return res;
    }

    fox::QuarkHandle FoxCreateQuarkHook(uint64_t param_1, fox::QuarkDesc *quarkDesc, uint64_t p3) {
        auto res = FoxCreateQuark(param_1, quarkDesc, p3);
        spdlog::info("{} {} (0x{:x}), p3 {:x}, handle 0x{:x}", __PRETTY_FUNCTION__, g_hook->pathDict[(uint64_t)quarkDesc], (uint64_t)quarkDesc, p3, res.value);
        hookState.quarkHandles[res.value] = g_hook->pathDict[(uint64_t)quarkDesc];
        return res;
    }

    void AiControllerImplAddNodeHook(void *thisPtr, uint32_t param_2, uint64_t quarkHandle, uint32_t param_4) {
        spdlog::info("{}, p2: {:x}, handle {} (0x{:x}), p4: {:x}", __PRETTY_FUNCTION__, param_2, hookState.quarkHandles[quarkHandle], quarkHandle, param_4);
        AiControllerImplAddNode(thisPtr, param_2, quarkHandle, param_4);
    }

    void AiControllerImplSleepNodeHook(void *AiControllerImpl, uint32_t param_1, int param_2, int32_t SleepCause) {
        spdlog::info("{}, {:x}, {:x}, cause: {:x}", __PRETTY_FUNCTION__, param_1, param_2, SleepCause);
        AiControllerImplSleepNode(AiControllerImpl, param_1, param_2, SleepCause);
    }

    void AiControllerImplWakeNodeHook(void *AiControllerImpl, uint32_t param_1, int param_2, uint32_t param_3) {
        spdlog::info("{}, {:x}, {:x}, {:x}", __PRETTY_FUNCTION__, param_1, param_2, param_3);
        AiControllerImplWakeNode(AiControllerImpl, param_1, param_2, param_3);
    }

    unsigned short CoreAiImplGetVehicleIdHook(void *thisPtr, unsigned short *param_2, uint32_t param_3) {
        auto res = CoreAiImplGetVehicleId(thisPtr, param_2, param_3);
        if (*param_2 == 65535) {
            return res;
        }

        spdlog::info("{}: {} {} -> {}", __PRETTY_FUNCTION__, *param_2, param_3, res);
        return res;
    }

    unsigned char CoreAiImplGetVehicleRideStateHook(void *thisPtr, uint32_t param_1) {
        const auto res = CoreAiImplGetVehicleRideState(thisPtr, param_1);
        spdlog::info("{}, {} -> {}", __PRETTY_FUNCTION__, param_1, static_cast<uint32_t>(res));

        return res;
    }

    bool CoreAiImplIsVehicleRetainHook(void *thisPtr, uint32_t param_1) {
        const auto res = CoreAiImplIsVehicleRetain(thisPtr, param_1);
        spdlog::info("{}, {} -> {}", __PRETTY_FUNCTION__, param_1, res);

        return res;
    }

    bool SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStepHook(
        void *RouteAiImpl, uint32_t param_1, void *RouteAiKnowledge, bool param_3, bool param_4, bool param_5, bool param_6) {
        const auto res =
            SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStep(RouteAiImpl, param_1, RouteAiKnowledge, param_3, param_4, param_5, param_6);
        spdlog::info("{}, p1: {}, p3: {}, p4: {}, p5: {}, p6: {}, res: {}", __PRETTY_FUNCTION__, param_1, param_3, param_4, param_5, param_6, res);

        return res;
    }

    bool StatusControllerImplIsSetHook(void *StatusControllerImpl, unsigned char param_1) {
        const auto res = StatusControllerImplIsSet(StatusControllerImpl, param_1);
        if (param_1 == TppGameStatusFlag::S_IS_ONLINE) {
            spdlog::info("{}, {} -> {}", __PRETTY_FUNCTION__, "S_IS_ONLINE", res);
        }

        return res;
    }

    void *ScriptDeclVarsImplGetVarHandleWithVarIndexHook(void *ScriptDeclVarsImpl, void *param_1, uint32_t param_2) {
        const auto res = ScriptDeclVarsImplGetVarHandleWithVarIndex(ScriptDeclVarsImpl, param_1, param_2);

        const auto varsInfo = GmGetScriptVarInfo();
        const auto tp = (char *)varsInfo + 0x8;
        const auto hash = *(uint32_t *)(*(char **)tp + param_2 * 0x18 + 0x10);

        spdlog::info("{} {} 0x{:x} {} {} (0x{:x})", __PRETTY_FUNCTION__, param_1, param_2, res, g_hook->messageDict[hash], hash);

        return res;
    }

    int32_t BandWidthManagerImplCalcAverageRttOfBetterHalfConnectionHook(void *thisPtr) {
        const auto res = BandWidthManagerImplCalcAverageRttOfBetterHalfConnection(thisPtr);
        if (res != 0) {
            spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
        }

        return res;
    }

    int32_t BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnectionHook(void *thisPtr) {
        const auto res = BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnection(thisPtr);
        if (res != 0) {
            spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
        }

        return res;
    }

    void BandWidthManagerImplStartLimitStateHook(void *thisPtr) {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        BandWidthManagerImplStartLimitState(thisPtr);
    }

    uint32_t FoxNioMpMessageContainerGetFreeSizeHook(void *MpMessageContainer) {
        auto res = FoxNioMpMessageContainerGetFreeSize(MpMessageContainer);
        spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
        return res;
    }

    int32_t FoxNioImplMpMuxImplSendHook(
        void *MpMuxImpl, unsigned short param_1, unsigned char param_2, void *param_3, int size, void *SppInfo, unsigned short param_6) {
        // spdlog::info("{}: message container {}", __PRETTY_FUNCTION__, *(void **)((char *)MpMuxImpl + 0x468));
        auto res = FoxNioImplMpMuxImplSend(MpMuxImpl, param_1, param_2, param_3, size, SppInfo, param_6);

        if (g_hook->cfg.debug.muxSendError) {
            if (res < 0) {
                spdlog::info("{} fail: p1={}, p2={}, p3={}, size={}, p6={}, res {}", __PRETTY_FUNCTION__, param_1, param_2, param_3, size, param_6, res);
            }
            return res;
        }

        if (res < 0) {
            spdlog::info("{} fail: p1={}, p2={}, p3={}, size={}, p6={}, res {}", __PRETTY_FUNCTION__, param_1, param_2, param_3, size, param_6, res);
        } else {
            spdlog::info("{} ok: p1={}, p2={}, p3={}, size={}, p6={}, res {}", __PRETTY_FUNCTION__, param_1, param_2, param_3, size, param_6, res);
        }
        return res;
    }

    int32_t FoxNioImplMpMuxImplRecv1Hook(void *MpMuxImpl, unsigned short param_1, void *Buffer, void *SppInfo, unsigned short param_4) {
        auto res = FoxNioImplMpMuxImplRecv1(MpMuxImpl, param_1, Buffer, SppInfo, param_4);
        spdlog::info("{}: p1={}, p4={}, res {}", __PRETTY_FUNCTION__, param_1, param_4, res);
        return res;
    }

    int32_t FoxNioImplMpMuxImplRecv2Hook(void *MpMuxImpl, unsigned short param_1, void *param_2, int param_3, void *param_4, unsigned short param_5) {
        auto res = FoxNioImplMpMuxImplRecv2(MpMuxImpl, param_1, param_2, param_3, param_4, param_5);
        spdlog::info("{}: p1={}, p2={}, p3={}, p4={}, p5={}, res {}", __PRETTY_FUNCTION__, param_1, param_2, param_3, param_4, param_5, res);
        return res;
    }

    int32_t FoxNtPeerControllerSendHook(void *PeerController, uint32_t param_1, int param_2, int param_3) {
        // auto pp1 = *(uint64_t *)((char *)PeerController + 0x28);
        // auto pp2 = pp1 + *(uint32_t *)((char *)PeerController + 0x20);
        // spdlog::info("{}, pp1={:x}, pp2={:x}", __PRETTY_FUNCTION__, pp1, pp2);
        // auto len = pp2 - pp1;
        // for (int i = 0; i < len; i++) {
        //     auto v = *(uint64_t *)((char *)PeerController + 0x28 + 8 * i);
        //     spdlog::info("{} subcontroller {}: {:x} ({})", __PRETTY_FUNCTION__, i, v, (void *)((char *)PeerController + 0x28 + 8 * i));
        //     auto qq = (void *)v;
        //     if (qq != nullptr) {
        //         spdlog::info("{}, {} ok", __PRETTY_FUNCTION__, i);
        //     } else {
        //         spdlog::info("{}, {} not ok", __PRETTY_FUNCTION__, i);
        //     }
        // }
        auto res = FoxNtPeerControllerSend(PeerController, param_1, param_2, param_3);
        spdlog::info("{}, p1={}, p2={}, p3={}, res={}", __PRETTY_FUNCTION__, param_1, param_2, param_3, res);
        return res;
    }

    bool FoxNtImplGameSocketImplPeerIsSendPacketEmptyHook(void *Peer) {
        auto res = FoxNtImplGameSocketImplPeerIsSendPacketEmpty(Peer);
        spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
        return res;
    }

    int FoxNtTotalControllerSendHook(void *TotalController, uint32_t param_1, int32_t param_2, int32_t param_3) {
        auto res = FoxNtTotalControllerSend(TotalController, param_1, param_2, param_3);
        spdlog::info("{}, p1={}, p2={}, p3={}, res={}", __PRETTY_FUNCTION__, param_1, param_2, param_3, res);
        return res;
    }

    int FoxNtImplTransceiverManagerImplPeerSendHook(void *TransceiverManagerImpl, uint32_t param_1, int32_t param_2, int32_t param_3) {
        auto res = FoxNtImplTransceiverManagerImplPeerSend(TransceiverManagerImpl, param_1, param_2, param_3);
        spdlog::info("{}, res={}, p1={}, p2={}, p3={}", __PRETTY_FUNCTION__, res, param_1, param_2, param_3);
        return res;
    }

    int FoxNioImplMpSocketImplSendHook(void *MpSocketImpl, void *param_1, int size, void *Info, void *Address) {
        auto res = FoxNioImplMpSocketImplSend(MpSocketImpl, param_1, size, Info, Address);
        if (res < 0) {
            spdlog::info("{} fail, p1={}, size={}, info={}, address={}, res={}", __PRETTY_FUNCTION__, param_1, size, Info, Address, res);
        } else {
            spdlog::info("{} ok, p1={}, size={}, info={}, address={}, res={}", __PRETTY_FUNCTION__, param_1, size, Info, Address, res);
        }
        return res;
    }

    int FoxNioImplMpMuxImplGetTotalPayloadSizeHook(void *thisPtr) {
        auto res = FoxNioImplMpMuxImplGetTotalPayloadSize(thisPtr);
        if (res != 0) {
            spdlog::info("{}: res={}", __PRETTY_FUNCTION__, res);
        }
        return res;
    }

    void FoxNioMpMessageSerializerSerializeHook(void *Serializer, fox::nio::Buffer *buffer) {
        spdlog::info("{} before: size {}, m1 {}, m2 {}, m3 {}",
            __PRETTY_FUNCTION__,
            buffer->size,
            buffer->mystery1,
            buffer->mystery2,
            buffer->mystery3); // bytes_to_hex(buffer->mem, buffer->size));
        FoxNioMpMessageSerializerSerialize(Serializer, buffer);
        spdlog::info("{} after: size {}", __PRETTY_FUNCTION__, buffer->size);
    }

    void *FoxNioMpMessageContainerCreateHook(void *param_1, uint32_t sizeWithHeader) {
        auto res = FoxNioMpMessageContainerCreate(param_1, sizeWithHeader);
        auto dump = bytes_to_hex(param_1, 11);
        spdlog::info("{}: p1={}, sizeWithHeader={}, res={}, dump={}", __PRETTY_FUNCTION__, param_1, sizeWithHeader, res, dump);
        return res;
    }

    int FoxNioMpMessageContainerAddMessageHook(void *MpMessageContainer, void *MpMessageComponent) {
        spdlog::info("{}: {}, {}", __PRETTY_FUNCTION__, MpMessageContainer, MpMessageComponent);
        auto res = FoxNioMpMessageContainerAddMessage(MpMessageContainer, MpMessageComponent);
        if (res != 0) {
            spdlog::info("{} fail: {}, {}, res={}", __PRETTY_FUNCTION__, MpMessageContainer, MpMessageComponent, res);
        } else {
            spdlog::info("{} ok: {}, {}, res={}", __PRETTY_FUNCTION__, MpMessageContainer, MpMessageComponent, res);
        }
        return res;
    }

    int32_t FoxNioImplSppSocketImplGetStateHook(void *SppSocketImpl) {
        auto res = FoxNioImplSppSocketImplGetState(SppSocketImpl);
        spdlog::info("{}, state: {}", __PRETTY_FUNCTION__, res);
        return res;
    }

    void *FoxNtImplSyncMemoryCollectorSyncMemoryCollectorHook(
        void *SyncMemoryCollector, uint32_t param_1, uint32_t param_2, uint32_t param_3, void *TransceiverImpl, void *param_5, uint64_t param_6) {
        spdlog::info("{}: p1={}, p2={}, p3={}, p5={}, p6={} (p1*p2)", __PRETTY_FUNCTION__, param_1, param_2, param_3, param_5, param_6);
        auto res = FoxNtImplSyncMemoryCollectorSyncMemoryCollector(SyncMemoryCollector, param_1, param_2, param_3, TransceiverImpl, param_5, param_6);
        return res;
    }

    void *FoxNtImplGameSocketBufferImplAllocHook(void *GameSocketBufferImpl, uint32_t size) {
        auto res = FoxNtImplGameSocketBufferImplAlloc(GameSocketBufferImpl, size);
        spdlog::info("{}: size {}, res {}", __PRETTY_FUNCTION__, size, res);
        return res;
    }

    void *FoxBitStreamWriterPrimitiveWriteHook(void *BitStreamWriter, void *ErrorCode, const uint64_t value, const uint32_t size) {
        if (hookState.recordBinWrites) {
            hookState.varsTotalSize += size;

            // const auto offset = *(uint32_t *)((char *)BitStreamWriter + 0x10);
            // auto capacity = *(int32_t *)((char *)BitStreamWriter + 0xC);
            // recordBinWriter = *(void **)BitStreamWriter;
            // recordOffset = offset;
            // spdlog::info("{}: a={}, cap={}, offset={}, value={}, varSize={}", __PRETTY_FUNCTION__, recordBinWriter, capacity, offset, value, size);
        }

        const auto res = FoxBitStreamWriterPrimitiveWrite(BitStreamWriter, ErrorCode, value, size);
        if (*(uint32_t *)res != 0) {
            spdlog::info("{}: error, res={}", __PRETTY_FUNCTION__, *(uint32_t *)res);
        }

        return res;
    }

    int32_t FoxNtImplTransceiverManagerImplPeerSendImpl1Hook(void *PeerThis, void *Peer, int32_t param_2) {
        auto res = FoxNtImplTransceiverManagerImplPeerSendImpl1(PeerThis, Peer, param_2);
        spdlog::info("{}: p2={}, res={}", __PRETTY_FUNCTION__, param_2, res);
        return res;
    }

    int32_t FoxNtImplTransceiverManagerImplPeerSendImpl2Hook(void *PeerThis, void *Peer, int32_t param_2) {
        auto res = FoxNtImplTransceiverManagerImplPeerSendImpl2(PeerThis, Peer, param_2);
        spdlog::info("{}: p2={}, res={}", __PRETTY_FUNCTION__, param_2, res);
        return res;
    }

    void *FoxNtImplTransceiverImplTransceiverImplHook(void *TransceiverImpl, void *TransceiverCreationDesc) {
        auto res = FoxNtImplTransceiverImplTransceiverImpl(TransceiverImpl, TransceiverCreationDesc);
        auto size = *(uint32_t *)((char *)TransceiverCreationDesc + 0x4);
        auto memsize = *(uint32_t *)((char *)res + 0x10);
        auto something = *(uint32_t *)((char *)res + 0xC);
        spdlog::info("{}, size={}, memsize={}, something={}", __PRETTY_FUNCTION__, size, memsize, something);
        return res;
    }

    void FoxNtImplGameSocketImplPeerRequestToSendHook(void *Peer, void *src, uint32_t size) {
        FoxNtImplGameSocketImplPeerRequestToSend(Peer, src, size);
        auto contentsSize = size;
        if (contentsSize > 50) {
            contentsSize = 50;
        }
        spdlog::info("{}, peer={}, src={}, size={}, dump={}", __PRETTY_FUNCTION__, Peer, src, size, bytes_to_hex(src, contentsSize));
    }

    void *FoxNtImplGameSocketBufferImplGameSocketBufferImplHook(void *GameSocketBufferImpl, uint32_t size) {
        spdlog::info("{}, size={}", __PRETTY_FUNCTION__, size);
        auto res = FoxNtImplGameSocketBufferImplGameSocketBufferImpl(GameSocketBufferImpl, size);
        return res;
    }

    void *FoxNioMpMessageCreateHook(void *param_1, uint32_t maxSize, void *param_3, uint32_t requestedSize) {
        auto msgPtr = BlockHeapAlloc(maxSize, 8, MEMTAG_TPP_NETWORK);
        auto res = FoxNioMpMessageCreate(msgPtr, maxSize, param_3, requestedSize);
        if (res == nullptr) {
            spdlog::info("{}: fail, p1={}, maxSize={}, p3={}, requestedSize={}", __PRETTY_FUNCTION__, param_1, maxSize, param_3, requestedSize);
        } else {
            spdlog::info("{}: ok, p1={}, maxSize={}, p3={}, requestedSize={}", __PRETTY_FUNCTION__, param_1, maxSize, param_3, requestedSize);
        }

        return res;
    }

    uint32_t FoxNtImplGameSocketImplGetPacketCountHook(void *GameSocketImpl, uint32_t param_1) {
        spdlog::info("{}, socket={}, p1={}", __PRETTY_FUNCTION__, GameSocketImpl, param_1);
        return FoxNtImplGameSocketImplGetPacketCount(GameSocketImpl, param_1);
    }

    void *FoxNtImplNetworkSystemImplCreateGameSocketHook(void *NetworkSystemImpl, fox::nt::GameSocketDesc *gameSocketDesc) {
        spdlog::info("{}, socket={}, value={}", __PRETTY_FUNCTION__, gameSocketDesc->socketNumber, gameSocketDesc->value);
        if ((gameSocketDesc->socketNumber == ScriptDeclVarsGameSocketNumber) && (gameSocketDesc->value == 1)) {
            // create socket when ScriptDeclVars creates one
            // FIXME deprecated??
            g_hook->dynamiteSyncImpl.Init();
            g_hook->dynamiteSyncImpl.SyncInit();
        }
        return FoxNtImplNetworkSystemImplCreateGameSocket(NetworkSystemImpl, gameSocketDesc);
    }

    void FoxNtNtModuleInitHook() {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        FoxNtNtModuleInit();
    }

    void FoxNtImplGameSocketImplRequestToSendToMemberHook(
        void *GameSocketImpl, unsigned char memberIndex, uint32_t param_2, void *bufferPtr, uint32_t byteCount) {
        auto contentsSize = byteCount;
        if (contentsSize > 50) {
            contentsSize = 50;
        }
        auto contents = bytes_to_hex(bufferPtr, contentsSize);
        spdlog::info("{}, memberIndex={}, sender(?)={}, bufPtr={}, byteCount={}, contents={}",
            __PRETTY_FUNCTION__,
            memberIndex,
            param_2,
            bufferPtr,
            byteCount,
            contents);
        FoxNtImplGameSocketImplRequestToSendToMember(GameSocketImpl, memberIndex, param_2, bufferPtr, byteCount);
    }

    void FoxNtImplGameSocketImplSetIntervalHook(void *GameSocketImpl, uint32_t param_1, unsigned char param_2, float param_3) {
        spdlog::info("{}, p1={}, p2={}, p3={}", __PRETTY_FUNCTION__, param_1, param_2, param_3);
        FoxNtImplGameSocketImplSetInterval(GameSocketImpl, param_1, param_2, param_3);
    }

    void FoxNtImplPeerCommonInitializeLastSendTimeHook(void *PeerCommon) {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        FoxNtImplPeerCommonInitializeLastSendTime(PeerCommon);
    }

    void *TppGmImplScriptDeclVarsImplScriptDeclVarsImplHook(void *ScriptDeclVarsImpl) {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        const auto res = TppGmImplScriptDeclVarsImplScriptDeclVarsImpl(ScriptDeclVarsImpl);
        return res;
    }

    void TppGmImplScriptDeclVarsImplUpdateHook(void *ScriptDeclVarsImpl) { TppGmImplScriptDeclVarsImplUpdate(ScriptDeclVarsImpl); }

    void TppGmImplScriptDeclVarsImplOnSessionNotifyHook(void *ScriptDeclVarsImpl, void *SessionInterface, const int param_2, void *param_3) {
        if (param_2 != 4) {
            spdlog::info("{}, notification type {}, ignoring", __PRETTY_FUNCTION__, param_2);
            TppGmImplScriptDeclVarsImplOnSessionNotify(ScriptDeclVarsImpl, SessionInterface, param_2, param_3);
            return;
        }

        auto memberIndex = *(unsigned char *)param_3;
        spdlog::info("{}, member index {}", __PRETTY_FUNCTION__, memberIndex);

        // scriptDeclVarsImpl = ScriptDeclVarsImpl;

        auto varCount = *(uint32_t *)((char *)ScriptDeclVarsImpl + -0x10);
        auto syncCount = 0;
        auto offset = 0;
        for (int i = 0; i < varCount; i++) {
            const auto varTable = *(uint64_t *)((char *)ScriptDeclVarsImpl + -0x20);
            const auto flag = *(unsigned char *)(varTable + offset + 0x10);
            if ((flag & 0x10) != 0) {
                syncCount++;
                //                auto handle = TppGmImplScriptDeclVarsImplGetVarHandleWithVarIndex(ScriptDeclVarsImpl, i);
            }
            offset += 0x18;
        }

        hookState.recordBinWrites = true;
        TppGmImplScriptDeclVarsImplOnSessionNotify(ScriptDeclVarsImpl, SessionInterface, param_2, param_3);
        hookState.recordBinWrites = false;

        spdlog::info("{}, {} records, syncCount {}, wrote {} bits, will allocate {} bytes",
            __PRETTY_FUNCTION__,
            varCount,
            syncCount,
            hookState.varsTotalSize,
            hookState.varsTotalSize >> 3);

        if (g_hook->cfg.Host && syncCount > 0) {
            g_hook->dynamiteSyncImpl.SendEmblem();
        }

        if (syncCount > 0 && !g_hook->cfg.Host) {
            //            dynamiteSyncImpl.WaitForSync();
        } else {
            g_hook->dynamiteSyncImpl.Ping();
        }

        hookState.varsTotalSize = 0;
    }

    void *FoxNtImplSessionImpl2GetMemberInterfaceAtIndexHook(void *SessionImpl2, unsigned char index) {
        spdlog::info("{}, {} index {}", __PRETTY_FUNCTION__, SessionImpl2, index);
        return FoxNtImplSessionImpl2GetMemberInterfaceAtIndex(SessionImpl2, index);
    }

    void FoxNtImplGameSocketImplHandleMessageHook(void *GameSocketImpl, void *Buffer, uint32_t fromIndex, void *Buffer2, void *BitStreamReader) {
        // if (GameSocketImpl == dynamiteSyncImpl.gameSocket) {
        //     auto uvar2 = *(int32_t *)((char *)GameSocketImpl + 0x10);
        //     spdlog::info("{}, handling game socket message ({}), from={}, uvar2={}!", __PRETTY_FUNCTION__, GameSocketImpl, fromIndex, uvar2);
        // }

        FoxNtImplGameSocketImplHandleMessage(GameSocketImpl, Buffer, fromIndex, Buffer2, BitStreamReader);
    }

    void *FoxNtImplPeerCommonPeerCommonHook(void *PeerCommon, unsigned char param_1, uint32_t param_2) {
        spdlog::info("{}, {}, p1={}, p2={}", __PRETTY_FUNCTION__, PeerCommon, param_1, param_2);
        return FoxNtImplPeerCommonPeerCommon(PeerCommon, param_1, param_2);
    }

    void TppGmPlayerImplSynchronizerImplInitializeHook(void *SynchronizerImpl, void *QuarkDesc) {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        TppGmPlayerImplSynchronizerImplInitialize(SynchronizerImpl, QuarkDesc);
    }

    void FoxNtImplGameSocketImplGameSocketImplDtorHook(void *GameSocketImpl, uint32_t freeMem) {
        auto socket = *(unsigned short *)((char *)GameSocketImpl + 0x8);
        auto value = *(unsigned short *)((char *)GameSocketImpl + 0x10);
        spdlog::info("{}, ptr={}, freeMem={}, socket={}, value={}", __PRETTY_FUNCTION__, GameSocketImpl, freeMem, socket, value);
        if ((socket == ScriptDeclVarsGameSocketNumber) && (value == 1)) {
            // delete socket before ScriptDeclVars socket
        }
        FoxNtImplGameSocketImplGameSocketImplDtor(GameSocketImpl, freeMem);
    }

    void TppGmImplScriptDeclVarsImplScriptDeclVarsImplDtorHook(void *ScriptDeclVarsImpl) {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        TppGmImplScriptDeclVarsImplScriptDeclVarsImplDtor(ScriptDeclVarsImpl);
    }

    void TppGmPlayerImplAnonymous_namespaceCamouflageControllerImplInitializeHook(void *CamouflageControllerImpl, fox::QuarkDesc *param_1) {
        TppGmPlayerImplAnonymous_namespaceCamouflageControllerImplInitialize(CamouflageControllerImpl, param_1);
        // TODO FIXME
        // this function must be removed, pointer replaced with GetCamoController call
        hookState.camouflageControllerImpl = CamouflageControllerImpl;
    }

    void FoxNtImplTransceiverManagerImplPeerAddToSendQueueHook(void *Peer, void *PeerCommon) {
        auto bp = (*(unsigned char *)PeerCommon & 2) == 0;
        if (bp) {
            spdlog::info("{}, peer {}, peer common {}, bp {}", __PRETTY_FUNCTION__, Peer, PeerCommon, bp);
        }
        FoxNtImplTransceiverManagerImplPeerAddToSendQueue(Peer, PeerCommon);
    }

    uint32_t FoxNioImplMpMuxImplSendUpdateHook(void *MpMuxImpl) {
        auto res = FoxNioImplMpMuxImplSendUpdate(MpMuxImpl);
        spdlog::info("{}, res={}", __PRETTY_FUNCTION__, res);
        return res;
    }

    int32_t FoxNioImplSppSocketImplSendImplHook(void *SppSocketImpl, void *bufferAddr, int size, void *info, void *addr, bool param_5) {
        auto res = FoxNioImplSppSocketImplSendImpl(SppSocketImpl, bufferAddr, size, info, addr, param_5);

        std::string bytes = "empty";
        if (size > 0) {
            auto printSize = size;
            if (size > 50) {
                printSize = 50;
            }
            bytes = bytes_to_hex(bufferAddr, printSize);

            spdlog::info("{}, p1={} ({}), size={}, info={}, address={}, p5={}, res={}", __PRETTY_FUNCTION__, bufferAddr, bytes, size, info, addr, param_5, res);
        }
        return res;
    }

    int32_t FoxNioImplSteamUdpSocketImplSendHook(void *SteamUdpSocketImpl, void *param_1, int param_2, void *SocketInfo, void *Address) {
        g_hook->dynamiteSyncImpl.steamUDPAddress = Address;
        g_hook->dynamiteSyncImpl.steamUDPSocketInfo = SocketInfo;
        g_hook->dynamiteSyncImpl.steamUDPSocket = SteamUdpSocketImpl;

        auto dumpSize = param_2;
        if (dumpSize > 50) {
            dumpSize = 50;
        }

        auto dump = bytes_to_hex(param_1, dumpSize);
        auto res = FoxNioImplSteamUdpSocketImplSend(SteamUdpSocketImpl, param_1, param_2, SocketInfo, Address);
        spdlog::debug("{}, p1={}, p2={}, socketInfo={}, address={}, res={}, dump={}", __PRETTY_FUNCTION__, param_1, param_2, SocketInfo, Address, res, dump);
        return res;
    }

    int32_t FoxNioImplSteamUdpSocketImplRecvHook(void *SteamUdpSocketImpl, void *buffer, int maxBufferSize, void *SocketInfo, void *Address) {
        auto responseSize = FoxNioImplSteamUdpSocketImplRecv(SteamUdpSocketImpl, buffer, maxBufferSize, SocketInfo, Address);
        if (responseSize < sizeof(DYNAMITE_RAW_HEADER)) {
            return responseSize;
        }

        if (responseSize < 0) {
            return responseSize;
        }

        if (memcmp(buffer, &DYNAMITE_RAW_HEADER, sizeof(DYNAMITE_RAW_HEADER)) != 0) {
            return responseSize;
        }

        auto dumpSize = responseSize;
        if (dumpSize > 50) {
            dumpSize = 50;
        }

        auto bytes = bytes_to_hex(buffer, dumpSize);
        spdlog::debug("{}, bufSize={}, responseSize={}, dump={}", __PRETTY_FUNCTION__, maxBufferSize, responseSize, bytes);
        g_hook->dynamiteSyncImpl.RecvRaw(buffer, responseSize);

        return responseSize;
    }

    void *TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParametersHook(void *EmblemEditorSystemImpl, void *ErrorCode, void *EmblemTextureParameters,
        uint32_t *emblemTextureTag, uint32_t *emblemColorL, uint32_t *emblemColorH, char *emblemX, char *emblemY, char *emblemScale, char *emblemRotate,
        unsigned char version, bool param_10) {
        spdlog::info("{}, emblemTextureTag={:x}, emblemColorL={:x}, emblemColorH={:d}, emblemX={:d}, emblemY={:d}, emblemScale={:d}, emblemRotate={:d}, "
                     "version={:d}, p10={}",
            __PRETTY_FUNCTION__,
            *emblemTextureTag,
            *emblemColorL,
            *emblemColorH,
            *emblemX,
            *emblemY,
            *emblemScale,
            *emblemRotate,
            version,
            param_10);

        return TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParameters(EmblemEditorSystemImpl,
            ErrorCode,
            EmblemTextureParameters,
            emblemTextureTag,
            emblemColorL,
            emblemColorH,
            emblemX,
            emblemY,
            emblemScale,
            emblemRotate,
            version,
            param_10);
    }

    void FoxNtImplSessionImpl2DeleteMemberHook(void *SessionImpl2, void *Member) {
        g_hook->dynamiteSyncImpl.Stop();
        FoxNtImplSessionImpl2DeleteMember(SessionImpl2, Member);
    }

    void *FoxImplMessage2MessageBox2ImplSendMessageToSubscribersHook(void *MessageBox2Impl, void *ErrorCode, uint32_t msgID, void *MessageArgs) {
        if (msgID == MESSAGE_DISCONNECT_FROM_HOST) {
            spdlog::info("{}, disconnect from host", __PRETTY_FUNCTION__);
            g_hook->dynamiteSyncImpl.Stop();
        }

        return FoxImplMessage2MessageBox2ImplSendMessageToSubscribers(MessageBox2Impl, ErrorCode, msgID, MessageArgs);
    }

    bool TppUiEmblemImplEmblemEditorSystemImplCreateEmblemHook(
        void *EmblemEditorSystemImpl, uint64_t textureName, uint64_t textureNameSmall, void *EmblemTextureParameters, uint32_t maybe_sizes) {

        spdlog::info("{}, name={:x} ({}), nameSmall={:x} ({}), sizes={}",
            __PRETTY_FUNCTION__,
            textureName,
            g_hook->messageDict[textureName],
            textureNameSmall,
            g_hook->messageDict[textureNameSmall],
            maybe_sizes);

        return TppUiEmblemImplEmblemEditorSystemImplCreateEmblem(EmblemEditorSystemImpl, textureName, textureNameSmall, EmblemTextureParameters, maybe_sizes);
    }

    // this might be a nice place to wrap up everything
    void TppGkTppGameKitModuleEndHook(void *TppGameKitModule) {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        // dynamiteSyncImpl.Stop();
        TppGkTppGameKitModuleEnd(TppGameKitModule);
    }

    bool TppGmPlayerImplClimbActionPluginImplCheckActionStateHook(void *ClimbActionPluginImpl, uint32_t param_1) { return true; }

    int FoxGeoPathResultGetNumPointHook(void *PathResult) {
        auto q = *(void**)PathResult;
        auto v = *(void **)((char *)q+ 0x40);
        if (v == nullptr) {
            return 1;
        }

        return FoxGeoPathResultGetNumPoint(PathResult);
    }

    void TppUiUtilityChangeLanguageHook(int param_1) {
        spdlog::info("{}, langID {}", __PRETTY_FUNCTION__, param_1);
        TppUiUtilityChangeLanguage(param_1);
        TppUiMenuUiCommonDataManagerLoadLanguageBlock(0x5228f70f3baa9166);
    }

    void TppGmPlayerImplEquipControllerImplInitializeHook(void *EquipControllerImpl, fox::QuarkDesc *param_1) {
        TppGmPlayerImplEquipControllerImplInitialize(EquipControllerImpl, param_1);
        hookState.equipControllerImpl = (char *)EquipControllerImpl + 0x20;
    }

    void TppGmBossquietImplActionControllerImplSetCommandHook(void *ActionControllerImpl, uint32_t entityIndex, BossQuietActionCommand *ActionCommand) {
        if (!g_hook->cfg.Host) {
            return;
        }

        const auto o1 = (char *)hookState.bossQuietImplActionController + 0x20;
        const auto work = (BossQuietImplActionControllerImplWork *)(void **)(o1 + 0x48);
        if (g_hook->cfg.debug.bossQuiet) {
            spdlog::info("{}, entityIndex={}, workPtr={}, work=\n{}\ncommand=\n{}\ncommandDump={}",
                __PRETTY_FUNCTION__,
                entityIndex,
                (void *)work,
                work->ToString(),
                ((BossQuietActionTask *)ActionCommand)->ToString(),
                bytes_to_hex(ActionCommand, sizeof(BossQuietActionCommand)));
        }

        TppGmBossquietImplActionControllerImplSetCommand(ActionControllerImpl, entityIndex, ActionCommand);
        g_hook->dynamiteSyncImpl.SendBossquietActionCommand(entityIndex, ActionCommand);
    }

    void TppGmBossquietImplActionControllerImplSetExtraActionCommandHook(void *ActionControllerImpl, uint32_t entityIndex, void *ExtraActionCommand) {
        if (!g_hook->cfg.Host) {
            return;
        }

        spdlog::info("{}, entityIndex={}", __PRETTY_FUNCTION__, entityIndex);
        TppGmBossquietImplActionControllerImplSetExtraActionCommand(ActionControllerImpl, entityIndex, ExtraActionCommand);
        g_hook->dynamiteSyncImpl.SendBossquietExtraActionCommand(entityIndex, (BossQuietActionCommand *)ExtraActionCommand);
    }

    // this is a rewrite of SetNextActionTask
    void TppGmBossquietImplActionControllerImplSetNextActionTaskHook(
        void *ActionControllerImpl, uint32_t entityIndex, BossQuietImplActionControllerImplWork *work) {
        if (!g_hook->cfg.Host) {
            return;
        }

        const auto off1 = *(uint64_t *)((char *)ActionControllerImpl + 0x58);
        const auto navController = *(void **)((char *)off1 + 0x18);
        if (navController == nullptr) {
            spdlog::error("{}, navigation controller is nullptr", __PRETTY_FUNCTION__);
            return;
        }

        auto navigator = TppGmImplNavigationController2ImplGetNavigator(navController, entityIndex);
        if (navigator == nullptr) {
            spdlog::error("{}, navigator is nullptr", __PRETTY_FUNCTION__);
            return;
        }

        auto workCondition = (work->field7_0x17e & 3) - 2;
        if (workCondition >= 2) {
            return;
        }

        uint32_t reqID = *(uint32_t *)((char *)navigator + 8);
        auto prepared = TppGmImplNavigationController2ImplIsCurrentRequestPrepared(navController, reqID);
        if (!prepared) {
            return;
        }

        if (g_hook->cfg.debug.bossQuiet) {
            spdlog::info("{}, entityIndex={}, workPtr={}, work=\n{}", __PRETTY_FUNCTION__, entityIndex, (void *)work, work->ToString());
        }

        auto snipeManager = *(void **)((char *)off1 + 0xb0);

        auto vOff = *(uint64_t *)((char *)off1 + 0x10);
        auto vectorOff = *(uint64_t *)((char *)vOff + 0x20) + entityIndex * 0x10;
        auto vv = (Vector3 *)vectorOff;

        Vector3 someLocation{
            .x = vv->x,
            .y = vv->y,
            .z = vv->z,
            .w = 0,
        };

        auto workLocation = work->task1.v9_0x80;

        const auto outOfNav =
            TppGmBossquietImplActionControllerImplCheckUseOutOfNavJump(ActionControllerImpl, entityIndex, navController, snipeManager, &someLocation);
        if (outOfNav) {
            Vector3 landingPos{};
            TppGmBossquietImplSnipeManagerImplGetOptimalLandingPosition(snipeManager, &landingPos, entityIndex, &someLocation, &workLocation);

            BossQuietActionTask a{};
            a.v1_0x0 = landingPos;
            a.v6_0x50 = work->task1.v6_0x50;
            a.v2_0x10 = Vector3{};
            a.v5_0x40 = work->task1.v5_0x40;
            a.actionType_0xac = 0x11;
            a.v8_0x70 = work->task1.v8_0x70;
            a.v7_0x60 = work->task1.v7_0x60;
            a.field20_0xad = work->task1.field18_0xab;
            char precalc[16] = {0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
            memcpy(&a.v3_0x20, precalc, 16);

            TppGmSahelanImplActionControllerImplSetTaskParamFromActionCommand(ActionControllerImpl, &a, (BossQuietActionCommand *)work);

            auto currentTask = (BossQuietActionTask *)(*(uint64_t *)((char *)ActionControllerImpl + 0x60) + entityIndex * 0xb0);
            TppGmSahelanActionTaskoperatorAssign(currentTask, &a);
            work->field8_0x180 = work->field8_0x180 + 1;
            // doesn't make much sense?
            if (work->field8_0x180 == -1) {
                work->field8_0x180 = 0;
            }

            currentTask->anotherType_0xa8 = work->field8_0x180;
            work->field7_0x17e = work->field7_0x17e | 0x40c;
            g_hook->dynamiteSyncImpl.SendBossquietSetNextActionTask(entityIndex, &a, BossQuietNextActionTaskActionCondition::out_of_nav);
        } else {
            const auto path = TppGmImplNavigationController2ImplGetPath(navController, entityIndex);
            if (path == nullptr) {
                return;
            }

            auto i = *(uint32_t *)((char *)path + 0x20);
            const auto workFlag = *(unsigned short *)((char *)work + 0x17e);
            if ((workFlag & 0x1000) == 0 && (workFlag & 0x400) == 0) {
                const auto state = TppGmImplNavigationController2ImplGetResultState(navController, entityIndex);
                if (state == 5) {
                    BossQuietActionTask a{};
                    a.v1_0x0 = workLocation;
                    a.v5_0x40 = work->task1.v5_0x40;
                    a.v2_0x10 = Vector3{};
                    a.v6_0x50 = work->task1.v6_0x50;
                    a.v7_0x60 = work->task1.v7_0x60;
                    a.field17_0xaa = a.field17_0xaa & 0xfd | 1;
                    a.actionType_0xac = 0x11;
                    a.v8_0x70 = work->task1.v8_0x70;

                    char precalc[16] = {0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
                    memcpy(&a.v3_0x20, precalc, 16);
                    a.field14_0xa4 = i - 1;
                    TppGmSahelanImplActionControllerImplSetTaskParamFromActionCommand(ActionControllerImpl, &a, (BossQuietActionCommand *)work);
                    TppGmBossquietImplActionControllerImplSetActionTask(ActionControllerImpl, entityIndex, work, &a);
                    work->field5_0x178 = i - 1;
                    work->field7_0x17e = work->field7_0x17e | 0x404;
                    g_hook->dynamiteSyncImpl.SendBossquietSetNextActionTask(entityIndex, &a, BossQuietNextActionTaskActionCondition::in_nav_with_state);
                    return;
                }
            }
            BossQuietActionTask a{};

            a.v1_0x0 = work->task1.v1_0x0;
            a.v2_0x10 = work->task1.v2_0x10;
            a.v3_0x20 = work->task1.v3_0x20;
            a.field17_0xaa = a.field17_0xaa & 0xfd | 1;
            a.actionType_0xac = work->task1.field17_0xaa;
            a.v4_0x30 = work->task1.v4_0x30;
            a.v5_0x40 = work->task1.v5_0x40;
            a.field20_0xad = work->task1.field18_0xab;
            a.v6_0x50 = work->task1.v6_0x50;
            a.v7_0x60 = work->task1.v7_0x60;
            a.v8_0x70 = work->task1.v8_0x70;
            a.field14_0xa4 = i - 1;
            TppGmSahelanImplActionControllerImplSetTaskParamFromActionCommand(ActionControllerImpl, &a, (BossQuietActionCommand *)work);
            TppGmBossquietImplActionControllerImplSetActionTask(ActionControllerImpl, entityIndex, work, &a);
            work->field7_0x17e = work->field7_0x17e | 4;
            work->field5_0x178 = i - 1;
            g_hook->dynamiteSyncImpl.SendBossquietSetNextActionTask(entityIndex, &a, BossQuietNextActionTaskActionCondition::in_nav_without_state);
        }
    }

    void TppGmBossquietImplActionControllerImplSetActionTaskHook(
        void *ActionControllerImpl, const uint32_t entityIndex, BossQuietImplActionControllerImplWork *work, BossQuietActionTask *task) {
        if (!g_hook->cfg.Host) {
            return;
        }

        if (g_hook->cfg.debug.bossQuiet) {
            spdlog::info("{}, entityIndex {}, task=\n{}", __PRETTY_FUNCTION__, entityIndex, task->ToString());
        }

        TppGmBossquietImplActionControllerImplSetActionTask(ActionControllerImpl, entityIndex, work, task);
        g_hook->dynamiteSyncImpl.SendBossquietSetActionTask(entityIndex, task);
    }

    void TppGmBossquietImplActionControllerImplInitializeHook(void *ActionControllerImpl, fox::QuarkDesc *param_1) {
        TppGmBossquietImplActionControllerImplInitialize(ActionControllerImpl, param_1);
        hookState.bossQuietImplActionController = ActionControllerImpl;
    }

    bool TppGmBossquietImplCloseCombatAiImplRequestMoveActionHook(void *CloseCombatAiImpl, uint32_t param_1, void *Work) { return false; }

    void TppGmBossquietImplRecoveryAiImplStepMoveHook(void *RecoveryAiImpl, uint32_t entityIndex, uint32_t StepProc, unsigned char *RecoveryAiKnowledge) {
        if (StepProc == 3) {
            // pretend that moving phase is already over
            *RecoveryAiKnowledge = 1;
        } else {
            TppGmBossquietImplRecoveryAiImplStepMove(RecoveryAiImpl, entityIndex, StepProc, RecoveryAiKnowledge);
        }
    }

    void TppGmBossquietImplanonymous_namespaceLifeControllerImplUpdateLifeHook(
        void *LifeControllerImpl, TppGmBossquietLifeControllerWork *work, uint32_t entityIndex, float param_3) {

        // very naive, will have network concurrency issues:
        // if messages from two enemies arrive before processing, second will overwrite the first;
        // only second will be processed

        bool needSend = false;

        if (work->incomingDamage > 0 || work->incomingStaminaDamage > 0) {
            spdlog::info("{}, incoming damage {}/(current life {}), {}/(current stam {})",
                __PRETTY_FUNCTION__,
                work->incomingDamage,
                work->currentLife_0xc,
                work->incomingStaminaDamage,
                work->currentStamina_0x12);

            needSend = true;
            hookState.outgoingBossQuietDamage.entityIndex = entityIndex;
            hookState.outgoingBossQuietDamage.currentLife = work->currentLife_0xc;
            hookState.outgoingBossQuietDamage.currentStamina = work->currentStamina_0x12;
            hookState.outgoingBossQuietDamage.lifeDamage = work->incomingDamage;
            hookState.outgoingBossQuietDamage.staminaDamage = work->incomingStaminaDamage;
        }

        TppGmBossquietImplanonymous_namespaceLifeControllerImplUpdateLife(LifeControllerImpl, work, entityIndex, param_3);

        if (needSend) {
            g_hook->dynamiteSyncImpl.SendBossQuietDamage(&hookState.outgoingBossQuietDamage);
            hookState.outgoingBossQuietDamage = {};
        }

        if (hookState.incomingBossQuietDamage.entityIndex > -1 && entityIndex == hookState.incomingBossQuietDamage.entityIndex) {

            auto newLife = hookState.incomingBossQuietDamage.currentLife - hookState.incomingBossQuietDamage.lifeDamage;
            if (newLife < 0) {
                newLife = 0;
            }

            if (work->currentLife_0xc > newLife && work->status_0x2d != 1) {
                spdlog::info("{}, updating life for {} from {} to {}", __PRETTY_FUNCTION__, entityIndex, work->currentLife_0xc, newLife);
                work->currentLife_0xc = newLife;
            }

            // killing blow
            if (hookState.incomingBossQuietDamage.currentLife == 1) {
                spdlog::info("{}, killing blow", __PRETTY_FUNCTION__);
                work->currentLife_0xc = 0;
            }

            auto newStamina = hookState.incomingBossQuietDamage.currentStamina - hookState.incomingBossQuietDamage.staminaDamage;
            if (newStamina < 0) {
                newStamina = 0;
            }

            if (work->currentStamina_0x12 > newStamina && work->status_0x2d != 1) {
                spdlog::info("{}, updating stamina for {} from {} to {}", __PRETTY_FUNCTION__, entityIndex, work->currentStamina_0x12, newStamina);
                work->currentStamina_0x12 = newStamina;
            }

            hookState.incomingBossQuietDamage = {};
            hookState.incomingBossQuietDamage.entityIndex = -1;
        }
    }
}
