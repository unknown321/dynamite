#ifndef HOOK_DYNAMITE_H
#define HOOK_DYNAMITE_H

#include "Config.h"
#include "Tpp/TppNPCLifeState.h"
#include "Tpp/TppTypes.h"
#include "Version.h"
#include "lua/lua.h"
#include "patch.h"
#include "spdlog/logger.h"
#include "windows.h"
#include <filesystem>
#include <map>
#include <memory>

struct ScriptVarResult {
    TppVarType type;

    std::vector<bool> bools;
    std::vector<int32_t> int32s;
    std::vector<uint32_t> uint32s;
    std::vector<float> floats;
    std::vector<int8_t> int8s;
    std::vector<uint8_t> uint8s;
    std::vector<int16_t> int16s;
    std::vector<uint16_t> uint16s;
};

struct EmblemInfo {
    uint32_t emblemTextureTag[4];
    uint32_t emblemColorL[4];
    uint32_t emblemColorH[4];
    int8_t emblemX[4];
    int8_t emblemY[4];
    int8_t emblemScale[4];
    int8_t emblemRotate[4];
};

namespace Dynamite {
    extern std::map<std::string, uint64_t> addressSet;
    static const std::string logName = "dynamite";
    static const std::filesystem::path logPath = std::filesystem::path("dynamite") / std::filesystem::path("dynamite.log.txt");

    extern Config cfg;

    extern unsigned int offensePlayerID;
    extern unsigned int defensePlayerID;
    extern bool stopNearestEnemyThread;
    extern bool nearestEnemyThreadRunning;
    extern lua_State *luaState;
    extern bool sessionCreated;
    extern bool sessionConnected;

    /*
    If you are loading a mission from a checkpoint with already placed marker, game will attempt to restore
    that marker tpp::ui::menu::UiDepend::ActUserMarkerSaveLoad function (not lua).
    Combined with co-op hacks, marker restoration will result in a hang.
    Markers are accepted again at the end of TppMain.OnMissionCanStart.
    Removing all markers using RemovedAllUserMarker doesn't help for some reason, so this is a hack.
    */
    extern bool ignoreMarkerRequests;

    extern void *DamageControllerImpl;
    extern void *MarkerSystemImpl;
    extern void *SightManagerImpl;
    extern void *EquipHudSystemImpl;

    extern std::map<uint32_t, std::string> messageDict;

    void AbortHandler(int signal_number);

    void TerminateHandler();

    static std::vector<Patch> GetPatches();

    bool PatchMasterServerURL(const std::string &url);

    void StartNearestEnemyThread();
    ENPCLifeState GetSoldierLifeStatus(int objectID);
    int GetMemberCount();
    Vector3 GetSoldierPosition(int objectID);
    Vector3 GetPlayerPosition(int index);
    int GetNearestPlayer();
    EmblemInfo GetEmblemInfo();
    ScriptVarResult GetSVar(const std::string &catName, const std::string &varName);
    void *GetEmblemEditorSystemImpl();
    void CreateEmblem(EmblemInfo info);

    class Dynamite {
      public:
        Dynamite();
        ~Dynamite();

        void SetupLogger();

        void RebaseAddresses() const;

        static void CreateHooks();

        static void CreateDebugHooks();

        static void ReadConfig();

      private:
        static constexpr uint64_t BaseAddr = 0x140000000;
        uint64_t RealBaseAddr = 0;
        HMODULE thisModule{nullptr};
        std::shared_ptr<spdlog::logger> log = nullptr;
    };
}

#endif // HOOK_DYNAMITE_H
