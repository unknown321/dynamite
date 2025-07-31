local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}
local TimerStart = GkEventTimerManager.Start



local SUPPORT_HELI			= "SupportHeli"			
local TARGET_VEHICLE_COUNT	= 7	
local BONUS_TARGET_COUNT	= 4	

local TARGET_VEHICLE_01 = "veh_s10054_0000"		
local TARGET_VEHICLE_02 = "veh_s10054_0002"		
local TARGET_VEHICLE_03 = "veh_s10054_0003"		
local TARGET_VEHICLE_04 = "veh_s10054_0004"		
local TARGET_VEHICLE_05 = "veh_s10054_0005"		
local TARGET_VEHICLE_06 = "veh_s10054_0007"		
local TARGET_VEHICLE_07 = "veh_s10054_0008"		
local BONUS_TNK_01	= "veh_s10054_0010"		
local BONUS_TNK_02	= "veh_s10054_0011"		
local BONUS_TNK_03	= "veh_s10054_0012"		
local BONUS_HELI	= "EnemyHeli"		

local BULLET_TRUCK_01	= "veh_s10054_0001"	
local VEHICLE_01		= "veh_s10054_0006"	

local TARGET_VEHICLE_DRIVER_01 = "sol_s10054_0000"	
local TARGET_VEHICLE_DRIVER_02 = "sol_s10054_0002"	
local TARGET_VEHICLE_DRIVER_03 = "sol_s10054_0005"	
local TARGET_VEHICLE_DRIVER_04 = "sol_s10054_0003"	
local TARGET_VEHICLE_DRIVER_05 = "sol_s10054_0004"	
local TARGET_VEHICLE_DRIVER_06 = "sol_s10054_0006"	
local TARGET_VEHICLE_DRIVER_07 = "sol_s10054_0007"	
local BONUS_VEHICLE_DRIVER_01 = "sol_s10054_0008"	
local BONUS_VEHICLE_DRIVER_02 = "sol_s10054_0009"	
local BONUS_VEHICLE_DRIVER_03 = "sol_s10054_0010"	

local BULLET_TRUCK_DRIVER_01	= "sol_s10054_0001"		
local VEHICLE_DRIVER_01			= "sol_s10054_0011"		
local VEHICLE_DRIVER_02			= "sol_s10054_0012"		

local HOSTAGE_ABDUCT	= "hos_s10054_0001"

local TIME_LIMIT = {
	START_TIME_SEC		= 900,	
	CAUTION_TIME_SEC	= 300,	
}

this.MAX_PICKABLE_LOCATOR_COUNT = 40	
this.MAX_PLACED_LOCATOR_COUNT = 70		
this.EQUIP_MISSION_BLOCK_GROUP_SIZE = 1887437 



local cpId_TABLE = {
	"s10054_searchEnemy_cp",
	"afgh_tent_cp",
	"afgh_enemyBase_cp",
	"afgh_remnants_cp",
	"afgh_tentEast_ob",
	"afgh_tentNorth_ob",
	"afgh_enemyEast_ob",
	"afgh_villageWest_ob",
	"afgh_remnantsNorth_ob",
	"afgh_04_32_lrrp",
	"afgh_04_36_lrrp",
	"afgh_06_24_lrrp",
	"afgh_06_36_lrrp",
	"afgh_15_36_lrrp",
	"afgh_20_21_lrrp",
	"afgh_21_24_lrrp",
	"afgh_21_28_lrrp",
	"afgh_22_24_lrrp",
	"afgh_28_29_lrrp",
	"afgh_36_38_lrrp",
	"s10054_areaOut_cp",
	"s10054_areaOut02_cp",
}



this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true







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
	displayTimeSec			= TIME_LIMIT.START_TIME_SEC,
	isBonusTargetClear_CNT	= 0,		
	isTargrtCount_Clear		= 0,		
	isTargetCount_areaOut	= 0,		
	isNonTargetCount_areaOut	= 0,	
	isTargetVehicle_01		= 0,		
	isTargetVehicle_02		= 0,		
	isTargetVehicle_03		= 0,		
	isTargetVehicle_04		= 0,		
	isTargetVehicle_05		= 0,		
	isTargetVehicle_06		= 0,		
	isTargetVehicle_07		= 0,		
	isBulletTruck			= 0,		
	isHostageVehicle		= 0,		
	isBonusTarget			= false,	
	isEmergencyTime			= false,	
	isTimeUp				= false,	
	isTarget04_D_route		= false,
	isTarget05_E_route		= false,
	isMonologue_abductHostages	= false,
	isMonologue_escapeHostages	= false,
	isMB_Support			= false,	
	isSearchEnemy_CollectCNT	= 0,
	isHostages_CollectCNT	= 0,
	isTarget03Discovery		= false,	
	isCollectTank_CNT		= 0,
	isDeadBySearchEnemy		= false,
	isDrpHeliTrap_inPC		= false,
	isTelopEnd				= false,
	
	isReserveFlag_01		= false,	
	isReserveFlag_02		= false,	
	isReserveFlag_03		= false,	
	isReserveFlag_04		= false,	
	isReserveFlag_05		= false,	
	isReserveFlag_06		= false,	
	isReserveFlag_07		= false,	
	isReserveFlag_08		= false,
	isReserveFlag_09		= false,
	isReserveFlag_10		= false,
	isReserveFlag_11		= false,
	isReserveFlag_12		= false,
	isReserveFlag_13		= false,
	isReserveFlag_14		= false,
	isReserveFlag_15		= false,
	isReserveFlag_CNT_01	= 0,		
	isReserveFlag_CNT_02	= 0,
	isReserveFlag_CNT_03	= 0,
	isReserveFlag_CNT_04	= 0,
	isReserveFlag_CNT_05	= 0,
}

this.checkPointList = {
	"CHK_MissionStart",		
	
	"CHK_DBG_StartPoint_01",
	nil
}



function this.OptRadioControl_Setting()

	local sequence = TppSequence.GetCurrentSequenceName()

	if ( sequence == "Seq_Game_MainGame" ) then
		if		svars.isTargrtCount_Clear + svars.isTargetCount_areaOut >= 0 and svars.isTargrtCount_Clear + svars.isTargetCount_areaOut <= 1		then
			s10054_radio.optionalRadio_01()
		elseif	svars.isTargrtCount_Clear + svars.isTargetCount_areaOut == 2	then
			s10054_radio.optionalRadio_02()
		elseif	svars.isTargrtCount_Clear + svars.isTargetCount_areaOut >= 3 and svars.isTargrtCount_Clear + svars.isTargetCount_areaOut <= 4		then
			s10054_radio.optionalRadio_03()
		elseif	svars.isTargrtCount_Clear + svars.isTargetCount_areaOut >= 5 then
			s10054_radio.optionalRadio_04()
		end
	elseif ( sequence == "Seq_Game_Escape" ) then
		if svars.isBonusTarget == true and svars.isBonusTargetClear_CNT <= 2 then
			s10054_radio.optionalRadio_bonus()
		else
			s10054_radio.optionalRadio_escape()
		end
	else
		Fox.Log(" Whats Sequence ...")
	end
end



this.REVENGE_MINE_LIST = {"afgh_enemyBase","afgh_tent","afgh_remnants"}
this.MISSION_REVENGE_MINE_LIST = {

	["afgh_enemyBase"] = {
		
		["trap_afgh_enemyBase_mine_south"] = { 
			mineLocatorList = {
				"itm_revMine_enemyBase_a_0010",
				"itm_revMine_enemyBase_a_0011",
				"itm_revMine_enemyBase_a_0012",
			},
		},
		["trap_afgh_enemyBase_mine_west"] = { 
			mineLocatorList = {
				"itm_revMine_enemyBase_a_0013",
			},
		},
		["trap_afgh_enemyBase_mine_east"] = {	
			mineLocatorList = {
				"itm_revMine_enemyBase_a_0014",
			},
		},
		
		decoyLocatorList = {
			"itm_revDecoy_enemyBase_a_0005",
			"itm_revDecoy_enemyBase_a_0006",
			"itm_revDecoy_enemyBase_a_0007",
		},
	},
	["afgh_remnants"] = {
	},
	["afgh_tent"] = {
	},
	
}

this.baseList = {
	"tent",
	"enemyBase",
	"remnants",
	"tentEast",
	"tentNorth",
	"enemyEast",
	"villageWest",
	"remnantsNorth",
	nil
}



this.missionObjectiveEnum = Tpp.Enum {
	"VAGUE_VEHICLE_POS_01",
	"VAGUE_VEHICLE_POS_02",
	"VAGUE_VEHICLE_01",
	"VAGUE_VEHICLE_02",
	"VAGUE_VEHICLE_03",
	"VAGUE_VEHICLE_04",
	"VAGUE_VEHICLE_05",
	"VAGUE_VEHICLE_06",
	"VAGUE_VEHICLE_07",
	"VAGUE_TRUCK_01",
	"VAGUE_HOSTAGE_VEHICLE",
	"VAGUE_BONUS_01",
	"VAGUE_BONUS_02",
	"VAGUE_BONUS_03",
	"VAGUE_BONUS_04",
	"FIXED_VEHICLE_01",
	"FIXED_VEHICLE_02",
	"FIXED_VEHICLE_03",
	"FIXED_VEHICLE_04",
	"FIXED_VEHICLE_05",
	"FIXED_VEHICLE_06",
	"FIXED_VEHICLE_07",
	"FIXED_TRUCK_01",
	"FIXED_HOSTAGE_VEHICLE",
	"FIXED_BONUS_01",
	"FIXED_BONUS_02",
	"FIXED_BONUS_03",
	"FIXED_BONUS_04",
	"default_photo_Target",
	"clear_photo_Target",
	"default_subGoal",
	"escape_subGoal",
	"missionTask_1",
	"missionTask_1_clear",
	"missionTask_2",
	"missionTask_2_clear",
	"missionTask_3",
	"missionTask_3_clear",
	"missionTask_4",
	"missionTask_4_clear",
	"missionTask_5",
	"missionTask_5_clear",
	"missionTask_6",
	"missionTask_6_clear",
	"missionTask_7",
	"missionTask_7_clear",
	"missionTask_8",
	"missionTask_8_clear",
	"hostage_enemyBase",
	"hostage_remnants",
	"movingHostage_01",
	"movingHostage_02",
	"movingHostage_03",
	"searchEnemy_01",
	"searchEnemy_02",
	"searchEnemy_03",
	"searchEnemy_04",
}

this.specialBonus = {
        first = {
                missionTask = { taskNo = 1 },
                pointList = {
					0,		
					5000,	
					5000,	
					5000,	
					10000,	
					10000,	
					15000,	
					20000,	
					20000,	
					30000,	
					40000,	
				},
                maxCount = 11,
        },
        second = {
                missionTask = { taskNo = 2 },
        }
}






this.missionObjectiveDefine = {
	
	hostage_remnants = {
		gameObjectName = "hos_s10054_0003" , goalType = "defend", setNew = true, viewType = "map_and_world_only_icon", announceLog = "updateMap", langId = "marker_hostage",
	},
	hostage_enemyBase = {
		gameObjectName = "hos_s10054_0004" , goalType = "defend", setNew = true, viewType = "map_and_world_only_icon", announceLog = "updateMap", langId = "marker_hostage",
	},
	
	VAGUE_VEHICLE_POS_01 = {	
		gameObjectName = "Marker_Target01_vague" , visibleArea = 5, randomRange = 9, setNew = false, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea", mapRadioName = "f1000_mprg0220",
	},
	VAGUE_VEHICLE_POS_02 = {	
		gameObjectName = "Marker_Target02_vague" , visibleArea = 5, randomRange = 9, setNew = false, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea", mapRadioName = "f1000_mprg0230",
	},
	
	VAGUE_VEHICLE_01 = {	
		gameObjectName = TARGET_VEHICLE_01 , visibleArea = 5, randomRange = 9, setNew = false, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	VAGUE_VEHICLE_02 = {	
		gameObjectName = TARGET_VEHICLE_02 , visibleArea = 5, randomRange = 9, setNew = false, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	VAGUE_VEHICLE_03 = {	
		gameObjectName = TARGET_VEHICLE_03 , visibleArea = 1, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	VAGUE_VEHICLE_04 = {	
		gameObjectName = TARGET_VEHICLE_04 , visibleArea = 5, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	VAGUE_VEHICLE_05 = {	
		gameObjectName = TARGET_VEHICLE_05 , visibleArea = 5, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	VAGUE_VEHICLE_06 = {	
		gameObjectName = TARGET_VEHICLE_06 , visibleArea = 5, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	VAGUE_VEHICLE_07 = {	
		gameObjectName = TARGET_VEHICLE_07 , visibleArea = 5, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	VAGUE_TRUCK_01 = {	
		gameObjectName = BULLET_TRUCK_01 , visibleArea = 5, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_truck",
	},
	VAGUE_HOSTAGE_VEHICLE = {	
		gameObjectName = VEHICLE_01 , visibleArea = 5, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_vehicle_4wd",
	},
	VAGUE_BONUS_01 = {	
		gameObjectName = BONUS_TNK_01 , visibleArea = 6, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_tank",
	},
	VAGUE_BONUS_02 = {	
		gameObjectName = BONUS_TNK_02 , visibleArea = 6, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_tank",
	},
	VAGUE_BONUS_03 = {	
		gameObjectName = BONUS_TNK_03 , visibleArea = 6, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_tank",
	},
	VAGUE_BONUS_04 = {	
		gameObjectName = BONUS_HELI , visibleArea = 7, randomRange = 9, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_heli_battle",
	},
	
	FIXED_VEHICLE_01 = {
		gameObjectName = TARGET_VEHICLE_01 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_mission_target",
	},
	FIXED_VEHICLE_02 = {
		gameObjectName = TARGET_VEHICLE_02 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_mission_target",
	},
	FIXED_VEHICLE_03 = {
		gameObjectName = TARGET_VEHICLE_03 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_mission_target",
	},
	FIXED_VEHICLE_04 = {
		gameObjectName = TARGET_VEHICLE_04 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_mission_target",
	},
	FIXED_VEHICLE_05 = {
		gameObjectName = TARGET_VEHICLE_05 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_mission_target",
	},
	FIXED_VEHICLE_06 = {
		gameObjectName = TARGET_VEHICLE_06 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_mission_target",
	},
	FIXED_VEHICLE_07 = {
		gameObjectName = TARGET_VEHICLE_07 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_mission_target",
	},
	FIXED_TRUCK_01 = {
		gameObjectName = BULLET_TRUCK_01 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_truck",
	},
	FIXED_HOSTAGE_VEHICLE = {
		gameObjectName = "hos_s10054_0001" , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId = "marker_hostage",
	},
	FIXED_BONUS_01 = {
		gameObjectName = BONUS_TNK_01 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_tank",
	},
	FIXED_BONUS_02 = {
		gameObjectName = BONUS_TNK_02 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_tank",
	},
	FIXED_BONUS_03 = {
		gameObjectName = BONUS_TNK_03 , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_tank",
	},
	FIXED_BONUS_04 = {
		gameObjectName = BONUS_HELI , goalType = "attack", viewType = "map_and_world_only_icon", setImportant = true, announceLog = "updateMap", langId="marker_info_heli_battle",
	},
	
	default_photo_Target = {
			photoId = 10,	photoRadioName = "f1000_mirg0010",
	},
	clear_photo_Target = {
			photoId = 10,
	},
	
	default_subGoal = {	
		subGoalId= 0,
	},
	escape_subGoal = {
		subGoalId= 1,
	},
	
	missionTask_1 = {	
		missionTask = { taskNo=0, isNew=true, isComplete=false },
	},
	missionTask_1_clear = {
		missionTask = { taskNo=0, isComplete=true },
	},
	missionTask_2 = {	
		missionTask = { taskNo=1, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_2_clear = {
		missionTask = { taskNo=1, isComplete=true, },
	},
	missionTask_3 = {	
		missionTask = { taskNo=2, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_3_clear = {
		missionTask = { taskNo=2 },
	},
	missionTask_4 = {	
		missionTask = { taskNo=3, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_4_clear = {
		missionTask = { taskNo=3, isComplete=true },
	},
	missionTask_5 = {	
		missionTask = { taskNo=4, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_5_clear = {
		missionTask = { taskNo=4, isComplete=true },
	},
	missionTask_6 = {	
		missionTask = { taskNo=5, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_6_clear = {
		missionTask = { taskNo=5, isComplete=true },
	},
	missionTask_7 = {	
		missionTask = { taskNo=6, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_7_clear = {
		missionTask = { taskNo=6, isComplete=true },
	},
	missionTask_8 = {	
		missionTask = { taskNo=7, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_8_clear = {
		missionTask = { taskNo=7, isComplete=true },
	},
	
	movingHostage_01 = {
		gameObjectName = "Marker_movingHostage_MNT" , visibleArea = 4, randomRange = 0, setNew = true, viewType = "map_only_icon", announceLog = "updateMap", langId = "marker_information",
	},
	movingHostage_02 = {
		gameObjectName = "Marker_movingHostage_RVR" , visibleArea = 5, randomRange = 0, setNew = true, viewType = "map_only_icon", announceLog = "updateMap", langId = "marker_information",
	},
	movingHostage_03 = {
		gameObjectName = "Marker_movingHostage_SND" , visibleArea = 5, randomRange = 0, setNew = true, viewType = "map_only_icon", announceLog = "updateMap", langId = "marker_information",
	},
	
	searchEnemy_01 = {
		gameObjectName = "sol_search_0000" , goalType = "attack", viewType = "map_and_world_only_icon", announceLog = "updateMap",
	},
	searchEnemy_02 = {
		gameObjectName = "sol_search_0001" , goalType = "attack", viewType = "map_and_world_only_icon", announceLog = "updateMap",
	},
	searchEnemy_03 = {
		gameObjectName = "sol_search_0002" , goalType = "attack", viewType = "map_and_world_only_icon", announceLog = "updateMap",
	},
	searchEnemy_04 = {
		gameObjectName = "sol_search_0003" , goalType = "attack", viewType = "map_and_world_only_icon", announceLog = "updateMap",
	},
}










this.missionObjectiveTree = {

	clear_photo_Target = {
		default_photo_Target = {},
	},

	FIXED_VEHICLE_01 = {
		VAGUE_VEHICLE_01 = {
			VAGUE_VEHICLE_POS_01 = {},
		},
	},
	FIXED_VEHICLE_02 = {
		VAGUE_VEHICLE_02 = {
			VAGUE_VEHICLE_POS_02 = {},
		},
	},
	FIXED_VEHICLE_03 = {
		VAGUE_VEHICLE_03 = {},
	},
	FIXED_VEHICLE_04 = {
		VAGUE_VEHICLE_04 = {},
	},
	FIXED_VEHICLE_05 = {
		VAGUE_VEHICLE_05 = {},
	},
	FIXED_VEHICLE_06 = {
		VAGUE_VEHICLE_06 = {},
	},
	FIXED_VEHICLE_07 = {
		VAGUE_VEHICLE_07 = {},
	},
	FIXED_TRUCK_01 = {
		VAGUE_TRUCK_01 = {},
	},
	FIXED_HOSTAGE_VEHICLE = {
		VAGUE_HOSTAGE_VEHICLE = {},
	},
	FIXED_BONUS_01 = {
		VAGUE_BONUS_01 = {},
	},
	FIXED_BONUS_02 = {
		VAGUE_BONUS_02 = {},
	},
	FIXED_BONUS_03 = {
		VAGUE_BONUS_03 = {},
	},
	FIXED_BONUS_04 = {
		VAGUE_BONUS_04 = {},
	},
	escape_subGoal = {
		default_subGoal = {},
	},
	missionTask_1_clear = {
		missionTask_1 = {},
	},
	missionTask_2_clear = {
		missionTask_2 = {},
	},
	missionTask_3_clear = {
		missionTask_3 = {},
	},
	missionTask_4_clear = {
		missionTask_4 = {},
	},
	missionTask_5_clear = {
		missionTask_5 = {},
	},
	missionTask_6_clear = {
		missionTask_6 = {},
	},
	missionTask_7_clear = {
		missionTask_7 = {},
	},
	missionTask_8_clear = {
		missionTask_8 = {},
	},
}

this.missionStartPosition = {
		orderBoxList = {
			"box_s10054_00",
			"box_s10054_01",
			"box_s10054_02",
		},
		helicopterRouteList = {
			
			"lz_drp_remnantsNorth_N0000|rt_drp_remnantsNorth_N_0000",	
			"lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000",			
			"lz_drp_tent_N0000|rt_drp_tent_N_0000",						
			
			"lz_drp_remnants_I0000|rt_drp_remnants_I_0000",	
			"lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000",	
			"lz_drp_tent_I0000|rt_drp_tent_I_0000",				
		},
}




function this.OnGameOver()

	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.S10054_TIME_UP ) then
		Fox.Log("gameover patarn is TIME UP & NO CLEAR TARGET ")
	
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	else
		Fox.Log("gameover patarn is not TIME UP & NO CLEAR TARGET ")
	end
end






function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	
	TppUiCommand.EraseDisplayTimer()		
	TppUiCommand.InitAllEnemyRoutePoints()	
	TppRatBird.EnableRat()	
	TppRatBird.EnableBird("TppCritterBird")	
	
	TppMission.RegisterMissionSystemCallback{
		
		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,
		OnEstablishMissionClear = function( missionClearType )
			
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
		end,
		
		OnRecovered = function( gameObjectId )
			if gameObjectId == GameObject.GetGameObjectId( "sol_search_0000" ) or gameObjectId == GameObject.GetGameObjectId( "sol_search_0001" )
				or gameObjectId == GameObject.GetGameObjectId( "sol_search_0002" ) or gameObjectId == GameObject.GetGameObjectId( "sol_search_0003" )	then
				
					svars.isSearchEnemy_CollectCNT = svars.isSearchEnemy_CollectCNT + 1

					if svars.isSearchEnemy_CollectCNT	>= 4	then
						TppMission.UpdateObjective{
							objectives = { "missionTask_6_clear",},
						}
					else
					end
			elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0000" ) or gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0001" ) or gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0002" )
				or gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0003" ) or gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0004" ) or gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0005" )	then

					svars.isHostages_CollectCNT = svars.isHostages_CollectCNT + 1
					
					
					if gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0005" )		then	
						TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
						{ 
							{ name = "enqt1000_107027",		func = s10054_enemy.InterCall_movingHostage_02, },
						} )
						TppMarker.Disable("Marker_movingHostage_MNT")
					elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0000" )		then	
						TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
						{ 
							{ name = "enqt1000_107032",		func = s10054_enemy.InterCall_movingHostage_03, },
						} )
						TppMarker.Disable("Marker_movingHostage_RVR")
					elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0002" )		then	
						TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
						{ 
							{ name = "enqt1000_1i1210",		func = s10054_enemy.InterCall_movingHostage_04, },
						} )
						TppMarker.Disable("Marker_movingHostage_SND")
					else
					end
					
					if svars.isHostages_CollectCNT	>= 6	then
						TppMission.UpdateObjective{
							objectives = { "missionTask_7_clear",},
						}
					else
					end
					
					if gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0001" )	and svars.isTarget03Discovery == false and svars.isTargetVehicle_03 == 0	then
						s10054_radio.hostageInfo_hideTarget()
					else
						Fox.Log("Target03 Radio Nothing !!")
					end
			elseif gameObjectId == GameObject.GetGameObjectId( "veh_s10054_0010" ) or gameObjectId == GameObject.GetGameObjectId( "veh_s10054_0011" ) or gameObjectId == GameObject.GetGameObjectId( "veh_s10054_0012" )	then

				svars.isCollectTank_CNT = svars.isCollectTank_CNT + 1
				svars.isBonusTargetClear_CNT = svars.isBonusTargetClear_CNT + 1
				TppUI.ShowAnnounceLog( "recoverTarget" )	
				this.bonusTargetClear_commonAnnounceLog()	
				this.OptRadioControl_Setting()
				this.BGM_Setting()							
				if svars.isCollectTank_CNT	>= 3	then
						TppMission.UpdateObjective{
							objectives = { "missionTask_8_clear",},
						}
				else
				end
			else
				Fox.Log("NO SETTING CHARACTER !!")
			end
        end,
        OnSetMissionFinalScore = function( missionClearType )
			
			if svars.isReserveFlag_03 == true	then
				for i=1,svars.isTargrtCount_Clear + svars.isBonusTargetClear_CNT,1 do
					TppResult.AcquireSpecialBonus{ first = { pointIndex = i },}
				end
			else
			end
        end,
		OnGameOver = this.OnGameOver	
	}
	
	
	TppMarker.SetUpSearchTarget{	
		{	
			gameObjectName = TARGET_VEHICLE_03,
			gameObjectType = "TppVehicle2",
			messageName = TARGET_VEHICLE_03,
			offSet = Vector3(0,1.5,-0.25),
			doDirectionCheck = false,
			func = function ()
				local sequence = TppSequence.GetCurrentSequenceName()
				svars.isTarget03Discovery = true
				
				if sequence == "Seq_Game_MainGame"	then
					if svars.isTargetVehicle_03 == 0	then
						s10054_radio.discovery_hideTargetVehicle01()
					else
						s10054_radio.markingTarget_01()
					end
				else
					s10054_radio.discovery_hideTargetVehicle02()
				end
			end,
		},
	}
	

























































































































end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
	TppRevenge.RegisterMissionMineList( this.MISSION_REVENGE_MINE_LIST )
end

function this.AddHighInterrogation()
	
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("afgh_remnants_cp"),
	{ 
		{ name = "enqt1000_1i1210",		func = s10054_enemy.InterCall_Hostage_01, },	
		{ name = "enqt1000_107018",		func = s10054_enemy.InterCall_searchEnemy, },	
	} )
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("afgh_enemyBase_cp"),
	{ 
		{ name = "enqt1000_1i1310",		func = s10054_enemy.InterCall_Hostage_02, },	
		{ name = "enqt1000_107018",		func = s10054_enemy.InterCall_searchEnemy, },	
	} )
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("afgh_villageWest_ob"),
	{ 
		{ name = "enqt1000_107018",		func = s10054_enemy.InterCall_searchEnemy, },	
	} )
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("afgh_tent_cp"),
	{ 
		{ name = "enqt1000_107018",		func = s10054_enemy.InterCall_searchEnemy, },	
	} )	
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("afgh_tentEast_ob"),
	{ 
		{ name = "enqt1000_107018",		func = s10054_enemy.InterCall_searchEnemy, },	
	} )
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("afgh_tentNorth_ob"),
	{ 
		{ name = "enqt1000_107018",		func = s10054_enemy.InterCall_searchEnemy, },	
	} )
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("afgh_enemyEast_ob"),
	{ 
		{ name = "enqt1000_107018",		func = s10054_enemy.InterCall_searchEnemy, },	
	} )
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("afgh_remnantsNorth_ob"),
	{ 
		{ name = "enqt1000_107018",		func = s10054_enemy.InterCall_searchEnemy, },	
	} )
	TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
	{ 
		{ name = "enqt1000_107022",		func = s10054_enemy.InterCall_movingHostage_01, },	
		{ name = "enqt1000_107027",		func = s10054_enemy.InterCall_movingHostage_02, },	
		{ name = "enqt1000_107032",		func = s10054_enemy.InterCall_movingHostage_03, },	
		{ name = "enqt1000_1i1210",		func = s10054_enemy.InterCall_movingHostage_04, },	
	} )
	






	

end



function this.AddMapIconText()
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId("veh_s10054_0006"), langId="marker_info_vehicle_4wd" }		
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId("veh_s10054_0009"), langId="marker_info_truck" }		
end



function this.targetIconText_Change()
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId( TARGET_VEHICLE_01 ), langId="marker_info_APC" }
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId( TARGET_VEHICLE_02 ), langId="marker_info_APC" }
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId( TARGET_VEHICLE_03 ), langId="marker_info_APC" }
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId( TARGET_VEHICLE_04 ), langId="marker_info_APC" }
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId( TARGET_VEHICLE_05 ), langId="marker_info_APC" }
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId( TARGET_VEHICLE_06 ), langId="marker_info_APC" }
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId( TARGET_VEHICLE_07 ), langId="marker_info_APC" }
end



function this.bonusTargetClear_commonAnnounceLog()

	TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.isTargrtCount_Clear + svars.isBonusTargetClear_CNT , TARGET_VEHICLE_COUNT + BONUS_TARGET_COUNT )
end

function this.targetClear_commonAnnounceLog()
	
	TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.isTargrtCount_Clear , TARGET_VEHICLE_COUNT )
	
	
	if		svars.isTargrtCount_Clear == 1	then
		TppMission.UpdateObjective{ objectives = { "missionTask_1_clear",},}
	elseif	svars.isTargrtCount_Clear >= 2 and svars.isTargrtCount_Clear <= 6	then
		if svars.isReserveFlag_03 == false	then
			TppMission.UpdateObjective{ objectives = { "missionTask_2_clear",},}
			svars.isReserveFlag_03 = true
		else
			Fox.Log("already missionTask_2_clear ... ")
		end
	elseif	svars.isTargrtCount_Clear >= 7	then
		Fox.Log("All Normal Targets Clear !!")
	else
		Fox.Error("svars.isTargrtCount_Clear is WRONG VALUE !!")
	end
	
	if svars.isReserveFlag_01 == true and svars.isReserveFlag_02 == false	then
		TppMission.UpdateObjective{ objectives = { "missionTask_5_clear",},}
		svars.isReserveFlag_02 = true
	else
		Fox.Log("svars.isReserveFlag_01 == false ... Nothing Done !!")
	end
end

function this.targetDestory_commonAnnounceLog()

	TppUI.ShowAnnounceLog( "destroyTarget" )
	
	if		svars.isTargrtCount_Clear >= 7	then
		svars.isBonusTarget = true
		TppSequence.SetNextSequence("Seq_Game_Escape")		
	else
		Fox.Log("svars.isTargrtCount_Clear <= 6 ... Nothing Done !!")
	end

	this.targetClear_commonAnnounceLog()	
end

function this.targetRecover_commonAnnounceLog()

	TppUI.ShowAnnounceLog( "recoverTarget" )

	if		svars.isTargrtCount_Clear >= 7	then
		svars.isBonusTarget = true
		TppSequence.SetNextSequence("Seq_Game_Escape")		
	else
		Fox.Log("svars.isTargrtCount_Clear is NO MACH !!")
	end

	this.targetClear_commonAnnounceLog()	
end



function this.EventTimer_Disposal()

	local sequence = TppSequence.GetCurrentSequenceName()
	local TimerName = GkEventTimerManager.IsTimerActive( "timer_PasstimeCheck" )
	Fox.Log("timer_PasstimeCheck is ".. tostring(TimerName) .. " !!")
	if ( sequence == "Seq_Game_MainGame" )	then
		if GkEventTimerManager.IsTimerActive( "timer_PasstimeCheck" ) == true	then
			Fox.Log("already EventTimer Start ... Nothing Done !!")
		else
			TimerStart( "timer_PasstimeCheck", 5 )		
		end
	elseif ( sequence == "Seq_Game_Escape" )	then
		GkEventTimerManager.Stop("timer_PasstimeCheck")
	else
	end
end



function this.nextVehicle_ON()

	if svars.isTargrtCount_Clear + svars.isTargetCount_areaOut + svars.isNonTargetCount_areaOut == 0		then
		Fox.Log("isTargrtCount_Clear + isTargetCount_areaOut + isNonTargetCount_areaOut == 0 ... No Clear or AreaOut Target Vehicle !!")
	elseif svars.isTargrtCount_Clear + svars.isTargetCount_areaOut + svars.isNonTargetCount_areaOut == 1	then
		this.areaOut01_GO()				
	elseif svars.isTargrtCount_Clear + svars.isTargetCount_areaOut + svars.isNonTargetCount_areaOut == 2	then
		this.vehicle_GO()				
		this.areaOut01_GO()				
	elseif svars.isTargrtCount_Clear + svars.isTargetCount_areaOut + svars.isNonTargetCount_areaOut == 3	then
		this.areaOut02_GO()				
		this.areaOut01_GO()				
		this.vehicle_GO()				
	elseif svars.isTargrtCount_Clear + svars.isTargetCount_areaOut + svars.isNonTargetCount_areaOut == 4	then
		this.hideTargetVehicle_GO()		
		this.areaOut01_GO()				
		this.vehicle_GO()				
		this.areaOut02_GO()				
	elseif svars.isTargrtCount_Clear + svars.isTargetCount_areaOut + svars.isNonTargetCount_areaOut == 5	then
		this.bulletTruck_GO()			
		this.areaOut01_GO()				
		this.vehicle_GO()				
		this.areaOut02_GO()				
		this.hideTargetVehicle_GO()		
	elseif svars.isTargrtCount_Clear + svars.isTargetCount_areaOut + svars.isNonTargetCount_areaOut >= 6	then
		this.areaOut03_GO()				
		this.areaOut01_GO()				
		this.vehicle_GO()				
		this.areaOut02_GO()				
		this.hideTargetVehicle_GO()		
		this.bulletTruck_GO()			
	else
		Fox.Log("isTargrtCount_Clear + isTargetCount_areaOut = WRONG VALUE ...")
	end
end



function this.checkPoint_off()
	
	TppCheckPoint.Disable{ baseName = { "tent", "enemyBase", "remnants", "tentEast","tentNorth","enemyEast","villageWest","remnantsNorth",} }
end



function this.BGM_Setting()

	local sequence = TppSequence.GetCurrentSequenceName()

	if		sequence == "Seq_Game_MainGame"		then
		s10054_sound.SetPhase_frontLine()
		if svars.isEmergencyTime == true	then
			s10054_sound.SetScene_emergencyTime()
		else
			Fox.Log("No EmergencyTime ... Not BGM Change !!")
		end
	elseif	sequence == "Seq_Game_Escape"		then
		if svars.isBonusTarget == true	then
			if svars.isBonusTargetClear_CNT == BONUS_TARGET_COUNT	then
				s10054_sound.SetScene_bonusTarget_AllClear()
			else
				s10054_sound.SetScene_bonusTarget()
			end
		else
			Fox.Log("No BonusTarget ... Not BGM Change !!")
		end
	else
		TppSound.StopSceneBGM() 
		TppSound.ResetPhaseBGM() 
	end
end



function this.common_movingCourseCheck()


	
	
	
	
	
	
	


	local sequence = TppSequence.GetCurrentSequenceName()

	if		sequence == "Seq_Game_MainGame"		then

	
	TppUiCommand.InitAllEnemyRoutePoints()	

	
	if		svars.isTargetVehicle_01 == 1	or	svars.isTargetVehicle_02 == 1	or	svars.isTargetVehicle_03 == 1
		or	svars.isTargetVehicle_04 == 1	or	svars.isTargetVehicle_05 == 1	or	svars.isTargetVehicle_06 == 1	or	svars.isTargetVehicle_07 == 1	then
		TppUiCommand.ShowEnemyRoutePoints{ groupIndex=0, width=250.0, langId="marker_target_forecast_path", radioGroupName = Fox.StrCode32("f1000_mprg0240"),
			points={
				Vector3( -1797.1,0.0,37.0 ), Vector3( -1917.5,0.0,571.9 ), Vector3( -1760.0,0.0,750.0 ),
			}
		}
	else
		Fox.Log("A_Route No Mapping ... ")
	end
	
	if		svars.isTargetVehicle_01 == 1	or	svars.isTargetVehicle_05 == 1	then
		TppUiCommand.ShowEnemyRoutePoints{ groupIndex=1, width=250.0, langId="marker_target_forecast_path", radioGroupName = Fox.StrCode32("f1000_mprg0250"),
			points={
				Vector3( -1520.0,0.0,880.0 ), Vector3( -888.4,0.0,964.2 ), Vector3( -550.2,0.0,635.0 ),
			}
		}
	else
		Fox.Log("B_Route No Mapping ... ")
	end
	
	if		svars.isTargetVehicle_02 == 1	or	svars.isTargetVehicle_04 == 1	or	svars.isTargetVehicle_06 == 1
		or	svars.isTargetVehicle_07 == 1	then
		TppUiCommand.ShowEnemyRoutePoints{ groupIndex=2, width=250.0, langId="marker_target_forecast_path", radioGroupName = Fox.StrCode32("f1000_mprg0240"),
			points={
				Vector3( -1750.0,0.0,1000.0 ), Vector3( -1570.0,0.0,1170.0 ), Vector3( -1237.9,0.0,1200.0 ), 
				Vector3( -970.0,0.0,1470.0 ), Vector3( -876.4,0.0,1849.5 ),
			}
		}
	else
		Fox.Log("C_Route No Mapping ... ")
	end
	
	if		svars.isTargetVehicle_04 == 1	then
		if svars.isTarget04_D_route == false	then
			TppUiCommand.ShowEnemyRoutePoints{ groupIndex=3, width=250.0, langId="marker_target_forecast_path", radioGroupName = Fox.StrCode32("f1000_mprg0250"),
				points={
					Vector3( -749.5,0.0,1476.4 ), Vector3( -187.2,0.0,1760.3 ),
				}
			}
		else
			Fox.Log("svars.isTarget04_D_route == true ... D_Route OFF !!")
		end
	else
		Fox.Log("D_Route No Mapping ... ")
	end	
	
	if		svars.isTargetVehicle_05 == 1	then
		if svars.isTarget05_E_route == false	then
			TppUiCommand.ShowEnemyRoutePoints{ groupIndex=4, width=250.0, langId="marker_target_forecast_path", radioGroupName = Fox.StrCode32("f1000_mprg0250"),
				points={
					Vector3( -404.1,0.0,856.8 ), Vector3( -105.8,0.0,943.8 ), Vector3( 30.8,0.0,816.1 ),
				}
			}
		else
			Fox.Log("svars.isTarget05_E_route == true ... D_Route OFF !!")
		end
	else
		Fox.Log("D_Route No Mapping ... ")
	end
	
	else
	end
end



this.timerStart = function ()
	TppUI.StartDisplayTimer{
		svarsName = "displayTimeSec",
		cautionTimeSec = TIME_LIMIT.CAUTION_TIME_SEC,
	}
	TppUiCommand.SetDisplayTimerText( "timeCount_10054_00" )	
end



this.BonusTarget_ON = function()
	local bonusDriverId_01		= GameObject.GetGameObjectId("TppSoldier2", BONUS_VEHICLE_DRIVER_01 )
	local bonusDriverId_02		= GameObject.GetGameObjectId("TppSoldier2", BONUS_VEHICLE_DRIVER_02 )
	local bonusVehicleId_01		= GameObject.GetGameObjectId("TppVehicle2", BONUS_TNK_01 )
	local bonusVehicleId_02		= GameObject.GetGameObjectId("TppVehicle2", BONUS_TNK_02 )
	local command_bonus01 		= { id="SetRelativeVehicle", targetId = bonusVehicleId_01	, rideFromBeginning = true }
	local command_bonus02 		= { id="SetRelativeVehicle", targetId = bonusVehicleId_02	, rideFromBeginning = true }
	
	svars.isBonusTarget = true
	this.BGM_Setting()
	
	GameObject.SendCommand( { type="TppVehicle2", },{ id = "Respawn", name = BONUS_TNK_01 , } )
	GameObject.SendCommand( { type="TppVehicle2", },{ id = "Respawn", name = BONUS_TNK_02 , } )
	
	GameObject.SendCommand( GameObject.GetGameObjectId( BONUS_VEHICLE_DRIVER_01 ) , { id="SetEnabled", enabled=true } )
	GameObject.SendCommand( GameObject.GetGameObjectId( BONUS_VEHICLE_DRIVER_02 ) , { id="SetEnabled", enabled=true } )
	
	GameObject.SendCommand( bonusDriverId_01	, command_bonus01 )
	GameObject.SendCommand( bonusDriverId_02	, command_bonus02 )
	
	s10054_enemy.bonusTarget_GO()
	
	TppEnemy.SetSneakRoute( BONUS_HELI , "rts_eneHeli_0000", 0 )
	TppEnemy.SetCautionRoute( BONUS_HELI , "rts_eneHeli_0000", 0 )
	
	s10054_radio.escape_AllTargetClear_after()
	
	this.OptRadioControl_Setting()
	
	TimerStart( "timer_BonusPasstimeCheck", 5 )		
	
	for i, cpId in pairs( cpId_TABLE ) do
		local cpId_GID			= GameObject.GetGameObjectId( "TppCommandPost2" , cpId )
		local KeepCaution_ON	= { id = "SetKeepCaution", enable = true }
		GameObject.SendCommand( cpId_GID, KeepCaution_ON )
	end
end

this.BonusTarget_ON_2 = function()

	
	if svars.isBonusTarget == true and 	svars.isNonTargetCount_areaOut >= 2 and svars.isReserveFlag_08 == false then

		local bonusDriverId_03		= GameObject.GetGameObjectId("TppSoldier2", BONUS_VEHICLE_DRIVER_03 )
		local bonusVehicleId_03		= GameObject.GetGameObjectId("TppVehicle2", BONUS_TNK_03 )	
		local command_bonus03		= { id="SetRelativeVehicle", targetId = bonusVehicleId_03	, rideFromBeginning = true }

		GameObject.SendCommand( { type="TppVehicle2", },{ id = "Respawn", name = BONUS_TNK_03 , } )
		GameObject.SendCommand( GameObject.GetGameObjectId( BONUS_VEHICLE_DRIVER_03 ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( bonusDriverId_03	, command_bonus03 )
		
		TppMission.UpdateObjective{ objectives = { "FIXED_BONUS_03" } }
		s10054_enemy.bonusTarget_GO_2()
		svars.isReserveFlag_08 = true
		GkEventTimerManager.Stop("timer_BonusPasstimeCheck")
	else
		TimerStart( "timer_BonusPasstimeCheck", 5 )
	end
end



this.unTargetDriver_clear = function( gameObjectId )
	local truck_bul = GameObject.GetGameObjectId( "TppVehicle2", BULLET_TRUCK_01 )
	local vehicle_hos = GameObject.GetGameObjectId( "TppVehicle2", VEHICLE_01 )

	if 		gameObjectId == GameObject.GetGameObjectId( BULLET_TRUCK_DRIVER_01	)	then	
		if svars.isReserveFlag_04 == false	and GameObject.SendCommand( truck_bul , { id="IsAlive", } ) then
			svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
			svars.isReserveFlag_04 = true
			svars.isBulletTruck = 3
			TppMarker.Disable( BULLET_TRUCK_01 )
		else
			Fox.Log("Nothing Done !!")
		end
	elseif 	gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_01 )	then		
		if svars.isReserveFlag_05 == false	and GameObject.SendCommand( vehicle_hos , { id="IsAlive", } ) then
			svars.isReserveFlag_CNT_01 = svars.isReserveFlag_CNT_01 + 1
			svars.isReserveFlag_05 = true
			if svars.isReserveFlag_CNT_01 >= 2	then
				TppMarker.Disable( VEHICLE_01 )
				svars.isHostageVehicle = 3
				svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
			else
				Fox.Log("Nothing Done !!")
			end
		else
			Fox.Log("Nothing Done !!")
		end
	elseif 	gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_02 )	then		
		if svars.isReserveFlag_06 == false	and GameObject.SendCommand( vehicle_hos , { id="IsAlive", } ) then
			svars.isReserveFlag_CNT_01 = svars.isReserveFlag_CNT_01 + 1
			svars.isReserveFlag_06 = true
			if svars.isReserveFlag_CNT_01 >= 2	then
				TppMarker.Disable( VEHICLE_01 )
				svars.isHostageVehicle = 3
				svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
			else
				Fox.Log("Nothing Done !!")
			end
		else
			Fox.Log("Nothing Done !!")
		end
	else
		Fox.Error("NO SETTING CHARA ... MUST CHECK !!")
	end
end




this.enemyBaseVehicle_GO = function()

	if svars.isTargetVehicle_01 == 0	then
		Fox.Log("enemyBaseTargetVehicle_GO")
		
		svars.isTargetVehicle_01 = 1
		
		s10054_enemy.enemyBaseTargetVehicle_GO()
	elseif svars.isTargetVehicle_01 == 1	then
		Fox.Log("TargetVehicle_01 Now Moving ...")
	elseif svars.isTargetVehicle_01 == 2	then
		Fox.Log("TargetVehicle_01 Clear or areaOut")
	else
		Fox.Log("TargetVehicle_01 is WRONG VALUE ... CHECK !!")
	end
end

this.remnantsVehicle_GO = function()

	if svars.isTargetVehicle_02 == 0	then
		Fox.Log("remnantsTargetVehicle_GO")
		
		svars.isTargetVehicle_02 = 1
		
		s10054_enemy.remnantsTargetVehicle_GO()	
		
		this.common_movingCourseCheck()	
		
		s10054_radio.Target_movingStart()
		






	elseif svars.isTargetVehicle_02 == 1	then
		Fox.Log("TargetVehicle_02 Now Moving ...")
	elseif svars.isTargetVehicle_02 == 2	then
		Fox.Log("TargetVehicle_02 Clear or areaOut")
	else
		Fox.Log("TargetVehicle_02 is WRONG VALUE ... CHECK !!")
	end			
end

this.hideTargetVehicle_GO = function()
	if svars.isTargetVehicle_03 == 0	then
		Fox.Log("HideVehicle_GO")
		
		svars.isTargetVehicle_03 = 1
		
		s10054_enemy.hideTargetVehicle_GO()	
		
		TppMission.UpdateObjective{
			radio = { radioGroups = "f1000_rtrg3280", },
			
			objectives = { "FIXED_VEHICLE_03", }
		}
		
		this.common_movingCourseCheck()
	elseif svars.isTargetVehicle_03 == 1	then
		Fox.Log("TargetVehicle_03 Now Moving ...")
	elseif svars.isTargetVehicle_03 == 2	then
		Fox.Log("TargetVehicle_03 Clear or areaOut")
	else
		Fox.Log("TargetVehicle_03 is WRONG VALUE ... CHECK !!")
	end
end

this.areaOut01_GO = function()

	local targetDriverId_04		= GameObject.GetGameObjectId("TppSoldier2", TARGET_VEHICLE_DRIVER_04 )
	local targetVehicleId_04	= GameObject.GetGameObjectId("TppVehicle2", TARGET_VEHICLE_04 )
	local command_target04 		= { id="SetRelativeVehicle", targetId = targetVehicleId_04	, rideFromBeginning = true }

	if svars.isTargetVehicle_04 == 0	then
		Fox.Log(" areaOut01_GO ")
		
		svars.isTargetVehicle_04 = 1
		
		GameObject.SendCommand( { type="TppVehicle2", },{ id = "Respawn", name = TARGET_VEHICLE_04 , } )
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_04 ) , { id="SetEnabled", enabled=true } )
		
		GameObject.SendCommand( targetDriverId_04	, command_target04 )
		
		s10054_enemy.areaOut01_GO()	
		this.common_movingCourseCheck()	
		
		TppMission.UpdateObjective{
			radio = { radioGroups = "s0054_rtrg2110", },
			
	
			objectives = { "FIXED_VEHICLE_04", }
		}
	elseif svars.isTargetVehicle_04 == 1	then
		Fox.Log("TargetVehicle_04 Now Moving ...")
	elseif svars.isTargetVehicle_04 == 2	then
		Fox.Log("TargetVehicle_04 Clear or areaOut")
	else
		Fox.Log("TargetVehicle_04 is WRONG VALUE ... CHECK !!")
	end
end

this.areaOut02_GO = function()

	local targetDriverId_05		= GameObject.GetGameObjectId("TppSoldier2", TARGET_VEHICLE_DRIVER_05 )
	local targetVehicleId_05	= GameObject.GetGameObjectId("TppVehicle2", TARGET_VEHICLE_05 )
	local command_target05 		= { id="SetRelativeVehicle", targetId = targetVehicleId_05	, rideFromBeginning = true }

	if svars.isTargetVehicle_05 == 0	then
		Fox.Log("areaOut02_GO")
		
		svars.isTargetVehicle_05 = 1
		
		GameObject.SendCommand( { type="TppVehicle2", },{ id = "Respawn", name = TARGET_VEHICLE_05 , } )
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_05 ) , { id="SetEnabled", enabled=true } )
		
		GameObject.SendCommand( targetDriverId_05	, command_target05 )
		
		s10054_enemy.areaOut02_GO()	
		this.common_movingCourseCheck()	
		
		TppMission.UpdateObjective{
			radio = { radioGroups = "s0054_rtrg2120", },
			
	
			objectives = { "FIXED_VEHICLE_05", }
		}
	elseif svars.isTargetVehicle_05 == 1	then
		Fox.Log("TargetVehicle_05 Now Moving ...")
	elseif svars.isTargetVehicle_05 == 2	then
		Fox.Log("TargetVehicle_05 Clear or areaOut")
	else
		Fox.Log("TargetVehicle_05 is WRONG VALUE ... CHECK !!")
	end
end

this.areaOut03_GO = function()
	if ( svars.isTargetVehicle_06 == 0 ) and ( svars.isTargetVehicle_07 == 0 )	then
		Fox.Log("areaOut03_GO")
		local targetDriverId_06		= GameObject.GetGameObjectId("TppSoldier2", TARGET_VEHICLE_DRIVER_06 )
		local targetDriverId_07		= GameObject.GetGameObjectId("TppSoldier2", TARGET_VEHICLE_DRIVER_07 )
		local targetVehicleId_06	= GameObject.GetGameObjectId("TppVehicle2", TARGET_VEHICLE_06 )
		local targetVehicleId_07	= GameObject.GetGameObjectId("TppVehicle2", TARGET_VEHICLE_07 )
		local command_target06 		= { id="SetRelativeVehicle", targetId = targetVehicleId_06	, rideFromBeginning = true }
		local command_target07 		= { id="SetRelativeVehicle", targetId = targetVehicleId_07	, rideFromBeginning = true }
		
		svars.isTargetVehicle_06 = 1
		svars.isTargetVehicle_07 = 1
		
		GameObject.SendCommand( { type="TppVehicle2", },{ id = "Respawn", name = TARGET_VEHICLE_06 , } )
		GameObject.SendCommand( { type="TppVehicle2", },{ id = "Respawn", name = TARGET_VEHICLE_07 , } )		
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_06 ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_07 ) , { id="SetEnabled", enabled=true } )
		
		GameObject.SendCommand( targetDriverId_06	, command_target06 )
		GameObject.SendCommand( targetDriverId_07	, command_target07 )
		
		GameObject.SendCommand( { type="TppVehicle2", },
		{
				id                      = "RegisterConvoy",
				convoyId        =
				{
						GameObject.GetGameObjectId( "TppVehicle2", TARGET_VEHICLE_06 ),
						GameObject.GetGameObjectId( "TppVehicle2", TARGET_VEHICLE_07 ),
				},
		} )
		
		s10054_enemy.areaOut03_GO()	
		this.common_movingCourseCheck()	
		
		TppMission.UpdateObjective{
			radio = { radioGroups = "f1000_rtrg3290", },
			
		
			objectives = { "FIXED_VEHICLE_06","FIXED_VEHICLE_07", }
		}
	else
		Fox.Log("TargetVehicle_06 or 07 is WRONG VALUE ... CHECK !!")
	end
end

this.bulletTruck_GO = function()
	
	local truckDriverId			= GameObject.GetGameObjectId("TppSoldier2", BULLET_TRUCK_DRIVER_01 )
	local truckVehicleId		= GameObject.GetGameObjectId("TppVehicle2", BULLET_TRUCK_01 )
	local command_truckVehicle 	= { id="SetRelativeVehicle", targetId = truckVehicleId	, rideFromBeginning = true }

	if svars.isBulletTruck == 0	then
		Fox.Log("bulletTruck_GO")
		
		svars.isBulletTruck = 1
		
		GameObject.SendCommand( { type="TppVehicle2", },{ id = "Respawn", name = BULLET_TRUCK_01 , } )
		GameObject.SendCommand( GameObject.GetGameObjectId( BULLET_TRUCK_DRIVER_01 ) , { id="SetEnabled", enabled=true } )
		
		GameObject.SendCommand( truckDriverId	, command_truckVehicle )
		
		TppPickable.PutOn( "bulletTruck_WP" , GameObject.GetGameObjectId( BULLET_TRUCK_01 ) , 0 )
		
		s10054_enemy.bulletTruck_GO()
		
		s10054_radio.bulletTruck()
	elseif svars.isBulletTruck == 1	then
		Fox.Log("BulletTruck Now Moving ...")
	elseif svars.isBulletTruck == 2	or svars.isBulletTruck == 3 then
		Fox.Log("BulletTruck Clear or areaOut")
	else
		Fox.Log("svars.isBulletTruck is WRONG VALUE ... CHECK !!")
	end
end

this.vehicle_GO = function()
	if svars.isHostageVehicle == 0	then
		local vehicleDriverId_A		= GameObject.GetGameObjectId("TppSoldier2", VEHICLE_DRIVER_01 )
		local vehicleDriverId_B		= GameObject.GetGameObjectId("TppSoldier2", VEHICLE_DRIVER_02 )
		local carryVehicleId	= GameObject.GetGameObjectId("TppVehicle2", "veh_s10054_0006" )	
		local carryHostageId	= GameObject.GetGameObjectId("TppHostage2", "hos_s10054_0001" )	
		Fox.Log("vehicle_GO")
		
		svars.isHostageVehicle = 1
		
		GameObject.SendCommand( { type="TppVehicle2", },{ id = "Respawn", name = VEHICLE_01 , } )
		GameObject.SendCommand( GameObject.GetGameObjectId( VEHICLE_DRIVER_01 ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( VEHICLE_DRIVER_02 ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "hos_s10054_0001" ) , { id="SetEnabled", enabled=true } )
		
		local command_vehicleVehicle 	= { id="SetRelativeVehicle", targetId = carryVehicleId	, rideFromBeginning = true }
		GameObject.SendCommand( vehicleDriverId_A	, command_vehicleVehicle )
		GameObject.SendCommand( vehicleDriverId_B	, command_vehicleVehicle )
		
		local rideVehicleHostageCommand = {
			id			=	"RideVehicle",
			vehicleId	=	carryVehicleId,
			off			=	false
		}
		GameObject.SendCommand( carryHostageId , rideVehicleHostageCommand )
		
		s10054_enemy.vehicle_GO()
		s10054_radio.hostageVehicle_start()
	elseif svars.isHostageVehicle == 1	then
		Fox.Log("HostageVehicle Now Moving ...")
	elseif svars.isHostageVehicle == 2	or svars.isHostageVehicle == 3 then
		Fox.Log("HostageVehicle Clear or areaOut")
	else
		Fox.Log("svars.isHostageVehicle is WRONG VALUE ... CHECK !!")
	end
end




function this.Messages()
	return
	StrCode32Table {
		GameObject = {
			{	
				msg = "PlacedIntoVehicle" ,
				func = function ( gameObjectId , vehicleType )
					
					if vehicleType == GameObject.GetGameObjectId( SUPPORT_HELI ) then
						if gameObjectId == GameObject.GetGameObjectId( BULLET_TRUCK_DRIVER_01 )	
						or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_01 )	or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_02 )	then	
							this.unTargetDriver_clear( gameObjectId )
						elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0005" ) then
							TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
							{ 
								{ name = "enqt1000_107027",		func = s10054_enemy.InterCall_movingHostage_02, },
							} )
							TppMarker.Disable("Marker_movingHostage_MNT")
						elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0000" ) then
							TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
							{ 
								{ name = "enqt1000_107032",		func = s10054_enemy.InterCall_movingHostage_03, },
							} )
							TppMarker.Disable("Marker_movingHostage_RVR")
						elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0002" ) then
							TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
							{ 
								{ name = "enqt1000_1i1210",		func = s10054_enemy.InterCall_movingHostage_04, },
							} )
							TppMarker.Disable("Marker_movingHostage_SND")
						else
							Fox.Log("No Setting Character !!")
						end
					else
						Fox.Log("No Setting vehicleType Vehicle !!")
					end
				end
			},
			{	
				msg = "Fulton" ,
				func = function ( gameObjectId )
					Fox.Log("Fulton SUCCESS!!")
					local sequence = TppSequence.GetCurrentSequenceName()
					if gameObjectId == GameObject.GetGameObjectId( BULLET_TRUCK_DRIVER_01 )	
						or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_01 )	or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_02 )	then	
						this.unTargetDriver_clear( gameObjectId )
					elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_01)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_02)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_03))
					or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_04)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_05)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_06))
					or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_07)) then
						svars.isReserveFlag_01 = true	
						
						if ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_01))		then
							svars.isTargetVehicle_01 = 2
							
							TppMarker.Disable( TARGET_VEHICLE_01 )
							TppMarker.Disable( "Marker_Target01_vague" )
						elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_02))	then
							svars.isTargetVehicle_02 = 2
							
							TppMarker.Disable( TARGET_VEHICLE_02 )
							TppMarker.Disable( "Marker_Target02_vague" )
						elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_03))	then
							svars.isTargetVehicle_03 = 2
							Player.RemoveSearchTarget( TARGET_VEHICLE_03 )
							TppMarker.Disable( TARGET_VEHICLE_03 )
						elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_04))	then
							svars.isTargetVehicle_04 = 2
							svars.isTarget04_D_route = true
							
							TppMarker.Disable( TARGET_VEHICLE_04 )
						elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_05))	then
							svars.isTargetVehicle_05 = 2
							svars.isTarget05_E_route = true
							
							TppMarker.Disable( TARGET_VEHICLE_05 )
						elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_06))	then
							svars.isTargetVehicle_06 = 2
							
							TppMarker.Disable( TARGET_VEHICLE_06 )
						elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_07))	then
							svars.isTargetVehicle_07 = 2
							
							TppMarker.Disable( TARGET_VEHICLE_07 )
						else
							Fox.Log("Not Target Vehicle")
						end
						this.common_movingCourseCheck()
						if ( sequence == "Seq_Game_MainGame" ) then
							svars.isTargrtCount_Clear = svars.isTargrtCount_Clear + 1
							Fox.Log("svars.isTargrtCount_Clear is "..svars.isTargrtCount_Clear.." !!")
							this.OptRadioControl_Setting()
							
							if svars.isTargrtCount_Clear == 1 or svars.isTargrtCount_Clear == 4 or svars.isTargrtCount_Clear >= TARGET_VEHICLE_COUNT	then
								s10054_radio.TargetFulton_succes_01()
							elseif svars.isTargrtCount_Clear == 2 or svars.isTargrtCount_Clear == 5	then
								s10054_radio.TargetFulton_succes_02()
							elseif svars.isTargrtCount_Clear == 3 or svars.isTargrtCount_Clear == 6	then
								s10054_radio.TargetFulton_succes_03()
							else
								Fox.Error("svars.isTargrtCount_Clear is WRONG VALUE ...")
							end
						else
							Fox.Log("Not MainGame Sequence ... Nothing Done !!")
						end
					elseif ( gameObjectId == GameObject.GetGameObjectId( BULLET_TRUCK_01 ))	then	
						svars.isBulletTruck = 2
						if svars.isReserveFlag_04 == false		then
							svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
							Fox.Log("svars.isNonTargetCount_areaOut is "..svars.isNonTargetCount_areaOut.." !!")
						else
						end
					elseif ( gameObjectId == GameObject.GetGameObjectId( VEHICLE_01 ))	then	
						if svars.isReserveFlag_CNT_01 >= 2 then
						else
							if svars.isHostageVehicle ~= 3 then
								svars.isHostageVehicle = 2
							else
							end
							svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
							Fox.Log("svars.isNonTargetCount_areaOut is "..svars.isNonTargetCount_areaOut.." !!")
						end
					else
						Fox.Log("No Setting Character !!")
					end
				end
			},
			{	
				msg = "FultonFailedEnd" ,
				func = function ( gameObjectId , locatorname , locatorNameUpper , failureType )
					Fox.Log("Fulton FAILDED ... ")
					local sequence = TppSequence.GetCurrentSequenceName()
					
					if gameObjectId == GameObject.GetGameObjectId( BULLET_TRUCK_DRIVER_01 )	
						or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_01 )	or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_02 )	then	
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE	then
							this.unTargetDriver_clear( gameObjectId )
						else
							Fox.Log("failureType ~= FULTON_FAILED_TYPE_ON_FINISHED_RISE ... Nothing Done !!")
						end
					elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_01)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_02)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_03))
					or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_04)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_05)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_06))
					or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_07)) then
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE	then	
							svars.isTargrtCount_Clear = svars.isTargrtCount_Clear + 1
							Fox.Log("svars.isTargrtCount_Clear is "..svars.isTargrtCount_Clear.." !!")
							this.OptRadioControl_Setting()
							
							if ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_01))		then
								svars.isTargetVehicle_01 = 2
								
								TppMarker.Disable( TARGET_VEHICLE_01 )
								TppMarker.Disable( "Marker_Target01_vague" )
							elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_02))	then
								svars.isTargetVehicle_02 = 2
								
								TppMarker.Disable( TARGET_VEHICLE_02 )
								TppMarker.Disable( "Marker_Target02_vague" )
							elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_03))	then
								svars.isTargetVehicle_03 = 2
								Player.RemoveSearchTarget( TARGET_VEHICLE_03 )
								TppMarker.Disable( TARGET_VEHICLE_03 )
							elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_04))	then
								svars.isTargetVehicle_04 = 2
								svars.isTarget04_D_route = true
								
								TppMarker.Disable( TARGET_VEHICLE_04 )
							elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_05))	then
								svars.isTargetVehicle_05 = 2
								svars.isTarget05_E_route = true
								
								TppMarker.Disable( TARGET_VEHICLE_05 )
							elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_06))	then
								svars.isTargetVehicle_06 = 2
								
								TppMarker.Disable( TARGET_VEHICLE_06 )
							elseif ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_07))	then
								svars.isTargetVehicle_07 = 2
								
								TppMarker.Disable( TARGET_VEHICLE_07 )
							else
								Fox.Log("Not Target Vehicle")
							end
							this.common_movingCourseCheck()
							if ( sequence == "Seq_Game_MainGame" ) then
								if svars.isTargrtCount_Clear == 1 or svars.isTargrtCount_Clear == 3 or svars.isTargrtCount_Clear == 5	or svars.isTargrtCount_Clear >= TARGET_VEHICLE_COUNT	then
									s10054_radio.TargetFulton_failed_01()
								elseif svars.isTargrtCount_Clear == 2 or svars.isTargrtCount_Clear == 4 or svars.isTargrtCount_Clear == 6	then
									s10054_radio.TargetFulton_failed_02()
								else
								end
							else
								Fox.Log("Not MainGame Sequence ... Nothing Done !!")
							end
						else
							Fox.Log("failureType ~= FULTON_FAILED_TYPE_ON_FINISHED_RISE ... Nothing Done !!")
						end
					elseif ( gameObjectId == GameObject.GetGameObjectId( BULLET_TRUCK_01 ))	then	
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE	then	
							svars.isBulletTruck = 2
							if svars.isReserveFlag_04 == false then
								svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
								Fox.Log("svars.isNonTargetCount_areaOut is "..svars.isNonTargetCount_areaOut.." !!")
							else
							end
						else
							Fox.Log("failureType ~= FULTON_FAILED_TYPE_ON_FINISHED_RISE ... Nothing Done !!")
						end
					elseif ( gameObjectId == GameObject.GetGameObjectId( VEHICLE_01 ))	then	
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE	then	
							if svars.isReserveFlag_CNT_01 >= 2 then
							else
								if svars.isHostageVehicle ~= 3 then
									svars.isHostageVehicle = 2
								else
								end
								svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
								Fox.Log("svars.isNonTargetCount_areaOut is "..svars.isNonTargetCount_areaOut.." !!")
							end
						else
							Fox.Log("failureType ~= FULTON_FAILED_TYPE_ON_FINISHED_RISE ... Nothing Done !!")
						end
					else
						Fox.Log("No Setting Character !!")
					end
				end
			},
			{	
				msg = "Dying",
				func = function( gameObjectId )
					if gameObjectId == GameObject.GetGameObjectId( BULLET_TRUCK_DRIVER_01 )	
						or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_01 )	or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_02 )	then	
						this.unTargetDriver_clear( gameObjectId )
					else
					end
				end
			},
			{	
				msg = "Dead",
				func = function( gameObjectId , attackerId , phase )
					if gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0005" )	then
						s10054_radio.ChangeIntelRadio_HostageDead_MNT()
						
						if attackerId ~= 0 then
							
							svars.isDeadBySearchEnemy = true
							
							TppEnemy.SetSneakRoute( "sol_search_0000" , "rts_search0000_01" )
							TppEnemy.SetCautionRoute( "sol_search_0000" , "rts_search0000_00" )
							TppEnemy.SetSneakRoute( "sol_search_0001" , "rts_search0001_01" )
							TppEnemy.SetCautionRoute( "sol_search_0001" , "rts_search0001_00" )
							TppEnemy.SetSneakRoute( "sol_search_0002" , "rts_search0002_01" )
							TppEnemy.SetCautionRoute( "sol_search_0002" , "rts_search0002_00" )
							TppEnemy.SetSneakRoute( "sol_search_0003" , "rts_search0003_01" )
							TppEnemy.SetCautionRoute( "sol_search_0003" , "rts_search0003_00" )
						else
							Fox.Log("attacker is not searchEnemy ... Nothing Done !!")
						end
						TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
						{ 
							{ name = "enqt1000_107027",		func = s10054_enemy.InterCall_movingHostage_02, },
						} )
						TppMarker.Disable("Marker_movingHostage_MNT")
					elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0000" )	then
						s10054_radio.ChangeIntelRadio_HostageDead_RIV()
						TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
						{ 
							{ name = "enqt1000_107032",		func = s10054_enemy.InterCall_movingHostage_03, },
						} )
						TppMarker.Disable("Marker_movingHostage_RVR")
					elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0002" )	then
						s10054_radio.ChangeIntelRadio_HostageDead_SAN()
						TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
						{ 
							{ name = "enqt1000_1i1210",		func = s10054_enemy.InterCall_movingHostage_04, },
						} )
						TppMarker.Disable("Marker_movingHostage_SND")
					elseif gameObjectId == GameObject.GetGameObjectId( BULLET_TRUCK_DRIVER_01 )	
						or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_01 )	or gameObjectId == GameObject.GetGameObjectId( VEHICLE_DRIVER_02 )	then	
						this.unTargetDriver_clear( gameObjectId )
					else
					end
				end
			},
			{ 
				msg = "VehicleBroken",
				func = function( gameObjectId , state )
					Fox.Log("gameObjectId is"..gameObjectId)
					local sequence = TppSequence.GetCurrentSequenceName()
					
					if ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_01)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_02)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_03))
					or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_04)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_05)) or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_06))
					or ( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_07)) then
						Fox.Log("MSG VehicleBroken !!")
						if state == StrCode32("End")	then
							Fox.Log("VehicleBroken State == end")
							
							if		( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_01))		then
								svars.isTargetVehicle_01 = 2
							elseif	( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_02))		then
								svars.isTargetVehicle_02 = 2
							elseif	( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_03))		then
								svars.isTargetVehicle_03 = 2
								Player.RemoveSearchTarget( TARGET_VEHICLE_03 )
							elseif	( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_04))		then
								svars.isTargetVehicle_04 = 2
								svars.isTarget04_D_route = true
							elseif	( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_05))		then
								svars.isTargetVehicle_05 = 2
								svars.isTarget05_E_route = true
							elseif	( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_06))		then
								svars.isTargetVehicle_06 = 2
							elseif	( gameObjectId == GameObject.GetGameObjectId(TARGET_VEHICLE_07))		then
								svars.isTargetVehicle_07 = 2
							else
								Fox.Log("gameObjectId is not TargetVehicle ... Must Check !!")
							end
							this.common_movingCourseCheck()
							if ( sequence == "Seq_Game_MainGame" ) then
								svars.isTargrtCount_Clear = svars.isTargrtCount_Clear + 1
								Fox.Log("svars.isTargrtCount_Clear is "..svars.isTargrtCount_Clear.." !!")
								this.OptRadioControl_Setting()
								
								if		( svars.isTargrtCount_Clear == 1 )	then
									s10054_radio.TargetBroken_CNT_1()
								elseif	( svars.isTargrtCount_Clear == 2 )	then
									s10054_radio.TargetBroken_CNT_2()
								elseif	( svars.isTargrtCount_Clear == 3 )	then
									s10054_radio.TargetBroken_CNT_3()
								elseif	( svars.isTargrtCount_Clear == 4 )	then
									s10054_radio.TargetBroken_CNT_4()
								elseif	( svars.isTargrtCount_Clear == 5 )	then
									s10054_radio.TargetBroken_CNT_5()
								elseif	( svars.isTargrtCount_Clear == 6 )	then
									s10054_radio.TargetBroken_CNT_6()
								elseif	( svars.isTargrtCount_Clear >= 7 )	then
									Fox.Log("Radio Nothing Done !!")
								else
									Fox.Log("isTargrtCount_Clear is WRONG VALUE !!")
								end
							else
								Fox.Log("Not MainGame Sequence ... Nothing Done !!")
							end
						else
							Fox.Log("VehicleBroken Arg is WRONG VALUE !!")
						end
					elseif ( gameObjectId == GameObject.GetGameObjectId( BULLET_TRUCK_01 ))	then	
						if state == StrCode32("End")	then
							Fox.Log("VehicleBroken State == end")
							svars.isBulletTruck = 2
							if svars.isReserveFlag_04 == false		then
								svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
								Fox.Log("svars.isNonTargetCount_areaOut is "..svars.isNonTargetCount_areaOut.." !!")
							else
								Fox.Log("Truck Driver Clear ... svars.isNonTargetCount_areaOut is not Count Up !!")
							end
						else
							Fox.Log("VehicleBroken Arg is WRONG VALUE !!")
						end
					elseif ( gameObjectId == GameObject.GetGameObjectId( VEHICLE_01 ))	then	
						if state == StrCode32("End")	then
							Fox.Log("VehicleBroken State == end")
							svars.isHostageVehicle = 2
							if svars.isReserveFlag_CNT_01 ~= 2	then
								svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
								Fox.Log("svars.isNonTargetCount_areaOut is "..svars.isNonTargetCount_areaOut.." !!")
							else
								Fox.Log("Vehicle Driver Clear ... svars.isNonTargetCount_areaOut is not Count Up !!")
							end
						else
							Fox.Log("VehicleBroken Arg is WRONG VALUE !!")
						end
					elseif gameObjectId == GameObject.GetGameObjectId(BONUS_TNK_01) or gameObjectId == GameObject.GetGameObjectId(BONUS_TNK_02) or gameObjectId == GameObject.GetGameObjectId(BONUS_TNK_03) then
						if state == StrCode32("End")	then
							Fox.Log("VehicleBroken State == end")
							svars.isBonusTargetClear_CNT = svars.isBonusTargetClear_CNT + 1
							this.BGM_Setting()
							this.OptRadioControl_Setting()
							s10054_radio.bonus_Tank_Clear()
						else
							Fox.Log("BONUS TARGET MSG:VehicleBroken STATE:??? ... Must Check !!")
						end
					else
						Fox.Log("Not Target Vehicle")
					end
				end
			},
			{ 
				msg = "RoutePoint2" ,
				func = function ( gameObjectId , routeID , nodeNo , msgID )
					local sequence = TppSequence.GetCurrentSequenceName()
					if msgID == Fox.StrCode32( "target_areaOut" ) then
						
						
						if gameObjectId == GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_01 )		then
							Fox.Log("TARGET_VEHICLE_DRIVER_01 & TARGET_VEHICLE_01 Disable !!")
							
							svars.isTargetVehicle_01 = 2
							
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_01 ) , { id="SetEnabled", enabled=false } )
							GameObject.SendCommand( { type="TppVehicle2", },{	id = "Despawn",	name = TARGET_VEHICLE_01, } )
						elseif gameObjectId == GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_02 )	then
							Fox.Log("TARGET_VEHICLE_DRIVER_02  & TARGET_VEHICLE_02 Disable !!")
							
							svars.isTargetVehicle_02 = 2
							
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_02 ) , { id="SetEnabled", enabled=false } )
							GameObject.SendCommand( { type="TppVehicle2", },{	id = "Despawn",	name = TARGET_VEHICLE_02, } )
						elseif gameObjectId == GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_03 )	then
							Fox.Log("TARGET_VEHICLE_DRIVER_03  & TARGET_VEHICLE_03 Disable !!")
							
							svars.isTargetVehicle_03 = 2
							
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_03 ) , { id="SetEnabled", enabled=false } )
							GameObject.SendCommand( { type="TppVehicle2", },{	id = "Despawn",	name = TARGET_VEHICLE_03, } )
						elseif gameObjectId == GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_04 )	then
							Fox.Log("TARGET_VEHICLE_DRIVER_04  & TARGET_VEHICLE_04 Disable !!")
							
							svars.isTargetVehicle_04 = 2
							
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_04 ) , { id="SetEnabled", enabled=false } )
							GameObject.SendCommand( { type="TppVehicle2", },{	id = "Despawn",	name = TARGET_VEHICLE_04, } )
						elseif gameObjectId == GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_05 )	then
							Fox.Log("TARGET_VEHICLE_DRIVER_05  & TARGET_VEHICLE_05 Disable !!")
							
							svars.isTargetVehicle_05 = 2
							
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_05 ) , { id="SetEnabled", enabled=false } )
							GameObject.SendCommand( { type="TppVehicle2", },{	id = "Despawn",	name = TARGET_VEHICLE_05, } )
						elseif gameObjectId == GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_06 )	then
							Fox.Log("TARGET_VEHICLE_DRIVER_06  & TARGET_VEHICLE_06 Disable !!")
							
							svars.isTargetVehicle_06 = 2
							
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_06 ) , { id="SetEnabled", enabled=false } )
							GameObject.SendCommand( { type="TppVehicle2", },{	id = "Despawn",	name = TARGET_VEHICLE_06, } )
						elseif gameObjectId == GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_07 )	then
							Fox.Log("TARGET_VEHICLE_DRIVER_07  & TARGET_VEHICLE_07 Disable !!")
							
							svars.isTargetVehicle_07 = 2
							
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VEHICLE_DRIVER_07 ) , { id="SetEnabled", enabled=false } )
							GameObject.SendCommand( { type="TppVehicle2", },{	id = "Despawn",	name = TARGET_VEHICLE_07, } )
						else
							Fox.Log("gameObjectId is not TARGET_VEHICLE_DRIVER !!")
						end
						
						this.common_movingCourseCheck()
						
						if ( sequence == "Seq_Game_MainGame" ) then
							
							TppSoundDaemon.PostEvent( 'sfx_s_esc_alert' )
							
							svars.isTargetCount_areaOut = svars.isTargetCount_areaOut + 1
							Fox.Log("svars.isTargetCount_areaOut is "..svars.isTargetCount_areaOut.." !!")
							
							if svars.isTargetCount_areaOut == 1	or svars.isTargetCount_areaOut == 3 or svars.isTargetCount_areaOut == 5 or svars.isTargetCount_areaOut == 7 then
								s10054_radio.targetVehicle_areaOut_01()
							else
								s10054_radio.targetVehicle_areaOut_02()
							end
						else
							Fox.Log("Not MainGame Sequence ... Nothing Done !!")
						end
					elseif msgID == Fox.StrCode32( "target04_D_route_finish" ) then
						svars.isTarget04_D_route = true
						TppUiCommand.InitEnemyRoutePoints( 3 )
					elseif msgID == Fox.StrCode32( "target05_E_route_finish" ) then
						svars.isTarget05_E_route = true
						TppUiCommand.InitEnemyRoutePoints( 4 )
					elseif msgID == Fox.StrCode32( "bulletTruck_areaOut" ) then
						Fox.Log("BULLET_TRUCK_DRIVER_01 & BULLET_TRUCK_01 Disable !!")
						local checkVehicle = GameObject.GetGameObjectId( "TppVehicle2", BULLET_TRUCK_01 )
						local riderIdArray = GameObject.SendCommand( checkVehicle , { id= "GetRiderId", } )
						Fox.Log(tostring(riderIdArray))
						local seatCount = #riderIdArray
						
						for seatIndex,riderId in ipairs( riderIdArray ) do
							if ( riderId ~= GameObject.NULL_ID ) then	
								Fox.Log("on vehicle rider is = "..riderId.." !!")
								GameObject.SendCommand( riderId , { id="SetEnabled", enabled=false } )
							else
								Fox.Log("empty Seat !!")
								break	
							end						
						end
						GameObject.SendCommand( { type="TppVehicle2", },{	id = "Despawn",	name = BULLET_TRUCK_01, } )
						svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
						Fox.Log("svars.isNonTargetCount_areaOut is "..svars.isNonTargetCount_areaOut.." !!")
					elseif msgID == Fox.StrCode32( "vehicle_areaOut" ) then
						Fox.Log("VEHICLE_DRIVER_01 & 02 ( & Hostage ) ... VEHICLE_01 Disable !!")
						local checkVehicle = GameObject.GetGameObjectId( "TppVehicle2", VEHICLE_01 )
						local riderIdArray = GameObject.SendCommand( checkVehicle , { id= "GetRiderId", } )
						Fox.Log(tostring(riderIdArray))
						local seatCount = #riderIdArray
						
						for seatIndex,riderId in ipairs( riderIdArray ) do
							if ( riderId ~= GameObject.NULL_ID ) then	
								Fox.Log("on vehicle rider is = "..riderId.." !!")
								GameObject.SendCommand( riderId , { id="SetEnabled", enabled=false } )
							else
								Fox.Log("empty Seat !!")
								break	
							end
						end
						GameObject.SendCommand( { type="TppVehicle2", },{	id = "Despawn",	name = VEHICLE_01, } )	
						svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut + 1
						Fox.Log("svars.isNonTargetCount_areaOut is "..svars.isNonTargetCount_areaOut.." !!")
					elseif msgID == Fox.StrCode32( "searchEnemy_RouteMSG" )	then
						if svars.isDeadBySearchEnemy == true	then
							TppEnemy.SetSneakRoute( "sol_search_0000" , "rts_search0000_01" )
							TppEnemy.SetCautionRoute( "sol_search_0000" , "rts_search0000_00" )
							TppEnemy.SetSneakRoute( "sol_search_0001" , "rts_search0001_01" )
							TppEnemy.SetCautionRoute( "sol_search_0001" , "rts_search0001_00" )
							TppEnemy.SetSneakRoute( "sol_search_0002" , "rts_search0002_01" )
							TppEnemy.SetCautionRoute( "sol_search_0002" , "rts_search0002_00" )
							TppEnemy.SetSneakRoute( "sol_search_0003" , "rts_search0003_01" )
							TppEnemy.SetCautionRoute( "sol_search_0003" , "rts_search0003_00" )
						else
							TppEnemy.SetSneakRoute( "sol_search_0000" , "rts_search0000_00" )
							TppEnemy.SetCautionRoute( "sol_search_0000" , "rts_search0000_00" )
							TppEnemy.SetSneakRoute( "sol_search_0001" , "rts_search0001_00" )
							TppEnemy.SetCautionRoute( "sol_search_0001" , "rts_search0001_00" )
							TppEnemy.SetSneakRoute( "sol_search_0002" , "rts_search0002_00" )
							TppEnemy.SetCautionRoute( "sol_search_0002" , "rts_search0002_00" )
							TppEnemy.SetSneakRoute( "sol_search_0003" , "rts_search0003_00" )
							TppEnemy.SetCautionRoute( "sol_search_0003" , "rts_search0003_00" )
						end
					elseif msgID == Fox.StrCode32( "hosRiver_routeMSG" ) then
						local hosRiverId			= GameObject.GetGameObjectId( "hos_s10054_0000" )
						local hosRiver_routeClear	= { id = "SetSneakRoute", route = "",}
						GameObject.SendCommand( hosRiverId, hosRiver_routeClear )
					elseif msgID == Fox.StrCode32( "hosSand_routeMSG" ) then
						local hosSandId			= GameObject.GetGameObjectId( "hos_s10054_0002" )
						local hosSand_routeClear	= { id = "SetSneakRoute", route = "",}
						GameObject.SendCommand( hosSandId, hosSand_routeClear )
					elseif msgID == Fox.StrCode32( "hosCliff_routeMSG" ) then
						local hosCliffId			= GameObject.GetGameObjectId( "hos_s10054_0005" )
						local hosCliff_routeClear	= { id = "SetSneakRoute", route = "",}
						GameObject.SendCommand( hosCliffId, hosCliff_routeClear )
					elseif msgID == Fox.StrCode32( "bonus01_railChange_to01" ) then
						s10054_enemy.bonusTarget01_railChange_to01()
					elseif msgID == Fox.StrCode32( "bonus01_railChange_to02" ) then
						s10054_enemy.bonusTarget01_railChange_to02()
					elseif msgID == Fox.StrCode32( "bonus02_railChange_to01" ) then
						s10054_enemy.bonusTarget02_railChange_to01()
					elseif msgID == Fox.StrCode32( "bonus02_railChange_to02" ) then
						s10054_enemy.bonusTarget02_railChange_to02()
					elseif msgID == Fox.StrCode32( "bonus03_railChange_to01" ) then
						s10054_enemy.bonusTarget03_railChange_to01()
					elseif msgID == Fox.StrCode32( "bonus03_railChange_to02" ) then
						s10054_enemy.bonusTarget03_railChange_to02()
					else
						Fox.Log("Another Route Message ... ")
					end
				end
			},
			{ 
					msg = "MonologueEnd",
					func = function ( gameObjectId , label )
						local abductHostageId		= GameObject.GetGameObjectId( "hos_s10054_0001" )			
						local escapeHostageId		= GameObject.GetGameObjectId( "hos_s10054_0005" )			
						local GetStateCommand		= { id = "GetStatus", }
						local state_abductHostage	= GameObject.SendCommand( abductHostageId, GetStateCommand )
						local state_escapeHostage	= GameObject.SendCommand( escapeHostageId, GetStateCommand )
						local abductHostage_monologue_11	= { id="CallMonologue", label = "speech054_carry011", carry = true }
						local abductHostage_monologue_12	= { id="CallMonologue", label = "speech054_carry012", carry = true }
						local abductHostage_monologue_13	= { id="CallMonologue", label = "speech054_carry013", carry = true }
						local abductHostage_monologue_14	= { id="CallMonologue", label = "speech054_carry014", carry = true }
						local abductHostage_monologue_15	= { id="CallMonologue", label = "speech054_carry015", carry = true }
						local abductHostage_monologue_16	= { id="CallMonologue", label = "speech054_carry016", carry = true }
						local abductHostage_monologue_17	= { id="CallMonologue", label = "speech054_carry017", carry = true }
						local abductHostage_monologue_18	= { id="CallMonologue", label = "speech054_carry018", carry = true }
				
						local escapeHostage_monologue_22	= { id="CallMonologue", label = "speech054_carry022", carry = true }
						local escapeHostage_monologue_23	= { id="CallMonologue", label = "speech054_carry023", carry = true }
						local escapeHostage_monologue_24	= { id="CallMonologue", label = "speech054_carry024", carry = true }
						local escapeHostage_monologue_25	= { id="CallMonologue", label = "speech054_carry025", carry = true }
						local escapeHostage_monologue_26	= { id="CallMonologue", label = "speech054_carry026", carry = true }
						local escapeHostage_monologue_27	= { id="CallMonologue", label = "speech054_carry027", carry = true }
						local escapeHostage_monologue_28	= { id="CallMonologue", label = "speech054_carry028", carry = true }
						
						if gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0001" )	and state_abductHostage == TppGameObject.NPC_STATE_CARRIED then
							if		label == Fox.StrCode32("speech054_carry010")	then
								GameObject.SendCommand( abductHostageId, abductHostage_monologue_11 )
							elseif	label == Fox.StrCode32("speech054_carry011")	then
								if svars.isTarget03Discovery == false and svars.isTargetVehicle_03 ~= 2	then
									GameObject.SendCommand( abductHostageId, abductHostage_monologue_12 )
								else
									Fox.Log("isTarget03Discovery == true ... MonologueEnd")
								end
							elseif	label == Fox.StrCode32("speech054_carry012")	then
								GameObject.SendCommand( abductHostageId, abductHostage_monologue_13 )
							elseif	label == Fox.StrCode32("speech054_carry013")	then
								svars.isTarget03Discovery = true
								TppMission.UpdateObjective{
									objectives = { "FIXED_VEHICLE_03",},
								}
								GameObject.SendCommand( abductHostageId, abductHostage_monologue_14 )
							









							else
							end
						
						elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0005" )	and state_escapeHostage == TppGameObject.NPC_STATE_CARRIED then
							if		label == Fox.StrCode32("speech054_carry021")	then
								GameObject.SendCommand( escapeHostageId, escapeHostage_monologue_22 )
							elseif	label == Fox.StrCode32("speech054_carry022")	then
								GameObject.SendCommand( escapeHostageId, escapeHostage_monologue_23 )
							elseif	label == Fox.StrCode32("speech054_carry023")	then
								GameObject.SendCommand( escapeHostageId, escapeHostage_monologue_24 )
							elseif	label == Fox.StrCode32("speech054_carry024")	then
								GameObject.SendCommand( escapeHostageId, escapeHostage_monologue_25 )
							elseif	label == Fox.StrCode32("speech054_carry025")	then
								GameObject.SendCommand( escapeHostageId, escapeHostage_monologue_26 )
							elseif	label == Fox.StrCode32("speech054_carry026")	then
								GameObject.SendCommand( escapeHostageId, escapeHostage_monologue_27 )
							elseif	label == Fox.StrCode32("speech054_carry027")	then
								GameObject.SendCommand( escapeHostageId, escapeHostage_monologue_28 )
							else
							end
						else
							Fox.Log("No Setting Carry character ... HYUUUUUUUU !!!")
						end
					end
				},
				{ 
					msg = "Carried",
					func = function ( gameObjectId , carriedState )
						local abductHostageId			= GameObject.GetGameObjectId( "hos_s10054_0001" )			
						local escapeHostageId			= GameObject.GetGameObjectId( "hos_s10054_0005" )			
						local abductHostage_monologue	= { id="CallMonologue", label = "speech054_carry010", carry = true }
						local escapeHostage_monologue	= { id="CallMonologue", label = "speech054_carry021", carry = true }
						
						if gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0001" )	then
							if 		carriedState == 2 and svars.isMonologue_abductHostages == false	then		
								svars.isMonologue_abductHostages = true
								GameObject.SendCommand( abductHostageId, abductHostage_monologue )
							elseif	carriedState == 0	then		
								Fox.Log("Carry START !!")
							elseif	carriedState == 1	then		
								Fox.Log("Carry END !!")
							else									
								Fox.Log("Carried MSG ... NOT State ... START or END")
							end
						
						elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10054_0005" )	then
							if 		carriedState == 2 and svars.isMonologue_escapeHostages == false	then		
								svars.isMonologue_escapeHostages = true
								GameObject.SendCommand( escapeHostageId, escapeHostage_monologue )
							elseif	carriedState == 0	then		
								Fox.Log("Carry START !!")
							elseif	carriedState == 1	then		
								Fox.Log("Carry END !!")
							else									
								Fox.Log("Carried MSG ... NOT State ... START or END")
							end
						else
							Fox.Log("No Setting Carry character ... HYUUUUUUUU !!!")
						end
					end
				},
		},
		Marker = {
			{	
				msg = "ChangeToEnable", sender = "hos_s10054_0005",
				func = function()
					TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
					{ 
						{ name = "enqt1000_107027",		func = s10054_enemy.InterCall_movingHostage_02, },
					} )
					TppMarker.Disable("Marker_movingHostage_MNT")
				end
			},
			{	
				msg = "ChangeToEnable", sender = "hos_s10054_0000",
				func = function()
					TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
					{ 
						{ name = "enqt1000_107032",		func = s10054_enemy.InterCall_movingHostage_03, },
					} )
					TppMarker.Disable("Marker_movingHostage_RVR")
				end
			},
			{	
				msg = "ChangeToEnable", sender = "hos_s10054_0002",
				func = function()
					TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("s10054_searchEnemy_cp"),
					{ 
						{ name = "enqt1000_1i1210",		func = s10054_enemy.InterCall_movingHostage_04, },
					} )
					TppMarker.Disable("Marker_movingHostage_SND")
				end
			},
		},
		Radio = {
			{	
				msg = "Finish",	sender = "f1000_rtrg3390",
				func = function()
					this.targetRecover_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg3400",
				func = function()
					this.targetRecover_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg1562",
				func = function()
					this.targetRecover_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg3410",
				func = function()
					this.targetDestory_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg3420",
				func = function()
					this.targetDestory_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg3330",
				func = function()
					this.targetDestory_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg3340",
				func = function()
					this.targetDestory_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg3350",
				func = function()
					this.targetDestory_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg3360",
				func = function()
					this.targetDestory_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg3370",
				func = function()
					this.targetDestory_commonAnnounceLog()
				end
			},
			{	
				msg = "Finish",	sender = "f1000_rtrg3380",
				func = function()
					this.targetDestory_commonAnnounceLog()
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
	}
end



sequences.Seq_Game_MainGame = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Radio = {
				{	
					msg = "Finish",	sender = "f1000_rtrg3300",
					func = function()
						TppMarker.SetQuestMarker( BULLET_TRUCK_01 )
						TppMission.UpdateObjective{ objectives = { "FIXED_TRUCK_01", } }
						s10054_radio.occelotAdvice()
					end
				},
				{	
					msg = "Finish",	sender = "f1000_rtrg3460",
					func = function()
						TppMarker.SetQuestMarker( "hos_s10054_0001" )
						TppMission.UpdateObjective{ objectives = { "FIXED_HOSTAGE_VEHICLE", } }
					end
				},
				{	
					msg = "Finish",	sender = "s0054_rtrg2100",
					func = function()
						this.targetClear_commonAnnounceLog()
					end
				},
				{	
					msg = "Finish",	sender = "f1000_esrg2040",
					func = function()
						s10054_radio.ChangeIntelRadio_gunMount2nd()
					end
				},
				{	
					msg = "Finish",	sender = "f1000_esrg2050",
					func = function()
						s10054_radio.ChangeIntelRadio_mortar2nd()
					end
				},
				{	
					msg = "Finish",	sender = "s0054_rtrg2140",
					func = function()
						TppMission.UpdateObjective{
					
							objectives = { "FIXED_VEHICLE_03",},
						}
					end
				},
				{	
					msg = "Finish",	sender = "s0054_rtrg2010",
					func = function()
						TimerStart( "timer_openingRadioAfter", 3 )		
						this.common_movingCourseCheck()					
					end
				},
				{	
					msg = "Finish",	sender = "s0054_rtrg2130",
					func = function()
						this.timerStart()
					end
				},
				{	
					msg = "Finish",	sender = "s0054_rtrg2060",
					func = function()
						Fox.Log("isTargrtCount_Clear is = "..svars.isTargrtCount_Clear.." !!")
						if svars.isTargrtCount_Clear == 0	then		
							s10054_radio.noTargetClear_EmergencyTime()
						elseif svars.isTargrtCount_Clear >= 1 and svars.isTargrtCount_Clear < 5	then	
							s10054_radio.TargetClear_EmergencyTime_01()
						elseif svars.isTargrtCount_Clear >= 5 and svars.isTargrtCount_Clear <= TARGET_VEHICLE_COUNT	then	
							s10054_radio.TargetClear_EmergencyTime_02()
						else
							Fox.Log("ERROR ... isTargrtCount_Clear COUNT !!")
						end
					end
				},
			},
			Trap = {
				{
					msg = "Enter", sender = "drpHeliTrap",
					func = function()
						svars.isDrpHeliTrap_inPC = true
						if ( TppMission.IsStartFromHelispace() == true ) then
							Fox.Log("### Player Start Game From Helicopter ###")
							if		svars.isTelopEnd == true		then
								this.timerStart()
							else
								Fox.Log("Nothing Done!! ... telopEnd is TimeCNT START ")
							end
						elseif ( TppMission.IsStartFromFreePlay() == true ) then
							Fox.Log("### Player Start Game From FreePlay ... nothing Done!! ###")
						else
							Fox.Log("### Player Start Game From ??? Must Check !! ... nothing Done !! ###")
						end
					end
				},
			},
			Timer = {
				{ msg = "Finish",	sender = "timer_openingRadioAfter",	
					func = function()
						s10054_radio.confirmationTarget()
					end
				},
				{ msg = "Finish",	sender = "timer_PasstimeCheck",	
					func = function()
						Fox.Log("TIMER PASS TIME CHECK !!")
						Fox.Log("isTargrtCount_Clear is "..svars.isTargrtCount_Clear.." !!")
						Fox.Log("isTargetCount_areaOut is "..svars.isTargetCount_areaOut.." !!")
						Fox.Log("isNonTargetCount_areaOut is "..svars.isNonTargetCount_areaOut.." !!")
						local ActiveVhicle_CNT = 0	
						local isPlaying = TppRadioCommand.IsPlayingRadio()
						
						if	svars.isNonTargetCount_areaOut >= 2		then
							
							if svars.isBulletTruck == 0 or svars.isBulletTruck == 1 then
								svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut - 1
							end
						end
						
						if	svars.isNonTargetCount_areaOut >= 2		then
							
							if svars.isHostageVehicle == 0 or svars.isHostageVehicle == 1 then
								svars.isNonTargetCount_areaOut = svars.isNonTargetCount_areaOut - 1
							end
						end
						
						if isPlaying == false	then
							
							if svars.isTargrtCount_Clear + svars.isTargetCount_areaOut >= 7	then
									TppSequence.SetNextSequence("Seq_Game_Escape")
							else
								Fox.Log("NextVehicle_ON CHECK !!")
								
								
								if svars.isTargetVehicle_01 ~= 2	then
									ActiveVhicle_CNT = ActiveVhicle_CNT + 1
								else
									Fox.Log("Nothing Done !!")
								end
								
								if svars.isTargetVehicle_02 ~= 2	then
									ActiveVhicle_CNT = ActiveVhicle_CNT + 1
								else
									Fox.Log("Nothing Done !!")
								end
								
								if svars.isTargetVehicle_03 ~= 2	then
									ActiveVhicle_CNT = ActiveVhicle_CNT + 1
								else
									Fox.Log("Nothing Done !!")
								end
								
								if svars.isTargetVehicle_04 == 1	then
									ActiveVhicle_CNT = ActiveVhicle_CNT + 1
								else
									Fox.Log("Nothing Done !!")
								end
								
								if svars.isTargetVehicle_05 == 1	then
									ActiveVhicle_CNT = ActiveVhicle_CNT + 1
								else
									Fox.Log("Nothing Done !!")
								end
								
								if svars.isTargetVehicle_06 == 1	then
									ActiveVhicle_CNT = ActiveVhicle_CNT + 1
								else
									Fox.Log("Nothing Done !!")
								end
								
								if svars.isTargetVehicle_07 == 1	then
									ActiveVhicle_CNT = ActiveVhicle_CNT + 1
								else
									Fox.Log("Nothing Done !!")
								end
								
								if svars.isBulletTruck == 1	then
									ActiveVhicle_CNT = ActiveVhicle_CNT + 1
								elseif svars.isBulletTruck == 2 or svars.isBulletTruck == 3	then
									ActiveVhicle_CNT = ActiveVhicle_CNT - 1
									svars.isBulletTruck = 4
								else
									Fox.Log("Nothing Done !!")
								end
								
								if svars.isHostageVehicle == 1	then
									ActiveVhicle_CNT = ActiveVhicle_CNT + 1
								elseif svars.isHostageVehicle == 2 or svars.isHostageVehicle == 3	then
									ActiveVhicle_CNT = ActiveVhicle_CNT - 1
									svars.isHostageVehicle = 4
								else
									Fox.Log("Nothing Done !!")
								end
								
								Fox.Log("ActiveVhicle_CNT is "..ActiveVhicle_CNT.." !!")
								if ActiveVhicle_CNT <= 2	then
									this.nextVehicle_ON()
								else
									Fox.Log("ActiveVhicle_CNT more than 3 ... Nothing Done !!")
								end
							end
						else
							Fox.Log("already Rdio Playing ... Nothing Done !!")
						end
						this.EventTimer_Disposal()		
					end
				},
			},
			Player = {
				{	
					msg = "OnPickUpWeapon",
					func = function( playerGameObjectId, equipId, number)
						if equipId == TppEquip.EQP_WP_East_ms_020	then
							TppMission.UpdateObjective{
								objectives = { "missionTask_4_clear",},
							}
						else
						end
					end
				},
			},
			SupportAttack = {
				{	
					msg = "OnRequested",
					func = function()
						svars.isMB_Support = true
					end
				},
			},
			Terminal = {
				{	
					msg = "MbDvcActSelectItemDropPoint",
					func = function()
						svars.isMB_Support = true
					end
				},
			},
			UI = {
				{	
					msg = "EndTelopCast",
					func = function()
						svars.isTelopEnd = true
						
						if ( TppMission.IsStartFromHelispace() == true ) then
							Fox.Log("### Player Start Game From Helicopter ###")
							if	svars.isDrpHeliTrap_inPC == true	then
								this.timerStart()
							else
								Fox.Log("Nothing Done !!")
							end
						
						elseif ( TppMission.IsStartFromFreePlay() == true ) then
							Fox.Log("### Player Start Game From FreePlay ###")
							this.timerStart()
						else
							Fox.Log("### Player Start Game From ??? Must Check !! ###")
						end					
					end
				},
				{
					msg = "DisplayTimerTimeUp",
					func = function()
						if svars.isTargrtCount_Clear == 0	then	
							Fox.Log("TimeOver...")
							TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.S10054_TIME_UP, TppDefine.GAME_OVER_RADIO.S10054_TIME_UP )	
						else
							svars.isTimeUp = true
							TppSequence.SetNextSequence("Seq_Game_Escape")
						end
					end
				},
				{
					msg = "DisplayTimerLap",
					func = function ( RestTime , PassTime )
						local isPlaying = TppRadioCommand.IsPlayingRadio()
						
						if	RestTime <= 840 and not mvars.firstEnemyMoveStarted	then		
							this.remnantsVehicle_GO()		
							mvars.firstEnemyMoveStarted = true
						end
						if	RestTime == 720	or RestTime == 715 or RestTime == 710	then	
							if isPlaying == false	then
								
								Fox.Log("isTargrtCount_Clear is = "..svars.isTargrtCount_Clear.." !!")
								if		svars.isTargrtCount_Clear == 0 or svars.isTargrtCount_Clear == 1	then	
									Fox.Log("No Radio ...")
								elseif	svars.isTargrtCount_Clear >= 2	then	
									s10054_radio.TargetClear_halfTime_nml()
								else
									Fox.Log("WRONG isTargrtCount_Clear !!")
								end
							else
								Fox.Log("isPlaying == true ... Nothin Done !!")
							end
						elseif	RestTime == 450	or RestTime == 445 or RestTime == 440	then	
							if svars.isReserveFlag_07 == false	then
								
								Fox.Log("isTargrtCount_Clear is = "..svars.isTargrtCount_Clear.." !!")
								if		svars.isTargrtCount_Clear == 0	then	
									s10054_radio.noTargetClear_halfTime()
									svars.isReserveFlag_07 = true
								elseif	svars.isTargrtCount_Clear == 1	or svars.isTargrtCount_Clear == 2 or svars.isTargrtCount_Clear == 3 then	
									Fox.Log("No Radio ...")
								elseif	svars.isTargrtCount_Clear >= 4	then	
									s10054_radio.TargetClear_halfTime_high()
									svars.isReserveFlag_07 = true
								else
									Fox.Log("WRONG isTargrtCount_Clear !!")
								end
							else
								Fox.Log("isReserveFlag_07 == true ... Nothing Radio !!")
							end
						elseif	RestTime == 300		then	
							svars.isEmergencyTime = true
							this.BGM_Setting()
							if isPlaying == false	then
								s10054_radio.EmergencyTime()
							else
								Fox.Log("Nothing Done !!")
							end
						elseif 	RestTime == 180		then	
							if isPlaying == false	then
								s10054_radio.last_3min()
							else
								Fox.Log("Nothing Done !!")
							end
						elseif	RestTime == 150		then	
						
						elseif 	RestTime == 120		then	
							if isPlaying == false	then
								s10054_radio.last_2min()
							else
								Fox.Log("Nothing Done !!")
							end
						elseif 	RestTime == 60		then	
							if isPlaying == false	then
								s10054_radio.last_1min()
							else
								Fox.Log("Nothing Done !!")
							end
						elseif 	RestTime == 30		then	
							if isPlaying == false and svars.isTargrtCount_Clear == 0	then
								s10054_radio.last_30s()
							else
								Fox.Log("Nothing Done !!")
							end
						elseif	RestTime == 5		then	
							if isPlaying == false and svars.isTargrtCount_Clear == 0	then
								s10054_radio.last_5s()
							else
								Fox.Log("Nothing Done !!")
							end
						else
							
						end








































					end
				},
				nil
			},
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		TppTelop.StartCastTelop()					
		this.EventTimer_Disposal()
		this.BGM_Setting()
		this.AddMapIconText()						
		this.checkPoint_off()						
		this.OptRadioControl_Setting()				
		this.AddHighInterrogation()					
		TppWeather.SetWeatherProbabilitiesAfghNoSandStorm()	
		TppMission.UpdateObjective{
			objectives = { "default_photo_Target","default_subGoal","missionTask_1","missionTask_2","missionTask_3","missionTask_4","missionTask_5","missionTask_6","missionTask_7","missionTask_8",},
		}
		this.enemyBaseVehicle_GO()
		
		if TppSequence.GetContinueCount() == 0 then	
			TppMission.UpdateObjective{
				radio = { radioGroups = "s0054_rtrg2010", },
				
				objectives = { "FIXED_VEHICLE_01","FIXED_VEHICLE_02", },
				options = { isMissionStart = true },
			}
		else
			s10054_radio.Seq_MainGame_Continue()
			TppMission.UpdateObjective{
				
				objectives = { "FIXED_VEHICLE_01","FIXED_VEHICLE_02", },
			}
			this.common_movingCourseCheck()					
			






		end
		TppPickable.PutOn( "normalTruck_bullet" , GameObject.GetGameObjectId( "veh_s10054_0009" ) , 0 )	
	end,
	
	OnLeave = function ()
		
	end,
}

sequences.Seq_Game_Escape = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{
					msg = "LostControl",
						func = function ( gameObjectId, state, Attacker )
							
							if	gameObjectId == GameObject.GetGameObjectId( "EnemyHeli" )	then
								if state == StrCode32("Start")	then
									svars.isBonusTargetClear_CNT = svars.isBonusTargetClear_CNT + 1
									this.OptRadioControl_Setting()
									this.BGM_Setting()
								elseif state == StrCode32("End")	then
									s10054_radio.bonus_EnemyHeli_Clear()
								else
									Fox.Log("state is WRONG VALUE !!")
								end
							else
							end
						end,
				},
			},
			Timer = {
				{	
					msg = "Finish",	sender = "timer_radio_AllTargetClear",
					func = function ()
						this.BonusTarget_ON()	
					end,
				},
				{
					msg = "Finish",	sender = "timer_BonusPasstimeCheck",	
					func = function()
						this.BonusTarget_ON_2()
					end,
				},
				nil
			},
			Player = {
				{	
					msg = "OnPickUpWeapon",
					func = function( playerGameObjectId, equipId, number)
						if equipId == TppEquip.EQP_WP_East_ms_020	then
							TppMission.UpdateObjective{
								objectives = { "missionTask_4_clear",},
							}
						else
						end
					end
				},
			},
			Radio = {
				{	
					msg = "Finish",	sender = "s0054_rtrg3040",
					func = function()
						TppMission.UpdateObjective{ objectives = { "FIXED_BONUS_01","FIXED_BONUS_02","FIXED_BONUS_04", } }
						this.OptRadioControl_Setting()
					end
				},
				{
					msg = "Finish",	sender = "s0054_rtrg2100",
					func = function ()
						TimerStart( "timer_radio_AllTargetClear", 5 )		
					end,
				},
				{	
					msg = "Finish",	sender = "s0054_rtrg3060",
					func = function ()
						TppUI.ShowAnnounceLog( "destroyTarget" )
						this.bonusTargetClear_commonAnnounceLog()
					end,
				},
				{	
					msg = "Finish",	sender = "s0054_rtrg3050",
					func = function ()
						TppUI.ShowAnnounceLog( "destroyTarget" )
						this.bonusTargetClear_commonAnnounceLog()
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function()
		TppUiCommand.InitAllEnemyRoutePoints()
		TppUiCommand.EraseDisplayTimer()			
		TppUiCommand.SetDisplayTimerText( "" )		
		this.EventTimer_Disposal()					
		this.checkPoint_off()						
		this.AddMapIconText()						
		this.targetIconText_Change()				
		this.OptRadioControl_Setting()				
		TppWeather.SetWeatherProbabilitiesAfghNoSandStorm()	
		TppUiCommand.InitAllEnemyRoutePoints()		
		
		if svars.isTargetVehicle_03 ~= 2	then
			Player.RemoveSearchTarget( TARGET_VEHICLE_03 )
		else
			Fox.Log("isTargetVehicle_03 == 2 ... Nothing Done !!")
		end
		
		TppMarker.Disable( TARGET_VEHICLE_01 )
		TppMarker.Disable( TARGET_VEHICLE_02 )
		TppMarker.Disable( TARGET_VEHICLE_03 )
		TppMarker.Disable( TARGET_VEHICLE_04 )
		TppMarker.Disable( TARGET_VEHICLE_05 )
		TppMarker.Disable( TARGET_VEHICLE_06 )
		TppMarker.Disable( TARGET_VEHICLE_07 )
	
	
		TppMission.UpdateObjective{
			objectives = { "escape_subGoal",},
		}
		
		TppMission.CanMissionClear()
		
		Fox.Log("TARGET_VEHICLE_COUNT is"..svars.isTargrtCount_Clear.." !!")
		if svars.isTargrtCount_Clear >= TARGET_VEHICLE_COUNT	then
			s10054_radio.escape_AllTargetClear()
			
			if svars.isMB_Support == false	then
				TppMission.UpdateObjective{ objectives = { "missionTask_3_clear",},}
				TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}
			else
				Fox.Log("svars.isMB_Support == true ... NO BONUS")
			end
		elseif svars.isTargrtCount_Clear >= 1 and svars.isTargrtCount_Clear < TARGET_VEHICLE_COUNT	then
			
			if svars.isTimeUp == true	then
				s10054_radio.escape_TargetClear()
			else
				s10054_radio.noMore_reinforce()
			end
		else
			Fox.Log("TARGET_VEHICLE_COUNT is WRONG")
		end
		this.BGM_Setting()
	end,
}




return this