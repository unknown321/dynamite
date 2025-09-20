local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local TimerStart = GkEventTimerManager.StartRaw

local sequences = {}

local MISSION_NAME
local TARGET_NAME = "hos_target_0000"
local DRIVER_NAME = "sol_s10052_transportVehicle_0000"
local GUARD_NAME = "sol_s10052_transportVehicle_0001"
local EXECUTIONER_REMNANTS_NAME = "sol_s10052_Executioner_remnants_0000"
local EXECUTIONER_TENT_NAME = "sol_s10052_Executioner_tent_0000"

local EXECUTED_HOSTAGE_NAME_1 = "hos_remnants_0000"
local EXECUTED_HOSTAGE_NAME_2 = "hos_remnants_0001"
local EXECUTED_HOSTAGE_NAME_3 = "hos_remnants_0002"

local TENT_HOSTAGE_NAME_1 = "hos_tent_0000"
local TENT_HOSTAGE_NAME_2 = "hos_tent_0001"

local SUPPORT_HELI = "SupportHeli"
local TRANSPORT_VEHICLE = "veh_transportVehicle_0000"
local GUARD_VEHICLE = "veh_transportVehicle_0001"

local ALL_HOSTAGE_REMNANTS = 3
local ALL_HOSTAGE_TENT = 2

local TARGET_IN_REMNANTS = 0
local TARGET_IN_TENT = 1

local GIMMICK_NAME = {
	DOOR_REMNANTS_000 = "afgh_hutt008_door001_gim_n0001|srt_afgh_hutt008_door001",
	DOOR_TENT_000 = "gntn_wall001_door001_gim_n0000|srt_gntn_wall001_door001",
	DOOR_TENT_001 = "gntn_wall001_door001_gim_n0001|srt_gntn_wall001_door001",
	DOOR_TENT_002 = "gntn_wall001_door001_gim_n0002|srt_gntn_wall001_door001",
}

local GIMMICK_PATH = {
	REMNANTS = "/Assets/tpp/level/location/afgh/block_large/remnants/afgh_remnants_gimmick.fox2",
	TENT = "/Assets/tpp/level/location/afgh/block_large/tent/afgh_tent_gimmick.fox2",
}

local drawRouteList = {

	[1] = {
		Vector3(-859.08581542969, 285.21942138672, 1906.1018066406),
		Vector3(-879.55462646484, 285.86206054688, 1859.3969726563),
		Vector3(-880.19171142578, 290.2041015625, 1814.8795166016),
		Vector3(-907.25524902344, 289.83776855469, 1693.0522460938),
		Vector3(-950.44708251953, 291.87194824219, 1651.33203125),
		Vector3(-967.92736816406, 292.83544921875, 1600.5180664063),
		Vector3(-963.96862792969, 292.87860107422, 1555.8970947266),
		Vector3(-983.85980224609, 292.11389160156, 1503.4844970703),
		Vector3(-1047.2803955078, 289.9931640625, 1455.4591064453),
		Vector3(-1110.2307128906, 289.56851196289, 1428.8797607422),
		Vector3(-1158.8184814453, 288.74609375, 1391.4769287109),
		Vector3(-1229.8486328125, 295.28594970703, 1264.5120849609),
		Vector3(-1331.5617675781, 297.29092407227, 1175.8989257813),
		Vector3(-1533.2375488281, 317.91186523438, 1145.2424316406),
		Vector3(-1603.6722412109, 311.57217407227, 1092.5113525391),
		Vector3(-1691.9565429688, 306.02453613281, 967.59356689453),
		Vector3(-1703.3657226563, 306.62878417969, 858.50561523438),
		Vector3(-1669.2515869141, 305.31317138672, 810.63610839844),
		Vector3(-1743.9819335938, 310.69467163086, 807.3759765625),
	},

	[2] = {
		Vector3(-859.08581542969, 285.21942138672, 1906.1018066406),
		Vector3(-879.55462646484, 285.86206054688, 1859.3969726563),
		Vector3(-880.19171142578, 290.2041015625, 1814.8795166016),
		Vector3(-907.25524902344, 289.83776855469, 1693.0522460938),
		Vector3(-950.44708251953, 291.87194824219, 1651.33203125),
		Vector3(-967.92736816406, 292.83544921875, 1600.5180664063),
		Vector3(-963.96862792969, 292.87860107422, 1555.8970947266),
		Vector3(-983.85980224609, 292.11389160156, 1503.4844970703),
		Vector3(-1047.2803955078, 289.9931640625, 1455.4591064453),
		Vector3(-1110.2307128906, 289.56851196289, 1428.8797607422),
		Vector3(-1158.8184814453, 288.74609375, 1391.4769287109),
		Vector3(-1229.8486328125, 295.28594970703, 1264.5120849609),
		Vector3(-1299.1060791016, 295.77932739258, 1199.2358398438),
		Vector3(-1404.0336914063, 301.03927612305, 1039.5500488281),
		Vector3(-1383.8725585938, 301.16595458984, 974.92395019531),
		Vector3(-1453.4377441406, 300.49130249023, 947.38330078125),
		Vector3(-1493.2576904297, 297.79528808594, 909.14019775391),
		Vector3(-1573.2214355469, 301.85629272461, 924.58190917969),
		Vector3(-1614.1596679688, 303.27682495117, 842.27893066406),
		Vector3(-1669.2515869141, 305.31317138672, 810.63610839844),
		Vector3(-1743.9819335938, 310.69467163086, 807.3759765625),
	},

	[3] = {
		Vector3(-859.08581542969, 285.21942138672, 1906.1018066406),
		Vector3(-879.55462646484, 285.86206054688, 1859.3969726563),
		Vector3(-880.19171142578, 290.2041015625, 1814.8795166016),
		Vector3(-907.25524902344, 289.83776855469, 1693.0522460938),
		Vector3(-950.44708251953, 291.87194824219, 1651.33203125),
		Vector3(-967.92736816406, 292.83544921875, 1600.5180664063),
		Vector3(-963.96862792969, 292.87860107422, 1555.8970947266),
		Vector3(-983.85980224609, 292.11389160156, 1503.4844970703),
		Vector3(-1033.5231933594, 289.53277587891, 1460.7841796875),
		Vector3(-1015.705078125, 305.27194213867, 1243.7102050781),
		Vector3(-1081.8931884766, 324.69964599609, 1155.7434082031),
		Vector3(-1038.3820800781, 307.21502685547, 1045.4780273438),
		Vector3(-1015.9256591797, 300.27630615234, 968.47705078125),
		Vector3(-1141.9438476563, 302.01947021484, 912.04864501953),
		Vector3(-1248.8297119141, 302.58166503906, 931.54876708984),
		Vector3(-1326.017578125, 301.89813232422, 972.76147460938),
		Vector3(-1383.8725585938, 301.16595458984, 974.92395019531),
		Vector3(-1453.4377441406, 300.49130249023, 947.38330078125),
		Vector3(-1493.2576904297, 297.79528808594, 909.14019775391),
		Vector3(-1573.2214355469, 301.85629272461, 924.58190917969),
		Vector3(-1614.1596679688, 303.27682495117, 842.27893066406),
		Vector3(-1669.2515869141, 305.31317138672, 810.63610839844),
		Vector3(-1743.9819335938, 310.69467163086, 807.3759765625),
	},
}

local MARKER_NAME = {
	AREA_REMNANTS = "s10052_marker_areaRemnants",
	AREA_TENT_LV1 = "s10052_marker_areaTent_lv1",
	AREA_TENT_LV2 = "s10052_marker_areaTent_lv2",
	AREA_TENT_LV3 = "s10052_marker_areaTent_lv3",
	REMNANTS_HOSTAGE_1 = "s10052_marker_remnantsHostage_0",
	REMNANTS_HOSTAGE_2 = "s10052_marker_remnantsHostage_1",
	REMNANTS_HOSTAGE_3 = "s10052_marker_remnantsHostage_2",
	REMNANTS_INTEL_FILE = "s10052_marker_intelFile",
}

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

this.MAX_PLACED_LOCATOR_COUNT = 50

this.NPC_ENTRY_POINT_SETTING = {
	[Fox.StrCode32("lz_drp_remnants_S0000|rt_drp_remnants_S_0000")] = {
		[EntryBuddyType.VEHICLE] = { Vector3(-426.173, 282.098, 1997.011), TppMath.DegreeToRadian(-131.9) },
		[EntryBuddyType.BUDDY] = { Vector3(-431.167, 282.098, 2005.659), -131.9 },
	},
}

function this.OnLoad()
	Fox.Log("#### s10052_sequence.OnLoad ####")

	TppSequence.RegisterSequences({

		"Seq_Game_MainGame",
		"Seq_Game_Escape",
		nil,
	})
	TppSequence.RegisterSequenceTable(sequences)
end

this.saveVarsList = {
	infoCount = 0,
	eventCount = 1,
	talkCount = 1,
	tortureCount = 1,

	interCount_driver = 0,
	interCount_guard = 0,
	interCount_executioner_remnants = 0,
	interCount_executioner_tent = 0,

	executeRouteName_S = "",
	executeRouteName_C = "",

	isArrivedRemnants = false,
	isArrivedTent = false,

	isRadioTrigger_1 = false,
	isRadioTrigger_2 = false,
	isRadioTrigger_3 = false,

	isGetInfoFromEnemy = false,
	isGetInfoFromFile = false,
	isGetInfoFromHostage = false,
	isGetInfoFromDriver = false,

	isTargetMarked = false,
	isTargetMarkedWithCarry = false,
	isTargetFoundOnVehicle = false,
	isTargetRescue = false,
	isTargetRaidHeli = false,
	isFirstTimeEscape = true,

	isDiscoverdEscape_Target = false,
	isDiscoverdEscape_1 = false,
	isDiscoverdEscape_2 = false,
	isDiscoverdEscape_3 = false,

	isPermitMarkedHostage_1 = true,
	isPermitMarkedHostage_2 = true,
	isPermitMarkedHostage_3 = true,

	isSkipOnEmergency = false,
	isOverlapCheckPhase = false,
	isActiveEventAnimalBlock = false,
	isStayPlayerInAnimalTrap = false,
	isSkipAnimalEvent = false,
	isVehicleArrivedTent = false,
	isVehicleArrivedTent_Caution = false,
	isTargetRideOnVehicleSequence = true,

	isTalkTime = false,
	isDriveTime = false,
	isTortureTime = false,

	isNearTarget = false,
	isHearTransportProject = false,
	isReactionOnEvent_1 = false,
	isReactionOnEvent_2 = false,
	isReactionOnEvent_3 = false,
	isReactionOnEvent_4 = false,
	isReactionOnEvent_5 = false,

	isRecoveryWAV = false,
	rescueHostageCount_remnants = 0,
	rescueHostageCount_tent = 0,
	isHearLastConversation = false,

	tempSvars_001 = false,
	tempSvars_002 = false,
	tempSvars_003 = false,
	tempSvars_004 = false,
	tempSvars_005 = false,
	tempSvars_006 = false,
	tempSvars_007 = false,
	tempSvars_008 = false,
	tempSvars_009 = false,
	tempSvars_010 = false,
	tempSvars_011 = false,
	tempSvars_012 = false,
	tempSvars_013 = false,
	tempSvars_014 = false,
	tempSvars_015 = false,
	tempSvars_016 = false,
	tempSvars_017 = false,
	tempSvars_018 = false,
	tempSvars_019 = false,
	tempSvars_020 = false,
}

this.checkPointList = {
	nil,
}

this.baseList = {

	"remnants",
	"tent",

	"remnantsNorth",
	"fieldWest",
	"tentEast",
	"tentNorth",
	nil,
}

this.s10052_baseOnActiveTable = {
	afgh_remnants = function()
		this.ResetGimmick("remnants")
	end,
	afgh_tent = function()
		this.ResetGimmick("tent")
	end,
}

this.MISSION_TASK_TARGET_LIST_REMNANTS = {
	"hos_remnants_0000",
	"hos_remnants_0001",
	"hos_remnants_0002",
}

this.MISSION_TASK_TARGET_LIST_TENT = {
	"hos_tent_0000",
	"hos_tent_0001",
}

this.MISSION_TASK_TARGET_LIST_VEHICLE = {
	"veh_transportVehicle_0001",
}

this.specialBonus = {
	first = {
		missionTask = { taskNo = 2 },
	},
	second = {
		missionTask = { taskNo = 3 },
		pointList = {
			2500,
			5000,
			7500,
		},
	},
}

this.VARIABLE_TRAP_SETTING = {
	{
		name = "trap_intelAtRemnants",
		type = TppDefine.TRAP_TYPE.NORMAL,
		initialState = TppDefine.TRAP_STATE.DISABLE,
	},
	{
		name = "trap_intelMarkAreaRemnants",
		type = TppDefine.TRAP_TYPE.NORMAL,
		initialState = TppDefine.TRAP_STATE.DISABLE,
	},
}

this.missionObjectiveEnum = Tpp.Enum({

	"targetCpSetting",

	"area_remnants",
	"area_tent_lv0",
	"area_tent_lv1",
	"area_tent_lv2",
	"area_tent_lv3",
	"foundTarget_subGoal",
	"foundTarget_subGoal_withMark",
	"escape_subGoal",
	"default_photo_target",
	"vehicle_route_correct",
	"vehicle_route_dummy_01",
	"vehicle_route_dummy_02",
	"remnants_hostage_1",
	"remnants_hostage_2",
	"remnants_hostage_3",

	"intelFile_remnants",
	"intelFile_remnants_get",

	"default_missionTask_01",
	"default_missionTask_02",
	"default_missionTask_03",
	"default_missionTask_04",
	"default_missionTask_05",

	"appear_missionTask_03",
	"appear_missionTask_04",

	"complete_missionTask_01",
	"complete_missionTask_02",
	"complete_missionTask_03",
	"complete_missionTask_04",
	"complete_missionTask_05",

	"tent_hostage_1",
	"tent_hostage_2",
	"hud_photo_flee",

	"targetExtract",
	"achieveObjective",
})

this.missionObjectiveDefine = {

	targetCpSetting = {
		targetBgmCp = "afgh_remnants_cp",
	},

	area_remnants = {
		gameObjectName = MARKER_NAME.AREA_REMNANTS,
		visibleArea = 3,
		randomRange = 0,
		setNew = false,
		viewType = "all",
		announceLog = "updateMap",
		subGoalId = 0,
		mapRadioName = "s0052_mprg1010",
		langId = "marker_info_mission_targetArea",
	},

	area_tent_lv0 = {
		announceLog = "updateMap",
		subGoalId = 0,
	},

	area_tent_lv1 = {
		gameObjectName = MARKER_NAME.AREA_TENT_LV1,
		visibleArea = 5,
		randomRange = 0,
		setNew = false,
		viewType = "map",
		announceLog = "updateMap",
		subGoalId = 0,
		mapRadioName = "f1000_mprg0110",
		langId = "marker_info_mission_targetArea",
	},

	area_tent_lv2 = {
		gameObjectName = MARKER_NAME.AREA_TENT_LV2,
		visibleArea = 5,
		randomRange = 0,
		setNew = false,
		viewType = "map",
		announceLog = "updateMap",
		subGoalId = 0,
		mapRadioName = "f1000_mprg0120",
		langId = "marker_info_mission_targetArea",
	},

	area_tent_lv3 = {
		gameObjectName = MARKER_NAME.AREA_TENT_LV3,
		visibleArea = 1,
		randomRange = 0,
		setNew = false,
		viewType = "map",
		announceLog = "updateMap",
		subGoalId = 0,
		mapRadioName = "s0052_mprg3035",
		langId = "marker_info_mission_targetArea",
	},

	remnants_hostage_1 = {
		gameObjectName = EXECUTED_HOSTAGE_NAME_1,
		visibleArea = 0,
		randomRange = 0,
		setNew = true,
		viewType = "map_and_world_only_icon",
		announceLog = "updateMap",
		langId = "marker_hostage",
	},
	remnants_hostage_2 = {
		gameObjectName = EXECUTED_HOSTAGE_NAME_2,
		visibleArea = 0,
		randomRange = 0,
		setNew = true,
		viewType = "map_and_world_only_icon",
		langId = "marker_hostage",
	},
	remnants_hostage_3 = {
		gameObjectName = EXECUTED_HOSTAGE_NAME_3,
		visibleArea = 0,
		randomRange = 0,
		setNew = true,
		viewType = "map_and_world_only_icon",
		langId = "marker_hostage",
	},

	intelFile_remnants = {
		gameObjectName = MARKER_NAME.REMNANTS_INTEL_FILE,
	},

	intelFile_remnants_get = {},

	default_photo_target = {
		photoId = 10,
		addFirst = true,
		photoRadioName = "s0052_mirg0010",
	},

	foundTarget_subGoal = {
		gameObjectName = TARGET_NAME,
		goalType = "defend",
		viewType = "map_and_world_only_icon",
		announceLog = "updateMap",
		setImportant = true,
		langId = "marker_info_mission_target",
		subGoalId = 0,
	},
	foundTarget_subGoal_withMark = {},
	escape_subGoal = {
		gameObjectName = TARGET_NAME,
		goalType = "defend",
		viewType = "map_and_world_only_icon",
		announceLog = "updateMissionInfo",
		setImportant = true,
		langId = "marker_info_mission_target",
		subGoalId = 2,
	},

	default_missionTask_01 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false },
	},
	complete_missionTask_01 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = true },
	},

	default_missionTask_02 = {
		missionTask = { taskNo = 2, isNew = false, isComplete = false, isFirstHide = true },
	},
	complete_missionTask_02 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = true },
	},

	default_missionTask_03 = {
		missionTask = { taskNo = 3, isNew = false, isComplete = false, isFirstHide = true },
	},
	appear_missionTask_03 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = false },
	},
	complete_missionTask_03 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = true },
	},

	default_missionTask_04 = {
		missionTask = { taskNo = 4, isNew = false, isComplete = false, isFirstHide = true },
	},
	appear_missionTask_04 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = false },
	},
	complete_missionTask_04 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = true },
	},

	default_missionTask_05 = {
		missionTask = { taskNo = 5, isNew = false, isComplete = false, isFirstHide = true },
	},
	complete_missionTask_05 = {
		missionTask = { taskNo = 5, isNew = true, isComplete = true },
	},

	vehicle_route_correct = {
		showEnemyRoutePoints = {
			groupIndex = 0,
			width = 50.0,
			langId = "marker_target_forecast_path",
			radioGroupName = "s0052_mprg4010",
			points = {
				Vector3(-1743.9819335938, 310.69467163086, 807.3759765625),
				Vector3(-1669.2515869141, 305.31317138672, 810.63610839844),
				Vector3(-1703.3657226563, 306.62878417969, 858.50561523438),
				Vector3(-1691.9565429688, 306.02453613281, 967.59356689453),
				Vector3(-1603.6722412109, 311.57217407227, 1092.5113525391),
				Vector3(-1533.2375488281, 317.91186523438, 1145.2424316406),
				Vector3(-1331.5617675781, 297.29092407227, 1175.8989257813),
				Vector3(-1229.8486328125, 295.28594970703, 1264.5120849609),
				Vector3(-1158.8184814453, 288.74609375, 1391.4769287109),
				Vector3(-1110.2307128906, 289.56851196289, 1428.8797607422),
				Vector3(-1047.2803955078, 289.9931640625, 1455.4591064453),
				Vector3(-983.85980224609, 292.11389160156, 1503.4844970703),
				Vector3(-963.96862792969, 292.87860107422, 1555.8970947266),
				Vector3(-967.92736816406, 292.83544921875, 1600.5180664063),
				Vector3(-950.44708251953, 291.87194824219, 1651.33203125),
				Vector3(-907.25524902344, 289.83776855469, 1693.0522460938),
				Vector3(-880.19171142578, 290.2041015625, 1814.8795166016),
				Vector3(-879.55462646484, 285.86206054688, 1859.3969726563),
				Vector3(-859.08581542969, 285.21942138672, 1906.1018066406),
			},
		},
	},
	vehicle_route_dummy_01 = {
		showEnemyRoutePoints = {
			groupIndex = 1,
			width = 20.0,
			langId = "marker_target_forecast_path",
			points = {
				Vector3(-1743.9819335938, 310.69467163086, 807.3759765625),
				Vector3(-1669.2515869141, 305.31317138672, 810.63610839844),
				Vector3(-1614.1596679688, 303.27682495117, 842.27893066406),
				Vector3(-1573.2214355469, 301.85629272461, 924.58190917969),
				Vector3(-1493.2576904297, 297.79528808594, 909.14019775391),
				Vector3(-1453.4377441406, 300.49130249023, 947.38330078125),
				Vector3(-1383.8725585938, 301.16595458984, 974.92395019531),
				Vector3(-1404.0336914063, 301.03927612305, 1039.5500488281),
				Vector3(-1299.1060791016, 295.77932739258, 1199.2358398438),
				Vector3(-1229.8486328125, 295.28594970703, 1264.5120849609),
				Vector3(-1158.8184814453, 288.74609375, 1391.4769287109),
				Vector3(-1110.2307128906, 289.56851196289, 1428.8797607422),
				Vector3(-1047.2803955078, 289.9931640625, 1455.4591064453),
				Vector3(-983.85980224609, 292.11389160156, 1503.4844970703),
				Vector3(-963.96862792969, 292.87860107422, 1555.8970947266),
				Vector3(-967.92736816406, 292.83544921875, 1600.5180664063),
				Vector3(-950.44708251953, 291.87194824219, 1651.33203125),
				Vector3(-907.25524902344, 289.83776855469, 1693.0522460938),
				Vector3(-880.19171142578, 290.2041015625, 1814.8795166016),
				Vector3(-879.55462646484, 285.86206054688, 1859.3969726563),
				Vector3(-859.08581542969, 285.21942138672, 1906.1018066406),
			},
		},
	},
	vehicle_route_dummy_02 = {
		showEnemyRoutePoints = {
			groupIndex = 2,
			width = 20.0,
			langId = "marker_target_forecast_path",
			points = {
				Vector3(-1743.9819335938, 310.69467163086, 807.3759765625),
				Vector3(-1669.2515869141, 305.31317138672, 810.63610839844),
				Vector3(-1614.1596679688, 303.27682495117, 842.27893066406),
				Vector3(-1573.2214355469, 301.85629272461, 924.58190917969),
				Vector3(-1493.2576904297, 297.79528808594, 909.14019775391),
				Vector3(-1453.4377441406, 300.49130249023, 947.38330078125),
				Vector3(-1383.8725585938, 301.16595458984, 974.92395019531),
				Vector3(-1326.017578125, 301.89813232422, 972.76147460938),
				Vector3(-1248.8297119141, 302.58166503906, 931.54876708984),
				Vector3(-1141.9438476563, 302.01947021484, 912.04864501953),
				Vector3(-1015.9256591797, 300.27630615234, 968.47705078125),
				Vector3(-1038.3820800781, 307.21502685547, 1045.4780273438),
				Vector3(-1081.8931884766, 324.69964599609, 1155.7434082031),
				Vector3(-1015.705078125, 305.27194213867, 1243.7102050781),
				Vector3(-1033.5231933594, 289.53277587891, 1460.7841796875),
				Vector3(-983.85980224609, 292.11389160156, 1503.4844970703),
				Vector3(-963.96862792969, 292.87860107422, 1555.8970947266),
				Vector3(-967.92736816406, 292.83544921875, 1600.5180664063),
				Vector3(-950.44708251953, 291.87194824219, 1651.33203125),
				Vector3(-907.25524902344, 289.83776855469, 1693.0522460938),
				Vector3(-880.19171142578, 290.2041015625, 1814.8795166016),
				Vector3(-879.55462646484, 285.86206054688, 1859.3969726563),
				Vector3(-859.08581542969, 285.21942138672, 1906.1018066406),
			},
		},
	},

	tent_hostage_1 = {
		gameObjectName = TENT_HOSTAGE_NAME_1,
		visibleArea = 0,
		randomRange = 0,
		setNew = true,
		viewType = "map_and_world_only_icon",
		announceLog = "updateMap",
		langId = "marker_hostage",
	},
	tent_hostage_2 = {
		gameObjectName = TENT_HOSTAGE_NAME_2,
		visibleArea = 0,
		randomRange = 0,
		setNew = true,
		viewType = "map_and_world_only_icon",
		langId = "marker_hostage",
	},

	hud_photo_flee = {
		hudPhotoId = 10,
	},
	targetExtract = {
		announceLog = "recoverTarget",
	},
	achieveObjective = {
		announceLog = "achieveAllObjectives",
	},
}

this.missionObjectiveTree = {
	escape_subGoal = {
		foundTarget_subGoal_withMark = {},
		foundTarget_subGoal = {
			area_tent_lv3 = {
				area_tent_lv2 = {
					area_tent_lv1 = {
						area_tent_lv0 = {
							targetCpSetting = {},
							area_remnants = {},
						},
					},
				},
			},
			vehicle_route_correct = {},
			vehicle_route_dummy_01 = {},
			vehicle_route_dummy_02 = {},
		},
	},
	default_photo_target = {},
	remnants_hostage_1 = {},
	remnants_hostage_2 = {},
	remnants_hostage_3 = {},

	intelFile_remnants_get = {
		intelFile_remnants = {},
	},

	complete_missionTask_01 = {
		default_missionTask_01 = {},
	},
	complete_missionTask_02 = {
		default_missionTask_02 = {},
	},
	complete_missionTask_03 = {
		appear_missionTask_03 = {
			default_missionTask_03 = {},
		},
	},
	complete_missionTask_04 = {
		appear_missionTask_04 = {
			default_missionTask_04 = {},
		},
	},
	complete_missionTask_05 = {
		default_missionTask_05 = {},
	},
	tent_hostage_1 = {},
	tent_hostage_2 = {},
	hud_photo_flee = {},
	targetExtract = {},
	achieveObjective = {},
}

this.missionStartPosition = {

	orderBoxList = {
		"box_s10052_00",
	},

	helicopterRouteList = {
		"lz_drp_remnants_S0000|rt_drp_remnants_S_0000",
		"lz_drp_remnants_I0000|rt_drp_remnants_I_0000",
		"lz_drp_tent_I0000|rt_drp_tent_I_0000",
	},
}

function this.MissionPrepare()
	MISSION_NAME = TppMission.GetMissionName()
	Fox.Log("#### s10052_sequence.MissionPrepare ***")

	this.RegisterMissionSystemCallback()

	TppMarker.SetUpSearchTarget({
		{
			gameObjectName = TARGET_NAME,
			gameObjectType = "TppHostage2",
			messageName = TARGET_NAME,
			skeletonName = "SKL_004_HEAD",
			func = this.FoundTarget,
			objectives = { "hud_photo_flee" },
		},
	})

	TppPlayer.AddTrapSettingForIntel({
		intelName = "Intel_remnants",
		autoIcon = true,
		identifierName = "GetIntelIdentifier",
		locatorName = "GetIntel_remnants",
		gotFlagName = "isGetInfoFromFile",
		trapName = "trap_intelAtRemnants",
		markerObjectiveName = "intelFile_remnants",
		markerTrapName = "trap_intelMarkAreaRemnants",
	})

	TppRatBird.EnableRat()
	TppRatBird.EnableBird("TppEagle")

	TppLocation.RegistMissionAssetInitializeTable(this.s10052_baseOnActiveTable)
end

function this.OnRestoreSVars()
	Fox.Log("#### " .. tostring(MISSION_NAME) .. "_sequence.OnRestoreSVars ####")

	if svars.isOverLapCheckPhase then
		svars.isOverLapCheckPhase = false
	end
end

function this.RegisterMissionSystemCallback()
	Fox.Log("#### s10052_sequence.RegisterMissionSystemCallback ####")

	local systemCallbackTable = {
		OnRecovered = this.OnRecovered,
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnGameOver = this.OnGameOver,
		CheckMissionClearFunction = function()
			Fox.Log("#### s10052_sequence.RegisterMissionSystemCallback::CheckMissionClearFunction ####")
			return TppEnemy.CheckAllTargetClear()
		end,
		nil,
	}

	TppMission.RegisterMissionSystemCallback(systemCallbackTable)
end

function this.OnRecovered(gameObjectId)
	Fox.Log("#### s10052_sequence.OnRecovered #### gameObjectId = " .. tostring(gameObjectId))
	local target = ""

	target = GameObject.GetGameObjectId("TppHostage2", TARGET_NAME)
	if gameObjectId == target then
		Fox.Log("#### s10052_sequence.OnRecovered #### Mission Task 01 Completed!")
		TppMission.UpdateObjective({ objectives = { "complete_missionTask_01" } })
	end

	target = GameObject.GetGameObjectId("TppVehicle2", GUARD_VEHICLE)
	if gameObjectId == target then
		Fox.Log("#### s10052_sequence.OnRecovered #### Mission Task 02 Completed!")

		TppResult.AcquireSpecialBonus({ first = { isComplete = true } })
	end

	this.CheckMissionTask_Hostage()
end

function this.OnEstablishMissionClear(missionClearType)
	Fox.Log("#### s10052_sequence.OnEstablishMissionClear #### clearType = " .. tostring(missionClearType))

	TppMission.UpdateObjective({ objectives = { "complete_missionTask_01" } })

	s10052_radio.OnGameCleared()

	if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
		TppTerminal.ReserveHelicopterSoundOnMissionGameEnd()
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

function this.OnGameOver(gameOverType)
	if TppMission.CheckGameOverDemo(TppDefine.GAME_OVER_TYPE.TARGET_DEAD) then
		TppPlayer.SetTargetDeadCamera({ gameObjectName = TARGET_NAME })
		TppMission.ShowGameOverMenu({ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME })
		return true
	end
end

function this.Messages()
	return StrCode32Table({
		GameObject = {
			{ msg = "Dead", func = this.CheckDeadNPC },
			{ msg = "Carried", func = this.CheckCarryNPC },

			{ msg = "LostHostage", func = this.LostHostage },
			{ msg = "NoticeVehicleInvalid", func = this.LostVehicle },
			{ msg = "VehicleDisappeared", func = this.SetHostageExecute },
			{ msg = "VehicleTrouble", func = this.SetHostageExecute },
			{ msg = "VehicleBroken", func = this.SetHostageExecute },
			{ msg = "RoutePoint2", func = this.StartEvent, option = { isExecMissionPrepare = true } },
			{ msg = "ConversationEnd", func = this.StartEventConversation, option = { isExecMissionPrepare = true } },
			{ msg = "MonologueEnd", func = this.StartEventMonologue },

			{
				msg = "PlayerGetNear",
				func = function()
					Fox.Log("#### s10052_sequence.Messages::PlayerGetNear ####")
					svars.isNearTarget = true

					s10052_radio.SetOptionalRadioFromSituation()
					s10052_radio.SetIntelRadioFromSituation()
				end,
			},

			{
				msg = "PlayerGetAway",
				func = function()
					Fox.Log("#### s10052_sequence.Messages::PlayerGetAway ####")
					svars.isNearTarget = false

					if svars.isTargetRescue then
						if not svars.isTargetRaidHeli then
							s10052_radio.Caution_LeaveBehind()
						end
					end

					s10052_radio.SetOptionalRadioFromSituation()
					s10052_radio.SetIntelRadioFromSituation()
				end,
			},
			nil,
		},
		Player = {
			{
				msg = "GetIntel",
				sender = "Intel_remnants",
				func = function(intelNameHash)
					Fox.Log("#### s10052_sequence.Messages::GetIntelAtRemnants ####")
					TppPlayer.GotIntel(intelNameHash)

					local func = function()
						svars.infoCount = svars.infoCount + 1
						this.GetInfo("file")
						TppMission.UpdateCheckPointAtCurrentPosition()
					end
					s10052_demo.GetIntel_remnants(func)
				end,
			},
			{ msg = "RideHelicopter", func = this.PlayerRideHeli },
			{ msg = "RideHelicopterWithHuman", func = this.PlayerRideHeli },
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
		Sound = {
			{

				msg = "ChangeBgmPhase",
				func = function(bgmPhase)
					Fox.Log("#### s10052_sequence.Messages::ChangeBgmPhase### " .. bgmPhase)

					if
						bgmPhase == TppSystem.BGM_PHASE_SNEAK_1
						or bgmPhase == TppSystem.BGM_PHASE_SNEAK_2
						or bgmPhase == TppSystem.BGM_PHASE_SNEAK_3
					then
						this.CheckSituationForPhaseBGM()
					elseif bgmPhase == TppSystem.BGM_PHASE_ALERT then
						if svars.isTargetRescue and svars.isNearTarget then
							if not svars.tempSvars_008 then
								s10052_radio.Caution_CollateralDamage()
								svars.tempSvars_008 = true
							end
						end
					end
				end,
			},
		},
		Radio = {
			{

				msg = "Finish",
				func = function(radioGroup, eventType)
					Fox.Log(
						"#### s10052_sequence.Messages #### Message Radio Finished Received. radioGroup:"
							.. radioGroup
							.. ", eventType:"
							.. eventType
					)
					if radioGroup == Fox.StrCode32("s0052_rtrg6010") then
						Fox.Log("#### s10052_sequence.Messages #### Go To Mission Finalize.")
						TppMission.MissionFinalize()
					end
				end,
				option = { isExecMissionClear = true },
			},
		},
		Timer = {
			{

				msg = "Finish",
				sender = "Timer_SwitchPhaseToCaution",
				func = function()
					Fox.Log("#### s10052_sequence.Messages #### Timer_SwitchPhaseToCaution Received.")
					if s10052_enemy.CheckExecuteFlag() then
						s10052_enemy.SwitchPhaseToCaution()
					end
				end,
			},
			{

				msg = "Finish",
				sender = "Timer_SwitchPhaseToCaution_TimeOut",
				func = function()
					Fox.Log("#### s10052_sequence.Messages #### Timer_SwitchPhaseToCaution_TimeOut Received.")
					if s10052_enemy.CheckExecuteFlag() then
						s10052_enemy.SwitchPhaseToCaution()
					end
				end,
			},
			{

				msg = "Finish",
				sender = "Timer_AfterRewardRadioTimeOut",
				func = function()
					Fox.Log("#### s10052_sequence.Messages #### Timer_AfterRewardRadioTimeOut Received.")
					Fox.Log("#### s10052_sequence.Messages #### Go To Mission Finalize.")
					TppMission.MissionFinalize()
				end,
				option = { isExecMissionClear = true },
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
		Block = {
			{
				msg = "OnScriptBlockStateTransition",
				func = function(blockName, blockState)
					this.CheckBlock(blockName, blockState)
				end,
				option = { isExecMissionPrepare = true },
			},
		},
		Trap = {

			{
				msg = "Enter",
				sender = "trap_intelAtRemnants",
				func = function()
					TppPlayer.ShowIconForIntel("Intel_remnants", svars.isGetInfoFromFile)
				end,
			},

			{ msg = "Exit", sender = "trap_intelAtRemnants", func = TppPlayer.HideIconForIntel },

			{
				msg = "Enter",
				sender = "trap_eventAnimalControl_enable",
				func = function()
					svars.isStayPlayerInAnimalTrap = true

					if
						svars.eventCount >= s10052_enemy.EVENT_SEQUENCE["REMNANTSNORTH_VEHICLE_START"]
						and svars.eventCount <= s10052_enemy.EVENT_SEQUENCE["BETWEEN_A_FRIEND_ACT_FIRE_2"]
					then
						s10052_enemy.SetEnableForAnimal(true)
						s10052_enemy.EnableNoticeForAnimal(false)
					end
				end,
			},
			{
				msg = "Exit",
				sender = "trap_eventAnimalControl_enable",
				func = function()
					svars.isStayPlayerInAnimalTrap = false
				end,
			},
			{
				msg = "Enter",
				sender = "trap_eventAnimalControl_skip",
				func = function()
					svars.isSkipAnimalEvent = true

					s10052_enemy.EnableSoldierOnLrrp_21_24(true)

					if svars.eventCount == 1 then
						s10052_enemy.SetRouteDrivers("TrapIn(NotEnemy)", "TrapIn(NotRoute)")
					end
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

this.PlayerRideHeli = function()
	if svars.isTargetRescue then
		if not svars.isTargetRaidHeli then
			s10052_radio.Caution_LeaveBheind_Heli()
		end
	else
		s10052_radio.AbortByHeli()
	end
end

this.CheckSituationForPhaseBGM = function()
	local bgmTag = "bgm_transport"

	Fox.Log(
		"#### s10052_sequence.CheckSituationForPhaseBGM #### isTargetRescue = "
			.. tostring(svars.isTargetRescue)
			.. ", isTargetMarked = "
			.. tostring(svars.isTargetMarked)
			.. ", isHearTransportProject = "
			.. tostring(svars.isHearTransportProject)
			.. ", infoCount = "
			.. tostring(svars.infoCount)
	)

	if svars.isTargetRescue then
		TppSound.ResetPhaseBGM()
		Fox.Log("#### s10052_sequence.CheckSituationForPhaseBGM #### Reset phase bgm.")
	elseif svars.isTargetMarked or svars.isHearTransportProject or svars.infoCount > 0 then
		if this.isChaseVehicle() then
			TppSound.SetPhaseBGM(bgmTag)
			Fox.Log("#### s10052_sequence.CheckSituationForPhaseBGM #### Change phase bgm. -> " .. tostring(bgmTag))
		else
			TppSound.ResetPhaseBGM()
			Fox.Log("#### s10052_sequence.CheckSituationForPhaseBGM #### Reset phase bgm.")
		end
	else
	end
end

this.isChaseVehicle = function()
	local targetId = GameObject.GetGameObjectId(TARGET_NAME)
	local position, rotY = GameObject.SendCommand(targetId, { id = "GetPosition" })
	local player2target = TppMath.FindDistance(TppMath.Vector3toTable(position), TppPlayer.GetPosition())

	local PlayerToTargetDistance = math.sqrt(player2target)
	local CheckDistance = 160

	if PlayerToTargetDistance <= CheckDistance then
		return true
	else
		return false
	end
end

this.CheckBlock = function(blockName, blockState)
	local targetBlock = "remnantsNorth_N_s10052"

	Fox.Log(
		"#### s10052_sequence.CheckBlock #### blockName = "
			.. tostring(blockName)
			.. ", blockState = "
			.. tostring(blockState)
	)

	if blockName == Fox.StrCode32("animal_block") then
		if blockState == ScriptBlock.TRANSITION_ACTIVATED then
			if TppScriptBlock.GetCurrentPackListName("animal_block") == targetBlock then
				Fox.Log(
					"#### s10052_sequence.CheckBlock #### targetBlock [ " .. tostring(targetBlock) .. " ] is active! "
				)
				svars.isActiveEventAnimalBlock = true
				s10052_enemy.SetEnableForAnimal(false)
			end
		elseif blockState == ScriptBlock.TRANSITION_DEACTIVATED then
			Fox.Log(
				"#### s10052_sequence.CheckBlock #### targetBlock [ " .. tostring(targetBlock) .. " ] is deactive... "
			)

			svars.isActiveEventAnimalBlock = false
		end
	end
end

this.ResetGimmick = function(targetStage)
	local resetGimmickIdTable = {}

	Fox.Log("#### s10052_sequence.ResetGimmick #### targetStage [ " .. targetStage .. " ]")
	if targetStage == "remnants" then
		if not svars.tempSvars_004 then
			Gimmick.ResetGimmick(
				TppGameObject.GAME_OBJECT_TYPE_DOOR,
				GIMMICK_NAME.DOOR_REMNANTS_000,
				GIMMICK_PATH.REMNANTS
			)
			svars.tempSvars_004 = true
		end
	elseif targetStage == "tent" then
		if not svars.tempSvars_005 then
			Gimmick.ResetGimmick(TppGameObject.GAME_OBJECT_TYPE_DOOR, GIMMICK_NAME.DOOR_TENT_000, GIMMICK_PATH.TENT)

			Gimmick.ResetGimmick(TppGameObject.GAME_OBJECT_TYPE_DOOR, GIMMICK_NAME.DOOR_TENT_002, GIMMICK_PATH.TENT)
			svars.tempSvars_005 = true

			Gimmick.SetEventDoorLock(GIMMICK_NAME.DOOR_TENT_001, GIMMICK_PATH.TENT, false, 0)
		end
	else
		return
	end
end

this.CheckDeadNPC = function(characterId)
	Fox.Log("#### s10052_sequence.CheckDeadNPC #### DeadNPC = " .. characterId)

	if characterId == GameObject.GetGameObjectId("TppHostage2", TARGET_NAME) then
		TppMission.ReserveGameOver(TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD)
	elseif characterId == GameObject.GetGameObjectId("TppHostage2", EXECUTED_HOSTAGE_NAME_1) then
		svars.isPermitMarkedHostage_1 = false
		TppMarker.Disable(MARKER_NAME.REMNANTS_HOSTAGE_1)
	elseif characterId == GameObject.GetGameObjectId("TppHostage2", EXECUTED_HOSTAGE_NAME_2) then
		svars.isPermitMarkedHostage_2 = false
		TppMarker.Disable(MARKER_NAME.REMNANTS_HOSTAGE_2)
	elseif characterId == GameObject.GetGameObjectId("TppHostage2", EXECUTED_HOSTAGE_NAME_3) then
		svars.isPermitMarkedHostage_3 = false
		TppMarker.Disable(MARKER_NAME.REMNANTS_HOSTAGE_3)
	end
end

this.CheckCarryNPC = function(characterId)
	Fox.Log("#### s10052_sequence.CheckCarryNPC #### CarriedNPC = " .. characterId)

	if characterId == GameObject.GetGameObjectId("TppHostage2", EXECUTED_HOSTAGE_NAME_1) then
		svars.isPermitMarkedHostage_1 = false
		TppMarker.Disable(MARKER_NAME.REMNANTS_HOSTAGE_1)
	elseif characterId == GameObject.GetGameObjectId("TppHostage2", EXECUTED_HOSTAGE_NAME_2) then
		svars.isPermitMarkedHostage_2 = false
		TppMarker.Disable(MARKER_NAME.REMNANTS_HOSTAGE_2)
	elseif characterId == GameObject.GetGameObjectId("TppHostage2", EXECUTED_HOSTAGE_NAME_3) then
		svars.isPermitMarkedHostage_3 = false
		TppMarker.Disable(MARKER_NAME.REMNANTS_HOSTAGE_3)
	end
end

this.CheckMissionTask_Hostage = function()
	local isAllRecovered_remnants = true
	local isAllRecovered_tent = true

	svars.rescueHostageCount_remnants = 0

	for index, targetName in ipairs(this.MISSION_TASK_TARGET_LIST_REMNANTS) do
		if TppEnemy.IsRecovered(targetName) then
			Fox.Log(
				"#### s10052_sequence.CheckMissionTask_Hostage #### isGetInfoFromHostage = "
					.. tostring(svars.isGetInfoFromHostage)
			)

			if not svars.isGetInfoFromHostage and not svars.isTargetRescue and svars.tempSvars_007 then
				svars.infoCount = svars.infoCount + 1
				this.GetInfo("hostage")
			else
			end

			Fox.Log(
				"#### s10052_sequence.CheckMissionTask_Hostage #### targetName["
					.. tostring(targetName)
					.. "] is recovered!"
			)
			svars.rescueHostageCount_remnants = svars.rescueHostageCount_remnants + 1
		else
			Fox.Log(
				"#### s10052_sequence.CheckMissionTask_Hostage #### targetName["
					.. tostring(targetName)
					.. "] is not recovered..."
			)
			isAllRecovered_remnants = false
		end
	end

	if svars.rescueHostageCount_remnants >= 1 then
		Fox.Log("#### s10052_sequence.CheckMissionTask_Hostage #### Mission Task_03 Updated.")
		TppResult.AcquireSpecialBonus({ second = { pointIndex = svars.rescueHostageCount_remnants } })
	end

	svars.rescueHostageCount_tent = 0
	for index, targetName in ipairs(this.MISSION_TASK_TARGET_LIST_TENT) do
		if TppEnemy.IsRecovered(targetName) then
			Fox.Log(
				"#### s10052_sequence.CheckMissionTask_Hostage #### targetName["
					.. tostring(targetName)
					.. "] is recovered!"
			)
			svars.rescueHostageCount_tent = svars.rescueHostageCount_tent + 1
		else
			Fox.Log(
				"#### s10052_sequence.CheckMissionTask_Hostage #### targetName["
					.. tostring(targetName)
					.. "] is not recovered..."
			)
			isAllRecovered_tent = false
		end
	end

	if isAllRecovered_tent then
		Fox.Log("#### s10052_sequence.OnRecovered #### Mission Task_04 Completed!")
		TppMission.UpdateObjective({ objectives = { "complete_missionTask_04" } })
		this.ControlInterFlagToCP("afgh_tent_cp", "reset")
	elseif svars.rescueHostageCount_tent >= 1 then
		Fox.Log("#### s10052_sequence.OnRecovered #### Mission Task_04 Updated.")
	end
end

this.RestoreEventSituation = function()
	if svars.isSkipOnEmergency and not svars.tempSvars_009 then
		s10052_enemy.EnableForceRailDriveSpeedFAST(true)
	end

	if svars.tempSvars_010 then
		s10052_enemy.SwitchRouteByLostVehicle()
	end
end

this.SetHostageExecute = function(vehicleId, arg1)
	Fox.Log("#### s10052_sequence.SetHostageExecute #### vehicleId = " .. tostring(vehicleId))
	local targetVehicle = GameObject.GetGameObjectId("TppVehicle2", TRANSPORT_VEHICLE)
	if vehicleId == targetVehicle then
		svars.tempSvars_010 = true
		s10052_enemy.SetHostageExecutionFlag()
		s10052_enemy.JoinToActorToNearestBase()
		if not svars.tempSvars_003 then
			s10052_enemy.SetFormationAround(GUARD_VEHICLE)
			s10052_enemy.UnsetTravelPlanForException()
		end
	end
	if arg1 == StrCode32("CanNotMove") then
		s10052_enemy.UnsetTravelPlanForEventVehicle(DRIVER_NAME)
		s10052_enemy.UnsetTravelPlanForEventVehicle(GUARD_NAME)
	end
end

this.LostVehicle = function(vehicleId)
	Fox.Log("#### s10052_sequence.LostVehicle #### vehicleId = " .. tostring(vehicleId))
	local targetVehicle = GameObject.GetGameObjectId("TppVehicle2", TRANSPORT_VEHICLE)
	if vehicleId == targetVehicle then
		svars.tempSvars_010 = true
		s10052_enemy.JoinToActorToNearestBase()
		s10052_enemy.SwitchRouteByLostVehicle()
	end
end

this.LostHostage = function(hostageId)
	Fox.Log("#### s10052_sequence.LostHostage #### hostageId = " .. tostring(hostageId))

	if hostageId == GameObject.GetGameObjectId("TppHostage2", EXECUTED_HOSTAGE_NAME_1) then
		Fox.Log("#### s10052_sequence.LostHostage( " .. EXECUTED_HOSTAGE_NAME_1 .. " ) ####")
		svars.isDiscoverdEscape_1 = true
	elseif hostageId == GameObject.GetGameObjectId("TppHostage2", EXECUTED_HOSTAGE_NAME_2) then
		Fox.Log("#### s10052_sequence.LostHostage( " .. EXECUTED_HOSTAGE_NAME_2 .. " ) ####")
		svars.isDiscoverdEscape_2 = true
	elseif hostageId == GameObject.GetGameObjectId("TppHostage2", EXECUTED_HOSTAGE_NAME_3) then
		Fox.Log("#### s10052_sequence.LostHostage( " .. EXECUTED_HOSTAGE_NAME_3 .. " ) ####")
		svars.isDiscoverdEscape_3 = true
	elseif hostageId == GameObject.GetGameObjectId("TppHostage2", TARGET_NAME) then
		Fox.Log("#### s10052_sequence.LostHostage( " .. TARGET_NAME .. " ) ####")
		svars.isDiscoverdEscape_Target = true
		s10052_enemy.JoinToActorToNearestBase()
		s10052_enemy.UnsetTravelPlanForException()
	else
		return
	end
end

this.CheckFultonNPC = function(targetId) end

this.CheckRideHeliNPC = function(targetId, vehicleId)
	if Tpp.IsHelicopter(vehicleId) then
		if Tpp.IsHostage(targetId) then
			svars.rescueHostageCount_remnants = svars.rescueHostageCount_remnants + 1
			Fox.Log(
				"#### s10052_sequence.CheckRideHeliNPC #### targetId = "
					.. tostring(targetId)
					.. ", rescueHostageCount_remnants = "
					.. tostring(svars.rescueHostageCount_remnants)
			)

			this.CheckMissionTask_Hostage()
		end
	else
		Fox.Log(
			"#### s10052_sequence.CheckRideHeliNPC #### targetId = "
				.. targetId
				.. ", vehicleId ="
				.. vehicleId
				.. ", This is Not Heli!!"
		)
	end
end

this.StartEvent = function(id, routeId, routeNode, sendM)
	Fox.Log("#### s10052_sequence.StartEvent #### sendMessage = " .. sendM)

	if sendM == StrCode32("startConversation") then
		s10052_enemy.StartConversation()
	elseif sendM == StrCode32("startEventDrivers") then
		s10052_enemy.SetRouteDrivers(id, routeId)
	elseif sendM == StrCode32("disableForceRailDriveSpeedFAST") then
		svars.tempSvars_009 = true
		s10052_enemy.EnableForceRailDriveSpeedFAST(false)
	elseif sendM == StrCode32("arrivedEdge_03_02_tent") then
		svars.tempSvars_012 = true
	elseif sendM == StrCode32("joinNormalShift") then
		TppEnemy.UnsetSneakRoute(GUARD_NAME)
		TppEnemy.UnsetCautionRoute(GUARD_NAME)
		s10052_enemy.DisableOccasionalChatFor(GUARD_NAME, false)

		local driverId = GameObject.GetGameObjectId(DRIVER_NAME)
		local isNeutralizeDriver = TppEnemy.IsNeutralized(DRIVER_NAME)

		if isNeutralizeDriver then
			TppEnemy.SetSneakRoute(EXECUTIONER_TENT_NAME, s10052_enemy.routeTable.tent.executioner.sneak[2])
			TppEnemy.SetCautionRoute(EXECUTIONER_TENT_NAME, s10052_enemy.routeTable.tent.executioner.caution[2])
		end
	elseif sendM == StrCode32("isStartSAV") then
		if not svars.isSkipOnEmergency then
			s10052_enemy.DeleteConvoySetting()
			s10052_enemy.SetTravelPlanForEventVehicle(
				"sol_s10052_guardVehicle_0000",
				"travel_mission_tent_to_enemyBase"
			)
			svars.tempSvars_013 = true
		end
	elseif sendM == StrCode32("isVanishSAV") then
		s10052_enemy.VanishSAV()
	elseif sendM == StrCode32("isLeaveGuardVehicle") then
		svars.tempSvars_003 = true
	elseif sendM == StrCode32("checkTransportVehicleAlive") then
		if not (s10052_enemy.CheckRideOnAnyEnemy(TRANSPORT_VEHICLE)) then
			if not svars.tempSvars_011 then
				s10052_enemy.DeleteConvoySetting()
				TppEnemy.SetSneakRoute("sol_s10052_guardVehicle_0000", "rts_guardVehicle_driver_tent_caution_0001")
				TppEnemy.SetCautionRoute("sol_s10052_guardVehicle_0000", "rts_guardVehicle_driver_tent_caution_0001")
				TppEnemy.SetAlertRoute("sol_s10052_guardVehicle_0000", "rts_guardVehicle_driver_tent_caution_0001")
				s10052_enemy.UnsetTravelPlanForEventVehicle("sol_s10052_guardVehicle_0000")
				svars.tempSvars_011 = true
			end
		end
	elseif sendM == StrCode32("isChangeRouteGuardVehicle_01") then
		TppEnemy.SetSneakRoute("sol_s10052_guardVehicle_0000", "rts_guardVehicle_driver_tent_caution_0002")
		TppEnemy.SetCautionRoute("sol_s10052_guardVehicle_0000", "rts_guardVehicle_driver_tent_caution_0002")
		TppEnemy.SetAlertRoute("sol_s10052_guardVehicle_0000", "rts_guardVehicle_driver_tent_caution_0002")
	elseif sendM == StrCode32("isChangeRouteGuardVehicle_02") then
		TppEnemy.SetSneakRoute("sol_s10052_guardVehicle_0000", "rts_guardVehicle_driver_tent_caution_0003")
		TppEnemy.SetCautionRoute("sol_s10052_guardVehicle_0000", "rts_guardVehicle_driver_tent_caution_0003")
		TppEnemy.SetAlertRoute("sol_s10052_guardVehicle_0000", "rts_guardVehicle_driver_tent_caution_0003")
	elseif sendM == StrCode32("setEndRouteHostage") then
		s10052_enemy.SetEndRouteHostage()
	elseif sendM == StrCode32("setRouteExecutionerRemnants") then
		s10052_enemy.SetRouteExecutionerRemnants()
	elseif sendM == StrCode32("setEndRouteExecutionerTent") then
		s10052_enemy.SetEndRouteExecutionerTent()
	elseif sendM == StrCode32("isTortureTimeTrue") then
		svars.isTortureTime = true
		s10052_radio.SetIntelRadioFromSituation()
	elseif sendM == StrCode32("isTortureTimeFalse") then
		svars.isTortureTime = false
		s10052_radio.SetIntelRadioFromSituation()
	elseif sendM == StrCode32("enableAnimalNotice") then
		s10052_enemy.EnableNoticeForAnimal(true)
	else
		return
	end
end

this.StartEventConversation = function(gameObjectId, label, flag)
	local isSuccess = 1
	Fox.Log(
		"#### s10052_sequence.StartEventConversation #### gameObjectId = "
			.. gameObjectId
			.. ", label = "
			.. label
			.. ", flag = "
			.. flag
	)

	if s10052_enemy.SearchLabelFromConversationEndMessage(label) then
		svars.isTalkTime = false

		if not svars.isSkipOnEmergency then
			if
				gameObjectId ~= GameObject.GetGameObjectId("TppSoldier2", EXECUTIONER_TENT_NAME)
				and gameObjectId ~= GameObject.GetGameObjectId("TppHostage2", TARGET_NAME)
			then
				svars.talkCount = svars.talkCount + 1
				s10052_enemy.SetRouteDrivers(gameObjectId, "ConversationEnd(NotRoute)")
			else
				Fox.Log(
					"#### s10052_sequence.StartEventConversation #### This gameObjectId does not execute this function!!"
				)
			end
		end
	end
end

this.StartEventMonologue = function(gameObjectId, label, flag)
	local isSuccess = 1
	Fox.Log(
		"#### s10052_sequence.StartEventMonologue #### gameObjectId = "
			.. gameObjectId
			.. ", label = "
			.. label
			.. ", flag = "
			.. flag
	)

	if (label == Fox.StrCode32("speech052_carry010")) and (flag == isSuccess) then
		s10052_enemy.CallMonologue(TARGET_NAME, s10052_enemy.voiceTable.hostage.carry.missionTarget[2])
	end
end

this.FoundTarget = function()
	Fox.Log("#### s10052_sequence.FoundTarget:" .. TARGET_NAME .. " ####")

	if svars.isTargetRescue == false then
		TppMission.UpdateObjective({
			radio = {
				radioGroups = { "f1000_rtrg2170" },
				radioOptions = { delayTime = "mid", isEnqueue = true },
			},
			objectives = { "foundTarget_subGoal" },
		})
	end

	svars.isTargetMarked = true

	s10052_radio.SetOptionalRadioFromSituation()
	s10052_radio.SetIntelRadioFromSituation()

	this.ControlInterFlagToCP("afgh_remnants_cp", "reset")

	if svars.isTargetRescue then
		svars.isTargetMarkedWithCarry = true
	end

	if svars.eventCount == 1 then
		s10052_enemy.SetRouteDrivers("FoundTarget(NotEnemy)", "StartEvent(NotRoute)")
	end

	this.CheckSituationForPhaseBGM()
end

this.GetInfo = function(getInfoFrom)
	Fox.Log(
		"#### s10052_sequence.GetInfo #### getInfoFrom " .. tostring(getInfoFrom) .. ", infoCount = " .. svars.infoCount
	)

	local callRadio = { radioGroups = "" }
	local setObjective = { objectives = "" }
	local infoLv = { "area_tent_lv1", "area_tent_lv2", "area_tent_lv3" }

	TppUiCommand.SetMisionInfoCurrentStoryNo(TARGET_IN_TENT)

	if svars.infoCount == 1 then
		if getInfoFrom == "hostage" then
			callRadio = { radioGroups = { "s0052_rtrg3020", "s0052_rtrg3050" }, radioOptions = { delayTime = "long" } }
		elseif getInfoFrom == "file" then
			callRadio = {
				radioGroups = { "s0052_rtrg3030", "s0052_rtrg3010", "s0052_rtrg3040", "s0052_rtrg3050" },
				radioOptions = { delayTime = "short" },
			}
		else
			callRadio = { radioGroups = { "s0052_rtrg3040", "s0052_rtrg3050" }, radioOptions = { delayTime = "mid" } }
		end
	elseif svars.infoCount == 2 then
		if getInfoFrom == "hostage" then
			callRadio = { radioGroups = { "f1000_rtrg2230" }, radioOptions = { delayTime = "long" } }
		elseif getInfoFrom == "file" then
			callRadio = {
				radioGroups = { "s0052_rtrg3030", "s0052_rtrg3010", "f1000_rtrg2220" },
				radioOptions = { delayTime = "short" },
			}
		else
			callRadio = { radioGroups = { "f1000_rtrg2220" }, radioOptions = { delayTime = "mid" } }
		end
	else
		if getInfoFrom == "hostage" then
			callRadio = { radioGroups = { "f1000_rtrg2230", "s0052_rtrg3150" }, radioOptions = { delayTime = "long" } }
		elseif getInfoFrom == "file" then
			callRadio = {
				radioGroups = { "s0052_rtrg3030", "s0052_rtrg3010", "f1000_rtrg2220", "s0052_rtrg3150" },
				radioOptions = { delayTime = "short" },
			}
		else
			callRadio = { radioGroups = { "f1000_rtrg2220", "s0052_rtrg3150" }, radioOptions = { delayTime = "mid" } }
		end

		this.ControlInterFlagToCP("afgh_remnants_cp", "reset")
	end

	if getInfoFrom == "file" then
		setObjective = { infoLv[svars.infoCount], "intelFile_remnants_get" }

		if svars.infoCount == 2 then
			setObjective = { infoLv[svars.infoCount], "intelFile_remnants_get", "vehicle_route_correct" }
		end
	else
		setObjective = { infoLv[svars.infoCount] }

		if svars.infoCount == 2 then
			setObjective = { infoLv[svars.infoCount], "vehicle_route_correct" }
		end
	end

	Fox.Log(
		"#### s10052_sequence.GetInfo #### isTargetMarked = "
			.. tostring(svars.isTargetMarked)
			.. ", isHearTransportProject = "
			.. tostring(svars.isHearTransportProject)
	)

	if svars.isTargetMarked or (svars.infoCount > 3) then
		if getInfoFrom == "file" then
			s10052_radio.NoInfoFromIF()
			TppMission.UpdateObjective({
				objectives = { "intelFile_remnants_get" },
			})
		end
	else
		TppMission.UpdateObjective({
			radio = callRadio,
			objectives = setObjective,
		})
	end

	if getInfoFrom == "enemy" then
		this.ControlInterFlagToCP("afgh_remnants_cp", "reset")
	end

	if getInfoFrom == "hostage" then
		svars.isGetInfoFromHostage = true
	end

	s10052_radio.SetOptionalRadioFromSituation()
	s10052_radio.SetIntelRadioFromSituation()

	this.CheckSituationForPhaseBGM()
end

this.SetObjectiveAndPlayRadio = function()
	Fox.Log("#### s10052_sequence.SetObjectiveAndPlayRadio ####")

	if svars.isTargetRescue then
		s10052_radio.AfterContinue_TargetRescued()
	elseif svars.isTargetMarked then
		s10052_radio.AfterContinue_TargetMarked()
	elseif svars.infoCount >= 3 then
		s10052_radio.AfterContinue_GetInfo3()
	elseif svars.infoCount == 2 then
		s10052_radio.AfterContinue_GetInfo2()
	elseif svars.infoCount == 1 then
		if not svars.isGetInfoFromEnemy then
			s10052_radio.AfterContinue_GetInfo1_WithoutEnemy()
		elseif not svars.isGetInfoFromFile then
			s10052_radio.AfterContinue_GetInfo1_WithoutFile()
		else
			s10052_radio.AfterContinue_GetInfo1_WithoutHostage()
		end
	elseif TppSequence.GetContinueCount() > 0 then
		s10052_radio.AfterContinue_BeforeGetInfo()
	elseif TppSequence.GetContinueCount() == 0 then
		TppMission.UpdateObjective({
			radio = { radioGroups = { "s0052_rtrg1010" } },
			objectives = { "area_remnants" },
			options = { isMissionStart = true },
		})
	end
end

this.ControlInterFlagToCP = function(targetCP, flag)
	Fox.Log("#### s10052_sequence.ControlInterFlagToCP #### targetCP = " .. targetCP .. ", flag = " .. flag)

	if flag == "set" then
		Fox.Log("#### s10052_sequence.ControlInterFlagToCP #### SetFlag ! targetCP = " .. targetCP)

		if targetCP == "afgh_remnants_cp" then
			TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId(targetCP), {

				{ name = s10052_enemy.voiceTable.remnants.inter.cpHigh[1], func = s10052_enemy.InterCall_remnants },
			})
		elseif targetCP == "afgh_tent_cp" then
			TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId(targetCP), {
				{ name = s10052_enemy.voiceTable.tent.inter.cpHigh[1], func = s10052_enemy.InterCall_tent },
			})
		else
			Fox.Log(
				"#### s10052_sequence.ControlInterFlagToCP #### UNKNOWN!! targetCP = "
					.. targetCP
					.. ", flag = "
					.. flag
			)
		end
	elseif flag == "reset" then
		Fox.Log("#### s10052_sequence.ControlInterFlagToCP #### ResetFlag! targetCP = " .. targetCP)

		if targetCP == "afgh_remnants_cp" or targetCP == "afgh_tent_cp" then
			TppInterrogation.ResetFlagHigh(GameObject.GetGameObjectId(targetCP))
		else
			Fox.Log(
				"#### s10052_sequence.ControlInterFlagToCP #### UNKNOWN!! targetCP = "
					.. targetCP
					.. ", flag = "
					.. flag
			)
		end
	else
		Fox.Log(
			"#### s10052_sequence.ControlInterFlagToCP #### UNKNOWN!! targetCP = " .. targetCP .. ", flag = " .. flag
		)
	end
end

this.drawVehicleRoute = function()
	Fox.Log("#### s10052_sequence.drawVehicleRoute #### infoCount = " .. svars.infoCount)
end

this.StartTimer = function(timerName, timerTime)
	Fox.Log(
		"#### s10052_sequence.StartTimer #### timerName = "
			.. tostring(timerName)
			.. ", timerTime = "
			.. tostring(timerTime)
	)
	if not GkEventTimerManager.IsTimerActive(timerName) then
		GkEventTimerManager.StartRaw(timerName, timerTime)
	end
end

this.StopTimer = function(timerName)
	Fox.Log("#### s10052_sequence.StopTimer #### timerName = " .. tostring(timerName))
	if GkEventTimerManager.IsTimerActive(timerName) then
		GkEventTimerManager.Stop(timerName)
	end
end

sequences.Seq_Demo_Opening = {

	OnEnter = function()
		local func = function()
			TppSequence.SetNextSequence("Seq_Game_MainGame")
		end
		s10052_demo.PlayOpeningDemo(func)
	end,

	OnLeave = function()
		TppMission.UpdateCheckPointAtCurrentPosition()
	end,
}

sequences.Seq_Game_MainGame = {

	Messages = function(self)
		return StrCode32Table({
			GameObject = {
				{ msg = "Carried", sender = TARGET_NAME, func = self.RescueTarget },
				{ msg = "ChangePhase", func = s10052_enemy.CheckPhaseChange },
				nil,
			},
			Trap = {
				{ msg = "Enter", sender = "trap_startTransferEvent", func = self.StartTransferEvent00 },
				{ msg = "Enter", sender = "trap_startTransferEvent_2", func = self.StartTransferEvent00 },
				{ msg = "Enter", sender = "trap_arrivedRemnants", func = self.ArrivedRemnants },
				{ msg = "Exit", sender = "trap_arrivedRemnants", func = self.ArrivedRemnants },
				{ msg = "Enter", sender = "trap_arrivedTent", func = self.ArrivedTent },
				nil,
			},
			Player = {
				{ msg = "OnVehicleRide_Start", func = self.CheckVehicleOnPlayer },
			},
			Subtitles = {
				{
					msg = "SubtitlesEndEventMessage",
					func = function(speechLabel, status)
						local radioTrigger = {
							[1] = SubtitlesCommand:ConvertToSubtitlesId("shks8000_111010_0_enea_ru"),
							[2] = SubtitlesCommand:ConvertToSubtitlesId("shks8000_121010_0_ened_ru"),
							[3] = SubtitlesCommand:ConvertToSubtitlesId("shks8000_151010_0_ened_ru"),
						}

						local taskTrigger = SubtitlesCommand:ConvertToSubtitlesId("shks8000_391010_0_ened_ru")

						if speechLabel == radioTrigger[1] then
							Fox.Log(
								"#### s10052_sequence.SubtitlesEndEventMessage #### radioTrigger = "
									.. tostring(speechLabel)
							)
							svars.isRadioTrigger_1 = true
						elseif speechLabel == radioTrigger[2] then
							Fox.Log(
								"#### s10052_sequence.SubtitlesEndEventMessage #### radioTrigger = "
									.. tostring(speechLabel)
							)
							svars.isRadioTrigger_2 = true
						elseif speechLabel == radioTrigger[3] then
							Fox.Log(
								"#### s10052_sequence.SubtitlesEndEventMessage #### radioTrigger = "
									.. tostring(speechLabel)
							)
							svars.isRadioTrigger_3 = true
						elseif speechLabel == taskTrigger then
							Fox.Log(
								"#### s10052_sequence.SubtitlesEndEventMessage #### taskTrigger = "
									.. tostring(speechLabel)
							)
							Fox.Log("#### s10052_sequence.OnRecovered #### Mission Task 05 Completed!")
							TppMission.UpdateObjective({ objectives = { "complete_missionTask_05" } })
							svars.isHearLastConversation = true
						end
					end,
				},
			},
			nil,
		})
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(-1203.9891, 291.23022, 1283.3148))
			TppNetworkUtil.SessionEnableAccept(true)
			Dynamite.StartNearestEnemyThread()
		end

		TppTelop.StartCastTelop()

		if svars.isHearTransportProject or svars.infoCount > 0 then
			TppUiCommand.SetMisionInfoCurrentStoryNo(TARGET_IN_TENT)
		else
			TppUiCommand.SetMisionInfoCurrentStoryNo(TARGET_IN_REMNANTS)
		end

		TppMission.UpdateObjective({
			objectives = {
				"default_missionTask_01",
				"default_missionTask_02",
				"default_missionTask_03",
				"default_missionTask_04",
				"default_missionTask_05",
				"default_photo_target",
				"targetCpSetting",
			},
		})

		this.SetObjectiveAndPlayRadio()
		s10052_radio.SetOptionalRadioFromSituation()
		s10052_radio.SetIntelRadioFromSituation()

		this.CheckMissionTask_Hostage()

		if svars.isTargetRideOnVehicleSequence == true then
			s10052_enemy.SetHostageRideVehicle(false)
		end

		this.RestoreEventSituation()

		TppScriptBlock.LoadDemoBlock("Demo_GetIntel")
	end,

	CheckVehicleOnPlayer = function(id, flag, vehicleId)
		Fox.Log("#### s10052_sequence.CheckVehicleOnPlayer #### vehicleId = " .. vehicleId)

		local checkVehicleId = GameObject.GetGameObjectId("TppVehicle2", TRANSPORT_VEHICLE)

		if
			svars.isTargetFoundOnVehicle == false
			and svars.isTargetRideOnVehicleSequence == true
			and vehicleId == checkVehicleId
		then
			local findTargetId = GameObject.GetGameObjectId("TppHostage2", TARGET_NAME)

			local riderIdArray = GameObject.SendCommand(checkVehicleId, { id = "GetRiderId" })
			local seatCount = #riderIdArray

			for seatIndex, riderId in ipairs(riderIdArray) do
				Fox.Log(
					"#### s10052_sequence.CheckVehicleOnPlayer #### seatIndex = "
						.. seatIndex
						.. ", riderId = "
						.. riderIdArray[seatIndex]
				)

				if riderId ~= GameObject.NULL_ID then
					if riderIdArray[seatIndex] == findTargetId then
						svars.isTargetFoundOnVehicle = true
						Fox.Log(
							"#### s10052_sequence.CheckVehicleOnPlayer #### find target on vehicle!! targetId = "
								.. findTargetId
								.. ", seatIndex = "
								.. seatIndex
						)

						svars.isTargetRescue = true

						svars.isTargetRideOnVehicleSequence = false

						TppMarker.DisableSearchTarget(TARGET_NAME)

						TppMarker.Enable(TARGET_NAME, 0, "defend", "map_and_world_only_icon", 0, true, true)

						TppSequence.SetNextSequence("Seq_Game_Escape")
					else
					end
				end
			end
		else
			Fox.Log(
				"#### s10052_sequence.CheckVehicleOnPlayer #### not execute this func! isTargetFoundOnVehicle = "
					.. tostring(svars.isTargetFoundOnVehicle)
					.. ", isTargetRideOnVehicleSequence = "
					.. tostring(svars.isTargetRideOnVehicleSequence)
			)
		end
	end,

	RescueTarget = function(s_characterId)
		Fox.Log("#### s10052_sequence.RescueTarget #### hostageId = " .. s_characterId)

		if s_characterId == GameObject.GetGameObjectId("TppHostage2", TARGET_NAME) then
			Fox.Log("#### s10052_sequence.RescueTarget #### This Hostage is Target! targetId = " .. TARGET_NAME)
			svars.isTargetRescue = true

			svars.isTargetRideOnVehicleSequence = false

			TppSequence.SetNextSequence("Seq_Game_Escape")
		else
			return
		end
	end,

	ArrivedRemnants = function()
		Fox.Log(
			"#### s10052_sequence.ArrivedRemnants #### infoCount = "
				.. svars.infoCount
				.. ", isTargetMarked = "
				.. tostring(svars.isTargetMarked)
		)

		if svars.isArrivedRemnants then
			svars.isArrivedRemnants = false
		elseif (svars.infoCount == 0) and not svars.isTargetMarked then
			s10052_radio.ArrivedRemnants()
			svars.isArrivedRemnants = true

			if svars.tempSvars_007 and not svars.isGetInfoFromEnemy then
				this.ControlInterFlagToCP("afgh_remnants_cp", "set")
			end
		else
			Fox.Log("#### s10052_sequence.ArrivedRemnants : [ infoCount > 0 or isTargetMarked = true ] ####")
			svars.isArrivedRemnants = true
		end

		s10052_radio.SetOptionalRadioFromSituation()
		s10052_radio.SetIntelRadioFromSituation()
	end,

	ArrivedTent = function()
		Fox.Log(
			"#### s10052_sequence.ArrivedTent #### infoCount = "
				.. svars.infoCount
				.. ", isTargetMarked = "
				.. tostring(svars.isTargetMarked)
		)
		s10052_radio.ArrivedTent()
		svars.isArrivedTent = true

		if svars.eventCount == 1 then
			s10052_enemy.SetRouteDrivers("TrapIn(NotEnemy)", "TrapIn(NotRoute)")

			s10052_enemy.EnableSoldierOnLrrp_21_24(true)
		end

		s10052_radio.SetOptionalRadioFromSituation()
		s10052_radio.SetIntelRadioFromSituation()
	end,

	StartTransferEvent00 = function()
		Fox.Log("#### s10052_sequence.StartTransferEvent00 ####")

		if svars.eventCount == 1 then
			s10052_enemy.SetRouteDrivers("TrapIn(NotEnemy)", "TrapIn(NotRoute)")
		end

		s10052_radio.SetOptionalRadioFromSituation()
		s10052_radio.SetIntelRadioFromSituation()
	end,
}

sequences.Seq_Game_Escape = {

	Messages = function(self)
		return StrCode32Table({
			GameObject = {
				{ msg = "PlacedIntoVehicle", sender = TARGET_NAME, func = self.RideTargetHeli },
				nil,
			},
			Timer = {
				{
					msg = "Finish",
					sender = "timer_monologue",
					func = function()
						Fox.Log("#### s10052_sequence.Seq_Game_Escape #### Messages : timer_monologue / Finish")
						s10052_enemy.CallMonologue(TARGET_NAME, s10052_enemy.voiceTable.hostage.carry.missionTarget[1])
					end,
				},
			},
			nil,
		})
	end,

	OnEnter = function()
		s10052_radio.SetOptionalRadioFromSituation()
		s10052_radio.SetIntelRadioFromSituation()

		if svars.isHearTransportProject or svars.infoCount > 0 then
			TppUiCommand.SetMisionInfoCurrentStoryNo(TARGET_IN_TENT)
		else
			TppUiCommand.SetMisionInfoCurrentStoryNo(TARGET_IN_REMNANTS)
		end

		this.RestoreEventSituation()

		this.CheckSituationForPhaseBGM()

		mvars.mis_needSetEscapeBgm = true

		this.CheckMissionTask_Hostage()

		if svars.isTargetRaidHeli == true then
			s10052_radio.BeforeClear()
		elseif svars.isFirstTimeEscape == false then
			s10052_radio.AfterContinue_TargetRescued()
		else
			local callRadio = { radioGroups = "" }
			local setObjective = { "" }

			if svars.isTargetMarkedWithCarry == true then
				callRadio = {
					radioGroups = { "f1000_rtrg2170", "f1000_rtrg1210" },
					radioOptions = { delayTime = "mid" },
				}
				setObjective = { "foundTarget_subGoal" }
				svars.isTargetMarked = true
			elseif svars.isTargetMarked == false then
				callRadio = {
					radioGroups = { "f1000_rtrg2170", "f1000_rtrg1210" },
					radioOptions = { delayTime = "mid" },
				}
				setObjective = { "foundTarget_subGoal" }

				TppSoundDaemon.PostEvent("sfx_s_enemytag_main_tgt")
			else
				callRadio = {
					radioGroups = { "f1000_rtrg1210" },
					radioOptions = { delayTime = "mid" },
				}
				setObjective = { "foundTarget_subGoal_withMark" }
			end

			TppMission.UpdateObjective({
				radio = callRadio,
				objectives = setObjective,
			})

			svars.isFirstTimeEscape = false

			svars.isTortureTime = false

			TimerStart("timer_monologue", 20)

			TppEnemy.UnsetSneakRoute(EXECUTIONER_TENT_NAME)
			TppEnemy.UnsetCautionRoute(EXECUTIONER_TENT_NAME)
		end
	end,

	RideTargetHeli = function(s_characterId, s_rideVehicleID)
		Fox.Log(
			"#### s10052_sequence.RideTargetHeli #### characterId = "
				.. s_characterId
				.. ", vehicleId ="
				.. s_rideVehicleID
		)

		if s_rideVehicleID == GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI) then
			if s_characterId == GameObject.GetGameObjectId("TppHostage2", TARGET_NAME) then
				Fox.Log("#### s10052_sequence.RideTargetHeli #### Target ride on heli! targetName = " .. TARGET_NAME)
				TppMission.CanMissionClear()
				svars.isTargetRaidHeli = true

				TppMission.UpdateObjective({ objectives = { "targetExtract" } })
				TppMission.UpdateObjective({ objectives = { "achieveObjective" } })

				TppMission.UpdateObjective({
					radio = {
						radioGroups = { "f1000_rtrg1380" },
					},
					objectives = { "escape_subGoal" },
				})

				s10052_radio.SetOptionalRadioFromSituation()
				s10052_radio.SetIntelRadioFromSituation()
			end
		else
			return
		end
	end,
}

return this
