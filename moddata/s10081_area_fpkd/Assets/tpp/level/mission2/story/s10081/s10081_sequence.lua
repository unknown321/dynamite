local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

this.MAX_PLACED_LOCATOR_COUNT = 60
this.MAX_PICKABLE_LOCATOR_COUNT = 30

local TIME_CLER_RADIO = 9
local PHOTO_ID_SPYROOM = 10

this.SPY_STATUS = Tpp.Enum({
	"SPY_WAIT",
	"SPY_ESCAPE",
	"SPY_RIDETRUCK",
	"SPY_INJURED",
	"SPY_ALERT",
	"SPY_HAVEN",
})

this.SPY_ROOM = Tpp.Enum({
	"DOOR",
	"WINDOW",
})

this.missionObjectiveEnum = Tpp.Enum({
	"default_area_diamondWest",
	"default_photo_spy",
	"house_of_spy",
	"prisonbreak_area",
	"truckEscape_area",
	"explosion_area",
	"target_detail",
	"haven_area",
	"rv_missionClear",

	"default_subGoal",
	"escape_subGoal",

	"targetCpSetting",

	"missionTask_rescure_spy",
	"firstBonus_MissionTask",
	"secondBonus_MissionTask",

	"clear_missionTask_rescure_spy",
	"clear_firstBonus_MissionTask",
	"clear_secondBonus_MissionTask",

	"announce_recoverTarget",
	"announce_achieveAllObjectives",

	"escape_subGoal_noAccident",

	"clear_photo_spy",
})

this.specialBonus = {
	first = {
		missionTask = { taskNo = 2 },
	},
	second = {
		missionTask = { taskNo = 3 },
	},
}

function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences({

		"Seq_Game_RescueTarget",
		"Seq_Demo_PrisonBreak",
		"Seq_Game_Escape",

		nil,
	})
	TppSequence.RegisterSequenceTable(sequences)
end

this.saveVarsList = {

	SpyStatus = this.SPY_STATUS.SPY_WAIT,
	RoomEntryState = this.SPY_ROOM.DOOR,

	isWatchPhotoOnce = false,

	isCarridSpyOnce = false,
	isCallSpyHaven = false,

	isExplosionTruck = false,

	isCarChaseEnd = false,

	isGoToSpyRoom = false,

	isKnowSpy = false,
	isPlayerTrukStartArea = false,

	isMissionStart = false,

	SpyVehicleId = 0,

	isNearSpyOnce = false,

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
}

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

this.checkPointList = {}

this.baseList = {
	"banana",
	"diamond",
	"bananaEast",
	"diamondWest",
	"diamondSouth",
	"savannahNorth",
	nil,
}

this.missionObjectiveDefine = {

	default_area_diamondWest = {
		gameObjectName = "10081_marker_diamondWest",
		viewType = "all",
		visibleArea = 5,
		mapRadioName = "f1000_mprg0060",
		randomRange = 0,
		setNew = false,
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
	},

	default_photo_spy = {
		photoId = PHOTO_ID_SPYROOM,
		photoRadioName = "s0081_mirg0030",
	},

	house_of_spy = {
		gameObjectName = "10081_marker_spyHouse",
		viewType = "all",
		visibleArea = 2,
		mapRadioName = "f1000_mprg0060",
		randomRange = 0,
		setNew = false,
		announceLog = "updateMap",
	},

	prisonbreak_area = {
		gameObjectName = "10081_marker_diamondWest",
		visibleArea = 6,
		mapRadioName = "f1000_mprg0060",
		randomRange = 1,
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
	},

	truckEscape_area = {
		gameObjectName = "10081_marker_diamondWest",
		visibleArea = 8,
		mapRadioName = "f1000_mprg0060",
		randomRange = 1,
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
	},

	explosion_area = {
		gameObjectName = "10081_marker_truck",
		viewType = "all",
		visibleArea = 2,
		randomRange = 0,
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
	},

	target_detail = {
		gameObjectName = "hos_spy",
		visibleArea = 0,
		viewType = "map_and_world_only_icon",
		mapRadioName = "f1000_mprg0100",
		setNew = true,
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_target",
	},

	haven_area = {
		gameObjectName = "10081_marker_spyHaven",
		viewType = "all",
		visibleArea = 1,
		randomRange = 0,
		setNew = true,
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
	},

	rv_missionClear = {},

	default_subGoal = {
		subGoalId = 0,
	},
	escape_subGoal = {
		subGoalId = 1,
	},

	targetCpSetting = {
		targetBgmCp = "mafr_diamondWest_ob",
	},

	missionTask_rescure_spy = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false },
	},

	clear_missionTask_rescure_spy = {
		missionTask = { taskNo = 1, isNew = true, isComplete = true },
	},

	firstBonus_MissionTask = {
		missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide = true },
	},
	secondBonus_MissionTask = {
		missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide = true },
	},
	clear_firstBonus_MissionTask = {
		missionTask = { taskNo = 2, isNew = true },
	},
	clear_secondBonus_MissionTask = {
		missionTask = { taskNo = 3, isNew = true },
	},

	announce_recoverTarget = {
		announceLog = "recoverTarget",
	},
	announce_achieveAllObjectives = {
		announceLog = "achieveAllObjectives",
	},

	escape_subGoal_noAccident = {
		subGoalId = 2,
	},

	clear_photo_spy = {
		photoId = PHOTO_ID_SPYROOM,
	},
}

this.missionObjectiveTree = {

	rv_missionClear = {
		target_detail = {
			haven_area = {
				explosion_area = {
					truckEscape_area = {
						prisonbreak_area = {
							house_of_spy = {
								default_area_diamondWest = {},
							},
						},
						targetCpSetting = {},
					},
				},
			},
		},
	},

	clear_photo_spy = {
		default_photo_spy = {},
	},

	clear_missionTask_rescure_spy = {
		missionTask_rescure_spy = {},
	},
	clear_firstBonus_MissionTask = {
		firstBonus_MissionTask = {},
	},
	clear_secondBonus_MissionTask = {
		secondBonus_MissionTask = {},
	},
	announce_recoverTarget = {},
	announce_achieveAllObjectives = {},

	default_subGoal = {},
	escape_subGoal = {},
	escape_subGoal_noAccident = {},
}

this.missionStartPosition = {
	helicopterRouteList = {
		"lz_drp_diamondSouth_W0000|rt_drp_diamondSouth_W_0000",
	},
	orderBoxList = {
		"box_s10081_00",
	},
}

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	TppMarker.SetUpSearchTarget({
		{
			gameObjectName = "hos_spy",
			gameObjectType = "TppHostageUnique",
			messageName = "hos_spy",
			wideCheckRange = 0.01,
			skeletonName = "SKL_004_HEAD",
			func = this.commonUpdateMarkerTargetFound,
		},
	})

	TppMission.RegisterMissionSystemCallback({
		OnEstablishMissionClear = function(missionClearType)
			Fox.Log("_______________Mission clear with VIP. On estableish mission clear")
			Fox.Log(TppSequence.GetCurrentSequenceName())

			s10081_radio.MissionClear()

			if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
				TppPlayer.PlayMissionClearCamera()
				TppMission.MissionGameEnd({
					loadStartOnResult = true,

					fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,

					delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
				})
			else
				TppMission.MissionGameEnd({ delayTime = TIME_CLER_RADIO, loadStartOnResult = true })
				SubtitlesCommand.SetIsEnabledUiPrioStrong(true)
			end

			TppSound.PostJingleOnEstablishMissionClear()

			if svars.SpyStatus == this.SPY_STATUS.SPY_INJURED then
				TppMotherBaseManagement.RemoveStaffS10081()
				s10081_radio.TelephoneRadioDead()
			else
				TppMotherBaseManagement.UnlockedStaffS10081()
				s10081_radio.TelephoneRadioAlive()
			end
		end,

		OnGameOver = this.OnGameOver,

		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,

		OnOutOfHotZoneMissionClear = this.ReserveMissionClear,

		OnSetMissionFinalScore = this.OnSetMissionFinalScore,

		OnRecovered = function(gameObjectId)
			Fox.Log("______________s10081_sequence.OnRecovered()  gameObjectId : " .. tostring(gameObjectId))

			local hosId = GameObject.GetGameObjectId("hos_spy")
			if hosId == gameObjectId then
				this.UpdateObjectives("RescureSpy")

				if svars.SpyStatus ~= this.SPY_STATUS.SPY_INJURED then
					this.UpdateObjectives("RescureBeforeAccident")
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
end

function this.OnGameOver(gameOverType)
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo(TppDefine.GAME_OVER_TYPE.TARGET_DEAD) then
		TppPlayer.SetTargetDeadCamera({ gameObjectName = "hos_spy" })
		TppMission.ShowGameOverMenu({ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME })
		return true
	end
end

function this.OnSetMissionFinalScore(missionClearType)
	if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
		this.UpdateObjectives("RescureOnFoot")
	end
end

this.OnEndMissionPrepareSequence = function()
	if TppSequence.GetMissionStartSequenceName() == "Seq_Game_RescueTarget" then
		Fox.Log("____________s10081_sequence.ResetGimmick()")
		local huttPath = "mafr_hutt005_gim_i0000|TppSharedGimmick_mafr_hutt005"
		local assetPath = "/Assets/tpp/level/location/mafr/block_small/137/137_124/mafr_137_124_asset.fox2"
		Gimmick.ResetSharedGimmickData(huttPath, assetPath)

		if TppDataUtility.IsValidEffectFromId("smoke") then
			TppDataUtility.DestroyImmediateEffectFromId("smoke")
		end
	end
end

function this.OnTerminate()
	Fox.Log("____________________________________s10081_sequence.OnTerminate3()")
end

local objectiveGroup = {

	MissionStart = function()
		svars.isMissionStart = true

		TppMission.UpdateObjective({
			objectives = {
				"default_photo_spy",
				"default_subGoal",
				"targetCpSetting",

				"missionTask_rescure_spy",
				"firstBonus_MissionTask",
				"secondBonus_MissionTask",
			},
		})

		TppMission.UpdateObjective({
			radio = {

				radioGroups = "s0081_rtrg0010",
			},

			objectives = {
				"default_area_diamondWest",
			},
			options = { isMissionStart = true },
		})

		TppRadio.SetOptionalRadio("Set_s0081_oprg0010")
	end,

	SpyPrisonBreak = function()
		local CpPhase = TppEnemy.GetPhase("mafr_diamondWest_ob")

		if CpPhase == TppEnemy.PHASE.ALERT then
			TppMission.UpdateObjective({
				radio = {

					radioGroups = { "s0081_rtrg2015" },
				},
				objectives = { "prisonbreak_area" },
			})
		else
			TppMission.UpdateObjective({
				radio = {

					radioGroups = { "s0081_rtrg2010" },
				},
				objectives = { "prisonbreak_area" },
			})
		end

		TppRadio.SetOptionalRadio("Set_s0081_oprg2010")

		s10081_radio.ResetIntelRadioForHouse()
	end,

	SpyMarking = function()
		if svars.SpyStatus < this.SPY_STATUS.SPY_INJURED then
			if svars.isCallSpyHaven then
				TppMission.UpdateObjective({
					radio = {
						radioGroups = { "f1000_rtrg2170" },
					},
					objectives = { "target_detail" },
				})
			else
				TppMission.UpdateObjective({
					radio = {
						radioGroups = { "s0081_rtrg2020" },
					},
					objectives = { "target_detail" },
				})
			end

			TppRadio.SetOptionalRadio("Set_s0081_oprg5010")
		else
			TppMission.UpdateObjective({
				objectives = { "target_detail" },
			})
			this.InsertTargetPhoto()
		end

		s10081_radio.ResetIntelRadioDefaultAll()
	end,

	SpyHaven = function()
		TppMission.UpdateObjective({
			radio = {
				radioGroups = { "s0081_rtrg4010" },
			},
			objectives = { "haven_area" },
		})

		TppRadio.SetOptionalRadio("Set_s0081_oprg5010")

		s10081_radio.ResetIntelRadioDefaultAll()
	end,

	SpyAccident = function()
		s10081_radio.SpyAccident()

		TppMission.UpdateObjective({
			objectives = { "explosion_area" },
		})

		TppRadio.SetOptionalRadio("Set_s0081_oprg4010")

		if svars.isKnowSpy then
			TppRadio.ChangeIntelRadio({ accidentSmoke = "s0081_esrg3020" })
			TppRadio.SetOptionalRadio("Set_s0081_oprg3010")
		else
			TppRadio.ChangeIntelRadio({ accidentSmoke = "s0081_esrg3010" })
			TppRadio.SetOptionalRadio("Set_s0081_oprg4010")
		end

		TppInterrogation.ResetFlagHigh(GameObject.GetGameObjectId("mafr_diamondWest_ob"))

		s10081_radio.ResetIntelRadioDefaultAll()
	end,

	SpyCarried = function()
		TppMission.UpdateObjective({
			radio = {
				radioGroups = { "s0081_rtrg5020" },
			},
			objectives = { "rv_missionClear", "escape_subGoal" },
		})
		this.InsertTargetPhoto()

		TppSound.StopSceneBGM()

		TppRadio.SetOptionalRadio("Set_s0081_oprg5010")

		s10081_radio.ResetIntelRadioDefaultAll()
		TppRadio.ChangeIntelRadio({ accidentSmoke = "Invalid" })
	end,

	SpyCarriedBeforeAccident = function()
		TppMission.UpdateObjective({
			radio = {
				radioGroups = { "s0081_rtrg2020" },
			},
			objectives = { "escape_subGoal_noAccident" },
		})
		this.InsertTargetPhoto()

		TppRadio.SetOptionalRadio("Set_s0081_oprg5010")

		s10081_radio.ResetIntelRadioDefaultAll()
	end,

	Escape = function()
		TppMission.UpdateObjective({
			radio = {
				radioGroups = { "s0081_rtrg6010" },
			},
			objectives = { "escape_subGoal" },
		})

		TppMission.UpdateObjective({
			objectives = { "clear_photo_spy" },
		})

		this.SetUpPhotoHostage()

		TppRadio.SetOptionalRadio("Set_s0081_oprg9000")

		local gameObjectId = GameObject.GetGameObjectId("SupportHeli")
		GameObject.SendCommand(gameObjectId, { id = "EnablePullOut" })
	end,

	SpyEscapeTruck = function()
		TppMission.UpdateObjective({
			objectives = { "truckEscape_area" },
		})
		s10081_radio.SpyEscapeTruck()

		TppRadio.SetOptionalRadio("Set_s0081_oprg2010")

		s10081_radio.ResetIntelRadioDefaultAll()

		svars.isPreliminaryFlag02 = true
	end,

	RescureSpy = function()
		TppMission.UpdateObjective({
			objectives = { "announce_recoverTarget" },
		})
		TppMission.UpdateObjective({
			objectives = { "announce_achieveAllObjectives" },
		})
		TppMission.UpdateObjective({
			objectives = { "clear_missionTask_rescure_spy" },
		})
	end,

	RescureBeforeAccident = function()
		TppMission.UpdateObjective({
			objectives = { "clear_firstBonus_MissionTask" },
		})

		TppResult.AcquireSpecialBonus({
			first = { isComplete = true },
		})
	end,

	RescureOnFoot = function()
		TppMission.UpdateObjective({
			objectives = { "clear_secondBonus_MissionTask" },
		})

		TppResult.AcquireSpecialBonus({
			second = { isComplete = true },
		})
	end,
}

this.UpdateObjectives = function(objectiveName)
	Fox.Log("__________s10081_sequence.UpdateObjectives()  / " .. tostring(objectiveName))
	local Func = objectiveGroup[objectiveName]
	if Func and Tpp.IsTypeFunc(Func) then
		Func()
	end
end

this.InsertTargetPhoto = function()
	Fox.Log("__________s10081_sequence.InsertTargetPhoto()")
	if not svars.isPreliminaryFlag01 then
		svars.isPreliminaryFlag01 = true

		TppUiCommand.ShowPictureInfoHud("mb_staff", this.GetStaffID10081(), 3.0)
	end
end

function this.commonUpdateMarkerTargetFound(messageName, gameObjectId, msg)
	if gameObjectId == GameObject.GetGameObjectId("hos_spy") then
		svars.isKnowSpy = true
		this.InsertTargetPhoto()
		this.UpdateObjectives("SpyMarking")
	end
end

this.GetStaffID10081 = function()
	local spyId = GameObject.GetGameObjectId("hos_spy")
	local staffId = TppMotherBaseManagement.GetStaffIdFromGameObject({ gameObjectId = spyId })

	return staffId
end

this.SetUpPhotoHostage = function()
	Fox.Log("__________s10081_sequence.SetUpPhotoHostage()")
	TppUiCommand.SetAdditonalMissionPhotoId(10, true, false, this.GetStaffID10081(), 0)
end

function this.Messages()
	return StrCode32Table({
		Player = {
			{
				msg = "PressedFultonNgIcon",
				func = function(id, gameObjectId)
					Fox.Log("_________s10081_sequence.messages.  PressedFultonNgIcon_____charaId : " .. gameObjectId)
					if gameObjectId == GameObject.GetGameObjectId("hos_spy") then
						if TppMarker.GetSearchTargetIsFound("hos_spy") == true then
							TppRadio.Play("s0081_oprg5010")
						else
							TppMarker.CompleteSearchTarget("hos_spy")
							TppUiCommand.RegisterIconUniqueInformation({
								markerId = GameObject.GetGameObjectId("hos_spy"),
								langId = "marker_info_mission_target",
							})
						end
					else
						Fox.Log("MSG::PressedFultonNgIcon No Setting Character !!")
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
			nil,
		},
		GameObject = {
			{
				msg = "Dead",
				sender = "hos_spy",
				func = function()
					TppMission.ReserveGameOver(
						TppDefine.GAME_OVER_TYPE.TARGET_DEAD,
						TppDefine.GAME_OVER_RADIO.TARGET_DEAD
					)
				end,
			},
			{
				msg = "FultonFailed",
				sender = "hos_spy",
				func = function(id, arg1, arg2, type)
					Fox.Log("fulton failed " .. type)
					if type == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
						TppMission.ReserveGameOver(
							TppDefine.GAME_OVER_TYPE.TARGET_DEAD,
							TppDefine.GAME_OVER_RADIO.TARGET_DEAD
						)
					else
						Fox.Log("meybe inside")
					end
				end,
			},
			{
				msg = "Observed",
				func = function()
					s10081_enemy.DestroySpyVehicle()
				end,
			},
			{
				msg = "VehicleBroken",
				func = function(vid, brokenState)
					local strEnd = StrCode32("End")
					local vehicleId = GameObject.GetGameObjectId("Vehs_truck_0000")

					if vid == vehicleId then
						if brokenState == strEnd then
							this.TruckExplosion()
						end
					end
				end,
			},
			nil,
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

this.TruckExplosion = function()
	if svars.SpyStatus == this.SPY_STATUS.SPY_INJURED then
		svars.isExplosionTruck = true

		local position = Vector3(618.750, 93.380, -1109.007)
		TppSoundDaemon.PostEvent3D("Play_sfx_c_explosion_s10081", position)

		TppDataUtility.CreateEffectFromId("smoke")

		local gameObjectId = { type = "TppSoldier2" }
		local command = { id = "AddSpecialNoise", noiseType = 0, pos = { 618.2075, 93.5151, -1110.054 } }
		GameObject.SendCommand(gameObjectId, command)

		this.UpdateObjectives("SpyAccident")

		s10081_enemy.UnsetRouteSpGuardSol()

		s10081_enemy.PursuitUnitTravelStart()

		s10081_enemy.OnRoutePoint(nil, nil, nil, Fox.StrCode32("huntingShift"))

		s10081_enemy.SetKeepCaution()

		TppSound.SetSceneBGM("bgm_chase")
	end
end

this.OffCheckPointSave = function()
	Fox.Log("___________s10081_sequence.OffCheckPointSave()")
	TppCheckPoint.Disable({
		baseName = {
			"banana",
			"diamond",
			"bananaEast",
			"diamondWest",
			"diamondSouth",
			"savannahNorth",
		},
	})
end

sequences.Seq_Game_RescueTarget = {

	Messages = function(self)
		return StrCode32Table({
			Marker = {

				nil,
			},

			Terminal = {
				{
					msg = "MbDvcActWatchPhoto",

					func = function()
						if svars.isWatchPhotoOnce == false then
							svars.isWatchPhotoOnce = true
							TppRadio.ChangeIntelRadio({ hosHouse = "f1000_esrg1250" })
						end
					end,
				},
				nil,
			},

			GameObject = {
				{
					msg = "Fulton",
					sender = "hos_spy",
					func = function()
						TppSequence.SetNextSequence("Seq_Game_Escape")
					end,
				},
				{
					msg = "PlacedIntoVehicle",
					sender = "hos_spy",
					func = function(passengerID, vehicleID)
						local hostageId = GameObject.GetGameObjectId("hos_spy")

						if vehicleID == GameObject.GetGameObjectId("SupportHeli") then
							if passengerID == hostageId then
								TppSequence.SetNextSequence("Seq_Game_Escape")
							end
						end
					end,
				},
				{
					msg = "Carried",
					sender = "hos_spy",
					func = function()
						Fox.Log("____________s10081_sequence :    Spy Carried ")

						this.OffCheckPointSave()

						if svars.isCarridSpyOnce == false then
							svars.isCarridSpyOnce = true

							GkEventTimerManager.Start("SpyTalkStartTimer", 8)

							TppEnemy.UnsetSneakRoute("hos_spy")

							if svars.SpyStatus == this.SPY_STATUS.SPY_INJURED then
								self.FuncCallAutoHeli()
								this.UpdateObjectives("SpyCarried")

								self.SetSoundPhaseBGM()
							else
								this.UpdateObjectives("SpyCarriedBeforeAccident")
							end
						end
					end,
				},
				{
					msg = "PlayerGetNear",
					func = function()
						Fox.Log("____________s10081_sequence :    Player Get Near ")

						if svars.isExplosionTruck then
							s10081_radio.NearTarget()
						else
							Fox.Log("Talk Spy 「Boss...」 ")

							if not svars.isNearSpyOnce then
								svars.isNearSpyOnce = true
								s10081_enemy.SpyMonologue("speech081_carry020", false)

								TppEnemy.UnsetSneakRoute("hos_spy")
							end
						end
					end,
				},

				{
					msg = "ChangePhase",
					sender = "mafr_diamondWest_ob",
					func = function(cpGameObjectId, phaseName) end,
				},

				nil,
			},

			Trap = {

				{
					msg = "Enter",
					sender = "trap_prisonBreakDoor",
					func = function()
						svars.RoomEntryState = this.SPY_ROOM.DOOR
						self.FuncDemoPrisonBreak()
					end,
				},
				{
					msg = "Enter",
					sender = "trap_prisonBreakWindow",
					func = function()
						svars.RoomEntryState = this.SPY_ROOM.WINDOW
						self.FuncDemoPrisonBreak()
					end,
				},
				{ msg = "Enter", sender = "trap_TruckStartArea", func = self.FuncTruckStartArea },
				nil,
			},

			Timer = {

				{
					msg = "Finish",
					sender = "SpyHavenTimer",
					func = function()
						this.UpdateObjectives("SpyHaven")
					end,
				},
				{
					msg = "Finish",
					sender = "SpyTalkStartTimer",
					func = function()
						s10081_enemy.SpyMonologue("speech081_carry010", true)
					end,
				},
			},

			nil,
		})
	end,

	OnEnter = function(self)
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept(true)
			Dynamite.StartNearestEnemyThread()
			TppCoder.SetWorldCenter(Vector3(1029.3385, 67.354385, -1005.48193))
		end

		if not svars.isKnowSpy then
		end

		self.FuncCheckContinued()

		TppHelicopter.SetDisableLandingZone({ landingZoneName = "lz_banana_E0000|lz_banana_E_0000" })

		this.SetUpPhotoHostage()
	end,

	OnLeave = function() end,

	FuncCheckContinued = function()
		if TppMission.IsEnableMissionObjective("target_detail") then
			TppRadio.Play({ "s0081_oprg4010" })
		elseif TppMission.IsEnableMissionObjective("prisonbreak_area") then
			TppRadio.Play({ "s0081_oprg2010" })
		elseif TppMission.IsEnableMissionObjective("default_area_diamondWest") then
			if svars.isGoToSpyRoom then
				this.UpdateObjectives("SpyPrisonBreak")
			else
				TppRadio.Play({ "s0081_oprg0010", "f1000_oprg0570" })
			end
		else
			TppTelop.StartCastTelop()
			this.UpdateObjectives("MissionStart")
		end
	end,

	FuncSecondSequence = function() end,

	FuncMarkingTarget = function()
		s10081_enemy.SpyEscape()
	end,

	FuncEnemyFindHostage = function() end,

	FuncDemoPrisonBreak = function()
		if svars.isGoToSpyRoom == false then
			svars.isGoToSpyRoom = true

			if svars.SpyStatus < this.SPY_STATUS.SPY_INJURED and svars.isKnowSpy == false then
				local CpPhase = TppEnemy.GetPhase("mafr_diamondWest_ob")

				if CpPhase == TppEnemy.PHASE.ALERT or svars.isPreliminaryFlag02 then
					this.UpdateObjectives("SpyPrisonBreak")
				else
					TppSequence.SetNextSequence("Seq_Demo_PrisonBreak")
				end
			end
		end
	end,

	FuncTruckStartArea = function()
		svars.isPlayerTrukStartArea = true

		if svars.SpyStatus == this.SPY_STATUS.SPY_ALERT then
			s10081_enemy.SpyEscape()
		end
	end,

	FuncCpAlertPhaseChange = function()
		if svars.isPlayerTrukStartArea == false then
			svars.SpyStatus = this.SPY_STATUS.SPY_ALERT

			s10081_enemy.SpyAlert()
		end
	end,

	FuncCpCautionPhaseChange = function()
		if svars.isPlayerTrukStartArea == false then
			s10081_enemy.SpyEscape()
		end
	end,

	FuncCallAutoHeli = function()
		local gameObjectId = GameObject.GetGameObjectId("SupportHeli")

		TppHelicopter.SetEnableLandingZone({ landingZoneName = "lz_banana_E0000|lz_banana_E_0000" })

		GameObject.SendCommand(
			gameObjectId,
			{ id = "CallToLandingZoneAtName", name = "lz_banana_E0000|lz_banana_E_0000" }
		)
		GameObject.SendCommand(gameObjectId, { id = "DisablePullOut" })
	end,

	SetSoundPhaseBGM = function()
		TppSound.StopSceneBGM()
		TppSound.SetPhaseBGM("bgm_carry")
	end,
}

sequences.Seq_Demo_PrisonBreak = {
	OnEnter = function()
		TppBuddyService.SetIgnoreDisableNpc(true)
		local funcs = function()
			TppBuddyService.SetIgnoreDisableNpc(false)
			TppSequence.SetNextSequence("Seq_Game_RescueTarget")
		end
		s10081_demo.PrisonBreak(funcs)
	end,
	OnLeave = function()
		if svars.SpyStatus < this.SPY_STATUS.SPY_RIDETRUCK then
			TppMission.UpdateCheckPointAtCurrentPosition()
		end
	end,
}

sequences.Seq_Game_Escape = {

	OnEnter = function(self)
		TppMission.CanMissionClear()

		this.UpdateObjectives("Escape")
	end,
}

return this
