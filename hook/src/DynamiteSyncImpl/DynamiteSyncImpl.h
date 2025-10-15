#ifndef HOOK_DYNAMITESYNCIMPL_H
#define HOOK_DYNAMITESYNCIMPL_H

#include "DynamiteSyncSchema_generated.h"
#include "Tpp/TppTypes.h"

#include <map>
#include <thread>

const char DYNAMITE_RAW_HEADER[8] = {68, 89, 78, 65, 77, 73, 84, 69}; // DYNAMITE

namespace Dynamite {
    class DynamiteSyncImpl {
      public:
        DynamiteSyncImpl();
        ~DynamiteSyncImpl();

        void Init();
        void Stop();
        void SyncInit();
        void WaitForSync();
        bool IsSynchronized();

        [[deprecated("use SteamUDPSocket")]] void CreateGameSocket();
        [[deprecated("use SteamUDPSocket")]] void RemoveGameSocket();
        void *gameSocket = nullptr;
        [[deprecated("use SendRaw")]] bool Send(const flatbuffers::FlatBufferBuilder *builder) const;

        bool SendRaw(const flatbuffers::FlatBufferBuilder *builder) const;
        bool RecvRaw(void *buffer, int32_t size);

        void Ping();

        void RequestVar(const std::string &catName, const std::string &varName);
        void HandleRequestVar(const DynamiteMessage::MessageWrapper *w);

        void AddFixedUserMarker(const Vector3 *pos);
        static void HandleAddFixedUserMarker(const DynamiteMessage::MessageWrapper *w);

        void AddFollowUserMarker(const Vector3 *pos, uint32_t objectID);
        static void HandleAddFollowUserMarker(const DynamiteMessage::MessageWrapper *w);

        void RemoveUserMarker(uint32_t markerID);
        static void HandleRemoveUserMarker(const DynamiteMessage::MessageWrapper *w);

        void SetSightMarker(uint32_t objectID, uint32_t duration);
        static void HandleSetSightMarker(const DynamiteMessage::MessageWrapper *w);

        void SendEmblem();
        static void HandleSendEmblem(const DynamiteMessage::MessageWrapper *w);

        void SyncVar(const std::string &catName, const std::string &varName);
        void HandleSyncVar(const DynamiteMessage::MessageWrapper *w);

        // todo replace with template?
        static bool SyncBoolVar(const DynamiteMessage::SyncVar *m, void *vars, uint32_t varIndex);
        static bool SyncInt32Var(const DynamiteMessage::SyncVar *m, void *vars, uint32_t varIndex);
        static bool SyncUint32Var(const DynamiteMessage::SyncVar *m, void *vars, uint32_t varIndex);
        static bool SyncInt16Var(const DynamiteMessage::SyncVar *m, void *vars, uint32_t varIndex);
        static bool SyncUint16Var(const DynamiteMessage::SyncVar *m, void *vars, uint32_t varIndex);
        static bool SyncInt8Var(const DynamiteMessage::SyncVar *m, void *vars, uint32_t varIndex);
        static bool SyncUint8Var(const DynamiteMessage::SyncVar *m, void *vars, uint32_t varIndex);
        static bool SyncFloatVar(const DynamiteMessage::SyncVar *m, void *vars, uint32_t varIndex);

        void SyncEnemyVars();

        void *steamUDPAddress = nullptr;
        void *steamUDPSocketInfo = nullptr;
        void *steamUDPSocket = nullptr;

        char updateBuffer[1024];
        uint32_t packetNumber = 0;
        uint32_t packetSeen = 0;
        std::jthread syncThread;
        std::map<std::string, bool> syncStatus{};
        std::vector<std::string> enemyVars = {
            // "cpNames",
            // "cpFlags",
            // "solName",
            // "solState",
            // "solFlagAndStance",
            // "solWeapon",
            // "solLocation",
            // "solMarker",
            "solFovaSeed",
            "solFaceFova",
            "solBodyFova",
            // "solCp",
            // "solCpRoute",
            // "solScriptSneakRoute",
            // "solScriptCautionRoute",
            // "solScriptAlertRoute",
            // "solRouteNodeIndex",
            // "solRouteEventIndex",
            // "solTravelName",
            // "solTravelStepIndex",
            // "solOptName",
            // "solOptParam1",
            // "solOptParam2",
            // "passengerInfoName",
            // "passengerFlagName",
            // "passengerNameName",
            // "passengerVehicleNameName",
            // "noticeObjectType",
            // "noticeObjectPosition",
            // "noticeObjectOwnerName",
            // "noticeObjectOwnerId",
            // "noticeObjectAttachId",
            "solRandomSeed",
            // "hosName",
            // "hosState",
            // "hosFlagAndStance",
            // "hosWeapon",
            // "hosLocation",
            // "hosMarker",
            // "hosFovaSeed",
            // "hosFaceFova",
            // "hosBodyFova",
            // "hosScriptSneakRoute",
            // "hosRouteNodeIndex",
            // "hosRouteEventIndex",
            // "hosOptParam1",
            // "hosOptParam2",
            // "hosRandomSeed",
            // "enemyHeliName",
            // "enemyHeliLocation",
            // "enemyHeliCp",
            // "enemyHeliFlag",
            // "enemyHeliSneakRoute",
            // "enemyHeliCautionRoute",
            // "enemyHeliAlertRoute",
            // "enemyHeliRouteNodeIndex",
            // "enemyHeliRouteEventIndex",
            // "enemyHeliMarker",
            // "enemyHeliLife",
            // "ene_wkrg_name",
            // "ene_wkrg_life",
            // "ene_wkrg_partslife",
            // "ene_wkrg_location",
            // "ene_wkrg_bulletleft",
            // "ene_wkrg_marker",
            // "ene_holdRecoveredStateName",
            // "ene_isRecovered",
            // "ene_holdBrokenStateName",
            // "ene_isVehicleBroken",
            // "liquidLifeStatus",
            // "liquidMarker",
            // "uavName",
            // "uavIsDead",
            // "uavMarker",
            // "uavCp",
            // "uavPatrolRoute",
            // "uavCombatRoute",
            // "securityCameraCp",
            // "securityCameraMarker",
            // "securityCameraFlag",
        };
    };
}

#endif // HOOK_DYNAMITESYNCIMPL_H
