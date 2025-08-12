local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}



this.EQUIP_MISSION_BLOCK_GROUP_SIZE	= 1240000	


this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PLACED_LOCATOR_COUNT = 40

this.MAX_PICKABLE_LOCATOR_COUNT = 22



local TIME_MOTHER_BASE_DEMO = "19:00:00"

local MISSION_INFO_PHOTO_ID = 10


local TARGET_HUEY = "TppHuey2GameObjectLocator"
local TARGET_HUEY_LIFE = 10000


local RANGE_TARGET_CHECK_NEAR = 3	
local RANGE_TARGET_CHECK_FAR = 20	


local TIMER_HUEY_FEAR = 60				
local TIMER_HUEY_CARRIED_MONOLOGUE = 20	
local TIMER_HUEY_ROLE = 20				
local TIMER_ABOUT_WALKERGEAR = 5		
local TIMER_HUEY_DAMAGE = 30			


local SP_WALKERGEAR_COLOR = 5
local SP_WALKERGEAR_LIFE = 30000
local SP_WALKERGEAR_LIFE_SAHELAN = 10000

this.MISSION_TASK_TARGET = {
	"wkr_s10070_0000",
	"wkr_s10070_0001",
	"wkr_s10070_0002",
}

this.MISSION_WALKER_LIST = {
	"wkr_s10070_sp",
	"wkr_s10070_0000",
	"wkr_s10070_0001",
	"wkr_s10070_0002",
}

this.WALKER_POS_ATTACK_DEMO = {-2194.278, 443.072, -1256.083}
this.HORSE_POS01_ATTACK_DEMO = Vector3(-2191.306, 445.059, -1256.470)
this.HORSE_POS02_ATTACK_DEMO = Vector3(-2175.822, 445.704, -1270.753)
this.VEHICLE_POS_ATTACK_DEMO = Vector3(-2204.378, 443.156, -1251.877)
this.TRUCK_POS_ATTACK_DEMO = Vector3(-2204.378, 443.156, -1251.877)


local EVENT_DOOR_NAME		= "gntn_door004_vrtn002_gim_n0001|srt_gntn_door004_vrtn002"
local EVENT_DOOR_PATH		= "/Assets/tpp/level/location/afgh/block_large/powerPlant/afgh_powerPlant_gimmick.fox2"
local DATASET_PATH_LARGE = "/Assets/tpp/level/location/afgh/block_large/sovietBase/afgh_sovietBase_asset.fox2"

local DATASET_PATH_ASSET01 = "/Assets/tpp/level/location/afgh/block_large/sovietBase/afgh_soviet_mission_asset01.fox2"


local GIMMICK_NAME = {
	CNTN001				= "gntn_cntn001_vrtn001_gim_n0000|srt_gntn_cntn001_vrtn001",			
	CNTN002				= "gntn_cntn001_vrtn001_gim_n0001|srt_gntn_cntn001_vrtn001",			
	CNTN003				= "gntn_cntn001_vrtn001_gim_n0002|srt_gntn_cntn001_vrtn001",			
	CNTN004				= "gntn_cntn001_vrtn001_gim_n0003|srt_gntn_cntn001_vrtn001",			
}
local GIMMICK_PATH = {
	CNTN001				= "/Assets/tpp/level/mission2/story/s10070/s10070_gimmick.fox2",			
	CNTN002				= "/Assets/tpp/level/mission2/story/s10070/s10070_gimmick.fox2",			
	CNTN003				= "/Assets/tpp/level/mission2/story/s10070/s10070_gimmick.fox2",			
	CNTN004				= "/Assets/tpp/level/mission2/story/s10070/s10070_gimmick.fox2",			
}


local RV01 = "lzs_sovietBase_S_0000"	
local RV02 = "lzs_sovietSouth_W_0000"	
local RV_ESCAPE = "lzs_sovietBase_S_escape"	

local HELI_WAIT_HIGHT_DEFAULT = 20		
local HELI_WAIT_HIGHT_ESCAPE01 = 45		
local HELI_WAIT_HIGHT_ESCAPE02 = 30		
local HELI_WAIT_HIGHT_SAHELAN = 70		

local RANGE_SAHELAN_TO_LZ_CHECK_CAUTION = 200	
local RANGE_SAHELAN_TO_LZ_CHECK_SNEAK = 60		
local RANGE_HELI_TO_PLAYER_CHECK = 13		
local RANGE_SAHELAN_TO_LZ_CHECK_LANDED = 100	


local TIMER_ABOUT_9YEARS_RADIO = 15				
local TIMER_ABOUT_SAHELAN_FALLDEMO = 3		
local TIMER_ABOUT_CALL_HELI = 45		
local TIMER_LANDING_CHECK = 8			

local TIMER_SHOOTSAHEKAN_INIT = 10
local TIMER_SHOOTSAHEKAN_OBJECTIVE = 13
local TIMER_SHOOTSAHEKAN_STOP = 19
local TIMER_SHOOTSAHEKAN_FINAL_ATTACK_INIT = 1
local TIMER_SHOOTSAHEKAN_FINAL_ATTACK_RADIO = 1


this.npcScriptPackList = {
	
	powerPlantHunger =	{
					"/Assets/tpp/pack/mission2/story/s10070/s10070_npc01.fpk",
				 },
	
	Huey =		{
					TppDefine.MISSION_COMMON_PACK.HUEY,
					"/Assets/tpp/pack/mission2/story/s10070/s10070_npc02.fpk",
				 },
}



this.VARIABLE_TRAP_SETTING = {
	
	{ name = "trig_innerZone_01",	type = TppDefine.TRAP_TYPE.TRIGGER,	initialState = TppDefine.TRAP_STATE.ENABLE, },
	{ name = "trig_outerZone_01",	type = TppDefine.TRAP_TYPE.TRIGGER,	initialState = TppDefine.TRAP_STATE.ENABLE, },

	
	{ name = "trig_innerZone_02",	type = TppDefine.TRAP_TYPE.TRIGGER,	initialState = TppDefine.TRAP_STATE.DISABLE, },
	{ name = "trig_outerZone_02",	type = TppDefine.TRAP_TYPE.TRIGGER,	initialState = TppDefine.TRAP_STATE.DISABLE, },

}








function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		

		"Seq_Demo_SahelanTest",			

		"Seq_Demo_MissionTitle",		

		"Seq_Game_GoToSovietBase",		

		"Seq_Demo_ContactHuey",			

		"Seq_Game_EscapeSovietBase",	

		"Seq_Demo_SahelanAttacks",		

		"Seq_Game_EscapeSahelan",		

		"Seq_Game_ShootSahelan",		

		"Seq_Demo_SahelanFalling",		

		"Seq_Demo_MotherBase",			

		nil
	}
	TppSequence.RegisterSequenceTable(sequences)


end





this.saveVarsList = {
	ispowerPlantHeliStart		= false,		
	ispowerPlantHeliMove		= false,		
	isOpeningRadio02			= false,		
	isOpeningDemoRadio			= false,		
	isWalkerLrrpStart			= false,		
	isSovietBaseLrrpStart		= false,		
	ispowerPlantHeliDisable		= false,		
	issovietEnemyHeliStart		= false,		
	issovietEnemyHeliMove		= false,		
	issovietBaseHeliExitStart	= false,		
	issovietBaseHeliDisable		= false,		
	isArrivedSovietBase			= false,		
	isFoundHueyPos				= false,		
	isRideMetalDemoPlay			= false,		
	is9yearsRadioPlay			= false,		
	isSahelan_Herald00			= false,		
	
	isSahelan_Herald02			= false,		
	isCallHeliRV_escape			= false,		
	isAfterSahelanAttack		= false,		
	isRideOnHeli_Huey			= false,		
	isRideEscapeHeli			= false,		
	
	isHuey_Damaged				= false,		

	isDummyFlag01 = false,		
	isDummyFlag02 = false,		
	isDummyFlag03 = false,		
	isDummyFlag04 = false,		
	isDummyFlag05 = false,		
	isDummyFlag06 = false,		
	isDummyFlag07 = false,		
	isDummyFlag08 = false,
	isDummyFlag09 = false,
	isDummyFlag10 = false,
	isDummyFlag11 = false,
	isDummyFlag12 = false,
	isDummyFlag13 = false,
	isDummyFlag14 = false,
	isDummyFlag15 = false,
	isDummyFlag16 = false,
	isDummyFlag17 = false,
	isDummyFlag18 = false,
	isDummyFlag19 = false,
	isDummyFlag20 = false,

	countDummyValue01 = 0,
	countDummyValue02 = 0,
	countDummyValue03 = -1,

	typeHueyRideVehicle = 0,
	idHueyRideVehicle = 0,
	seatIndexHueyRideVehicle = 0,
	isPlayerRideBuddy = false,
	isPlayerRideVehicle = false,
	isPlayerRideWalker = false,
	numPlayerRideWalker = 0,

}

this.missionVarsList = {
}


this.checkPointList = {
	"CHK_MissionStart",
	"CHK_BeforeSahelanTestDemo",
	"CHK_AfterSahelanTestDemo",
	"CHK_AfterGetIntelDemo",
	"CHK_BeforeContactHueyDemo",
	"CHK_AfterContactHueyDemo",
	"CHK_AfterRideMetalDemo",
	"CHK_BeforeSahelanAttackDemo",
	"CHK_AfterSahelanAttackDemo",
	"CHK_MotherBaseDemo",
	nil
}

if TppLocation.IsAfghan() then
	
	this.baseList = {
		"sovietBase",
		"powerPlant",
		"plantWest",
		"sovietSouth",
		nil
	}
end







this.missionObjectiveDefine = {
	
	mission_target_cp = {
		packLabel = { "afterSahelanTestDemo" },
		targetBgmCp = "afgh_sovietBase_cp",
	},
	
	default_area_sovietBase01 = {
		gameObjectName = "Marker_default_area_sovietBase", visibleArea = 6, randomRange = 0, viewType = "map_only_icon", setNew = false,
		announceLog = "updateMap", mapRadioName = "s0070_mprg0020", targetBgmCp = "afgh_sovietBase_cp", langId = "marker_info_mission_targetArea",
	},
	
	default_area_sovietBase02 = {
		gameObjectName = "Marker_default_area_sovietBase", visibleArea = 6, randomRange = 0, viewType = "all", setNew = true,
		announceLog = "updateMap", mapRadioName = "s0070_mprg0020", targetBgmCp = "afgh_sovietBase_cp", langId = "marker_info_mission_targetArea",
	},
	
	detail_area_sovietBase = {
		gameObjectName = "Marker_default_area_sovietBase", visibleArea = 5, randomRange = 0, viewType = "map_only_icon", setNew = false,
		announceLog = "updateMap", targetBgmCp = "afgh_sovietBase_cp", langId = "marker_info_mission_targetArea",
	},
	
	detail_area_huey = {
		gameObjectName = "Marker_detail_area_huey", visibleArea = 2, randomRange = 0, viewType = "all",
		announceLog = "updateMap", mapRadioName = "s0070_mprg0030", langId = "marker_info_mission_targetArea",
	},
	
	target_huey = {
		gameObjectName = "Marker_huey", goalType = "defend", viewType = "all", setNew = true, setImportant = true,
		announceLog = "updateMap", langId = "marker_chara_huey", 
	},
	
	area_sp_walkergear = {
		gameObjectName = "Marker_area_sp_walkergear", visibleArea = 0, goalType = "moving", viewType = "map_only_icon", setNew = false,
		announceLog = "updateMap", 
	},
	
	rv_escape = {
		gameObjectName = "Marker_rv_escape", visibleArea = 0, randomRange = 0, viewType = "all", setNew = true,
		announceLog = "updateMap",

	},
	
	rv_01 = {
		gameObjectName = "Marker_rv_01", visibleArea = 0, randomRange = 0, viewType = "map_and_world_only_icon", setNew = true,
		announceLog = "updateMap",
	},
	
	rv_02 = {
		gameObjectName = "Marker_rv_02", visibleArea = 0, randomRange = 0, viewType = "map_and_world_only_icon", setNew = true,
		announceLog = "updateMap",
	},
	
	shoot_sahelan = {
		
	},

	
	
	photo_target = {
		photoId = MISSION_INFO_PHOTO_ID,	addFirst = true, addSecond = false, photoRadioName = "s0070_mirg0010",
	},
	
	
	subGoal_default = {		
		subGoalId= 0,
	},
	subGoal_gotoLZ = {		
		subGoalId= 1,
	},
	subGoal_rideHeli = {	
		subGoalId= 2,
	},
	
	
	 
	default_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = false },
	},
	clear_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = true },
	},
	 
	default_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false },
	},
	clear_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = true },
	},
	
	 
	default_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide=true },
	},
	clear_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = false },
	},
	 
	default_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide=true },
	},
	clear_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = false },
	},
	
	 
	default_missionTask_05 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = false, isFirstHide=true },
	},
	clear_missionTask_05 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = true },
	},
	 
	default_missionTask_06 = {
		missionTask = { taskNo = 5, isNew = true, isComplete = false, isFirstHide=true },
	},
	clear_missionTask_06 = {
		missionTask = { taskNo = 5, isNew = true, isComplete = true },
	},
	
	
	announce_rescue_target = {
		announceLog = "recoverTarget",			
	},
	announce_rescue_complete = {
		announceLog = "achieveAllObjectives",	
	},
	
	area_Intel_powerPlant = {
		gameObjectName = "s10070_marker_intelFile", 
	},
	
	area_Intel_powerPlant_get = {
	},
}











this.missionObjectiveTree = {
	shoot_sahelan = {
		rv_01 = {
			area_sp_walkergear = {},
			rv_escape = {	
				target_huey = {	
					detail_area_huey = {	
						detail_area_sovietBase = {	
							default_area_sovietBase02 = {
								default_area_sovietBase01 = {},	
							},
						},

					},
					area_Intel_powerPlant_get = {	
						area_Intel_powerPlant = {},	
					},
				},
			},
		},
		rv_02 = {},
	},
	photo_target = {},	
	mission_target_cp = {},

	clear_missionTask_01 = {
		default_missionTask_01 = {},
	},
	clear_missionTask_02 = {
		default_missionTask_02 = {},
	},
	clear_missionTask_03 = {
		default_missionTask_03 = {},
	},
	clear_missionTask_04 = {
		default_missionTask_04 = {},
	},
	clear_missionTask_05 = {
		default_missionTask_05 = {},
	},
	clear_missionTask_06 = {
		default_missionTask_06 = {},
	},
	announce_rescue_target = {},
	announce_rescue_complete = {},
}

this.missionObjectiveEnum = Tpp.Enum{
	"default_area_sovietBase01",
	"default_area_sovietBase02",
	"detail_area_sovietBase",
	"detail_area_huey",
	"target_huey",
	"area_sp_walkergear",
	"rv_escape",
	"rv_01",
	"rv_02",
	"shoot_sahelan",
	"mission_target_cp",
	"photo_target",

	"subGoal_default",
	"subGoal_gotoLZ",
	"subGoal_rideHeli",

	"default_missionTask_01",
	"default_missionTask_02",
	"default_missionTask_03",
	"default_missionTask_04",
	"default_missionTask_05",
	"default_missionTask_06",
	"clear_missionTask_01",
	"clear_missionTask_02",
	"clear_missionTask_03",
	"clear_missionTask_04",
	"clear_missionTask_05",
	"clear_missionTask_06",

	"announce_rescue_target",
	"announce_rescue_complete",
	"area_Intel_powerPlant",
	"area_Intel_powerPlant_get",
}



this.NPC_ENTRY_POINT_SETTING = {
	[TppDefine.INIT_HELI_ROUTE] = {
		[EntryBuddyType.VEHICLE] = { Vector3(-794.496, 517.690, -1272.109), TppMath.DegreeToRadian(180.0) }, 
		[EntryBuddyType.BUDDY] = { Vector3(-807.012, 516.625, -1266.057), TppMath.DegreeToRadian(180.0) }, 
	},
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 2, },		
	},
	second = {
		missionTask = { taskNo = 3, },		
	},
}









function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	
	this.RegisterMissionSystemCallback()

	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "Demo_SahelanTest" },
	}

	
	TppEnemy.RequestLoadWalkerGearEquip()

	
	
	TppScriptBlock.RegisterCommonBlockPackList( "npc_block", this.npcScriptPackList )

	
	if TppLocation.IsAfghan() then
		TppLocation.RegistMissionAssetInitializeTable(	this.s10070_baseOnActiveTable )
	end

	
	
	this.AddTrapSettingForRideMetalDemo{
		metalName = "RideMetal",
		trapName = "trap_RideMetal",
		direction = 180,
	}

	
	
	TppPlayer.AddTrapSettingForIntel{
		intelName			= "Intel_powerPlant",				
		autoIcon			= true,
		identifierName		= "GetIntelIdentifier",
		locatorName			= "GetIntel_HueyPos",
		gotFlagName			= "isDummyFlag02",					
		trapName			= "trap_intel_00",					
		markerObjectiveName	= "area_Intel_powerPlant",		
		markerTrapName		= "trap_intelMarkAreaPowerPlant",	

	}

	
	mvars.waitHueyBlockLoad 			= false		
	mvars.isHueyBlockLoad 				= false		
	mvars.isContactHueyDemoBlockLoad 	= false		

	mvars.ispowerPlantHeliDisableReserve = false	
	mvars.issovietBaseHeliDisableReserve = false	
	mvars.issovietBaseHeliExitReserve	 = false	

	mvars.WalkerRouteA					= 0		
	mvars.WalkerRouteB					= 0		

	mvars.isReserveRideMetalDemoPlay	= false		
	mvars.isPreMoveRideMetal			= false		
	mvars.isSahelanHerald02DemoPlay		= false		


	mvars.is1stHeliRadio = false		
	mvars.is1stHeliCall = false			

	mvars.isSahelan_Herald02 = false	
	mvars.isSahelanAlert = false		
	mvars.isSahelan1stAlert = false		
	mvars.isSahelanEvasion = false		
	mvars.isUsePatrolMissile = false	
	mvars.currentRVPoint = RV01			
	mvars.isPlayerInsovietBase = false	
	mvars.isPlayerOnLZ = false			
	mvars.isHeliLZTry = false			
	mvars.isPlayerRideOnHeli = false	
	mvars.isSahelanAttackHeli1 = false	
	mvars.isSahelanAttackHeli2 = false	
	mvars.isCantLandingRadio = false	
	mvars.HeliDamageCount				= 0		
	mvars.isSahelanStopped = false		

	mvars.vsHeliSeqLZ = nil				
	mvars.deadSahelan = false			
	mvars.alldeadSahelan = false		


	
	mvars.isPlayedMonologue_Huey01 = false
	mvars.isPlayedMonologue_Huey01_end = false
	mvars.isPlayedMonologue_Huey02 = false
	mvars.isPlayedMonologue_Huey03 = false
	mvars.isPlayedMonologue_Huey04 = false
	mvars.isPlayedMonologue_Huey05 = false
	mvars.isPlayedMonologue_Huey05_end = false
	mvars.isPlayedMonologue_Huey06 = false
	mvars.isPlayedMonologue_Huey07 = false
	mvars.isPlayedMonologue_Huey08 = false
	mvars.isPlayedMonologue_Huey09 = false
	mvars.isPlayedMonologue_Huey10 = false
	mvars.isPlayedMonologue_Huey11 = false

	mvars.isPlaying_Huey11 = false		
	

end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	local restoreSeq		= TppSequence.GetMissionStartSequenceName()	

	
	this.UpdateMissionZone()

	
	if restoreSeq == "Seq_Demo_SahelanTest" then

	
	elseif restoreSeq == "Seq_Demo_MissionTitle" or restoreSeq == "Seq_Game_GoToSovietBase" then
		
		this.CheckNpcScriptBlockLoad()

	
	elseif restoreSeq == "Seq_Game_EscapeSovietBase" then

		
		if TppScriptBlock.GetCurrentPackListName( "npc_block" ) ~= "Huey" then
			Fox.Log("_____ npc_block[huey] is not loaded _____")
			TppScriptBlock.Load( "npc_block", "Huey", true )
		end

		local gameObjectId = GameObject.GetGameObjectId("TppHuey2", "TppHuey2GameObjectLocator" )	
		vars.initialPlayerPairGameObjectId = gameObjectId

		if svars.isRideMetalDemoPlay == false then
			this.SwitchSovietBaseHungerDoor( false )
		end

	
	elseif restoreSeq == "Seq_Demo_SahelanAttacks" then
		
		Fox.Log("*** s10070_sequence:ReSet HeliEscape BGM ***")
		TppMusicManager.PostJingleEvent( "MissionEnd", "Stop_bgm_mission_clear_heli" )
		this.UnlockedHuey()					

		
		vars.initialPlayerVehicleGameObjectId = 0

		
		local gameObjectId = GameObject.GetGameObjectId("TppHuey2", "TppHuey2GameObjectLocator" )
		vars.initialPlayerPairGameObjectId = gameObjectId

		
		this.SetTargetDistanceCheck()
	
	elseif restoreSeq == "Seq_Game_EscapeSahelan" then
		
		Fox.Log("*** s10070_sequence:ReSet HeliEscape BGM ***")
		TppMusicManager.PostJingleEvent( "MissionEnd", "Stop_bgm_mission_clear_heli" )
		this.UnlockedHuey()					

		
		vars.initialPlayerVehicleGameObjectId = 0

		local gameObjectId = GameObject.GetGameObjectId("TppHuey2", "TppHuey2GameObjectLocator" )
		vars.initialPlayerPairGameObjectId = gameObjectId

		
		this.SetTargetDistanceCheck()

	end
	
	
	TppCollection.RepopCountOperation( "SetAt", "col_POSTER_GRAVURE_V0001", 0 )

end




this.OnEndMissionPrepareSequence = function ()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnEndMissionPrepareSequence ***")

	local restoreSeq		= TppSequence.GetMissionStartSequenceName()	

	
	Gimmick.EnableAlarmLampAll(false)

	
	if restoreSeq == "Seq_Demo_SahelanTest" then
		

	
	elseif restoreSeq == "Seq_Demo_MissionTitle" or restoreSeq == "Seq_Game_GoToSovietBase" then
		
		Gimmick.SetAiPodLocation ( 0 )
		

		
		this.SwitchSovietBaseHungerGimmick_RescueHuey()

		
		Gimmick.StopAiPod ( true )

	
	elseif restoreSeq == "Seq_Game_EscapeSovietBase" then
		
		Gimmick.SetAiPodLocation ( 0 )
		

		
		this.SwitchSovietBaseHungerGimmick_RescueHuey()

		
		Gimmick.StopAiPod ( true )

	
	elseif restoreSeq == "Seq_Game_EscapeSahelan" then
		
		this.LockAutoDoor_sovietBase()

		
		local towerPath = "afgh_sttw002_vrtn004_gim_i0000|TppSharedGimmick_afgh_sttw002_vrtn004"
		local cablePath = "cypr_cabl002_vrtn005_gim_i0000|TppSharedGimmick_cypr_cabl002_vrtn005"
		local  asset_117_123 = "/Assets/tpp/level/location/afgh/block_small/117/117_123/afgh_117_123_asset.fox2"
		local  asset_119_123 = "/Assets/tpp/level/location/afgh/block_small/119/119_123/afgh_119_123_asset.fox2"
		local  asset_120_123 = "/Assets/tpp/level/location/afgh/block_small/120/120_123/afgh_120_123_asset.fox2"

		Gimmick.ResetSharedGimmickData(towerPath,asset_117_123)
		Gimmick.ResetSharedGimmickData(cablePath,asset_117_123)
		Gimmick.ResetSharedGimmickData(towerPath,asset_119_123)
		Gimmick.ResetSharedGimmickData(cablePath,asset_119_123)
		Gimmick.ResetSharedGimmickData(towerPath,asset_120_123)
		Gimmick.ResetSharedGimmickData(cablePath,asset_120_123)

	end

end



function this.RegisterMissionSystemCallback()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " RegisterMissionSystemCallback ***")

	
	local systemCallbackTable ={

		OnEstablishMissionClear = this.OnEstablishMissionClear,	
		OnEndMissionCredit = this.OnEndMissionCredit,			
		OnEndMissionReward = this.OnEndMissionReward,			
		OnRecovered = this.OnRecovered,							
		OnGameOver = this.OnGameOver,							
		OnEndDeliveryWarp = this.OnEndDeliveryWarp,				
		OnSetMissionFinalScore = this.OnSetMissionFinalScore,	
		nil
	}
	
	TppMission.RegisterMissionSystemCallback(systemCallbackTable)

end


function this.OnEstablishMissionClear()

	Fox.Log("##### s10070_sequence::OnEstablishMissionClear #####")
	
	TppSequence.SetNextSequence( "Seq_Demo_SahelanFalling", { isExecMissionClear = true } )

end


function this.OnEndMissionCredit()

	Fox.Log("TppMission.Reload OnEndFadeOut")	

	
	TppSequence.ReserveNextSequence( "Seq_Demo_MotherBase", { isExecMissionClear = true })

	
	TppScriptBlock.LoadDemoBlock(
		"Demo_MotherBase",
		false 
	)

	
	TppMission.DisablePauseForShowResult()

	TppMission.Reload{
		isNoFade = true,								
		missionPackLabelName = "beforeMotherBaseDemo",
		locationCode = TppDefine.LOCATION_ID.MTBS, 		
		layoutCode	= TppDefine.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
		clusterId	= TppDefine.CLUSTER_DEFINE.Command,
	}
end


function this.OnEndMissionReward()
	TppMission.MissionFinalize()
end


function this.OnGameOver()
	
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
		
		TppPlayer.SetTargetDeadCamera{ gameObjectName = TARGET_HUEY }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		TppUiCommand.SetGameOverType('TimeParadox')
		return true
	
	elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.HELICOPTER_DESTROYED ) then
		
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end

end


function this.ReserveMissionClear()

	TppStory.DisableMissionNewOpenFlag( 10070 )		

	
	if TppStory.IsMissionCleard( 10070 ) then
		TppMission.ReserveMissionClear{
			missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
			nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI,	
		}
	else
		TppMission.ReserveMissionClear{
			missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
			nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE,	
		}
	end
end

function this.OnRecovered(gameObjectId)
	local allRecovered = true
	for index, targetName in ipairs(this.MISSION_TASK_TARGET) do
		if TppEnemy.IsRecovered(targetName) == false then
			allRecovered = false
		end
	end
	if allRecovered then
		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_03" },
		}
		
		TppResult.AcquireSpecialBonus{
			first = { isComplete = true },
		}
	end
end


function this.OnEndDeliveryWarp( stationUniqueId )

	Fox.Log("##### s10070_sequence::OnEndDeliveryWarp #####")
	local currentSequence = TppSequence.GetCurrentSequenceName()

	
	if stationUniqueId == TppPlayer.GetStationUniqueId( "sovietBase" ) then
		Fox.Log("Now soviet base!!")
		if currentSequence == "Seq_Game_GoToSovietBase" then
			
			if svars.isArrivedSovietBase == false then
				svars.isArrivedSovietBase = true
				
				if svars.isWalkerLrrpStart == false then
					s10070_enemy02.WalkerGearLRRPStart()
					svars.isWalkerLrrpStart = true
				end
				
				if svars.isSovietBaseLrrpStart == false then
					s10070_enemy02.sovietBaseLRRPStart()
					svars.isSovietBaseLrrpStart = true
				end
				
				if svars.issovietEnemyHeliMove == false then
					s10070_enemy02.sovietEnemyHeliMove()
					svars.issovietEnemyHeliMove = true
				end
				
				if mvars.WalkerRouteA ~= 3 and mvars.WalkerRouteB ~= 3 then
					s10070_enemy02.UpdateWalkerRoute_Seq3()
					mvars.WalkerRouteA = 3
					mvars.WalkerRouteB = 3
				end
				
				if svars.isFoundHueyPos == false then
					TppMission.UpdateObjective{
						objectives = { "detail_area_sovietBase", },
						radio = {
							radioGroups = "s0070_rtrg0060",
							radioOptions = { delayTime = "mid", playDebug = false },
						},
					}
					
					if svars.isDummyFlag02 == false then
						
						TppRadio.SetOptionalRadio("Set_s0070_oprg0050")	
					end
				end
			end
		end
	end
end




function this.OnSetMissionFinalScore( missionClearType )
	
	if svars.isHuey_Damaged == false then
		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_04", },
		}
		
		TppResult.AcquireSpecialBonus{
			second = { isComplete = true },
		}
	end
end




function this.OnTerminate()
	
	TppGameStatus.Reset("s10070_sequence.lua", "S_DISABLE_PLAYER_DAMAGE")
end





function this.Messages()
	return
	StrCode32Table {
		Player = {
			{	
				msg = "OnPickUpCollection",
				func = function( playerGameObjectId, collectionUniqueId, collectionTypeId )
					if collectionUniqueId == TppCollection.GetUniqueIdByLocatorName( "col_POSTER_GRAVURE_V0001" ) then
						
						TppMission.UpdateObjective{
							objectives = { "clear_missionTask_05" },
						}
					end
					if collectionUniqueId == TppCollection.GetUniqueIdByLocatorName( "col_develop_Semiauto_SR_s10070_0000" ) then
						
						TppMission.UpdateObjective{
							objectives = { "clear_missionTask_06" },
						}
					end
				end
			},
			{
				
				msg = "PressedFultonNgIcon",
				func = function(playerId,gameObjectId)
					local hueyId = GameObject.GetGameObjectId("TppHuey2", TARGET_HUEY )
					if gameObjectId == hueyId then
						Fox.Log("**** PressedFultonNgIcon:Huey ****")
						TppRadio.Play("s0070_rtrg3000", { delayTime = "short" } )		
					end
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
		Marker = {
			{
				msg = "ChangeToEnable",
				func = function ( instanceName, makerType, s_gameObjectId, identificationCode )
					
					if identificationCode == Fox.StrCode32("Player") then
						Fox.Log("### Marker ChangeToEnable  ###"..instanceName )
						local strWkr00 = StrCode32("wkr_s10070_0000")
						local strWkr01 = StrCode32("wkr_s10070_0001")
						local strWkr02 = StrCode32("wkr_s10070_0002")
						if instanceName == strWkr00 or instanceName == strWkr01 or instanceName == strWkr02 then	
							TppRadio.Play("s0070_rtrg0080")
						end
					end
				end
			},
			nil
		},
		GameObject = {
			
			{
				msg = "Dead", 
				func = function( arg0, arg1 )
					local gameObjectId = GameObject.GetGameObjectId("TppHuey2", TARGET_HUEY )
					
					if arg0 == gameObjectId then
						Fox.Log("!!!!! s10070_sequence:TARGET_HUEY Dead !!!!!")
						if Tpp.IsPlayer( arg1 ) then
							TppRadio.Play("f1000_rtrg0110")
						end
						TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )	
					end
				end,
			},
			
			{
				msg = "Damage", 
				func = function( arg0, arg1 )
					local gameObjectId = GameObject.GetGameObjectId("TppHuey2", TARGET_HUEY )
					
					if arg0 == gameObjectId then
						Fox.Log("!!!!! s10070_sequence:TARGET_HUEY Damaged !!!!!")
						svars.isHuey_Damaged = true		
						if this.IsHueyStateCarried() == false and mvars.isPlaying_Huey11 == false then
							local currentSequence = TppSequence.GetCurrentSequenceName()
							if currentSequence == "Seq_Game_EscapeSovietBase" then
								s10070_radio.CallMonologueHuey11()		
							end
							mvars.isPlaying_Huey11 = true
							
							GkEventTimerManager.Start( "DamageVoiceCheckTimer", TIMER_HUEY_DAMAGE )
							mvars.isPlayedMonologue_Huey11 = true
						end
					end
				end,
			},
			
			{
				msg = "Carried", 
				func = function( arg0, arg1 )
					local gameObjectId = GameObject.GetGameObjectId("TppHuey2", TARGET_HUEY )
					
					if arg0 == gameObjectId then
						if arg1 == 0 then
							Fox.Log("!!!!! s10070_sequence:TARGET_HUEY Carried:START !!!!!")
							
							GkEventTimerManager.Stop( "MonologueCheckTimer" )	
							GkEventTimerManager.Start( "MonologueCheckTimer", TIMER_HUEY_CARRIED_MONOLOGUE )
							
							if GkEventTimerManager.IsTimerActive( "HueyFearTimer" ) then
								GkEventTimerManager.Stop( "HueyFearTimer" )
							end
						elseif arg1 == 1 then
							Fox.Log("!!!!! s10070_sequence:TARGET_HUEY Carried:END !!!!!")
							
							if GkEventTimerManager.IsTimerActive( "MonologueCheckTimer" ) then
								GkEventTimerManager.Stop( "MonologueCheckTimer" )
							end

						else
							Fox.Log("!!!!! s10070_sequence:TARGET_HUEY Carried:????? !!!!!")
							
						end

					end
				end,
			},
			{
			
				msg =	"PlayerGetAway",
				func = function()
					Fox.Log( "**** s10070_sequence.Messages::PlayerGetAway ****" )
					this.HueyLeaveAloneCheck()		
				end
			},
			{
			
				msg = "LostControl",
				func = function ( gameObjectId, state, Attacker )
					
					if gameObjectId == GameObject.GetGameObjectId( "SupportHeli" ) then
						if state == StrCode32("Start")	then
							Fox.Log("SUPPORT HELI LOST CONTROL START !!")
						elseif state == StrCode32("End")	then
							if svars.isRideOnHeli_Huey == true	then	
								TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )	
							else
								if Attacker == 0 then		
									s10070_radio.SupprtHeliDeadByPC()
								else
									s10070_radio.SupprtHeliDeadByEnemy()
								end
							end
						end
					else
						Fox.Log("No Setting HeliID ... ")
					end
				end
			},
			{
			
				msg =	"ChangePhase",
				func = function( cpId, phase )
					if cpId == GameObject.GetGameObjectId("afgh_powerPlant_cp") then
						Fox.Log( "**** s10070_sequence.ChangePhase::powerPlant ****"..phase )
						if phase == TppGameObject.PHASE_ALERT or phase == TppGameObject.PHASE_EVASION then
							Gimmick.EnableAlarmLampAll(true)	
						else
							Gimmick.EnableAlarmLampAll(false)
						end
					end
				end
			},
		},
		Timer = {
			
			{
				msg = "Finish",	sender = "MonologueCheckTimer",
				func = function ()
					this.HueyCommonMonologueCheck()		
				end
			},
			
			{
				msg = "Finish",	sender = "HueyFearTimer",
				func = function ()
					if this.IsHueyStateCarried() == false then
						s10070_radio.CallMonologueHuey07()	
						mvars.isPlayedMonologue_Huey07 = true
						
						GkEventTimerManager.Start( "HueyFearTimer", TIMER_HUEY_FEAR )
					end
				end
			},
			
			{
				msg = "Finish",	sender = "DamageVoiceCheckTimer",
				func = function ()
					mvars.isPlaying_Huey11 = false
				end
			},
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
		Block = {
			{
				msg = "OnScriptBlockStateTransition",
				func = function (blockName,blockState)
					Fox.Log("________s10070_sequence.OnScriptBlockStateTransition________")
					Fox.Log("blockName is " .. tostring(blockName) .. "        / blockState is " .. tostring(blockState))
					
					if blockName == Fox.StrCode32( "npc_block" ) and blockState == ScriptBlock.TRANSITION_ACTIVATED then
						if TppScriptBlock.GetCurrentPackListName( "npc_block" ) == "Huey" then
								Fox.Log("*** npc_block Load::Huey ***")
						elseif TppScriptBlock.GetCurrentPackListName( "npc_block" ) == "powerPlantHunger" then
							Fox.Log("*** npc_block Load::powerPlantHunger ***")
							
							this.ClosepowerPlantHangereDoor()
						else
							Fox.Log("*** npc_block Load:: Others ***")		
						end
					end

				end,
				option = { isExecMissionPrepare = true }
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

this.s10070_baseOnActiveTable = {
	afgh_powerPlant = function()
		Fox.Log("s10070_baseOnActiveTable : afgh_powerPlant")
		local currentSequence = TppSequence.GetCurrentSequenceName()
		if currentSequence == "Seq_Game_GoToSovietBase" then

		end
	end,
	afgh_sovietBase = function()
		Fox.Log("s10070_baseOnActiveTable : afgh_sovietBase")

		local function currentSeqCheck()
			local currentSequence = TppSequence.GetCurrentSequenceName()
			if currentSequence == "Seq_Game_GoToSovietBase" or
			   currentSequence == "Seq_Demo_ContactHuey" or
			   currentSequence == "Seq_Game_EscapeSovietBase" then
			   		return true
			else
					return false
			end
		end

		local function restoreSeqCheck()
			local restoreSeq = TppSequence.GetMissionStartSequenceName()	
			if restoreSeq == "Seq_Game_GoToSovietBase" or
			   restoreSeq == "Seq_Demo_ContactHuey" or
			   restoreSeq == "Seq_Game_EscapeSovietBase" then
			   		return true
			else
					return false
			end
		end
		
		if currentSeqCheck() or restoreSeqCheck() then
			
			this.SwitchSovietBaseHungerAsset_RescueHuey()
		end
	end,
}







this.SetLimitPlayerAction = function()
	Fox.Log("**** s10070_sequence.SetLimitPlayerAction() ****")

	Player.SetPadMask {
		
		settingName = "beforeDemoPlay",
		
		except = false,
		
		buttons = PlayerPad.ALL,
		
		sticks = PlayerPad.STICK_L,
		
		triggers = PlayerPad.TRIGGER_L,
	}
end


this.CheckPlayerRideSomething = function()
	Fox.Log("**** s10070_sequence.CheckPlayerRideSomething() ****")
	local playerState		= Player.GetGameObjectIdIsRiddenToLocal()
	local notRideSomething	= 65535	

	if ( playerState == notRideSomething ) then
		return false
	else
		return playerState
	end
end



this.CheckPlayerRideType = function()

	
	Fox.Log("**** s10070_sequence.CheckPlayerRideType():BuddyHorse ****")
	local buddyHorseId = GameObject.GetGameObjectIdByIndex( "TppHorse2",0 )
	if buddyHorseId ~= GameObject.NULL_ID then
		local isRideHorse = GameObject.SendCommand( buddyHorseId, { id = "IsRidePlayer" } )
		if isRideHorse then
			
			svars.isPlayerRideBuddy = true		
			svars.isDummyFlag04 = true			
		end
	end

	
	Fox.Log("**** s10070_sequence.CheckPlayerRideType():BuddyWalker ****")
	local buddyWalkerId = GameObject.GetGameObjectIdByIndex( "TppWalkerGear2",0 )
	if buddyWalkerId ~= GameObject.NULL_ID then
		local isRideWalker = GameObject.SendCommand( buddyWalkerId, { id = "IsPlayerRiding" } )
		if isRideWalker then
			
			svars.isPlayerRideBuddy = true		
			svars.isDummyFlag05 = true			
		end
	end

	
	Fox.Log("**** s10070_sequence.CheckPlayerRideType():Vehicle ****")
	local vehicleId = { type="TppVehicle2", index=0 }
	
	if GameObject.SendCommand( vehicleId, { id="IsAlive", } ) then
		local riderIdArray = GameObject.SendCommand( vehicleId, { id="GetRiderId", } )
		local seatCount = #riderIdArray
		for seatIndex,riderId in ipairs( riderIdArray ) do
			if riderId~=GameObject.NULL_ID then
				if seatIndex==1 and riderId == 0 then
					
					svars.isDummyFlag06 = true
					break
				else
					

				end
			end
		end
	end

	
	Fox.Log("**** s10070_sequence.CheckPlayerRideType():Walker ****")
	for k, walkerName in ipairs(this.MISSION_WALKER_LIST) do
		local walkerId = GameObject.GetGameObjectId( "TppCommonWalkerGear2",walkerName )
		if walkerId ~= GameObject.NULL_ID then
			local isRideWalker = GameObject.SendCommand( walkerId, { id = "IsPlayerRiding" } )
			if isRideWalker then
				
				
				if walkerName == "wkr_s10070_sp" then
					svars.numPlayerRideWalker = 3
				elseif walkerName == "wkr_s10070_0000" then
					svars.numPlayerRideWalker = 0
				elseif walkerName == "wkr_s10070_0001" then
					svars.numPlayerRideWalker = 1
				elseif walkerName == "wkr_s10070_0002" then
					svars.numPlayerRideWalker = 2
				else
					Fox.Log("*** WalkerGear not found ***")
				end
				svars.isPlayerRideWalker = true
				break
			end
		end
	end

end


this.CallHorseOnSahelanAttackDemo = function()
	Fox.Log("**** s10070_sequence.CallHorseOnSahelanAttackDemo() ****")

	
	if svars.isDummyFlag04 then
		local buddyHorseId = GameObject.GetGameObjectIdByIndex( "TppHorse2",0 )
		if buddyHorseId ~= GameObject.NULL_ID then
			local command = { id = "SetCallHorse",
								 startPosition = this.HORSE_POS01_ATTACK_DEMO, 
								 goalPosition = this.HORSE_POS02_ATTACK_DEMO 	
							}
			GameObject.SendCommand( buddyHorseId, command )
		end
	end
end


this.CheckDistancePlayerToHeli = function()
	Fox.Log("**** s10070_sequence.CheckDistancePlayerToHeli() ****")

	local heliPos = GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="GetPosition" } ) 
	local SquarePlayerToHeliDistance = TppMath.FindDistance( TppMath.Vector3toTable(heliPos), TppPlayer.GetPosition() )
	local playerToHeliDistance = math.sqrt(SquarePlayerToHeliDistance)	
	return playerToHeliDistance

end




function this.SetUpHueyLife()
	Fox.Log("s10070_sequence.SetUpHueyLife")

	
	local gameObjectId = { type="TppHuey2", index=0 }
	local command = { id = "SetMaxLife", life = TARGET_HUEY_LIFE, stamina = 3000 }
	GameObject.SendCommand( gameObjectId, command )

	this.SetUniqueStaffType()	

end


function this.SetUniqueStaffType()
	Fox.Log("s10070_sequence.SetUniqueStaffType")

	TppEnemy.AssignUniqueStaffType{
		locaterName = TARGET_HUEY,
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.HUEY,
	}
end


function this.SetDamageRateHuey()
	Fox.Log("s10070_sequence.SetDamageRateHuey")
	local gameObjectId = { type="TppHuey2", index=0 }
	local command = { id = "SetEnemyDamageRate", rate=0.3 }
	GameObject.SendCommand( gameObjectId, command )
end

function this.SetDisableDamageHuey( flag )
	Fox.Log("**** s10070_sequence.SetDisableDamageHuey ****")

	local gameObjectId = { type="TppHuey2", index=0 }
	local command = { id = "SetDisableDamage", life = flag, faint = flag, sleep = flag }
	GameObject.SendCommand( gameObjectId, command )
end


function this.SetUpHueyVoice()
	Fox.Log("s10070_sequence.SetUpHueyVoice")

	local gameObjectId = { type="TppHuey2", index=0 }
	local command = { id = "SetVoiceType", voiceType="huey" }
	GameObject.SendCommand( gameObjectId, command )
end


function this.SwitchEnebleHueyOnDemo( flag )
	Fox.Log("***** s10070_sequence.SwitchEnebleHueyOnDemo *****")

	local gameObjectId = { type="TppHuey2", index=0 }
	if gameObjectId then
		GameObject.SendCommand(gameObjectId, { id="SetIgnoreDisableNpc", enable=flag })
	end
end


function this.SetUpHueyMovingNoticeTrap()
	Fox.Log("s10070_sequence.SetUpHueyMovingNoticeTrap")

	local gameObjectId = { type="TppHuey2", index=0 }
	local command = { id = "SetMovingNoticeTrap", enable = true }
	GameObject.SendCommand( gameObjectId, command )
end


function this.SetTargetDistanceCheck()
	Fox.Log( "s10070_sequence.SetTargetDistanceCheck" )

	local gameObjectId = { type="TppHuey2", index=0 }
	local command = { id = "SetPlayerDistanceCheck", enabled = true, near = RANGE_TARGET_CHECK_NEAR, far = RANGE_TARGET_CHECK_FAR }
	GameObject.SendCommand( gameObjectId, command )
end


function this.IsHueyStateCarried()
	Fox.Log( "s10070_sequence.IsHueyStateCarried" )

	local gameObjectId = { type="TppHuey2", index=0 }
	local command = { id = "GetStatus", }
	local status =	GameObject.SendCommand( gameObjectId, command )
	if status == TppGameObject.NPC_STATE_CARRIED then
		return true
	else
		return false
	end
end


function this.GetHueyRideState()
	Fox.Log( "**** s10070_sequence.GetHueyRideState ****" )

	local gameObjectId = { type="TppHuey2", index=0 }
	local command = { id = "GetRideVehicleState", }
	local type, vehicleId, seatIndex = GameObject.SendCommand( gameObjectId, command )

	if type then
		svars.typeHueyRideVehicle = type
		svars.idHueyRideVehicle = vehicleId
		svars.seatIndexHueyRideVehicle = seatIndex
	end

end


function this.SetHueyRideState()
	Fox.Log( "**** s10070_sequence.SetHueyRideState ****" )

	if svars.typeHueyRideVehicle and svars.typeHueyRideVehicle ~= 0 then
		local gameObjectId = { type="TppHuey2", index=0 }
		GameObject.SendCommand( gameObjectId, {
				id = "RideVehicle",
				vehicleId = svars.idHueyRideVehicle, type = svars.typeHueyRideVehicle,	seatIndex = svars.seatIndexHueyRideVehicle,
				fastRide = true,
		} )
	end
end

function this.HueyCommonMonologueCheck()
	Fox.Log( "s10070_sequence.HueyCommonMonologueCheck" )
	local currentSequence = TppSequence.GetCurrentSequenceName()
	

	
	if currentSequence == "Seq_Game_EscapeSovietBase" then
		
		if mvars.isPlayedMonologue_Huey04 == true and this.IsHueyStateCarried() then
			
			GkEventTimerManager.Start( "MonologueCheckTimer", TIMER_HUEY_CARRIED_MONOLOGUE )
			
			if TppRadio.IsRadioPlayable() then
				
				if svars.isRideMetalDemoPlay == false and mvars.isPlayedMonologue_Huey02 == false then
					
					s10070_radio.CallMonologueHuey02()		
					mvars.isPlayedMonologue_Huey02 = true
				elseif mvars.isPlayedMonologue_Huey08 == false then
					s10070_radio.CallMonologueHuey08()		
					mvars.isPlayedMonologue_Huey08 = true
				elseif mvars.isPlayedMonologue_Huey09 == false then
					s10070_radio.CallMonologueHuey09()		
					mvars.isPlayedMonologue_Huey09 = true
				else
					
					Fox.Log( "!!! HueyCommonMonologue All Done !!!" )
					GkEventTimerManager.Stop( "MonologueCheckTimer" )
				end
			end

		elseif this.IsHueyStateCarried() then
			
			GkEventTimerManager.Start( "MonologueCheckTimer", TIMER_HUEY_CARRIED_MONOLOGUE )
		else
			
			Fox.Log( "s10070_sequence.HueyCommonMonologueCheck::NotPlay" )
		end

	elseif currentSequence == "Seq_Game_EscapeSahelan" then
		
		local phase = this.GetSahelanPhase()

		if phase == TppSahelan2.SAHELAN2_PHASE_SNEAK and mvars.isPlayedMonologue_Huey10 == false then
		
			mvars.isPlayedMonologue_Huey10 = true
		else
			
			GkEventTimerManager.Start( "MonologueCheckTimer", TIMER_HUEY_CARRIED_MONOLOGUE )
		end

	else

	end
end


function this.HueyLeaveAloneCheck()
	Fox.Log( "s10070_sequence.HueyLeaveAloneCheck" )

	
	if GkEventTimerManager.IsTimerActive( "HueyFearTimer" ) then
		
	elseif this.IsHueyStateCarried() == false then
		
		TppRadio.Play("s0070_rtrg0160")

		
		s10070_radio.CallMonologueHuey06()	
		mvars.isPlayedMonologue_Huey06 = true
		GkEventTimerManager.Start( "HueyFearTimer", TIMER_HUEY_FEAR )
	end
end


function this.SetUpSPwalkerGear( gameObjectId )
	Fox.Log("s10070_sequence.SetUpSPwalkerGear")
	local currentSequence = TppSequence.GetCurrentSequenceName()

	if gameObjectId == nil then
		return
	end

	local command1 = { id = "SetExtraPartsForSpecialEnemy", enabled = true }
	local command2 = { id = "SetColoringType", type = SP_WALKERGEAR_COLOR }
	GameObject.SendCommand( gameObjectId, command1 )
	GameObject.SendCommand( gameObjectId, command2 )

	
	if currentSequence == "Seq_Demo_SahelanAttacks" or currentSequence == "Seq_Game_EscapeSahelan" then
		local command3 = { id = "SetMaxLife", life = SP_WALKERGEAR_LIFE_SAHELAN }		
		GameObject.SendCommand( gameObjectId, command3 )
	else
		local command3 = { id = "SetMaxLife", life = SP_WALKERGEAR_LIFE }		
		GameObject.SendCommand( gameObjectId, command3 )
	end

end


function this.UnlockedHuey()
	Fox.Log("*** s10070_sequence.UnlockedHuey ***")
	local gameObjectId = { type="TppHuey2", index=0 }
	if gameObjectId == nil then
		return
	end
	local command = {
		id = "SetHostage2Flag",
		
		flag = "unlocked",	
		on = true,
	}
	GameObject.SendCommand( gameObjectId, command )

end


function this.GotHueyHungerPos()
	Fox.Log("*** s10070_sequence.GotHueyHungerPos ***")

	if svars.isFoundHueyPos == false then
		svars.isFoundHueyPos = true

		
		TppMission.UpdateObjective{
			objectives = { "detail_area_huey",},
		}

		TppInterrogation.ResetFlagHigh( GameObject.GetGameObjectId("afgh_sovietBase_cp"))

		
		TppRadio.SetOptionalRadio("Set_s0070_oprg0040")	

		TppRadioCommand.SetEnableEspionageRadioTarget{ name= {"EspRadioLocator_hunger"}, enable = true }	
		TppRadioCommand.SetEnableEspionageRadioTarget{ name= {"EspRadioLocator_sovistBase"}, enable = false }	
	end

end


function this.GetWalkerGearName()
	Fox.Log("s10070_sequence.GetWalkerGearName")

	if svars.numPlayerRideWalker == 3 then
		return "wkr_s10070_sp"
	elseif svars.numPlayerRideWalker == 0 then
		return "wkr_s10070_0000"
	elseif svars.numPlayerRideWalker == 1 then
		return "wkr_s10070_0001"
	elseif svars.numPlayerRideWalker == 2 then
		return "wkr_s10070_0002"
	else
		return nil
	end

end



function this.UpdateMissionZone()

	Fox.Log("*** s10070_sequence.UpdateMissionZone ***")
	local currentSequence = TppSequence.GetCurrentSequenceName()

	if currentSequence == "Seq_Game_EscapeSahelan" or currentSequence == "Seq_Game_EscapeSovietBase" then
		TppTrap.Disable( "trig_innerZone_01" )
		TppTrap.Disable( "trig_outerZone_01" )
		TppTrap.Enable( "trig_innerZone_02" )
		TppTrap.Enable( "trig_outerZone_02" )
		TppUiCommand.HideInnerZone() 
		TppUiCommand.ShowInnerZone( "trig_innerZone_02" )
	else
		TppTrap.Disable( "trig_innerZone_02" )
		TppTrap.Disable( "trig_outerZone_02" )
		TppTrap.Enable( "trig_innerZone_01" )
		TppTrap.Enable( "trig_outerZone_01" )
		TppUiCommand.HideInnerZone() 
		TppUiCommand.ShowInnerZone( "trig_innerZone_01" )
	end
end



function this.SetUpCommandPostSirenType( cpName, sirenType, sePos )
	Fox.Log("***** s10070_sequence.SetUpCommandPostSirenType *****")

	local gameObjectId = GameObject.GetGameObjectId( "TppCommandPost2", cpName )
	local command = { id = "SetCpSirenType", type = sirenType, pos = sePos }
	GameObject.SendCommand( gameObjectId, command )

end

function this.SetForceSiren( cpName, flag )
	Fox.Log("***** s10070_sequence.SetForceSiren *****")

	local gameObjectId = GameObject.GetGameObjectId( "TppCommandPost2", cpName )
	local command1 = { id = "SetCpForceSiren", enable=flag }
	local command2 = { id = "SetKeepCaution", enable=flag }
	GameObject.SendCommand( gameObjectId, command1 )
	GameObject.SendCommand( gameObjectId, command2 )

end


function this.SetIgnoreLookHeli( cpName )
	Fox.Log("***** s10070_sequence.SetIgnoreLookHeli *****")

	local cpId = GameObject.GetGameObjectId( "TppCommandPost2", cpName )
	GameObject.SendCommand( cpId, { id = "SetIgnoreLookHeli" } )

	this.LandingZoneWaitHeight( HELI_WAIT_HIGHT_ESCAPE01 )
end

function this.RemoveIgnoreLookHeli( cpName )
	Fox.Log("***** s10070_sequence.RemoveIgnoreLookHeli *****")

	local cpId = GameObject.GetGameObjectId( "TppCommandPost2", cpName )
	GameObject.SendCommand( cpId, { id = "RemoveIgnoreLookHeli" } )

	this.LandingZoneWaitHeight( HELI_WAIT_HIGHT_DEFAULT )
end



function this.GetSahelanPhase()
	Fox.Log("*** s10070_sequence.GetSahelanPhase ***")
	local gameObjectId = { type="TppSahelan2", index=0 }
	local command = { id = "GetPhase" }
	return GameObject.SendCommand( gameObjectId, command )
end


function this.CallSupportHeliToRV( rvName )

	Fox.Log("s10070_sequence.CallSupportHeliToRV::"..rvName)

	if rvName then
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name = rvName })
		GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })					
		s10070_sequence.Switch_DescentToLandingZone(false)		

		
		GameObject.SendCommand(gameObjectId, { id="SetCombatEnabled", enabled=false }) 
	end
end

function this.WithdrawalSupportHeli()

	Fox.Log("***** s10070_sequence.WithdrawalSupportHeli *****")

	this.SwitchAntiSahelanMode( false )	

	
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	
	if svars.isRideOnHeli_Huey == false then
		GameObject.SendCommand(gameObjectId, { id="PullOut" })	
	end
	s10070_sequence.Switch_DescentToLandingZone(false)		

	
	s10070_enemy03.ResetRVPosToSahelan()

	mvars.isHeliLZTry = false	
	mvars.isCantLandingRadio = false

end


function this.ReturnSupportHeliToRV()

	Fox.Log("***** s10070_sequence.ReturnSupportHeliToRV *****")

	
	

	local currentLZName = this.GetCurrentLZName()
	if currentLZName == StrCode32("lzs_sovietBase_S_0000") then
		this.CallSupportHeliToRV( RV01 )
	elseif currentLZName == StrCode32("lzs_sovietSouth_W_0000") then
		this.CallSupportHeliToRV( RV02 )
	else
		Fox.Log( "ReturnSupportHeliToRV::Error LZ Name..." )
	end

end



function this.GetCurrentLZName()

	
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	local currentLZName = GameObject.SendCommand(gameObjectId, { id="GetCurrentLandingZoneName" })	
	Fox.Log("currentLZName : "..currentLZName )
	return currentLZName

end


function this.CheckHeliStatusOnLZ()

	local aiState = GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="GetAiState" } )
	if		aiState == Fox.StrCode32("WaitPoint") 			

		or	aiState == Fox.StrCode32("Descent") 			
		or	aiState == Fox.StrCode32("Landing") then		
			Fox.Log("*** s10070_sequence:CheckHeliStatusOnLZ::true ***")
			
			return true
	else
			Fox.Log("*** s10070_sequence:CheckHeliStatusOnLZ::false ***")
			return false
	end
end


function this.CheckHeliStatusOnExit()

	local aiState = GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="GetAiState" } )
	if		aiState == Fox.StrCode32("PullOut") 		
		or	aiState == Fox.StrCode32("") then			
			Fox.Log("*** s10070_sequence:CheckHeliStatusOnExit::true ***")
			
			return true
	else
			Fox.Log("*** s10070_sequence:CheckHeliStatusOnExit::false ***")
			
			return false
	end
end


function this.CheckHeliStatusJustOnLZ()

	local aiState = GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="GetAiState" } )
	if		aiState == Fox.StrCode32("Landing") or aiState == Fox.StrCode32("Descent") then	
			Fox.Log("*** s10070_sequence:CheckHeliStatusJustOnLZ::true ***")
			return true
	else
			Fox.Log("*** s10070_sequence:CheckHeliStatusJustOnLZ::false ***")
			return false
	end
end


function this.CheckHeliLanding()
	Fox.Log("!!! s10070_mission CheckHeliLanding !!!")
	
	local phase = this.GetSahelanPhase()
	local isHueyHere = TppEnemy.CheckAllTargetClear()
	local aiState = GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="GetAiState" } )
	local distance = s10070_enemy03.GetDistanceToLandingZone()
	local isInSight = s10070_enemy03.CheckPlayerInSight()

	
	local aiState = GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="GetAiState" } )
	if aiState == Fox.StrCode32("Descent") or aiState == Fox.StrCode32("Landing") then
		return
	end

	
	local isDisableLanding = false
	
	if phase == TppSahelan2.SAHELAN2_PHASE_ALERT then
		isDisableLanding = true
	end
	
	if phase == TppSahelan2.SAHELAN2_PHASE_CAUTION and distance < RANGE_SAHELAN_TO_LZ_CHECK_CAUTION and isInSight then
		isDisableLanding = true
	end
	
	if distance < RANGE_SAHELAN_TO_LZ_CHECK_SNEAK then
		isDisableLanding = true
	end
	
	if mvars.isSahelanStopped then
		isDisableLanding = false
	end

	if isDisableLanding then
		s10070_sequence.Switch_DescentToLandingZone(false)		
		
		if this.CheckHeliStatusOnLZ() and mvars.isHeliLZTry == false and mvars.isCantLandingRadio == false then
			s10070_radio.RV_Disabled()
			mvars.isCantLandingRadio = true
		end
		
		if mvars.isPlayerOnLZ then
			GkEventTimerManager.Stop( "Timer_LandingCheck" )
			GkEventTimerManager.Start( "Timer_LandingCheck", TIMER_LANDING_CHECK )
		end
	else
		
		if isHueyHere or (svars.isRideOnHeli_Huey == true ) then
			
			s10070_enemy03.SetRVPosToSahelan()
			
			s10070_sequence.Switch_DescentToLandingZone(true)	
			
			if aiState == Fox.StrCode32("WaitPoint") and mvars.isHeliLZTry == false then
				s10070_radio.RV_Enabled()
				mvars.isHeliLZTry = true	
			end
		else
			
			TppRadio.Play("s0070_rtrg0160", { playDebug = false } )
		end
	end


end


function this.LandingZoneWaitHeight( heightNum )
	Fox.Log("***** s10070_sequence.LandingZoneWaitHeight *****"..heightNum)

	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	GameObject.SendCommand( gameObjectId, { id="SetLandingZoneWaitHeightTop", height=heightNum } ) 
end


function this.Switch_DescentToLandingZone( flag )
	Fox.Log("***** s10070_sequence.Switch_DescentToLandingZone *****")
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")

	if flag then
		GameObject.SendCommand(gameObjectId, { id="EnableDescentToLandingZone" })		
		GameObject.SendCommand(gameObjectId, { id="EnablePullOut" })					
	else
		GameObject.SendCommand(gameObjectId, { id="DisableDescentToLandingZone" })		
		GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })					
	end
end


function this.SwitchSahelanBattleLZ( flag )

	if flag then
		Fox.Log("### s10070_sequence.SwitchSahelanBattleLZ::Enable ###")
		TppHelicopter.SetEnableLandingZone{ landingZoneName = RV01 }
		TppHelicopter.SetEnableLandingZone{ landingZoneName = RV02 }
	else
		Fox.Log("### s10070_sequence.SwitchSahelanBattleLZ::Disable ###")
		TppHelicopter.SetDisableLandingZone{ landingZoneName = RV01 }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = RV02 }
	end

end


function this.SetLandingZnoeDoor()
	Fox.Log("***** s10070_sequence.SetLandingZnoeDoort *****")

	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	GameObject.SendCommand( gameObjectId, { id="SetLandingZnoeDoorFlag", name=RV01, leftDoor="Open", rightDoor="Close" } )
	GameObject.SendCommand( gameObjectId, { id="SetLandingZnoeDoorFlag", name=RV02, leftDoor="Open", rightDoor="Close" } )

end


function this.SwitchEnebleGameHeliOnDemo( flag )

	Fox.Log("***** s10070_sequence.SwitchEnebleGameHeliOnDemo *****")

	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	if gameObjectId then
		GameObject.SendCommand(gameObjectId, { id="SetIgnoreDisableNpc", enabled=flag })
	end

end


function this.SwitchAntiSahelanMode( flag )













end


function this.SetUpEnableNpcOnSahelanAttackDemo()
	Fox.Log("***** s10070_sequence.SetUpEnableNpcOnSahelanAttackDemo *****")

	
	this.SwitchEnebleHueyOnDemo( true )

	
	if svars.isPlayerRideVehicle then

		
		if svars.isPlayerRideBuddy then
			TppBuddyService.SetIgnoreDisableNpc( true )
		end

		
		if svars.isDummyFlag06 then
			local vehicleId = { type="TppVehicle2", index=0 }
			GameObject.SendCommand( vehicleId, { id="SetIgnoreDisableNpc", enable=true })
		end

		
		if svars.isPlayerRideWalker then
			local walkerName = this.GetWalkerGearName()
			if walkerName ~= nil then
				local walkerId = GameObject.GetGameObjectId( "TppCommonWalkerGear2",walkerName )
				GameObject.SendCommand( walkerId, { id="SetIgnoreDisableNpc", enabled=true })
			end
		end
	end

end


function this.SetUpPositionNpcOnSahelanAttackDemo()
	Fox.Log("***** s10070_sequence.SetUpPositionNpcOnSahelanAttackDemo *****")
	
	
	if svars.isPlayerRideVehicle then













		
		if svars.isDummyFlag05 then
			local gameObjectId = GameObject.GetGameObjectIdByIndex( "TppWalkerGear2",0 )
			if gameObjectId ~= GameObject.NULL_ID then
				local command = { id = "SetPosition", pos=this.WALKER_POS_ATTACK_DEMO, rotY=270 }
				GameObject.SendCommand( gameObjectId, command )
			end
		end

		
		if svars.isDummyFlag06 then
			local vehicleId = { type = "TppVehicle2", index=0 }
			if vehicleId ~= GameObject.NULL_ID then
				
				local type = GameObject.SendCommand( vehicleId, { id="GetVehicleType", } )
				
				if type==Vehicle.type.WESTERN_LIGHT_VEHICLE or type==Vehicle.type.EASTERN_LIGHT_VEHICLE then

					GameObject.SendCommand( vehicleId, { id="SetPosition", position=this.VEHICLE_POS_ATTACK_DEMO, rotY=245, } )

				elseif type==Vehicle.type.WESTERN_TRUCK or type==Vehicle.type.EASTERN_TRUCK then

					GameObject.SendCommand( vehicleId, { id="SetPosition", position=this.TRUCK_POS_ATTACK_DEMO, rotY=245, } )

				else
					
					GameObject.SendCommand( vehicleId, { id="SetPosition", position=this.TRUCK_POS_ATTACK_DEMO, rotY=245, } )

				end
			end
		end

		
		if svars.isPlayerRideWalker then
			local walkerName = this.GetWalkerGearName()
			if walkerName ~= nil then
				local walkerId = GameObject.GetGameObjectId( "TppCommonWalkerGear2",walkerName )
				if walkerId ~= GameObject.NULL_ID then
					local command = { id = "SetPosition", pos=this.WALKER_POS_ATTACK_DEMO, rotY=270 }
					GameObject.SendCommand( walkerId, command )
				end
			end
		end
	end

end



function this.CheckNpcScriptBlockLoad()

	
	if TppPackList.IsMissionPackLabel( "afterSahelanTestDemo" ) then
		
		if svars.isDummyFlag07 == true then
			TppScriptBlock.Load( "npc_block", "Huey", true )
		else
			TppScriptBlock.Load( "npc_block", "powerPlantHunger", true )
		end
	end
end


function this.CheckBeforeContactHueyDemo()

	
	if TppScriptBlock.GetCurrentPackListName( "npc_block" ) == "Huey" and
	   TppScriptBlock.GetCurrentPackListName( "demo_block" ) == "Demo_ContactHuey" then
		TppSequence.SetNextSequence("Seq_Demo_ContactHuey")		
		return
	end

	if TppScriptBlock.GetCurrentPackListName( "npc_block" ) ~= "Huey" then
	
		TppScriptBlock.Load( "npc_block", "Huey", true )
	end
	if TppScriptBlock.GetCurrentPackListName( "demo_block" ) ~= "Demo_ContactHuey" then
	
		TppScriptBlock.LoadDemoBlock("Demo_ContactHuey")	
	end
end



function this.AddTrapSettingForRideMetalDemo( params )
	local trapName = params.trapName
	local direction = params.direction or 0
	local directionRange = params.directionRange or 30
	local metalName = params.metalName

	if not Tpp.IsTypeString(trapName) then
		Fox.Error("Invalid trap name. trapName = " .. tostring(trapName) )
	end

	Fox.Log("s10070_sequence.AddTrapSettingForRideMetalDemo. trapName = " .. tostring(trapName) .. ", direction = " .. tostring(direction) .. ", directionRange = " .. tostring(directionRange) )

	mvars.rideMetal_TrapInfo = mvars.rideMetal_TrapInfo or {}

	if metalName then
		mvars.rideMetal_TrapInfo[metalName] = { trapName = trapName }
	else
		Fox.Error("s10070_sequence.AddTrapSettingForRideMetalDemo: Must set metal name.")
	end

	Player.AddTrapDetailCondition {
		trapName = trapName,
		condition = PlayerTrap.FINE,
		action = ( PlayerTrap.NORMAL + PlayerTrap.CARRY ),
		stance = (PlayerTrap.STAND + PlayerTrap.SQUAT ),
		direction = direction,
		directionRange = directionRange,
	}
end

function this.ShowIconForRideMetalDemo( metalName, doneCheckFlag )

	if not Tpp.IsTypeString(metalName) then
		Fox.Error("invalid metal name. metalName = " .. tostring(metalName) )
		return
	end

	local trapName
	if mvars.rideMetal_TrapInfo and mvars.rideMetal_TrapInfo[metalName] then
		trapName = mvars.rideMetal_TrapInfo[metalName].trapName
	end

	if not doneCheckFlag then
		if Tpp.IsNotAlert() then
			Fox.Log("s10070_sequence.ShowIconForRideMetalDemo()")
			Player.RequestToShowIcon {
				type = ActionIcon.ACTION,
				icon = ActionIcon.RIDE_MGM,
				message = Fox.StrCode32("Ride_WalkerGear"),
				messageArg = metalName,
			}
		elseif trapName then
			this.HideIconForRideMetalDemo()
			Player.SetWaitingTimeToTrapDetailCondition { trapName = trapName, time = 2.0 }
			
		else
			
		end
	end
end

function this.HideIconForRideMetalDemo()
	Fox.Log("s10070_sequence.HideIconForRideMetalDemo()")
	Player.RequestToHideIcon{
		type = ActionIcon.ACTION,
		icon = ActionIcon.RIDE_MGM,
	}
end


function this.SwitchWalkerGearRide( gearIndex, flag )

	Fox.Log("s10070_sequence.HideIconForRideMetalDemo()")

	
	local gameObjectId = { type="TppCommonWalkerGear2", index=gearIndex }
	local command = { id = "NoRideOn", enabled = flag }

	if gameObjectId ~= nil then
		GameObject.SendCommand( gameObjectId, command )
	else
		Fox.Warning("WalkerGear gameObjectId is nil")
	end
end




function this.SwitchSovietBaseHungerAsset_RescueHuey()

	Fox.Log("s10070_sequence.SwitchSovietBaseHungerAsset_RescueHuey()")

	
	TppDataUtility.SetVisibleDataFromIdentifier( "sovietBase_asset_DataIdentifier", "ReptileHungerAsset_HueyMission", true, true)
	
	TppDataUtility.SetVisibleDataFromIdentifier( "sovietBase_asset_DataIdentifier", "HueyHungerAsset_ReptileMission", false, true)
	
	TppDataUtility.SetVisibleDataFromIdentifier( "sovietBase_asset_DataIdentifier", "ReptileHungerAsset_TopRoof_Before", true, true)

	
	TppDataUtility.SetVisibleDataFromIdentifier( "soviet_mission_asset01_DataIdentifier", "HueyHungerAsset_HueyMission", true, true)
	TppDataUtility.SetVisibleDataFromIdentifier( "soviet_mission_asset01_DataIdentifier", "HueyHungerAsset_ReptileMission", false, true)

	
	TppDataUtility.SetVisibleDataFromIdentifier( "soviet_mission_asset02_DataIdentifier", "ReptileHungerAsset_ReptileMission", false, true)
	TppDataUtility.SetVisibleDataFromIdentifier( "soviet_mission_asset02_DataIdentifier", "ReptileHungerAsset_HueyMission", true, true)
	TppDataUtility.SetVisibleDataFromIdentifier( "soviet_mission_asset02_DataIdentifier", "ReptileHungerAsset_TopRoof_After", false, true)

end

function this.SwitchSovietBaseHungerGimmick_RescueHuey()

	Fox.Log("s10070_sequence.SwitchSovietBaseHungerGimmick_RescueHuey()")

	
	Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "afgh_cmpt002_gim_n0001|srt_afgh_cmpt002", DATASET_PATH_ASSET01, false )
	Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "afgh_cmpt002_gim_n0002|srt_afgh_cmpt002", DATASET_PATH_ASSET01, false )
	Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "afgh_cmpt002_gim_n0003|srt_afgh_cmpt002", DATASET_PATH_ASSET01, true )
	Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "afgh_cmpt002_gim_n0004|srt_afgh_cmpt002", DATASET_PATH_ASSET01, true )

	
	Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "aip0_main0_gm_gim_n0000|srt_aip0_main0_gm", DATASET_PATH_ASSET01, false )
	Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "aip0_main0_gm_gim_n0001|srt_aip0_main0_gm", DATASET_PATH_ASSET01, true )

end


function this.SwitchSovietBaseHungerDoor( switchFlag )

	Fox.Log("*** s10070_sequence.SwitchSovietBaseHungerDoor ***")

	if switchFlag then
		
		TppDataUtility.SetVisibleDataFromIdentifier( "sovietBase_asset_DataIdentifier", "HueyHungerDoor_Before", false, true)
		TppDataUtility.SetVisibleDataFromIdentifier( "sovietBase_asset_DataIdentifier", "HueyHungerDoor_After", true, true)
		TppDataUtility.SetEnableDataFromIdentifier( "id_20150312_101903_016", "LightGroup_OpenDoor_Isolate", true)
	else
		
		TppDataUtility.SetVisibleDataFromIdentifier( "sovietBase_asset_DataIdentifier", "HueyHungerDoor_Before", true, true)
		TppDataUtility.SetVisibleDataFromIdentifier( "sovietBase_asset_DataIdentifier", "HueyHungerDoor_After", false, true)
		TppDataUtility.SetEnableDataFromIdentifier( "id_20150312_101903_016", "LightGroup_OpenDoor_Isolate", false)
	end
end

function this.SwitchpowerPlantGateDoor( switchFlag )

	Fox.Log("*** s10070_sequence.SwitchpowerPlantGateDoor ***")

	if switchFlag ~= nil then
		
		TppDataUtility.SetVisibleDataFromIdentifier( "powerPlant_asset_DataIdentifier", "GateDoor", switchFlag, true)
	end

end

function this.SwitchVisibleAiPod( switchFlag )

	Fox.Log("*** s10070_sequence.SwitchVisibleAiPod ***")

	if switchFlag == false then
		
		Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "aip0_main0_gm_gim_n0000|srt_aip0_main0_gm", DATASET_PATH_ASSET01, true )
		TppDataUtility.SetVisibleDataFromIdentifier( "id_20150312_190823_571_Crip", "aip_memo", false, true)
	else
		Gimmick.InvisibleGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, "aip0_main0_gm_gim_n0000|srt_aip0_main0_gm", DATASET_PATH_ASSET01, false )
		TppDataUtility.SetVisibleDataFromIdentifier( "id_20150312_190823_571_Crip", "aip_memo", true, true)
	end

end

function this.ClosepowerPlantHangereDoor()

	
	if TppScriptBlock.GetCurrentPackListName( "npc_block" ) == "powerPlantHunger" then
		Fox.Log("*** s10070_sequence.ClosepowerPlantHangereDoor ***")
		TppDataUtility.SetVisibleDataFromIdentifier( "DemoModelIdentifier", "hangar_door", true, true)
	end
end

function this.LockAutoDoor_sovietBase()

	Fox.Log("*** s10070_sequence.LockAutoDoor_sovietBase ***")
	
	Gimmick.SetEventDoorLock( "mtbs_door006_door005_gim_n0005|srt_mtbs_door006_door005" , DATASET_PATH_LARGE, true , 0 )
	Gimmick.SetEventDoorLock( "mtbs_door006_door005_gim_n0002|srt_mtbs_door006_door005" , DATASET_PATH_LARGE, true , 0 )
	Gimmick.SetEventDoorLock( "mtbs_door006_door005_gim_n0006|srt_mtbs_door006_door005" , DATASET_PATH_LARGE, true , 0 )
	Gimmick.SetEventDoorLock( "mtbs_door006_door005_gim_n0003|srt_mtbs_door006_door005" , DATASET_PATH_LARGE, true , 0 )
	Gimmick.SetEventDoorLock( "mtbs_door006_door005_gim_n0007|srt_mtbs_door006_door005" , DATASET_PATH_LARGE, true , 0 )
	Gimmick.SetEventDoorLock( "mtbs_door006_door005_gim_n0004|srt_mtbs_door006_door005" , DATASET_PATH_LARGE, true , 0 )
end








sequences.Seq_Demo_SahelanTest = {

	OnEnter = function()
		

		
		TppStory.MissionOpen( 10070 )
		TppStory.DisableMissionNewOpenFlag( 10070 )

		local startFunc = function()
			
			this.SwitchpowerPlantGateDoor( false )
			Gimmick.SetEventDoorInvisible( EVENT_DOOR_NAME , EVENT_DOOR_PATH , true )

		end
		local endFunc = function()
			this.SwitchpowerPlantGateDoor( true )
			Gimmick.SetEventDoorInvisible( EVENT_DOOR_NAME , EVENT_DOOR_PATH , false )
		
			
			TppMission.Reload{
				isNoFade = false,
				showLoadingTips = false,
				missionPackLabelName = "afterSahelanTestDemo",
				OnEndFadeOut = function()
					TppScriptBlock.LoadDemoBlock("Demo_GetIntel", false )
					TppSequence.ReserveNextSequence("Seq_Demo_MissionTitle")
					
					TppMission.UpdateCheckPoint("CHK_AfterSahelanTestDemo")
				end,
			}
		end
		s10070_demo.SahelanTest( startFunc, endFunc )

	end,

	OnLeave = function ()
	end,

}


sequences.Seq_Demo_MissionTitle = {		

	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					
					msg = "StartMissionTelopFadeOut",
					func = function ()
						Fox.Log("!!!!!!!!!!!!!!!!! s10070_sequence: StartMissionTelopFadeOut !!!!!!!!!!!!!!!")
						TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "FadeInOnGameStart")
						TppMain.EnableGameStatus()	
						TppSequence.SetNextSequence("Seq_Game_GoToSovietBase")
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(-1626.0468, 485.41876, -1495.6141))
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		TppUI.StartMissionTelop()
	end,

	OnLeave = function ()
		
		TppMission.UpdateCheckPoint("CHK_AfterSahelanTestDemo")
	end,

}


sequences.Seq_Game_GoToSovietBase = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Block = {
				{
					msg = "OnScriptBlockStateTransition",
					func = function (blockName,blockState)
						Fox.Log("*** Seq_Game_GoToSovietBase.OnScriptBlockStateTransition ***")
						Fox.Log("blockName is " .. tostring(blockName) .. "        / blockState is " .. tostring(blockState))

						
						if TppScriptBlock.GetCurrentPackListName( "npc_block" ) == "Huey" and blockState == ScriptBlock.TRANSITION_ACTIVATED then
							mvars.isHueyBlockLoad = true
							this.SetUniqueStaffType()	
							if TppScriptBlock.GetCurrentPackListName( "demo_block" ) ~= "Demo_ContactHuey" then
								TppScriptBlock.LoadDemoBlock("Demo_ContactHuey")	
							end
						end
						
						if TppScriptBlock.GetCurrentPackListName( "demo_block" ) == "Demo_ContactHuey" and blockState == ScriptBlock.TRANSITION_ACTIVATED then
							mvars.isContactHueyDemoBlockLoad = true
							
							if mvars.waitHueyBlockLoad == true then
								this.CheckBeforeContactHueyDemo()
							end
						end
					end,
				},
				{
					msg = "OnChangeLargeBlockState",
					func = function( blockName , state)
						if blockName == Fox.StrCode32( "afgh_powerPlant" ) and state == StageBlock.ACTIVE	then
							Fox.Log("*** Seq_Game_GoToSovietBase.OnChangeLargeBlockState afgh_powerPlant ***")
							
							local gameObjectId = { type="TppHuey2", index=0 }
							local command = { id="SetEnabled", enabled=false }
							GameObject.SendCommand( gameObjectId, command )
							
							if TppScriptBlock.GetCurrentPackListName( "demo_block" ) == "Demo_ContactHuey" then
								TppScriptBlock.Unload( "demo_block" )
							end
						elseif blockName == Fox.StrCode32( "afgh_sovietBase" ) and state == StageBlock.ACTIVE	then
							Fox.Log("*** Seq_Game_GoToSovietBase.OnChangeLargeBlockState afgh_sovietBase ***")
							
							if TppScriptBlock.GetCurrentPackListName( "demo_block" ) == "Demo_GetIntel" then
								TppScriptBlock.Unload( "demo_block" )
							end
						end
					end,
				},
				nil
			},
			Radio = {
				{
					
					msg = "Finish",	sender = "s0070_rtrg0030",
					func = function ()
						Fox.Log("s10070_mission Finish s0070_rtrg0030!!")
						
						TppTelop.StartMissionObjective()
					end
				},
			},
			Player = {
				
				{
					msg = "GetIntel",	sender = "Intel_powerPlant",
					func = function( intelNameHash )
						TppPlayer.GotIntel( intelNameHash )
						local func = function()
							if svars.isFoundHueyPos or svars.isDummyFlag01 then
								
								TppRadio.Play("f1000_rtrg1540")
							else
								TppRadio.Play("f1000_rtrg3050")	
							end
							this.GotHueyHungerPos()
							
							TppMission.UpdateObjective{
								objectives = { "area_Intel_powerPlant_get", },
							}
							
							TppMission.UpdateCheckPoint("CHK_AfterGetIntelDemo")
						
						end
						
						s10070_demo.GetIntel(func)
					end,
				},
			},
			Marker = {
				
				{
					msg = "ChangeToEnable",	
					func = function ( instanceName, makerType, s_gameObjectId, identificationCode )
						local gameObjectId = GameObject.GetGameObjectId("TppHuey2", TARGET_HUEY )
						
						if s_gameObjectId == gameObjectId and identificationCode == Fox.StrCode32("Player") then
							Fox.Log("### Marking Huey ###")
							TppMission.UpdateObjective{
								objectives = { "target_huey", },
								radio = {
									radioGroups = "s0070_rtrg0090",
									radioOptions = { delayTime = "short", playDebug = false },
								},
							}
							
							TppMarker.Enable( TARGET_HUEY, 0, "defend", "map_and_world_only_icon", 0, true, false )
							TppUiCommand.ShowPictureInfoHud( MISSION_INFO_PHOTO_ID, 1, 3.0 )
							
							TppRadio.SetOptionalRadio("Set_s0070_oprg0040")	
							svars.isDummyFlag01 = true	
						end
					end
				},
				nil
			},
			GameObject = {
				
				{
					msg = "ChangePhase", sender = "afgh_sovietBase_cp",
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10070_sequence:ChangePhase sovietBase !!!!!")
						local phaseName = arg1
						
						if phaseName == TppGameObject.PHASE_ALERT then
							
							if svars.isFoundHueyPos or svars.isDummyFlag01 then
								TppRadio.SetOptionalRadio("Set_s0070_oprg0060")	
							end
						else
							
							if svars.isArrivedSovietBase == false and svars.isFoundHueyPos == false then
								TppRadio.SetOptionalRadio("Set_s0070_oprg0030")		
							
							elseif svars.isFoundHueyPos or svars.isDummyFlag01 then
								TppRadio.SetOptionalRadio("Set_s0070_oprg0040")		
							else
								TppRadio.SetOptionalRadio("Set_s0070_oprg0050")		
							end
						end
					end,
				},
				{
					msg = "RoutePoint2",
					func = function (gameObjectId, routeId ,routeNode, messageId )
						Fox.Log("*** " .. tostring(gameObjectId) .. " ::RouteChangeGameObjectId ***")
						
						if svars.issovietEnemyHeliStart == false then
							if messageId == StrCode32("msg_pwHeli_exit_9999") then
								
								if mvars.ispowerPlantHeliDisableReserve then
								
								end
							elseif messageId == StrCode32("msg_pwHeli_rt0001_end") then
								if svars.isOpeningDemoRadio == true then
									s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_powerPlant_0003", "rts_ptr_c_powerPlant_0000" )
									svars.ispowerPlantHeliMove = true
								else
									s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_powerPlant_0002", "rts_ptr_c_powerPlant_0000" )
									svars.ispowerPlantHeliMove = false
								end
							elseif messageId == StrCode32("msg_pwHeli_rt0002_end") then
								if svars.ispowerPlantHeliMove == false then
									s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_powerPlant_0003", "rts_ptr_c_powerPlant_0000" )
									svars.ispowerPlantHeliMove = true
								end
							elseif messageId == StrCode32("msg_pwHeli_rt0003_check") then
								if svars.isWalkerLrrpStart == false then
									
									
								end
							elseif messageId == StrCode32("msg_pwHeli_rt0003_end") then
								
								s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_sovietBase_1000", "rts_ptr_e_sovietBase_1000" )
							elseif messageId == StrCode32("msg_pwHeli_rt9999_end") then
								
								s10070_enemy02.ChangeEnableEnemyHeli( false )
								svars.ispowerPlantHeliDisable = true
							end
						else
						
							if messageId == StrCode32("msg_svHeli_exit_9998") then
								
								if mvars.issovietBaseHeliExitReserve then
									s10070_enemy02.EnemyHeliForceExit( "rts_ptr_e_sovietBase_9998" )
									svars.issovietBaseHeliExitStart = true
								end
							elseif messageId == StrCode32("msg_svHeli_exit_9999") then
								
								if mvars.issovietBaseHeliExitReserve then
									s10070_enemy02.EnemyHeliForceExit( "rts_ptr_e_sovietBase_9999" )
									svars.issovietBaseHeliExitStart = true
								end
							elseif messageId == StrCode32("msg_svHeli_rt0000_end") then
								s10070_enemy02.ChangeEnableEnemyHeli( true )
							elseif messageId == StrCode32("msg_svHeli_rt0001_end") then
								s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_sovietBase_0002", "rts_ptr_c_sovietBase_0000" )
							elseif messageId == StrCode32("msg_svHeli_rt0002_end") then
								if svars.issovietBaseHeliExitStart == false then
									s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_sovietBase_0003", "rts_ptr_c_sovietBase_0000" )
								else
									s10070_enemy02.EnemyHeliForceExit( "rts_ptr_e_sovietBase_9999" )
								end
							elseif messageId == StrCode32("msg_svHeli_rt0003_check") then
								if svars.issovietBaseHeliExitStart == true then
									
								
									svars.issovietBaseHeliDisable = true
								end
							elseif messageId == StrCode32("msg_svHeli_rt0003_end") then
								if svars.issovietBaseHeliExitStart == true then
									
								
									svars.issovietBaseHeliDisable = true
								else
									s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_sovietBase_0001", "rts_ptr_c_sovietBase_0000" )
								end
							elseif messageId == StrCode32("msg_svHeli_rt9999_end") then
								
								s10070_enemy02.ChangeEnableEnemyHeli( false )
								svars.issovietBaseHeliDisable = true
							end
						end
						
						if messageId == StrCode32("msg_Wkr0_rt0001_end") then
							if mvars.WalkerRouteA <= 2 then
								s10070_enemy02.SetAllRoute( "sol_sovietBase_0003", "rts_sovietBase_wkr0_e_0002" )
								mvars.WalkerRouteA = 2
							end
						elseif messageId == StrCode32("msg_Wkr0_rt0002_end") then
							if mvars.WalkerRouteA <= 3 then
								s10070_enemy02.SetAllRoute( "sol_sovietBase_0003", "rts_sovietBase_wkr0_e_0003" )
								mvars.WalkerRouteA = 3
							end
						elseif messageId == StrCode32("msg_Wkr0_rt0003_end") then
							if mvars.WalkerRouteA <= 4 then
								
								
								TppEnemy.SetSneakRoute( "sol_sovietBase_0003", "rts_sovietBase_wkr0_d_0000" )	
								TppEnemy.SetCautionRoute( "sol_sovietBase_0003", "rts_sovietBase_wkr0_c_0000" )	
								mvars.WalkerRouteA = 4
							end
						else
							
						end
						
						if messageId == StrCode32("msg_Wkr1_rt0001_end") then
							if mvars.WalkerRouteB <= 2 then
								s10070_enemy02.SetAllRoute( "sol_sovietBase_0006", "rts_sovietBase_wkr1_e_0002" )
								mvars.WalkerRouteB = 2
							end
						elseif messageId == StrCode32("msg_Wkr1_rt0002_end") then
							if mvars.WalkerRouteB <= 3 then
								s10070_enemy02.SetAllRoute( "sol_sovietBase_0006", "rts_sovietBase_wkr1_e_0003" )
								mvars.WalkerRouteB = 3
							end
						elseif messageId == StrCode32("msg_Wkr1_rt0003_end") then
							if mvars.WalkerRouteB <= 4 then
								
								
								TppEnemy.SetSneakRoute( "sol_sovietBase_0006", "rts_sovietBase_wkr1_d_0000" )	
								TppEnemy.SetCautionRoute( "sol_sovietBase_0006", "rts_sovietBase_wkr1_c_0000" )	
								mvars.WalkerRouteB = 4
							end
						else
							
						end
					end
				},
			},
			Trap = {
				{	
					msg = "Enter",	sender = "trap_powerPlantEnemyHeliStart",
					func = function ()
						Fox.Log("s10070_sequence trap_powerPlantEnemyHeliStart!!")
						
						if svars.ispowerPlantHeliStart == false then
							s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_powerPlant_0001", "rts_ptr_c_powerPlant_0000" )
							svars.ispowerPlantHeliStart = true
						end
					end
				},
				{	
					msg = "Enter",	sender = "trap_powerPlantEnemyHeliMove",
					func = function ()
						Fox.Log("s10070_sequence trap_powerPlantEnemyHeliMove!!")
						
						if svars.ispowerPlantHeliMove == false then
							s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_powerPlant_0003", "rts_ptr_c_powerPlant_0000" )
							svars.ispowerPlantHeliMove = true
						end
					end
				},
				{	
					msg = "Exit",	sender = "trap_CHK_powerPlant",
					func = function ()
						Fox.Log("s10070_sequence trap_CHK_powerPlant!!")
						
						if svars.isOpeningDemoRadio == false then
							TppRadio.Play("s0070_rtrg0040", { isEnqueue = true })
							svars.isOpeningDemoRadio = true
						end
					end
				},
				{	
					msg = "Enter",	sender = "trap_load_d02",
					func = function ()
						Fox.Log("s10070_sequence trap_load_d02!!")
						local blockId = ScriptBlock.GetScriptBlockId("npc_block")
						local state = ScriptBlock.GetScriptBlockState(blockId)
						
						if TppScriptBlock.GetCurrentPackListName( "npc_block" ) == "Huey" then
							TppScriptBlock.LoadDemoBlock("Demo_ContactHuey")	
						else
							
							Fox.Log("!!!! npc_block[huey] is notloaded !!!!")
							TppScriptBlock.Load( "npc_block", "Huey", true )
						end
					end
				},
				{	
					msg = "Enter",	sender = "trap_load_d07",
					func = function ()
						Fox.Log("s10070_sequence trap_load_d07!! ::Enter")
						
						TppScriptBlock.Load( "npc_block", "powerPlantHunger", true )
						
						if svars.isDummyFlag02 == false then
							TppScriptBlock.LoadDemoBlock("Demo_GetIntel")	
						end
					end
				},
				{	
					msg = "Exit",	sender = "trap_load_d07",
					func = function ()
						Fox.Log("s10070_sequence trap_load_d07 ::Exit!!")
						
						if svars.isOpeningRadio02 == false then
							TppMission.UpdateObjective{
								objectives = { "default_area_sovietBase02", "mission_target_cp", "photo_target", },
								radio = {
									radioGroups = "s0070_rtrg0050",
									radioOptions = { delayTime = "short", playDebug = false },
								},
							}
							svars.isOpeningRadio02 = true
						end
						if svars.ispowerPlantHeliMove == false then
							s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_powerPlant_0003", "rts_ptr_c_powerPlant_0000" )
							svars.ispowerPlantHeliMove = true
						end
					end
				},
				{	
					msg = "Enter",
					sender = "trap_walkerStart",
					func = function ()
						Fox.Log("s10070_sequence trap_walkerStart!!")
						if svars.isWalkerLrrpStart == false then
							s10070_enemy02.WalkerGearLRRPStart()
							svars.isWalkerLrrpStart = true
						end
					end
				},
				{	
					msg = "Enter",
					sender = "trap_sovietBaseLrrpStart",
					func = function ()
						Fox.Log("s10070_sequence trap_sovietBaseLrrpStart!!")
						if svars.isSovietBaseLrrpStart == false then
							s10070_enemy02.sovietBaseLRRPStart()
							svars.isSovietBaseLrrpStart = true
						end
						if mvars.ispowerPlantHeliDisableReserve == false then
							
							
							mvars.ispowerPlantHeliDisableReserve = true
						end
					end
				},
				{	
					msg = "Enter",	sender = "trap_sovietEnemyHeliStart",
					func = function ()
						Fox.Log("s10070_sequence trap_sovietEnemyHeliStart!!")
						if svars.issovietEnemyHeliStart == false then
							s10070_enemy02.sovietEnemyHeliStart()
							svars.issovietEnemyHeliStart = true
						end
					end
				},
				{	
					msg = "Enter",	sender = "trap_sovietEnemyHeliMove",
					func = function ()
						Fox.Log("s10070_sequence trap_sovietEnemyHeliMove!!")
						if svars.issovietEnemyHeliMove == false then
							s10070_enemy02.sovietEnemyHeliMove()
							svars.issovietEnemyHeliMove = true
						end
					end
				},
				{
					msg = "Enter",
					sender = "trap_sovietBase_Entry",
					func = function ()
						if svars.isArrivedSovietBase == false then
							Fox.Log("s10070_sequence trap_sovietBase_Entry!!")
							svars.isArrivedSovietBase = true
							TppMission.UpdateObjective{
								objectives = { "detail_area_sovietBase", },
								radio = {
									radioGroups = "s0070_rtrg0060",
									radioOptions = { delayTime = "short", playDebug = false },
								},
							}
							
							if svars.isFoundHueyPos == false then
								
								TppRadio.SetOptionalRadio("Set_s0070_oprg0050")	
							end
							
							s10070_enemy02.UpdateWalkerRoute_Seq2()
							mvars.WalkerRouteA = 1
							mvars.WalkerRouteB = 1

							
							s10070_enemy02.SwitchChargemode( "sol_sovietBase_0003", true )

						else
							Fox.Log("s10070_sequence Already Arrived SovietBase....")
						end
					end
				},
				{	
					msg = "Enter",	sender = "trap_SahelanAttack_Herald00",
					func = function ()
						if mvars.WalkerRouteA ~= 3 and mvars.WalkerRouteB ~= 3 then
							Fox.Log("s10070_mission trap_SahelanAttack_Herald00 at SeqGoToSovietBase!!")
							s10070_enemy02.UpdateWalkerRoute_Seq3()
							mvars.WalkerRouteA = 3
							mvars.WalkerRouteB = 3

							
							s10070_enemy02.SwitchChargemode( "sol_sovietBase_0003", false )
						end
					end
				},
				{	
					msg = "Enter",	sender = "trap_sovietHeliExit",
					func = function ()
						if svars.issovietBaseHeliExitStart == false and mvars.issovietBaseHeliExitReserve == false then
							Fox.Log("s10070_sequence trap_sovietHeliExit!!")
							
							mvars.issovietBaseHeliExitReserve = true
							if s10070_enemy02.CheckUsingRouteName_EnemyHeli("rts_ptr_e_sovietBase_0002") then
								s10070_enemy02.EnemyHeliForceExit( "rts_ptr_e_sovietBase_9999" )
								svars.issovietBaseHeliExitStart = true
							end
						end
					end
				},
				{
					msg = "Enter",	sender = "trap_HueyHungerNear",
					func = function ()
						if svars.isArrivedSovietBase == true then
							Fox.Log("s10070_sequence npc_block:Huey Load!!")
							s10070_sequence.SetDisableDamageHuey( true )	
						end
					end
				},
				{
					msg = "Enter",	sender = "trap_Start_ContactHueyDemo",
					func = function ()
						Fox.Log("s10070_sequence trap_Start_ContactHueyDemo!!")
						mvars.waitHueyBlockLoad = true
						this.CheckBeforeContactHueyDemo()
					end
				},
				{
					msg = "Enter",
					sender = "trap_sovietBase_Area",
					func = function ()
						if TppScriptBlock.GetCurrentPackListName( "npc_block" ) ~= "Huey" then
							svars.isDummyFlag07 = true				
							
							Fox.Log("**** npc_block[huey] is loading ****")
							TppScriptBlock.Load( "npc_block", "Huey", true )
						end
					end
				},
				{
					msg = "Exit",
					sender = "trap_sovietBase_Area",
					func = function ()	svars.isDummyFlag07 = false	end		
				},
			},
			nil
		}
	end,

	OnEnter = function()

		
		Gimmick.SetEventDoorLock( EVENT_DOOR_NAME , EVENT_DOOR_PATH , false, 0 )	

		
		for index, targetName in pairs(this.MISSION_TASK_TARGET) do
			local gameObjectId = GameObject.GetGameObjectId( targetName )
			if gameObjectId ~= NULL_ID then
				TppEnemy.RegistHoldRecoveredState( targetName )
			else
				Fox.Warning("s10070_sequence::Cannot get gameObjectId. targetName = " .. tostring(targetName) )
			end
		end

		
		TppHelicopter.SetDisableLandingZone{ landingZoneName = RV_ESCAPE }
		this.SwitchSahelanBattleLZ( false )		

		
		TppInterrogation.AddHighInterrogation(
			GameObject.GetGameObjectId("afgh_sovietBase_cp"),
			{
			
				{ name = "svhy1000_094979", func = s10070_enemy02.InterCall_huey_pos01, },
			}
		)

		
		
		if svars.isArrivedSovietBase == false and svars.isFoundHueyPos == false then
			TppRadio.SetOptionalRadio("Set_s0070_oprg0030")		
		
		elseif svars.isFoundHueyPos or svars.isDummyFlag01 then
			TppRadio.SetOptionalRadio("Set_s0070_oprg0040")		
		else
			TppRadio.SetOptionalRadio("Set_s0070_oprg0050")		
		end

		
		if svars.isFoundHueyPos == false then
			TppRadioCommand.SetEnableEspionageRadioTarget{ name= {"EspRadioLocator_hunger"}, enable = false }
		else
			TppRadioCommand.SetEnableEspionageRadioTarget{ name= {"EspRadioLocator_sovistBase"}, enable = true }
		end

		
		TppMission.UpdateObjective{
			objectives = {
				
				"photo_target",
				
				"subGoal_default",
				
				"default_missionTask_01",
				"default_missionTask_02",
				
				"default_missionTask_03",
				"default_missionTask_05",
				"default_missionTask_06",
			},
		}

		if TppSequence.GetContinueCount()	== 0 then
			
			TppMission.UpdateObjective{
				objectives = { "default_area_sovietBase01", "mission_target_cp", },
				radio = {
					radioGroups = "s0070_rtrg0030",
					radioOptions = { delayTime = "short", playDebug = false },
				},
			}
			
			if not TppQuest.IsCleard("sovietBase_q99020") then
				TppQuest.ClearWithSave( TppDefine.QUEST_CLEAR_TYPE.CLEAR, "sovietBase_q99020" )
			end

		else
			
			if svars.isOpeningRadio02 == false then
				TppMission.UpdateObjective{
					objectives = { "default_area_sovietBase01", "mission_target_cp", },
					radio = {
						radioGroups = "s0070_rtrg0030",
						radioOptions = { delayTime = "short", playDebug = false },
					},
				}
			else
				
				TppMission.UpdateObjective{
					objectives = { "default_area_sovietBase01", "mission_target_cp", },
					radio = {
						radioGroups = "s0070_rtrg0050",		
						radioOptions = { delayTime = "short", playDebug = false },
					},
				}
			end
		end

		
		if svars.isArrivedSovietBase == false and svars.issovietEnemyHeliStart == true then
			s10070_enemy02.sovietEnemyHeliStart()
		else

		end

		
		
		if svars.issovietBaseHeliDisable then
			

		elseif svars.issovietEnemyHeliMove then
			
			s10070_enemy02.sovietEnemyHeliMove()
		elseif svars.issovietEnemyHeliStart then
			
			s10070_enemy02.sovietEnemyHeliStart()
		elseif svars.ispowerPlantHeliMove then
			
			s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_powerPlant_0003", "rts_ptr_c_powerPlant_0000" )
		else
			
			s10070_enemy02.UpdateEnemyHeliRoute( "rts_ptr_e_powerPlant_0000", "rts_ptr_c_powerPlant_0000" )
		end

		
		if svars.isArrivedSovietBase == false and svars.isOpeningRadio02 == true then
			TppRadio.Play( "s0070_rtrg0050" )

		
		elseif svars.isArrivedSovietBase and svars.isFoundHueyPos == false then
			TppRadio.Play( "s0070_rtrg0070" )
		end

		
		this.UpdateMissionZone()

		
		
		s10070_enemy02.SetRelativeVehicle( "sol_sovietBase_0003", "wkr_s10070_0000")
		s10070_enemy02.SetRelativeVehicle( "sol_sovietBase_0006", "wkr_s10070_0001")
		s10070_enemy02.SetRelativeVehicle( "sol_sovietBase_0013", "wkr_s10070_0002")

		
		this.SwitchWalkerGearRide( 3, true )

	end,

	OnLeave = function ()
		
		
		TppMission.UpdateCheckPointAtCurrentPosition()
	end,

}


sequences.Seq_Demo_ContactHuey = {

	OnEnter = function()

		local startFunc = function()
			
			this.SwitchVisibleAiPod( false )
		end
		local endFunc = function()
			this.SwitchVisibleAiPod( true )
			TppScriptBlock.LoadDemoBlock("Demo_RideMetal")
			TppSequence.SetNextSequence("Seq_Game_EscapeSovietBase")
		end
		s10070_demo.ContactHuey( startFunc, endFunc )
	end,

	OnLeave = function ()
		
		
		TppMission.UpdateCheckPointAtCurrentPosition()
	end,

}


sequences.Seq_Game_EscapeSovietBase = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Demo = {
				{	
					msg = "p31_040130_DemoEnd_hyu",
					func = function( targetName, gameObjectId )
						Fox.Log("*** DemoMessage:p31_040130_DemoEnd_hyu ***")
						
						local gameObjectId = { type="TppHuey2", index=0 }
						local command = { id="SetIgnoreDisableNpc", enable=true }
						GameObject.SendCommand( gameObjectId, command )
						
						this.SwitchSovietBaseHungerDoor( true )
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "Skip",
					func = function( arg1, arg2 )
						Fox.Log("*** DemoMessage:Skip ***")
						if TppScriptBlock.GetCurrentPackListName( "demo_block" ) == "Demo_RideMetal" then
							
							this.SwitchSovietBaseHungerDoor( true )
						end
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			GameObject = {
				{
					
					msg = "MonologueEnd",
					func = function (GameObjectId,speechLabel,isSuccess)
						Fox.Log("s10070_sequence Monologue GameObjectId"..GameObjectId)
						Fox.Log("s10070_sequence Monologue speechLabel"..speechLabel)
						Fox.Log("s10070_sequence Monologue isSuccess"..isSuccess)
						
						if( isSuccess )then
							
							if( GameObjectId == GameObject.GetGameObjectId(TARGET_HUEY) )then
								
								if( speechLabel == Fox.StrCode32("speech070_carry060") )then	
									mvars.isPlayedMonologue_Huey01_end = true
									
									TppMarker2System.EnableMarker{	gameObjectId = GameObject.GetGameObjectId( "TppCommonWalkerGear2", "wkr_s10070_sp" ),}
									s10070_radio.MonologueAfterKazuRadio01()
								elseif( speechLabel == Fox.StrCode32("speech070_carry120") )then	
									mvars.isPlayedMonologue_Huey05_end = true
									s10070_radio.MonologueAfterKazuRadio02()
								elseif( speechLabel == Fox.StrCode32("speech070_carry100") )then	
									
									GkEventTimerManager.Start( "HueyRoleTimer", TIMER_HUEY_ROLE )
								else
									
									Fox.Log("s10070_sequence Monologue Unkown Label!!")
								end
							else
								
								Fox.Log("s10070_sequence Monologue Unkown Charal!!")
							end
						else
							
							Fox.Log("s10070_sequence Monologue failed !!")
						end
					end
				},
				
				{
					msg = "ArrivedAtLandingZoneWaitPoint", sender = "SupportHeli",
					func = function ( arg0, arg1 )
						Fox.Log("!!!!! LandedAtLandingZone !!!!!")
						
						if mvars.isPlayerOnLZ then
							local isHueyHere = TppEnemy.CheckAllTargetClear()
							if isHueyHere then
								
								self.OnSahelanHerald02()
							else
								
								TppRadio.Play("s0070_rtrg0160")
							end
						end
					end
				},
			},
			Timer = {
				
				{
					msg = "Finish",	sender = "AboutWalkerGearRadio",
					func = function ()
						if mvars.isPlayedMonologue_Huey05 == false then
							s10070_radio.CallMonologueHuey05()	 
							mvars.isPlayedMonologue_Huey05 = true
						end
					end
				},
				
				{
					msg = "Finish",	sender = "9yearsRadio",
					func = function ()
						
						self.OnCheck9yeasRadio()
					end
				},
				
				{
					msg = "Finish",	sender = "HueyRoleTimer",
					func = function ()
						if mvars.isPlayedMonologue_Huey04 == false then
							s10070_radio.CallMonologueHuey04()	 
							mvars.isPlayedMonologue_Huey04 = true
						end
					end
				},
			},
			Player = {
				
				{
					msg = "Ride_WalkerGear", sender = "RideMetal",
					func = function()
						if svars.isRideMetalDemoPlay then
							
							this.HideIconForRideMetalDemo()
						else
							
							if PlayerInfo.OrCheckStatus{ PlayerStatus.CARRY, } then
								this.SetLimitPlayerAction()		
								
								TppGameStatus.Set("s10070_sequence.lua", "S_DISABLE_PLAYER_DAMAGE")
								Player.RequestToMoveToPosition{
									name = "rideMetalRotate",  
									position = Vector3(-2415.307, 438.944, -1530.091),	  
									direction = 85, 	   
									moveType = PlayerMoveType.WALK, 
									timeout = 3,   
								}
								mvars.isReserveRideMetalDemoPlay = true
							else
								self.OnRideMetal_DemoPlay()
							end
						end
					end,
				},
				{	
					msg = "FinishMovingToPosition",
					func = function(arg0,arg1)
						Fox.Log("**** s10070_sequence:FinishMovingToPosition ****")
						
						if mvars.isReserveRideMetalDemoPlay and arg0 == StrCode32("rideMetalRotate") then
							if arg1 == StrCode32("success") then
								GameObject.SendCommand( { type="TppPlayer2", index=PlayerInfo.GetLocalPlayerIndex() }, { id="RequestCarryOff" } )
							else
								Fox.Warning("**** s10070_sequence:FinishMovingToPosition Failed or TimeOut!! ****")
								GameObject.SendCommand( { type="TppPlayer2", index=PlayerInfo.GetLocalPlayerIndex() }, { id="RequestCarryOff" } )	
							end
						
						elseif mvars.isReserveRideMetalDemoPlay and arg0 == StrCode32("rideMetalMove") then
							if arg1 == StrCode32("success") and mvars.isPreMoveRideMetal == false then
								Player.ResetPadMask {	settingName = "beforeDemoPlay"	}			
								self.OnRideMetal_DemoPlay()
								mvars.isReserveRideMetalDemoPlay = false
							elseif arg1 == StrCode32("timeout") then
								Fox.Warning("**** s10070_sequence:FinishMovingToPosition TimeOut ****")
								Player.ResetPadMask {	settingName = "beforeDemoPlay"	}			
								self.OnRideMetal_DemoPlay()
							else
								Fox.Warning("**** s10070_sequence:FinishMovingToPosition Failed ****")
								Player.RequestToMoveToPosition{
									name = "rideMetalMove",  
									position = Vector3(-2416.060, 438.944, -1530.147),	  
									direction = 180, 	   
									moveType = PlayerMoveType.WALK, 
									timeout = 5,   
								}
								mvars.isPreMoveRideMetal = false
							end
						end
					end,
				},
				{	
					msg = "EndCarryAction",
					func = function()
						Fox.Log("**** s10070_sequence:EndCarryAction ****")
						
						if mvars.isReserveRideMetalDemoPlay then
							Player.RequestToMoveToPosition{
								name = "rideMetalMove",  
								position = Vector3(-2416.060, 438.944, -1530.147),	  
								direction = 180, 	   
								moveType = PlayerMoveType.WALK, 
								timeout = 5,   
							}
							mvars.isPreMoveRideMetal = true
						end
					end,
				},
			},
			Radio = {
			{
				
				msg = "Finish",	sender = "s0070_rtrg0100",
				func = function ()
					Fox.Log("s10070_mission CallMonologueHuey01!!")
					if mvars.isPlayedMonologue_Huey01 == false then
						s10070_radio.CallMonologueHuey01()		
						mvars.isPlayedMonologue_Huey01 = true

						
						TppMission.UpdateObjective{
							objectives = { "clear_missionTask_01", "default_missionTask_04", },
						}
						
						TppMarker.Enable( TARGET_HUEY, 0, "defend", "map_and_world_only_icon", 0, true, false )
					end
				end
			},
			{
				
				msg = "Finish",	sender = "s0070_rtrg0190",
				func = function ()
					Fox.Log("*** s10070_mission Finish MonologueAfterKazuRadio01 ***")
					svars.isDummyFlag03 = true	
				end
			},
			{
				
				msg = "Finish",	sender = "s0070_rtrg0250",
				func = function ()
					Fox.Log("s10070_mission CallMonologueHuey03!!")
					if mvars.isPlayedMonologue_Huey03 == false then
						s10070_radio.CallMonologueHuey03()		
						mvars.isPlayedMonologue_Huey03 = true
					end
				end
			},
		},
			Trap = {
				
				{
					msg = "Enter",	sender = "trap_AiPod",
					func = function ()
						if svars.isDummyFlag03 then	
							Fox.Log("*** trap_AiPod:AiPod Talking Start ***")
							Gimmick.StopAiPod ( false )
						else
							Fox.Log("*** trap_AiPod:AiPod Talking Not Start ***")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = "trap_RideMetal",
					func = function ()
						if mvars.isPlayedMonologue_Huey01_end and svars.isRideMetalDemoPlay == false then
							this.ShowIconForRideMetalDemo( "RideMetal", svars.isRideMetalDemoPlay )
						end
					end
				},
				
				{
					msg = "Exit",
					sender = "trap_RideMetal",
					func = function ()
						if svars.isRideMetalDemoPlay == false then
							this.HideIconForRideMetalDemo()
						end
					end
				},
				
				{
					msg = "Enter",
					sender = "trap_HueyHunger",
					func = function ()
						
						if svars.isRideMetalDemoPlay then
							Fox.Log("s10070_mission trap_HueyHunger:Enter!!Already Played RideMetalDemo")
						else
							
							TppScriptBlock.LoadDemoBlock("Demo_RideMetal")
						end
					end
				},
				{
					msg = "Exit",
					sender = "trap_HueyHunger",
					func = function ()
						Fox.Log("s10070_mission trap_HueyHunger:Exit!!")
						
						TppScriptBlock.LoadDemoBlock("Demo_SahelanHerald01")
						local isHueyHere = TppEnemy.CheckAllTargetClear()
						if isHueyHere then
							
							self.OnCheck9yeasRadio()

							
							if svars.isRideMetalDemoPlay == false then
								
								TppSound.SetPhaseBGM( "bgm_rescue_emmerich" )
							end
						else
							
						
						end
						Gimmick.StopAiPod ( true )	
						
						this.CallSupportHeliToRV( RV_ESCAPE )
					end
				},
				
				{
					msg = "Enter",
					sender = "trap_CallHeli_RV_ESCAPE",
					func = function ()
						if svars.isCallHeliRV_escape == false then
							Fox.Log("s10070_mission trap_CallHeli_RV_ESCAPE!!")
							
							this.RemoveIgnoreLookHeli( "afgh_sovietBase_cp" )
							svars.isCallHeliRV_escape = true
						end
					end
				},
				{
					msg = "Enter",
					sender = "trap_SahelanAttack_Herald00",
					func = function ()
						if svars.isSahelan_Herald00 == false then
							Fox.Log("s10070_mission trap_SahelanAttack_Herald00!!")
							
							
							this.SetUpCommandPostSirenType( "afgh_sovietBase_cp", TppGameObject.SIREN_TYPE_POWP, {-1864.860, 463.629, -1436.973} )
							local gameObjectId = GameObject.GetGameObjectId( "TppCommandPost2", "afgh_sovietBase_cp" )
							local command = { id = "SetCpForceSiren", enable=true }
							GameObject.SendCommand( gameObjectId, command )

							svars.isSahelan_Herald00 = true
						end
					end
				},
				{
					msg = "Enter",
					sender = "trap_SahelanAttack_Herald02",
					func = function ()
						if svars.isSahelan_Herald02 == false then
							Fox.Log("s10070_mission trap_SahelanAttack_Herald02!!")
							
							this.SetUpCommandPostSirenType( "afgh_sovietBase_cp", TppGameObject.SIREN_TYPE_SOVB, {-2257.874, 451.303, -1516.756} )
							this.SetForceSiren( "afgh_sovietBase_cp", true )

							svars.isSahelan_Herald02 = true

							this.LandingZoneWaitHeight( HELI_WAIT_HIGHT_ESCAPE02 )	
						end
					end
				},
				{	
					msg = "Enter",	sender = "trap_sovietEnemyHeliMove",
					func = function ()
						Fox.Log("*** s10070_mission trap_sovietEnemyHeliMove ***")
						TppRadio.Play("s0070_rtrg0107")		
					end
				},
				{
					msg = "Enter",
					sender = "trap_Start_SahelanAttackDemo",
					func = function ()
						mvars.isPlayerOnLZ = true
						if mvars.isSahelanHerald02DemoPlay == false then
							local isHueyHere = TppEnemy.CheckAllTargetClear()
							if isHueyHere then
								Fox.Log("s10070_mission trap_Start_SahelanAttackDemo!!")
								
								if this.CheckHeliStatusOnLZ() then
									
									self.OnSahelanHerald02()
								else
									

								end
							else
								
								TppRadio.Play("s0070_rtrg0160")
							end
						end
					end
				},
				{
					msg = "Exit",
					sender = "trap_Start_SahelanAttackDemo",
					func = function ()	mvars.isPlayerOnLZ = false	end
				},
			},
			nil
		}
	end,

	OnEnter = function()

		
		this.SetUpHueyMovingNoticeTrap()	

		
		TppMission.UpdateObjective{
			radio = {
				radioGroups = { "s0070_rtrg0100", },	
				radioOptions = { delayTime = "short", playDebug = false },
			},
			objectives = { "subGoal_gotoLZ", "rv_escape", },
		}

		
		TppMarker.Enable( TARGET_HUEY, 0, "defend", "map_and_world_only_icon", 0, true, false )
		TppUiCommand.RegisterIconUniqueInformation{ markerId = GameObject.GetGameObjectId(TARGET_HUEY), langId = "marker_chara_huey" }
		this.UnlockedHuey()	
		TppEnemy.SetRescueTargets( {TARGET_HUEY} )

		
		this.SwitchWalkerGearRide( 3, true )

		
		TppRadio.SetOptionalRadio("Set_s0070_oprg0070")	

		
		TppRadio.ChangeIntelRadio( s10070_radio.intelRadioList_AfterHueyDemo )

		
		
		
		

		

		TppHelicopter.SetEnableLandingZone{ landingZoneName = RV_ESCAPE }
		this.SwitchSahelanBattleLZ( false )		

		
		TppLandingZone.DisableUnlockLandingZoneOnMission(true)
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_sovietBase_E0000|lz_sovietBase_E_0000" }	
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_powerPlant_E0000|lz_powerPlant_E_0000" }

		
		this.SetTargetDistanceCheck()

		
		this.SetUpHueyLife()
		this.SetDamageRateHuey()
		s10070_sequence.SetDisableDamageHuey( false )	

		
		this.SetIgnoreLookHeli( "afgh_sovietBase_cp" )
		s10070_enemy02.ChangeEnableEnemyHeli( false )	

		
		this.UpdateMissionZone()

		
		s10070_enemy02.ChangeRouteHungerGuard()

		
		s10070_enemy02.SetUpEnemySettingOnEscapeSequence()

		
		TppCheckPoint.Disable{ baseName = { "sovietBase", "sovietSouth", } }

	end,

	OnLeave = function ()
	end,

	
	OnCheck9yeasRadio = function ()
		
		if svars.isRideMetalDemoPlay then
			
			if mvars.isPlayedMonologue_Huey05_end then
				if not TppRadio.IsPlayed("s0070_rtrg0250") then
					TppRadio.Play("s0070_rtrg0250", { delayTime = "mid", isEnqueue = true })
					svars.is9yearsRadioPlay = true
				end
			else
				
				GkEventTimerManager.Stop( "9yearsRadio" )
				GkEventTimerManager.Start( "9yearsRadio", TIMER_ABOUT_9YEARS_RADIO )
			end
		else
			
			if mvars.isPlayedMonologue_Huey01_end then
				if not TppRadio.IsPlayed("s0070_rtrg0250") then
					TppRadio.Play("s0070_rtrg0250", { delayTime = "mid", isEnqueue = true })
					svars.is9yearsRadioPlay = true
				end
			else
				
				GkEventTimerManager.Stop( "9yearsRadio" )
				GkEventTimerManager.Start( "9yearsRadio", TIMER_ABOUT_9YEARS_RADIO )
			end
		end
	end,

	
	OnRideMetal_DemoPlay = function ()
		local startFunc = function()
			
			TppGameStatus.Reset("s10070_sequence.lua", "S_DISABLE_PLAYER_DAMAGE")
		end
		local endFunc = function()
			
			this.SwitchWalkerGearRide( 3, false )

			
			TppScriptBlock.LoadDemoBlock("Demo_SahelanHerald01")

			
			GkEventTimerManager.Start( "AboutWalkerGearRadio", TIMER_ABOUT_WALKERGEAR )

			svars.isRideMetalDemoPlay = true

			
			TppRadio.SetOptionalRadio("Set_s0070_oprg0075")	

			
			TppSound.SetPhaseBGM( "bgm_rescue_emmerich" )

			
			
			
		end
		s10070_demo.RideMetal( startFunc, endFunc )
	end,

	
	OnSahelanHerald02 = function ()
		mvars.isSahelanHerald02DemoPlay = true
		


		
		
		if this.CheckPlayerRideSomething() ~= false then
			svars.isPlayerRideVehicle = true

			
			this.CheckPlayerRideType()

		end

		this.SwitchEnebleGameHeliOnDemo( true )			
		this.SwitchEnebleHueyOnDemo( true )				

		
		local func = function()
			this.SwitchEnebleGameHeliOnDemo( false )			
			this.SwitchEnebleHueyOnDemo( false )
			
			TppMission.Reload{
				isNoFade = false,
				showLoadingTips = false,
				missionPackLabelName = "beforeSahelanAttackDemo",
				OnEndFadeOut = function()
					TppScriptBlock.LoadDemoBlock("Demo_SahelanAttacks", false )
					TppSequence.ReserveNextSequence("Seq_Demo_SahelanAttacks")
					
					
					TppMission.UpdateCheckPoint{
							checkPoint = "CHK_AfterSahelanAttackDemo",
							ignoreAlert = true,
						}
				end,
			}
		end
		s10070_demo.SahelanHerald02(func)

	end,

}


sequences.Seq_Demo_SahelanAttacks = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{	
					msg = "p31_0400140_Player_setpos01",
					func = function( targetName, gameObjectId )
						Fox.Log("*** DemoMessage:p31_0400140_Player_setpos01 ***")
						this.CallHorseOnSahelanAttackDemo()
						GameObject.SendCommand( GameObject.GetGameObjectId( "TppPlayer2", "Player" ), { id = "Warp", pos = { -2213.135, 443.240, -1312.413 }, rotY = 0 } )
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "p31_0400140_Player_setpos02",
					func = function( targetName, gameObjectId )
						Fox.Log("*** DemoMessage:p31_0400140_Player_setpos02 ***")
						this.CallHorseOnSahelanAttackDemo()
						GameObject.SendCommand( GameObject.GetGameObjectId( "TppPlayer2", "Player" ), { id = "Warp", pos = { -2196.855,443.828,-1252.046 }, rotY = 0 } )
						Player.RequestToStartHeadAdjust(Vector3(-2199.752, 463.689, -1222.117))		
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function()

		
		this.SetUpEnableNpcOnSahelanAttackDemo()
		this.SetUpPositionNpcOnSahelanAttackDemo()

		
		local vehicleId = GameObject.GetGameObjectId( "TppVehicle2", "VehicleLocator01" )
		GameObject.SendCommand( vehicleId, { id="SetIgnoreDisableNpc", enable=true })

		


		
		GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetDemoToPullOutEnabled", enabled=true } )

		svars.isAfterSahelanAttack = true	
		local func = function()
			Player.RequestToStopHeadAdjust()	
			Vehicle.SetIgnoreDisableNpc(false)
			TppScriptBlock.LoadDemoBlock("Demo_SahelanFalling")
			TppSequence.SetNextSequence("Seq_Game_EscapeSahelan")
		end
		s10070_demo.SahelanAttacks(func)
	end,

	OnLeave = function ()
		
		TppMission.UpdateCheckPoint("CHK_AfterSahelanAttackDemo")
		
	end,

}


sequences.Seq_Game_EscapeSahelan = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Player = {
				{ msg = "RideHelicopter",		 	func = self.FuncPlayerRideOnHeli },				

			},
			GameObject = {
				
				{
					msg = "PlacedIntoVehicle", sender = TARGET_HUEY,
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10070_sequence:TARGET_HUEY PlacedIntoVehicle !!!!!")
						svars.isRideOnHeli_Huey = true
						local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
						GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })					

						
						GkEventTimerManager.Start( "Timer_radio_HurryUp", 10 )
					end,

				},
				
				{
					msg = "ArrivedAtLandingZoneWaitPoint",
					sender = "SupportHeli",
					func = function ()
						Fox.Log("!!!!! ArrivedAtLandingZoneSkyNav !!!!!")
						mvars.isCantLandingRadio = false
						
						s10070_enemy03.SetRVPosToSahelan()
						s10070_enemy03.SwitchAttackToHoveringHeli(false)	
					end
				},
				
				{
					msg = "StartedMoveToLandingZone",
					sender = "SupportHeli",
					func = function ( arg0, arg1 )
						Fox.Log("!!!!! StartedMoveToLandingZone !!!!!")
						if this.CheckHeliStatusOnLZ() then
							
							s10070_enemy03.SwitchAttackToHoveringHeli(false)	
						end
						
					
					end
				},
				
				{
					msg = "LandedAtLandingZone",
					sender = "SupportHeli",
					func = function ( arg0, arg1 )
						Fox.Log("!!!!! LandedAtLandingZone !!!!!")
						local distance = s10070_enemy03.GetDistanceToLandingZone()
						if mvars.isPlayerOnLZ == false and distance < RANGE_SAHELAN_TO_LZ_CHECK_LANDED then
							this.SwitchAntiSahelanMode( true )	
							s10070_sequence.Switch_DescentToLandingZone(false)		
						
						end
						s10070_enemy03.SwitchAttackToHoveringHeli(true)	
					end
				},
				
				{
					msg = "Damage",
					sender = "SupportHeli",
					func = function ( arg0, arg1, arg2 )
						local gameObjectId = { type="TppSahelan2", index=0 }
						if arg2 == gameObjectId then
							Fox.Log("!!!!! SupportHeli Damaged from Sahelan !!!!!")
							
							if this.CheckDistancePlayerToHeli() > RANGE_HELI_TO_PLAYER_CHECK then
								this.SwitchAntiSahelanMode( true )	
								s10070_sequence.Switch_DescentToLandingZone(false)		
							end
							mvars.HeliDamageCount = mvars.HeliDamageCount + 1
							if mvars.HeliDamageCount > HELI_DAMAGE_COUNT_MAX then
								this.SwitchAntiSahelanMode( false )		
								s10070_enemy03.SwitchAttackToHoveringHeli(false)	
								
								this.WithdrawalSupportHeli()
								TppRadio.Play("s0070_rtrg0125", { delayTime = "short", isEnqueue = true } ) 
								mvars.HeliDamageCount = 0
							end
						end
					end
				},
				
				{
					msg = "SahelanVulcunStartToHeli",	sender = "Sahelanthropus",
					func = function ( arg0, arg1 )
						Fox.Log("!!!!! SahelanVulcunStartToHeli !!!!!")
						
						if mvars.isSahelanAttackHeli1 == false and this.CheckDistancePlayerToHeli() > RANGE_HELI_TO_PLAYER_CHECK then
							mvars.isSahelanAttackHeli1 = true
							
							local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
							GameObject.SendCommand(gameObjectId, { id="EnablePullOut" })	
							
						
							this.SwitchAntiSahelanMode( true )	
							
							s10070_enemy03.ResetRVPosToSahelan()
							TppRadio.Play("s0070_rtrg0123", { delayTime = "mid", isEnqueue = true } ) 
						
						else
							mvars.isSahelanAttackHeli2 = true
							
						
						
						
						end
					end
				},
				
				{
					msg = "SahelanVulcunStopToHeli",	sender = "Sahelanthropus",
					func = function ( arg0, arg1 )
						Fox.Log("!!!!! SahelanVulcunStopToHeli !!!!!")
					
					
						
						if mvars.isSahelanAttackHeli2 then
							
							local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
							GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })	
							mvars.isSahelanAttackHeli2 = false
						end
					end
				},
				
				{
					msg = "SahelanChangePhase", sender = "Sahelanthropus",
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10070_sequence:SahelanChangePhase !!!!!")
						local sahelanPhase = arg1
						
						if sahelanPhase == TppSahelan2.SAHELAN2_PHASE_ALERT then
							
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10070_sahelan_al")
							s10070_sequence.Switch_DescentToLandingZone(false)		
							s10070_enemy03.SwitchAttackToHoveringHeli(false)	

							
							if this.CheckHeliStatusOnLZ() and svars.isRideEscapeHeli == false and mvars.isPlayerRideOnHeli == false and mvars.isSahelanEvasion == false and mvars.isPlayerOnLZ == false then
								
								
								this.SwitchAntiSahelanMode( true )	
								
								
								TppRadio.Play("f1000_rtrg0800")		
								
							elseif mvars.isSahelan1stAlert == true then
								TppRadio.Play("f1000_rtrg0800")		
							end
							
							s10070_enemy03.CountSahelanCounter()
							mvars.isSahelanAlert = true
							mvars.isSahelan1stAlert = true		

						
						elseif sahelanPhase == TppSahelan2.SAHELAN2_PHASE_CAUTION then

							if mvars.isSahelanAlert then			
								mvars.isSahelanEvasion = true
								
								TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10070_sahelan_ev")
								TppRadio.Play("s0070_rtrg0115", { delayTime = "long", isEnqueue = true } )	

								this.SwitchAntiSahelanMode( false )	
								
								if mvars.isSahelanAttackHeli1 then
									mvars.isSahelanAttackHeli1 = false
									mvars.isSahelanAttackHeli2 = false
								end
							else
								
								TppRadio.Play("s0070_rtrg0114")		
							end
						
						elseif sahelanPhase == TppSahelan2.SAHELAN2_PHASE_SNEAK then
							
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10070_sahelan_sn")

							if mvars.isSahelanEvasion then			
								
								if mvars.isSahelanStopped == false then
									TppRadio.Play("f1000_rtrg0900", { delayTime = "long", isEnqueue = true } )		
								end
								mvars.isSahelanAlert = false
								mvars.isSahelanEvasion = false
								mvars.isCantLandingRadio = false
							end
							
							if this.CheckHeliStatusOnExit() then
								TppRadio.Play("f1000_rtrg3160", { delayTime = "short", isEnqueue = true } ) 
								mvars.is1stHeliRadio = true
							else
								local aiState = GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="GetAiState" } )
								if aiState ~= Fox.StrCode32("Landing") or aiState ~= Fox.StrCode32("Descent") then
									TppRadio.Play("s0070_rtrg0270", { delayTime = "short", isEnqueue = true } ) 
								end
							end

							
							if mvars.isPlayerOnLZ and this.CheckHeliStatusOnLZ() then
								this.CheckHeliLanding()
							end

						else
							

						end
					end,
				},
				
				{
					msg = "SahelanStopped", sender = "Sahelanthropus",
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10070_sequence:SahelanStopped !!!!!")
						mvars.isSahelanStopped = true
						TppRadio.Play("f1000_rtrg1650", { delayTime = "short", isEnqueue = true } )
					
					end,
				},
				
				{
					msg = "SahelanPatrolMissile", sender = "Sahelanthropus",
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10070_sequence:SahelanPatrolMissile !!!!!")
						TppRadio.Play("s0070_rtrg0116", { delayTime = "long", isEnqueue = true } )	
					end,
				},
				nil
			},
			Trap = {
				{
					
					msg = "Enter",	sender = "trap_sovietEnemyHeliMove",
					func = function ()
						if this.CheckHeliStatusOnExit() and mvars.is1stHeliRadio == false then
							mvars.is1stHeliRadio = true
							TppRadio.Play("f1000_rtrg3160", { delayTime = "short", isEnqueue = true } ) 
							TppRadio.Play("s0070_rtrg0113", { delayTime = "short", isEnqueue = true } ) 
						end
					end
				},
				{
					
					msg = "Enter",	sender = "trap_shln_lzs_sovietBase_S_0000",
					func = function ()
						Fox.Log("s10070_mission trap_shln_lzs_sovietBase_S_0000!!")
						mvars.isPlayerOnLZ = true
						local currentLZName = this.GetCurrentLZName()
						if currentLZName == StrCode32("lzs_sovietBase_S_0000") then
							this.SwitchAntiSahelanMode( false )	

							
							if this.CheckHeliStatusOnLZ() then
								
								this.CheckHeliLanding()
							else
								
								GkEventTimerManager.Stop( "Timer_LandingCheck" )
								GkEventTimerManager.Start( "Timer_LandingCheck", TIMER_LANDING_CHECK )
							end
						elseif currentLZName == StrCode32("lzs_sovietSouth_W_0000") then
							

						else
							
							if this.CheckHeliStatusOnExit() then
								TppRadio.Play("f1000_rtrg3160", { delayTime = "short", isEnqueue = true } ) 
							end
						end
						mvars.currentRVPoint = RV02	
					end
				},
				{
					msg = "Exit",	sender = "trap_shln_lzs_sovietBase_S_0000",
					func = function ()
						mvars.isPlayerOnLZ = false
						GkEventTimerManager.Stop( "Timer_LandingCheck" )
						local phase = this.GetSahelanPhase()
						if phase == TppSahelan2.SAHELAN2_PHASE_ALERT and this.CheckHeliStatusJustOnLZ() then
							this.CallSupportHeliToRV( RV02 )
							TppRadio.Play("s0070_rtrg0130")
						end
					end
				},
				{
					
					msg = "Enter",	sender = "trap_shln_lzs_sovietSouth_W_0000",
					func = function ()
						Fox.Log("s10070_mission trap_shln_lzs_sovietSouth_W_0000!!")
						mvars.isPlayerOnLZ = true
						local currentLZName = this.GetCurrentLZName()
						if currentLZName == StrCode32("lzs_sovietSouth_W_0000") then
							this.SwitchAntiSahelanMode( false )	
							
							if this.CheckHeliStatusOnLZ() then
								
								this.CheckHeliLanding()
							else
								
								GkEventTimerManager.Stop( "Timer_LandingCheck" )
								GkEventTimerManager.Start( "Timer_LandingCheck", TIMER_LANDING_CHECK )
							end
						elseif currentLZName == StrCode32("lzs_sovietBase_S_0000") then
							

						else
							
							if this.CheckHeliStatusOnExit() then
								TppRadio.Play("f1000_rtrg3160", { delayTime = "short", isEnqueue = true } ) 
							end
						end
						mvars.currentRVPoint = RV01	
					end
				},
				{
					msg = "Exit",	sender = "trap_shln_lzs_sovietSouth_W_0000",
					func = function ()
						mvars.isPlayerOnLZ = false
						GkEventTimerManager.Stop( "Timer_LandingCheck" )
						local phase = this.GetSahelanPhase()
						if phase == TppSahelan2.SAHELAN2_PHASE_ALERT and this.CheckHeliStatusJustOnLZ() then
							this.CallSupportHeliToRV( RV01 )
							TppRadio.Play("s0070_rtrg0130")
						end
					end
				},
				{
					
					
					msg = "Enter",	sender = "trap_shln_area0010",
					func = function ()
						mvars.isPlayerInsovietBase = true
						
					
					end
				},
				{
					msg = "Exit",	sender = "trap_shln_area0010",
					func = function ()
						mvars.isPlayerInsovietBase = false
						
						if this.CheckHeliStatusOnLZ() then
							
						
						end
					end
				},
			},
			Timer = {
				
				{
					msg = "Finish",	sender = "Timer_radio_HurryUp",
					func = function ()
						Fox.Log("*** Finish::Timer_radio_HurryUp ***")
						TppRadio.Play("s0070_rtrg0150")
					end
				},
				
				{
					msg = "Finish",	sender = "Timer_CallHeliGuide",
					func = function ()
						if this.CheckHeliStatusOnExit() and mvars.is1stHeliRadio == false then
							Fox.Log("*** Finish::Timer_CallHeliGuide ***")
							mvars.is1stHeliRadio = true
						
							TppRadio.Play("s0070_rtrg0113", { delayTime = "short", isEnqueue = true } ) 
						
						elseif mvars.is1stHeliCall == false then
							
						
							TppRadio.Play("s0070_rtrg0113", { delayTime = "short", isEnqueue = true } ) 
						
						end
					end
				},
				
				{
					msg = "Finish",	sender = "Timer_LandingCheck",
					func = function ()
						if mvars.isPlayerOnLZ then
							this.CheckHeliLanding()
						end
					end
				},
			},
			Radio = {
				{
					
					msg = "Finish",	sender = "s0070_rtrg0110",
					func = function ()
						Fox.Log("s10070_mission Radio s0070_rtrg0110 END!!")
						
					
					end
				},
			},
			Terminal = {
				{
					msg = "MbDvcActCallRescueHeli",
					func = function( markerId, safety )
						mvars.is1stHeliCall = true
						if mvars.isSahelanAttackHeli1 == true or mvars.isSahelanAttackHeli2 == true then
							Fox.Log("**** MbDvcActCallRescueHeli ****")
							this.SwitchAntiSahelanMode( false )	
						end
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function()

		
		s10070_enemy03.SetSahelanType()

		
		Fox.Log("*** s10070_sequence:Set Sahelan BGM ***")
		TppSound.SetSceneBGM( "bgm_sahelan_01" )

		
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10070_sahelan_al")

		
		TppMission.UpdateObjective{
			radio = {
				radioGroups = { "s0070_rtrg0110", },	
				radioOptions = { delayTime = "short", playDebug = false },
			},
			objectives = { "subGoal_rideHeli", "rv_01", },
		}

		
		TppMarker.Enable( TARGET_HUEY, 0, "defend", "map_and_world_only_icon", 0, true, false )
		TppUiCommand.RegisterIconUniqueInformation{ markerId = GameObject.GetGameObjectId(TARGET_HUEY), langId = "marker_chara_huey" }
		this.UnlockedHuey()	

		
		TppMarker.Enable( "Sahelanthropus", 0, "attack", "map_and_world_only_icon", 0, false, false )

		
		this.SwitchSovietBaseHungerDoor( false )

		
		this.LockAutoDoor_sovietBase()

		
		this.SetUpHueyLife()
		this.SetDamageRateHuey()

		
		TppRadio.SetOptionalRadio("Set_s0070_oprg0080")	
		
		TppRadio.EnableCommonOptionalRadio(false)

		
		TppRadio.ChangeIntelRadio( s10070_radio.intelRadioList_AfterHueyDemo )

		
		TppHelicopter.SetDisableLandingZone{ landingZoneName = RV_ESCAPE }

		
		TppLandingZone.DisableUnlockLandingZoneOnMission(true)
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_sovietBase_E0000|lz_sovietBase_E_0000" }	
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_powerPlant_E0000|lz_powerPlant_E_0000" }

		
		this.LandingZoneWaitHeight( HELI_WAIT_HIGHT_SAHELAN )
		
		this.SetLandingZnoeDoor()
		
		TppSound.SkipDecendingLandingZoneJingle()
		TppSound.SkipDecendingLandingZoneWithOutCanMissionClearJingle()

		
		local rvName = StrCode32(RV01)
		s10070_enemy03.SetRVPosToSahelanbyName( rvName )
		this.CallSupportHeliToRV( RV01 )

		
	

		
		GkEventTimerManager.Stop( "Timer_CallHeliGuide" )	
		GkEventTimerManager.Start( "Timer_CallHeliGuide", 25 )

		
		s10070_enemy03.ResetSahelanCounter()

		
		TppWeather.SetWeatherProbabilitiesAfghNoSandStorm()

		
		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE

		
		this.UpdateMissionZone()

		
		TppCheckPoint.Disable{ baseName = { "sovietBase", "sovietSouth", } }

		
		TppMission.StartBossBattle()

		GkEventTimerManager.Stop( "HueyFearTimer" )

	end,

	OnLeave = function ()
	end,

	
	FuncPlayerRideOnHeli = function()
		Fox.Log("###########s10070_sequenceLog:  RideHelicopter!!  ###########")
		local flag = svars.isRideOnHeli_Huey
		mvars.isPlayerRideOnHeli = true

		if flag == true then
			
			Fox.Log(" RideHelicopter : Huey is Here!!!")
			mvars.vsHeliSeqLZ = this.GetCurrentLZName()	
			svars.isRideEscapeHeli = true
			GkEventTimerManager.Stop( "Timer_radio_HurryUp" )
			TppSequence.SetNextSequence("Seq_Game_ShootSahelan")
		else
			
			Fox.Log(" RideHelicopter : Huey is Not Here...")
			TppRadio.Play("s0070_rtrg0160")
			local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
			GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })					
		end
	end,

	
	FuncPlayerRideOnHeliWithHuman = function(playerId,gameObjectId,arg2,arg3)

		Fox.Log("###########s10070_sequenceLog:  RideHelicopterWithHuman!!  ###########")
		local hueyId = GameObject.GetGameObjectId(TARGET_HUEY)
		mvars.isPlayerRideOnHeli = true

		if gameObjectId == hueyId then
			
			Fox.Log(" RideHelicopterWith...Huey!!!")

			mvars.vsHeliSeqLZ = this.GetCurrentLZName()	
			svars.isRideEscapeHeli = true
			GkEventTimerManager.Stop( "Timer_radio_HurryUp" )
			this.SwitchAntiSahelanMode( false )	
			TppSequence.SetNextSequence("Seq_Game_ShootSahelan")

		else
			
			Fox.Log(" RideHelicopterWith...Others!!!")
			
			if svars.isRideOnHeli_Huey then
				mvars.vsHeliSeqLZ = this.GetCurrentLZName()	
				svars.isRideEscapeHeli = true
				GkEventTimerManager.Stop( "Timer_radio_HurryUp" )
				TppSequence.SetNextSequence("Seq_Game_ShootSahelan")
			else
				
				Fox.Log(" RideHelicopter : Huey is Not Here...")
				TppRadio.Play("s0070_rtrg0160")
				local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
				GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })					
			end
		end
	end,

}


sequences.Seq_Game_ShootSahelan = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Timer = {
				
				{
					msg = "Finish",	sender = "ShootSahelan_INIT",
					func = function ()
						Fox.Log("*** Timer ShootSahelan_INIT ***")
						
						s10070_enemy03.SetVsHeliSeqStart( mvars.vsHeliSeqLZ )
						
						
					end
				},
				
				{
					msg = "Finish",	sender = "ShootSahelan_START",
					func = function ()
						Fox.Log("*** Timer ShootSahelan_START ***")

						
						TppMission.UpdateObjective{
							radio = {
								radioGroups = { "s0070_rtrg0170", },	
								radioOptions = { delayTime = "short", playDebug = false },
							},
							objectives = { "shoot_sahelan", },
						}

						
						GkEventTimerManager.Start( "ShootSahelan_STOP", TIMER_SHOOTSAHEKAN_STOP )

					end
				},
				
				{
					msg = "Finish",	sender = "ShootSahelan_STOP",
					func = function ()
						Fox.Log("*** Timer ShootSahelan_STOP ***")

						s10070_enemy03.SetVsHeliSeqEnd()

						
						GkEventTimerManager.Start( "FinalAttack_START", TIMER_SHOOTSAHEKAN_FINAL_ATTACK_INIT )

					end
				},
				
				{
					msg = "Finish",	sender = "FinalAttack_START",
					func = function ()
						Fox.Log("*** Timer FinalAttack_START ***")

						
						s10070_enemy03.SetVsHeliSeqFinishAttack()

						
						GkEventTimerManager.Start( "FinalAttack_END", TIMER_SHOOTSAHEKAN_FINAL_ATTACK_RADIO )

					end
				},
				
				{
					msg = "Finish",	sender = "FinalAttack_END",
					func = function ()
						Fox.Log("*** Timer FinalAttack_END ***")
						TppRadio.Play("s0070_rtrg0180")
						s10070_enemy03.SetSahelanPartsLife(s10070_enemy03.sahelanLifeTable_Last)
					end
				},
				
				{
					msg = "Finish",	sender = "Timer_SahelanFallingDemo",
					func = function ()
						Fox.Log("*** Timer SahelanFallingDemo ***")
						
						this.ReserveMissionClear()
						TppMission.UpdateObjective{
							objectives = { "clear_missionTask_02" },	
						}
					end
				},
			},
			GameObject = {
				{
					msg = "RoutePoint2",
					sender = "SupportHeli",
					func = function (gameObjectId, routeId ,routeNode, messageId )
						Fox.Log("*** " .. tostring(gameObjectId) .. " ::RouteChangeGameObjectId ***")
						if messageId == StrCode32("ShootEventEnd") then
							
							
						

						

						end
					end
				},
				
				{
					msg = "SahelanAttackedToHeli", sender = "Sahelanthropus",
					func = function( arg0, arg1 )
						if mvars.deadSahelan == false then
							Fox.Log("!!!!! s10070_sequence:SahelanAttackedToHeli !!!!!")
							
							local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
							GameObject.SendCommand(gameObjectId, { id="SetLife", life=0 })
						end
					end,
				},
				
				{
					msg = "Dead", sender = "Sahelanthropus",
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10070_sequence:Dead !!!!!")
						
					
						
						mvars.deadSahelan = true
					end,
				},
				
				{
					msg = "SahelanAllDead", sender = "Sahelanthropus",
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10070_sequence:SahelanAllDead !!!!!")
						if mvars.alldeadSahelan == false then
							
							TppMission.UpdateObjective{
								objectives = { "announce_rescue_target", "announce_rescue_complete", },
							}
							TppHero.AddTargetLifesavingHeroicPoint( false, true )	
							
							GkEventTimerManager.Start( "Timer_SahelanFallingDemo", TIMER_ABOUT_SAHELAN_FALLDEMO )
							mvars.alldeadSahelan = true
						end

					end,
				},
				
				{
					msg = "LostControl",
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10070_sequence:LostControl !!!!!")
						TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.HELICOPTER_DESTROYED, TppDefine.GAME_OVER_RADIO.PLAYER_DEAD )
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function()
		
		s10070_sequence.SetDisableDamageHuey( true )

		
	

		
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="EnablePullOut" })					
		GameObject.SendCommand(gameObjectId, { id="SetTakeOffWaitTime", time = 0 })		

		
		GkEventTimerManager.Start( "ShootSahelan_INIT", TIMER_SHOOTSAHEKAN_INIT )
		
		GkEventTimerManager.Start( "ShootSahelan_START", TIMER_SHOOTSAHEKAN_OBJECTIVE )

		
		TppRadio.SetOptionalRadio("Set_s0070_oprg0100")	

	end,

	OnLeave = function ()
		
		TppMission.FinishBossBattle()
	end,
}


sequences.Seq_Demo_SahelanFalling = {

	OnEnter = function()
		
		if mvars.vsHeliSeqLZ == StrCode32("lzs_sovietBase_S_0000") then
			StageBlockCurrentPositionSetter.SetEnable( true )
			StageBlockCurrentPositionSetter.SetPosition( -1992.968, -1225.625 )	
		end

		TppSound.StopSceneBGM()

		this.SwitchEnebleGameHeliOnDemo( true )			
		
		
		local func = function()
			Fox.Log("##### SahelanFalling Demo End #####")
			
			Player.SetPause()
			this.SwitchEnebleGameHeliOnDemo( false )			
			TppMission.MissionGameEnd()
		end
		s10070_demo.SahelanFalling(func)
	end,

	OnLeave = function ()
		
		StageBlockCurrentPositionSetter.SetEnable( false )
		
		Player.UnSetPause()
	end,
}


sequences.Seq_Demo_MotherBase = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Timer = {
				{ 	msg = "Finish",sender = "TelopTimer",
					func = function()
						
						TppUiCommand.RegistInfoTypingText( "lang",	4, "area_demo_mb" )
						TppUiCommand.RegistInfoTypingText( "lang",	5, "area_demo_room101" )
						TppUiCommand.ShowInfoTypingText()
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil
			},
			Demo = {
				{ 	msg = "Play",
					func = function()
						GkEventTimerManager.Start( "TelopTimer", 2 )
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				{	
					msg = "Skip",
					func = function()
						GkEventTimerManager.Stop( "TelopTimer" )
						TppUiCommand.HideInfoTypingText()
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil
			},
			nil
		}
	end,

	OnEnter = function()
		
		TppClock.SetTime( TIME_MOTHER_BASE_DEMO )

		
		TppPlayer.Refresh()

		local func = function()
			TppMission.ShowMissionReward()
		end
		s10070_demo.MotherBase(func)
	end,

	OnLeave = function ()
		
		
		TppUiCommand.HideInfoTypingText()
	end,
}



return this
