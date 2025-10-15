#ifndef HOOK_DYNAMITECORE_H
#define HOOK_DYNAMITECORE_H
#include "Config.h"
#include "EmblemInfo.h"
#include "ScriptVarResult.h"
#include "Tpp/TppNPCLifeState.h"
#include "Tpp/TppTypes.h"

#include <thread>

namespace Dynamite {
    class DynamiteCore {
      public:
        void WithConfig(Config*);

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

      private:
        bool sessionCreated = false;
        bool sessionConnected = false;
        bool emblemCreated = false;
        bool hostSessionCreated = false;
        unsigned int offensePlayerID = 0;
        unsigned int defensePlayerID = 15;
        Config *cfg = nullptr;
        std::jthread nearestPlayerThread;
    };
}

#endif // HOOK_DYNAMITECORE_H
