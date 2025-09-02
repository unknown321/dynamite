#include "dynamite.h"
#include "windows.h"
#include <eh.h>
#include <exception>
#include <filesystem>
#include <fstream>
#include <iostream>

#include "Config.h"
#include "Messagebox.h"
#include "MinHook.h"
#include "Tpp/TppGameObject.h"
#include "Tpp/TppNPCLifeState.h"
#include "memtag.h"
#include "mgsvtpp_addresses_1_0_15_3_en.h"
#include "mgsvtpp_func_typedefs.h"
#include "mgsvtpp_funcptr_set.h"
#include "patch.h"
#include "spdlog/sinks/basic_file_sink.h"
#include "spdlog/spdlog.h"
#include "util.h"

#include "DynamiteHook.h"
#include "DynamiteLua.h"

namespace Dynamite {
    terminate_function terminate_Original;

    Config cfg{};
    std::map<std::string, uint64_t> addressSet{};
    unsigned int offensePlayerID = 0;
    unsigned int defensePlayerID = 15;
    bool stopNearestEnemyThread = false;
    bool nearestEnemyThreadRunning = false;
    lua_State *luaState = nullptr;
    bool sessionCreated = false;
    bool sessionConnected = false;
    bool ignoreMarkerRequests = false;

    void *DamageControllerImpl = nullptr;
    void *MarkerSystemImpl = nullptr;
    void *SightManagerImpl = nullptr;
    void *EquipHudSystemImpl = nullptr;

    std::map<uint32_t, std::string> messageDict{};
    std::map<uint64_t, std::string> pathDict{};
    std::map<uint64_t, std::string> quarkHandles{};

    void AbortHandler(int signal_number) {
        auto l = spdlog::get(logName);
        if (l != nullptr) {
            l->error("abort was called");
            l->flush();
        }
    }

    void TerminateHandler() {
        auto l = spdlog::get(logName);
        if (l != nullptr) {
            l->error("terminate was called");
            l->flush();
        }

        terminate_Original();
    }

    bool g_showCrashDialog = true;
    LONG WINAPI UnhandledExceptionHandler(EXCEPTION_POINTERS * /*ExceptionInfo*/) {
        auto log = spdlog::get(logName);
        if (log != nullptr) {
            log->error("Unhandled exception");
            log->flush();
        }

        return g_showCrashDialog ? EXCEPTION_CONTINUE_SEARCH : EXCEPTION_EXECUTE_HANDLER;
    }

    void Dynamite::ReadConfig() {
        ConfigValidateResult r{};
        if (!cfg.Read(&r)) {
            spdlog::error(r.Message);
            ShowMessageBox(r.Message.c_str(), "Config error", MB_ICONERROR);
            exit(1);
        }

        cfg.Log();
    }

    // essentially tpp::gm::tool::`anonymous_namespace'::GetSessionMemberCount
    int GetMemberCount() {
        if ((!sessionCreated) && (!hostSessionCreated)) {
            //            spdlog::info("{}, no session created, member count 1", __FUNCTION__);
            return 1;
        }

        auto session = GetMainSession();
        if (session == nullptr) {
            spdlog::error("{} Main session is null", __FUNCTION__);
            return 1;
        }

        auto session2impl = (void *)((char *)session + 0x20);
        if (session2impl == nullptr) {
            spdlog::error("{} Session2Impl is null", __FUNCTION__);
            return 1;
        }

        return GetSessionMemberCount(session2impl);
    }

    Vector3 GetPlayerPosition(int index) {
        auto playerPos = BlockHeapAlloc(4 * 4, 4, MEMTAG_NULL);
        PlayerInfoServiceGetPositionAtIndex(playerPos, index);
        auto result = Vector3();
        result.x = *(float *)(playerPos);
        result.y = *(float *)((char *)playerPos + 4);
        result.z = *(float *)((char *)playerPos + 8);
        //            auto w = *(float*)((char*)playerPos + 12);
        BlockHeapFree(playerPos);

        return result;
    }

    int GetNearestPlayer() {
        if (GetMemberCount() == 1) {
            if (cfg.debug.playerTarget) {
                spdlog::info("{}, one player", __FUNCTION__);
            }
            return 0;
        }

        auto minDistance = 99999;
        auto minDistancePlayer = 0;

        std::vector<Vector3> playerPositions;
        for (int i = 0; i < GetMemberCount(); i++) {
            auto pos = GetPlayerPosition(i);
            if (!pos.Valid()) {
                if (cfg.debug.playerTarget) {
                    spdlog::info("{}, player {}, invalid position {} {} {}", __FUNCTION__, i, pos.x, pos.y, pos.z);
                }
                break;
            }

            if (cfg.debug.playerTarget) {
                spdlog::info("{}, player {}, valid position {} {} {}", __FUNCTION__, i, pos.x, pos.y, pos.z);
            }
            playerPositions.push_back(pos);
        }

        auto range = GetTypeRange(GAME_OBJECT_TYPE_SOLDIER2);
        for (int i = range.first; i < range.second; i++) {
            auto soldierStatus = GetSoldierLifeStatus(i);

            switch (soldierStatus) {
            case DEAD:
            case DYING:
            case SLEEP:
            case FAINT:
                continue;
            case NORMAL:
                break;
            }

            auto soldierPos = GetSoldierPosition(i);
            if (!soldierPos.Valid()) {
                continue;
            }

            if (!positionValid(soldierPos)) {
                continue;
            }

            if (cfg.debug.playerTarget) {
                spdlog::info("{}, soldier {}, valid pos {:03.2f} {:03.2f} {:03.2f}", __FUNCTION__, i, soldierPos.x, soldierPos.y, soldierPos.z);
            }

            for (int p = 0; p < playerPositions.size(); p++) {
                auto ppos = playerPositions[p];
                auto distance = static_cast<int>(calculateDistance(ppos, soldierPos));
                if (distance < minDistance) {
                    if ((distance > -1000) && (distance < 1000)) {
                        minDistance = distance;
                        minDistancePlayer = p;
                    }
                }
            }
        }

        if (cfg.debug.playerTarget) {
            spdlog::info("{}, nearest player: {:d}, distance: {:d}", __FUNCTION__, minDistancePlayer, minDistance);
        }

        return minDistancePlayer;
    }

    ENPCLifeState GetSoldierLifeStatus(int objectID) {
        auto go = FindGameObjectWithID(objectID);
        if (go == nullptr) {
            return ENPCLifeState::NORMAL;
        }

        go = *(void **)((char *)go + 0x40);
        go = *(void **)((char *)go + 0x10);

        auto interfaceName = "TppSoldier2";
        auto hash = FoxStrHash32(interfaceName, strlen(interfaceName)); // 3fef1d0298aa
        auto soldierInterface = Soldier2ImplGetInterface((void *)go, hash);
        if (soldierInterface == nullptr) {
            return ENPCLifeState::NORMAL;
        }
        soldierInterface = (char *)soldierInterface - 0xc;

        auto pos1 = *(void **)((char *)soldierInterface + 0x38);
        auto position = *(char **)((char *)pos1 + 0x8) + 0x3e + 0x40 * (objectID - 1024);

        if (*position == 2) {
            return ENPCLifeState::DEAD;
        }

        position = *(char **)((char *)pos1 + 0x8) + 0x12 + 0x40 * (objectID - 1024);
        switch ((*(char *)position) & 3) {
        case 1:
            return ENPCLifeState::SLEEP;
        case 2:
            return ENPCLifeState::FAINT;
        case 3:
            return ENPCLifeState::DYING;
        case 4:
            return ENPCLifeState::NORMAL;
        default:
            return ENPCLifeState::NORMAL;
        }

        return ENPCLifeState::NORMAL;
    }

    Vector3 GetSoldierPosition(int objectID) {
        auto go = FindGameObjectWithID(objectID);
        if (go == nullptr) {
            return {};
        }

        go = *(void **)((char *)go + 0x40);
        go = *(void **)((char *)go + 0x10);

        auto interfaceName = "TppSoldier2";
        auto hash = FoxStrHash32(interfaceName, strlen(interfaceName)); // 3fef1d0298aa
        auto soldierInterface = Soldier2ImplGetInterface((void *)go, hash);
        if (soldierInterface == nullptr) {
            return {};
        }
        soldierInterface = (char *)soldierInterface - 0xc;

        auto pos1 = *(void **)((char *)soldierInterface + 0x18);
        auto position = *(char **)((char *)pos1 + 0x20) + 0x10 * (objectID - 1024);
        auto result = Vector3();
        result.x = *(float *)position;
        result.y = *(float *)(position + 4);
        result.z = *(float *)(position + 8);

        return result;
    }

    void StartNearestEnemyThread() {
        spdlog::info("{}, starting", __FUNCTION__);
        if (!cfg.Host) {
            spdlog::info("{}, not starting for client", __FUNCTION__);
            return;
        }

        if (nearestEnemyThreadRunning) {
            spdlog::info("{}, nearest enemy thread already running", __FUNCTION__);
            return;
        }

        auto loop = [](bool *stop, bool *nearestEnemyThreadStatus) {
            for (;;) {
                if (*stop) {
                    *stop = false;
                    *nearestEnemyThreadStatus = false;
                    spdlog::info("StartNearestEnemyThread(), stopped");
                    return;
                }

                *nearestEnemyThreadStatus = true;
                auto opID = GetNearestPlayer();
                if (cfg.debug.playerTarget) {
                    if (opID != offensePlayerID) {
                        spdlog::info("changing offense player ID from {:d} to {:d}", offensePlayerID, opID);
                    }
                }
                offensePlayerID = opID;
                std::this_thread::sleep_for(std::chrono::milliseconds(500));
            }
        };
        std::thread d(loop, &stopNearestEnemyThread, &nearestEnemyThreadRunning);
        d.detach();
    }

    void Dynamite::RebaseAddresses() const {
        for (auto const &entry : addressSet) {
            std::string name = entry.first;
            uint64_t addr = entry.second;
            uint64_t rebasedAddr = (addr - BaseAddr) + RealBaseAddr;
            addressSet[name] = rebasedAddr;
        }
    }

    void Dynamite::CreateDebugHooks() {
        if (cfg.debug.foxBlock) {
            CREATE_HOOK(FoxBlockUnload)
            ENABLEHOOK(FoxBlockUnload)

            CREATE_HOOK(FoxBlock)
            ENABLEHOOK(FoxBlock)

            CREATE_HOOK(FoxBlockReload)
            ENABLEHOOK(FoxBlockReload)

            CREATE_HOOK(FoxGenerateUniqueName)
            ENABLEHOOK(FoxGenerateUniqueName)

            CREATE_HOOK(FoxBlockActivate)
            ENABLEHOOK(FoxBlockActivate)

            CREATE_HOOK(FoxBlockDeactivate)
            ENABLEHOOK(FoxBlockDeactivate)

            CREATE_HOOK(FoxBlockLoad)
            ENABLEHOOK(FoxBlockLoad)
        }

        if (cfg.debug.foxBlockProcess) {
            CREATE_HOOK(FoxBlockProcess)
            ENABLEHOOK(FoxBlockProcess)
        }

        if (cfg.debug.memoryAllocTail) {
            CREATE_HOOK(BlockMemoryAllocTail)
            ENABLEHOOK(BlockMemoryAllocTail)
        }

        if (cfg.debug.setScriptVars) {
            CREATE_HOOK(ScriptDeclVarsImplSetVarValue)
            ENABLEHOOK(ScriptDeclVarsImplSetVarValue)
        }

        CREATE_HOOK(RouteGroupImplGetEventId)
        ENABLEHOOK(RouteGroupImplGetEventId)

        CREATE_HOOK(FoxCreateQuark)
        ENABLEHOOK(FoxCreateQuark)

        CREATE_HOOK(AiControllerImplAddNode)
        ENABLEHOOK(AiControllerImplAddNode)

        //        CREATE_HOOK(SoldierRouteAiImplPreUpdate)
        //        ENABLEHOOK(SoldierRouteAiImplPreUpdate)
    }

    void Dynamite::CreateHooks() {
        ReadConfig();

        CreateDebugHooks();

        CREATE_HOOK(luaL_openlibs)
        ENABLEHOOK(luaL_openlibs)

        CREATE_HOOK(IsDefenseTeamByOnlineFobLocal)
        ENABLEHOOK(IsDefenseTeamByOnlineFobLocal)

        CREATE_HOOK(IsOffenseTeamByOnlineFobLocal)
        ENABLEHOOK(IsOffenseTeamByOnlineFobLocal)

        CREATE_HOOK(SetSteamId)
        ENABLEHOOK(SetSteamId)

        CREATE_HOOK(IsConnectReady)
        ENABLEHOOK(IsConnectReady)

        CREATE_HOOK(UpdateClientEstablished)
        ENABLEHOOK(UpdateClientEstablished)

        CREATE_HOOK(GetFobOffensePlayerInstanceIndex)
        ENABLEHOOK(GetFobOffensePlayerInstanceIndex)

        CREATE_HOOK(GetFobDefensePlayerInstanceIndex)
        ENABLEHOOK(GetFobDefensePlayerInstanceIndex)

        CREATE_HOOK(GetUiMarkerTypeFromSystemType2)
        ENABLEHOOK(GetUiMarkerTypeFromSystemType2)

        CREATE_HOOK(SightManagerImplSetMarker)
        ENABLEHOOK(SightManagerImplSetMarker)

        CREATE_HOOK(SteamUdpSocketImplOnP2PSessionRequest)
        ENABLEHOOK(SteamUdpSocketImplOnP2PSessionRequest)

        CREATE_HOOK(MessageBufferAddMessage)
        ENABLEHOOK(MessageBufferAddMessage)

        CREATE_HOOK(AddLocalDamage)
        ENABLEHOOK(AddLocalDamage)

        CREATE_HOOK(DamageControllerImplInitialize)
        ENABLEHOOK(DamageControllerImplInitialize)

        CREATE_HOOK(SynchronizerImplGetDamage)
        ENABLEHOOK(SynchronizerImplGetDamage)

        CREATE_HOOK(Marker2SystemImpl)
        ENABLEHOOK(Marker2SystemImpl)

        CREATE_HOOK(EquipHudSystemImplInitData)
        ENABLEHOOK(EquipHudSystemImplInitData)

        CREATE_HOOK(Marker2SystemImplRemovedUserMarker)
        ENABLEHOOK(Marker2SystemImplRemovedUserMarker)

        CREATE_HOOK(Marker2SystemImplPlacedUserMarkerFixed)
        ENABLEHOOK(Marker2SystemImplPlacedUserMarkerFixed)

        CREATE_HOOK(Marker2SystemImplPlacedUserMarkerFollow)
        ENABLEHOOK(Marker2SystemImplPlacedUserMarkerFollow)

        CREATE_HOOK(SightManagerImplInitialize)
        ENABLEHOOK(SightManagerImplInitialize)

        CREATE_HOOK(UiControllerImplSetNoUseEquipId)
        ENABLEHOOK(UiControllerImplSetNoUseEquipId)

        CREATE_HOOK(EquipCrossEvCallIsItemNoUse)
        ENABLEHOOK(EquipCrossEvCallIsItemNoUse)

        CREATE_HOOK(CreateHostSession)
        ENABLEHOOK(CreateHostSession)

        CREATE_HOOK(CloseSession)
        ENABLEHOOK(CloseSession)

        CREATE_HOOK(BlockHeapAlloc)
        ENABLEHOOK(BlockHeapAlloc)

        CREATE_HOOK(FobTargetCtor)
        ENABLEHOOK(FobTargetCtor)

        for (auto p : GetPatches()) {
            if (!p.Apply()) {
                std::stringstream msg;
                msg << "Failed to apply patch: " << p.description << ".";
                spdlog::error(msg.str());
                ShowMessageBox(msg.str().c_str(), "Dynamite error", MB_ICONERROR);
                exit(1);
            }
        }

        if (!PatchMasterServerURL(cfg.MasterServerURL)) {
            auto msg = "Failed to patch master server url.";
            spdlog::error(msg);
            ShowMessageBox(msg, "Dynamite error", MB_ICONERROR);
            exit(1);
        }
    }

    void Dynamite::SetupLogger() {
        log = spdlog::basic_logger_st(logName, logPath.string(), true);
        spdlog::set_default_logger(log);
        // using `flush_every` with multithreaded logger will result in application hang during DLL_PROCESS_DETACH
        spdlog::flush_on(spdlog::level::info);
        log->info("starting");
        log->info("dynamite {}", SOFTWARE_VERSION);
    }

    Dynamite::Dynamite() : thisModule{GetModuleHandle(nullptr)} {
        signal(SIGABRT, &AbortHandler);
        terminate_Original = std::set_terminate(TerminateHandler);
        _set_abort_behavior(1, _WRITE_ABORT_MSG);
        SetUnhandledExceptionFilter(UnhandledExceptionHandler);

        SetupLogger();

        // mgo bad
        HMODULE hExe = GetModuleHandle(nullptr);
        WCHAR fullPath[MAX_PATH]{0};
        GetModuleFileNameW(hExe, fullPath, MAX_PATH);
        std::filesystem::path path(fullPath);
        std::wstring exeName = path.filename().c_str();
        if (exeName.find(L"mgo") != std::wstring::npos) {
            return;
        }

        MH_Initialize();

        addressSet = mgsvtpp_adresses_1_0_15_3_en;
        RealBaseAddr = (size_t)GetModuleHandle(nullptr);

        RebaseAddresses();
        SetFuncPtrs();
        CreateHooks();
    }

    Dynamite::~Dynamite() {
        MH_Uninitialize();
        spdlog::shutdown();
    }

    std::vector<Patch> GetPatches() {
        return {
            {
                .address = 0x140ffa9ff,
                .expected = {0x74, 0x07}, // JZ 0x140ffaa08
                .patch = {0xeb, 0x07},    // JMP 0x140ffaa08
                .description = "Apply damage to player no matter what, "
                               "tpp::gm::player::impl::`anonymous_namespace'::DefenseCallback::TargetCallbackExec",
            },
            {
                .address = 0x141378209,
                .expected = {0x74, 0x5c}, // JZ 0x141378267
                .patch = {0x48, 0x90},    // NOP
                .description = "Attempt to fix damage (not needed?), "
                               "tpp::gm::soldier::impl::ActionCoreImpl::ExecGrazeCallback",
            },
            {
                .address = 0x149f57ac7,
                .expected = {0x74, 0x1a}, // JZ 0x149f57ae3
                .patch = {0xeb, 0x1a},    // JMP 0x149f57ae3
                .description = "Always update action task, "
                               "tpp::gm::soldier::impl::ActionControllerImpl::UpdateActionTask",
            },
            {
                .address = 0x1417a200e,
                .expected = {0x74, 0x19}, // JZ 0x1417a2029
                .patch = {0x48, 0x90},    // NOP
                .description = "Always respawn player no matter what, "
                               "tpp::gm::player::impl::RespawnActionPluginImpl::UpdatePlaySubState",
            },
            {
                .address = 0x14133d9cb,
                .expected = {0x0f, 0x84, 0xdc, 0x03, 0x00, 0x00}, // JZ 0x14133ddad
                .patch = {0x66, 0x48, 0x90, 0x66, 0x48, 0x90},    // NOP NOP
                .description = "Skip sight controller host check, always run host code, ignore IsHost call, "
                               "tpp::gm::impl::`anonymous_namespace`::SightControllerImpl::Update. "
                               "Without it soldiers will lose track of client after raising an alert.",
            },
            {
                .address = 0x140ebcfc4,
                .expected = {0x74, 0x2e}, // JZ 0x140ebcff4
                .patch = {0x48, 0x90},    // NOP
                .description = "Client always uses host code for SetHostage2Flag lua command, "
                               "tpp::gm::hostage::impl::Hostage2FlagInfoImpl::RequestSetAndSyncImpl",
            },
            {
                .address = 0x140887905,
                .expected = {0x74, 0x1c}, // JZ 0x140887923
                .patch = {0xeb, 0x1c},    // JMP 0x140887923
                .description = "Do not send sneak result (online request) on game over, "
                               "tpp::ui::menu::GameOverEvCall::UpdateGameOver",
            },
            {
                .address = 0x1416026ce,
                .expected = {0xff, 0x90, 0x68, 0x03, 0x00, 0x00}, // CALL qword ptr RAX+0x368
                .patch = {0xf2, 0x48, 0x90, 0xf2, 0x48, 0x90},    // NOP NOP
                .description = "Do not send sneak result on mission end (fob results screen)"
                               "tpp::ui::hud::impl::TppUIFobResultImpl::UpdateFobResult",
            },
            {
                .address = 0x145ccff85,
                .expected = {0x74, 0x09}, // JZ 0x145ccff90
                .patch = {0x48, 0x90},    // NOP
                .description = "Skip Resume Game prompt"
                               "tpp::ui::menu::LoadingTipsEv::UpdateActPhase",
            },
            {
                .address = 0x144e42a62,
                .expected = {0x0f, 0x094, 0xd0}, // SETZ AL
                .patch = {0x40, 0xb0, 0x01},     // MOV AL, 0x01
                .description = "Trap check is player and local is always true #2, fix crash on enter"
                               "tpp::TrapCheckIsPlayerAndLocalCallback::ExecCallback",
            },
            {
                .address = 0x144e42a8e,
                .expected = {0x30, 0xc0}, // XOR AL, AL
                .patch = {0xb0, 0x01},    // MOV AL, 0x1
                .description = "Trap check is player and local is always true, fix crash on enter"
                               "tpp::TrapCheckIsPlayerAndHostCallback::ExecCallback",
            },
            {
                .address = 0x144e46f45,
                .expected = {0x30, 0xc0}, // XOR AL, AL
                .patch = {0xb0, 0x01},    // MOV AL, 0x1
                .description = "Trap check is player and host is always true, fix crash on enter"
                               "tpp::TrapCheckIsPlayerAndHostCallback",
            },
            {
                .address = 0x14625fd1a,
                .expected = {0x75, 0xd}, // JNZ 0x14625fd29
                .patch = {0x48, 0x90},   // NOP
                .description = "DoesFobGhostPlayer remove mission ID check"
                               "tpp::gm::player::impl::Player2GameObjectImpl::DoesFobGhostPlayer"
                               "without it mission won't load (infinite loading)",
            },
            {
                .address = 0x1459b60b5,
                // clang-format off
                    .expected =
                        {
                            0x48, 0x83, 0x79, 0x58, 0x00, // CMP qword ptr [RCX + 0x58], 0x0
                            0x48, 0x89, 0xcb, // MOV RBX, RCX
                            0x75, 0x09, // JMP LAB_1459b60c8
                        },
                    .patch =
                        {
                            0xf2, 0x48, 0x90, // NOP
                            0x48, 0x90, // NOP
                            0x48, 0x89, 0xcb, // MOV RBX, RCX
                            0x48, 0x90, // NOP
                        },
                // clang-format on
                .description = "Always start fob p2p resolver, ignore exists check (not needed?)"
                               "tpp::net::Daemon::StarFobP2pNameResolver",
            },
            {
                .address = 0x140da58e5,
                .expected = {0x0f, 0x84, 0x41, 0x05, 0x00, 0x00}, // JZ LAB_140da5e2c
                .patch = {0x66, 0x48, 0x90, 0x66, 0x48, 0x90},    // NOP NOP
                .description =
                    "Always run host damage controller implementation"
                    "Fixes crash on shooting animals (like goats in PITCH BLACK after the village at {-711.90826416016, 5.1010074615479, 661.36602783203})"
                    "tpp::gm::impl::`anonymous_namespace'::DamageControllerImpl::Update",
            },
            {
                .address = 0x146457b68,
                .expected = {0x75, 0x13}, // JNZ LAB_146457b7d
                .patch = {0x48, 0x90},    // NOP
                .description = "always run full CloseSession code, ignore mission code check"
                               "tpp::gm::tool::`anonymous_namespace'::CloseSession",
            },
            {
                .address = 0x14163fcda,
                .expected = {0x0f, 0x84, 0xa2, 0x01, 0x00, 0x00}, // JZ LAB_14163fe82
                .patch = {0x66, 0x48, 0x90, 0x66, 0x48, 0x90},    // NOP NOP
                .description =
                    "add Quiet and Ocelot to staff list in sortie by ignoring tpp::ui::menu::impl::MissionPreparationSystemImpl::IsFobMissionMode check result"
                    "tpp::ui::menu::impl::CharacterSelectorCallbackImpl::SetupStaffList",

            },
            {
                .address = 0x1409cc6c0,
                .expected = {0x0f, 0x85, 0x9c, 0x07, 0x00, 0x00}, // JNZ LAB_1409cce62
                .patch = {0x48, 0xe9, 0x9c, 0x07, 0x00, 0x00},    // JMP LAB_1409cce62
                .description = "skip some check that resets player to Snake from Quiet/Ocelot"
                               "tpp::gm::player::impl::Player2GameObjectImpl::UpdatePartsStatus",
            },
            {
                .address = 0x149cfba54,
                .expected = {0x74, 0x10}, // JZ LAB_149cfba66
                .patch = {0x48, 0x90},    // NOP
                .description = "skip check and call FUN_1411b4350 that sets up dual revolvers for Ocelot"
                               "tpp::gm::player::impl::UnrealUpdaterImpl::PreUpdate",
            },
            {
                .address = 0x149f4f17b,
                .expected = {0x74, 0x07}, // JZ LAB_149f4f184
                .patch = {0xeb, 0x07},    // JMP LAB_149f4f184
                .description = "always use non-fob function to update cp member status"
                               "tpp::gm::soldier::impl::Soldier2Impl::UpdateCpMemberStatus",
            },
        };
    }

    bool PatchMasterServerURL(const std::string &url) {
        // a better approach would be changing string address in tpp::net::LoginUtility::Update
        // that will allow longer addresses
        // lets keep it simple for now

        if (url.length() > 69) {
            return false;
        }
        // clang-format off
            auto expected = std::vector<int16_t>{0x68, 0x74, 0x74, 0x70, 0x73, 0x3a, 0x2f, 0x2f, 0x6d, 0x67, 0x73,
                0x74, 0x70, 0x70, 0x2d, 0x67, 0x61, 0x6d, 0x65, 0x2e, 0x6b, 0x6f, 0x6e,
                0x61, 0x6d, 0x69, 0x6f, 0x6e, 0x6c, 0x69, 0x6e, 0x65, 0x2e, 0x63, 0x6f,
                0x6d, 0x2f, 0x74, 0x70, 0x70, 0x73, 0x74, 0x6d, 0x2f, 0x67, 0x61, 0x74,
                0x65, 0x0}; //  "https://mgstpp-game.konamionline.com/tppstm/gate\0"
        // clang-format on

        auto patch = std::vector<int16_t>();
        for (auto v : url) {
            patch.push_back(v);
        }
        patch.push_back(0);

        auto p = Patch{
            .address = 0x142218770,
            .expected = expected,
            .patch = patch,
            .description = "override master server url",
        };

        return p.Apply();
    }
}