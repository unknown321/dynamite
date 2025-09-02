#ifndef HOOK_MGSVTPP_FUNC_TYPEDEFS_H
#define HOOK_MGSVTPP_FUNC_TYPEDEFS_H

#include "Tpp/PlayerDamage.h"
#include "Tpp/TppTypes.h"
#include "lua/lauxlib.h"
#include "lua/lua.h"

typedef void(__fastcall luaI_openlibFunc)(lua_State *L, const char *libName, const luaL_Reg *l, int nup);

typedef void(__fastcall luaL_openlibsFunc)(lua_State *L);

typedef void(__fastcall lua_setfieldFunc)(lua_State *L, int idx, const char *k);

typedef void(__fastcall lua_pushintegerFunc)(lua_State *L, lua_Integer n);

typedef lua_Integer(__fastcall luaL_checkintegerFunc)(lua_State *L, int numArg);

typedef lua_Number(__fastcall luaL_checknumberFunc)(lua_State *L, int numArg);

typedef void(__fastcall lua_pushbooleanFunc)(lua_State *L, int b);

typedef bool(__fastcall IsDefenseTeamByOnlineFobLocalFunc)();

typedef bool(__fastcall IsOffenseTeamByOnlineFobLocalFunc)();

typedef int64_t(__fastcall CreateHostSessionFunc)(FobTarget *param);

typedef bool(__thiscall CreateClientSessionFunc)(FobTarget *param, SessionConnectInfo *sessionConnectInfo);

typedef void(__fastcall SetSteamIdFunc)(void *param, uint64_t *steamID);

typedef FobTarget *(__thiscall FobTargetCtorFunc)(FobTarget *);

typedef SessionConnectInfo *(__fastcall SessionConnectInfoCtorFunc)(SessionConnectInfo *);

typedef void(__fastcall NetworkSystemCreateHostSessionFunc)();

typedef void(__fastcall lua_pushstringFunc)(lua_State *L, const char *s);

typedef void(__fastcall lua_getfieldFunc)(lua_State *L, int idx, const char *k);

typedef int(__fastcall lua_pcallFunc)(lua_State *L, int nargs, int nresults, int errfunc);

typedef void *(__cdecl BlockHeapAllocFunc)(uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag);

typedef void *(__cdecl BlockHeapFreeFunc)(void *);

typedef void(__fastcall NetInfoCreateSessionFunc)();

typedef bool(__thiscall IsConnectReadyFunc)(void *);

typedef void(__thiscall UpdateClientEstablishedFunc)(void *);

typedef void *(__cdecl GetQuarkSystemTableFunc)();

typedef bool(__thiscall SessionImpl2IsHostFunc)(void *);

typedef unsigned int(__thiscall GetFobOffensePlayerInstanceIndexFunc)(void *);

typedef unsigned int(__thiscall GetFobDefensePlayerInstanceIndexFunc)(void *);

typedef void *(__fastcall HashMapOperatorFindKeyFunc)(void *hashmap, uint64_t key, uint64_t *keyPointer, void *testerFunc);

typedef uint64_t(__cdecl FoxStrHash32Func)(const char *text, uint64_t length);

typedef unsigned int(__thiscall CommandPost2ImplGetAvailableMemberCountFunc)(void *);

typedef unsigned int(__thiscall CommandPost2ImplGetMaxCpCountFunc)(void *);

typedef void *(__cdecl FoxFindEntityFunc)(uint64_t *);

typedef void *(__thiscall FoxGetEntityHandleFunc)(void *sharedPtrToEntity, void *EntityHandlePtr);

typedef void *(__fastcall FoxGetEntityPropertyFunc)(void *entityPtr, void *propertyInfo, void *string, int, int);

typedef uint32_t(__cdecl ValueGetAsUInt32Func)(void *value);

typedef double(__thiscall FoxBlockProcessFunc)(void *Block, void *TaskContext, void *BlockProcessState);

typedef int32_t *(__thiscall FoxBlockUnloadFunc)(void *Block, int32_t *param_2);

typedef int32_t *(__thiscall FoxBlockReloadFunc)(void *Block, int32_t *param_2);

typedef int32_t *(__thiscall FoxBlockActivateFunc)(void *Block, int32_t *param_2);

typedef int32_t *(__thiscall FoxBlockDeactivateFunc)(void *Block, int32_t *param_2);

typedef int *(FoxBlockLoadFunc)(void *thisPtr, int *errorCode, uint64_t *pathID, uint32_t param_4);

typedef int(lua_tobooleanFunc)(lua_State *L, int idx);

typedef void(lua_createtableFunc)(lua_State *L, int narray, int nrec);

typedef void(lua_pushvalueFunc)(lua_State *L, int index);

typedef void(lua_removeFunc)(lua_State *L, int index);

/*
enum fox::PropertyInfo::Type,
class fox::String const & __ptr64,
unsigned __int64,
unsigned __int64,
enum fox::PropertyInfo::Container,
enum fox::PropertyInfo::Storage,
class fox::EntityInfo const * __ptr64,
class fox::EnumInfo * __ptr64) */
typedef void *(__cdecl FoxCreatePropertyInfoFunc)(int type, void *name, uint64_t param_3, uint64_t param_4, int32_t container, int32_t storage,
    void *entityInfo,
    void *enumInfo); // EnumInfo::GetEnumInfo, GetEntityInfo

typedef void *(__thiscall FoxStringFunc)(void *, const char *);

typedef void *(__cdecl FindGameObjectWithIDFunc)(uint16_t);

typedef void *(__thiscall Soldier2ImplGetInterfaceFunc)(void *thisPtr, uint64_t stringID);

typedef void *(__cdecl PlayerInfoServiceGetPositionAtIndexFunc)(void *result, uint32_t playerIndex);

typedef void *(__cdecl GetMainSessionFunc)();

typedef int(__thiscall GetSessionMemberCountFunc)(void *session);

typedef uint32_t(__thiscall GetUiMarkerTypeFromSystemType2Func)(void *, void *);

typedef bool(__thiscall SightManagerImplSetMarkerFunc)(void *thisPtr, unsigned short param_2, float param_3);

typedef void(__thiscall SteamUdpSocketImplOnP2PSessionRequestFunc)(void *thisPtr, void *request);

typedef void *(__thiscall MessageBufferAddMessageFunc)(
    void *thisPtr, void *errCodePtr, uint32_t param_1, uint32_t param_2, uint32_t param_3, uint32_t param_4, void *messageArgs, uint32_t param_6);

typedef bool(__thiscall AddLocalDamageFunc)(void *thisPtr, uint32_t playerIndex, PlayerDamage *Damage);

typedef void(__thiscall DamageControllerImplInitializeFunc)(void *thisPtr, void *QuarkDesc);

typedef uint32_t(__thiscall SynchronizerImplGetDamageFunc)(void *thisPtr, uint32_t param1, PlayerDamage *Damage);

typedef void *(__thiscall Marker2SystemImplFunc)(void *thisPtr);

typedef void(__thiscall Marker2SystemImplPlacedUserMarkerFixedFunc)(void *thisPtr, Vector3 *param_1);

typedef bool(__cdecl GetLocalPlayerIDFunc)(uint32_t *result);

typedef bool(__thiscall RemoveUserMarkerFunc)(void *thisPtr, Vector3 *param_1);

typedef void(__thiscall EquipHudSystemImplInitDataFunc)(void *thisPtr);

typedef void(__thiscall Marker2SystemImplRemovedUserMarkerFunc)(void *thisPtr, uint32_t markerID);

typedef bool(__thiscall Marker2SystemImplPlacedUserMarkerFollowFunc)(void *thisPtr, Vector3 *pos, unsigned short objectID);

typedef void(__thiscall Marker2SystemImplRemovedAllUserMarkerFunc)(void *thisPtr);

typedef void(__thiscall SightManagerImplInitializeFunc)(void *thisPtr, void *QuarkDesc);

typedef void(__thiscall UiControllerImplSetNoUseEquipIdFunc)(void *thisPtr, bool param_1, unsigned int EquipID);

typedef bool(__thiscall EquipCrossEvCallIsItemNoUseFunc)(void *thisPtr, unsigned int EquipID);

typedef void(__cdecl FoxLuaPushVector3Func)(lua_State *param_1, Vector4 *param_2);

typedef void(__cdecl FoxLuaPushQuatFunc)(lua_State *L, Quat *param_2);

typedef void *(FoxGenerateUniqueNameFunc)(void *sharedString, unsigned long long param_2, void *string);

typedef void *(FoxBlockFunc)(void *p);

typedef void *(GetCurrentBlockMemoryFunc)();

typedef void *(__thiscall BlockMemoryAllocTailFunc)(void *memBlock, uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag);

typedef void *(__thiscall BlockMemoryAllocHeapFunc)(uint64_t sizeInBytes, uint64_t alignment, uint32_t categoryTag);

typedef void *(CloseSessionFunc)(void);

typedef void(__cdecl Player2GameObjectImplWarpFunc)(void *thisPtr, uint32_t objectID, Vector3 *pos, Quat *rot, bool param_5);

typedef void(__cdecl ScriptDeclVarsImplSetVarValueFunc)(void *thisPtr, uint64_t param_1, uint32_t param_2, bool param_3, ScriptVarValue value);

typedef void(__thiscall SoldierRouteAiImplPreUpdateFunc)(void *thisPtr, uint32_t param_1, void *AiNodeUpdateContext);

typedef uint32_t(__thiscall RouteGroupImplGetEventIdFunc)(void *RouteGroupImpl, unsigned short param_1, unsigned short param_2, unsigned short param_3);

typedef fox::QuarkHandle (__cdecl FoxCreateQuarkFunc)(uint64_t param_1, fox::QuarkDesc *qd, uint64_t p3);

typedef void (AiControllerImplAddNodeFunc)(void *thisPtr, uint32_t param_2, uint64_t quarkHandle, uint32_t param_4);

// lua library functions
extern luaI_openlibFunc *luaI_openlib;
extern luaL_openlibsFunc *luaL_openlibs;
extern lua_setfieldFunc *lua_setfield;
extern lua_pushintegerFunc *lua_pushinteger;
extern lua_pushstringFunc *lua_pushstring;
extern lua_getfieldFunc *lua_getfield;
extern lua_pcallFunc *lua_pcall;
extern luaL_checkintegerFunc *luaL_checkinteger;
extern lua_pushbooleanFunc *lua_pushboolean;
extern luaL_checknumberFunc *luaL_checknumber;
extern lua_tobooleanFunc *lua_toboolean;
extern lua_createtableFunc *lua_createtable;
extern lua_pushvalueFunc *lua_pushvalue;
extern lua_removeFunc *lua_remove;

// tpp lua functions (TppUiCommand.AnnounceLogView)
extern lua_CFunction l_AnnounceLogView;
extern FoxLuaPushVector3Func *FoxLuaPushVector3;
extern FoxLuaPushQuatFunc *FoxLuaPushQuat;

// tpp C++ functions
extern IsDefenseTeamByOnlineFobLocalFunc *IsDefenseTeamByOnlineFobLocal;
extern IsOffenseTeamByOnlineFobLocalFunc *IsOffenseTeamByOnlineFobLocal;
extern CreateHostSessionFunc *CreateHostSession;
extern CreateClientSessionFunc *CreateClientSession;
extern SetSteamIdFunc *SetSteamId;
extern FobTargetCtorFunc *FobTargetCtor;
extern SessionConnectInfoCtorFunc *SessionConnectInfoCtor;
extern NetworkSystemCreateHostSessionFunc *NetworkSystemCreateHostSession;
extern BlockHeapAllocFunc *BlockHeapAlloc;
extern BlockHeapFreeFunc *BlockHeapFree;
extern NetInfoCreateSessionFunc *NetInfoCreateSession;
extern IsConnectReadyFunc *IsConnectReady;
extern UpdateClientEstablishedFunc *UpdateClientEstablished;
extern GetQuarkSystemTableFunc *GetQuarkSystemTable;
extern SessionImpl2IsHostFunc *SessionImpl2IsHost;
extern GetFobOffensePlayerInstanceIndexFunc *GetFobOffensePlayerInstanceIndex;
extern GetFobDefensePlayerInstanceIndexFunc *GetFobDefensePlayerInstanceIndex;
extern HashMapOperatorFindKeyFunc *HashMapFindKey;
extern FoxStrHash32Func *FoxStrHash32;
extern CommandPost2ImplGetAvailableMemberCountFunc *CommandPost2ImplGetAvailableMemberCount;
extern CommandPost2ImplGetMaxCpCountFunc *CommandPost2ImplGetMaxCpCount;
extern FoxFindEntityFunc *FoxFindEntity;
extern FoxGetEntityHandleFunc *FoxGetEntityHandle;
extern FoxGetEntityPropertyFunc *FoxGetEntityProperty;
extern FoxCreatePropertyInfoFunc *FoxCreatePropertyInfo;
extern ValueGetAsUInt32Func *ValueGetAsUInt32;
extern FoxStringFunc *FoxString;
extern FindGameObjectWithIDFunc *FindGameObjectWithID;
extern Soldier2ImplGetInterfaceFunc *Soldier2ImplGetInterface;
extern PlayerInfoServiceGetPositionAtIndexFunc *PlayerInfoServiceGetPositionAtIndex;
extern GetMainSessionFunc *GetMainSession;
extern GetSessionMemberCountFunc *GetSessionMemberCount;
extern GetUiMarkerTypeFromSystemType2Func *GetUiMarkerTypeFromSystemType2;
extern SightManagerImplSetMarkerFunc *SightManagerImplSetMarker;
extern SteamUdpSocketImplOnP2PSessionRequestFunc *SteamUdpSocketImplOnP2PSessionRequest;
extern MessageBufferAddMessageFunc *MessageBufferAddMessage;
extern AddLocalDamageFunc *AddLocalDamage;
extern DamageControllerImplInitializeFunc *DamageControllerImplInitialize;
extern SynchronizerImplGetDamageFunc *SynchronizerImplGetDamage;
extern Marker2SystemImplFunc *Marker2SystemImpl;
extern Marker2SystemImplPlacedUserMarkerFixedFunc *Marker2SystemImplPlacedUserMarkerFixed;
extern GetLocalPlayerIDFunc *GetLocalPlayerId;
extern RemoveUserMarkerFunc *RemoveUserMarker;
extern EquipHudSystemImplInitDataFunc *EquipHudSystemImplInitData;
extern Marker2SystemImplRemovedUserMarkerFunc *Marker2SystemImplRemovedUserMarker;
extern Marker2SystemImplPlacedUserMarkerFollowFunc *Marker2SystemImplPlacedUserMarkerFollow;
extern Marker2SystemImplRemovedAllUserMarkerFunc *Marker2SystemImplRemovedAllUserMarker;
extern SightManagerImplInitializeFunc *SightManagerImplInitialize;
extern UiControllerImplSetNoUseEquipIdFunc *UiControllerImplSetNoUseEquipId;
extern EquipCrossEvCallIsItemNoUseFunc *EquipCrossEvCallIsItemNoUse;
extern FoxBlockProcessFunc *FoxBlockProcess;
extern FoxBlockUnloadFunc *FoxBlockUnload;
extern FoxBlockReloadFunc *FoxBlockReload;
extern FoxGenerateUniqueNameFunc *FoxGenerateUniqueName;
extern FoxBlockFunc *FoxBlock;
extern GetCurrentBlockMemoryFunc *GetCurrentBlockMemory;
extern BlockMemoryAllocTailFunc *BlockMemoryAllocTail;
extern BlockMemoryAllocHeapFunc *BlockMemoryAllocHeap;
extern FoxBlockActivateFunc *FoxBlockActivate;
extern FoxBlockDeactivateFunc *FoxBlockDeactivate;
extern FoxBlockLoadFunc *FoxBlockLoad;
extern CloseSessionFunc *CloseSession;
extern Player2GameObjectImplWarpFunc *Player2GameObjectImplWarp;
extern ScriptDeclVarsImplSetVarValueFunc *ScriptDeclVarsImplSetVarValue;
extern SoldierRouteAiImplPreUpdateFunc *SoldierRouteAiImplPreUpdate;
extern RouteGroupImplGetEventIdFunc *RouteGroupImplGetEventId;
extern FoxCreateQuarkFunc *FoxCreateQuark;
extern AiControllerImplAddNodeFunc *AiControllerImplAddNode;

#endif // HOOK_MGSVTPP_FUNC_TYPEDEFS_H
