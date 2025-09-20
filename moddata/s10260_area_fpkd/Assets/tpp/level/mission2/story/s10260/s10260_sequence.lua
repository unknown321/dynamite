local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

local TARGET_DOOR_NAME = "afgh_hutt008_door001_gim_n0001|srt_afgh_hutt008_door001"
local TARGET_DOOR_PATH = "/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_gimmick.fox2"

local ENEMY_VEHICLE_0000 = "TppVehicleLocator0000"
local ENEMY_VEHICLE_0001 = "TppVehicleLocator0001"
local ENEMY_VEHICLE_0002 = "TppVehicleLocator0002"
local ENEMY_VEHICLE_0003 = "TppVehicleLocator0003"
local ENEMY_VEHICLE_0004 = "TppVehicleLocator0004"
local ENEMY_VEHICLE_0005 = "TppVehicleLocator0005"
local ENEMY_VEHICLE_0006 = "TppVehicleLocator0006"
local ENEMY_VEHICLE_0007 = "TppVehicleLocator0007"
local ENEMY_VEHICLE_0008 = "TppVehicleLocator0008"

local ENEMY_VEHICLE_0009 = "TppVehicleLocator0009"
local ENEMY_VEHICLE_0010 = "TppVehicleLocator0010"
local ENEMY_VEHICLE_0011 = "TppVehicleLocator0011"
local ENEMY_VEHICLE_0012 = "TppVehicleLocator0012"
local ENEMY_VEHICLE_0013 = "TppVehicleLocator0013"

function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences({

		"Seq_Game_MainGame",
		"Seq_Demo_EncountQuiet",
		"Seq_Demo_QuietChoked",

		"Seq_Game_MainGame_02_Phase01",
		"Seq_Game_MainGame_02_Phase02",
		"Seq_Game_MainGame_02_Phase03",
		"Seq_Game_MainGame_02_Phase04",

		"Seq_Demo_AfterTankBattle",

		"Seq_Game_MainGame_03",
		"Seq_Demo_SnakeBite_01",
		"Seq_Demo_SnakeBite_02",

		"Seq_Demo_QuietSpeak",
		"Seq_Demo_QuietVanishing",

		"Seq_Game_MainGame_04",

		"Seq_Demo_CameraForLetter",
		"Seq_Demo_LetterFromQuiet",
		"Seq_Demo_QuietDrifted",

		"Seq_Game_Escape",
		nil,
	})
	TppSequence.RegisterSequenceTable(sequences)
end

this.saveVarsList = {
	bossDyingNum = 0,
	isClearDemoPlayed = false,
	isQuietDamaged = false,

	FultonCombatVehicle = 0,

	sub_Flag_0000 = false,
	sub_Flag_0001 = false,
	sub_Flag_0002 = false,
	sub_Flag_0003 = false,
	sub_Flag_0004 = false,
	sub_Flag_0005 = false,
	sub_Flag_0006 = false,
	sub_Flag_0007 = false,
	sub_Flag_0008 = false,
	sub_Flag_0009 = false,

	sub_Flag_0010 = 0,
	sub_Flag_0011 = 0,
	sub_Flag_0012 = 0,
	sub_Flag_0013 = 0,
	sub_Flag_0014 = 0,
	sub_Flag_0015 = 0,
	sub_Flag_0016 = 0,
	sub_Flag_0017 = 0,
	sub_Flag_0018 = 0,
	sub_Flag_0019 = 0,
}

this.checkPointList = {
	"CHK_MissionStart",
	"CHK_StartVsTank",
	"CHK_Interval",
	"CHK_StartEscape",
	"CHK_StartEnd",
	nil,
}

this.VARIABLE_TRAP_SETTING = {
	{ name = "InnerZone", type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.ENABLE },
	{ name = "OuterZone", type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.ENABLE },
	{ name = "InnerZone0000", type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE },
	{ name = "OuterZone0000", type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE },
	{ name = "InnerZone0001", type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE },
	{ name = "OuterZone0001", type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE },
	{ name = "InnerZone0002", type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE },
	{ name = "OuterZone0002", type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE },
}

this.missionObjectiveDefine = {
	default_Target_Area = {
		gameObjectName = "10260_marker_Init",
		visibleArea = 3,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		langId = "marker_info_mission_targetArea",
	},

	default_ProtectQuiet = {
		gameObjectName = "10260_marker_Quiet",
		visibleArea = 3,
		goalType = "defend",
		randomRange = 0,
		viewType = "all",
		setImportant = true,
		setNew = false,
	},

	default_Escape_Area = {
		gameObjectName = "10260_marker_Escape",
		visibleArea = 0,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		langId = "marker_info_LZ",
	},

	default_photo_target_10 = {
		photoId = 10,
		addFirst = true,
		photoRadioName = "s0260_mirg0100",
	},

	default_subGoal_ContactQuiet = {
		subGoalId = 0,
	},

	default_subGoal_RejectTanks = {
		subGoalId = 1,
	},

	default_subGoal_HeadToLZ = {
		subGoalId = 2,
	},

	default_subGoal_FindOut = {
		subGoalId = 3,
	},

	MissionTask_ContactQuiet = {
		missionTask = { taskNo = 0, isNew = true, isComplete = false },
	},
	ClearTask_ContactQuiet = {
		missionTask = { taskNo = 0, isComplete = true },
	},
	MissionTask_DestroyVehicles = {
		missionTask = { taskNo = 1, isNew = true, isFirstHide = true, isComplete = false },
	},
	ClearTask_DestroyVehicles = {
		missionTask = { taskNo = 1, isComplete = true },
	},
	MissionTask_GetQuietTape = {
		missionTask = { taskNo = 2, isNew = true, isFirstHide = true, isComplete = false },
	},
	ClearTask_GetQuietTape = {
		missionTask = { taskNo = 2, isComplete = true },
	},
	MissionTask_CaptureVehicles = {
		missionTask = { taskNo = 3, isNew = true, isFirstHide = true, isComplete = false },
	},
	ClearTask_CaptureVehicles = {
		missionTask = { taskNo = 3, isComplete = true },
	},
	MissionTask_NoDamage = {
		missionTask = { taskNo = 4, isNew = true, isFirstHide = true, isComplete = false },
	},
	ClearTask_NoDamage = {
		missionTask = { taskNo = 4, isComplete = true },
	},

	targetCpSetting = {
		targetBgmCp = "afgh_remnants_cp",
	},

	announce_ObjectiveComplete = {
		announceLog = "achieveAllObjectives",
	},

	OpenMissionTask_DestroyVehicles = {
		missionTask = { taskNo = 1, isNew = true, isFirstHide = false, isComplete = false },
	},

	default_photo_target_10_noRadio = {
		photoId = 10,
		addFirst = true,
	},
}

this.specialBonus = {
	first = {
		missionTask = { taskNo = 3 },
	},
	second = {
		missionTask = { taskNo = 4 },
	},
}

this.missionObjectiveTree = {

	default_photo_target_10_noRadio = {
		default_photo_target_10 = {},
	},

	default_subGoal_FindOut = {
		default_Escape_Area = {
			default_ProtectQuiet = {
				default_Target_Area = {},
			},
		},
		default_subGoal_HeadToLZ = {
			default_subGoal_RejectTanks = {
				default_subGoal_ContactQuiet = {},
			},
		},
	},

	ClearTask_ContactQuiet = {
		MissionTask_ContactQuiet = {},
	},

	ClearTask_DestroyVehicles = {
		OpenMissionTask_DestroyVehicles = {
			MissionTask_DestroyVehicles = {},
		},
	},

	ClearTask_GetQuietTape = {
		MissionTask_GetQuietTape = {},
	},

	ClearTask_CaptureVehicles = {
		MissionTask_CaptureVehicles = {},
	},

	ClearTask_NoDamage = {
		MissionTask_NoDamage = {},
	},

	targetCpSetting = {},

	announce_ObjectiveComplete = {},
}

this.missionObjectiveEnum = Tpp.Enum({
	"default_Target_Area",
	"default_ProtectQuiet",
	"default_Escape_Area",
	"default_Quiet_Area",

	"default_photo_target_10",

	"default_subGoal_ContactQuiet",
	"default_subGoal_RejectTanks",
	"default_subGoal_HeadToLZ",
	"default_subGoal_FindOut",

	"MissionTask_ContactQuiet",
	"MissionTask_DestroyVehicles",
	"MissionTask_GetQuietTape",
	"MissionTask_CaptureVehicles",
	"MissionTask_NoDamage",

	"ClearTask_ContactQuiet",
	"ClearTask_DestroyVehicles",
	"ClearTask_GetQuietTape",
	"ClearTask_CaptureVehicles",
	"ClearTask_NoDamage",

	"targetCpSetting",

	"announce_ObjectiveComplete",

	"OpenMissionTask_DestroyVehicles",
	"default_photo_target_10_noRadio",
})

this.missionStartPosition = {

	orderBoxList = {},

	helicopterRouteList = {
		"drp_s10260",
	},
}

function this.RegisterMissionSystemCallback()
	local missionName = TppMission.GetMissionName()
	Fox.Log("#### " .. tostring(missionName) .. "_sequence.RegisterMissionSystemCallback ####")

	local systemCallbackTable = {
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnGameOver = this.OnGameOver,
		OnOutOfMissionArea = this.OnOutOfMissionArea,
		OnRecovered = this.OnRecovered,
		OnEndMissionCredit = this.OnEndMissionCredit,
		OnDisappearGameEndAnnounceLog = this.OnDisappearGameEndAnnounceLog,
		nil,
	}

	TppMission.RegisterMissionSystemCallback(systemCallbackTable)
end

function this.OnGameOver(gameOverType)
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo(TppDefine.GAME_OVER_TYPE.TARGET_DEAD) then
		TppPlayer.SetTargetDeadCamera({ gameObjectName = mvars.deadNPCId })
		TppMission.ShowGameOverMenu({ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME })
		return true
	end
end

function this.OnEstablishMissionClear()
	Fox.Log("#### s10260_sequence.OnEstablishMissionClear ####")
	TppSequence.SetNextSequence("Seq_Demo_SnakeBite_01", { isExecMissionClear = true })
end

function this.OnOutOfMissionArea()
	Fox.Log("#### s10260_sequence.OnOutOfMissionArea ####")
	TppMission.ReserveGameOver(
		TppDefine.GAME_OVER_TYPE.OUTSIDE_OF_MISSION_AREA,
		TppDefine.GAME_OVER_RADIO.OUTSIDE_OF_MISSION_AREA
	)
end

function this.OnRecovered(gameObjectId)
	Fox.Log("### OnRecovered_is_coming ###")

	svars.FultonCombatVehicle = svars.FultonCombatVehicle + 1
	this.CountDyingTank(gameObjectId)
	if svars.FultonCombatVehicle == 14 then
		TppResult.AcquireSpecialBonus({ first = { isComplete = true } })
	else
		Fox.Log(" ### Not Collect All Yet ### ")
	end
end

function this.OnEndMissionCredit()
	Fox.Log("### OnEndMissionCredit ###")
	if TppSequence.GetCurrentSequenceIndex() == TppSequence.GetSequenceIndex("Seq_Demo_QuietSpeak") then
		TppSequence.SetNextSequence("Seq_Demo_QuietVanishing", { isExecMissionClear = true })
	end
end

function this.OnDisappearGameEndAnnounceLog()
	if TppSequence.GetCurrentSequenceIndex() == TppSequence.GetSequenceIndex("Seq_Demo_QuietDrifted") then
		TppStory.RequestLoseQuiet()
		TppUiStatusManager.SetStatus("MissionTelop", "RESULT_SKIP_ALL_SCORE")
		TppQuest.Clear("waterway_q99012")
		TppQuest.Save()
	end
	TppUiStatusManager.SetStatus("MissionTelop", "RESULT_SKIP_CAST")
	TppMission.ShowMissionResult()
end

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	this.RegisterMissionSystemCallback()
	TppRatBird.EnableRat()
	TppRatBird.EnableBird("TppEagle")
	TppUiCommand.LyricTexture("regist_quiet")
	TppScriptBlock.PreloadRequestOnMissionStart({
		{ demo_block = "Demo_EncountQuiet" },
	})
end

function this.OnBuddyBlockLoad()
	Fox.Log("s10260_sequence.OnBuddyBlockLoad()")
	if TppMission.IsMissionStart() then
		if vars.buddyType == BuddyType.QUIET then
			Fox.Log(
				"s10260_sequence.OnBuddyBlockLoad() : Force override BuddyType.NONE because already buddyType is quiet."
			)
			vars.buddyType = BuddyType.NONE
		end
	end
end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
end

function this.OnTerminate()
	this.ResetUiSetting()
	TppUiStatusManager.ClearStatus("AnnounceLog")
end

this.FuncForceVehiclesStop = function()
	local ridingGameObjectId = vars.playerVehicleGameObjectId
	if Tpp.IsHorse(ridingGameObjectId) then
		GameObject.SendCommand(ridingGameObjectId, { id = "HorseForceStop" })
	elseif Tpp.IsVehicle(ridingGameObjectId) then
		local vehicleType = GameObject.SendCommand(ridingGameObjectId, { id = "GetVehicleType" })
		GameObject.SendCommand(ridingGameObjectId, { id = "ForceStop", enabled = true })
	elseif Tpp.IsPlayerWalkerGear(ridingGameObjectId) or Tpp.IsEnemyWalkerGear(ridingGameObjectId) then
		GameObject.SendCommand(ridingGameObjectId, { id = "ForceStop", enabled = true })
	else
	end
end

this.FuncForceVehiclesStop_disable = function()
	local ridingGameObjectId = vars.playerVehicleGameObjectId
	if Tpp.IsHorse(ridingGameObjectId) then
	elseif Tpp.IsVehicle(ridingGameObjectId) then
		local vehicleType = GameObject.SendCommand(ridingGameObjectId, { id = "GetVehicleType" })
		GameObject.SendCommand(ridingGameObjectId, { id = "ForceStop", enabled = false })
	elseif Tpp.IsPlayerWalkerGear(ridingGameObjectId) or Tpp.IsEnemyWalkerGear(ridingGameObjectId) then
		GameObject.SendCommand(ridingGameObjectId, { id = "ForceStop", enabled = false })
	else
	end
end

function this.ChangePhase(Phase)
	local gameObjectId = GameObject.GetGameObjectId("afgh_remnants_cp")
	local command = { id = "SetPhase", phase = Phase }
	GameObject.SendCommand(gameObjectId, command)
end

function this.KeepAlert()
	local gameObjectId = GameObject.GetGameObjectId("afgh_remnants_cp")
	local command = { id = "SetKeepAlert", enable = true }
	GameObject.SendCommand(gameObjectId, command)
end

function this.CreateSandStorm(TIME)
	Fox.Log("CREATE SAND STORM")
	TppWeather.RequestWeather(TppDefine.WEATHER.SANDSTORM, TIME)
	TppClock.Stop()
end

function this.DestroySandStorm()
	Fox.Log("DESTROY SAND STORM")
	TppWeather.RequestWeather(TppDefine.WEATHER.SUNNY, 0)
	TppClock.Start()
end

function this.HeliRealize()
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local gameObjectId = GetGameObjectId("TppHeli2", "SupportHeli")
	SendCommand(gameObjectId, { id = "Realize" })
end

function this.HeliCallToLZ()
	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local gameObjectId = GetGameObjectId("TppHeli2", "SupportHeli")
	SendCommand(gameObjectId, { id = "CallToLandingZoneAtName", name = "lzs_QuietGone|lz_pfCamp_E_0000" })
end

function this.HeliCallForContinue()
	local gameObjectId = GameObject.GetGameObjectId("SupportHeli")
	GameObject.SendCommand(gameObjectId, { id = "SetForceRoute", route = "rts_s10260_heli" })
end

function this.EnemyHeliSetRoute(routeId)
	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli")
	GameObject.SendCommand(gameObjectId, { id = "SetAlertRoute", route = routeId })
end

function this.EnemyHeliUnsetRoute(routeId)
	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli")
	GameObject.SendCommand(gameObjectId, { id = "SetAlertRoute", enabled = false })
end

function this.VanishEnemyHeli()
	local gameObjectId = GameObject.GetGameObjectId("EnemyHeli")
	GameObject.SendCommand(gameObjectId, { id = "Unrealize" })
end

function this.DisableModel()
	Fox.Log("s10260 DisableModel")

	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_vrtn004_0001", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_vrtn001_0000", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_burn001_0000", false)

	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_tank003_vrtn002_0000", false)

	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "mafr_grbg004_vrtn002_0000", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "mafr_grbg004_vrtn002_0001", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "mafr_grbg004_vrtn002_0002", false)

	TppDataUtility.SetVisibleDataFromIdentifier("id_for10260", "tent_collition", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_for10260", "tent01", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_for10260", "tent02", false)

	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "gntn_trsh001_irpl001", false)
end

function this.DisableModelAfterDemo()
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_0000", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_vrtn004_0001", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_wdfm003_0000", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_wdfm003_00001", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_wdfm003_00002", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_wndw001_0000", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_for10260", "tent_collition", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_for10260", "tent01", false)
	TppDataUtility.SetVisibleDataFromIdentifier("id_for10260", "tent02", false)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_tent005_gim_n0001|srt_afgh_tent005",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas001",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas002",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0000",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0001",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas004",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0000",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0001",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0002",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0000",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_wndw003_wdfm003_gim_n0001|srt_afgh_wndw003_glas003_0000",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_wndw003_wdfm003_gim_n0001|srt_afgh_wndw003_glas003_0001",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0002",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0003",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0004",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0005",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_wndw003_wdfm003_gim_n0003|srt_afgh_wndw003_glas003_0000",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_wndw003_wdfm003_gim_n0003|srt_afgh_wndw003_glas003_0001",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_wndw003_wdfm003_gim_n0002|srt_afgh_wndw003_glas003_0000",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
	Gimmick.InvisibleGimmick(
		-1,
		"afgh_wndw003_wdfm003_gim_n0002|srt_afgh_wndw003_glas003_0001",
		"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
		true
	)
end

function this.DisableGimickDoor(FLAG)
	Gimmick.SetEventDoorInvisible(TARGET_DOOR_NAME, TARGET_DOOR_PATH, FLAG)
end

function this.SetEventDoorLock()
	Gimmick.SetEventDoorLock(TARGET_DOOR_NAME, TARGET_DOOR_PATH, false, 1)
end

function this.MoveQuiet()
	Fox.Log(" ### QuietItemDrop ### ")

	local gameObjectId = GameObject.GetGameObjectIdByIndex("TppBuddyQuiet2", 0)
	mvars.quietOriginalPosition = GameObject.SendCommand(gameObjectId, { id = "GetPosition" })

	local playerPosition = TppPlayer.GetPosition()
	local calcPosition = { 1.5, 0, -1.5 }
	local quietPosition = TppMath.AddVector(playerPosition, calcPosition)
	local gameObjectId = { type = "TppBuddyQuiet2", index = 0 }
	GameObject.SendCommand(
		gameObjectId,
		{ id = "MoveToPosition", position = Vector3(quietPosition), rotationY = 0, index = 99, disableAim = true }
	)
end

function this.QuietItemDrop()
	Fox.Log(" ### QuietItemDrop ### ")
	local gameObjectId = GameObject.GetGameObjectIdByIndex("TppBuddyQuiet2", 0)
	GameObject.SendCommand(gameObjectId, { id = "RequestSupplyFlare" })
end

function this.QuietReturn()
	local gameObjectId = { type = "TppBuddyQuiet2", index = 0 }
	GameObject.SendCommand(
		gameObjectId,
		{ id = "MoveToPosition", position = Vector3(mvars.quietOriginalPosition), rotationY = 0 }
	)
end

function this.EnableQuietDying(bool)
	local gameObjectId = { type = "TppBuddyQuiet2", index = 0 }
	GameObject.SendCommand(gameObjectId, { id = "EnableDying", enable = bool })
end

function this.EnableQuietDown()
	if TppBuddy2BlockController.IsBlockActive() then
		local gameObjectId = { type = "TppBuddyQuiet2", index = 0 }
		GameObject.SendCommand(gameObjectId, { id = "SetDownIdle", enable = true })
	else
		Fox.Log("Quiet does not exist")
	end
end

function this.ChangeArea(DisableInnnerZone, DisableOuterZone, EnableInnnerZone, EnableOuterZone)
	TppTrap.Disable(DisableInnnerZone)
	TppTrap.Disable(DisableOuterZone)
	TppTrap.Enable(EnableInnnerZone)
	TppTrap.Enable(EnableOuterZone)
	TppUiCommand.HideInnerZone()
	TppUiCommand.ShowInnerZone(EnableInnnerZone)
end

function this.TankBattleSetting()
	Fox.Log(" ### TankBattleSetting ### ")
	this.ChangeArea("InnerZone", "OuterZone", "InnerZone0000", "OuterZone0000")
	this.UiSettigForBuddy()
	this.EnableQuietDying(false)
end

function this.SetLookNotice(bool)
	local gameObjectId = GameObject.GetGameObjectId("afgh_remnants_cp")
	local command = { id = "SetLookPlayerWithNotice", enable = bool }
	GameObject.SendCommand(gameObjectId, command)
end

function this.Kamikaze(enemyId, bool)
	local gameObjectId = GameObject.GetGameObjectId(enemyId)
	local command = { id = "SetCharger", enable = bool }
	GameObject.SendCommand(gameObjectId, command)
end

function this.FollowVehiclesAi(VehicleName, followEnemyName01, followEnemyName02)
	local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", followEnemyName01)
	local vehicle = GameObject.GetGameObjectId("TppVehicle2", VehicleName)
	local sol01 = GameObject.GetGameObjectId("TppSoldier2", followEnemyName01)
	local sol02 = GameObject.GetGameObjectId("TppSoldier2", followEnemyName02)
	local command =
		{ id = "SetCommandAi", commandType = CommandAi.INFANTRY, vehicle = vehicle, sol01 = sol01, sol02 = sol02 }
	GameObject.SendCommand(gameObjectId, command)
end

function this.UnsetFollowVehiclesAi(followEnemyName)
	local enemyId = GameObject.GetGameObjectId("TppSoldier2", followEnemyName)
	local command = { id = "RemoveCommandAi" }
	GameObject.SendCommand(enemyId, command)
end

function this.SetIngnoreCoop()
	local gameObjectId = GameObject.GetGameObjectId("afgh_remnants_cp")
	local command = { id = "SetIgnoreCoop" }
	GameObject.SendCommand(gameObjectId, command)
end

function this.UnSetIngnoreCoop()
	local gameObjectId = GameObject.GetGameObjectId("afgh_remnants_cp")
	local command = { id = "RemoveIgnoreCoop" }
	GameObject.SendCommand(gameObjectId, command)
end

function this.SetCombatLocator(enemyId, locatorName)
	local SendCommand = GameObject.SendCommand
	local gameObjectId = { type = "TppCommandPost2", index = 0 }
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", enemyId)

	local command = {
		id = "AssignMemberRoleInLocator",
		locatorName = LocatorName,
		soldier2GameObjectId = soldierId,
	}
	SendCommand(gameObjectId, command)
end

function this.SetCannonTime(TIME)
	local enemies = { type = "TppSoldier2" }
	local time = TIME
	local command = { id = "SetCannonTime", time = time }
	GameObject.SendCommand(enemies, command)
end

function this.AimSubLasPos(TIME)
	local time = TIME
	local gameObjectId = GameObject.GetGameObjectId("afgh_remnants_cp")
	local command = { id = "SetTargetQuietTime", time = time }
	GameObject.SendCommand(gameObjectId, command)
end

function this.ReleaseEnemies(vehicleId, driverId, enemyId_1, enemyId_2, enemyId_3)
	Fox.Log(" ### Release Enemies From A_Vehicle ###")
	local gameObjectId = { type = "TppSoldier2" }

	local vehicle = GameObject.GetGameObjectId("TppVehicle2", vehicleId)
	local driver = GameObject.GetGameObjectId("TppSoldier2", driverId)

	local sol01 = GameObject.GetGameObjectId("TppSoldier2", enemyId_1)
	local sol02 = GameObject.GetGameObjectId("TppSoldier2", enemyId_2)
	local sol03 = GameObject.GetGameObjectId("TppSoldier2", enemyId_3)
	TppEnemy.SetEnable(enemyId_1)
	TppEnemy.SetEnable(enemyId_2)
	TppEnemy.SetEnable(enemyId_3)

	local command =
		{ id = "SetInVehicle", vehicle = vehicle, driver = driver, sol01 = sol01, sol02 = sol02, sol03 = sol03 }
	GameObject.SendCommand(gameObjectId, command)
end

function this.LunchRocket(enemyId, x, y, z)
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", enemyId, x, y, z)
	local command = { id = "SetCommandAi", commandType = CommandAi.SHOOT_ROCKET, x = x, y = y, z = z }
	GameObject.SendCommand(soldierId, command)
end

function this.DeleateUserVehicle()
	local vehicleId = { type = "TppVehicle2", index = 0 }
	if GameObject.SendCommand(vehicleId, { id = "IsAlive" }) then
		GameObject.SendCommand(vehicleId, { id = "Seize", options = { "FadeOut" } })
	else
		Fox.Log(" ### nothing to Deleate ### ")
	end
end

function this.EnablePatrols()
	TppEnemy.SetEnable("sol_infantry_0100")
	TppEnemy.SetEnable("sol_infantry_0101")
	TppEnemy.SetEnable("sol_infantry_0102")
	TppEnemy.SetEnable("sol_infantry_0103")
	TppEnemy.SetEnable("sol_infantry_0104")
	TppEnemy.SetEnable("sol_infantry_0105")
end

function this.OpenMission()
	TppStory.MissionOpen(10260)
	TppStory.DisableMissionNewOpenFlag(10260)
end

function this.SetEnabledHeli(flag)
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	if gameObjectId ~= NULL_ID then
		Fox.Log(" #### s10260_sequence.SetEnabledHeli #### flag = " .. tostring(flag))
		GameObject.SendCommand(gameObjectId, { id = "SetEnabled", enabled = flag })
	end
end

function this.HeliDisablePullOut()
	Fox.Log(" #### s10260_sequence.HeliDIsablePullOut #### ")
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	GameObject.SendCommand(gameObjectId, { id = "DisablePullOut" })
end

function this.GetRocketLuncher()
	Player.ChangeEquip({
		equipId = TppEquip.EQP_WP_East_ms_010,
		stock = 8,
		stockSub = 0,
		ammo = 1,
		ammoSub = 0,
		suppressorLife = 0,
		isSuppressorOn = false,
		isLightOn = false,
		toActive = true,
		dropPrevEquip = true,
	})
end

function this.UnsetEquipments()
	Player.UnsetEquip({ slotType = PlayerSlotType.PRIMARY_1, dropPrevEquip = false })
	Player.UnsetEquip({ slotType = PlayerSlotType.PRIMARY_2, dropPrevEquip = false })
	Player.UnsetEquip({ slotType = PlayerSlotType.SECONDARY, dropPrevEquip = false })

	for i = 0, 7 do
		if vars.supportWeapons[i] ~= TppEquip.EQP_None then
			Player.UnsetEquip({ slotType = PlayerSlotType.SUPPORT, subIndex = i, dropPrevEquip = false })
		end

		if vars.items[i] ~= TppEquip.EQP_None then
			Player.UnsetEquip({ slotType = PlayerSlotType.ITEM, subIndex = i, dropPrevEquip = false })
		end
	end
end

function this.UiSettigForAfterTankBattle()
	TppTerminal.SetActiveTerminalMenu({})
end

function this.UiSettigForBuddy()
	TppTerminal.SetActiveTerminalMenu({

		TppTerminal.MBDVCMENU.MBM,
		TppTerminal.MBDVCMENU.MBM_CUSTOM,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_WEAPON,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_ARMS,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_ARMS_HELI,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_HORSE,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_DOG,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_QUIET,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_WALKER,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_BATTLE,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_DESIGN,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_DESIGN_EMBLEM,
		TppTerminal.MBDVCMENU.MBM_CUSTOM_AVATAR,

		TppTerminal.MBDVCMENU.MBM_DEVELOP,
		TppTerminal.MBDVCMENU.MBM_DEVELOP_WEAPON,
		TppTerminal.MBDVCMENU.MBM_DEVELOP_ARMS,
		TppTerminal.MBDVCMENU.MBM_RESOURCE,
		TppTerminal.MBDVCMENU.MBM_STAFF,
		TppTerminal.MBDVCMENU.MBM_COMBAT,
		TppTerminal.MBDVCMENU.MBM_BASE,
		TppTerminal.MBDVCMENU.MBM_DB,
		TppTerminal.MBDVCMENU.MBM_DB_ENCYCLOPEDIA,
		TppTerminal.MBDVCMENU.MBM_DB_KEYITEM,
		TppTerminal.MBDVCMENU.MBM_DB_CASSETTE,
		TppTerminal.MBDVCMENU.MBM_LOG,

		TppTerminal.MBDVCMENU.MSN,
		TppTerminal.MBDVCMENU.MSN_EMERGENCIE_N,
		TppTerminal.MBDVCMENU.MSN_EMERGENCIE_F,
		TppTerminal.MBDVCMENU.MSN_DROP,
		TppTerminal.MBDVCMENU.MSN_DROP_BULLET,
		TppTerminal.MBDVCMENU.MSN_DROP_WEAPON,
		TppTerminal.MBDVCMENU.MSN_DROP_LOADOUT,
		TppTerminal.MBDVCMENU.MSN_DROP_VEHICLE,

		TppTerminal.MBDVCMENU.MSN_ATTACK,
		TppTerminal.MBDVCMENU.MSN_ATTACK_ARTILLERY,
		TppTerminal.MBDVCMENU.MSN_ATTACK_SMOKE,
		TppTerminal.MBDVCMENU.MSN_ATTACK_SLEEP,
		TppTerminal.MBDVCMENU.MSN_ATTACK_CHAFF,
		TppTerminal.MBDVCMENU.MSN_ATTACK_WEATHER,
		TppTerminal.MBDVCMENU.MSN_ATTACK_WEATHER_SANDSTORM,
		TppTerminal.MBDVCMENU.MSN_ATTACK_WEATHER_STORM,
		TppTerminal.MBDVCMENU.MSN_ATTACK_WEATHER_CLEAR,
		TppTerminal.MBDVCMENU.MSN_HELI,
		TppTerminal.MBDVCMENU.MSN_HELI_RENDEZVOUS,
		TppTerminal.MBDVCMENU.MSN_HELI_ATTACK,
		TppTerminal.MBDVCMENU.MSN_HELI_DISMISS,
		TppTerminal.MBDVCMENU.MSN_MISSIONLIST,
		TppTerminal.MBDVCMENU.MSN_SIDEOPSLIST,
		TppTerminal.MBDVCMENU.MSN_LOCATION,
		TppTerminal.MBDVCMENU.MSN_FOB,
		TppTerminal.MBDVCMENU.MSN_FRIEND,
		TppTerminal.MBDVCMENU.MSN_LOG,
	})
end

function this.ResetUiSetting()
	TppTerminal.SetActiveTerminalMenu({
		TppTerminal.MBDVCMENU.ALL,
	})
end

this.CountDestroyedTanks = {

	[1] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("1 dying!!")
		s10260_radio.QuietIsGo()
	end,

	[2] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("2 dying!! start next wave")
		s10260_enemy.CreateWave({ waveList = s10260_enemy.WAVE_02 })
		s10260_radio.Reinforcement()
	end,

	[3] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("3 dying!! start next sequence")
		TppSequence.SetNextSequence("Seq_Game_MainGame_02_Phase02")
		this.MoveQuiet()
		s10260_enemy.CreateWave({ waveList = s10260_enemy.WAVE_03 })
	end,

	[5] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("5 dying!! start next wave")
	end,

	[6] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("6 dying!! start next wave")
		TppSequence.SetNextSequence("Seq_Game_MainGame_02_Phase03")
		this.MoveQuiet()
	end,

	[7] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("7 dying!! go next sequence")
	end,

	[9] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("10 dying!! go next sequence")
		s10260_enemy.CreateWave({ waveList = s10260_enemy.WAVE_06 })
		TppSequence.SetNextSequence("Seq_Game_MainGame_02_Phase04")
		s10260_radio.StillComing()
		this.MoveQuiet()
	end,

	[10] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("10 dying!! go next sequence")
		this.EnemyHeliSetRoute("enemyHeliRoute0000")
		s10260_radio.FewRemain()
	end,

	[11] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("11 dying!! go next sequence")
		s10260_enemy.CreateWave({ waveList = s10260_enemy.WAVE_07 })
	end,

	[12] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("12 dying!! go next sequence")
		s10260_enemy.CreateWave({ waveList = s10260_enemy.WAVE_08 })
		this.MoveQuiet()
	end,

	[13] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("13 dying!! go next sequence")
		s10260_radio.NoEnemyInSight()
	end,

	[15] = function(gameObjectId, routeId, routeNode, messageId)
		Fox.Log("All dying!! go next sequence")
		TppSequence.SetNextSequence("Seq_Demo_AfterTankBattle")
	end,
}

function this.CountDyingTank(gameObjectId, state)
	if state ~= StrCode32("Start") then
		svars.bossDyingNum = svars.bossDyingNum + 1
		local TankDestroyedNumber = svars.bossDyingNum
		Fox.Log("parasite dying : " .. svars.bossDyingNum)
		if
			this.CountDestroyedTanks
			and this.CountDestroyedTanks[TankDestroyedNumber]
			and Tpp.IsTypeFunc(this.CountDestroyedTanks[TankDestroyedNumber])
		then
			this.CountDestroyedTanks[TankDestroyedNumber](TankDestroyedNumber)
		end
	end
end

function this.Messages()
	return StrCode32Table({
		GameObject = {
			{
				msg = "Dead",
				func = function(arg)
					if arg == GameObject.GetGameObjectId("BuddyQuietGameObjectLocator") then
						Fox.Log(" ### QuietDead ### ")
						mvars.deadNPCId = "BuddyQuietGameObjectLocator"
						TppMission.ReserveGameOver(
							TppDefine.GAME_OVER_TYPE.TARGET_DEAD,
							TppDefine.GAME_OVER_RADIO.S10260_QUIET_DEAD
						)
					end
				end,
			},

			{
				msg = "ChangeLife",
				func = function(gameObjectId, hitPoint)
					Fox.Log("### ChangeLife ### " .. tostring(hitPoint) .. "### HitPoint ###")
					svars.isQuietDamaged = true
					if gameObjectId == GameObject.GetGameObjectId("BuddyQuietGameObjectLocator") then
						if
							TppSequence.GetCurrentSequenceIndex()
								== TppSequence.GetSequenceIndex("Seq_Game_MainGame_02_Phase01")
							or TppSequence.GetCurrentSequenceIndex() == TppSequence.GetSequenceIndex(
								"Seq_Game_MainGame_02_Phase02"
							)
							or TppSequence.GetCurrentSequenceIndex() == TppSequence.GetSequenceIndex(
								"Seq_Game_MainGame_02_Phase03"
							)
							or TppSequence.GetCurrentSequenceIndex()
								== TppSequence.GetSequenceIndex("Seq_Game_MainGame_02_Phase04")
						then
							if hitPoint <= 25 then
								s10260_radio.QuietDamage_25()
							elseif hitPoint <= 50 then
								s10260_radio.QuietDamage_50()
							elseif hitPoint <= 99 then
								s10260_radio.QuietDamage_99()
							end
						end
					else
						Fox.Log(" ### ChangeLife : From Unknown GameObject ### ")
					end
				end,
			},

			{
				msg = "BuddyArrived",
				func = function(gameObjectId, moveIndex)
					if gameObjectId == GameObject.GetGameObjectId("BuddyQuietGameObjectLocator") then
						if moveIndex == 99 then
							this.QuietItemDrop()
							this.QuietReturn()
						end
					end
				end,
			},

			{
				msg = "VehicleBroken",
				func = function(gameObjectId, state)
					Fox.Log("Message : Vehicle Broken")
					if
						(gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0000))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0001))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0002))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0003))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0004))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0005))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0006))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0007))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0008))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0009))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0010))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0011))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0012))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0013))
					then
						this.CountDyingTank(gameObjectId, state)
					end
				end,
			},

			{
				msg = "FultonFailed",
				func = function(gameObjectId, locatorName, locatorNameUpper, failureType)
					if
						(gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0000))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0001))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0002))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0003))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0004))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0005))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0006))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0007))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0008))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0009))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0010))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0011))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0012))
						or (gameObjectId == GameObject.GetGameObjectId(ENEMY_VEHICLE_0013))
					then
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
							this.CountDyingTank(gameObjectId)
						else
							Fox.Log(" ### FultonFailed:But Not Dead ### ")
						end
					end
				end,
			},

			{
				msg = "RoutePoint2",
				func = function(gameObjectId, routeId, routeNode, messageId)
					Fox.Log(" ### Message : RoutePoint2 :" .. tostring(messageId) .. " ### ")
					if messageId == StrCode32("EnemyComesFront") then
						s10260_radio.EnemyComesFront()
					elseif messageId == StrCode32("EnemyComesRight") then
						s10260_radio.EnemyComesRight()
					elseif messageId == StrCode32("EnemyComesLeft") then
						s10260_radio.EnemyComesLeft()
					elseif messageId == StrCode32("EnemyReached") then
						s10260_radio.EnemyReached()
					elseif messageId == StrCode32("StartFollowing_0000") then
						this.FollowVehiclesAi("TppVehicleLocator0000", "sol_infantry_0002", "sol_infantry_0003")
					elseif messageId == StrCode32("StartFollowing_0001") then
						this.FollowVehiclesAi("TppVehicleLocator0001", "sol_infantry_0000", "sol_infantry_0001")
					end
				end,
			},
		},

		Block = {
			{
				msg = "OnChangeLargeBlockState",
				func = function(blockName, state)
					if blockName == Fox.StrCode32("afgh_remnants") and state == StageBlock.ACTIVE then
						Fox.Log("### OnChangeLargeBlockState : Remnants ###")
						if
							TppSequence.GetCurrentSequenceIndex()
								== TppSequence.GetSequenceIndex("Seq_Game_MainGame")
							or TppSequence.GetCurrentSequenceIndex()
								== TppSequence.GetSequenceIndex("Seq_Demo_EncountQuiet")
						then
							this.DisableModel()
							this.DisableGimickDoor(true)
							TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_glas002_0000", true)
							TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_glas003_0000", true)
							TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_glas003_0001", true)
							TppDataUtility.InvisibleMeshFromIdentifier(
								"id_forDemo",
								"afgh_buld005_vrtn004_0001",
								"MESH_burn"
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_tent005_gim_n0001|srt_afgh_tent005",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas002",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas004",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0002",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_wndw003_wdfm003_gim_n0001|srt_afgh_wndw003_glas003_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_wndw003_wdfm003_gim_n0001|srt_afgh_wndw003_glas003_0001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
						else
							TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_0000", false)
							TppDataUtility.SetVisibleDataFromIdentifier(
								"id_forDemo",
								"afgh_buld005_vrtn004_0001",
								false
							)
							TppDataUtility.SetVisibleDataFromIdentifier(
								"id_forDemo",
								"afgh_wndw003_wdfm003_0000",
								false
							)
							TppDataUtility.SetVisibleDataFromIdentifier(
								"id_forDemo",
								"afgh_wndw003_wdfm003_00001",
								false
							)
							TppDataUtility.SetVisibleDataFromIdentifier(
								"id_forDemo",
								"afgh_wndw003_wdfm003_00002",
								false
							)
							TppDataUtility.SetVisibleDataFromIdentifier(
								"id_forDemo",
								"afgh_buld005_wndw001_0000",
								false
							)
							TppDataUtility.SetVisibleDataFromIdentifier("id_for10260", "tent_collition", false)
							TppDataUtility.SetVisibleDataFromIdentifier("id_for10260", "tent01", false)
							TppDataUtility.SetVisibleDataFromIdentifier("id_for10260", "tent02", false)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_tent005_gim_n0001|srt_afgh_tent005",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas002",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas004",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0002",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas005_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_wndw003_wdfm003_gim_n0001|srt_afgh_wndw003_glas003_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_wndw003_wdfm003_gim_n0001|srt_afgh_wndw003_glas003_0001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0002",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0003",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0004",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0005",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_wndw003_wdfm003_gim_n0003|srt_afgh_wndw003_glas003_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_wndw003_wdfm003_gim_n0003|srt_afgh_wndw003_glas003_0001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_wndw003_wdfm003_gim_n0002|srt_afgh_wndw003_glas003_0000",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
							Gimmick.InvisibleGimmick(
								-1,
								"afgh_wndw003_wdfm003_gim_n0002|srt_afgh_wndw003_glas003_0001",
								"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
								true
							)
						end
					end
				end,
			},
		},

		Player = {
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
		nil,
	})
end

sequences.Seq_Game_MainGame = {

	Messages = function(self)
		return StrCode32Table({
			Player = {
				{
					msg = "OnPlayerHeliHatchOpen",
					func = function()
						s10260_radio.MissionStory()
					end,
				},
			},

			Trap = {

				{
					msg = "Enter",
					sender = "trap_playDemo_0000",
					func = function()
						Fox.Log("Trap:Change trap_playDemo_0000")
						TppSequence.SetNextSequence("Seq_Demo_EncountQuiet")
					end,
				},
			},
		})
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(-889.44543, 280.28174, 1516.5265))
			TppNetworkUtil.SessionEnableAccept(true)
			Dynamite.StartNearestEnemyThread()
		end

		TppLandingZone.DisableUnlockLandingZoneOnMission(true)
		TppTelop.StartCastTelop()
		this.ResetUiSetting()
		TppUiCommand.HideInnerZone()
		TppUiCommand.ShowInnerZone("InnerZone")
		TppHelicopter.SetDisableLandingZone({ landingZoneName = "lzs_QuietGone|lz_pfCamp_E_0000" })

		TppMission.UpdateObjective({
			objectives = {
				"default_photo_target_10",
				"default_subGoal_ContactQuiet",
				"MissionTask_ContactQuiet",
				"MissionTask_DestroyVehicles",
				"MissionTask_GetQuietTape",
				"MissionTask_CaptureVehicles",
				"MissionTask_NoDamage",
			},
			options = { isMissionStart = true },
		})

		TppMission.UpdateObjective({
			radio = {

				radioGroups = { "s0260_rtrg0100" },
			},

			objectives = {
				"default_Target_Area",
			},
			options = { isMissionStart = true },
		})
		TppRadio.SetOptionalRadio("Set_s0260_oprg0010")

		TppCassette.Acquire({
			cassetteList = { "tp_m_10260_01" },
			isShowAnnounceLog = true,
		})
	end,

	OnLeave = function() end,
}

sequences.Seq_Demo_EncountQuiet = {
	OnEnter = function()
		TppBuddyService.SetIgnoreDisableNpc(true)
		Vehicle.SetIgnoreDisableNpc(true)
		this.FuncForceVehiclesStop()
		s10260_demo.EncountQuiet(function()
			TppSequence.SetNextSequence("Seq_Demo_QuietChoked")
		end)
		TppMarker.Disable("10260_marker_Init")
	end,

	OnLeave = function()
		TppBuddyService.SetIgnoreDisableNpc(false)
		Vehicle.SetIgnoreDisableNpc(false)
		this.FuncForceVehiclesStop_disable()
		TppScriptBlock.LoadDemoBlock("Demo_QuietChoked")
	end,
}

sequences.Seq_Demo_QuietChoked = {

	Messages = function(self)
		return StrCode32Table({
			GameObject = {
				{
					msg = "BuddyAppear",
					func = function()
						Fox.Log("############# QUIET APPEARED ############# ")
						mvars.waitingBuddyBlockLoadEnd = nil
						s10260_demo.QuietChoked(function()
							TppSequence.SetNextSequence("Seq_Game_MainGame_02_Phase01")
						end)
					end,
				},
			},

			Timer = {
				{
					msg = "Finish",
					sender = "DemoForceStart",
					func = function()
						Fox.Error(
							"### DEMO FORCE START : TIME OUT. BUDDY CANNOT LOAD IN TIME. CALL LevelDesigner. ### "
						)
						s10260_demo.QuietChoked(function()
							TppSequence.SetNextSequence("Seq_Game_MainGame_02_Phase01")
						end)
					end,
				},
			},

			Demo = {

				{
					msg = "BuildingBurn",
					func = function()
						Fox.Log("Seq_Demo_QuietChoked : BuildingBurn")
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_burn001_0000", true)
						TppDataUtility.VisibleMeshFromIdentifier("id_forDemo", "afgh_buld005_vrtn004_0001", "MESH_burn")

						TppDataUtility.InvisibleMeshFromIdentifier(
							"id_forDemo",
							"afgh_buld005_glas002_0000",
							"MESH_before"
						)
						TppDataUtility.VisibleMeshFromIdentifier(
							"id_forDemo",
							"afgh_buld005_glas002_0000",
							"MESH_break_IV"
						)
						TppDataUtility.InvisibleMeshFromIdentifier(
							"id_forDemo",
							"afgh_wndw003_glas003_0000",
							"MESH_before"
						)
						TppDataUtility.VisibleMeshFromIdentifier(
							"id_forDemo",
							"afgh_wndw003_glas003_0000",
							"MESH_break_IV"
						)
						TppDataUtility.InvisibleMeshFromIdentifier(
							"id_forDemo",
							"afgh_wndw003_glas003_0001",
							"MESH_before"
						)
						TppDataUtility.VisibleMeshFromIdentifier(
							"id_forDemo",
							"afgh_wndw003_glas003_0001",
							"MESH_break_IV"
						)
						Gimmick.InvisibleGimmick(
							-1,
							"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0002",
							"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
							true
						)
						Gimmick.InvisibleGimmick(
							-1,
							"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0003",
							"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
							true
						)
						Gimmick.InvisibleGimmick(
							-1,
							"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0004",
							"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
							true
						)
						Gimmick.InvisibleGimmick(
							-1,
							"afgh_buld005_wndw001_gim_n0001|srt_afgh_buld005_glas003_0005",
							"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
							true
						)
						Gimmick.InvisibleGimmick(
							-1,
							"afgh_wndw003_wdfm003_gim_n0003|srt_afgh_wndw003_glas003_0000",
							"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
							true
						)
						Gimmick.InvisibleGimmick(
							-1,
							"afgh_wndw003_wdfm003_gim_n0003|srt_afgh_wndw003_glas003_0001",
							"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
							true
						)
						Gimmick.InvisibleGimmick(
							-1,
							"afgh_wndw003_wdfm003_gim_n0002|srt_afgh_wndw003_glas003_0000",
							"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
							true
						)
						Gimmick.InvisibleGimmick(
							-1,
							"afgh_wndw003_wdfm003_gim_n0002|srt_afgh_wndw003_glas003_0001",
							"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2",
							true
						)
					end,
					option = { isExecDemoPlaying = true },
				},

				{
					msg = "WaterFall",
					func = function()
						Fox.Log("Seq_Demo_QuietChoked : WaterFall")
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_tank003_vrtn002_0000", true)
					end,
					option = { isExecDemoPlaying = true },
				},

				{
					msg = "ChangeAsset",
					func = function()
						Fox.Log("Seq_Demo_QuietChoked:Change Asset")
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_0000", false)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_vrtn004_0001", false)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_vrtn001_0000", true)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_tank003_vrtn002_0000", false)

						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_glas002_0000", false)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_glas003_0000", false)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_glas003_0001", false)

						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_wdfm003_0000", false)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_wdfm003_00001", false)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_wndw003_wdfm003_00002", false)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "afgh_buld005_wndw001_0000", false)

						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "mafr_grbg004_vrtn002_0000", true)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "mafr_grbg004_vrtn002_0001", true)
						TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "mafr_grbg004_vrtn002_0002", true)
					end,
					option = { isExecDemoPlaying = true },
				},

				{
					msg = "ChangeRPG",
					func = function()
						Fox.Log(" ### Seq_Demo_QuietChoked : ChangeAsset ### ")
						this.GetRocketLuncher()
						mvars.AlreadyGetChangeRPG = true
					end,
					option = { isExecDemoPlaying = true },
				},

				{
					msg = "Skip",
					func = function()
						Fox.Log(" ### Seq_Demo_QuietChoked : Skip ### ")
						if not mvars.AlreadyGetChangeRPG == true then
							mvars.DemoSkipped = true
						end
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		})
	end,

	OnEnter = function()
		mvars.AlreadyGetChangeRPG = false
		mvars.DemoSkipped = false
		mvars.waitingBuddyBlockLoadEnd = true
		Gimmick.ResetGimmickData(
			"afgh_wdbx001_wdbx001_gim_i0000|TppSharedGimmick_afgh_wdbx001_wdbx001",
			"/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_asset.fox2"
		)
		s10260_enemy.CreateWave({ waveList = s10260_enemy.WAVE_00 })
		TppEnemy.SetEnable("sol_infantry_0000")
		TppEnemy.SetEnable("sol_infantry_0001")
		TppBuddy2BlockController.CallBuddy(BuddyType.QUIET, Vector3(-855, 297, 1951), -2.4)
		GkEventTimerManager.Start("DemoForceStart", 120)
	end,

	OnUpdate = function(self)
		if mvars.waitingBuddyBlockLoadEnd then
			if DebugText then
				local context = DebugText.NewContext()
				DebugText.Print(context, "Now waiting buddy block load.")
			end
			TppUI.ShowAccessIconContinue()
		end
	end,

	OnLeave = function()
		if mvars.DemoSkipped == true then
			this.GetRocketLuncher()
		end
		this.DisableGimickDoor(false)
		this.SetEventDoorLock()
		TppScriptBlock.LoadDemoBlock("Demo_AfterTankBattle")
		TppDataUtility.SetVisibleDataFromIdentifier("id_forDemo", "gntn_trsh001_irpl001", true)
		TppMission.UpdateCheckPoint({ checkPoint = "CHK_StartVsTank", atCurrentPosition = true })
	end,
}

sequences.Seq_Game_MainGame_02_Phase01 = {

	OnEnter = function()
		this.TankBattleSetting()
		this.DisableModelAfterDemo()
		TppMission.StartBossBattle()
		TppRadio.EnableCommonOptionalRadio(false)
		this.SetLookNotice(true)
		this.ChangePhase(TppGameObject.PHASE_ALERT)
		this.KeepAlert()
		this.SetIngnoreCoop()
		this.SetCannonTime(12.0)
		this.AimSubLasPos(40)
		TppSound.SetSceneBGM("bgm_tankbattle_01")
		s10260_enemy.CreateWave({ waveList = s10260_enemy.WAVE_01 })
		TppMission.UpdateObjective({
			radio = {

				radioGroups = { "s0260_rtrg0120" },
			},

			objectives = {
				"default_ProtectQuiet",
				"default_subGoal_RejectTanks",
				"ClearTask_ContactQuiet",
				"OpenMissionTask_DestroyVehicles",
			},
			options = { isMissionStart = true },
		})
		TppRadio.SetOptionalRadio("Set_s0260_oprg0020")
	end,

	OnLeave = function() end,
}

sequences.Seq_Game_MainGame_02_Phase02 = {

	OnEnter = function()
		this.AimSubLasPos(35)
		this.SetCannonTime(10.0)
		this.SetCombatLocator("sol_infantry_0006", "TppCombatLocatorData0004")
		this.SetCombatLocator("sol_infantry_0007", "TppCombatLocatorData0004")
	end,

	OnLeave = function()
		TppMission.UpdateCheckPoint({
			checkPoint = "CHK_Interval",
			ignoreAlert = true,
		})
	end,
}

sequences.Seq_Game_MainGame_02_Phase03 = {
	Messages = function(self)
		return StrCode32Table({
			GameObject = {
				{
					msg = "RoutePoint2",
					func = function(gameObjectId, routeId, routeNode, messageId)
						Fox.Log(" ### Message : RoutePoint2 :" .. tostring(messageId) .. " ### ")

						if messageId == StrCode32("LunchRocket01") then
							if mvars.isRocketLunched01 == false then
								this.LunchRocket("sol_tank_0006", -898.320, 288.046, 1919.811)
								mvars.isRocketLunched01 = true
							end
						elseif messageId == StrCode32("LunchRocket02") then
							if mvars.isRocketLunched02 == false then
								this.LunchRocket("sol_tank_0006", -874.796, 297.652, 1922.942)
								mvars.isRocketLunched02 = true
							end
						elseif messageId == StrCode32("route0007_End") then
							mvars.route0007_End_Count = mvars.route0007_End_Count + 1
							if mvars.route0007_End_Count == 1 then
								this.ReleaseEnemies(
									"TppVehicleLocator0007",
									"sol_tank_0007",
									"sol_infantry_riders_0000",
									"sol_infantry_riders_0001",
									"sol_infantry_riders_0002"
								)
								this.Kamikaze("sol_infantry_riders_0000", true)
								this.Kamikaze("sol_infantry_riders_0001", true)
								this.Kamikaze("sol_infantry_riders_0002", true)
							end
						elseif messageId == StrCode32("route0008_End") then
							mvars.route0008_End_Count = mvars.route0008_End_Count + 1
							if mvars.route0008_End_Count == 1 then
								this.ReleaseEnemies(
									"TppVehicleLocator0008",
									"sol_tank_0008",
									"sol_infantry_riders_0003",
									"sol_infantry_riders_0004",
									"sol_infantry_riders_0005"
								)
								this.Kamikaze("sol_infantry_riders_0003", true)
								this.Kamikaze("sol_infantry_riders_0004", true)
								this.Kamikaze("sol_infantry_riders_0005", true)
							end
						else
							Fox.Log("NO ROUTE MESSAGE")
						end
					end,
				},
			},
		})
	end,

	OnEnter = function()
		this.TankBattleSetting()
		this.DisableModelAfterDemo()
		TppMission.StartBossBattle()
		s10260_enemy.fleeEnemies()
		this.SetLookNotice(true)
		s10260_enemy.CreateWave({ waveList = s10260_enemy.WAVE_04 })
		s10260_enemy.CreateWave({ waveList = s10260_enemy.WAVE_05 })
		s10260_radio.interval()
		s10260_radio.intervalHint()
		mvars.isRocketLunched01 = false
		mvars.isRocketLunched02 = false
		mvars.route0007_End_Count = 0
		mvars.route0008_End_Count = 0
		this.ChangePhase(TppGameObject.PHASE_ALERT)
		this.KeepAlert()
		this.UnSetIngnoreCoop()
		this.AimSubLasPos(30)
		this.SetCannonTime(9.0)
		TppSound.SetSceneBGM("bgm_tankbattle_02")
	end,

	OnLeave = function() end,
}

sequences.Seq_Game_MainGame_02_Phase04 = {
	Messages = function(self)
		return StrCode32Table({
			GameObject = {

				{
					msg = "LostControl",
					sender = "EnemyHeli",
					func = function(gameObjectId, state)
						Fox.Log("Message : Lost Control")
						this.CountDyingTank(gameObjectId, state)
					end,
				},

				{
					msg = "RoutePoint2",
					sender = "EnemyHeli",
					func = function(gameObjectId, routeId, routeNode, messageId)
						if messageId == StrCode32("enemyHeliArrived") then
							Fox.Log("Message : RoutePoint2 : enemyHeliArrived")
							s10260_radio.enemyChopperComes()
							this.EnemyHeliUnsetRoute()
						else
							Fox.Log("NO ROUTE MESSAGE")
						end
					end,
				},

				{
					msg = "Returned",
					sender = "EnemyHeli",
					func = function(gameObjectId)
						this.CountDyingTank(gameObjectId)
					end,
				},
			},
		})
	end,

	OnEnter = function()
		this.SetIngnoreCoop()
		this.AimSubLasPos(25)
		this.SetCannonTime(8.0)
	end,

	OnLeave = function()
		this.ChangePhase(TppGameObject.PHASE_CAUTION)
		this.EnableQuietDying(true)
	end,
}

sequences.Seq_Demo_AfterTankBattle = {

	Messages = function(self)
		return StrCode32Table({
			Demo = {
				{
					msg = "CreateSandStorm",
					func = function(demoId)
						Fox.Log("Seq_Demo_AfterTankBattle : CreateSandStorm")
						this.CreateSandStorm(20)
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		})
	end,

	OnEnter = function()
		this.DeleateUserVehicle()
		TppSound.StopSceneBGM()
		this.VanishEnemyHeli()
		s10260_enemy.DisableBossEnemies()
		s10260_demo.AfterTankBattle(function()
			TppSequence.SetNextSequence("Seq_Game_MainGame_03")
		end)
	end,

	OnLeave = function()
		TppScriptBlock.LoadDemoBlock("Demo_SnakeBite_01")
		TppMission.UpdateCheckPoint({ checkPoint = "CHK_StartEscape", atCurrentPosition = true })
	end,
}

sequences.Seq_Game_MainGame_03 = {

	Messages = function(self)
		return StrCode32Table({

			GameObject = {
				{
					msg = "Carried",
					func = function(gameObjectId, carriedState)
						Fox.Log(" ### Carried ### ")
						if
							(gameObjectId == GameObject.GetGameObjectId("BuddyQuietGameObjectLocator"))
							and (carriedState == TppGameObject.NPC_CARRIED_STATE_IDLE_START)
							and (svars.sub_Flag_0000 == true)
						then
							Fox.Log(" ### QUIET:CARRIED ### ")
							this.OpenMission()
							TppMission.ReserveMissionClear({
								nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI,
								missionClearType = TppDefine.MISSION_CLEAR_TYPE.ON_FOOT,
							})
						end
					end,
				},
			},

			Trap = {

				{
					msg = "Enter",
					sender = "trap_playDemo_0001",
					func = function()
						Fox.Log(" ### Trap:Enter_trap_playDemo_0001 ### ")
						svars.sub_Flag_0000 = true
						local gameObjectId = { type = "TppBuddyQuiet2", index = 0 }
						local command = { id = "GetStatus" }
						local actionStatus = GameObject.SendCommand(gameObjectId, command)
						if actionStatus == TppGameObject.NPC_STATE_CARRIED then
							Fox.Log(" ### QUIET:CARRIED ### ")
							this.OpenMission()
							TppMission.ReserveMissionClear({
								nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI,
								missionClearType = TppDefine.MISSION_CLEAR_TYPE.ON_FOOT,
							})
						else
							Fox.Log(" ### QUIET:NOT CARRIED ### ")
						end

						if svars.isQuietDamaged == false then
							TppResult.AcquireSpecialBonus({ second = { isComplete = true } })
						end
					end,
				},

				{
					msg = "Exit",
					sender = "trap_playDemo_0001",
					func = function()
						Fox.Log(" ### Trap:Exit_trap_playDemo_0001 ### ")
						svars.sub_Flag_0000 = false
					end,
				},
			},

			Terminal = {
				{
					msg = "MbDvcActSelectNonActiveMenu",
					func = function(menuId)
						Fox.Log("Message : MbDvcActSelectNonActiveMenu")
						s10260_radio.CannotCallAllMenu()
					end,
				},
			},
		})
	end,

	OnEnter = function()
		this.DisableModelAfterDemo()
		TppMission.FinishBossBattle()
		this.SetLookNotice(false)
		this.UnsetEquipments()
		this.CreateSandStorm(0)
		this.ChangeArea("InnerZone0000", "OuterZone0000", "InnerZone0001", "OuterZone0001")
		this.EnableQuietDown()
		this.SetEnabledHeli(false)
		this.UiSettigForAfterTankBattle()

		TppMission.UpdateObjective({
			objectives = { "default_Escape_Area", "default_photo_target_10_noRadio" },
		})

		TppMission.UpdateObjective({
			radio = {

				radioGroups = { "s0260_rtrg0380" },
			},

			objectives = { "default_subGoal_HeadToLZ", "ClearTask_DestroyVehicles" },
		})
		TppRadio.SetOptionalRadio("Set_s0260_oprg0030")
		this.EnablePatrols()
		TppUiStatusManager.SetStatus("AnnounceLog", "SUSPEND_LOG")
	end,

	OnLeave = function()
		TppMarker.Disable("BuddyQuietGameObjectLocator")
		TppMarker.Disable("10260_marker_Escape")
	end,
}

sequences.Seq_Demo_SnakeBite_01 = {

	OnEnter = function()
		s10260_demo.SnakeBite_01(function()
			TppSequence.SetNextSequence("Seq_Demo_SnakeBite_02", { isExecMissionClear = true })
		end)
	end,

	OnLeave = function()
		TppScriptBlock.LoadDemoBlock("Demo_SnakeBite_02")
	end,
}

sequences.Seq_Demo_SnakeBite_02 = {

	OnEnter = function()
		s10260_demo.SnakeBite_02(function()
			TppSequence.SetNextSequence("Seq_Demo_QuietSpeak", { isExecMissionClear = true })
		end)
	end,

	OnLeave = function()
		TppScriptBlock.LoadDemoBlock("Demo_QuietSpeak")
	end,
}

sequences.Seq_Demo_QuietSpeak = {

	Messages = function(self)
		return StrCode32Table({
			Demo = {
				{
					msg = "DestroySandStorm",
					func = function(demoId)
						Fox.Log("Seq_Demo_AfterTankBattle : DestroySandStorm")
						this.DestroySandStorm()
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		})
	end,

	OnEnter = function()
		this.HeliRealize()
		TppHelicopter.SetEnableLandingZone({ landingZoneName = "lzs_QuietGone|lz_pfCamp_E_0000" })
		s10260_demo.QuietSpeak(function()
			TppMission.MissionGameEnd()
		end)
	end,

	OnLeave = function()
		TppScriptBlock.LoadDemoBlock("Demo_QuietVanishing")
	end,
}

sequences.Seq_Demo_QuietVanishing = {

	OnEnter = function()
		this.HeliRealize()
		this.DestroySandStorm()
		s10260_demo.QuietVanishing(function()
			TppSequence.SetNextSequence("Seq_Game_MainGame_04", { isExecMissionClear = true })
			TppMain.EnablePlayerPad()
		end)
	end,

	OnLeave = function()
		this.HeliCallToLZ()
		TppMission.UpdateCheckPoint({ checkPoint = "CHK_StartEnd", atCurrentPosition = true })
	end,
}

local S10260_MAINGAME4_GAME_OVER_STATE = {
	INIT = 1,
	REQUESTED = 2,
	SHOW_GAME_OVER_MENU = 3,
}

sequences.Seq_Game_MainGame_04 = {

	Messages = function(self)
		return StrCode32Table({
			Player = {
				{

					msg = "Dead",
					func = function()
						mvars.s10260_mainGame4_gameOverState = S10260_MAINGAME4_GAME_OVER_STATE.REQUESTED
					end,
					option = { isExecMissionClear = true },
				},

				{

					msg = "Exit",
					sender = "outerZone",
					func = function()
						mvars.s10260_mainGame4_gameOverState = S10260_MAINGAME4_GAME_OVER_STATE.REQUESTED
					end,
					option = { isExecMissionClear = true },
				},
			},
			Trap = {
				{
					msg = "Enter",
					sender = "trap_playDemo_0002",
					func = function()
						Fox.Log("Trap:Change trap_playDemo_0002")
						s10260_radio.OnGameCleared()

						TppSequence.SetNextSequence("Seq_Demo_CameraForLetter", { isExecMissionClear = true })
					end,
					option = { isExecMissionClear = true },
				},

				{
					msg = "Exit",
					sender = "trap_FakeInner",
					func = function()
						Fox.Log("### Outside of alert mission area ###")
						TppUI.ShowAnnounceLog("closeOutOfMissionArea")
						TppRadio.PlayCommonRadio(TppDefine.COMMON_RADIO.OUTSIDE_MISSION_AREA)
						TppTerminal.PlayTerminalVoice("VOICE_WARN_MISSION_AREA", true, 1.0)
						TppOutOfMissionRangeEffect.Enable(3.0)
					end,
					option = { isExecMissionPrepare = true, isExecMissionClear = true },
				},
				{
					msg = "Enter",
					sender = "trap_FakeInner",
					func = function()
						Fox.Log("### Inside of alert mission area ###")
						TppOutOfMissionRangeEffect.Disable(1.0)
						TppTerminal.PlayTerminalVoice("VOICE_WARN_MISSION_AREA", false)
					end,
					option = { isExecMissionPrepare = true, isExecMissionClear = true },
				},
			},
			UI = {
				{
					msg = "GameOverOpen",
					func = TppMain.DisableGameStatusOnGameOverMenu,
					option = { isExecMissionClear = true },
				},
				{
					msg = "GameOverContinue",
					func = TppMission.ExecuteContinueFromCheckPoint,
					option = { isExecMissionClear = true },
				},
				{
					msg = "PauseMenuCheckpoint",
					func = TppMission.ContinueFromCheckPoint,
					option = { isExecMissionClear = true },
				},
			},
		})
	end,

	OnEnter = function()
		this.HeliCallForContinue()
		this.UiSettigForAfterTankBattle()

		TppSound.SkipDecendingLandingZoneJingle()
		TppSound.SkipDecendingLandingZoneWithOutCanMissionClearJingle()

		TppSoundDaemon.SetMute("HeliClosing")

		mvars.s10260_mainGame4_gameOverState = S10260_MAINGAME4_GAME_OVER_STATE.INIT
		TppPlayer.ResetDisableAction()
		TppRadio.UnregisterRadioGroupSet()
		TppSound.SetSceneBGM("bgm_footprints")
		this.SetEnabledHeli(true)
		this.HeliDisablePullOut()
		TppUiStatusManager.UnsetStatus("AnnounceLog", "SUSPEND_LOG")
		this.ChangeArea("InnerZone0001", "OuterZone0001", "InnerZone0002", "OuterZone0002")
		TppBuddyService.SetDisable(true)
		TppBuddyService.UnsetBuddyCommonFlag(BuddyCommonFlag.BUDDY_QUIET_DYING)
		TppMission.UpdateObjective({
			objectives = { "default_subGoal_FindOut" },
		})

		TppUiCommand.RegisterPauseMenuPage({
			GamePauseMenu.RESTART_FROM_CHECK_POINT,
			GamePauseMenu.OPEN_OPTION_MENU,
		})
		TppUiCommand.RegisterGameOverMenuItems({
			GameOverMenu.GAME_OVER_CONTINUE,
		})
	end,

	OnUpdate = function()
		if mvars.s10260_mainGame4_gameOverState == S10260_MAINGAME4_GAME_OVER_STATE.REQUESTED then
			mvars.s10260_mainGame4_gameOverState = S10260_MAINGAME4_GAME_OVER_STATE.SHOW_GAME_OVER_MENU
			TppMission.ShowGameOverMenu()
		end
	end,

	OnLeave = function()
		TppSoundDaemon.ResetMute("HeliClosing")
		TppSound.StopSceneBGM()
		TppScriptBlock.LoadDemoBlock("Demo_CameraForLetter")
		TppMission.UpdateObjective({
			objectives = { "announce_ObjectiveComplete", "ClearTask_GetQuietTape" },
		})
	end,
}

sequences.Seq_Demo_CameraForLetter = {

	OnEnter = function()
		TppUiStatusManager.SetStatus("AnnounceLog", "SUSPEND_LOG")
		s10260_demo.CameraForLetter(function()
			TppSequence.SetNextSequence("Seq_Demo_LetterFromQuiet", { isExecMissionClear = true })
		end)
	end,

	OnLeave = function()
		TppScriptBlock.LoadDemoBlock("Demo_LetterFromQuiet")
	end,
}

sequences.Seq_Demo_LetterFromQuiet = {

	OnEnter = function()
		s10260_demo.LetterFromQuiet(function()
			TppSequence.SetNextSequence("Seq_Demo_QuietDrifted", { isExecMissionClear = true })
		end)
	end,

	OnLeave = function()
		TppScriptBlock.LoadDemoBlock("Demo_QuietDrifted")
	end,
}

sequences.Seq_Demo_QuietDrifted = {

	Messages = function(self)
		return StrCode32Table({
			Demo = {
				{
					msg = "lostquiendrool",
					func = function(demoId)
						Fox.Log("Demo_Message : lostquiendrool")
						TppEnding.Start("Quiet")
						TppUI.StartLyricQuiet(23.0)
					end,
					option = { isExecDemoPlaying = true, isExecMissionClear = true },
				},
			},
		})
	end,

	OnEnter = function()
		TppEnding.SetEndsFile("GZEndingSetting_jp")
		s10260_demo.QuietDrifted(function()
			TppUiCommand.LyricTexture("hide")
			TppMission.ShowMissionGameEndAnnounceLog()
		end)
	end,

	OnLeave = function() end,
}

sequences.Seq_Game_Escape = {

	OnEnter = function()
		TppMission.MissionGameEnd({})
	end,
}

return this
