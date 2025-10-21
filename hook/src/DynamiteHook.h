#ifndef HOOK_DYNAMITEHOOK_H
#define HOOK_DYNAMITEHOOK_H

#include "BlockInfo.h"
#include "Config.h"
#include "DynamiteSyncImpl/DynamiteSyncImpl.h"
#include "Tpp/PlayerDamage.h"
#include "Tpp/TppTypes.h"
#include "lua/lua.h"
#include "windows.h"

#include "dynamite.h"

#include <map>

#define MESSAGE_DISCONNECT_FROM_HOST 0x190fd3bf
#define ScriptDeclVarsGameSocketNumber 6

// various pointers that are hard to acquire natively
// also some temp vars used in hooks
struct HookState {
    lua_State *luaState = nullptr;

    /*
    If you are loading a mission from a checkpoint with already placed marker, game will attempt to restore
    that marker tpp::ui::menu::UiDepend::ActUserMarkerSaveLoad function (not lua).
    Combined with co-op hacks, marker restoration will result in a hang.
    Markers are accepted again at the end of TppMain.OnMissionCanStart.
    Removing all markers using RemovedAllUserMarker doesn't help for some reason, so this is a hack.
    */
    bool ignoreMarkerRequests = false;
    void *fobTargetCtor = nullptr;
    bool blockHeapAllocLoginUtilityCalled = false;

    bool recordBinWrites = false;
    uint32_t varsTotalSize = 0;
    void *camouflageControllerImpl = nullptr;
    void *damageControllerImpl = nullptr;
    void *markerSystemImpl = nullptr;
    void *equipHudSystemImpl = nullptr;
    void *sightManagerImpl = nullptr;

    std::map<void *, BlockInfo> processCounter{};
    std::map<void *, std::string> blockNames{};
    std::string latestGeneratedName;

    std::map<uint64_t, std::string> quarkHandles;
};

namespace Dynamite {
    inline Dynamite *g_hook = nullptr;
    inline HookState hookState{};

    // // used for debugging, see docs/issue_7.md
    inline int32_t blockStatus(void *block) { return *(int32_t *)((char *)block + 0x80); }

    // used for debugging, see docs/issue_7.md
    inline int32_t blockStatus2(void *block) { return *(int32_t *)((char *)block + 0x84); }

    void __fastcall luaL_openlibsHook(lua_State *L);
    bool IsDefenseTeamByOnlineFobLocalHook();
    bool IsOffenseTeamByOnlineFobLocalHook();
    unsigned int GetFobOffensePlayerInstanceIndexHook(void *);
    unsigned int GetFobDefensePlayerInstanceIndexHook(void *);
    unsigned int GetUiMarkerTypeFromSystemType2Hook(void *p1, void *p2);
    bool SightManagerImplSetMarkerHook(void *thisPtr, unsigned short objectID, float duration);
    void SteamUdpSocketImplOnP2PSessionRequestHook(void *thisPtr, void *request);
    void SetSteamIdHook(void *param, uint64_t *steamID);
    bool IsConnectReadyHook(void *param);
    void UpdateClientEstablishedHook(void *param);
    void *MessageBufferAddMessageHook(
        void *thisPtr, void *errCodePtr, uint32_t messageID, uint32_t sender, uint32_t receiver, uint32_t param_4, void *messageArgs, uint32_t param_6);
    bool AddLocalDamageHook(void *thisPtr, uint32_t playerIndex, PlayerDamage *Damage);
    void DamageControllerImplInitializeHook(void *thisPtr, void *QuarkDesc);
    void *Marker2SystemImplHook(void *thisPtr);
    void EquipHudSystemImplInitDataHook(void *thisPtr);
    void Marker2SystemImplRemovedUserMarkerHook(void *thisPtr, uint32_t markerID);
    void Marker2SystemImplPlacedUserMarkerFixedHook(void *thisPtr, Vector3 *pos);
    bool Marker2SystemImplPlacedUserMarkerFollowHook(void *thisPtr, Vector3 *pos, unsigned short objectID);
    void SightManagerImplInitializeHook(void *thisPtr, void *QuarkDesc);
    void UiControllerImplSetNoUseEquipIdHook(void *thisPtr, bool param_1, unsigned int EquipID);
    bool EquipCrossEvCallIsItemNoUseHook(void *thisPtr, unsigned int EquipID);
    double FoxBlockProcessHook(void *Block, void *TaskContext, void *BlockProcessState);
    int32_t *FoxBlockReloadHook(void *Block, int32_t *param_2);
    int32_t *FoxBlockUnloadHook(void *Block, int32_t *param_2);
    void *FoxGenerateUniqueNameHook(void *sharedString, unsigned long long param_2, void *string);
    void *FoxBlockHook(void *p1);
    int32_t *FoxBlockActivateHook(void *Block, int32_t *param_2);
    int32_t *FoxBlockDeactivateHook(void *Block, int32_t *param_2);
    int *FoxBlockLoadHook(void *thisPtr, int *errorCode, uint64_t *pathID, uint32_t count);
    void *BlockMemoryAllocTailHook(void *memBlock, uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag);
    int64_t CreateHostSessionHook(FobTarget *param);
    FobTarget *FobTargetCtorHook(FobTarget *p);
    void *BlockHeapAllocHook(uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag);
    void *CloseSessionHook();
    void ScriptDeclVarsImplSetVarValueHook(void *thisPtr, uint64_t index, uint32_t param_2, uint32_t param_3, uint32_t value);
    void SoldierRouteAiImplPreUpdateHook(void *thisPtr, uint32_t param_1, void *AiNodeUpdateContext);
    uint32_t RouteGroupImplGetEventIdHook(void *RouteGroupImpl, unsigned short param_1, unsigned short param_2, unsigned short param_3);
    fox::QuarkHandle FoxCreateQuarkHook(uint64_t param_1, fox::QuarkDesc *quarkDesc, uint64_t p3);
    void AiControllerImplAddNodeHook(void *thisPtr, uint32_t param_2, uint64_t quarkHandle, uint32_t param_4);
    void AiControllerImplSleepNodeHook(void *AiControllerImpl, uint32_t param_1, int param_2, int32_t SleepCause);
    void AiControllerImplWakeNodeHook(void *AiControllerImpl, uint32_t param_1, int param_2, uint32_t param_3);
    unsigned short CoreAiImplGetVehicleIdHook(void *thisPtr, unsigned short *param_2, uint32_t param_3);
    unsigned char CoreAiImplGetVehicleRideStateHook(void *thisPtr, uint32_t param_1);
    bool CoreAiImplIsVehicleRetainHook(void *thisPtr, uint32_t param_1);
    bool SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStepHook(
        void *RouteAiImpl, uint32_t param_1, void *RouteAiKnowledge, bool param_3, bool param_4, bool param_5, bool param_6);
    bool StatusControllerImplIsSetHook(void *StatusControllerImpl, unsigned char param_1);
    void *ScriptDeclVarsImplGetVarHandleWithVarIndexHook(void *ScriptDeclVarsImpl, void *param_1, uint32_t param_2);
    int32_t BandWidthManagerImplCalcAverageRttOfBetterHalfConnectionHook(void *thisPtr);
    int32_t BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnectionHook(void *thisPtr);
    void BandWidthManagerImplStartLimitStateHook(void *thisPtr);
    uint32_t FoxNioMpMessageContainerGetFreeSizeHook(void *MpMessageContainer);
    int32_t FoxNioImplMpMuxImplSendHook(
        void *MpMuxImpl, unsigned short param_1, unsigned char param_2, void *param_3, int size, void *SppInfo, unsigned short param_6);
    int32_t FoxNioImplMpMuxImplRecv1Hook(void *MpMuxImpl, unsigned short param_1, void *Buffer, void *SppInfo, unsigned short param_4);
    int32_t FoxNioImplMpMuxImplRecv2Hook(void *MpMuxImpl, unsigned short param_1, void *param_2, int param_3, void *param_4, unsigned short param_5);
    int32_t FoxNtPeerControllerSendHook(void *PeerController, uint32_t param_1, int param_2, int param_3);
    bool FoxNtImplGameSocketImplPeerIsSendPacketEmptyHook(void *Peer);
    int FoxNtTotalControllerSendHook(void *TotalController, uint32_t param_1, int32_t param_2, int32_t param_3);
    int FoxNtImplTransceiverManagerImplPeerSendHook(void *TransceiverManagerImpl, uint32_t param_1, int32_t param_2, int32_t param_3);
    int FoxNioImplMpSocketImplSendHook(void *MpSocketImpl, void *param_1, int size, void *Info, void *Address);
    int FoxNioImplMpMuxImplGetTotalPayloadSizeHook(void *thisPtr);
    void FoxNioMpMessageSerializerSerializeHook(void *Serializer, fox::nio::Buffer *buffer);
    void *FoxNioMpMessageContainerCreateHook(void *param_1, uint32_t sizeWithHeader);
    int FoxNioMpMessageContainerAddMessageHook(void *MpMessageContainer, void *MpMessageComponent);
    int32_t FoxNioImplSppSocketImplGetStateHook(void *SppSocketImpl);
    void *FoxNtImplSyncMemoryCollectorSyncMemoryCollectorHook(
        void *SyncMemoryCollector, uint32_t param_1, uint32_t param_2, uint32_t param_3, void *TransceiverImpl, void *param_5, uint64_t param_6);
    void *FoxNtImplGameSocketBufferImplAllocHook(void *GameSocketBufferImpl, uint32_t size);
    void TppGmImplScriptDeclVarsImplOnSessionNotifyHook(void *ScriptDeclVarsImpl, void *SessionInterface, int param_2, void *param_3);
    void *FoxBitStreamWriterPrimitiveWriteHook(void *BitStreamWriter, void *ErrorCode, uint64_t value, uint32_t size);
    int32_t FoxNtImplTransceiverManagerImplPeerSendImpl1Hook(void *PeerThis, void *Peer, int32_t param_2);
    int32_t FoxNtImplTransceiverManagerImplPeerSendImpl2Hook(void *PeerThis, void *Peer, int32_t param_2);
    void *FoxNtImplTransceiverImplTransceiverImplHook(void *TransceiverImpl, void *TransceiverCreationDesc);
    void FoxNtImplGameSocketImplPeerRequestToSendHook(void *Peer, void *src, uint32_t size);
    void *FoxNtImplGameSocketBufferImplGameSocketBufferImplHook(void *GameSocketBufferImpl, uint32_t size);
    void *FoxNioMpMessageCreateHook(void *param_1, uint32_t maxSize, void *param_3, uint32_t requestedSize);
    void TppGmImplScriptDeclVarsImplUpdateHook(void *ScriptDeclVarsImpl);
    uint32_t FoxNtImplGameSocketImplGetPacketCountHook(void *GameSocketImpl, uint32_t param_1);
    void *FoxNtImplNetworkSystemImplCreateGameSocketHook(void *NetworkSystemImpl, fox::nt::GameSocketDesc *gameSocketDesc);
    void FoxNtNtModuleInitHook();
    void FoxNtImplGameSocketImplRequestToSendToMemberHook(
        void *GameSocketImpl, unsigned char memberIndex, uint32_t param_2, void *bufferPtr, uint32_t byteCount);
    void FoxNtImplGameSocketImplSetIntervalHook(void *GameSocketImpl, uint32_t param_1, unsigned char param_2, float param_3);
    void FoxNtImplPeerCommonInitializeLastSendTimeHook(void *PeerCommon);
    void *TppGmImplScriptDeclVarsImplScriptDeclVarsImplHook(void *ScriptDeclVarsImpl);
    void *FoxNtImplSessionImpl2GetMemberInterfaceAtIndexHook(void *SessionImpl2, unsigned char index);
    void FoxNtImplGameSocketImplHandleMessageHook(void *GameSocketImpl, void *Buffer, uint32_t fromIndex, void *Buffer2, void *BitStreamReader);
    void *FoxNtImplPeerCommonPeerCommonHook(void *PeerCommon, unsigned char param_1, uint32_t param_2);
    void TppGmPlayerImplSynchronizerImplInitializeHook(void *SynchronizerImpl, void *QuarkDesc);
    void FoxNtImplGameSocketImplGameSocketImplDtorHook(void *GameSocketImpl, uint32_t freeMem);
    void TppGmImplScriptDeclVarsImplScriptDeclVarsImplDtorHook(void *ScriptDeclVarsImpl);
    void TppGmPlayerImplAnonymous_namespaceCamouflageControllerImplInitializeHook(void *CamouflageControllerImpl, fox::QuarkDesc *param_1);
    void FoxNtImplTransceiverManagerImplPeerAddToSendQueueHook(void *Peer, void *PeerCommon);
    uint32_t FoxNioImplMpMuxImplSendUpdateHook(void *MpMuxImpl);
    int32_t FoxNioImplSppSocketImplSendImplHook(void *SppSocketImpl, void *bufferAddr, int size, void *info, void *addr, bool param_5);
    int32_t FoxNioImplSteamUdpSocketImplSendHook(void *SteamUdpSocketImpl, void *param_1, int param_2, void *SocketInfo, void *Address);
    int32_t FoxNioImplSteamUdpSocketImplRecvHook(void *SteamUdpSocketImpl, void *buffer, int maxBufferSize, void *SocketInfo, void *Address);
    void *TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParametersHook(void *EmblemEditorSystemImpl, void *ErrorCode, void *EmblemTextureParameters,
        uint32_t *emblemTextureTag, uint32_t *emblemColorL, uint32_t *emblemColorH, char *emblemX, char *emblemY, char *emblemScale, char *emblemRotate,
        unsigned char version, bool param_10);
    void FoxNtImplSessionImpl2DeleteMemberHook(void *SessionImpl2, void *Member);
    void *FoxImplMessage2MessageBox2ImplSendMessageToSubscribersHook(void *MessageBox2Impl, void *ErrorCode, uint32_t msgID, void *MessageArgs);
    bool TppUiEmblemImplEmblemEditorSystemImplCreateEmblemHook(
        void *EmblemEditorSystemImpl, uint64_t textureName, uint64_t textureNameSmall, void *EmblemTextureParameters, uint32_t maybe_sizes);
    void TppGkTppGameKitModuleEndHook(void *TppGameKitModule);
    bool TppGmPlayerImplClimbActionPluginImplCheckActionStateHook(void *ClimbActionPluginImpl, uint32_t param_1);
    int FoxGeoPathResultGetNumPointHook(void *PathResult);
    void TppUiUtilityChangeLanguageHook(int param_1);
}

#endif // HOOK_DYNAMITEHOOK_H
