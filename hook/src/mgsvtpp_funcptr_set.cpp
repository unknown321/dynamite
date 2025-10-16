#include "dynamite.h"
#include "mgsvtpp_func_typedefs.h"

namespace Dynamite {
    void Dynamite::SetFuncPtrs() {
        luaI_openlib = (luaI_openlibFunc *)addressSet["luaI_openlib"];
        luaL_openlibs = (luaL_openlibsFunc *)addressSet["luaL_openlibs"];

        lua_pushinteger = (lua_pushintegerFunc *)addressSet["lua_pushinteger"];
        lua_setfield = (lua_setfieldFunc *)addressSet["lua_setfield"];
        lua_pushstring = (lua_pushstringFunc *)addressSet["lua_pushstring"];
        lua_getfield = (lua_getfieldFunc *)addressSet["lua_getfield"];
        lua_pcall = (lua_pcallFunc *)addressSet["lua_pcall"];
        luaL_checkinteger = (luaL_checkintegerFunc *)addressSet["luaL_checkinteger"];
        lua_pushboolean = (lua_pushbooleanFunc *)addressSet["lua_pushboolean"];
        luaL_checknumber = (luaL_checknumberFunc *)addressSet["luaL_checknumber"];
        lua_toboolean = (lua_tobooleanFunc *)addressSet["lua_toboolean"];
        lua_createtable = (lua_createtableFunc *)addressSet["lua_createtable"];
        lua_pushvalue = (lua_pushvalueFunc *)addressSet["lua_pushvalue"];
        luaL_checklstring = (luaL_checklstringFunc *)addressSet["luaL_checklstring"];
        lua_pushnumber = (lua_pushnumberFunc *)addressSet["lua_pushnumber"];

        IsDefenseTeamByOnlineFobLocal = (IsDefenseTeamByOnlineFobLocalFunc *)addressSet["IsDefenseTeamByOnlineFobLocal"];
        IsOffenseTeamByOnlineFobLocal = (IsOffenseTeamByOnlineFobLocalFunc *)addressSet["IsOffenseTeamByOnlineFobLocal"];
        CreateHostSession = (CreateHostSessionFunc *)addressSet["CreateHostSession"];
        CreateClientSession = (CreateClientSessionFunc *)addressSet["CreateClientSession"];
        SetSteamId = (SetSteamIdFunc *)addressSet["SetSteamId"];
        FobTargetCtor = (FobTargetCtorFunc *)addressSet["FobTargetCtor"];
        SessionConnectInfoCtor = (SessionConnectInfoCtorFunc *)addressSet["SessionConnectInfoCtor"];
        NetworkSystemCreateHostSession = (NetworkSystemCreateHostSessionFunc *)addressSet["NetworkSystemCreateHostSession"];
        BlockHeapAlloc = (BlockHeapAllocFunc *)addressSet["BlockHeapAlloc"];
        BlockHeapFree = (BlockHeapFreeFunc *)addressSet["BlockHeapFree"];
        NetInfoCreateSession = (NetInfoCreateSessionFunc *)addressSet["NetInfoCreateSession"];
        IsConnectReady = (IsConnectReadyFunc *)addressSet["IsConnectReady"];
        UpdateClientEstablished = (UpdateClientEstablishedFunc *)addressSet["UpdateClientEstablished"];
        GetQuarkSystemTable = (GetQuarkSystemTableFunc *)addressSet["GetQuarkSystemTable"];
        SessionImpl2IsHost = (SessionImpl2IsHostFunc *)addressSet["SessionImpl2IsHost"];
        GetFobOffensePlayerInstanceIndex = (GetFobOffensePlayerInstanceIndexFunc *)addressSet["GetFobOffensePlayerInstanceIndex"];
        GetFobDefensePlayerInstanceIndex = (GetFobDefensePlayerInstanceIndexFunc *)addressSet["GetFobDefensePlayerInstanceIndex"];
        HashMapFindKey = (HashMapOperatorFindKeyFunc *)addressSet["HashMapFindKey"];
        FoxStrHash32 = (FoxStrHash32Func *)addressSet["FoxStrHash32"];
        CommandPost2ImplGetAvailableMemberCount = (CommandPost2ImplGetAvailableMemberCountFunc *)addressSet["CommandPost2ImplGetAvailableMemberCount"];
        CommandPost2ImplGetMaxCpCount = (CommandPost2ImplGetMaxCpCountFunc *)addressSet["CommandPost2ImplGetMaxCpCount"];
        FoxFindEntity = (FoxFindEntityFunc *)addressSet["FoxFindEntity"];
        FoxGetEntityHandle = (FoxGetEntityHandleFunc *)addressSet["FoxGetEntityHandle"];
        FoxGetEntityProperty = (FoxGetEntityPropertyFunc *)addressSet["FoxGetEntityProperty"];
        FoxCreatePropertyInfo = (FoxCreatePropertyInfoFunc *)addressSet["FoxCreatePropertyInfo"];
        ValueGetAsUInt32 = (ValueGetAsUInt32Func *)addressSet["ValueGetAsUInt32"];
        FoxString = (FoxStringFunc *)addressSet["FoxString"];
        FindGameObjectWithID = (FindGameObjectWithIDFunc *)addressSet["FindGameObjectWithID"];
        Soldier2ImplGetInterface = (Soldier2ImplGetInterfaceFunc *)addressSet["Soldier2ImplGetInterface"];
        PlayerInfoServiceGetPositionAtIndex = (PlayerInfoServiceGetPositionAtIndexFunc *)addressSet["PlayerInfoServiceGetPositionAtIndex"];
        FoxNtSessionGetMainSession = (FoxNtSessionGetMainSessionFunc *)addressSet["FoxNtSessionGetMainSession"];
        GetSessionMemberCount = (GetSessionMemberCountFunc *)addressSet["GetSessionMemberCount"];
        GetUiMarkerTypeFromSystemType2 = (GetUiMarkerTypeFromSystemType2Func *)addressSet["GetUiMarkerTypeFromSystemType2"];
        SightManagerImplSetMarker = (SightManagerImplSetMarkerFunc *)addressSet["SightManagerImplSetMarker"];
        SteamUdpSocketImplOnP2PSessionRequest = (SteamUdpSocketImplOnP2PSessionRequestFunc *)addressSet["SteamUdpSocketImplOnP2PSessionRequest"];
        MessageBufferAddMessage = (MessageBufferAddMessageFunc *)addressSet["MessageBufferAddMessage"];
        AddLocalDamage = (AddLocalDamageFunc *)addressSet["DamageControllerImplAddLocalDamage"];
        DamageControllerImplInitialize = (DamageControllerImplInitializeFunc *)addressSet["DamageControllerImplInitialize"];
        SynchronizerImplGetDamage = (SynchronizerImplGetDamageFunc *)addressSet["SynchronizerImplGetDamage"];
        Marker2SystemImpl = (Marker2SystemImplFunc *)addressSet["Marker2SystemImpl"];
        Marker2SystemImplPlacedUserMarkerFixed = (Marker2SystemImplPlacedUserMarkerFixedFunc *)addressSet["Marker2SystemImplPlacedUserMarkerFixed"];
        GetLocalPlayerId = (GetLocalPlayerIDFunc *)addressSet["GetLocalPlayerID"];
        RemoveUserMarker = (RemoveUserMarkerFunc *)addressSet["RemoveUserMarker"];
        EquipHudSystemImplInitData = (EquipHudSystemImplInitDataFunc *)addressSet["EquipHudSystemImplInitData"];
        Marker2SystemImplRemovedUserMarker = (Marker2SystemImplRemovedUserMarkerFunc *)addressSet["Marker2SystemImplRemovedUserMarker"];
        Marker2SystemImplPlacedUserMarkerFollow = (Marker2SystemImplPlacedUserMarkerFollowFunc *)addressSet["Marker2SystemImplPlacedUserMarkerFollow"];
        Marker2SystemImplRemovedAllUserMarker = (Marker2SystemImplRemovedAllUserMarkerFunc *)addressSet["Marker2SystemImplRemovedAllUserMarker"];
        SightManagerImplInitialize = (SightManagerImplInitializeFunc *)addressSet["SightManagerImplInitialize"];
        UiControllerImplSetNoUseEquipId = (UiControllerImplSetNoUseEquipIdFunc *)addressSet["UiControllerImplSetNoUseEquipId"];
        EquipCrossEvCallIsItemNoUse = (EquipCrossEvCallIsItemNoUseFunc *)addressSet["EquipCrossEvCallIsItemNoUse"];
        FoxBlockProcess = (FoxBlockProcessFunc *)addressSet["FoxBlockProcess"];
        FoxBlockUnload = (FoxBlockUnloadFunc *)addressSet["FoxBlockUnload"];
        FoxBlockReload = (FoxBlockReloadFunc *)addressSet["FoxBlockReload"];
        FoxGenerateUniqueName = (FoxGenerateUniqueNameFunc *)addressSet["FoxGenerateUniqueName"];
        FoxBlock = (FoxBlockFunc *)addressSet["FoxBlock"];
        GetCurrentBlockMemory = (GetCurrentBlockMemoryFunc *)addressSet["GetCurrentBlockMemory"];
        BlockMemoryAllocTail = (BlockMemoryAllocTailFunc *)addressSet["BlockMemoryAllocTail"];
        BlockMemoryAllocHeap = (BlockMemoryAllocHeapFunc *)addressSet["BlockMemoryAllocHeap"];
        FoxBlockActivate = (FoxBlockActivateFunc *)addressSet["FoxBlockActivate"];
        FoxBlockDeactivate = (FoxBlockDeactivateFunc *)addressSet["FoxBlockDeactivate"];
        FoxBlockLoad = (FoxBlockLoadFunc *)addressSet["FoxBlockLoad"];
        CloseSession = (CloseSessionFunc *)addressSet["CloseSession"];
        Player2GameObjectImplWarp = (Player2GameObjectImplWarpFunc *)addressSet["Player2GameObjectImplWarp"];
        ScriptDeclVarsImplSetVarValue = (ScriptDeclVarsImplSetVarValueFunc *)addressSet["ScriptDeclVarsImplSetVarValue"];
        SoldierRouteAiImplPreUpdate = (SoldierRouteAiImplPreUpdateFunc *)addressSet["SoldierRouteAiImplPreUpdate"];
        RouteGroupImplGetEventId = (RouteGroupImplGetEventIdFunc *)addressSet["RouteGroupImplGetEventId"];
        FoxCreateQuark = (FoxCreateQuarkFunc *)addressSet["FoxCreateQuark"];
        AiControllerImplAddNode = (AiControllerImplAddNodeFunc *)addressSet["AiControllerImplAddNode"];
        AiControllerImplSleepNode = (AiControllerImplSleepNodeFunc *)addressSet["AiControllerImplSleepNode"];
        AiControllerImplWakeNode = (AiControllerImplWakeNodeFunc *)addressSet["AiControllerImplWakeNode"];
        CoreAiImplGetVehicleId = (CoreAiImplGetVehicleIdFunc *)addressSet["CoreAiImplGetVehicleId"];
        CoreAiImplGetVehicleRideState = (CoreAiImplGetVehicleRideStateFunc *)addressSet["CoreAiImplGetVehicleRideState"];
        CoreAiImplIsVehicleRetain = (CoreAiImplIsVehicleRetainFunc *)addressSet["CoreAiImplIsVehicleRetain"];
        SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStep =
            (SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStepFunc *)addressSet["SoldierImplRouteAiImplCheckVehicleAndWalkerGearGetInAndOutStep"];
        StatusControllerImplIsSet = (StatusControllerImplIsSetFunc *)addressSet["StatusControllerImplIsSet"];
        ScriptDeclVarsImplGetVarHandleWithVarIndex = (ScriptDeclVarsImplGetVarHandleWithVarIndexFunc *)addressSet["ScriptDeclVarsImplGetVarHandleWithVarIndex"];
        GmGetScriptVarInfo = (GmGetScriptVarInfoFunc *)addressSet["GmGetScriptVarInfo"];
        BandWidthManagerImplCalcAverageRttOfBetterHalfConnection =
            (BandWidthManagerImplCalcAverageRttOfBetterHalfConnectionFunc *)addressSet["BandWidthManagerImplCalcAverageRttOfBetterHalfConnection"];
        BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnection =
            (BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnectionFunc *)addressSet["BandWidthManagerImplCalcAverageLostRateOfBetterHalfConnection"];
        BandWidthManagerImplStartLimitState = (BandWidthManagerImplStartLimitStateFunc *)addressSet["BandWidthManagerImplStartLimitState"];

        l_AnnounceLogView = (lua_CFunction)addressSet["l_AnnounceLogView"];
        FoxLuaPushVector3 = (FoxLuaPushVector3Func *)addressSet["FoxLuaPushVector3"];
        FoxLuaPushQuat = (FoxLuaPushQuatFunc *)addressSet["FoxLuaPushQuat"];
        FoxNioMpMessageContainerGetFreeSize = (FoxNioMpMessageContainerGetFreeSizeFunc *)addressSet["FoxNioMpMessageContainerGetFreeSize"];
        FoxNioImplMpMuxImplSend = (FoxNioImplMpMuxImplSendFunc *)addressSet["FoxNioImplMpMuxImplSend"];
        FoxNioImplMpMuxImplRecv1 = (FoxNioImplMpMuxImplRecv1Func *)addressSet["FoxNioImplMpMuxImplRecv1"];
        FoxNioImplMpMuxImplRecv2 = (FoxNioImplMpMuxImplRecv2Func *)addressSet["FoxNioImplMpMuxImplRecv2"];
        FoxNtPeerControllerSend = (FoxNtPeerControllerSendFunc *)addressSet["FoxNtPeerControllerSend"];
        FoxNtImplGameSocketImplPeerIsSendPacketEmpty =
            (FoxNtImplGameSocketImplPeerIsSendPacketEmptyFunc *)addressSet["FoxNtImplGameSocketImplPeerIsSendPacketEmpty"];
        FoxNtTotalControllerSend = (FoxNtTotalControllerSendFunc *)addressSet["FoxNtTotalControllerSend"];
        FoxNtImplTransceiverManagerImplPeerSend = (FoxNtImplTransceiverManagerImplPeerSendFunc *)addressSet["FoxNtImplTransceiverManagerImplPeerSend"];
        FoxNioImplMpSocketImplSend = (FoxNioImplMpSocketImplSendFunc *)addressSet["FoxNioImplMpSocketImplSend"];
        FoxNioImplMpMuxImplGetTotalPayloadSize = (FoxNioImplMpMuxImplGetTotalPayloadSizeFunc *)addressSet["FoxNioImplMpMuxImplGetTotalPayloadSize"];
        FoxNioMpMessageSerializerSerialize = (FoxNioMpMessageSerializerSerializeFunc *)addressSet["FoxNioMpMessageSerializerSerialize"];
        FoxNioMpMessageContainerCreate = (FoxNioMpMessageContainerCreateFunc *)addressSet["FoxNioMpMessageContainerCreate"];
        FoxNioMpMessageContainerAddMessage = (FoxNioMpMessageContainerAddMessageFunc *)addressSet["FoxNioMpMessageContainerAddMessage"];
        FoxNioImplSppSocketImplGetState = (FoxNioImplSppSocketImplGetStateFunc *)addressSet["FoxNioImplSppSocketImplGetState"];
        FoxNtImplSyncMemoryCollectorSyncMemoryCollector =
            (FoxNtImplSyncMemoryCollectorSyncMemoryCollectorFunc *)addressSet["FoxNtImplSyncMemoryCollectorSyncMemoryCollector"];
        FoxNtImplGameSocketBufferImplAlloc = (FoxNtImplGameSocketBufferImplAllocFunc *)addressSet["FoxNtImplGameSocketBufferImplAlloc"];
        TppGmImplScriptDeclVarsImplOnSessionNotify = (TppGmImplScriptDeclVarsImplOnSessionNotifyFunc *)addressSet["TppGmImplScriptDeclVarsImplOnSessionNotify"];
        FoxBitStreamWriterPrimitiveWrite = (FoxBitStreamWriterPrimitiveWriteFunc *)addressSet["FoxBitStreamWriterPrimitiveWrite"];
        TppGmImplScriptDeclVarsImplGetVarHandleWithVarIndex =
            (TppGmImplScriptDeclVarsImplGetVarHandleWithVarIndexFunc *)addressSet["TppGmImplScriptDeclVarsImplGetVarHandleWithVarIndex"];
        FoxNtImplTransceiverManagerImplPeerSendImpl1 =
            (FoxNtImplTransceiverManagerImplPeerSendImpl1Func *)addressSet["FoxNtImplTransceiverManagerImplPeerSendImpl1"];
        FoxNtImplTransceiverManagerImplPeerSendImpl2 =
            (FoxNtImplTransceiverManagerImplPeerSendImpl2Func *)addressSet["FoxNtImplTransceiverManagerImplPeerSendImpl2"];
        FoxNtImplTransceiverImplTransceiverImpl = (FoxNtImplTransceiverImplTransceiverImplFunc *)addressSet["FoxNtImplTransceiverImplTransceiverImpl"];
        FoxNtImplGameSocketImplPeerRequestToSend = (FoxNtImplGameSocketImplPeerRequestToSendFunc *)addressSet["FoxNtImplGameSocketImplPeerRequestToSend"];
        FoxNtImplGameSocketBufferImplGameSocketBufferImpl =
            (FoxNtImplGameSocketBufferImplGameSocketBufferImplFunc *)addressSet["FoxNtImplGameSocketBufferImplGameSocketBufferImpl"];
        FoxNioMpMessageCreate = (FoxNioMpMessageCreateFunc *)addressSet["FoxNioMpMessageCreate"];
        FoxNtImplNetworkSystemImplGetMainSession = (FoxNtImplNetworkSystemImplGetMainSessionFunc *)addressSet["FoxNtImplNetworkSystemImplGetMainSession"];
        FoxImplScopeAllocatorImplAlloc = (FoxImplScopeAllocatorImplAllocFunc *)addressSet["FoxImplScopeAllocatorImplAlloc"];
        FoxScopeMemoryScopeMemory1 = (FoxScopeMemoryScopeMemory1Func *)addressSet["FoxScopeMemoryScopeMemory1"];
        FoxScopeMemoryScopeMemoryDtor = (FoxScopeMemoryScopeMemoryDtorFunc *)addressSet["FoxScopeMemoryScopeMemoryDtor"];
        TppGmImplScriptDeclVarsImplUpdate = (TppGmImplScriptDeclVarsImplUpdateFunc *)addressSet["TppGmImplScriptDeclVarsImplUpdate"];
        FoxNtImplGameSocketImplGetPacketCount = (FoxNtImplGameSocketImplGetPacketCountFunc *)addressSet["FoxNtImplGameSocketImplGetPacketCount"];
        FoxNtImplGameSocketImplGetPacket = (FoxNtImplGameSocketImplGetPacketFunc *)addressSet["FoxNtImplGameSocketImplGetPacket"];
        FoxNtImplNetworkSystemImplCreateGameSocket = (FoxNtImplNetworkSystemImplCreateGameSocketFunc *)addressSet["FoxNtImplNetworkSystemImplCreateGameSocket"];
        FoxNtNtModuleInit = (FoxNtNtModuleInitFunc *)addressSet["FoxNtNtModuleInit"];
        FoxNtImplGameSocketImplRequestToSendToMember =
            (FoxNtImplGameSocketImplRequestToSendToMemberFunc *)addressSet["FoxNtImplGameSocketImplRequestToSendToMember"];
        FoxNtImplGameSocketImplSetInterval = (FoxNtImplGameSocketImplSetIntervalFunc *)addressSet["FoxNtImplGameSocketImplSetInterval"];
        FoxNtImplPeerCommonInitializeLastSendTime = (FoxNtImplPeerCommonInitializeLastSendTimeFunc *)addressSet["FoxNtImplPeerCommonInitializeLastSendTime"];
        FoxNtImplGameSocketImplGetPacketSize = (FoxNtImplGameSocketImplGetPacketSizeFunc *)addressSet["FoxNtImplGameSocketImplGetPacketSize"];
        FoxNtImplGameSocketImplGameSocketImplDtor = (FoxNtImplGameSocketImplGameSocketImplDtorFunc *)addressSet["FoxNtImplGameSocketImplGameSocketImplDtor"];
        TppGmImplScriptDeclVarsImplGetVarHandle = (TppGmImplScriptDeclVarsImplGetVarHandleFunc *)addressSet["TppGmImplScriptDeclVarsImplGetVarHandle"];
        TppGmImplScriptDeclVarsImplScriptDeclVarsImpl =
            (TppGmImplScriptDeclVarsImplScriptDeclVarsImplFunc *)addressSet["TppGmImplScriptDeclVarsImplScriptDeclVarsImpl"];
        TppGmImplScriptSystemImplGetScriptDeclVarHandle =
            (TppGmImplScriptSystemImplGetScriptDeclVarHandleFunc *)addressSet["TppGmImplScriptSystemImplGetScriptDeclVarHandle"];
        TppGmImplScriptDeclVarsImplGetVarIndexWithName =
            (TppGmImplScriptDeclVarsImplGetVarIndexWithNameFunc *)addressSet["TppGmImplScriptDeclVarsImplGetVarIndexWithName"];
        TppGmGetSVars = (TppGmGetSVarsFunc *)addressSet["TppGmGetSVars"];
        TppGmGetGVars = (TppGmGetGVarsFunc *)addressSet["TppGmGetGVars"];
        FoxNtImplSessionImpl2GetMemberInterfaceAtIndex =
            (FoxNtImplSessionImpl2GetMemberInterfaceAtIndexFunc *)addressSet["FoxNtImplSessionImpl2GetMemberInterfaceAtIndex"];
        FoxNtImplGameSocketImplHandleMessage = (FoxNtImplGameSocketImplHandleMessageFunc *)addressSet["FoxNtImplGameSocketImplHandleMessage"];
        FoxNtImplPeerCommonPeerCommon = (FoxNtImplPeerCommonPeerCommonFunc *)addressSet["FoxNtImplPeerCommonPeerCommon"];
        TppGmPlayerImplSynchronizerImplInitialize = (TppGmPlayerImplSynchronizerImplInitializeFunc *)addressSet["TppGmPlayerImplSynchronizerImplInitialize"];
        TppGmImplScriptDeclVarsImplScriptDeclVarsImplDtor =
            (TppGmImplScriptDeclVarsImplScriptDeclVarsImplDtorFunc *)addressSet["TppGmImplScriptDeclVarsImplScriptDeclVarsDtor"];
        TppGmPlayerImplAnonymous_namespaceCamouflageControllerImplInitialize = (TppGmPlayerImplAnonymous_namespaceCamouflageControllerImplInitializeFunc *)
            addressSet["TppGmPlayerImplAnonymous_namespaceCamouflageControllerImplInitialize"];
        FoxNtImplTransceiverManagerImplPeerAddToSendQueue =
            (FoxNtImplTransceiverManagerImplPeerAddToSendQueueFunc *)addressSet["FoxNtImplTransceiverManagerImplPeerAddToSendQueue"];
        FoxNioImplMpMuxImplSendUpdate = (FoxNioImplMpMuxImplSendUpdateFunc *)addressSet["FoxNioImplMpMuxImplSendUpdate"];
        FoxNioImplSppSocketImplSendImpl = (FoxNioImplSppSocketImplSendImplFunc *)addressSet["FoxNioImplSppSocketImplSendImpl"];
        FoxNioImplSteamUdpSocketImplSend = (FoxNioImplSteamUdpSocketImplSendFunc *)addressSet["FoxNioImplSteamUdpSocketImplSend"];
        FoxNioImplSteamUdpSocketImplRecv = (FoxNioImplSteamUdpSocketImplRecvFunc *)addressSet["FoxNioImplSteamUdpSocketImplRecv"];
        TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParameters =
            (TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParametersFunc *)addressSet["TppUiEmblemImplEmblemEditorSystemImplCreateEmblemParameters"];
        TppUiEmblemImplEmblemEditorSystemImplCreateEmblem =
            (TppUiEmblemImplEmblemEditorSystemImplCreateEmblemFunc *)addressSet["TppUiEmblemImplEmblemEditorSystemImplCreateEmblem"];
        TppUiEmblemImplEmblemEditorSystemImplLoadEmblemTextureInfo =
            (TppUiEmblemImplEmblemEditorSystemImplLoadEmblemTextureInfoFunc *)addressSet["TppUiEmblemImplEmblemEditorSystemImplLoadEmblemTextureInfo"];
        FoxNtImplSessionImpl2DeleteMember = (FoxNtImplSessionImpl2DeleteMemberFunc *)addressSet["FoxNtImplSessionImpl2DeleteMember"];
        FoxImplMessage2MessageBox2ImplSendMessageToSubscribers =
            (FoxImplMessage2MessageBox2ImplSendMessageToSubscribersFunc *)addressSet["FoxImplMessage2MessageBox2ImplSendMessageToSubscribers"];
        TppUiEmblemImplEmblemEditorSystemImplDeleteTexture =
            (TppUiEmblemImplEmblemEditorSystemImplDeleteTextureFunc *)addressSet["TppUiEmblemImplEmblemEditorSystemImplDeleteTexture"];
        TppUiEmblemImplEmblemEditorSystemImplUnloadEmblemTextureInfo =
            (TppUiEmblemImplEmblemEditorSystemImplUnloadEmblemTextureInfoFunc *)addressSet["TppUiEmblemImplEmblemEditorSystemImplUnloadEmblemTextureInfo"];
        TppGkTppGameKitModuleEnd = (TppGkTppGameKitModuleEndFunc *)addressSet["TppGkTppGameKitModuleEnd"];
        TppUiEmblemImplEmblemEditorSystemImplDeleteBlender =
            (TppUiEmblemImplEmblemEditorSystemImplDeleteBlenderFunc *)addressSet["TppUiEmblemImplEmblemEditorSystemImplDeleteBlender"];
        TppGkEmblemManagerCreateBlender = (TppGkEmblemManagerCreateBlenderFunc *)addressSet["TppGkEmblemManagerCreateBlender"];
        TppUiEmblemImplEmblemEditorSystemImplIsReady =
            (TppUiEmblemImplEmblemEditorSystemImplIsReadyFunc *)addressSet["TppUiEmblemImplEmblemEditorSystemImplIsReady"];
        TppGmPlayerImplClimbActionPluginImplCheckActionState =
            (TppGmPlayerImplClimbActionPluginImplCheckActionStateFunc *)addressSet["TppGmPlayerImplClimbActionPluginImplCheckActionState"];
        FoxGeoPathResultGetNumPoint = (FoxGeoPathResultGetNumPointFunc *)addressSet["FoxGeoPathResultGetNumPoint"];
    }
}