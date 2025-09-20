local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local NULL_ID = GameObject.NULL_ID

local sequences = {}

local SUPPORT_HELI = "SupportHeli"
local FLEE_HOSTAGE_NAME = "hos_target_0000"
local CONVOY_HOSTAGE_NAME = "hos_target_0001"
local HILL_VEHICLE_NAME = "veh_s10085_LV1"
local CHECKPOINT_VEHICLE_NAME = "veh_s10085_LV2"

local TIMER_HOSTAGE_RUNAWAY_WAIT = 28
local TIMER_CHASE_HOSTAGE_CHECKPOINT_WAIT = 68

local PHOTO_NAME = {
	FLEE_HOSTAGE = 10,
	CONVOY_HOSTAGE = 20,
	TENT = 30,
}

local taskContainerIdTable = {
	"hillNorth_cntn001",
	"hillNorth_cntn002",
	"hillNorth_cntn003",
	"hillNorth_cntn004",
}
local NUM_CONTAINER_RECOVER_SUB_TASK = 4
local NUM_NUBIAN_RECOVER_BONUS_TASK = 6
local NUM_VEHICLE_RECOVER_BONUS_TASK = 2
local NUBIAN_AREA_NAME = "factory_S"

local EVENT_DOOR_NAME = "mafr_fenc005_door001_gim_n0001|srt_mafr_fenc005_door001"
local EVENT_DOOR_PATH = "/Assets/tpp/level/location/mafr/block_large/hill/mafr_hill_asset.fox2"

local MAX_COUNT_RESCUE_TARGET = 2

local fleeHostageMonologueTable = {
	"speech085_carry010_00",
	"speech085_carry010_01",
	"speech085_carry010_02",
	"speech085_carry010_03",
	"speech085_carry010_04",
	"speech085_carry010_05",
	"speech085_carry010_06",
	"speech085_carry010_07",
	"speech085_carry010_08",
	"speech085_carry010_09",
	"speech085_carry010_10",
	"speech085_carry010_11",
	"speech085_carry010_12",
	"speech085_carry010_13",
}
local FLEE_HOSTAGE_MONOLOGUE_CONTINUED_INDEX = 8

local convoyHostageMonologueTable = {
	"speech085_carry030_00",
	"speech085_carry030_01",
	"speech085_carry030_02",
	"speech085_carry030_03",
	"speech085_carry030_04",
	"speech085_carry030_05",
	"speech085_carry030_06",
	"speech085_carry030_07",
	"speech085_carry030_08",
	"speech085_carry030_09",
	"speech085_carry030_10",
	"speech085_carry030_11",
	"speech085_carry030_12",
	"speech085_carry030_13",
	"speech085_carry030_14",
	"speech085_carry030_15",
}
local CONVOY_HOSTAGE_MONOLOGUE_CONTINUED_INDEX = 11

this.MAX_PLACED_LOCATOR_COUNT = 20

this.MISSIONTASK_LIST = {
	MAIN_FIRST = 0,
	MAIN_SECOND = 1,
	BONUS_FIRST = 2,
	BONUS_SECOND = 3,
	SUB_FIRST = 4,
	SUB_SECOND = 5,
	SUB_THIRD = 6,
}

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

function this.OnLoad()
	Fox.Log("#### s10085_sequence.OnLoad() ####")

	TppSequence.RegisterSequences({

		"Seq_Game_MainGame",
		"Seq_Game_Escape",
		nil,
	})
	TppSequence.RegisterSequenceTable(sequences)
end

this.saveVarsList = {

	isFleeHostageRescued = false,
	isConvoyHostageRescued = false,

	isConvoyHostageMissed = false,
	isFleeHostageMissed = false,

	isFleeHostageFlee = false,

	isConvoyHostageAway = false,

	isConvoyPositionKnown = false,

	isHostageNotInTentKnown = false,

	isConvoyHostageMarked = false,

	isFleeHostageDead = false,
	isConvoyHostageDead = false,

	isConvoySolider1_Dead = false,
	isConvoySolider2_Dead = false,

	isFirstLightVehicleRecovered = false,
	isSecondLightVehicleRecovered = false,

	numContainerRecovered = 0,

	numNubianRecovered = 0,

	fleeHostageMonologueNum = 1,
	convoyHostageMonologueNum = 1,
	isFleeHostageMonologuePlayed = false,
	isConvoyHostageMonologuePlayed = false,

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

	countRescuedTargets = 0,

	need_Timer_HostageRunAway = false,

	need_Timer_ChaseHostageFromCheckpoint = false,

	isIgnoreNoticeExceptForPlayer = true,

	need_SetFollowed = false,
}

this.baseList = {
	"factorySouth",
	"hill",
	"hillNorth",
	"hillWest",
	"hillWestNear",
	nil,
}

this.REVENGE_MINE_LIST = { "mafr_hill" }
this.MISSION_REVENGE_MINE_LIST = {
	["mafr_hill"] = {
		decoyLocatorList = {
			"itm_revDecoy_factorySouth_a_0000",
		},

		["trap_mafr_hill_mine_factorySouth"] = {
			mineLocatorList = {
				"itm_revMine_factorySouth_a_0000",
				"itm_revMine_factorySouth_a_0001",
				"itm_revMine_factorySouth_a_0002",
				"itm_revMine_factorySouth_a_0003",
			},
		},
	},
}

this.missionObjectiveDefine = {
	Area_hosTarget_flee = {
		gameObjectName = "Marker_hosTarget_0000",
		visibleArea = 5,
		randomRange = 0,
		setNew = false,
		viewType = "all",
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
		mapRadioName = "f1000_mprg0170",
		targetBgmCp = "s10085_interrogator_cp",
	},
	clear_Area_hosTarget_flee = {},
	Area_hosTarget_convoy = {
		gameObjectName = "Marker_hosTarget_convoy",
		visibleArea = 1,
		randomRange = 0,
		setNew = false,
		viewType = "all",
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
		mapRadioName = "s0085_mprg0020",
		targetBgmCp = "mafr_hill_cp",
	},
	clear_Area_hosTarget_convoy = {},
	hostage_Target_flee = {
		gameObjectName = FLEE_HOSTAGE_NAME,
		goalType = "defend",
		viewType = "map_and_world_only_icon",
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_target",
	},
	hostage_Target_convoy = {
		gameObjectName = CONVOY_HOSTAGE_NAME,
		goalType = "defend",
		viewType = "map_and_world_only_icon",
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_target",
	},

	default_photo_flee = {
		photoId = PHOTO_NAME.FLEE_HOSTAGE,
		addFirst = true,
		addSecond = false,
		photoRadioName = "s0085_mirg0010",
	},
	default_photo_convoy = {
		photoId = PHOTO_NAME.CONVOY_HOSTAGE,
		addFirst = true,
		addSecond = false,
		photoRadioName = "s0085_mirg0020",
	},
	default_photo_tent = {
		photoId = PHOTO_NAME.TENT,
		addFirst = false,
		addSecond = false,
		photoRadioName = "s0085_mirg0030",
	},
	clear_photo_tent = {
		photoId = PHOTO_NAME.TENT,
		addFirst = false,
		addSecond = false,
	},

	hud_photo_flee = {
		hudPhotoId = PHOTO_NAME.FLEE_HOSTAGE,
	},
	hud_photo_convoy = {
		hudPhotoId = PHOTO_NAME.CONVOY_HOSTAGE,
	},

	default_subGoal = {
		subGoalId = 0,
	},
	end_subGoal = {
		subGoalId = 1,
	},

	rescueFleeHostage_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_FIRST, isNew = true, isComplete = false },
	},
	rescueConvoyHostage_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SECOND, isNew = true, isComplete = false },
	},
	clear_rescueFleeHostage_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_FIRST, isNew = false, isComplete = true },
	},
	clear_rescueConvoyHostage_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SECOND, isNew = false, isComplete = true },
	},

	firstBonus_MissionTask = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.BONUS_FIRST,
			isNew = true,
			isComplete = false,
			isFirstHide = true,
		},
	},
	Area_task_nubian = {
		gameObjectName = "Marker_task_Animal",
		visibleArea = 3,
		randomRange = 0,
		setNew = true,
		viewType = "map_only_icon",
		announceLog = "updateMap",
		langId = "marker_area_wildlife",
		goalType = "none",
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
	},

	firstSub_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_FIRST, isNew = true, isComplete = false, isFirstHide = true },
	},
	secondSub_MissionTask = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SUB_SECOND,
			isNew = true,
			isComplete = false,
			isFirstHide = true,
		},
	},
	Area_task_plant = {
		gameObjectName = "Marker_task_Plant",
		visibleArea = 1,
		randomRange = 0,
		setNew = true,
		viewType = "map_only_icon",
		announceLog = "updateMap",
		langId = "marker_area_medicinal_plant",
		goalType = "none",
	},
	thirdSub_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_THIRD, isNew = true, isComplete = false, isFirstHide = true },
	},
	Area_task_bird = {
		gameObjectName = "Marker_task_Bird",
		visibleArea = 4,
		randomRange = 0,
		setNew = true,
		viewType = "map_only_icon",
		announceLog = "updateMap",
		langId = "marker_area_wildlife",
		goalType = "none",
	},
	clear_firstSub_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_FIRST, isNew = false, isComplete = true },
	},
	clear_secondSub_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_SECOND, isNew = false, isComplete = true },
	},
	clear_thirdSub_MissionTask = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_THIRD, isNew = false, isComplete = true },
	},

	announce_rescue_flee_hostage = {
		announceLog = "recoverTarget",
	},
	announce_rescue_convoy_hostage = {
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
	clear_Area_hosTarget_flee = {
		Area_hosTarget_flee = {},
	},
	clear_Area_hosTarget_convoy = {
		Area_hosTarget_convoy = {},
	},
	clear_rescueFleeHostage_MissionTask = {
		rescueFleeHostage_MissionTask = {},
	},
	clear_rescueConvoyHostage_MissionTask = {
		rescueConvoyHostage_MissionTask = {},
	},
	clear_firstBonus_MissionTask = {
		firstBonus_MissionTask = {},
		Area_task_nubian = {},
	},
	clear_secondBonus_MissionTask = {
		secondBonus_MissionTask = {},
	},
	clear_firstSub_MissionTask = {
		firstSub_MissionTask = {},
	},
	clear_secondSub_MissionTask = {
		secondSub_MissionTask = {},
		Area_task_plant = {},
	},
	clear_thirdSub_MissionTask = {
		thirdSub_MissionTask = {},
		Area_task_bird = {},
	},
	clear_photo_tent = {
		default_photo_tent = {},
	},
}

this.missionObjectiveEnum = Tpp.Enum({
	"Area_hosTarget_flee",
	"clear_Area_hosTarget_flee",
	"Area_hosTarget_convoy",
	"clear_Area_hosTarget_convoy",
	"hostage_Target_flee",
	"hostage_Target_convoy",
	"default_photo_flee",
	"default_photo_convoy",
	"default_photo_tent",
	"clear_photo_tent",
	"hud_photo_flee",
	"hud_photo_convoy",
	"default_subGoal",
	"end_subGoal",
	"rescueFleeHostage_MissionTask",
	"rescueConvoyHostage_MissionTask",
	"clear_rescueFleeHostage_MissionTask",
	"clear_rescueConvoyHostage_MissionTask",
	"clear_firstSub_MissionTask",
	"firstBonus_MissionTask",
	"Area_task_nubian",
	"secondBonus_MissionTask",
	"clear_firstBonus_MissionTask",
	"clear_secondBonus_MissionTask",
	"firstSub_MissionTask",
	"secondSub_MissionTask",
	"Area_task_plant",
	"thirdSub_MissionTask",
	"Area_task_bird",
	"clear_firstSub_MissionTask",
	"clear_secondSub_MissionTask",
	"clear_thirdSub_MissionTask",
	"announce_rescue_flee_hostage",
	"announce_rescue_convoy_hostage",
})

this.missionStartPosition = {
	helicopterRouteList = {
		"lz_drp_hillNorth_W0000|rt_drp_hillNorth_W_0000",
		"lz_drp_hillWest_S0000|lz_drp_hillWest_S_0000",
		"lz_drp_hill_I0000|rt_drp_hill_I_0000",
	},
	orderBoxList = {
		"box_s10085_00",
		"box_s10085_01",
	},
}

this.VARIABLE_TRAP_SETTING = {

	{ name = "trap_startRunAway", type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.ENABLE },
	{
		name = "trap_interrogatorApproach",
		type = TppDefine.TRAP_TYPE.NORMAL,
		initialState = TppDefine.TRAP_STATE.ENABLE,
	},
	{ name = "trap_interrogatorStart", type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.ENABLE },
	{
		name = "trap_convoyHostageMissed",
		type = TppDefine.TRAP_TYPE.NORMAL,
		initialState = TppDefine.TRAP_STATE.ENABLE,
	},
	{ name = "trap_playerTentInside", type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.ENABLE },
}

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	TppMission.RegisterMissionSystemCallback({

		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,
		OnGameOver = this.OnGameOver,
		OnEstablishMissionClear = this.OnEstablishMissionClear,

		OnRecovered = this.OnTargetRescued,

		OnSetMissionFinalScore = this.OnSetMissionFinalScore,
	})

	TppLocation.RegistMissionAssetInitializeTable(this.s10085_baseOnActiveTable)

	TppMarker.SetUpSearchTarget({
		{
			gameObjectName = FLEE_HOSTAGE_NAME,
			gameObjectType = "TppHostage2",
			messageName = FLEE_HOSTAGE_NAME,
			skeletonName = "SKL_004_HEAD",
			func = this.commonUpdateMarkerTargetFound,
			objectives = { "hostage_Target_flee", "hud_photo_flee" },
		},
		{
			gameObjectName = CONVOY_HOSTAGE_NAME,
			gameObjectType = "TppHostageUnique2",
			messageName = CONVOY_HOSTAGE_NAME,
			skeletonName = "SKL_004_HEAD",
			func = this.commonUpdateMarkerTargetFound,
			objectives = { "hostage_Target_convoy", "hud_photo_convoy" },
		},
	})

	TppRatBird.EnableRat()
	TppRatBird.EnableBird("TppEagle")
end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	mvars.deadHostageName = nil

	TppRevenge.RegisterMissionMineList(this.MISSION_REVENGE_MINE_LIST)
end

function this.OnEstablishMissionClear(missionClearType)
	Fox.Log("*** " .. tostring(missionClearType) .. " OnEstablishMissionClear ***")

	s10085_radio.BlackTelephoneRadio()

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

function this.OnSetMissionFinalScore(missionClearType)
	if vars.playerVehicleGameObjectId ~= NULL_ID then
		this.OnTargetRescued(vars.playerVehicleGameObjectId)
	end
end

this.s10085_baseOnActiveTable = {
	mafr_hill = function()
		Fox.Log("s10085_baseOnActiveTable : mafr_hill")
		Gimmick.SetEventDoorLock(EVENT_DOOR_NAME, EVENT_DOOR_PATH, false, 0)
	end,
}

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
					if collectionUniqueId == TppCollection.GetUniqueIdByLocatorName("col_herb_l_s10085_0000") then
						TppMission.UpdateObjective({
							objectives = { "clear_secondSub_MissionTask" },
						})
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
		GameObject = {

			{ msg = "Fulton", func = this.OnFultonRecovered },

			{ msg = "PlacedIntoVehicle", sender = FLEE_HOSTAGE_NAME, func = this.OnPlacedVehicle },
			{ msg = "PlacedIntoVehicle", sender = CONVOY_HOSTAGE_NAME, func = this.OnPlacedVehicle },

			{ msg = "Dead", sender = FLEE_HOSTAGE_NAME, func = this.OnTargetDead },
			{ msg = "Dead", sender = CONVOY_HOSTAGE_NAME, func = this.OnTargetDead },

			{ msg = "Carried", sender = FLEE_HOSTAGE_NAME, func = this.PlayCarryMonologue },
			{ msg = "Carried", sender = CONVOY_HOSTAGE_NAME, func = this.PlayCarryMonologue },

			{ msg = "MonologueEnd", func = this.PlayCarryMonologueContinued },

			{ msg = "RoutePoint2", sender = s10085_enemy.TENT_GUARD_SOLDIER_1_NAME, func = this.HandleRouteEvent },
			{ msg = "RoutePoint2", sender = s10085_enemy.TENT_GUARD_SOLDIER_2_NAME, func = this.HandleRouteEvent },

			{ msg = "RoutePoint2", sender = s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, func = this.HandleRouteEvent },
			{ msg = "RoutePoint2", sender = s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, func = this.HandleRouteEvent },
			{
				msg = "RoutePoint2",
				sender = s10085_enemy.CHECKPOINT_REINFORCE_SOLDIER_1_NAME,
				func = this.HandleRouteEvent,
			},
			{
				msg = "RoutePoint2",
				sender = s10085_enemy.CHECKPOINT_REINFORCE_SOLDIER_2_NAME,
				func = this.HandleRouteEvent,
			},

			{ msg = "RoutePoint2", sender = FLEE_HOSTAGE_NAME, func = this.HandleRouteEvent },
			{ msg = "RoutePoint2", sender = CONVOY_HOSTAGE_NAME, func = this.HandleRouteEvent },
			{ msg = "ConversationEnd", func = this.OnConvesationEnd },

			{
				msg = "RouteEventFaild",
				sender = { s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, s10085_enemy.CHECKPOINT_REINFORCE_SOLDIER_2_NAME },
				func = function(gameObjectId, routeId, failureType)
					Fox.Log("route event faild " .. routeId)

					if failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_LOST_HOSTAGE_PUT_IN_VEHICLE then
						Fox.Log("ROUTE_EVENT_FAILED_TYPE_LOST_HOSTAGE_PUT_IN_VEHICLE: hostage is missed")
						this.SetInterrogatorSoldierSearchConvoyHostage()
					elseif failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_LOST_HOSTAGE_TAKE_OUT_OF_VEHICLE then
						Fox.Log("ROUTE_EVENT_FAILED_TYPE_LOST_HOSTAGE_TAKE_OUT_OF_VEHICLE: hostage is missed")
						this.SetInterrogatorSoldierFindHostageInHill()
					elseif failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_LOST_VEHICLE_HOSTAGE_PUT_IN then
						Fox.Log("ROUTE_EVENT_FAILED_TYPE_LOST_HOSTAGE_PUT_IN_VEHICLE: vehicle is missed")
						this.StartWalkConvoyForHill()
					elseif failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_LOST_VEHICLE_HOSTAGE_TAKE_OUT_OF then
						Fox.Log("ROUTE_EVENT_FAILED_TYPE_LOST_HOSTAGE_TAKE_OUT_OF_VEHICLE: vehicle is missed")
						this.GetIntoHill()
					end
				end,
			},
		},
		Timer = {
			{

				msg = "Finish",
				sender = "Timer_HostageRunAway",
				func = function()
					svars.need_Timer_HostageRunAway = false

					this.SetSneakRouteHostage(FLEE_HOSTAGE_NAME, "rts_hostage_runAway")

					GkEventTimerManager.Start("Timer_ChaseHostageFromCheckpoint", TIMER_CHASE_HOSTAGE_CHECKPOINT_WAIT)

					svars.need_Timer_ChaseHostageFromCheckpoint = true
				end,
			},
			{

				msg = "Finish",
				sender = "Timer_ChaseHostageFromCheckpoint",
				func = function()
					svars.need_Timer_ChaseHostageFromCheckpoint = false

					this.SetSneakCautionRouteSoldier(
						s10085_enemy.CHECKPOINT_REINFORCE_SOLDIER_1_NAME,
						"rts_veh_checkpointReinforce"
					)
					this.SetSneakCautionRouteSoldier(
						s10085_enemy.CHECKPOINT_REINFORCE_SOLDIER_2_NAME,
						"rts_veh_checkpointReinforce"
					)

					s10085_enemy.SetHostageMovingNoticeTrap(FLEE_HOSTAGE_NAME)
				end,
			},
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
		Trap = {
			{

				msg = "Enter",
				sender = "trap_startRunAway",
				func = function()
					Fox.Log("Enter trap_startRunAway")

					GkEventTimerManager.Start("Timer_HostageRunAway", TIMER_HOSTAGE_RUNAWAY_WAIT)

					svars.need_Timer_HostageRunAway = true

					TppEnemy.SetSneakRoute(s10085_enemy.TENT_BACK_SOLDIER_NAME, "rts_hangOut_fromTentBack")
					TppEnemy.SetSneakRoute(s10085_enemy.TENT_GUARD_SOLDIER_1_NAME, "rts_hangOut_0000")
					TppEnemy.SetSneakRoute(s10085_enemy.TENT_GUARD_SOLDIER_2_NAME, "rts_hangOut_0001")

					TppTrap.Disable("trap_startRunAway")
				end,
			},
			{

				msg = "Enter",
				sender = "trap_interrogatorStart",
				func = function()
					Fox.Log("Enter trap_interrogatorStart")
					s10085_enemy.StartTravelPlan(
						{ s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, s10085_enemy.INTERROGATOR_SOLDIER_2_NAME },
						s10085_enemy.TRAVEL_TYPE.HILL_TO_WAIT
					)

					this.SetSneakCautionRouteSoldier(
						s10085_enemy.CHECKPOINT_REINFORCE_SOLDIER_1_NAME,
						"rts_veh_checkpoint"
					)
					this.SetSneakCautionRouteSoldier(
						s10085_enemy.CHECKPOINT_REINFORCE_SOLDIER_2_NAME,
						"rts_veh_checkpoint"
					)

					s10085_radio.PlayConvoyTroopsStarted()

					TppTrap.Disable("trap_interrogatorStart")
				end,
			},
			{

				msg = "Enter",
				sender = "trap_interrogatorApproach",
				func = function()
					Fox.Log("Enter trap_interrogatorApproach")
					s10085_enemy.StartTravelPlan(
						{ s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, s10085_enemy.INTERROGATOR_SOLDIER_2_NAME },
						s10085_enemy.TRAVEL_TYPE.WAIT_TO_FACTORYSOUTH
					)

					TppTrap.Disable("trap_interrogatorApproach")
				end,
			},
			{

				msg = "Enter",
				sender = "trap_convoyHostageMissed",
				func = this.HostateEnterTent,
			},
			{

				msg = "Exit",
				sender = "trap_convoyHostageMissed",
				func = this.HostateExitTent,
			},
			{

				msg = "Enter",
				sender = "trap_playerTentInside",
				func = this.ProcessPlayerTentInside,
			},
			nil,
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
		nil,
	})
end

this.HostateExitTent = function(trapName, hostageGameObject)
	this.UpdateHostateInTentFlag(trapName, hostageGameObject, true)
end
this.HostateEnterTent = function(trapName, hostageGameObject)
	this.UpdateHostateInTentFlag(trapName, hostageGameObject, false)
end
this.UpdateHostateInTentFlag = function(trapName, hostageGameObject, isExit)
	Fox.Log(
		"trap_convoyHostageMissed. trapName: "
			.. tostring(trapName)
			.. " hostageGameObject "
			.. tostring(hostageGameObject)
			.. " Exit ? "
			.. tostring(isExit)
	)
	if hostageGameObject == GameObject.GetGameObjectId(FLEE_HOSTAGE_NAME) then
		svars.isFleeHostageMissed = isExit
	elseif hostageGameObject == GameObject.GetGameObjectId(CONVOY_HOSTAGE_NAME) then
		svars.isConvoyHostageMissed = isExit
	end

	if svars.isFleeHostageMissed and svars.isConvoyHostageMissed then
		TppRadio.ChangeIntelRadio(s10085_radio.intelRadioListTentOff)
	end
end

this.ProcessPlayerTentInside = function()
	if s10085_sequence.CanBeEscaped() then
		Fox.Log("#### s10085_radio.PlayHostageNotInTent. No Playing Radio. CanBeEscaped ####")
		return
	end

	if svars.isFleeHostageMissed and svars.isConvoyHostageMissed then
		if svars.isConvoyHostageAway and svars.isConvoyHostageMarked == false then
			s10085_radio.PlayHostageNotInTent()

			svars.isHostageNotInTentKnown = true

			s10085_radio.OptionalRadioRescueOneHostage()

			TppTrap.Disable("trap_playerTentInside")
		end
	end
end

this.ConversationStart = function(param)
	if param == StrCode32("visitTent") then
	elseif param == StrCode32("convoy") then
		if svars.isConvoyHostageRescued == false then
			if TppEnemy.GetLifeStatus(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME) < TppEnemy.LIFE_STATUS.DEAD then
				this.SetSneakCautionRouteSoldier(
					s10085_enemy.HILL_GUARD_CONV_SOLDIER_NAME,
					"rts_conversation_hillArrival_caller"
				)
				this.SetSneakCautionRouteSoldier(
					s10085_enemy.INTERROGATOR_SOLDIER_1_NAME,
					"rts_conversation_hillArrival_callee"
				)
				this.SetSneakCautionRouteSoldier(
					s10085_enemy.INTERROGATOR_SOLDIER_2_NAME,
					"rts_conversation_hillArrival_calleeWait"
				)
			else
				this.SetSneakCautionRouteSoldier(
					s10085_enemy.HILL_GUARD_CONV_SOLDIER_NAME,
					"rts_conversation_hillArrival_caller_sub"
				)
				this.SetSneakCautionRouteSoldier(
					s10085_enemy.INTERROGATOR_SOLDIER_2_NAME,
					"rts_conversation_hillArrival_callee"
				)
				this.SetSneakCautionRouteSoldier(
					s10085_enemy.INTERROGATOR_SOLDIER_1_NAME,
					"rts_conversation_hillArrival_calleeWait"
				)
			end
		else
			this.SetInterrogatorSoldierFindHostageInHill()
		end

		this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "")
	end
end

this.ConversationWaitEnd = function(param)
	this.ChangeRouteAfterConversation(param)
end

this.OnConvesationEnd = function(gameObjectId, label, isSucceed)
	Fox.Log("OnConvesationEnd: gameObjectId " .. gameObjectId .. " label " .. label)
	if label == StrCode32("speech085_EV010") then
		this.ChangeRouteAfterConversation(StrCode32("visitTent"))
	elseif label == StrCode32("speech085_EV030") then
		this.ChangeRouteAfterConversation(StrCode32("convoy"))
	end
end

this.ChangeRouteAfterConversation = function(param)
	Fox.Log("ChangeRouteAfterConversation " .. tostring(param))

	if param == StrCode32("visitTent") then
		if TppEnemy.GetLifeStatus(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME) < TppEnemy.LIFE_STATUS.DEAD then
			this.SetAllPhaseRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_walk_interrogator_approachTent")
			TppEnemy.SetSneakRoute(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_walk_interrogator_approachTent_wait")
			TppEnemy.SetCautionRouteSoldier(
				s10085_enemy.INTERROGATOR_SOLDIER_2_NAME,
				"rts_walk_interrogator_approachTent_wait_c"
			)
		else
			this.SetAllPhaseRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_walk_interrogator_approachTent")
			TppEnemy.SetSneakRoute(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_walk_interrogator_approachTent_wait")
			TppEnemy.SetCautionRouteSoldier(
				s10085_enemy.INTERROGATOR_SOLDIER_1_NAME,
				"rts_walk_interrogator_approachTent_wait_c"
			)
		end

		TppEnemy.SetSneakRoute(s10085_enemy.TENT_GUARD_SOLDIER_1_NAME, "rts_tentGuard_0000")
		TppEnemy.SetSneakRoute(s10085_enemy.TENT_GUARD_SOLDIER_2_NAME, "rts_tentGuard_0001")
		TppEnemy.SetSneakRoute(s10085_enemy.TENT_BACK_SOLDIER_NAME, "rts_factorySouth_tentBack")
		TppEnemy.SetCautionRouteSoldier(s10085_enemy.TENT_GUARD_SOLDIER_1_NAME, "rts_tentGuard_c_0000")
		TppEnemy.SetCautionRouteSoldier(s10085_enemy.TENT_GUARD_SOLDIER_2_NAME, "rts_tentGuard_c_0001")
		TppEnemy.SetCautionRouteSoldier(s10085_enemy.TENT_BACK_SOLDIER_NAME, "rts_factorySouth_tentBack_c")
	elseif param == StrCode32("convoy") then
		this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_hillConvoy")
		this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_hillConvoy")

		this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "rts_hillConvoy")

		TppEnemy.SetSneakRoute(s10085_enemy.HILL_GUARD_CONV_SOLDIER_NAME, "rts_hill_guardForConversation")
		TppEnemy.SetCautionRoute(s10085_enemy.HILL_GUARD_CONV_SOLDIER_NAME, "rts_hill_guardForConversation_c")
	end
end

this.GetFirstGameObjectIdUsingRoute = function(routeName)
	local gameObjectId = { type = "TppSoldier2" }
	local command = { id = "GetGameObjectIdUsingRoute", route = routeName }
	local soldiers = GameObject.SendCommand(gameObjectId, command)
	Fox.Log(#soldiers)
	for i, soldier in ipairs(soldiers) do
		return soldier
	end
end

this.SetConversation = function(speakerGameObjectId, friendGameObjectId, speechLabel)
	Fox.Log("*** SetConversation ***")
	if Tpp.IsTypeString(speakerGameObjectId) then
		speakerGameObjectId = GameObject.GetGameObjectId(speakerGameObjectId)
	end
	if Tpp.IsTypeString(friendGameObjectId) then
		friendGameObjectId = GameObject.GetGameObjectId(friendGameObjectId)
	end
	if speakerGameObjectId == NULL_ID or friendGameObjectId == NULL_ID then
		Fox.Log("SetConversation. GameObjectId is Null")
		return
	end

	local command = { id = "CallConversation", label = speechLabel, friend = friendGameObjectId }
	GameObject.SendCommand(speakerGameObjectId, command)
end

this.OnPlacedVehicle = function(arg1, arg2)
	if arg2 == GameObject.GetGameObjectId(SUPPORT_HELI) then
		this.OnTargetRescued(arg1)
	end
end

this.OnTargetRescued = function(s_gameObjectId)
	Fox.Log("s10085_sequence.OnTargetRescued( " .. s_gameObjectId .. " )")

	local isMissionTargetRescued = false

	if s_gameObjectId == GameObject.GetGameObjectId(FLEE_HOSTAGE_NAME) then
		if TppMarker.GetSearchTargetIsFound(FLEE_HOSTAGE_NAME) == true then
			Fox.Log("already Important Marker ... Nothing Done !!")
		else
			TppSoundDaemon.PostEvent("sfx_s_enemytag_main_tgt")
			TppMission.UpdateObjective({ objectives = { "hud_photo_flee" } })
		end

		if svars.isFleeHostageRescued then
			Fox.Log("OnTargetRescued: FLEE_HOSTAGE_NAME is already rescued. return")
			return
		end

		svars.isFleeHostageRescued = true

		if svars.isConvoyHostageRescued == false and svars.isConvoyHostageDead == false then
			s10085_radio.PlayAfterRescueOneHostage()
		end

		TppMission.UpdateObjective({
			objectives = { "announce_rescue_flee_hostage" },
		})

		svars.countRescuedTargets = svars.countRescuedTargets + 1
		TppUI.ShowAnnounceLog("achieveObjectiveCount", svars.countRescuedTargets, MAX_COUNT_RESCUE_TARGET)

		TppMission.UpdateObjective({
			objectives = { "clear_rescueFleeHostage_MissionTask" },
		})

		if svars.isConvoyHostageAway and svars.isConvoyHostageMarked then
			TppMission.UpdateObjective({
				objectives = { "clear_Area_hosTarget_flee" },
			})
		end

		isMissionTargetRescued = true
	elseif s_gameObjectId == GameObject.GetGameObjectId(CONVOY_HOSTAGE_NAME) then
		if TppMarker.GetSearchTargetIsFound(CONVOY_HOSTAGE_NAME) == true then
			Fox.Log("already Important Marker ... Nothing Done !!")
		else
			TppSoundDaemon.PostEvent("sfx_s_enemytag_main_tgt")
			TppMission.UpdateObjective({ objectives = { "hud_photo_convoy" } })
		end

		if svars.isConvoyHostageRescued then
			Fox.Log("OnTargetRescued: CONVOY_HOSTAGE_NAME is already rescued. return")
			return
		end

		svars.isConvoyHostageRescued = true

		TppMission.UpdateObjective({
			objectives = { "announce_rescue_convoy_hostage" },
		})

		svars.countRescuedTargets = svars.countRescuedTargets + 1
		TppUI.ShowAnnounceLog("achieveObjectiveCount", svars.countRescuedTargets, MAX_COUNT_RESCUE_TARGET)

		TppMission.UpdateObjective({
			objectives = { "clear_Area_hosTarget_convoy" },
		})

		if svars.isFleeHostageRescued == false and svars.isFleeHostageDead == false then
			s10085_radio.PlayAfterRescueOneHostage()
		end

		TppRadio.ChangeIntelRadio(s10085_radio.intelRadioListConvoyTroopsOff)

		TppMission.UpdateObjective({
			objectives = { "clear_rescueConvoyHostage_MissionTask" },
		})

		isMissionTargetRescued = true
	elseif Tpp.IsVehicle(s_gameObjectId) then
		Fox.Log("*** OnTargetRescued Vehicle ***" .. tostring(s_gameObjectId))
		if s_gameObjectId == GameObject.GetGameObjectId(HILL_VEHICLE_NAME) then
			svars.isFirstLightVehicleRecovered = true
		elseif s_gameObjectId == GameObject.GetGameObjectId(CHECKPOINT_VEHICLE_NAME) then
			svars.isSecondLightVehicleRecovered = true
		end
		if svars.isFirstLightVehicleRecovered == true and svars.isSecondLightVehicleRecovered == true then
			TppMission.UpdateObjective({
				objectives = {
					"clear_secondBonus_MissionTask",
				},
			})

			TppResult.AcquireSpecialBonus({
				second = { isComplete = true },
			})
		end
	else
		return
	end

	if isMissionTargetRescued then
		s10085_radio.OptionalRadioRescueOneHostage()

		this.ProcessGameEscape()
	end
end

this.OnFultonRecovered = function(s_gameObjectId)
	Fox.Log("s10085_sequence.OnFultonRecovered( " .. s_gameObjectId .. " )")

	if Tpp.IsFultonContainer(s_gameObjectId) then
		Fox.Log("*** this.Messages Fulton Container ***")
		for i, gimmickId in pairs(taskContainerIdTable) do
			local ret, gameObjectId = TppGimmick.GetGameObjectId(gimmickId)
			if gameObjectId == NULL_ID then
				Fox.Error("Cannot get gameObjectId. gimmickId = " .. tostring(gimmickId))
			else
				if s_gameObjectId == gameObjectId then
					svars.numContainerRecovered = svars.numContainerRecovered + 1

					if svars.numContainerRecovered == NUM_CONTAINER_RECOVER_SUB_TASK then
						TppMission.UpdateObjective({
							objectives = {
								"clear_firstSub_MissionTask",
							},
						})
					end
				end
			end
		end
	elseif Tpp.IsAnimal(s_gameObjectId) then
		Fox.Log("*** this.Messages Fulton Animal ***")
		local animalType = GameObject.GetTypeIndex(s_gameObjectId)

		if animalType == TppGameObject.GAME_OBJECT_TYPE_NUBIAN then
			if TppAnimalBlock.GetCurrentAnimalBlockAreaName() == NUBIAN_AREA_NAME then
				svars.numNubianRecovered = svars.numNubianRecovered + 1
				if svars.numNubianRecovered == NUM_NUBIAN_RECOVER_BONUS_TASK then
					TppMission.UpdateObjective({
						objectives = {
							"clear_firstBonus_MissionTask",
						},
					})

					TppResult.AcquireSpecialBonus({
						first = { isComplete = true },
					})
				end
			end
		elseif animalType == TppGameObject.GAME_OBJECT_TYPE_EAGLE then
			TppMission.UpdateObjective({
				objectives = {
					"clear_thirdSub_MissionTask",
				},
			})
		end
	end
end

function this.commonUpdateMarkerTargetFound(messageName, gameObjectId, msg)
	Fox.Log("*** commonUpdateMarkerTargetFound ***")

	if gameObjectId == GameObject.GetGameObjectId(FLEE_HOSTAGE_NAME) then
		if svars.isFleeHostageFlee == false then
			TppRadio.ChangeIntelRadio(s10085_radio.intelRadioListFleeHosMarkedTarget)
		end
		s10085_radio.PlayUpdateFleeHostageMarketTarget()
	else
		TppRadio.ChangeIntelRadio(s10085_radio.intelRadioListConvoyHosMarkedTarget)
		s10085_radio.PlayUpdateWomanHostageMarketTarget()
	end
end

this.CanBeEscaped = function()
	Fox.Log("CanBeEscaped")

	if svars.isFleeHostageRescued == true and svars.isConvoyHostageRescued == true then
		return true
	end

	return false
end

this.OnTargetDead = function(s_gameObjectId, killerId)
	Fox.Log("s10085_sequence.OnTargetDead( " .. s_gameObjectId .. " )")
	Fox.Log("killerId: " .. killerId)

	if s_gameObjectId == GameObject.GetGameObjectId(FLEE_HOSTAGE_NAME) then
		svars.isFleeHostageDead = true
		mvars.deadHostageName = FLEE_HOSTAGE_NAME
	elseif s_gameObjectId == GameObject.GetGameObjectId(CONVOY_HOSTAGE_NAME) then
		svars.isConvoyHostageDead = true
		mvars.deadHostageName = CONVOY_HOSTAGE_NAME
	elseif s_gameObjectId == GameObject.GetGameObjectId(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME) then
		svars.isConvoySolider1_Dead = true
	elseif s_gameObjectId == GameObject.GetGameObjectId(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME) then
		svars.isConvoySolider2_Dead = true
	end
	local didPlayerKillTargetHostage = (killerId == GameObject.GetGameObjectId("Player"))

	this.ProcessGameOver(didPlayerKillTargetHostage)

	if svars.isConvoySolider1_Dead and svars.isConvoySolider2_Dead then
		Fox.Log("Convoy Soldiers are dead. Set Hostage Ever Down.")

		this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "")
	end
end

this.SwitchEnableCpSoldiers = function(soldierList, switch)
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local command = { id = "SetEnabled", enabled = switch }

	for idx = 1, table.getn(soldierList) do
		local gameObjectId = GetGameObjectId(soldierList[idx])
		if gameObjectId ~= NULL_ID then
			SendCommand(gameObjectId, command)
		end
	end
end

this.SetSneakRouteCpSoldiers = function(soldierList, routeName)
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local command = { id = "SetSneakRoute", route = routeName, point = 0 }

	for idx = 1, table.getn(soldierList) do
		local gameObjectId = GetGameObjectId(soldierList[idx])
		if gameObjectId ~= NULL_ID then
			SendCommand(gameObjectId, command)
		end
	end
end

this.SetSneakRouteCpSoldiers = function(soldierList, routeName)
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local command = { id = "SetSneakRoute", route = routeName, point = 0 }

	for idx = 1, table.getn(soldierList) do
		local gameObjectId = GetGameObjectId(soldierList[idx])
		if gameObjectId ~= NULL_ID then
			SendCommand(gameObjectId, command)
		end
	end
end

this.SetSneakCautionRouteCpSoldiers = function(soldierList, routeName)
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local commandSneak = { id = "SetSneakRoute", route = routeName, point = 0 }
	local commandCaution = { id = "SetCautionRoute", route = routeName, point = 0 }

	for idx = 1, table.getn(soldierList) do
		local gameObjectId = GetGameObjectId(soldierList[idx])
		if gameObjectId ~= NULL_ID then
			SendCommand(gameObjectId, commandSneak)
			SendCommand(gameObjectId, commandCaution)
		end
	end
end

this.SetAllPhaseRouteCpSoldiers = function(soldierList, routeName, routePoint)
	if routePoint == nil then
		routePoint = 0
	end
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local commandSneak = { id = "SetSneakRoute", route = routeName, point = routePoint }
	local commandCaution = { id = "SetCautionRoute", route = routeName, point = routePoint }
	local commandAlert = { id = "SetAlertRoute", enabled = true, route = routeName, point = routePoint }

	for idx = 1, table.getn(soldierList) do
		local gameObjectId = GetGameObjectId(soldierList[idx])
		if gameObjectId ~= NULL_ID then
			SendCommand(gameObjectId, commandSneak)
			SendCommand(gameObjectId, commandCaution)
			SendCommand(gameObjectId, commandAlert)
		end
	end
end

this.UnsetAlertRouteSoldier = function(soldierName)
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local commandUnsetAlert = { id = "SetAlertRoute", enabled = false, route = "" }
	local gameObjectId = GetGameObjectId(soldierName)
	if gameObjectId ~= NULL_ID then
		SendCommand(gameObjectId, commandUnsetAlert)
	end
end

this.SetSneakRoute = function(soldierName, routeName)
	local gameObjectId = GameObject.GetGameObjectId(soldierName)
	if gameObjectId ~= NULL_ID then
		local command = { id = "SetSneakRoute", route = routeName, point = 0 }
		GameObject.SendCommand(gameObjectId, command)
	end
end

TppEnemy.SetCautionRouteSoldier = function(soldierName, routeName)
	local gameObjectId = GameObject.GetGameObjectId(soldierName)
	if gameObjectId ~= NULL_ID then
		local commandCaution = { id = "SetCautionRoute", route = routeName, point = 0 }
		GameObject.SendCommand(gameObjectId, commandCaution)
	end
end

this.SetSneakCautionRouteSoldier = function(soldierName, routeName, routePoint)
	local gameObjectId = GameObject.GetGameObjectId(soldierName)
	if gameObjectId ~= NULL_ID then
		if routePoint == nil then
			routePoint = 0
		end
		local commandSneak = { id = "SetSneakRoute", route = routeName, point = routePoint }
		local commandCaution = { id = "SetCautionRoute", route = routeName, point = routePoint }
		local commandUnsetAlert = { id = "SetAlertRoute", enabled = false, route = "" }
		GameObject.SendCommand(gameObjectId, commandSneak)
		GameObject.SendCommand(gameObjectId, commandCaution)
		GameObject.SendCommand(gameObjectId, commandUnsetAlert)
	end
end

this.SetAllPhaseRouteSoldier = function(soldierName, routeName)
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local commandSneak = { id = "SetSneakRoute", route = routeName, point = 0 }
	local commandCaution = { id = "SetCautionRoute", route = routeName, point = 0 }
	local commandAlert = { id = "SetAlertRoute", enabled = true, route = routeName, point = 0 }

	local gameObjectId = GameObject.GetGameObjectId(soldierName)
	if gameObjectId ~= NULL_ID then
		SendCommand(gameObjectId, commandSneak)
		SendCommand(gameObjectId, commandCaution)
		SendCommand(gameObjectId, commandAlert)
	end
end

this.SetSneakRouteHostage = function(hostageName, routeName, routePoint)
	local gameObjectId = GameObject.GetGameObjectId(hostageName)
	if gameObjectId ~= NULL_ID then
		if routePoint == nil then
			routePoint = 0
		end
		local command = { id = "SetSneakRoute", route = routeName, point = routePoint }
		GameObject.SendCommand(gameObjectId, command)
	end
end

this.HandleRouteEvent = function(gameObjectId, routeId, param, messageId)
	Fox.Log(
		"HandleRouteEvent "
			.. "gameObjectId: "
			.. tostring(gameObjectId)
			.. "routeId: "
			.. tostring(routeId)
			.. "routeNode: "
			.. tostring(routeNode)
			.. "messageId: "
			.. tostring(messageId)
	)

	if messageId == StrCode32("startInterrogation") then
		if TppEnemy.GetLifeStatus(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME) < TppEnemy.LIFE_STATUS.DEAD then
			this.SetSneakCautionRouteSoldier(
				s10085_enemy.INTERROGATOR_SOLDIER_1_NAME,
				"rts_conversation_visitTent_caller"
			)
			this.SetSneakCautionRouteSoldier(
				s10085_enemy.INTERROGATOR_SOLDIER_2_NAME,
				"rts_conversation_visitTent_callerWait"
			)
			this.SetSneakCautionRouteSoldier(s10085_enemy.TENT_BACK_SOLDIER_NAME, "rts_conversation_visitTent_callee")
			TppEnemy.SetAlertRoute(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_walk_interrogator_approachTent")
		else
			this.SetSneakCautionRouteSoldier(
				s10085_enemy.INTERROGATOR_SOLDIER_2_NAME,
				"rts_conversation_visitTent_caller"
			)
			this.SetSneakCautionRouteSoldier(
				s10085_enemy.INTERROGATOR_SOLDIER_1_NAME,
				"rts_conversation_visitTent_callerWait"
			)
			this.SetSneakCautionRouteSoldier(
				s10085_enemy.TENT_BACK_SOLDIER_NAME,
				"rts_conversation_visitTent_callee_sub"
			)
			TppEnemy.SetAlertRoute(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_walk_interrogator_approachTent")
		end

		this.SetIgnoreNoticeExceptForPlayerOnInterrogator(false)

		if DEBUG then
			TppDebug.Print2D({
				showTime = 60 * 4,
				xPos = 450,
				yPos = 250,
				text = "Start Interrogation",
				color = "red",
			})
		end
	elseif messageId == StrCode32("sendHostageToVehicle") then
		if svars.isConvoyHostageMissed then
			this.SetInterrogatorSoldierSearchConvoyHostage()
		else
			this.GiveHostageRideVehicle()
		end
	elseif messageId == StrCode32("goToHill") then
		if gameObjectId ~= GameObject.GetGameObjectId(CONVOY_HOSTAGE_NAME) then
			this.StartTravelForHill()
		end
		if DEBUG then
			TppDebug.Print2D({
				showTime = 60 * 4,
				xPos = 450,
				yPos = 450,
				text = "Go to HILL",
				color = "green",
			})
		end
	elseif messageId == StrCode32("beforeGetIntoHill") then
		this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "")
	elseif messageId == StrCode32("getIntoHill") then
		this.GetIntoHill()
		if DEBUG then
			TppDebug.Print2D({
				showTime = 60 * 4,
				xPos = 450,
				yPos = 450,
				text = "Get Into HILL",
				color = "green",
			})
		end
	elseif messageId == StrCode32("killingPointArrived") then
		this.SetSneakCautionRouteSoldier(s10085_enemy.CHECKPOINT_REINFORCE_SOLDIER_1_NAME, "rts_checkpointGoToTent")
		this.SetSneakCautionRouteSoldier(s10085_enemy.CHECKPOINT_REINFORCE_SOLDIER_2_NAME, "rts_checkpointGoToTent")
	elseif messageId == StrCode32("hillArrived") then
		if gameObjectId == GameObject.GetGameObjectId(CONVOY_HOSTAGE_NAME) then
			this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_interrogate")
			this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_interrogate_guard")
			this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "")
		end
	elseif messageId == StrCode32("lying") then
		if gameObjectId == GameObject.GetGameObjectId(CONVOY_HOSTAGE_NAME) then
			this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "")
		elseif gameObjectId == GameObject.GetGameObjectId(FLEE_HOSTAGE_NAME) then
			this.SetSneakRouteHostage(FLEE_HOSTAGE_NAME, "")
		end
		if DEBUG then
			TppDebug.Print2D({
				showTime = 60 * 4,
				xPos = 450,
				yPos = 350,
				text = "Start lying(None Route)",
				color = "blue",
			})
		end
	elseif messageId == StrCode32("playRadio") then
		this.PlayRadioFromMessage(gameObjectId, param)
	elseif messageId == StrCode32("startConversation") then
		this.ConversationStart(param)
	elseif messageId == StrCode32("waitEndConversation") then
		this.ConversationWaitEnd(param)
	elseif messageId == StrCode32("routeStart_hostage_runAway") then
		svars.isFleeHostageFlee = true

		TppRadio.ChangeIntelRadio(s10085_radio.intelRadioListFlee)
	elseif messageId == StrCode32("setCommandPost") then
		this.SetCommandPost(gameObjectId)
	end
end

this.SetHostageFollowed = function(hostageName)
	local gameObjectId = GameObject.GetGameObjectId(hostageName)
	local command = { id = "SetFollowed", enable = true }
	GameObject.SendCommand(gameObjectId, command)
	svars.need_SetFollowed = true
end

this.SetInterrogatorSoldierSearchConvoyHostage = function()
	this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_walk_hostageMissed_0000")
	this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_walk_hostageMissed_0001")
end

this.StartTravelForHill = function()
	s10085_enemy.StartTravelPlan(
		{ s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, s10085_enemy.INTERROGATOR_SOLDIER_2_NAME },
		s10085_enemy.TRAVEL_TYPE.FACTORYSOUTH_TO_HILL
	)

	this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "rts_veh_fromFactorySouth")

	this.SetHostageFollowed(CONVOY_HOSTAGE_NAME)

	TppRadio.ChangeIntelRadio(s10085_radio.intelRadioListConvoyStart)

	this.AddMissionInterrogation(s10085_enemy.INTERROGATION_TYPE.CONVOY, s10085_enemy.InterCall_ConvoyPosition)

	this.SetIgnoreNoticeExceptForPlayerOnInterrogator(true)
end

this.StartWalkConvoyForHill = function()
	this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_walk_factorySouthToHill")
	this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_walk_factorySouthToHill")

	this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "rts_walk_factorySouthToHill")

	this.SetHostageFollowed(CONVOY_HOSTAGE_NAME)

	TppRadio.ChangeIntelRadio(s10085_radio.intelRadioListConvoyStart)

	this.AddMissionInterrogation(s10085_enemy.INTERROGATION_TYPE.CONVOY, s10085_enemy.InterCall_ConvoyPosition)
end

this.SetCommandPost = function(gameObjectId)
	if Tpp.IsSoldier(gameObjectId) then
		GameObject.SendCommand(gameObjectId, { id = "SetCommandPost", cp = "mafr_hill_cp" })
	end
end

this.GetIntoHill = function()
	s10085_enemy.FinishTravelPlan({ s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, s10085_enemy.INTERROGATOR_SOLDIER_2_NAME })

	this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_hillArrival")
	this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_hillArrival")

	this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "rts_hillArrival")

	this.SetIgnoreNoticeExceptForPlayerOnInterrogator(false)

	TppRadio.ChangeIntelRadio(s10085_radio.intelRadioListConvoyFinished)
end

this.SetInterrogatorSoldierFindHostageInHill = function()
	this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_hill_hostageMissed")
	this.SetSneakCautionRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_hill_hostageMissed")
end

this.ProcessGameOver = function(didPlayerKillTargetHostage)
	Fox.Log(
		"svars.isFleeHostageDead "
			.. tostring(svars.isFleeHostageDead)
			.. ", svars.isConvoyHostageDead "
			.. tostring(svars.isConvoyHostageDead)
	)

	if svars.isFleeHostageDead or svars.isConvoyHostageDead then
		local targetDeadRadioType = TppDefine.GAME_OVER_RADIO.TARGET_DEAD

		if didPlayerKillTargetHostage then
			if svars.isFleeHostageDead then
				targetDeadRadioType = TppDefine.GAME_OVER_RADIO.PLAYER_KILL_TARGET
			else
				targetDeadRadioType = TppDefine.GAME_OVER_RADIO.PLAYER_KILL_TARGET_WOMAN
			end
		end
		TppMission.ReserveGameOver(TppDefine.GAME_OVER_TYPE.TARGET_DEAD, targetDeadRadioType)
	end
end

function this.OnGameOver(gameOverType)
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo(TppDefine.GAME_OVER_TYPE.TARGET_DEAD) then
		if mvars.deadHostageName then
			TppPlayer.SetTargetDeadCamera({ gameObjectName = mvars.deadHostageName })
		end
		TppMission.ShowGameOverMenu({ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME })
		return true
	end
end

this.ProcessGameEscape = function()
	if TppSequence.GetCurrentSequenceName() == "Seq_Game_Escape" then
		return
	end

	if this.CanBeEscaped() then
		s10085_radio.PlayBreakAwayRescueAll()
		Fox.Log("## CanBeEscaped: True. Seq_Game_Escape")

		TppSequence.SetNextSequence("Seq_Game_Escape")

		TppMission.UpdateObjective({
			objectives = { "clear_Area_hosTarget_flee", "clear_Area_hosTarget_convoy" },
		})
	end
end

this.GiveHostageRideVehicle = function()
	Fox.Log("GiveHostageRideVehicle")

	s10085_enemy.SetEnemyVehicle({ CONVOY_HOSTAGE_NAME }, "veh_s10085_LV1", false)

	this.SetSneakRouteHostage(CONVOY_HOSTAGE_NAME, "rts_hostageGiveRideVehicle", 0)
	this.SetAllPhaseRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, "rts_hostageGiveRideVehicle")
	this.SetAllPhaseRouteSoldier(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, "rts_hostageGiveRideVehicle")

	svars.isConvoyHostageAway = true

	s10085_radio.OptionalRadioRescueOneHostage()
end

this.PlayRadioFromMessage = function(gameObjectId, radioType)
	Fox.Log(
		"PlayRadioFromMessage " .. "gameObjectId: " .. tostring(gameObjectId) .. " radioType: " .. tostring(radioType)
	)
	if radioType == StrCode32("startFlee") then
		Fox.Log("PlayRadioFromMessage: startFlee. Not playing hostage flee radio because of direction")
	end
end

local InterrogationCpList = {
	"s10085_interrogator_cp",
	"mafr_hillNorth_ob",
	"mafr_hillWest_ob",
	"mafr_hill_cp",
	"mafr_hillWestNear_ob",
}

function this.HighInterrogation()
	Fox.Log("HighInterrogation")
	local sequence = TppSequence.GetCurrentSequenceName()

	if sequence == "Seq_Game_MainGame" then
		for i, cp in pairs(InterrogationCpList) do
			Fox.Log(cp)
			TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId(cp), {
				{ name = s10085_enemy.INTERROGATION_TYPE.NUBIAN, func = s10085_enemy.InterCall_Nubian },
				{ name = s10085_enemy.INTERROGATION_TYPE.PLANT, func = s10085_enemy.InterCall_Plant },
				{ name = s10085_enemy.INTERROGATION_TYPE.BIRD, func = s10085_enemy.InterCall_Bird },
				{ name = s10085_enemy.INTERROGATION_TYPE.CONTAINER, func = s10085_enemy.InterCall_Container },
			})
		end
	end

	Fox.Log("End HighInterrogation")
end

this.AddMissionInterrogation = function(addName, addFunc)
	Fox.Log("AddMissionInterrogation")

	for i, cp in pairs(InterrogationCpList) do
		Fox.Log(cp)
		TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId(cp), {
			{ name = addName, func = addFunc },
		})
	end
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

this.PlayCarryMonologue = function(gameObjectId, carriedState)
	if carriedState ~= 2 then
		Fox.Log("PlayCarryMonologue: not Carried START. Return. carriedState: " .. tostring(carriedState))
		return
	end

	local monologueLabel = nil

	if
		gameObjectId == GameObject.GetGameObjectId(FLEE_HOSTAGE_NAME)
		and svars.isFleeHostageMonologuePlayed == false
	then
		monologueLabel = fleeHostageMonologueTable[svars.fleeHostageMonologueNum]
		svars.isFleeHostageMonologuePlayed = true
	elseif
		gameObjectId == GameObject.GetGameObjectId(CONVOY_HOSTAGE_NAME)
		and svars.isConvoyHostageMonologuePlayed == false
	then
		monologueLabel = convoyHostageMonologueTable[svars.convoyHostageMonologueNum]
		svars.isConvoyHostageMonologuePlayed = true
	end

	if monologueLabel then
		this.CallMonologue(gameObjectId, monologueLabel)
	end
end

this.PlayCarryMonologueContinued = function(gameObjectId, label)
	local GetStateCommand = { id = "GetStatus" }
	local hostageState = GameObject.SendCommand(gameObjectId, GetStateCommand)
	if hostageState ~= TppGameObject.NPC_STATE_CARRIED then
		Fox.Log(
			"# Stop PlayCarryMonologueContinued. This character is not carried anymore. GameObjectId: "
				.. tostring(gameObjectId)
		)
		return
	end

	local monologueLabel = nil
	if gameObjectId == GameObject.GetGameObjectId(FLEE_HOSTAGE_NAME) then
		svars.fleeHostageMonologueNum = svars.fleeHostageMonologueNum + 1

		if
			svars.isFleeHostageFlee == false
			and svars.fleeHostageMonologueNum >= FLEE_HOSTAGE_MONOLOGUE_CONTINUED_INDEX
		then
			return
		end
		monologueLabel = fleeHostageMonologueTable[svars.fleeHostageMonologueNum]
	elseif gameObjectId == GameObject.GetGameObjectId(CONVOY_HOSTAGE_NAME) then
		svars.convoyHostageMonologueNum = svars.convoyHostageMonologueNum + 1

		if
			svars.isFleeHostageFlee == false
			and svars.convoyHostageMonologueNum >= CONVOY_HOSTAGE_MONOLOGUE_CONTINUED_INDEX
		then
			return
		end
		monologueLabel = convoyHostageMonologueTable[svars.convoyHostageMonologueNum]
	end
	if monologueLabel then
		this.CallMonologue(gameObjectId, monologueLabel)
	end
end

this.CallMonologue = function(gameObjectId, monologueLabel)
	local command = {
		id = "CallMonologue",
		label = monologueLabel,
	}
	GameObject.SendCommand(gameObjectId, command)
end

this.SetIgnoreNoticeExceptForPlayerOnInterrogator = function(isIgnore)
	s10085_enemy.SetIgnoreNoticeExceptForPlayer(s10085_enemy.INTERROGATOR_SOLDIER_1_NAME, isIgnore)
	s10085_enemy.SetIgnoreNoticeExceptForPlayer(s10085_enemy.INTERROGATOR_SOLDIER_2_NAME, isIgnore)
	svars.isIgnoreNoticeExceptForPlayer = isIgnore
	Fox.Log("## SetIgnoreNoticeExceptForPlayerOnInterrogator: " .. tostring(svars.isIgnoreNoticeExceptForPlayer))
end

sequences.Seq_Game_MainGame = {
	Messages = function(self)
		return StrCode32Table({
			Marker = {
				{
					msg = "ChangeToEnable",
					sender = CONVOY_HOSTAGE_NAME,
					func = function(arg0, arg1, arg2, arg3)
						Fox.Log("ChangeToEnable CONVOY_HOSTAGE_NAME")
						if arg3 == StrCode32("Player") then
							s10085_radio.PlayMarkConvoyHostage()
						end
						svars.isConvoyHostageMarked = true
						s10085_radio.OptionalRadioRescueOneHostage()
					end,
				},
				{
					msg = "ChangeToEnable",
					sender = FLEE_HOSTAGE_NAME,
					func = function(arg0, arg1, arg2, arg3)
						Fox.Log("ChangeToEnable FLEE_HOSTAGE_NAME")
						if arg3 == StrCode32("Player") then
							s10085_radio.PlayMarkFleeHostage()
						end
					end,
				},
			},
		})
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(2053.5586, 53.039246, 69.70874))
			TppNetworkUtil.SessionEnableAccept(true)
			Dynamite.StartNearestEnemyThread()
		end

		Fox.Log("sequences.Seq_Game_MainGame")

		TppMission.UpdateObjective({
			objectives = {
				"default_photo_flee",
				"default_photo_convoy",
				"default_photo_tent",
				"default_subGoal",
				"rescueFleeHostage_MissionTask",
				"rescueConvoyHostage_MissionTask",
				"firstBonus_MissionTask",
				"secondBonus_MissionTask",
				"firstSub_MissionTask",
				"secondSub_MissionTask",
				"thirdSub_MissionTask",
			},
		})

		local startRadioGroup = s10085_radio.GetMissionStartRadioGroup()
		TppMission.UpdateObjective({
			objectives = { "Area_hosTarget_flee" },
			radio = {
				radioGroups = startRadioGroup,
			},
		})

		if TppSequence.GetContinueCount() > 0 then
			s10085_radio.PlayMissionContinueRadio()
		end

		local fleeGameObjectId = GameObject.GetGameObjectId(FLEE_HOSTAGE_NAME)
		local convoyGameObjectId = GameObject.GetGameObjectId(CONVOY_HOSTAGE_NAME)
		local command = {
			id = "SetHostage2Flag",
			flag = "disableScared",
			on = true,
		}
		GameObject.SendCommand(fleeGameObjectId, command)
		GameObject.SendCommand(convoyGameObjectId, command)

		if svars.need_Timer_HostageRunAway == true then
			GkEventTimerManager.Start("Timer_HostageRunAway", TIMER_HOSTAGE_RUNAWAY_WAIT)
		end

		if svars.need_Timer_ChaseHostageFromCheckpoint == true then
			GkEventTimerManager.Start("Timer_ChaseHostageFromCheckpoint", TIMER_CHASE_HOSTAGE_CHECKPOINT_WAIT)
		end

		this.SetIgnoreNoticeExceptForPlayerOnInterrogator(svars.isIgnoreNoticeExceptForPlayer)

		if svars.need_SetFollowed == true then
			this.SetHostageFollowed(CONVOY_HOSTAGE_NAME)
		end

		if DEBUG then
			TppDebug.Print2D({
				showTime = 60 * 4,
				xPos = 450,
				yPos = 250,
				text = "Seq_Game_MainGame",
				color = "yellow",
			})
		end

		TppTelop.StartCastTelop()

		this.HighInterrogation()

		if svars.isFleeHostageRescued == false and svars.isConvoyHostageRescued == false then
			s10085_radio.OptionalRadioRescueTwo()
		else
			s10085_radio.OptionalRadioRescueOneHostage()
		end
	end,

	OnLeave = function() end,
}

sequences.Seq_Game_Escape = {

	OnEnter = function()
		TppMission.UpdateObjective({
			objectives = { "end_subGoal", "clear_photo_tent" },
		})

		TppMission.CanMissionClear()
		s10085_radio.OptionalRadioClear()
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
