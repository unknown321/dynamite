#ifndef HOOK_DYNAMITECORE_H
#define HOOK_DYNAMITECORE_H
#include "BossQuietNextActionTaskActionCondition.h"
#include "Config.h"
#include "EmblemInfo.h"
#include "ScriptVarResult.h"
#include "Tpp/BossQuietActionTask.h"
#include "Tpp/TppNPCLifeState.h"
#include "Tpp/TppTypes.h"

#include <thread>

namespace Dynamite {
    class DynamiteCore {
      public:
        DynamiteCore();
        void WithConfig(Config *);

        int GetMemberCount() const;
        int GetNearestPlayer() const;
        static Vector3 GetPlayerPosition(int index);
        static ENPCLifeState GetSoldierLifeStatus(int objectID);
        static Vector3 GetSoldierPosition(int objectID);
        static EmblemInfo GetEmblemInfo();
        static ScriptVarResult GetSVar(const std::string &catName, const std::string &varName);
        static void *GetEmblemEditorSystemImpl();
        void CreateEmblem(EmblemInfo info);
        void RemoveOpponentEmblemTexture();
        void StartNearestEnemyThread();
        void StopNearestEnemyThread();
        bool IsNearestEnemyThreadRunning() const;
        unsigned int GetOffensePlayerID() const;
        unsigned int GetDefensePlayerID() const;
        void ResetState();
        void SetSessionCreated(bool v);
        bool GetSessionCreated() const;
        void SetHostSessionCreated(bool v);
        bool GetHostSessionCreated() const;
        void SetSessionConnected(bool v);
        bool GetSessionConnected() const;
        void SetEmblemCreated(bool v);
        bool GetEmblemCreated() const;
        void MissionComplete();
        uint32_t GetMissionsCompleted() const;
        static unsigned short GetActiveEquipmentID(uint32_t playerID);
        static unsigned short GetEquipIDInSlot(uint32_t playerID, uint32_t slotID, uint32_t index);
        void BossQuietSetNextActionTask(uint32_t param_1, BossQuietActionTask *actionTask, BossQuietNextActionTaskActionCondition actionType) const;

      private:
        bool sessionCreated = false;
        bool sessionConnected = false;
        bool emblemCreated = false;
        bool hostSessionCreated = false;
        unsigned int offensePlayerID = 0;
        unsigned int defensePlayerID = 15;
        Config *cfg = nullptr;
        std::jthread nearestPlayerThread;
        uint32_t missionsCompleted = 0;
        std::filesystem::path missionsFilename = std::filesystem::path("dynamite") / std::filesystem::path("missions.txt");
    };
}

#endif // HOOK_DYNAMITECORE_H
