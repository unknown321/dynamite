#include "DynamiteHook.h"
#include "DynamiteSyncImpl/DynamiteSyncImpl.h"
#include "Tpp/TppFOB.h"
#include "Tpp/TppGameStatusFlag.h"
#include "Tpp/TppMarkerType.h"
#include "memtag.h"
#include "mgsvtpp_func_typedefs.h"
#include "spdlog/spdlog.h"
#include "util.h"

#include <filesystem>

namespace Dynamite {
    void *fobTargetCtor = nullptr;
    void *messageBuffer = nullptr;
    bool recordBinWrites = false;
    void *recordBinWriter = nullptr;
    void *camouflageControllerImpl = nullptr;
    uint32_t recordOffset = 0;
    uint32_t varsTotalSize = 0;
    DynamiteSyncImpl dynamiteSyncImpl{};

    // entry point
    void __fastcall luaL_openlibsHook(lua_State *L) {
        int Version = 1;
        luaL_openlibs(L);

        lua_pushinteger(L, Version);
        lua_setfield(L, LUA_GLOBALSINDEX, "_Dynamite");

        CreateLibs(L);
        luaState = L;

        messageDict = readMessageDictionary("strcode32hex.txt");
        pathDict = readPathCodeDictionary("pathfilenamecode64.txt"); // pathfilenamecode64 in HashWrangler

        auto luaLog = "dynamite/lualog.txt";
        if (cfg.debug.luaLog) {
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

        dynamiteSyncImpl.SetSightMarker(objectID, duration);

        return res;
    }

    void SteamUdpSocketImplOnP2PSessionRequestHook(void *thisPtr, void *request) {
        auto clientSteamID = *(uint64_t *)request;
        spdlog::info("{}: Connection request: {:d}", __PRETTY_FUNCTION__, clientSteamID);

        if (!cfg.Host) {
            spdlog::warn("client, but there was a connection attempt?");
        }

        if ((cfg.whitelist.empty()) && (cfg.blacklist.empty())) {
            spdlog::info("{}: Connection accepted", __PRETTY_FUNCTION__);
            SteamUdpSocketImplOnP2PSessionRequest(thisPtr, request);
            return;
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
                spdlog::info("{}: Not in whitelist: {:d}", __PRETTY_FUNCTION__, clientSteamID);
                return;
            }

            SteamUdpSocketImplOnP2PSessionRequest(thisPtr, request);
            return;
        }

        for (const auto &v : cfg.blacklist) {
            if (v == clientSteamID) {
                spdlog::info("{}: In blacklist: {:d}", __PRETTY_FUNCTION__, clientSteamID);
                return;
            }
        }

        SteamUdpSocketImplOnP2PSessionRequest(thisPtr, request);
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
            spdlog::info("{}: Co-op connection established", __PRETTY_FUNCTION__);

            if (dynamiteSyncImpl.gameSocket == nullptr) {
                dynamiteSyncImpl.Init();
                dynamiteSyncImpl.SyncInit();
            }

            dynamiteSyncImpl.Ping();
        }

        UpdateClientEstablished(param);
    }

    void *MessageBufferAddMessageHook(
        void *thisPtr, void *errCodePtr, uint32_t messageID, uint32_t sender, uint32_t receiver, uint32_t param_4, void *messageArgs, uint32_t param_6) {
        messageBuffer = thisPtr;

        if (messageDict.size() > 0) {
            spdlog::info("Message: {} ({:x}), from: {} ({:x}), to: {} ({:x}), {} ({:x}), {} ({:x})",
                messageDict[messageID],
                messageID,
                messageDict[sender],
                sender,
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

        return MessageBufferAddMessage(thisPtr, errCodePtr, messageID, sender, receiver, param_4, messageArgs, param_6);
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

    void *Marker2SystemImplHook(void *thisPtr) {
        MarkerSystemImpl = thisPtr;
        return Marker2SystemImpl(thisPtr);
    }

    void EquipHudSystemImplInitDataHook(void *thisPtr) {
        EquipHudSystemImpl = thisPtr;
        EquipHudSystemImplInitData(thisPtr);
    }

    void Marker2SystemImplRemovedUserMarkerHook(void *thisPtr, uint32_t markerID) {
        spdlog::info("{}: {}", __PRETTY_FUNCTION__, markerID);
        if (ignoreMarkerRequests) {
            spdlog::info("{}, ignored remove local marker request", __PRETTY_FUNCTION__);
            return;
        }

        Marker2SystemImplRemovedUserMarker(thisPtr, markerID);
        dynamiteSyncImpl.RemoveUserMarker(markerID);
    }

    void Marker2SystemImplPlacedUserMarkerFixedHook(void *thisPtr, Vector3 *pos) {
        spdlog::info("{}, placing fixed local user marker at {}, {}, {}", __PRETTY_FUNCTION__, pos->x, pos->y, pos->z);
        if (ignoreMarkerRequests) {
            spdlog::info("{}, ignored fixed local marker request", __PRETTY_FUNCTION__);
            return;
        }

        Marker2SystemImplPlacedUserMarkerFixed(thisPtr, pos);
        dynamiteSyncImpl.AddFixedUserMarker(pos);
    }

    bool Marker2SystemImplPlacedUserMarkerFollowHook(void *thisPtr, Vector3 *pos, unsigned short objectID) {
        spdlog::info("{}, {}, {}, {}, objectID {}", __PRETTY_FUNCTION__, pos->x, pos->y, pos->z, objectID);
        if (ignoreMarkerRequests) {
            spdlog::info("{}, ignored follow local marker request", __PRETTY_FUNCTION__);
            return true;
        }

        auto res = Marker2SystemImplPlacedUserMarkerFollow(thisPtr, pos, objectID);
        dynamiteSyncImpl.AddFollowUserMarker(pos, objectID);

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

    struct blockInfo {
        uint32_t counter;
        uint32_t blockState;
    };

    std::map<void *, blockInfo> processCounter{};
    std::map<void *, std::string> blockNames{};

    // used for debugging, see docs/issue_7.md
    double FoxBlockProcessHook(void *Block, void *TaskContext, void *BlockProcessState) {
        DWORD tid = GetCurrentThreadId();
        if (processCounter.contains(Block)) {
            processCounter[Block].counter++;
        } else {
            processCounter[Block].counter = 0;
            processCounter[Block].blockState = 0;
        }

        uint32_t blockState = *(uint32_t *)((char *)Block + 0x84);
        if ((processCounter[Block].counter % 500 == 0) || (processCounter[Block].blockState != blockState)) {
            auto blockName = blockNames[Block];
            uint32_t mem1 = *(int *)((char *)Block + 0x60);
            int32_t mem2 = *(int *)((char *)Block + 0x18);
            int32_t mem3 = *(int *)((char *)Block + 0x40);
            int32_t mem4 = *(int *)((char *)Block + 0x10);
            uint32_t mem5 = *(int *)((char *)Block + 0x148);
            processCounter[Block].blockState = blockState;
            auto processTime = *(double *)((char *)BlockProcessState + 0x28);
            auto total = mem1 - mem2 + mem3 + mem4;
            spdlog::info("{}, tid {}, process {} ({}), state {}, time {}, mem {} - {} + {} + {} = {} ({}), diff {}",
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
                mem5,
                mem5 - total);
        }

        //        if ((uint)((*(int *)(param_1 + 0x60) - *(int *)(param_1 + 0x18)) + *(int *)(param_1 + 0x40) +
        //                   *(int *)(param_1 + 0x10)) <= *(uint *)(param_1 + 0x148)) {

        return FoxBlockProcess(Block, TaskContext, BlockProcessState);
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockReloadHook(void *Block, int32_t *param_2) {
        DWORD tid = GetCurrentThreadId();
        processCounter[Block].counter = 0;
        auto blockName = blockNames[Block];
        spdlog::info("{}, tid {}, reload {} ({})", __PRETTY_FUNCTION__, tid, blockName, Block);
        return FoxBlockReload(Block, param_2);
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockUnloadHook(void *Block, int32_t *param_2) {
        DWORD tid = GetCurrentThreadId();
        processCounter[Block].counter = 0;
        auto blockName = blockNames[Block];
        auto res = FoxBlockUnload(Block, param_2);
        spdlog::info("{}, tid {}, unload {} ({}), res {}", __PRETTY_FUNCTION__, tid, blockName, Block, *res);
        return res;
    }

    std::string latestGeneratedName;

    // used for debugging, see docs/issue_7.md
    void *FoxGenerateUniqueNameHook(void *sharedString, unsigned long long param_2, void *string) {
        DWORD tid = GetCurrentThreadId();
        spdlog::info("{}, tid {}, generate name: {}", __PRETTY_FUNCTION__, tid, *(char **)*(void **)(string));
        latestGeneratedName = std::string(*(char **)*(void **)(string));

        return FoxGenerateUniqueName(sharedString, param_2, string);
    }

    // used for debugging, see docs/issue_7.md
    void *FoxBlockHook(void *p1) {
        DWORD tid = GetCurrentThreadId();
        spdlog::info("{}, tid {}, block: {} ({})", __PRETTY_FUNCTION__, tid, latestGeneratedName, p1);
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
        spdlog::info("{}, tid {}, activate {} ({}), res {}", __PRETTY_FUNCTION__, tid, blockName, Block, *q);
        spdlog::info("{}, {}, activate block status {} {}", __PRETTY_FUNCTION__, blockName, blockStatus(Block), blockStatus2(Block));
        return q;
    }

    // used for debugging, see docs/issue_7.md
    int32_t *FoxBlockDeactivateHook(void *Block, int32_t *param_2) {
        spdlog::info("{} deactivating {}", __PRETTY_FUNCTION__, Block);
        auto q = FoxBlockDeactivate(Block, param_2);
        DWORD tid = GetCurrentThreadId();
        auto blockName = blockNames[Block];
        spdlog::info(
            "{}, tid {}, deactivate {} ({}), res {}, status {} {}", __PRETTY_FUNCTION__, tid, blockName, Block, *q, blockStatus(Block), blockStatus2(Block));
        return q;
    }

    // used for debugging, see docs/issue_7.md
    int *FoxBlockLoadHook(void *thisPtr, int *errorCode, uint64_t *pathID, uint32_t count) {
        DWORD tid = GetCurrentThreadId();
        auto pp = pathID;
        auto blockName = blockNames[thisPtr];
        if (pathDict.empty()) {
            spdlog::info("{}, tid {}, block {} ({}), loading {:x} ({:d})", __PRETTY_FUNCTION__, tid, blockName, thisPtr, *pp, count);
            return FoxBlockLoad(thisPtr, errorCode, pathID, count);
        }

        for (int i = 0; i < count; i++) {
            auto name = pathDict[*pp];
            if (name.empty()) {
                spdlog::info("{}, tid {}, block {} ({}), loading {:x} ({:d}/{:d})", __PRETTY_FUNCTION__, tid, blockName, thisPtr, *pp, i + 1, count);
            } else {
                spdlog::info("{}, tid {}, block {} ({}), loading {} ({:d}/{})", __PRETTY_FUNCTION__, tid, blockName, thisPtr, name, i + 1, count);
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

    void *BlockHeapAllocHook(uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag) {
        if (categoryTag == MEMTAG_TPP_SYSTEM2SCRIPT) {
            // spdlog::info("{}, allocating {} bytes, {} align, category MEMTAG_TPP_SYSTEM2SCRIPT", __PRETTY_FUNCTION__, sizeInBytes, alignment);
            return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
        }

        if (!cfg.Host) {
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
        if (blockHeapAllocLoginUtilityCalled) {
            spdlog::info("{}, alloc MEMTAG_TPP_NETWORK force on heap", __PRETTY_FUNCTION__);
            return BlockMemoryAllocHeap(sizeInBytes, alignment, categoryTag);
        }

        blockHeapAllocLoginUtilityCalled = true;
        spdlog::info("{}, alloc MEMTAG_TPP_NETWORK run as is", __PRETTY_FUNCTION__);

        return BlockHeapAlloc(sizeInBytes, alignment, categoryTag);
    }

    void *CloseSessionHook() {
        spdlog::info("{}, closing session", __PRETTY_FUNCTION__);
        if (cfg.Host) {
            hostSessionCreated = false;
        }

        dynamiteSyncImpl.Stop();
        return CloseSession();
    }

    void ScriptDeclVarsImplSetVarValueHook(void *thisPtr, uint64_t index, uint32_t param_2, uint32_t param_3, uint32_t value) {
        auto tp = (char *)thisPtr + 0x18;
        auto hash = *(uint32_t *)(*(char **)tp + 0xc + index * 0x18 + -0x4);

        spdlog::info("{} {} (0x{:x}) = p1 = 0x{:x}, p2 = 0x{:x}, p3 = 0x{:x}, value = 0x{:x}",
            __PRETTY_FUNCTION__,
            messageDict[hash],
            hash,
            index,
            param_2,
            param_3,
            value);
        ScriptDeclVarsImplSetVarValue(thisPtr, index, param_2, param_3, value);
    }

    void SoldierRouteAiImplPreUpdateHook(void *thisPtr, uint32_t param_1, void *AiNodeUpdateContext) {
        auto qq = *((char *)AiNodeUpdateContext + 0x26);
        auto v = (unsigned char)qq;
        spdlog::info("{}, {} {:x} {:d}", __PRETTY_FUNCTION__, AiNodeUpdateContext, qq, v);
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
        spdlog::info("{}: {} (0x{:x}), {:d}, {:d}, {:d}", __PRETTY_FUNCTION__, name, res, param_1, param_2, param_3);
        return res;
    }

    fox::QuarkHandle FoxCreateQuarkHook(uint64_t param_1, fox::QuarkDesc *quarkDesc, uint64_t p3) {
        auto res = FoxCreateQuark(param_1, quarkDesc, p3);
        spdlog::info("{} {} (0x{:x}), p3 {:x}, handle 0x{:x}", __PRETTY_FUNCTION__, pathDict[(uint64_t)quarkDesc], (uint64_t)quarkDesc, p3, res.value);
        quarkHandles[res.value] = pathDict[(uint64_t)quarkDesc];
        return res;
    }

    void AiControllerImplAddNodeHook(void *thisPtr, uint32_t param_2, uint64_t quarkHandle, uint32_t param_4) {
        spdlog::info("{}, p2: {:x}, handle {} (0x{:x}), p4: {:x}", __PRETTY_FUNCTION__, param_2, quarkHandles[quarkHandle], quarkHandle, param_4);
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
        auto res = CoreAiImplGetVehicleRideState(thisPtr, param_1);
        spdlog::info("{}, {} -> {}", __PRETTY_FUNCTION__, param_1, static_cast<uint32_t>(res));
        return res;
    }

    bool CoreAiImplIsVehicleRetainHook(void *thisPtr, uint32_t param_1) {
        auto res = CoreAiImplIsVehicleRetain(thisPtr, param_1);
        spdlog::info("{}, {} -> {}", __PRETTY_FUNCTION__, param_1, res);
        return res;
    }

    bool SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStepHook(
        void *RouteAiImpl, uint32_t param_1, void *RouteAiKnowledge, bool param_3, bool param_4, bool param_5, bool param_6) {
        auto res = SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStep(RouteAiImpl, param_1, RouteAiKnowledge, param_3, param_4, param_5, param_6);
        spdlog::info("{}, p1: {}, p3: {}, p4: {}, p5: {}, p6: {}, res: {}", __PRETTY_FUNCTION__, param_1, param_3, param_4, param_5, param_6, res);
        return res;
    }

    bool StatusControllerImplIsSetHook(void *StatusControllerImpl, unsigned char param_1) {
        auto res = StatusControllerImplIsSet(StatusControllerImpl, param_1);
        if (param_1 == TppGameStatusFlag::S_IS_ONLINE) {
            spdlog::info("{}, {} -> {}", __PRETTY_FUNCTION__, "S_IS_ONLINE", res);
        }
        return res;
    }

    void *ScriptDeclVarsImplGetVarHandleWithVarIndexHook(void *ScriptDeclVarsImpl, void *param_1, uint32_t param_2) {
        auto res = ScriptDeclVarsImplGetVarHandleWithVarIndex(ScriptDeclVarsImpl, param_1, param_2);

        auto varsInfo = GmGetScriptVarInfo();
        auto tp = (char *)varsInfo + 0x8;
        auto hash = *(uint32_t *)(*(char **)tp + param_2 * 0x18 + 0x10);

        spdlog::info("{} {} 0x{:x} {} {} (0x{:x})", __PRETTY_FUNCTION__, param_1, param_2, res, messageDict[hash], hash);
        return res;
    }

    int32_t BandWidthManagerImplCalcAverageRttOfBetterHalfConnectionHook(void *thisPtr) {
        auto res = BandWidthManagerImplCalcAverageRttOfBetterHalfConnection(thisPtr);
        if (res != 0) {
            spdlog::info("{}: {}", __PRETTY_FUNCTION__, res);
        }
        return res;
    }

    int32_t BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnectionHook(void *thisPtr) {
        auto res = BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnection(thisPtr);
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

        if (cfg.debug.muxSendError) {
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
        if (recordBinWrites) {
            varsTotalSize += size;

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
        if ((gameSocketDesc->socketNumber == 6) && (gameSocketDesc->value == 1)) {
            // create socket when ScriptDeclVars creates one
            dynamiteSyncImpl.Init();
            dynamiteSyncImpl.SyncInit();
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

        scriptDeclVarsImpl = ScriptDeclVarsImpl;

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

        recordBinWrites = true;
        TppGmImplScriptDeclVarsImplOnSessionNotify(ScriptDeclVarsImpl, SessionInterface, param_2, param_3);
        recordBinWrites = false;

        spdlog::info(
            "{}, {} records, syncCount {}, wrote {} bits, will allocate {} bytes", __PRETTY_FUNCTION__, varCount, syncCount, varsTotalSize, varsTotalSize >> 3);

        if (syncCount > 0 && !cfg.Host) {
            //            dynamiteSyncImpl.WaitForSync();
        } else {
            dynamiteSyncImpl.Ping();
        }

        varsTotalSize = 0;
    }

    void *FoxNtImplSessionImpl2GetMemberInterfaceAtIndexHook(void *SessionImpl2, unsigned char index) {
        spdlog::info("{}, {} index {}", __PRETTY_FUNCTION__, SessionImpl2, index);
        return FoxNtImplSessionImpl2GetMemberInterfaceAtIndex(SessionImpl2, index);
    }

    void FoxNtImplGameSocketImplHandleMessageHook(void *GameSocketImpl, void *Buffer, uint32_t fromIndex, void *Buffer2, void *BitStreamReader) {
        if (GameSocketImpl == dynamiteSyncImpl.gameSocket) {
            auto uvar2 = *(int32_t *)((char *)GameSocketImpl + 0x10);
            spdlog::info("{}, handling game socket message ({}), from={}, uvar2={}!", __PRETTY_FUNCTION__, GameSocketImpl, fromIndex, uvar2);
        }

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
        if ((socket == 6) && (value == 1)) {
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
        camouflageControllerImpl = CamouflageControllerImpl;
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
        dynamiteSyncImpl.steamUDPAddress = Address;
        dynamiteSyncImpl.steamUDPSocketInfo = SocketInfo;
        dynamiteSyncImpl.steamUDPSocket = SteamUdpSocketImpl;

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
        dynamiteSyncImpl.RecvRaw(buffer, responseSize);

        return responseSize;
    }
}
