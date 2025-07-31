local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

this.MAX_PLACED_LOCATOR_COUNT = 32	


this.routePointHintTableRoot = {}




local TARGET_ENEMY_NAME = "sol_dealer"
local TARGET_VIP_NAME 	= "sol_vip"
local VIP_STARTMOVE_TIME = 120
local VIP_WAIT_TIME = 3
local VIP_FULTON_GET_INFO_TIME	= 15

this.TRAP = Tpp.Enum{
	"ENTER", 		
	"EXIT",			
}

this.AREA_STATUS = Tpp.Enum{
	"PFCAMP_NORTH", 		
	"SAVANNAH_EAST",		
	"HILL_WEST",			
	"HILL_NORTH",			
	"MEETING_AREA",			
	"NOW_MEETING",			
	"HILL_NORTH_AFTER",		
}




this.missionObjectiveEnum = Tpp.Enum {
	"default_area_savannahEast",
	"default_photo_VIP",
	"default_photo_Daaler",
	"detail_area_VIP",
	"about_area_meeting",
	"about_area_meeting_fulton",
	"detail_area_Dealer",
	"rv_missionClear",
	"about_area_VIP",
	"detail_area_VIP_onlyMarking",
	"about_area_heli",
	"default_subGoal",
	"killTarget_subGoal",
	"escape_subGoal",

	"bonus_Hostage",

	"missionTask_mark_VIP",
	"missionTask_mark_DEALER",
	"missionTask_eliminate_DEALER",
	"firstBonus_MissionTask",
	"secondBonus_MissionTask",
	"thirdBonus_sub_MissionTask",
	"forthBonus_sub_MissionTask",

	"clear_missionTask_mark_VIP",
	"clear_missionTask_mark_DEALER",
	"clear_missionTask_eliminate_DEALER",
	"clear_firstBonus_MissionTask",
	"clear_secondBonus_MissionTask",
	"clear_thirdBonus_sub_MissionTask",
	"clear_forthBonus_sub_MissionTask",

	"vip_dead",
	"announce_eliminateTarget",
	"announce_recoverTarget",
	"announce_achieveAllObjectives",

	"hud_photo_vip",
	"hud_photo_dealer",

	"clear_photo_VIP",
	"clear_photo_Daaler",
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 3 },
	},
	second = {
		missionTask = { taskNo = 4 },
	},
}








function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Game_FollowCommander",
		"Seq_Game_Escape",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	
	isMissionWarning	 = false,			
	isTerminalWatchPhoto = false,			
	isTerminalMapFocusVIP = false,			
	isMoveObjective		= false,			
	isTimerStart 		= false,			

	
	isKnowDealer = false,					
	isKnowDealerPlace = false,				
	isKnowVIP = false,						

	PlayerArea	= this.AREA_STATUS.PFCAMP_NORTH,	

	
	isVipRouteChange = false,				
	isVipDriveCar	= false,				
	isVipMarking	= false,				

	isMeeting = false,
	isEndMeeting = false,					
	isCancelMeeting = false,				

	VipArea = this.AREA_STATUS.SAVANNAH_EAST,	
	VipInterCount	= 0,						
	DealerInterCount	= 0,					

	
	isStartTruck = false,

	isInfo = false,							

	isMissionStart = false,

	isAnomalyDealer = false,				

	
	isArrivalDS = false,					
	isLeaveMA	= false,					

	isChangeVehicle = false,				

	
	isPreliminaryFlag01			= false,	
	isPreliminaryFlag02			= false,	
	isPreliminaryFlag03			= false,	
	isPreliminaryFlag04			= false,	
	isPreliminaryFlag05			= false,	
	isPreliminaryFlag06			= false,	
	isPreliminaryFlag07			= false,	
	isPreliminaryFlag08			= false,	
	isPreliminaryFlag09			= false,	
	isPreliminaryFlag10			= false,	
	isPreliminaryFlag11			= false,	
	isPreliminaryFlag12			= false,	
	isPreliminaryFlag13			= false,	
	isPreliminaryFlag14			= false,	
	isPreliminaryFlag15			= false,	
	isPreliminaryFlag16			= false,	
	isPreliminaryFlag17			= false,	
	isPreliminaryFlag18			= false,	
	isPreliminaryFlag19			= false,	
	isPreliminaryFlag20			= false,	

	PreliminaryValue01			= 0,		
	PreliminaryValue02			= 0,		
	PreliminaryValue03			= 0,		
	PreliminaryValue04			= 0,		
	PreliminaryValue05			= 0,		
	PreliminaryValue06			= 0,		
	PreliminaryValue07			= 0,		
	PreliminaryValue08			= 0,		
	PreliminaryValue09			= 0,		
	PreliminaryValue10			= 0,		
	
	DelearLifeStatus			= TppGameObject.NPC_LIFE_STATE_NORMAL,
	VipLifeStatus				= TppGameObject.NPC_LIFE_STATE_NORMAL,
	isTakeOff 					= false,	
	
	isSolVipCarAccident			= false,	
	isTelephoneRadio 			= false,	
}







this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true



this.checkPointList = {
	nil
}



this.baseList = {
	"savannah",
	"diamondSouth",
	"hillNorth",
	"hillWest",
	"savannahEast",
	"pfCampNorth",
	"pfCampEast",
	nil
}









this.missionObjectiveDefine = {
	
	default_area_savannahEast = {
		gameObjectName = "10195_marker_VIP", viewType = "all", visibleArea = 4, mapRadioName = "s0195_mprg0020",
		randomRange = 0, setNew = false, announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
	},

	default_photo_VIP = {
		photoId	= 10, addFirst = true, photoRadioName = "s0195_mirg0010",
	},

	default_photo_Daaler = {
		photoId = 20, addFirst = true, photoRadioName = "s0195_mirg0020",
	},


	
	about_area_VIP = {
		gameObjectName = TARGET_VIP_NAME, visibleArea = 5,viewType = "map",
		setNew = true, announceLog = "updateMap",
		langId = "marker_ene_coyote",
		goalLangId = "marker_info_mission_targetArea",
	
	},

	
	detail_area_VIP = {
		gameObjectName = TARGET_VIP_NAME, visibleArea = 0,viewType = "map_and_world_only_icon",
		setNew = true, setImportant= true, announceLog = "updateMap",mapRadioName = "s0195_mprg0030",
		langId = "marker_ene_tailing_trgt",
	},

	
	detail_area_VIP_onlyMarking = {
		gameObjectName = TARGET_VIP_NAME, visibleArea = 0,viewType = "map_and_world_only_icon",
		setNew = false, setImportant= false,
		langId = "marker_ene_tailing_trgt",
	},

	about_area_meeting = {
		gameObjectName = "10195_marker_dealer", visibleArea = 4, randomRange = 0, setNew = false, announceLog = "updateMap",
		viewType = "all",
		langId = "marker_info_mission_targetArea",
	},

	about_area_meeting_fulton = {
		gameObjectName = "10195_marker_dealer", visibleArea = 5, randomRange = 0, setNew = false, announceLog = "updateMap",
		viewType = "all",
		langId = "marker_info_mission_targetArea",
	},

	
	detail_area_Dealer = {
		gameObjectName = TARGET_ENEMY_NAME, visibleArea = 0,viewType = "map_and_world_only_icon",
		setNew = true, setImportant= true, announceLog = "updateMap",
		langId = "marker_info_mission_target",
	},

	
	about_area_heli = {
		gameObjectName = "EnemyHeli", visibleArea = 0, viewType = "map_and_world_only_icon", randomRange = 0, setNew = true, announceLog = "updateMap",
		setImportant= true,
		langId = "marker_info_mission_target",
	},

	
	rv_missionClear = {
		gameObjectName = "10195_marker_RV", goalType = "moving", viewType = "all", announceLog = "updateMap",
	},



	
	default_subGoal = {		
		subGoalId= 0,
	},
	killTarget_subGoal = {	
		subGoalId= 1,
	},
	escape_subGoal = {		
		subGoalId= 2,
	},

	
	bonus_Hostage = {
		gameObjectName = "hos_hillNorth", visibleArea = 0,viewType = "map_and_world_only_icon",
		goalType = "none", setNew = true, setImportant= false, announceLog = "updateMap",
		missionTask = { taskNo=1},
	},

	
	missionTask_mark_VIP = {
		missionTask = { taskNo=0, isNew=true, isComplete=false },
	},
	missionTask_mark_DEALER = {
		missionTask = { taskNo=1, isNew=true, isComplete=false },
	},
	missionTask_eliminate_DEALER = {
		missionTask = { taskNo=2, isNew=true, isComplete=false },
	},

	clear_missionTask_mark_VIP = {
		missionTask = { taskNo=0, isNew=true, isComplete=true },
	},
	clear_missionTask_mark_DEALER = {
		missionTask = { taskNo=1, isNew=true, isComplete=true },
	},
	clear_missionTask_eliminate_DEALER = {
		missionTask = { taskNo=2, isNew=true, isComplete=true },
	},

	
	firstBonus_MissionTask = {
		missionTask = { taskNo=3, isNew=true, isComplete=false, isFirstHide=true },
	},
	secondBonus_MissionTask = {
		missionTask = { taskNo=4, isNew=true, isComplete=false, isFirstHide=true },
	},

	clear_firstBonus_MissionTask = {
		missionTask = { taskNo=3, isNew=true },
	},
	clear_secondBonus_MissionTask = {
		missionTask = { taskNo=4, isNew=true },
	},

	
	thirdBonus_sub_MissionTask = {
		missionTask = { taskNo=5, isNew=true, isComplete=false, isFirstHide=true },
	},
	forthBonus_sub_MissionTask = {
		missionTask = { taskNo=6, isNew=true, isComplete=false, isFirstHide=true },
	},

	clear_thirdBonus_sub_MissionTask = {
		missionTask = { taskNo=5, isNew=false, isComplete=true },
	},
	clear_forthBonus_sub_MissionTask = {
		missionTask = { taskNo=6, isNew=false, isComplete=true },
	},

	
	vip_dead = {
	},

	
	announce_eliminateTarget = {
		announceLog = "eliminateTarget",
	},
	announce_recoverTarget = {
		announceLog = "recoverTarget",
	},
	announce_achieveAllObjectives = {
		announceLog = "achieveAllObjectives",
	},


	
	hud_photo_vip = {
		hudPhotoId = 10 
	},
	
	hud_photo_dealer = {
		hudPhotoId = 20 
	},
	
	
	clear_photo_VIP = {
		photoId	= 10, addFirst = true,
	},

	clear_photo_Daaler = {
		photoId = 20, addFirst = true,
	},
}

this.missionObjectiveTree = {

	rv_missionClear = {
		detail_area_VIP_onlyMarking = {},
		detail_area_Dealer = {
			about_area_heli ={
				about_area_meeting = {
					about_area_meeting_fulton ={
						vip_dead = {
							detail_area_VIP = {
								about_area_VIP = {
									default_area_savannahEast = {},
								},
							},
						},
					},
				},
			},
		},
	},
	clear_photo_VIP = {
		default_photo_VIP = {},
	},
	clear_photo_Daaler = {
		default_photo_Daaler = {},
	},
	escape_subGoal = {
		killTarget_subGoal ={
			default_subGoal = {},
		},
	},

	bonus_Hostage = {},

	clear_missionTask_mark_VIP = {
		missionTask_mark_VIP = {},
	},
	clear_missionTask_mark_DEALER = {
		missionTask_mark_DEALER = {},
	},
	clear_missionTask_eliminate_DEALER = {
		missionTask_eliminate_DEALER = {},
	},
	clear_firstBonus_MissionTask = {
		firstBonus_MissionTask = {},
	},
	clear_secondBonus_MissionTask = {
		secondBonus_MissionTask = {},
	},
	clear_thirdBonus_sub_MissionTask = {
		thirdBonus_sub_MissionTask = {},
	},
	clear_forthBonus_sub_MissionTask = {
		forthBonus_sub_MissionTask = {},
	},

	announce_eliminateTarget = {},
	announce_recoverTarget = {},
	announce_achieveAllObjectives = {},

	hud_photo_vip = {},
	hud_photo_dealer = {},

}




this.missionStartPosition = {
		helicopterRouteList = {
			"lz_drp_savannahEast_N0000|rt_drp_savannahEast_N_0000",
			"lz_drp_savannahEast_S0000|lz_drp_savannahEast_S_0000",
			"lz_drp_savannah_I0000|lz_drp_savannah_I",					
		},
		orderBoxList = {
			"box_s10195_00",
			"box_s10195_01",
		},
}








function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")


	
	TppMarker.SetUpSearchTarget{
		{
			gameObjectName = TARGET_ENEMY_NAME, gameObjectType = "TppSoldier2", messageName = TARGET_ENEMY_NAME, skeletonName = "SKL_004_HEAD",
			func = this.commonUpdateMarkerTargetFound, objectives = { "hud_photo_dealer" }
		},
		{
			gameObjectName = TARGET_VIP_NAME, gameObjectType = "TppSoldier2", messageName = TARGET_VIP_NAME, skeletonName = "SKL_004_HEAD",
			func = this.commonUpdateMarkerTargetFound, objectives = { "hud_photo_vip" }
		},
	}

	
	this.RegiserMissionSystemCallback()

	
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppEagle" )
end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	Fox.Log("*** OnRestoreSVars VipArea   : " .. svars.VipArea)
	Fox.Log("*** OnRestoreSVars PlayerArea: " .. svars.PlayerArea)
	


end





function this.OnGameOver()
		if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_ESCAPE_BY_HELI ) then
			
			TppPlayer.SetTargetHeliCamera{ gameObjectName = "EnemyHeli" }

			TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
			return true
		end
end


function this.RegiserMissionSystemCallback()
	Fox.Log("!!!! s10195_mission.RegiserMissionSystemCallback !!!!")

	
	local systemCallbackTable ={
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnGameOver = this.OnGameOver,

		
		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,
		OnOutOfHotZoneMissionClear = this.ReserveMissionClear, 

		OnRecovered = function( gameObjectId )

			Fox.Log("______________s10195_sequence.OnRecovered()  gameObjectId : " .. tostring(gameObjectId))

			local vipId = GameObject.GetGameObjectId("sol_vip")
			local targetId = GameObject.GetGameObjectId("sol_dealer")
			local hostageId = GameObject.GetGameObjectId("hos_hillNorth")

			if vipId == gameObjectId then
				this.UpdateObjectives("RescureVip")
			elseif targetId == gameObjectId then

				this.UpdateObjectives("RescureDealer")
			elseif hostageId == gameObjectId then
				this.UpdateObjectives("RescureHostage")
			else
				Fox.Log("____Who is this ?____")
			end
		end,

		nil
	}
	
	TppMission.RegiserMissionSystemCallback(systemCallbackTable)

end



this.OnEstablishMissionClear = function( missionClearType )
	Fox.Log("*** " .. tostring(missionClearType) .. " OnEstablishMissionClear ***")

	
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

	
	
	if svars.DelearLifeStatus == TppGameObject.NPC_LIFE_STATE_DEAD and svars.isTelephoneRadio == false then
		
	else
		s10195_radio.TelephoneRadio()
	end
end
























function this.Messages()
	return
	StrCode32Table {
		Marker = {
			{ msg = "ChangeToEnable", sender = TARGET_VIP_NAME,
				func = function ( instanceName, makerType, s_gameObjectId, identificationCode )
					
					if identificationCode == Fox.StrCode32("Player") then
						svars.isVipMarking = true	
					end
				end
			},


		
			nil
		},
		GameObject = {
			{
				msg = "RoutePoint2",
				func = function (id,routeId,routeNode,sendM)
					this.OnRoutePointHint(id,routeId,routeNode,sendM)
				end
			},
			{
				
				msg = "ChangePhase",
				func = function ( GameObjectId, phaseName )
					Fox.Log("_____________ChangePhase / id : " .. tostring(GameObjectId))
					
					if ( phaseName == TppGameObject.PHASE_ALERT ) then
						if GameObjectId == GameObject.GetGameObjectId( "sol_vip" ) then
							this.FuncAbortMeeting()
						elseif GameObjectId == GameObject.GetGameObjectId( "sol_dealer" ) or GameObject.GetGameObjectId( "mafr_diamondSouth_ob" )  then
							svars.isAnomalyDealer = true
							this.FuncAbortMeeting()
						end
					end
				end
			},

			{
				
				msg = "VehicleAction",sender = TARGET_VIP_NAME,
				func = function ( rideMemberId, vehicleId, actionType )
					
					if ( actionType == TppGameObject.VEHICLE_ACTION_TYPE_GOT_IN_VEHICLE) then
						svars.isVipDriveCar = true

						s10195_radio.FuncRideOnCar(vehicleId)


					else
						svars.isVipDriveCar = false
					end
					this.SetSoundType()

				end
			},
			{
				msg = "RouteEventFaild",
				func = function (id,routeId,reason)
					Fox.Log("______________s10195_sequence.Messages()   RouteEventFaild : " .. tostring(reason))
					if id == GameObject.GetGameObjectId( TARGET_VIP_NAME ) then
						if reason == TppGameObject.ROUTE_EVENT_FAILED_TYPE_VEHICLE_GET_IN then
							svars.isSolVipCarAccident = true
						end
					end
				end
			},
			{
				
				msg = "ConversationEnd",
				func = function( gameObjectId, speechLabel, isSuccess )

					Fox.Log( "this.Messages(): ConversationEnd Message Received. gameObjectId:" ..
						tostring( gameObjectId ) .. ", speechLabel:" .. tostring( speechLabel ) .. ", isSuccess:" .. isSuccess )

					svars.isEndMeeting =true

					if speechLabel == Fox.StrCode32("CT10195_01") then
						s10195_enemy.OnRoutePoint( nil, nil, nil, Fox.StrCode32("endMeeting") )

						if isSuccess then
							
							
						end

					end
				end
			},
		},
		Subtitles = {
		{
			
			msg = "SubtitlesEndEventMessage",
			func = function( speechLabel, status )
			Fox.Log( "####SubtitlesEndEventMessage ####")
				if (speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf1000_1m1010_0_enea_af" )) then 
					svars.isInfo = true
					svars.isTelephoneRadio = true
					this.UpdateObjectives("GetInfoSecret")
				end
			end
			},
		},
		Sound = {
			{
				
				msg = "ChangeBgmPhase",
				func = function ( bgmPhase )

					Fox.Log("ChangeBgmPhase__ / : "..bgmPhase)

					if bgmPhase == TppSystem.BGM_PHASE_SNEAK_1 or
						bgmPhase == TppSystem.BGM_PHASE_SNEAK_2 or
						bgmPhase == TppSystem.BGM_PHASE_SNEAK_3 then

						this.SetSoundType()

					end
				end
			},
		},
		Trap = {
			{
				msg = "Exit",
				sender = "trap_StartArea",
				func = function ()
					Fox.Log("s10211_mission message do!!")
				end
			},
			{
				msg = "Enter",sender = {"trap_nearSvannahEast","trap_nearHillWest","trap_nearHillNorth","trap_nearMeetingArea"},
				func = function (sender)
					local messageId = this.TRAP.ENTER
					this.FuncSetPlayerArea(sender,messageId)
				end
			},
			{
				msg = "Exit",sender = {"trap_nearSvannahEast","trap_nearHillWest","trap_nearHillNorth","trap_nearMeetingArea"},
				func = function ( sender )
					local messageId = this.TRAP.EXIT
					this.FuncSetPlayerArea(sender,messageId)
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
		nil
	}
end






local objectiveGroup = {

	
	MissionStart = function()
		svars.isMissionStart = true

		TppMission.UpdateObjective{
			objectives = {
				"default_photo_VIP",
				"default_photo_Daaler",
				"default_subGoal",
				"missionTask_mark_VIP",
				"missionTask_mark_DEALER",
				"missionTask_eliminate_DEALER",
				"firstBonus_MissionTask",
				"secondBonus_MissionTask",
				"thirdBonus_sub_MissionTask",
				"forthBonus_sub_MissionTask",
			},

		}
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = { "s0195_rtrg0010" },	
			},
			
			objectives = {
				"default_area_savannahEast",

			},
			options = { isMissionStart = true },
		}
		
		TppRadio.SetOptionalRadio( "Set_s0195_oprg0010" )

	end,

	
	moveObjective = function()

		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = { "s0195_rtrg0210" },
			},
			objectives = { "about_area_VIP" },
		}
		
	

		
	
	end,

	
	MarkingDealer = function()

		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = { "f1000_rtrg2175" },
			},
			objectives = { "detail_area_Dealer","clear_missionTask_mark_DEALER" },
		}
		
		TppRadio.SetOptionalRadio( "Set_s0195_oprg0040" )

				
		TppRadio.ChangeIntelRadio( s10195_radio.intelRadioList_MarkDealer )

		
		if svars.isVipMarking then
			TppMission.UpdateObjective{
				objectives = { "detail_area_VIP_onlyMarking" },
			}
		end
	end,

	
	MarkingVip = function()

		if not svars.isKnowDealer and not svars.isCancelMeeting then
			TppMission.UpdateObjective{
				radio = {
					radioGroups = { "s0195_rtrg0030", },
				},
				objectives = { "detail_area_VIP","clear_missionTask_mark_VIP", },
			}

			
			TppRadio.SetOptionalRadio( "Set_s0195_oprg0060" )

		else
			TppMission.UpdateObjective{

				radio = {
					radioGroups = { "s0195_rtrg0340" },
				},

				objectives = { "detail_area_VIP_onlyMarking","clear_missionTask_mark_VIP" },
			}
		end

		
		TppRadio.ChangeIntelRadio( s10195_radio.intelRadioList_MarkVip )

	end,

	
	InterVip = function()
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = { "s0195_rtrg0160" },
			},
			objectives = { "about_area_meeting" },
		}

		
		TppRadio.SetOptionalRadio( "Set_s0195_oprg0060" )

		svars.isKnowDealerPlace = true
	end,


	
	FlutonVip = function()
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = { "s0195_rtrg0180" },
			},
			objectives = { "about_area_meeting_fulton" },
		}

		
		TppRadio.SetOptionalRadio( "Set_s0195_oprg0060" )

		svars.isKnowDealerPlace = true
	end,

	
	TargetHeli = function()

		TppMission.UpdateObjective{
			radio = {
				radioGroups = { "s0195_rtrg0350" },
			},
			objectives = { "about_area_heli" },
		}
		
		
		TppRadio.SetOptionalRadio( "Set_s0195_oprg0040" )
		
	end,


	
	AbortMeeting = function()
		TppMission.UpdateObjective{
			objectives = { "killTarget_subGoal"},
		}
	end,

	
	Escape = function()
		TppMission.UpdateObjective{
			objectives = { "escape_subGoal"},
		}
		
		TppRadio.SetOptionalRadio( "Set_s0195_oprg0080" )
	end,

	
	KillDealer = function()
		TppSound.StopSceneBGM()	
	
		
		
		
		if svars.DelearLifeStatus == TppGameObject.NPC_LIFE_STATE_DEAD then
			TppMission.UpdateObjective{
				objectives = { "announce_eliminateTarget" },
			}
		
		else
			TppMission.UpdateObjective{
				objectives = { "announce_recoverTarget" },
			}
		end

		TppMission.UpdateObjective{
			objectives = { "announce_achieveAllObjectives" },
		}

		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_eliminate_DEALER" },
		}
	end,

	
	RescureDealer = function()
	
		
		if svars.DelearLifeStatus == TppGameObject.NPC_LIFE_STATE_DEAD then
			TppMission.UpdateObjective{
				objectives = { "announce_eliminateTarget" },
			}
		
		else
			TppMission.UpdateObjective{
				objectives = { "announce_recoverTarget" },
			}
		end

		TppMission.UpdateObjective{
			objectives = { "announce_achieveAllObjectives" },
		}

		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_eliminate_DEALER" },
		}

		TppMission.UpdateObjective{
			objectives = { "clear_firstBonus_MissionTask"},
		}
		
		TppResult.AcquireSpecialBonus{
			first = { isComplete = true },
		}
	end,

	
	RescureVip = function()

		TppMission.UpdateObjective{
			objectives = { "clear_secondBonus_MissionTask" },
		}
		
		TppResult.AcquireSpecialBonus{
			second = { isComplete = true },
		}

	end,
	
	RescureHostage = function()
		TppMission.UpdateObjective{
			objectives = { "clear_thirdBonus_sub_MissionTask" },
		}
	end,
	
	GetInfoSecret = function()
		TppMission.UpdateObjective{
			objectives = { "clear_forthBonus_sub_MissionTask" },
		}
	end,

	DeadVip = function()
		TppMission.UpdateObjective{
			objectives = { "vip_dead" },
		}
		
		TppRadio.SetOptionalRadio( "Set_s0195_rtrg0060" )

	end,
}


this.UpdateObjectives = function( objectiveName )
	Fox.Log("__________s10150_sequence.UpdateObjectives()  / " .. tostring(objectiveName))
	local Func = objectiveGroup[ objectiveName ]
	if Func and Tpp.IsTypeFunc( Func ) then
		Func()
	end


end






function this.FuncAbortMeeting()

	Fox.Log("__________________s10195_sequence.FuncAbortMeeting()")



	if( svars.isCancelMeeting == false ) then
		svars.isCancelMeeting = true

		if svars.isAnomalyDealer then
			Fox.Log("__________________Dealer(Target) is Anomaly.")
		else
			
			s10195_enemy.OnRoutePoint( nil,nil,nil,Fox.StrCode32("CancelMeetingVIP") )
		end

		
		if this.IsDealerUnconscious() == false then
			s10195_radio.CancelMeeting()
		end
		
		s10195_enemy.DealerReturn()
			
		this.UpdateObjectives("DeadVip")

		this.UpdateObjectives("AbortMeeting")
			
		
		TppSound.SetSceneBGM( "bgm_target_escape")

		
		TppMission.UpdateObjective{ objectives = { "clear_photo_VIP" }, }

	else

		Fox.Log("__________________svars.isCancelMeeting == true")
		
		this.OffCheckPointSave()

	end

end

this.IsDealerUnconscious = function()
	local dealerState = TppEnemy.GetLifeStatus( "sol_dealer" ) 
	
	Fox.Log("s10195_sequence.IsDealerUnconscious() : "..tostring(dealerState))
	
	if dealerState == TppGameObject.NPC_LIFE_STATE_NORMAL then
		return false
	else
		return true
	end

end

function this.FuncSetPlayerArea(sender,messageId)

	Fox.Log("s10195_sequence.FuncSetPlayerArea() : "..sender.." messageId : "..messageId)

	if( sender == StrCode32("trap_nearMeetingArea" )) then
		if( messageId == this.TRAP.ENTER) then
			svars.PlayerArea = this.AREA_STATUS.MEETING_AREA
		elseif( messageId == this.TRAP.EXIT) then
			svars.PlayerArea = this.AREA_STATUS.HILL_NORTH
		end

	elseif(sender ==StrCode32("trap_nearHillNorth")) then
		if( messageId == this.TRAP.ENTER)and(svars.PlayerArea<this.AREA_STATUS.MEETING_AREA) then
			svars.PlayerArea = this.AREA_STATUS.HILL_NORTH
		elseif( messageId == this.TRAP.EXIT) then
			svars.PlayerArea = this.AREA_STATUS.HILL_WEST
		end

	elseif(sender ==StrCode32("trap_nearHillWest")) then
		if( messageId == this.TRAP.ENTER)and(svars.PlayerArea<this.AREA_STATUS.HILL_NORTH) then
			svars.PlayerArea = this.AREA_STATUS.HILL_WEST
		elseif( messageId == this.TRAP.EXIT) then
			svars.PlayerArea = this.AREA_STATUS.SAVANNAH_EAST
		end
	elseif(sender ==StrCode32("trap_nearSvannahEast")) then
		if( messageId == this.TRAP.ENTER)and(svars.PlayerArea<this.AREA_STATUS.HILL_WEST) then
			svars.PlayerArea = this.AREA_STATUS.SAVANNAH_EAST
		elseif( messageId == this.TRAP.EXIT) then
			svars.PlayerArea = this.AREA_STATUS.PFCAMP_NORTH
		end

	end

end



function this.commonUpdateMarkerTargetFound( messageName, gameObjectId, msg )
	if gameObjectId == GameObject.GetGameObjectId( TARGET_ENEMY_NAME) then
		svars.isKnowDealer = true
		this.UpdateObjectives("MarkingDealer")


	elseif gameObjectId == GameObject.GetGameObjectId( TARGET_VIP_NAME ) then
		svars.isKnowVIP = true
		this.UpdateObjectives("MarkingVip")

	end

	this.SetSoundType()

end



function this.infoPhote_vip()

	if TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == true        then
		Fox.Log("already Important Marker ... Nothing Done !!")
	else
		TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
		TppMission.UpdateObjective{ objectives = { "hud_photo_vip" }, }
	end	
end

function this.infoPhote_dealer()

	if TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == true        then
		Fox.Log("already Important Marker ... Nothing Done !!")
	else
		TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
		TppMission.UpdateObjective{ objectives = { "hud_photo_dealer" }, }
	end
end

this.SetSoundType = function()

	Fox.Log("________________s10195_sequence.SetSoundType()")
	local SPY_DISTANCE = 200


	if this.IsBGMFollow() then

		
		if this.PlayerToVipDistance() < SPY_DISTANCE then
			if not svars.isChangeVehicle then
				TppSound.SetPhaseBGM( "bgm_follow" )
			else
				TppSound.SetPhaseBGM( "bgm_follow_02" )
			end
		else
			TppSound.SetPhaseBGM( "bgm_follow_normal" )
		end

	else
		TppSound.SetPhaseBGM( "bgm_follow_normal" )
	end

end

this.IsBGMFollow = function()

	
	if svars.isKnowDealer == false and
		svars.isEndMeeting == false and
		svars.isKnowVIP 	== true and
		svars.isVipDriveCar == true and
		svars.isCancelMeeting == false then
			return true
	end
	return false
end

this.PlayerToVipDistance = function()
	Fox.Log("s10195_sequence.PlayerToVipDistance()")
	local vipId = GameObject.GetGameObjectId( "sol_vip" )
	local position, rotY = GameObject.SendCommand( vipId, { id="GetPosition", } )
	local p2vip=TppMath.FindDistance( TppMath.Vector3toTable(position), TppPlayer.GetPosition() )

	local PlayerToVipDistance = math.sqrt(p2vip)	

	return PlayerToVipDistance


end





this.routePointHintTableRoot[ Fox.StrCode32( "hint_spyMove" ) ] = {
	func = function()

		if not svars.isKnowVIP and not svars.isKnowDealer then
			if not svars.isMoveObjective then
				svars.isMoveObjective = true
				this.UpdateObjectives("moveObjective")
			else
				Fox.Log("hint_spyMove message/ There is no problem")

			end
		else
			s10195_radio.FollowTheVip()
		end
	end
}



this.routePointHintTableRoot[ Fox.StrCode32( "LeaveMA" ) ] = {
	func = function()
		svars.isLeaveMA = true
	end
}


this.routePointHintTableRoot[ Fox.StrCode32( "heliHelp" ) ] = {
	func = function()
		this.UpdateObjectives("TargetHeli")
	end
}


this.routePointHintTableRoot[ Fox.StrCode32( "heliOut" ) ] = {

	func = function()
		

		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_ESCAPE_BY_HELI,TppDefine.GAME_OVER_RADIO.S10195_TARGET_ESCAPE )

		
		
	

		
		
	end

}


this.routePointHintTableRoot[ Fox.StrCode32( "toNextCar" ) ] = {
	func = function()
		s10195_radio.FuncGotOutCar()
	end
}


this.OnRoutePointHint = function( gameObjectId, routeId, routeNodeIndex, messageId )
	Fox.Log( "s10195_sequence.OnRoutePointHint( gameObjectId:" .. tostring(gameObjectId) .. ", routeId:" .. tostring(routeId) ..
			", routeNodeIndex:" .. tostring(routeNodeIndex) .. ", messageId:" .. tostring(messageId) ..  " )" )

	local routePointHintTable = this.routePointHintTableRoot[ messageId ]
	if routePointHintTable then
		if routePointHintTable.func then
			routePointHintTable.func()
		end
	else
		Fox.Log( "s10195_sequence.OnRoutePointHint(): There is no routeChangeTables!" )
	end

end


this.OffCheckPointSave = function()
	Fox.Log("___________s10195_sequence.OffCheckPointSave")
	TppCheckPoint.Disable{
		baseName = {
			"savannah",
			"diamondSouth",
			"hillNorth",
			"hillWest",
			"savannahEast",
			"pfCampNorth",
			"pfCampEast",
		}
	}
end







sequences.Seq_Game_FollowCommander = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{ 
					msg = "Dead", sender = TARGET_ENEMY_NAME,
					func = function()
						svars.DelearLifeStatus = TppGameObject.NPC_LIFE_STATE_DEAD
						this.infoPhote_dealer()		
						self.FuncTargetNeutralize()
					end
				},
				{ 
					msg = "Fulton", sender = TARGET_ENEMY_NAME,
					func = function()
						this.infoPhote_dealer()		
						self.FuncTargetNeutralize()
					end
				},
				{ 
					msg = "FultonFailed", sender = TARGET_ENEMY_NAME,
					func = function(id,arg1,arg2,type)
						Fox.Log("fulton failed "..type)
						if type == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then	
				
						else
							
							Fox.Log("meybe inside")
						end

					end,
				},
				{ 
					msg = "Conscious", sender = TARGET_ENEMY_NAME,
					func = function()
						svars.isAnomalyDealer = true
						this.FuncAbortMeeting()
					end
				},

				{	
					msg = "PlacedIntoVehicle",sender = TARGET_ENEMY_NAME,
					func = function (passengerID,vehicleID)
						local targetID = GameObject.GetGameObjectId(TARGET_ENEMY_NAME)

						
						if vehicleID == GameObject.GetGameObjectId("SupportHeli") then
							if passengerID == targetID then
								self.FuncTargetNeutralize()
							end
						end
					end
				},

				
				{ 
					msg = "Dead", sender = TARGET_VIP_NAME,
					func = function()
						svars.VipLifeStatus = TppGameObject.NPC_LIFE_STATE_DEAD
						this.infoPhote_vip()	
						this.FuncAbortMeeting()
					end
				},
				{ 
					msg = "Dying", sender = TARGET_VIP_NAME,
					func = this.FuncAbortMeeting
				},
				{ 
					msg = "FultonFailed", sender = TARGET_VIP_NAME,
					func = function(id,arg1,arg2,type)
						Fox.Log("fulton failed "..type)
						if type == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then	
							
						else
							
							Fox.Log("meybe inside")
						end
					end,
				},

				{ 
					msg = "Unconscious", sender = TARGET_VIP_NAME,
					func = function()
						svars.VipLifeStatus = TppGameObject.NPC_LIFE_STATE_FAINT
						this.FuncAbortMeeting()
					end
				},
				{ 
					msg = "Holdup", sender = TARGET_VIP_NAME,
					func = function()
						svars.VipLifeStatus = TppGameObject.NPC_LIFE_STATE_FAINT	
						this.FuncAbortMeeting()
					end
				},

				





				{ 
					msg = "Fulton", sender = TARGET_VIP_NAME,
					func = function()
						this.infoPhote_vip()	
						if svars.isKnowDealerPlace == false then
							
							GkEventTimerManager.Start( "VipGetInfoTimer", VIP_FULTON_GET_INFO_TIME )
							s10195_radio.FultonVip()
						end
						
						
						svars.VipLifeStatus = TppGameObject.NPC_LIFE_STATE_FAINT
						this.FuncAbortMeeting()
					end
				},


				nil
			},
			Trap = {
				{ 	msg = "Enter", sender = "trap_nearVIPstart",
					func = function ()

						s10195_radio.MissionWarning()

						if(svars.isVipRouteChange == false) then
							GkEventTimerManager.Stop( "VipRouteChangeToCarTimer"  )
							GkEventTimerManager.Start( "VipRouteChangeToCarTimer", VIP_WAIT_TIME )
						end
					end
				},

				nil
			},

			Timer = {
				{ msg = "Finish",sender = "VipRouteChangeToCarTimer",func = self.FuncVIPstart },
				{
					msg = "Finish",sender = "VipGetInfoTimer",
					func = function()
						this.UpdateObjectives("FlutonVip")
					end
				},

				nil
			},

			nil
		}
	end,

	OnEnter = function(self)
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		self.FuncCheckContinued()

		
		if not svars.isVipRouteChange then
			svars.isTimerStart = true
			if not GkEventTimerManager.IsTimerActive( "VipRouteChangeToCarTimer" ) then
				GkEventTimerManager.Start( "VipRouteChangeToCarTimer", VIP_STARTMOVE_TIME )
			end
		end

		













	end,

	OnLeave = function ()
		
		
	end,


	
	FuncTargetNeutralize = function()
	

	

		this.UpdateObjectives("KillDealer")

		
		TppSequence.SetNextSequence("Seq_Game_Escape")
	end,

	FuncVIPstart = function()
		if svars.isVipRouteChange == false and svars.isCancelMeeting == false then
			svars.isVipRouteChange = true,
			s10195_enemy.VipStartMove()
		end
	end,

	
	FuncCheckContinued = function()

		if TppMission.IsEnableMissionObjective( "detail_area_Dealer" ) then
			TppRadio.Play{"s0195_rtrg0290"}
		elseif TppMission.IsEnableMissionObjective( "detail_area_VIP" ) then
			TppRadio.Play{"s0195_oprg0060" }
		elseif TppMission.IsEnableMissionObjective( "default_area_savannahEast" ) then
			
			if svars.isVipRouteChange then
				TppRadio.Play{"s0195_oprg0060"}
			else
				TppRadio.Play{"s0195_oprg0010","s0195_oprg0015"}
			end

		else
			
			TppTelop.StartCastTelop()
			this.UpdateObjectives("MissionStart")
		end
	end,


}



sequences.Seq_Game_Escape = {

	OnEnter = function(self)

		TppMission.CanMissionClear()

		this.UpdateObjectives("Escape")
		
		TppMission.UpdateObjective{
			objectives = { "clear_photo_VIP" , "clear_photo_Daaler" , },
		}

	end,

}




return this
