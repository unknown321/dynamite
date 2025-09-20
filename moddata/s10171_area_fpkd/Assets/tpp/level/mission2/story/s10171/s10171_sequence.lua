local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

local IsTypeString = Tpp.IsTypeString
local NULL_ID = GameObject.NULL_ID

local TIMER_HELI_WAITING_POINT_INTERVAL = 60
local TIMER_VEH_WAITING_POINT_INTERVAL = 180
local TIMER_BGM_INTERVAL = 25
local TIMER_HELI_START_LOOP_INTERVAL = 1
local TIMER_HELI_START_MAX_LOOP_COUNT = 220

local INTEL_NAME = "Intel_showRoute"
local INTEL_TRAP_NAME = "trap_GetIntel_showRoute"
local INTEL_MARKER_TRAP_NAME = "trap_IntelTent"
local ENEMY_HELI_NAME = "EnemyHeli"

local PHOTO_NAME = {
	HELI = 10,
	TANK_SWAMP = 20,
	TANK_HILL = 30,
	WAV_HILL = 40,
	WAV_ADD = 50,
}

local WAITPOINT_ROUTE = {
	"rts_veh_waiting_first",
	"rts_veh_waiting_second",
	"rts_veh_waiting_third",
}

local MAX_COUNT_ELIMINATING_TANKS = 2
local MAX_COUNT_ELIMINATING_WAVS = 2
local MAX_COUNT_ELIMINATING_TARGETS = 5

this.MAX_PICKABLE_LOCATOR_COUNT = 26

this.MAX_PLACED_LOCATOR_COUNT = 67

local MISSION_BLUE_PRINT_NAME = "col_develop_FLamethrower"
local SUB_TASK_BLUE_PRINT_NUMBER = TppTerminal.BLUE_PRINT_LOCATOR_TABLE[MISSION_BLUE_PRINT_NAME]

this.MISSIONTASK_LIST = {
	MAIN_FIRST = 0,
	MAIN_SECOND = 1,
	MAIN_THIRD = 3,
	BONUS_FIRST = 4,
	BONUS_SECOND = 5,
	SUB_FIRST = 6,
	SUB_SECOND = 7,
}

local DEV_DOC_POSITION_FOR_CONTINUE = Vector3(939.916, -5.4, 328.052)

local ENEMY_HELI_STATE = {
	NORMAL = 0,
	LOST_CONTROL_START = 1,
	LOST_CONTROL_END = 2,
}

function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences({

		"Seq_Game_MainGame",
		"Seq_Game_Escape",
		nil,
	})
	TppSequence.RegisterSequenceTable(sequences)
end

this.saveVarsList = {
	isHeliBroken = false,
	isTank1Broken = false,
	isTank2Broken = false,
	isWavBroken = false,
	isTank1Rescued = false,
	isTank2Rescued = false,
	isWavRescued = false,

	isArmoredForcesLeftRallyPoint = false,

	isHeliCleared = false,
	isTank1Cleared = false,
	isTank2Cleared = false,
	isWavCleared = false,

	isVehicleWaitTimerStarted = false,

	isOnGetIntel = false,

	isVehiclesDeparted = false,

	firstArrivedDriverGameObjectId = NULL_ID,
	secondArrivedDriverGameObjectId = NULL_ID,
	thirdArrivedDriverGameObjectId = NULL_ID,

	heliStartTimerLoopCount = 0,
	didHeliSetRouteFromFirst = false,

	reserve_boolFlagOne = false,
	reserve_boolFlagTwo = false,
	reserve_boolFlagThree = false,
	reserve_boolFlagFour = false,
	reserve_boolFlagFive = false,
	reserve_numberFlagOne = 0,
	reserve_numberFlagTwo = 0,
	reserve_numberFlagThree = 0,
	reserve_numberFlagFour = 0,
	reserve_numberFlagFive = 0,

	waitPointArrivedOrder = 1,

	isTank1ArrivedPfCamp = false,
	isTank2ArrivedPfCamp = false,
	isWavArrivedPfCamp = false,

	isWavAddShown = false,
	isWavAddBroken = false,
	isWavAddRecovered = false,
	isWavAddCleared = false,
	isWavAddUseSwampEastRoute = false,
	isWavAddGoneForSecondMove = false,

	countEliminatedTanks = 0,
	countEliminatedWAVs = 0,

	isSetWaitPointRouteTank1 = false,
	isSetWaitPointRouteTank2 = false,
	isSetWaitPointRouteWav = false,

	countEliminatedTarget = 0,

	need_Timer_HeliWaitingPoint = false,
	need_Timer_WaitingPoint = false,

	enemyHeliState = ENEMY_HELI_STATE.NORMAL,
}

this.REVENGE_MINE_LIST = { "mafr_pfCamp", "mafr_hill", "mafr_swamp", "mafr_savannah" }
this.MISSION_REVENGE_MINE_LIST = {
	["mafr_pfCamp"] = {
		decoyLocatorList = {
			"itm_revDecoy_pfCampNorth_a_0000",
		},
		["trap_mafr_pfCampNorth_mine"] = {
			mineLocatorList = {
				"itm_revMine_pfCampNorth_a_0000",
				"itm_revMine_pfCampNorth_a_0001",
			},
		},
	},
}

this.baseList = {
	"pfCamp",
	"pfCampNorth",
	"pfCampEast",
	"swamp",
	"swampSouth",
	"swampEast",
	"swampWest",
	"hill",
	"hillWest",
	"hillWestNear",
	"savannah",
	"savannahEast",
	nil,
}

this.checkPointList = {
	"CHK_GetIntel",
	nil,
}

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

this.missionObjectiveDefine = {

	Area_marker_target = {
		gameObjectName = "s10171_marker_target",
		visibleArea = 5,
		randomRange = 0,
		setNew = false,
		viewType = "map_only_icon",
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
		targetBgmCp = "mafr_pfCamp_cp",
		showEnemyRoutePoints = {
			groupIndex = 2,
			width = 200.0,
			langId = "marker_target_forecast_path",
			radioGroupName = "s0171_mprg0010",
			points = {
				Vector3(829.2, 0.0, 1160.1),
				Vector3(828.8, 0.0, 694.6),
				Vector3(933.6, 0.0, 379.4),
			},
		},
	},
	clear_area_marker_target = {},
	Area_marker_rally = {
		gameObjectName = "s10171_marker_rally",
		visibleArea = 5,
		randomRange = 0,
		setNew = false,
		viewType = "map_only_icon",
		langId = "marker_info_mission_targetArea",
		targetBgmCp = "mafr_pfCampNorth_ob",
		mapRadioName = "s0171_mprg0020",
	},
	clear_area_marker_rally = {},
	area_Intel_get = {},
	area_Intel = {
		gameObjectName = "s10171_marker_Intel",
	},
	attack_marker_heli = {
		gameObjectName = s10171_enemy.ENEMY_HELI,
		goalType = "attack",
		viewType = "map_and_world_only_icon",
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_target",
	},
	attack_marker_tank_swamp = {
		gameObjectName = s10171_enemy.ENEMY_TANK1,
		goalType = "attack",
		viewType = "map_and_world_only_icon",
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_target",
	},
	attack_marker_tank_hill = {
		gameObjectName = s10171_enemy.ENEMY_TANK2,
		goalType = "attack",
		viewType = "map_and_world_only_icon",
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_target",
	},
	attack_marker_wav_hill = {
		gameObjectName = s10171_enemy.ENEMY_WAV,
		goalType = "attack",
		viewType = "map_and_world_only_icon",
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_target",
	},
	attack_marker_wav_add = {
		gameObjectName = s10171_enemy.ENEMY_WAV_ADD,
		goalType = "attack",
		viewType = "map_and_world_only_icon",
		setImportant = true,
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_target",
	},

	defult_photo_heli = {
		photoId = PHOTO_NAME.HELI,
		addFirst = false,
		addSecond = false,
		photoRadioName = "s0171_mirg0010",
	},
	defult_photo_tank_swamp = {
		photoId = PHOTO_NAME.TANK_SWAMP,
		addFirst = false,
		addSecond = false,
		photoRadioName = "s0171_mirg0020",
	},
	defult_photo_tank_hill = {
		photoId = PHOTO_NAME.TANK_HILL,
		addFirst = false,
		addSecond = false,
		photoRadioName = "s0171_mirg0030",
	},
	defult_photo_wav_hill = {
		photoId = PHOTO_NAME.WAV_HILL,
		addFirst = false,
		addSecond = false,
		photoRadioName = "s0171_mirg0040",
	},
	defult_photo_wav_add = {
		photoId = PHOTO_NAME.WAV_ADD,
		addFirst = false,
		addSecond = false,
		photoRadioName = "s0171_mirg0050",
	},
	enemy_route_tank_swamp = {
		showEnemyRoutePoints = {
			groupIndex = 0,
			width = 200.0,
			langId = "marker_target_forecast_path",
			radioGroupName = "s0171_mprg0010",
			points = {
				Vector3(881.5, 0.0, 310.6),
				Vector3(563.4, 0.0, -16.7),
				Vector3(-282.6, 0.0, 51.0),
				Vector3(-525.0, 0.0, -153.7),
			},
		},
	},

	enemy_route_tank_hill = {
		showEnemyRoutePoints = {
			groupIndex = 1,
			width = 200.0,
			langId = "marker_target_forecast_path",
			radioGroupName = "s0171_mprg0010",
			points = {
				Vector3(1012.7, 0.0, 279.7),
				Vector3(1238.3, 0.0, 69.5),
				Vector3(1265.5, 0.0, 463.6),
				Vector3(2085.3, 0.0, 410.8),
			},
		},
	},

	clear_swamp_route = {},
	clear_hill_route = {},

	default_subGoal = {
		subGoalId = 0,
	},
	end_subGoal = {
		subGoalId = 1,
	},

	eliminate_heli_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_FIRST, isNew = true, isComplete = false },
	},
	eliminate_tanks_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SECOND, isNew = true, isComplete = false },
	},
	eliminate_wav_hill_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_THIRD, isNew = true, isComplete = false },
	},
	clear_eliminate_heli_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_FIRST, isNew = false, isComplete = true },
	},
	clear_eliminate_tanks_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SECOND, isNew = false, isComplete = true },
	},
	clear_eliminate_tank_swamp_marker = {},
	clear_eliminate_tank_hill_marker = {},
	clear_eliminate_wavs_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_THIRD, isNew = false, isComplete = true },
	},
	clear_eliminate_wav_hill_marker = {},
	clear_eliminate_wav_add_marker = {},

	firstBonus_MissionTask = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.BONUS_FIRST,
			isNew = true,
			isComplete = false,
			isFirstHide = true,
		},
	},
	secondBonus_MissionTask = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.BONUS_SECOND,
			isNew = true,
			isComplete = false,
			isFirstHide = true,
		},
	},
	clear_firstBonus_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.BONUS_FIRST, isNew = false },
	},
	clear_secondBonus_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.BONUS_SECOND, isNew = false },
		announceLog = "recoverTarget",
	},

	firstSub_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_FIRST, isNew = true, isComplete = false, isFirstHide = true },
	},
	Area_task_diamond = {
		gameObjectName = "Marker_task_Diamond",
		visibleArea = 1,
		randomRange = 0,
		setNew = true,
		viewType = "map_only_icon",
		announceLog = "updateMap",
		langId = "marker_diamond_gem",
		goalType = "none",
	},
	secondSub_MissionTask = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SUB_SECOND,
			isNew = true,
			isComplete = false,
			isFirstHide = true,
		},
	},
	clear_firstSub_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_FIRST, isNew = false, isComplete = true },
	},
	clear_secondSub_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_SECOND, isNew = false, isComplete = true },
	},

	announce_destory_heli = {
		announceLog = "destroyTarget",
	},
	announce_destory_tank1 = {
		announceLog = "destroyTarget",
	},
	announce_destory_tank2 = {
		announceLog = "destroyTarget",
	},
	announce_destory_wav = {
		announceLog = "destroyTarget",
	},
	announce_destory_wav_add = {
		announceLog = "destroyTarget",
	},
	announce_recover_tank1 = {
		announceLog = "recoverTarget",
	},
	announce_recover_tank2 = {
		announceLog = "recoverTarget",
	},
	announce_recover_wav = {
		announceLog = "recoverTarget",
	},
	announce_recover_wav_add = {
		announceLog = "recoverTarget",
	},
	announce_get_intel = {
		announceLog = "recoverTarget",
	},
}

this.specialBonus = {
	first = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.BONUS_FIRST },
	},
	second = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.BONUS_SECOND },
	},
}

this.missionObjectiveTree = {
	clear_area_marker_target = {
		Area_marker_target = {
			clear_area_marker_rally = {
				Area_marker_rally = {},
			},
		},
	},
	clear_swamp_route = {
		enemy_route_tank_swamp = {},
	},
	clear_hill_route = {
		enemy_route_tank_hill = {},
	},

	area_Intel_get = {
		area_Intel = {},
	},
	clear_eliminate_heli_MissionTask = {
		attack_marker_heli = {},
		eliminate_heli_MissionTask = {},
	},
	clear_eliminate_tank_swamp_marker = {
		attack_marker_tank_swamp = {},
	},
	clear_eliminate_tank_hill_marker = {
		attack_marker_tank_hill = {},
	},
	clear_eliminate_tanks_MissionTask = {
		eliminate_tanks_MissionTask = {},
	},
	clear_eliminate_wav_hill_marker = {
		attack_marker_wav_hill = {},
	},
	clear_eliminate_wav_add_marker = {
		attack_marker_wav_add = {},
	},
	clear_eliminate_wavs_MissionTask = {
		eliminate_wav_hill_MissionTask = {},
	},
	clear_firstBonus_MissionTask = {
		firstBonus_MissionTask = {},
	},
	clear_secondBonus_MissionTask = {
		secondBonus_MissionTask = {},
	},
	clear_firstSub_MissionTask = {
		firstSub_MissionTask = {},
	},
	clear_secondSub_MissionTask = {
		secondSub_MissionTask = {},
	},
}

this.missionObjectiveEnum = Tpp.Enum({
	"Area_marker_target",
	"clear_area_marker_target",
	"Area_marker_rally",
	"clear_area_marker_rally",
	"area_Intel_get",
	"area_Intel",
	"attack_marker_heli",
	"attack_marker_tank_swamp",
	"attack_marker_tank_hill",
	"attack_marker_wav_hill",
	"attack_marker_wav_add",
	"defult_photo_heli",
	"defult_photo_tank_swamp",
	"defult_photo_tank_hill",
	"defult_photo_wav_hill",
	"defult_photo_wav_add",
	"enemy_route_tank_swamp",
	"enemy_route_tank_hill",
	"clear_swamp_route",
	"clear_hill_route",
	"default_subGoal",
	"end_subGoal",
	"eliminate_heli_MissionTask",
	"eliminate_tanks_MissionTask",
	"eliminate_wav_hill_MissionTask",
	"clear_eliminate_heli_MissionTask",
	"clear_eliminate_tanks_MissionTask",
	"clear_eliminate_tank_swamp_marker",
	"clear_eliminate_tank_hill_marker",
	"clear_eliminate_wavs_MissionTask",
	"clear_eliminate_wav_hill_marker",
	"clear_eliminate_wav_add_marker",
	"firstBonus_MissionTask",
	"secondBonus_MissionTask",
	"clear_firstBonus_MissionTask",
	"clear_secondBonus_MissionTask",
	"firstSub_MissionTask",
	"Area_task_diamond",
	"secondSub_MissionTask",
	"clear_firstSub_MissionTask",
	"clear_secondSub_MissionTask",
	"announce_destory_heli",
	"announce_destory_tank1",
	"announce_destory_tank2",
	"announce_destory_wav",
	"announce_destory_wav_add",
	"announce_recover_tank1",
	"announce_recover_tank2",
	"announce_recover_wav",
	"announce_recover_wav_add",
})

this.missionStartPosition = {
	helicopterRouteList = {
		"lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000",
		"lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000",
		"lz_drp_swamp_N0000|lz_drp_swamp_N_0000",
		"lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000",
	},
	orderBoxList = {
		"box_s10171_00",
		"box_s10171_01",
	},
}

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	TppMission.RegisterMissionSystemCallback({

		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,

		OnEstablishMissionClear = this.OnEstablishMissionClear,

		OnRecovered = this.OnTargetRescued,
	})

	TppPlayer.AddTrapSettingForIntel({
		intelName = INTEL_NAME,
		autoIcon = true,
		identifierName = "GetIntelIdentifier",
		locatorName = "GetIntel_showRoute",
		gotFlagName = "isOnGetIntel",
		trapName = INTEL_TRAP_NAME,
		markerObjectiveName = "area_Intel",
		markerTrapName = INTEL_MARKER_TRAP_NAME,
	})

	TppRatBird.EnableRat()
	TppRatBird.EnableBird("TppCritterBird")
end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	mvars.waitPointArrivalList = {}
	mvars.vipInterrogationOrder = 0

	TppRevenge.RegisterMissionMineList(this.MISSION_REVENGE_MINE_LIST)
end

function this.OnEstablishMissionClear(missionClearType)
	Fox.Log("*** " .. tostring(missionClearType) .. " OnEstablishMissionClear ***")

	if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
		TppPlayer.PlayMissionClearCamera()
		TppMission.MissionGameEnd({
			loadStartOnResult = true,

			fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,

			delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
		})
	else
		TppMission.MissionGameEnd({ loadStartOnResult = true })
	end
end

function this.Messages()
	return StrCode32Table({
		Player = {
			{
				msg = "OnPickUpCollection",
				func = function(playerGameObjectId, collectionUniqueId, collectionTypeId)
					Fox.Log(
						"OnPickUpCollection playerGameObjectId: "
							.. tostring(playerGameObjectId)
							.. " collectionUniqueId: "
							.. tostring(collectionUniqueId)
							.. " collectionTypeId: "
							.. tostring(collectionTypeId)
					)
					if collectionUniqueId == TppCollection.GetUniqueIdByLocatorName("col_diamond_l_s10171_0000") then
						TppMission.UpdateObjective({
							objectives = { "clear_firstSub_MissionTask" },
						})
					end
				end,
			},
			{
				msg = "OnPickUpWeapon",
				func = function(playerGameObjectId, equipId, number)
					Fox.Log(
						"OnPickUpWeapon playerGameObjectId: "
							.. tostring(playerGameObjectId)
							.. " equipId: "
							.. tostring(equipId)
							.. " number: "
							.. tostring(number)
							.. " SUB_TASK_BLUE_PRINT_NUMBER: "
							.. tostring(SUB_TASK_BLUE_PRINT_NUMBER)
					)
					if equipId == TppEquip.EQP_IT_DevelopmentFile and number == SUB_TASK_BLUE_PRINT_NUMBER then
						TppMission.UpdateObjective({
							objectives = { "clear_secondSub_MissionTask" },
						})

						TppTerminal.PickUpBluePrint(nil, SUB_TASK_BLUE_PRINT_NUMBER)

						svars.enemyHeliState = ENEMY_HELI_STATE.LOST_CONTROL_END
					end
				end,
			},
			{
				msg = "DeadInFOB",
				func = function(deadPlayerIndex, AttackerId)
					TppUiCommand.AnnounceLogView("Player " .. tostring(deadPlayerIndex) .. " died")
					if deadPlayerIndex == PlayerInfo.GetLocalPlayerIndex() then
						TppUiCommand.AnnounceLogView("Respawn in 10 seconds")
						GkEventTimerManager.Start("RespawnPlayer", 10)
					end
				end,
			},
		},
		Timer = {
			{
				msg = "Finish",
				sender = "RespawnPlayer",
				func = function()
					TppUiCommand.AnnounceLogView("Respawning")
					TppUiStatusManager.ClearStatus("AnnounceLog")
					TppUiStatusManager.ClearStatus("EquipPanel")
					TppUiStatusManager.ClearStatus("HeadMarker")
					TppUiStatusManager.ClearStatus("WorldMarker")
					Player.RequestToRespawn()
				end,
			},
		},
		Network = {
			{
				msg = "FobPeerNameResolved",
				func = function()
					TppUiCommand.AnnounceLogView("Co-op partner connecting")
				end,
			},
		},
		Nt = {
			{
				msg = "SessionDeleteMember",
				func = function()
					TppUiCommand.AnnounceLogView("Client Player Disconnected!")
				end,
			},
			{
				msg = "SessionDisconnectFromHost",
				func = function()
					TppUiCommand.AnnounceLogView("Host Player Disconnected!")
				end,
			},
		},
	})
end

local InterrogationCpList = {
	"mafr_pfCamp_cp",
	"mafr_pfCampNorth_ob",
	"mafr_pfCampEast_ob",
	"mafr_swamp_cp",
	"mafr_swampSouth_ob",
	"mafr_swampEast_ob",
	"mafr_swampWest_ob",
	"mafr_savannah_cp",
	"mafr_savannahEast_ob",
}

function this.HighInterrogation()
	Fox.Log("HighInterrogation")
	local sequence = TppSequence.GetCurrentSequenceName()

	if sequence == "Seq_Game_MainGame" then
		if svars.isOnGetIntel == false then
			TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("mafr_pfCampNorth_ob"), {
				{ name = s10171_enemy.INTERROGATION_TYPE.INTEL, func = s10171_enemy.InterCall_TellIntelligenceFile },
			})
		end

		for i, cp in pairs(InterrogationCpList) do
			Fox.Log(cp)
			TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId(cp), {
				{ name = s10171_enemy.INTERROGATION_TYPE.AIRPORT, func = s10171_enemy.InterCall_VipSchedule },
				{ name = s10171_enemy.INTERROGATION_TYPE.HELI, func = s10171_enemy.InterCall_VipRideOnHeli },
				{ name = s10171_enemy.INTERROGATION_TYPE.GREAT, func = s10171_enemy.InterCall_VipGreat },
			})
		end
	else
		for i, cp in pairs(InterrogationCpList) do
			TppInterrogation.ResetFlagHigh(GameObject.GetGameObjectId(cp))
		end
	end

	Fox.Log("End HighInterrogation")
end

this.RemoveMissionInterrogation = function(removeName, removeFunc)
	Fox.Log("RemoveMissionInterrogation")

	for i, cp in pairs(InterrogationCpList) do
		Fox.Log(cp)
		TppInterrogation.RemoveHighInterrogation(GameObject.GetGameObjectId(cp), {
			{ name = removeName, func = removeFunc },
		})
	end
end

sequences.Seq_Game_MainGame = {

	Messages = function(self)
		return StrCode32Table({
			Player = {
				{
					msg = "GetIntel",
					sender = INTEL_NAME,
					func = function(intelNameHash)
						Fox.Log("Got Intel")
						TppPlayer.GotIntel(intelNameHash)

						s10171_demo.PlayGetIntel_showRoute(func)

						this.RemoveMissionInterrogation(
							s10171_enemy.INTERROGATION_TYPE.INTEL,
							s10171_enemy.InterCall_TellIntelligenceFile
						)
					end,
				},
			},
			Timer = {
				{

					msg = "Finish",
					sender = "Timer_HeliStart",
					func = function()
						if svars.heliStartTimerLoopCount < TIMER_HELI_START_MAX_LOOP_COUNT then
							GkEventTimerManager.Start("Timer_HeliStart", TIMER_HELI_START_LOOP_INTERVAL)
							svars.heliStartTimerLoopCount = svars.heliStartTimerLoopCount + 1
						else
							Fox.Log(
								"s10171_enemy.EnemyHeliSetRoute: rts_enemy_heli_toPfCampNorth. svars.didHeliSetRouteFromFirst: "
									.. tostring(svars.didHeliSetRouteFromFirst)
							)

							if svars.didHeliSetRouteFromFirst == false then
								s10171_enemy.EnemyHeliSetRoute("rts_enemy_heli_toPfCampNorth")
								svars.didHeliSetRouteFromFirst = true
								if DEBUG then
									TppDebug.Print2D({
										showTime = 60 * 4,
										xPos = 450,
										yPos = 550,
										text = "Start Heli",
										color = "yellow",
									})
								end
							end
						end
					end,
					option = { isExecDemoPlaying = true },
				},
				{

					msg = "Finish",
					sender = "Timer_HeliWaitingPoint",
					func = function()
						svars.need_Timer_HeliWaitingPoint = false

						s10171_enemy.EnemyHeliSetRoute("rts_enemy_heli_to_pfCamp")
						if DEBUG then
							TppDebug.Print2D({
								showTime = 60 * 4,
								xPos = 450,
								yPos = 550,
								text = "Finish Timer_HeliWaitingPoint. Start Heli",
								color = "yellow",
							})
						end

						if
							svars.firstArrivedDriverGameObjectId ~= NULL_ID
							and svars.secondArrivedDriverGameObjectId ~= NULL_ID
							and svars.thirdArrivedDriverGameObjectId ~= NULL_ID
						then
							this.StartVehicleConvoyFromWaitingPoint()
						end
					end,
					option = { isExecDemoPlaying = true },
				},
				{

					msg = "Finish",
					sender = "Timer_WaitingPoint",
					func = function()
						svars.need_Timer_WaitingPoint = false

						this.StartVehicleConvoyFromWaitingPoint()
						if DEBUG then
							TppDebug.Print2D({
								showTime = 60 * 4,
								xPos = 450,
								yPos = 550,
								text = "Finish Timer_WaitingPoint. Start Vehicles",
								color = "yellow",
							})
						end
					end,
					option = { isExecDemoPlaying = true },
				},
				{

					msg = "Finish",
					sender = "Timer_ChangeBGM",
					func = function()
						s10171_sound.SetPhase_missionBGM()

						if TppSequence.GetContinueCount() > 0 then
							this.UpdateBGMAndRadio()
						end
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			GameObject = {
				{
					msg = "LostControl",
					func = this.OnHeliBroken,
				},
				{
					msg = "VehicleBroken",
					func = this.OnVehicleBroken,
				},
				{
					msg = "FultonFailed",
					func = function(gameObjectId, locatorName, locatorNameUpper, failureType)
						Fox.Log(
							"FultonFailed "
								.. "GameObjectId: "
								.. tostring(gameObjectId)
								.. " locator: "
								.. tostring(locatorName)
								.. " failureType "
								.. tostring(failureType)
						)
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
							if this.SetVehicleDestroyed(gameObjectId) then
								s10171_radio.PlayTargetFultonFailed()
							end
						end
					end,
				},

				{ msg = "RoutePoint2", sender = s10171_enemy.ENEMY_HELI, func = this.HandleRouteEvent },
				{ msg = "RoutePoint2", sender = s10171_enemy.ENEMY_TANK1_SOLDIER, func = this.HandleRouteEvent },
				{ msg = "RoutePoint2", sender = s10171_enemy.ENEMY_TANK2_SOLDIER, func = this.HandleRouteEvent },
				{ msg = "RoutePoint2", sender = s10171_enemy.ENEMY_WAV_SOLDIER, func = this.HandleRouteEvent },
				{ msg = "RoutePoint2", sender = s10171_enemy.ENEMY_WAV_ADD_SOLDIER, func = this.HandleRouteEvent },
				nil,
			},
			Trap = {
				{

					msg = "Enter",
					sender = "trap_playerAccessPfCampRight",
					func = function()
						Fox.Log("Enter trap_playerAccessPfCampRight")

						if svars.isTank1ArrivedPfCamp then
							this.SetAllPhaseRouteSoldier(
								s10171_enemy.ENEMY_TANK1_SOLDIER,
								"rts_veh_pfCampCenterFromLeft_front"
							)
						end
						if svars.isTank2ArrivedPfCamp then
							this.SetAllPhaseRouteSoldier(
								s10171_enemy.ENEMY_TANK2_SOLDIER,
								"rts_veh_pfCampCenterFromLeft_middle"
							)
						end
						if svars.isWavArrivedPfCamp then
							this.SetAllPhaseRouteSoldier(
								s10171_enemy.ENEMY_WAV_SOLDIER,
								"rts_veh_pfCampCenterFromLeft_deep"
							)
						end
					end,
				},
				{

					msg = "Enter",
					sender = "trap_playerAccessPfCampLeft",
					func = function()
						Fox.Log("Enter trap_playerAccessPfCampLeft")

						if svars.isTank1ArrivedPfCamp then
							this.SetAllPhaseRouteSoldier(
								s10171_enemy.ENEMY_TANK1_SOLDIER,
								"rts_veh_pfCampCenterFromRight_front"
							)
						end
						if svars.isTank2ArrivedPfCamp then
							this.SetAllPhaseRouteSoldier(
								s10171_enemy.ENEMY_TANK2_SOLDIER,
								"rts_veh_pfCampCenterFromRight_middle"
							)
						end
						if svars.isWavArrivedPfCamp then
							this.SetAllPhaseRouteSoldier(
								s10171_enemy.ENEMY_WAV_SOLDIER,
								"rts_veh_pfCampCenterFromRight_deep"
							)
						end
					end,
				},
				{

					msg = "Enter",
					sender = "trap_playerArrivedPfCampNorth",
					func = function()
						Fox.Log("Enter trap_playerAccessPfCampLeft")
						if svars.isArmoredForcesLeftRallyPoint then
							s10171_radio.OptionalRadioDoInterrogate()
						end
					end,
				},
				{

					msg = "Exit",
					sender = "trap_playerArrivedPfCampNorth",
					func = function()
						Fox.Log("Exit trap_playerAccessPfCampLeft")
						s10171_radio.OptionalRadioEliminateTarget()
					end,
				},

				{
					msg = "Enter",
					sender = "trap_near_vip_room",
					func = function()
						Fox.Log("Reset:Vip Alert Route Unset")
						svars.reserve_boolFlagTwo = true
						if svars.reserve_boolFlagOne == true then
							TppEnemy.UnsetAlertRoute(s10171_enemy.ENEMY_VIP)
						end
					end,
				},

				{
					msg = "Exit",
					sender = "trap_near_vip_room",
					func = function()
						svars.reserve_boolFlagTwo = false
					end,
				},

				nil,
			},
			nil,
		})
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(888.89844, -5.69104, 341.49625))
			TppNetworkUtil.SessionEnableAccept(true)
			Dynamite.StartNearestEnemyThread()
		end

		TppScriptBlock.LoadDemoBlock("Demo_GetIntel")

		TppMission.UpdateObjective({

			objectives = {
				"defult_photo_heli",
				"defult_photo_tank_swamp",
				"defult_photo_tank_hill",
				"defult_photo_wav_hill",
				"defult_photo_wav_add",
				"eliminate_heli_MissionTask",
				"eliminate_tanks_MissionTask",
				"eliminate_wav_hill_MissionTask",
				"default_subGoal",
				"firstBonus_MissionTask",
				"secondBonus_MissionTask",
				"firstSub_MissionTask",
				"secondSub_MissionTask",
			},
		})
		TppMission.UpdateObjective({

			objectives = {
				"enemy_route_tank_swamp",
				"enemy_route_tank_hill",
				"Area_marker_rally",
				"attack_marker_heli",
				"attack_marker_tank_swamp",
				"attack_marker_tank_hill",
				"attack_marker_wav_hill",
			},
			radio = {
				radioGroups = s10171_radio.GetMissionStartRadioGroup(),
			},
		})

		if TppSequence.GetContinueCount() > 0 then
			s10171_radio.PlayMissionContinueRadio()
		end

		if svars.need_Timer_HeliWaitingPoint == true then
			GkEventTimerManager.Start("Timer_HeliWaitingPoint", TIMER_HELI_WAITING_POINT_INTERVAL)
		end

		if svars.need_Timer_WaitingPoint == true then
			GkEventTimerManager.Start("Timer_WaitingPoint", TIMER_VEH_WAITING_POINT_INTERVAL)
		end

		s10171_radio.OptionalRadioEliminateTarget()

		this.HighInterrogation()

		TppTelop.StartCastTelop()

		GkEventTimerManager.Start("Timer_ChangeBGM", TIMER_BGM_INTERVAL)

		GkEventTimerManager.Start("Timer_HeliStart", TIMER_HELI_START_LOOP_INTERVAL)

		if svars.enemyHeliState == ENEMY_HELI_STATE.LOST_CONTROL_START then
			this.HeliItemDrop(DEV_DOC_POSITION_FOR_CONTINUE)
		end

		this.CheckMissionClear()
	end,

	OnLeave = function() end,
}

this.SetSneakCautionRouteSoldier = function(soldierName, routeName, routeNo)
	local gameObjectId = soldierName
	if IsTypeString(gameObjectId) then
		gameObjectId = GameObject.GetGameObjectId(soldierName)
	end
	local SendCommand = GameObject.SendCommand
	if not routeNo then
		routeNo = 0
	end

	if gameObjectId ~= NULL_ID then
		local commandSneak = { id = "SetSneakRoute", route = routeName, point = routeNo }
		local commandCaution = { id = "SetCautionRoute", route = routeName, point = routeNo }
		local commandUnsetAlert = { id = "SetAlertRoute", enabled = false, route = "", point = routeNo }
		SendCommand(gameObjectId, commandSneak)
		SendCommand(gameObjectId, commandCaution)
		SendCommand(gameObjectId, commandUnsetAlert)
	end
end

this.SetAllPhaseRouteSoldier = function(soldierName, routeName, routeNo)
	local gameObjectId = soldierName
	if IsTypeString(gameObjectId) then
		gameObjectId = GameObject.GetGameObjectId(soldierName)
	end

	if not routeNo then
		routeNo = 0
	end
	local commandSneak = { id = "SetSneakRoute", route = routeName, point = routeNo }
	local commandCaution = { id = "SetCautionRoute", route = routeName, point = routeNo }
	local commandAlert = { id = "SetAlertRoute", enabled = true, route = routeName, point = routeNo }
	if gameObjectId ~= NULL_ID then
		local SendCommand = GameObject.SendCommand
		SendCommand(gameObjectId, commandSneak)
		SendCommand(gameObjectId, commandCaution)
		SendCommand(gameObjectId, commandAlert)
	end
end

this.SetPfCampGuardRoute = function(soldierName, routeName, routeNo)
	local gameObjectId = soldierName
	if IsTypeString(gameObjectId) then
		gameObjectId = GameObject.GetGameObjectId(soldierName)
	end

	if not IsTypeString(routeName) then
		routeName = this.ConvertRouteStrCodeToRouteName(routeName)
	end

	if not IsTypeString(routeName) then
		Fox.Warning(
			"SetPfCampGuardRoute Failed. Can't Convert RouteName("
				.. tostring(routeName)
				.. ") soldierName("
				.. tostring(soldierName)
				.. ")"
		)
		return
	end
	local cautionRouteName = routeName
	if not routeNo then
		routeNo = 0
	end
	local commandSneak = { id = "SetSneakRoute", route = routeName, point = routeNo }
	local commandCaution = { id = "SetCautionRoute", route = cautionRouteName, point = routeNo }
	local commandAlert = { id = "SetAlertRoute", enabled = true, route = routeName, point = routeNo }
	if gameObjectId ~= NULL_ID then
		local SendCommand = GameObject.SendCommand
		SendCommand(gameObjectId, commandSneak)
		SendCommand(gameObjectId, commandCaution)
		SendCommand(gameObjectId, commandAlert)
	end
end

this.ConvertRouteStrCodeToRouteName = function(routeNameInStrCode)
	local routeName = nil
	if routeNameInStrCode == StrCode32("rts_veh_pfCampGuardRight_front") then
		routeName = "rts_veh_pfCampGuardRight_front"
	elseif routeNameInStrCode == StrCode32("rts_veh_pfCampGuardRight_middle") then
		routeName = "rts_veh_pfCampGuardRight_middle"
	elseif routeNameInStrCode == StrCode32("rts_veh_pfCampGuardRight_deep") then
		routeName = "rts_veh_pfCampGuardRight_deep"
	elseif routeNameInStrCode == StrCode32("rts_veh_pfCampGuardLeft_front") then
		routeName = "rts_veh_pfCampGuardLeft_front"
	elseif routeNameInStrCode == StrCode32("rts_veh_pfCampGuardLeft_middle") then
		routeName = "rts_veh_pfCampGuardLeft_middle"
	elseif routeNameInStrCode == StrCode32("rts_veh_pfCampGuardLeft_deep") then
		routeName = "rts_veh_pfCampGuardLeft_deep"
	elseif routeNameInStrCode == StrCode32("rts_veh_savannahEast_add_idle") then
		routeName = "rts_veh_savannahEast_add_idle"
	elseif routeNameInStrCode == StrCode32("rts_veh_swampEast_add_idle") then
		routeName = "rts_veh_swampEast_add_idle"
	else
		Fox.Error(
			"ConvertRouteStrCodeToRouteName: passed parameter("
				.. tostring(routeNameInStrCode)
				.. ") is not defined in this function"
		)
	end

	return routeName
end

this.HandleRouteEvent = function(gameObjectId, routeId, param, messageId)
	Fox.Log(
		"HandleRouteEvent-> gameObjectId: "
			.. tostring(gameObjectId)
			.. " messageId: "
			.. tostring(messageId)
			.. " param: "
			.. tostring(param)
	)

	if messageId == StrCode32("waitingPointArrival") then
		Fox.Log("Message: waitingPointArrival" .. " gameObjectId: " .. tostring(gameObjectId))

		if gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_HELI) then
			this.StarHeliMoveFromWaitingPointTimer()
		else
			this.StartVehicleMoveFromWaitingPointTimer()
			local routeName = this.GetWaitPointRouteName(gameObjectId)
			if routeName then
				this.SetAllPhaseRouteSoldier(gameObjectId, routeName)
			end
			if gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV_SOLDIER) then
				s10171_enemy.SetVehicleConvoy({ s10171_enemy.INITIAL_CONVOY_LEAD }, false)
			end

			if DEBUG then
				TppDebug.Print2D({
					showTime = 60 * 4,
					xPos = 250,
					yPos = 550,
					text = tostring(gameObjectId) .. " arrived in WaitingPoint. ChangeRoute: " .. tostring(routeName),
					color = "yellow",
				})
			end
		end
	elseif messageId == StrCode32("waitingPointForConvoy") then
		Fox.Log("waitingPointForConvoy: gameObjectId is " .. tostring(gameObjectId))

		if
			svars.firstArrivedDriverGameObjectId ~= gameObjectId
			and svars.secondArrivedDriverGameObjectId ~= gameObjectId
			and svars.thirdArrivedDriverGameObjectId ~= gameObjectId
		then
			if svars.firstArrivedDriverGameObjectId == NULL_ID then
				svars.firstArrivedDriverGameObjectId = gameObjectId
			elseif svars.secondArrivedDriverGameObjectId == NULL_ID then
				svars.secondArrivedDriverGameObjectId = gameObjectId
			elseif svars.thirdArrivedDriverGameObjectId == NULL_ID then
				svars.thirdArrivedDriverGameObjectId = gameObjectId
			end
		end

		if this.IsEnableUnsetAlertRoute() then
			TppEnemy.UnsetAlertRoute(s10171_enemy.ENEMY_TANK1_SOLDIER)
			TppEnemy.UnsetAlertRoute(s10171_enemy.ENEMY_TANK2_SOLDIER)
			TppEnemy.UnsetAlertRoute(s10171_enemy.ENEMY_WAV_SOLDIER)
		end
	elseif messageId == StrCode32("heliDestinationArrival") then
		TppEnemy.SetSneakRoute(s10171_enemy.ENEMY_VIP, "rts_vip")
		TppEnemy.SetCautionRoute(s10171_enemy.ENEMY_VIP, "rts_vip")
		if svars.reserve_boolFlagTwo == false then
			TppEnemy.SetAlertRoute(s10171_enemy.ENEMY_VIP, "rts_vip_alert")
		elseif svars.reserve_boolFlagTwo == true then
			TppEnemy.UnsetAlertRoute(s10171_enemy.ENEMY_VIP)
		end

		svars.reserve_boolFlagOne = true
		if DEBUG then
			TppDebug.Print2D({
				showTime = 60 * 4,
				xPos = 250,
				yPos = 250,
				text = "Heli Arrived in PfCamp",
				color = "green",
			})
		end
	elseif messageId == StrCode32("vehiclePfCampSeparated") then
		if gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK1_SOLDIER) then
			this.SetPfCampGuardRoute(gameObjectId, "rts_veh_pfCampGuardLeft_front")
		elseif gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK2_SOLDIER) then
			this.SetPfCampGuardRoute(gameObjectId, "rts_veh_pfCampGuardLeft_middle")
		elseif gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV_SOLDIER) then
			this.SetPfCampGuardRoute(gameObjectId, "rts_veh_pfCampGuardLeft_deep")
		end
	elseif messageId == StrCode32("vehiclePfCampArrival") then
		s10171_enemy.SetVehicleConvoy(mvars.waitPointArrivalList, false)
		s10171_enemy.FinishTravelPlan(gameObjectId)
		if gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK1_SOLDIER) then
			this.SetPfCampGuardRoute(gameObjectId, "rts_pfCampSeparate_front")
			svars.isTank1ArrivedPfCamp = true
		elseif gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK2_SOLDIER) then
			this.SetPfCampGuardRoute(gameObjectId, "rts_pfCampSeparate_middle")
			svars.isTank2ArrivedPfCamp = true
		elseif gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV_SOLDIER) then
			this.SetPfCampGuardRoute(gameObjectId, "rts_pfCampSeparate_deep")
			svars.isWavArrivedPfCamp = true
		end

		this.ContinueWavAddToMoveToPfCamp()
	elseif messageId == StrCode32("wavAddArrivedInWaitingPoint") then
		local routeName = this.ConvertRouteStrCodeToRouteName(param)
		if routeName then
			this.SetSneakCautionRouteSoldier(gameObjectId, routeName)
		end

		this.ContinueWavAddToMoveToPfCamp()
	elseif messageId == StrCode32("setGuardRoute") then
		this.SetPfCampGuardRoute(gameObjectId, param)
	elseif messageId == StrCode32("unsetAlertRoute") then
		TppEnemy.UnsetAlertRoute(gameObjectId)
	end
end

this.IsEnableUnsetAlertRoute = function()
	if
		svars.firstArrivedDriverGameObjectId ~= NULL_ID
		and svars.secondArrivedDriverGameObjectId ~= NULL_ID
		and svars.thirdArrivedDriverGameObjectId ~= NULL_ID
	then
		return true
	end

	if
		svars.firstArrivedDriverGameObjectId ~= NULL_ID
		and svars.secondArrivedDriverGameObjectId == NULL_ID
		and svars.thirdArrivedDriverGameObjectId == NULL_ID
	then
		if svars.isTank1Cleared and svars.isTank2Cleared then
			return true
		end
		if svars.isTank2Cleared and svars.isWavCleared then
			return true
		end
		if svars.isTank1Cleared and svars.isWavCleared then
			return true
		end
	end

	if
		svars.firstArrivedDriverGameObjectId ~= NULL_ID
		and svars.secondArrivedDriverGameObjectId ~= NULL_ID
		and svars.thirdArrivedDriverGameObjectId == NULL_ID
	then
		if svars.isTank1Cleared or svars.isTank2Cleared or svars.isWavCleared then
			return true
		end
	end

	return false
end

this.GetWaitPointRouteName = function(gameObjectId)
	local currentWaitPointArrivalOrder = svars.waitPointArrivedOrder
	local waitPointRoute = WAITPOINT_ROUTE[currentWaitPointArrivalOrder]
	if not waitPointRoute then
		Fox.Log("currentWaitPointArrivalOrder( " .. tostring(gameObjectId) .. " ) " .. currentWaitPointArrivalOrder)
		return nil
	end

	Fox.Log("GetWaitPointRouteName( " .. tostring(gameObjectId) .. " ) " .. waitPointRoute)

	if gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK1_SOLDIER) then
		if svars.isSetWaitPointRouteTank1 == false then
			svars.waitPointArrivedOrder = svars.waitPointArrivedOrder + 1
			svars.isSetWaitPointRouteTank1 = true
			return waitPointRoute
		end
	elseif gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK2_SOLDIER) then
		if svars.isSetWaitPointRouteTank2 == false then
			svars.waitPointArrivedOrder = svars.waitPointArrivedOrder + 1
			svars.isSetWaitPointRouteTank2 = true
			return waitPointRoute
		end
	elseif gameObjectId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV_SOLDIER) then
		if svars.isSetWaitPointRouteWav == false then
			svars.waitPointArrivedOrder = svars.waitPointArrivedOrder + 1
			svars.isSetWaitPointRouteWav = true
			return waitPointRoute
		end
	end

	Fox.Log(
		"GetWaitPointRouteName: gameObjectId "
			.. tostring(gameObjectId)
			.. " is not deserve to get waitpoint route. return nil"
	)
	return nil
end

this.StartVehicleConvoyFromWaitingPoint = function()
	if svars.isVehiclesDeparted then
		return
	end
	svars.isVehiclesDeparted = true

	local driverTable = {}
	if svars.firstArrivedDriverGameObjectId ~= NULL_ID then
		table.insert(driverTable, svars.firstArrivedDriverGameObjectId)
		table.insert(
			mvars.waitPointArrivalList,
			s10171_enemy.driverVehicleMatchIdTable[svars.firstArrivedDriverGameObjectId]
		)
	end
	if svars.secondArrivedDriverGameObjectId ~= NULL_ID then
		table.insert(driverTable, svars.secondArrivedDriverGameObjectId)
		table.insert(
			mvars.waitPointArrivalList,
			s10171_enemy.driverVehicleMatchIdTable[svars.secondArrivedDriverGameObjectId]
		)
	end
	if svars.thirdArrivedDriverGameObjectId ~= NULL_ID then
		table.insert(driverTable, svars.thirdArrivedDriverGameObjectId)
		table.insert(
			mvars.waitPointArrivalList,
			s10171_enemy.driverVehicleMatchIdTable[svars.thirdArrivedDriverGameObjectId]
		)
	end

	s10171_enemy.SetVehicleConvoy(mvars.waitPointArrivalList, true)

	s10171_enemy.StartTravelPlan(driverTable, nil)

	svars.isArmoredForcesLeftRallyPoint = true

	TppMission.UpdateObjective({
		objectives = { "clear_area_marker_rally" },
	})

	if DEBUG then
		TppDebug.Print2D({
			showTime = 60 * 4,
			xPos = 250,
			yPos = 550,
			text = "Finish Waiting. ChangeRoute: rts_veh_waitingPointToPfCamp",
			color = "red",
		})
	end
end

this.StarHeliMoveFromWaitingPointTimer = function()
	GkEventTimerManager.Start("Timer_HeliWaitingPoint", TIMER_HELI_WAITING_POINT_INTERVAL)
	svars.need_Timer_HeliWaitingPoint = true

	if DEBUG then
		TppDebug.Print2D({
			showTime = 60 * 4,
			xPos = 250,
			yPos = 550,
			text = "start Timer_HeliWaitingPoint",
			color = "green",
		})
	end
end

this.StartVehicleMoveFromWaitingPointTimer = function()
	if svars.isVehicleWaitTimerStarted == false then
		svars.isVehicleWaitTimerStarted = true

		GkEventTimerManager.Start("Timer_WaitingPoint", TIMER_VEH_WAITING_POINT_INTERVAL)
		svars.need_Timer_WaitingPoint = true

		if DEBUG then
			TppDebug.Print2D({
				showTime = 60 * 4,
				xPos = 250,
				yPos = 550,
				text = "start Timer_WaitingPoint",
				color = "green",
			})
		end
	end
end

this.OnHeliBroken = function(vid, brokenState)
	Fox.Log("__________Heli Broken__________ " .. vid)
	Fox.Log(" brokenState: " .. brokenState .. " Start:" .. StrCode32("Start") .. " End:" .. StrCode32("End"))
	if vid ~= GameObject.GetGameObjectId(ENEMY_HELI_NAME) then
		Fox.Log("OnHeliBroken: vid" .. tostring(vid) .. " is not enemy helicopter. Return.")
		return
	end

	if brokenState == StrCode32("Start") then
		svars.isHeliBroken = true

		TppMission.UpdateObjective({
			objectives = { "announce_destory_heli" },
		})
		this.UpdateAnnounceLogAchieveObjeciveCount()
		Fox.Log(
			"isHeliBroken:  "
				.. tostring(svars.isHeliBroken)
				.. " isTank1Broken:  "
				.. tostring(svars.isTank1Broken)
				.. " isTank1Broken:  "
				.. tostring(svars.isTank2Broken)
		)

		svars.enemyHeliState = ENEMY_HELI_STATE.LOST_CONTROL_START
	elseif brokenState == StrCode32("End") then
		this.HeliItemDrop()
		svars.enemyHeliState = ENEMY_HELI_STATE.LOST_CONTROL_END
		this.CheckMissionClear()
	end
end

function this.HeliItemDrop(continuePosition)
	Fox.Log(" ### HeliItemDrop ### ")
	local downposition = continuePosition
	if downposition == nil then
		local gameObjectId = GameObject.GetGameObjectId(ENEMY_HELI_NAME)
		local command = { id = "GetPosition" }
		downposition = GameObject.SendCommand(gameObjectId, command)
	end

	TppPickable.DropItem({
		equipId = TppEquip.EQP_IT_DevelopmentFile,
		number = SUB_TASK_BLUE_PRINT_NUMBER,
		position = downposition,
		rotation = Quat.RotationY(0),
		linearVelocity = Vector3(0, 2, 0),
		angularVelocity = Vector3(0, 2, 0),
	})
end

this.OnVehicleBroken = function(vid, brokenState)
	Fox.Log("__________Vehicle Broken__________ VehicleId: " .. vid)
	Fox.Log(
		"Tank1: "
			.. GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK1)
			.. " Tank2: "
			.. GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK2)
	)
	Fox.Log(
		"WAV: "
			.. GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV)
			.. " WAV_ADD: "
			.. GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV_ADD)
	)
	Fox.Log(" brokenState: " .. brokenState .. " Start:" .. StrCode32("Start") .. " End:" .. StrCode32("End"))
	if brokenState == StrCode32("End") then
		this.SetVehicleDestroyed(vid)
	end
end

this.SetVehicleDestroyed = function(vid)
	local isTargetEliminated = false
	if vid == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK1) then
		svars.isTank1Broken = true

		TppMission.UpdateObjective({
			objectives = { "announce_destory_tank1" },
		})
		this.UpdateAnnounceLogAchieveObjeciveCount()
		isTargetEliminated = true
	elseif vid == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK2) then
		svars.isTank2Broken = true

		TppMission.UpdateObjective({
			objectives = { "announce_destory_tank2" },
		})
		this.UpdateAnnounceLogAchieveObjeciveCount()
		isTargetEliminated = true
	elseif vid == GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV) then
		svars.isWavBroken = true

		TppMission.UpdateObjective({
			objectives = { "announce_destory_wav" },
		})
		this.UpdateAnnounceLogAchieveObjeciveCount()
		isTargetEliminated = true
	elseif vid == GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV_ADD) then
		svars.isWavAddBroken = true

		TppMission.UpdateObjective({
			objectives = { "announce_destory_wav_add" },
		})
		this.UpdateAnnounceLogAchieveObjeciveCount()
		isTargetEliminated = true
	end
	this.CheckMissionClear()
	Fox.Log(
		"isHeliBroken:  "
			.. tostring(svars.isHeliBroken)
			.. " isTank1Broken:  "
			.. tostring(svars.isTank1Broken)
			.. " isTank1Broken:  "
			.. tostring(svars.isTank2Broken)
	)
	Fox.Log(" isWavBroken:  " .. tostring(svars.isWavBroken) .. " isWavAddBroken:  " .. tostring(svars.isWavAddBroken))
	return isTargetEliminated
end

this.OnTargetRescued = function(s_characterId)
	if s_characterId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_VIP) then
		TppMission.UpdateObjective({
			objectives = { "clear_secondBonus_MissionTask" },
		})

		TppResult.AcquireSpecialBonus({
			second = { isComplete = true },
		})
	end

	Fox.Log("s10171_sequence.OnTargetRescued( " .. s_characterId .. " )")

	if s_characterId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK1) then
		svars.isTank1Rescued = true

		TppMission.UpdateObjective({
			objectives = { "announce_recover_tank1" },
		})
		this.UpdateAnnounceLogAchieveObjeciveCount()
	elseif s_characterId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_TANK2) then
		svars.isTank2Rescued = true

		TppMission.UpdateObjective({
			objectives = { "announce_recover_tank2" },
		})
		this.UpdateAnnounceLogAchieveObjeciveCount()
	elseif s_characterId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV) then
		svars.isWavRescued = true

		TppMission.UpdateObjective({
			objectives = { "announce_recover_wav" },
		})
		this.UpdateAnnounceLogAchieveObjeciveCount()
	elseif s_characterId == GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV_ADD) then
		svars.isWavAddRecovered = true

		TppMission.UpdateObjective({
			objectives = { "announce_recover_wav_add" },
		})
		this.UpdateAnnounceLogAchieveObjeciveCount()
	else
		return
	end

	this.CheckMissionClear()

	if svars.isTank1Rescued and svars.isTank2Rescued and svars.isWavRescued and svars.isWavAddCleared then
		TppMission.UpdateObjective({
			objectives = { "clear_firstBonus_MissionTask" },
		})

		TppResult.AcquireSpecialBonus({
			first = { isComplete = true },
		})
	end
end

this.UpdateAnnounceLogAchieveObjeciveCount = function()
	svars.countEliminatedTarget = svars.countEliminatedTarget + 1
	TppUI.ShowAnnounceLog("achieveObjectiveCount", svars.countEliminatedTarget, MAX_COUNT_ELIMINATING_TARGETS)
end

this.CheckMissionClear = function()
	Fox.Log(
		"isHeliBroken:  "
			.. tostring(svars.isHeliBroken)
			.. " isTank1Broken:  "
			.. tostring(svars.isTank1Broken)
			.. " isTank1Broken:  "
			.. tostring(svars.isTank2Broken)
			.. " isWavBroken:  "
			.. tostring(svars.isWavBroken)
	)
	Fox.Log(
		"isTank1Rescued:  "
			.. tostring(svars.isTank1Rescued)
			.. " isTank2Rescued:  "
			.. tostring(svars.isTank2Rescued)
			.. " isWavRescued:  "
			.. tostring(svars.isWavRescued)
	)

	this.UpdateClearStatus()
	this.UpdateBGMAndRadio()
	this.StartAdditinalWAV()
	if this.IsGoalAchieved() then
		TppSequence.SetNextSequence("Seq_Game_Escape")
	end
end

this.UpdateClearStatus = function()
	svars.isHeliCleared = svars.isHeliBroken
	if svars.isHeliCleared then
		TppMission.UpdateObjective({
			objectives = { "clear_eliminate_heli_MissionTask" },
		})
		Fox.Log("HeliCleared")
	end

	if svars.isTank1Broken or svars.isTank1Rescued then
		svars.isTank1Cleared = true
		Fox.Log("Tank1Cleared")
		TppMission.UpdateObjective({
			objectives = { "clear_eliminate_tank_swamp_marker" },
		})
	end
	if svars.isTank2Broken or svars.isTank2Rescued then
		svars.isTank2Cleared = true
		Fox.Log("Tank2Cleared")
		TppMission.UpdateObjective({
			objectives = { "clear_eliminate_tank_hill_marker" },
		})
	end
	if svars.isTank1Cleared and svars.isTank2Cleared then
		Fox.Log("Tanks Cleared")
		TppMission.UpdateObjective({
			objectives = { "clear_eliminate_tanks_MissionTask" },
		})
	end
	if svars.isWavBroken or svars.isWavRescued then
		svars.isWavCleared = true
		Fox.Log("WavHillCleared")
		TppMission.UpdateObjective({
			objectives = { "clear_eliminate_wav_hill_marker" },
		})
	end

	if svars.isWavAddBroken or svars.isWavAddRecovered then
		svars.isWavAddCleared = true
		Fox.Log("WavAddCleared")
		TppMission.UpdateObjective({
			objectives = { "clear_eliminate_wav_add_marker" },
		})
	end

	if svars.isWavCleared and svars.isWavAddCleared then
		Fox.Log("WAVs Cleared")
		TppMission.UpdateObjective({
			objectives = { "clear_eliminate_wavs_MissionTask" },
		})
	end

	if svars.isTank1Cleared then
		TppMission.UpdateObjective({
			objectives = { "clear_swamp_route" },
		})
	end

	if svars.isTank2Cleared and svars.isWavCleared then
		TppMission.UpdateObjective({
			objectives = { "clear_hill_route" },
		})
	end
end

this.IsGoalAchieved = function()
	if svars.isHeliCleared then
		if svars.isTank1Cleared and svars.isTank2Cleared and svars.isWavCleared and svars.isWavAddCleared then
			return true
		end
	end

	return false
end

this.UpdateBGMAndRadio = function()
	local numClearTarget = 0

	if svars.isHeliCleared then
		numClearTarget = numClearTarget + 1
	end
	if svars.isTank1Cleared then
		numClearTarget = numClearTarget + 1
	end
	if svars.isTank2Cleared then
		numClearTarget = numClearTarget + 1
	end
	if svars.isWavCleared then
		numClearTarget = numClearTarget + 1
	end

	if svars.isWavAddCleared then
		numClearTarget = numClearTarget + 1
	end

	if numClearTarget == 1 then
		s10171_sound.SetScene_cheer()
	elseif numClearTarget == 2 then
		s10171_sound.SetScene_wipeLeftOut()
	elseif numClearTarget == 3 then
		s10171_sound.SetScene_heli_fight()
		s10171_radio.PlayLittleMoreTargetRadio()
	elseif numClearTarget == 4 then
		s10171_radio.PlayOneTargetLeftRadio()
	end
end

this.ContinueWavAddToMoveToPfCamp = function()
	if not svars.isWavAddShown then
		Fox.Log("ContinueWavAddToMoveToPfCamp: Additional WAV is not shown yet. Call StartAdditinalWAV")
		this.StartAdditinalWAV()
		return
	end

	if svars.isWavAddGoneForSecondMove then
		Fox.Log("ContinueWavAddToMoveToPfCamp: svars.isWavAddGoneForSecondMove is true. Return")
		return
	end

	local needContinueSecondTravel = false

	if svars.isTank1Cleared and svars.isTank2Cleared and svars.isWavCleared then
		needContinueSecondTravel = true
	else
		needContinueSecondTravel = this.IsNotUseRoadToPfCamp()
	end

	if needContinueSecondTravel then
		svars.isWavAddGoneForSecondMove = true
		if svars.isWavAddUseSwampEastRoute then
			s10171_enemy.StartTravelPlan(
				{ s10171_enemy.ENEMY_WAV_ADD_SOLDIER },
				s10171_enemy.TRAVEL_TYPE.SWAMP_EAST_PFCAMP
			)
			Fox.Log("Start Travel. s10171_enemy.TRAVEL_TYPE.SWAMP_EAST_PFCAMP")
		else
			s10171_enemy.StartTravelPlan(
				{ s10171_enemy.ENEMY_WAV_ADD_SOLDIER },
				s10171_enemy.TRAVEL_TYPE.SAVANNAH_EAST_PFCAMP
			)
			Fox.Log("Start Travel. s10171_enemy.TRAVEL_TYPE.SAVANNAH_EAST_PFCAMP")
		end
	end
end

this.IsNotUseRoadToPfCamp = function()
	local isTank1NotUseWavAddRoute = false
	local isTank2NotUseWavAddRoute = false
	local isWavNotUseWavAddRoute = false

	if svars.isTank1Cleared or svars.isTank1ArrivedPfCamp then
		isTank1NotUseWavAddRoute = true
	end
	if svars.isTank2Cleared or svars.isTank2ArrivedPfCamp then
		isTank2NotUseWavAddRoute = true
	end
	if svars.isWavCleared or svars.isWavArrivedPfCamp then
		isWavNotUseWavAddRoute = true
	end

	if isTank1NotUseWavAddRoute and isTank2NotUseWavAddRoute and isWavNotUseWavAddRoute then
		return true
	end

	return false
end

this.StartAdditinalWAV = function()
	if svars.isWavAddShown then
		Fox.Log("StartAdditinalWAV: Additional WAV already shown once. Check All other vehicles are broken for Moving")
		this.ContinueWavAddToMoveToPfCamp()
		return
	end

	if svars.isTank1Cleared then
		svars.isWavAddUseSwampEastRoute = true
	elseif svars.isTank2Cleared or svars.isWavCleared then
		svars.isWavAddUseSwampEastRoute = false
	else
		Fox.Log("StartAdditinalWAV: Not targeted vehicle or heli is broken. Return")
		return
	end

	local targetDriverId = GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV_ADD_SOLDIER)
	local targetVehicleId = GameObject.GetGameObjectId(s10171_enemy.ENEMY_WAV_ADD)
	local command_target = { id = "SetRelativeVehicle", targetId = targetVehicleId, rideFromBeginning = true }

	GameObject.SendCommand({ type = "TppVehicle2" }, { id = "Respawn", name = s10171_enemy.ENEMY_WAV_ADD })
	GameObject.SendCommand(targetDriverId, { id = "SetEnabled", enabled = true })

	GameObject.SendCommand(targetDriverId, command_target)

	Fox.Log("StartAdditinalWAV")
	if svars.isWavAddUseSwampEastRoute then
		s10171_enemy.StartTravelPlan(
			{ s10171_enemy.ENEMY_WAV_ADD_SOLDIER },
			s10171_enemy.TRAVEL_TYPE.SAVANNAH_SWAMP_EAST
		)
	else
		s10171_enemy.StartTravelPlan(
			{ s10171_enemy.ENEMY_WAV_ADD_SOLDIER },
			s10171_enemy.TRAVEL_TYPE.SAVANNAH_SAVANNAH_EAST
		)
	end

	svars.isWavAddShown = true

	TppMission.UpdateObjective({
		objectives = { "attack_marker_wav_add" },
	})

	s10171_radio.NewTargetRadio()
end

sequences.Seq_Game_Escape = {

	OnEnter = function()
		TppMission.UpdateObjective({
			objectives = { "clear_area_marker_target", "end_subGoal" },
		})

		TppMission.CanMissionClear()

		this.HighInterrogation()

		s10171_sound.SetScene_target_AllClear()

		s10171_radio.PlayClearRadio()

		s10171_radio.OptionalRadioEscape()

		if DEBUG then
			TppDebug.Print2D({
				showTime = 60 * 4,
				xPos = 450,
				yPos = 250,
				text = "Seq_Game_Escape. CanMissionClear",
				color = "yellow",
			})
		end
	end,
}

return this
