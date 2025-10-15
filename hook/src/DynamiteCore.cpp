#include "DynamiteCore.h"

#include "DynamiteHook.h"
#include "EmblemInfo.h"
#include "ScriptVarResult.h"
#include "Tpp/TppGameObject.h"
#include "Tpp/TppNPCLifeState.h"
#include "memtag.h"
#include "mgsvtpp_func_typedefs.h"
#include "util.h"

#include <spdlog/spdlog.h>

namespace Dynamite {
    void DynamiteCore::WithConfig(Config *c) { cfg = c; }

    // essentially tpp::gm::tool::`anonymous_namespace'::GetSessionMemberCount
    int DynamiteCore::GetMemberCount() const {
        if ((!sessionCreated) && (!hostSessionCreated)) {
            //            spdlog::info("{}, no session created, member count 1", __FUNCTION__);
            return 1;
        }

        const auto session = FoxNtSessionGetMainSession();
        if (session == nullptr) {
            spdlog::error("{} Main session is null", __FUNCTION__);
            return 1;
        }

        const auto session2impl = (void *)((char *)session + 0x20);
        if (session2impl == nullptr) {
            spdlog::error("{} Session2Impl is null", __FUNCTION__);
            return 1;
        }

        return GetSessionMemberCount(session2impl);
    }

    int DynamiteCore::GetNearestPlayer() const {
        if (GetMemberCount() == 1) {
            if (cfg->debug.playerTarget) {
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
                if (cfg->debug.playerTarget) {
                    spdlog::info("{}, player {}, invalid position {} {} {}", __FUNCTION__, i, pos.x, pos.y, pos.z);
                }
                break;
            }

            if (cfg->debug.playerTarget) {
                spdlog::info("{}, player {}, valid position {} {} {}", __FUNCTION__, i, pos.x, pos.y, pos.z);
            }
            playerPositions.push_back(pos);
        }

        const auto [rangeStart, rangeEnd] = GetTypeRange(GAME_OBJECT_TYPE_SOLDIER2);
        for (int i = rangeStart; i < rangeEnd; i++) {
            const auto soldierStatus = GetSoldierLifeStatus(i);

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

            if (cfg->debug.playerTarget) {
                spdlog::info("{}, soldier {}, valid pos {:03.2f} {:03.2f} {:03.2f}", __FUNCTION__, i, soldierPos.x, soldierPos.y, soldierPos.z);
            }

            for (int p = 0; p < playerPositions.size(); p++) {
                const auto ppos = playerPositions[p];
                const auto distance = static_cast<int>(calculateDistance(ppos, soldierPos));
                if (distance < minDistance) {
                    if ((distance > -1000) && (distance < 1000)) {
                        minDistance = distance;
                        minDistancePlayer = p;
                    }
                }
            }
        }

        if (cfg->debug.playerTarget) {
            spdlog::info("{}, nearest player: {:d}, distance: {:d}", __FUNCTION__, minDistancePlayer, minDistance);
        }

        return minDistancePlayer;
    }

    Vector3 DynamiteCore::GetPlayerPosition(const int index) {
        const auto playerPos = BlockHeapAlloc(4 * 4, 4, MEMTAG_NULL);
        PlayerInfoServiceGetPositionAtIndex(playerPos, index);
        auto result = Vector3();
        result.x = *(float *)(playerPos);
        result.y = *(float *)((char *)playerPos + 4);
        result.z = *(float *)((char *)playerPos + 8);
        //            auto w = *(float*)((char*)playerPos + 12);
        BlockHeapFree(playerPos);

        return result;
    }

    ENPCLifeState DynamiteCore::GetSoldierLifeStatus(const int objectID) {
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

    Vector3 DynamiteCore::GetSoldierPosition(const int objectID) {
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

    EmblemInfo DynamiteCore::GetEmblemInfo() {
        // see tpp::ui::emblem::impl::EmblemEditorSystemImpl::LoadFromVars

        const auto qt = GetQuarkSystemTable();
        const auto v1 = *(uint64_t *)((char *)qt + 0x98);
        const auto vars = *(void **)(v1 + 0x10);

        EmblemInfo result;
        memcpy(result.emblemTextureTag, (char *)vars + 0x230, sizeof(uint32_t) * 4);
        memcpy(result.emblemColorL, (char *)vars + 0x240, sizeof(uint32_t) * 4);
        memcpy(result.emblemColorH, (char *)vars + 0x250, sizeof(uint32_t) * 4);
        memcpy(result.emblemX, (char *)vars + 0x260, sizeof(uint8_t) * 4);
        memcpy(result.emblemY, (char *)vars + 0x264, sizeof(uint8_t) * 4);
        memcpy(result.emblemScale, (char *)vars + 0x268, sizeof(uint8_t) * 4);
        memcpy(result.emblemRotate, (char *)vars + 0x26c, sizeof(uint8_t) * 4);

        return result;
    }

    // values from gvars or svars
    ScriptVarResult DynamiteCore::GetSVar(const std::string &catName, const std::string &varName) {
        const auto hash = (uint32_t)(FoxStrHash32(varName.c_str(), varName.length()) & 0xffffffff);
        const auto catHash = (uint32_t)(FoxStrHash32(catName.c_str(), catName.length()) & 0xffffffff);

        const auto qt = GetQuarkSystemTable();
        const auto v1 = *(uint64_t *)((char *)qt + 0x98);
        const auto scriptSystemImpl = *(void **)(v1 + 0x18);

        ScriptVarResult s{};

        const auto handle = BlockHeapAlloc(8, 8, MEMTAG_TPP_SYSTEM2SCRIPT);
        TppGmImplScriptSystemImplGetScriptDeclVarHandle(scriptSystemImpl, handle, catHash, hash);
        if (handle == nullptr) {
            spdlog::error("{}, no handle for var {}.{}", __PRETTY_FUNCTION__, catName, varName);
            return s;
        }

        auto varType = *(unsigned char *)((char *)handle + 0xC) & 7;
        if (varType > TYPE_MAX) {
            spdlog::error("{}, invalid var type {}.{} {}", __PRETTY_FUNCTION__, catName, varName, varType);
            return s;
        }

        auto arraySize = *(unsigned short *)((char *)handle + 0x8);
        if (arraySize == 0) {
            spdlog::error("{}, invalid var size {}.{}: {}", __PRETTY_FUNCTION__, catName, varName, arraySize);
            return s;
        }

        spdlog::info("{}: {}, type {}, size {}", __PRETTY_FUNCTION__, varName, varType, arraySize);

        auto elementSize = 1;

        switch (varType) {
        case TYPE_INT32:
            elementSize = 4;
            break;
        case TYPE_UINT32:
            elementSize = 4;
            break;
        case TYPE_FLOAT:
            elementSize = 4;
            break;
        case TYPE_INT8:
            elementSize = 1;
            break;
        case TYPE_UINT8:
            elementSize = 1;
            break;
        case TYPE_INT16:
            elementSize = 2;
            break;
        case TYPE_UINT16:
            elementSize = 2;
            break;
        case TYPE_BOOL:
            break;
        default:
            break;
        }

        s.type = static_cast<TppVarType>(varType);

        const auto dataStart = *(unsigned short *)((char *)handle + 0xA);
        const auto offset = *(uint64_t *)handle;
        BlockHeapFree(handle);
        for (int i = 0; i < arraySize; i++) {
            if (varType == TYPE_BOOL) {
                auto res = (*(unsigned char *)(((i + dataStart) >> 3) + offset) & 1 << ((unsigned char)(i + dataStart) & 7)) != 0;
                s.bools.push_back(res);

                spdlog::info("{}, {}, {}: {}", __PRETTY_FUNCTION__, varName, i, res);
                continue;
            }

            auto value = offset + (dataStart + i) * elementSize;
            switch (varType) {
            case TYPE_INT32:
                spdlog::info("{}, {}, {}: {}", __PRETTY_FUNCTION__, varName, i, *(int32_t *)value);
                s.int32s.push_back(*(int32_t *)value);
                break;
            case TYPE_UINT32: {
                spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(uint32_t *)value);
                s.uint32s.push_back(*(uint32_t *)value);
                break;
            }
            case TYPE_FLOAT:
                spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(float *)value);
                s.floats.push_back(*(float *)value);
                break;
            case TYPE_INT8:
                spdlog::info("{}, {} {}: {:d}", __PRETTY_FUNCTION__, varName, i, *(signed char *)value);
                s.int8s.push_back(*(int8_t *)value);
                break;
            case TYPE_UINT8:
                spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(unsigned char *)value);
                s.uint8s.push_back(*(uint8_t *)value);
                break;
            case TYPE_INT16:
                spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(short *)value);
                s.int16s.push_back(*(int16_t *)value);
                break;
            case TYPE_UINT16:
                spdlog::info("{}, {} {}: {}", __PRETTY_FUNCTION__, varName, i, *(unsigned short *)value);
                s.uint16s.push_back(*(uint16_t *)value);
                break;
            case TYPE_BOOL:
            default:
                break;
            }
        }

        return s;
    }

    void *DynamiteCore::GetEmblemEditorSystemImpl() {
        const auto qt = GetQuarkSystemTable();
        // see tpp::ui::menu::impl::MissionPreparationCallbackImpl::UpdateEmblem
        const auto res = *(void **)(*(uint64_t *)(*(uint64_t *)((char *)qt + 0x98) + 0x40) + 0x60);
        return res;
    }

    void DynamiteCore::CreateEmblem(EmblemInfo info) {
        // prevent crash in tpp::gk::`anonymous_namespace'::EmblemManagerImplJob::UpdateRendering (0x14055ac0c)
        if (emblemCreated) {
            spdlog::info("{}, cannot create two emblems in one session", __PRETTY_FUNCTION__);
            return;
        }

        const auto emblemEditor = GetEmblemEditorSystemImpl();
        if (emblemEditor == nullptr) {
            spdlog::error("{}, emblem editor is null", __PRETTY_FUNCTION__);
            return;
        }

        const auto loadOk = TppUiEmblemImplEmblemEditorSystemImplLoadEmblemTextureInfo(emblemEditor);
        if (!loadOk) {
            spdlog::warn("{}, load emblem texture info fail (but it's ok)", __PRETTY_FUNCTION__);
        }

        uint64_t errcode = 0;
        const auto params = BlockHeapAlloc(1024, 8, MEMTAG_TPP_GK_EMBLEM);
        if (params == nullptr) {
            spdlog::error("{}, malloc failed", __PRETTY_FUNCTION__);
            return;
        }

        auto ecode = BlockHeapAlloc(8, 8, MEMTAG_TPP_GK_EMBLEM);
        ecode = TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParametersHook(emblemEditor,
            &errcode,
            params,
            info.emblemTextureTag,
            info.emblemColorL,
            info.emblemColorH,
            reinterpret_cast<char *>(&info.emblemX[0]),
            reinterpret_cast<char *>(&info.emblemY[0]),
            reinterpret_cast<char *>(&info.emblemScale[0]),
            reinterpret_cast<char *>(&info.emblemRotate[0]),
            1, // version
            true);

        if (errcode != 0) {
            spdlog::error("{}, TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParameters error code {}", __PRETTY_FUNCTION__, errcode);
            BlockHeapFree(params);
            BlockHeapFree(ecode);
            return;
        }

        const auto ready = TppUiEmblemImplEmblemEditorSystemImplIsReady(emblemEditor);
        if (!ready) {
            spdlog::error("{}, emblem editor not ready", __PRETTY_FUNCTION__);
            return;
        }

        const auto name = "OpponentEmblem";
        const auto nameSmall = "OpponentEmblem_S";
        const auto hash = FoxStrHash32(name, strlen(name));                // 0x90bb6285c23c
        const auto hashSmall = FoxStrHash32(nameSmall, strlen(nameSmall)); // 0xd2ee491abe8f

        auto res = TppUiEmblemImplEmblemEditorSystemImplCreateEmblemHook(emblemEditor, hash, hashSmall, params, 4);
        spdlog::info("{}, TppUiEmblemImplEmblemEditorSystemImplCreateEmblem res={}", __PRETTY_FUNCTION__, res);

        BlockHeapFree(params);
        BlockHeapFree(ecode);
        TppUiEmblemImplEmblemEditorSystemImplUnloadEmblemTextureInfo(emblemEditor);

        emblemCreated = true;
    }

    void DynamiteCore::RemoveOpponentEmblemTexture() {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        const auto emblemEditor = GetEmblemEditorSystemImpl();
        if (emblemEditor == nullptr) {
            spdlog::error("{}, emblem editor is null", __PRETTY_FUNCTION__);
            return;
        }

        if (!emblemCreated) {
            spdlog::info("{}, but there was no emblem created", __PRETTY_FUNCTION__);
            return;
        }

        const auto name = "OpponentEmblem";
        const auto nameSmall = "OpponentEmblem_S";
        const auto hash = FoxStrHash32(name, strlen(name));                // 0x90bb6285c23c
        const auto hashSmall = FoxStrHash32(nameSmall, strlen(nameSmall)); // 0xd2ee491abe8f
        TppUiEmblemImplEmblemEditorSystemImplDeleteTexture(emblemEditor, hash);
        TppUiEmblemImplEmblemEditorSystemImplDeleteTexture(emblemEditor, hashSmall);

        TppUiEmblemImplEmblemEditorSystemImplDeleteBlender(emblemEditor);

        emblemCreated = false;
    }

    void DynamiteCore::StartNearestEnemyThread() {
        spdlog::info("{}", __FUNCTION__);

        if (!cfg->Host) {
            spdlog::info("{}, not starting for client", __FUNCTION__);
            return;
        }

        if (nearestPlayerThread.joinable()) {
            spdlog::info("{}, nearest enemy thread already running", __FUNCTION__);
            return;
        }

        nearestPlayerThread = std::jthread([this](const std::stop_token &stoken) {
            spdlog::info("{}, starting", __PRETTY_FUNCTION__);
            while (!stoken.stop_requested()) {
                auto opID = GetNearestPlayer();
                if (cfg->debug.playerTarget) {
                    if (opID != offensePlayerID) {
                        spdlog::info("changing offense player ID from {:d} to {:d}", offensePlayerID, opID);
                    }
                }
                offensePlayerID = opID;

                using namespace std::chrono_literals;
                std::this_thread::sleep_for(500ms);
            }

            spdlog::info("{}, stopping", __PRETTY_FUNCTION__);
        });
    }

    void DynamiteCore::StopNearestEnemyThread() {
        spdlog::info("{}", __PRETTY_FUNCTION__);
        if (nearestPlayerThread.joinable()) {
            nearestPlayerThread.request_stop();
            nearestPlayerThread.join();
        }
    }

    bool DynamiteCore::IsNearestEnemyThreadRunning() const { return nearestPlayerThread.joinable(); }

    unsigned int DynamiteCore::GetOffensePlayerID() const { return offensePlayerID; }

    unsigned int DynamiteCore::GetDefensePlayerID() const { return defensePlayerID; }

    void DynamiteCore::ResetState() {
        offensePlayerID = 0;
        defensePlayerID = 15;
        sessionCreated = false;
        sessionConnected = false;
        hostSessionCreated = false;
        emblemCreated = false;
    }

    void DynamiteCore::SetSessionCreated(const bool v) { sessionCreated = v; }

    bool DynamiteCore::GetSessionCreated() const { return sessionCreated; }

    void DynamiteCore::SetHostSessionCreated(const bool v) { hostSessionCreated = v; }

    bool DynamiteCore::GetHostSessionCreated() const { return hostSessionCreated; }

    void DynamiteCore::SetSessionConnected(const bool v) { sessionConnected = v; }

    bool DynamiteCore::GetSessionConnected() const { return sessionConnected; }

    void DynamiteCore::SetEmblemCreated(bool v) { emblemCreated = v; }

    bool DynamiteCore::GetEmblemCreated() const { return emblemCreated; }
}