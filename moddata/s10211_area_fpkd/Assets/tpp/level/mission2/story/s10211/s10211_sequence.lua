local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

local TIMER_NO_HINT = 60 * 5
local TIMER_TIME = 60 * 10

local HOSTAGE_TALK_MAX = 12
local HOSTAGE_TALK_MARRILA = 11
local HOSTAGE_TALK_LOOP = 10

local TASK_HOSTAGE_MAX = 4
local TASK_ENEMY_MAX = 6

local JACKAL_MAX = 12

local ESCAPE_POINT_00 = 0
local ESCAPE_POINT_01 = 1
local ESCAPE_POINT_02 = 2
local ESCAPE_POINT_03 = 3
local ESCAPE_POINT_04 = 4
local ESCAPE_POINT_05 = 5

if debug then
	this.DEBUG_strCode32List = {
		"p31_010025",
		"Demo_GetIntel",
	}
end

local ANIMAL_DEADLY_ATTACK_LIST_1 = {
	TppDamage.ATK_BearStandAttack,
	TppDamage.ATK_BearAttack,
	TppDamage.ATK_BearRush,
	TppDamage.ATK_WolfBite,

	TppDamage.ATK_FireBurn,
	TppDamage.ATK_HeavyPhysics,
	TppDamage.ATK_GimmickBlast,
	TppDamage.ATK_GimmickBlastHigh,
	TppDamage.ATK_GuardTower,
	TppDamage.ATK_BrokenBridge,
	TppDamage.ATK_BrokenPillar,
	TppDamage.ATK_WaterTowerSplash,
	TppDamage.ATK_WaterTankSplash,
	TppDamage.ATK_ElectricWire,
	TppDamage.ATK_WaterWayArch,
	TppDamage.ATK_WaterWayWall,
	TppDamage.ATK_WaterWayPillar,
	TppDamage.ATK_WaterFaucetSplash,
	TppDamage.ATK_FallBoundDeath,
	TppDamage.ATK_HorseBodyAttack,
	TppDamage.ATK_HorseBodyAttackMil1,
	TppDamage.ATK_HorseBodyAttackMil2,
	TppDamage.ATK_HorseBodyAttackMil3,
	TppDamage.ATK_HorseBodyAttackDeath,
	TppDamage.ATK_Dung,
	TppDamage.ATK_VehicleHit,
	TppDamage.ATK_VehiclePush,
	TppDamage.ATK_LightVehicleHit,
	TppDamage.ATK_VehicleCrash,
	TppDamage.ATK_VehicleBlast,
	TppDamage.ATK_VehicleDrop,
	TppDamage.ATK_LightVehicleDrop,
	TppDamage.ATK_FlyingDisc,
	TppDamage.ATK_Kibidango,
	TppDamage.ATK_HeliBlast,
}
local ANIMAL_DEADLY_ATTACK_LIST = {

	TppDamage.ATK_FallBoundDeath,
	TppDamage.ATK_FallDeath,
	TppDamage.ATK_Death,
	TppDamage.ATK_Fall,
	TppDamage.ATK_Event,
	TppDamage.ATK_HorseBodyAttackDeath,
	TppDamage.ATK_VehicleHit,
	TppDamage.ATK_LightVehicleHit,
	TppDamage.ATK_VehicleBlast,
	TppDamage.ATK_VehicleDrop,
	TppDamage.ATK_LightVehicleDrop,
	TppDamage.ATK_HeliBlast,
	TppDamage.ATK_GimmickBlast,
	TppDamage.ATK_GimmickBlastHigh,
	TppDamage.ATK_GuardTower,
	TppDamage.ATK_BrokenBridge,
	TppDamage.ATK_BrokenPillar,
	TppDamage.ATK_WaterWayArch,
	TppDamage.ATK_WaterWayWall,
	TppDamage.ATK_WaterWayPillar,
	TppDamage.ATK_BearStandAttack,
	TppDamage.ATK_BearAttack,
	TppDamage.ATK_WolfBite,
}

this.TASK_VIP_SOLO_GROUP = {
	"sol_mis_0000",
}

this.TASK_VIP_SQUAD_GROUP = {
	"sol_mis_0001",
	"sol_mis_0000",
	"sol_mis_0002",

	"sol_mis_0003",
	"sol_mis_0004",
	"sol_mis_0005",
}

this.TASK_HOSTAGE_GROUP = {
	"hos_mis_0000",
	"hos_mis_0001",
	"hos_mis_0002",
	"hos_mis_0003",
}

local PHOTO_NAME = {
	TARGET = 10,
}

local TARGET_NAME = "sol_mis_0000"

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

this.MAX_PLACED_LOCATOR_COUNT = 69
this.MAX_PICKABLE_LOCATOR_COUNT = 46
this.EQUIP_MISSION_BLOCK_GROUP_SIZE = 1599990

function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences({

		"Seq_Game_BeforeGetDocument",
		"Seq_Game_AfterGetDocument",
		"Seq_Game_KillTarget",
		"Seq_Game_Escape",
		nil,
	})
	TppSequence.RegisterSequenceTable(sequences)
end

this.saveVarsList = {

	isCallsavannahRadio = false,
	isRadioAppendHint = false,
	isRadioHostageHint = false,

	isHearJackal = false,
	isAnnounceSnipePoint = false,
	isArrivedSnipePoint = false,

	isHearEquip1 = false,
	isHearEquip2 = false,

	isGetIntel = false,

	isTargetArrivedSwamp = false,
	isTargetGoSwampSouth = false,
	VipEliminatedType = 0,
	isAninalKill = false,

	isTargetFound = false,

	HostageRescue = 0,
	GuardEliminate = 0,
	BonusEnemyKill = 0,
	isVipAnimalKill = 0,

	isCarried = false,
	isHearCarryTalk = false,
	isHearCarryhos1 = false,
	isHearCarryhos2 = false,
	isHearCarryhos3 = false,
	isHearCarryhos4 = false,
	isHearMarrila = false,

	HostageTalkCount = 0,

	vipTalkCount = 0,
	guardTalkCount1 = 0,
	guardTalkCount2 = 0,
	guardTalkCount3 = 0,
	guardTalkCount4 = 0,

	medicTalkCount = 0,

	isSwampBeforeGetDocument = false,
	isTimeOut = false,

	isReserve_01 = false,
	isReserve_02 = false,
	isReserve_03 = false,
	isReserve_04 = false,
	isReserve_05 = false,
	isReserve_06 = false,
	isReserve_07 = false,
	isReserve_08 = false,
	isReserve_09 = false,
	isReserve_10 = false,
	isReserve_11 = false,
	isReserve_12 = false,
	isReserve_13 = false,
	isReserve_14 = false,
	isReserve_15 = false,
	isReserve_16 = false,
	isReserve_17 = false,
	isReserve_18 = false,
	isReserve_19 = false,
	isReserve_20 = false,

	ldReserve_01 = 0,
	ldReserve_02 = 0,
	ldReserve_03 = 0,
	ldReserve_04 = 0,
	ldReserve_05 = 0,
	ldReserve_06 = 0,
	ldReserve_07 = 0,
	ldReserve_08 = 0,
	ldReserve_09 = 0,
	ldReserve_10 = 0,
	ldReserve_11 = 0,
	ldReserve_12 = 0,
	ldReserve_13 = 0,
	ldReserve_14 = 0,
	ldReserve_15 = 0,
	ldReserve_16 = 0,
	ldReserve_17 = 0,
	ldReserve_18 = 0,
	ldReserve_19 = 0,
	ldReserve_20 = 0,

	isTargetDead = false,
}

this.missionVarsList = {
	EscapeRadioGroups,
}

this.checkPointList = {
	"CHK_MissionStart",
	"CHK_GetSavCassette",
	nil,
}

this.baseList = {
	"savannah",
	"swamp",
	"swampEast",
	"swampSouth",
	"pfCampNorth",
	"savannahWest",
	"savannahEast",
	"bananaSouth",
	"swampWest",
	nil,
}

this.REVENGE_MINE_LIST = { "mafr_swamp", "mafr_savannah" }

this.MISSION_REVENGE_MINE_LIST = {
	["mafr_swamp"] = {
		decoyLocatorList = {
			"itm_revDecoy_swamp_b_0005",
			"itm_revDecoy_swamp_b_0006",
			"itm_revDecoy_swamp_b_0007",
		},

		["trap_mafr_swamp_mine_south"] = {
			mineLocatorList = {
				"itm_revMine_swamp_a_0010",
				"itm_revMine_swamp_a_0011",
			},
		},

		["trap_mafr_swamp_mine_west"] = {
			mineLocatorList = {
				"itm_revMine_swamp_a_0012",
			},
		},
	},

	["mafr_savannah"] = {
		["trap_mafr_savannah_mine_south1"] = {
			mineLocatorList = {
				"itm_revMine_savannah_a_0014",
			},
			decoyLocatorList = {
				"itm_revDecoy_savannah_b_0010",
				"itm_revDecoy_savannah_b_0011",
			},
		},
		["trap_mafr_savannah_mine_south2"] = {
			mineLocatorList = {
				"itm_revMine_savannah_a_0010",
				"itm_revMine_savannah_a_0011",
				"itm_revMine_savannah_a_0012",
				"itm_revMine_savannah_a_0013",
			},
			decoyLocatorList = {
				"itm_revDecoy_savannah_b_0007",
				"itm_revDecoy_savannah_b_0009",
			},
		},

		["trap_mafr_savannah_mine_north"] = {
			mineLocatorList = {
				"itm_revMine_savannah_a_0018",
				"itm_revMine_savannah_a_0019",
			},
			decoyLocatorList = {
				"itm_revDecoy_savannah_b_0008",
			},
		},
		["trap_mafr_savannah_mine_west"] = {
			mineLocatorList = {
				"itm_revMine_savannah_a_0015",
				"itm_revMine_savannah_a_0016",
				"itm_revMine_savannah_a_0017",
			},
			decoyLocatorList = {
				"itm_revDecoy_savannah_b_0005",
				"itm_revDecoy_savannah_b_0006",
			},
		},
	},
}

this.missionObjectiveDefine = {

	default_area_savannah = {
		gameObjectName = "TppMarker2Locator_savannah",
		visibleArea = 4,
		randomRange = 0,
		viewType = "map_only_icon",
		setNew = false,
		announceLog = "updateMap",
		mapRadioName = "s0211_mprg0020",
		langId = "marker_unkown_info",
	},

	default_area_savannah_arrived = {
		gameObjectName = "TppMarker2Locator_savannah",
		visibleArea = 4,
		randomRange = 0,
		viewType = "map_only_icon",
		setNew = false,
		announceLog = "updateMap",
		mapRadioName = "s0211_mprg0022",
		langId = "marker_unkown_info",
	},

	default_s10211_TargetArea02 = {
		gameObjectName = "TppMarker2Locator_TargetArea",
		visibleArea = 6,
		randomRange = 0,
		viewType = "map_only_icon",
		setNew = false,
		announceLog = "updateMap",
		mapRadioName = "s0211_mprg0010",
		langId = "marker_info_mission_targetArea",
	},

	add_area_swampSouth = {
		gameObjectName = "TppMarker2Locator_swampSouth",
		visibleArea = 0,
		randomRange = 0,
		viewType = "map_only_icon",
		announceLog = "updateMap",
	},

	search_Item_InfoTape = {
		gameObjectName = "TppMarker2Locator_InfoTape",
		visibleArea = 1,
		viewType = "map_only_icon",
		setNew = true,
		mapRadioName = "s0211_mprg0023",
		announceLog = "updateMap",
		langId = "marker_unkown_info",
	},

	Interrogation_InfoTape = {
		gameObjectName = "TppMarker2Locator_InterInfoTape",
		langId = "marker_infomation",
		visibleArea = 1,
		viewType = "map_only_icon",
		setNew = true,
		mapRadioName = "s0211_mprg0021",
		announceLog = "updateMap",
		langId = "marker_information",
	},
	area_Intel = {
		gameObjectName = "TppMarker2Locator_InterIcon",
	},

	area_Intel_get = {},

	add_TargetRoute = {
		showEnemyRoutePoints = {
			groupIndex = 0,
			width = 200.0,
			langId = "marker_target_forecast_path",
			radioGroupName = "s0211_mprg2010",
			points = {
				Vector3(108.4, 0.0, 94.1),
				Vector3(375.0, 0.0, 277.7),
				Vector3(851.6, 0.0, 344.8),
			},
		},
	},

	add_TargetGoal = {
		gameObjectName = "TppMarker2Locator_swamp",
		visibleArea = 4,
		randomRange = 0,
		viewType = "map_only_icon",
		setNew = false,
		announceLog = "updateMap",
		mapRadioName = "s0211_mprg2020",
	},

	add_TargetHint = {
		gameObjectName = "TppMarker2Locator_swamp",
		visibleArea = 4,
		randomRange = 0,
		viewType = "map_only_icon",
		setNew = false,
		announceLog = "updateMap",
		mapRadioName = "s0211_mprg2020",
	},

	add_TargetGoal_afterArrivalAndGetIntel = {
		gameObjectName = "TppMarker2Locator_swamp",
		visibleArea = 3,
		randomRange = 0,
		viewType = "map_only_icon",
		setNew = false,
		announceLog = "updateMap",
		mapRadioName = "s0211_mprg4020",
	},

	target_s10211_vip_swamp = {
		gameObjectName = TARGET_NAME,
		goalType = "attack",
		viewType = "map_and_world_only_icon",
		setNew = true,
		setImportant = true,
		announceLog = "updateMap",
		mapRadioName = "s0211_mprg4010",
		langId = "marker_info_mission_target",
	},

	hos_subTarget_0000 = {
		gameObjectName = "hos_mis_0000",
		goalType = "none",
		viewType = "map_and_world_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",
		mapRadioName = "f1000_esrg0760",
	},

	hos_subTarget_0001 = {
		gameObjectName = "hos_mis_0001",
		goalType = "none",
		viewType = "map_and_world_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",
		mapRadioName = "f1000_esrg0760",
	},

	hos_subTarget_0002 = {
		gameObjectName = "hos_mis_0002",
		goalType = "none",
		viewType = "map_and_world_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",
		mapRadioName = "f1000_esrg0760",
	},

	hos_subTarget_0003 = {
		gameObjectName = "hos_mis_0003",
		goalType = "none",
		viewType = "map_and_world_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",
		mapRadioName = "f1000_esrg0760",
	},

	marker_jackal_00 = {
		gameObjectName = "TppMarker2Locator_jackal_00",
		visibleArea = 1,
		viewType = "map_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_area_wildlife",
		mapRadioName = "f1000_rtrg2930",
	},
	marker_jackal_01 = {
		gameObjectName = "TppMarker2Locator_jackal_01",
		visibleArea = 1,
		viewType = "map_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_area_wildlife",
		mapRadioName = "f1000_rtrg2930",
	},
	marker_jackal_02 = {
		gameObjectName = "TppMarker2Locator_jackal_02",
		visibleArea = 1,
		viewType = "map_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_area_wildlife",
		mapRadioName = "f1000_rtrg2930",
	},
	marker_jackal_03 = {
		gameObjectName = "TppMarker2Locator_jackal_03",
		visibleArea = 1,
		viewType = "map_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_area_wildlife",
		mapRadioName = "f1000_rtrg2930",
	},
	marker_jackal_04 = {
		gameObjectName = "TppMarker2Locator_jackal_04",
		visibleArea = 1,
		viewType = "map_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_area_wildlife",
		mapRadioName = "f1000_rtrg2930",
	},
	marker_jackal_05 = {
		gameObjectName = "TppMarker2Locator_jackal_05",
		visibleArea = 1,
		viewType = "map_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_area_wildlife",
		mapRadioName = "f1000_rtrg2930",
	},
	delete_marker_jackal = {},

	snipePointMarker = {
		gameObjectName = "TppMarker2Locator_snipePoint",
		visibleArea = 2,
		randomRange = 0,
		viewType = "map_only_icon",
		mapRadioName = "s0211_mprg1000",
		announceLog = "updateMap",
		langId = "marker_info_vantage_point",
	},

	rv_missionClearRV01 = {},
	rv_missionClearRV02 = {},

	default_photo_target = {
		photoId = PHOTO_NAME.TARGET,
		addFirst = true,
		addSecond = false,
		isComplete = false,
		photoRadioName = "s0211_mirg0010",
	},

	clear_photo_target = {
		photoId = PHOTO_NAME.TARGET,
		addFirst = true,
		addSecond = false,
		isComplete = false,
	},

	default_subGoal = {
		subGoalId = 0,
	},
	killTarget_subGoal = {
		subGoalId = 1,
	},
	escape_subGoal = {
		subGoalId = 3,
	},

	task0_default = { missionTask = { taskNo = 0, isNew = true, isComplete = false } },

	task2_default = { missionTask = { taskNo = 2, isNew = true, isComplete = false } },
	task3_default = { missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide = true } },
	task4_default = { missionTask = { taskNo = 4, isNew = true, isComplete = false, isFirstHide = true } },
	task5_default = { missionTask = { taskNo = 5, isNew = true, isComplete = false, isFirstHide = true } },
	task6_default = { missionTask = { taskNo = 6, isNew = true, isComplete = false, isFirstHide = true } },

	task0_complete = { missionTask = { taskNo = 0, isComplete = true } },

	task2_complete = { missionTask = { taskNo = 2, isComplete = true } },
	task3_complete = { missionTask = { taskNo = 3, isComplete = true } },
	task4_complete = { missionTask = { taskNo = 4, isComplete = true } },
	task5_complete = { missionTask = { taskNo = 5, isComplete = true } },
	task6_complete = { missionTask = { taskNo = 6, isComplete = true } },

	target_arrived_swamp = {},

	announce_TargetKilled = { announceLog = "eliminateTarget" },
	announce_TargetRecovered = { announceLog = "recoverTarget" },

	announce_AllObjectiveFinish = { announceLog = "achieveAllObjectives" },

	hud_photo_target = {
		hudPhotoId = 10,
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
	clear_photo_target = {
		target_s10211_vip_swamp = {
			add_TargetGoal_afterArrivalAndGetIntel = {
				target_arrived_swamp = {
					add_area_swampSouth = {},
					snipePointMarker = {},
					add_TargetRoute = {},
					add_TargetGoal = {
						add_TargetHint = {},
						default_s10211_TargetArea02 = {},
						area_Intel_get = {
							area_Intel = {
								Interrogation_InfoTape = {},
								search_Item_InfoTape = {
									default_area_savannah_arrived = {
										default_area_savannah = {},
									},
								},
							},
						},
					},
				},
			},
		},
		announce_TargetKilled = {},
		announce_TargetRecovered = {},
		announce_AllObjectiveFinish = {},
		default_photo_target = {},
	},

	delete_marker_jackal = {
		marker_jackal_00 = {},
		marker_jackal_01 = {},
		marker_jackal_02 = {},
		marker_jackal_03 = {},
		marker_jackal_04 = {},
		marker_jackal_05 = {},
	},
}

this.missionObjectiveEnum = Tpp.Enum({
	"default_area_savannah",
	"default_s10211_TargetArea02",
	"add_area_swampSouth",
	"search_Item_InfoTape",
	"Interrogation_InfoTape",
	"add_TargetRoute",
	"add_TargetGoal",
	"add_TargetGoal_afterArrivalAndGetIntel",

	"area_Intel",
	"area_Intel_get",

	"target_s10211_vip_swamp",
	"rv_missionClearRV01",
	"rv_missionClearRV02",
	"default_photo_target",
	"snipePointMarker",

	"default_subGoal",
	"killTarget_subGoal",
	"escape_subGoal",

	"hos_subTarget_0000",
	"hos_subTarget_0001",
	"hos_subTarget_0002",
	"hos_subTarget_0003",

	"task0_default",

	"task2_default",
	"task3_default",
	"task4_default",
	"task5_default",
	"task6_default",

	"task0_complete",

	"task2_complete",
	"task3_complete",
	"task4_complete",
	"task5_complete",
	"task6_complete",

	"marker_jackal_00",
	"marker_jackal_01",
	"marker_jackal_02",
	"marker_jackal_03",
	"marker_jackal_04",
	"marker_jackal_05",
	"delete_marker_jackal",
	"add_TargetHint",
	"default_area_savannah_arrived",
	"clear_photo_target",

	"target_arrived_swamp",
	"announce_TargetKilled",
	"announce_TargetRecovered",
	"announce_AllObjectiveFinish",
	"hud_photo_target",
})

this.missionStartPosition = {

	orderBoxList = {
		"box_s10211_00",
		"box_s10211_01",
	},

	helicopterRouteList = {
		"lz_drp_bananaSouth_N0000|rt_drp_bananaSouth_N_0000",
		"lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000",
		"lz_drp_swamp_S0000|rt_drp_swamp_S_0000",
		"lz_drp_swamp_I0000|rt_drp_swamp_I_0000",
		"lz_drp_savannah_I0000|rt_drp_savannah_I_0000",
	},
}

local InterrogationCpList = {
	"mafr_savannahWest_ob",
	"mafr_bananaSouth_ob",
}

local AnimalCpList = {
	"mafr_savannahWest_ob",
	"mafr_bananaSouth_ob",
	"mafr_04_07_lrrp",
}
local CfaOBList = {
	"mafr_savannahEast_ob",
	"mafr_swampSouth_ob",
	"mafr_swampEast_ob",
	"mafr_pfCampNorth_ob",
}

local CfaCPList = {
	"mafr_savannah_cp",
	"mafr_swamp_cp",
}

local CfaHintList = {
	"mafr_savannahEast_ob",
	"mafr_swampSouth_ob",
	"mafr_swampEast_ob",
	"mafr_pfCampNorth_ob",
	"mafr_swamp_cp",
}
function this.HighInterrogation()
	Fox.Log("#####################HighInterrogation")
	local sequence = TppSequence.GetCurrentSequenceName()

	if (sequence == "Seq_Game_BeforeGetDocument") or (sequence == "Seq_Game_AfterGetDocument") then
		TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("cp_swamp_vip"), {

			{ name = s10211_enemy.LABEL_GUARD_REACTION_00, func = s10211_enemy.InterCall_GuardReaction_00 },
			{ name = s10211_enemy.LABEL_GUARD_REACTION_01, func = s10211_enemy.InterCall_GuardReaction_01 },
		})

		TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("mafr_savannah_cp"), {
			{ name = s10211_enemy.LABEL_INTEL, func = s10211_enemy.InterCall_Inter },
			{ name = s10211_enemy.LABEL_HOSTAGE, func = s10211_enemy.InterCall_Hostage },
		})
		TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("mafr_swamp_cp"), {
			{ name = s10211_enemy.LABEL_HOSTAGE, func = s10211_enemy.InterCall_Hostage },
		})

		TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("mafr_04_07_lrrp"), {
			{ name = s10211_enemy.LABEL_ROGUE_COYOTE_00, func = s10211_enemy.InterCall_SearchUnit1 },
			{ name = s10211_enemy.LABEL_ROGUE_COYOTE_01, func = s10211_enemy.InterCall_SearchUnit2 },
			{ name = s10211_enemy.LABEL_JACKAL, func = s10211_enemy.InterCall_WildAnimal },
		})

		this.AddHighInterrogationVipEquip()

		this.AddHighInterrogationRogueCoyote()
	elseif sequence == "Seq_Game_Escape" then
	else
	end

	Fox.Log("End HighInterrogation")
end

function this.AddHighInterrogationRogueCoyote()
	for i, cp in pairs(InterrogationCpList) do
		Fox.Log(cp)
		TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId(cp), {
			{ name = s10211_enemy.LABEL_JACKAL, func = s10211_enemy.InterCall_WildAnimal },
			{ name = s10211_enemy.LABEL_ROGUE_COYOTE_00, func = s10211_enemy.InterCall_SearchUnit1 },
			{ name = s10211_enemy.LABEL_ROGUE_COYOTE_01, func = s10211_enemy.InterCall_SearchUnit2 },
		})
	end
end

function this.DeleteHighInterrogationAboutAnimal()
	for i, cp in pairs(AnimalCpList) do
		Fox.Log(cp)
		TppInterrogation.RemoveHighInterrogation(GameObject.GetGameObjectId(cp), {
			{ name = s10211_enemy.LABEL_JACKAL, func = s10211_enemy.InterCall_WildAnimal },
		})
	end
end

function this.AddHighInterrogationVipEquip()
	for i, cp in pairs(CfaOBList) do
		Fox.Log(cp)
		TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId(cp), {
			{ name = s10211_enemy.LABEL_TARGET_EQUIPMENT_00, func = s10211_enemy.InterCall_VipEquip1 },
			{ name = s10211_enemy.LABEL_TARGET_EQUIPMENT_01, func = s10211_enemy.InterCall_VipEquip2 },
		})
	end
end

function this.DeleteHighInterrogationVipEquip()
	for i, cp in pairs(CfaOBList) do
		Fox.Log(cp)
		TppInterrogation.RemoveHighInterrogation(GameObject.GetGameObjectId(cp), {
			{ name = s10211_enemy.LABEL_TARGET_EQUIPMENT_00, func = s10211_enemy.InterCall_VipEquip1 },
			{ name = s10211_enemy.LABEL_TARGET_EQUIPMENT_01, func = s10211_enemy.InterCall_VipEquip2 },
		})
	end
end

function this.AddHighInterrogationTargetGoal()
	for i, cp in pairs(CfaOBList) do
		Fox.Log(cp)
		TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId(cp), {
			{ name = s10211_enemy.LABEL_TARGET_AREA, func = s10211_enemy.InterCall_TargetGoal },
		})
	end
end

function this.DeleteHighInterrogationTargetGoal()
	for i, cp in pairs(CfaHintList) do
		Fox.Log(cp)
		TppInterrogation.RemoveHighInterrogation(GameObject.GetGameObjectId(cp), {
			{ name = s10211_enemy.LABEL_TARGET_AREA, func = s10211_enemy.InterCall_TargetGoal },
		})
	end
end

function this.DeleteHighInterrogationHostage()
	for i, cp in pairs(CfaCPList) do
		Fox.Log(cp)
		TppInterrogation.RemoveHighInterrogation(GameObject.GetGameObjectId(cp), {
			{ name = s10211_enemy.LABEL_HOSTAGE, func = s10211_enemy.InterCall_Hostage },
		})
	end
end

function this.AddHighInterrogationTargetPosition()
	TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("mafr_swamp_cp"), {
		{ name = s10211_enemy.LABEL_TARGET_POSITION, s10211_enemy = this.InterCall_VipSwamp },
	})
end

function this.DeleteHighInterrogationTargetPosition()
	TppInterrogation.RemoveHighInterrogation(GameObject.GetGameObjectId("mafr_swamp_cp"), {
		{ name = s10211_enemy.LABEL_TARGET_POSITION, s10211_enemy = this.InterCall_VipSwamp },
	})
end

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	GkEventTimerManager.Stop("Timer_Timeout")
	GkEventTimerManager.Start("Timer_Timeout", TIMER_TIME)

	GkEventTimerManager.Stop("Timer_Hint")
	GkEventTimerManager.Start("Timer_Hint", TIMER_NO_HINT)

	this.RegiserMissionSystemCallback()

	TppMarker.SetUpSearchTarget({
		{
			gameObjectName = s10211_enemy.ENEMY_NAME.TARGET,
			gameObjectType = "TppSoldier2",
			messageName = s10211_enemy.ENEMY_NAME.TARGET,
			skeletonName = "SKL_004_HEAD",
			func = this.TargetFound,
		},
	})

	TppPlayer.AddTrapSettingForIntel({
		intelName = "Intel_savannah",
		autoIcon = true,
		identifierName = "GetIntelIdentifier",
		locatorName = "GetIntel_savannah",
		gotFlagName = "isGetIntel",
		trapName = "trap_GetIntel_savannah",
		direction = 100,
		markerObjectiveName = "area_Intel",
		markerTrapName = "trap_ItemDocument",
	})

	TppMission.RegisterMissionSystemCallback({
		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllVipClear()
		end,

		OnRecovered = function(gameObjectId)
			local allRecovred = true
			for index, targetName in ipairs(this.TASK_VIP_SOLO_GROUP) do
				if TppEnemy.IsRecovered(targetName) == false then
					allRecovred = false
				end
			end

			if allRecovred then
				this.vipTaskCheckRecover()
			end

			allRecovred = true
			local everCount = false
			for index, targetName in ipairs(this.TASK_VIP_SQUAD_GROUP) do
				if TppEnemy.IsRecovered(targetName) == false then
					allRecovred = false
				else
					if everCount == false then
						everCount = true
						Fox.Log("##Recovered " .. gameObjectId)
						if
							gameObjectId == GameObject.GetGameObjectId(s10211_enemy.ENEMY_NAME.TARGET)
							and svars.isReserve_15 == true
						then
							Fox.Log("# vip already extract by heli #")
						elseif
							gameObjectId == GameObject.GetGameObjectId(s10211_enemy.ENEMY_NAME.FOLLOWER01)
							and svars.isReserve_08 == true
						then
							Fox.Log("# guard1 already extract by heli #")
						elseif
							gameObjectId == GameObject.GetGameObjectId(s10211_enemy.ENEMY_NAME.FOLLOWER02)
							and svars.isReserve_09 == true
						then
							Fox.Log("# guard2 already extract by heli #")
						elseif
							gameObjectId == GameObject.GetGameObjectId(s10211_enemy.ENEMY_NAME.FOLLOWER03)
							and svars.isReserve_10 == true
						then
							Fox.Log("# guard3 already extract by heli #")
						elseif
							gameObjectId == GameObject.GetGameObjectId(s10211_enemy.ENEMY_NAME.FOLLOWER04)
							and svars.isReserve_11 == true
						then
							Fox.Log("# guard4 already extract by heli #")
						elseif
							gameObjectId == GameObject.GetGameObjectId(s10211_enemy.ENEMY_NAME.FOLLOWER05)
							and svars.ldReserve_05 == 1
						then
							Fox.Log("# guard5 already extract by heli #")
						else
							this.GuardTaskCheckRecover()
						end
					end
				end
			end

			allRecovred = true
			everCount = false
			for index, targetName in ipairs(this.TASK_HOSTAGE_GROUP) do
				if TppEnemy.IsRecovered(targetName) == false then
					allRecovred = false
				else
					if everCount == false then
						everCount = true

						if gameObjectId == GameObject.GetGameObjectId(s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00) then
							Fox.Log("***** HOSTAGE_00　  *****")
							if svars.isReserve_17 == false then
								svars.isReserve_17 = true
								Fox.Log("***** HOSTAGE_00　 recovered *****")

								this.HostageTaskCheckRecover()
							end
						elseif
							gameObjectId == GameObject.GetGameObjectId(s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01)
						then
							Fox.Log("***** HOSTAGE_01  *****")
							if svars.isReserve_18 == false then
								svars.isReserve_18 = true
								Fox.Log("***** HOSTAGE_01　 recovered *****")
								this.HostageTaskCheckRecover()
							end
						elseif
							gameObjectId == GameObject.GetGameObjectId(s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_02)
						then
							Fox.Log("***** HOSTAGE_02  *****")
							if svars.isReserve_19 == false then
								svars.isReserve_19 = true
								Fox.Log("***** HOSTAGE_02　 recovered *****")

								this.HostageTaskCheckRecover()
							end
						else
							Fox.Log("***** HOSTAGE_03  *****")
							if svars.isReserve_20 == false then
								svars.isReserve_20 = true
								Fox.Log("***** HOSTAGE_03　 recovered *****")
								this.HostageTaskCheckRecover()
							end
						end
					end
				end
			end
		end,
	})

	TppRatBird.EnableRat()
	TppRatBird.EnableBird("TppEagle")
end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	TppUiCommand.InitEnemyRoutePoints(0)

	TppRevenge.RegisterMissionMineList(this.MISSION_REVENGE_MINE_LIST)
end

function this.RegiserMissionSystemCallback()
	Fox.Log("*** RegiserMissionSystemCallback ***")

	local systemCallbackTable = {
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		nil,
	}

	TppMission.RegisterMissionSystemCallback(systemCallbackTable)
end

this.OnEstablishMissionClear = function(missionClearType)
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

	local tmp = svars.isTargetDead
	if svars.isTargetDead then
	else
		s10211_radio.TelephoneRadio()
	end
end

function this.Messages()
	return StrCode32Table({
		Player = {

			{
				msg = "Exit",
				sender = "hotZone",
				func = function() end,
			},

			{
				msg = "GetIntel",
				sender = "Intel_savannah",
				func = function()
					this.OnGetIntel_savannah()
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

			nil,
		},

		Weather = {
			{
				msg = "Clock",
				sender = "OnMorning",
				func = function(sender, time)
					s10211_enemy.SetWolfRouteDayTime()
				end,
			},
			{
				msg = "Clock",
				sender = "OnNight",
				func = function(sender, time)
					s10211_enemy.SetWolfRouteNightTime()
				end,
			},
		},

		Timer = {

			{
				msg = "Finish",
				sender = "Timer_Hint",
				func = function()
					svars.isReserve_12 = true

					svars.isReserve_04 = false
					svars.isReserve_05 = false
					svars.isReserve_06 = false
					svars.isReserve_07 = false
				end,
			},

			{
				msg = "Finish",
				sender = "Timer_Timeout",
				func = function()
					svars.isTimeOut = true

					svars.isReserve_04 = false
					svars.isReserve_05 = false
					svars.isReserve_06 = false
					svars.isReserve_07 = false

					if
						svars.isGetIntel == false
						and svars.isTargetArrivedSwamp == false
						and svars.isTargetFound == false
					then
						this.AddHighInterrogationTargetGoal()

						TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("mafr_swamp_cp"), {
							{ name = s10211_enemy.LABEL_TARGET_AREA, func = s10211_enemy.InterCall_TargetGoal },
						})
					end
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
			nil,
		},

		Radio = {
			{
				msg = "Finish",
				func = function(arg0)
					if arg0 == StrCode32("s0211_oprg2005") then
						Fox.Log("#### s0211_oprg2005 Finish ####")
						svars.isAnnounceSnipePoint = true
						if svars.isTargetFound == false then
							TppMission.UpdateObjective({ objectives = { "snipePointMarker" } })

							TppRadio.SetOptionalRadio("Set_s0211_oprg0022")
						end
					elseif arg0 == StrCode32("s0211_esrg0051") then
						Fox.Log("#### s0211_esrg0051 Finish ####")

						if svars.isTargetFound == false then
							TppRadio.ChangeIntelRadio(s10211_radio.intelRadioListTargetNotFoundTwice)
						end

						TppRadio.ChangeIntelRadio(s10211_radio.intelRadioListRogueCoyoteTwice)
					end
				end,
			},
		},

		Trap = {

			{
				msg = "Enter",
				sender = "trap_swamp",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if svars.isReserve_02 == false then
							svars.isReserve_02 = true
							if svars.isTargetArrivedSwamp == true then
								if svars.isTargetFound == true then
									s10211_radio.SwampVipArrivedIdentified()
								else
									s10211_radio.SwampVipArrivedNotIdentified()
								end
							else
								if svars.isGetIntel == true then
									s10211_radio.SwampAfterGetDocument()
								else
									if svars.isTimeOut == true then
										if
											svars.isReserve_13 == false
											and svars.isReserve_14 == false
											and svars.isTargetFound == false
										then
											s10211_radio.SwampBeforeGetDocumentTimeOut()
										end
									else
										s10211_radio.SwampBeforeGetDocument()
									end
								end
							end
						end
					end
				end,
			},

			{
				msg = "Exit",
				sender = "trap_swamp",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if svars.isTargetFound == true and svars.isTargetArrivedSwamp == true then
							TppRadio.SetOptionalRadio("Set_s0211_oprg2001")
						end
					end
				end,
			},
			{
				msg = "Enter",
				sender = "trap_swamp_for_vip",
				func = function()
					Fox.Log("#### target enter swamp ####")

					if svars.isTargetArrivedSwamp == false then
						svars.isTargetArrivedSwamp = true
						TppUiCommand.SetMisionInfoCurrentStoryNo(1)
						this.DeleteHighInterrogationTargetGoal()
						this.AddHighInterrogationTargetPosition()
						TppMission.UpdateObjective({ objectives = { "add_TargetGoal_afterArrivalAndGetIntel" } })
						svars.isReserve_02 = false
						s10211_enemy.SetVipGroupSwampCautionRoute()

						s10211_radio.VipArrivedSwamp()
						if svars.isTargetFound == true then
							TppRadio.SetOptionalRadio("Set_s0211_oprg0021")
						else
							TppRadio.SetOptionalRadio("Set_s0211_oprg2000")
						end
					end
				end,
			},

			{
				msg = "Enter",
				sender = "trap_swampSouth",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if svars.isTargetArrivedSwamp == false then
							if svars.isReserve_04 == false then
								if svars.isTimeOut == true then
									if
										svars.isReserve_13 == false
										and svars.isReserve_14 == false
										and svars.isTargetFound == false
									then
										s10211_radio.OuterBaseBeforeGetDocumentTimeOut()
									end
								elseif svars.isGetIntel == false then
									s10211_radio.OuterBaseBeforeGetDocument()
								else
									Fox.Log("*** trap_swampSouth: GetIntel,not TimeOut ***")
								end
								svars.isReserve_04 = true
							end
						else
							TppRadio.SetOptionalRadio("Set_s0211_oprg3010")
						end
					end
				end,
			},
			{
				msg = "Enter",
				sender = "trap_swampEast",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if svars.isTargetArrivedSwamp == false then
							if svars.isReserve_05 == false then
								if svars.isTimeOut == true then
									if
										svars.isReserve_13 == false
										and svars.isReserve_14 == false
										and svars.isTargetFound == false
									then
										s10211_radio.OuterBaseBeforeGetDocumentTimeOut()
									end
								elseif svars.isGetIntel == false then
									s10211_radio.OuterBaseBeforeGetDocument()
								else
									Fox.Log("*** trap_swampEast: GetIntel,not TimeOut ***")
								end
							end
							svars.isReserve_05 = true
						end
					end
				end,
			},
			{
				msg = "Enter",
				sender = "trap_savannahEast",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if svars.isTargetArrivedSwamp == false then
							if svars.isReserve_06 == false then
								if svars.isTimeOut == true then
									if
										svars.isReserve_13 == false
										and svars.isReserve_14 == false
										and svars.isTargetFound == false
									then
										s10211_radio.OuterBaseBeforeGetDocumentTimeOut()
									end
								elseif svars.isGetIntel == false then
									s10211_radio.OuterBaseBeforeGetDocument()
								else
									Fox.Log("*** trap_savannahEast: GetIntel,not TimeOut ***")
								end
							end
							svars.isReserve_06 = true
						end
					end
				end,
			},
			{
				msg = "Enter",
				sender = "trap_pfCampNorth",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if svars.isTargetArrivedSwamp == false then
							if svars.isReserve_07 == false then
								if svars.isTimeOut == true then
									if
										svars.isReserve_13 == false
										and svars.isReserve_14 == false
										and svars.isTargetFound == false
									then
										s10211_radio.OuterBaseBeforeGetDocumentTimeOut()
									end
								elseif svars.isGetIntel == false then
									s10211_radio.OuterBaseBeforeGetDocument()
								else
									Fox.Log("*** trap_pfCampNorth: GetIntel,not TimeOut ***")
								end
							end
						end
						svars.isReserve_07 = true
					end
				end,
			},

			{
				msg = "Enter",
				sender = "trap_savannahWest",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if
							svars.isTargetArrivedSwamp == false
							and svars.isTargetFound == false
							and svars.isReserve_13 == true
						then
							s10211_radio.GetOutRogueCoyoteOb()
						end
					end
				end,
			},

			{
				msg = "Enter",
				sender = "trap_bananaSouth",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if
							svars.isTargetArrivedSwamp == false
							and svars.isTargetFound == false
							and svars.isReserve_13 == true
						then
							s10211_radio.GetOutRogueCoyoteOb()
						end
					end
				end,
			},

			{

				msg = "Enter",
				sender = "trap_SnipePoint",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if svars.isAnnounceSnipePoint == true then
							if svars.isTargetArrivedSwamp == false then
								TppRadio.SetOptionalRadio("Set_s0211_oprg0030")

								if svars.isArrivedSnipePoint == false then
									svars.isArrivedSnipePoint = true

									local type = Player.GetEquipTypeIdBySlot(PlayerSlotType.PRIMARY_2, 0)
									if type == TppEquip.EQP_TYPE_Sniper then
										s10211_radio.SnipePointEquipSniperrifle()
									else
										if this.CheckDevelopSniperRifle() == true then
											s10211_radio.SnipePointDeveloppedSniperrifle()
										else
											s10211_radio.SnipePointNotDeveloppedSniperrifle()
										end
									end
								end
							end
						end
					end
				end,
			},
			{

				msg = "Exit",
				sender = "trap_OuterSnipePoint",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence == "Seq_Game_Escape" then
					else
						if svars.isAnnounceSnipePoint == true then
							if svars.isTargetArrivedSwamp == false then
								TppRadio.SetOptionalRadio("Set_s0211_oprg0021")
							end
						end
					end
				end,
			},
		},

		GameObject = {
			{
				msg = "HeliDoorClosed",
				sender = "SupportHeli",
				func = function()
					if TppEnemy.CheckAllVipClear() then
						Fox.Log("All vip neutralize and exit hotzone")
						TppMission.CanMissionClear()
					end
				end,
			},

			{

				msg = "MonologueEnd",
				sender = {
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_02,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_03,
					nil,
				},
				func = function(gameObjectId, speechLabel, isSuccess)
					if
						(speechLabel == StrCode32("speech211_carry010") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry011") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry012") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry013") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry014") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry015") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry016") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry017") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry018") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry019") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry020") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry021") and isSuccess ~= 0)
						or (speechLabel == StrCode32("speech211_carry022") and isSuccess ~= 0)
					then
						if svars.HostageTalkCount < HOSTAGE_TALK_MAX then
							svars.HostageTalkCount = svars.HostageTalkCount + 1
							if svars.HostageTalkCount == HOSTAGE_TALK_MARRILA then
								if svars.isHearMarrila == true then
									return
								else
									svars.isHearMarrila = true
								end
							end
						else
							svars.HostageTalkCount = HOSTAGE_TALK_LOOP
							return
						end

						if svars.isHearCarryhos1 == true then
							s10211_enemy.CallMonologueHostageHos1()
						elseif svars.isHearCarryhos2 == true then
							s10211_enemy.CallMonologueHostageHos2()
						elseif svars.isHearCarryhos3 == true then
							s10211_enemy.CallMonologueHostageHos3()
						elseif svars.isHearCarryhos4 == true then
							s10211_enemy.CallMonologueHostageHos4()
						end
					end
				end,
			},

			{

				msg = "ChangePhase",
				sender = {
					"sol_mis_0001",
					"sol_mis_0000",
					"sol_mis_0002",

					"sol_mis_0003",
					"sol_mis_0004",
					"sol_mis_0005",
				},
				func = function(GameObjectId, phaseName)
					if phaseName >= TppEnemy.PHASE.CAUTION then
						Fox.Log("***** ChangePhase cp_swamp_vip  *****")
						s10211_enemy.SetVipEscapeRoute()
					end
				end,
			},

			{
				msg = "Carried",
				sender = {
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_02,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_03,
					nil,
				},
				func = function(GameObjectId, carriedState)
					if carriedState == 0 then
						if svars.isHearCarryTalk == false then
							svars.isHearCarryTalk = true

							if
								GameObjectId == GameObject.GetGameObjectId(s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00)
							then
								Fox.Log("***** HOSTAGE_00  *****")

								svars.isHearCarryhos1 = true

								s10211_enemy.CallMonologueHostageHos1()
							elseif
								GameObjectId == GameObject.GetGameObjectId(s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01)
							then
								Fox.Log("***** HOSTAGE_01  *****")

								svars.isHearCarryhos2 = true

								s10211_enemy.CallMonologueHostageHos2()
							elseif
								GameObjectId == GameObject.GetGameObjectId(s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_02)
							then
								Fox.Log("***** HOSTAGE_02  *****")

								svars.isHearCarryhos3 = true
								s10211_enemy.CallMonologueHostageHos3()
							else
								Fox.Log("***** HOSTAGE_03  *****")

								svars.isHearCarryhos4 = true
								s10211_enemy.CallMonologueHostageHos4()
							end
						end
					elseif carriedState == 1 then
						svars.isCarried = true
					end
				end,
			},

			{
				msg = "Dead",
				sender = s10211_enemy.ENEMY_NAME.TARGET,
				func = function(nObjevtId, nAttakerId)
					svars.isTargetDead = true
					if svars.isReserve_01 == false then
						svars.isReserve_01 = true
						if nAttakerId == "player_locator_0000" then
							Fox.Log("***** killed by player  *****")
						else
							Fox.Log("***** killed by other  *****")
						end

						if svars.isTargetFound == true then
							if svars.isAninalKill then
								s10211_radio.TargetAnimalkill()
							else
								s10211_radio.TargetDead()
							end
						else
							s10211_radio.TargetDeadNotIdentified()
							TppSoundDaemon.PostEvent("sfx_s_enemytag_main_tgt")
							TppMission.UpdateObjective({ objectives = { "hud_photo_target" } })
						end
						TppSequence.SetNextSequence("Seq_Game_Escape")
					else
						local sequence = TppSequence.GetCurrentSequenceName()
						if sequence ~= "Seq_Game_Escape" then
							Fox.Log("#### EscapeSequence not yet, Set Seq_Game_Escape ####")
							TppSequence.SetNextSequence("Seq_Game_Escape")
							s10211_radio.TargetDead()
						else
							Fox.Log("#### Already enter 　Seq_Game_Escape ####")
						end
					end
				end,
			},

			{
				msg = "Damage",
				sender = s10211_enemy.ENEMY_NAME.TARGET,
				func = function(gameObjectId, attackId)
					for index, animalDeadlyDamage in ipairs(ANIMAL_DEADLY_ATTACK_LIST) do
						if attackId == animalDeadlyDamage then
							Fox.Log("***** Vip Killed By Animal *****")

							svars.isReserve_01 = true

							svars.isAninalKill = true
						else
						end
					end
				end,
			},

			{
				msg = "Fulton",
				sender = {
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_02,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_03,
					nil,
				},
				func = function()
					s10211_radio.FultonHostage()
				end,
			},

			{
				msg = "Fulton",
				sender = {
					"anml_Jackal_00",
					"anml_Jackal_01",
					"anml_Jackal_02",
					"anml_Jackal_03",
					"anml_Jackal_04",
					"anml_Jackal_05",
				},
				func = function(nObjevtId, nAttakerId)
					s10211_radio.FultonJackal()
				end,
			},

			{
				msg = "Fulton",
				sender = s10211_enemy.ENEMY_NAME.TARGET,
				func = function()
					if svars.isReserve_01 == false then
						svars.isReserve_01 = true

						if svars.isTargetFound == true then
							s10211_radio.FultonTarget()
						else
							TppSoundDaemon.PostEvent("sfx_s_enemytag_main_tgt")
							TppMission.UpdateObjective({ objectives = { "hud_photo_target" } })
							s10211_radio.FultonTargetNotIdentified()
						end
					end
					TppSequence.SetNextSequence("Seq_Game_Escape")
				end,
			},

			{
				msg = "Fulton",
				func = function(s_gameObjectId)
					local animalType = GameObject.GetTypeIndex(s_gameObjectId)
					if
						animalType == TppGameObject.GAME_OBJECT_TYPE_JACKAL
						or animalType == TppGameObject.GAME_OBJECT_TYPE_WOLF
					then
						TppMission.UpdateObjective({ objectives = { "task6_complete" } })
					end
				end,
			},

			{
				msg = "FultonFailed",
				sender = s10211_enemy.ENEMY_NAME.TARGET,
				func = function(nGameObjectId, arg1, arg2, type)
					Fox.Log("####fulton failed " .. type)
					if type == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
						if svars.isReserve_01 == false then
							svars.isReserve_01 = true
							if svars.isTargetFound == true then
								s10211_radio.FultonFailed()
							else
								TppSoundDaemon.PostEvent("sfx_s_enemytag_main_tgt")
								TppMission.UpdateObjective({ objectives = { "hud_photo_target" } })
								s10211_radio.FultonFailedNotIdentified()
							end
							TppSequence.SetNextSequence("Seq_Game_Escape")
						else
							Fox.Log("#### Target Already Dead　####")
						end
					else
						Fox.Log("#### Fulton Failed not FULTON_FAILED_TYPE_ON_FINISHED_RISE　####")
					end
				end,
			},
			{
				msg = "PlacedIntoVehicle",
				sender = s10211_enemy.ENEMY_NAME.TARGET,
				func = function(gameObjectId, vehicleId)
					Fox.Log("***** s10211_sequence:TargetPlacedIntoVehicle *****")
					this.TargetPlacedIntoVehicle(vehicleId)
				end,
			},

			{
				msg = "PlacedIntoVehicle",
				sender = s10211_enemy.ENEMY_NAME.FOLLOWER01,
				func = function(nGameObjectId, vehicleId)
					Fox.Log("###PlacedIntoVehicle####")
					if vehicleId == GameObject.GetGameObjectId("SupportHeli") then
						svars.isReserve_08 = true
						this.GuardTaskCheckRecover()
					end
				end,
			},
			{
				msg = "PlacedIntoVehicle",
				sender = s10211_enemy.ENEMY_NAME.FOLLOWER02,
				func = function(nGameObjectId, vehicleId)
					Fox.Log("###PlacedIntoVehicle####")
					if vehicleId == GameObject.GetGameObjectId("SupportHeli") then
						svars.isReserve_09 = true
						this.GuardTaskCheckRecover()
					end
				end,
			},
			{
				msg = "PlacedIntoVehicle",
				sender = s10211_enemy.ENEMY_NAME.FOLLOWER03,
				func = function(nGameObjectId, vehicleId)
					Fox.Log("###PlacedIntoVehicle####")
					if vehicleId == GameObject.GetGameObjectId("SupportHeli") then
						svars.isReserve_10 = true
						this.GuardTaskCheckRecover()
					end
				end,
			},
			{
				msg = "PlacedIntoVehicle",
				sender = s10211_enemy.ENEMY_NAME.FOLLOWER04,
				func = function(nGameObjectId, vehicleId)
					Fox.Log("###PlacedIntoVehicle####")
					if vehicleId == GameObject.GetGameObjectId("SupportHeli") then
						svars.isReserve_11 = true
						this.GuardTaskCheckRecover()
					end
				end,
			},
			{
				msg = "PlacedIntoVehicle",
				sender = s10211_enemy.ENEMY_NAME.FOLLOWER05,
				func = function(nGameObjectId, vehicleId)
					Fox.Log("###PlacedIntoVehicle####")
					if vehicleId == GameObject.GetGameObjectId("SupportHeli") then
						svars.ldReserve_05 = 1
						this.GuardTaskCheckRecover()
					end
				end,
			},
			{
				msg = "PlacedIntoVehicle",
				sender = {
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_02,
					s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_03,
					nil,
				},
				func = function(nGameObjectId, vehicleId)
					Fox.Log("###PlacedIntoVehicle####")
					if vehicleId == GameObject.GetGameObjectId("SupportHeli") then
						s10211_radio.HeliRideHostage()

						if nGameObjectId == GameObject.GetGameObjectId(s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00) then
							Fox.Log("***** HOSTAGE_00 ride heli *****")
							svars.isReserve_17 = true
						elseif
							nGameObjectId == GameObject.GetGameObjectId(s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01)
						then
							Fox.Log("***** HOSTAGE_01 ride heli *****")
							svars.isReserve_18 = true
						elseif
							nGameObjectId == GameObject.GetGameObjectId(s10211_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_02)
						then
							Fox.Log("***** HOSTAGE_02 ride heli *****")
							svars.isReserve_19 = true
						else
							Fox.Log("***** HOSTAGE_03 ride heli *****")
							svars.isReserve_20 = true
						end
						this.HostageTaskCheckRecover()
					end
				end,
			},

			{
				msg = "RoutePoint2",
				sender = s10211_enemy.ENEMY_NAME.TARGET,
				func = function(nObjectId, nRouteId, nRouteNodeId, sendM)
					if sendM == StrCode32("msgVipArrivedSwamp") then
						if svars.isTargetArrivedSwamp == false then
							svars.isTargetArrivedSwamp = true
							TppUiCommand.SetMisionInfoCurrentStoryNo(1)
							this.DeleteHighInterrogationTargetGoal()
							this.AddHighInterrogationTargetPosition()
							TppMission.UpdateObjective({ objectives = { "add_TargetGoal_afterArrivalAndGetIntel" } })
							svars.isReserve_02 = false

							s10211_enemy.SetVipGroupSwampCautionRoute()

							s10211_radio.VipArrivedSwamp()
							if svars.isTargetFound == true then
								TppRadio.SetOptionalRadio("Set_s0211_oprg0021")
							else
								TppRadio.SetOptionalRadio("Set_s0211_oprg2000")
							end
						end
					elseif sendM == StrCode32("msgCautionRouteChange1") then
						svars.ldReserve_02 = ESCAPE_POINT_01
					elseif sendM == StrCode32("msgCautionRouteChange2") then
						svars.ldReserve_02 = ESCAPE_POINT_02
					elseif sendM == StrCode32("msgCautionRouteChange3") then
						svars.ldReserve_02 = ESCAPE_POINT_03
					elseif sendM == StrCode32("msgCautionRouteChange4") then
						svars.ldReserve_02 = ESCAPE_POINT_04
					elseif sendM == StrCode32("msgCautionRouteChange5") then
						svars.ldReserve_02 = ESCAPE_POINT_05
					elseif sendM == StrCode32("msgCaution0000End") then
						svars.ldReserve_02 = ESCAPE_POINT_01
						svars.isReserve_03 = false
						s10211_enemy.ReStartVipTravel()
					elseif sendM == StrCode32("msgCaution0001End") then
						svars.ldReserve_02 = ESCAPE_POINT_02
						svars.isReserve_03 = false
						s10211_enemy.ReStartVipTravel()
					elseif sendM == StrCode32("msgCaution0002End") then
						svars.ldReserve_02 = ESCAPE_POINT_03
						svars.isReserve_03 = false
						s10211_enemy.ReStartVipTravel()
					elseif sendM == StrCode32("msgCaution0003End") then
						svars.ldReserve_02 = ESCAPE_POINT_04
						svars.isReserve_03 = false
						s10211_enemy.ReStartVipTravel()
					elseif sendM == StrCode32("msgCaution0004End") then
						svars.ldReserve_02 = ESCAPE_POINT_05
						svars.isReserve_03 = false
						s10211_enemy.ReStartVipTravel()
					elseif sendM == StrCode32("msgCaution0005End") then
						svars.isReserve_03 = false
						s10211_enemy.ReStartVipTravel()
					else
						Fox.Log("*** Unknown Message ***")
					end
				end,
			},

			{
				msg = "ChangePhase",
				sender = "cp_swamp_vip",
				func = function(gameObjectId, phaseName)
					Fox.Log("s10211_mission message ChangePhase!!" .. phaseName)
					if phaseName == TppEnemy.PHASE.ALERT then
						s10211_enemy.SetEnemyFlag_MovePriority(s10211_enemy.ENEMY_NAME.TARGET, "cl_swamp_1_0006")
						s10211_enemy.SetEnemyFlag_MovePriority(s10211_enemy.ENEMY_NAME.FOLLOWER02, "gt_swamp_0000")
					end
				end,
			},

			{
				msg = "InLocator",
				func = function()
					Fox.Log("#### Enemy InLocator msg ####")
					if svars.isTargetArrivedSwamp == false then
						Fox.Log("#### InLocator:: Vip arrived Swamp ####")
						svars.isTargetArrivedSwamp = true
						TppUiCommand.SetMisionInfoCurrentStoryNo(1)
						this.DeleteHighInterrogationTargetGoal()
						this.AddHighInterrogationTargetPosition()
						TppMission.UpdateObjective({ objectives = { "add_TargetGoal_afterArrivalAndGetIntel" } })
						svars.isReserve_02 = false
						s10211_enemy.SetVipGroupSwampCautionRoute()

						s10211_radio.VipArrivedSwamp()
						if svars.isTargetFound == true then
							TppRadio.SetOptionalRadio("Set_s0211_oprg0021")
						else
							TppRadio.SetOptionalRadio("Set_s0211_oprg2000")
						end

						s10211_enemy.SetEnemyFlag_MovePriority(s10211_enemy.ENEMY_NAME.TARGET, "gt_swamp_0000")
					else
						Fox.Log("#### InLocator:: Vip arrived Swamp House ####")

						s10211_enemy.UnSetEnemyFlag_MovePriority(s10211_enemy.ENEMY_NAME.TARGET, "gt_swamp_0000")
						s10211_enemy.UnSetEnemyFlag_MovePriority(s10211_enemy.ENEMY_NAME.FOLLOWER02, "gt_swamp_0000")
					end
				end,
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

this.MarkingCheck = function(target)
	Fox.Log("!!!! ChangeToEnable MESSAGE !!!!")
end

function this.TargetFound(messageName, gameObjectId, msg)
	Fox.Log("####### s10211_sequence.TargetFound #########")

	svars.isTargetFound = true

	TppUiCommand.RegisterIconUniqueInformation({
		markerId = GameObject.GetGameObjectId(s10211_enemy.ENEMY_NAME.TARGET),
		langId = "marker_info_mission_target",
	})

	TppMission.UpdateObjective({ objectives = { "hud_photo_target" } })

	TppRadio.ChangeIntelRadio(s10211_radio.intelRadioListTargetFound)

	if svars.isTargetArrivedSwamp == true then
		TppRadio.SetOptionalRadio("Set_s0211_oprg2001")
	else
		TppRadio.SetOptionalRadio("Set_s0211_oprg3010")
	end

	TppSequence.SetNextSequence("Seq_Game_KillTarget")
	return
end

function this.TargetPlacedIntoVehicle(vehicleId)
	Fox.Log("s10211_sequence.TargetPlacedIntoVehicle")

	if Tpp.IsHelicopter(vehicleId) then
		if svars.isReserve_01 == false then
			svars.isReserve_01 = true
			svars.isReserve_15 = true

			s10211_radio.TargetPlacedIntoHeli()
			this.vipTaskCheckRecover()
			this.GuardTaskCheckRecover()

			TppSequence.SetNextSequence("Seq_Game_Escape")
		end
	end
end

function this.GuardTaskCheckRecover()
	svars.GuardEliminate = svars.GuardEliminate + 1
	local enemyCount = svars.GuardEliminate
	if enemyCount == TASK_ENEMY_MAX then
		TppResult.AcquireSpecialBonus({ second = { isComplete = true } })
	end
end

function this.HostageTaskCheckRecover()
	Fox.Log("s10211_sequence.HostageTaskCheckRecover")

	svars.ldReserve_03 = svars.ldReserve_03 + 1
	svars.ldReserve_04 = svars.ldReserve_04 + 1
	if svars.ldReserve_03 == TASK_HOSTAGE_MAX then
		this.DeleteHighInterrogationHostage()
	end

	if
		svars.isReserve_17 == true
		and svars.isReserve_18 == true
		and svars.isReserve_19 == true
		and svars.isReserve_20 == true
	then
		TppMission.UpdateObjective({ objectives = { "task5_complete" } })
	else
		Fox.Log(" #cannot complete task5# ")
	end
end

this.vipTaskCheckRecover = function()
	Fox.Log("#### s10211_radio.vipTaskCheckRecover ####")
	if svars.isTargetArrivedSwamp == false then
		TppMission.UpdateObjective({ objectives = { "announce_TargetRecovered" } })
		TppMission.UpdateObjective({ objectives = { "announce_AllObjectiveFinish" } })
		TppMission.UpdateObjective({ objectives = { "task2_complete" } })
		TppResult.AcquireSpecialBonus({ first = { isComplete = true } })

		TppMission.UpdateObjective({ objectives = { "clear_photo_target" } })
	else
		TppMission.UpdateObjective({ objectives = { "announce_TargetRecovered" } })
		TppMission.UpdateObjective({ objectives = { "announce_AllObjectiveFinish" } })
		TppMission.UpdateObjective({ objectives = { "task2_complete" } })
		TppMission.UpdateObjective({ objectives = { "clear_photo_target" } })

		Fox.Log("*** Task vip eliminated after arrived swamp  ***")
	end
end

function this.vipTaskCheckKill()
	Fox.Log("#### s10211_sequence.vipTaskCheckKill ####")
	if svars.isTargetArrivedSwamp == false then
		TppMission.UpdateObjective({ objectives = { "announce_TargetKilled" } })
		TppMission.UpdateObjective({ objectives = { "announce_AllObjectiveFinish" } })
		TppMission.UpdateObjective({ objectives = { "task2_complete" } })
		TppResult.AcquireSpecialBonus({ first = { isComplete = true } })

		TppMission.UpdateObjective({ objectives = { "clear_photo_target" } })
	else
		TppMission.UpdateObjective({ objectives = { "announce_TargetKilled" } })
		TppMission.UpdateObjective({ objectives = { "announce_AllObjectiveFinish" } })
		TppMission.UpdateObjective({ objectives = { "task2_complete" } })
		TppMission.UpdateObjective({ objectives = { "clear_photo_target" } })

		Fox.Log("*** Task vip eliminated after arrived swamp  ***")
	end
end

function this.vipArrivedSwamp()
	TppUiCommand.SetMisionInfoCurrentStoryNo(1)
	this.DeleteHighInterrogationTargetGoal()
	this.AddHighInterrogationTargetPosition()
	TppMission.UpdateObjective({ objectives = { "add_TargetGoal_afterArrivalAndGetIntel" } })
	svars.isReserve_02 = false

	s10211_enemy.SetVipGroupSwampCautionRoute()

	s10211_radio.VipArrivedSwamp()
	if svars.isTargetFound == true then
		TppRadio.SetOptionalRadio("Set_s0211_oprg0021")
	else
		TppRadio.SetOptionalRadio("Set_s0211_oprg2000")
	end
end

function this.OnGetIntel_savannah()
	local func = function()
		Fox.Log("#####GetIntel_Swamp######")

		TppMission.UpdateObjective({ objectives = { "area_Intel_get" } })

		local sequence = TppSequence.GetCurrentSequenceName()
		if sequence == "Seq_Game_BeforeGetDocument" then
			TppSequence.SetNextSequence("Seq_Game_AfterGetDocument")
		elseif sequence == "Seq_Game_KillTarget" then
			TppRadio.Play("s0211_rtrg4031")

			TppMission.UpdateCheckPoint("CHK_GetSavCassette")
		elseif sequence == "Seq_Game_Escape" then
			TppRadio.Play("f1000_rtrg3190")

			TppMission.UpdateCheckPoint("CHK_GetSavCassette")
		else
		end
	end

	svars.isGetIntel = true

	s10211_demo.GetIntel_savannah(func)
end

sequences.Seq_Game_BeforeGetDocument = {

	Messages = function(self)
		return StrCode32Table({
			Marker = {
				{ msg = "ChangeToEnable", func = this.MarkingCheck },
			},

			Radio = {
				{
					msg = "Finish",
					func = function(arg0)
						if arg0 == StrCode32("s0211_esrg0010") then
							if svars.isTargetArrivedSwamp == false then
								Fox.Log("#### s0211_esrg0010 Finish ####")
								TppMission.UpdateObjective({ objectives = { "search_Item_InfoTape" } })
							end
						end
					end,
				},
			},

			Trap = {

				{
					msg = "Enter",
					sender = "trap_Savannah",
					func = function(trap, player)
						if svars.isTargetArrivedSwamp == false and svars.isTargetFound == false then
							if svars.isCallsavannahRadio == false then
								svars.isCallsavannahRadio = true

								TppMission.UpdateObjective({
									radio = {

										radioGroups = "s0211_rtrg1010",
										radioOptions = { isEnqueue = true },
									},

									objectives = { "default_area_savannah_arrived" },
								})

								TppRadio.SetOptionalRadio("Set_s0211_oprg0010")
							end
						end
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
			TppCoder.SetWorldCenter(Vector3(472.65738, -3.6367188, -29.446014))
		end

		Fox.Log("######## Seq_Game_BeforeGetDocument.OnEnter  ########")
		this.HighInterrogation()

		svars.isReserve_04 = true
		svars.isReserve_05 = true
		svars.isReserve_06 = true
		svars.isReserve_07 = true

		TppScriptBlock.LoadDemoBlock("Demo_GetIntel")
		TppTelop.StartCastTelop()

		local radioGroups = s10211_radio.MissionStart()
		Fox.Log("#### openig radio ##")

		if TppSequence.GetContinueCount() > 0 then
			TppRadio.Play(radioGroups)
		end

		TppUiCommand.SetCurrentMissionSubGoalNo(1)

		TppMission.UpdateObjective({

			objectives = {
				"default_photo_target",
				"task0_default",

				"task2_default",
				"task3_default",
				"task4_default",
				"task5_default",
				"task6_default",
			},
		})

		TppMission.UpdateObjective({
			radio = {

				radioGroups = radioGroups,
			},

			objectives = { "default_area_savannah", "default_s10211_TargetArea02" },
		})

		Fox.Log("#### StartTravel Vip ####")
		s10211_enemy.StartVipTravel()

		TppRadio.SetOptionalRadio("Set_s0211_oprg0100")
	end,

	OnLeave = function()
		if svars.isGetIntel == true then
			TppMission.UpdateCheckPoint("CHK_GetSavCassette")
		end
	end,
}

sequences.Seq_Game_AfterGetDocument = {

	Messages = function(self)
		return StrCode32Table({
			Marker = {
				{ msg = "ChangeToEnable", func = this.MarkingCheck },
			},
			GameObject = {
				nil,
			},
		})
	end,

	OnEnter = function()
		Fox.Log("######## Seq_Game_AfterGetDocument.OnEnter ########")

		TppMission.UpdateObjective({
			objectives = { "add_TargetGoal", "add_TargetRoute", "task0_complete", "task0_complete" },
		})
		s10211_radio.AfterGetDocument()

		TppRadio.SetOptionalRadio("Set_s0211_oprg0020")
	end,

	OnLeave = function() end,
}

function this.CheckDevelopSniperRifle()
	if TppMotherBaseManagement.IsDevelopTypeDeveloped({ developType = TppMbDev.EQP_DEV_TYPE_Sniper }) then
		Fox.Log("#####sniper_rifle_developed.")
		return true
	else
		Fox.Log("#####sniper_rifle_not_developed.")
		return false
	end
end

sequences.Seq_Game_KillTarget = {

	Messages = function(self)
		return StrCode32Table({
			Marker = {
				{ msg = "ChangeToEnable", func = this.MarkingCheck },
			},
			GameObject = {

				nil,
			},
			nil,
		})
	end,

	OnEnter = function()
		Fox.Log("######## Seq_Game_KillTarget.OnEnter ########")

		local radioGroups = s10211_radio.KillTarget()
		Fox.Log("#### openig radio ##")

		if TppSequence.GetContinueCount() > 0 then
			TppRadio.Play(radioGroups)
		end

		TppMission.UpdateObjective({
			radio = {

				radioGroups = radioGroups,
			},

			objectives = { "target_s10211_vip_swamp" },
		})
	end,

	OnLeave = function() end,
}

sequences.Seq_Game_Escape = {

	Messages = function(self)
		return StrCode32Table({
			GameObject = {
				nil,
			},
			nil,
		})
	end,

	OnEnter = function()
		Fox.Log("######## Seq_Game_Escape.OnEnter ########")

		this.DeleteHighInterrogationTargetPosition()
		this.DeleteHighInterrogationTargetGoal()

		TppMission.CanMissionClear()

		TppRadio.SetOptionalRadio("Set_s0211_oprg5010")

		TppMission.UpdateObjective({

			objectives = { "escape_subGoal", "task2_complete" },
		})
		s10211_radio.EscapeStartRadio()

		s10211_enemy.UnSetEnemyFlag_MovePriority(s10211_enemy.ENEMY_NAME.FOLLOWER02, "gt_swamp_0000")
	end,

	OnLeave = function() end,

	OnUpdate = function() end,
}

return this
