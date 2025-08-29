#include "mgsvtpp_funcptr_set.h"
#include "mgsvtpp_func_typedefs.h"

namespace Dynamite {
    void SetFuncPtrs() {
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
        lua_createtable = (lua_createtableFunc*)addressSet["lua_createtable"];
        lua_pushvalue = (lua_pushvalueFunc*)addressSet["lua_pushvalue"];

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
        GetMainSession = (GetMainSessionFunc *)addressSet["GetMainSession"];
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
        BlockMemoryAllocTail = (BlockMemoryAllocTailFunc*)addressSet["BlockMemoryAllocTail"];
        BlockMemoryAllocHeap = (BlockMemoryAllocHeapFunc*)addressSet["BlockMemoryAllocHeap"];
        FoxBlockActivate = (FoxBlockActivateFunc *)addressSet["FoxBlockActivate"];
        FoxBlockDeactivate = (FoxBlockDeactivateFunc *)addressSet["FoxBlockDeactivate"];
        FoxBlockLoad = (FoxBlockLoadFunc *)addressSet["FoxBlockLoad"];
        CloseSession = (CloseSessionFunc *)addressSet["CloseSession"];
        Player2GameObjectImplWarp = (Player2GameObjectImplWarpFunc *)addressSet["Player2GameObjectImplWarp"];

        l_AnnounceLogView = (lua_CFunction)addressSet["l_AnnounceLogView"];
        FoxLuaPushVector3 = (FoxLuaPushVector3Func *)addressSet["FoxLuaPushVector3"];
        FoxLuaPushQuat = (FoxLuaPushQuatFunc *)addressSet["FoxLuaPushQuat"];
    }
}