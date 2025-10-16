#include "DynamiteHook.h"
#include "HookMacros.h"
#include "Messagebox.h"
#include "dynamite.h"
#include "mgsvtpp_func_typedefs.h"

#include <spdlog/spdlog.h>

namespace Dynamite {
    void Dynamite::CreateDebugHooks() const {
        spdlog::info("{}", __PRETTY_FUNCTION__);

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

        if (cfg.debug.routeGroupGetEventID) {
            CREATE_HOOK(RouteGroupImplGetEventId)
            ENABLEHOOK(RouteGroupImplGetEventId)
        }

        if (cfg.debug.foxCreateQuark) {
            CREATE_HOOK(FoxCreateQuark)
            ENABLEHOOK(FoxCreateQuark)
        }

        if (cfg.debug.aiControllerNode) {
            CREATE_HOOK(AiControllerImplAddNode)
            ENABLEHOOK(AiControllerImplAddNode)

            CREATE_HOOK(AiControllerImplSleepNode)
            ENABLEHOOK(AiControllerImplSleepNode)

            CREATE_HOOK(AiControllerImplWakeNode)
            ENABLEHOOK(AiControllerImplWakeNode)
        }

        if (cfg.debug.coreAiVehicle) {
            CREATE_HOOK(CoreAiImplGetVehicleId)
            ENABLEHOOK(CoreAiImplGetVehicleId)

            CREATE_HOOK(CoreAiImplGetVehicleRideState)
            ENABLEHOOK(CoreAiImplGetVehicleRideState)

            CREATE_HOOK(CoreAiImplIsVehicleRetain)
            ENABLEHOOK(CoreAiImplIsVehicleRetain)
        }

        if (cfg.debug.soldierRouteVehicleGetInStep) {
            CREATE_HOOK(SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStep)
            ENABLEHOOK(SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStep)
        }

        if (cfg.debug.statusControllerIsOnline) {
            CREATE_HOOK(StatusControllerImplIsSet)
            ENABLEHOOK(StatusControllerImplIsSet)
        }

        if (cfg.debug.soldierRouteAiImplPreUpdate) {
            CREATE_HOOK(SoldierRouteAiImplPreUpdate)
            ENABLEHOOK(SoldierRouteAiImplPreUpdate)
        }

        if (cfg.debug.messages) {
            CREATE_HOOK(MessageBufferAddMessage)
            ENABLEHOOK(MessageBufferAddMessage)
        }

        if (cfg.debug.getSVarHandle) {
            CREATE_HOOK(ScriptDeclVarsImplGetVarHandleWithVarIndex)
            ENABLEHOOK(ScriptDeclVarsImplGetVarHandleWithVarIndex)
        }

        if (cfg.debug.rttAndLoss) {
            CREATE_HOOK(BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnection)
            ENABLEHOOK(BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnection)

            CREATE_HOOK(BandWidthManagerImplCalcAverageRttOfBetterHalfConnection)
            ENABLEHOOK(BandWidthManagerImplCalcAverageRttOfBetterHalfConnection)

            CREATE_HOOK(BandWidthManagerImplStartLimitState)
            ENABLEHOOK(BandWidthManagerImplStartLimitState)
        }

        if (cfg.debug.muxSendError) {
            CREATE_HOOK(FoxNioImplMpMuxImplSend)
            ENABLEHOOK(FoxNioImplMpMuxImplSend)
        }

        if (cfg.debug.nioDetailed) {
            CREATE_HOOK(FoxNioMpMessageContainerGetFreeSize)
            ENABLEHOOK(FoxNioMpMessageContainerGetFreeSize)

            CREATE_HOOK(FoxNtImplGameSocketImplPeerIsSendPacketEmpty)
            ENABLEHOOK(FoxNtImplGameSocketImplPeerIsSendPacketEmpty)

            CREATE_HOOK(FoxNioImplMpMuxImplGetTotalPayloadSize)
            ENABLEHOOK(FoxNioImplMpMuxImplGetTotalPayloadSize)

            CREATE_HOOK(FoxNioMpMessageSerializerSerialize)
            ENABLEHOOK(FoxNioMpMessageSerializerSerialize)

            CREATE_HOOK(FoxNioMpMessageContainerCreate)
            ENABLEHOOK(FoxNioMpMessageContainerCreate)

            CREATE_HOOK(FoxNioMpMessageContainerAddMessage)
            ENABLEHOOK(FoxNioMpMessageContainerAddMessage)

            CREATE_HOOK(FoxNioImplSppSocketImplGetState)
            ENABLEHOOK(FoxNioImplSppSocketImplGetState)

            CREATE_HOOK(FoxNtImplSyncMemoryCollectorSyncMemoryCollector)
            ENABLEHOOK(FoxNtImplSyncMemoryCollectorSyncMemoryCollector)

            CREATE_HOOK(FoxNioMpMessageCreate)
            ENABLEHOOK(FoxNioMpMessageCreate)

            CREATE_HOOK(FoxNtNtModuleInit)
            ENABLEHOOK(FoxNtNtModuleInit)

            CREATE_HOOK(FoxNtImplGameSocketImplSetInterval)
            ENABLEHOOK(FoxNtImplGameSocketImplSetInterval)

            CREATE_HOOK(FoxNtImplGameSocketImplGetPacketCount)
            ENABLEHOOK(FoxNtImplGameSocketImplGetPacketCount)

            CREATE_HOOK(FoxNtImplPeerCommonInitializeLastSendTime)
            ENABLEHOOK(FoxNtImplPeerCommonInitializeLastSendTime)

            CREATE_HOOK(FoxNtImplTransceiverManagerImplPeerAddToSendQueue)
            ENABLEHOOK(FoxNtImplTransceiverManagerImplPeerAddToSendQueue)

            CREATE_HOOK(FoxNioImplMpMuxImplSendUpdate)
            ENABLEHOOK(FoxNioImplMpMuxImplSendUpdate)
        }

        if (cfg.debug.nio) {
            if (!cfg.debug.muxSendError) {
                CREATE_HOOK(FoxNioImplMpMuxImplSend)
                ENABLEHOOK(FoxNioImplMpMuxImplSend)
            }

            CREATE_HOOK(FoxNioImplMpMuxImplRecv1)
            ENABLEHOOK(FoxNioImplMpMuxImplRecv1)

            CREATE_HOOK(FoxNioImplMpMuxImplRecv2)
            ENABLEHOOK(FoxNioImplMpMuxImplRecv2)

            CREATE_HOOK(FoxNtPeerControllerSend)
            ENABLEHOOK(FoxNtPeerControllerSend)

            CREATE_HOOK(FoxNtTotalControllerSend)
            ENABLEHOOK(FoxNtTotalControllerSend)

            CREATE_HOOK(FoxNtImplTransceiverManagerImplPeerSend)
            ENABLEHOOK(FoxNtImplTransceiverManagerImplPeerSend)

            CREATE_HOOK(FoxNioImplMpSocketImplSend)
            ENABLEHOOK(FoxNioImplMpSocketImplSend)

            CREATE_HOOK(FoxNtImplGameSocketBufferImplAlloc)
            ENABLEHOOK(FoxNtImplGameSocketBufferImplAlloc)

            CREATE_HOOK(FoxNtImplTransceiverManagerImplPeerSendImpl1)
            ENABLEHOOK(FoxNtImplTransceiverManagerImplPeerSendImpl1)

            CREATE_HOOK(FoxNtImplTransceiverManagerImplPeerSendImpl2)
            ENABLEHOOK(FoxNtImplTransceiverManagerImplPeerSendImpl2)

            CREATE_HOOK(FoxNtImplTransceiverImplTransceiverImpl)
            ENABLEHOOK(FoxNtImplTransceiverImplTransceiverImpl)

            CREATE_HOOK(FoxNtImplGameSocketImplPeerRequestToSend)
            ENABLEHOOK(FoxNtImplGameSocketImplPeerRequestToSend)

            CREATE_HOOK(FoxNtImplGameSocketBufferImplGameSocketBufferImpl)
            ENABLEHOOK(FoxNtImplGameSocketBufferImplGameSocketBufferImpl)

            CREATE_HOOK(FoxNtImplGameSocketImplRequestToSendToMember)
            ENABLEHOOK(FoxNtImplGameSocketImplRequestToSendToMember)

            CREATE_HOOK(FoxNioImplSppSocketImplSendImpl)
            ENABLEHOOK(FoxNioImplSppSocketImplSendImpl)

            CREATE_HOOK(FoxNtImplNetworkSystemImplCreateGameSocket)
            ENABLEHOOK(FoxNtImplNetworkSystemImplCreateGameSocket)

            CREATE_HOOK(FoxNtImplGameSocketImplGameSocketImplDtor)
            ENABLEHOOK(FoxNtImplGameSocketImplGameSocketImplDtor)
        }

        spdlog::info("{} done", __PRETTY_FUNCTION__);
    }

    void Dynamite::CreateHooks() const {
        spdlog::info("{}", __PRETTY_FUNCTION__);

        CreateDebugHooks();

        CREATE_HOOK(luaL_openlibs)
        ENABLEHOOK(luaL_openlibs)

        CREATE_HOOK(IsDefenseTeamByOnlineFobLocal)
        ENABLEHOOK(IsDefenseTeamByOnlineFobLocal)

        CREATE_HOOK(IsOffenseTeamByOnlineFobLocal)
        ENABLEHOOK(IsOffenseTeamByOnlineFobLocal)

        CREATE_HOOK(GetFobOffensePlayerInstanceIndex)
        ENABLEHOOK(GetFobOffensePlayerInstanceIndex)

        CREATE_HOOK(GetFobDefensePlayerInstanceIndex)
        ENABLEHOOK(GetFobDefensePlayerInstanceIndex)

        CREATE_HOOK(SetSteamId)
        ENABLEHOOK(SetSteamId)

        CREATE_HOOK(IsConnectReady)
        ENABLEHOOK(IsConnectReady)

        CREATE_HOOK(UpdateClientEstablished)
        ENABLEHOOK(UpdateClientEstablished)

        CREATE_HOOK(GetUiMarkerTypeFromSystemType2)
        ENABLEHOOK(GetUiMarkerTypeFromSystemType2)

        CREATE_HOOK(SightManagerImplSetMarker)
        ENABLEHOOK(SightManagerImplSetMarker)

        CREATE_HOOK(SteamUdpSocketImplOnP2PSessionRequest)
        ENABLEHOOK(SteamUdpSocketImplOnP2PSessionRequest)

        CREATE_HOOK(AddLocalDamage)
        ENABLEHOOK(AddLocalDamage)

        CREATE_HOOK(DamageControllerImplInitialize)
        ENABLEHOOK(DamageControllerImplInitialize)

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

        CREATE_HOOK(FoxNioImplSteamUdpSocketImplSend)
        ENABLEHOOK(FoxNioImplSteamUdpSocketImplSend)

        CREATE_HOOK(FoxNioImplSteamUdpSocketImplRecv)
        ENABLEHOOK(FoxNioImplSteamUdpSocketImplRecv)

        CREATE_HOOK(TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParameters)
        ENABLEHOOK(TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParameters)

        CREATE_HOOK(FoxNtImplSessionImpl2DeleteMember)
        ENABLEHOOK(FoxNtImplSessionImpl2DeleteMember)

        CREATE_HOOK(FoxImplMessage2MessageBox2ImplSendMessageToSubscribers)
        ENABLEHOOK(FoxImplMessage2MessageBox2ImplSendMessageToSubscribers)

        CREATE_HOOK(TppUiEmblemImplEmblemEditorSystemImplCreateEmblem)
        ENABLEHOOK(TppUiEmblemImplEmblemEditorSystemImplCreateEmblem)

        CREATE_HOOK(TppGmPlayerImplClimbActionPluginImplCheckActionState)
        ENABLEHOOK(TppGmPlayerImplClimbActionPluginImplCheckActionState)

        CREATE_HOOK(FoxGeoPathResultGetNumPoint)
        ENABLEHOOK(FoxGeoPathResultGetNumPoint)

        // clang-format off
        {
            // these must go together to keep track of bytes written
            // OnSessionNotify doesn't always send sync variables
            CREATE_HOOK(TppGmImplScriptDeclVarsImplOnSessionNotify)
            ENABLEHOOK(TppGmImplScriptDeclVarsImplOnSessionNotify)

            CREATE_HOOK(FoxBitStreamWriterPrimitiveWrite)
            ENABLEHOOK(FoxBitStreamWriterPrimitiveWrite)
        }
        // clang-format on

        // CREATE_HOOK(TppGmPlayerImplAnonymous_namespaceCamouflageControllerImplInitialize)
        // ENABLEHOOK(TppGmPlayerImplAnonymous_namespaceCamouflageControllerImplInitialize)

        for (auto p : GetPatches()) {
            if (!p.Apply()) {
                std::stringstream msg;
                msg << "Failed to apply patch: " << p.description << " (" << p.address << ").";
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

        spdlog::info("{}, done", __PRETTY_FUNCTION__);
    }

}