local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local IsTypeFunc = Tpp.IsTypeFunc
local IsTypeTable = Tpp.IsTypeTable
local IsTypeString = Tpp.IsTypeString
local GetGameObjectId = GameObject.GetGameObjectId
local NULL_ID = GameObject.NULL_ID

local sequences = {}

this.commonFuncTable = {}







local TARGET_BREAK_GIMMICK_NAME = {
	ANTN001							= "afgh_antn001_vrtn004_gim_n0000|srt_afgh_antn001_fndt004",			
	ANTN002							= "afgh_antn001_vrtn004_gim_n0001|srt_afgh_antn001_fndt004",			
	ANTN003							= "afgh_antn001_vrtn004_gim_n0002|srt_afgh_antn001_fndt004",			
	AACR001							= "afgh_antn006_gim_n0000|srt_afgh_antn006",							
	CMMN001							= "afgh_cmmn002_cmmn001_gim_n0000|srt_afgh_cmmn002_cmmn001",			
}


local TARGET_SEARCHTARGET_NAME_LIST = {
	ANTN001							= { MESSAGE = "missiontarget01", FOX2NAME = "/Assets/tpp/level/location/afgh/block_large/commFacility/afgh_commFacility_gimmick.fox2" },
	ANTN002							= { MESSAGE = "missiontarget02", FOX2NAME = "/Assets/tpp/level/location/afgh/block_large/commFacility/afgh_commFacility_gimmick.fox2" },
	ANTN003							= { MESSAGE = "missiontarget03", FOX2NAME = "/Assets/tpp/level/location/afgh/block_large/commFacility/afgh_commFacility_gimmick.fox2" },
	CMMN001							= { MESSAGE = "missiontarget04", FOX2NAME = "/Assets/tpp/level/location/afgh/block_large/commFacility/afgh_commFacility_gimmick.fox2" },
}


local GIMMICK_ID_LIST = {
	ANTN001							= "commFacility_antn001",
	ANTN002							= "commFacility_antn002",
	ANTN003							= "commFacility_antn003",
	CMMN001							= "commFacility_cmmn001",
}


local TRAP_NAME = {
	ARRIVALATCOMMFACILITY			= "s10043_trap_ArrivalAtcommFacility",									
	
	MOVESTART_AFGH_13_34_LRRP		= "s10043_trap_MoveStartcommFacility",									
	
	DISCOVERYANTN001				= "s10043_trap_DiscoveryAntn0001",										
	DISCOVERYANTN002				= "s10043_trap_DiscoveryAntn0002",										
	DISCOVERYANTN003				= "s10043_trap_DiscoveryAntn0003",										
	DISCOVERYCMMN001				= "s10043_trap_DiscoveryCmmn0001",										
	
	ROUTECHANGECOMMFACILITY_S		= "s10043_trap_RouteChangecommFacility0000",							
	ROUTECHANGECOMMFACILITY_WE		= "s10043_trap_RouteChangecommFacility0001",							
}


local MARKER_NAME = {
	
	AREA_RUINSNORTH					= "s10043_marker_ruinsNorth",											
	AREA_COMMFACILITY				= "s10043_marker_commFacility",											
	
	TARGET_ANTN001					= "s10043_marker_antn0001",												
	TARGET_ANTN002					= "s10043_marker_antn0002",												
	TARGET_ANTN003					= "s10043_marker_antn0003",												
	TARGET_CMN001					= "s10043_marker_cmmn",													
	
	ITEM_DIAMOND_S001				= "s10043_marker_commFacility_dia0000",									
	
	HOSTAGE001						= "s10043_marker_village_hostage0000",									
	HOSTAGE002						= "s10043_marker_village_hostage0001",									
}


local CHECKPOINT_NAME = {
	MISSINSTART						= "CHK_MissionStart",													
	DBG_COMMFACILITY				= "DBG_CHK_commFacility",												
	DBG_RUINSNORTH					= "DBG_CHK_ruinsNorth",													
}


local PHOTO_NAME = {
	COMMFACILITY					= 10,																	
}


this.COMMON_MESSAGE_LIST = {
	S_ENEMY_SETUP_DAY				= "enemySetupDay",														
	S_ENEMY_SETUP_NIGHT				= "enemySetupNight",													
	T_LRRP_MOVE_START				= "lrrpMoveStart",														
	R_LRRP_MOVE_CHANGE01			= "lrrpMoveChange01",													
	R_LRRP_MOVE_CHANGE02			= "lrrpMoveChange02",													
}


this.MISSIONTASK_LIST = {
	MAIN_SEARCH_TARGET				= 0,																	
	MAIN_BREAK_TARGET				= 1,																	
	SPECIALBONUS_RECOVERED_DIAMOND	= 2,																	
	SPECIALBONUS_BREAK_CMMN			= 3,																	
	SUB_RECOVERED_HOSTAGE			= 4,																	
	SUB_RECOVERED_CONTAINER			= 5,																	
}


local MAX_COUNT_ANTN = 3


local MAX_COUNT_HOSTAGE = 2




local gimmickBreakSettingTable = {}

gimmickBreakSettingTable[StrCode32( TARGET_BREAK_GIMMICK_NAME.ANTN001 )] = {
	
	gameObjectName			= TARGET_BREAK_GIMMICK_NAME.ANTN001,
	gameObjectType			= "TppPermanentGimmickImportantBreakable",
	messageName				= TARGET_SEARCHTARGET_NAME_LIST.ANTN001.MESSAGE,
	offSet					= Vector3(0,1.5,0),
	fox2Name				= TARGET_SEARCHTARGET_NAME_LIST.ANTN001.FOX2NAME,
	doDirectionCheck		= false,
	
	gimmickType				= "Antn",
	markFlagName			= "isMarkAntn01",
	breakFlagName			= "isBreakAntn01",
	breakMarkOffFlagName	= "isBreakMarkOffAntn01",
	markObjectiveName		= { "on_target_s10043_antn001" },
	breakObjectiveName		= { "off_target_s10043_antn001" },
	trapName				= TRAP_NAME.DISCOVERYANTN001,
}
gimmickBreakSettingTable[StrCode32( TARGET_BREAK_GIMMICK_NAME.ANTN002 )] = {
	
	gameObjectName			= TARGET_BREAK_GIMMICK_NAME.ANTN002,
	gameObjectType			= "TppPermanentGimmickImportantBreakable",
	messageName				= TARGET_SEARCHTARGET_NAME_LIST.ANTN002.MESSAGE,
	offSet					= Vector3(0,1.5,0),
	fox2Name				= TARGET_SEARCHTARGET_NAME_LIST.ANTN002.FOX2NAME,
	doDirectionCheck		= false,
	
	gimmickType				= "Antn",
	markFlagName			= "isMarkAntn02",
	breakFlagName			= "isBreakAntn02",
	breakMarkOffFlagName	= "isBreakMarkOffAntn02",
	markObjectiveName		= { "on_target_s10043_antn002" },
	breakObjectiveName		= { "off_target_s10043_antn002" },
	trapName				= TRAP_NAME.DISCOVERYANTN002,
}
gimmickBreakSettingTable[StrCode32( TARGET_BREAK_GIMMICK_NAME.ANTN003 )] = {
	
	gameObjectName			= TARGET_BREAK_GIMMICK_NAME.ANTN003,
	gameObjectType			= "TppPermanentGimmickImportantBreakable",
	messageName				= TARGET_SEARCHTARGET_NAME_LIST.ANTN003.MESSAGE,
	offSet					= Vector3(0,1.5,0),
	fox2Name				= TARGET_SEARCHTARGET_NAME_LIST.ANTN003.FOX2NAME,
	doDirectionCheck		= false,
	
	gimmickType				= "Antn",
	markFlagName			= "isMarkAntn03",
	breakFlagName			= "isBreakAntn03",
	breakMarkOffFlagName	= "isBreakMarkOffAntn03",
	markObjectiveName		= { "on_target_s10043_antn003" },
	breakObjectiveName		= { "off_target_s10043_antn003" },
	trapName				= TRAP_NAME.DISCOVERYANTN003,
}
gimmickBreakSettingTable[StrCode32( TARGET_BREAK_GIMMICK_NAME.CMMN001 )] = {
	
	gameObjectName			= TARGET_BREAK_GIMMICK_NAME.CMMN001,
	gameObjectType			= "TppPermanentGimmickImportantBreakable",
	messageName				= TARGET_SEARCHTARGET_NAME_LIST.CMMN001.MESSAGE,
	offSet					= Vector3(0,0.25,0),
	fox2Name				= TARGET_SEARCHTARGET_NAME_LIST.CMMN001.FOX2NAME,
	doDirectionCheck		= false,
	
	gimmickType				= "Cmmn",
	markFlagName			= "isMarkCmmn",
	breakFlagName			= "isBreakCmmn",
	breakMarkOffFlagName	= "isBreakMarkOffCmmn",
	markObjectiveName		= { "on_target_s10043_cmmn001" },
	breakObjectiveName		= { "off_target_s10043_cmmn001" },
	trapName				= TRAP_NAME.DISCOVERYCMMN001,
}


local resetGimmickIdTable = {
	"commFacility_antn001",
	"commFacility_antn002",
	"commFacility_antn003",
	"commFacility_mchn001",
	"commFacility_mchn002",
	"commFacility_mchn003",
	"commFacility_cmmn001",
	"commFacility_cmmn002",
}


local taskContainerIdTable = {
	"commFacility_cntn001",
	"commFacility_cntn002",
}


local taskHostageIdTable = {
	"hos_s10043_0000",
	"hos_s10043_0001",
}






this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PICKABLE_LOCATOR_COUNT = 24


this.MAX_PLACED_LOCATOR_COUNT = 30


this.REVENGE_MINE_LIST = { "afgh_commFacility", "afgh_village", }








function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Game_MainGame",
		"Seq_Game_Escape",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	IsForceMissionClear				= false,		
	
	isMarkAntn01					= false,		
	isMarkAntn02					= false,		
	isMarkAntn03					= false,		
	isMarkCmmn						= false,		
	isMarkAllTarget					= false,		
	isBreakAntn01					= false,		
	isBreakAntn02					= false,		
	isBreakAntn03					= false,		
	isBreakCmmn						= false,		
	isBreakMarkOffAntn01			= false,		
	isBreakMarkOffAntn02			= false,		
	isBreakMarkOffAntn03			= false,		
	isBreakMarkOffCmmn				= false,		
	
	isArrivalatruinsNorth			= false,		
	isMarkVip						= false,		
	UniqueInterVipCount				= 0,			
	
	isAirSearchRadar				= false,		
	
	isShowControlGuide_C4_01		= false,		
	isShowControlGuide_C4_02		= false,		
	
	isMoveStart_afgh_13_34_lrrp		= false,		
	isUniqueInterLrrp01				= false,		
	isUniqueInterLrrp02				= false,		
	
	antnBreakStartCount				= 0,			
	
	subHostageFultonCount			= 0,			
	
	
	isReserveFlag_01					= false,	
	isReserveFlag_02					= false,
	isReserveFlag_03					= false,
	isReserveFlag_04					= false,
	isReserveFlag_05					= false,
	isReserveFlag_06					= false,
	isReserveFlag_07					= false,
	isReserveFlag_08					= false,
	isReserveFlag_09					= false,
	isReserveFlag_10					= false,
	
	reserveCount_01						= 0,
	reserveCount_02						= 0,
	reserveCount_03						= 0,
	reserveCount_04						= 0,
	reserveCount_05						= 0,
	reserveCount_06						= 0,
	reserveCount_07						= 0,
	reserveCount_08						= 0,
	reserveCount_09						= 0,
	reserveCount_10						= 0,

}


this.checkPointList = {
	CHECKPOINT_NAME.MISSINSTART,					
	CHECKPOINT_NAME.DBG_COMMFACILITY,				
	CHECKPOINT_NAME.DBG_RUINSNORTH,					
	nil
}

 
this.baseList = {
	
	"commFacility",
	"village",
	
	"ruinsNorth",
	"commWest",
	"villageEast",
	"villageNorth",
	nil
}





this.missionObjectiveDefine = {
	
	
	default_area_commFacility = {
		gameObjectName	= MARKER_NAME.AREA_COMMFACILITY,		visibleArea = 4, randomRange = 0, viewType = "all", setNew = false,
		langId = "marker_info_mission_targetArea",	mapRadioName = "f1000_mprg0095",
		announceLog = "updateMap",
	},
	
	on_target_s10043_antn001 = {
		gimmickId = GIMMICK_ID_LIST.ANTN001,	goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true, announceLog = "updateMap",
		langId = "marker_info_mission_target",			mapRadioName = "f1000_mprg0140",
	},
	on_target_s10043_antn002 = {
		gimmickId = GIMMICK_ID_LIST.ANTN002,	goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true, announceLog = "updateMap",
		langId = "marker_info_mission_target",			mapRadioName = "f1000_mprg0140",
	},
	on_target_s10043_antn003 = {
		gimmickId = GIMMICK_ID_LIST.ANTN003,	goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true, announceLog = "updateMap",
		langId = "marker_info_mission_target",			mapRadioName = "f1000_mprg0140",
	},
	on_target_s10043_cmmn001 = {
		gimmickId = GIMMICK_ID_LIST.CMMN001,	goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true, announceLog = "updateMap",
		langId = "marker_info_mission_target",			mapRadioName = "f1000_mprg0140",
	},
	off_target_s10043_antn001 = {
		announceLog = "destroyTarget",
	},
	off_target_s10043_antn002 = {
		announceLog = "destroyTarget",
	},
	off_target_s10043_antn003 = {
		announceLog = "destroyTarget",
	},
	off_target_s10043_cmmn001 = {
		announceLog = "destroyTarget",
	},
	marker_all_target = {
		nil,
	},
	
	
	targetCpSetting = {
		targetBgmCp = "afgh_commFacility_cp",
	},
	
	
	default_photo_commFacility = {
		photoId			= PHOTO_NAME.COMMFACILITY, addFirst = true,
		photoRadioName	= "s0043_mirg0020",
	},
	
	
	default_subGoal_missionStart = {
		subGoalId		= 0,
	},
	on_subGoal_break_missiontarget = {
		subGoalId		= 1,
	},
	on_subGoal_missionComplete = {
		subGoalId		= 2,
	},
	
	
	default_mainTask_search_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SEARCH_TARGET,					isNew = false,	isComplete = false,	isFirstHide = false },
	},
	default_mainTask_break_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_BREAK_TARGET,					isNew = false,	isComplete = false,	isFirstHide = false },
	},
	on_mainTask_search_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SEARCH_TARGET,					isNew = true,	isComplete = true,	},
	},
	on_mainTask_break_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_BREAK_TARGET,					isNew = true,	isComplete = true,	},
	},
	
	
	default_subTask_recovered_hostage = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_HOSTAGE,				isNew = false,	isComplete = false,	isFirstHide = true },
	},
	default_subTask_recovered_container = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_CONTAINER,				isNew = false,	isComplete = false,	isFirstHide = true },
	},
	on_subTask_recovered_hostage = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_HOSTAGE,				isNew = true,	isComplete = true,	},
		announceLog = "updateMap",
	},
	on_subTask_recovered_container = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_CONTAINER,				isNew = true,	isComplete = true,	},
		announceLog = "updateMap",
	},
	
	
	rv_missionClear = {
		nil
	},
	
	
	on_itm_s10043_diamond001 = {
		gameObjectName = MARKER_NAME.ITEM_DIAMOND_S001,			goalType = "none", viewType = "map_and_world_only_icon", setNew = true, announceLog = "updateMap",
		langId = "marker_diamond_gem",
	},
	
	on_s10043_hostage001 = {
		gameObjectName = MARKER_NAME.HOSTAGE001,				goalType = "none", viewType = "map_and_world_only_icon", setNew = true, announceLog = "updateMap",
		langId = "marker_hostage",
	},
	
	on_s10043_hostage002 = {
		gameObjectName = MARKER_NAME.HOSTAGE002,				goalType = "none", viewType = "map_and_world_only_icon", setNew = true, announceLog = "updateMap",
		langId = "marker_hostage",
	},
	
	
	
	announce_log_achieveAllObjectives = {
		announceLog = "achieveAllObjectives",
	},
}










this.missionObjectiveTree = {
	
	rv_missionClear = {
		
		default_photo_commFacility = {
		},
		
		off_target_s10043_antn001 = {
			on_target_s10043_antn001 = {
			},
		},
		
		off_target_s10043_antn002 = {
			on_target_s10043_antn002 = {
			},
		},
		
		off_target_s10043_antn003 = {
			on_target_s10043_antn003 = {
			},
		},
		
		off_target_s10043_cmmn001 = {
			on_target_s10043_cmmn001 = {
			},
		},
		
		marker_all_target = {
			
			default_area_commFacility = {
			},
		},
		
		targetCpSetting = {
		},
	},
	
	on_subGoal_missionComplete = {
		on_subGoal_break_missiontarget = {
			default_subGoal_missionStart = {
			},
		},
	},
	
	on_itm_s10043_diamond001 = {
	},
	
	on_s10043_hostage001 = {
	},
	
	on_s10043_hostage002 = {
	},
	
	on_mainTask_search_target = {
		default_mainTask_search_target = {
		},
	},
	on_mainTask_break_target = {
		default_mainTask_break_target = {
		},
	},
	
	on_subTask_recovered_hostage = {
		default_subTask_recovered_hostage = {
		},
	},
	on_subTask_recovered_container = {
		default_subTask_recovered_container = {
		},
	},
	announce_log_achieveAllObjectives = {
	},
}





this.missionObjectiveEnum = Tpp.Enum{
	"default_area_commFacility",
	"on_target_s10043_antn001",
	"on_target_s10043_antn002",
	"on_target_s10043_antn003",
	"on_target_s10043_cmmn001",
	"off_target_s10043_antn001",
	"off_target_s10043_antn002",
	"off_target_s10043_antn003",
	"off_target_s10043_cmmn001",
	"marker_all_target",
	"targetCpSetting",
	"default_photo_commFacility",
	"default_subGoal_missionStart",
	"on_subGoal_break_missiontarget",
	"on_subGoal_missionComplete",
	"rv_missionClear",
	"on_itm_s10043_diamond001",
	"on_s10043_hostage001",
	"on_s10043_hostage002",
	
	"default_mainTask_search_target",
	"default_mainTask_break_target",
	"on_mainTask_search_target",
	"on_mainTask_break_target",
	
	"default_subTask_recovered_hostage",
	"default_subTask_recovered_container",
	"on_subTask_recovered_hostage",
	"on_subTask_recovered_container",
	
	"announce_log_achieveAllObjectives",
}






this.missionStartPosition = {
	
	orderBoxList = {
		"box_s10043_00",
	},
	
	helicopterRouteList = {
		"lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000",
	},
}






this.specialBonus = {
	first = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_DIAMOND,	},
	},
	second = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_BREAK_CMMN,			},
	},
}






function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	
	
	this.RegisterMissionSystemCallback()
	
	
	TppQuest.RegisterCanActiveQuestListInMission{ "ruins_q19010" }
	
	
	TppRatBird.EnableBird( "TppCritterBird" )

	
	TppLocation.RegistMissionAssetInitializeTable(
		this.s10043_baseOnActiveTable
	)

	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_LRRP_MOVE_START ) ] = {
		{ enemyName = s10043_enemy.ENEMY_NAME.LRRP_01,			routeId_d = "rts_d_ene01_13to34_0000",		routeId_n = "rts_n_ene01_13to34_0000", },
		{ enemyName = s10043_enemy.ENEMY_NAME.LRRP_02,			routeId_d = "rts_d_ene02_13to34_0000",		routeId_n = "rts_n_ene02_13to34_0000", },
		{ func = function() TppEnemy.SetEnable( s10043_enemy.ENEMY_NAME.LRRP_01 ) end },
		{ func = function() TppEnemy.SetEnable( s10043_enemy.ENEMY_NAME.LRRP_02 ) end },
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_LRRP_MOVE_CHANGE01 ) ] = {
		{ enemyName = s10043_enemy.ENEMY_NAME.LRRP_01,			routeId_d = "rts_13to34_0000" },
		{ enemyName = s10043_enemy.ENEMY_NAME.LRRP_02,			routeId_d = "rts_13to34_0000" },
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_LRRP_MOVE_CHANGE02 ) ] = {
		{ travelEnemyNameTable = { s10043_enemy.ENEMY_NAME.LRRP_01, s10043_enemy.ENEMY_NAME.LRRP_02, }, travelPlanName = "travelCommFacility" },
	}
	
end


function this.OnRestoreSVars()
	
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
end


this.OnEndMissionPrepareSequence = function()
	Fox.Log("*** OnEndMissionPrepareSequence ***")
	local missionName = TppMission.GetMissionName()
	

	if TppMission.IsMissionStart() 
	and gvars.s10043_forceMissionClear == true 
	and missionName == "s10043" then
		
		
		svars.isBreakAntn01	 = TppGimmick.IsBroken{ gimmickId = GIMMICK_ID_LIST.ANTN001, searchFromSaveData = true }
		svars.isBreakAntn02	 = TppGimmick.IsBroken{ gimmickId = GIMMICK_ID_LIST.ANTN002, searchFromSaveData = true }
		svars.isBreakAntn03	 = TppGimmick.IsBroken{ gimmickId = GIMMICK_ID_LIST.ANTN003, searchFromSaveData = true }
		svars.isBreakCmmn	 = TppGimmick.IsBroken{ gimmickId = GIMMICK_ID_LIST.CMMN001, searchFromSaveData = true }
		
		if this.IsMissionCompleteCheck() == true then
			
			svars.IsForceMissionClear = true
		else
			
			local markAntnCount, breakAntnCount, breakMarkOffAntnCount = this.GetAntnCount()
			
			svars.antnBreakStartCount = breakAntnCount
			Fox.Log("*** OnEndMissionPrepareSequence : AntnBreakStartCount *** : "..svars.antnBreakStartCount )
		end
	end
	
end


function this.RegisterMissionSystemCallback()
	Fox.Log("*** RegiserMissionSystemCallback ***")
	
	local systemCallbackTable ={
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnGameOver				= this.OnGameOver,
		OnRecovered				= this.OnRecovered,
		nil
	}
	
	
	TppMission.RegisterMissionSystemCallback(systemCallbackTable)
	
end


function this.OnEstablishMissionClear( missionClearType )
	Fox.Log("*** " .. tostring(missionClearType) .. " OnEstablishMissionClear ***")
	
	
	if ( missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT ) then
		TppTerminal.ReserveHelicopterSoundOnMissionGameEnd()
		TppPlayer.PlayMissionClearCamera()
		TppMission.MissionGameEnd{
				loadStartOnResult = true,
				
				fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,
				
				delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
		}
	else
		TppMission.MissionGameEnd{ loadStartOnResult = true }
	end
end


function this.OnGameOver( gameOverType )
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
end


function this.OnTerminate()
	
	if gvars.s10043_forceMissionClear == true then
		gvars.s10043_forceMissionClear = false
	end
	
end


function this.OnRecovered( gameObjectId )
	
	
	if Tpp.IsHostage( gameObjectId ) then
		this.OnFultonHostage( gameObjectId )
	end
	
end


function this.OnEndDeliveryWarp( stationUniqueId )
	Fox.Log("*** OnEndDeliveryWarp ***")
	if stationUniqueId == TppPlayer.GetStationUniqueId( "commFacility" ) then
	end
end








function this.Messages()

	return
	StrCode32Table {
		
		GameObject = {
			{	
				msg = "RoutePoint2",
				func = function ( gameObjectId, routeId, routeNodeIndex, messageId )
					this.OnCommonFunc{ gameObjectId = gameObjectId, routeId = routeId, routeNodeIndex = routeNodeIndex, messageId = messageId }
				end
			},
			{
				
				msg = "Fulton",
				func = function ( s_gameObjectId, containerName )
					
					if Tpp.IsFultonContainer( s_gameObjectId ) then
						this.OnFultonContainer( s_gameObjectId, containerName )
					end
					
					local puppyId = GameObject.GetGameObjectId("TppBuddyPuppy", "anml_BuddyPuppy_00")
					if puppyId ~= nil then
						if s_gameObjectId == puppyId then
							Fox.Log( "**** s30010_sequence::Puppy Fulton ****" )
							TppRadio.Play("f1000_rtrg5050", { delayTime = "long", isEnqueue = true } )
						end
					end
				end
			},
			{	
				msg = "BuddyPuppyFind",
				func = function( gameObjectId )
					Fox.Log( "**** s30010_sequence::BuddyPuppyFind ****" )
					if not TppRadio.IsPlayed("f1000_rtrg5040") then
						TppRadio.Play("f1000_rtrg5040", { delayTime = "long", isEnqueue = true } )
					end
				end
			},
			{	
				msg = "Damage",
				func = function( gameObjectId, attackId, attakerId )
					local puppyId = GameObject.GetGameObjectId("TppBuddyPuppy", "anml_BuddyPuppy_00")
					if puppyId ~= nil then
						if gameObjectId == puppyId and Tpp.IsPlayer( attakerId ) then
							Fox.Log( "**** s30010_sequence::Puppy Damaged by Player ****" )
							TppRadio.Play("f1000_rtrg5060", { delayTime = "short", } )
						end
					end
				end
			},
			{	
				msg = "Dead",
				func = function( gameObjectId, attakerId, attackId )
					local puppyId = GameObject.GetGameObjectId("TppBuddyPuppy", "anml_BuddyPuppy_00")
					if puppyId ~= nil then
						if gameObjectId == puppyId and Tpp.IsPlayer( attakerId ) then
							Fox.Log( "**** s30010_sequence::Puppy Dead ****" )
							TppRadio.Play("f1000_rtrg5070", { delayTime = "short", } )
						end
					end
				end
			},
			nil
		},
		
		Player = {
			{	
			 	msg = "OnEquipWeapon",
				func = function( playerIndex, equipId )
					if this.IsEquipC4( equipId ) then
						s10043_radio.Equip_C4()
					end
				end
			},
			{	
			 	msg = "WeaponPutPlaced",
				func = function( playerIndex, equipId )
					if this.IsEquipC4( equipId ) then
						s10043_radio.PutPlaced_C4()
					end
				end
			},
			{	
			 	msg = "OnAmmoStackEmpty",
				func = function( playerIndex, equipId )
					if this.IsEquipBlastWeapon() == true then
						s10043_radio.AmmoStackEmpty_C4()
					end
				end
			},
			{	
			 	msg = "OnPickUpCollection",
				func = function( playerGameObjectId, collectionUniqueId, collectionTypeId )
					this.OnPickUpCollection( collectionUniqueId )
				end
			},
			{
				msg = "DeadInFOB",
				func = function (deadPlayerIndex, AttackerId)
					TppUiCommand.AnnounceLogView("Player " .. tostring(deadPlayerIndex) .. " died")
					if deadPlayerIndex == PlayerInfo.GetLocalPlayerIndex() then
						TppUiCommand.AnnounceLogView("Respawn in 10 seconds")
						GkEventTimerManager.Start("RespawnPlayer", 10 )
					end
				end
			},
		},
		
		Trap = {
			{	
				msg = "Enter",
				sender = TRAP_NAME.ARRIVALATCOMMFACILITY,
				func = function ()
					if this.IsMainSequence() then
						if svars.isMarkCmmn == false then
							s10043_radio.ArrivalAtcommFacilityMarkerOff()
						else
							s10043_radio.ArrivalAtcommFacilityMarkerOn()
						end
					end
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.MOVESTART_AFGH_13_34_LRRP,
				func = function ()
					svars.isMoveStart_afgh_13_34_lrrp = true
					this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.T_LRRP_MOVE_START ) }
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.DISCOVERYANTN001,
				func = function ()
					if this.IsMainSequence() then
						this.OnDiscoveryTarget( TARGET_BREAK_GIMMICK_NAME.ANTN001 )
					end
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.DISCOVERYANTN002,
				func = function ()
					if this.IsMainSequence() then
						this.OnDiscoveryTarget( TARGET_BREAK_GIMMICK_NAME.ANTN002 )
					end
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.DISCOVERYANTN003,
				func = function ()
					if this.IsMainSequence() then
						this.OnDiscoveryTarget( TARGET_BREAK_GIMMICK_NAME.ANTN003 )
					end
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.DISCOVERYCMMN001,
				func = function ()
					if this.IsMainSequence() then
						this.OnDiscoveryTarget( TARGET_BREAK_GIMMICK_NAME.CMMN001 )
					end
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.ROUTECHANGECOMMFACILITY_S,
				func = function ()
					s10043_enemy.CheckRouteChangecommFacility( true )
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.ROUTECHANGECOMMFACILITY_WE,
				func = function ()
					s10043_enemy.CheckRouteChangecommFacility( false )
				end
			},
		},
		
		Radio = {
			{	
				msg = "Finish",
				sender = { "s0043_rtrg1010", "s0043_rtrg1011", "s0043_rtrg1012", "s0043_rtrg1015", },
				func = function ()
					local missionName = TppMission.GetMissionName()
					if missionName == "s10043" then
						local isMissionComplete	= this.IsMissionCompleteCheck() 
						local isEquipWeapons	= this.IsEquipSlotBlastWeapon()
						if isMissionComplete == false and isEquipWeapons == false then
							s10043_radio.ArrivalAtcommFacilityNoExplosionWeapons()
						end
					end
				end
			},
			{	
				msg = "Finish",
				sender = { "s0043_rtrg0062", "s0043_rtrg0063", "s0043_rtrg0065", "s0043_rtrg0070", "s0043_rtrg0050", "f1000_rtrg2160" },
				func = function ()
					if this.IsMainSequence() then
						local isMarkAllTarget = this.IsMarkingkAllTarget()
						if isMarkAllTarget == true then
							s10043_radio.MarkingAllTarget()

						end
					end
				end
			},
		},
		Timer = {
			{
				msg = "Finish",
				sender = "RespawnPlayer",
				func = function ()
					TppUiCommand.AnnounceLogView("Respawning")
					TppUiStatusManager.ClearStatus("AnnounceLog")
					TppUiStatusManager.ClearStatus("EquipPanel")
					TppUiStatusManager.ClearStatus("HeadMarker")
					TppUiStatusManager.ClearStatus("WorldMarker")
					Player.RequestToRespawn()
				end
			},
		},
		Network = {
			{
				msg = "FobPeerNameResolved",
				func = function ()
					TppUiCommand.AnnounceLogView("Co-op partner connecting")
				end
			},
		},
		Nt = {
			{
				msg = "SessionDeleteMember",
				func = function ()
					TppUiCommand.AnnounceLogView("Client Player Disconnected!")
				end
			},
			{
				msg = "SessionDisconnectFromHost",
				func = function ()
					TppUiCommand.AnnounceLogView("Host Player Disconnected!")
				end
			},
		},
		nil
	}
end






this.s10043_baseOnActiveTable = {
	afgh_commFacility = function()
		Fox.Log("s10043_baseOnActiveTable : afgh_commFacility")
		this.IsSetUpGimmcik()
		
	end,
}

function this.IsMainSequence()
	local sequenceName	 = TppSequence.GetCurrentSequenceName()
	local blRetcode = false
	if sequenceName == "Seq_Game_MainGame" then
		blRetcode = true
	end
	return blRetcode
end


function this.IsMissionCompleteCheck()
	if ( svars.isBreakAntn01 == true and svars.isBreakAntn02 == true and svars.isBreakAntn03 == true ) or svars.isBreakCmmn == true then
		return true
	end
	return false
end



function this.IsSetUpGimmcik()
	Fox.Log("IsSetUpGimmcik()")
	if svars.isBreakAntn01 == true then
		Fox.Log("Antn01 Break")
		local gimmickBreakSetting	= gimmickBreakSettingTable[ StrCode32( TARGET_BREAK_GIMMICK_NAME.ANTN001 ) ]
		Gimmick.BreakGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, gimmickBreakSetting.gameObjectName, gimmickBreakSetting.fox2Name, false)
	end

	if svars.isBreakAntn02 == true then
		Fox.Log("Antn02 Break")
		local gimmickBreakSetting	= gimmickBreakSettingTable[ StrCode32( TARGET_BREAK_GIMMICK_NAME.ANTN002 ) ]
		Gimmick.BreakGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, gimmickBreakSetting.gameObjectName, gimmickBreakSetting.fox2Name, false)
	end

	if svars.isBreakAntn03 == true then
		Fox.Log("Antn03 Break")
		local gimmickBreakSetting	= gimmickBreakSettingTable[ StrCode32( TARGET_BREAK_GIMMICK_NAME.ANTN003 ) ]
		Gimmick.BreakGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, gimmickBreakSetting.gameObjectName, gimmickBreakSetting.fox2Name, false)
	end

	if svars.isBreakCmmn == true then
		Fox.Log("Cmmn01 Break")
		local gimmickBreakSetting	= gimmickBreakSettingTable[ StrCode32( TARGET_BREAK_GIMMICK_NAME.CMMN001 ) ]
		Gimmick.BreakGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, gimmickBreakSetting.gameObjectName, gimmickBreakSetting.fox2Name, false)
	end


end


function this.IsMarkingkAllTarget()
	
	local markAntnCount, breakAntnCount, breakMarkOffAntnCount = this.GetAntnCount()
	local markCmmnCount = 0
	
	if svars.isMarkCmmn == true then
		markCmmnCount = markCmmnCount + 1
	end
	
	if ( svars.antnBreakStartCount + markAntnCount + breakMarkOffAntnCount + markCmmnCount ) == 4 then
		return true
	end
	
	return false
end



function this.IsEquipSlotBlastWeapon()
	local slotTable = {
		PlayerSlotType.SUPPORT,
	}
	local isBlastWeapon = false
	local blRetcode = false
	for i, slot in pairs( slotTable ) do
		for subIndex = 0, 7 do
			if isBlastWeapon == false then
				isBlastWeapon = Player.IsBlastWeaponBySlot( slot, subIndex, false )
			end
		end
	end
	
	if isBlastWeapon == true then
		blRetcode = true
	end
	
	return blRetcode
end


function this.IsEquipBlastWeapon()
	local blRetcode			= true

	
	if Player.IsBlastWeaponBySlot( PlayerSlotType.PRIMARY_1, 0 ) then
		local count, countSub = Player.GetAmmoStockBySlot( PlayerSlotType.PRIMARY_1, 0 )		
		if count > 0 then
			Fox.Log( "Primary1 : "..tostring(count) )
			blRetcode = false
		end
	end

	
	if Player.IsBlastWeaponBySlot( PlayerSlotType.PRIMARY_1, 0, true ) then
		local count, countSub = Player.GetAmmoStockBySlot( PlayerSlotType.PRIMARY_1, 1 )		
		if count > 0 then
			Fox.Log( "Primary1Under : "..tostring(count) )
			blRetcode = false
		end
	end

	
	if Player.IsBlastWeaponBySlot( PlayerSlotType.PRIMARY_2, 0 ) then
		local count, countSub = Player.GetAmmoStockBySlot( PlayerSlotType.PRIMARY_2, 0 )		
		if count > 0 then
			Fox.Log( "Primary2 : "..tostring(count) )
			blRetcode = false
		end
	end

	
	if Player.IsBlastWeaponBySlot( PlayerSlotType.SECONDARY, 0 ) then
		local count, countSub = Player.GetAmmoStockBySlot( PlayerSlotType.SECONDARY, 0 )		
		if count > 0 then
			Fox.Log( "SECONDARY : "..tostring(count) )
			blRetcode = false
		end
	end

	
	for i = 0 , 7 do
		if Player.IsBlastWeaponBySlot( PlayerSlotType.SUPPORT, i ) then
			local count, countSub = Player.GetAmmoStockBySlot( PlayerSlotType.SUPPORT, i )		
			if count > 0 then
			

				Fox.Log( "Support "..tostring(i).." : "..tostring(count) )
				blRetcode = false

			end
		end
	end

	Fox.Log( tostring(blRetcode) )
	return blRetcode
end


function this.IsEquipC4( equipId )
	local blRetcode = false
	local c4IdTable = {
		TppEquip.EQP_SWP_C4,
		TppEquip.EQP_SWP_C4_G01,
		TppEquip.EQP_SWP_C4_G02,
		TppEquip.EQP_SWP_C4_G03,
		TppEquip.EQP_SWP_C4_G04,
	}
	for i, c4Id in ipairs( c4IdTable ) do
		if c4Id == equipId then
			blRetcode =  true
		end
	end
	return blRetcode
end






function this.GetAntnCount()
	local markAntnCount = 0
	local breakAntnCount = 0
	local breakMarkOffAntnCount = 0
	for key, gimmickBreakSetting in pairs(gimmickBreakSettingTable)  do
		if gimmickBreakSetting.gimmickType == "Antn" then
			if svars[gimmickBreakSetting.markFlagName] then
				markAntnCount = markAntnCount + 1
			end
			if svars[gimmickBreakSetting.breakFlagName] then
				breakAntnCount = breakAntnCount + 1
			end
			if svars[gimmickBreakSetting.breakMarkOffFlagName] then
				breakMarkOffAntnCount = breakMarkOffAntnCount + 1
			end
		end
	end
	return markAntnCount, breakAntnCount, breakMarkOffAntnCount
end


function this.GetTargetRadio( radioType, gimmickType )
	local radioGroups = nil
	local markAntnCount, breakAntnCount, breakMarkOffAntnCount = this.GetAntnCount()
	
	
	markAntnCount = markAntnCount - breakMarkOffAntnCount
	
	if gimmickType == "Antn" then
		if svars.antnBreakStartCount == 0 then
			if radioType == "Marking" then
				if markAntnCount == 1 then
					if breakAntnCount == 0 or breakAntnCount == 1 then
						radioGroups = s10043_radio.GetMarkingAnntena01()
					else
						radioGroups = s10043_radio.GetMarkingAllAnntena( 2 )
					end
				elseif markAntnCount == 2 then
					if breakAntnCount == 0 then
						radioGroups = s10043_radio.GetMarkingAnntena02()
					elseif breakAntnCount == 1 then
						radioGroups = s10043_radio.GetMarkingAllAnntena( 1 )
					elseif breakAntnCount == 2 then
						radioGroups = s10043_radio.GetMarkingAllAnntena( 2 )
					end
				elseif markAntnCount == 3 then
					if breakAntnCount == 0 then
						radioGroups = s10043_radio.GetMarkingAllAnntena( 0 )
					elseif breakAntnCount == 1 then
						radioGroups = s10043_radio.GetMarkingAllAnntena( 1 )
					else
						radioGroups = s10043_radio.GetMarkingAllAnntena( 2 )
					end
				end
			else
				if breakAntnCount == 1 then
					radioGroups = s10043_radio.GetBreakAnntenaOne()
				elseif breakAntnCount == 2 then
					radioGroups = s10043_radio.GetBreakAnntenaTwo()
				end
			end
		elseif svars.antnBreakStartCount == 1 then
			if radioType == "Marking" then
				if markAntnCount == 1 then
					if breakAntnCount == 1 then
						radioGroups = s10043_radio.GetMarkingAnntena01()
					else
						radioGroups = s10043_radio.GetMarkingAllAnntena( 2 )
					end
				else
					if breakAntnCount == 1 then
						radioGroups = s10043_radio.GetMarkingAllAnntena( 1 )
					else
						radioGroups = s10043_radio.GetMarkingAllAnntena( 2 )
					end
				end
			else
				if breakAntnCount == 2 then
					radioGroups = s10043_radio.GetBreakAnntenaOne()
				end
			end
		elseif svars.antnBreakStartCount == 2 then
			if radioType == "Marking" then
				radioGroups = s10043_radio.GetMarkingAllAnntena( 2 )
			end
		end
	
	elseif gimmickType == "Cmmn" then
		if radioType == "Marking" then
			radioGroups = s10043_radio.GetMarkingComm()
		end
	end
	
	return radioGroups
end






function this.OnTargetMarker( messageName )
	local objectives
	local gimmickBreakSettingData
	local radioGroups
	
	
	for key, gimmickBreakSetting in pairs(gimmickBreakSettingTable)  do
		if messageName == StrCode32( gimmickBreakSetting.messageName ) then
			gimmickBreakSettingData = gimmickBreakSetting
			break
		end
	end
	
	
	if gimmickBreakSettingData == nil then 
		return 
	end

	
	if svars[gimmickBreakSettingData.breakFlagName] == true then
		return
	end

	local isMarking = svars[gimmickBreakSettingData.markFlagName]
	
	
	if isMarking == false then
		svars[gimmickBreakSettingData.markFlagName] = true
	else
		return
	end
	
	
	TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )

	
	if gimmickBreakSettingData.markObjectiveName then
		TppMission.UpdateObjective{
			objectives = gimmickBreakSettingData.markObjectiveName,
		}
	end
	
	
	local radioGroups = this.GetTargetRadio( "Marking", gimmickBreakSettingData.gimmickType )

	
	local markAntnCount, breakAntnCount, breakMarkOffAntnCount = this.GetAntnCount()
	local chekcMarkingTask = markAntnCount + svars.antnBreakStartCount
	Fox.Log("marking count : "..chekcMarkingTask )
	
	if ( chekcMarkingTask >= MAX_COUNT_ANTN or svars.isMarkCmmn == true )
	and svars.isReserveFlag_01 == false then
		svars.isReserveFlag_01 = true
		
		
		TppMission.UpdateObjective{
			objectives = { "marker_all_target", "on_subGoal_break_missiontarget", "on_mainTask_search_target" },
		}
	end
	
	if radioGroups then
		TppRadio.Play( radioGroups, { delayTime = "mid" } )
	end
	
end


function this.OnDiscoveryTarget( gameObjectName )
	
	local gimmickBreakSettingData
	
	
	for key, gimmickBreakSetting in pairs(gimmickBreakSettingTable)  do
		if gimmickBreakSetting.gameObjectName == gameObjectName then
			gimmickBreakSettingData = gimmickBreakSetting
			break
		end
	end
	
	
	if gimmickBreakSettingData == nil then 
		return 
	end

	local isBreak		= svars[gimmickBreakSettingData.breakFlagName]
	local isMarking		= svars[gimmickBreakSettingData.markFlagName]
	
	if isBreak == false then
		if isMarking == false then
			this.OnTargetMarker( StrCode32( gimmickBreakSettingData.messageName ) )
		else
			s10043_radio.DiscoveryTarget()
		end
	end
end


function this.OnFultonContainer( s_gameObjectId, containerName )
	
	if TppMission.IsEnableAnyParentMissionObjective( "on_subTask_recovered_container" ) == false then
		for i, gimmickId in pairs( taskContainerIdTable ) do
			local ret, gameObjectId = TppGimmick.GetGameObjectId( gimmickId )
			if gameObjectId == NULL_ID then
				Fox.Error("Cannot get gameObjectId. gimmickId = " .. tostring(gimmickId) )
			else
				if s_gameObjectId == gameObjectId then
					
					TppMission.UpdateObjective{
						objectives = {
							"on_subTask_recovered_container",
						},
					}
				end
			end
		end
	end
end


function this.OnFultonHostage( s_gameObjectId )
	
	if TppMission.IsEnableAnyParentMissionObjective( "on_subTask_recovered_hostage" ) == false then
		for i, gameObjectName in pairs( taskHostageIdTable ) do
			local gameObjectId = GameObject.GetGameObjectId( gameObjectName )
			if gameObjectId == NULL_ID then
				Fox.Error("Cannot get gameObjectId. gameObjectName = " .. tostring(gameObjectName) )
			else
				if s_gameObjectId == gameObjectId then
				
					
					if gameObjectName == taskHostageIdTable[1] then
						s10043_enemy.RemoveInterrogationHostage1()
					end
					if gameObjectName == taskHostageIdTable[2] then
						s10043_enemy.RemoveInterrogationHostage2()
					end
				
					
					svars.subHostageFultonCount = svars.subHostageFultonCount + 1
					
					if svars.subHostageFultonCount == MAX_COUNT_HOSTAGE then
						
						TppMission.UpdateObjective{
							objectives = {
								"on_subTask_recovered_hostage",
							},
						}
						
					end
				end
			end
		end
	end
end


function this.OnPickUpCollection( collectionUniqueId )
	
	if collectionUniqueId == TppCollection.GetUniqueIdByLocatorName( "col_diamond_l_s10043_0000" ) then
		
		TppResult.AcquireSpecialBonus{
			first = { isComplete = true },
		}
	end
end






function this.SetSearchTarget()
	Fox.Log("*** SetSearchTarget ***")
	for key, gimmickBreakSetting in pairs(gimmickBreakSettingTable)  do
		if not svars[gimmickBreakSetting.breakFlagName] then
			TppPlayer.SetSearchTarget(
				gimmickBreakSetting.gameObjectName,
				gimmickBreakSetting.gameObjectType,
				gimmickBreakSetting.messageName,
				nil,
				gimmickBreakSetting.offSet,
				gimmickBreakSetting.fox2Name,
				gimmickBreakSetting.doDirectionCheck
			)
		end
	end
end






this.OnCommonFunc = function( params )
	
	local commonFuncTable = this.commonFuncTable[ params.messageId ]
	if commonFuncTable then
		for i, commonFunc in ipairs( commonFuncTable ) do
			
			if commonFunc.enemyName then
				if commonFunc.routeId_d then
					local routeId = commonFunc.routeId_d
					if TppClock.GetTimeOfDay() == "night" and commonFunc.routeId_n then
						routeId = commonFunc.routeId_n
					end
					TppEnemy.SetSneakRoute( commonFunc.enemyName, routeId )
				end
				if commonFunc.routeId_c then
					TppEnemy.SetCautionRoute( commonFunc.enemyName, commonFunc.ruoteId_c )
				end
				if commonFunc.routeId_a then
					TppEnemy.SetAlertRoute( commonFunc.enemyName, commonFunc.ruoteId_a )
				end
			end
			
			if commonFunc.travelEnemyNameTable and commonFunc.travelPlanName then
				for j, travelEnemyName in ipairs( commonFunc.travelEnemyNameTable ) do
					local gameObjectId = GameObject.GetGameObjectId( travelEnemyName )
					GameObject.SendCommand( gameObjectId, { id = "StartTravel", travelPlan = commonFunc.travelPlanName } )
				end
			end
			
			if commonFunc.vehicleName and commonFunc.pos and commonFunc.rotY then
				local gameObjectId = GetGameObjectId( commonFunc.vehicleName )
				if gameObjectId == NULL_ID then
					Fox.Error( "Cannot get gameObjectId. gameObjectName = " .. params.gameObjectName )
				else
					GameObject.SendCommand( gameObjectId, { id  = "SetPosition", position = commonFunc.pos, rotY = commonFunc.rotY, } )
				end
			end
			
			if commonFunc.func then
				commonFunc.func()
			end
			
			if commonFunc.timerName and commonFunc.time then
				if not GkEventTimerManager.IsTimerActive( commonFunc.timerName ) then
					GkEventTimerManager.Start( commonFunc.timerName, commonFunc.time )
				end
			end
		end
	end
end






sequences.Seq_Game_MainGame = {

	Messages = function( self )
		return
		StrCode32Table {
			Player = {
				{	
				 	msg = "LookingTarget",
					func = function( messageName, gameObectId )
						this.OnTargetMarker( messageName )
					end
				},
			},
			GameObject = {
				{	
					msg = "BreakGimmick",
					func = function( cpGameObjectId, gameObjectName )
						self.BreakGimmick( gameObjectName )
					end
				},
			},
			Radio = {
				{	
					msg = "Finish",
					sender = "s0043_rtrg0015",
					func = function ()
						
						TppResult.RegistNoMissionClearRank()
						
						if Tpp.IsHelicopter( vars.playerVehicleGameObjectId ) then
							
							TppMission.ReserveMissionClear{
								nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI
							}
						else
							
							TppMission.ReserveMissionClear{
								missionClearType	= TppDefine.MISSION_CLEAR_TYPE.ON_FOOT,
								nextMissionId		= TppDefine.SYS_MISSION_ID.AFGH_FREE
							}
						end
					end
				},
			},
			nil
		}
	end,
	
	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		if svars.IsForceMissionClear == false then
			
			TppMission.UpdateObjective{
				objectives = {
								"default_photo_commFacility",
								"default_subGoal_missionStart",
								"default_mainTask_search_target",
								"default_mainTask_break_target",
								"default_subTask_recovered_hostage",
								"default_subTask_recovered_container",
								"targetCpSetting",
							},
			}
			if TppSequence.GetContinueCount() == 0 then

				
				local radioGroups = s10043_radio.GetMissionStart()
				TppMission.UpdateObjective{
					radio = {
						radioGroups = radioGroups,
					},
					objectives = {
									"default_area_commFacility",
								},
				}
			else
				s10043_radio.ContinueMissionStart()
				TppMission.UpdateObjective{
					objectives = {
									"default_area_commFacility",
								},
				}
			end
			
			this.SetSearchTarget()
			
			TppTelop.StartCastTelop()
		else
			
			s10043_radio.MissionStartGameClear()
			
			TppTelop.StartCastTelop()
		end
	end,
	
	OnLeave = function()
	end,
	
	
	BreakGimmick = function( gameObjectName )
		
		local objectives			= nil
		local gimmickBreakSetting	= gimmickBreakSettingTable[gameObjectName]
		
		if gimmickBreakSetting == nil then 
			return 
		end
		
		
		if svars[gimmickBreakSetting.breakFlagName] == false then
			svars[gimmickBreakSetting.breakFlagName] = true
		else
			return
		end
		
		
		if svars[gimmickBreakSetting.markFlagName] == true then
			svars[gimmickBreakSetting.breakMarkOffFlagName] = true
		end
				
		
		if gimmickBreakSetting.breakObjectiveName then
			objectives = gimmickBreakSetting.breakObjectiveName
		end
		
		
		local radioGroups = this.GetTargetRadio( "Break", gimmickBreakSetting.gimmickType )
		
		
		if this.IsMissionCompleteCheck() == false then
			if radioGroups then
				TppRadio.Play( radioGroups, { delayTime = "mid" } )
			end
			
			TppMission.UpdateObjective{
				objectives = objectives,
			}
		
		else
			
			TppMission.UpdateObjective{
				objectives = objectives,
			}
		end
		
		
		if gimmickBreakSetting.gimmickType == "Antn" then
			local markAntnCount, breakAntnCount, breakMarkOffAntnCount = this.GetAntnCount()
			TppUI.ShowAnnounceLog( "achieveObjectiveCount", ( svars.antnBreakStartCount + breakAntnCount ), MAX_COUNT_ANTN )
		
		elseif gimmickBreakSetting.gimmickType == "Cmmn" then
			TppMission.UpdateObjective{
				objectives = { "announce_log_achieveAllObjectives" },
			}
			
			TppResult.AcquireSpecialBonus{
				second = { isComplete = true },
			}
		end
		
		if this.IsMissionCompleteCheck() == true then
			
			TppSequence.SetNextSequence("Seq_Game_Escape")
		end
	end,
}


sequences.Seq_Game_Escape = {

	OnEnter = function()
		
		TppMission.CanMissionClear()
		
		TppMission.UpdateObjective{
			objectives = {
				"on_subGoal_missionComplete",
				"on_mainTask_break_target"
			},
		}
		
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = "s0043_rtrg0110",
			},
			objectives = {
							"rv_missionClear",
			},
		}
		
		s10043_radio.SetMissionClear()
	end,
}




return this
