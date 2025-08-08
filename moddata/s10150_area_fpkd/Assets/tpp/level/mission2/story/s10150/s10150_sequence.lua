local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}



this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true




this.MAX_PLACED_LOCATOR_COUNT = 10	


local SKULL_TALK_AND_SONG_TIME = 60*6+29	
local LYRIC_TIME = SKULL_TALK_AND_SONG_TIME-127
local PLAY_DELAY_TIME = 10				

local DISTANCE_APPROACH_SKULL = 3.5	
local DISTANCE_APPROACH_TIMER = 1	
local HOKEN_RIDE_DRIVER_TIME = 30		

this.MISSION_TASK_TARGET_LIST = {
	TANK ={
		"vehs_citadel_tank_0000",
		"vehs_citadel_tank_0001",
		"vehs_citadel_tank_0002",
	
	},
	WALKERGEAR ={
		"WalkerGearGameObjectLocator",
		"WalkerGearGameObjectLocator0000",
		"WalkerGearGameObjectLocator0001",
		"WalkerGearGameObjectLocator0002",
	},
	
	CONTAINER = {
		"citadel_cntn001",
		"citadel_cntn002",
		"citadel_cntn003",
		"citadel_cntn004",
		"citadel_cntn005",
		"citadel_cntn006",
		"citadel_cntn007",	
	},
	CASSET = {
		"citadel_casset001",
	},
}



this.NPC_ENTRY_POINT_SETTING = {
	[TppDefine.INIT_HELI_ROUTE] = {
		[EntryBuddyType.VEHICLE] = { Vector3(-1700.08,527.0961,-2295.061), TppMath.DegreeToRadian( 195 ) }, 
		[EntryBuddyType.BUDDY] = { Vector3(-1711.701,528.4319,-2290.729), TppMath.DegreeToRadian( 183 ) }, 
	},
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 2 },
	},
	second = {
		missionTask = { taskNo = 3 },
	},
}






this.ZONE_NAME = Tpp.Enum{
	"SKULL",	
	"SAHELAN",	
	"TALK",		
}

this.HELI_STATE = Tpp.Enum{
	"DEFAULT",	
	"BATTLE",	
	"RETURN",	
}




this.missionObjectiveEnum = Tpp.Enum {
	"default_area_Okb",
	"default_photo_SkullFace",
	"default_photo_Sahelan",
	"detail_area_Okb",
	"followSkullFace",
	
	"default_subGoal",
	"talk_subGoal",
	
	"missionTask_meet_SkullFace",
	"missionTask_GetInfo_SkullFace",
	"firstBonus_MissionTask",
	"secondBonus_MissionTask",
	"thirdBonus_sub_MissionTask",
	"forthBonus_sub_MissionTask",
	
	"clear_missionTask_meet_SkullFace",
	"clear_missionTask_GetInfo_SkullFace",
	"clear_firstBonus_MissionTask",
	"clear_secondBonus_MissionTask",
	"clear_thirdBonus_sub_MissionTask",
	"clear_forthBonus_sub_MissionTask",
	
	"announce_achieveAllObjectives",
}




this.VARIABLE_TRAP_SETTING = {
	
	{ name = "trig_innerZone_01",	type = TppDefine.TRAP_TYPE.TRIGGER,	initialState = TppDefine.TRAP_STATE.DISABLE, },
	{ name = "trig_outerZone_01",	type = TppDefine.TRAP_TYPE.TRIGGER,	initialState = TppDefine.TRAP_STATE.DISABLE, },

	
	{ name = "trig_innerZone_03",	type = TppDefine.TRAP_TYPE.TRIGGER,	initialState = TppDefine.TRAP_STATE.DISABLE, },
	{ name = "trig_outerZone_03",	type = TppDefine.TRAP_TYPE.TRIGGER,	initialState = TppDefine.TRAP_STATE.DISABLE, },

}









function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{

		
		"Seq_Demo_OkbOpening",				
		"Seq_Game_MeetSkullFace",			

		
		"Seq_Demo_SkullFaceAppearance",		
		"Seq_Game_TalkSkullFace",			
		"Seq_Game_SkullFaceToPlant",		

		
		"Seq_Demo_SahelanAppearance",		

		"Seq_ToBeContinued",				
		
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end






this.saveVarsList = {
	isSetPhaseBGM	 = false,			
	getTaskContainer = 0,
	isPlayerInEV = false,				
	isPlayerRidingOn = false,			
		
	isPlaySoundRoad 			= false,	
	EnemyHeliState		= this.HELI_STATE.DEFAULT

}




this.checkPointList = {
	"CHK_MissionStart",		
	
	"CHK_EvHall",			
	"CHK_TalkSkull",		
	"CHK_DriveSkull",		
	"CHK_BattleSahelan",	

	nil
}


this.baseList = {
	"citadel",
	nil
}











function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	
	
	mvars.NgMbCount = 0

	
	this.RegiserMissionSystemCallback()
	
	
	TppLocation.RegistMissionAssetInitializeTable(
		this.s10150_baseOnActiveTable,
		this.s10150_OnActiveSmallBlockTable
	)
	
	
	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "Demo_OpOKBZero" },
	}
		
	
	if TppPackList.IsMissionPackLabel( "StartingSahelan" ) then
		TppEnemy.SetSoldier2CommonPackageLabel( "s10150_special" )
	
	
	elseif TppPackList.IsMissionPackLabel( "SkullFaceAppearance" ) then
		TppBuddyService.SetDisableAllBuddy() 
		TppEnemy.SetSoldier2CommonPackageLabel( "default" )
		TppUiCommand.LyricTexture( "regist_okb" )
	
	
	else
		
		
		TppEnemy.RequestLoadWalkerGearEquip()
		TppEnemy.SetSoldier2CommonPackageLabel( "default" )
	end

end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	Fox.Log("*** " .. tostring(TppSequence.GetMissionStartSequenceName()) .. " OnRestoreSVars ***")
	
	if TppSequence.GetMissionStartSequenceName() == "Seq_Demo_OkbOpening" then
		vars.initialPlayerAction = PlayerInitialAction.FROM_HELI_SPACE
		
	
	elseif TppSequence.GetMissionStartSequenceName() == "Seq_Game_MeetSkullFace" then
		
		this.resetZone()
		this.showZone(this.ZONE_NAME.SKULL)
	
	elseif TppSequence.GetMissionStartSequenceName() == "Seq_Demo_SkullFaceAppearance" then
		
		
	
	elseif TppSequence.GetMissionStartSequenceName() == "Seq_Game_TalkSkullFace" then
		
		s10150_enemy02.WarpSetRoute("trap_0000_EV2")

		GkEventTimerManager.Stop("SkullWarnsPlayerTimer20")
		GkEventTimerManager.Stop("SkullWarnsPlayerTimer30")
		GkEventTimerManager.Stop("SkullWarnsPlayerTimer40")
		GkEventTimerManager.Stop("SkullWarnsPlayerTimer50")
		GkEventTimerManager.Stop("SkullWarnsPlayerTimer110")
		
		
		
		this.resetZone()
		this.showZone(this.ZONE_NAME.TALK)

	elseif TppSequence.GetMissionStartSequenceName() == "Seq_Game_SkullFaceToPlant" then

		s10150_enemy02.SkullWalk()
		s10150_enemy02.OnRoutePoint(nil,nil,nil,Fox.StrCode32( "outEV" ))
		s10150_enemy02.OnRoutePoint(nil,nil,nil,Fox.StrCode32( "outEV2" ))
		mvars.PlayerStateForSkull = 110 
		s10150_enemy02.OnRoutePoint(nil,nil,nil,Fox.StrCode32( "rideSkull" ))
		mvars.tmpSequenceName = "Seq_Game_SkullFaceToPlant"
		s10150_enemy02.SetUpSkullSolBringPlayer(false)
		s10150_enemy02.WarpSetRoute("trap_0100_EV3")
		
		s10150_enemy02.WarpSetHeli("trap_heli0000")
		
		s10150_enemy02.SetUpRelativeVehicle() 
		
		TppSoundDaemon.PostEvent( "State_g_okb_walk_talk" )
		
		GkEventTimerManager.Stop("SkullTalkTimer")		
		GkEventTimerManager.Stop("LyricTimer")			
		GkEventTimerManager.Stop("SOFDelayTimer")		
		GkEventTimerManager.Stop("RideOnDriverTimer")	
		GkEventTimerManager.Stop("PassangerActionTimer")	
		
		
		TppWeather.SetWeatherProbabilitiesAfghNoSandStorm()
		
	
	end
	
	
	
	
end




this.OnEndMissionPrepareSequence = function()
	Fox.Log( "OnEndMissionPrepareSequence()" )
	
	if mvars.tmpSequenceName == "Seq_Game_SkullFaceToPlant" then
		this.UpdateObjectives("FollowSkull")
		
		
		local GameObjectType = TppGameObject.GAME_OBJECT_TYPE_EVENT_ANIMATION
		Gimmick.BreakGimmick(GameObjectType,"afgh_elvt001_gim_n0000|srt_afgh_elvt001","/Assets/tpp/level/location/afgh/block_large/citadel/afgh_citadel_gimmick.fox2",1)
		
		Player.ChangeLifeMaxValue(1)
	end
end


	

function this.RegiserMissionSystemCallback()
	Fox.Log("!!!! s10150_mission.RegiserMissionSystemCallback !!!!")

	
	
	local systemCallbackTable ={

		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnGameOver = this.OnGameOver,
		OnRecovered = this.OnRecovered,							

		nil
	}
	
	TppMission.RegiserMissionSystemCallback(systemCallbackTable)

end


this.OnEstablishMissionClear = function(missionClearType)

	Fox.Log("TppMission.Reload OnEndFadeOut") 

	TppSequence.ReserveNextSequence( "Seq_Demo_SahelanAppearance" , { isExecMissionClear = true })

	
	TppScriptBlock.LoadDemoBlock(
		"Demo_SahelanAppearance",
		false 
	)

	
	TppGameStatus.Reset( "s10150","S_ENABLE_TUTORIAL_PAUSE" )
	TppUI.UnsetOverrideFadeInGameStatus()
	TppUiCommand.SetAllInvalidMbSoundControllerVoice( false ) 
	
	TppUiCommand.LyricTexture( "release" ) 

	
	Player.ResetLifeMaxValue()
	
	TppSound.StopSceneBGM()

	TppMission.Reload{
		OnEndFadeOut = function()
			
			TppMission.UpdateCheckPointAtCurrentPosition()
			
			
			this.UpdateObjectives("DriveEnd")
			
			
			TppPlayer.SetInitialPosition( {-695.002,532.4105,-1688.287}, 0 )
		end,

		isNoFade = false,
		showLoadingTips = false,
		missionPackLabelName = "StartingSahelan", 
	}


	
	
end

this.IsAllRecovered = function( targetType )

	local targetList = this.MISSION_TASK_TARGET_LIST[ targetType ]
	if not targetList then
		return
	end
	
	for i, targetName in ipairs( targetList ) do
		if not TppEnemy.IsRecovered( targetName ) then
			return false
		end
	end
	
	return true

end

this.OnRecovered = function( gameObjectId )
	Fox.Log("______________s10150_sequence.OnRecovered()  gameObjectId : " .. tostring(gameObjectId))
	
	if this.IsAllRecovered( "TANK" ) then
		this.UpdateObjectives("RecoveredTank")
	end
	
	if this.IsAllRecovered( "WALKERGEAR" ) then
		this.UpdateObjectives("RecoveredWG")
	end
end

function this.ReserveMissionClear()
	TppMission.ReserveMissionClear{
		missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
		nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI
	}
end


function this.OnTerminate()
	Fox.Log("____________________________________s10150_sequence.OnTerminate()")

	
	TppBuddyService.ClearDisableAllBuddy()
	
	TppUiStatusManager.UnsetStatus( "Subjective", "MARKER_HELP_OFF" )
	
	
	TppMusicManager.SetPhaseMusicEnable( true )
	
	
	TppEffectUtility.ClearFxCutLevelMaximum()
	
	
	TppMusicManager.SetForceSceneMode( false )
end


function this.OnBuddyBlockLoad()
	Fox.Log("_______________s10150_sequence.OnBuddyBlockLoad()___________________")
	
	if TppPackList.IsMissionPackLabel( "SkullFaceAppearance" ) then
		
		Player.ResetVarsWhenMissionToBeContinued()
	
	else

	end
end









function this.Messages()
	local messageTable = {
	
		Block = {
			{
				msg = "OnScriptBlockStateTransition",
				func = function (blockName,blockState)
					Fox.Log("________s10150_sequence.OnScriptBlockStateTransition________")
					Fox.Log("blockName is " .. tostring(blockName) .. "        / blockState is " .. tostring(blockState))
				
					this.ActivatedBlock(blockName,blockState)
				end,
				option = { isExecMissionPrepare = true } 
			},
			nil
		},
		Player = {
			{ 	msg = "FinishMovingOnRoute",	
				func = function()
					this.HoldPlayer()
					svars.isPlayerInEV = true
				end
			},
			  
			{       
				msg = "OnPickUpWeapon",
				func = function( playerGameObjectId, equipId, number )
					Fox.Log("__________________________________equipId "..tostring(equipId))
					Fox.Log("__________________________________number "..tostring(number))
					
					if equipId == TppEquip.EQP_IT_Cassette then
						
							this.UpdateObjectives("RecoveredCasset")
						
					end
				end
			},
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
			nil
		},
		GameObject = {
			{
				
				msg = "Fulton",
				func = function ( s_gameObjectId, containerName )
					
					if Tpp.IsFultonContainer( s_gameObjectId ) then
						if TppMission.IsEnableAnyParentMissionObjective( "clear_thirdBonus_sub_MissionTask" ) == false then
							Fox.Log( "*** this.Messages Fulton Container ***")
							for i, gimmickId in pairs( this.MISSION_TASK_TARGET_LIST.CONTAINER ) do
								local ret, gameObjectId = TppGimmick.GetGameObjectId( gimmickId )
								if gameObjectId == NULL_ID then
									Fox.Error("Cannot get gameObjectId. gimmickId = " .. tostring(gimmickId) )
								else
									if s_gameObjectId == gameObjectId then
										svars.getTaskContainer = svars.getTaskContainer +1
										
										Fox.Log("___________________svars.getTaskContainer : "..svars.getTaskContainer)
										local MAX_RED_CONTAINER = #this.MISSION_TASK_TARGET_LIST.CONTAINER
										if svars.getTaskContainer == MAX_RED_CONTAINER then
											
											this.UpdateObjectives("RecoveredContainer")
										end
										
							
									end
								end
							end
						end
					end
				end,
			},
			nil
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
	}
	return
	StrCode32Table( messageTable )
end







this.missionObjectiveDefine = {

	default_area_Okb = {
		gameObjectName = "10150_marker_heliport",viewType = "all", visibleArea = 1,
		randomRange = 0, setNew = false, announceLog = "updateMap", mapRadioName = "s0150_mprg0010",
		langId = "marker_info_mission_targetArea",
	},
	
	default_photo_SkullFace = {
		photoId	= 10, addFirst = true,  photoRadioName = "s0150_mirg0010", 
	},

	default_photo_Sahelan = {
		photoId	= 20, addFirst = true,
	},

	detail_area_Okb = {
		gameObjectName = "10150_marker_heliport",viewType = "all", visibleArea = 0,
		randomRange = 0, setNew = false, announceLog = "updateMap", mapRadioName = "s0150_mprg0020",
		langId = "marker_info_mission_targetArea",
	},


	followSkullFace= {

	},
	
	
	default_subGoal = {		
		subGoalId= 0,
	},
	talk_subGoal = {		
		subGoalId= 1,
	},
	

	
	missionTask_meet_SkullFace = {
		missionTask = { taskNo=0, isNew=true, isComplete=false },
	},
	missionTask_GetInfo_SkullFace = {
		missionTask = { taskNo=1, isNew=true, isComplete=false ,isFirstHide=true},
	},

	clear_missionTask_meet_SkullFace = {
		missionTask = { taskNo=0, isNew=true, isComplete=true },
	},
	clear_missionTask_GetInfo_SkullFace = {
		missionTask = { taskNo=1, isNew=true, isComplete=true },
	},

	
	firstBonus_MissionTask = {
		missionTask = { taskNo=2, isNew=true, isComplete=false, isFirstHide=true },
	},
	secondBonus_MissionTask = {
		missionTask = { taskNo=3, isNew=true, isComplete=false, isFirstHide=true },
	},

	clear_firstBonus_MissionTask = {
		missionTask = { taskNo=2, isNew=true },
	},
	clear_secondBonus_MissionTask = {
		missionTask = { taskNo=3, isNew=true },
	},

	
	thirdBonus_sub_MissionTask = {
		missionTask = { taskNo=4, isNew=true, isComplete=false, isFirstHide=true },
	},
	forthBonus_sub_MissionTask = {
		missionTask = { taskNo=5, isNew=true, isComplete=false, isFirstHide=true },
	},

	clear_thirdBonus_sub_MissionTask = {
		missionTask = { taskNo=4, isNew=true, isComplete=true },
	},
	clear_forthBonus_sub_MissionTask = {
		missionTask = { taskNo=5, isNew=true, isComplete=true },
	},
	
	
	announce_achieveAllObjectives = {
		announceLog = "achieveAllObjectives",
	},
	

}



this.missionObjectiveTree = {
	
	followSkullFace = {
		detail_area_Okb = {
			default_area_Okb = {},
			default_photo_SkullFace = {},
			default_photo_Sahelan = {},
		},
	
	},
	
	talk_subGoal = {
		default_subGoal = {},
	},
	
	clear_missionTask_meet_SkullFace = {
		missionTask_meet_SkullFace = {},
	},
	clear_missionTask_GetInfo_SkullFace = {
		missionTask_GetInfo_SkullFace = {},
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
	
	announce_achieveAllObjectives ={},
}




this.missionStartPosition = {
		helicopterRouteList = {
			
		},
		orderBoxList = {
			
		},
}










this.s10150_OnActiveSmallBlockTable = {
	citadelSouth = {
		activeArea = { 120, 113, 120, 113 },    
		OnActive = function()
			Fox.Log("s10150_OnActiveSmallBlockTable : citadelSouth")
			
			TppDataUtility.SetVisibleDataFromIdentifier( "afgh_120_113_asset_DataIdentifier", "gate_close", false, true)
			TppDataUtility.SetVisibleDataFromIdentifier( "afgh_120_113_asset_DataIdentifier", "gate_open", true, true)
			
			Nav.SetEnabledTacticalActionInRange("", Vector3(-1636.367,532.4562,-2465.553), 3.0, true)
		end,
	}
}

this.s10150_baseOnActiveTable = {
	afgh_citadel = function()
		Fox.Log("s10150_baseOnActiveTable : afgh_citadel")
		TppDataUtility.SetVisibleDataFromIdentifier( "citadel_asset_DataIdentifier", "heliport_door", false, true)
		
		
		
	end,
	
	afgh_powerPlant = function()
		Fox.Log("s10150_baseOnActiveTable : afgh_powerPlant")
		
		local EVENT_DOOR_NAME		= "gntn_door004_vrtn002_gim_n0001|srt_gntn_door004_vrtn002"
		local EVENT_DOOR_PATH		= "/Assets/tpp/level/location/afgh/block_large/powerPlant/afgh_powerPlant_gimmick.fox2"
		
		TppDataUtility.SetVisibleDataFromIdentifier( "powerPlant_asset_DataIdentifier", "GateDoor", false, true)
		TppDataUtility.SetVisibleDataFromIdentifier( "powerPlant_asset_DataIdentifier", "rock_break_before", true, true)
		TppDataUtility.SetVisibleDataFromIdentifier( "powerPlant_asset_DataIdentifier", "rock_break_after", false, true)
		
		
		Gimmick.SetEventDoorInvisible( EVENT_DOOR_NAME , EVENT_DOOR_PATH , true )
	end,
}




local objectiveGroup = {

	MissionStart = function()
		TppMission.UpdateObjective{
			
			objectives = { 
				"default_area_Okb", 
				"default_photo_SkullFace",
				"default_subGoal",
				"missionTask_meet_SkullFace",
				"missionTask_GetInfo_SkullFace",
				"firstBonus_MissionTask",
				"secondBonus_MissionTask",
				"thirdBonus_sub_MissionTask",
				"forthBonus_sub_MissionTask",				
			},
		}
		
		TppRadio.SetOptionalRadio( "Set_s0150_oprg0010" )
		
		
		
		this.resetZone()
		this.showZone(this.ZONE_NAME.SKULL)
	
	end,
	
	
	GotoHeliport = function()
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = "s0150_rtrg0210",
			},
			
			objectives = { "detail_area_Okb", },
		}
		
		TppRadio.SetOptionalRadio( "Set_s0150_oprg0020" )
	
	end,
	
	
	FollowSkull = function()
		TppMission.UpdateObjective{
			objectives = {"clear_missionTask_meet_SkullFace","talk_subGoal" },
		}

		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = "s0150_rtrg0150",

			},
			
			objectives = { "followSkullFace" },
		}

		
		
		this.resetZone()
		this.showZone(this.ZONE_NAME.TALK)
		
		
		this.SetLimitPlayerAction()
		this.SetCameraParam_TalkSkull()
		
		
		this.SetLimitIdroidButton()
	
	end,
	
	DriveEnd = function()
		TppMission.UpdateObjective{
			objectives = { "announce_achieveAllObjectives" },
		}
	
		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_GetInfo_SkullFace", },
		}

	
	end,


	RecoveredWG = function()
		
		TppMission.UpdateObjective{
			objectives = { "clear_firstBonus_MissionTask", },
		}
		
		
		TppResult.AcquireSpecialBonus{
			first = { isComplete = true },
		}
	end,
		
	RecoveredCasset= function()
		
		TppMission.UpdateObjective{
			objectives = { "clear_secondBonus_MissionTask", },
		}
		
		
		TppResult.AcquireSpecialBonus{
			second = { isComplete = true },
		}

	end,
	
	RecoveredTank= function()
		
		TppMission.UpdateObjective{
			objectives = { "clear_forthBonus_sub_MissionTask", },
		}
		

	end,
	
	RecoveredContainer= function()
		TppMission.UpdateObjective{
			objectives = { "clear_thirdBonus_sub_MissionTask", },
		}

	end,
}


this.UpdateObjectives = function( objectiveName )
	Fox.Log("__________s10150_sequence.UpdateObjectives()  / " .. tostring(objectiveName))
	local Func = objectiveGroup[ objectiveName ]
	if Func and Tpp.IsTypeFunc( Func ) then
		Func()
	end
end


this.resetZone = function()
	
	TppTrap.Disable( "trig_innerZone_01" )
	TppTrap.Disable( "trig_outerZone_01" )
	TppTrap.Disable( "trig_innerZone_03" )
	TppTrap.Disable( "trig_outerZone_03" )

	
	TppUiCommand.HideInnerZone() 
end

this.showZone = function(areaName)
	Fox.Log("s10150_sequence.showZone : areaName = " .. tostring(areaName) )
	if areaName == this.ZONE_NAME.SKULL then
		TppTrap.Enable( "trig_innerZone_01" )
		TppTrap.Enable( "trig_outerZone_01" )
		TppUiCommand.ShowInnerZone( "trig_innerZone_01" )
	else
		TppTrap.Enable( "trig_innerZone_03" )
		TppTrap.Enable( "trig_outerZone_03" )
	end
end


this.SetLimitPlayerAction = function()
	Fox.Log("________________s10150_sequence.SetLimitPlayerAction()")
	vars.playerDisableActionFlag = PlayerDisableAction.RUN 
									+ PlayerDisableAction.OPEN_EQUIP_MENU
									+ PlayerDisableAction.CQC
									+ PlayerDisableAction.FULTON 
									+ PlayerDisableAction.OPEN_CALL_MENU
									+ PlayerDisableAction.RIDE_VEHICLE
									+ PlayerDisableAction.BEHIND
									+ PlayerDisableAction.MARKING,
									
	Player.SetPadMask {
		
		settingName = "restrictAttacks",    
		
		except = false,                                 
		
		buttons = PlayerPad.CQC 	
				+ PlayerPad.HOLD	
				+ PlayerPad.FIRE	
				+ PlayerPad.STANCE	
				+ PlayerPad.RELOAD	
				+ PlayerPad.EVADE	
				+ PlayerPad.CALL	
				+ PlayerPad.PLACE_MARKER, 
	}
	
	
	TppUiStatusManager.SetStatus( "Subjective", "MARKER_HELP_OFF" )
	
end

this.SetCameraParam_TalkSkull = function()

	Fox.Log("________________s10150_sequence.SetCameraParam_TalkSkull()")

	Player.SetAroundCameraManualMode(true) 

	Player.SetAroundCameraManualModeParams{
		offset = Vector3(0.5,0.7,0),        
		distance = 1.2,                 
		focalLength = 21,               
		focusDistance = 8.175,          
		target = Vector3(2,10,10),      
		targetInterpTime = 0.2,         
		targetIsPlayer = true,         
		ignoreCollisionGameObjectName = "Player",        
		rotationLimitMinX = -50,        
		rotationLimitMaxX = 50,         
		alphaDistance = 0.5,         
		enableStockChangeSe = true,     
	}
	
	Player.UpdateAroundCameraManualModeParams()
end

this.SetCameraParam_DriveSkull = function()

	Fox.Log("________________s10150_sequence.SetCameraParam_DriveSkull()")

	Player.SetAroundCameraManualMode(true) 

	Player.SetAroundCameraManualModeParams{
	
		offset = Vector3(0,0.75,0),        
		distance = 1.2,                 
		focalLength = 19,               
		focusDistance = 2,          
		
		target = Vector3(5,10,10),      
		targetInterpTime = 1.5,         
		targetOffsetFromPlayer = Vector3(0,0,0.5),
		targetIsPlayer = true,         
		ignoreCollisionGameObjectName = "SkullFace",        
		rotationLimitMinX = -6,        
		rotationLimitMaxX = 30,         
		alphaDistance = 0.5,         
		rotationBasedOnPlayer = true,
		useShakeParam = true 		
	}

	Player.SetAroundCameraManualModeShakeParams (
        0.01,   
		0.02,   
        0.0,    
        0.3,    
        0.45,   
        0.0,    
        9.0,    
        21.0,   
        0.5,    
        0.01,   
        11.0,   
        0.333333,       
        0.333333        
	)

	Player.UpdateAroundCameraManualModeParams()
	
	
	


	
	
end


this.SetLimitIdroidButton = function()
	Fox.Log("________________s10150_sequence.SetLimitIdroidButton()")
	TppTerminal.SetActiveTerminalMenu{
	
		TppTerminal.MBDVCMENU.MBM_DB_CASSETTE,
	}
end


this.FuncTalkSkullSkip = function()
	Fox.Log("________________s10150_sequence.FuncTalkSkullSkip()")
	
	
	TppUI.ShowAccessIcon()				
	sequences.Seq_Game_SkullFaceToPlant.FuncNextSequenceSahelanAppearance()
end


this.ActivatedBlock = function(blockName,blockState)
	Fox.Log("________s10150_sequence.ActivatedBlock()_________")
	Fox.Log("blockName is " .. tostring(blockName) .. " / blockState is " .. tostring(blockState))
	
	if blockName == Fox.StrCode32( "demo_block" ) then
		if blockState == ScriptBlock.TRANSITION_ACTIVATED then
			if TppScriptBlock.GetCurrentPackListName( "demo_block" ) == "Demo_dummy_NPC01" then
				this.ActivatedNPC01()
			end
		end
	end
end



this.HoldPlayer = function()
	
	
	Player.SetPadMask {
		
		settingName = "limitMove",    
		
		except = false,                                 
		
		sticks = PlayerPad.STICK_L,     
		
		triggers = PlayerPad.TRIGGER_L, 
	}
end
	
this.UnsetHoldPlayer = function()
	
	Player.ResetPadMask {
		settingName = "limitMove"
	}
end


this.ActivatedNPC01 = function()
	s10150_enemy.SetUpWalkerGear()
	s10150_enemy.SetUpHeliSkull()

	
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppCritterBird" )
	
	
	s10150_enemy.SetUpEnemyHeli()
end












sequences.Seq_Demo_OkbOpening = {
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					
					msg = "StartMissionTelopFadeOut",
					func = function ()
						Fox.Log("!!!!!!!!!!!!!!!!! s10150_sequence: StartMissionTelopFadeOut !!!!!!!!!!!!!!!")
						self.OnEndMissionTelop()
						
						
						TppUI.ShowAccessIcon()
					end
				},
			},
			Demo = {
				{ 	msg = "Play",
					func = function()
						Fox.Log( "_________s10150_sequence.Messages(): Demo: Play" )
						
						TppUI.HideAccessIcon()
						GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetDemoToSendEnabled", enabled=true, route="rts_demo_citadelSouth_S_0000" } ) 
					end,
					option = { isExecDemoPlaying = true,},
				},
				{ 	msg = "Skip",
					func = function()
						Fox.Log( "_________s10150_sequence.Messages(): Demo: Skip" )
						TppSoundDaemon.SetMuteInstant( 'Loading' )
					end,
					option = { isExecDemoPlaying = true,},
				},
				nil
			},			
			nil
		}
	end,




	OnEnter = function()
		TppDemo.ReserveInTheBackGround{ demoName = "Demo_OpOKBZero" }
		
		
		TppUI.StartMissionTelop(s10150,true,true)

	end,

	OnLeave = function ()
	end,

	OnEndMissionTelop = function()
		
		local func = function() 
			TppSequence.SetNextSequence("Seq_Game_MeetSkullFace")
		end
		s10150_demo.OpOKBZero(func)
	end,

}




sequences.Seq_Game_MeetSkullFace = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Trap = {
				{ msg = "Enter", sender = "trap_Demo_SkullFace", func = self.FuncNextSequenceSkullFaceAppearance },
				
				{ msg = "Enter", sender = "trap_Demo_SkullHeliArrival", func = self.SkullHeliArrival },
				
				{ msg = "Enter", sender = "trap_Sound_Road", func = self.PlaySoundRoad },
				
				
				{	
					msg = "Enter", sender = "trap_ChangeModeWelcomeTrue", 
					func = function() 
						
						TppCheckPoint.Disable{ 
							baseName = { "citadel",}
						}
						
						self.PlaySoundStairs()
						
						
						s10150_enemy.SetUpEnemyHeliReturn()
						
						if TppEnemy.GetPhase("afgh_citadel_cp") >= TppGameObject.PHASE_CAUTION  then
							mvars.isWelcome = true
							s10150_enemy.SetModeWelcome(true)
						end
						
						s10150_radio.EVinAlert()
					end
				},
				{	
					msg = "Enter", sender = "trap_ChangeModeWelcomeFalse", 
					func = function()
						if mvars.isWelcome then
							s10150_enemy.SetModeWelcome(false)
							self.SetSoundPhaseBGM()
						end
					end
				},
				
			},
			Sound = {
				{
					
					msg = "ChangeBgmPhase",
					func = function ( bgmPhase )
						Fox.Log("______s10150_sequence.ChangeBgmPhase__ / : "..bgmPhase)
						
						if not svars.isSetPhaseBGM then
							svars.isSetPhaseBGM = true
							self.SetSoundPhaseBGM()
						end
					end
				},
			},
			Marker = {
				{ 
					
					msg = "ChangeToEnable", 
					func = function(id,markType, s_gameObjectId, identificationCode)
						if identificationCode == Fox.StrCode32("Player") then
							if markType == StrCode32("TYPE_ENEMY") then
								s10150_radio.MarkingXof()
							end
						end
					end
				},
				nil
			},
			Timer = {
				{
					msg = "Finish",
					sender = "Timer_MissionAreaEnableOnMissionStart",
					func = function()
						this.resetZone()
						this.showZone(this.ZONE_NAME.SKULL)
					end
				},
			},
			nil
		}
	end,


	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(-1129.8071, 550.9086, -1992.7622))
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end










		mvars.isWelcome = false 

		local state = ScriptBlock.GetScriptBlockState( ScriptBlock.GetScriptBlockId( "demo_block" ) )
		if state == ScriptBlock.SCRIPT_BLOCK_STATE_ACTIVE then
			this.ActivatedNPC01()			
		elseif state == ScriptBlock.SCRIPT_BLOCK_STATE_EMPTY then
			TppScriptBlock.LoadDemoBlock( "Demo_dummy_NPC01" )
		end

		this.UpdateObjectives("MissionStart")	

		
		TppTelop.StartMissionObjective()

		
		if TppSequence.GetContinueCount() > 0 then
			Fox.Log( "______________s10150_sequence.Seq_Game_MeetSkullFace Continue !!!!!" )
			
			TppRadio.Play("s0150_oprg0010")
		else
			Fox.Log( "______________s10150_sequence.Seq_Game_MeetSkullFace No Continue !!!!!" )
		end
		
		TppSoundDaemon.ResetMute( 'Loading' )
		
	end,


	PlaySoundRoad = function()
		if not svars.isPlaySoundRoad then
			svars.isPlaySoundRoad = true
			
			TppSound.SetSceneBGM( "bgm_skull_road")
		end
	end,
	
	PlaySoundStairs = function()
		
		TppSound.SetSceneBGM( "bgm_skull_stairs")
	end,

	FuncNextSequenceSkullFaceAppearance = function()
	
		TppMission.Reload{

			OnEndFadeOut = function()
				Fox.Log("TppMission.Reload OnEndFadeOut") 
				
				
				Player.SetCurrentItemIndex{
					itemIndex = 0
				}
				
				
				TppSound.StopSceneBGM()
				
				TppSequence.ReserveNextSequence( "Seq_Demo_SkullFaceAppearance" )

				
				TppScriptBlock.LoadDemoBlock(
					"Demo_SkullFaceAppearance",
					false 
				)

				
				
				
				TppMission.UpdateCheckPoint{
					ignoreAlert = true,
					atCurrentPosition = true
				}
				
				end,

				isNoFade = false,
				showLoadingTips = false,
				missionPackLabelName = "SkullFaceAppearance", 
		}
	end,

	SkullHeliArrival = function()
		this.UpdateObjectives("GotoHeliport")
		
		
		s10150_enemy.HeliRouteChange("WestHeli","rts_h_heli_skull_arrival")
		
		
		
		
		
		TppRadio.ChangeIntelRadio{	heliport	= "s0150_esrg0120"	}
		
		
		






	end,
	
	SetSoundPhaseBGM = function()
		TppSound.StopSceneBGM()
		TppSound.SetPhaseBGM( "bgm_skull_phase" )
	end,
}



sequences.Seq_Demo_SkullFaceAppearance = {

	OnEnter = function()
	
		
		local vehicleId = GameObject.CreateGameObjectId( "TppVehicle2", 0 )
		if vehicleId and vehicleId ~= GameObject.NULL_ID then
			GameObject.SendCommand( vehicleId, { id="Seize", options={ "Fulton", }, } )
		end
	
		TppUI.OverrideFadeInGameStatus{
			
			EquipHud = false,
			EquipPanel = false,
			
			AnnounceLog = false,
			HeadMarker = false,
			WorldMarker = false,
			
		}
		TppUiStatusManager.SetStatus( "AnnounceLog", "SUSPEND_LOG" )
	
		
		s10150_enemy02.WarpSetRoute("trap_0000_EV2")

		local funcs = function()
			TppSequence.SetNextSequence( "Seq_Game_TalkSkullFace" )
		end
		s10150_demo.SkullFaceAppearance( funcs )
	end,
	OnLeave = function ()
		
		TppMission.UpdateCheckPointAtCurrentPosition()
	end,
}



sequences.Seq_Game_TalkSkullFace = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Trap = {
				{ msg = "Enter", sender = "trap_rideVehicle", func = self.FuncNextSequenceSkullFaceToPlant },
			},
			GameObject = {
				{ msg = "Dead",	func = self.FuncGameOver },
				{	
					msg = "EventGimmickFinish",
					func = function ( GameObjectId, placedId )
						if placedId == Fox.StrCode32("afgh_elvt001_gim_n0000|srt_afgh_elvt001") then
							svars.isPlayerInEV = false
							this.UnsetHoldPlayer()
							self.SetLineWalkAfterEV()
						end
					end
				},
				nil
			},
			
			Timer = {
				{ msg = "Finish",	sender = "CheckDistanceTimer", 
					func = function()
						self.CheckDistance()
						s10150_enemy02.CheckUpdateRoute()
					end
				},
			},

			UI = {
				{ msg = "PauseMenuSkipTutorial",		func = this.FuncTalkSkullSkip	},
			},

			nil
		}
	end,

	OnEnter = function(self)

		TppUI.OverrideFadeInGameStatus{
			
			EquipHud = false,
			EquipPanel = false,
			
			AnnounceLog = false,
			HeadMarker = false,
			WorldMarker = false,
			
		}
			
		
		mvars.PlayerState = 0
		mvars.PlayerStateForSkull = 0
		mvars.SkullFaceState = 0
		mvars.BringerAState = 0
		mvars.BringerBState = 0
		
		mvars.isSkullStepSecondMotion = false
		
		s10150_enemy02.SetUpRelativeVehicle() 
		
		GkEventTimerManager.Stop("SOFDelayTimer")	
		GkEventTimerManager.Stop("SkullTalkTimer")	
		
		GkEventTimerManager.Stop("CheckDistanceTimer")	
		
		
		GkEventTimerManager.Start( "CheckDistanceTimer", DISTANCE_APPROACH_TIMER )
		
	
		
		TppSound.SetSceneBGM( "bgm_skull_walk")
	
		
		TppSoundDaemon.PostEvent( "State_g_okb_walk_talk" )
	
		
		TppGameStatus.Set( "s10150","S_ENABLE_TUTORIAL_PAUSE" )
	
		
		
		TppUiStatusManager.SetStatus( "AnnounceLog", "SUSPEND_LOG" )
		TppUiStatusManager.SetStatus( "EquipPanel", "INVALID" )
		TppUiStatusManager.SetStatus( "HeadMarker", "INVALID" )
		TppUiStatusManager.SetStatus( "WorldMarker", "INVALID" )
		
		TppUiCommand.SetAllInvalidMbSoundControllerVoice() 
	
		this.UpdateObjectives("FollowSkull")

		
		s10150_enemy02.WarpSetHeli("trap_heli0000")
		
		
		
		
		self.SetLineWalk()
		
		
		TppWeather.SetWeatherProbabilitiesAfghNoSandStorm()
		
		
		s10150_enemy02.SkullFaceWalkFirstStep()
				
		
		s10150_radio.ResetIntelRadio()
		
		
		Player.SetCurrentItemIndex{
			itemIndex = 0
		}
		
		
		local platform = Fox.GetPlatformName()
		if platform == "PS3" or platform == "Xbox360" then
			TppEffectUtility.SetFxCutLevelMaximum( 0 )
		else
			TppEffectUtility.SetFxCutLevelMaximum( -1 )
		end
		
		
		TppMusicManager.SetForceSceneMode( true )

	end,

	FuncGameOver = function()
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )
	end,

	OnLeave = function ()
		
		
		TppUI.UnsetOverrideFadeInGameStatus()
	end,

	
	CheckDistance = function ()
		
		if not svars.isPlayerInEV then
			
			if (sequences.Seq_Game_TalkSkullFace.PlayerToSkullFacecDistance() < DISTANCE_APPROACH_SKULL) then
				this.HoldPlayer()
			else
				this.UnsetHoldPlayer()
			end
		end
		
		GkEventTimerManager.Start( "CheckDistanceTimer", DISTANCE_APPROACH_TIMER )
		
	end,

	
	PlayerToSkullFacecDistance = function()
		
		local SkullId = GameObject.GetGameObjectId( "SkullFace" )
		local position, rotY = GameObject.SendCommand( SkullId, { id="GetPosition", } )
		local SquarePlayerToSkullDistance=TppMath.FindDistance( TppMath.Vector3toTable(position), TppPlayer.GetPosition() )

		local playerToSkullDistance = math.sqrt(SquarePlayerToSkullDistance)	

		return playerToSkullDistance


	end,


	FuncNextSequenceSkullFaceToPlant = function()
		TppSequence.SetNextSequence( "Seq_Game_SkullFaceToPlant" )
	end,
	
	SetLineWalk = function()
		Fox.Log("___________s10150_sequence.sequences.Seq_Game_TalkSkullFace.SetLineWalk_____________")



	




	
		Player.RequestToMoveOnRoute{
			position = {
				Vector3(-1305.733398, 647.518677, -3286.344238),
				Vector3(-1305.389160, 647.518677, -3284.421875),
				Vector3(-1305.662964, 646.060181, -3282.041504),
				Vector3(-1299.828613, 642.063477, -3280.603516),
				Vector3(-1300.856323, 638.093628, -3274.654785),
				Vector3(-1302.640259, 638.093628, -3270.210693),
				Vector3(-1303.489746, 638.093628, -3265.343262),
				Vector3(-1296.694214, 634.055786, -3263.963867),
				Vector3(-1297.175049, 634.055786, -3257.782227),
				Vector3(-1296.994873, 634.055786, -3251.551270),
				Vector3(-1295.497192, 634.055786, -3245.365479),
				Vector3(-1291.664917, 634.055786, -3237.049561),
				Vector3(-1285.507080, 634.055786, -3230.052246),
				Vector3(-1274.624878, 634.055786, -3223.465332),
				Vector3(-1268.254883, 634.025635, -3219.051758),
				Vector3(-1263.162720, 634.055786, -3213.683838),
				Vector3(-1261.194336, 634.180359, -3210.141846),
				Vector3(-1261.561035, 634.155151, -3206.459229),
				Vector3(-1307.682983, 647.518677, -3287.105713)
			}
		}
	end,
	
	SetLineWalkAfterEV = function()
		Player.RequestToMoveOnRoute{
			position = {
				Vector3(-1261.716431, 602.086914, -3203.822510),
				Vector3(-1262.124756, 602.221252, -3200.475342),
				Vector3(-1262.957153, 602.028137, -3192.916992),
				Vector3(-1262.884766, 602.028198, -3185.995605),
				Vector3(-1263.283203, 602.028137, -3181.346191)
			}
		}
	end,
	
}


sequences.Seq_Game_SkullFaceToPlant = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Player = {

				{ msg = "RideOk", func = self.PlayerRideVehicle },
				{ 	msg = "DirectMotion",
					func = function(arg0,arg1)
						if arg0 == StrCode32("rideVehicleRear") then
							if arg1 == StrCode32("PlayEnd") then
								
								svars.isPlayerRidingOn = true

								this.SetCameraParam_DriveSkull()	
								s10150_enemy02.SkullRideCars()
								
								
								TppSound.StopSceneBGM()
								
								
								TppMusicManager.SetPhaseMusicEnable( false )
								
								
								
								GkEventTimerManager.Start( "RideOnDriverTimer", HOKEN_RIDE_DRIVER_TIME )
								
								Player.FixMotionToDefaultOnOkbVehicle(true) 
							end
						end
					end,
				},
			},

			Trap = {
				{ msg = "Enter", sender = "trap_rideVehicle", func = self.ShowRideIcon },
				{ msg = "Exit",	 sender = "trap_rideVehicle", func = self.HideRideIcon },
				{ msg = "Enter", sender = "trap_Demo_SahelanAppearance", func = self.FuncNextSequenceSahelanAppearance },
				{ msg = "Enter", sender = "trap_talk_Skull07", func = self.StartTalkTimer },
			},
			UI = {
				{ msg = "PauseMenuSkipTutorial",		func = this.FuncTalkSkullSkip	},
			},
			
			Timer = {
				{ msg = "Finish",	sender = "SkullTalkTimer", func = self.TalkSkullLastWord },
				{ msg = "Finish",	sender = "SOFDelayTimer", func = function() TppSound.SetSceneBGM( "bgm_skull_drive") end },
				{ msg = "Finish", sender = "LyricTimer", 
					func = function()
						TppUI.StartLyricOkb(0.6)
					end 
				},
				{ msg = "Finish", sender = "PassangerActionTimer", 
					func = function()
						s10150_enemy02.SkullPassangerAction()
					end 
				},
				{ msg = "Finish",	sender = "RideOnDriverTimer", 
					func = function()
						
						
						s10150_enemy02.SkullDriveHoken()
					end 
				},
				
			},
			
			nil
		}
	end,


	OnEnter = function(self)
		TppUI.OverrideFadeInGameStatus{
			
			EquipHud = false,
			EquipPanel = false,
			
			AnnounceLog = false,
			
		}
		
		
		TppGameStatus.Set( "s10150","S_ENABLE_TUTORIAL_PAUSE" )
	
		
		TppUiStatusManager.SetStatus( "AnnounceLog", "SUSPEND_LOG" )
		TppUiStatusManager.SetStatus( "EquipPanel", "INVALID" )
		TppUiStatusManager.SetStatus( "HeadMarker", "INVALID" )
		TppUiStatusManager.SetStatus( "WorldMarker", "INVALID" )
		
	
		self.ShowRideIcon()

		
		Fox.Log( "sequences.Seq_Game_SkullFaceToPlant.OnEnter(): TppEffectUtility.SetFxCutLevelMaximum( -1 )" )
		TppEffectUtility.SetFxCutLevelMaximum( -1 )

	end,

	OnLeave = function ()
		TppUI.UnsetOverrideFadeInGameStatus()
		
		Player.FixMotionToDefaultOnOkbVehicle(false)
		




	end,

	ShowRideIcon = function()
		Player.RequestToShowIcon {
			type = ActionIcon.ACTION,
			icon = ActionIcon.RIDE_VEHICLE,
			message = Fox.StrCode32("RideOk"),
			messageArg = "message_arg"		
		}
	end,

	HideRideIcon = function()
		Player.RequestToHideIcon {
			type = ActionIcon.ACTION,
			icon = ActionIcon.RIDE_MILITALY_VEHICLE,
		}
	end,

	PlayerRideVehicle = function()
		Player.RequestToPlayDirectMotion {
			
			"rideVehicleRear",
			{
					
					"/Assets/tpp/motion/SI_game/fani/bodies/snap/snapplv/snapplv_s_rde_rear_st_l.gani",
					
					false,
					
					"vehs_citadel_0001",
					
					"CNP_ppos_c",
					
					"MTP_GLOBAL_C",
					 
					true
			},
			{
					"stateDirectPlayRideRearLeftSeatOnVehicle",
					true,
					"vehs_citadel_0001",
					"CNP_ppos_c",
					"MTP_GLOBAL_C",
					true
			}
		}
	end,

	FuncNextSequenceSahelanAppearance = function()
		
		
		this.ReserveMissionClear()
	
		































		
	end,
	StartTalkTimer = function()
		
		GkEventTimerManager.Start( "SOFDelayTimer", PLAY_DELAY_TIME )
		
		
		GkEventTimerManager.Start( "SkullTalkTimer", SKULL_TALK_AND_SONG_TIME )
		
		
		GkEventTimerManager.Start( "LyricTimer", LYRIC_TIME)
		
		
		GkEventTimerManager.Start( "PassangerActionTimer", LYRIC_TIME-33.5)
		
		Player.FixMotionToDefaultOnOkbVehicle(false) 

	end,

	TalkSkullLastWord = function()
		s10150_enemy02.TalkSkullFace("SFT_08")
		
		Player.FixMotionToDefaultOnOkbVehicle(true) 
	end,

}


sequences.Seq_Demo_SahelanAppearance = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Demo = {
				{ 	msg = "Play",
					func = function()
						TppUI.HideAccessIcon() 
					end,
					option = { isExecDemoPlaying = true,},
				},
			
				{ 	msg = "Skip",
					func = function()
						Fox.Log("______s10150_sequence.Seq_Demo_SahelanAppearance() DEMO: Skip")
						if TppUiCommand.IsDispToBeContinue() then
							Fox.Log(" true - IsDispToBeContinue")
							mvars.IsContinued = false	
						else
							Fox.Log("false - IsDispToBeContinue")
							mvars.IsContinued = true	
						end
					end,
					option = { isExecDemoPlaying = true,},
				},
				nil
			},	
			
			nil
		}
	end,
	OnEnter = function()

		mvars.IsContinued = false 
		local funcs = function()
			TppSequence.SetNextSequence( "Seq_ToBeContinued", { isExecMissionClear = true } )
		end

		s10150_demo.SahelanAppearance( funcs )
	end,
}



sequences.Seq_ToBeContinued = {
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{ msg = "TelopTypingEnd",
					func = function()
						TppMission.MissionGameEnd{ loadStartOnResult = true }
					end,
					option = { isExecMissionClear = true, } 
				},
			},
			
			nil
		}
	end,

	OnEnter = function()
		TppSoundDaemon.SetMute( 'Loading' )	
		
		if mvars.IsContinued then
			TppUiCommand.CallMissionTelopTyping( "mission_to_be_continued", "" )
		else
			TppMission.MissionGameEnd{ loadStartOnResult = true }
		end
	end,
	OnLeave = function ()
		TppSoundDaemon.ResetMute('Loading') 
	end,
}



return this
