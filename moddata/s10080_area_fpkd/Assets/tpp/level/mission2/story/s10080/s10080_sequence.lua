
local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}
local TimerStart = GkEventTimerManager.Start






this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PICKABLE_LOCATOR_COUNT = 80


this.MAX_PLACED_LOCATOR_COUNT = 100


this.EQUIP_MISSION_BLOCK_GROUP_SIZE = 1340000


this.MISSION_START_INITIAL_WEATHER  = TppDefine.WEATHER.CLOUDY





local FLOWSTATION 					= "mafr_flowStation"


local MARKER_NAME_AREA_FLOWSTATION	= "s10080_marker_flowStation"
local MARKER_NAME_AREA_TANK			= "s10080_marker_targetTank"
local MARKER_NAME_AREA_SWITCHAREA	= "s10080_marker_targetSwitchArea"
local MARKER_NAME_AREA_SWITCH		= "s10080_marker_targetSwitch"
local MARKER_NAME_AREA_CONTAINER	= "s10080_marker_container"


local OPENMB_TIMER					= 5
local CANCLOSEMB_TIMER				= 10
local CLEARING_TIMER				= 60
local STOPPUMP_TIMER				= 60
local REINFORCEMNT_TIMER			= 10
local TANKDERAY_TIMER				= 0.75
local CHILDDEMO_TIMER				= 30
local EXPLOSION_DERAY_TIMER			= 2


local PUMP_NAME	 					= "mtbs_mchn015_vrtn002_gim_n0000|srt_mtbs_mchn015_vrtn002"		
local PUMP_NAME_I 					= "mtbs_mchn015_vrtn002_gim_i0000|TppPermanentGimmick_mtbs_mchn015_vrtn002"		
local TANK_NAME1_I 					= "mafr_tank005_gim_i0000|TppPermanentGimmick_mafr_tank005"		
local TANK_NAME2_I 					= "mafr_tank003_gim_i0000|TppPermanentGimmick_mafr_tank003"		


local PUMP_SWITCH_NAME1	 			= "flowStation_pumpSwitch"		
local TANK_ID_NAME1	 				= "flowStation_tank005"			
local TANK_ID_NAME2	 				= "flowStation_tank003_00"		
local TANK_ID_NAME3	 				= "flowStation_tank003_01"		
local TANK_ID_NAME4	 				= "flowStation_tank003_02"		
local TANK_ID_NAME5	 				= "flowStation_tank005_vrtn006"	
local PDOR_NAME1	 				= "flowStation_pickingDoor_01"		
local PDOR_NAME2	 				= "flowStation_pickingDoor_02"		

local S10080_GIMMICK_PATH			= "/Assets/tpp/level/mission2/story/s10080/s10080_sequence.fox2"	
local FLOWSTATION_GIMMICK_PATH 		= "/Assets/tpp/level/location/mafr/block_large/flowStation/mafr_flowStation_gimmick.fox2"


local resetGimmickIdTable_Tank = {
	PDOR_NAME1,
	PDOR_NAME2,





}
local resetGimmickIdTable_Pump = {
	PUMP_SWITCH_NAME1,
}


local CHECKPOINT_NAME				= "CHK_MissionStart"
local RELOAD_CHECKPOINT_NAME		= "CHK_MissionStart"


this.PLAYERAREA_STATUS = Tpp.Enum{	
	"IN_STARTPOINT", 		
	"IN_OUTLAND",			
	"IN_ROAD",				
	"IN_FLOWSTATION",		
}


this.FLOWSTATIONAREA_STATUS = Tpp.Enum{	
	"TANK_UNDER1", 
	"TANK_UNDER2",
	"TANK_UNDER3", 
	"TANK_UNDER4",
	"TANK_UNDER5", 
	"TANK_UNDER6",
	"TANK_UNDER7",
	"TANK_UNDER8",
	"TANK_UPPER1",
	"TANK_UPPER2",	
	"TANK_UPPER3",
	"TANK_UPPER4",
	"TANK_UPPER5",	
	"TANK_UPPER6",
	"TANK_UPPER7",
	"TANK_UPPER8",	
	"TANK_UPPER9",
	"TANK_OUTSIDE1",
	"TANK_OUTSIDE2",
	"TANK_OUTSIDE3",
	"TANK_OUTSIDE4",
	"TANK_OUTSIDE5",
	"TANK_OUTSIDE6",	
	"TANK_OUTSIDE7",
	"TANK_OUTSIDE8",
	"TANK_OUTSIDE9",
	"TANK_OUTSIDE10",
	"TANK_OUTSIDE11",
	"PUMP1",
	"PUMP2",
	"PUMP3",
	"PUMP4",
	"PUMP5",
	"PUMP6",
	"PUMP7",
	"PUMP8",
	"PUMP9",
	"PUMP10",
	"PUMP11",
	"PUMP_UNDER1",
	"PUMP_UNDER2",	
	"PUMP_UNDER3",
	"PUMP_UNDER4",	
	"PUMP_UNDER5",	
	"PUMP_UNDER6",	
	"PUMP_UPPER1",
	"PUMP_UPPER2",
	"PUMP_UPPER3",
	"PUMP_UPPER4",
	"PUMP_UPPER5",
	"PUMP_UPPER6",
	"OTHER1",
	"OTHER2",
	"OTHER3",
	"OTHER4",
	"OTHER5",
	"OTHER6",
	"ROAD1",
	"ROAD2",
	"ROAD3",
	"ROAD4",
	"ROAD5",
	"ROAD6",
	"ROAD7",
	"ROAD8",
	"ROAD9",
	"ROAD10",
	"ROAD11",
	"OUTOFAREA",
}

local ReloadCheckpointNameTable = {
	[this.FLOWSTATIONAREA_STATUS.TANK_UNDER1] = "CHK_FlowStation_Tank_Under1",
	[this.FLOWSTATIONAREA_STATUS.TANK_UNDER2] = "CHK_FlowStation_Tank_Under2",
	[this.FLOWSTATIONAREA_STATUS.TANK_UNDER3] = "CHK_FlowStation_Tank_Under3",
	[this.FLOWSTATIONAREA_STATUS.TANK_UNDER4] = "CHK_BreakTank",
	[this.FLOWSTATIONAREA_STATUS.TANK_UNDER5] = "CHK_FlowStation_Tank_Under5",
	[this.FLOWSTATIONAREA_STATUS.TANK_UNDER6] = "CHK_FlowStation_Tank_Under6",
	[this.FLOWSTATIONAREA_STATUS.TANK_UNDER7] = "CHK_FlowStation_Tank_Under7",
	[this.FLOWSTATIONAREA_STATUS.TANK_UNDER8] = "CHK_FlowStation_Tank_Under8",
	[this.FLOWSTATIONAREA_STATUS.TANK_UPPER1] = "CHK_FlowStation_Tank_Upper1",
	[this.FLOWSTATIONAREA_STATUS.TANK_UPPER2] = "CHK_FlowStation_Tank_Upper2",
	[this.FLOWSTATIONAREA_STATUS.TANK_UPPER3] = "CHK_FlowStation_Tank_Upper3",
	[this.FLOWSTATIONAREA_STATUS.TANK_UPPER4] = "CHK_FlowStation_Tank_Upper4",
	[this.FLOWSTATIONAREA_STATUS.TANK_UPPER5] = "CHK_FlowStation_Tank_Upper5",
	[this.FLOWSTATIONAREA_STATUS.TANK_UPPER6] = "CHK_FlowStation_Tank_Upper6",
	[this.FLOWSTATIONAREA_STATUS.TANK_UPPER7] = "CHK_FlowStation_Tank_Upper7",
	[this.FLOWSTATIONAREA_STATUS.TANK_UPPER8] = "CHK_FlowStation_Tank_Upper8",
	[this.FLOWSTATIONAREA_STATUS.TANK_UPPER9] = "CHK_FlowStation_Tank_Upper9",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE1] = "CHK_FlowStation_Tank_Outside1",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE2] = "CHK_FlowStation_Tank_Outside2",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE3] = "CHK_FlowStation_Tank_Outside3",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE4] = "CHK_FlowStation_Tank_Outside4",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE5] = "CHK_FlowStation_Tank_Outside5",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE6] = "CHK_FlowStation_Tank_Outside6",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE7] = "CHK_FlowStation_Tank_Outside7",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE8] = "CHK_FlowStation_Tank_Outside8",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE9] = "CHK_FlowStation_Tank_Outside9",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE10] = "CHK_FlowStation_Tank_Outside10",
	[this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE11] = "CHK_FlowStation_Tank_Outside11",
	[this.FLOWSTATIONAREA_STATUS.PUMP1] = "CHK_FlowStation_Pump1",
	[this.FLOWSTATIONAREA_STATUS.PUMP2] = "CHK_FlowStation_Pump2",
	[this.FLOWSTATIONAREA_STATUS.PUMP3] = "CHK_FlowStation_Pump3",
	[this.FLOWSTATIONAREA_STATUS.PUMP4] = "CHK_FlowStation_Pump4",
	[this.FLOWSTATIONAREA_STATUS.PUMP5] = "CHK_FlowStation_Pump5",
	[this.FLOWSTATIONAREA_STATUS.PUMP6] = "CHK_FlowStation_Pump6",
	[this.FLOWSTATIONAREA_STATUS.PUMP7] = "CHK_FlowStation_Pump7",
	[this.FLOWSTATIONAREA_STATUS.PUMP8] = "CHK_FlowStation_Pump8",
	[this.FLOWSTATIONAREA_STATUS.PUMP9] = "CHK_FlowStation_Pump9",
	[this.FLOWSTATIONAREA_STATUS.PUMP10] = "CHK_FlowStation_Pump10",
	[this.FLOWSTATIONAREA_STATUS.PUMP11] = "CHK_FlowStation_Pump11",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UNDER1] = "CHK_FlowStation_Pump_Under1",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UNDER2] = "CHK_FlowStation_Pump_Under2",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UNDER3] = "CHK_FlowStation_Pump_Under3",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UNDER4] = "CHK_FlowStation_Pump_Under4",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UNDER5] = "CHK_FlowStation_Pump_Under5",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UNDER6] = "CHK_FlowStation_Pump_Under6",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UPPER1] = "CHK_FlowStation_Pump_Upper1",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UPPER2] = "CHK_FlowStation_Pump_Upper2",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UPPER3] = "CHK_FlowStation_Pump_Upper3",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UPPER4] = "CHK_FlowStation_Pump_Upper4",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UPPER5] = "CHK_FlowStation_Pump_Upper5",
	[this.FLOWSTATIONAREA_STATUS.PUMP_UPPER6] = "CHK_StopPump",
	[this.FLOWSTATIONAREA_STATUS.OTHER1] = "CHK_FlowStation_Other1",
	[this.FLOWSTATIONAREA_STATUS.OTHER2] = "CHK_FlowStation_Other2",
	[this.FLOWSTATIONAREA_STATUS.OTHER3] = "CHK_FlowStation_Other3",
	[this.FLOWSTATIONAREA_STATUS.OTHER4] = "CHK_FlowStation_Other4",
	[this.FLOWSTATIONAREA_STATUS.OTHER5] = "CHK_FlowStation_Other5",
	[this.FLOWSTATIONAREA_STATUS.OTHER6] = "CHK_FlowStation_Other6",
	[this.FLOWSTATIONAREA_STATUS.ROAD1] = "CHK_FlowStation_Road1",
	[this.FLOWSTATIONAREA_STATUS.ROAD2] = "CHK_FlowStation_Road2",
	[this.FLOWSTATIONAREA_STATUS.ROAD3] = "CHK_FlowStation_Road3",
	[this.FLOWSTATIONAREA_STATUS.ROAD4] = "CHK_FlowStation_Road4",
	[this.FLOWSTATIONAREA_STATUS.ROAD5] = "CHK_FlowStation_Road5",
	[this.FLOWSTATIONAREA_STATUS.ROAD6] = "CHK_FlowStation_Road6",
	[this.FLOWSTATIONAREA_STATUS.ROAD7] = "CHK_FlowStation_Road7",
	[this.FLOWSTATIONAREA_STATUS.ROAD8] = "CHK_FlowStation_Road8",
	[this.FLOWSTATIONAREA_STATUS.ROAD9] = "CHK_FlowStation_Road9",
	[this.FLOWSTATIONAREA_STATUS.ROAD10] = "CHK_FlowStation_Road10",
	[this.FLOWSTATIONAREA_STATUS.ROAD11] = "CHK_FlowStation_Road11",
	[this.FLOWSTATIONAREA_STATUS.OUTOFAREA] = "",
}

local nextBrakeTankName = ""








function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		"Seq_Demo_InAfrica",
		"Seq_Game_Opening",
		"Seq_Demo_Opening",
		"Seq_Game_MissionSetting",
		"Seq_Game_StopFlowStation",
		"Seq_Game_Escape",
		"Seq_Demo_Reinforcement",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {

	playerAreaStatus			= this.PLAYERAREA_STATUS.IN_STARTPOINT,		

	
	isChanegePhase 				= false,		
	isPlayDemo_TeachChild		= false,		
 
	isCanTraining				= true,			
 
	isAroundTank				= false,		
 	isPutC4						= false,		
	
	isBreakedTank				= false,		
	isStopedPump				= false,		
	isBreakedTank_after_StopedPump		= false,	

	isFlowStationCpAnnihilated	= false,		

	isReinforcement				= false,		
	isReinforcement1_arrived	= false,		
	isReinforcement2_arrived	= false,		

	isCanReinforcement			= true,			

	isClearingComplete			= false,		

	isMountainHunting_ready		= false,		
	isMountainHunting_started	= false,		
	
	isInFlowStation				= false,		
	
	isInDay						= true,
	
	isFultoned_child1			= this.FLOWSTATIONAREA_STATUS.OTHER3,		
	isFultoned_child2			= false,
	isFultoned_child3			= false,
	isFultoned_child4			= false,
	
	
	DisableTranslateCount		= 0,
	
	RescueChildCount			= 0,
	RescueWalkerGearCount		= 0,
	
	TeacherTranslateCount		= 0,
	
	
	isLoadedFlowStation			= false,
	
	
	isSNARradio					= false,
	
	
	isLook_TeachChildDemo		= false,
	
	afterBreakTank_reloadCount = 0,
	
	isArrivalFlowStation		= false,		
	
	isJingleCharred				= false,		
}


this.checkPointList = {
	"CHK_MissionStart",		
	"CHK_StopPump",			
	"CHK_BreakTank",		
	
	"CHK_FlowStation_Tank_Under1",
	"CHK_FlowStation_Tank_Under2",	
	"CHK_FlowStation_Tank_Under3",

	"CHK_FlowStation_Tank_Under5",
	"CHK_FlowStation_Tank_Under7",
	"CHK_FlowStation_Tank_Upper1",	
	"CHK_FlowStation_Tank_Upper2",	
	"CHK_FlowStation_Tank_Upper4",	
	"CHK_FlowStation_Tank_Upper5",	
	"CHK_FlowStation_Tank_Upper6",	
	"CHK_FlowStation_Tank_Upper7",	
	"CHK_FlowStation_Tank_Upper9",			
	"CHK_FlowStation_Tank_Outside5",	
	"CHK_FlowStation_Tank_Outside6",		
	"CHK_FlowStation_Tank_Outside7",	
	"CHK_FlowStation_Tank_Outside8",	
	"CHK_FlowStation_Tank_Outside9",	
	"CHK_FlowStation_Tank_Outside10",	
	"CHK_FlowStation_Tank_Outside11",		
	"CHK_FlowStation_Pump1",
	"CHK_FlowStation_Pump2",
	"CHK_FlowStation_Pump3",
	"CHK_FlowStation_Pump5",
	"CHK_FlowStation_Pump6",
	"CHK_FlowStation_Pump7",
	"CHK_FlowStation_Pump8",
	"CHK_FlowStation_Pump9",
	"CHK_FlowStation_Pump10",
	"CHK_FlowStation_Pump11",
	"CHK_FlowStation_Pump_Upper1",
	"CHK_FlowStation_Pump_Upper2",
	"CHK_FlowStation_Pump_Upper3",
	"CHK_FlowStation_Pump_Upper4",
	"CHK_FlowStation_Pump_Upper5",

	"CHK_FlowStation_Pump_Under2",
	"CHK_FlowStation_Pump_Under3",
	"CHK_FlowStation_Pump_Under4",
	"CHK_FlowStation_Pump_Under6",	
	"CHK_FlowStation_Other1",
	"CHK_FlowStation_Other2",
	"CHK_FlowStation_Other3",
	"CHK_FlowStation_Other4",
	"CHK_FlowStation_Other5",	
	"CHK_FlowStation_Other6",
	"CHK_FlowStation_Road1",
	"CHK_FlowStation_Road2",
	"CHK_FlowStation_Road3",
	"CHK_FlowStation_Road4",
	"CHK_FlowStation_Road5",
	"CHK_FlowStation_Road6",
	"CHK_FlowStation_Road7",
	"CHK_FlowStation_Road8",
	"CHK_FlowStation_Road9",
	"CHK_FlowStation_Road10",
	"CHK_FlowStation_Road11",
	nil
}

this.baseList = {
	"outland",
	"flowStation",
	"outlandNorth",
	"outlandEast",
	"swampWest",
	nil
}

this.missionStartPosition = {
        helicopterRouteList = {
				"rts_drproute_outland_S_0001"
        },
}







this.missionObjectiveDefine = {
	
	
	default_area_flowStation = {
		gameObjectName = MARKER_NAME_AREA_FLOWSTATION, visibleArea = 5, viewType = "all", randomRange = 0, setNew = false, 
		langId = "marker_info_mission_targetArea",
	},
	
	default_area_arrivalFlowStation = {
		targetBgmCp = "mafr_flowStation_cp",
	},
	
	default_area_targetTank = {
		gameObjectName = MARKER_NAME_AREA_TANK, visibleArea = 1, 
		goalType = "attack",viewType = "all", randomRange = 0, setNew = false, 
		langId = "marker_info_mission_targetArea",mapRadioName = "s0080_mprg1020",
	},
	default_area_targetTank_important = {
		gameObjectName = MARKER_NAME_AREA_TANK, visibleArea = 0, 
		goalType = "attack", viewType = "all", setNew = true, setImportant = true, announceLog = "updateMap",
		langId = "marker_info_mission_target",mapRadioName = "s0080_mprg1020",
	},
	default_area_targetTank_break = {
		announceLog = "destroyTarget",
	},	
	
	default_area_targetPump = {
		gameObjectName = MARKER_NAME_AREA_SWITCHAREA, visibleArea = 1, 
		goalType = "attack", viewType = "all", randomRange = 1, setNew = false, 
		langId = "marker_info_mission_targetArea",mapRadioName = "s0080_mprg1010",
	},
	default_area_targetPump_intel = {
		gameObjectName = MARKER_NAME_AREA_SWITCH, visibleArea = 1,
		goalType = "attack", viewType = "all", setNew = true, setImportant = true, announceLog = "updateMap",
		langId = "marker_info_mission_target",mapRadioName = "s0080_mprg1010",
	},
	default_area_targetPump_discover = {
		gameObjectName = MARKER_NAME_AREA_SWITCH, visibleArea = 0, 
		goalType = "attack", viewType = "all", setNew = true, setImportant = true, announceLog = "updateMap",
		langId = "marker_info_mission_target",mapRadioName = "s0080_mprg1010",
	},
	default_area_targetPump_stop = {
		announceLog = "updateMissionInfo",
	},
	
	default_area_container = {
		gameObjectName = MARKER_NAME_AREA_CONTAINER, visibleArea = 1, 
		viewType = "map_only_icon", randomRange = 0, setNew = true, announceLog = "updateMap",
		langId = "marker_container",
	},	
	default_area_container_get = {
	},	
	
	rv_missionClear = {
		announceLog = "achieveAllObjectives",
	},
	
	
	photo_flowStation = {	
		photoId			= 10,
		photoRadioName	= "s0080_mirg1010"
	},
	photo_tank = {	
		photoId			= 20,
		photoRadioName	= "s0080_mirg1020"
	},
	photo_pumpArea = {	
		photoId			= 30,
		photoRadioName	= "s0080_mirg1030"
	},

	
	subGoal_default = {		
		subGoalId= 0,
	},
	subGoal_escape = {		
		subGoalId= 1,
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
		missionTask = { taskNo = 2, isNew = true, isComplete = false ,isFirstHide=true },
	},
	clear_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = true },
	},
	
	default_missionTask_04 = {	
		missionTask = { taskNo = 3, isNew = true, isComplete = false ,isFirstHide=true },
	},
	clear_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = true },
	},

	
	default_missionTask_05 = {	
		missionTask = { taskNo = 4, isNew = true, isComplete = false ,isFirstHide=true },
	},
	clear_missionTask_05 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = true },
	},

	
	default_missionTask_06 = {	
		missionTask = { taskNo = 5, isNew = true, isComplete = false ,isFirstHide=true },
	},
	clear_missionTask_06 = {
		missionTask = { taskNo = 5, isNew = true, isComplete = true },
	},
}




this.missionObjectiveTree = {
	rv_missionClear = {
		default_area_targetTank_break = {
			default_area_targetTank_important = {
				default_area_targetTank = {},
			},
		},		
		default_area_targetPump_stop = {
			default_area_targetPump_discover = {
				default_area_targetPump_intel = {
					default_area_targetPump = {},
				},
			},	
		},
		default_area_arrivalFlowStation = {
			default_area_flowStation = {},
		},
		default_area_container_get = {
			default_area_container = {},
		},
	},
	photo_flowStation = {},
	photo_tank = {},
	photo_pumpArea = {},
	
	clear_missionTask_01 = 	{
		default_missionTask_01,
	},
	clear_missionTask_02 = {
		default_missionTask_02,	
	},
	clear_missionTask_03 = {
		default_missionTask_03,
	},
	clear_missionTask_04 = {
		default_missionTask_04,
	},
	clear_missionTask_05 = {
		default_missionTask_05,
	},
	clear_missionTask_06 = {
		default_missionTask_06,
	},

}

this.missionObjectiveEnum = Tpp.Enum{
	"default_area_flowStation",
	"default_area_arrivalFlowStation",
	"default_area_targetTank",
	"default_area_targetTank_important",
	"default_area_targetTank_break",
	"default_area_targetPump",
	"default_area_targetPump_intel",
	"default_area_targetPump_discover",
	"default_area_targetPump_stop",
	"default_area_container",
	"default_area_container_get",
	"rv_missionClear",
	"photo_flowStation",
	"photo_tank",
	"photo_pumpArea",
	"subGoal_default",
	"subGoal_escape",
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
}



this.missionTask_3_bonus_TARGET_LIST = {	
	"sol_child_0000",				
	"sol_child_0001",			
	"sol_child_0002",				
	"sol_child_0003",		
}
this.missionTask_5_TARGET_LIST = {	
	"wkr_s10080_0000",
	"wkr_s10080_0001",
	"wkr_s10080_0002",
	"wkr_s10080_0003",	
}

this.specialBonus = {
        first = {
                missionTask = { taskNo = 2 },
        },
        second = {
                missionTask = { taskNo = 3 },
        }
}




this.VARIABLE_TRAP_SETTING = {
        { name = "trap_MountainHunting", 	type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.DISABLE, } ,
        { name = "trap_RoadBlocked_1", 		type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.DISABLE, } ,
        { name = "trap_RoadBlocked_2",	 	type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.DISABLE, } ,
        { name = "trap_TeachChildDemo",	 	type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.DISABLE, } ,
}




this.NPC_ENTRY_POINT_SETTING = {
	[TppDefine.INIT_HELI_ROUTE] = {
		[EntryBuddyType.VEHICLE] = { Vector3(-480.132, -11.938, 1142.344), TppMath.DegreeToRadian(82.0) }, 
		[EntryBuddyType.BUDDY] = { Vector3(-488.708, -12.176, 1140.744), TppMath.DegreeToRadian(80.0) }, 
	},
}







function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	
	
	local largeBlockNames = { FLOWSTATION }
	StageBlock.AddLargeBlockNameForMessage(largeBlockNames)
	
	
	this.RegiserMissionSystemCallback()

	
	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "Demo_ArrivalInAfrica" },
	}	

	
	TppRatBird.EnableBird( "TppCritterBird" )
		
	
	TppEnemy.RequestLoadWalkerGearEquip()	

	if TppMission.IsMissionStart() then		
		
		TppBuddyService.ReserveBuddyForLandStart(BuddyInitStatus.RIDE)
	end
	
	if TppMission.IsHardMission( vars.missionCode ) then
		TppMission.RegistDiscoveryGameOver()
	end

end



function this.OnEndMissionPrepareSequence()
	
	WeatherManager.RequestTag("pitchDark", 0 )

	
	this.FuncWeatherSetting()
	
	
	if svars.isLoadedFlowStation  == true  then
		this.FuncFlowStationModelChange()
	end
end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	
	if TppMission.IsMissionStart() then
		if TppStory.IsMissionCleard( 10080 )  == false then

			Fox.Log("s10080:settingtime")
			
			TppClock.SetTime( "15:00:00" )

		end
	end

	
	this.FuncSetIgnoreReinforce()

	if TppPackList.IsMissionPackLabel( "afterPumpStopDemo" ) then
		
		s10080_enemy.SwitchEnableCpSoldiers(s10080_enemy.CHILD_NAME_LIST,false)

	else
		
		s10080_enemy.childRouteSet_check()
	end
end


function this.RegiserMissionSystemCallback()

	local systemCallbackTable ={
	
		OnRecovered 				= this.OnRecovered,	
		OnEstablishMissionClear 	= this.OnEstablishMissionClear,
		OnGameOver 					= this.OnGameOver,
		OnOutOfMissionArea 			= this.OnOutOfMissionArea,
		OnSetMissionFinalScore 		= this.OnSetMissionFinalScore,
		
		
		CheckMissionClearFunction = function()
			if svars.isBreakedTank == true and	svars.isStopedPump == true then
				return true
			else
				return false
			end
		end,
		
		nil
	}
	
	TppMission.RegiserMissionSystemCallback(systemCallbackTable)

end


function this.OnOutOfMissionArea()
	Fox.Log("*** s10080:OnOutOfMissionArea ***")
	if TppStory.IsMissionCleard( 10080 )  == true then
		
		TppMission.AbortForOutOfMissionArea{ isNoSave = false }
	else
		
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.OUTSIDE_OF_MISSION_AREA, TppDefine.GAME_OVER_RADIO.OUT_OF_MISSION_AREA )
	end
end


function this.OnSetMissionFinalScore()
	Fox.Log("*** s10080:OnSetMissionFinalScore ***")
	
	if svars.isReinforcement == false then
		


		
		TppResult.AcquireSpecialBonus{
			second = { isComplete = true },
		}	
	end		
end


function this.OnEstablishMissionClear( missionClearType )
	Fox.Log("*** " .. tostring(missionClearType) .. " OnEstablishMissionClear ***")

	s10080_radio.afterMissionRadio()

	
	if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
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


function this.OnGameOver(gameOverType)
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.PLAYER_KILL_CHILD_SOLDIER ) then
		TppPlayer.SetPlayerKilledChildCamera()
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end
end


function this.OnRecovered(gameObjectId)
	Fox.Log("##** OnRecovered_is_coming ####")
	
	if this.DoesIncludeTarget( gameObjectId, this.missionTask_3_bonus_TARGET_LIST ) then
		s10080_radio.FultonChild()
		
		svars.RescueChildCount = svars.RescueChildCount + 1
		if svars.RescueChildCount == 4 then
			TppResult.AcquireSpecialBonus{ 
				first = { isComplete = true  },
			}	
		end
	end
	
	if this.DoesIncludeTarget( gameObjectId, this.missionTask_5_TARGET_LIST ) then
		svars.RescueWalkerGearCount = svars.RescueWalkerGearCount + 1
		if svars.RescueWalkerGearCount == 4 then
			TppMission.UpdateObjective{	objectives = { "clear_missionTask_06"},		}
		end
	end
end








function this.Messages()
	return
	StrCode32Table {
		GameObject = {
			{ msg = "CommandPostAnnihilated", 	func = this.FuncCPAnnihilatedCheck },
			{ msg = "DisableTranslate",	 		func = this.FuncDisableTranslate },		
			{ msg = "RoutePoint2",				func = this.FuncRoutePoint		},	
			{ msg = "Fulton", 	
				func = function(gameobjectId,animalId)
					local animalType = GameObject.GetTypeIndex( gameobjectId )
					if animalType == TppGameObject.GAME_OBJECT_TYPE_EAGLE then
						TppMission.UpdateObjective{	objectives = {	"clear_missionTask_05",	},	}
					end
				end
			},
			{ msg = "SwitchGimmick", 			func = this.FuncSwitchPump },		
			{ msg = "PlacedIntoVehicle",		func = this.FuncRideOnHeli	},		
		},
		Block = {
			{ msg = "OnChangeLargeBlockState",	 	func = this.FuncFlowStationModelChange_loaded },		
		},
		Radio = {
				{ msg = "Finish", sender = "s0080_esrg1030",	
					func = function() s10080_radio.SetRadio_ChangeIntelRadio_enemy() end,  },	
		},
		Marker = {
			{ msg = "ChangeToEnable", func = this.FuncOnMarkingWalkerGear },		
		},
		Trap = {
			{ msg = "Enter", 	sender = "trap_FlowStation",				func = function() 
																				svars.isInFlowStation = true 
																				svars.isArrivalFlowStation = true	
																			end, },
			{ msg = "Exit", 	sender = "trap_FlowStation",				func = function() svars.isInFlowStation = false	end, },
			
			{	
				msg = "Enter",
				sender = "jingleCharredTrap",
				func = function ()
					if svars.isJingleCharred == false then
						GkEventTimerManager.Start( "timer_JingleCharred", 1 )
					else
					end
				end
			},
			{	
				msg = "Exit",
				sender = "jingleCharredTrap",
				func = function ()
					GkEventTimerManager.Stop( "timer_JingleCharred" )	
				end
			},
			{	
				msg = "Enter",
				sender = "jingleCharredTrap0000",
				func = function ()
					if svars.isJingleCharred == false then
						GkEventTimerManager.Start( "timer_JingleCharred0000", 1 )
					else
					end
				end
			},
			{	
				msg = "Exit",
				sender = "jingleCharredTrap0000",
				func = function ()
					GkEventTimerManager.Stop( "timer_JingleCharred0000" )	
				end
			},
		},
		Timer = {
			{
				msg = "Finish",	sender = "timer_JingleCharred",	
				func = function()
					
					local checkInCamera = Player.AddSearchTarget{
						name					= "charred_locator",
						dataIdentifierName		= "jingle_Identifier",
						keyName					= "jingle_charred",
						distance				= 13,
						checkImmediately		= true,
					}
					
					if checkInCamera == true and Player.GetGameObjectIdIsRiddenToLocal() == 65535 and Player.IsOnTheLoadingPlatform() == false then
						
						if PlayerInfo.OrCheckStatus{ PlayerStatus.DASH, PlayerStatus.BINOCLE, } then
							GkEventTimerManager.Start( "timer_JingleCharred", 1 )		
						else	
							
							TppSoundDaemon.PostEvent( 'sfx_s_bgm_dead_body' )
							
							Player.StartTargetConstrainCamera {
								cameraType = PlayerCamera.Around,		
								force = false,							
								fixed = false,							
								recoverPreOrientation = false,			
								dataIdentifierName = "jingle_Identifier",	
								keyName = "jingle_charred",				
								interpTime = 1.0,						
								time = 3,								
								focalLength = 32.0,						
								focalLengthInterpTime = 1.5,			
								minDistance = 3.0,						
								maxDistanve = 20.0,						
								doCollisionCheck = true,				
							}
							svars.isJingleCharred = true
							GkEventTimerManager.Stop( "timer_JingleCharred" )	
						end
					else
						GkEventTimerManager.Start( "timer_JingleCharred", 1 )		
					end
				end
			},
			{
				msg = "Finish",	sender = "timer_JingleCharred0000",	
				func = function()
					
					local checkInCamera = Player.AddSearchTarget{
						name					= "charred_locator0000",
						dataIdentifierName		= "jingle_Identifier",
						keyName					= "jingle_charred0000",
						distance				= 13,
						checkImmediately		= true,
					}
					
					if checkInCamera == true and Player.GetGameObjectIdIsRiddenToLocal() == 65535 and Player.IsOnTheLoadingPlatform() == false then
						
						if PlayerInfo.OrCheckStatus{ PlayerStatus.DASH, PlayerStatus.BINOCLE, } then
							GkEventTimerManager.Start( "timer_JingleCharred0000", 1 )		
						else	
							
							TppSoundDaemon.PostEvent( 'sfx_s_bgm_dead_body' )
							
							Player.StartTargetConstrainCamera {
								cameraType = PlayerCamera.Around,		
								force = false,							
								fixed = false,							
								recoverPreOrientation = false,			
								dataIdentifierName = "jingle_Identifier",	
								keyName = "jingle_charred0000",				
								interpTime = 1.0,						
								time = 3,								
								focalLength = 32.0,						
								focalLengthInterpTime = 1.5,			
								minDistance = 3.0,						
								maxDistanve = 20.0,						
								doCollisionCheck = true,				
							}
							svars.isJingleCharred = true
							GkEventTimerManager.Stop( "timer_JingleCharred0000" )	
						end
					else
						GkEventTimerManager.Start( "timer_JingleCharred0000", 1 )		
					end
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


this.DoesIncludeTarget = function( gameObjectId, targetList )
	Fox.Log("##** Checking_MissionTaskList ####")
	for i, targetName in ipairs( targetList ) do
		if GameObject.GetGameObjectId( targetName ) == gameObjectId then
			return true
		end
	end
	return false

end


this.FuncTutorial_AllPadMaskReset = function()
	Player.ResetPadMask {settingName = "All"	}
end


this.FuncFlowStationModelChange_loaded = function(largeBlockName,state)
	if largeBlockName == StrCode32(FLOWSTATION) then
		if state == StageBlock.ACTIVE then
			
			this.FuncFlowStationModelChange()
		end
	else
		
		svars.isLoadedFlowStation	= false
	end
end


this.FuncFlowStationSirenOn = function()
	local gameObjectId = GameObject.GetGameObjectId( "mafr_flowStation_cp" )
	local command = { id = "SetCpForceSiren", enable=true }
	GameObject.SendCommand( gameObjectId, command )
end


this.FuncFlowStationModelChange = function()
	
	if svars.isBreakedTank == false then
		
		TppDataUtility.DestroyEffectFromId( "ExpSmk" )
		
		
		TppDataUtility.SetVisibleDataFromIdentifier( "id_before_explosion", "before_explosion", true , true )
		TppDataUtility.SetVisibleDataFromIdentifier( "id_after_explosion" , "after_explosion" , false , true )

		TppDataUtility.SetEnableDataFromIdentifier( "id_after_explosion", "pathWall_0001", false)
		
		
		Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank005_gim_n0001|srt_mafr_tank005",FLOWSTATION_GIMMICK_PATH)
		Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank003_gim_n0000|srt_mafr_tank003",FLOWSTATION_GIMMICK_PATH)
		Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank003_gim_n0001|srt_mafr_tank003",FLOWSTATION_GIMMICK_PATH)
		Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank003_gim_n0002|srt_mafr_tank003",FLOWSTATION_GIMMICK_PATH)
		Gimmick.ForceIndelibleClear(TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE,"mafr_tank005_vrtn006_gim_n0001|srt_mafr_tank005_vrtn006",FLOWSTATION_GIMMICK_PATH)
		
		
		for i, gimmickId in pairs( resetGimmickIdTable_Tank ) do
			Fox.Log("TppGimmick.s10080.ResetGimmick"..gimmickId)
			TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = false }
		end
		
	else
		
		TppDataUtility.CreateEffectFromId( "ExpSmk" )

		TppDataUtility.SetVisibleDataFromIdentifier( "id_before_explosion", "before_explosion",false , true )
		TppDataUtility.SetVisibleDataFromIdentifier( "id_after_explosion" , "after_explosion" , true , true )
		
		TppDataUtility.SetVisibleDataFromIdentifier( "id_after_explosion_tank", "mafr_tank003_vrtn001_0000", false , true )
		TppDataUtility.SetVisibleDataFromIdentifier( "id_after_explosion_tank", "mafr_tank003_vrtn001_0001", false , true )
		TppDataUtility.SetVisibleDataFromIdentifier( "id_after_explosion_tank", "mafr_tank003_vrtn001_0002", false , true )
		
		TppDataUtility.SetEnableDataFromIdentifier( "id_after_explosion", "pathWall_0001", true)
		
		TppGimmick.Hide( PDOR_NAME1 )	
		TppGimmick.Hide( PDOR_NAME2 )
	end

	
	if svars.isStopedPump == false then
		
		TppDataUtility.SetVisibleEffectFromGroupId( "FxLocatorGroupFlowStationBefore", 	true )
		TppDataUtility.SetVisibleEffectFromGroupId( "FxLocatorGroupFlowStationAfter", 		false )
		
		Gimmick.InvisibleGimmick( -1,"cps1_main0_sta_gim_n0000|srt_cps1_main0_sta", S10080_GIMMICK_PATH, true)
		Gimmick.InvisibleGimmick( -1,"cps1_main0_sta_gim_n0001|srt_cps1_main0_sta", S10080_GIMMICK_PATH, true)
		Gimmick.InvisibleGimmick( -1,"cps1_main0_sta_gim_n0002|srt_cps1_main0_sta", S10080_GIMMICK_PATH, true)
		Gimmick.InvisibleGimmick( -1,"cps1_main0_sta_gim_n0003|srt_cps1_main0_sta", S10080_GIMMICK_PATH, true)
		Gimmick.InvisibleGimmick( -1,"cps1_main0_sta_gim_n0004|srt_cps1_main0_sta", S10080_GIMMICK_PATH, true)
		Gimmick.InvisibleGimmick( -1,"cps1_main0_sta_gim_n0005|srt_cps1_main0_sta", S10080_GIMMICK_PATH, true)

		
		for i, gimmickId in pairs( resetGimmickIdTable_Pump ) do
			Fox.Log("TppGimmick.s10080.ResetGimmick"..gimmickId)
			TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = false }
		end
		
		
		Gimmick.InvincibleGimmickData( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, PUMP_NAME_I,	FLOWSTATION_GIMMICK_PATH, true )
		
		Fox.Log("s10080_sequence:ChangeSwitch true")
		Gimmick.ChangeSwitch (PUMP_NAME,FLOWSTATION_GIMMICK_PATH, true)
		
	else
		
		TppDataUtility.SetVisibleEffectFromGroupId( "FxLocatorGroupFlowStationBefore", 	false )
		TppDataUtility.SetVisibleEffectFromGroupId( "FxLocatorGroupFlowStationAfter", 		true )	
		
		Gimmick.ResetGimmickData( "cps1_main0_sta_gim_i0000|TppSharedGimmick_cps1_main0_sta", 	S10080_GIMMICK_PATH )
		
		Gimmick.InvincibleGimmickData( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, PUMP_NAME_I,	FLOWSTATION_GIMMICK_PATH, false )

	end	
	
	
	svars.isLoadedFlowStation	= true
end


this.FuncMissionReload = function()

	local reloadCheckpointName = ReloadCheckpointNameTable[svars.isFultoned_child1]
	CHECKPOINT_NAME = reloadCheckpointName
	
	
	if svars.isInFlowStation == true then
		
		TppSequence.ReserveNextSequence( "Seq_Demo_Reinforcement" )
	else
		
	end
	
	Fox.Log( "s10080_sequence.FuncMissionReload: " .. svars.isFultoned_child1 .. " : " .. reloadCheckpointName )
	
	TppMission.UpdateCheckPoint{	
		checkPoint = reloadCheckpointName,
		ignoreAlert = true,
		permitHelicopter = true,
	}

	TppMission.Reload{
		isNoFade = false,
		showLoadingTips = false,
		missionPackLabelName = "afterPumpStopDemo",
	}	
end


this.FuncConstrainCamera_tank = function()
	Player.StartTargetConstrainCamera {
			
			cameraType = PlayerCamera.Around,
			
			force = true,
			
			fixed = true,
			
			recoverPreOrientation = true,
			
			gameObjectName = "mafr_tank003_gim_n0001|srt_mafr_tank003",
			
			targetFox2Name = "/Assets/tpp/level/location/mafr/block_large/flowStation/mafr_flowStation_gimmick.fox2",
			
			interpTime = 0.6,
			
			interpTimeToRecover = 0.2,
			
			areaSize = 0.5,
			
			time = 8,
			
			minDistance = 1.0,
			
			maxDistanve = 50.0,
			
			focalLength = 32.0,
			
			focalLengthInterpTime = 1.5,
			
			targetOffset = Vector3(0,7.5,0),		
			
			
			doCollisionCheck = true,
		}
end


this.FuncSwitchPump =function(GameObjectId,gameObjectName,name,switchFlag)
	Fox.Log("s10080:switchFlag :"..switchFlag)
	
	if svars.isLoadedFlowStation == true then
		if gameObjectName == StrCode32(PUMP_NAME) then	
			
			if svars.isStopedPump == false then
				if switchFlag == 0 then				
					this.FuncStopedPump()
				end
			
			else
				if switchFlag == 255 then	
					this.FuncSwitchBuzzer()
				end
			end
		end
	end
end


this.FuncSwitchBuzzer = function()
	local soundPos = 	Vector3(-1064.034, -3.786, -249.909)
	TppSoundDaemon.PostEvent3D( "sfx_m_door_buzzer", soundPos )
end


this.FuncStopedPump = function()
	svars.isStopedPump			= true

	
	Gimmick.InvincibleGimmickData( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, TANK_NAME1_I,	FLOWSTATION_GIMMICK_PATH, true )
	Gimmick.InvincibleGimmickData( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, TANK_NAME2_I,	FLOWSTATION_GIMMICK_PATH, true )
	
	
	Gimmick.CloseDoor("mafr_door006_vrtn001_gim_n0000|srt_mafr_door006_vrtn001",FLOWSTATION_GIMMICK_PATH)

	CHECKPOINT_NAME = "CHK_StopPump"

	local func =  function()
		
		Fox.Log("s10080:clear_missionTask_01")
		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_01"},
		}
		
		
		this.FuncFlowStationModelChange()
		
		
		Gimmick.InvincibleGimmickData( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, TANK_NAME1_I,	FLOWSTATION_GIMMICK_PATH, false )
		Gimmick.InvincibleGimmickData( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, TANK_NAME2_I,	FLOWSTATION_GIMMICK_PATH, false )

		if svars.isBreakedTank == false then
		
			s10080_radio.StopedPump_beforeTank()
			
			
			s10080_radio.SetRadio_afterStopedPump()
						
			
			TimerStart( "stopPumpTimer",STOPPUMP_TIMER)	
			
			
			TppMission.UpdateObjective{
				objectives = { "default_area_targetPump_stop"},
			}
					
		else
		
			svars.isBreakedTank_after_StopedPump = true
			TppSequence.SetNextSequence("Seq_Game_Escape")
			
		end

		Fox.Log("s10080:UpdateCheckPoint_FuncStopedPump ".."CHK_StopPump")
		
		TppMission.UpdateCheckPoint{	
			checkPoint = "CHK_StopPump",
			ignoreAlert = true,
		}
	end
	
	s10080_demo.DeadBody(func)
end


this.FuncKeepCaution_flowStation = function()
	
	local gameObjectId = GameObject.GetGameObjectId( "mafr_flowStation_cp" )
	local command = { id = "SetKeepCaution", enable=true } 
	GameObject.SendCommand( gameObjectId, command ) 
	
	
	s10080_enemy.flowStation_clearing_start()
end


this.FuncCPAnnihilatedCheck = function(gameObjectId)
	Fox.Log( "s10080_sequence.FuncCPAnnihilatedCheck( gameObjectId:" .. tostring(gameObjectId)  ..  " )" )
	if gameObjectId == GameObject.GetGameObjectId( "mafr_flowStation_cp" ) then
		svars.isFlowStationCpAnnihilated = true
		svars.isCanReinforcement = false
	end
end


this.FuncTankDemo = function()

	local funcs =  function()
		
		Fox.Log("s10080:clear_missionTask_02")

		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_02"},
		}	

		
		local sol1_rtPoint
		local sol2_rtPoint
		local wkr_rtPoint
		
		if svars.isInFlowStation == true then
			sol1_rtPoint	= 13
			sol2_rtPoint	= 10
			wkr_rtPoint		= 13				
		else
			sol1_rtPoint	= 0
			sol2_rtPoint	= 0
			wkr_rtPoint		= 0	
		end
		s10080_enemy.reinforcement_start(sol1_rtPoint,sol2_rtPoint,wkr_rtPoint)
		
		
		s10080_enemy.SwitchEnableCpSoldiers(s10080_enemy.REINFORCEMENT_LIST,true)
		
		
		local gameObjectId = GameObject.GetGameObjectId( "mafr_swampWest_ob")
		local command = { id = "SetKeepCharge", enable=true }
		GameObject.SendCommand( gameObjectId, command )
		
		
		this.FuncKeepCaution_flowStation()

		
		this.FuncReinforcementRadio()	

		
		this.FuncFlowStationSirenOn()
		
		
		TppDataUtility.CreateEffectFromId( "ExpSmk" )


		
		if svars.isStopedPump == true  then
			TppSequence.SetNextSequence("Seq_Game_Escape")
		else
		
			TppSequence.SetNextSequence("Seq_Game_StopFlowStation")
		end	
	end		

	return funcs
	
end



this.FuncReinforcementRadio = function()
	
	if svars.isFlowStationCpAnnihilated == false then
		
		local gameObjectId = GameObject.GetGameObjectId( "mafr_flowStation_cp" )
		local command = { id = "RequestRadio", label="CPI0200_01" } 
		GameObject.SendCommand( gameObjectId, command )
	end
end


this.FuncRoutePoint = function(gameObjectId,routeId,routeNodeIndex,messageId)
	Fox.Log( "s10080_sequence.FuncRoutePoint( gameObjectId:" .. tostring(gameObjectId) .. ", routeId:" .. tostring(routeId) ..
			", routeNodeIndex:" .. tostring(routeNodeIndex) .. ", messageId:" .. tostring(messageId) ..  " )" )
	
	if messageId == StrCode32("dropPointArrival") then
		
		this.FuncTutorial_AllPadMaskReset()
		
	
	elseif messageId == StrCode32("childEscape") then
		local GetGameObjectId = GameObject.GetGameObjectId
		local SendCommand = GameObject.SendCommand
		local command = { id="SetEnabled", enabled = false }
		
		if gameObjectId ~= NULL_ID then
			SendCommand( gameObjectId, command )
		end	
		
	
	elseif messageId == StrCode32("reinforcement1_arrival") then
		svars.isReinforcement	= true
		svars.isReinforcement1_arrived	= true
		TppTrap.Enable( "trap_RoadBlocked_1" )
		
		s10080_enemy.reinforcement_loop()
		
		
		if svars.isClearingComplete == true then
			this.FuncMountainHunting_ready()
		end
	elseif messageId == StrCode32("reinforcement2_arrival") then
		svars.isReinforcement	= true
		svars.isReinforcement2_arrived	= true
		TppTrap.Enable( "trap_RoadBlocked_2" )
		
	end
end


this.FuncOnMarkingWalkerGear = function(GameObjectInstanceName,MalkerTypeId,GameObjectId,MalkerById)
	
	if MalkerById == StrCode32("Player")	then
		
		if GameObjectInstanceName == StrCode32("wkr_s10080_0000") 	or
		 GameObjectInstanceName == StrCode32("wkr_s10080_0001") 	or
		 GameObjectInstanceName == StrCode32("wkr_s10080_0002") 	or
		 GameObjectInstanceName == StrCode32("wkr_s10080_0003") 	then

			s10080_radio.LookatWalkerGear()
		
		elseif GameObjectInstanceName == StrCode32("sol_child_0000") 	or
		 GameObjectInstanceName == StrCode32("sol_child_0001") 	or
		 GameObjectInstanceName == StrCode32("sol_child_0002") 	or
		 GameObjectInstanceName == StrCode32("sol_child_0003") 	then
			
			if svars.isPlayDemo_TeachChild == false then
				s10080_radio.SurprisedChild()
			end
		end
	end
end


this.FuncRideOnHeli = function(gameObjectId, VehicleId)
	
	local heliId = GameObject.GetGameObjectId("SupportHeli")
	
	if gameObjectId == s10080_enemy.CHILD_NAME.CHILD1 or s10080_enemy.CHILD_NAME.CHILD2 or 
			s10080_enemy.CHILD_NAME.CHILD3 or s10080_enemy.CHILD_NAME.CHILD4 then
		if VehicleId == heliId then
			
			s10080_radio.FultonChild()
		end
	end
end


this.FuncMountainHunting_ready  = function()
	svars.isMountainHunting_ready = true
	
	TppTrap.Enable( "trap_MountainHunting" )
end



this.FuncDisableTranslate = function()
	svars.DisableTranslateCount = svars.DisableTranslateCount + 1
	
	if svars.DisableTranslateCount == 1 then
		s10080_radio.DisableTranslateCount()
	end
end


this.FuncSetIgnoreReinforce = function()
 	local cpId = { type="TppCommandPost2" } 
	local command = { id = "SetIgnoreReinforce" }
 	GameObject.SendCommand( cpId, command )
end


this.FuncWeatherSetting = function()
	if TppStory.IsMissionCleard( 10080 )  == false then
		WeatherManager.SetNewWeatherProbabilities("default", { { 1, 100, } } )
	end
end




sequences.Seq_Demo_InAfrica = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Demo = {
				{ 	msg = "Play",
					func = function()
						
						GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetDemoToSendEnabled", enabled=true, route="rts_drproute_outland_S_0001" } ) 
					end,
					option = { isExecDemoPlaying = true,},
				},
				nil
			},		
			UI = {
				{
					
					msg = "StartMissionTelopFadeOut",
					func = function ()
						Fox.Log("!!!!!!!!!!!!!!!!! s10080_sequence: StartMissionTelopFadeOut !!!!!!!!!!!!!!!")
						self.OnEndMissionTelop()
					end
				},
			},
			Timer = {
				{ 
					msg = "Finish",	sender = "locationTerop_timer",						
					func = function ()
						
						TppUiCommand.CallMissionTelopTyping( "area_mission_20_10080" )
					end,
					option = { isExecDemoPlaying = true,}
				},
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(-569.03827, -3.9259033, 312.8404))
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		TppMission.UpdateObjective{
			
			objectives = { 
				"photo_flowStation",
				"photo_tank",
				"photo_pumpArea",
				"subGoal_default",
				"default_missionTask_01",
				"default_missionTask_02", 
				"default_missionTask_03",
				"default_missionTask_04",
				"default_missionTask_05",
				"default_missionTask_06",
			},
		}

		
		local missionId = TppMission.GetMissionID()
		TppUI.StartMissionTelop(missionId,true,true)
		
		
		s10080_enemy.childRouteSet_check()
		
		
		
		TppMusicManager.DisableHeliNewPlay()

	end,
	
	OnLeave = function ()
	end,

	OnEndMissionTelop = function ()
	
		GkEventTimerManager.Start( "locationTerop_timer", 3 )

		local endfunc = function()
			
			
			TppMusicManager.EnableHeliNewPlay()
			
			TppSequence.SetNextSequence(
				"Seq_Game_Opening",
				{isExecDemoPlaying = true}
				)
		end
		local skipfunc = function() 
		end
		s10080_demo.InAfrica(endfunc,skipfunc)
		
	end,	


}
sequences.Seq_Game_Opening = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Player = {
				{ msg = "PlayerHeliGetOff",	func = 	function() TppSequence.SetNextSequence("Seq_Demo_Opening") end,	},
			},
			GameObject = {
			},
			Radio = {
			},
			Timer = {
				{ msg = "Finish",	sender = "openMBTerminal",					func = 	self.FuncOpenMBTerminal},
				{ msg = "Finish",	sender = "canCloseMBTerminal",				func = 	self.FuncCanCloseMBTerminal},
			},
		nil
	}
	end,
	
	OnEnter = function()
		
		TppTelop.StartCastTelop()
		
		
		GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetInvincible", enabled=true, } ) 
			
		
		TimerStart( "openMBTerminal",OPENMB_TIMER)	
		
	end,
	
	OnLeave = function ()
	
		
		GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetInvincible", enabled=false, } ) 
		
		TppUiCommand.SetEnableMenuCancelClose( true )
		this.FuncTutorial_AllPadMaskReset()
		
	end,

	FuncOpenMBTerminal = function ()
		
		s10080_radio.Opening()	

		
		TppMission.UpdateObjective{
			
			objectives = { "default_area_flowStation"},
		}

		
		TppUiCommand.RequestMbDvcOpenCondition{ isTopModeMission=true, photoId=20 }

		
		this.FuncTutorial_AllPadMaskReset()
		
		
		
		
	end,

	FuncCanCloseMBTerminal = function ()
		
		TppUiCommand.SetEnableMenuCancelClose( true )
		
		this.FuncTutorial_AllPadMaskReset()
	end,

}

sequences.Seq_Demo_Opening = {
	OnEnter = function()
		
		GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetDemoToAfterDropEnabled", enabled=true, route="rts_drproute_outland_S_0002" } )
		
		
		TppBuddyService.SetIgnoreDisableNpc( true )

		local func = function() 
			TppSequence.SetNextSequence("Seq_Game_MissionSetting")
		end
		s10080_demo.ArrivalInAfrica(func)

	end,
	
	OnLeave = function ()
		
		Fox.Log("s10080:UpdateCheckPoint_Seq_Demo_Opening CHK_MissionStart")
		TppMission.UpdateCheckPoint("CHK_MissionStart")
	end,
	
}
sequences.Seq_Game_MissionSetting = {
	OnEnter = function()				
		
		TppScriptBlock.LoadDemoBlock("Demo_TeachChild")
		
		
		TppClock.RegisterClockMessage( "OnNight", TppClock.DAY_TO_NIGHT )		
		TppClock.RegisterClockMessage( "OnMorning", TppClock.NIGHT_TO_DAY )		

		
		if TppClock.GetTimeOfDay() == "day" then
			svars.isInDay = true
		else
			svars.isInDay = false	
		end

		
		s10080_radio.SetRadio_start()

		
		TppTrap.Disable( "trap_MountainHunting" )
		TppTrap.Disable( "trap_RoadBlocked_1" )
		TppTrap.Disable( "trap_RoadBlocked_2" )
		
		TppTrap.Enable( "trap_TeachChildDemo" )

		TppSequence.SetNextSequence("Seq_Game_StopFlowStation")			
	end,

}

sequences.Seq_Game_StopFlowStation = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Player = {
				{ msg = "WeaponPutPlaced",	func = 	self.FuncPutC4	},
				{ msg = "CqcHoldReleseChild", 	func = 	self.FuncCantCatchThechild},		
				{ msg = "PressedFultonNgIcon", 	func = self.FuncAboutFultonThechild	},		
			},
			GameObject = {
				
				
				{ msg = "Dead", sender = { s10080_enemy.ENEMY_NAME.TEACHER1 , s10080_enemy.ENEMY_NAME.TEACHER2 
				,s10080_enemy.CHILD_NAME.CHILD1, s10080_enemy.CHILD_NAME.CHILD2, s10080_enemy.CHILD_NAME.CHILD3, s10080_enemy.CHILD_NAME.CHILD4},
				func = self.FuncCantTraining,	},
				
				{ msg = "Dying", sender = { s10080_enemy.ENEMY_NAME.TEACHER1 , s10080_enemy.ENEMY_NAME.TEACHER2 
				,s10080_enemy.CHILD_NAME.CHILD1, s10080_enemy.CHILD_NAME.CHILD2, s10080_enemy.CHILD_NAME.CHILD3, s10080_enemy.CHILD_NAME.CHILD4},
				func = self.FuncCantTraining,	},
				
				{ msg = "Fulton", sender = { s10080_enemy.ENEMY_NAME.TEACHER1 , s10080_enemy.ENEMY_NAME.TEACHER2 
				,s10080_enemy.CHILD_NAME.CHILD1, s10080_enemy.CHILD_NAME.CHILD2, s10080_enemy.CHILD_NAME.CHILD3, s10080_enemy.CHILD_NAME.CHILD4},
				func = self.FuncCantTraining,	},
				
				{ msg = "FultonFailed", sender = { s10080_enemy.ENEMY_NAME.TEACHER1 , s10080_enemy.ENEMY_NAME.TEACHER2 
				,s10080_enemy.CHILD_NAME.CHILD1, s10080_enemy.CHILD_NAME.CHILD2, s10080_enemy.CHILD_NAME.CHILD3, s10080_enemy.CHILD_NAME.CHILD4},
				func = self.FuncCantTraining,	},		
				
				{ msg = "Conscious", sender = { s10080_enemy.ENEMY_NAME.TEACHER1 , s10080_enemy.ENEMY_NAME.TEACHER2 
				,s10080_enemy.CHILD_NAME.CHILD1, s10080_enemy.CHILD_NAME.CHILD2, s10080_enemy.CHILD_NAME.CHILD3, s10080_enemy.CHILD_NAME.CHILD4},
				func = self.FuncCantTraining,	},			
				
				{ msg = "Unconscious", sender = { s10080_enemy.ENEMY_NAME.TEACHER1 , s10080_enemy.ENEMY_NAME.TEACHER2 
				,s10080_enemy.CHILD_NAME.CHILD1, s10080_enemy.CHILD_NAME.CHILD2, s10080_enemy.CHILD_NAME.CHILD3, s10080_enemy.CHILD_NAME.CHILD4},
				func = self.FuncCantTraining,	},		
				
				{ msg = "Neutralize", sender = { s10080_enemy.ENEMY_NAME.TEACHER1 , s10080_enemy.ENEMY_NAME.TEACHER2 
				,s10080_enemy.CHILD_NAME.CHILD1, s10080_enemy.CHILD_NAME.CHILD2, s10080_enemy.CHILD_NAME.CHILD3, s10080_enemy.CHILD_NAME.CHILD4},
				func = self.FuncCantTraining,	},		
				
				{ msg = "Damage", sender = { s10080_enemy.ENEMY_NAME.TEACHER1 , s10080_enemy.ENEMY_NAME.TEACHER2 
				,s10080_enemy.CHILD_NAME.CHILD1, s10080_enemy.CHILD_NAME.CHILD2, s10080_enemy.CHILD_NAME.CHILD3, s10080_enemy.CHILD_NAME.CHILD4},
				func = self.FuncCantTraining,	},	
				
				{ msg = "BreakGimmick", 	func = self.FuncBreakedTank },		
				
				{ msg = "ChangePhase",	 	sender = "mafr_outland_cp", 	func = self.FuncChangePhase },	
				{ msg = "DisableTranslate",	 	func = this.FuncDisableTranslate },		
			},
			Trap = {
				{ msg = "Enter", 	sender = "trap_ApproachFlowStation",		func = self.FuncApproachFlowStation },
				{ msg = "Enter", 	sender = "trap_ApproachFlowStation_radio",	func = self.FuncApproachFlowStation_radio },				
				
				{ msg = "Enter", 	sender = "trap_ApproachOutland",			func = self.FuncApproachOutland },	
				{ msg = "Enter", 	sender = "trap_ApproachOutland_near",		func = self.FuncApproachOutland_near},	
					
				{ msg = "Enter", 	sender = "trap_TeachChildDemo",				func = self.FuncTeachChildDemo },	
		
				{ msg = "Enter", 	sender = "trap_ApproachPump",				func = self.FuncApproachPump },
				{ msg = "Enter", 	sender = "trap_ApproachTank",				func = self.FuncApproachTank },
				{ msg = "Exit", 	sender = "trap_ApproachTank",				func = function() svars.isAroundTank = false end, },
				{ msg = "Exit", 	sender = "trap_PutC4andLeave",				func = self.FuncPutC4andLeave },

				{ msg = "Enter", 	sender = "trap_DetailOfMission",							func = self.FuncDetailOfMission },
				{ msg = "Enter", 	sender = "trap_DetailOfMission2",							func = self.FuncDetailOfMission2 },
				{ msg = "Enter", 	sender = "trap_ApproachScorchedearthVillage",				func = self.FuncApproachScorchedearthVillage },

				{ msg = "Enter", 	sender = "trap_ApproachRiver",				func = self.FuncApproachRiver },
				{ msg = "Enter", 	sender = "trap_OtherSideWay",				func = self.FuncOtherSideWay },
				{ msg = "Enter", 	sender = "trap_WayToFlowStation",			func = self.FuncWayToFlowStation },
				
				{ msg = "Enter", 	sender = "trap_StopStartBGM",				func = function() 	TppSound.StopSceneBGM() end, },		

				{ msg = "Enter", 	sender = "trap_ApproachScorchedearthCorpse",	func = function() 	s10080_radio.ApproachScorchedearthCorpse() end, },		

				
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Under1",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UNDER1 end, },		
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Under2",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UNDER2 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Under3",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UNDER3 end, },		
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Under4",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UNDER4 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Under5",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UNDER5 end, },		
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Under6",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UNDER6 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Under7",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UNDER7 end, },		
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Under8",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UNDER8 end, },		
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Upper1",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UPPER1 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Upper2",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UPPER2 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Upper3",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UPPER3 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Upper4",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UPPER4 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Upper5",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UPPER5 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Upper6",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UPPER6 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Upper7",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UPPER7 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Upper8",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UPPER8 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Upper9",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_UPPER9 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside1",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE1 end, },				
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside2",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE2 end, },					
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside3",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE3 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside4",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE4 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside5",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE5 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside6",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE6 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside7",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE7 end, },					
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside8",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE8 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside9",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE9 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside10",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE10 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Tank_Outside11",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.TANK_OUTSIDE11 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump1",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP1 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump2",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP2 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump3",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP3 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump4",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP4 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump5",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP5 end, },				
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump6",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP6 end, },				
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump7",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP7 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump8",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP8 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump9",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP9 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump10",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP10 end, },				
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump11",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP11 end, },					
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Under1",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UNDER1 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Under2",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UNDER2 end, },				
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Under3",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UNDER3 end, },				
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Under4",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UNDER4 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Under5",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UNDER5 end, },				
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Under6",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UNDER6 end, },
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Upper1",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UPPER1 end, },			
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Upper2",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UPPER2 end, },			
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Upper3",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UPPER3 end, },			
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Upper4",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UPPER4 end, },			
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Upper5",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UPPER5 end, },			
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Pump_Upper6",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.PUMP_UPPER6 end, },			
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road1",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD1 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road2",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD2 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road3",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD3 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road4",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD4 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road5",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD5 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road6",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD6 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road7",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD7 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road8",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD8 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road9",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD9 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road10",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD10 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Road11",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.ROAD11 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Other1",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.OTHER1 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Other2",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.OTHER2 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Other3",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.OTHER3 end, },	
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Other4",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.OTHER4 end, },					
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Other5",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.OTHER5 end, },					
				{ msg = "Enter", 	sender = "trap_CHK_FlowStation_Other6",	func = function() svars.isFultoned_child1 = this.FLOWSTATIONAREA_STATUS.OTHER6 end, },	

			},
			Timer = {
				{ msg = "Finish",	sender = "childDemoRoop",					func = 	self.FuncTeachChildDemo	},
				{ msg = "Finish",	sender = "stopPumpTimer",					func = 	self.FuncDetectStopedPump	},
				{ msg = "Finish",	sender = "breakTankTimer1",					func = 	self.FuncBreakTank1	},
				{ msg = "Finish",	sender = "breakTankTimer2",					func = 	self.FuncBreakTank2	},
				{ msg = "Finish",	sender = "breakTankTimer3",					func = 	self.FuncBreakTank3	},
				{ msg = "Finish",	sender = "breakTankTimer4",					func = 	self.FuncBreakTank4	},
				{ msg = "Finish",	sender = "explosionDeray",					func = 	function() this.FuncMissionReload() end,	},
			},
			Radio = {
				{ msg = "EspionageRadioCandidate", 	func = self.FuncLookAtEspionageRadio },
				{ msg = "Finish", 	sender = "s0080_rtrg1030", 					func = self.FuncApproachOutland_updateObjective },
				{ msg = "Finish", 	sender = "s0080_rtrg1040", 					func = function() s10080_radio.DontAttackTochild() end, },
				{ msg = "Finish", 	sender = "LG_s0080_0150", 					func = function() svars.isSNARradio = true end, },
				{ msg = "Finish", 	sender = "s0080_rtrg1035", 					
					func = function()
						if svars.isLook_TeachChildDemo == true then
							s10080_radio.AfterDemo_outland()
						else
							
							s10080_radio.DontAttackTochild() 
						end
					end,},
			},
			Weather = {
				{ msg = "Clock",	sender = "OnMorning",						func = self.FuncOnMorning	},	
				{ msg = "Clock",	sender = "OnNight",							func = self.FuncOnNight},		
			},
		nil
	}
	end,

	OnEnter = function()
		local ContinueCount = TppSequence.GetContinueCount()
		
		
		if svars.isLoadedFlowStation	== true then
			this.FuncFlowStationModelChange()
		end

		
		
		if TppPackList.IsMissionPackLabel( "afterPumpStopDemo" ) then
		
			
			TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "DemoPlayendFadeIn", scdDemoID )
			
			
			Player.ResetPadMask {settingName = "breakedTank"	}

			local funcs = this.FuncTankDemo()
			funcs()

			if svars.isStopedPump == false  then
		
				
				s10080_radio.BreakedTank_beforePump()

				
				s10080_radio.SetRadio_EspionageRadio_start()
				
				
				s10080_radio.SetRadio_afterBreakedTank()

				
				TppMission.UpdateObjective{
					objectives = { "default_area_targetTank_break"},
				}
			
				
				if 	ContinueCount == 0 then 
					s10080_radio.BreakedTank_beforePump()			
				elseif 	ContinueCount >= 1 then	
					s10080_radio.continue_afterBreakTank()	
				end
				
			end
		
		elseif TppPackList.IsMissionPackLabel( "default" ) then

			
			if svars.playerAreaStatus  == this.PLAYERAREA_STATUS.IN_STARTPOINT then
				if 	ContinueCount == 0 then 
					
					s10080_radio.MissionStart()	
					
					TppSound.SetSceneBGM("bgm_south_africa")

				else
					
					s10080_radio.continue_startpoint()
				end
			
			elseif svars.playerAreaStatus  == this.PLAYERAREA_STATUS.IN_OUTLAND then
				s10080_radio.continue_outland()
			
			elseif svars.playerAreaStatus  == this.PLAYERAREA_STATUS.IN_ROAD then
				s10080_radio.continue_road()
			
			elseif svars.playerAreaStatus  == this.PLAYERAREA_STATUS.IN_FLOWSTATION then
				
				if svars.isStopedPump == true and svars.isBreakedTank	 == false then
					s10080_radio.continue_afterStopPump()					
				
				elseif svars.isStopedPump == false and svars.isBreakedTank	 == false then
					s10080_radio.continue_flowStation()
				end
			end	
		end
	end,
	
	OnLeave = function ()
		
		if	svars.isBreakedTank_after_StopedPump == true then
			Fox.Log("s10080:UpdateCheckPoint_FuncStopedPump ".."CHK_StopPump")
			
			TppMission.UpdateCheckPoint{	
				checkPoint = "CHK_StopPump",
				ignoreAlert = true,
			}
		end
	end,

	
	FuncOtherSideWay = function() 
		
		svars.playerAreaStatus  = this.PLAYERAREA_STATUS.IN_ROAD
	end,
	
	
	FuncApproachOutland = function() 
		
		svars.playerAreaStatus  = this.PLAYERAREA_STATUS.IN_OUTLAND
	end,
	
	
	FuncApproachOutland_near = function()
		if svars.isArrivalFlowStation == false then
			s10080_radio.ApproachOutland()
			
			s10080_radio.SetRadio_ApproachOutland()
		end
	end,
	
	FuncApproachOutland_updateObjective = function()
		if svars.isArrivalFlowStation == false then
			TppMission.UpdateObjective{
				objectives = { "default_area_container"},
			}
		end
	end,

	
	FuncOnMorning = function()
		svars.isInDay = true
		if svars.isCanTraining == true then
			s10080_enemy.childRouteSet_training_day()
			s10080_enemy.teacherRouteSet_training_day()
		else
			sequences.Seq_Game_StopFlowStation.FuncCantTraining()
		end
	end,
	FuncOnNight = function()
		svars.isInDay = false
		if svars.isCanTraining == true then
			s10080_enemy.teacherRouteSet_training_night()
			s10080_enemy.childRouteSet_training_night()
			
			s10080_radio.SetRadio_DisableEspionageTeacherDemo()
		else
			sequences.Seq_Game_StopFlowStation.FuncCantTraining()
		end
	end,

	
	FuncCantTraining = function()

		svars.isCanTraining = false
		
		
		TppTrap.Disable( "trap_TeachChildDemo" )
		
		s10080_enemy.childRouteSet_check()
		
		s10080_enemy.childRouteSet_Escape()
		s10080_enemy.TeacherRouteChange_normal()

		s10080_radio.SetRadio_DisableEspionageTeacherDemo()

	end,

	
	FuncAboutFultonThechild = function(playerId,GameObjectId)
	
		local command = { id = "IsChild" }
		local result = GameObject.SendCommand( GameObjectId, command )

		if result == true then
			
			s10080_radio.AboutFultonThechild()
		end
	end,
	
	
	FuncCantCatchThechild = function(PlayerId,GameObjectId)

		local command = { id = "IsChild" }
		local result = GameObject.SendCommand( GameObjectId, command )

		if result == true then
			
			s10080_radio.CantCatchThechild()
		end

	end,
	
	
	FuncChangePhase = function( cpName, PhaseName ) 
		if PhaseName == TppEnemy.PHASE.SNEAK then
		else
			svars.isChanegePhase = true
			
			sequences.Seq_Game_StopFlowStation.FuncCantTraining()
		end
	end,

	
	
	
	
	
	FuncTeachChildDemo = function() 
		
		local routeCheck = s10080_enemy.childDemoRouteCheck()

		if 	svars.playerAreaStatus  == this.PLAYERAREA_STATUS.IN_OUTLAND and
			svars.isCanTraining == true and
			routeCheck == true	then

				s10080_radio.SetRadio_EnableEspionageTeacherDemo()

				local func =  function()
					TimerStart( "childDemoRoop",CHILDDEMO_TIMER)	
					svars.isPlayDemo_TeachChild = true
				end
				s10080_demo.TeachChild(func)
		end
	end,

	
	FuncLookAtEspionageRadio  = function(gameObjectId) 
		
		if gameObjectId == GameObject.GetGameObjectId("erl_teacherDemo") then
			svars.isLook_TeachChildDemo = true

			s10080_radio.SetRadio_DisableEspionageTeacherDemo()
			s10080_radio.SurprisedChild()

		
		elseif gameObjectId == GameObject.GetGameObjectId("erl_lookAtTank") then
			TppMission.UpdateObjective{
				objectives = { "default_area_targetTank_important"},
			}
			s10080_radio.ThisisTank()
		end
	end,

	
	FuncApproachRiver = function() 
		s10080_radio.ApproachRiver()	
	end,

	
	FuncWayToFlowStation = function() 
		if svars.isArrivalFlowStation == false then
			s10080_radio.WayToFlowStation()	
			
			s10080_radio.SetRadio_WayToFlowStation()
		end
		
		svars.playerAreaStatus  = this.PLAYERAREA_STATUS.IN_ROAD
	end,
	
	
	FuncDetailOfMission = function() 
		if svars.isArrivalFlowStation == false then
			s10080_radio.DetailOfMission()	
		end
	end,
	
	
	FuncDetailOfMission2 = function()
		if svars.isArrivalFlowStation == false then
			if svars.isSNARradio == false then
				s10080_radio.DetailOfMission2()	
			end
		end
	end,
	
	
	FuncApproachScorchedearthVillage = function() 
		if svars.isArrivalFlowStation == false then
			s10080_radio.ApproachScorchedearthVillage()	
		end
	end,
	
	
	FuncApproachScorchedearthCorpse = function() 
		s10080_radio.ApproachScorchedearthCorpse()	
	end,
	
	
	FuncApproachFlowStation = function() 
		
		s10080_radio.SetRadio_ApproachFlowStation()	
		
		TppMission.UpdateObjective{
			objectives = { "default_area_arrivalFlowStation"},
			}
			
		if svars.isStopedPump	== false then
		TppMission.UpdateObjective{
			objectives = { "default_area_targetPump"},
			}
		end
		if svars.isBreakedTank	 == false then
		TppMission.UpdateObjective{
			objectives = { "default_area_targetTank"},
			}
		end

		
		svars.playerAreaStatus  = this.PLAYERAREA_STATUS.IN_FLOWSTATION
	end,
	
	
	FuncApproachFlowStation_radio = function() 
		if svars.isArrivalFlowStation == false then
			s10080_radio.ApproachFlowStation()	
		end
	end,

	
	FuncApproachPump = function() 
		if svars.isStopedPump	== false then
		
			TppMission.UpdateObjective{
				objectives = { "default_area_targetPump_discover"},
			}
			
			s10080_radio.ApproachPump()
		end
	end,

	
	FuncApproachTank = function() 
		if svars.isBreakedTank	 == false then
			svars.isAroundTank = true
			s10080_radio.ApproachTank()		
		end
	end,

	
	FuncPutC4	= function( playerIndex, equipId )
		if 	equipId == TppEquip.EQP_SWP_C4 or 
			equipId == TppEquip.EQP_SWP_C4_G01 or
			equipId == TppEquip.EQP_SWP_C4_G02 or
			equipId == TppEquip.EQP_SWP_C4_G03 or
			equipId == TppEquip.EQP_SWP_C4_G04 then
			
			if svars.isAroundTank == true then
				svars.isPutC4 = true
				s10080_radio.PutC4()
			end
		end
	end,
	
	
	FuncPutC4andLeave	= function( )
		if svars.isPutC4 == true then
			s10080_radio.PutC4andLeave()
		end
	end,
		
	
	FuncBreakedTank = function(gameObjectId,instanceName,name) 

		
		if svars.isLoadedFlowStation == true then
		
			local breakedgimmickId = TppGimmick.GetGimmickID( gameObjectId, instanceName, name )
			
			local breakTimerNameTable = {
				[TANK_ID_NAME1] = "breakTankTimer3",
				[TANK_ID_NAME3] = "breakTankTimer2",
				[TANK_ID_NAME2] = "breakTankTimer4",
				[TANK_ID_NAME4] = "breakTankTimer1",
			}
			
			
			if breakedgimmickId ==  TANK_ID_NAME1 or breakedgimmickId ==  TANK_ID_NAME2 or
			breakedgimmickId ==  TANK_ID_NAME3 or breakedgimmickId ==  TANK_ID_NAME4 then
				
				if svars.isBreakedTank	== false then		
					this.FuncConstrainCamera_tank()
				end
				
				svars.isBreakedTank			= true		
				
				
				Player.SetPadMask {  settingName = "breakedTank", except = true, buttons =  PlayerPad.STOCK,	sticks = PlayerPad.STICK_R + PlayerPad.STICK_L ,  }	
				
				if breakedgimmickId ==  TANK_ID_NAME1 then
					
					TppDataUtility.SetVisibleDataFromIdentifier( "id_before_explosion", "before_explosion",false , true )
					TppDataUtility.SetVisibleDataFromIdentifier( "id_after_explosion" , "after_explosion" , true , true )
					
					TppDataUtility.SetEnableDataFromIdentifier( "id_after_explosion", "pathWall_0001", true)
					
					TppGimmick.Hide( PDOR_NAME1 )	
					TppGimmick.Hide( PDOR_NAME2 )

					local identifierParam = mafr_gimmick.gimmickIdentifierParamTable[TANK_ID_NAME5]
					Gimmick.BreakGimmick( identifierParam.type, identifierParam.locatorName, identifierParam.dataSetName, false)
				end

				
				if TppGimmick.IsBroken{  gimmickId = TANK_ID_NAME1 } == true and
				TppGimmick.IsBroken{  gimmickId = TANK_ID_NAME2 } == true and
				TppGimmick.IsBroken{  gimmickId = TANK_ID_NAME3 } == true and
				TppGimmick.IsBroken{  gimmickId = TANK_ID_NAME4 } == true then
				
				
				GkEventTimerManager.Stop( "explosionDeray")
				GkEventTimerManager.Start( "explosionDeray", EXPLOSION_DERAY_TIMER )
					
				
				else
					local timerName = breakTimerNameTable[breakedgimmickId]
					if timerName then
						TimerStart( timerName,TANKDERAY_TIMER)	
					end
				end
			end
		end
	end,
	
	
	FuncBreakTank1 = function() 
		local identifierParam = mafr_gimmick.gimmickIdentifierParamTable[TANK_ID_NAME1]
		Gimmick.BreakGimmick( identifierParam.type, identifierParam.locatorName, identifierParam.dataSetName, false)
	end,
	FuncBreakTank2 = function() 
		local identifierParam = mafr_gimmick.gimmickIdentifierParamTable[TANK_ID_NAME2]
		Gimmick.BreakGimmick( identifierParam.type, identifierParam.locatorName, identifierParam.dataSetName, false)
	end,
	FuncBreakTank3 = function() 
		local identifierParam = mafr_gimmick.gimmickIdentifierParamTable[TANK_ID_NAME3]
		Gimmick.BreakGimmick( identifierParam.type, identifierParam.locatorName, identifierParam.dataSetName, false)
	end,
	FuncBreakTank4 = function() 
		local identifierParam = mafr_gimmick.gimmickIdentifierParamTable[TANK_ID_NAME4]
		Gimmick.BreakGimmick( identifierParam.type, identifierParam.locatorName, identifierParam.dataSetName, false)
	end,


	
	FuncDetectStopedPump = function()
		
		if svars.isBreakedTank == false then
			this.FuncKeepCaution_flowStation()	
			this.FuncReinforcementRadio()
		end
	end,

}


sequences.Seq_Demo_Reinforcement = {
	OnEnter = function()
		local funcs = this.FuncTankDemo()
		s10080_demo.Reinforcement(funcs)
	end,
}


sequences.Seq_Game_Escape = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Trap = {
				
				{ msg = "Enter", 	sender = "trap_MountainHunting",			func = self.FuncMountainHunting_ready },
				
				{ msg = "Enter", 	sender = "trap_RoadBlocked_1",			func = function()	s10080_radio.RoadBlocked_1() end, },
				{ msg = "Enter", 	sender = "trap_RoadBlocked_2",			func = function()	s10080_radio.RoadBlocked_2() end, },
			},
			GameObject = {
			},
			Timer = {
				{ msg = "Finish",	sender = "mountainHunting_ready",		func = 	self.FuncMountainHunting_timer	},
			},
	nil
	}
	end,
	
	OnEnter = function()
		Fox.Log("***s10080:Seq_Game_Escape***")
		
		TppMission.CanMissionClear() 

		
		s10080_radio.SetRadio_missionComplete()	

		
		TppMission.UpdateObjective{
			objectives = { "rv_missionClear","default_area_container_get","subGoal_escape",},
		}

		
		TppUiCommand.ShowHotZone()
		
		

				
		
		this.FuncKeepCaution_flowStation()

		
		this.FuncReinforcementRadio()	

		
		this.FuncFlowStationSirenOn()
				
		
		TppSound.SetPhaseBGM( "bgm_destroy" ) 
		
		
		TimerStart( "mountainHunting_ready"		,CLEARING_TIMER)	
	
		
		local ContinueCount = TppSequence.GetContinueCount()
		if 	ContinueCount == 0 then 
			if svars.isBreakedTank_after_StopedPump		== false then
				s10080_radio.BreakedTank_afterPump()
			else
				s10080_radio.StopedPump_afterTank()	
			end
		elseif 	ContinueCount >= 1 then	
			s10080_radio.continue_completeObjective()
		end

	end,
	
	
	
	
	

	
	FuncMountainHunting_timer = function()
		
		svars.isClearingComplete = true
		
		
		if svars.isReinforcement1_arrived == true then
			this.FuncMountainHunting_ready()
		end
		
	end,
		
	
	FuncMountainHunting_ready = function()
		
		if svars.isMountainHunting_started == false then
			
			if svars.isMountainHunting_ready == true then
				
				s10080_enemy.mountainHunting()
				s10080_radio.MountainHunting_start()
				svars.isMountainHunting_started = true
			end
		end
	end,

}




return this