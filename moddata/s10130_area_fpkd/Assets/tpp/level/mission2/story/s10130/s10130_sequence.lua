local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

this.DEBUG_strCode32List = {
	"StartedCombat",
	"trap_ApproachIntelAtinMansion",
	"trap_ApproachIntelAtinMansion_OnAlert",
	"Intel_inMansion",
	"GetIntel",
	"CheckEventDoorNgIcon",
	"StartEventDoorPicking",
	"Finish",
	"StartedCombat",
	"Unconscious",
	"Dead",
	"Fulton",
	"Enter",
	"Exit",
	"RoutePoint2",
}








this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PLACED_LOCATOR_COUNT = 16


this.MAX_PICKABLE_LOCATOR_COUNT = 25






local TARGET_HOSTAGE_NAME = "CodeTalker"


local PARASITE000		= "wmu_lab_0000"
local PARASITE001		= "wmu_lab_0001"
local PARASITE002		= "wmu_lab_0002"
local PARASITE003		= "wmu_lab_0003"


local VEHICLE_NAME		= "veh_guard01_0000"


local TRAP_NAME = {

	
	SNEAK_BGM_START				= "trap_CamoParasiteSNBGMStart",
	SNEAK_BGM_RESTART			= "trap_CamoParasiteSNBGMRestart",
	BGM_STOP					= "trap_CamoParasiteBGMStop",
	CODETALKER_BGM_START		= "trap_CodetalkerBGMStart",

	
	ROUTECHANGE002				= "trap_CamoParasiteRouteChangeRestart",

	
	MODECHANGE_LONG				= "trap_CamoParasiteModeChangeLong",
	MODECHANGE_SHORT			= "trap_CamoParasiteModeChangeShort",

	
	WATERFALLSHIFT				= "trap_WaterFallShift",
	NORMALSHIFT					= "trap_NormalShift",

	
	CHASEWEST					= "trap_CamoParasiteChaseWest",
	CHASESOUTH					= "trap_CamoParasiteChaseSouth",
	RETURNWEST					= "trap_CamoParasiteReturnWest",
	RETURNSOUTH					= "trap_CamoParasiteReturnSouth",
	ZOMBIE						= "trap_ArrivalZombie",
	RESTRICTION_RELEASE			= "trap_ActionRestrictionRelease",

	
	IN_MANSION					= "trap_ApproachIntelAtinMansion",
	IN_MANSION_ALERT			= "trap_ApproachIntelAtinMansion_OnAlert",
	IN_MANSION_MARKER			= "trap_intelMarkLabMansion",

	
	LABINROOM					= "trap_LabInRoom",

	
	RTRG2020					= "trap_s0130_rtrg2020",
	RTRG6020					= "trap_s0130_rtrg6020",
	CPRADIO01					= "trap_CPRadio01",

	
	DEMOBLOCK01					= "trap_s0130_d01Load",
	DEMOBLOCK02					= "trap_s0130_d02Load",
	DEMOBLOCK03					= "trap_s0130_d03Load",

	
	CODETALKER_DEMO000			= "GeoTrap_CodeTalkerDemoStart",
	CODETALKER_DEMO001			= "trap_CodeTalkerDemo_0001",
	PARASITE_DEMO000			= "trap_ArrivalParasiteDemo",

}


local INTEL_SENDER_NAME		= {
	IN_MANSION					= "Intel_inMansion",	
}

local MARKER_NAME = {
	INTEL_LAB_MANSION	= "s10130_marker_intelFile_Mansion",
}



local PHOTO_NAME = {
	CODETALKER				= 10,	
	LAB						= 20,	
}


local SUBGOAL_ID = {
	START					= 0,
	ESCAPE					= 1,
	RIDEHELI				= 2,
}


local LARGE_IDENTIFIER_ID	= "mafr_lab_StaticModelControl"


local MAFR_LAB_SHUTTER01 = "mafr_door005_vrtn006_0001_isIsolated"
local MAFR_LAB_SHUTTER02 = "mafr_door005_vrtn006_0001_isIsolated0000"
local MAFR_LAB_SHUTTER03 = "mafr_door005_vrtn006_0002_isIsolated"
local MAFR_LAB_SHUTTER04 = "mafr_door005_vrtn006_0002_isIsolated0000"


local MISSION_IDENTIFIER_ID	= "s10130_StaticModelControl"


local S10130_COAT = "cdt0_coat1_sta_isIsolated"



local PACKFILE_NAME = {
	ENEMY_ESCAPE_A	=	"",			
	ENEMY_ESCAPE_B	=	"",			
}


local GIMMICK_NAME = {
	DOOR001					= "mafr_gate001_door001_gim_n0000|srt_mafr_gate001_door001",	
	CANDLE001				= "mafr_cndl001_gim_i0000|TppSharedGimmick_mafr_cndl001",	
	CANDLE002				= "mafr_cndl001_vrtn001_gim_i0000|TppSharedGimmick_mafr_cndl001_vrtn001",	
	CANDLE003				= "mafr_cndl001_vrtn002_gim_i0000|TppSharedGimmick_mafr_cndl001_vrtn002",	
	CANDLE004				= "mafr_cndl001_vrtn004_gim_i0000|TppSharedGimmick_mafr_cndl001_vrtn004",	
	WBOX001					= "mafr_wdbx001_vrtn001_gim_i0000|TppSharedGimmick_mafr_wdbx001_vrtn001",	
	WBOX002					= "mafr_wdbx001_vrtn004_gim_i0000|TppSharedGimmick_mafr_wdbx001_vrtn004",	
	BARREL001				= "mafr_brrl001_gim_i0000|TppSharedGimmick_mafr_brrl001",	
	BARREL002				= "mafr_brrl001_brrl001_gim_i0000|TppSharedGimmick_mafr_brrl001_brrl001",	
}


local GIMMICK_PATH = {
	DOOR001					= "/Assets/tpp/level/location/mafr/block_large/lab/mafr_lab_asset_underground.fox2",	
	RESET_GIMMICK01			= "/Assets/tpp/level/location/mafr/block_large/lab/mafr_lab_light_underground.fox2",
	RESET_GIMMICK02			= "/Assets/tpp/level/location/mafr/block_large/lab/mafr_lab_asset.fox2",
	RESET_GIMMICK03			= "/Assets/tpp/level/location/mafr/block_large/lab/mafr_lab_asset_room.fox2",
}


local CHECK_ENEMY_POS01		= {2692.318, 162.6562, -2418.07} 
local CHECK_ENEMY_RANGE01		= 10	


local CHECK_ENEMY_POS02		= {2669.865, 173.9299, -2474.738} 
local CHECK_ENEMY_RANGE02		= 25	

this.NPC_ENTRY_POINT_SETTING = {
	[Fox.StrCode32("rts_drp_lab_S_0000")] = {
		[EntryBuddyType.VEHICLE] = { Vector3(2456.153, 70.319, -1192.765), TppMath.DegreeToRadian( 151 ) }, 
		[EntryBuddyType.BUDDY] = { Vector3(2435.610, 71.799, -1193.728), 163 }, 
	},
}








this.OnLoad = function()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Game_ParasiteBattle", 
		
		"Seq_Game_CodeTalkerMeetBefore", 
		
		"Seq_Demo_Brank",				
		"Seq_Demo_CodeTalker",
		
		"Seq_Game_Escape_A",
		
		"Seq_Game_Escape_B",
		
		"Seq_Demo_ClearDemo",
		
		"Seq_ToBeContinued",
		
		"Seq_Game_ParasiteCombat", 
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end


function this.ReserveMissionClear()
	
	if (svars.isRideOnHeli_CodeTalker == true) then
		Fox.Log("!!!!! s10130_sequence:CodeTalker Ride Heli Mission Clear!!!!!")
		TppMission.ReserveMissionClear{
			missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
			nextMissionId = 40020,
		}
	else
		Fox.Log("!!!!! s10130_sequence:CodeTalker Not Ride Heli Mission Abort!!!!!")
		TppMission.AbortForRideOnHelicopter{ isNoSave = true }
	end
end


function this.ReserveMissionClearLand()

	TppMission.ReserveMissionClear{
		missionClearType = TppDefine.MISSION_CLEAR_TYPE.ON_FOOT,
		nextMissionId = 40020,
	}

end





this.saveVarsList = {
	
	isArrivalParasiteDemo				= false,
	
	isAllKillParasite					= false,
	
	wmu_lab_0000Disablement				= false,
	wmu_lab_0001Disablement				= false,
	wmu_lab_0002Disablement				= false,
	wmu_lab_0003Disablement				= false,
	
	wmu_lab_0000Fulton					= false,
	wmu_lab_0001Fulton					= false,
	wmu_lab_0002Fulton					= false,
	wmu_lab_0003Fulton					= false,
	
	isParasiteSNBGMStart				= false,
	
	isParasiteALBGMStart				= false,
	
	isParasiteBGMStop					= false,
	
	isCodetalkerBGMStart				= false,
	
	isCodetalkerDemo001					= false,
	
	isParasiteRouteChange000			= false,
	isParasiteRouteChange001			= false,
	isParasiteRouteChange002			= false,
	
	isParasiteBattle					= false,
	
	isParasiteMarking					= false,
	
	isNearLab							= false,
	
	isLabInRoom							= false,
	
	isQuietFriend						= false,
	
	isOnGetIntel_AtinMansion			= false,
	
	isChaseWest							= false,
	isChaseSouth						= false,
	
	isTargetFound						= false,
	
	isCodeTalkerPlaceEstablishing		= false,
	
	isDoorPlaceEstablishing				= false,
	
	isCodeTalkerDamage					= false,
	
	isEnemyFound						= false,
	
	isDontPutCodeTalker					= false,
	
	isDistantCodeTalkerRadio			= false,
	
	isRideOnHeli_CodeTalker				= false,
	
	isParasiteMarkerOff					= false,

	
	isDemoDoor_Alert					= false,
	isDemoDoor_Enemy					= false,

	
	isArrivalZombie						= false,

	
	speech130_CTV010_01					= false,
	speech130_CTV010_02					= false,
	speech130_CTV010_03					= false,
	speech130_CTV010_04					= false,

	
	speech130_CTV010_05					= false,
	speech130_CTV010_06					= false,
	speech130_CTV010_07					= false,
	speech130_CTV010_08					= false,

	
	speech130_CTV020_01					= false,
	speech130_CTV020_02					= false,
	speech130_CTV020_03					= false,

	
	isCarryTalkStart01					= false,
	
	isCarryTalkStart02					= false,
	
	isCarryTalkStart03					= false,
	
	isCarryTalkStart04					= false,

	PreliminaryFlag01					= false,	
	PreliminaryFlag02					= false,	
	PreliminaryFlag03					= false,	
	PreliminaryFlag04					= false,	
	PreliminaryFlag05					= false,	
	PreliminaryFlag06					= false,	
	PreliminaryFlag07					= false,	
	PreliminaryFlag08					= false,	
	PreliminaryFlag09					= false,	
	PreliminaryFlag10					= false,	
	PreliminaryFlag11					= false,	
	PreliminaryFlag12					= false,	
	PreliminaryFlag13					= false,	
	PreliminaryFlag14					= false,	
	PreliminaryFlag15					= false,	
	PreliminaryFlag16					= false,	
	PreliminaryFlag17					= false,	
	PreliminaryFlag18					= false,	
	PreliminaryFlag19					= false,	
	PreliminaryFlag20					= false,	

	PreliminaryValue01					= 0,		
	PreliminaryValue02					= 0,		
	PreliminaryValue03					= 0,		
	PreliminaryValue04					= 0,		
	PreliminaryValue05					= 0,		
	PreliminaryValue06					= 0,		
	PreliminaryValue07					= 0,		
	PreliminaryValue08					= 0,		
	PreliminaryValue09					= 0,		
	PreliminaryValue10					= 0,		

	
	parasiteSquadMarkerFlag	= { name = "parasiteSquadMarkerFlag", type = TppScriptVars.TYPE_BOOL,  arraySize = 4, value = false, save = true, sync = true, wait = true, category = TppScriptVars.CATEGORY_RETRY },

}




this.checkPointList = {
	"CHK_MissionStart",				
	"CHK_ParasiteBattleEnd",		
	"CHK_CodeTalkerAfter",			
	"CHK_HeliDemoStart",			
	nil
}




this.baseList = {


	nil
}




this.longMonologueList = {
	"speech130_CTV010_01",
	"speech130_CTV010_02",
	"speech130_CTV010_03",
	"speech130_CTV010_04",
	"speech130_CTV010_05",
	"speech130_CTV010_06",
	"speech130_CTV010_07",
	"speech130_CTV010_08",
	"speech130_CTV020_01",
	"speech130_CTV020_02",
	"speech130_CTV020_03",
}

this.longMonologueList01 = {
	"speech130_CTV010_01",
	"speech130_CTV010_02",
	"speech130_CTV010_03",
	"speech130_CTV010_04",
	"speech130_CTV010_05",
	"speech130_CTV010_06",
	"speech130_CTV010_07",
	"speech130_CTV010_08",
}

this.longMonologueList02 = {
	"speech130_CTV020_01",
	"speech130_CTV020_02",
	"speech130_CTV020_03",
}

this.longMonologueList03 = {
	"speech130_CTV020_01",
	"speech130_CTV020_02",
	"speech130_CTV020_03",
}







this.missionObjectiveDefine = {
	
	default_area_lab = {
		gameObjectName = "10130_marker_lab",
		visibleArea = 4,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
		mapRadioName = "s0130_mprg2010",
		subGoalId = SUBGOAL_ID.START,
	},
	
	
	default_area_codetalker = {
		gameObjectName = "10130_marker_codetalker",
		visibleArea = 0,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
		setImportant = true,
		langId = "marker_info_mission_target",
	},
	default_codetalker = {
	},
	
	
	default_labdoor01 = {
		gameObjectName = "10130_marker_labdoor01",
		visibleArea = 0,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
		goalType = "none",
		viewType = "map_only_icon",
		langId = "marker_exit",
	},
	default_labdoor02 = {
		gameObjectName = "10130_marker_labdoor02",
		visibleArea = 0,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
		goalType = "none",
		viewType = "map_only_icon",
		langId = "marker_exit",
	},
	default_labdoor03 = {
		gameObjectName = "10130_marker_labdoor03",
		visibleArea = 0,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
		goalType = "none",
		viewType = "map_only_icon",
		langId = "marker_exit",
	},
	default_labdoor04 = {
		gameObjectName = "10130_marker_labdoor04",
		visibleArea = 0,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
		goalType = "none",
		viewType = "map_only_icon",
		langId = "marker_exit",
	},
	default_labdoor05 = {
		gameObjectName = "10130_marker_labdoor05",
		visibleArea = 0,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
		goalType = "none",
		viewType = "map_only_icon",
		langId = "marker_exit",
	},
	default_inroom = {
	},
	
	intelFile_lab_Mansion = {
		gameObjectName = MARKER_NAME.INTEL_LAB_MANSION,
	},
	
	intelFile_lab_Mansion_get = {
	},
	
	
	default_photo_codetalker = {
		photoId	= PHOTO_NAME.CODETALKER,
		addFirst 		= true,
		photoRadioName = "s0130_mirg0010",
	},
	default_photo_lab = {
		photoId	= PHOTO_NAME.LAB,
		photoRadioName = "s0130_mirg0020",
	},
	
	
	target_area_cp = {
		targetBgmCp = "mafr_lab_cp",
	},
	
	
	Intermediate_target01 = {
		subGoalId = SUBGOAL_ID.START,
	},
	
	
	
	
	default_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = false },
	},
	
	default_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false },
	},
	
	default_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_05 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_06 = {
		missionTask = { taskNo = 5, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	
	clear_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = true },
	},
	
	clear_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = true },
	},
	
	clear_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, },
	},
	
	clear_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = true },
	},
	
	clear_missionTask_05 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = true },
	},
	
	clear_missionTask_06 = {
		missionTask = { taskNo = 5, isNew = true, isComplete = true },
	},
	
	
	rv_missionClear = {
		photoId	= PHOTO_NAME.CODETALKER,
		addFirst = true,
		subGoalId = SUBGOAL_ID.ESCAPE,
	},
	rv_missionClear01 = {
		photoId	= PHOTO_NAME.LAB,
	},
	
	
	announce_recoverTarget = {
		announceLog = "recoverTarget",
	},
	announce_achieveAllObjectives = {
		announceLog = "achieveAllObjectives",
	},
	
	
	Intermediate_target02 = {
		subGoalId = SUBGOAL_ID.RIDEHELI,
	},
}











this.missionObjectiveTree = {
	rv_missionClear = {
		default_codetalker = {
			default_area_codetalker = {
				default_area_lab = {},
			},
			default_inroom = {
				default_labdoor01 = {},
				default_labdoor02 = {},
				default_labdoor03 = {},
				default_labdoor04 = {},
				default_labdoor05 = {},
			},
		},
		Intermediate_target01 = {},
		default_photo_codetalker = {},
		default_photo_lab = {},
		target_area_cp = {},
	},
	rv_missionClear01 = {
	},
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
	intelFile_lab_Mansion_get = {
		intelFile_lab_Mansion = {
		},
	},
	
	announce_recoverTarget = {
	},
	announce_achieveAllObjectives = {
	},
	Intermediate_target02 = {
	},
}


this.missionObjectiveEnum = Tpp.Enum{
	"default_area_lab",
	"default_area_codetalker",
	"default_codetalker",
	"default_labdoor01",
	"default_labdoor02",
	"default_labdoor03",
	"default_labdoor04",
	"default_labdoor05",
	"default_inroom",
	"default_photo_codetalker",
	"default_photo_lab",
	"target_area_cp",
	"Intermediate_target01",
	"rv_missionClear",
	"rv_missionClear01",
	"clear_missionTask_01",
	"default_missionTask_01",
	"clear_missionTask_02",
	"default_missionTask_02",
	"clear_missionTask_03",
	"default_missionTask_03",
	"clear_missionTask_04",
	"default_missionTask_04",
	"clear_missionTask_05",
	"default_missionTask_05",
	"clear_missionTask_06",
	"default_missionTask_06",
	"intelFile_lab_Mansion_get",
	"intelFile_lab_Mansion",
	"announce_recoverTarget",
	"announce_achieveAllObjectives",
	"Intermediate_target02",
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 2 },
	},
	second = {
		missionTask = { taskNo = 3 },
		pointList = {
			5000,
			10000,
			15000,
			20000,
		},	}
}


this.missionStartPosition = {
	
	helicopterRouteList = {
		"rts_drp_lab_S_0000",
	},
	
	orderBoxList = {
		"box_s10130_00",
	},
}








function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	
	
	mvars.currentspeech130					= ""

	
	TppRatBird.EnableRat()

	
	TppMission.RegisterMissionSystemCallback{
		OnSetMissionFinalScore = function( missionClearType )
			Fox.Log("!!!! s10130_mission.OnSetMissionFinalScore !!!!")
			
			if vars.playerVehicleGameObjectId ~= NULL_ID then
				if vars.playerVehicleGameObjectId == GameObject.GetGameObjectId( "TppVehicle2" , VEHICLE_NAME ) then
					Fox.Log("##** OnEstablishMissionClear VEHICLE_NAME ####")
					
					TppMission.UpdateObjective{
						objectives = { "clear_missionTask_06" , },
					}
				end
			end

			Fox.Log("!!!! s10130_mission.clear_missionTask_03 check !!!! isCodeTalkerDamage = " .. tostring(svars.isCodeTalkerDamage) )
			if svars.isCodeTalkerDamage == false then
				
				TppResult.AcquireSpecialBonus{
					first = { isComplete = true },
				}
			end
			
			
			if( svars.PreliminaryValue01 > 0 )then
				if ( svars.PreliminaryValue01 > 4 )then
					svars.PreliminaryValue01 = 4
				end
				for i=1, svars.PreliminaryValue01 do
					TppResult.AcquireSpecialBonus{	second = {  isComplete = true, pointIndex = i },	}
				end
			end
		end,
		OnDisappearGameEndAnnounceLog = function()
			TppDemo.ReserveInTheBackGround{ demoName = "ClearDemo" }
			TppMission.ShowMissionResult()
		end,
		OnEndMissionReward = function()
			Fox.Log("!!!! s10130_mission.OnEndMissionReward !!!!")
			
			
			TppMission.Reload{
				isNoFade = false,												
				showLoadingTips = false,										
				missionPackLabelName = "CodeTalkerClearDemo",					
				OnEndFadeOut = function()										
					TppSequence.ReserveNextSequence( "Seq_Demo_ClearDemo" ,{ isExecMissionClear = true })		
					
					TppMission.UpdateCheckPoint{
						checkPoint	= "CHK_HeliDemoStart",
						ignoreAlert	= true,
						permitHelicopter = true,
					}
				end,
			}
		end,
		OnEstablishMissionClear = function( missionClearType )
			Fox.Log("*** " .. missionClearType .. " OnEstablishMissionClear ***")

			s10130_radio.OnGameCleared()
			
			TppMission.UpdateObjective{
				objectives = { "announce_achieveAllObjectives" },
			}	
			
			TppMission.UpdateObjective{
				objectives = { "clear_missionTask_02", },
			}

			if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
				
				if not(svars.isRideOnHeli_CodeTalker) then
					TppHero.AddTargetLifesavingHeroicPoint( false, true )
				end
				
				TppPlayer.PlayMissionClearCamera()
				TppMission.MissionGameEnd{

					fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,
					delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
				}
				
			elseif missionClearType == TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER then
				TppMission.MissionGameEnd{}
			else
				TppMission.MissionGameEnd{ loadStartOnResult = true }
			end

			
			
			TppMotherBaseManagement.RemoveStaffsS10130()

		end,
		OnRecovered = function( gameObjectId )
			
			Fox.Log("##** OnRecovered_is_coming ####")
			if gameObjectId == GameObject.GetGameObjectId( "TppVehicle2" , VEHICLE_NAME ) then
				Fox.Log("##** OnRecovered VEHICLE_NAME ####")
				
				TppMission.UpdateObjective{
					objectives = { "clear_missionTask_06" , },
				}
			else
				Fox.Log("##** OnRecovered Not Target ####")
			end
		end,
		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,
		OnGameOver = this.OnGameOver,
		OnOutOfHotZoneMissionClear = this.ReserveMissionClearLand,
	}

	
	local indices = { {154, 114} }
	StageBlock.AddSmallBlockIndexForMessage(indices)

	
	local largeBlockNames = { "mafr_lab" }
	StageBlock.AddLargeBlockNameForMessage(largeBlockNames)

	
	TppMarker.SetUpSearchTarget{
		{
			gameObjectName = TARGET_HOSTAGE_NAME,
			gameObjectType = "TppCodeTalker2",
			messageName = TARGET_HOSTAGE_NAME,
			langId = "marker_chara_codetalker",
			skeletonName = "SKL_004_HEAD",
			func = this.TargetFound
		},
	}

end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	
	Fox.Log("#### s10130_sequence.SetAllStaffParam ####")
	TppEnemy.AssignUniqueStaffType{
		locaterName = "CodeTalker",
		uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.CODETALKER,
	}

	
	local gameObjectId = GameObject.GetGameObjectId( TARGET_HOSTAGE_NAME )
	local command = { id = "SetNoticeState", state = TppGameObject.HOSTAGE_NOTICE_STATE_FLEE }
	GameObject.SendCommand( gameObjectId, command )
end


this.OnEndMissionPrepareSequence = function ()

	
	if TppMission.IsMissionStart() then
		Fox.Log( "s10130_sequence Gimmick Restore!!!!!" )
		this.GimmickRestore()
	end

end



this.OnEstablishMissionClear = function( missionClearType )
	Fox.Log("!!!! s10130_mission.OnEstablishMissionClear !!!! missionClearType = " .. tostring(missionClearType) )

	
	TppMission.MissionGameEnd()

end


this.OnGameOver = function()

	
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
		
		TppPlayer.SetTargetDeadCamera{ gameObjectName = TARGET_HOSTAGE_NAME }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end
end

this.OnTerminate = function()
	Fox.Log("!!!! s10130_mission.OnTerminate !!!!")
	
	this.StartEnableActionForEvent()
end



this.GimmickRestore = function()
	
	Gimmick.ResetGimmick(
		TppGameObject.GAME_OBJECT_TYPE_DOOR,
		GIMMICK_NAME.DOOR001,GIMMICK_PATH.DOOR001 )
end


this.eventDoorSetting = function()

	local sequence = TppSequence.GetCurrentSequenceName()
	
	if ( sequence == "Seq_Game_ParasiteBattle" )	then
		Fox.Log("Event Door Setting ON")
		Gimmick.SetEventDoorLock( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , true , 0 )	
	elseif ( sequence == "Seq_Game_ParasiteCombat" )	then
		Fox.Log("Event Door Setting ON")
		Gimmick.SetEventDoorLock( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , true , 0 )	
	elseif ( sequence == "Seq_Game_CodeTalkerMeetBefore" )	then
		Fox.Log("Event Door Setting ON")
		Gimmick.SetEventDoorLock( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , true , 0 )	
	elseif ( sequence == "Seq_Game_Escape_A" )	then
		Fox.Log("Event Door Enable")
		Fox.Log("Event Door Setting OFF")
		Gimmick.SetEventDoorInvisible( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , false )	
		Gimmick.SetEventDoorLock( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , false , 0 )	
	elseif ( sequence == "Seq_Game_Escape_B" )	then
		Fox.Log("Event Door Enable")
		Fox.Log("Event Door Setting OFF")
		Gimmick.SetEventDoorInvisible( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , false )	
		Gimmick.SetEventDoorLock( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , false , 0 )	
	else
		Fox.Log("DemoSequence ... No Setting !!")
	end
end



this.LabShutterOff = function()
	TppDataUtility.SetVisibleDataFromIdentifier( LARGE_IDENTIFIER_ID, MAFR_LAB_SHUTTER01, false, true)
	TppDataUtility.SetVisibleDataFromIdentifier( LARGE_IDENTIFIER_ID, MAFR_LAB_SHUTTER02, false, true)
	TppDataUtility.SetVisibleDataFromIdentifier( LARGE_IDENTIFIER_ID, MAFR_LAB_SHUTTER03, false, true)
	TppDataUtility.SetVisibleDataFromIdentifier( LARGE_IDENTIFIER_ID, MAFR_LAB_SHUTTER04, false, true)
end


this.CoatOn = function()
	Fox.Log( "!!!! s10130_sequence.CoatOn !!!!" )
	TppDataUtility.SetVisibleDataFromIdentifier( MISSION_IDENTIFIER_ID, S10130_COAT, true, true)
end


this.CodeTalkerPlaceMark = function()
	svars.isCodeTalkerPlaceEstablishing	= true
	
	TppMission.UpdateObjective{
		radio = {
			radioGroups = { "s0130_rtrg2190", },	
			radioOptions = { delayTime = "short" },
		},
		objectives = { "default_area_codetalker",},
	}
end


this.DoorPlaceMark = function()
	svars.isDoorPlaceEstablishing	= true
	
	TppMission.UpdateObjective{
		radio = {
			radioGroups = { "s0130_rtrg2180", },
			radioOptions = { delayTime = "short" },
		},
		objectives = {
			"default_labdoor01",
			"default_labdoor02",
			"default_labdoor03",
			"default_labdoor04",
			"default_labdoor05",
		},
	}
end


this.EnemyMark = function()
	
	s10130_radio.GetIntelFile()

	
	s10130_enemy.EnemyMarkerSet( s10130_enemy.soldierDefine.mafr_lab_cp )

end


this.ParasiteDisablementEvaluate = function(gameObjectId,seq)
	Fox.Log( "!!!! s10130_sequence.ParasiteDisablementEvaluate !!!!" )
	Fox.Log( "!!!! s10130_sequence.Parasitegame ObjectId !!!!" .. gameObjectId )
	if GameObject.GetGameObjectId(PARASITE000) == gameObjectId then
		svars.wmu_lab_0000Disablement = true
		svars.PreliminaryValue01 = svars.PreliminaryValue01 + 1
	elseif GameObject.GetGameObjectId(PARASITE001) == gameObjectId then
		svars.wmu_lab_0001Disablement = true
		svars.PreliminaryValue01 = svars.PreliminaryValue01 + 1
	elseif GameObject.GetGameObjectId(PARASITE002) == gameObjectId then
		svars.wmu_lab_0002Disablement = true
		svars.PreliminaryValue01 = svars.PreliminaryValue01 + 1
	elseif GameObject.GetGameObjectId(PARASITE003) == gameObjectId then
		svars.wmu_lab_0003Disablement = true
		svars.PreliminaryValue01 = svars.PreliminaryValue01 + 1
	else
		Fox.Log( "!!!! Abnormal Parasite gameObjectId !!!!" )
	end
	
	if ((svars.wmu_lab_0000Disablement == true)and
		(svars.wmu_lab_0001Disablement == true)and
		(svars.wmu_lab_0002Disablement == true)and
		(svars.wmu_lab_0003Disablement == true)) then

		
		svars.PreliminaryFlag02	= false

		
		svars.isAllKillParasite = true

		
		GkEventTimerManager.Start("BgmStop", 4.0 )

		
		GkEventTimerManager.Start("AllKillParasiteRadio", 1.0 )

		
		s10130_enemy.CamoParasiteFogOff()

		
		WeatherManager.PauseNewWeatherChangeRandom(false)

		
		if seq == "Seq_Game_ParasiteCombat" then
			Fox.Log("!!!*** s10130_mission.All Kill CombatEnd Seq_Game_ParasiteCombat ***!!!")
			
			s10130_sound.BGMParasitesEd()
			
			GkEventTimerManager.Start("BgmChange", 5.0 )
		elseif seq == "Seq_Game_Escape_A" then
			Fox.Log("!!!*** s10130_mission.All Kill CombatEnd Seq_Game_Escape_A ***!!!")
			
			s10130_sound.BGMParasitesEd2()
			
			s10130_enemy.DiszombieEnemy()
			
			TppRadio.ChangeIntelRadio( s10130_radio.intelRadioListAfterZombie )
		else
			
			TppSound.StopSceneBGM()
		end
		
		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE
		
		
		TppRadio.ChangeIntelRadio( s10130_radio.intelRadioListDefeatedParasites )

	else
		Fox.Log( "!!!! s10130_sequence.ParasiteDisablementEvaluate Are still parasites !!!!" )
	end
end


this.FuncCheckCodeTalkerRange = function()
	Fox.Log("#### s10130_radio.DistantCodeTalker FuncCheckCodeTalkerRange ####")
	local gameObjectId = GameObject.GetGameObjectId( "TppCodeTalker2", TARGET_HOSTAGE_NAME )
	local command = {	id = "GetStatus",	}
	local actionStatus = GameObject.SendCommand( gameObjectId, command )

	GkEventTimerManager.Start( "checkCodeTalkerStatus", 30)

	
	if svars.isRideOnHeli_CodeTalker == false then
		Fox.Log("#### s10130_radio.DistantCodeTalker isRideOnHeli_CodeTalker = false ####")
		
		if actionStatus == TppGameObject.NPC_STATE_CARRIED then
			
			Fox.Log("#### s10130_radio.DistantCodeTalker actionStatus = NPC_STATE_CARRIED ####")
		else
			
			local isInRangeflag = GameObject.SendCommand( gameObjectId, {
				id="IsInRange",
				range = 20,
				target = { vars.playerPosX, vars.playerPosY, vars.playerPosZ },
			} )		
			Fox.Log("#### s10130_radio.DistantCodeTalker IsInRange " .. tostring(isInRangeflag) .. " ####")
			if not isInRangeflag then
				
				if svars.isDistantCodeTalkerRadio == false then
					svars.isDistantCodeTalkerRadio = true
					s10130_radio.DistantCodeTalkerRadio01()
				else
					svars.isDistantCodeTalkerRadio = false
					s10130_radio.DistantCodeTalkerRadio02()
				end
			end
		end
	else
		Fox.Log("#### s10130_radio.DistantCodeTalker isRideOnHeli_CodeTalker = true ####")
		
		GkEventTimerManager.Stop( "checkCodeTalkerStatus" )
	end
end


this.FuncDeadCodetalker = function( gameObjectId )
	TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD)
end
	

this.FuncDamageCodetalker = function( gameObjectId, AttackId , AttackerId )

	Fox.Log("s10130_mission DamageCodetalker AttackId= ".. AttackId .. " AttackerId= " .. AttackerId)

	local PUSH_ATTACK_ID = 1
	local AttackerIsPlayer = Tpp.IsPlayer( AttackerId )

	if not GkEventTimerManager.IsTimerActive( "ResetDamageRadio" ) then
		GkEventTimerManager.Start("ResetDamageRadio", 15.0 )
	end

	local lifeState = GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_HOSTAGE_NAME ), { id = "GetLifeStatus" } )
	
	if ( lifeState == TppGameObject.NPC_LIFE_STATE_DEAD )then
		return 
	end

	if AttackerIsPlayer == true then
		if AttackId == TppDamage.ATK_Push then
			return 
		elseif AttackId == TppDamage.ATK_BlastWind then
			return 
		elseif AttackId == TppDamage.ATK_Smoke then
			return 
		elseif AttackId == TppDamage.ATK_SmokeOccurred then
			return 
		elseif AttackId == TppDamage.ATK_SleepGus then
			return 
		elseif AttackId == TppDamage.ATK_SleepGusOccurred then
			return 
		end	
		Fox.Log("###########s10130_sequenceLog: DamageCodetalker !!  ###########")
		if( svars.PreliminaryFlag07 == true )then
			return
		end
		s10130_radio.PlayerAttackCodetalker()
		svars.PreliminaryFlag07 = true
	else
		if AttackId == TppDamage.ATK_None then
			return 
		end
		Fox.Log("###########s10130_sequenceLog: DamageCodetalker !!  ###########")
		if( svars.PreliminaryFlag07 == true )then
			return
		end
		s10130_radio.EnemyAttackCodetalker()
		svars.PreliminaryFlag07 = true
	end

	
	local gameObjectId = GameObject.GetGameObjectId( TARGET_HOSTAGE_NAME )
	local command = { id = "GetMaxLife" }
	local lifeMax, staminaMax = GameObject.SendCommand( gameObjectId, command )

	command = { id = "GetCurrentLife" }
	local life, stamina = GameObject.SendCommand( gameObjectId, command )
	
	if(lifeMax > life)then
		svars.isCodeTalkerDamage = true
	end

end



this.FuncPlayerRideOnHeli = function()
	Fox.Log("###########s10130_sequenceLog:  RideHelicopter!!  ###########")
	local flag = svars.isRideOnHeli_CodeTalker
	if flag == true then
		
		Fox.Log(" RideHelicopter : CodeTalker is Here!!!")
		
		
		
		GkEventTimerManager.Stop( "Timer_radio_HurryUp" )
		
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="EnablePullOut" })					
		GameObject.SendCommand(gameObjectId, { id="SetTakeOffWaitTime", time = 0 })		

		
		local cpId = { type="TppCommandPost2" } 
		GameObject.SendCommand( cpId, { id = "SetIgnoreLookHeli" } )
	else
		
		Fox.Log(" RideHelicopter : CodeTalker is Not Here...")
		s10130_radio.CodeTalkerNotStayInHeli()
	end
end



this.FuncPlayerRideOnHeliWithHuman = function()





















end


this.FuncHeliIcon = function()
	if svars.PreliminaryFlag05 == false then
		svars.PreliminaryFlag05 = true
		
		TppMission.UpdateObjective{
			objectives = { "Intermediate_target02" },
		}
	end
end



this.TargetFound = function()
	Fox.Log("###########s10130_sequenceLog:  TargetFound!!  ###########")
	svars.isTargetFound = true
	TppMission.UpdateObjective{
		objectives = { "default_codetalker" },
	}
end



this.StartDisableActionForEvent = function()
	
	if (TppSequence.GetContinueCount() > 0 ) then
		return
	end

	
	TppUI.OverrideFadeInGameStatus{
		
		EquipHud = false,
		EquipPanel = false,
		
		AnnounceLog = false,
		
	}
	
	this.SetDisableAction()
	
	TppUiStatusManager.SetStatus( "EquipHud", "INVALID" )
	TppUiStatusManager.SetStatus( "EquipPanel", "INVALID" )
	TppUiStatusManager.SetStatus( "AnnounceLog", "SUSPEND_LOG" )
	
	TppUiCommand.SetAllInvalidMbSoundControllerVoice()
end


this.SetDisableAction = function()	
	Fox.Log( "#### s10130_sequence.SetDisableAction ###" )
	
	vars.playerDisableActionFlag =
		PlayerDisableAction.FULTON
		+ PlayerDisableAction.MARKING
		+ PlayerDisableAction.BEHIND
		+ PlayerDisableAction.RUN 
		+ PlayerDisableAction.CQC
		+ PlayerDisableAction.CQC_INTERROGATE
		+ PlayerDisableAction.STEALTHASSIST
		+ PlayerDisableAction.TIME_CIGARETTE
		+ PlayerDisableAction.OPEN_EQUIP_MENU
		+ PlayerDisableAction.KILLING_WEAPON

	
	Player.SetPadMask {
		settingName = "CodeTalkerMonologue",
		except	=	true,					
		buttons =	PlayerPad.STANCE,		
		sticks	=	PlayerPad.STICK_R	+	
					PlayerPad.STICK_L,		
	}

end


this.StartEnableActionForEvent = function()
	
	TppUI.UnsetOverrideFadeInGameStatus()
	
	this.SetEnableAction()
	
	TppUiStatusManager.ClearStatus("EquipHud")
	TppUiStatusManager.ClearStatus("EquipPanel")
	TppUiStatusManager.ClearStatus("AnnounceLog")
	
	TppUiCommand.SetAllInvalidMbSoundControllerVoice( false )
end


this.SetEnableAction = function()	
	Fox.Log( "#### s10130_sequence.SetEnableAction ###" )
	
	local currentSeq = TppSequence.GetCurrentSequenceName()
	
	if ( currentSeq == "Seq_Game_Escape_A" ) then
		
		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE
	elseif ( currentSeq == "Seq_Game_Escape_B" ) then
		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE
	else
		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE
	end

	
	Player.ResetPadMask {
		settingName = "CodeTalkerMonologue",
	}

end


this.GimmickReset = function()	
	Fox.Log( "#### s10130_sequence.GimmickReset ###" )

	
	Gimmick.ResetGimmickData( GIMMICK_NAME.CANDLE001, GIMMICK_PATH.RESET_GIMMICK01 )
	Gimmick.ResetGimmickData( GIMMICK_NAME.CANDLE002, GIMMICK_PATH.RESET_GIMMICK01 )
	Gimmick.ResetGimmickData( GIMMICK_NAME.CANDLE003, GIMMICK_PATH.RESET_GIMMICK01 )
	Gimmick.ResetGimmickData( GIMMICK_NAME.CANDLE004, GIMMICK_PATH.RESET_GIMMICK01 )

	
	Gimmick.ResetGimmickData( GIMMICK_NAME.WBOX001, GIMMICK_PATH.RESET_GIMMICK02 )
	Gimmick.ResetGimmickData( GIMMICK_NAME.WBOX002, GIMMICK_PATH.RESET_GIMMICK02 )

	
	Gimmick.ResetGimmickData( GIMMICK_NAME.BARREL001, GIMMICK_PATH.RESET_GIMMICK03 )
	Gimmick.ResetGimmickData( GIMMICK_NAME.BARREL002, GIMMICK_PATH.RESET_GIMMICK03 )

end

this.RecoveryStaminaForCodeTalker = function()
	
	local locatorName = "CodeTalker"
	local gameObjectType = "TppCodeTalker2"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, locatorName)
	local command = { id="RecoveryStamina" }
	GameObject.SendCommand( gameObjectId, command )
end

this.EnableEnemyFor = function(seq)
	if (seq == "Seq_A") then
		
		s10130_enemy.ZombieEnemy()
	elseif (seq == "Seq_B") then
		
		s10130_enemy02.EnableEnemy()
		
		s10130_enemy02.SetEnabledFlagToEnemyHeli(true)
		s10130_enemy02.EnemyHeliAround()	
	end
end












function this.Messages()
	return
	StrCode32Table {
		GameObject = {	
			{
				
				msg = "Dead",
				sender = TARGET_HOSTAGE_NAME,
				func = this.FuncDeadCodetalker
			},
			{
				
				msg = "Damage",
				sender = TARGET_HOSTAGE_NAME,
				func = this.FuncDamageCodetalker
			},
			
			{
				msg = "Carried",
				func = function ( GameObjectId, carriedState )
					
					if (( svars.isCarryTalkStart01 == true )and( svars.isCarryTalkStart02 == false )) then
						
						if( GameObjectId == GameObject.GetGameObjectId(TARGET_HOSTAGE_NAME) )then
							
							if carriedState == 2 then
								Fox.Log("s10130_mission TARGET_HOSTAGE_NAME Carried End!!!")
								
								for index, labelName in ipairs( this.longMonologueList01 ) do
									if ( svars[labelName] == false ) then
										Fox.Log("s10130_mission Monologue labelName Play!!!".. tostring(labelName))
										s10130_radio.CallMonologueHostage( TARGET_HOSTAGE_NAME, labelName )
										break
									else
										Fox.Log("s10130_mission Monologue labelName Played!!!".. tostring(labelName))
									end
								end
							else
								Fox.Log("s10130_mission TARGET_HOSTAGE_NAME Carried Start!!!")
							end
						end
					elseif (( svars.isCarryTalkStart01 == true )and( svars.isCarryTalkStart02 == true )) then
						
						if( GameObjectId == GameObject.GetGameObjectId(TARGET_HOSTAGE_NAME) )then
							
							if carriedState == 2 then
								Fox.Log("s10130_mission TARGET_HOSTAGE_NAME Carried End!!!")
								
								for index, labelName in ipairs( this.longMonologueList02 ) do
									if ( svars[labelName] == false ) then
										Fox.Log("s10130_mission Monologue labelName Play!!!".. tostring(labelName))
										s10130_radio.CallMonologueHostage( TARGET_HOSTAGE_NAME, labelName )
										break
									else
										Fox.Log("s10130_mission Monologue labelName Played!!!".. tostring(labelName))
									end
								end
							else
								Fox.Log("s10130_mission TARGET_HOSTAGE_NAME Carried Start!!!")
							end
						end
					end
				end
			},
			
			{
				msg = "MonologueEnd",
				func = function (GameObjectId,speechLabel,isSuccess)
					Fox.Log("s10130_mission Monologue GameObjectId"..GameObjectId)
					Fox.Log("s10130_mission Monologue speechLabel"..speechLabel)
					Fox.Log("s10130_mission Monologue isSuccess"..isSuccess)
					
					if( isSuccess )then
						
						if( GameObjectId == GameObject.GetGameObjectId(TARGET_HOSTAGE_NAME) )then

							
							for index, labelName in ipairs( this.longMonologueList ) do
								if ( speechLabel == Fox.StrCode32(labelName) ) then
									svars[labelName] = true
									Fox.Log("s10130_mission Monologue speechLabel"..labelName)
									Fox.Log("s10130_mission Monologue speechLabel".. tostring(svars[labelName]))
									break
								end
							end

							
							for index, labelName in ipairs( this.longMonologueList ) do
								if ( speechLabel == Fox.StrCode32("speech130_CTV010_04") ) then
									
									Fox.Log("s10130_mission Monologue labelName NoPlay!!!".. tostring(labelName))
									s10130_radio.MonologueAfterKazuRadio01()
									break
								elseif ( speechLabel == Fox.StrCode32("speech130_CTV010_08") ) then
									Fox.Log("s10130_mission Monologue labelName NoPlay!!!".. tostring(labelName))
									break
								elseif ( speechLabel == Fox.StrCode32("speech130_CTV020_03") ) then
									
									Fox.Log("s10130_mission Monologue labelName NoPlay!!!".. tostring(labelName))
									s10130_radio.MonologueAfterKazuRadio02()
									break
								else
									local gameObjectId = GameObject.GetGameObjectId( "TppCodeTalker2", TARGET_HOSTAGE_NAME )
									local command = {	id = "GetStatus",	}
									local actionStatus = GameObject.SendCommand( gameObjectId, command )
									
									if actionStatus == TppGameObject.NPC_STATE_CARRIED then
										if ( svars[labelName] == false ) then
											Fox.Log("s10130_mission Monologue labelName Play!!!".. tostring(labelName))
											s10130_radio.CallMonologueHostage( TARGET_HOSTAGE_NAME, labelName )
											break
										else
											
											Fox.Log("s10130_mission Monologue MonologueEnd l!!")
										end
									else
										break
									end
								end
							end

						else
							
							Fox.Log("s10130_mission Monologue Unkown Charal!!")
						end
					else
						
						Fox.Log("s10130_mission Monologue failed !!")
					end
				end
			},
			{
				msg = "ChangePhase",
				sender = "mafr_lab_cp",
				func = function ( GameObjectId, phaseName )
					if ( phaseName == TppGameObject.PHASE_ALERT ) then
						svars.isEnemyFound = true
					end
				end
			},
			{
				msg = "ChangePhase",
				sender = "mafr_lab_w_cp",
				func = function ( GameObjectId, phaseName )
					if ( phaseName == TppGameObject.PHASE_ALERT ) then
						svars.isEnemyFound = true
					end
				end
			},
			{
				msg = "ChangePhase",
				sender = "mafr_lab_s_cp",
				func = function ( GameObjectId, phaseName )
					if ( phaseName == TppGameObject.PHASE_ALERT ) then
						svars.isEnemyFound = true
					end
				end
			},
			
			{
				msg = "RoutePoint2", sender = "SupportHeli",
				func = function (gameObjectId, routeId ,routeNode, messageId )
					if ( messageId == StrCode32("ReserveMissionClear") ) then
						this.ReserveMissionClear()
					end
				end
			},
			{
				msg =	"ReportDiscoveryHostage",
				func =	function()
					
					if( svars.PreliminaryFlag07 == true )then
						return
					end
					if not GkEventTimerManager.IsTimerActive( "ResetDamageRadio" ) then
						GkEventTimerManager.Start("ResetDamageRadio", 15.0 )
					end
					s10130_radio.EnemyAttackCodetalker()
				end
			},
		},
		Radio = {
			{
				
				msg = "Finish",
				sender = "s0130_rtrg6100",
				func = function ()
					Fox.Log("s10130_mission MonologueCodeTalker02 Start!!")
					s10130_radio.CallMonologueCodeTalker02()
				end
			},
			{
				
				msg = "Finish",
				sender = "s0130_oprg2010",
				func = function ()
					Fox.Log("s10130_mission s0130_oprg2010 Played! Change oprg0010 to oprg0030 !!")
					svars.PreliminaryFlag06 = true
					
					TppRadio.SetOptionalRadio("Set_s0130_oprg0030")
				end
			},
		},
		Timer = {
			
			{
				msg = "Finish",
				sender = "CarryTalkStart01",
				func = function ()
					
					svars.isCarryTalkStart01 = true
					
					
					if (TppSequence.GetContinueCount() > 0) then
						
						svars.speech130_CTV010_01 = true
						svars.speech130_CTV010_02 = true
						svars.speech130_CTV010_03 = true
						svars.speech130_CTV010_04 = true
						svars.speech130_CTV010_05 = true
						svars.speech130_CTV010_06 = true
						svars.speech130_CTV010_07 = true
						svars.speech130_CTV010_08 = true
						return
					end
					
					local gameObjectId = GameObject.GetGameObjectId( "TppCodeTalker2", TARGET_HOSTAGE_NAME )
					local command = {	id = "GetStatus",	}
					local actionStatus = GameObject.SendCommand( gameObjectId, command )
					
					if actionStatus == TppGameObject.NPC_STATE_CARRIED then
						Fox.Log("s10130_mission TARGET_HOSTAGE_NAME is Carring!!!")
						
						for index, labelName in ipairs( this.longMonologueList ) do
							if ( svars[labelName] == false ) then
								Fox.Log("s10130_mission Monologue labelName Play!!!".. tostring(labelName))
								s10130_radio.CallMonologueHostage( TARGET_HOSTAGE_NAME, labelName )
								break
							else
								Fox.Log("s10130_mission Monologue labelName Played!!!".. tostring(labelName))
							end
						end
					else
						Fox.Log("s10130_mission Monologue Player Not Carry Hostage!!!".. tostring(labelName))
					end
				end
			},
			{
				
				msg = "Finish",
				sender = "BgmStop",
				func = function ()

					Fox.Log("s10130_mission BGM Stop!!")
					
					TppSound.StopSceneBGM()

				end
			},
			{
				
				msg = "Finish",
				sender = "BgmChange",
				func = function ()
					Fox.Log("s10130_mission BGM Change!!")
					TppSound.SetPhaseBGM( "bgm_pre_codetalker" )
				end
			},
			{
				
				msg = "Finish",
				sender = "AllKillParasiteRadio",
				func = function ()
					Fox.Log("s10130_mission AllKillParasiteRadio!!")
					
					local sequence = TppSequence.GetCurrentSequenceName()
					if ( sequence == "Seq_Game_Escape_A" )	then
						
						Fox.Log("s10130_mission ParasiteCombatEnd03 Seq_Game_Escape_A!!")
						s10130_radio.ParasiteCombatEnd03()
						
						TppRadio.SetOptionalRadio("Set_s0130_oprg0040")
					else
						Fox.Log("s10130_mission ParasiteCombatEnd03 Not Seq_Game_Escape_A!!")
						s10130_radio.ParasiteCombatEnd02()
						
						TppRadio.SetOptionalRadio("Set_s0130_oprg0030")
					end
				end
			},
			{
				
				msg = "Finish",
				sender = "ResetDamageRadio",
				func = function ()
					svars.PreliminaryFlag07 = false
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
				msg = "OnChangeSmallBlockState",
				func = function ( smallBlock_X, smallBlock_Z, smallBlock_Stat)
					Fox.Log("s10130_mission message OnChangeSmallBlockState!!")



					if((smallBlock_X == 154) and (smallBlock_Z == 114 ))then
						if(smallBlock_Stat == StageBlock.ACTIVE)then

							
							TppDataUtility.SetEnableDataFromIdentifier( "NavIdentifier", "NavxNavFileLocator0000", true )

						elseif(smallBlock_Stat == StageBlock.INACTIVE)then

							
							TppDataUtility.SetEnableDataFromIdentifier( "NavIdentifier", "NavxNavFileLocator0000", false )

						else
							Fox.Log("s10130_mission message AbnormalSmallBlockState!!")
						end
					else
						Fox.Log("s10130_mission message AbnormalSmallBlockPos!!")
					end
				end,
				option = { isExecDemoPlaying = true },
			},
			{
				msg = "OnChangeLargeBlockState",
				func = function ( largeBlockName, largeBlock_Stat)
					Fox.Log("s10130_mission message OnChangeLargeBlockName!!"..largeBlockName)
					Fox.Log("s10130_mission message OnChangeLargeBlockState!!"..largeBlock_Stat)



					if( largeBlockName == Fox.StrCode32("mafr_lab") )then
						if(largeBlock_Stat == StageBlock.ACTIVE)then
							this.LabShutterOff()
						else
							Fox.Log("s10130_mission message AbnormallargeBlockState!!")
						end
					else
						Fox.Log("s10130_mission message AbnormallargeBlockPos!!")
					end
				end,
				option = { isExecDemoPlaying = true },
			},
		},
		Player = {
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







sequences.Seq_Game_ParasiteBattle = {

	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "CamoParasiteAllKill" ) then
			return
		elseif TppPackList.IsMissionPackLabel( "CodeTalkerClearDemo" ) then
			return
		end
		return
		StrCode32Table {
			Trap = {
				
				{
					msg = "Enter",
					sender = TRAP_NAME.SNEAK_BGM_START,
					func = function ()
						if svars.isParasiteSNBGMStart == false then
							svars.isParasiteSNBGMStart	= true
							Fox.Log("s10130_mission SetNextSequence Seq_Game_ParasiteCombat...")
							TppSequence.SetNextSequence( "Seq_Game_ParasiteCombat" )
						else
							Fox.Log("s10130_mission CamoParasite Was CheckPoint...")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.BGM_STOP,
					func = function ()

						if svars.isParasiteBGMStop == false then
							Fox.Log("s10130_mission CamoParasiteBGMStop!!")
							svars.isParasiteBGMStop		= true

							
							s10130_enemy.CamoParasiteFogOff()

							
							WeatherManager.PauseNewWeatherChangeRandom(false)

							
							s10130_sound.BGMParasitesEd()

							
							GkEventTimerManager.Start("BgmStop", 4.0 )

							
							GkEventTimerManager.Start("ParasiteCombatEnd", 5.0 )

						else
							Fox.Log("s10130_mission CamoParasiteBGM none stop!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.RTRG2020,
					func = function ()
						Fox.Log("s10130_mission s10130_radio.NoEnemy call!!")
						s10130_radio.NoEnemy()
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(2283.6484, 142.16449, -1768.9397))
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		if TppSequence.GetContinueCount() > 0 then
			Fox.Log( "s10130_sequence.Seq_Game_ParasiteBattle Continue !!!!!" )
			
		else
			Fox.Log( "s10130_sequence.Seq_Game_ParasiteBattle No Continue !!!!!" )
		end

		
		
		s10130_enemy.CamoParasiteOff()

		
		WeatherManager.RequestWeather( TppDefine.WEATHER.CLOUDY, 5.0 )

		
		WeatherManager.PauseNewWeatherChangeRandom(true)

		
		TppScriptBlock.LoadDemoBlock("ArrivalParasiteDemo")

		
		TppTelop.StartCastTelop()

		
		if (svars.PreliminaryFlag06 == false) then
			
			TppRadio.SetOptionalRadio("Set_s0130_oprg0010")
		else
			
			TppRadio.SetOptionalRadio("Set_s0130_oprg0030")
		end
		
		TppRadio.EnableCommonOptionalRadio(false)

		
		TppMission.UpdateObjective{
			objectives = { "default_photo_codetalker", "default_photo_lab", "target_area_cp", "Intermediate_target01",},
		}
		
		TppMission.UpdateObjective{
			objectives = { "default_missionTask_01", "default_missionTask_02", "default_missionTask_03", "default_missionTask_04", "default_missionTask_05", "default_missionTask_06", },
		}
		
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = { "s0130_rtrg2010" },	
			},
			
			objectives = { "default_area_lab",},
			options = { isMissionStart = true },
		}

	end,
	
	OnLeave = function ()
		
		TppMission.UpdateCheckPointAtCurrentPosition()
	end,

}



sequences.Seq_Game_ParasiteCombat = {

	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "CamoParasiteAllKill" ) then
			return
		elseif TppPackList.IsMissionPackLabel( "CodeTalkerClearDemo" ) then
			return
		end
		return
		StrCode32Table {
			Radio = {
				{
					msg = "Finish",
					sender = "s0130_rtrg2120",
					func = function ()
						s10130_radio.BackCipher()
					end
				},
				{
					msg = "Finish",
					sender = "s0130_rtrg2040",
					func = function ()
						if ( TppRadio.IsPlayed("s0130_mirg0020") == true ) then
							Fox.Log("s10130_mission s0130_mirg0020 Played!!")
							
							s10130_radio.ParasitePhantom()
						else
							Fox.Log("s10130_mission s0130_mirg0020 not Played!!")
						end
					end
				},
			},
			Marker = {
				
				{
					msg = "ChangeToEnable",
					sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function ()
						svars.isParasiteMarking	= true
					end
				},
			},
			Timer = {
				{
					
					msg = "Finish",
					sender = "ParasiteCombatEnd",
					func = function ()
						
						if ((svars.wmu_lab_0000Disablement == true)and
							(svars.wmu_lab_0001Disablement == true)and
							(svars.wmu_lab_0002Disablement == true)and
							(svars.wmu_lab_0003Disablement == true)) then
							
							Fox.Log("s10130_mission All Parasite Unconscious!!")
						else
							
							s10130_radio.ParasiteCombatEndAfter()
						end
						
						TppSequence.SetNextSequence( "Seq_Game_CodeTalkerMeetBefore" )
					end
				},
				{
					msg = "Finish",
					sender = "ParasiteHints01",
					func = function ()
						Fox.Log("s10130_mission ParasiteCombatHint01 Played!!")
						if (svars.isParasiteMarking	== false) then
							
							if not(svars.isAllKillParasite) then
								s10130_radio.ParasiteCombatHint01()
							end
						end
					end
				},
				{
					msg = "Finish",
					sender = "ParasiteWarp01",
					func = function ()
						Fox.Log("s10130_mission ParasiteWarp01!!")
						s10130_enemy.WarpCamoParasite( "wmu_lab_0002", {2627.358,127.3464,-1997.11}, 0 )
						s10130_enemy.WarpCamoParasite( "wmu_lab_0003", {2522.942,129.6939,-1962.911}, 0 )
					end
				},
				{
					msg = "Finish",
					sender = "ParasiteFog01",
					func = function ()
						Fox.Log("s10130_mission ParasiteFog01!!")
						
						Fox.Log("s10130_mission CamoParasiteSNBGMStart!!")
						s10130_sound.BGMParasitesSneek()
						
						s10130_radio.FogSkulls()
					end
				},
			},
			GameObject = {
				{
				
					msg = "StartedCombat", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function ()
						
						TppRadio.SetOptionalRadio("Set_s0130_oprg0020")
						
						TppRadio.ChangeIntelRadio( s10130_radio.intelRadioListPrasiteCombat )
						
						
						if svars.isParasiteBattle == true then
							Fox.Log("s10130_mission CamoParasiteALBGMStart!!")
							svars.isParasiteALBGMStart	= true
							s10130_sound.BGMParasitesAlert()
						else
							Fox.Log("s10130_mission CamoParasiteALBGM none!!")
						end
					end
				},
				{
				
					msg = "QuietFinishReflex", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function (gameObjectId)
						Fox.Log("s10130_mission CamoParasiteALBGMStart!!")

						
						s10130_radio.ParasiteCombatStart()

						
						svars.isParasiteBattle	= true

						
						local command = { id = "SetKeepCaution", enable = true } 
						for i, cpId in pairs( s10130_enemy.cpIdList ) do
							GameObject.SendCommand( GameObject.GetGameObjectId(cpId), command ) 
						end
						svars.isParasiteALBGMStart	= true
						s10130_sound.BGMParasitesAlert()
						GkEventTimerManager.Start("ParasiteHints01", 30.0 )
					end
				},
				{
				
					msg = "Unconscious", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function (gameObjectId,arg01)
						this.ParasiteDisablementEvaluate(gameObjectId,"Seq_Game_ParasiteCombat")
					end
				},
				{
				
					msg = "Dying", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function (gameObjectId,arg01)
						
						TppMission.UpdateObjective{	objectives = { "clear_missionTask_04" , },	}
					end
				},
				{
				
					msg = "Fulton", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function (gameObjectId,arg01,arg02,arg03)
						
						for i, ParasiteName in ipairs( s10130_enemy.parasiteDefine ) do
							if GameObject.GetGameObjectId(ParasiteName) == gameObjectId then
								
								svars[ParasiteName.."Fulton"] = true
								break
							end
						end

						
						TppMission.UpdateObjective{	objectives = { "clear_missionTask_05", },	}
					end
				},
				{
				
					msg = "QuietEraseMarker", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function (gameObjectId)
						if svars.isParasiteMarkerOff == false then
							Fox.Log("s10130_mission Parasite Marker Off!!")
							svars.isParasiteMarkerOff	= true
							
							s10130_radio.ParasiteCombatHint02()
						else
							Fox.Log("s10130_mission Parasite Already Marker Off!!")
						end
					end
				},
			},
			Trap = {
				
				{
					msg = "Enter",
					sender = TRAP_NAME.PARASITE_DEMO000,
					func = function ()
						if svars.isArrivalParasiteDemo == false then
							svars.isArrivalParasiteDemo = true
							
							sequences.Seq_Game_ParasiteCombat.ArrivalParasite()
						else
							Fox.Log("s10130_mission ArrivalParasiteDemo was played!!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.BGM_STOP,
					func = function ()

						if svars.isParasiteBGMStop == false then
							Fox.Log("s10130_mission CamoParasiteBGMStop!!")
							svars.isParasiteBGMStop		= true

							
							s10130_enemy.CamoParasiteFogOff()

							
							WeatherManager.PauseNewWeatherChangeRandom(false)

							
							s10130_sound.BGMParasitesEd()

							
							GkEventTimerManager.Start("BgmStop", 4.0 )

							
							GkEventTimerManager.Start("ParasiteCombatEnd", 5.0 )

						else
							Fox.Log("s10130_mission CamoParasiteBGM none stop!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.MODECHANGE_SHORT,
					func = function ()
						if svars.PreliminaryFlag01 == false then
							Fox.Log("s10130_mission CamoParasite Change Short_Range!!")
							svars.PreliminaryFlag01 = true
							s10130_enemy.CamoParasiteShortMode()
						else
							Fox.Log("s10130_mission CamoParasite was Changed Short_Range")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.MODECHANGE_LONG,
					func = function ()
						if svars.PreliminaryFlag01 == true then
							Fox.Log("s10130_mission CamoParasite Change Long_Range!!")
							svars.PreliminaryFlag01 = false
							s10130_enemy.CamoParasiteLongMode()
						else
							Fox.Log("s10130_mission CamoParasite was Changed Long_Range")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.WATERFALLSHIFT,
					func = function ()
						if svars.PreliminaryFlag04 == false then
							Fox.Log("s10130_mission CamoParasite Change WaterFallShift!!")
							svars.PreliminaryFlag04 = true
							s10130_enemy.CamoParasiteWaterFallShift()
						else
							Fox.Log("s10130_mission CamoParasite was Changed WaterFallShift")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.NORMALSHIFT,
					func = function ()
						if svars.PreliminaryFlag04 == true then
							Fox.Log("s10130_mission CamoParasite Change NormalShift!!")
							svars.PreliminaryFlag04 = false
							s10130_enemy.CamoParasiteNormalShift()
						else
							Fox.Log("s10130_mission CamoParasite was Changed NormalShift")
						end
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()

		
		if TppSequence.GetContinueCount() > 0 then
			Fox.Log( "s10130_sequence.Seq_Game_ParasiteCombat Continue !!!!!" )
			
			s10130_enemy.CamoParasiteOff()

			
			TppScriptBlock.LoadDemoBlock("ArrivalParasiteDemo")

			
			WeatherManager.RequestWeather( TppDefine.WEATHER.CLOUDY, 0.1 )

			
			WeatherManager.PauseNewWeatherChangeRandom(true)

			
			if (svars.PreliminaryFlag06 == false) then
				
				TppRadio.SetOptionalRadio("Set_s0130_oprg0010")
			else
				
				TppRadio.SetOptionalRadio("Set_s0130_oprg0030")
			end
			
			TppRadio.EnableCommonOptionalRadio(false)

			
		else
			Fox.Log( "s10130_sequence.Seq_Game_ParasiteCombat No Continue !!!!!" )
		end

		
		TppMission.StartBossBattle()

		
		
		s10130_enemy.CamoParasiteFogOn()

		
		GkEventTimerManager.Start("ParasiteFog01", 1.5 )

	end,
	
	OnLeave = function ()
		
		TppMission.UpdateCheckPoint("CHK_ParasiteBattleEnd")
	end,

	
	ArrivalParasite = function()

		
		local func = function()
			s10130_radio.ParasiteDiscovery()
			
			GkEventTimerManager.Start("ParasiteWarp01", 1.0 )
		end

		
		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE

		
		s10130_demo.ArrivalParasiteDemo(func)

	end,

}



sequences.Seq_Game_CodeTalkerMeetBefore = {

	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "CamoParasiteAllKill" ) then
			return
		elseif TppPackList.IsMissionPackLabel( "CodeTalkerClearDemo" ) then
			return
		end
		return
		StrCode32Table {
			Player = {
				{
					msg = "CheckEventDoorNgIcon",
					func = function(playerId,doorId)
						Fox.Log("player in event door")
						local isPlaying = TppRadioCommand.IsPlayingRadio()
						local result,checkAlert,checkEnemy = TppDemo.CheckEventDemoDoor(doorId,CHECK_ENEMY_POS01,CHECK_ENEMY_RANGE01)
						
						if result == true then
							Fox.Log("check is ok")
							if svars.isDemoDoor_Alert == true	then
								if isPlaying == false	then
									s10130_radio.Alert_off()
									svars.isDemoDoor_Alert = false
								end
							else
								if svars.isDemoDoor_Enemy == true	then
									if isPlaying == false	then
										s10130_radio.enemy_off()
										svars.isDemoDoor_Enemy = false
									end
								end
							end
						elseif checkAlert == false then
							Fox.Log("check is ng. alert")
							if isPlaying == false	then
								s10130_radio.dontPicking_Alert()
								svars.isDemoDoor_Alert = true
								svars.isDemoDoor_Enemy = false
							else
								Fox.Log("Now Playing Radio ... Nothing Done !!")
							end
						elseif checkEnemy == false then
							Fox.Log("check is ng. enemy")
							if isPlaying == false	then
								s10130_radio.dontPicking_Enemy()
								svars.isDemoDoor_Enemy = true
								svars.isDemoDoor_Alert = false
							else
								Fox.Log("Now Playing Radio ... Nothing Done !!")
							end
						end

					end
				},
				{
					msg = "StartEventDoorPicking",
					func = function ()
						Fox.Log("Event door Open!!")
						TppUiStatusManager.SetStatus( "ActionIcon", "NO_INVALID" )
						TppSequence.SetNextSequence("Seq_Demo_Brank")
					end
				},
			},
			Marker = {
				{
					
					msg = "ChangeToEnable",
					func = function( gameObjectId, markType, s_gameObjectId, identificationCode )
						Fox.Log("*** gameObjectId " .. tostring(gameObjectId) .. " ***")
						Fox.Log("*** makerType " .. tostring(markType) .. " ***")
						
						if markType == Fox.StrCode32("TYPE_ENEMY") then
							
							if identificationCode == Fox.StrCode32("Player") then
								Fox.Log( "s10093_sequence Marked Enemy !!!!!" )
								s10130_radio.ZRSDiscovery()
							end
						else
							Fox.Log( "s10093_sequence Marked Not Enemy !!!!!" )
						end
					end
				},
			},
			Radio = {
				{
					msg = "Finish",
					sender = "s0130_rtrg2200",
					func = function ()
						s10130_radio.GetIntelFileAfter()
					end
				},
				{
					msg = "Finish",
					sender = "CPRadio01",
					func = function ()

					end
				},
				{
					
					msg = "Finish",
					sender = "s0130_rtrg2160",
					func = function ()
						if (TppMission.IsEnableMissionObjective( "default_area_codetalker" )==false) then
							Fox.Log("s10130_mission ZRSQuestioning Start!!")
							s10130_radio.ZRSQuestioning()
						end
					end
				},
				{
					
					msg = "Finish",
					sender = "s0130_rtrg2165",
					func = function ()
						if (TppMission.IsEnableMissionObjective( "default_area_codetalker" )==false) then
							Fox.Log("s10130_mission ZRSQuestioning Start!!")
							s10130_radio.ZRSQuestioning()
						end
					end
				},
			},
			GameObject = {
				{
					
					msg = "RadioEnd",
					func = function( GameObjectId, cpGameObjectId, speechLabel, isSuccess )
						Fox.Log( "*** ConversationEnd ***")
						if speechLabel == StrCode32( "CPRSP010" ) then
							s10130_radio.ZRSCPtoKazu()
						end
					end
				},
			},
			Trap = {
				
				{
					msg = "Enter",
					sender = TRAP_NAME.CPRADIO01,
					func = function ()

						
						this.LabShutterOff()

						
						TppRadio.ChangeIntelRadio( s10130_radio.intelRadioListNearLab )

						if svars.isNearLab == false then
							svars.isNearLab = true
							if svars.isParasiteBattle == false then
								
								Fox.Log("s10130_mission s10130_radio.ArrivalLab call!!")
								s10130_radio.ArrivalLab()
							else
								
								Fox.Log("s10130_mission s10130_radio.CPRadio01 call!!")
								s10130_radio.CPRadio01()
							end
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.CODETALKER_BGM_START,
					func = function ()
						if svars.isCodetalkerBGMStart == false then
							Fox.Log("s10130_mission CodetalkerBGMStart!!")
							svars.isCodetalkerBGMStart	= true
							TppSound.SetPhaseBGM( "bgm_codetalker" )
						else
							Fox.Log("s10130_mission CodetalkerBGM Started!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.LABINROOM,
					func = function ()
						if svars.isLabInRoom == false then
							Fox.Log("s10130_mission LabInRoom!!")
							svars.isLabInRoom	= true
							
							TppMission.UpdateObjective{
								objectives = {
									"default_inroom",
								},
							}
							
							TppInterrogation.RemoveHighInterrogation(
								GameObject.GetGameObjectId("mafr_lab_cp"),
								{
									{ name = "enqt3000_1e1010", func = s10130_enemy.InterCall_codetalker_pos01, },
								}
							)
						else
							Fox.Log("s10130_mission LabRoom went!!!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.RTRG6020,
					func = function ()
						if ( svars.PreliminaryFlag09 == false ) then
							svars.PreliminaryFlag09 = true
							if (( svars.isEnemyFound == false ) and (svars.isParasiteBattle == false )) then
								s10130_radio.KazuSneakSuccess()
							end
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.DEMOBLOCK01,
					func = function()

						
						this.LabShutterOff()

						TppScriptBlock.LoadDemoBlock("ContactCodetalkerDemo")
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()
		
		TppMission.FinishBossBattle()

		
		s10130_enemy.SetUpCamoParasiteResetAI( "wmu_lab_0000" )
		s10130_enemy.SetUpCamoParasiteResetAI( "wmu_lab_0001" )
		s10130_enemy.SetUpCamoParasiteResetAI( "wmu_lab_0002" )
		s10130_enemy.SetUpCamoParasiteResetAI( "wmu_lab_0003" )

		
		if (svars.PreliminaryFlag06 == false) then
			
			TppRadio.SetOptionalRadio("Set_s0130_oprg0010")
		else
			
			TppRadio.SetOptionalRadio("Set_s0130_oprg0030")
		end
		
		TppRadio.EnableCommonOptionalRadio(true)

		
		if TppSequence.GetContinueCount() > 0 then
			Fox.Log( "s10130_sequence.Seq_Game_CodeTalkerMeetBefore Continue !!!!!" )
			
			s10130_radio.MissionContinue()

			
			
			s10130_enemy.CamoParasiteOff()
			
			TppSound.SetPhaseBGM( "bgm_pre_codetalker" )

			
			if svars.isParasiteBattle == true then
				
				local command = { id = "SetKeepCaution", enable = true } 
				for i, cpId in pairs( s10130_enemy.cpIdList ) do
					GameObject.SendCommand( GameObject.GetGameObjectId(cpId), command ) 
				end
			end

		else
			Fox.Log( "s10130_sequence.Seq_Game_CodeTalkerMeetBefore No Continue !!!!!" )
			
			if svars.isAllKillParasite == false then
				Fox.Log( "!!!! s10130_mission CamoParasiteOff yonderu !!!!" )

				
				
				s10130_enemy.CamoParasiteOff()

				
				TppSound.SetPhaseBGM( "bgm_pre_codetalker" )

			else
				Fox.Log( "!!!! s10130_mission Are still parasites !!!!" )
			end
		end

		
		
		this.eventDoorSetting()
		
		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE

		
		if svars.isDoorPlaceEstablishing == false then
			TppInterrogation.AddHighInterrogation(
				GameObject.GetGameObjectId("mafr_lab_cp"),
				{
					{ name = "enqt3000_1e1010", func = s10130_enemy.InterCall_codetalker_pos01, },
				}
			)
		end
		
		if svars.isCodeTalkerPlaceEstablishing == false then
			TppInterrogation.AddHighInterrogation(
				GameObject.GetGameObjectId("mafr_lab_cp"),
				{
					{ name = "enqt3000_1f1010", func = s10130_enemy.InterCall_codetalker_pos02, },
				}
			)
		end

	end,
	
	OnLeave = function ()
		
		if svars.isDoorPlaceEstablishing == false then
			TppInterrogation.RemoveHighInterrogation(
				GameObject.GetGameObjectId("mafr_lab_cp"),
				{
					{ name = "enqt3000_1e1010", func = s10130_enemy.InterCall_codetalker_pos01, },
				}
			)
		end
		
		if svars.isCodeTalkerPlaceEstablishing == false then
			TppInterrogation.RemoveHighInterrogation(
				GameObject.GetGameObjectId("mafr_lab_cp"),
				{
					{ name = "enqt3000_1f1010", func = s10130_enemy.InterCall_codetalker_pos02, },
				}
			)
		end
	end,

}


sequences.Seq_Demo_Brank = {

	OnEnter = function()
		local func_init = function()
			TppUiStatusManager.SetStatus( "ActionIcon", "NO_INVALID" )
		end
		local func_end = function()
			TppUiStatusManager.UnsetStatus( "ActionIcon", "NO_INVALID" )
			TppSequence.SetNextSequence("Seq_Demo_CodeTalker")
		end
		s10130_demo.Demo_Brank_30( func_init , func_start , func_end )
	end,
	
	OnLeave = function ()
		
		Player.SetCurrentItemIndex{	itemIndex = 0 }
	end,
}


sequences.Seq_Demo_CodeTalker = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Demo = {
				{	
					msg = "Skip",
					func = function( demoId )
						Fox.Log("Demo_Codetalker Skip !!")
						Fox.Log("Demo MSG [ Door_envModel_visOn ]!!")
						Gimmick.SetEventDoorInvisible( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , false )	
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "IdoorHide",
					func = function( demoId )
						Fox.Log("Demo MSG [ Door_envModel_visOff ]!!")
						Gimmick.SetEventDoorInvisible( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , true )	
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "IdoorUnHide",
					func = function( demoId )
						Fox.Log("Demo MSG [ Door_envModel_visOn ]!!")
						Gimmick.SetEventDoorInvisible( GIMMICK_NAME.DOOR001 , GIMMICK_PATH.DOOR001 , false )	
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "cdtstacoaton",
					func = function( demoId )
						Fox.Log("Demo MSG [ Coat_envModel_visOn ]!!")
						this.CoatOn()	
					end,
					option = { isExecDemoPlaying = true },
				},
			},		
		}
	end,

	OnEnter = function()
		
		local func = function()

			
			s10130_enemy.ResetPositionEnemy01()

			
			if svars.isAllKillParasite == false then

				TppSequence.SetNextSequence( "Seq_Game_Escape_A" )
			else
				sequences.Seq_Demo_CodeTalker.EscapeB_Prepare()
			end

		end

		
		this.GimmickReset()

		
		s10130_enemy.UnlockedCodeTalker()

		
		s10130_demo.PlayContactCodetalkerDemo(func)

	end,

	
	EscapeB_Prepare = function()

		
		TppScriptBlock.Unload( "demo_block" )

		
		TppMission.Reload{
			isNoFade = false,													
			showLoadingTips = false,										
			missionPackLabelName = "CamoParasiteAllKill",					
			OnEndFadeOut = function()											
				TppSequence.ReserveNextSequence( "Seq_Game_Escape_B" )
				TppMission.UpdateCheckPointAtCurrentPosition()
			end,
		}

	end,

	OnLeave = function ()

		
		TppUiStatusManager.SetStatus( "AnnounceLog", "SUSPEND_LOG" )

		if svars.isAllKillParasite == false then
			
			TppMission.UpdateCheckPointAtCurrentPosition()
		end
	end,

}



sequences.Seq_Game_Escape_A = {

	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "CamoParasiteAllKill" ) then
			return
		elseif TppPackList.IsMissionPackLabel( "CodeTalkerClearDemo" ) then
			return
		end
		return
		StrCode32Table {
			Player = {
				{
				
					msg = "RideHelicopter",
					func = function()
						this.FuncPlayerRideOnHeli()
					end
				},
				{
				
					msg = "RideHelicopterWithHuman",
					func = function()
						this.FuncPlayerRideOnHeliWithHuman()
					end
				},
				
				{
					msg = "IconRideHelicopterStartShown",
					func = this.FuncHeliIcon
				},
			},
			Trap = {
				
				{
					msg = "Enter",
					sender = TRAP_NAME.DEMOBLOCK03,
					func = function()
						TppScriptBlock.LoadDemoBlock("CemeteryCodetalkerDemo")
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.CODETALKER_DEMO001,
					func = function ()
						
						local gameObjectId = GameObject.GetGameObjectId( "TppCodeTalker2", TARGET_HOSTAGE_NAME )
						local command = {	id = "GetStatus",	}
						local actionStatus = GameObject.SendCommand( gameObjectId, command )
						
						if actionStatus == TppGameObject.NPC_STATE_CARRIED then
							if svars.isCodetalkerDemo001 == false then
								Fox.Log("s10130_mission demo001")
								
								svars.isCodetalkerDemo001	= true
								svars.isCarryTalkStart02	= true
								
								
								TppRadio.ChangeIntelRadio( s10130_radio.intelRadioListCemeteryDemoEnd )

								
								for index, labelName in ipairs( this.longMonologueList01 ) do
									
									Fox.Log("s10130_mission Monologue Stop longMonologueList01 ".. labelName .. " bool= " .. tostring(svars[labelName]))
									svars[labelName] = true
								end

								
								
								local checkAlert = Tpp.IsNotAlert() 
								
								local checkEnemy = TppEnemy.IsActiveSoldierInRange( CHECK_ENEMY_POS02, CHECK_ENEMY_RANGE02 )
								
								this.RecoveryStaminaForCodeTalker()

								
								if ((svars.PreliminaryFlag02 == false ) and (checkAlert == true) and ( checkEnemy == false )) then

									
									local func = function()
										
										s10130_radio.CallMonologueCodeTalker03()
										TppBuddyService.SetIgnoreDisableNpc( false )
									end
									
									TppBuddyService.SetIgnoreDisableNpc( true )
									s10130_demo.PlayCemeteryCodetalkerDemo(func)

								
								else
									
									s10130_radio.CallMonologueCodeTalker04()
								end
							else
								Fox.Log("s10130_mission Codetalker Carrydemo was played")
							end
						else
							Fox.Log("s10130_mission Monologue Player Not Carry Hostage!!!Can not play demo")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.SNEAK_BGM_RESTART,
					func = function ()
						if svars.isParasiteSNBGMStart == false then
							Fox.Log("s10130_mission CamoParasiteSNBGMStart!!")
							svars.isParasiteSNBGMStart	= true
							s10130_sound.BGMParasitesSneek2()
							
							s10130_enemy.CamoParasiteFogOn()
						else
							Fox.Log("s10130_mission CamoParasiteSNBGM none!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.ROUTECHANGE002,
					func = function ()













					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.CHASEWEST,
					func = function()
						if svars.isChaseWest == false then
							Fox.Log("s10130_mission Parasite Chase West!!")
							svars.isChaseWest = true

						else
							Fox.Log("s10130_mission Parasite was Chase West!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.CHASESOUTH,
					func = function()
						if svars.isChaseSouth == false then
							Fox.Log("s10130_mission Parasite Chase South!!")
							svars.isChaseSouth = true

						else
							Fox.Log("s10130_mission Parasite was Chase South!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.RETURNWEST,
					func = function()
						if svars.isChaseWest == true then
							Fox.Log("s10130_mission Parasite Return West!!")
							svars.isChaseWest = false

						else
							Fox.Log("s10130_mission Parasite was Return West!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.RETURNSOUTH,
					func = function()
						if svars.isChaseSouth == true then
							Fox.Log("s10130_mission Parasite Return South!!")
							svars.isChaseSouth = false

						else
							Fox.Log("s10130_mission Parasite was Return South!!")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.ZOMBIE,
					func = function()
						if svars.isArrivalZombie == false then
							svars.isArrivalZombie = true
							
							s10130_radio.ZombieRadio01()
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.RESTRICTION_RELEASE,
					func = function()
						Fox.Log("*** Finish::StartEnableAction Trap ***")
						if svars.PreliminaryFlag03 == false then
							svars.PreliminaryFlag03 = true
							
							this.StartEnableActionForEvent()
						end
						
						if not(svars.PreliminaryFlag10) then
							svars.PreliminaryFlag10 = true
							this.EnableEnemyFor("Seq_A")
						end
					end
				},
			},
			Radio = {
				{
					msg = "Finish",
					sender = "s0130_rtrg4010",
					func = function ()
						
						s10130_radio.ZombieRadio02()
					end
				},
			},
			GameObject = {
				
				{
					msg = "PlacedIntoVehicle", sender = TARGET_HOSTAGE_NAME,
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10130_sequence:TARGET_HOSTAGE_NAME PlacedIntoVehicle !!!!!")
						svars.isRideOnHeli_CodeTalker = true
						
						local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
						GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })

						
						GkEventTimerManager.Start( "Timer_radio_HurryUp", 10 )
						
						
						TppHero.AddTargetLifesavingHeroicPoint( false, true )
						
						
						TppMission.UpdateObjective{
							objectives = { "announce_recoverTarget" },
						}
						
						TppMission.CanMissionClear()
					end,

				},
				{
				
					msg = "StartedCombat", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function ()
						
						if svars.PreliminaryFlag02 == false then
							svars.PreliminaryFlag02	= true

							
							s10130_enemy.CombatCamoParasiteSeq02()
						end

						
						if svars.isParasiteBattle == true then
							Fox.Log("s10130_mission CamoParasiteALBGMStart!!")
							s10130_sound.BGMParasitesAlert2()
						else
							Fox.Log("s10130_mission CamoParasiteALBGM none!!")
						end
					end
				},
				{
				
					msg = "QuietFinishReflex", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function (gameObjectId)
						Fox.Log("s10130_mission CamoParasiteALBGMStart!!")
						
						svars.isParasiteBattle	= true
						s10130_sound.BGMParasitesAlert2()
					end
				},				{
				
					msg = "Unconscious", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function (gameObjectId,arg01)
						this.ParasiteDisablementEvaluate(gameObjectId,"Seq_Game_Escape_A")
					end
				},
				{
				
					msg = "Dying", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function (gameObjectId,arg01)
						
						TppMission.UpdateObjective{	objectives = { "clear_missionTask_04" , },	}
					end
				},
				{
				
					msg = "Fulton", sender = {PARASITE000,PARASITE001,PARASITE002,PARASITE003},
					func = function (gameObjectId,arg01,arg02,arg03)
						
						for i, ParasiteName in ipairs( s10130_enemy.parasiteDefine ) do
							if GameObject.GetGameObjectId(ParasiteName) == gameObjectId then
								
								svars[ParasiteName.."Fulton"] = true
								break
							end
						end
						
						TppMission.UpdateObjective{	objectives = { "clear_missionTask_05", },	}
						
						if ((svars.wmu_lab_0000Fulton == true)and
							(svars.wmu_lab_0001Fulton == true)and
							(svars.wmu_lab_0002Fulton == true)and
							(svars.wmu_lab_0003Fulton == true)) then

							
							svars.isAllKillParasite = true
						end
					end
				},
			},
			Timer = {
				
				{
					msg = "Finish",
					sender = "checkCodeTalkerStatus",
					func = function ()
						Fox.Log("#### s10130_radio.DistantCodeTalker checkCodeTalkerStatus ####")
						this.FuncCheckCodeTalkerRange()
					end
				},
				
				{
					msg = "Finish",	sender = "Timer_radio_HurryUp",
					func = function ()
						Fox.Log("*** Finish::Timer_radio_HurryUp ***")
						s10130_radio.CodeTalkerStayInHeli()
					end
				},
				
				{
					msg = "Finish",	sender = "StartEnableAction",
					func = function ()
						Fox.Log("*** Finish::StartEnableAction Timer ***")
						if svars.PreliminaryFlag03 == false then
							svars.PreliminaryFlag03 = true
							
							this.StartEnableActionForEvent()
						end
					end
				},
				{
					msg = "Finish",
					sender = "ToDo00",
					func = function ()
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()
		Fox.Log("######## Seq_Game_Escape_A.OnEnter ########")
		
		
		TppMission.StartBossBattle()
		
		
		
		this.StartDisableActionForEvent()

		
		GkEventTimerManager.Start("StartEnableAction", 89.0 )

		
		this.LabShutterOff()

		
		TppDataUtility.SetEnableDataFromIdentifier( "NavIdentifier", "NavxNavFileLocator0000", true )

		
		this.GimmickReset()

		
		this.CoatOn()

		
		
		TppRadio.ChangeIntelRadio( s10130_radio.intelRadioListEscapeA )

		
		GkEventTimerManager.Start("CarryTalkStart01", 10.0 )

		
		TppSound.SetSceneBGM("bgm_codetalker_walk")

		
		TppScriptBlock.LoadDemoBlock("CemeteryCodetalkerDemo")

		
		this.eventDoorSetting()

		
		svars.isParasiteSNBGMStart	= false
		svars.isParasiteALBGMStart	= false
		svars.isParasiteBattle		= false
		
		
		WeatherManager.RequestWeather( TppDefine.WEATHER.CLOUDY, 5.0 )

		
		WeatherManager.PauseNewWeatherChangeRandom(true)

		
		s10130_enemy.WarpCamoParasiteSeq02()

		
		TppRadio.SetOptionalRadio("Set_s0130_oprg0040")
		
		TppRadio.EnableCommonOptionalRadio(false)

		
		s10130_enemy.SetUpCamoParasiteSeq02()

		
		s10130_enemy.ResetPositionCamoParasite()

		
		s10130_enemy.SetUpCamoParasiteResetAI( "wmu_lab_0000" )
		s10130_enemy.SetUpCamoParasiteResetAI( "wmu_lab_0001" )
		s10130_enemy.SetUpCamoParasiteResetAI( "wmu_lab_0002" )
		s10130_enemy.SetUpCamoParasiteResetAI( "wmu_lab_0003" )

		
		s10130_enemy.ResetPositionZombie()

		
		TppMarker.CompleteSearchTarget(TARGET_HOSTAGE_NAME)
		TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId(TARGET_HOSTAGE_NAME), langId="marker_chara_codetalker" }

		
		s10130_enemy.CamoParasiteOn()

		
		s10130_enemy.CamoParasiteForceUnrealize()

		
		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_01", },
		}

		
		TppMission.UpdateObjective{

			objectives = { "rv_missionClear", "rv_missionClear01",},
		}

		
		s10130_radio.GoToRV()

		
		
		svars.isDontPutCodeTalker = false

		
		GkEventTimerManager.Start( "checkCodeTalkerStatus", 5)

	end,

	OnLeave = function()
		
		TppMission.FinishBossBattle()
	end,

	OnUpdate = function()
	end,

}




sequences.Seq_Game_Escape_B = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Player = {
				
				{
					msg = "RideHelicopter",
					func = function()
						this.FuncPlayerRideOnHeli()
					end
				},
				
				{
					msg = "RideHelicopterWithHuman",
					func = function()
						this.FuncPlayerRideOnHeliWithHuman()
					end
				},
				
				{
					msg = "IconRideHelicopterStartShown",
					func = this.FuncHeliIcon
				},
			},
			Trap = {
				{
					msg = "Enter",
					sender = TRAP_NAME.DEMOBLOCK03,
					func = function()
						TppScriptBlock.LoadDemoBlock("CemeteryCodetalkerDemo")
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.CODETALKER_DEMO001,
					func = function ()
						
						local gameObjectId = GameObject.GetGameObjectId( "TppCodeTalker2", TARGET_HOSTAGE_NAME )
						local command = {	id = "GetStatus",	}
						local actionStatus = GameObject.SendCommand( gameObjectId, command )
						
						if actionStatus == TppGameObject.NPC_STATE_CARRIED then
							if svars.isCodetalkerDemo001 == false then
								Fox.Log("s10130_mission demo001")
								
								svars.isCodetalkerDemo001	= true
								svars.isCarryTalkStart02	= true

								
								TppRadio.ChangeIntelRadio( s10130_radio.intelRadioListCemeteryDemoEnd )

								
								for index, labelName in ipairs( this.longMonologueList01 ) do
									
									Fox.Log("s10130_mission Monologue Stop longMonologueList01 ".. labelName .. " bool= " .. tostring(svars[labelName]))
									svars[labelName] = true
								end

								
								
								local checkAlert = Tpp.IsNotAlert() 
								
								local checkEnemy = TppEnemy.IsActiveSoldierInRange( CHECK_ENEMY_POS02, CHECK_ENEMY_RANGE02 )
								
								this.RecoveryStaminaForCodeTalker()

								
								if ((checkAlert == true) and ( checkEnemy == false )) then

									
									local func = function()
										
										s10130_radio.CallMonologueCodeTalker03()
										TppBuddyService.SetIgnoreDisableNpc( false )
									end
									
									TppBuddyService.SetIgnoreDisableNpc( true )
									s10130_demo.PlayCemeteryCodetalkerDemo(func)

								
								else
									
									s10130_radio.CallMonologueCodeTalker04()
								end
							else
								Fox.Log("s10130_mission Codetalker Carrydemo was played")
							end
						else
							Fox.Log("s10130_mission Monologue Player Not Carry Hostage!!!Can not play demo")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.ZOMBIE,
					func = function()
						if svars.isArrivalZombie == false then
							svars.isArrivalZombie = true
							Fox.Log("#### s10130_radio.CPRadio02 Start ####")
							s10130_radio.CPRadio02()
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.RESTRICTION_RELEASE,
					func = function()
						Fox.Log("*** Finish::StartEnableAction Trap ***")
						if svars.PreliminaryFlag03 == false then
							svars.PreliminaryFlag03 = true
							
							this.StartEnableActionForEvent()
						end
						
						if not(svars.PreliminaryFlag10) then
							svars.PreliminaryFlag10 = true
							this.EnableEnemyFor("Seq_B")
							TppSound.StopSceneBGM()
							TppSound.SetPhaseBGM( "bgm_codetalker_2nd" )
						end
					end
				},
			},
			GameObject = {
				
				{
					msg = "PlacedIntoVehicle", sender = TARGET_HOSTAGE_NAME,
					func = function( arg0, arg1 )
						Fox.Log("!!!!! s10130_sequence:TARGET_HOSTAGE_NAME PlacedIntoVehicle !!!!!")
						svars.isRideOnHeli_CodeTalker = true
						
						local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
						GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })

						
						GkEventTimerManager.Start( "Timer_radio_HurryUp", 10 )
						
						
						TppHero.AddTargetLifesavingHeroicPoint( false, true )
						
						
						TppMission.UpdateObjective{
							objectives = { "announce_recoverTarget" },
						}

						TppMission.CanMissionClear()
					end,

				},
				
				{
					
					msg = "RadioEnd",
					func = function( GameObjectId, cpGameObjectId, speechLabel, isSuccess )
						Fox.Log( "*** ConversationEnd ***")
						if speechLabel == StrCode32( "CPRSP020" ) then
							s10130_radio.ZRSCPtoKazuEscape()
							
							local command = { id = "SetKeepCaution", enable = true } 
							for i, cpId in pairs( s10130_enemy02.cpIdList ) do
								GameObject.SendCommand( GameObject.GetGameObjectId(cpId), command ) 
							end
						end
					end
				},
			},
			Timer = {
				
				{
					msg = "Finish",
					sender = "checkCodeTalkerStatus",
					func = function ()
						Fox.Log("#### s10130_radio.DistantCodeTalker checkCodeTalkerStatus ####")
						this.FuncCheckCodeTalkerRange()
					end
				},
				
				{
					msg = "Finish",	sender = "Timer_radio_HurryUp",
					func = function ()
						Fox.Log("*** Finish::Timer_radio_HurryUp ***")
						s10130_radio.CodeTalkerStayInHeli()
					end
				},
				
				{
					msg = "Finish",	sender = "StartEnableAction",
					func = function ()
						Fox.Log("*** Finish::StartEnableAction Timer ***")
						if svars.PreliminaryFlag03 == false then
							svars.PreliminaryFlag03 = true
							
							this.StartEnableActionForEvent()
						end
					end
				},
				
				{
					msg = "Finish",
					sender = "CPRadio02Start",
					func = function ()
						Fox.Log("#### s10130_radio.CPRadio02 Start ####")
						s10130_radio.CPRadio02()
					end
				},
				{
					msg = "Finish",
					sender = "ToDo00",
					func = function ()
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()
		Fox.Log("######## Seq_Game_Escape_B.OnEnter ########")

		
		
		this.StartDisableActionForEvent()

		
		GkEventTimerManager.Start("StartEnableAction", 89.0 )

		
		this.LabShutterOff()

		
		TppDataUtility.SetEnableDataFromIdentifier( "NavIdentifier", "NavxNavFileLocator0000", true )

		
		this.GimmickReset()

		
		this.CoatOn()

		
		
		TppRadio.ChangeIntelRadio( s10130_radio.intelRadioListEscapeB )

		
		GkEventTimerManager.Start("CarryTalkStart01", 10.0 )

		
		TppSound.SetSceneBGM("bgm_codetalker_walk")

		
		this.eventDoorSetting()

		
		s10130_enemy02.EnemyReloadResetPosition()
		
		
		s10130_enemy02.SetEnabledFlagToEnemyHeli(false)

		
		TppRadio.SetOptionalRadio("Set_s0130_oprg0040")
		
		
		TppRadio.EnableCommonOptionalRadio(false)

		
		TppMarker.CompleteSearchTarget(TARGET_HOSTAGE_NAME)
		TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId(TARGET_HOSTAGE_NAME), langId="marker_chara_codetalker" }

		
		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_01", },
		}

		
		TppMission.UpdateObjective{

			objectives = { "rv_missionClear", "rv_missionClear01",},
		}

		
		s10130_radio.GoToRV()

		
		
		svars.isDontPutCodeTalker = false

		
		GkEventTimerManager.Start( "checkCodeTalkerStatus", 5)

		
		s10130_enemy02.SetRelativeVehicle()

	end,

	OnLeave = function()
	end,

	OnUpdate = function()
	end,

}



sequences.Seq_Demo_ClearDemo = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Demo = {
				{ 	msg = "Skip",
					func = function()
						if TppUiCommand.IsDispToBeContinue() then
							Fox.Log(" true - IsDispToBeContinue")
							mvars.IsContinued = false	
						else
							Fox.Log("false - IsDispToBeContinue")
							mvars.IsContinued = true	
						end
					end,
					option = { isExecDemoPlaying = true,},
				},
				nil
			},	
			
			nil
		}
	end,
	OnEnter = function()
		mvars.IsContinued = false 
		local func = function()
			Player.SetPause()
			TppSequence.SetNextSequence( "Seq_ToBeContinued", { isExecMissionClear = true } )
		end
		s10130_demo.PlayClearDemo(func)
	end,

	OnLeave = function ()
	end,

}



sequences.Seq_ToBeContinued = {
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{ msg = "TelopTypingEnd",
					func = function()
						TppMission.MissionFinalize()
					end,
					option = { isExecMissionClear = true, } 
				},
			},
			
			nil
		}
	end,

	OnEnter = function()
		TppSoundDaemon.SetMute( 'Loading' )	
		
		if mvars.IsContinued then
			TppUiCommand.CallMissionTelopTyping( "mission_to_be_continued", "" )
		else
			TppMission.MissionFinalize()
		end
		
	end,

	OnLeave = function ()
	end,
}




return this
