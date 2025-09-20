local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

this.EQUIP_MISSION_BLOCK_GROUP_SIZE = 1500000

this.SHOT_SKULL_TIME = 15
this.FLASHBACK_TIME = 0.5
this.MAX_SHOT_COUNT = 3

local SUPPORT_BULLET_POS = {

	trap_supportPos_AREA01 = Vector3(-396.873, 491.413, -1123.225),
	trap_supportPos_AREA02 = Vector3(-641.844, 489.365, -1079.313),
	trap_supportPos_AREA03 = Vector3(-597.820, 463.508, -975.634),
	trap_supportPos_AREA04 = Vector3(-487.553, 452.118, -894.493),
	trap_supportPos_AREA05 = Vector3(-396.873, 491.413, -1123.225),
	trap_supportPos_AREA06 = Vector3(-460.821, 453.883, -929.655),
	trap_supportPos_AREA07 = Vector3(-672.784, 421.123, -821.791),
	trap_supportPos_AREA08 = Vector3(-615.162, 430.883, -847.903),
}

this.missionObjectiveEnum = Tpp.Enum({
	"default_area_Sahelan",
	"default_photo_Sahelan",

	"missionTask_break_Sahelan",
	"firstBonus_MissionTask",
	"secondBonus_MissionTask",
	"clear_missionTask_break_Sahelan",
	"clear_firstBonus_MissionTask",
	"clear_secondBonus_MissionTask",

	"announce_destroyTarget",
	"announce_achieveAllObjectives",
})

this.NPC_ENTRY_POINT_SETTING = {
	[TppDefine.INIT_HELI_ROUTE] = {
		[EntryBuddyType.VEHICLE] = { Vector3(-622.267, 490.917, -1092.220), TppMath.DegreeToRadian(281) },
		[EntryBuddyType.BUDDY] = { Vector3(-625.105, 490.848, -1102.887), TppMath.DegreeToRadian(275) },
	},
}

this.specialBonus = {
	first = {
		missionTask = { taskNo = 1 },
	},
	second = {
		missionTask = { taskNo = 2 },
	},
}

this.rankLimitedSetting = {
	permitSupportHelicopterAttack = true,
	permitFireSupport = true,
}

function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences({

		"Seq_Demo_SahelanAppearance",
		"Seq_Game_BattleSahelan",
		"Seq_Demo_BreakSahelan",
		"Seq_Demo_DeadSkullFace",
		"Seq_Game_KillSkullFace",
		"Seq_Demo_AfterDeadSkullFace",

		"Seq_Demo_Ending1",
		"Seq_Credit_Staff1",
		"Seq_Demo_Ending2",
		"Seq_Credit_Staff2",
		"Seq_Demo_Ending3",

		"Seq_Delay_Sequence",

		"Seq_movie_Preview",

		"Seq_Loading_SetUpAvatar",
		"Seq_Loading_ResetAvatar",

		"Seq_Game_LoadSnakeForDD",

		nil,
	})
	TppSequence.RegisterSequenceTable(sequences)
end

this.saveVarsList = {
	isPreliminaryFlag01 = false,
	isPreliminaryFlag02 = false,
	isPreliminaryFlag03 = false,
	isPreliminaryFlag04 = false,
	isPreliminaryFlag05 = false,
	isPreliminaryFlag06 = false,
	isPreliminaryFlag07 = false,
	isPreliminaryFlag08 = false,
	isPreliminaryFlag09 = false,
	isPreliminaryFlag10 = false,
	isPreliminaryFlag11 = false,
	isPreliminaryFlag12 = false,
	isPreliminaryFlag13 = false,
	isPreliminaryFlag14 = false,
	isPreliminaryFlag15 = false,
	isPreliminaryFlag16 = false,
	isPreliminaryFlag17 = false,
	isPreliminaryFlag18 = false,
	isPreliminaryFlag19 = false,
	isPreliminaryFlag20 = false,

	PreliminaryValue01 = 0,
	PreliminaryValue02 = 0,
	PreliminaryValue03 = 0,
	PreliminaryValue04 = 0,
	PreliminaryValue05 = 0,
	PreliminaryValue06 = 0,
	PreliminaryValue07 = 0,
	PreliminaryValue08 = 0,
	PreliminaryValue09 = 0,
	PreliminaryValue10 = 0,

	isCleardS10151 = false,
}

this.checkPointList = {
	"CHK_BattleSahelan",
	"CHK_Ending",
	nil,
}

this.baseList = {
	nil,
}

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	mvars.EscapeCount = 0

	TppLocation.RegistMissionAssetInitializeTable(this.s10151_baseOnActiveTable)

	TppEquip.RequestLoadToEquipMissionBlock({ TppEquip.EQP_WP_SkullFace_hg_010 })

	this.RegiserMissionSystemCallback()

	TppScriptBlock.PreloadRequestOnMissionStart({
		{ demo_block = "Demo_SahelanAppearance" },
	})

	if TppPackList.IsMissionPackLabel("OkbEnding") then
		TppEnemy.SetSoldier2CommonPackageLabel("s10151_ending")
		TppUiCommand.LyricTexture("regist_okb")
	else
		TppEnemy.SetSoldier2CommonPackageLabel("s10151_special")
	end
end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	if TppSequence.GetMissionStartSequenceName() == "Seq_Demo_SahelanAppearance" then
		svars.isCleardS10151 = TppStory.IsMissionCleard(10151)
	elseif
		TppSequence.GetMissionStartSequenceName() == "Seq_Demo_BreakSahelan"
		or TppSequence.GetMissionStartSequenceName() == "Seq_Demo_DeadSkullFace"
		or TppSequence.GetMissionStartSequenceName() == "Seq_Demo_AfterDeadSkullFace"
	then
		this.KillAiSahelan()
	end
end

function this.RegiserMissionSystemCallback()
	Fox.Log("!!!! s10151_mission.RegiserMissionSystemCallback !!!!")

	local systemCallbackTable = {

		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnEndMissionCredit = this.OnEndMissionCredit,
		OnEndMissionReward = this.OnEndMissionReward,

		OnGameOver = this.OnGameOver,
		nil,
	}

	TppMission.RegiserMissionSystemCallback(systemCallbackTable)
end

this.OnEstablishMissionClear = function(missionClearType)
	TppSequence.SetNextSequence("Seq_Game_LoadSnakeForDD", { isExecMissionClear = true })

	local missionName = TppMission.GetMissionName()
	if missionName == "s10151" then
		TppUiStatusManager.SetStatus("MissionTelop", "RESULT_SKIP_CAST")
	end
end

this.OnEndMissionCredit = function()
	Fox.Log("TppMission.Reload OnEndFadeOut")

	local missionName = TppMission.GetMissionName()
	if missionName == "s10151" then
		TppSequence.ReserveNextSequence("Seq_Demo_Ending1", { isExecMissionClear = true })

		TppScriptBlock.LoadDemoBlock("Demo_Ending1", false)
		TppMission.VarSaveOnUpdateCheckPoint()
		TppMission.DisablePauseForShowResult()
		TppMission.Reload({
			isNoFade = true,
			showLoadingTips = false,
			missionPackLabelName = "OkbEnding",
			locationCode = TppDefine.LOCATION_ID.MTBS,
			layoutCode = TppDefine.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
			clusterId = TppDefine.CLUSTER_DEFINE.Develop,
		})
	else
		TppMission.ShowMissionReward()
	end
end

this.OnEndMissionReward = function()
	local missionName = TppMission.GetMissionName()

	if missionName ~= "s10151" then
		TppMission.MissionFinalize()
	elseif svars.isCleardS10151 then
		TppSequence.SetNextSequence("Seq_Demo_Ending3", { isExecMissionClear = true })
	else
		TppUiCommand.ShowChapterTelop("pre", 2)
		TppSequence.SetNextSequence("Seq_movie_Preview", { isExecMissionClear = true })
	end
end

function this.ReserveMissionClear()
	local missionName = TppMission.GetMissionName()
	if missionName == "s10151" then
		TppMission.ReserveMissionClear({
			missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
			nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE,
		})
	else
		TppMission.ReserveMissionClear({
			missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
			nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI,
		})
	end
end

function this.OnTerminate()
	Fox.Log("____________________________________s10151_sequence.OnTerminate()")

	TppUiStatusManager.ClearStatus("AnnounceLog")

	TppUI.UnsetOverrideFadeInGameStatus()
	TppUiCommand.SetAllInvalidMbSoundControllerVoice(false)

	TppGameStatus.Reset("s10151", "S_ENABLE_TUTORIAL_PAUSE")

	TppUiCommand.LyricTexture("release")

	TppEffectUtility.SetDirtyModelMemoryStrategy("Default")

	TppUI.SetFadeColorToBlack()

	TppEffectUtility.ClearFxCutLevelMaximum()
end

this.OnEndMissionPrepareSequence = function()
	if TppSequence.GetMissionStartSequenceName() == "Seq_Game_BattleSahelan" then
		this.CreateEffectSmoke(true)
	end

	if
		TppSequence.GetMissionStartSequenceName() == "Seq_Demo_BreakSahelan"
		or TppSequence.GetMissionStartSequenceName() == "Seq_Demo_DeadSkullFace"
		or TppSequence.GetMissionStartSequenceName() == "Seq_Game_KillSkullFace"
		or TppSequence.GetMissionStartSequenceName() == "Seq_Demo_AfterDeadSkullFace"
	then
		WeatherManager.RequestTag("Sahelan_fog", 0)
	end

	if
		TppSequence.GetMissionStartSequenceName() == "Seq_Demo_SahelanAppearance"
		or TppSequence.GetMissionStartSequenceName() == "Seq_Game_BattleSahelan"
	then
		Fox.Log("____________s10151_sequence.ResetGimmick()")
		local towerPath = "afgh_sttw002_vrtn004_gim_i0000|TppSharedGimmick_afgh_sttw002_vrtn004"
		local cablePath = "cypr_cabl002_vrtn005_gim_i0000|TppSharedGimmick_cypr_cabl002_vrtn005"

		local asset_127_123 = "/Assets/tpp/level/location/afgh/block_small/127/127_123/afgh_127_123_asset.fox2"
		local asset_128_123 = "/Assets/tpp/level/location/afgh/block_small/128/128_123/afgh_128_123_asset.fox2"
		local asset_128_124 = "/Assets/tpp/level/location/afgh/block_small/128/128_124/afgh_128_124_asset.fox2"
		local asset_128_125 = "/Assets/tpp/level/location/afgh/block_small/128/128_125/afgh_128_125_asset.fox2"
		local asset_128_126 = "/Assets/tpp/level/location/afgh/block_small/128/128_126/afgh_128_126_asset.fox2"
		local asset_129_124 = "/Assets/tpp/level/location/afgh/block_small/129/129_124/afgh_129_124_asset.fox2"
		local asset_129_126 = "/Assets/tpp/level/location/afgh/block_small/129/129_126/afgh_129_126_asset.fox2"

		local asset_130_123 = "/Assets/tpp/level/location/afgh/block_small/130/130_123/afgh_130_123_asset.fox2"
		local asset_130_125 = "/Assets/tpp/level/location/afgh/block_small/130/130_125/afgh_130_125_asset.fox2"

		Gimmick.ResetSharedGimmickData(towerPath, asset_127_123)
		Gimmick.ResetSharedGimmickData(towerPath, asset_128_123)
		Gimmick.ResetSharedGimmickData(towerPath, asset_128_124)
		Gimmick.ResetSharedGimmickData(towerPath, asset_128_125)
		Gimmick.ResetSharedGimmickData(towerPath, asset_128_126)
		Gimmick.ResetSharedGimmickData(towerPath, asset_129_124)
		Gimmick.ResetSharedGimmickData(towerPath, asset_129_126)
		Gimmick.ResetSharedGimmickData(towerPath, asset_130_123)
		Gimmick.ResetSharedGimmickData(towerPath, asset_130_125)

		Gimmick.ResetSharedGimmickData(cablePath, asset_127_123)
		Gimmick.ResetSharedGimmickData(cablePath, asset_128_123)
		Gimmick.ResetSharedGimmickData(cablePath, asset_128_124)
		Gimmick.ResetSharedGimmickData(cablePath, asset_128_126)
		Gimmick.ResetSharedGimmickData(cablePath, asset_130_123)
		Gimmick.ResetSharedGimmickData(cablePath, asset_130_125)
	end
end

this.missionObjectiveDefine = {

	default_area_Sahelan = {},

	default_photo_Sahelan = {
		photoId = 10,
		addFirst = true,
		photoRadioName = "s0150_mirg0040",
	},

	missionTask_break_Sahelan = {
		missionTask = { taskNo = 0, isNew = true, isComplete = false },
	},
	clear_missionTask_break_Sahelan = {
		missionTask = { taskNo = 0, isNew = true, isComplete = true },
	},

	firstBonus_MissionTask = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = true },
	},
	secondBonus_MissionTask = {
		missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide = true },
	},

	clear_firstBonus_MissionTask = {
		missionTask = { taskNo = 1, isNew = true },
	},
	clear_secondBonus_MissionTask = {
		missionTask = { taskNo = 2, isNew = true },
	},

	announce_destroyTarget = {
		announceLog = "destroyTarget",
	},
	announce_achieveAllObjectives = {
		announceLog = "achieveAllObjectives",
	},
}

this.missionObjectiveTree = {
	default_area_Sahelan = {},
	default_photo_Sahelan = {},
	clear_missionTask_break_Sahelan = {
		missionTask_break_Sahelan = {},
	},
	clear_firstBonus_MissionTask = {
		firstBonus_MissionTask = {},
	},
	clear_secondBonus_MissionTask = {
		secondBonus_MissionTask = {},
	},
	announce_destroyTarget = {},
	announce_achieveAllObjectives = {},
}

this.missionStartPosition = {
	helicopterRouteList = {},
	orderBoxList = {},
}

function this.Messages()
	local messageTable = {
		GameObject = {
			{
				msg = "SahelanAllDead",
				func = function()
					Fox.Log("SahelanAllDead message received.")
				end,
				option = { isExecMissionClear = true },
			},
			nil,
		},
		UI = {
			{
				msg = "EndChapterTelop",
				func = function()
					Fox.Log("____________EndChapterTelop_______________")
					TppSequence.SetNextSequence("Seq_Demo_Ending3", { isExecMissionClear = true })
				end,
				option = { isExecMissionClear = true },
			},
			nil,
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
	}
	return StrCode32Table(messageTable)
end

this.s10151_baseOnActiveTable = {
	afgh_powerPlant = function()
		Fox.Log("s10151_baseOnActiveTable : afgh_powerPlant")

		local EVENT_DOOR_NAME = "gntn_door004_vrtn002_gim_n0001|srt_gntn_door004_vrtn002"
		local EVENT_DOOR_PATH = "/Assets/tpp/level/location/afgh/block_large/powerPlant/afgh_powerPlant_gimmick.fox2"

		TppDataUtility.SetVisibleDataFromIdentifier("powerPlant_asset_DataIdentifier", "GateDoor", false, true)
		Gimmick.SetEventDoorInvisible(EVENT_DOOR_NAME, EVENT_DOOR_PATH, true)
	end,
}

local objectiveGroup = {

	MissionStart = function()
		TppMission.UpdateObjective({
			objectives = {
				"default_photo_Sahelan",
				"missionTask_break_Sahelan",
				"firstBonus_MissionTask",
				"secondBonus_MissionTask",
			},
		})

		TppMission.UpdateObjective({
			radio = {

				radioGroups = "s0150_rtrg0160",
			},
			objectives = {
				"default_area_Sahelan",
			},
		})

		TppRadio.SetOptionalRadio("Set_s0150_oprg0030")
	end,

	BreakSahelan = function()
		TppMission.UpdateObjective({
			objectives = { "announce_destroyTarget" },
		})

		TppMission.UpdateObjective({
			objectives = { "announce_achieveAllObjectives" },
		})

		TppMission.UpdateObjective({
			objectives = {
				"clear_missionTask_break_Sahelan",
			},
		})
	end,

	BreakSahelanHead = function()
		TppMission.UpdateObjective({
			objectives = {
				"clear_firstBonus_MissionTask",
			},
		})

		TppResult.AcquireSpecialBonus({
			first = { isComplete = true },
		})
	end,

	HitMaints = function()
		TppMission.UpdateObjective({
			objectives = {
				"clear_secondBonus_MissionTask",
			},
		})

		TppResult.AcquireSpecialBonus({
			second = { isComplete = true },
		})
	end,
}

this.UpdateObjectives = function(objectiveName)
	Fox.Log("__________s10151_sequence.UpdateObjectives()  / " .. tostring(objectiveName))
	local Func = objectiveGroup[objectiveName]
	if Func and Tpp.IsTypeFunc(Func) then
		Func()
	end
end

this.SetVisiblePowerPlant = function()
	TppDataUtility.SetVisibleDataFromIdentifier("powerPlant_asset_DataIdentifier", "GateDoor", false, true)
	TppDataUtility.SetVisibleDataFromIdentifier("powerPlant_asset_DataIdentifier", "afgh_sttw002_0000", false, false)
end

this.SetVisibleUIStatus = function()
	local exceptGameStatus = {}
	for key, value in pairs(TppDefine.GAME_STATUS_TYPE_ALL) do
		exceptGameStatus[key] = false
	end
	for key, value in pairs(TppDefine.UI_STATUS_TYPE_ALL) do
		exceptGameStatus[key] = false
	end

	exceptGameStatus["PauseMenu"] = nil

	TppUI.OverrideFadeInGameStatus(exceptGameStatus)
end

this.CreateEffectSmoke = function(enabled)
	Fox.Log("______________s10151_sequence.CreateEffectSmoke()")

	if enabled then
		TppDataUtility.CreateEffectFromGroupId("BattleFx")

		TppDataUtility.CreateEffectFromId("pp_ash")
	else
		TppDataUtility.DestroyEffectFromGroupId("BattleFx")
	end
end

this.KillAiSahelan = function()
	Fox.Log("______________s10151_sequence.KillAiSahelan()")
	local gameObjectId = { type = "TppSahelan2", group = 0, index = 0 }
	local command = { id = "SetStopSahelan" }
	GameObject.SendCommand(gameObjectId, command)
end

sequences.Seq_Demo_SahelanAppearance = {
	Messages = function(self)
		return StrCode32Table({
			UI = {
				{

					msg = "StartMissionTelopFadeOut",
					func = function()
						Fox.Log("!!!!!!!!!!!!!!!!! s10151_sequence: StartMissionTelopFadeOut !!!!!!!!!!!!!!!")
						self.OnEndMissionTelop()

						TppUI.ShowAccessIcon()
					end,
				},
			},
			Demo = {
				{
					msg = "Play",
					func = function()
						Fox.Log("_________s10151_sequence.Messages(): Demo: Play")

						TppUI.HideAccessIcon()
					end,
					option = {
						isExecDemoPlaying = true,
					},
				},
				{
					msg = "BattleFx_on",
					func = function()
						Fox.Log("_________s10151_sequence.Messages(): Demo: BattleFx_on")

						this.CreateEffectSmoke(true)
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil,
			},

			nil,
		})
	end,

	OnEnter = function()
		TppUI.StartMissionTelop()
	end,

	OnLeave = function()
		TppMission.UpdateCheckPoint({
			checkPoint = "CHK_BattleSahelan",
			ignoreAlert = true,
		})
	end,

	OnEndMissionTelop = function()
		local funcs = function()
			TppSequence.SetNextSequence("Seq_Game_BattleSahelan")
		end
		s10151_demo.SahelanAppearance(funcs)
	end,
}

sequences.Seq_Game_BattleSahelan = {

	Messages = function(self)
		local messageTable = {
			GameObject = {
				{
					msg = "Dead",
					func = function(id)
						Fox.Log(
							"______________s10151_sequence.Seq_Game_BattleSahelan.Messages Dead________________"
								.. tostring(id)
						)
						if id == GameObject.GetGameObjectId("Sahelanthropus") then
							Fox.Log("_______________Sahelanthropus Dead________________")
							self.StopRedStorm()
							self.FuncSahelanDead()
						end
					end,
				},
				{
					msg = "SahelanAllDead",
					func = function()
						Fox.Log(
							"______________s10151_sequence.Seq_Game_BattleSahelan.Messages SahelanAllDead________________"
								.. tostring(id)
						)
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "Damage",
					func = function(id)
						Fox.Log("______________s10151_sequence.Messages Damage________________" .. tostring(id))
						if id == GameObject.GetGameObjectId("Mantis") then
							Fox.Log("_______________MANTIS DAMAGED________________")
							this.UpdateObjectives("HitMaints")
						end
					end,
				},
				{
					msg = "SahelanHeadBroken",
					func = function()
						Fox.Log("______________s10151_sequence.Messages SahelanHeadBroken________________")
						this.UpdateObjectives("BreakSahelanHead")
					end,
				},

				{
					msg = "SahelanEnableHeliAttack",
					func = function()
						Fox.Log("______________s10151_sequence.Messages SahelanEnableHeliAttack________________")

						self.StopRedStorm()

						GameObject.SendCommand(
							{ type = "TppHeli2", index = 0 },
							{ id = "SetAntiSahelanEventEnabled", enabled = true }
						)
					end,
				},

				{
					msg = "SahelanGrenadeExplosion",
					func = function()
						Fox.Log("______________s10151_sequence.Messages SahelanGrenadeExplosion________________")
						if mvars.isNormal then
							self.StartRedStrom(60)
						else
							self.StartRedStrom(90)
						end
					end,
				},

				{
					msg = "SahelanChangePhase",
					func = function(id, phaseName)
						Fox.Log(
							"______________s10151_sequence.Messages SahelanChangePhase________________: " .. phaseName
						)

						mvars.SahelanPhase = phaseName

						if phaseName == TppSahelan2.SAHELAN2_PHASE_2ND then
							s10151_enemy.StartHeliAntiSahelan()
						elseif phaseName == TppSahelan2.SAHELAN2_PHASE_7TH then
						elseif phaseName == TppSahelan2.SAHELAN2_PHASE_8TH then
						end
					end,
				},
				{
					msg = "Sahelan1stRailGun",
					func = function()
						Fox.Log("______________s10151_sequence.Messages Sahelan1stRailGun________________: ")

						mvars.is1stRailGun = true

						GameObject.SendCommand(
							{ type = "TppHeli2", index = 0 },
							{ id = "SetAntiSahelanEventEnabled", enabled = false }
						)

						GameObject.SendCommand({ type = "TppHeli2", index = 0 }, { id = "PullOut" })
					end,
				},
				{
					msg = "SahelanReturned1stRailGun",
					func = function()
						Fox.Log("______________s10151_sequence.Messages SahelanReturned1stRailGun________________: ")

						TppMusicManager.PostSceneSwitchEvent("Set_Switch_bgm_s10151_up")

						s10151_radio.SahelanFinalPhase()
					end,
				},
				{
					msg = "SahelanEnableSuportAttack",
					func = function()
						Fox.Log("______________s10151_sequence.Messages SahelanEnableSuportAttack________________: ")
						if mvars.isNormal then
							self.CallSupportAttack()
						end
					end,
				},

				{
					msg = "SahelanPartsBroken",
					func = function()
						Fox.Log("______________s10151_sequence.Messages SahelanPartsBroken________________: ")
						s10151_radio.PartsBroken()
					end,
				},

				{
					msg = "SahelanBlastDamageToWeakPoint",
					func = function()
						Fox.Log(
							"______________s10151_sequence.Messages SahelanBlastDamageToWeakPoint________________: "
						)

						if mvars.CleanHitCount % 3 == 0 then
							s10151_radio.CleanHit()
						end

						mvars.CleanHitCount = mvars.CleanHitCount + 1
					end,
				},

				{
					msg = "SahelanSearchMissileToHeli",
					func = function()
						Fox.Log("______________s10151_sequence.Messages SahelanSearchMissileToHeli________________: ")
						s10151_radio.HelpSuportHeli()

						self.StopRedStorm()
					end,
				},
			},

			Player = {
				{
					msg = "OnAmmoStackEmpty",
					func = function()
						Fox.Log("______________s10151_sequence.Messages OnAmmoStackEmpty________________")

						self.CallSupportBullet()
					end,
				},
				{
					msg = "StartPlayerBrainFilter",
					func = function(id, reasonID)
						Fox.Log("______________s10151_sequence.Messages StartPlayerBrainFilter________________")
						if reasonID == GameObject.GetGameObjectId("Sahelanthropus") then
							mvars.BrainFilterCount = mvars.BrainFilterCount + 1
							Fox.Log(
								"_____mvars.BrainFilterCount : "
									.. tostring(mvars.BrainFilterCount)
									.. "_____reasonID : "
									.. tostring(reasonID)
							)

							if mvars.BrainFilterCount % 2 == 0 then
								if mvars.isNormal and mvars.SahelanPhase < TppSahelan2.SAHELAN2_PHASE_7TH then
									Fox.Log("_____Sahelan SetSupportAttack")
									local gameObjectId = { type = "TppSahelan2", group = 0, index = 0 }
									local command = { id = "SetSupportAttack" }
									GameObject.SendCommand(gameObjectId, command)
								end
							end
						end
					end,
				},
			},

			Timer = {
				{
					msg = "Finish",
					sender = "RedStromTimer",
					func = function()
						self.StopRedStorm()
					end,
				},

				{
					msg = "Finish",
					sender = "FadeOutTimer",
					func = function()
						Fox.Log(
							"______________s10151_sequence.Seq_Game_BattleSahelan.Messages FadeOutTimer________________"
						)

						TppUI.SetFadeColorToWhite()
						TppUI.FadeOut(0.2)
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "Finish",
					sender = "SahelanAllDeadTimer",
					func = function()
						Fox.Log(
							"______________s10151_sequence.Seq_Game_BattleSahelan.Messages SahelanAllDeadTimer________________"
						)

						TppMission.FinishBossBattle()

						this.ReserveMissionClear()
					end,
					option = { isExecMissionClear = true },
				},
			},
			Weather = {
				{
					msg = "ChangeWeather",
					func = function()
						self.StopRedStorm()
					end,
				},
			},
			Trap = {},
			nil,
		}

		for trapName, s_pos in pairs(SUPPORT_BULLET_POS) do
			local trapTableSuppoertPos = {
				msg = "Enter",
				sender = trapName,
				func = function()
					Fox.Log("______s10151_sequence.trapTableSuppoertPos() : " .. tostring(s_pos))
					mvars.SupportPos = s_pos
				end,
			}
			table.insert(messageTable.Trap, trapTableSuppoertPos)
		end
		return StrCode32Table(messageTable)
	end,

	OnEnter = function(self)
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept(true)
			Dynamite.StartNearestEnemyThread()
			TppCoder.SetWorldCenter(Vector3(-455.89664, 505.80142, -1012.0719))
		end

		mvars.SupportPos = SUPPORT_BULLET_POS.trap_supportPos_AREA03
		mvars.isNormal = false
		mvars.isFirstSupportBullet = false

		local missionName = TppMission.GetMissionName()
		if missionName == "s10151" then
			mvars.isNormal = true
		end

		mvars.BrainFilterCount = 0
		mvars.SahelanPhase = TppSahelan2.SAHELAN2_PHASE_1ST
		mvars.is1stRailGun = false
		mvars.CleanHitCount = 0
		mvars.isFirstRedFog = false

		mvars.mis_isAlertOutOfMissionArea = false
		TppMission.DisableAlertOutOfMissionArea()

		TppTelop.StartMissionObjective()

		TppMarker.Enable("Sahelanthropus", 0, "attack", "map_and_world_only_icon", 0, false, false, "s0150_mprg0030")

		TppSound.SetSceneBGM("bgm_sahelan_02")

		TppMusicManager.PostSceneSwitchEvent("Set_Switch_bgm_s10151_normal")

		this.UpdateObjectives("MissionStart")

		s10151_enemy.SetUpSahelan()

		s10151_enemy.SetUpSupportHeli()

		WeatherManager.RequestTag("Sahelan_fog", 40)

		TppWeather.SetWeatherProbabilitiesAfghNoSandStorm()

		TppMission.StartBossBattle()

		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE
	end,

	OnLeave = function()
		TppDataUtility.DestroyEffectFromId("pp_ash")

		TppSound.StopSceneBGM()

		s10151_enemy.DisableSupportHeli()

		TppMission.UpdateCheckPointAtCurrentPosition()

		TppUI.SetFadeColorToBlack()

		Player.StopTargetConstrainCamera()

		this.KillAiSahelan()
	end,

	FuncSahelanDead = function()
		GkEventTimerManager.Start("SahelanAllDeadTimer", 2.2)
		GkEventTimerManager.Start("FadeOutTimer", 2.0)

		this.UpdateObjectives("BreakSahelan")

		TppMission.CanMissionClear()

		Player.SetPadMask({

			settingName = "ClearControl",

			except = true,

			buttons = PlayerPad.FIRE,
		})
	end,

	CallSupportBullet = function()
		Fox.Log("______s10151_sequence.CallSupportBullet()")

		if mvars.isFirstSupportBullet == false then
			mvars.isFirstSupportBullet = true
			TppSupportRequest.RequestDropBullet({ waitLevel = 7 })
		else
			TppSupportRequest.RequestDropBullet({ pos = mvars.SupportPos })
		end

		s10151_radio.HelpSupportBullet()
	end,

	CallSupportAttack = function()
		Fox.Log("______s10151_sequence.CallSupportAttack()")

		s10151_radio.HelpSupportAttack()

		local gameObjectId = { type = "TppSahelan2", group = 0, index = 0 }
		local command = { id = "GetPosition" }
		local position = GameObject.SendCommand(gameObjectId, command)

		TppSupportRequest.RequestSupportAttack({
			attackType = "BOMBARDMENT_TO_SAHELAN",
			pos = Vector3(position),
			attackLevel = 5,
			waitTime = 0.0,
			isIgnoreSectionFunc = true,
		})
	end,

	StartRedStrom = function(stormTime)
		Fox.Log("______s10151_sequence.StartRedStrom()")
		WeatherManager.RequestTag("Sahelan_RedFog", 7)

		GameObject.SendCommand({ type = "TppHeli2", index = 0 }, { id = "PullOut" })

		TppSoundDaemon.PostEvent("env_para_storm")

		GkEventTimerManager.Start("RedStromTimer", stormTime)

		TppMarker.Disable("Sahelanthropus", "", true)

		local gameObjectId = { type = "TppSahelan2", group = 0, index = 0 }
		local command = { id = "SetParasiteEffect" }
		GameObject.SendCommand(gameObjectId, command)

		if mvars.isFirstRedFog == false then
			mvars.isFirstRedFog = true
			for i = 1, 5 do
				local testID = { type = "TppVehicle2", index = i }
			end
		end
	end,

	StopRedStorm = function()
		Fox.Log("______s10151_sequence.StopRedStorm()")
		WeatherManager.RequestTag("Sahelan_fog", 3)

		TppMarker.Enable("Sahelanthropus", 0, "attack", "map_and_world_only_icon", 0, false, false, "s0150_mprg0030")

		TppSoundDaemon.PostEvent("env_para_storm_end")

		if not mvars.is1stRailGun then
			s10151_enemy.StartHeliAntiSahelan()
		end

		local gameObjectId = { type = "TppSahelan2", group = 0, index = 0 }
		local command = { id = "ResetParasiteEffect" }
		GameObject.SendCommand(gameObjectId, command)
	end,

	SetHeliSequenceCamera = function()
		Fox.Log("______s10151_sequence.SetHeliSequenceCamera()")

		Player.StartTargetConstrainCamera({

			cameraType = PlayerCamera.Around,

			force = true,

			fixed = true,

			recoverPreOrientation = false,

			gameObjectName = "SupportHeli",

			targetFox2Name = "/Assets/tpp/level_asset/chara/heli/support_heli_afgn.fox2",

			interpTime = 1.2,

			interpTimeToRecover = 0.2,

			areaSize = 0.5,

			time = 5,

			cameraOffset = Vector3(0.5, 0.1, 0.0),

			cameraOffsetInterpTime = 0.2,

			targetOffset = Vector3(-0.5, -0.1, 0.0),

			targetOffsetInterpTime = 0.3,

			focalLength = 35.0,

			focalLengthInterpTime = 0.3,

			minDistance = 1.0,

			maxDistanve = 500.0,

			doCollisionCheck = true,
		})
	end,
}

sequences.Seq_Game_LoadSnakeForDD = {

	OnEnter = function(self)
		Fox.Log("sequences.Seq_Game_LoadSnakeForDD.OnEnter()")

		local missionName = TppMission.GetMissionName()
		if missionName == "s10151" then
			if vars.playerType == PlayerType.DD_MALE or vars.playerType == PlayerType.DD_FEMALE then
				TppPlayer.SaveCurrentPlayerType()
				TppPlayer.ForceChangePlayerToSnake()
			else
				self.GotoNextSequence()
			end
		else
			self.GotoNextSequence()
		end

		mvars.playerCheckCount = 0
	end,

	OnUpdate = function(self)
		if mvars.playerCheckCount > 3 then
			if PlayerInfo.OrCheckStatus({ PlayerStatus.PARTS_ACTIVE }) then
				Fox.Log(
					"sequences.Seq_Game_LoadSnakeForDD.OnUpdate(): Finish PlayerInfo.OrCheckStatus{ PlayerStatus.PARTS_ACTIVE, }"
				)
				self.GotoNextSequence()
			end
		else
			mvars.playerCheckCount = mvars.playerCheckCount + 1
		end
	end,

	OnLeave = function(self)
		Fox.Log("sequences.Seq_Game_LoadSnakeForDD.OnLeave()")
	end,

	GotoNextSequence = function()
		TppSequence.SetNextSequence("Seq_Demo_BreakSahelan", { isExecMissionClear = true })
	end,
}

sequences.Seq_Demo_BreakSahelan = {

	OnEnter = function()
		TppUI.SetFadeColorToBlack()

		local funcs = function()
			local missionName = TppMission.GetMissionName()
			if missionName == "s10151" then
				TppSequence.SetNextSequence("Seq_Demo_DeadSkullFace", { isExecMissionClear = true })
			else
				TppSoundDaemon.ResetCutSceneMute(3536485690)
				TppMission.MissionGameEnd()
			end
		end

		s10151_demo.BreakSahelan(funcs)

		mvars.mis_isAlertOutOfMissionArea = false
		TppMission.DisableAlertOutOfMissionArea()
	end,

	OnLeave = function()
		this.CreateEffectSmoke(false)

		TppMission.UpdateCheckPointAtCurrentPosition()
	end,
}

sequences.Seq_Demo_DeadSkullFace = {
	Messages = function(self)
		return StrCode32Table({
			Demo = {
				{
					msg = "Play",
					func = function()
						this.SetVisiblePowerPlant()
						self.SetPlayerWeapon()

						sequences.Seq_Game_KillSkullFace.PlaySkullMotion(
							"/Assets/tpp/motion/SI_game/fani/bodies/wsp0/wsp0/wsp0_p_p31_dam_idl.gani"
						)
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				{
					msg = "changekaz",
					func = function() end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil,
			},
			nil,
		})
	end,

	OnEnter = function()
		local gameObjectId = GameObject.GetGameObjectId("SkullFace")
		local cmdChangeFova = { id = "ChangeFova", bodyId = 376, demoBodyId = 376 }
		GameObject.SendCommand(gameObjectId, cmdChangeFova)

		local funcs = function()
			TppSequence.SetNextSequence(
				"Seq_Game_KillSkullFace",
				{ isExecMissionClear = true, isExecDemoPlaying = true }
			)
		end
		s10151_demo.DeadSkullFace(funcs)

		Player.SetCurrentItemIndex({
			itemIndex = 0,
		})
	end,

	OnLeave = function() end,

	SetPlayerWeapon = function()
		local param = {
			id = "SetSpecialAttackMode",
			enabled = true,
			type = "KillSkullFace",
			sequence = 0,
		}
		GameObject.SendCommand({ type = "TppPlayer2", index = PlayerInfo.GetLocalPlayerIndex() }, param)
		Player.ChangeEquip({
			equipId = TppEquip.EQP_WP_SkullFace_hg_010,
			stock = 0,
			stockSub = 0,
			ammo = 3,
			ammoSub = 0,
			suppressorLife = 0,
			isSuppressorOn = false,
			isLightOn = false,
			dropPrevEquip = false,
			temporaryChange = true,
		})
	end,
}

function this.GetKillSkullFaceExceptGameStatus()
	local exceptGameStatus = {}
	for key, value in pairs(TppDefine.GAME_STATUS_TYPE_ALL) do
		exceptGameStatus[key] = false
	end
	for key, value in pairs(TppDefine.UI_STATUS_TYPE_ALL) do
		exceptGameStatus[key] = false
	end

	exceptGameStatus["PauseMenu"] = nil
	exceptGameStatus["S_DISABLE_PLAYER_PAD"] = nil
	exceptGameStatus["S_DISABLE_NPC"] = nil

	return exceptGameStatus
end

sequences.Seq_Game_KillSkullFace = {
	Messages = function(self)
		return StrCode32Table({
			Player = {
				{
					msg = "FireSkullFace",
					func = function(Gid, shotSeq)
						self.FireSkull(shotSeq)
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil,
			},
			Timer = {
				{
					msg = "Finish",
					sender = "ShotSkullTimer",
					func = self.NextSequence,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				{
					msg = "Finish",
					sender = "FlashBackTimer",
					func = self.NextSequence,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				{
					msg = "Finish",
					sender = "ShotBreathTimer",
					func = function()
						TppSoundDaemon.PostEvent("Play_skll_breath")

						self.PlaySkullMotion("/Assets/tpp/motion/SI_game/fani/bodies/wsp0/wsp0/wsp0_p_p31_dam_idl.gani")
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				{
					msg = "Finish",
					sender = "ShotDemoTimer",
					func = function()
						Fox.Log(
							"_______s10151_sequence.messages/ ShotDemoTimer ____  mvars.shotCount:"
								.. tostring(mvars.shotCount)
						)

						s10151_demo.ShotSkullChangeCamera(funcs)
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil,
			},
			UI = {
				{
					msg = "PauseMenuSkipTutorial",
					func = self.NextSequence,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
			},
			nil,
		})
	end,
	OnEnter = function(self)
		mvars.shotCount = 0

		local exceptGameStatus = this.GetKillSkullFaceExceptGameStatus()
		TppUI.OverrideFadeInGameStatus(exceptGameStatus)

		TppUiStatusManager.SetStatus("AnnounceLog", "SUSPEND_LOG")
		TppUiStatusManager.SetStatus("WorldMarker", "INVALID")

		TppGameStatus.Set("s10151", "S_ENABLE_TUTORIAL_PAUSE")

		self.SetUpSkullFace()

		TppMain.EnablePlayerPad()

		self.SetLimitPad(true)

		GkEventTimerManager.Stop("ShotSkullTimer")
		GkEventTimerManager.Start("ShotSkullTimer", this.SHOT_SKULL_TIME)

		TppSoundDaemon.PostEvent("Play_skll_breath")

		TppDemoUtility.DisablePadZoom()

		TppEffectUtility.SetFxCutLevelMaximum(-1)
	end,
	OnLeave = function(self)
		TppUI.UnsetOverrideFadeInGameStatus()

		TppSoundDaemon.PostEvent("Stop_skll_breath")

		TppGameStatus.Reset("s10151", "S_ENABLE_TUTORIAL_PAUSE")

		self.SetLimitPad(false)
	end,

	SetLimitPad = function(isEnabled)
		if isEnabled then
			Player.SetPadMask({

				settingName = "NoCameraControl",

				except = true,

				buttons = PlayerPad.FIRE,
			})
		else
			Player.ResetPadMask({
				settingName = "NoCameraControl",
			})
		end
	end,

	FireSkull = function(shotSeq)
		Fox.Log("_______s10151_sequence.Seq_Game_KillSkullFace.FireSkull____  shotcount:" .. tostring(shotSeq))

		mvars.shotCount = shotSeq + 1
		local skullMotionList = {
			"/Assets/tpp/motion/SI_game/fani/bodies/wsp0/wsp0/wsp0_p_p31_dam_la.gani",
			"/Assets/tpp/motion/SI_game/fani/bodies/wsp0/wsp0/wsp0_p_p31_dam_lh.gani",
			"/Assets/tpp/motion/SI_game/fani/bodies/wsp0/wsp0/wsp0_p_p31_dam_bd.gani",
		}

		GkEventTimerManager.Stop("ShotSkullTimer")
		GkEventTimerManager.Stop("ShotBreathTimer")

		TppSoundDaemon.PostEvent("Stop_skll_breath")

		sequences.Seq_Game_KillSkullFace.PlaySkullMotion(skullMotionList[shotSeq + 1])

		GkEventTimerManager.Start("ShotDemoTimer", 0.2)

		TppMain.DisablePlayerPad()
	end,

	NextSequence = function()
		GkEventTimerManager.Stop("ShotSkullTimer")
		GkEventTimerManager.Stop("ShotBreathTimer")
		GkEventTimerManager.Stop("ShotDemoTimer")
		GkEventTimerManager.Stop("FlashBackTimer")

		TppSequence.SetNextSequence(
			"Seq_Demo_AfterDeadSkullFace",
			{ isExecMissionClear = true, isExecDemoPlaying = true }
		)
	end,

	PlaySkullMotion = function(motionPath)
		Fox.Log(
			"_______s10151_sequence.Seq_Game_KillSkullFace.PlaySkullMotion____  motionPath :" .. tostring(motionPath)
		)

		local gameObjectId = GameObject.GetGameObjectId("SkullFace")
		GameObject.SendCommand(gameObjectId, {
			id = "SpecialAction",
			action = "PlayMotion",

			path = motionPath,
			autoFinish = false,
			enableMessage = true,
			enableGravity = false,
			enableCollision = false,
		})
	end,

	SetUpSkullFace = function()
		Fox.Log("_______s10151_sequence.Seq_Game_KillSkullFace.SetUpSkullFace()")

		local gameObjectId = GameObject.GetGameObjectId("SkullFace")
		local commandMuteki = { id = "SetDisableDamage", life = true, faint = true, sleep = true }
		local actionState = GameObject.SendCommand(gameObjectId, commandMuteki)

		local commandNoReaction = {
			id = "SetHostage2Flag",
			flag = "disableDamageReaction",
			on = true,
		}
		GameObject.SendCommand(gameObjectId, commandNoReaction)
	end,
}

sequences.Seq_Demo_AfterDeadSkullFace = {
	Messages = function(self)
		return StrCode32Table({
			Demo = {
				{
					msg = "Play",
					func = function()
						this.SetVisiblePowerPlant()
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil,
			},
			nil,
		})
	end,
	OnEnter = function()
		TppUI.SetFadeColorToBlack()

		local funcs = function()
			TppMission.MissionGameEnd()
		end
		s10151_demo.AfterDeadSkullFace(funcs)
	end,
}

sequences.Seq_Demo_Ending1 = {
	Messages = function(self)
		return StrCode32Table({
			Timer = {
				{
					msg = "Finish",
					sender = "TelopTimer",
					func = function()
						TppUiCommand.RegistInfoTypingText("lang", 4, "area_demo_mb")
						TppUiCommand.RegistInfoTypingText("lang", 5, "platform_RD")
						TppUiCommand.ShowInfoTypingText()
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil,
			},
			Demo = {
				{
					msg = "Play",
					func = function()
						GkEventTimerManager.Start("TelopTimer", 2)
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil,
			},
			nil,
		})
	end,

	OnEnter = function(self)
		Fox.Log("____________Seq_Demo_Ending1.onEnter() : ")
		mvars.buddyTypeTmp = vars.buddyType
		mvars.isPlayDemo = false

		TppBuddyService.UnsetDeadBuddyType(BuddyType.DOG)

		if TppBuddyService.CanSortieBuddyType(BuddyType.DOG) then
			vars.buddyType = BuddyType.DOG
		end

		if vars.buddyType == BuddyType.DOG then
			Fox.Log("**********vars.buddyType is BuddyType.DOG :  TppBuddy2BlockController.Load() start ")
			TppBuddy2BlockController.ReserveCallBuddy(BuddyType.NONE, BuddyInitStatus.NORMAL, Vector3(0, 0, 0), 0.0)
			TppBuddy2BlockController.Load()
		else
			Fox.Log("**********vars.buddyType ~= BuddyType.DOG********************")
			self.PlayEnding1()
		end
	end,

	OnUpdate = function(self)
		if vars.buddyType == BuddyType.DOG then
			if TppBuddy2BlockController.IsBlockActive() then
				if not mvars.isPlayDemo then
					Fox.Log(
						"_________s10151_sequence.Seq_Demo_Ending1(): OnUpdate: TppBuddy2BlockController.IsBlockActive() ==> true "
					)
					mvars.isPlayDemo = true
					self.PlayEnding1()
				end
			end
		end
	end,

	PlayEnding1 = function()
		Fox.Log("_________s10151_sequence.sequences.Seq_Demo_Ending1.PlayEnding1() ")
		local funcs = function()
			TppSequence.SetNextSequence("Seq_Loading_SetUpAvatar", { isExecMissionClear = true })
		end
		s10151_demo.Ending01(funcs)
	end,
}

sequences.Seq_Credit_Staff1 = {

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "TppEndingMainStaffFinish",
					func = self.FinishCredit,
					option = { isExecMissionClear = true },
				},
				nil,
			},
			nil,
		})
	end,

	OnEnter = function()
		Player.SetPause()

		TppMain.DisablePlayerPad()

		this.SetVisibleUIStatus()

		TppEnding.Start("Okb_MainStaff")
	end,

	OnLeave = function()
		Player.UnsetPause()
		TppUI.UnsetOverrideFadeInGameStatus()
	end,

	FinishCredit = function()
		TppEnding.Stop()
		TppSequence.SetNextSequence("Seq_Demo_Ending2", { isExecMissionClear = true })
	end,
}

sequences.Seq_Loading_SetUpAvatar = {
	OnEnter = function()
		Fox.Log("________s10151_sequence.Seq_Loading_SetUpAvatar.OnEnter()____________")
		TppSequence.SetNextSequence("Seq_Demo_Ending2", { isExecMissionClear = true })
	end,
}

sequences.Seq_Demo_Ending2 = {
	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "TppEndingMainStaffFinish",
					func = function()
						Fox.Log("_________s10151_sequence.Messages(): Demo: TppEndingMainStaffFinish")

						TppEnding.Stop()
					end,
					option = { isExecMissionClear = true },
				},
				{
					msg = "TppEndingAllStaffFinish",
					func = function()
						Fox.Log("_________s10151_sequence.Messages(): Demo: TppEndingAllStaffFinish")

						TppEnding.Stop()
					end,
					option = { isExecMissionClear = true },
				},
				nil,
			},
			Demo = {
				{
					msg = "start_endroll01",
					func = function()
						Fox.Log("_________s10151_sequence.Messages(): Demo: start_endroll01")

						TppEnding.Start("Okb_MainStaff")
						TppUI.StartLyricEnding(0.3)
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				{
					msg = "start_endroll02",
					func = function()
						Fox.Log("_________s10151_sequence.Messages(): Demo: start_endroll02")

						TppEnding.Start("Okb_StaffRoll")
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil,
			},
			nil,
		})
	end,
	OnEnter = function()
		local funcs = function()
			TppEnding.Stop()
			TppUiCommand.LyricTexture("hide")
			TppMission.ShowMissionReward()
		end
		s10151_demo.Ending02(funcs)
	end,
	OnLeave = function() end,
}

sequences.Seq_Loading_ResetAvatar = {

	OnEnter = function()
		Fox.Log("________s10151_sequence.Seq_Loading_ResetAvatar.OnEnter()____________")

		if svars.isCleardS10151 then
			TppSequence.SetNextSequence("Seq_Demo_Ending3", { isExecMissionClear = true })
		else
			TppSequence.SetNextSequence("Seq_movie_Preview", { isExecMissionClear = true })
		end
	end,
}

sequences.Seq_Credit_Staff2 = {

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "TppEndingAllStaffFinish",
					func = self.FinishCredit,
					option = { isExecMissionClear = true },
				},
				nil,
			},
			nil,
		})
	end,

	OnEnter = function()
		Player.SetPause()

		TppMain.DisablePlayerPad()

		this.SetVisibleUIStatus()

		TppEnding.Start("Okb_StaffRoll")

		TppUI.StartLyricEnding(4.5)
	end,

	OnLeave = function()
		TppUI.UnsetOverrideFadeInGameStatus()
		Player.UnsetPause()
		TppUiCommand.LyricTexture("release")
	end,

	FinishCredit = function()
		TppEnding.Stop()
		TppSequence.SetNextSequence("Seq_Demo_Ending3", { isExecMissionClear = true })
	end,
}

sequences.Seq_movie_Preview = {
	Messages = function(self)
		return StrCode32Table({
			Block = {
				{
					msg = "OnScriptBlockStateTransition",
					func = function(blockName, blockState)
						Fox.Log("________s10151_sequence.OnScriptBlockStateTransition________")
						Fox.Log(
							"blockName is " .. tostring(blockName) .. "        / blockState is " .. tostring(blockState)
						)

						self.ActivatedBlock(blockName, blockState)
					end,
					option = { isExecMissionClear = true },
				},
				nil,
			},

			nil,
		})
	end,
	OnEnter = function(self)
		this.SetVisibleUIStatus()

		local state = ScriptBlock.GetScriptBlockState(ScriptBlock.GetScriptBlockId("demo_block"))
		if state == ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE then
			self.PlayMoviePreview()
		elseif state == ScriptBlock.SCRIPT_BLOCK_STATE_EMPTY then
			TppScriptBlock.LoadDemoBlock("Demo_Movie")
		end
	end,

	ActivatedBlock = function(blockName, blockState)
		Fox.Log("________s10151_sequence.ActivatedBlock()_________")
		Fox.Log("blockName is " .. tostring(blockName) .. " / blockState is " .. tostring(blockState))

		if blockName == Fox.StrCode32("demo_block") then
			if blockState == ScriptBlock.TRANSITION_ACTIVATED then
				if TppScriptBlock.GetCurrentPackListName("demo_block") == "Demo_Movie" then
					sequences.Seq_movie_Preview.PlayMoviePreview()
				end
			end
		end
	end,

	PlayMoviePreview = function()
		Fox.Log("_______s10151_sequence.PlayMoviePreview()  / demo_block is acivated___ play movie preview")
		TppMovie.Play({
			videoName = "p31_050100_movie",
			onEnd = function()
				TppScriptBlock.LoadDemoBlock("Demo_Ending3")
				TppUiCommand.ShowChapterTelop(2, 4)

				TppMusicManager.PostJingleEvent("SingleShot", "Play_chapter_telop")
			end,
			memoryPool = "movie_Preview",
		})
	end,

	OnLeave = function()
		TppUI.UnsetOverrideFadeInGameStatus()
	end,
}

sequences.Seq_Demo_Ending3 = {
	Messages = function(self)
		return StrCode32Table({
			Block = {
				{
					msg = "OnScriptBlockStateTransition",
					func = function(blockName, blockState)
						Fox.Log("________s10151_sequence.OnScriptBlockStateTransition________")
						Fox.Log(
							"blockName is " .. tostring(blockName) .. "        / blockState is " .. tostring(blockState)
						)

						self.ActivatedBlock(blockName, blockState)
					end,
					option = { isExecMissionClear = true },
				},
				nil,
			},
			nil,
		})
	end,
	OnEnter = function(self)
		local state = ScriptBlock.GetScriptBlockState(ScriptBlock.GetScriptBlockId("demo_block"))
		if state == ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE then
			self.PlayMovieEnding3()
		elseif state == ScriptBlock.SCRIPT_BLOCK_STATE_EMPTY then
			TppScriptBlock.LoadDemoBlock("Demo_Ending3")
		end
	end,

	OnUpdate = function(self)
		if DemoDaemon.IsDemoPlaying() then
			TppUiStatusManager.UnsetStatus("PauseMenu", "INVALID")
		end
	end,

	OnLeave = function()
		TppUiCommand.LyricTexture("release")
		this.SetVisibleUIStatus()
	end,

	ActivatedBlock = function(blockName, blockState)
		Fox.Log("________s10151_sequence.ActivatedBlock()_________")
		Fox.Log("blockName is " .. tostring(blockName) .. " / blockState is " .. tostring(blockState))

		if blockName == Fox.StrCode32("demo_block") then
			if blockState == ScriptBlock.TRANSITION_ACTIVATED then
				if TppScriptBlock.GetCurrentPackListName("demo_block") == "Demo_Ending3" then
					sequences.Seq_Demo_Ending3.PlayMovieEnding3()
				end
			end
		end
	end,

	PlayMovieEnding3 = function()
		local funcs = function()
			TppMission.MissionFinalize({ showLoadingTips = false })
		end

		s10151_demo.Ending03(funcs)
	end,
}

return this
