local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

this.DEBUG_strCode32List = {
	"hos_s10033_0000",
	"Fulton",
	"FultonFailed",
	"Dead",
}





local ESCAPE_HOSTAGE_NAME	= "hos_s10033_0000"
local NORMAL_HOSTAGE_NAME	= "hos_s10033_0001"
local SUPPORT_HELI			= "SupportHeli"
local VEHICLE_NAME			= "veh_s10033_0000"
local BLUEPRINT_NAME		= "col_develop_HighprecisionAR_s10033_0000"


local TRAP_NAME = {
	ARRIVED_ENEMYBASE		= "trap_entryToEnemyBase",			
	ARRIVED_TARGETAREA		= "trap_entryToTargetArea",			
	ARRIVED_UNDERBUILDING	= "trap_entryToUnderBuilding",		
	LEAVE_UNDERBUILDING		= "trap_leaveToUnderBuilding",		
	ARRIVED_INTELREPORT		= "trap_intel_00",					
	CANFULTONHOLE			= "trap_canFultonHole",				
}


local MARKER_NAME = {
	AREA_ENEMYBASE			= "s10033_marker_enemyBase",		
	AREA_UB					= "s10033_marker_underBuilding",	
	ENEMYBASE_INTEL_FILE	= "s10033_marker_intelFile",
}


local PHOTO_NAME = {
	PHOTO_TARGET			= 10,								
}


local SUBGOAL_ID = {
	START					= 0,
	ESCAPE					= 1,
}


local GIMMICK_NAME = {
	DOOR001					= "gntn_wall001_door001_gim_n0001|srt_gntn_wall001_door001",	
}


local GIMMICK_PATH = {
	DOOR001					= "/Assets/tpp/level/location/afgh/block_large/enemyBase/afgh_enemyBase_gimmick.fox2",	
}


	HELI_START_TIME			= 18







this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PLACED_LOCATOR_COUNT = 25


this.MAX_PICKABLE_LOCATOR_COUNT = 25




this.REVENGE_MINE_LIST = {"afgh_enemyBase"}
this.MISSION_REVENGE_MINE_LIST = {
	["afgh_enemyBase"] = {
		decoyLocatorList = {
			"itm_revDecoy_enemyBase_a_0005",
			"itm_revDecoy_enemyBase_a_0006",
			"itm_revDecoy_enemyBase_a_0007",
		},
		
		["trap_afgh_enemyBase_mine_south"] = {
			mineLocatorList = {
				"itm_revMine_enemyBase_a_0010",
				"itm_revMine_enemyBase_a_0011",
				"itm_revMine_enemyBase_a_0012",
			},
		},
		
		["trap_afgh_enemyBase_mine_west"] = {
			mineLocatorList = {
				"itm_revMine_enemyBase_a_0013",
			},
		},
		
		["trap_afgh_enemyBase_mine_east"] = {
			mineLocatorList = {
				"itm_revMine_enemyBase_a_0014",
			},
		},
	},
}








function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Game_MainGame",
		"Seq_Game_RescueTarget",
		"Seq_Game_Escape",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	
	isReachEnemyBase			= false,	
	isGetIntelFile				= false,	
	isHostageRescue				= false,	
	isNearBindTarget			= false,	
	isLockingTagRadio			= false,	
	isFailedInnerFulton			= false,	
	isLeaveConfRuins			= false,	
	isFultonStartConfRuins		= false,	
	isTargetFound				= false,	
	isTargetLockState			= false,	
	isTargetUnlockedByPlayer	= false,	
	isTargetLaidHeli			= false,	
	isTargetFulton				= false,	
	isTargetRescue				= false,	
	speech033_carry010_01		= false,	
	speech033_carry010_02		= false,	
	speech033_carry010_03		= false,	
	speech033_carry010_04		= false,	
	speech033_carry010_05		= false,	
	speech033_carry010_06		= false,	
	speech033_carry010_07		= false,	
	speech033_carry010_08		= false,	
	speech033_carry010_09		= false,	
	speech033_carry010_10		= false,	
	speech033_carry010_11		= false,	
	speech033_carry010_12		= false,	
	isCarryTalkStart			= false,	

	PreliminaryFlag01			= false,	
	PreliminaryFlag02			= false,	
	PreliminaryFlag03			= false,	
	PreliminaryFlag04			= false,	
	PreliminaryFlag05			= false,	
	PreliminaryFlag06			= false,	
	PreliminaryFlag07			= false,	
	PreliminaryFlag08			= false,	
	PreliminaryFlag09			= false,	
	PreliminaryFlag10			= false,	
	PreliminaryFlag11			= false,	
	PreliminaryFlag12			= false,	
	PreliminaryFlag13			= false,	
	PreliminaryFlag14			= false,	
	PreliminaryFlag15			= false,	
	PreliminaryFlag16			= false,	
	PreliminaryFlag17			= false,	
	PreliminaryFlag18			= false,	
	PreliminaryFlag19			= false,	
	PreliminaryFlag20			= false,	

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

}


this.checkPointList = {
	
	
	"CHK_ReachGateBack",	
	"CHK_GetIntelFile",		
	"CHK_HostageRescue",	
	"CHK_ReachConfRuins",	
	"CHK_FoundTarget",		
	"CHK_TargetLaidHeli",	
	"CHK_TargetRescue",		
	nil
}

this.baseList = {
	"enemyBase",
	"villageWest",
	"enemyEast",
	"slopedWest",
	"tentEast",
	nil
}




this.longMonologueList = {
	"speech033_carry010_01",
	"speech033_carry010_02",
	"speech033_carry010_03",
	"speech033_carry010_04",
	"speech033_carry010_05",
	"speech033_carry010_06",
	"speech033_carry010_07",
	"speech033_carry010_08",
	"speech033_carry010_09",
	"speech033_carry010_10",
	"speech033_carry010_11",
	"speech033_carry010_12",
}







this.missionObjectiveDefine = {
	
	default_area_enemyBase = {
		gameObjectName	= MARKER_NAME.AREA_ENEMYBASE,
		visibleArea = 4,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		mapRadioName = "f1000_mprg0190",
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
	},
	
	marker_area_UB = {
		gameObjectName = MARKER_NAME.AREA_UB,
		visibleArea = 2,
		randomRange = 0,
		viewType = "all",
		setNew = true,
		mapRadioName = "f1000_mprg0190",
		announceLog = "updateMap",
		setImportant = true,
		langId = "marker_info_mission_targetArea",
	},
	
	marker_area_Target = { 
		gameObjectName = MARKER_NAME.AREA_UB,
		visibleArea = 1,
		randomRange = 0,
		setNew = true,
		viewType = "all",
		mapRadioName = "f1000_mprg0190",
		announceLog = "updateMap",
		setImportant = true,
		langId = "marker_info_mission_targetArea",
	},
	
	marker_Target = { 
		gameObjectName = ESCAPE_HOSTAGE_NAME,
		goalType = "moving",
		viewType="map_and_world_only_icon",
		setNew = true,
		setImportant = true,
		langId = "marker_info_mission_target",
	},
	
	default_photo_target = {
		photoId	= PHOTO_NAME.PHOTO_TARGET,
		photoRadioName = "s0033_mirg0013",
		addFirst = true,
	},
	
	Intermediate_target01 = {
		subGoalId = SUBGOAL_ID.START,
	},
	
	
	default_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = false },
	},
	
	default_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_05 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	
	clear_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = true },
	},
	
	clear_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, },
	},
	
	clear_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, },
	},
	
	clear_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = true },
	},
	
	clear_missionTask_05 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = true },
	},
	
	rv_missionClear = {
		photoId		= PHOTO_NAME.PHOTO_TARGET,
		addFirst = true,
		subGoalId = SUBGOAL_ID.ESCAPE,
	},
	
	target_area_cp = {
		targetBgmCp = "afgh_enemyBase_cp",
	},
	
	intelFile_enemyBase = {
		gameObjectName = MARKER_NAME.ENEMYBASE_INTEL_FILE,
	},
	
	intelFile_enemyBase_get = {
	},
	
	announce_recoverTarget = {
		announceLog = "recoverTarget",
	},
	announce_achieveAllObjectives = {
		announceLog = "achieveAllObjectives",
	},
	
	hud_photo_flee = {
		hudPhotoId = PHOTO_NAME.PHOTO_TARGET 
	},
}

this.missionObjectiveTree = {
	
	rv_missionClear = {
		
		default_photo_target = {
		},
		
		marker_Target = {
			
			marker_area_Target = {
				
				marker_area_UB = {
					
					default_area_enemyBase = {
					},
				},
			},
			
			target_area_cp = {
			},
		},
		Intermediate_target01 = {},
	},
	clear_missionTask_01 = {
		default_missionTask_01 = {},
	},
	clear_missionTask_02 = {
		default_missionTask_02 = {},
	},
	clear_missionTask_03 = {
		default_missionTask_03 = {},
	},
	clear_missionTask_04 = {
		default_missionTask_04 = {},
	},
	clear_missionTask_05 = {
		default_missionTask_05 = {},
	},
	intelFile_enemyBase_get = {
		intelFile_enemyBase = {
		},
	},
	
	announce_recoverTarget = {
	},
	announce_achieveAllObjectives = {
	},
	
	hud_photo_flee = {
	},
}

this.missionObjectiveEnum = Tpp.Enum{
	"default_area_enemyBase",
	"marker_area_UB",
	"marker_area_Target",
	"marker_Target",
	"default_photo_target",
	"Intermediate_target01",
	"rv_missionClear",
	"target_area_cp",
	"clear_missionTask_01",
	"default_missionTask_01",
	"clear_missionTask_02",
	"default_missionTask_02",
	"clear_missionTask_03",
	"default_missionTask_03",
	"clear_missionTask_04",
	"default_missionTask_04",
	"clear_missionTask_05",
	"default_missionTask_05",
	"intelFile_enemyBase",
	"intelFile_enemyBase_get",
	"announce_recoverTarget",
	"announce_achieveAllObjectives",
	"hud_photo_flee",
}

this.missionTask_2_TARGET_LIST = {
	NORMAL_HOSTAGE_NAME,
}
this.missionTask_3_TARGET_LIST = {
	VEHICLE_NAME,
}

this.specialBonus = {
	first = {
		missionTask = { taskNo = 1 },
	},
	second = {
		missionTask = { taskNo = 2 },
	}
}

this.missionStartPosition = {
	orderBoxList = {
		"box_s10033_00",			
		"box_s10033_01",			
	},
	helicopterRouteList = {
		"lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000",	
		"lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000",	
		"lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000",	
	},
}







function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppCritterBird" )
	
	
	TppMission.RegisterMissionSystemCallback{
		OnEstablishMissionClear = function( missionClearType )
			Fox.Log("*** " .. missionClearType .. " OnEstablishMissionClear ***")

			s10033_radio.OnGameCleared()

			
			if vars.playerVehicleGameObjectId ~= NULL_ID then
				if vars.playerVehicleGameObjectId == GameObject.GetGameObjectId( "TppVehicle2" , VEHICLE_NAME ) then
					Fox.Log("##** OnEstablishMissionClear VEHICLE_NAME ####")
					
					TppMission.UpdateObjective{
						objectives = { "clear_missionTask_04" , },
					}
				end
			end

			if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
				TppPlayer.PlayMissionClearCamera()
				TppMission.MissionGameEnd{
					loadStartOnResult = true,
					fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,
					delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
				}
			elseif missionClearType == TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_FULTON_CONTAINER then
				TppMission.MissionGameEnd{
					loadStartOnResult = true,
					delayTime = 5,
				}
			else
				TppMission.MissionGameEnd{ loadStartOnResult = true }
			end
		end,
		OnRecovered = function( gameObjectId )
			
			Fox.Log("##** OnRecovered_is_coming ####")
			if gameObjectId == GameObject.GetGameObjectId( "TppHostage2", ESCAPE_HOSTAGE_NAME ) then
				Fox.Log("##** OnRecovered ESCAPE_HOSTAGE_NAME ####")
				
				TppMission.UpdateObjective{
					objectives = { "announce_recoverTarget" },
				}
				TppMission.UpdateObjective{
					objectives = { "announce_achieveAllObjectives" },
				}	
				
				TppMission.UpdateObjective{
					objectives = { "clear_missionTask_01" , },
				}
				if svars.isFultonStartConfRuins == true then
					
					TppMission.UpdateObjective{
						objectives = { "clear_missionTask_02" , },
					}
					
					TppResult.AcquireSpecialBonus{
						first = { isComplete = true },
					}
				end
			elseif gameObjectId == GameObject.GetGameObjectId( "TppHostage2", NORMAL_HOSTAGE_NAME ) then
				Fox.Log("##** OnRecovered NORMAL_HOSTAGE_NAME ####")
				
				TppMission.UpdateObjective{
					objectives = { "clear_missionTask_03" , },
				}
				
				TppResult.AcquireSpecialBonus{
					second = { isComplete = true },
				}
			elseif gameObjectId == GameObject.GetGameObjectId( "TppVehicle2" , VEHICLE_NAME ) then
				Fox.Log("##** OnRecovered VEHICLE_NAME ####")
				
				TppMission.UpdateObjective{
					objectives = { "clear_missionTask_04" , },
				}
			else
				Fox.Log("##** OnRecovered Not Target ####")
			end
		end,
		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,
		OnGameOver = this.OnGameOver,
	}

	
	TppMarker.SetUpSearchTarget{
		{
			gameObjectName = ESCAPE_HOSTAGE_NAME, 
			gameObjectType = "TppHostage2",
			messageName = ESCAPE_HOSTAGE_NAME,
			skeletonName = "SKL_004_HEAD",
			objectives = { "marker_Target", "hud_photo_flee" },
			func = this.TargetFound
		},
	}

	
	
	TppPlayer.AddTrapSettingForIntel{
		intelName			= "Intel_enemyBase",				
		autoIcon			= true,
		identifierName		= "GetIntelIdentifier",
		locatorName			= "intel_00",
		gotFlagName			= "isGetIntelFile",					
		trapName			= TRAP_NAME.ARRIVED_INTELREPORT,	
		markerObjectiveName	= "intelFile_enemyBase",			
		markerTrapName		= "trap_intelMarkAreaEnemyBase",	

	}

	
	if TppMission.IsHardMission( vars.missionCode ) then
		TppMission.RegistDiscoveryGameOver()
	end

end


function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	TppRevenge.RegisterMissionMineList( this.MISSION_REVENGE_MINE_LIST )

	
	if (svars.PreliminaryFlag01	== false) then
		TppInterrogation.AddHighInterrogation(
			GameObject.GetGameObjectId("afgh_enemyBase_cp"),
			{
				{ name = "enqt1000_1i1210", func = s10033_enemy.InterCall_hostage_pos01, },
			}
		)
	end

end


this.OnEndMissionPrepareSequence = function ()

	
	if TppMission.IsMissionStart() then
		Fox.Log( "s10033_sequence Gimmick Restore!!!!!" )
		this.GimmickRestore()
	end

end


function this.OnGameOver( gameOverType )
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
		
		TppPlayer.SetTargetDeadCamera{ gameObjectName = ESCAPE_HOSTAGE_NAME }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end
end





function this.GimmickRestore()
	
	Gimmick.ResetGimmick(
		TppGameObject.GAME_OBJECT_TYPE_DOOR,
		GIMMICK_NAME.DOOR001,GIMMICK_PATH.DOOR001 )
end


function this.OnTargetRescued( s_characterId )
	Fox.Log( "s10033_sequence.OnTargetRescued( " .. s_characterId .. " )" )
	Fox.Log( "ESCAPE_HOSTAGE_NAME:" .. ESCAPE_HOSTAGE_NAME )
	svars.isTargetFulton = true
	svars.isTargetRescue = true
	TppSequence.SetNextSequence("Seq_Game_Escape")
end




function this.Messages()
	return
	StrCode32Table {
		Player = {
			{
				msg = "GetIntel",
				sender = "Intel_enemyBase",
				func = function( intelNameHash )		
					Fox.Log( "#### s10033_sequence.GetIntelAtEnemyBase ####" )
					TppPlayer.GotIntel( intelNameHash )
					
					local func = function()
						if TppMission.IsEnableAnyParentMissionObjective( "marker_area_UB" ) == false then
							
							svars.PreliminaryFlag01	= true
							s10033_enemy.InterStop_hostage_pos01()
							
							TppMission.UpdateObjective{
								
								objectives = { "marker_area_UB" , "intelFile_enemyBase_get" },
							}
							
							s10033_radio.GetUsefulRecord()

							TppMission.UpdateCheckPointAtCurrentPosition()
						else
							
							s10033_radio.GetUselessRecord()
							TppMission.UpdateObjective{
								objectives = { "intelFile_enemyBase_get" },
							}
						end
					end
					s10033_demo.GetIntel_enemyBase(func)
				end
			},
			{
				msg = "PlayerFulton",
				func = function( playerId,gameObjectId )		
					Fox.Log( "#### s10033_sequence.PlayerFulton Start ####" )
					
					
					if gameObjectId == GameObject.GetGameObjectId("TppHostage2", ESCAPE_HOSTAGE_NAME) then

						if svars.speech033_carry010_12 == false then
							Fox.Log( "#### s10033_mission Monologue PlayerFulton Hostage Talk No End ####" )
							
							s10033_enemy.CallMonologueHostage( ESCAPE_HOSTAGE_NAME, "speech033_carry020" )
						end

						local isInRange01 = GameObject.SendCommand(
							GameObject.GetGameObjectId( ESCAPE_HOSTAGE_NAME ),
							{
								id="IsInRange",
								range = 3,
								target = { -626.664, 342.623, 470.654 },
							}
						)
						local isInRange02 = GameObject.SendCommand(
							GameObject.GetGameObjectId( ESCAPE_HOSTAGE_NAME ),
							{
								id="IsInRange",
								range = 3,
								target = { -631.879, 342.623, 462.636 },
							}
						)

						Fox.Log("*** isInRange01 " .. tostring(isInRange01) .. " ***")
						Fox.Log("*** isInRange02 " .. tostring(isInRange02) .. " ***")

						if (isInRange01)or(isInRange02) then
							svars.isFultonStartConfRuins = true
						else
							svars.isFultonStartConfRuins = false
						end

					end
				end
			},
			{
				msg = "OnPickUpCollection",
				func = function( gameObjectId , collectionTypeId )
					
					Fox.Log( "#### s10033_sequence.onPickUpCollection ####" )
					Fox.Log("*** gameObjectId " .. tostring(gameObjectId) .. " ***")
					Fox.Log("*** collectionTypeId " .. tostring(collectionTypeId) .. " ***")
					if collectionTypeId == TppCollection.GetUniqueIdByLocatorName(BLUEPRINT_NAME) then
						Fox.Log( "#### s10033_sequence.onPickUpCollection TaskId ####" )
						
						TppMission.UpdateObjective{
							objectives = { "clear_missionTask_05" , },
						}
					else
						Fox.Log( "#### s10033_sequence.onPickUpCollection Not Target ####" )
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
			{
				msg = "PlayerFultoned",
				func = function (fultonedPlayerId, staffId, isSuccess, fultonExecuteId)
					TppUiCommand.AnnounceLogView("### PlayerFultoned ### fultonExecuteId = " .. tostring(fultonExecuteId) )
				end
			},
		},
		Trap = {

			{
				msg = "Enter",
				sender = TRAP_NAME.ARRIVED_TARGETAREA,
				func = function ()
					svars.isNearBindTarget = true








				end
			},

			{
				msg = "Exit",
				sender = TRAP_NAME.ARRIVED_TARGETAREA,
				func = function ()
					svars.isNearBindTarget = false
				end
			},
		},
		Marker = {

			{
				msg = "ChangeToEnable",
				sender = NORMAL_HOSTAGE_NAME,
				func = function ( arg0, arg1, arg2, arg3 )
					if arg3 == StrCode32("Player") then
						s10033_radio.DiscoverUknownPOW()
					end
				end
			},
			nil
		},
		Timer = {

			{
				msg = "Finish",
				sender = "CarryTalkStart",
				func = function ()


					svars.isCarryTalkStart = true

					local gameObjectId = GameObject.GetGameObjectId( "TppHostage2", ESCAPE_HOSTAGE_NAME )
					local command = {	id = "GetStatus",	}
					local actionStatus = GameObject.SendCommand( gameObjectId, command )

					if actionStatus == TppGameObject.NPC_STATE_CARRIED then
						Fox.Log("s10033_mission ESCAPE_HOSTAGE_NAME is Carring!!!")

						for index, labelName in ipairs( this.longMonologueList ) do
							if ( svars[labelName] == false ) then
								Fox.Log("s10033_mission Monologue labelName Play!!!".. tostring(labelName))
								s10033_enemy.CallMonologueHostage( ESCAPE_HOSTAGE_NAME, labelName )
								break
							else
								Fox.Log("s10033_mission Monologue labelName Played!!!".. tostring(labelName))
							end
						end
					else
						Fox.Log("s10033_mission Monologue Player Not Carry Hostage!!!".. tostring(labelName))
					end

				end
			},
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
		GameObject = {

			{
				msg = "ChangePhase",
				sender = "afgh_enemyBase_cp",
				func = this.CheckTargetLock,
			},

			{
				msg = "Fulton",
				sender = ESCAPE_HOSTAGE_NAME,
				func = function ( arg0 )
					if TppMarker.GetSearchTargetIsFound( ESCAPE_HOSTAGE_NAME ) == true        then
						Fox.Log("already Important Marker ... Nothing Done !!")
					else
						TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
						TppMission.UpdateObjective{ objectives = { "hud_photo_flee" }, }
					end
					this.OnTargetRescued( arg0 )
				end
			},

			{
				msg = "Fulton",
				sender = NORMAL_HOSTAGE_NAME,
				func = function ()

					if svars.isTargetFound == false then
						s10033_radio.RescueUsefulPOW()

						svars.PreliminaryFlag01	= true
						s10033_enemy.InterStop_hostage_pos01()

						TppMission.UpdateObjective{
							objectives = { "marker_area_Target" },
						}
					else
						s10033_radio.RescueUselessPOW()
					end
				end
			},

			{
				msg = "PlacedIntoVehicle",
				sender = NORMAL_HOSTAGE_NAME,
				func = function (s_characterId, s_rideVehicleID)

					if Tpp.IsHelicopter(s_rideVehicleID) then

						if svars.isTargetFound == false then
							s10033_radio.RescueUsefulPOW()

							svars.PreliminaryFlag01	= true
							s10033_enemy.InterStop_hostage_pos01()

							TppMission.UpdateObjective{
								objectives = { "marker_area_Target" },
							}
						else
							s10033_radio.RescueUselessPOW()
						end
					end
				end
			},

			{
				msg = "Fulton",
				sender = VEHICLE_NAME,
				func = function ()
				end
			},

			{
				msg = "Carried",
				func = function ( GameObjectId, carriedState )

					if ( svars.isCarryTalkStart == true ) then

						if( GameObjectId == GameObject.GetGameObjectId(ESCAPE_HOSTAGE_NAME) )then

							if carriedState == 2 then
								Fox.Log("s10033_mission ESCAPE_HOSTAGE_NAME Carried End!!!")

								for index, labelName in ipairs( this.longMonologueList ) do
									if ( svars[labelName] == false ) then
										Fox.Log("s10033_mission Monologue labelName Play!!!".. tostring(labelName))
										s10033_enemy.CallMonologueHostage( ESCAPE_HOSTAGE_NAME, labelName )
										break
									else
										Fox.Log("s10033_mission Monologue labelName Played!!!".. tostring(labelName))
									end
								end
							else
								Fox.Log("s10033_mission ESCAPE_HOSTAGE_NAME Carried Start!!!")
							end
						end
					end
				end
			},

			{
				msg = "MonologueEnd",
				func = function (GameObjectId,speechLabel,isSuccess)
					Fox.Log("s10033_mission Monologue GameObjectId"..GameObjectId)
					Fox.Log("s10033_mission Monologue speechLabel"..speechLabel)
					Fox.Log("s10033_mission Monologue isSuccess"..isSuccess)

					if( isSuccess == 1 )then

						if( GameObjectId == GameObject.GetGameObjectId(ESCAPE_HOSTAGE_NAME) )then

							if ( speechLabel ~= Fox.StrCode32("speech033_carry020") ) then

								for index, labelName in ipairs( this.longMonologueList ) do
									if ( speechLabel == Fox.StrCode32(labelName) ) then
										svars[labelName] = true
										Fox.Log("s10033_mission Monologue speechLabel"..labelName)
										Fox.Log("s10033_mission Monologue speechLabel".. tostring(svars[labelName]))
										break
									end
								end

								for index, labelName in ipairs( this.longMonologueList ) do
									local gameObjectId = GameObject.GetGameObjectId( "TppHostage2", ESCAPE_HOSTAGE_NAME )
									local command = {	id = "GetStatus",	}
									local actionStatus = GameObject.SendCommand( gameObjectId, command )

									if actionStatus == TppGameObject.NPC_STATE_CARRIED then
										if ( svars[labelName] == false ) then
											Fox.Log("s10033_mission Monologue labelName Play!!!".. tostring(labelName))
											s10033_enemy.CallMonologueHostage( ESCAPE_HOSTAGE_NAME, labelName )
											break
										else
											Fox.Log("s10033_mission Monologue labelName Played!!!".. tostring(labelName))
										end
									else
										break
									end
								end
							else

								Fox.Log("s10033_mission Monologue speech033_carry020 MonologueEnd l!!")
							end
						else

							Fox.Log("s10033_mission Monologue Unkown Charal!!")
						end
					else

						Fox.Log("s10030_mission Monologue failed !!")
					end
				end
			},

			{
				msg = "Unlocked",
				sender = ESCAPE_HOSTAGE_NAME,
				func = function ()
					Fox.Log( "!!! s10033_sequence.TargetUnLock !!!" )
					svars.isTargetLockState = false
					svars.isTargetUnlockedByPlayer = true
				end
			},

			{
				msg = "Dead",
				sender = ESCAPE_HOSTAGE_NAME,
				func = this.OnTargetDead,
			},

			{
				msg = "FultonFailed",
				sender = ESCAPE_HOSTAGE_NAME,
				func = function(id,locatorName,locatorNameUpper,type)
					Fox.Log("fulton failed "..type)

					if type == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then

						s10033_radio.FailedFultonTargetDead()
						TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )

					elseif type == TppGameObject.FULTON_FAILED_TYPE_WRONG_POSITION then

						if svars.isFailedInnerFulton == false then
							s10033_radio.FailedFultonTarget1st()
							svars.isFailedInnerFulton = true

						else
							s10033_radio.FailedFultonTarget2nd()
						end











					else
						Fox.Log("fulton failed_unknownType")
					end
				end
			},
			{
				msg = "BuddyPuppyFind",
				func = function( gameObjectId )
					Fox.Log( "**** s30010_sequence::BuddyPuppyFind ****" )
					if not TppRadio.IsPlayed("f1000_rtrg5040") then
						TppRadio.Play("f1000_rtrg5040", { delayTime = "long", isEnqueue = true } )
					end
				end
			},
			{
				msg = "Damage",
				func = function( gameObjectId, attackId, attakerId )
					local puppyId = GameObject.GetGameObjectId("TppBuddyPuppy", "anml_BuddyPuppy_00")
					if puppyId ~= nil then
						if gameObjectId == puppyId and Tpp.IsPlayer( attakerId ) then
							Fox.Log( "**** s30010_sequence::Puppy Damaged by Player ****" )
							TppRadio.Play("f1000_rtrg5060", { delayTime = "short", } )
						end
					end
				end
			},
			{
				msg = "Dead",
				func = function( gameObjectId, attakerId, attackId )
					local puppyId = GameObject.GetGameObjectId("TppBuddyPuppy", "anml_BuddyPuppy_00")
					if puppyId ~= nil then
						if gameObjectId == puppyId and Tpp.IsPlayer( attakerId ) then
							Fox.Log( "**** s30010_sequence::Puppy Dead ****" )
							TppRadio.Play("f1000_rtrg5070", { delayTime = "short", } )
						end
					end
				end
			},
			{
				msg = "Fulton",
				func = function( gameObjectId, animaiId, arg2 )
					local puppyId = GameObject.GetGameObjectId("TppBuddyPuppy", "anml_BuddyPuppy_00")
					if puppyId ~= nil then
						if gameObjectId == puppyId then
							Fox.Log( "**** s30010_sequence::Puppy Fulton ****" )
							TppRadio.Play("f1000_rtrg5050", { delayTime = "long", isEnqueue = true } )
						end
					end
				end
			},
			{
				msg = "NeutralizeFob",
				func = function( neutralizedGameObjectId, attackerGameObjectId, neutralizeType, neutralizeCause )
					--TppUiCommand.AnnounceLogView("neutralize fob: " .. tostring(neutralizedGameObjectId) .. ", attacker: " .. tostring(attackerGameObjectId))
				end
			},
			nil
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





function this.OnTargetDead( s_characterId )
	Fox.Log( "s10033_sequence.OnTargetDead( " .. s_characterId .. " )" )
	
	TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )	
end


function this.CheckTargetLock( cpName, PhaseName )
	Fox.Log( "s10033_sequence.CheckTargetLock" )
	
















































end


function this.TargetFound()
	Fox.Log( "s10033_sequence.TargetFound" )
	Fox.Log( "ESCAPE_HOSTAGE_NAME:" .. ESCAPE_HOSTAGE_NAME )
	svars.isTargetFound = true
	s10033_radio.CarryTarget()
	
	svars.PreliminaryFlag01	= true
	s10033_enemy.InterStop_hostage_pos01()
	TppSequence.SetNextSequence("Seq_Game_RescueTarget")
end





sequences.Seq_Game_MainGame = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Trap = {
				
				{
					msg = "Enter",
					sender = TRAP_NAME.ARRIVED_ENEMYBASE,
					func = function ()
						
						if svars.isReachEnemyBase == false then
							s10033_radio.ArrivedEnemyBase()
							TppRadio.SetOptionalRadio("Set_s0033_oprg0020")
						end
						svars.isReachEnemyBase = true
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.ARRIVED_UNDERBUILDING,
					func = function ()
						s10033_radio.ArriveUnderBuilding()
					end
				},
			},nil
		}
	end,

	OnEnter = function()

		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
			TppCoder.SetWorldCenter(Vector3(-397.83188, 344.12, 556.29047))
		end

		TppTelop.StartCastTelop()

		s10033_enemy.UnlockedNormalHostage()

		TppRadio.SetOptionalRadio("Set_s0033_oprg0010")
		
		TppMission.UpdateObjective{
			objectives = { "default_photo_target" , "target_area_cp" , "Intermediate_target01" , },
		}
		
		TppMission.UpdateObjective{
			objectives = { "default_missionTask_01" , "default_missionTask_02" , "default_missionTask_03" , "default_missionTask_04" , "default_missionTask_05" , },
		}
		
		TppMission.UpdateObjective{
			radio = {
				radioGroups = "s0033_rtrg0010",
			},
			radioSecond = {
				radioGroups = "s0033_rtrg0011",
			},
			
			objectives = { "default_area_enemyBase" },
		}
		
		TppMission.SetHelicopterDoorOpenTime( HELI_START_TIME )

	end,

	OnLeave = function ()
		

	end,
}

sequences.Seq_Game_RescueTarget = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Player = {
				
				{
					msg = "Exit", sender = "hotZone",
					func = function()
						if TppEnemy.CheckAllVipClear() then
							Fox.Log("All vip neutralize and exit hotzone")
						end
					end,			
				},
			},
			GameObject = {
				
				{
					msg = "PlacedIntoVehicle",
					sender = ESCAPE_HOSTAGE_NAME,
					func = self.OnTargetRideVehicle,
				},
				nil
			},
			Trap = {
				
				{
					msg = "Enter",
					sender = TRAP_NAME.LEAVE_UNDERBUILDING,
					func = function ()
						local Target_status = TppEnemy.GetStatus( ESCAPE_HOSTAGE_NAME )
						if( Target_status == TppGameObject.NPC_STATE_CARRIED ) then
							s10033_radio.EscapeUnderBuilding()
						end
					end
				},
				
				{
					msg = "Enter",
					sender = TRAP_NAME.CANFULTONHOLE,
					func = function ()
						svars.isLeaveConfRuins = true
					end
				},
				{
					msg = "Exit",
					sender = TRAP_NAME.CANFULTONHOLE,
					func = function ()
						svars.isLeaveConfRuins = false
					end
				},
			},nil
		}
	end,

	OnEnter = function()

		
		TppRadio.SetOptionalRadio("Set_s0033_oprg0030")

		
		GkEventTimerManager.Start( "CarryTalkStart", 7 )

	end,
	
	
	OnTargetRideVehicle = function( s_characterId, s_rideVehicleID )
		Fox.Log( "s10033_sequence.OnTargetRideVehicle( " .. s_characterId .. " )" )
		Fox.Log( "s10033_sequence.OnTargetRideVehicle( " .. s_rideVehicleID .. " )" )
		Fox.Log( "ESCAPE_HOSTAGE_NAME:" .. ESCAPE_HOSTAGE_NAME )
		if Tpp.IsHelicopter(s_rideVehicleID) then
			
			svars.isTargetRescue = true
			TppSequence.SetNextSequence("Seq_Game_Escape")
		else
			
		end
	end,
	
	OnLeave = function ()
		
		if svars.isFultonStartConfRuins == false then
			s10033_radio.RescueTargetOut()
		else
			s10033_radio.RescueTargetInn()
		end
	end,

}

sequences.Seq_Game_Escape = {
	OnEnter = function()
		Fox.Log("######## Seq_Game_Escape.OnEnter ########")
		
		TppMission.CanMissionClear()

		
		TppMission.UpdateObjective{
			objectives = { "announce_recoverTarget" },
		}
		TppMission.UpdateObjective{
			objectives = { "announce_achieveAllObjectives" },
		}	
		
		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_01" , },
		}
		if svars.isFultonStartConfRuins == true then
			
			TppMission.UpdateObjective{
				objectives = { "clear_missionTask_02" , },
			}
			
			TppResult.AcquireSpecialBonus{
				first = { isComplete = true },
			}
		end

		
		TppMission.UpdateObjective{
			
			objectives = { "rv_missionClear" },
		}
		
		TppRadio.SetOptionalRadio("Set_s0033_oprg0040")
	end,
}



return this
