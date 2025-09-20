local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local IsTypeFunc = Tpp.IsTypeFunc
local IsTypeTable = Tpp.IsTypeTable
local IsTypeString = Tpp.IsTypeString
local GetGameObjectId = GameObject.GetGameObjectId
local NULL_ID = GameObject.NULL_ID

this.routeChangeTableRoot = {}
this.commonFuncTable = {}
this.walkerGearSettingTable = {}
this.walkerGearRouteNumTable = {}

local sequences = {}

local TARGET_HOSTAGE_NAME = "hos_vip_0000"

local MARKER_NAME = {
	AREA_FIELD = "s10045_marker_field",
	AREA_REMNANTS = "s10045_marker_remnants",
	AREA_VIP = "s10045_marker_vip",
	ON_AREA_VIP = "hos_vip_0000",
	AREA_GOAL = "s10045_marker_goal",
}

local MAX_COUNT_RECOVER_SOL_WALKERGEAR = 4
local MAX_COUNT_RECOVER_HOSTAGE = 2

this.MISSIONTASK_LIST = {
	MAIN_RECOVERED_TARGET = 1,
	SPECIALBONUS_QUICK_RECOVERED_TARGET = 2,
	SPECIALBONUS_RECOVERED_SOL_WALKERGEAR = 3,
	SUB_RECOVERED_SOL_RECOVER = 4,
	SUB_RECOVERED_RECOVERED_HOSTAGE = 5,
	SUB_RECOVERED_RECOVERED_EXECUTIONER = 6,
}

this.TASKTARGET = {
	"hos_vip_0000",
}

this.SOL_WALKERGEARTABLE = {
	"sol_WG_0000",
	"sol_WG_0001",
	"sol_WG_0002",
	"sol_WG_0003",
}

this.TASKHOSTAGETABLE = {
	"hos_s10045_0000",
	"hos_s10045_0001",
}

this.TASKSOLRECOVERY = {
	"sol_recovery_0000",
}

this.TASKEXECUTIONER = {
	"sol_executioner_0000",
}

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

this.MAX_PLACED_LOCATOR_COUNT = 25

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
	isTargetFulton = false,
	isTargetCarried = false,
	isTargetDiscovered = false,
	isTargetescape = false,
	isVipHut = false,
	isOnRemnants = false,
	isOnFlare = false,
	isOnPlayerRemnants = false,
	isOnExecutioner = false,
	isSearchExecutioner = false,
	isOnrecovery = false,
	isrecoveryradio = false,
	isrecoveryDead = false,
	isVehicleBroken = false,
	isExecutionerFulton = false,
	isOnExecutionerRemnants = false,

	coopCount = 0,

	subHostageFultonCount = 0,

	isReserveFlag_01 = false,
	isReserveFlag_02 = false,
	isReserveFlag_03 = false,
	isReserveFlag_04 = false,
	isReserveFlag_05 = false,
	isReserveFlag_06 = false,
	isReserveFlag_07 = false,
	isReserveFlag_08 = false,
	isReserveFlag_09 = false,
	isReserveFlag_10 = false,

	reserveCount_01 = 0,
	reserveCount_02 = 0,
	reserveCount_03 = 0,
	reserveCount_04 = 0,
	reserveCount_05 = 0,
	reserveCount_06 = 0,
	reserveCount_07 = 0,
	reserveCount_08 = 0,
	reserveCount_09 = 0,
	reserveCount_10 = 0,
}

this.checkPointList = {
	"CHK_MissionStart",
	"CHK_MissionComplete",

	"DBG_CHK_field",
	"DBG_CHK_remnants",
	"DBG_CHK_target",
}

this.baseList = {

	"field",
	"remnants",

	"fieldWest",
	nil,
}
this.REVENGE_MINE_LIST = { "afgh_remnants" }

this.missionObjectiveDefine = {

	area_remnants = {
		gameObjectName = MARKER_NAME.AREA_REMNANTS,
		visibleArea = 5,
		randomRange = 0,
		viewType = "map_only_icon",
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
		setNew = true,
	},

	default_area_vip = {
		gameObjectName = MARKER_NAME.AREA_VIP,
		visibleArea = 4,
		randomRange = 0,
		viewType = "all",
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
		setNew = false,
		mapRadioName = "f1000_mprg0065",
	},

	on_area_vip = {
		gameObjectName = MARKER_NAME.ON_AREA_VIP,
		visibleArea = 3,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		langId = "marker_info_mission_targetArea",
		mapRadioName = "f1000_mprg0090",
	},

	ShowEnemyRoute = {
		showEnemyRoutePoints = {
			groupIndex = 0,
			width = 100.0,
			langId = "marker_target_forecast_path",
			points = {
				Vector3(-803.4, 0.0, 1922.8),
				Vector3(-561.8, 0.0, 1869.1),
				Vector3(-389.9, 0.0, 1917.9),
				Vector3(-357.4, 0.0, 2047.1),
			},
		},
	},

	rv_missionClear = {
		announceLog = "updateMap",
	},

	default_photo_target = {
		photoId = 10,
		addFirst = true,
		photoRadioName = "s0045_mirg0010",
	},

	hud_photo_target = {
		hudPhotoId = 10,
	},

	off_area_vip = {
		gameObjectName = MARKER_NAME.ON_AREA_VIP,
		goalType = "defend",
		viewType = "map_and_world_only_icon",
		setImportant = true,
		langId = "marker_info_mission_target",
		announceLog = "updateMap",
	},

	on_hostage_00 = {
		gameObjectName = "hos_s10045_0000",
		goalType = "none",
		viewType = "map_and_world_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",
	},

	on_hostage_01 = {
		gameObjectName = "hos_s10045_0001",
		goalType = "none",
		viewType = "map_and_world_only_icon",
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",
	},

	default_subGoal_missionStart = {
		subGoalId = 0,
	},
	on_subGoal_missionComplete = {
		subGoalId = 2,
	},

	default_mainTask_recovered_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_RECOVERED_TARGET, isNew = false, isComplete = false },
	},
	on_mainTask_recovered_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_RECOVERED_TARGET, isNew = true, isComplete = true },
	},

	default_specialbonus_quick_recovered_target = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_QUICK_RECOVERED_TARGET,
			isNew = false,
			isComplete = false,
			isFirstHide = true,
		},
	},
	default_specialbonus_recovered_sol_walkergear = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_SOL_WALKERGEAR,
			isNew = false,
			isComplete = false,
			isFirstHide = true,
		},
	},
	on_specialbonus_quick_recovered_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_QUICK_RECOVERED_TARGET, isNew = true },
	},
	on_specialbonus_recovered_sol_walkergear = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_SOL_WALKERGEAR, isNew = true },
	},

	default_subTask_recovered_sol_recover = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_SOL_RECOVER,
			isNew = false,
			isComplete = false,
			isFirstHide = true,
		},
	},
	default_subTask_recovered_hostage = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_RECOVERED_HOSTAGE,
			isNew = false,
			isComplete = false,
			isFirstHide = true,
		},
	},
	default_subTask_recovered_executioner = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_RECOVERED_EXECUTIONER,
			isNew = false,
			isComplete = false,
			isFirstHide = true,
		},
	},
	on_subTask_recovered_sol_recover = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_SOL_RECOVER,
			isNew = true,
			isComplete = true,
		},
	},
	on_subTask_recovered_hostage = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_RECOVERED_HOSTAGE,
			isNew = true,
			isComplete = true,
		},
	},
	on_subTask_recovered_executioner = {
		missionTask = {
			taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_RECOVERED_EXECUTIONER,
			isNew = true,
			isComplete = true,
		},
	},

	announce_recovered_target = {
		announceLog = "recoverTarget",
	},

	announce_quick_recovered_target = {
		announceLog = "recoverTarget",
	},

	announce_recovered_sol_walkergear = {
		announceLog = "achieveAllObjectives",
	},

	announce_recovered_sol_recover = {
		announceLog = "recoverTarget",
	},

	announce_recovered_hostage = {
		announceLog = "achieveAllObjectives",
	},

	announce_recovered_executioner = {
		announceLog = "recoverTarget",
	},
}

this.missionObjectiveTree = {
	rv_missionClear = {
		ShowEnemyRoute = {},
		off_area_vip = {
			area_remnants = {},
			on_area_vip = {
				default_area_vip = {},
			},
		},
		default_photo_target = {},
	},

	on_mainTask_recovered_target = {},

	default_subGoal_missionStart = {},
	on_subGoal_missionComplete = {},

	on_specialbonus_quick_recovered_target = {},
	on_specialbonus_recovered_sol_walkergear = {},

	on_subTask_recovered_sol_recover = {},
	on_subTask_recovered_hostage = {},
	on_subTask_recovered_executioner = {},

	announce_recovered_target = {},
	announce_quick_recovered_target = {},
	announce_recovered_sol_walkergear = {},
	announce_recovered_sol_recover = {},
	announce_recovered_hostage = {},
	announce_recovered_executioner = {},

	hud_photo_target = {},

	on_hostage_00 = {},
	on_hostage_01 = {},
}

this.missionObjectiveEnum = Tpp.Enum({
	"area_remnants",
	"default_area_vip",
	"ShowEnemyRoute",
	"on_area_vip",
	"rv_missionClear",
	"off_area_vip",
	"default_photo_target",

	"default_subGoal_missionStart",
	"on_subGoal_missionComplete",

	"default_mainTask_recovered_target",
	"on_mainTask_recovered_target",

	"default_specialbonus_quick_recovered_target",
	"default_specialbonus_recovered_sol_walkergear",
	"on_specialbonus_quick_recovered_target",
	"on_specialbonus_recovered_sol_walkergear",

	"default_subTask_recovered_sol_recover",
	"default_subTask_recovered_hostage",
	"default_subTask_recovered_executioner",
	"on_subTask_recovered_sol_recover",
	"on_subTask_recovered_hostage",
	"on_subTask_recovered_executioner",

	"announce_recovered_target",
	"announce_quick_recovered_target",
	"announce_recovered_sol_walkergear",
	"announce_recovered_sol_recover",
	"announce_recovered_hostage",
	"announce_recovered_executioner",

	"hud_photo_target",

	"on_hostage_00",
	"on_hostage_01",
})

this.missionStartPosition = {

	orderBoxList = {
		"box_s10045_00",
	},

	helicopterRouteList = {
		"lz_drp_field_N0000",
		"lz_drp_field_I0000",
		"lz_drp_remnants_I0000",
	},
}

this.specialBonus = {
	first = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_QUICK_RECOVERED_TARGET },
	},
	second = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_SOL_WALKERGEAR },
	},
}

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	TppRatBird.EnableBird("TppEagle")

	TppRatBird.EnableRat()

	this.RegiserMissionSystemCallback()

	TppMission.RegisterMissionSystemCallback({

		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllVipClear()
		end,

		OnRecovered = function(gameObjectId)
			local function _IsTask(s_gameObjectId, gameObjectNameTable)
				for i, gameObjectName in ipairs(gameObjectNameTable) do
					local gameObjectId = GetGameObjectId(gameObjectName)
					if s_gameObjectId == gameObjectId then
						return true
					end
				end
				return false
			end

			if Tpp.IsSoldier(gameObjectId) then
				if _IsTask(gameObjectId, this.SOL_WALKERGEARTABLE) then
					svars.reserveCount_01 = svars.reserveCount_01 + 1
					if svars.reserveCount_01 == MAX_COUNT_RECOVER_SOL_WALKERGEAR then
						TppMission.UpdateObjective({
							objectives = {
								"on_specialbonus_recovered_sol_walkergear",
							},
						})

						TppResult.AcquireSpecialBonus({
							second = { isComplete = true },
						})
					end
				elseif _IsTask(gameObjectId, this.TASKEXECUTIONER) then
					TppMission.UpdateObjective({
						objectives = {
							"on_subTask_recovered_executioner",
						},
					})
				elseif _IsTask(gameObjectId, this.TASKSOLRECOVERY) then
					TppMission.UpdateObjective({
						objectives = {
							"on_subTask_recovered_sol_recover",
						},
					})
				end
			elseif Tpp.IsHostage(gameObjectId) then
				if _IsTask(gameObjectId, this.TASKHOSTAGETABLE) then
					svars.reserveCount_02 = svars.reserveCount_02 + 1
					if svars.reserveCount_02 == MAX_COUNT_RECOVER_HOSTAGE then
						TppMission.UpdateObjective({
							objectives = {
								"on_subTask_recovered_hostage",
							},
						})
					end
				end
			end
		end,

		OnEstablishMissionClear = function(missionClearType)
			TppMission.UpdateObjective({

				objectives = {
					"announce_recovered_target",
				},
			})
			TppMission.UpdateObjective({

				objectives = {
					"on_mainTask_recovered_target",
				},
			})
			if svars.isTargetDiscovered == false then
				TppResult.AcquireSpecialBonus({
					first = { isComplete = true },
				})
				TppMission.UpdateObjective({
					objectives = {
						"on_specialbonus_quick_recovered_target",
					},
				})
			end

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

			if svars.isOnExecutioner == false then
				s10045_radio.TelephoneRadioNoExecutioner()
			elseif svars.isExecutionerFulton == true then
				s10045_radio.TelephoneRadioExecutionerFulton()
			end
		end,
	})

	TppEnemy.RequestLoadWalkerGearEquip()

	TppMarker.SetUpSearchTarget({
		{
			gameObjectName = "hos_vip_0000",
			gameObjectType = "TppHostageUnique",
			messageName = "hos_vip_0000",
			skeletonName = "SKL_004_HEAD",
			func = this.commonUpdateMarkerTargetFound,
			objectives = { "hud_photo_target" },
		},
	})

	this.commonFuncTable[StrCode32("walkerGears_Start")] = {
		{ enemyName = "sol_WG_0000", routeId = "rts_sol_WG_0000", routeId_c = "rts_sol_WG_0000" },
		{ enemyName = "sol_WG_0001", routeId = "rts_sol_WG_0001", routeId_c = "rts_sol_WG_0001" },
		{ enemyName = "sol_WG_0002", routeId = "rts_sol_WG_0002", routeId_c = "rts_sol_WG_0002" },
		{ enemyName = "sol_WG_0003", routeId = "rts_sol_WG_0003", routeId_c = "rts_sol_WG_0003" },
	}

	this.commonFuncTable[StrCode32("DiscoveryConversation")] = {
		{
			func = function(gameObjectId)
				if svars.isTargetFulton == false and svars.isTargetCarried == false then
					if svars.isReserveFlag_02 == false then
						if gameObjectId == GameObject.GetGameObjectId("sol_WG_0000") then
							this.vip_notice_state()
							svars.isReserveFlag_02 = true
							s10045_enemy.Conversation_TargetDiscovered(gameObjectId)
						elseif gameObjectId == GameObject.GetGameObjectId("sol_WG_0001") then
							this.vip_notice_state()
							svars.isReserveFlag_02 = true
							s10045_enemy.Conversation_TargetDiscovered(gameObjectId)
						elseif gameObjectId == GameObject.GetGameObjectId("sol_WG_0002") then
							this.vip_notice_state()
							svars.isReserveFlag_02 = true
							s10045_enemy.Conversation_TargetDiscovered(gameObjectId)
						elseif gameObjectId == GameObject.GetGameObjectId("sol_WG_0003") then
							this.vip_notice_state()
							svars.isReserveFlag_02 = true
							s10045_enemy.Conversation_TargetDiscovered(gameObjectId)
						end
					end
				end
			end,
		},
	}

	this.commonFuncTable[StrCode32("rts_sol_WG_0004_routeChange01")] = {
		{ enemyName = "hos_vip_0000", routeId = "rts_vip_0000", routeId_c = "rts_vip_0000" },
		{ enemyName = "sol_WG_0000", routeId = "rts_sol_WG_0007", routeId_c = "rts_sol_WG_0007" },
		{ enemyName = "sol_WG_0001", routeId = "rts_sol_WG_0004", routeId_c = "rts_sol_WG_0004" },
		{ enemyName = "sol_WG_0002", routeId = "rts_sol_WG_0005", routeId_c = "rts_sol_WG_0005" },
		{ enemyName = "sol_WG_0003", routeId = "rts_sol_WG_0006", routeId_c = "rts_sol_WG_0006" },

		{
			func = function()
				this.TransferCp({ "sol_recovery_0000" }, "travel_recovery")
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("Conversation_recovery_route")] = {
		{
			enemyName = "sol_recovery_0000",
			routeId = "rts_RecoveryConversation_route0000",
			routeId_c = "rts_RecoveryConversation_route0000",
		},
		{
			func = function()
				if svars.isTargetFulton == true or svars.isTargetescape == true then
					this.OnCommonFunc({ messageId = StrCode32("rts_Vehicle_0000_routeChange01") })
					TppRadio.ChangeIntelRadio(s10045_radio.intelRadioListOnrecovery)
				else
					svars.isOnrecovery = true
					TppRadio.ChangeIntelRadio(s10045_radio.intelRadioListOnrecovery)
				end
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("Conversation_recovery")] = {
		{
			func = function(gameObjectId)
				local routeNameTable = { "rts_sol_WG_0007", "rts_sol_WG_0004", "rts_sol_WG_0005", "rts_sol_WG_0006" }
				local gameObjectId = s10045_enemy.GetGameObjectIdUsingRouteTable(routeNameTable)
				if svars.isTargetFulton == false and svars.isTargetescape == false then
					if gameObjectId then
						s10045_enemy.Conversation_Targetrecovery(gameObjectId)
					else
						this.OnCommonFunc({ messageId = StrCode32("in_vipVehicle") })
					end
				else
					this.OnCommonFunc({ messageId = StrCode32("in_vipVehicle") })
				end
			end,
		},
	}
	this.commonFuncTable[Fox.StrCode32("in_vipVehicle")] = {
		{ enemyName = "hos_vip_0000", routeId = "rts_get_in_route0001", routeId_c = "rts_get_in_route0001" },
		{ enemyName = "sol_recovery_0000", routeId = "rts_get_in_route0001", routeId_c = "rts_get_in_route0001" },
		{
			func = function()
				if svars.isTargetFulton == false and svars.isTargetescape == false then
					s10045_enemy.SetRelativeVehicle_Hostage()
				else
					this.OnCommonFunc({ messageId = StrCode32("rts_Vehicle_0000_routeChange01") })
				end
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("sol_in_Vehicle")] = {
		{
			enemyName = "sol_recovery_0000",
			routeId = "rts_vehicle_in",
			routeId_c = "rts_vehicle_in",
			routeId_a = "rts_vehicle_in",
		},
	}

	this.commonFuncTable[Fox.StrCode32("rts_Vehicle_0000_routeChange")] = {
		{
			func = function()
				if svars.isTargetescape == false then
					TppEnemy.UnsetSneakRoute("hos_vip_0000")
					TppEnemy.UnsetSneakRoute("sol_recovery_0000")
					TppEnemy.UnsetCautionRoute("hos_vip_0000")
					TppEnemy.UnsetCautionRoute("sol_recovery_0000")
					this.TransferCp({ "hos_vip_0000", "sol_recovery_0000" }, "travel_recovery_back")
				else
				end
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("rts_Vehicle_0000_routeChange01")] = {
		{
			func = function()
				if svars.isTargetescape == true then
					TppEnemy.SetSneakRoute("sol_recovery_0000", "rts_vip_escape_0004")
					TppEnemy.SetCautionRoute("sol_recovery_0000", "rts_vip_escape_0004")
				else
					this.TransferCp({ "hos_vip_0000", "sol_recovery_0000" }, "travel_recovery_back")
				end
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("wg_gardroute01")] = {

		{ enemyName = "sol_WG_0000", routeId = "rts_set_D_route0000", routeId_c = "rts_set_D_route0000" },
		{ enemyName = "sol_WG_0001", routeId = "rts_set_D_route0001", routeId_c = "rts_set_D_route0001" },
		{ enemyName = "sol_WG_0002", routeId = "rts_set_D_route0002", routeId_c = "rts_set_D_route0002" },
		{ enemyName = "sol_WG_0003", routeId = "rts_set_D_route0003", routeId_c = "rts_set_D_route0003" },
	}

	this.commonFuncTable[StrCode32("OptionalRadioChange")] = {
		{
			func = function()
				if svars.isrecoveryradio == true then
					s10045_radio.TargetJoinOptionalRadioChange()
				end
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("vip_GetOut")] = {
		{
			enemyName = "sol_recovery_0000",
			routeId = "rts_get_out_route0000",
			routeId_c = "rts_get_out_route0000",
			routeId_a = "rts_get_out_route0000",
		},

		{
			func = function()
				if svars.isVehicleBroken == true then
					TppEnemy.SetSneakRoute("hos_vip_0000", "rts_vip_0002")
					TppEnemy.SetSneakRoute("sol_recovery_0000", "rts_sol_recovery_0003")
				end
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("vip_remnants_route")] = {
		{ enemyName = "hos_vip_0000", routeId = "rts_vip_0002" },
		{ enemyName = "sol_recovery_0000", routeId = "rts_sol_recovery_0003", routeId_c = "rts_sol_recovery_0003" },

		{
			func = function()
				if svars.isTargetFulton == false then
					if svars.isOnRemnants == false then
						svars.isOnRemnants = true

						TppRadio.ChangeIntelRadio(s10045_radio.intelRadioListOnRemnants)
						if svars.isrecoveryradio == true then
							s10045_radio.TargetRemnants()
						end
					end
				end
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("on_hostage")] = {
		{
			func = function()
				svars.isVipHut = true
				this.spawnExecutioner()
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("remnants_gard")] = {
		{ enemyName = "sol_WG_0000", routeId = "rts_sol_WG_0014", routeId_c = "rts_sol_WG_0014" },
		{ enemyName = "sol_WG_0001", routeId = "rts_sol_WG_0015", routeId_c = "rts_sol_WG_0015" },
		{ enemyName = "sol_WG_0002", routeId = "rts_sol_WG_0016", routeId_c = "rts_sol_WG_0016" },
		{ enemyName = "sol_WG_0003", routeId = "rts_sol_WG_0017", routeId_c = "rts_sol_WG_0017" },
	}

	this.commonFuncTable[Fox.StrCode32("on_executioner_remnants")] = {
		{
			enemyName = "sol_executioner_0000",
			routeId = "rts_sol_executioner_0005",
			routeId_c = "rts_sol_executioner_0006",
			routeId_a = "rts_sol_executioner_0006",
		},
		{
			func = function()
				svars.isOnExecutionerRemnants = true
			end,
		},
	}

	this.commonFuncTable[Fox.StrCode32("vip_execution")] = {
		{
			func = function()
				if svars.isVipHut == true then
					this.Execution_Vip()
				else
					TppEnemy.UnsetAlertRoute("sol_executioner_0000")
				end
			end,
		},
	}

	this.walkerGearRouteNumTable = {
		{ messageId = Fox.StrCode32("D_gard00"), routeNum = 0 },
		{ messageId = Fox.StrCode32("D_gard01"), routeNum = 1 },
		{ messageId = Fox.StrCode32("D_gard02"), routeNum = 2 },
		{ messageId = Fox.StrCode32("D_gard03"), routeNum = 3 },
		{ messageId = Fox.StrCode32("D_gard04"), routeNum = 4 },
		{ messageId = Fox.StrCode32("D_gard05"), routeNum = 5 },
		{ messageId = Fox.StrCode32("D_gard06"), routeNum = 6 },
		{ messageId = Fox.StrCode32("D_gard07"), routeNum = 7 },
		{ messageId = Fox.StrCode32("D_gard08"), routeNum = 8 },
		{ messageId = Fox.StrCode32("D_gard09"), routeNum = 9 },
		{ messageId = Fox.StrCode32("D_gard10"), routeNum = 10 },
		{ messageId = Fox.StrCode32("D_gard11"), routeNum = 11 },
		{ messageId = Fox.StrCode32("D_gard12"), routeNum = 12 },
		{ messageId = Fox.StrCode32("D_gard13"), routeNum = 13 },
		{ messageId = Fox.StrCode32("D_gard14"), routeNum = 14 },
		{ messageId = Fox.StrCode32("D_gard15"), routeNum = 15 },
		{ messageId = Fox.StrCode32("D_gard16"), routeNum = 16 },
		{ messageId = Fox.StrCode32("D_gard17"), routeNum = 17 },
		{ messageId = Fox.StrCode32("D_gard18"), routeNum = 18 },
		{ messageId = Fox.StrCode32("D_gard19"), routeNum = 19 },
		{ messageId = Fox.StrCode32("D_gard20"), routeNum = 20 },
		{ messageId = Fox.StrCode32("D_gard21"), routeNum = 21 },
		{ messageId = Fox.StrCode32("D_gard22"), routeNum = 22 },
		{ messageId = Fox.StrCode32("D_gard23"), routeNum = 23 },
		{ messageId = Fox.StrCode32("D_gard24"), routeNum = 24 },
		{ messageId = Fox.StrCode32("D_gard25"), routeNum = 25 },
		{ messageId = Fox.StrCode32("D_gard26"), routeNum = 26 },
		{ messageId = Fox.StrCode32("D_gard27"), routeNum = 27 },
		{ messageId = Fox.StrCode32("D_gard28"), routeNum = 28 },
		{ messageId = Fox.StrCode32("D_gard29"), routeNum = 29 },
		{ messageId = Fox.StrCode32("D_gard30"), routeNum = 30 },
		{ messageId = Fox.StrCode32("D_gard31"), routeNum = 31 },
		{ messageId = Fox.StrCode32("D_gard32"), routeNum = 32 },
		{ messageId = Fox.StrCode32("D_gard33"), routeNum = 33 },
		{ messageId = Fox.StrCode32("D_gard34"), routeNum = 34 },
		{ messageId = Fox.StrCode32("D_gard35"), routeNum = 35 },
		{ messageId = Fox.StrCode32("D_gard36"), routeNum = 36 },
	}

	this.walkerGearSettingTable[StrCode32("sol_WG_0000")] = {
		enemyName = "sol_WG_0000",
		priorityNum = 1,
		priority = {
			nil,
		},
		route = {
			{ after_vehicle = "rts_D_route_00_0000", after_walk = "rts_D_route_b_00_0000" },
			{ after_vehicle = "rts_D_route_00_0001", after_walk = "rts_D_route_b_00_0001" },
			{ after_vehicle = "rts_D_route_00_0002", after_walk = "rts_D_route_b_00_0002" },
			{ after_vehicle = "rts_D_route_00_0003", after_walk = "rts_D_route_b_00_0003" },
			{ after_vehicle = "rts_D_route_00_0004", after_walk = "rts_D_route_b_00_0004" },
			{ after_vehicle = "rts_D_route_00_0005", after_walk = "rts_D_route_b_00_0005" },
			{ after_vehicle = "rts_D_route_00_0006", after_walk = "rts_D_route_b_00_0006" },
			{ after_vehicle = "rts_D_route_00_0007", after_walk = "rts_D_route_b_00_0007" },
			{ after_vehicle = "rts_D_route_00_0008", after_walk = "rts_D_route_b_00_0008" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0009" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0010" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0011" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0012" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0013" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0014" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0015" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0016" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0017" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_00_0018" },
		},
	}

	this.walkerGearSettingTable[StrCode32("sol_WG_0001")] = {
		enemyName = "sol_WG_0001",
		priorityNum = 2,
		priority = {
			"sol_WG_0000",
		},
		route = {
			{ after_vehicle = "rts_D_route_01_0000", after_walk = "rts_D_route_b_01_0000" },
			{ after_vehicle = "rts_D_route_01_0001", after_walk = "rts_D_route_b_01_0001" },
			{ after_vehicle = "rts_D_route_01_0002", after_walk = "rts_D_route_b_01_0002" },
			{ after_vehicle = "rts_D_route_01_0003", after_walk = "rts_D_route_b_01_0003" },
			{ after_vehicle = "rts_D_route_01_0004", after_walk = "rts_D_route_b_01_0004" },
			{ after_vehicle = "rts_D_route_01_0005", after_walk = "rts_D_route_b_01_0005" },
			{ after_vehicle = "rts_D_route_01_0006", after_walk = "rts_D_route_b_01_0006" },
			{ after_vehicle = "rts_D_route_01_0007", after_walk = "rts_D_route_b_01_0007" },
			{ after_vehicle = "rts_D_route_01_0008", after_walk = "rts_D_route_b_01_0008" },
			{ after_vehicle = "rts_D_route_01_0009", after_walk = "rts_D_route_b_01_0009" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_01_0010" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_01_0011" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_01_0012" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_01_0013" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_01_0014" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_01_0015" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_01_0016" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_01_0017" },
		},
	}

	this.walkerGearSettingTable[StrCode32("sol_WG_0002")] = {
		enemyName = "sol_WG_0002",
		priorityNum = 3,
		priority = {
			"sol_WG_0000",
			"sol_WG_0001",
		},
		route = {
			{ after_vehicle = "rts_D_route_02_0000", after_walk = "rts_D_route_b_02_0000" },
			{ after_vehicle = "rts_D_route_02_0001", after_walk = "rts_D_route_b_02_0001" },
			{ after_vehicle = "rts_D_route_02_0002", after_walk = "rts_D_route_b_02_0002" },
			{ after_vehicle = "rts_D_route_02_0003", after_walk = "rts_D_route_b_02_0003" },
			{ after_vehicle = "rts_D_route_02_0004", after_walk = "rts_D_route_b_02_0004" },
			{ after_vehicle = "rts_D_route_02_0005", after_walk = "rts_D_route_b_02_0005" },
			{ after_vehicle = "rts_D_route_02_0006", after_walk = "rts_D_route_b_02_0006" },
			{ after_vehicle = "rts_D_route_02_0007", after_walk = "rts_D_route_b_02_0007" },
			{ after_vehicle = "rts_D_route_02_0008", after_walk = "rts_D_route_b_02_0008" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0009" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0010" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0011" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0012" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0013" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0014" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0015" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0016" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0017" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_02_0018" },
		},
	}

	this.walkerGearSettingTable[StrCode32("sol_WG_0003")] = {
		enemyName = "sol_WG_0003",
		priorityNum = 4,
		priority = {
			"sol_WG_0000",
			"sol_WG_0001",
			"sol_WG_0002",
		},
		route = {
			{ after_vehicle = "rts_D_route_03_0000", after_walk = "rts_D_route_b_03_0000" },
			{ after_vehicle = "rts_D_route_03_0001", after_walk = "rts_D_route_b_03_0001" },
			{ after_vehicle = "rts_D_route_03_0002", after_walk = "rts_D_route_b_03_0002" },
			{ after_vehicle = "rts_D_route_03_0003", after_walk = "rts_D_route_b_03_0003" },
			{ after_vehicle = "rts_D_route_03_0004", after_walk = "rts_D_route_b_03_0004" },
			{ after_vehicle = "rts_D_route_03_0005", after_walk = "rts_D_route_b_03_0005" },
			{ after_vehicle = "rts_D_route_03_0006", after_walk = "rts_D_route_b_03_0006" },
			{ after_vehicle = "rts_D_route_03_0007", after_walk = "rts_D_route_b_03_0007" },
			{ after_vehicle = "rts_D_route_03_0008", after_walk = "rts_D_route_b_03_0008" },
			{ after_vehicle = "rts_D_route_03_0009", after_walk = "rts_D_route_b_03_0009" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_03_0010" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_03_0011" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_03_0012" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_03_0013" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_03_0014" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_03_0015" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_03_0016" },
			{ after_vehicle = "", after_walk = "rts_D_route_b_03_0017" },
		},
	}
end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
end

function this.RegiserMissionSystemCallback()
	Fox.Log("*** RegiserMissionSystemCallback ***")

	local systemCallbackTable = {
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnGameOver = this.OnGameOver,
		nil,
	}

	TppMission.RegiserMissionSystemCallback(systemCallbackTable)
end

function this.OnGameOver(gameOverType)
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo(TppDefine.GAME_OVER_TYPE.TARGET_DEAD) then
		TppPlayer.SetTargetDeadCamera({ gameObjectName = "hos_vip_0000" })
		TppMission.ShowGameOverMenu({ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME })
		return true
	end
end

function this.Messages()
	return StrCode32Table({
		GameObject = {
			{
				msg = "RoutePoint2",
				func = function(gameObjectId, routeId, routeNode, messageId)
					Fox.Log("### s10045_sequence.Messages(): msg:RoutePoint2" .. tostring(messageId) .. "###")
					if messageId == StrCode32("VipReplaced") then
						Fox.Log(" ### Target has been moved ### ")
						svars.isReserveFlag_04 = true
					else
						this.OnCommonFunc({
							gameObjectId = gameObjectId,
							routeId = routeId,
							routeNodeIndex = routeNodeIndex,
							messageId = messageId,
						})
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

function this.SetTimer(params)
	if params.timerName and params.time then
		if params.stop == true then
			Fox.Log("s10045_sequence.SetTimer(): TimerStop timerName:" .. params.timerName .. "")
			GkEventTimerManager.Stop(params.timerName)
		end
		if not GkEventTimerManager.IsTimerActive(params.timerName) then
			Fox.Log(
				"s10045_sequence.SetTimer(): TimerStart timerName:" .. params.timerName .. " time:" .. params.time .. ""
			)
			GkEventTimerManager.Start(params.timerName, params.time)
		end
	end
end

function this.OnTargetDead(s_characterId)
	Fox.Log("s10045_sequence.OnTargetDead( " .. s_characterId .. " )")
	TppMission.ReserveGameOver(TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD)
end

function this.commonUpdateMarkerTargetFound(messageName, gameObjectId, msg)
	Fox.Log("*** commonUpdateMarkerTargetFound ***")
	TppMission.UpdateObjective({
		objectives = { "off_area_vip" },
	})
	TppRadio.ChangeIntelRadio(s10045_radio.intelRadioListMarkerTarget)
end

function this.WalkerGearStart()
	if svars.isReserveFlag_05 == false then
		Fox.Log(" ### WalkerGearStart ###")
		svars.isReserveFlag_05 = true
		this.OnCommonFunc({ messageId = StrCode32("walkerGears_Start") })
	end
end

this.OnCommonFunc = function(params)
	local commonFuncTable = this.commonFuncTable[params.messageId]

	if commonFuncTable == nil then
		for i, walkerGearRouteNum in ipairs(this.walkerGearRouteNumTable) do
			if params.messageId == walkerGearRouteNum.messageId then
				if walkerGearRouteNum.routeNum == 0 or walkerGearRouteNum.routeNum > svars.coopCount then
					this.OnWalkerGearCoop(walkerGearRouteNum.routeNum)
				end
			end
		end
	else
		for i, commonFunc in ipairs(commonFuncTable) do
			if commonFunc.enemyName then
				if commonFunc.routeId then
					local routeId = commonFunc.routeId
					if TppClock.GetTimeOfDay() == "night" and commonFunc.routeId then
						routeId = commonFunc.routeId
					end
					TppEnemy.SetSneakRoute(commonFunc.enemyName, routeId)
				end
				if commonFunc.routeId_c then
					TppEnemy.SetCautionRoute(commonFunc.enemyName, commonFunc.routeId_c)
				end
				if commonFunc.routeId_a then
					TppEnemy.SetAlertRoute(commonFunc.enemyName, commonFunc.routeId_a)
				end
			end

			if commonFunc.travelEnemyNameTable and commonFunc.travelPlanName then
				for j, travelEnemyName in ipairs(commonFunc.travelEnemyNameTable) do
					local gameObjectId = GameObject.GetGameObjectId(travelEnemyName)
					GameObject.SendCommand(gameObjectId, { id = "StartTravel", travelPlan = commonFunc.travelPlanName })
				end
			end

			if commonFunc.vehicleName and commonFunc.pos and commonFunc.rotY then
				local gameObjectId = GetGameObjectId(commonFunc.vehicleName)
				if gameObjectId == NULL_ID then
					Fox.Error("Cannot get gameObjectId. gameObjectName = " .. param.gameObjectName)
				else
					GameObject.SendCommand(
						gameObjectId,
						{ id = "SetPosition", position = commonFunc.pos, rotY = commonFunc.rotY }
					)
				end
			end

			if commonFunc.func then
				local gameObjectId = params.gameObjectId or nil
				commonFunc.func(gameObjectId)
			end

			if commonFunc.timerName and commonFunc.time then
				if not GkEventTimerManager.IsTimerActive(commonFunc.timerName) then
					GkEventTimerManager.Start(commonFunc.timerName, commonFunc.time)
				end
			end
		end
	end
end

this.OnWalkerGearCoop = function(routeValue)
	local function GetGameObjectIdUsingRoute(routeName)
		Fox.Log("*** GetGameObjectIdUsingRoute ***")
		local soldiers = GameObject.SendCommand(
			{ type = "TppSoldier2" },
			{ id = "GetGameObjectIdUsingRoute", route = routeName }
		)
		return soldiers
	end

	local function GetEnemyStatus(enemyName)
		Fox.Log("*** GetEnemyStatus ***")
		if IsTypeString(enemyName) then
			enemyName = GetGameObjectId(enemyName)
		end
		local isValue = false
		local lifeState = GameObject.SendCommand(enemyName, { id = "GetLifeStatus" })
		if lifeState == TppGameObject.NPC_LIFE_STATE_NORMAL then
			isValue = true
		end
		return isValue
	end

	local function GetEnemyRoute(routeTable)
		local route = nil
		if svars.isVehicleBroken == false and svars.isrecoveryDead == false then
			if routeTable.after_vehicle then
				route = routeTable.after_vehicle
			end
		else
			if routeTable.after_walk then
				route = routeTable.after_walk
			end
		end
		return route
	end

	local function CheckPriority(priorityNum)
		Fox.Log("*** CheckPriority ***")
		for id, param in pairs(this.walkerGearSettingTable) do
			if priorityNum < param.priorityNum then
				if GetEnemyStatus(param.enemyName) == true then
					return true
				end
			end
		end
		return false
	end

	local routeIndex = 0
	local gameObjectTable = {}
	local walkerGearTable = {}
	local coopIndex = (routeValue % 2)

	if coopIndex == 0 then
		gameObjectTable[1] = GameObject.GetGameObjectId("sol_WG_0003")
		gameObjectTable[2] = GameObject.GetGameObjectId("sol_WG_0001")
		walkerGearTable[1] = this.walkerGearSettingTable[StrCode32("sol_WG_0003")]
		walkerGearTable[2] = this.walkerGearSettingTable[StrCode32("sol_WG_0001")]
		routeIndex = math.floor((routeValue / 2) + 1)
	else
		gameObjectTable[1] = GameObject.GetGameObjectId("sol_WG_0000")
		gameObjectTable[2] = GameObject.GetGameObjectId("sol_WG_0002")
		walkerGearTable[1] = this.walkerGearSettingTable[StrCode32("sol_WG_0000")]
		walkerGearTable[2] = this.walkerGearSettingTable[StrCode32("sol_WG_0002")]
		routeIndex = math.floor((routeValue / 2) + (routeValue % 2))
	end

	for i, param in ipairs(walkerGearTable) do
		local priorityRouteName = nils
		local prioritySucces = false

		if GetEnemyStatus(gameObjectTable[i]) == true then
			for j, enemyName in ipairs(param.priority) do
				if prioritySucces == false then
					if GetEnemyStatus(enemyName) == false then
						if CheckPriority(param.priorityNum) == false then
							priorityRouteName =
								GetEnemyRoute(this.walkerGearSettingTable[StrCode32(enemyName)].route[routeIndex])
							local soldiers = GetGameObjectIdUsingRoute(priorityRouteName)
							if #soldiers == 0 then
								prioritySucces = true
							elseif #soldiers == 1 then
								for k, enemyId in ipairs(soldiers) do
									if enemyId == GameObject.GetGameObjectId(enemyName) then
										prioritySucces = true
									end
								end
							end
						end
					end
				end
			end
			if prioritySucces == false then
				if param.route[routeIndex] then
					local routeName = GetEnemyRoute(param.route[routeIndex])
					TppEnemy.SetSneakRoute(gameObjectTable[i], routeName)
					TppEnemy.SetCautionRoute(gameObjectTable[i], routeName)
				end
			else
				TppEnemy.SetSneakRoute(gameObjectTable[i], priorityRouteName)
				TppEnemy.SetCautionRoute(gameObjectTable[i], priorityRouteName)
			end
		end
	end

	svars.coopCount = routeValue
end

this.TransferCp = function(travelMember, planName)
	local command = { id = "StartTravel", travelPlan = planName, keepInAlert = true }

	if not Tpp.IsTypeTable(travelMember) then
		travelMember = { travelMember }
	end

	if travelMember and next(travelMember) then
		for i, enemyName in pairs(travelMember) do
			local gameObjectId = GameObject.GetGameObjectId(enemyName)
			GameObject.SendCommand(gameObjectId, command)
		end
	end
end

this.vip_notice_state = function()
	local gameObjectId = GameObject.GetGameObjectId("hos_vip_0000")
	local command = { id = "SetNoticeState", state = TppGameObject.HOSTAGE_NOTICE_STATE_NORMAL }
	GameObject.SendCommand(gameObjectId, command)
end

this.vip_GetIn = function()
	local gameObjectId = GameObject.GetGameObjectId("hos_vip_0000")
	GameObject.SendCommand(gameObjectId, {
		id = "RideVehicle",
		vehicleId = GameObject.GetGameObjectIdByIndex("TppVehicle2", 1),
		off = false,
	})
end

this.vip_GetOut = function()
	local gameObjectId = GameObject.GetGameObjectId("hos_vip_0000")
	GameObject.SendCommand(gameObjectId, {
		id = "RideVehicle",
		vehicleId = GameObject.GetGameObjectIdByIndex("TppVehicle2", 2),
		off = true,
	})
end

this.spawnExecutioner = function()
	if svars.isOnPlayerRemnants == true and svars.isVipHut == true then
		if svars.isOnExecutioner == false then
			local isSucceeded = GameObject.SendCommand({ type = "TppVehicle2" }, {
				id = "Respawn",
				name = "veh_s10045_0001",
			})

			TppEnemy.SetEnable("sol_executioner_0000")
			svars.isOnExecutioner = true
			s10045_enemy.hq_radio_ExecutionerSpown()

			TppCheckPoint.Disable({ baseName = { "field", "remnants", "fieldWest", "fieldEast", "remnantsNorth" } })
		end
	end
end

this.OnRouteExecutioner = function()
	if svars.isOnExecutioner == true then
		this.TransferCp({ "sol_executioner_0000" }, "travel_executioner")
	end
end

this.Execution_Vip = function()
	local soldierName = "sol_executioner_0000"
	local soldierId = GameObject.GetGameObjectId("TppSoldier2", soldierName)
	local hostageName = "hos_vip_0000"
	local hostageId = GameObject.GetGameObjectId("TppHostageUnique", hostageName)
	local command = { id = "SetExecuteHostage", targetId = hostageId }
	GameObject.SendCommand(soldierId, command)
	TppEnemy.UnsetAlertRoute("sol_executioner_0000")
end

this.routeNameChangeOneSolName = function(routeName)
	local gameObjectId = { type = "TppSoldier2" }
	local command = { id = "GetGameObjectIdUsingRoute", route = routeName }
	local soldiers = GameObject.SendCommand(gameObjectId, command)

	if soldiers then
		return soldiers[1]
	else
		return nil
	end
end

this.HighInterrogation = function()
	TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("afgh_fieldWest_ob"), {
		{ name = "enqt1000_101528", func = s10045_enemy.InterCall_targetNextLocation },
	})

	TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("afgh_field_cp"), {
		{ name = "enqt1000_101528", func = s10045_enemy.InterCall_targetNextLocation },
	})

	TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("afgh_remnants_cp"), {
		{ name = "enqt1000_101528", func = s10045_enemy.InterCall_targetNextLocation },
	})
end

this.HighInterrogation01 = function()
	TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("afgh_field_cp"), {
		{ name = "enqt1000_1i1210", func = s10045_enemy.InterCall_afgh_field_cp },
	})

	TppInterrogation.AddHighInterrogation(GameObject.GetGameObjectId("afgh_remnants_cp"), {
		{ name = "enqt1000_1i1210", func = s10045_enemy.InterCall_afgh_remnants_cp },
	})
end

sequences.Seq_Game_MainGame = {

	Messages = function(self)
		return StrCode32Table({
			GameObject = {
				{
					msg = "Fulton",
					sender = "hos_vip_0000",
					func = function()
						Fox.Log("*** this.Messages Target Fulton ***")
						if TppMarker.GetSearchTargetIsFound("hos_vip_0000") == false then
							TppSoundDaemon.PostEvent("sfx_s_enemytag_main_tgt")
							TppMission.UpdateObjective({ objectives = { "hud_photo_target" } })
						end
						TppMission.UpdateObjective({

							objectives = {
								"announce_recovered_target",
							},
						})
						if svars.isTargetDiscovered == false then
							TppMission.UpdateObjective({

								objectives = {
									"on_specialbonus_quick_recovered_target",
								},
							})

							TppResult.AcquireSpecialBonus({
								first = { isComplete = true },
							})
							self.OnTargetFulton()
						else
							self.OnTargetFulton()
						end
					end,
				},
				{
					msg = "PlacedIntoVehicle",
					sender = "hos_vip_0000",
					func = self.OnTargetRideVehicle,
				},
				{
					msg = "Carried",
					sender = "hos_vip_0000",
					func = function(gameObjectId)
						Fox.Log("*** this.Messages Target Unconscious ***")
						if svars.isTargetCarried == false then
							svars.isTargetCarried = true
						end
					end,
				},
				{
					msg = "Dead",
					sender = "hos_vip_0000",
					func = this.OnTargetDead,
				},
				{
					msg = "FultonFailed",
					sender = "hos_vip_0000",
					func = function(id, arg1, arg2, type)
						Fox.Log("fulton failed " .. type)
						if type == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
							this.OnTargetDead()
						else
							Fox.Log("meybe inside")
						end
					end,
				},
				{
					msg = "CommandPostAnnihilated",
					sender = "afgh_Vip_point_cp",
					func = self.WG_Annihilated,
				},

				{
					msg = "Dead",
					sender = { "sol_WG_0000", "sol_WG_0001", "sol_WG_0002", "sol_WG_0003" },
					func = function()
						if svars.isReserveFlag_01 == false then
							svars.isReserveFlag_02 = false
							s10045_enemy.HostageSetNotice()
						else
						end
					end,
				},

				{
					msg = "Dead",
					sender = "sol_recovery_0000",
					func = function()
						svars.isrecoveryDead = true
						self.Sol_RecoveryDead()
					end,
				},
				{
					msg = "Dead",
					sender = "sol_executioner_0000",
					func = self.ExecutionerDead,
				},

				{
					msg = "Fulton",
					sender = "sol_recovery_0000",
					func = function()
						svars.isrecoveryDead = true
						self.Sol_RecoveryDead()
					end,
				},

				{
					msg = "Fulton",
					sender = "sol_executioner_0000",
					func = function()
						svars.isExecutionerFulton = true
						self.ExecutionerDead()
					end,
				},

				{
					msg = "ChangePhase",
					sender = "afgh_remnants_cp",
					func = self.ExecutionerChangePhase,
				},

				{
					msg = "VehicleBroken",
					sender = "veh_s10045_0000",
					func = function()
						svars.isVehicleBroken = true
						self.Sol_RecoveryDead()
					end,
				},

				{
					msg = "DiscoveryHostage",
					func = function(hosGameObjectId, solGameObjectId)
						if svars.isTargetCarried == false then
							if solGameObjectId == GameObject.GetGameObjectId("sol_WG_0000") then
								this.vip_notice_state()
								TppEnemy.SetSneakRoute("sol_WG_0000", "rts_DiscoveryConversation_route0000")
								TppEnemy.SetCautionRoute("sol_WG_0000", "rts_DiscoveryConversation_route0000")
							elseif solGameObjectId == GameObject.GetGameObjectId("sol_WG_0001") then
								this.vip_notice_state()
								TppEnemy.SetSneakRoute("sol_WG_0001", "rts_DiscoveryConversation_route0001")
								TppEnemy.SetCautionRoute("sol_WG_0001", "rts_DiscoveryConversation_route0001")
							elseif solGameObjectId == GameObject.GetGameObjectId("sol_WG_0002") then
								this.vip_notice_state()
								TppEnemy.SetSneakRoute("sol_WG_0002", "rts_DiscoveryConversation_route0002")
								TppEnemy.SetCautionRoute("sol_WG_0002", "rts_DiscoveryConversation_route0002")
							elseif solGameObjectId == GameObject.GetGameObjectId("sol_WG_0003") then
								this.vip_notice_state()
								TppEnemy.SetSneakRoute("sol_WG_0003", "rts_DiscoveryConversation_route0003")
								TppEnemy.SetCautionRoute("sol_WG_0003", "rts_DiscoveryConversation_route0003")
							end
						else
						end
					end,
				},

				{
					msg = "ConversationEnd",
					func = function(s_gameObjectId, speechLabel, isSuccess)
						Fox.Log("*** ConversationEnd ***")
						if speechLabel == StrCode32("speech045_EV010") then
							if s10045_enemy.IsWalkerGearSolider(s_gameObjectId) then
								s10045_enemy.cp_radio_TargetDiscovered(s_gameObjectId)
								svars.isReserveFlag_02 = true
								svars.isTargetDiscovered = true
							end
						elseif speechLabel == StrCode32("speech045_EV020") then
							local soliderName = s10045_enemy.GetWalkerGearSoliderId()
							if soliderName ~= nil then
								local gameObjectId = GetGameObjectId(soliderName)
								s10045_enemy.cp_radio_TargetRecovery(gameObjectId)
							else
								this.OnCommonFunc({ messageId = StrCode32("in_vipVehicle") })
							end
						end
					end,
				},

				{
					msg = "RadioEnd",
					func = function(GameObjectId, cpGameObjectId, speechLabel, isSuccess)
						Fox.Log("*** ConversationEnd ***")
						if speechLabel == StrCode32("CPRSP040") then
							if svars.isOnFlare == false then
								svars.isOnFlare = true
								svars.isReserveFlag_01 = true
								this.vip_notice_state()
								this.OnCommonFunc({ messageId = StrCode32("rts_sol_WG_0004_routeChange01") })
								if svars.isrecoveryDead == true then
									this.SetTimer({ timerName = "RecoveryDeadTimer", time = 20, stop = true })
								end
							end
						elseif speechLabel == StrCode32("CPRSP060") then
							if svars.isrecoveryDead == false then
								s10045_enemy.SetRelativeVehicle_Hostage()
								this.OnCommonFunc({ messageId = StrCode32("in_vipVehicle") })
							else
								TppEnemy.SetSneakRoute("hos_vip_0000", "rts_vip_escape_0004")
							end
						elseif speechLabel == StrCode32("CPRSP050") then
							if svars.isrecoveryDead == false then
								TppEnemy.SetSneakRoute("hos_vip_0000", "rts_vip_escape_0004")
								TppEnemy.SetSneakRoute("sol_recovery_0000", "rts_vip_escape_0004")
								TppEnemy.SetCautionRoute("sol_recovery_0000", "rts_vip_escape_0004")
								TppEnemy.SetAlertRoute("sol_recovery_0000", "rts_vip_escape_0004")
								s10045_radio.RecoveryDead01()
							else
								TppEnemy.SetSneakRoute("hos_vip_0000", "rts_vip_escape_0004")
								s10045_radio.RecoveryDead01()
							end
						elseif speechLabel == StrCode32("HQSP010") then
							this.OnRouteExecutioner()
						end
					end,
				},
			},
			Radio = {
				{
					msg = "Finish",
					sender = "s0045_rtrg6010",
					func = function()
						this.SetTimer({ timerName = "OnExecutionerTime", time = 10, stop = true })
					end,
				},
				{
					msg = "Finish",
					sender = "s0045_rtrg6020",
					func = function()
						TppRadio.ChangeIntelRadio(s10045_radio.intelRadioListExecutioner)
					end,
				},
				{
					msg = "Finish",
					sender = "s0045_oprg4020",
					func = function()
						TppRadio.ChangeIntelRadio(s10045_radio.intelRadioListExecutionerAfter)
					end,
				},
			},

			Trap = {
				{
					msg = "Enter",
					sender = "On_player_TargetZone",
					func = function()
						if svars.isrecoveryradio == false and svars.isReserveFlag_04 == true then
							if svars.isReserveFlag_03 == false then
								svars.isReserveFlag_03 = true
								if TppMarker.GetSearchTargetIsFound("hos_vip_0000") == false then
									s10045_radio.LostTarget()
									TppMarker.Disable("s10045_marker_vip")
									this.HighInterrogation()
								end
							end
						end
					end,
				},

				{
					msg = "Enter",
					sender = "trap_WGs_Start",
					func = function()
						this.WalkerGearStart()
					end,
				},

				{
					msg = "Enter",
					sender = "trig_On_Player_Remnants",
					func = function()
						svars.isOnPlayerRemnants = true
						this.spawnExecutioner()
					end,
				},
				{
					msg = "Exit",
					sender = "trig_On_Player_Remnants",
					func = function()
						svars.isOnPlayerRemnants = false
					end,
				},

				{
					msg = "Enter",
					sender = "trig_Vip_Hut",
					func = function()
						svars.isVipHut = true
					end,
				},
				{
					msg = "Exit",
					sender = "trig_Vip_Hut",
					func = function()
						svars.isVipHut = false
					end,
				},
			},

			Timer = {
				{
					msg = "Finish",
					sender = "RecoveryDeadTimer",
					func = function()
						Fox.Log("s10045_sequence.Messages(): Timer msg:Finish")
						local soliderName = s10045_enemy.GetWalkerGearSoliderId()
						if soliderName ~= nil then
							local gameObjectId = GetGameObjectId(soliderName)
							s10045_enemy.cp_radio_LoseContact(gameObjectId)
						end
					end,
				},

				{
					msg = "Finish",
					sender = "OnExecutionerTime",
					func = function()
						Fox.Log("s10045_sequence.Messages(): Timer msg:Finish")
						s10045_radio.OnExecutioner()
					end,
				},

				{
					msg = "Finish",
					sender = "WalkerGearStartTimer",
					func = function()
						Fox.Log("s10045_sequence.Messages(): Timer msg:Finish WalkerGearStartTimer")
						this.WalkerGearStart()
					end,
				},
			},

			Marker = {
				{
					msg = "ChangeToEnable",
					sender = "sol_executioner_0000",
					func = function(arg0, arg1, arg2, arg3)
						if arg3 == StrCode32("Player") then
							svars.isSearchExecutioner = true
							if
								svars.isOnExecutionerRemnants == true
								and TppEnemy.GetPhase("afgh_remnants_cp") == TppEnemy.PHASE.SNEAK
							then
								s10045_radio.Searchexecutioner()
							else
							end
						end
					end,
				},

				{
					msg = "ChangeToEnable",
					sender = "hos_vip_0000",
					func = function(arg0, arg1, arg2, arg3)
						if arg3 == StrCode32("Player") then
							if TppMarker.GetSearchTargetIsFound("hos_vip_0000") then
								s10045_radio.CarryTarget()
							else
								s10045_radio.UncertificationTarget()
							end
						end
					end,
				},

				{
					msg = "ChangeToEnable",
					sender = "hos_s10045_0000",
					func = function(arg0, arg1, arg2, arg3)
						if arg3 == StrCode32("Player") then
							s10045_radio.SearchHostage()
						end
					end,
				},
				{
					msg = "ChangeToEnable",
					sender = "hos_s10045_0001",
					func = function(arg0, arg1, arg2, arg3)
						if arg3 == StrCode32("Player") then
							s10045_radio.SearchHostage()
						end
					end,
				},
			},

			Subtitles = {
				{
					msg = "SubtitlesEndEventMessage",
					func = function(speechLabel, status)
						Fox.Log("####SubtitlesEndEventMessage####")
						if speechLabel == SubtitlesCommand:ConvertToSubtitlesId("sand1000_099049_0_ened_ru") then
							s10045_radio.WepFlr()
							TppRadio.ChangeIntelRadio(s10045_radio.RadioListTargetDiscovered)
							TppMarker.Disable("s10045_marker_vip")
							TppMission.UpdateObjective({ objectives = { "on_area_vip" } })
						elseif speechLabel == SubtitlesCommand:ConvertToSubtitlesId("sand1000_099053_0_ened_ru") then
							svars.isrecoveryradio = true
							s10045_radio.TargetJoin02()
							TppMission.UpdateObjective({ objectives = { "ShowEnemyRoute" } })
						elseif speechLabel == SubtitlesCommand:ConvertToSubtitlesId("sand1000_099062_0_hqc_ru") then
							s10045_radio.ExecutionerSpown01()
						end
					end,
				},
			},
			nil,
		})
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(-20.289124, 276.06445, 2055.9263))
			TppNetworkUtil.SessionEnableAccept(true)
			Dynamite.StartNearestEnemyThread()
		end

		GkEventTimerManager.Start("WalkerGearStartTimer", 600)
		if TppSequence.GetContinueCount() == 0 then
			TppTelop.StartCastTelop()

			TppMission.UpdateCheckPoint("CHK_MissionStart")
			TppRadio.SetOptionalRadio("Set_s0045_oprg0010")
			this.HighInterrogation01()
			TppMission.UpdateObjective({
				objectives = {

					"default_photo_target",

					"default_mainTask_recovered_target",
					"default_subGoal_missionStart",

					"default_specialbonus_quick_recovered_target",
					"default_specialbonus_recovered_sol_walkergear",

					"default_subTask_recovered_sol_recover",
					"default_subTask_recovered_hostage",
					"default_subTask_recovered_executioner",
				},
			})

			TppMission.UpdateObjective({

				radio = {
					radioGroups = "s0045_rtrg2010",
				},

				objectives = { "default_area_vip" },
			})

			TppMission.SetHelicopterDoorOpenTime(20)
		elseif svars.isOnRemnants == true then
			s10045_radio.Continue01()
		elseif svars.isTargetFulton == true then
			s10045_radio.Continue02()
		else
			s10045_radio.Continue()
		end
	end,

	OnTargetFulton = function()
		if TppMarker.GetSearchTargetIsFound("hos_vip_0000") then
			svars.isTargetFulton = true
			s10045_radio.TargetFulton()
			TppSequence.SetNextSequence("Seq_Game_Escape")
		else
			svars.isTargetFulton = true
			s10045_radio.NoSearchtargetFulton()
			TppSequence.SetNextSequence("Seq_Game_Escape")
		end
	end,

	WG_Annihilated = function()
		if svars.isrecoveryDead == true then
			if svars.isOnRemnants == false then
				s10045_radio.WG_Annihilated_01()
			end
		elseif svars.isOnrecovery == false then
			s10045_radio.WG_Annihilated_00()
		elseif svars.isOnrecovery == true then
			if svars.isOnRemnants == false then
				s10045_radio.WG_Annihilated_01()
			end
		end
	end,

	ExecutionerSpown02 = function()
		this.SetTimer({ timerName = "OnExecutionerTime", time = 10, stop = true })
	end,

	Sol_RecoveryDead = function()
		if svars.isrecoveryDead == false or svars.isVehicleBroken == false then
			if svars.isTargetDiscovered == true and svars.isOnrecovery == false then
				svars.isTargetescape = true
				this.SetTimer({ timerName = "RecoveryDeadTimer", time = 20, stop = true })
			elseif svars.isOnrecovery == true and svars.isOnRemnants == false then
				svars.isTargetescape = true
				TppEnemy.SetSneakRoute("hos_vip_0000", "rts_vip_escape_0004")
				this.vip_GetOut()
				TppEnemy.SetSneakRoute("sol_recovery_0000", "rts_vip_escape_0004")
				TppEnemy.SetCautionRoute("sol_recovery_0000", "rts_vip_escape_0004")
				TppEnemy.SetAlertRoute("sol_recovery_0000", "rts_vip_escape_0004")
			end
		else
		end
	end,

	ExecutionerDead = function()
		if svars.isSearchExecutioner == true then
			s10045_radio.ExecutionerDead()
		end
	end,

	ExecutionerChangePhase = function(cpName, PhaseName)
		if svars.isSearchExecutioner == true then
			if TppEnemy.GetPhase("afgh_remnants_cp") > TppEnemy.PHASE.SNEAK then
				s10045_radio.CautionExecutioner()
			end
		end
	end,

	OnTargetRideVehicle = function(s_characterId, s_rideVehicleID)
		if Tpp.IsHelicopter(s_rideVehicleID) then
			TppMission.UpdateObjective({

				objectives = {
					"announce_recovered_target",
				},
			})
			if svars.isTargetDiscovered == false then
				TppMission.UpdateObjective({

					objectives = {
						"on_specialbonus_quick_recovered_target",
					},
				})

				TppResult.AcquireSpecialBonus({
					first = { isComplete = true },
				})
			end
			svars.isTargetFulton = true
			s10045_radio.TargetFulton()
			TppSequence.SetNextSequence("Seq_Game_Escape")
		else
		end
	end,

	OnLeave = function() end,
}

sequences.Seq_Game_Escape = {

	OnEnter = function()
		TppMission.CanMissionClear()

		TppMission.UpdateObjective({

			objectives = {
				"rv_missionClear",
				"on_mainTask_recovered_target",
				"on_subGoal_missionComplete",
			},
		})
	end,
}

return this
