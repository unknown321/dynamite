local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

this.NO_AQUIRE_GMP = true
this.NO_MISSION_CLEAR_RANK = true
this.NO_TACTICAL_TAKE_DOWN = true
this.NO_TAKE_HIT_COUNT = true
this.MISSION_START_INITIAL_WEATHER = TppDefine.WEATHER.SUNNY
this.NO_PLAY_STYLE = true

local COMPLATE_NUM = 22
local RADIO_HUYE4 = 19
local RADIO_HUYE3 = 15
local RADIO_HUYE2 = 12
local RADIO_HUYE1 = 4
local BATTLE_COUNT = 3
local TEIDEN_DATA = "TppGimmickPowerCutAreaData0000"
local DOOR_ROOF = "mtbs_door005_door001_gim_n0002|srt_mtbs_door005_door001"
local DOOR_ENTER = "mtbs_door006_door001_gim_n0000|srt_mtbs_door006_door001"

local IDEN_ASSET_ID = "mbqfAssetIdentifier"
local IDEN_ASSET_BEFORE_KEY = {
	"room_before",
	"chika_before",
}
local IDEN_ASSET_AFTER_KEY = {
	"room_after",
	"chika_after",
}

local IDEN_BLOOD = {
	ROOM2F1 = "suicide_soldier1",
	ROOM2F3 = "suicide_soldier2",
}

local IDEN_PATH_ID = "mbqf_path_Identifier"
local IDEN_PATH_BEFORE_KEY = {
	"room_before_0000",
	"room_before_0001",
	"room_before_0002",
	"room_before_0003",
	"room_before_0004",
}
local IDEN_PATH_AFTER_KEY = {
	"room_after_0000",
	"room_after_0001",
	"room_after_0002",
	"room_after_0003",
	"room_after_0004",
	"room_after_0005",
	"room_after_0006",
	"room_after_0007",
	"room_after_0008",
	"room_after_0009",
}

local IDEN_LIGHT_ID = "mtbs_qrntnFacility_light"
local IDEN_LIGHT_EM_ID = "mtbs_qrntnFacility_light"

local TIME_BLACKOUT = 5
local TIME_RADIO_START = 10
local TIME_SHOOT_SNEAK = 12
local TIME_ZOMBIE_DOWN = 5
local TIME_LIVE_MAN = 2
local TIME_SET_PADMASK_MOVE = 0.1
local TIME_RESET_STOP_PADMASK = TIME_SET_PADMASK_MOVE + 2.5
local TIME_PESET_WALK_PADMASK = TIME_RESET_STOP_PADMASK + 2
local TIME_EVENT_1F4ROOM_WARP = 5
local TIME_EVENT_2F_START = 1
local TIME_EVENT_2F_DEAD = 4
local TIMER_TO_DEMO = 0.7
local TIMER_B1_DOOR = 0.12

local TIME_SHAKE_AIM = 2.0

local CAMERA_START00 = { rotX = 10, rotY = 80, interpTime = 2 }
local CAMERA_START01 = { rotX = 10, rotY = 100, interpTime = 10 }
local CAMERA_START = { rotX = 10, rotY = 90, interpTime = 0.5 }
local CAMERA_1F_ROUKA = { rotX = 7.5, rotY = 187.5, interpTime = 1.5 }
local CAMERA_1F_SOLDIER = { rotX = 10, rotY = 180, interpTime = 1.5 }
local CAMERA_2F1 = { rotX = 10, rotY = -70, interpTime = 1.5 }
local CAMERA_2F4 = { rotX = 10, rotY = 220, interpTime = 1 }
local CAMERA_2F42 = { rotX = 10, rotY = 280, interpTime = 1 }
local CAMERA_3F_ROUKA = { rotX = 7.5, rotY = 160, interpTime = 0.4 }
local CAMERA_3F4 = { rotX = 40, rotY = 290, interpTime = 3 }
local CAMERA_1F_STEP = { rotX = -25, rotY = 0, interpTime = 3 }
local CAMERA_BATTLE = { rotX = 10, rotY = 0, interpTime = 1 }
local CAMERA_END_BATTLE = { rotX = 10, rotY = 60, interpTime = 7 }
local CAMERA_DSIT = 0.8
local CAM_DATA = {
	cameraType = PlayerCamera.Around,
	force = true,
	fixed = true,
	recoverPreOrientation = false,
	dataIdentifierName = "CameraIdentifier",
	keyName = "camera01",
	interpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	interpTimeToRecover = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	areaSize = 0.5,
	time = 5,
	cameraOffset = Vector3(-0.5, 1.35, 0.0),
	cameraOffsetInterpTime = 2.0,
	targetOffset = Vector3(0.0, -0.9, 0.0),
	targetOffsetInterpTime = 0.3,
	focalLength = 35.0,
	focalLengthInterpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	minDistance = 1.0,
	maxDistanve = 50.0,
}
local CAM_DATA_B1 = {
	cameraType = PlayerCamera.Around,
	force = true,
	fixed = true,
	recoverPreOrientation = false,
	dataIdentifierName = "CameraIdentifier",
	keyName = "camera02",
	interpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	interpTimeToRecover = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	areaSize = 0.5,
	time = 3,
	cameraOffset = Vector3(-0.5, 0.8, 0.0),
	cameraOffsetInterpTime = 1.0,
	targetOffset = Vector3(0.0, 0.0, 0.0),
	targetOffsetInterpTime = 0.3,
	focalLength = 35.0,
	focalLengthInterpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	minDistance = 1.0,
	maxDistanve = 50.0,
}
local CAM_DATA_B1_LIVE_MAN = {
	cameraType = PlayerCamera.Around,
	force = true,
	fixed = true,
	recoverPreOrientation = false,
	gameObjectName = "sol_mbqf_0003",
	skeletonName = "SKL_004_HEAD",
	interpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	interpTimeToRecover = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	areaSize = 1.0,
	time = 10,
	cameraOffset = Vector3(0.4, 0.7, 2.4),
	cameraOffsetInterpTime = 0.8,
	targetOffset = Vector3(-0.8, 0.0, 0.0),
	targetOffsetInterpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	minDistance = 0.1,
	maxDistanve = 20.0,
}
local CAM_DATA_2F = {
	cameraType = PlayerCamera.Around,
	force = true,
	fixed = true,
	recoverPreOrientation = false,
	gameObjectName = "sol_mbqf_0003",
	skeletonName = "SKL_004_HEAD",
	interpTime = 1.0,
	interpTimeToRecover = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	areaSize = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	time = 3,
	cameraOffset = Vector3(-0.8, 0.6, 2.8),
	cameraOffsetInterpTime = 0.4,
	targetOffset = Vector3(0.2, 0.0, 0.0),
	targetOffsetInterpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	minDistance = 0.1,
	maxDistanve = 20.0,
}
local CAM_DATA_2F3 = {
	cameraType = PlayerCamera.Around,
	force = true,
	fixed = true,
	recoverPreOrientation = false,
	dataIdentifierName = "CameraIdentifier",
	keyName = "camera06",
	interpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	interpTimeToRecover = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	areaSize = 0.5,
	time = 3,
	cameraOffset = Vector3(-0.5, 0.7, 0.0),
	cameraOffsetInterpTime = 2.0,
	targetOffset = Vector3(0.1, 0.0, 0.0),
	targetOffsetInterpTime = 2.0,
	focalLength = 35.0,
	focalLengthInterpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	minDistance = 1.0,
	maxDistanve = 50.0,
}
local CAM_DATA_2F1 = {
	cameraType = PlayerCamera.Around,
	force = true,
	fixed = true,
	recoverPreOrientation = false,
	dataIdentifierName = "CameraIdentifier",
	keyName = "camera07",
	interpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	interpTimeToRecover = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	areaSize = 0.5,
	time = 3,
	cameraOffset = Vector3(-0.5, 0.7, 0.0),
	cameraOffsetInterpTime = 2.0,
	targetOffset = Vector3(0.1, 0.0, 0.0),
	targetOffsetInterpTime = 2.0,
	focalLength = 35.0,
	focalLengthInterpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	minDistance = 1.0,
	maxDistanve = 50.0,
}
local CAM_DATA_2F4 = {
	cameraType = PlayerCamera.Around,
	force = true,
	fixed = true,
	recoverPreOrientation = false,
	dataIdentifierName = "CameraIdentifier",
	keyName = "camera05",
	interpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	interpTimeToRecover = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	areaSize = 0.5,
	time = 3,
	cameraOffset = Vector3(-0.5, 0.7, 0.0),
	cameraOffsetInterpTime = 2.0,
	targetOffset = Vector3(0.1, -0.0, 0.0),
	targetOffsetInterpTime = 2.0,
	focalLength = 45.0,
	focalLengthInterpTime = TppDefine.DIRECTION_ZOOM_IN_CAMERA_ZOOM_INTERP_TIME,
	minDistance = 1.0,
	maxDistanve = 50.0,
}

local SFX_1F_ROUKA = { sfx = "sfx_w_e_ar01_s10240", pos = Vector3(-2.781, 1.601, 11.421) }
local SFX_1F_ROUKA_HIT = { sfx = "sfx_e_dmg_hit_bullet_body_l", pos = Vector3(-2.781, 1.601, 11.421) }
local SFX_1F_ROUKA_DOWN = { sfx = "Play_sfx_m_bodyfall_body", pos = Vector3(-2.781, 1.601, 11.421) }
local SFX_1F_ROUKA_DROP = { sfx = "sfx_w_gun_drop_rifle_01", pos = Vector3(-2.781, 1.601, 11.421) }
local SFX_2F_STEP_DEAD = { sfx = "sfx_e_dd_tosha", pos = Vector3(5.677, 3.735, 15.896) }
local SFX_2F_STEP_DOWN = { sfx = "Play_sfx_m_bodyfall_body", pos = Vector3(5.677, 3.735, 15.896) }
local SFX_2F_GERO = { sfx = "sfx_m_mbqf_vomit", pos = Vector3(-1.476, 4.500, 9.663) }
local SFX_3F_DOWN = { sfx = "Play_sfx_m_bodyfall_body", pos = Vector3(-4.516, 8.000, 22.888) }
local SFX_3F_ROUKA = { sfx = "sfx_w_e_hg00_s10240_2", pos = Vector3(-0.125, 9.861, 13.137) }
local SFX_3F_ROUKA_DOWN = { sfx = "Play_sfx_m_bodyfall_body", pos = Vector3(1.442, 8.000, 10.312) }
local SFX_SHOT_FIRE_ALERM = "sfx_m_mbqf_fire_alarm"
local SFX_SHOT_STOP_FIRE_ALERM = "Stop_m_mbqf_fire_alarm"
local SFX_SHOT_POWER_ON = "sfx_m_mtbs_power_on"
local SFX_SHOT_POWER_OFF = "sfx_m_mtbs_power_off"
local SFX_ENTER_LOAD = "sfx_m_mbqf_door_enter"
local SFX_ENTER = "sfx_m_mbqf_enter"
local SFX_ENTER_RESET = "sfx_m_mbqf_reset"
local SFX_EXIT = "sfx_m_mbqf_door_exit"
local SFX_RADIO_NOISE1 = "sfx_m_mbqf_radio1"
local SFX_RADIO_NOISE2 = "sfx_m_mbqf_radio2"
local SFX_KILL_ENEMY = "sfx_s_killed_dd_impact"

local EnemyVoiceParam = "DD_vox_ene_s10240"

local RATE_ENEMY = 0.04
local RATE_MIN = 0.5
local RATE_TIME = 0.3

local GIMMICK_PATH = "/Assets/tpp/level/location/mtbs/block_large/mtbs_qrntnFacility_gimmick.fox2"
local GIMMICK_NAME_BOX1 = "mtbs_crto002_vrtn001_gim_n0012|srt_mtbs_crto002_vrtn001"

local MESSAGE_ROUTE_DETH = "RouteInFire"
local MESSAGE_ROUTE_2F4 = "RouteLowRedy"

local ENEMY_0000 = "sol_mbqf_0012"
local ENEMY_0001 = "sol_mbqf_0013"
local ENEMY_0002 = "sol_mbqf_0000"
local ENEMY_0003 = "sol_mbqf_0014"
local ENEMY_0004 = "sol_mbqf_0015"
local ENEMY_0005 = "sol_mbqf_0016"
local ENEMY_1000 = "sol_mbqf_0001"
local ENEMY_1001 = "sol_mbqf_0018"
local ENEMY_1002 = "sol_mbqf_0022"
local ENEMY_1003 = "sol_mbqf_0023"
local ENEMY_1004 = "sol_mbqf_0024"
local ENEMY_1040 = "sol_mbqf_0019"
local ENEMY_1200 = "sol_mbqf_0003"
local ENEMY_1206 = "sol_mbqf_0026"
local ENEMY_2000 = "sol_mbqf_0008"
local ENEMY_2010 = "sol_mbqf_0002"
local ENEMY_2100 = "sol_mbqf_0010"
local ENEMY_2200 = "sol_mbqf_0021"
local ENEMY_2210 = "sol_mbqf_0026"
local ENEMY_3000 = "sol_mbqf_0017"
local ENEMY_3040 = "sol_mbqf_0004"
local ENEMY_4000 = "sol_mbqf_0005"
local ENEMY_4001 = "sol_mbqf_0006"
local ENEMY_4002 = "sol_mbqf_0007"
local ENEMY_5000 = "sol_mbqf_1000"
local ENEMY_5001 = "sol_mbqf_1001"
local ENEMY_5002 = "sol_mbqf_1002"
local ENEMY_5003 = "sol_mbqf_1003"
local ENEMY_5004 = "sol_mbqf_1004"
local ENEMY_5005 = "sol_mbqf_1005"
local ENEMY_5006 = "sol_mbqf_1006"
local ENEMY_5007 = "sol_mbqf_1007"
local ENEMY_5008 = "sol_mbqf_1008"
local ENEMY_5009 = "sol_mbqf_1009"
local ENEMY_5010 = "sol_mbqf_1010"
local ENEMY_5011 = "sol_mbqf_1011"

local ROUTE_1F4_STAY = "rts_mbqf_1040"
local ROUTE_1F4_TO_2F1 = "rts_mbqf_1041"
local ROUTE_2F1_EVENT = "rts_mbqf_2010"
local ROUTE_2ROUTE_WAIT = "rts_mbqf_2210"
local ROUTE_2ROUTE_FIRE = "rts_mbqf_2211"
local ROUTE_2F_STEP_STAY = "rts_mbqf_2000"
local ROUTE_2F_STEP_WALK = "rts_mbqf_2001"
local ROUTE_2F4_IDLE = "rts_mbqf_2400"
local ROUTE_2F4_START = "rts_mbqf_2410"
local ROUTE_2F4_AIM = "rts_mbqf_2402"
local ROUTE_2F4_TO_B1 = "rts_mbqf_2401"
local ROUTE_3F_OBIE = "rts_mbqf_3001"
local ROUTE_2F_SHOOT1 = "rts_mbqf_2002"
local ROUTE_2F_SHOOT2 = "rts_mbqf_2003"

local MESSAGE_ROUTE = {
	EVENT1040 = "route_end_1040",
	EVENT2000 = "routeEnd2000",
	EVENT2010 = "routeEnd2010",
}

local LIGHT_TABLE = {

	"Light_2F_Top",
	"Light_3F_Top",
	"Light_4F_Top",
}

local LIGHT_EM_TABLE = {
	"Light_1F",
	"Light_2F",
	"Light_3F",
	"Light_4F",
}

local DEAD_CASE_TABLE = {

	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	"sol_mbqf_0005",
	"sol_mbqf_0006",
	"sol_mbqf_0007",
	"sol_mbqf_0010",
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	"sol_mbqf_0019",
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	nil,
}

function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences({
		"Seq_Demo_Opening",
		"Seq_Game_GoToInQuarantineFacility",
		"Seq_Demo_GoToDoor",
		"Seq_Game_MainGame",
		"Seq_Demo_Roof",
		"Seq_Game_Battle_Roof",
		"Seq_Game_Slaughter",
		"Seq_Demo_EndCut",
		"Seq_Demo_Funeral",
		"Seq_Demo_InMbqf",
		nil,
	})
	TppSequence.RegisterSequenceTable(sequences)
end

this.saveVarsList = {
	numEnemyDown = 0,
	numEnemyDownSound = 0,
	numKillEnemy = 0,
	isClear3F = false,
	isClear2F = false,
	isClear1F = false,
	isClear0F = false,
	isAllClear = false,
	numBlackOut = 0,

	isDoEvent00 = 0,
	isDoEvent01 = false,
	isDoEvent12 = false,
	isDoEvent20 = false,
	isDoEvent24 = false,
	isDead24 = false,
	isDoEvent2rouka = false,
	isDoEvent34 = false,
	isDoEvent35 = false,
	isDoEventB1Pre = false,
	isDoEventB1 = false,
	isDoEventB2 = false,
	isSayRadioRoof = false,
	numDoEventRoof = 0,
	numDoEventLast = 0,
	isDoEventSong = false,
	numEventB1Talk = 0,
	numEvent2F3 = 0,
	isLook2F4Enemy = false,
	numCheckDead = 0,

	isObieLoop01 = false,
	isObieLoop02 = false,
	isObieLoop03 = false,
	isObieLoop04 = false,
	isObieLoop05 = false,
	isObieLoop06 = false,
	isObieLoop07 = false,
	isObieLoop08 = false,
	isObieLoop09 = false,
	isObieLoop10 = false,
	isObieLoop11 = false,
	isObieLoop12 = false,

	isTalk01 = false,
	isTalk02 = false,
	isTalk03 = false,
	isTalk04 = false,
	isTalk05 = false,
	isTalk06 = false,
	isTalk07 = false,
	isTalk08 = false,
	isTalk09 = false,
	isTalk10 = false,
	isTalk11 = false,
	isTalk12 = false,
	isTalk13 = false,
	isTalk14 = false,
	isTalk15 = false,
	isTalk16 = false,
	isTalk17 = false,
	isTalk18 = false,
	isDebug = 0,
	isTalk19 = false,
	isTalk20 = false,
	isTalk21 = false,

	isHoken03 = false,
	isHoken04 = false,
	isHoken05 = false,
	isHoken06 = false,
	isHoken07 = false,
	isHoken08 = false,
	isHoken09 = false,

	deadCase05Num = TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	deadCase06Num = TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	deadCase07Num = TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	deadCase10Num = TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,
	deadCase19Num = TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN,

	isSwitchBGM02 = false,
	isSwitchBGM03 = false,

	isTalk22 = false,
	nil,
}

this.event2F3Enum = Tpp.Enum({
	"START",
	"CAN_DEAD",
	"IDLE",
	"IDLE2",
	"AORI",
	"SELF",
	"DEAD",
})

this.checkPointList = {
	"CHK_roof",
	"CHK_startBattle",
	"CHK_exit",
	"CHK_enter",
	"CHK_1fRouka",
	"CHK_2f3",
	"CHK_2f4",
	"CHK_2f",
	"CHK_B1",
	nil,
}

this.missionObjectiveDefine = {

	marker_mbqf_enter = {
		gameObjectName = "default_area_door",
		visibleArea = 0,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
	},

	default_photo_mbqf = {
		photoId = 10,
		subGoalId = 0,
	},

	default_photo_in_mbqf = {
		photoId = 10,
		photoRadioName = "s0240_mirg0010",
		subGoalId = 0,
	},

	slaugher_photo_mbqf = {
		photoId = 10,
		subGoalId = 1,
		announceLog = "updateMissionInfo",
	},

	marker_clear_exit = {
		gameObjectName = "marker_clear_exit",
		visibleArea = 0,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
		subGoalId = 2,
	},

	default_missionTask_00 = { missionTask = { taskNo = 0, isNew = true, isComplete = false, isFirstHide = false } },
	clear_missionTask_00 = { missionTask = { taskNo = 0, isNew = true, isComplete = true } },

	default_missionTask_01 = { missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = true } },
	open_missionTask_01 = { missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = false } },
	clear_missionTask_01 = { missionTask = { taskNo = 1, isNew = true, isComplete = true } },
}

this.missionObjectiveTree = {
	marker_clear_exit = {
		slaugher_photo_mbqf = {
			default_photo_in_mbqf = {
				default_photo_mbqf = {},
				marker_mbqf_enter = {},
			},
		},
	},
	clear_missionTask_00 = {
		default_missionTask_00 = {},
	},
	clear_missionTask_01 = {
		open_missionTask_01 = {
			default_missionTask_01 = {},
		},
	},
}

this.missionObjectiveEnum = Tpp.Enum({
	"marker_mbqf_enter",
	"default_photo_mbqf",
	"marker_clear_exit",
	"default_photo_in_mbqf",
	"slaugher_photo_mbqf",

	"default_missionTask_00",
	"default_missionTask_01",
	"clear_missionTask_00",
	"clear_missionTask_01",
	"open_missionTask_01",
})

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	TppWeather.RequestWeather(TppDefine.WEATHER.SUNNY)

	TppPlayer.RegisterTemporaryPlayerType({
		partsType = PlayerPartsType.NORMAL,
		camoType = PlayerCamoType.OLIVEDRAB,
		playerType = PlayerType.SNAKE,
		handEquip = TppEquip.EQP_HAND_NORMAL,
		faceEquipId = 0,
	})

	TppScriptBlock.PreloadRequestOnMissionStart({
		{ demo_block = "Demo_Opening" },
	})

	this.SetMbDvcMenu(false)

	TppTerminal.StopChangeDayTerminalAnnounce()

	TppMission.RegiserMissionSystemCallback({
		OnEndMissionReward = function(missionClearType)
			Fox.Log("onEnd reward")

			TppStory.StartElapsedMissionEvent(
				TppDefine.ELAPSED_MISSION_EVENT.DECISION_HUEY,
				TppDefine.INIT_ELAPSED_MISSION_COUNT.DECISION_HUEY
			)

			Player.UnsetEquip({
				slotType = PlayerSlotType.ITEM,
				subIndex = 1,
				dropPrevEquip = false,
			})
			this.StopSongEvent()

			TppMission.DisablePauseForShowResult()

			TppMission.Reload({

				missionPackLabelName = "out",
				locationCode = TppDefine.LOCATION_ID.MTBS,
				layoutCode = TppDefine.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
				clusterId = 7,
				showLoadingTips = false,
				OnEndFadeOut = function()
					local pos = { -163.605, 0.000, -2098.350 }
					TppPlayer.SetInitialPosition(pos, 0)
					TppUiStatusManager.SetStatus("AnnounceLog", "INVALID_LOG")
					TppSequence.ReserveNextSequence("Seq_Demo_Funeral", { isExecMissionClear = true })
					TppMission.ReserveForcePlayerPositionToMbDemoCenter()
				end,
			})
		end,
	})
end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	TppWeather.RequestWeather(TppDefine.WEATHER.SUNNY)

	TppSoundDaemon.PostEvent(SFX_SHOT_STOP_FIRE_ALERM)

	local nextSequenceIndex = TppSequence.GetSequenceIndex(TppSequence.GetMissionStartSequenceName())
	Fox.Log("next seq index = " .. nextSequenceIndex)
	if
		nextSequenceIndex < TppSequence.GetSequenceIndex("Seq_Game_MainGame")
		or nextSequenceIndex == TppSequence.GetSequenceIndex("Seq_Demo_Funeral")
	then
		Fox.Log("not in MBQF")

		MotherBaseStage.LockCluster(7)
	else
		this.ResetEnableModel()
		this.ResetBlackOut()
	end

	if nextSequenceIndex == TppSequence.GetSequenceIndex("Seq_Game_Battle_Roof") then
		TppEnemy.SetDisable(ENEMY_4000)
		TppEnemy.SetDisable(ENEMY_4001)
		TppEnemy.SetDisable(ENEMY_4002)
		s10240_enemy02.AddEnemyRoute(ENEMY_4000, "rts_mbqf_4002", 0)
		s10240_enemy02.AddEnemyRoute(ENEMY_4001, "rts_mbqf_4000", 0)
		s10240_enemy02.AddEnemyRoute(ENEMY_4002, "rts_mbqf_4001", 0)
		TppEnemy.SetEnable(ENEMY_4000)
		TppEnemy.SetEnable(ENEMY_4001)
		TppEnemy.SetEnable(ENEMY_4002)
	end
end

function this.OnEndMissionPrepareSequence()
	local nextSequence = TppSequence.GetSequenceIndex(TppSequence.GetMissionStartSequenceName())

	if nextSequence == TppSequence.GetSequenceIndex("Seq_Game_Slaughter") then
		if svars.isAllClear == false then
		else
			TppEnemy.SetDisable(ENEMY_1200)
		end
	elseif nextSequence == TppSequence.GetSequenceIndex("Seq_Game_MainGame") then
		TppSoundDaemon.PostEvent(SFX_ENTER_RESET)

		if TppSequence.GetContinueCount() == 0 then
		end
	end

	TppUiStatusManager.UnsetStatus("AtTime", "INVALID")
	TppUiStatusManager.UnsetStatus("Notice", "INVALID")
end

function this.OnTerminate()
	TppUiStatusManager.UnsetStatus("AtTime", "INVALID")
	TppUiStatusManager.UnsetStatus("Notice", "INVALID")
	TppUiStatusManager.UnsetStatus("EquipHudAll", "ALL_KILL_NOUSE")

	TppSoundDaemon.PostEvent(SFX_SHOT_STOP_FIRE_ALERM)

	TppEffectUtility.SetDirtyModelMemoryStrategy("Default")

	vars.playerDisableActionFlag = PlayerDisableAction.NONE
end

this.playerInitialWeaponTable = {
	{ secondary = "EQP_WP_10004", magazine = TppDefine.INIT_MAG.HANDGUN_DEFAULT },
	{ primaryHip = "EQP_WP_30103", magazine = TppDefine.INIT_MAG.ASSAULT_DEFAULT },
	{ primaryBack = "EQP_None" },
	{ support = "EQP_None" },
	{ support = "EQP_None" },
	{ support = "EQP_None" },
	{ support = "EQP_None" },
	{ support = "EQP_None" },
	{ support = "EQP_None" },
	{ support = "EQP_None" },
	{ support = "EQP_None" },
}

this.playerInitialItemTable =
	{ "EQP_None", "EQP_None", "EQP_None", "EQP_None", "EQP_None", "EQP_None", "EQP_None", "EQP_None" }

function this.Messages()
	return StrCode32Table({
		Player = {
			{
				msg = "CheckEventDoorNgIcon",
				func = function(playerId, doorId)
					if doorId == this.GetDoorId("roof") then
						Player.SetEventLockDoorIcon({ doorId = doorId, isNgIcon = 0 })
					elseif doorId == this.GetDoorId() then
						if svars.isAllClear == true then
							Player.SetEventLockDoorIcon({ doorId = doorId, isNgIcon = 0 })
						else
							if svars.numDoEventLast == 0 and this.CheckIsCarriedLastMan() then
								Player.SetEventLockDoorIcon({ doorId = doorId, isNgIcon = 0 })
							else
								Player.SetEventLockDoorIcon({ doorId = doorId, isNgIcon = 1 })
							end
						end
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
			{
				msg = "Dead",
				func = function(gameObjectId, killerGameObjectId, phase, damage)
					if TppLocation.IsMBQF() == true then
						local rate = 0.9
						rate = rate - (svars.numEnemyDown * RATE_ENEMY)
						if rate < RATE_MIN then
							rate = RATE_MIN
						end
						Fox.Log("HighSpeedCamera rate : " .. rate .. ",  time : " .. RATE_TIME)

						HighSpeedCamera.RequestEvent({
							continueTime = RATE_TIME,
							worldTimeRate = rate,
							localPlayerTimeRate = rate,
							timeRateInterpTimeAtStart = 0.2,
							timeRateInterpTimeAtEnd = 0.2,
							cameraSetUpTime = 0.0,
							noDustEffect = true,
						})

						if svars.numCheckDead < 1 then
						else
							svars.numCheckDead = svars.numCheckDead - 1
						end

						if damage == DeadMessageFlag.FIRE then
							Fox.Log("dead by fire")
							if gameObjectId == GameObject.GetGameObjectId("TppSoldier2", ENEMY_4000) then
								svars.deadCase05Num = TppMotherBaseManagementConst.REMOVER_REASON_BURN
							elseif gameObjectId == GameObject.GetGameObjectId("TppSoldier2", ENEMY_4001) then
								svars.deadCase06Num = TppMotherBaseManagementConst.REMOVER_REASON_BURN
							elseif gameObjectId == GameObject.GetGameObjectId("TppSoldier2", ENEMY_4002) then
								svars.deadCase07Num = TppMotherBaseManagementConst.REMOVER_REASON_BURN
							end
						end
					end
				end,
			},
			{
				msg = "Damage",
				func = function(gameObjectId, attackId, attakerId)
					Fox.Log("Message: Damage")
					if TppLocation.IsMBQF() == true then
						if Tpp.IsPlayer(attakerId) and TppDamage.IsActiveByAttackId(attackId) then
							s10240_enemy02.CallDamageVoice(gameObjectId)
							s10240_enemy02.DamageMotion(gameObjectId)
						end

						if
							gameObjectId == GameObject.GetGameObjectId(ENEMY_0000)
							or gameObjectId == GameObject.GetGameObjectId(ENEMY_0001)
							or gameObjectId == GameObject.GetGameObjectId(ENEMY_0002)
							or gameObjectId == GameObject.GetGameObjectId(ENEMY_1000)
							or gameObjectId == GameObject.GetGameObjectId(ENEMY_1001)
							or gameObjectId == GameObject.GetGameObjectId(ENEMY_1002)
							or gameObjectId == GameObject.GetGameObjectId(ENEMY_1003)
							or gameObjectId == GameObject.GetGameObjectId(ENEMY_1004)
						then
							s10240_enemy02.AfterPushB1Room(gameObjectId)
						end
					end
				end,
			},

			{
				msg = "RoutePoint2",
				func = function(objectId, routeId, routeNode, message)
					Fox.Log("get message RoutePoint2 : " .. message)
					if message == StrCode32(MESSAGE_ROUTE_DETH) then
						local command = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DEAD }
						GameObject.SendCommand(objectId, command)
					elseif message == StrCode32(MESSAGE_ROUTE_2F4) then
					end
				end,
			},
		},
		Trap = {
			{
				msg = "Enter",
				sender = "light_mbqf_1f",
				func = function()
					this.ChangeIsolate("Light_1F")
					this.ChangeIsolateTop("Light_1F_Top")
				end,
			},
			{
				msg = "Enter",
				sender = "light_mbqf_2f",
				func = function()
					this.ChangeIsolate("Light_2F")
					this.ChangeIsolateTop("Light_2F_Top")
				end,
			},
			{
				msg = "Enter",
				sender = "light_mbqf_3f",
				func = function()
					this.ChangeIsolate("Light_3F")
					this.ChangeIsolateTop("Light_3F_Top")
				end,
			},
			{
				msg = "Enter",
				sender = "light_mbqf_4f",
				func = function()
					this.ChangeIsolate("Light_4F")
					this.ChangeIsolateTop("Light_4F_Top")
				end,
			},
		},
		Timer = {
			{
				msg = "Finish",
				sender = "Timer_BlackOut",
				func = function()
					Fox.Log("set sub light flag")
					TppSoundDaemon.PostEvent(SFX_SHOT_POWER_ON)
				end,
			},
			{
				msg = "Finish",
				sender = "Timer_SetPadMaskMove",
				func = function()
					this.SetPadMaskMove()
				end,
			},
			{
				msg = "Finish",
				sender = "Timer_ResetPadMaskMove",
				func = function()
					this.ResetPadMaskMove()
				end,
			},
			{
				msg = "Finish",
				sender = "Timer_ResetPadMaskWalk",
				func = function()
					this.ReSetPadMaskWalk()
					this.SetDisableActionFlag()
				end,
			},
			{
				msg = "Finish",
				sender = "Timer_ExitSE",
				func = function()
					s10240_radio.MissionClear()
					TppSoundDaemon.PostEvent(SFX_EXIT)
				end,
				option = { isExecMissionClear = true },
			},
			{
				msg = "Finish",
				sender = "Timer_Shake",
				func = function()
					Fox.Log("test shake")
					TppSoundDaemon.PostEvent("vib_door_open_hard_01")
				end,
			},
			{
				msg = "Finish",
				sender = "Timer_StopConstCamera",
				func = function()
					this.StopConstCamera()
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

this.CommonSetUpInMBQF = function()
	this.SetDisableActionFlag()
	this.SetGimmickDoorForDemo()
	s10240_enemy02.SetDisableCarried()
	this.ChangeEffetsSequence()
	this.SetHideRadio()
	this.SetMbDvcMenu(false)
	s10240_enemy02.SetNoClothAnim()
	s10240_enemy02.SetOwnerPlayer()
	TppUiStatusManager.SetStatus("AnnounceLog", "INVALID_LOG_EXCEPT")
	TppUiStatusManager.SetStatus("AtTime", "INVALID")
	TppUiStatusManager.SetStatus("Notice", "INVALID")

	this.SetHideFann()
end

this.PlaySfx3D = function(table)
	if table.sfx == nil then
		Fox.Error("sfx table.sfx is null")
		return
	end
	if table.pos == nil then
		Fox.Error("sfx table.pos is null")
		return
	end

	Fox.Log("play sfx " .. table.sfx)
	TppSoundDaemon.PostEvent3D(table.sfx, table.pos)
end

this.StopTimer = function(timerName)
	if Tpp.IsTypeString(timerName) == false then
		Fox.Error("pram is not string")
		return
	end

	if GkEventTimerManager.IsTimerActive(timerName) then
		GkEventTimerManager.Stop(timerName)
	end
end

this.GoToOutQuarantineFacility = function()
	if svars.isAllClear then
		GkEventTimerManager.Start("Timer_ExitSE", 2)
		TppMission.ReserveMissionClear({
			missionClearType = TppDefine.MISSION_CLEAR_TYPE.ON_FOOT,
			nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE,
		})
	else
		if svars.numDoEventLast ~= 1 then
			s10240_radio.NeedMoreKill()
		end
	end
end

this.SetMbDvcMenu = function(switch)
	local flag = true
	if switch == false then
		flag = false
	end

	TppUiCommand.SetMbTopMenuItemActive(TppTerminal.MBDVCMENU.MSN_DROP, flag)
	TppUiCommand.SetMbTopMenuItemActive(TppTerminal.MBDVCMENU.MSN_BUDDY, flag)
	TppUiCommand.SetMbTopMenuItemActive(TppTerminal.MBDVCMENU.MSN_ATTACK, flag)
	TppUiCommand.SetMbTopMenuItemActive(TppTerminal.MBDVCMENU.MSN_HELI, flag)
	TppUiCommand.SetMbTopMenuItemActive(TppTerminal.MBDVCMENU.MBM_DEVELOP_WEAPON, flag)
end

this.StopGimmickCrane = function()
	Fox.Log("StopGimmickCrane()")
	local layout = MotherBaseStage.GetCurrentLayout()
	local name =
		"ly003_cl07_item0000|cl07pl0_mb_fndt_plnt_gimmick2_nowep|mtbs_cran001_vrtn002_gim_n0000|srt_mtbs_cran001_vrtn002"
	local dataset = string.format(
		"/Assets/tpp/level/location/mtbs/block_area/ly%03d/cl07/mtbs_ly%03d_cl07_item.fox2",
		layout,
		layout
	)
	Fox.Log(name)
	Fox.Log(dataset)

	Gimmick.PauseSharedAnim(name, dataset, true, 0)
end

this.GetDoorId = function(doorName)
	local GIMMICK_PATH = "/Assets/tpp/level/location/mtbs/block_large/mtbs_qrntnFacility_gimmick.fox2"

	local name = DOOR_ENTER
	if doorName == "roof" then
		name = DOOR_ROOF
	end

	local enable, gimmickId = Gimmick.GetGameObjectId(TppGameObject.GAME_OBJECT_TYPE_DOOR, name, GIMMICK_PATH)

	return gimmickId
end

this.StartDisableActionForEvent = function(param)
	local addTime = 0
	local addWalkTime = 0
	local type = 0

	if Tpp.IsTypeTable(param) == false and param ~= nil then
		Fox.Error("param is not table")
	end

	if param ~= nil then
		if param.addTime ~= nil and Tpp.IsTypeNumber(param.addTime) then
			addTime = param.addTime
		end
		if param.addWalkTime ~= nil and Tpp.IsTypeNumber(param.addWalkTime) then
			addWalkTime = param.addWalkTime
		end

		if param.type ~= nil and Tpp.IsTypeString(param.type) then
			type = param.type
		end
	end

	this.SetDisableActionRun()

	this.SetPadMaskWalk(type)

	this.StopTimer("Timer_SetPadMaskMove")
	GkEventTimerManager.Start("Timer_SetPadMaskMove", TIME_SET_PADMASK_MOVE)

	this.StopTimer("Timer_ResetPadMaskMove")
	GkEventTimerManager.Start("Timer_ResetPadMaskMove", TIME_RESET_STOP_PADMASK + addTime)

	this.StopTimer("Timer_ResetPadMaskWalk")
	GkEventTimerManager.Start("Timer_ResetPadMaskWalk", TIME_PESET_WALK_PADMASK + addTime + addWalkTime)
end

this.StartDisableRunForEvent = function(time)
	local addTime = 0
	if Tpp.IsTypeNumber(time) then
		addTime = time
	end

	this.SetDisableActionRun()

	this.StopTimer("Timer_ResetPadMaskWalk")
	GkEventTimerManager.Start("Timer_ResetPadMaskWalk", TIME_PESET_WALK_PADMASK + addTime)
end

this.SetDisableActionRun = function()
	vars.playerDisableActionFlag = PlayerDisableAction.FULTON
		+ PlayerDisableAction.BEHIND
		+ PlayerDisableAction.RUN
		+ PlayerDisableAction.CQC
		+ PlayerDisableAction.CQC_INTERROGATE
		+ PlayerDisableAction.STEALTHASSIST
		+ PlayerDisableAction.SUBJECTIVE_CAMERA
end

this.SetDisableOnlyCQC = function()
	vars.playerDisableActionFlag = PlayerDisableAction.FULTON
		+ PlayerDisableAction.BEHIND
		+ PlayerDisableAction.CQC_INTERROGATE
		+ PlayerDisableAction.STEALTHASSIST
end

this.SetPadMaskWalk = function(type)
	local buttonsType = PlayerPad.ZOOM_CHANGE
	if type == "CanFire" then
		buttonsType = PlayerPad.ZOOM_CHANGE + PlayerPad.HOLD + PlayerPad.FIRE + PlayerPad.RELOAD + PlayerPad.SUBJECT
	end

	Player.SetPadMask({

		settingName = "WalkOnly",

		except = true,
		buttons = buttonsType,
		sticks = PlayerPad.STICK_L + PlayerPad.STICK_R,
	})
end

this.ReSetPadMaskWalk = function()
	Player.ResetPadMask({
		settingName = "WalkOnly",
	})
end

this.SetPadMaskMove = function(eventType)
	Player.SetPadMask({

		settingName = "stickLMaskForEvent",

		except = false,
		buttons = PlayerPad.EVADE,
		sticks = PlayerPad.STICK_L,
	})
end
this.ResetPadMaskMove = function()
	Player.ResetPadMask({
		settingName = "stickLMaskForEvent",
	})
end

this.SetPadMaskDash = function(eventType)
	Player.SetPadMask({

		settingName = "dash",

		except = false,
		buttons = PlayerPad.DASH + PlayerPad.EVADE,
	})
end
this.ResetPadMaskDash = function()
	Player.ResetPadMask({
		settingName = "dash",
	})
end

this.StartConstCamera = function(param)
	Fox.Log("StartConstCamera()")
	if param == nil then
		Fox.Error("param is nil")
		return
	end

	local stopTime = param.time
	param.time = param.time + 1

	Player.StartTargetConstrainCamera(param)

	GkEventTimerManager.Start("Timer_StopConstCamera", stopTime)

	TppSoundDaemon.PostEvent("sfx_s_force_camera_in")
end

this.StopConstCamera = function()
	Fox.Log("StopConstCamera()")
	TppSoundDaemon.PostEvent("sfx_s_force_camera_out")
	Player.StopTargetConstrainCamera()
end

this.SetDisableActionFlag = function()
	Fox.Log("SetDisableActionFlag")
	local checkSequence = TppSequence.GetCurrentSequenceIndex()
	if TppLocation.IsMBQF() then
		Fox.Log("set")
		vars.playerDisableActionFlag = PlayerDisableAction.FULTON
			+ PlayerDisableAction.BEHIND
			+ PlayerDisableAction.CQC
			+ PlayerDisableAction.CQC_INTERROGATE
			+ PlayerDisableAction.STEALTHASSIST
		this.SetPadMaskDash()
		GameObject.SendCommand(
			{ type = "TppPlayer2", index = PlayerInfo.GetLocalPlayerIndex() },
			{ id = "SetStandMoveSpeedLimit", speedRateLimit = 0.5 }
		)
	else
		Fox.Log("unset")

		vars.playerDisableActionFlag = PlayerDisableAction.CQC_KNIFE_KILL
			+ PlayerDisableAction.CQC_INTERROGATE
			+ PlayerDisableAction.FULTON
			+ PlayerDisableAction.KILLING_WEAPON
			+ PlayerDisableAction.STEALTHASSIST
		GameObject.SendCommand(
			{ type = "TppPlayer2", index = PlayerInfo.GetLocalPlayerIndex() },
			{ id = "SetStandMoveSpeedLimit", speedRateLimit = -1 }
		)
	end
end

this.SetCameraDistance = function(dist, time)
	local num
	local interpTime
	if dist == false then
		num = 1.1
	else
		num = dist
	end

	if time == nil then
		interpTime = 0.8
	else
		interpTime = time
	end
	Fox.Log("set camera distance. dist:" .. num .. " time:" .. interpTime)
	Player.RequestToSetCameraFocalLengthAndDistance({
		distance = num,
		interpTime = interpTime,
	})
end

this.SetWeaponStatus = function()
	Player.SetEquipState({
		slotType = PlayerSlotType.SECONDARY,
		isSuppressorOn = false,
		isLightOn = true,
	})
	Player.SetEquipState({
		slotType = PlayerSlotType.PRIMARY_1,
		isSuppressorOn = false,
		isLightOn = true,
	})
end

this.AimEnemy = function(gameObjectId, isFound)
	if isFound == 0 then
		return
	end
	Fox.Log("aim for player " .. gameObjectId)
	s10240_enemy02.SetObieMotion(gameObjectId)
	if not GkEventTimerManager.IsTimerActive("Timer_Shake") then
		GkEventTimerManager.Start("Timer_Shake", TIME_SHAKE_AIM)
	end
end

this.ResetEnemyPosition = function(enemyId, routeName)
	TppEnemy.SetDisable(enemyId)
	s10240_enemy02.AddEnemyRoute(enemyId, routeName, 0)
	TppEnemy.SetEnable(enemyId)
end

this.ResetEnableModel = function()
	if
		TppSequence.GetSequenceIndex(TppSequence.GetMissionStartSequenceName())
		== TppSequence.GetSequenceIndex("Seq_Game_Slaughter")
	then
		Fox.Log("model change visiblle. B1 enter")
		this.SetEnableModel()

		TppBullet.ClearBulletMark()
	else
		Fox.Log("reset model visiblle.")
		for i, key in pairs(IDEN_ASSET_BEFORE_KEY) do
			TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, key, true)
		end

		for i, key in pairs(IDEN_ASSET_AFTER_KEY) do
			TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, key, false)
		end

		for i, key in pairs(IDEN_PATH_BEFORE_KEY) do
			TppDataUtility.SetEnableDataFromIdentifier(IDEN_PATH_ID, key, true, true)
		end
		for i, key in pairs(IDEN_PATH_AFTER_KEY) do
			TppDataUtility.SetEnableDataFromIdentifier(IDEN_PATH_ID, key, false, true)
		end
	end

	TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, "clear_demo", false)
	TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, "clear_demo_off", true)
end

this.CheckIsDeadLastMan = function()
	local enableState = GameObject.SendCommand(GameObject.GetGameObjectId(ENEMY_1200), { id = "GetStatus" })
	if
		TppEnemy.GetLifeStatus(ENEMY_1200) == TppEnemy.LIFE_STATUS.DEAD
		or enableState == TppGameObject.NPC_STATE_DISABLE
	then
		return true
	else
		return false
	end
end

this.CheckEquipGoggle = function()
	if vars.items[vars.currentItemIndex] == TppEquip.EQP_IT_Infected then
		return true
	else
		return false
	end
end

this.CheckIsCarriedLastMan = function()
	local check = TppEnemy.GetStatus(ENEMY_1200)
	if check == EnemyState.CARRIED and this.CheckIsDeadLastMan() == false then
		return true
	else
		return false
	end
end

this.SetEnableModel = function()
	for i, key in pairs(IDEN_ASSET_AFTER_KEY) do
		TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, key, true)
	end

	for i, key in pairs(IDEN_PATH_AFTER_KEY) do
		TppDataUtility.SetEnableDataFromIdentifier(IDEN_PATH_ID, key, true, true)
	end

	for i, key in pairs(IDEN_ASSET_BEFORE_KEY) do
		TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, key, false)
	end

	for i, key in pairs(IDEN_PATH_BEFORE_KEY) do
		TppDataUtility.SetEnableDataFromIdentifier(IDEN_PATH_ID, key, false, true)
	end
end

this.SetHesitatingFire = function()
	Fox.Log("set Hesitating fire")
	GameObject.SendCommand(
		{ type = "TppPlayer2", index = PlayerInfo.GetLocalPlayerIndex() },
		{ id = "SetHesitatingFire", enabled = true }
	)
end

this.Event2FStepDead = function()
	if TppEnemy.GetLifeStatus(ENEMY_2000) == TppEnemy.LIFE_STATUS.DEAD then
	else
		s10240_enemy02.FaintEnemy(ENEMY_2000)
		s10240_enemy02.CallDamageVoice(ENEMY_2000)
		s10240_enemy02.CallVoice(ENEMY_2000, "DD_vox_ene", "EVD100")
		TppDataUtility.CreateEffectFromGroupId("effect_blood_2F")

		this.PlaySfx3D(SFX_2F_STEP_DEAD)

		GkEventTimerManager.Start("Timer_DeadEvent2F", TIME_EVENT_2F_DEAD)
		GkEventTimerManager.Start("Timer_DeadEvent2FSFX", TIME_EVENT_2F_DEAD - 0.6)
	end
end

this.RoutPointAction = function(objectId, routeId, routeNode, message)
	Fox.Log("RoutePoint2 function")
	Fox.Log(objectId)

	if message == Fox.StrCode32(MESSAGE_ROUTE.EVENT1040) then
		Fox.Log("1F4 soldier arrived 2F1")
		svars.isDoEvent00 = 3
		s10240_enemy02.IdleEvent2F1()
	end
end

this.SetGimmickDoorForDemo = function()
	Fox.Log("set gimmick door")
	if TppSequence.GetCurrentSequenceIndex() > TppSequence.GetSequenceIndex("Seq_Demo_Roof") then
		Fox.Log("door unlock")
		Gimmick.SetEventDoorLock(DOOR_ROOF, GIMMICK_PATH, false, 0)
		Gimmick.SetEventDoorInvisible(DOOR_ROOF, GIMMICK_PATH, false)
	else
		Fox.Log("door lock")
		Gimmick.SetEventDoorLock(DOOR_ROOF, GIMMICK_PATH, true, 0)
	end
	Gimmick.SetEventDoorLock(DOOR_ENTER, GIMMICK_PATH, true, 0)
end

this.StopSongEvent = function()
	TppSoundDaemon.PostEvent("stop_sfx_e_dd_radio")
	TppSoundDaemon.PostEvent("stop_vox_dd_hum_01")
	TppSoundDaemon.PostEvent("stop_vox_dd_hum_02")
	TppSoundDaemon.PostEvent("stop_vox_dd_hum_03")
	TppSoundDaemon.PostEvent("stop_vox_dd_hum_04")
	TppSoundDaemon.PostEvent("stop_vox_dd_hum_05")
end

this.StopSong = function(gameObjectId)
	if gameObjectId == GameObject.GetGameObjectId(ENEMY_1000) then
		TppSoundDaemon.PostEvent("stop_vox_dd_hum_02")
	elseif gameObjectId == GameObject.GetGameObjectId(ENEMY_1001) then
		TppSoundDaemon.PostEvent("stop_vox_dd_hum_03")
	elseif gameObjectId == GameObject.GetGameObjectId(ENEMY_1002) then
		TppSoundDaemon.PostEvent("stop_vox_dd_hum_01")
	elseif gameObjectId == GameObject.GetGameObjectId(ENEMY_1003) then
		TppSoundDaemon.PostEvent("stop_vox_dd_hum_04")
	elseif gameObjectId == GameObject.GetGameObjectId(ENEMY_1004) then
		TppSoundDaemon.PostEvent("stop_vox_dd_hum_05")
	else
		Fox.Log("not match song enemy")
	end
end

this._GimmickInvisible = function(name, type, enable)
	local set = true
	if enable == true then
		set = false
	end
	Gimmick.InvisibleGimmick(type, name, GIMMICK_PATH, set)
end

this.SetHideRadio = function(enable)
	local type = TppGameObject.GAME_OBJECT_TYPE_RADIO_CASSETTE
	local name = "afgh_radi001_csst001_gim_n0000|srt_afgh_radi001_csst001"

	this._GimmickInvisible(name, type, enable)
end

this.SetHideFann = function(enable)
	local name = "cypr_fann001_vrtn001_gim_n0000|srt_cypr_fann001_vrtn001"
	local type = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION

	this._GimmickInvisible(name, type, enable)
end

this.ChangeMotionForEvent = function(characterId, commandId)
	Fox.Log("change motion for event")

	if characterId == GameObject.GetGameObjectId(ENEMY_2100) then
		if svars.numEvent2F3 <= this.event2F3Enum.CAN_DEAD then
			svars.numEvent2F3 = this.event2F3Enum.IDLE
			s10240_enemy02.IdletEvent2F3()
		elseif svars.numEvent2F3 == this.event2F3Enum.IDLE then
			svars.numEvent2F3 = this.event2F3Enum.AORI
			s10240_enemy02.AoriEvent2F3()
			GkEventTimerManager.Start("Timer_Talk2F3_03", 2)
			GkEventTimerManager.Start("Timer_Talk2F3_04", 7)
		elseif svars.numEvent2F3 == this.event2F3Enum.AORI then
			svars.numEvent2F3 = this.event2F3Enum.SELF
			s10240_enemy02.SelfiEvent2F3()
			svars.deadCase10Num = TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE
			GkEventTimerManager.Start("Timer_Talk2F3_05", 5)
			GkEventTimerManager.Start("Timer_Blood2F3", 7.5)
		end
	elseif
		characterId == GameObject.GetGameObjectId(ENEMY_2200)
		or characterId == GameObject.GetGameObjectId(ENEMY_2210)
	then
		if commandId == Fox.StrCode32("2roukaFire") then
			svars.isDoEvent2rouka = true
			s10240_enemy02.ForObieEvent2rouka()
		else
			s10240_enemy02.IdleObieEvent2rouka()
		end
	elseif
		characterId == GameObject.GetGameObjectId(ENEMY_0000)
		or characterId == GameObject.GetGameObjectId(ENEMY_0001)
		or characterId == GameObject.GetGameObjectId(ENEMY_0002)
	then
		s10240_enemy02.IdleEventB1Room()
	elseif characterId == GameObject.GetGameObjectId(ENEMY_1000) then
		s10240_enemy02.SongEventB1Room(ENEMY_1000)
	elseif characterId == GameObject.GetGameObjectId(ENEMY_1001) then
		s10240_enemy02.SongEventB1Room(ENEMY_1001)
	elseif characterId == GameObject.GetGameObjectId(ENEMY_1002) then
		s10240_enemy02.SongEventB1Room(ENEMY_1002)
	elseif characterId == GameObject.GetGameObjectId(ENEMY_1003) then
		s10240_enemy02.SongEventB1Room(ENEMY_1003)
	elseif characterId == GameObject.GetGameObjectId(ENEMY_1004) then
		s10240_enemy02.SongEventB1Room(ENEMY_1004)
	elseif characterId == GameObject.GetGameObjectId(ENEMY_1200) then
		if svars.numDoEventLast < 2 then
			if commandId == Fox.StrCode32("LastManWakeUp") then
				s10240_enemy02.SetWakeMotionLastMan2()
			else
				s10240_enemy02.SetIdleMotionLastMan()
			end
		end
	end
end

this.ChangeMotionForDie = function(gameObjectId)
	Fox.Log("change motion for die")

	if gameObjectId == nil then
		Fox.Warning("gameObjectId is nil")
		return
	end

	if gameObjectId == GameObject.GetGameObjectId(ENEMY_2100) then
		svars.numEvent2F3 = this.event2F3Enum.DEAD
		Fox.Log("2f3 is dead")
	elseif gameObjectId == GameObject.GetGameObjectId(ENEMY_2200) then
		this.StopTimer("Timer_ShootPlayer")
		GkEventTimerManager.Start("Timer_ShootPlayer", 2)
		GkEventTimerManager.Start("Timer_ShootSay2210", 7)
		s10240_enemy02.CallVoice(ENEMY_2210, EnemyVoiceParam, "DDD207")
	elseif gameObjectId == GameObject.GetGameObjectId(ENEMY_2210) then
		this.StopTimer("Timer_ShootPlayer")
		GkEventTimerManager.Start("Timer_ShootPlayer", 2)
		GkEventTimerManager.Start("Timer_ShootSay2200", 7)
		s10240_enemy02.CallVoice(ENEMY_2200, EnemyVoiceParam, "DDD207")
	elseif gameObjectId == GameObject.GetGameObjectId(ENEMY_1200) then
		if TppSequence.GetCurrentSequenceIndex() == TppSequence.GetSequenceIndex("Seq_Game_MainGame") then
			s10240_enemy02.DeadEvent2F4()
		elseif svars.numDoEventLast == 1 then
			svars.numDoEventLast = 2

			s10240_radio.SorryBoss()
			if svars.isAllClear == false then
				s10240_radio.ORadioSet04()
			end
			s10240_enemy02.SetNodoLastMan(false)
			s10240_enemy02.SetDeadMotionLastMan()
		end
	elseif
		gameObjectId == GameObject.GetGameObjectId(ENEMY_1000)
		or gameObjectId == GameObject.GetGameObjectId(ENEMY_1001)
		or gameObjectId == GameObject.GetGameObjectId(ENEMY_1002)
		or gameObjectId == GameObject.GetGameObjectId(ENEMY_1003)
		or gameObjectId == GameObject.GetGameObjectId(ENEMY_1004)
	then
		s10240_enemy02.SetDeadMotionSong(gameObjectId)
	else
		s10240_enemy02.SetDeadMotionHanyou(gameObjectId)
	end
end

this.SetObieFlag = function(num)
	if num == 1 then
		svars.isObieLoop01 = true
	elseif num == 2 then
		svars.isObieLoop02 = true
	elseif num == 3 then
		svars.isObieLoop03 = true
	elseif num == 4 then
		svars.isObieLoop04 = true
	elseif num == 5 then
		svars.isObieLoop05 = true
	elseif num == 6 then
		svars.isObieLoop06 = true
	elseif num == 7 then
		svars.isObieLoop07 = true
	elseif num == 8 then
		svars.isObieLoop08 = true
	elseif num == 9 then
		svars.isObieLoop09 = true
	elseif num == 10 then
		svars.isObieLoop10 = true
	elseif num == 11 then
		svars.isObieLoop11 = true
	elseif num == 12 then
		svars.isObieLoop12 = true
	end
end

this.ResetObieFlag = function()
	svars.isObieLoop01 = false
	svars.isObieLoop02 = false
	svars.isObieLoop03 = false
	svars.isObieLoop04 = false
	svars.isObieLoop05 = false
	svars.isObieLoop06 = false
	svars.isObieLoop07 = false
	svars.isObieLoop08 = false
	svars.isObieLoop09 = false
	svars.isObieLoop10 = false
	svars.isObieLoop11 = false
	svars.isObieLoop12 = false
end

this.CheckObieFlag = function(num)
	if num == 1 and svars.isObieLoop01 == true then
		return true
	elseif num == 2 and svars.isObieLoop02 == true then
		return true
	elseif num == 3 and svars.isObieLoop03 == true then
		return true
	elseif num == 4 and svars.isObieLoop04 == true then
		return true
	elseif num == 5 and svars.isObieLoop05 == true then
		return true
	elseif num == 6 and svars.isObieLoop06 == true then
		return true
	elseif num == 7 and svars.isObieLoop07 == true then
		return true
	elseif num == 8 and svars.isObieLoop08 == true then
		return true
	elseif num == 9 and svars.isObieLoop09 == true then
		return true
	elseif num == 10 and svars.isObieLoop10 == true then
		return true
	elseif num == 11 and svars.isObieLoop11 == true then
		return true
	elseif num == 12 and svars.isObieLoop12 == true then
		return true
	end

	return false
end

this.ResetBlackOut = function()
	Fox.Log("not black out")
	for i, key in pairs(LIGHT_TABLE) do
		TppDataUtility.SetEnableDataFromIdentifier(IDEN_LIGHT_EM_ID, key, true, true)
	end

	Gimmick.PowerCutOff(TEIDEN_DATA)
	Gimmick.EnableAlarmLampAll(false)
end

this.BlackOut = function(flag)
	Fox.Log("black out")

	if svars.numBlackOut >= 2 then
		return
	else
		svars.numBlackOut = 2
	end

	Gimmick.PowerCutOn(TEIDEN_DATA)
	Gimmick.EnableAlarmLampAll(true)

	for i, key in pairs(LIGHT_TABLE) do
		TppDataUtility.SetEnableDataFromIdentifier(IDEN_LIGHT_EM_ID, key, false, true)
	end
end

this.ChangeIsolate = function(name, table)
	Fox.Log("ChangeIsolate")
	local checkTable = LIGHT_EM_TABLE
	if Tpp.IsTypeTable(table) == true then
		checkTable = table
	end

	for i, key in pairs(checkTable) do
		if key == name then
			Fox.Log("on : " .. key)
			TppDataUtility.SetEnableDataFromIdentifier(IDEN_LIGHT_EM_ID, key, true, true)
		else
			Fox.Log("off : " .. key)
			TppDataUtility.SetEnableDataFromIdentifier(IDEN_LIGHT_EM_ID, key, false, true)
		end
	end
end

this.ChangeIsolateTop = function(key)
	if svars.numBlackOut < 1 then
		this.ChangeIsolate(key, LIGHT_TABLE)
	end
end

this.ChangeEffetsSequence = function()
	Fox.Log("change effets sequence")
	if TppSequence.GetCurrentSequenceIndex() > TppSequence.GetSequenceIndex("Seq_Demo_Roof") then
		TppDataUtility.CreateEffectFromGroupId("effect_fire", true)
		TppDataUtility.SetVisibleEffectFromGroupId("effect_fire", true)
	else
		TppDataUtility.SetVisibleEffectFromGroupId("effect_fire", false)
	end
end

this.DeadCaseSetting = function()
	Fox.Log("DeadCaseSetting")

	local maleStaffIds, femaleStaffIds
	if TppStory.GetCurrentStorySequence() < TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then
		Fox.Log("Set tstaffIds. because first play")
		maleStaffIds, femaleStaffIds = TppMotherBaseManagement.GetStaffsS10240()
	else
		Fox.Log("not set dead case. because not first play")
		return
	end

	Fox.Log("DeadCaseSetting: Move to die list")
	TppMotherBaseManagement.RemoveStaffsS10240()

	Fox.Log("DeadCaseSetting: Set dead case")
	local index = 1
	index = this.SetDeadCase(femaleStaffIds, index)
	index = this.SetDeadCase(maleStaffIds, index)
end
this.CheckReason = function(enemyName)
	local flag = TppMotherBaseManagementConst.REMOVER_REASON_GUNDOWN
	local getFlag

	if enemyName == "sol_mbqf_0005" then
		getFlag = svars.deadCase05Num
	elseif enemyName == "sol_mbqf_0006" then
		getFlag = svars.deadCase06Num
	elseif enemyName == "sol_mbqf_0007" then
		getFlag = svars.deadCase07Num
	elseif enemyName == "sol_mbqf_0010" then
		getFlag = svars.deadCase10Num
	elseif enemyName == "sol_mbqf_0019" then
		getFlag = svars.deadCase19Num
	end

	if getFlag == nil then
		return flag
	else
		return getFlag
	end
end
this.SetDeadCase = function(staffIdList, index)
	for i, staffId in ipairs(staffIdList) do
		local reason = DEAD_CASE_TABLE[index]
		index = index + 1

		if reason == nil then
			Fox.Log("reason is nil. end")
		elseif Tpp.IsTypeString(reason) then
			reason = this.CheckReason(reason)
			Fox.Log("check other case. " .. tostring(reason))
		else
			Fox.Log("set case direct. " .. tostring(reason))
		end

		if
			(reason == TppMotherBaseManagementConst.REMOVER_REASON_BURN)
			or (reason == TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE)
		then
			Fox.Log("Set special case")
			TppMotherBaseManagement.SetRemoverReason({ staffId = staffId, reason = reason })
		end
	end

	return index
end

sequences.Seq_Demo_Opening = {
	Messages = function(self)
		return StrCode32Table({
			Demo = {
				{
					msg = "Play",
					func = function()
						GameObject.SendCommand(
							{ type = "TppHeli2", index = 0 },
							{ id = "SetDemoToSendEnabled", enabled = true, route = "rt_drp_mbqf_N" }
						)
					end,
					option = { isExecDemoPlaying = true },
				},
				nil,
			},
			UI = {
				{
					msg = "StartMissionTelopFadeOut",
					func = self.PlayOpeningDemo,
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_MissionTelop",
					func = function()
						Fox.Log("opening demo: start telop")
						TppUI.StartMissionTelop(missionCode)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_GoToSequence",
					func = function()
						Fox.Log("go to next sequence")
						TppSequence.SetNextSequence("Seq_Game_GoToInQuarantineFacility")
					end,
				},
			},
			nil,
		})
	end,
	PlayOpeningDemo = function()
		local func = function()
			Fox.Log("opening demo: change next sequence")
			Player.RequestToPlayHeliCameraAnimation()
			GkEventTimerManager.Start("Timer_GoToSequence", 1.0)
		end

		Fox.Log("opening demo: play opening ")
		s10240_demo.PlayOpeningDemo(func)
	end,
	OnEnter = function()
		TppPlayer.Refresh()
		TppScriptBlock.LoadDemoBlock("Demo_Opening")
		Fox.Log("opening demo: start timer")
		GkEventTimerManager.Start("Timer_MissionTelop", 2)
	end,

	OnLeave = function()
		TppMission.EnableInGameFlag()
		TppUI.OverrideFadeInGameStatus({

			EquipPanel = false,
		})
		TppUiStatusManager.SetStatus("EquipPanel", "INVALID")
		TppUI.FadeIn(TppUI.FADE_SPEED.FADE_LOWSPEED)
	end,
}

sequences.Seq_Game_GoToInQuarantineFacility = {

	Messages = function(self)
		return StrCode32Table({
			Player = {
				{
					msg = "LandingFromHeli",
					func = function()
						TppSoundDaemon.ResetMute("HeliDucking")
						TppMission.UpdateCheckPointAtCurrentPosition()
						TppMission.UpdateObjective({
							radio = { radioGroups = "s0240_rtrg0030" },
							objectives = { "marker_mbqf_enter" },
							options = { isMissionStart = true },
						})
					end,
				},
				{
					msg = "OnPlayerHeliHatchOpen",
					func = function()
						TppUiStatusManager.ClearStatus("EquipPanel")
					end,
				},
			},
			GameObject = {
				{
					msg = "Dead",
					func = function(gameObjectId)
						if not Tpp.IsPlayer(gameObjectId) then
							TppMission.ReserveGameOver(
								TppDefine.GAME_OVER_TYPE.TARGET_DEAD,
								TppDefine.GAME_OVER_RADIO.PLAYER_KILL_DD
							)
						end
					end,
				},
			},
			Radio = {
				{
					msg = "Finish",
					sender = "s0240_rtrg5000",
					func = function()
						TppSoundDaemon.ResetMute("HeliDucking")
					end,
				},
			},
			Trap = {

				{
					msg = "Enter",
					sender = "trap_Entrance",
					func = function()
						TppMission.UpdateObjective({
							objectives = { "default_photo_in_mbqf" },
						})

						TppSequence.SetNextSequence("Seq_Demo_GoToDoor")
					end,
				},
				{
					msg = "Enter",
					sender = "trap_FlyingBird",
					func = function()
						s10240_enemy.FlyingBird()
					end,
				},
				{
					msg = "Enter",
					sender = "trap_changeRoute",
					func = function()
						s10240_enemy.ChangeRouteEnemy()
						TppSoundDaemon.ResetMute("HeliDucking")

						s10240_sound.StopBGM00()
					end,
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_StartObjectiveTelop",
					func = function()
						TppTelop.StartMissionObjective()
					end,
				},
			},
			nil,
		})
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept(true)
			Dynamite.StartNearestEnemyThread()
			TppCoder.SetWorldCenter(Vector3(-171.80687, 9.861679, -2062.7605))
		end

		TppScriptBlock.LoadDemoBlock("Demo_GoToInside")
		this.SetDisableActionFlag()

		TppMission.UpdateObjective({
			objectives = { "default_photo_mbqf", "default_missionTask_00", "default_missionTask_01" },
		})

		if TppSequence.GetContinueCount() == 0 then
			GkEventTimerManager.Start("Timer_StartObjectiveTelop", 9)
			s10240_radio.HeliStartEndDemo()
			TppSoundDaemon.SetMute("HeliDucking")
		else
			TppMission.UpdateObjective({
				radio = { radioGroups = "s0240_rtrg0030" },
				objectives = { "marker_mbqf_enter" },
				options = { isMissionStart = true },
			})
		end
		this.SetMbDvcMenu(false)
		TppUiStatusManager.SetStatus("EquipHudAll", "ALL_KILL_NOUSE")
		TppUiStatusManager.SetStatus("AnnounceLog", "INVALID_LOG_EXCEPT")
		TppUiCommand.SetMisionInfoCurrentStoryNo(0)

		s10240_enemy.EnableBird()
		s10240_enemy.WarpBird()
		s10240_sound.StartBGM00()
		s10240_radio.ORadioSet01()
		this.SetWeaponStatus()
		this.StopGimmickCrane()

		local heliObjectId
		heliObjectId = GameObject.GetGameObjectId("WestHeli0000")
		GameObject.SendCommand(heliObjectId, { id = "SetForceRoute", route = "rts_heli_mbqf_0000" })
		GameObject.SendCommand(heliObjectId, { id = "SetEnabled", enabled = true })

		heliObjectId = GameObject.GetGameObjectId("WestHeli0001")
		GameObject.SendCommand(heliObjectId, { id = "SetForceRoute", route = "rts_heli_mbqf_0001" })
		GameObject.SendCommand(heliObjectId, { id = "SetEnabled", enabled = true })

		local IDEN_PATH_ID = "uq07_path_Identifier"
		local IDEN_PATH_KEY = {
			"pathElude_0007_before",
			"pathBehind_0016_before",
		}
		for i, key in pairs(IDEN_PATH_KEY) do
			TppDataUtility.SetEnableDataFromIdentifier(IDEN_PATH_ID, key, false, true)
		end
	end,

	OnLeave = function()
		TppUiStatusManager.UnsetStatus("EquipHudAll", "ALL_KILL_NOUSE")
	end,
}

sequences.Seq_Demo_GoToDoor = {
	Messages = function(self)
		StrCode32Table({
			Demo = {
				{
					msg = "Play",
					func = function()
						s10240_enemy.EnableBird()
					end,
					option = { isExecDemoPlaying = true },
				},
				nil,
			},
			nil,
		})
	end,
	OnEnter = function()
		if DEBUG and svars.isDebug == 10 then
			s10240_demo.PlayGoToInside()
			return
		end
		TppUiCommand.RemovedAllUserMarker()
		vars.playerDisableActionFlag = PlayerDisableAction.NONE
		local endFunc = function()
			Fox.Log("Go to next sequense")
			local typeName = "TppCritterBird"
			local command = {
				id = "SetIgnoreDisableNpc",
				enabled = false,
			}
			GameObject.SendCommand({ type = typeName, index = 0 }, command)
			GameObject.SendCommand({ type = typeName, index = 1 }, command)

			local heliObjectId
			heliObjectId = GameObject.GetGameObjectId("WestHeli0000")
			GameObject.SendCommand(heliObjectId, { id = "SetEnabled", enabled = false })

			heliObjectId = GameObject.GetGameObjectId("WestHeli0001")
			GameObject.SendCommand(heliObjectId, { id = "SetEnabled", enabled = false })

			TppSequence.ReserveNextSequence("Seq_Demo_InMbqf")
			TppMission.Reload({
				missionPackLabelName = "InQuarantineFacility",
				locationCode = TppDefine.LOCATION_ID.MBQF,
				showLoadingTips = false,
				OnEndFadeOut = function()
					vars.currentInventorySlot = TppDefine.WEAPONSLOT.SECONDARY
					TppPlayer.ResetInitialPosition()
					TppMission.UpdateCheckPoint("CHK_enter")
				end,
			})
		end

		local typeName = "TppCritterBird"
		local command = {
			id = "SetIgnoreDisableNpc",
			enabled = true,
		}
		GameObject.SendCommand({ type = typeName, index = 0 }, command)
		GameObject.SendCommand({ type = typeName, index = 1 }, command)

		s10240_demo.PlayGoToInside(endFunc)
	end,
}

sequences.Seq_Demo_InMbqf = {

	OnEnter = function()
		local endFunc = function()
			Fox.Log("end demo")
			TppSequence.SetNextSequence("Seq_Game_MainGame")
		end
		s10240_demo.PlayEnterInMbqf(endFunc)
	end,
	OnLeave = function()
		TppMission.UpdateCheckPoint("CHK_enter")
	end,
}

sequences.Seq_Game_MainGame = {

	Messages = function(self)
		return StrCode32Table({
			Player = {
				{
					msg = "StartEventDoorPicking",
					func = function()
						Fox.Log("Event door Open!!")
						s10240_sound.StopBGM01()
						s10240_enemy02.EndShoot3F2()

						GkEventTimerManager.Start("Timer_NextSequence", TIMER_TO_DEMO)
					end,
				},

				{
					msg = "EndCallVioce2",
					func = function()
						s10240_radio.StartInMBQF2()
					end,
				},
			},
			Radio = {
				{
					msg = "Finish",
					sender = "s0240_rtrg0032",
					func = function()
						GkEventTimerManager.Start("Timer_RadioStart02", 1)
					end,
				},
				{
					msg = "Finish",
					sender = "s0240_rtrg0034",
					func = function()
						GkEventTimerManager.Start("Timer_RadioStart03", 1)
					end,
				},
			},
			GameObject = {
				{
					msg = "Dead",
					func = function(characterId, attackId)
						Fox.Log("enemy dead " .. characterId .. ":" .. attackId)
						this.ChangeMotionForEvent(characterId)
						this.ChangeMotionForDie(characterId)

						if characterId == GameObject.GetGameObjectId(ENEMY_1040) then
							this.ReSetPadMaskWalk()
							this.SetDisableActionFlag()
							this.ResetPadMaskMove()
							TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, IDEN_BLOOD.ROOM2F1, true)
						end

						if characterId == GameObject.GetGameObjectId(ENEMY_1200) then
							svars.isDead24 = true
						end

						if
							characterId == GameObject.GetGameObjectId(ENEMY_1040)
							or characterId == GameObject.GetGameObjectId(ENEMY_2000)
							or characterId == GameObject.GetGameObjectId(ENEMY_3000)
						then
							if Tpp.IsPlayer(attackId) then
								Fox.Log("player kill")
								TppMission.ReserveGameOver(
									TppDefine.GAME_OVER_TYPE.S10240_STAFF_DEAD,
									TppDefine.GAME_OVER_RADIO.S10240_STAFF_DEAD
								)
							else
								Fox.Log("not player kill")
							end
						else
							Fox.Log("game over")
							TppMission.ReserveGameOver(
								TppDefine.GAME_OVER_TYPE.S10240_STAFF_DEAD,
								TppDefine.GAME_OVER_RADIO.S10240_STAFF_DEAD
							)
						end
					end,
				},
				{
					msg = "Damage",
					func = function(characterId, attackId, attakerId)
						Fox.Log("damege " .. characterId .. ":" .. attackId .. ":" .. attakerId)
						if Tpp.IsPlayer(attakerId) and TppDamage.IsActiveByAttackId(attackId) then
							Fox.Log("player killed")
							svars.numKillEnemy = svars.numKillEnemy + 1
							s10240_radio.DeadSoldier(svars.numKillEnemy)

							if TppEnemy.GetLifeStatus(characterId) == TppEnemy.LIFE_STATUS.DEAD then
								Fox.Log("and enemy dead")
								TppMission.ReserveGameOver(
									TppDefine.GAME_OVER_TYPE.S10240_STAFF_DEAD,
									TppDefine.GAME_OVER_RADIO.S10240_STAFF_DEAD
								)
							end
						elseif Tpp.IsPlayer(attakerId) then
							if
								attackId == TppDamage.ATK_10101
								or attackId == TppDamage.ATK_10102
								or attackId == TppDamage.ATK_10105
								or attackId == TppDamage.ATK_10107
								or attackId == TppDamage.ATK_10117
								or attackId == TppDamage.ATK_10214
								or attackId == TppDamage.ATK_10216
								or attackId == TppDamage.ATK_10637
								or attackId == TppDamage.ATK_10117
								or attackId == TppDamage.ATK_60013
								or attackId == TppDamage.ATK_60114
								or attackId == TppDamage.ATK_60325
								or attackId == TppDamage.ATK_Quiet_sr_020
								or attackId == TppDamage.ATK_50047
								or attackId == TppDamage.ATK_50147
								or attackId == TppDamage.ATK_50237
							then
								s10240_radio.NotMasui()
							end
						end

						if attackId == TppDamage.ATK_Push and characterId == GameObject.GetGameObjectId(ENEMY_1040) then
							Fox.Log("push 2f1")
							this.StopTimer("Timer_Talk2F_10")
							this.StopTimer("Timer_Talk2F_102")
							this.StopTimer("Timer_Talk2F_103")
							GkEventTimerManager.Start("Timer_Talk2F_103", 1)
							s10240_enemy02.PushEvent2F1()
							svars.deadCase19Num = TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE
						end
					end,
				},
				{
					msg = "AimedFromPlayer",
					func = function(gameObjectId, isFound)
						if gameObjectId == GameObject.GetGameObjectId(ENEMY_5008) then
							return
						end
						this.AimEnemy(gameObjectId, isFound)
					end,
				},
				{
					msg = "RoutePoint2",
					func = function(objectId, routeId, routeNode, message)
						Fox.Log("get message RoutePoint2 : " .. message)
						this.RoutPointAction(objectId, routeId, routeNode, message)
					end,
				},
				{
					msg = "SpecialActionEnd",
					func = function(characterId, actionId, commandId)
						Fox.Log("SpecialActionEnd")

						if commandId == Fox.StrCode32("ObieLoop") then
							s10240_enemy02.SetObieLoopMotion(characterId)
						elseif commandId == Fox.StrCode32("E2F_Turn_End") then
							s10240_enemy02.IdleEvent2F1B()
						elseif commandId == Fox.StrCode32("E2F_HandGun_End") then
							s10240_enemy02.IdleEvent2F1HandGun()
						end
					end,
				},
			},
			Trap = {
				{
					msg = "Enter",
					sender = "trap_exit",
					func = function()
						s10240_radio.DontOut()
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_story0000",
					func = function()
						if svars.isDoEvent01 == false then
							svars.isDoEvent01 = true

							Player.RequestToSetTargetStance(PlayerStance.STAND)

							Player.RequestToMoveToPosition({
								name = "name",
								position = Vector3(1.738, 0.000, 20.002),
								direction = 180,
								moveType = PlayerMoveType.WALK,
								timeout = 7,
							})

							Player.RequestToSetCameraRotation(CAMERA_1F_ROUKA)
							GkEventTimerManager.Start("Timer_EventFirstInpresion", 1.5)
							GkEventTimerManager.Start("Timer_EventFirstInpresionSound", 1.5)
							s10240_radio.Event1FRouka()
						end
					end,
				},
				{
					msg = "Exit",
					sender = "trap_camera_reset",
					func = function()
						this.SetCameraDistance(false)
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_story0001",
					func = function()
						if svars.isTalk01 == false then
							svars.isTalk01 = true
							this.StartDisableRunForEvent()
							TppSoundDaemon.PostEvent(SFX_RADIO_NOISE1)
							s10240_radio.StoryRadioNoise1()
							GkEventTimerManager.Start("Timer_Talk1F_01", 8)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event2001",
					func = function()
						if svars.isTalk10 == false then
							svars.isTalk10 = true
							this.PlaySfx3D(SFX_2F_GERO)
						end
					end,
				},

				{
					msg = "Enter",
					sender = "trap_talk_0000",
					func = function()
						if svars.isTalk02 == false then
							svars.isTalk02 = true
							GkEventTimerManager.Start("Timer_Talk2F_01", 1)
							GkEventTimerManager.Start("Timer_Talk2F_012", 3)
							this.PlaySfx3D(SFX_2F_GERO)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_talk_0001",
					func = function()
						if svars.isTalk03 == false then
							svars.isTalk03 = true
							GkEventTimerManager.Start("Timer_Talk2F_02", 1)
						end
					end,
				},

				{
					msg = "Enter",
					sender = "trap_radio_story0002",
					func = function()
						if svars.isTalk09 == false then
							svars.isTalk09 = true
							s10240_radio.StoryRadioNoise2()
							TppSoundDaemon.PostEvent(SFX_RADIO_NOISE2)
							this.StartDisableRunForEvent()
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_story0003",
					func = function()
						s10240_radio.StoryRadioNoise3()
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_game0001",
					func = function()
						s10240_radio.DontOpenDoor1()
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_game0002",
					func = function()
						s10240_radio.DontOpenDoor3()
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_game0003",
					func = function()
						s10240_radio.DontOpenDoor2()
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event1002",
					func = function()
						if svars.isDoEvent00 < 1 then
							svars.isDoEvent00 = 1

							this.PlaySfx3D(SFX_1F_ROUKA)
							GkEventTimerManager.Start("Timer_Event1GunFire1", 0.2)
							GkEventTimerManager.Start("Timer_Event1GunFire2", 0.8)
							GkEventTimerManager.Start("Timer_Event1GunFire25", 1.5)
							GkEventTimerManager.Start("Timer_Event1GunFire3", 2.2)
							GkEventTimerManager.Start("Timer_Event1GunFire4", 2.3)
							TppDataUtility.CreateEffectFromId("gun_fire")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event1000",
					func = function()
						if svars.isDoEvent00 < 2 then
							svars.isDoEvent00 = 2
							Player.RequestToSetCameraRotation(CAMERA_1F_SOLDIER)
							s10240_sound.StartBGM01()
							this.SetCameraDistance(CAMERA_DSIT)
							s10240_enemy02.StartEvent1F4(ENEMY_1040)
							s10240_enemy02.AddEnemyRoute(ENEMY_1040, ROUTE_1F4_TO_2F1, 0)
							GkEventTimerManager.Start("Timer_Talk1F_00", 0.5)
							GkEventTimerManager.Start("Timer_MoveBox1", 0.5)

							this.StartDisableActionForEvent()
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event1040",
					func = function()
						s10240_radio.Event1F4Room()
						TppDataUtility.CreateEffectFromId("effect_blood_1F4")
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event3100",
					func = function()
						TppDataUtility.CreateEffectFromId("effect_blood_1F4")
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_story0110",
					func = function()
						TppDataUtility.CreateEffectFromId("effect_blood_3F10")
					end,
				},

				{
					msg = "Enter",
					sender = "trap_radio_event2000",
					func = function()
						if svars.isDoEvent20 == false then
							svars.isDoEvent20 = true
							s10240_enemy02.ChangeRoute(ROUTE_2F_STEP_STAY, ROUTE_2F_STEP_WALK, 0)
							s10240_sound.SwitchBGM02()
							s10240_enemy02.CallVoice(ENEMY_2000, EnemyVoiceParam, "DDD170")

							GkEventTimerManager.Start("Timer_Event2Start", TIME_EVENT_2F_START)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event2020",
					func = function()
						if svars.isDoEvent12 == false then
							svars.isDoEvent12 = true
							this.PlaySfx3D(SFX_3F_DOWN)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_camera_2F0000",
					func = function()
						if svars.isTalk18 == false and svars.isDoEvent24 == false then
							svars.isTalk18 = true
							this.StartDisableActionForEvent({ addTime = -1 })
							s10240_enemy02.CallVoice(ENEMY_1200, EnemyVoiceParam, "DDD_EV008")
							Player.RequestToSetCameraRotation(CAMERA_2F42)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_camera_2F",
					func = function()
						if svars.isTalk18 == false and svars.isDoEvent24 == false then
							this.StartDisableActionForEvent({ addTime = -1 })

							GkEventTimerManager.Start("Timer_Talk2F_03", 0.5)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event2040",
					func = function()
						if svars.isDoEvent24 == false then
							svars.isDoEvent24 = true
							s10240_enemy02.SetUpEvent2F4()
							this.StartDisableActionForEvent({ addTime = 2 })
							s10240_enemy02.AddEnemyRoute(ENEMY_1200, ROUTE_2F4_START, 0)
							GkEventTimerManager.Start("Timer_Talk2F_04", 2)
							this.StartConstCamera(CAM_DATA_2F4)
						else
							s10240_enemy02.AddEnemyRoute(ENEMY_1200, ROUTE_2F4_IDLE, 0)
						end
					end,
				},
				{
					msg = "Exit",
					sender = "trap_radio_event2040",
					func = function()
						if svars.isHoken03 == false then
							svars.isHoken03 = true
							s10240_enemy02.CallVoice(ENEMY_1200, EnemyVoiceParam, "DDD_EV017")
							this.StopTimer("Timer_Talk2F_05")
						end
						s10240_enemy02.AddEnemyRoute(ENEMY_1200, ROUTE_2F4_AIM, 0)
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event3000",
					func = function()
						if svars.isTalk04 == false then
							svars.isTalk04 = true
							GkEventTimerManager.Start("Timer_Talk3F_01", 1)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event30001",
					func = function()
						if svars.isTalk07 == false then
							svars.isTalk07 = true
							GkEventTimerManager.Start("Timer_Talk3F_02", 1)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event3030",
					func = function()
						local checkEnemyLife = TppEnemy.GetLifeStatus(ENEMY_1040)
						if svars.isDoEvent00 == 3 and checkEnemyLife == TppGameObject.NPC_LIFE_STATE_NORMAL then
							this.StartConstCamera(CAM_DATA_2F1)
							GkEventTimerManager.Start("Timer_Talk2F_10", 1)
							GkEventTimerManager.Start("Timer_Talk2F_102", 9)
							GkEventTimerManager.Start("Timer_Talk2F_103", 9 + 7)

							this.StartDisableActionForEvent({ addTime = 3, type = "CanFire" })

							Player.RequestToMoveToPosition({
								name = "name",
								position = Vector3(-4.449, 4.000, 22.739),
								direction = -90,
								moveType = PlayerMoveType.WALK,
								timeout = 4,
							})

							Player.RequestToSetCameraRotation(CAMERA_2F1)
							svars.isDoEvent00 = 4
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event3050",
					func = function()
						if svars.isDoEvent35 == false then
							svars.isDoEvent35 = true
							s10240_sound.SwitchBGM03()

							s10240_enemy02.CallVoice(ENEMY_5007, EnemyVoiceParam, "DDD_EV010")
							s10240_enemy02.StartShoot3F()
							GkEventTimerManager.Start("Timer_Event3GunFire1", 1.0)
							GkEventTimerManager.Start("Timer_Event3GunFire2", 1.15)
							GkEventTimerManager.Start("Timer_Event3GunFire3", 1.5)
							GkEventTimerManager.Start("Timer_Event3GunFire4", 2.4)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_talk_0006",
					func = function()
						if svars.isHoken05 == false then
							svars.isHoken05 = true
							s10240_enemy02.CallVoice(ENEMY_5007, EnemyVoiceParam, "DDD_EV030")
							s10240_enemy02.CallVoice(ENEMY_5008, EnemyVoiceParam, "DDD170")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_event_3F",
					func = function()
						if svars.isHoken07 == false then
							svars.isHoken07 = true
							GkEventTimerManager.Start("Timer_Event3Shoot", 1)
						end
					end,
				},

				{
					msg = "Enter",
					sender = "trap_sound_enter",
					func = function()
						TppSoundDaemon.PostEvent(SFX_ENTER)
					end,
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_DeadEvent2F",
					func = function()
						s10240_enemy02.DieEnemy(ENEMY_2000)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_DeadEvent2FSFX",
					func = function()
						this.PlaySfx3D(SFX_2F_STEP_DOWN)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event2Start",
					func = function()
						Player.RequestToSetCameraRotation(CAMERA_1F_STEP)

						this.StartDisableActionForEvent({ type = "CanFire" })
						this.SetCameraDistance(CAMERA_DSIT)
						GkEventTimerManager.Start("Timer_Event2FHoken", 1.5)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event2FHoken",
					func = function()
						this.Event2FStepDead()
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_EventFirstInpresion",
					func = function()
						this.StartConstCamera(CAM_DATA)
						this.StartDisableActionForEvent()
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_EventFirstInpresionSound",
					func = function()
						s10240_sound.StartOneShot()
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_Event1GunFire1",
					func = function()
						this.PlaySfx3D(SFX_1F_ROUKA)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event1GunFire2",
					func = function()
						this.PlaySfx3D(SFX_1F_ROUKA_HIT)
						s10240_enemy02.CallVoice(ENEMY_1040, "DD_vox_ene", "EVD040")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event1GunFire25",
					func = function()
						this.PlaySfx3D(SFX_1F_ROUKA_DROP)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event1GunFire3",
					func = function()
						this.PlaySfx3D(SFX_1F_ROUKA_DOWN)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event1GunFire4",
					func = function()
						TppHero.SetAndAnnounceHeroicOgrePoint(TppHero.DEAD_DD_SOLDIER, "mbstaff_died")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event3GunFire1",
					func = function()
						this.PlaySfx3D(SFX_3F_ROUKA)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event3GunFire2",
					func = function()
						this.PlaySfx3D(SFX_3F_ROUKA)
						TppDataUtility.CreateEffectFromId("effect_recoil3F")
						s10240_enemy02.CallVoice(ENEMY_5008, "DD_vox_ene", "EVD040")
						GkEventTimerManager.Start("Timer_Event3GunFire1", 0.3)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event3GunFire3",
					func = function()
						this.PlaySfx3D(SFX_3F_ROUKA_DOWN)
						this.PlaySfx3D(SFX_3F_ROUKA)
						GkEventTimerManager.Start("Timer_Event3GunFire1", 0.2)

						Player.RequestToSetCameraRotation(CAMERA_3F_ROUKA)
						this.StartDisableActionForEvent({ addTime = -1, addWalkTime = -1 })
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event3GunFire4",
					func = function()
						this.PlaySfx3D(SFX_3F_ROUKA)
						s10240_enemy02.CallVoice(ENEMY_5007, "DD_vox_ene", "EVD040")
						GkEventTimerManager.Start("Timer_Event3GunFire1", 0.3)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event3Shoot",
					func = function()
						s10240_enemy02.LastShoot3F()
						GkEventTimerManager.Start("Timer_Event3End", 1)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Event3End",
					func = function()
						s10240_enemy02.EndShoot3F()
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_Talk1F_00",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_1040, "DD_600")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_MoveBox1",
					func = function()
						Gimmick.PushGimmick(-1, GIMMICK_NAME_BOX1, GIMMICK_PATH, Vector3(0.5, 0.5, -10.8), 2)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_10",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_1040, "DD_610")
						s10240_enemy02.StartEvent2F1()
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_102",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_1040, "DD_614")
						s10240_enemy02.StartEvent2F1HandGun()
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_103",
					func = function()
						s10240_enemy02.DeadEvent2F1()
						svars.deadCase19Num = TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE
						GkEventTimerManager.Start("Timer_Blood2F1", 0.1)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Blood2F1",
					func = function()
						TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, IDEN_BLOOD.ROOM2F1, true)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk1F_01",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_5000, "DD_011")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_01",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_5001, "DD_072")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_012",
					func = function()
						s10240_enemy02.CallVoice(ENEMY_5002, EnemyVoiceParam, "DDD070")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_02",
					func = function()
						s10240_enemy02.CallVoice(ENEMY_5005, EnemyVoiceParam, "DDD_EV021")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_03",
					func = function()
						if svars.isTalk18 == false and svars.isDoEvent24 == false then
							svars.isTalk18 = true

							s10240_enemy02.CallVoice(ENEMY_1200, EnemyVoiceParam, "DDD_EV008")
							Player.RequestToSetCameraRotation(CAMERA_2F4)
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_04",
					func = function()
						s10240_enemy02.CallVoice(ENEMY_1200, EnemyVoiceParam, "DDD_EV009")
						s10240_radio.Event2F4()
						GkEventTimerManager.Start("Timer_Talk2F_05", 15)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_05",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_1200, "DD_624")
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_Talk3F_01",
					func = function() end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk3F_02",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_5008, "DD_012")
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_NextSequence",
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_Roof")
					end,
				},
			},
			nil,
		})
	end,

	OnEnter = function()
		this.CommonSetUpInMBQF()
		s10240_radio.ORadioSet02()
		Player.SetMaskBreathSoundLevel({ soundLevel = 1 })

		s10240_enemy02.AddEnemyRoute(ENEMY_3000, "rts_mbqf_3000", 0)

		this.SetWeaponStatus()

		vars.currentInventorySlot = TppDefine.WEAPONSLOT.SECONDARY

		if TppSequence.GetContinueCount() > 0 then
			s10240_radio.EnterFacility()
			Player.RequestToSetCameraRotation(CAMERA_START)
		else
		end

		s10240_enemy02.AddEnemyRoute(ENEMY_1040, ROUTE_1F4_STAY, 0)
		s10240_enemy02.AddEnemyRoute(ENEMY_2000, ROUTE_2F_STEP_STAY, 0)
		s10240_enemy02.AddEnemyRoute(ENEMY_1200, ROUTE_2F4_IDLE, 0)
		s10240_enemy02.DisableCorpseRoof()
		TppDataUtility.SetVisibleEffectFromGroupId("effect_water", false)
		TppMission.UpdateObjective({
			objectives = { "default_photo_in_mbqf" },
		})
		TppUiCommand.SetMisionInfoCurrentStoryNo(1)
		this.StopSongEvent()

		TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, IDEN_BLOOD.ROOM2F1, false)
		TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, IDEN_BLOOD.ROOM2F3, false)

		s10240_enemy02.SetZombie2F()
	end,

	OnLeave = function()
		TppMission.UpdateCheckPointAtCurrentPosition()
	end,
}

sequences.Seq_Demo_Roof = {

	Messages = function(self)
		return StrCode32Table({
			Demo = {

				{
					msg = "DM_door",
					sender = s10240_demo.demoList.Demo_Roof_Event,
					func = function()
						Fox.Log("demo message. DM_door")

						Gimmick.SetEventDoorInvisible(DOOR_ROOF, GIMMICK_PATH, true)

						TppDataUtility.SetVisibleDataFromIdentifier("mbqfAssetIdentifier", "roof_door_outside", false)
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "dds3_demo10_StandIdle",
					sender = s10240_demo.demoList.Demo_Roof_Event,
					func = function()
						s10240_enemy02.SetZombieMode("Reset")
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "DM_enemy",
					sender = s10240_demo.demoList.Demo_Roof_Event,
					func = function()
						Fox.Log("demo message. DM_enemy")

						s10240_enemy02.EnableCorpseRoof()
						s10240_enemy02.KillEnemyAfterDemo()
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			nil,
		})
	end,

	OnEnter = function()
		Player.RequestToSetTargetStance(PlayerStance.STAND)
		s10240_enemy02.EnableEnamyForDemo()
		s10240_enemy02.DisableCorpseRoof()
		s10240_enemy02.SetDemoRealize()
		this.ChangeEffetsSequence()

		s10240_enemy02.SetBloodFace()
		TppUiCommand.RemovedAllUserMarker()
		local func = function()
			s10240_enemy02.SetZombieMode("Reset")
			s10240_enemy02.EnableCorpseRoof()
			s10240_enemy02.KillEnemyAfterDemo()
			s10240_enemy02.SetDemoRealize(false)
			TppUiStatusManager.SetStatus("AnnounceLog", "INVALID_LOG_EXCEPT")
			TppSequence.SetNextSequence("Seq_Game_Battle_Roof")
		end

		local startFunc = function()
			Fox.Log("start demo")
		end
		s10240_demo.PlayRoofDemo(func, startFunc)
	end,

	OnLeave = function()
		TppDataUtility.SetVisibleDataFromIdentifier("mbqfAssetIdentifier", "roof_door_outside", true)
		vars.currentInventorySlot = TppDefine.WEAPONSLOT.SECONDARY
		TppMission.UpdateCheckPoint("CHK_startBattle")
	end,
}

sequences.Seq_Game_Battle_Roof = {

	Messages = function(self)
		return StrCode32Table({
			GameObject = {
				{
					msg = "Dead",
					func = self.CountEnemyDown,
				},
			},
			Trap = {
				{
					msg = "Enter",
					sender = "trap_radio_story0100",
					func = function()
						Fox.Log("enemy is die")

						if not (TppEnemy.GetLifeStatus(ENEMY_4000) == TppEnemy.LIFE_STATUS.DEAD) then
							Fox.Log("die " .. ENEMY_4000)
							GameObject.SendCommand(
								GameObject.GetGameObjectId(ENEMY_4000),
								{ id = "SetEnabled", enabled = false }
							)
							s10240_enemy02.AddEnemyRoute(ENEMY_4000, "rts_mbqf_4100", 0)
							GameObject.SendCommand(
								GameObject.GetGameObjectId(ENEMY_4000),
								{ id = "SetEnabled", enabled = true }
							)
						end

						if not (TppEnemy.GetLifeStatus(ENEMY_4001) == TppEnemy.LIFE_STATUS.DEAD) then
							Fox.Log("die " .. ENEMY_4001)
							GameObject.SendCommand(
								GameObject.GetGameObjectId(ENEMY_4001),
								{ id = "SetEnabled", enabled = false }
							)
							s10240_enemy02.AddEnemyRoute(ENEMY_4001, "rts_mbqf_4101", 0)
							GameObject.SendCommand(
								GameObject.GetGameObjectId(ENEMY_4001),
								{ id = "SetEnabled", enabled = true }
							)
						end

						if not (TppEnemy.GetLifeStatus(ENEMY_4002) == TppEnemy.LIFE_STATUS.DEAD) then
							Fox.Log("die " .. ENEMY_4002)
							GameObject.SendCommand(
								GameObject.GetGameObjectId(ENEMY_4002),
								{ id = "SetEnabled", enabled = false }
							)
							s10240_enemy02.AddEnemyRoute(ENEMY_4002, "rts_mbqf_4102", 0)
							GameObject.SendCommand(
								GameObject.GetGameObjectId(ENEMY_4002),
								{ id = "SetEnabled", enabled = true }
							)
						end

						TppSequence.SetNextSequence("Seq_Game_Slaughter")
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_game_1000",
					func = function()
						s10240_radio.DontGoOut()
					end,
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_ShootSneak",
					func = function()
						s10240_radio.ShootSneakAgain()
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_ZombieStart",
					func = function()
						s10240_enemy02.SetRouteForBattle()
						s10240_enemy02.AddEnemyRoute(ENEMY_4000, "rts_mbqf_4202", 0)
						s10240_enemy02.AddEnemyRoute(ENEMY_4001, "rts_mbqf_4200", 0)
						s10240_enemy02.AddEnemyRoute(ENEMY_4002, "rts_mbqf_4201", 0)
						GkEventTimerManager.Start("Timer_ZombieDown", 6)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_ZombieDown",
					func = function()
						s10240_enemy02.SetEverDownRoof()
					end,
				},
			},
			nil,
		})
	end,

	CountEnemyDown = function(arg1)
		Fox.Log("check dead enemy")
		local lifeState0 = GameObject.SendCommand(GameObject.GetGameObjectId(ENEMY_4000), { id = "GetLifeStatus" })
		local lifeState1 = GameObject.SendCommand(GameObject.GetGameObjectId(ENEMY_4001), { id = "GetLifeStatus" })
		local lifeState2 = GameObject.SendCommand(GameObject.GetGameObjectId(ENEMY_4002), { id = "GetLifeStatus" })

		if
			lifeState0 == TppGameObject.NPC_LIFE_STATE_DEAD
			and lifeState1 == TppGameObject.NPC_LIFE_STATE_DEAD
			and lifeState2 == TppGameObject.NPC_LIFE_STATE_DEAD
		then
			Fox.Log("check is ok")
			s10240_radio.SodaSorede()
			TppSequence.SetNextSequence("Seq_Game_Slaughter")
		else
			Fox.Log("check is no")
		end
	end,

	OnEnter = function()
		this.CommonSetUpInMBQF()
		TppDataUtility.SetEnableDataFromIdentifier(IDEN_LIGHT_ID, "mtbs_qrntnFacility_Light01", true, true)
		s10240_radio.ORadioSet03()
		s10240_enemy02.KillEnemyAfterDemo()
		TppSoundDaemon.PostEvent(SFX_SHOT_FIRE_ALERM)
		Player.SetMaskBreathSoundLevel({ soundLevel = 2 })

		this.SetDisableOnlyCQC()

		Player.ChangeEquip({
			equipId = TppEquip.EQP_IT_Infected,
			dropPrevEquip = false,
			toActive = false,
		})
		this.SetWeaponStatus()

		vars.currentInventorySlot = TppDefine.WEAPONSLOT.SECONDARY
		Player.RequestToSetCameraRotation(CAMERA_BATTLE)

		TppDataUtility.CreateEffectFromGroupId("effect_water")

		s10240_enemy02.SetZombieMode()
		s10240_radio.ShootSneak()

		GkEventTimerManager.Start("Timer_ShootSneak", TIME_SHOOT_SNEAK)
		GkEventTimerManager.Start("Timer_ZombieStart", TIME_ZOMBIE_DOWN)

		this.SetEnableModel()

		TppUiCommand.SetMisionInfoCurrentStoryNo(2)
		TppMission.UpdateObjective({
			objectives = { "slaugher_photo_mbqf", "open_missionTask_01" },
		})
		TppMission.UpdateObjective({
			objectives = { "clear_missionTask_00" },
		})

		svars.numEnemyDownSound = svars.numEnemyDown

		TppCassette.Acquire({
			cassetteList = { "tp_m_10240_05" },
			isShowAnnounceLog = true,
		})
	end,

	OnLeave = function()
		GkEventTimerManager.Stop("Timer_ShootSneak")
	end,
}

sequences.Seq_Game_Slaughter = {

	Messages = function(self)
		return StrCode32Table({
			Player = {
				{
					msg = "LookingTarget",
					func = function()
						Fox.Log("LookingTarget")
					end,
				},
				{
					msg = "OnEquipItem",
					func = function(playerId, equpId)
						Fox.Log("check equip")

						if equpId == TppEquip.EQP_IT_Infected then
							if svars.numDoEventRoof == 1 then
								Fox.Log("set special goggle")
								svars.numDoEventRoof = 2

								if s10240_enemy02.CheckEnemyDistForTutorial() == true then
									s10240_radio.tutorial02()
								end
							end

							if svars.numDoEventLast == 1 then
								s10240_radio.LastMan03()
								this.StopTimer("Timer_TalkLastMan_05")
							end
						end
					end,
				},
				{
					msg = "StartEventDoorPicking",
					func = function(playerId, doorId)
						if doorId == this.GetDoorId() then
							Fox.Log("Event door Open!!")
							if svars.isAllClear == true then
								GkEventTimerManager.Start("Timer_GoToNextSeqence", TIMER_TO_DEMO)
							elseif this.CheckIsCarriedLastMan() and svars.numDoEventLast == 0 then
								svars.numDoEventLast = 1
								GkEventTimerManager.Start("Timer_PlayExitWithLiveMan", TIMER_TO_DEMO)
							end
						end
					end,
				},
			},
			Radio = {
				{
					msg = "Finish",
					sender = "s0240_rtrg0300",
					func = function()
						Fox.Log("talk: radio Last man 1 end")
						GkEventTimerManager.Start("Timer_TalkLastMan_02", 1)
					end,
				},
				{
					msg = "Finish",
					sender = "s0240_rtrg0307",
					func = function()
						GkEventTimerManager.Start("Timer_TalkLastMan_03", 0.5)
					end,
				},
			},
			GameObject = {
				{
					msg = "Dead",
					func = self.CountEnemyDown,
				},
				{
					msg = "Damage",
					sender = ENEMY_2100,
					func = function(gameObjectId, attackId, attakerId)
						Fox.Log("damage 2f3")
						if Tpp.IsPlayer(attakerId) and TppDamage.IsActiveByAttackId(attackId) then
							Fox.Log("2f3 check flag")

							if svars.numEvent2F3 < this.event2F3Enum.CAN_DEAD then
								Fox.Log("Play motion 2f3 event. before")
								s10240_enemy02.SetDeadMotionHanyou(gameObjectId)
								this.StopTimer("Timer_Talk2F3_05")
								this.StopTimer("Timer_Talk2F3_04")
								this.StopTimer("Timer_Talk2F3_03")
								this.StopTimer("Timer_Talk2F3_02")
								this.StopTimer("Timer_Talk2F3_01")
								this.ReSetPadMaskWalk()
								this.SetDisableActionFlag()
								this.ResetPadMaskMove()
								TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, IDEN_BLOOD.ROOM2F3, true)
							elseif svars.numEvent2F3 < this.event2F3Enum.DEAD then
								Fox.Log("Play motion 2f3 event. after")
								s10240_enemy02.DeadEvent2F3()
								svars.numEvent2F3 = this.event2F3Enum.DEAD
								this.StopTimer("Timer_Talk2F3_05")
								this.StopTimer("Timer_Talk2F3_04")
								this.StopTimer("Timer_Talk2F3_03")
								this.ReSetPadMaskWalk()
								this.SetDisableActionFlag()
								this.ResetPadMaskMove()
								TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, IDEN_BLOOD.ROOM2F3, true)
								GkEventTimerManager.Start("Timer_Talk2F3_06", 1)
							else
							end
						end

						if attackId == TppDamage.ATK_Push then
							Fox.Log("push 2f3")
							s10240_enemy02.PushEvent2F3()
							svars.deadCase10Num = TppMotherBaseManagementConst.REMOVER_REASON_SUICIDE
						end
					end,
				},
				{
					msg = "ConversationEnd",
					sender = ENEMY_1200,
					func = function(gameObjectId, label, isSucceed)
						if svars.isDead24 == true then
							return
						end

						if label == Fox.StrCode32("DD_660") then
							Fox.Log("talk: last man 01 end")
							s10240_radio.LastMan01()
							s10240_sound.StartJingleEnd()
						end
					end,
				},
				{
					msg = "Carried",
					sender = ENEMY_1200,
					func = function(characterId, arg1)
						if this.CheckIsDeadLastMan() == true then
							return
						end

						if
							arg1 == 0
							and svars.isClear0F == true
							and svars.isClear1F == true
							and svars.isClear2F == true
							and svars.isClear3F == true
						then
							TppMission.UpdateObjective({
								objectives = { "marker_clear_exit" },
							})
						end

						if svars.isHoken06 == false then
							svars.isHoken06 = true
							s10240_sound.StartBGM03()
							s10240_radio.ORadioSet045()
							s10240_radio.TakeOutSide()
						end

						if arg1 == 0 then
							s10240_enemy02.WakeUpEvent2F4()
							GkEventTimerManager.Start("Timer_TalkLastMan_10", 6)
							GameObject.SendCommand(
								{ type = "TppPlayer2", index = PlayerInfo.GetLocalPlayerIndex() },
								{ id = "SetStandMoveSpeedLimit", speedRateLimit = 0.1 }
							)
						elseif arg1 == 1 then
							s10240_enemy02.FaintEvent2F4()
							this.SetDisableActionFlag()

							if svars.numDoEventLast == 1 then
								s10240_enemy02.SetWakeMotionLastMan()

								if this.CheckEquipGoggle() == true then
									s10240_radio.LastMan03()
								else
									GkEventTimerManager.Start("Timer_TalkLastMan_05", 10)
								end
							end
						end
					end,
				},
				{
					msg = "AimedFromPlayer",
					func = function(gameObjectId, isFound)
						this.AimEnemy(gameObjectId, isFound)
					end,
				},
				{
					msg = "SpecialActionEnd",
					func = function(characterId, actionId, commandId)
						Fox.Log("SpecialActionEnd")
						if commandId == Fox.StrCode32("ObieLoop") then
							s10240_enemy02.SetObieLoopMotion(characterId)
						else
							this.ChangeMotionForEvent(characterId, commandId)
						end
					end,
				},
				{
					msg = "MtqfB1DoorOpen",
					func = function()
						Fox.Log("open the door")
						if svars.isDoEventB1Pre == true then
							GkEventTimerManager.Start("Timer_OpenB1Door", TIMER_B1_DOOR)
						end
					end,
				},
			},
			Trap = {
				{
					msg = "Enter",
					sender = "trap_setting_realize",
					func = function()
						local enemyName = "sol_mbqf_1000"
						s10240_enemy02.SetForceRealize(enemyName)
						Fox.Log("SetInheritanceForceRealizeToCorpse")
						local gameObjectId = GameObject.GetGameObjectId("TppSoldier2", enemyName)
						local command = { id = "SetInheritanceForceRealizeToCorpse", enabled = true }
						GameObject.SendCommand(gameObjectId, command)
					end,
				},
				{
					msg = "Exit",
					sender = "trap_setting_realize",
					func = function()
						s10240_enemy02.SetForceRealize("sol_mbqf_1000", false)
					end,
				},
				{
					msg = "Enter",
					sender = "trap_setting_realize2F",
					func = function()
						s10240_enemy02.SetForceRealize("sol_mbqf_1001")
					end,
				},
				{
					msg = "Exit",
					sender = "trap_setting_realize2F",
					func = function()
						s10240_enemy02.SetForceRealize("sol_mbqf_1001", false)
					end,
				},

				{
					msg = "Enter",
					sender = "trap_setting_b1_lamp",
					func = function()
						Gimmick.EnableAlarmLampAll(false)
					end,
				},
				{
					msg = "Exit",
					sender = "trap_setting_b1_lamp",
					func = function()
						Gimmick.EnableAlarmLampAll(true)
					end,
				},

				{
					msg = "Enter",
					sender = "trap_effect_rain_end",
					func = function()
						TppDataUtility.DestroyEffectFromGroupId("effect_water")
					end,
				},
				{
					msg = "Enter",
					sender = "trap_blackOut",
					func = function()
						if svars.numBlackOut == 0 then
							svars.numBlackOut = 1
							GkEventTimerManager.Start("Timer_BlackOut", TIME_BLACKOUT)
							TppSoundDaemon.PostEvent(SFX_SHOT_POWER_OFF)
							s10240_enemy02.Set2FUnarmed()
							s10240_enemy02.IdleEvent2rouka()
							GkEventTimerManager.Start("Timer_Down2F", 2)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_exit",
					func = function()
						if
							(svars.isAllClear == false)
							and (this.CheckIsCarriedLastMan() == false)
							and not (svars.numDoEventLast == 1)
						then
							s10240_radio.NeedMoreKill()
						end
					end,
				},
				{ msg = "Enter", sender = "trap_radio_event1200", func = self.OnCarriedEnemy },
				{ msg = "Enter", sender = "trap_event_B1", func = self.OpenB1Door },
				{
					msg = "Enter",
					sender = "trap_event_song",
					func = function()
						if svars.isDoEventB1Pre == false then
							svars.isDoEventB1Pre = true

							s10240_enemy02.PreSetEventB1Room()

							Gimmick.ResetGimmick(
								TppGameObject.GAME_OBJECT_TYPE_DOOR,
								"mtbs_door004_gim_n0000|srt_mtbs_door004",
								GIMMICK_PATH
							)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_talk_0007",
					func = function()
						if svars.isTalk22 == false then
							svars.isTalk22 = true
							s10240_enemy02.SetRouteZombie1FAfter()

							s10240_enemy02.SetRouteZombie1F()
							s10240_enemy02.SetNoClothAnim()

							GkEventTimerManager.Start("Timer_Talk1F_20", 1)
							GkEventTimerManager.Start("Timer_Talk1F_21", 5)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_story0000",
					func = function()
						if this.CheckIsCarriedLastMan() and svars.isTalk13 == false then
							svars.isTalk13 = true
							s10240_enemy02.CallVoice(ENEMY_1200, EnemyVoiceParam, "DDD_EV038")
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_talk_0003",
					func = function()
						if this.CheckIsCarriedLastMan() and svars.isTalk11 == false then
							svars.isTalk11 = true
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_event_B1_song",
					func = function()
						svars.isHoken08 = true
					end,
				},
				{
					msg = "Exit",
					sender = "trap_event_B1_song",
					func = function()
						svars.isHoken08 = false
					end,
				},

				{
					msg = "Enter",
					sender = "trap_event_B0001",
					func = function()
						if svars.numEventB1Talk == 0 then
							svars.numEventB1Talk = 1
							Fox.Log("Start talk")
							s10240_enemy02.WaitEventB1Room()
							this.StartDisableActionForEvent({ addTime = -1, type = "CanFire" })
							this.StartConstCamera(CAM_DATA_B1)
							GkEventTimerManager.Start("Timer_TalkB1_01", 0.1)
							GkEventTimerManager.Start("Timer_TalkB1_02", 1)
							GkEventTimerManager.Start("Timer_TalkB1_03", 4)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_event_B0002",
					func = function()
						if svars.isDoEventSong == false then
							svars.isDoEventSong = true
							Fox.Log("Start song")
							s10240_enemy02.StartSongEvent()

							this.SetHideRadio(true)
							s10240_sound.StopBGM02()
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_talk_0005",
					func = function()
						if svars.isTalk17 == false then
							svars.isTalk17 = true
							GkEventTimerManager.Start("Timer_Talk1F_22", 2)
						end
					end,
				},

				{
					msg = "Enter",
					sender = "trap_radio_event2000",
					func = function()
						s10240_enemy02.SetDeadHoken(3)
						if svars.isTalk15 == false then
							svars.isTalk15 = true
							GkEventTimerManager.Start("Timer_Talk1F_10", 1)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_talk_0004",
					func = function()
						if svars.isTalk16 == false then
							svars.isTalk16 = true
							s10240_enemy02.CallVoice(ENEMY_5004, EnemyVoiceParam, "DDD020")
							GkEventTimerManager.Start("Timer_Talk2F_10", 3)
						end
					end,
				},

				{
					msg = "Enter",
					sender = "trap_radio_event3000",
					func = function()
						if svars.isTalk05 == false then
							svars.isTalk05 = true

							s10240_enemy02.Kill2FEnemy()

							GkEventTimerManager.Start("Timer_Talk2F_12", 1)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event2100",
					func = function()
						if svars.numEvent2F3 == 0 then
							svars.numEvent2F3 = this.event2F3Enum.START
							s10240_enemy02.StartEvent2F3()
							this.StartConstCamera(CAM_DATA_2F3)
							this.StartDisableActionForEvent({ addTime = 1, type = "CanFire" })
							Player.RequestToSetCameraRotation(CAMERA_2F1)
							GkEventTimerManager.Start("Timer_Talk2F3_01", 1)
							GkEventTimerManager.Start("Timer_Talk2F3_02", 7)
						end
					end,
				},

				{
					msg = "Enter",
					sender = "trap_radio_event3100",
					func = function()
						if svars.isTalk12 == false then
							svars.isTalk12 = true
							GkEventTimerManager.Start("Timer_Talk3F_13", 0.5)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_event3040",
					func = function()
						if svars.isDoEvent34 == false and svars.numDoEventRoof >= 2 then
							svars.isDoEvent34 = true
							GkEventTimerManager.Start("Timer_Talk3F_11", 0.5)
							this.StartDisableActionForEvent({ addTime = -1, type = "CanFire" })
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_talk_0002",
					func = function()
						if svars.isTalk08 == false then
							svars.isTalk08 = true
							GkEventTimerManager.Start("Timer_Talk3F_12", 0.5)
							this.StartDisableActionForEvent({ addTime = -1, type = "CanFire" })
						end
					end,
				},

				{
					msg = "Enter",
					sender = "trap_camera_2F",
					func = function()
						if svars.isTalk06 == false then
							svars.isTalk06 = true
							GkEventTimerManager.Start("Timer_Talk2F_11", 0.5)
						end
					end,
				},

				{
					msg = "Enter",
					sender = "trap_radio_story0110",
					func = function()
						if svars.numDoEventRoof == 0 and s10240_enemy02.CheckEnemyLiveForTutorial() == true then
							svars.numDoEventRoof = 1

							if this.CheckEquipGoggle() == true then
								svars.numDoEventRoof = 2
								this.StartDisableActionForEvent({ addTime = -2, type = "CanFire" })
								Player.RequestToSetCameraRotation(CAMERA_2F42)
								s10240_radio.tutorial02()
							end
							GkEventTimerManager.Start("Timer_Talk3F_10", 4)

							GkEventTimerManager.Start("Timer_ShootSneak", TIME_SHOOT_SNEAK)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_event_2F4",
					func = function()
						if TppEnemy.GetLifeStatus(ENEMY_3040) == TppEnemy.LIFE_STATUS.DEAD then
							return
						end

						if svars.numDoEventRoof == 0 then
							svars.numDoEventRoof = 1
							s10240_radio.tutorial01("long")
							this.StartDisableActionForEvent({ addTime = -1, type = "CanFire" })
							Player.RequestToSetCameraRotation(CAMERA_3F4)
							GkEventTimerManager.Start("Timer_Talk3F_11", 4)
							Player.RequestToSetTargetStance(PlayerStance.STAND)
							Player.RequestToMoveToPosition({
								name = "name",
								position = Vector3(-2.893, 8.000, 10.609),

								moveType = PlayerMoveType.WALK,
								timeout = 4,
							})

							GkEventTimerManager.Start("Timer_ShootSneak", TIME_SHOOT_SNEAK)
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_event_B1_liveMan",
					func = function()
						if this.CheckIsDeadLastMan() == false then
							if this.CheckEquipGoggle() == true then
								s10240_radio.TakeOutSide()
								s10240_radio.ORadioSet045()
							else
								s10240_radio.LastManCheck()
							end
						end
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_game_1000",
					func = function()
						s10240_radio.DontGoOut()
					end,
				},
				{
					msg = "Enter",
					sender = "trap_radio_game0003",
					func = function()
						s10240_radio.DontOpenDoor2after()
					end,
				},
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_OpenB1Door",
					func = self.OpenB1Door,
				},
				{
					msg = "Finish",
					sender = "Timer_Radio_First",
					func = function()
						Fox.Log("play radio song")
						s10240_radio.KillAllPlease()

						this.StartDisableRunForEvent(13)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Radio",
					func = function()
						Fox.Log("play radio song")
						local position = Vector3(-7.645, -4.000, 15.031)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_BlackOut",
					func = function()
						this.BlackOut()
						TppSoundDaemon.PostEvent(SFX_SHOT_STOP_FIRE_ALERM)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_ShootSneak",
					func = function()
						if this.CheckEquipGoggle() == false then
							GkEventTimerManager.Start("Timer_Tutorial01", 3)
							s10240_radio.tutorial03()
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Tutorial01",
					func = function()
						if this.CheckEquipGoggle() == false then
							TppUI.ShowControlGuide({ actionName = "EQUIPMENT_WP", continue = false })
						end
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_StandUpB1",
					func = function()
						Fox.Log("Timer_StandUpB1")
						if svars.isDoEventB2 == false then
							svars.isDoEventB2 = true
							Fox.Log("StandUpEventB1Room")
							s10240_enemy02.StandUpEventB1Room()
							s10240_enemy02.StartEvent2F4()
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_LiveMan",
					func = function()
						if
							TppEnemy.GetLifeStatus(ENEMY_1200) ~= TppEnemy.LIFE_STATUS.DEAD
							and svars.isLook2F4Enemy == false
							and this.CheckIsCarriedLastMan() == false
						then
							if svars.isHoken08 == false then
								this.StopTimer("Timer_LiveMan")
								GkEventTimerManager.Start("Timer_LiveMan", 1)
							else
								svars.isLook2F4Enemy = true
								s10240_sound.StopBGM02()
								s10240_radio.CheckMaskMan()
								this.StartDisableActionForEvent({ addTime = 8 })
								this.StartConstCamera(CAM_DATA_B1_LIVE_MAN)
							end
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Down2F",
					func = function()
						s10240_enemy02.IdleEvent2rouka("two")
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_Talk2F3_01",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_2100, "DD_520")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F3_02",
					func = function()
						svars.numEvent2F3 = this.event2F3Enum.CAN_DEAD
						s10240_enemy02.SetDeadFlag2F3()
						s10240_enemy02.CallTalkEnemy(ENEMY_2100, "DD_522")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F3_03",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_2100, "DD_525")
						this.SetHesitatingFire()
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F3_04",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_2100, "DD_526")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F3_05",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_2100, "DD_527")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Blood2F3",
					func = function()
						svars.numEvent2F3 = this.event2F3Enum.DEAD
						TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, IDEN_BLOOD.ROOM2F3, true)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F3_06",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_2100, "DD_524")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkB1_01",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0001, "DD_530")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkB1_02",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0002, "DD_531")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkB1_03",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0002, "DD_532")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkB1_04",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0001, "DD_534")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkB1_05",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0002, "DD_535")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkB1_06",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0002, "DD_536")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkB1_07",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0001, "DD_537")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkB1_08",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0000, "DD_538")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk1F_10",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_5000, "DD_092")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk1F_20",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0003, "DD_180")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk1F_21",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0005, "DD_192")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk1F_22",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_0004, "DD_172")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk3F_10",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_5007, "DD_091")
						this.SetHesitatingFire()
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk3F_11",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_3040, "DD_650")
						GkEventTimerManager.Start("Timer_Talk3F_112", 2)
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk3F_112",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_3040, "DD_653")
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_Talk3F_12",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_5009, "DD_221")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk3F_13",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_5006, "DD_041")
						this.SetHesitatingFire()
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_ShootPlayer",
					func = function()
						s10240_enemy02.StartFireEvent2rouka()
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_ShootSay2210",
					func = function()
						s10240_enemy02.CallVoice(ENEMY_2210, EnemyVoiceParam, "DDD208")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_ShootSay2200",
					func = function()
						s10240_enemy02.CallVoice(ENEMY_2200, EnemyVoiceParam, "DDD208")
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_Talk2F_10",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_5003, "DD_052")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_11",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_5001, "DD_192")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_Talk2F_12",
					func = function()
						s10240_enemy02.CallTalkEnemy(ENEMY_2210, "DD_240")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkLastMan_10",
					func = function()
						if this.CheckIsDeadLastMan() == false then
							if svars.isTalk14 == false then
								svars.isTalk14 = true
								s10240_enemy02.CallTalkEnemy("sol_mbqf_0003", "DD_554")
							end
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkLastMan_01",
					func = function()
						if this.CheckIsDeadLastMan() == false then
							Fox.Log("talk: last man 01")
							s10240_enemy02.CallTalkEnemy(ENEMY_1200, "DD_660")
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkLastMan_02",
					func = function()
						if this.CheckIsDeadLastMan() == false then
							Fox.Log("talk: last man 02")
							s10240_enemy02.CallTalkEnemy(ENEMY_1200, "DD_663")
						end
					end,
				},

				{
					msg = "Finish",
					sender = "Timer_TalkLastMan_03",
					func = function()
						if this.CheckIsDeadLastMan() == false then
							Fox.Log("talk: last man 03")
							s10240_enemy02.CallTalkEnemy(ENEMY_1200, "DD_664")
							GkEventTimerManager.Start("Timer_TalkLastMan_04", 20)
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkLastMan_04",
					func = function()
						if this.CheckIsDeadLastMan() == false then
							Fox.Log("talk: last man 04")
							s10240_enemy02.CallTalkEnemy(ENEMY_1200, "DD_667")
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_TalkLastMan_05",
					func = function()
						if this.CheckIsDeadLastMan() == false then
							Fox.Log("talk: last man 04")
							s10240_radio.LastMan02()
						end
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_GoToNextSeqence",
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_EndCut")
					end,
				},
				{
					msg = "Finish",
					sender = "Timer_PlayExitWithLiveMan",
					func = function()
						local EndFunc = function()
							s10240_radio.ORadioSet05()
							s10240_enemy02.SetNodoLastMan()
							s10240_enemy02.SetWakeMotionLastMan()
							TppUiStatusManager.SetStatus("AnnounceLog", "INVALID_LOG_EXCEPT")
						end

						s10240_demo.PlayExitWithLiveMan(EndFunc)
					end,
				},
			},
			nil,
		})
	end,

	OpenB1Door = function()
		Fox.Log("enter B1 event")
		if svars.isDoEventB1 == false then
			Fox.Log("Start B1 event")
			svars.isDoEventB1 = true
			s10240_enemy02.FaintEvent2F4()
			s10240_enemy02.StartEventB1Room()
			this.StopTimer("Timer_StandUpB1")
			GkEventTimerManager.Start("Timer_StandUpB1", 0.5)

			GkEventTimerManager.Start("Timer_TalkB1_04", 2)
			GkEventTimerManager.Start("Timer_TalkB1_05", 3)
			GkEventTimerManager.Start("Timer_TalkB1_06", 4)
			GkEventTimerManager.Start("Timer_TalkB1_07", 5)
			GkEventTimerManager.Start("Timer_TalkB1_08", 6)
			s10240_enemy02.SetDeadHoken(3)
			s10240_enemy02.SetDeadHoken(2)
			s10240_enemy02.SetDeadHoken(1)
		end
	end,

	CountEnemyDown = function(gameObjectId, attakerId)
		svars.numEnemyDown = svars.numEnemyDown + 1
		if svars.numEnemyDown == RADIO_HUYE4 then
			s10240_radio.HuyeSay()
			Player.SetMaskBreathSoundLevel({ soundLevel = 5 })
		elseif svars.numEnemyDown == RADIO_HUYE3 then
			s10240_radio.HuyeSay()
		elseif svars.numEnemyDown == RADIO_HUYE2 then
			s10240_radio.HuyeSay()
			Player.SetMaskBreathSoundLevel({ soundLevel = 4 })
		elseif svars.numEnemyDown == RADIO_HUYE1 then
			s10240_radio.AfterHuey()
			Player.SetMaskBreathSoundLevel({ soundLevel = 3 })
		end

		if svars.numDoEventRoof == 1 then
			s10240_radio.tutorial03()
		elseif svars.numDoEventRoof == 2 then
			svars.numDoEventRoof = 3
			s10240_radio.SorryBoss()
		end

		this.StopTimer("Timer_ShootSneak")

		if GkEventTimerManager.IsTimerActive("Timer_StandUpB1") == false then
			if
				gameObjectId == GameObject.GetGameObjectId("TppSoldier2", ENEMY_0000)
				or gameObjectId == GameObject.GetGameObjectId("TppSoldier2", ENEMY_0001)
				or gameObjectId == GameObject.GetGameObjectId("TppSoldier2", ENEMY_0002)
			then
			end
		end

		if gameObjectId == GameObject.GetGameObjectId(ENEMY_1200) then
			Player.StopTargetConstrainCamera()
			s10240_enemy02.SetDisableCarried()
		end

		if svars.isClear3F == false then
			if s10240_enemy02.CheckEnemyDead(3) == true then
				svars.isClear3F = true
				Fox.Log("floor clear 3F")
			end
		end
		if svars.isClear2F == false then
			if s10240_enemy02.CheckEnemyDead(2) == true then
				svars.isClear2F = true
				Fox.Log("floor clear 2F")
			end
		end
		if svars.isClear1F == false then
			if s10240_enemy02.CheckEnemyDead(1) == true then
				svars.isClear1F = true
				Fox.Log("floor clear 1F")
			end
		end
		if svars.isClear0F == false then
			if s10240_enemy02.CheckEnemyDead(0) == true then
				svars.isClear0F = true
				Fox.Log("floor clear B1")

				if svars.isHoken06 == false then
					GkEventTimerManager.Start("Timer_LiveMan", TIME_LIVE_MAN)
				end
			end
		end

		if
			svars.isClear0F == true
			and svars.isClear1F == true
			and svars.isClear2F == true
			and svars.isClear3F == true
		then
			if this.CheckIsDeadLastMan() then
				Fox.Log("all floor is clear")
				TppMission.UpdateObjective({
					objectives = { "marker_clear_exit", "clear_missionTask_01" },
				})
				svars.isAllClear = true
				svars.isDead24 = true
				Player.SetMaskBreathSoundLevel({ soundLevel = 6 })
				s10240_radio.ORadioSet07()
				TppMission.UpdateCheckPointAtCurrentPosition()
			elseif this.CheckIsCarriedLastMan() then
				Fox.Log("all floor is clear")
				TppMission.UpdateObjective({
					objectives = { "marker_clear_exit" },
				})
				s10240_radio.ORadioSet045()

				s10240_sound.StartBGM03()
			else
				Fox.Log("last man not dead")
			end
		end

		local dieEnemy = svars.numEnemyDown - svars.numEnemyDownSound
		Fox.Log("dieEnemy : " .. dieEnemy)
		if dieEnemy >= 9 then
			if svars.isSwitchBGM03 == false then
				svars.isSwitchBGM03 = true
				s10240_sound.SwitchBGM03()
			end
		elseif dieEnemy >= 5 then
			if svars.isSwitchBGM02 == false then
				svars.isSwitchBGM02 = true
				s10240_sound.SwitchBGM02()
			end
		end

		if
			gameObjectId == GameObject.GetGameObjectId(ENEMY_0003)
			or gameObjectId == GameObject.GetGameObjectId(ENEMY_0004)
		then
			s10240_enemy02.CallVoice(gameObjectId, EnemyVoiceParam, "DDD300")
		end

		if gameObjectId == GameObject.GetGameObjectId(ENEMY_0005) then
			s10240_enemy02.CallVoice(gameObjectId, EnemyVoiceParam, "DDD270")
		end

		if
			gameObjectId == GameObject.GetGameObjectId(ENEMY_5010)
			or gameObjectId == GameObject.GetGameObjectId(ENEMY_5011)
		then
			Fox.Log("no sfx")
		else
			TppSoundDaemon.PostEvent(SFX_KILL_ENEMY)
		end

		this.ChangeMotionForDie(gameObjectId)
		this.StopSong(gameObjectId)
	end,

	OnCarriedEnemy = function()
		Fox.Log("check enemy carried")

		if svars.numDoEventLast == 0 and this.CheckIsDeadLastMan() then
			Fox.Log("check is ng. svars:" .. svars.numDoEventLast)
			svars.numDoEventLast = 2
		end
	end,

	OnEnter = function()
		this.CommonSetUpInMBQF()
		this.SetEnableModel()
		s10240_enemy02.SetDisableCarried()

		if svars.isAllClear == false then
			Fox.Log("not flag: isAllClear :")
			s10240_enemy02.EnableEnemy()
			s10240_enemy02.UnsetEvent2F4()
			s10240_enemy02.StartEvent2F4()
			this.ResetEnemyPosition(ENEMY_5008, ROUTE_3F_OBIE)
			this.ResetEnemyPosition(ENEMY_2210, ROUTE_2F_SHOOT1)
			this.ResetEnemyPosition(ENEMY_2200, ROUTE_2F_SHOOT2)
			s10240_radio.ORadioSet04()

			s10240_sound.StartBGM02()
			TppDataUtility.SetVisibleEffectFromGroupId("effect_water", true)
			TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, IDEN_BLOOD.ROOM2F3, false)

			if svars.isDead24 == false then
				this.ResetEnemyPosition(ENEMY_1200, ROUTE_2F4_TO_B1)

				s10240_enemy02.SetNodoLastMan(false)
			end
		else
			Fox.Log("isAllClear is true. skip")
			s10240_enemy02.DisableEnemyAfterClear()
		end
		TppUiCommand.SetMisionInfoCurrentStoryNo(2)
		this.StopSongEvent()

		this.SetHesitatingFire()

		s10240_enemy02.SetNoKrei()

		s10240_enemy02.SetMotionDown()
		this.ResetObieFlag()

		if svars.isSayRadioRoof == true then
			if svars.isAllClear == true then
			else
				s10240_radio.KillAllPleaseContinue()
			end
		else
			GkEventTimerManager.Start("Timer_Radio_First", 1.8)

			svars.isSayRadioRoof = true
			TppMission.UpdateCheckPointAtCurrentPosition()
		end
	end,
}

sequences.Seq_Demo_EndCut = {
	Messages = function(self)
		return StrCode32Table({
			Demo = {
				{
					msg = "DM_mask_off",
					sender = s10240_demo.demoList.Demo_Exit,
					func = function()
						Player.VisibleGasMask(false)
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "DM_mask_on",
					sender = s10240_demo.demoList.Demo_Exit,
					func = function()
						Player.VisibleGasMask(true)
					end,
					option = { isExecDemoPlaying = true },
				},
				{
					msg = "DM_thm_off",
					sender = s10240_demo.demoList.Demo_Exit,
					func = function()
						vars.playerDisableActionFlag = PlayerDisableAction.INFECTED_GOGGLES
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			nil,
		})
	end,
	OnEnter = function()
		Gimmick.PowerCutOn(TEIDEN_DATA)
		Gimmick.EnableAlarmLampAll(true)
		this.SetHideFann(true)
		s10240_enemy02.DisableCorpseForDemo()
		Player.SetMaskBreathSoundLevel({ soundLevel = 0 })
		TppPickable.ClearAllDroppedInstance()

		TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, "clear_demo", true)
		TppDataUtility.SetVisibleDataFromIdentifier(IDEN_ASSET_ID, "clear_demo_off", false)

		TppUiStatusManager.SetStatus("AnnounceLog", "INVALID_LOG_EXCEPT")
		local EndFunc = function()
			TppUiStatusManager.SetStatus("AnnounceLog", "INVALID_LOG")
			if TppStory.GetCurrentStorySequence() < TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then
				Fox.Log("Remove locked staffs")

				this.DeadCaseSetting()
			end
			TppMission.ReserveMissionClear({
				missionClearType = TppDefine.MISSION_CLEAR_TYPE.ON_FOOT,
				nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_HELI,
			})
		end

		TppDemo.SpecifyIgnoreNpcDisable(ENEMY_1200)
		Fox.Log("play exit demo")
		s10240_demo.PlayExitDemo(EndFunc)
	end,
}

sequences.Seq_Demo_Funeral = {

	OnEnter = function()
		TppScriptBlock.LoadDemoBlock("Demo_Funeral")

		TppPlayer.Refresh()
		s10240_enemy.DisableBird()
		s10240_enemy.DisableEnemyForDemo()

		this.StopGimmickCrane()

		local func = function()
			Fox.Log("demo is end. mission finalize")

			MotherBaseStage.UnlockCluster()

			TppMission.MissionFinalize()
		end

		s10240_demo.PlayFuneralDemo(func)
	end,
}

return this
