local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}



local GO_EXECUTE_TIMER = 60*10			
local GO_EXECUTE_TIMER_HELI = 60*11						

local NARROW_SEARCH_TIMER = 60*3								
local NARROW_SEARCH_TIMER_HELI = 60*3.5						

local GO_EXECUTE02_TIMER = 60*2.5			

local GIVE_UP_SEARCHING_TARGET01 = 90			




	HELI_START_TIME			= 11

local TARGET_HOSTAGE = {
	NORTH_FOREST = "hos_s10091_0000",
	SWAMP = "hos_s10091_0001",
}




this.missionTask_3_bonus_TARGET_LIST = {
	"sol_ExecuteUnit_0000",
	"sol_ExecuteUnit_0001",
}

this.missionTask_4_bonus_TARGET_LIST = {
	"hos_s10091_0002",
}


this.missionTask_5_TARGET_LIST = {
	"sol_SwampWest_0002",
	"sol_SwampWest_0003",
	"sol_SwampWest_0004",
	"sol_SwampWest_0005",
}

this.missionTask_6_TARGET_LIST = {
	"sol_Truck_Driver",
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 4 },
	},
	second = {
		missionTask = { taskNo = 5 },
	}
}




this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PLACED_LOCATOR_COUNT = 35







function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Game_MainGame",
		"Seq_Game_SwampTarget",
		"Seq_Game_ForestTarget",
		"Seq_Game_Escape",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end






this.saveVarsList = {

	isTarget01Rescue		= false,		
	isTarget02Rescue		= false,		

	isTarget01Marked		= false,		
	isTarget02Marked		= false,		

	isTarget01Unlocked		= false,		
	isTarget02Unlocked		= false,		

	isTarget01AlreadyMoved01	= false,		
	isTarget01AlreadyMoved02	= false,		


	isSearch0002Gone		= false,		
	isSearch0003Gone		= false,		

	isTarget02AreaSpecific	= false,		

	isExecuteUnitRouteChanged		= false,		
	isExecuteRadioStarted	= false,		
	isExecuteUnitInterrogated	= false,		
	isExecuteUnitRescued00	= false,		
	isExecuteUnitRescued01	= false,		

	isExecuteUnitDead00	= false,		
	isExecuteUnitDead01	= false,		

	isExecuteUnitOnMoving		= false,		

	isTransceiverFound		= false,		
	isSearchUnitSplitUp		= false,		
	isSearchUnitPullOut		= false,		
	isTimerPaused			= false, 		


	isSearchUnit01OnMoving		= false,		
	isSearchUnit02OnMoving		= false,		

	
	isExecuteUnitCount_clear	= 0,			
	isSearchUnitCount_clear	= 0,				

	isHiddenHostageFound	= false,			


	
	isHighInterrogationRemoved00	= false,		

	isHighInterrogationRemoved01	= false,		
	isHighInterrogationRemoved02	= false,
	isHighInterrogationRemoved03	= false,
	isHighInterrogationRemoved04	= false,
	isHighInterrogationRemoved05	= false,
	isHighInterrogationRemoved06	= false,		

	isThisHappened01 = false,				

	isThisHappened02 = false,				

	isThisHappened03 = false,				
	isThisHappened04 = false,				
	isThisHappened05 = false,				
	isThisHappened06 = false,				
	isThisHappened07 = false,				
	isThisHappened08 = false,				
	isThisHappened09 = false,				
	isThisHappened10 = false,				
	isThisHappened11 = false,				
	isThisHappened12 = false,				

	isFlagForA	= false,						

	isFlagForB	= false,						
	isFlagForC	= false,						
	isFlagForD	= false,
	isFlagForE	= false,
	isFlagForF	= false,
	isFlagForG	= false,
	isFlagForH	= false,

	countMinuteNum			= 0,
	countMinute02Num		= 0,

	
	countMissionTask01TargetsNum		= 0,		
	countMissionTask02TargetsNum		= 0,
	countMissionTask03TargetsNum		= 0,		
	countMissionTask04TargetsNum		= 0,
	countMissionTask05TargetsNum		= 0,		
	countMissionTask06TargetsNum		= 0,

	countEnvent01Num		= 0,
	countEnvent02Num		= 0,
	countEnvent03Num		= 0,
	countEnvent03Num		= 0,
}


this.checkPointList = {
	"CHK_After_IntelDemo",		
	"CHK_Target01Unlock",
	"CHK_Target02Unlock",
	nil
}


this.baseList = {
	"swamp",
	"swampWest",
	"swampSouth",
	"swampEast",
	nil
}




this.REVENGE_MINE_LIST = {"mafr_swamp"}

this.MISSION_REVENGE_MINE_LIST = {
	["mafr_swamp"] = {
		
		["trap_mafr_swamp_mine_south"] = {
			decoyLocatorList = {
				"itm_revDecoy_swamp_b_0005",
				"itm_revDecoy_swamp_b_0006",
				"itm_revDecoy_swamp_b_0007",
			},
			mineLocatorList = {
				"itm_revMine_swamp_a_0010",
				"itm_revMine_swamp_a_0011",

			},
		},
		
		["trap_mafr_swamp_mine_west"] = {
			decoyLocatorList = {
				"itm_revDecoy_swamp_b_0005",
				"itm_revDecoy_swamp_b_0006",
				"itm_revDecoy_swamp_b_0007",
			},
			mineLocatorList = {
				"itm_revMine_swamp_a_0012",		
			},
		},
	},
}






this.missionObjectiveDefine = {


	
	default_area_swampNorthForest = {
		gameObjectName = "marker_area_lostsignal",
		visibleArea = 3, viewType = "all", randomRange = 0,
		setNew = true,
		mapRadioName = "s0091_mprg1010",
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
	},

	
	swampNorthForest_Intel = {
		gameObjectName = "marker_swampNorthForest_Intel",
	},

	
	area_Intel_swampNorthForest_got = {
	},

	default_area_swamp = {
		gameObjectName = "marker_area_swamp",
		visibleArea = 4, viewType = "all", randomRange = 0,
		setNew = true,
		mapRadioName = "s0091_mprg1030",
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
	},

	
	interrogation_area_swampNorthForest = {
		gameObjectName = "marker_area_lostsignal",
		visibleArea = 1, viewType = "all", randomRange = 0,
		setNew = true,
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
	},

	
	interrogation_area_swamp_Target02 = {
		gameObjectName = "marker_area_swamp_02",
		visibleArea = 3, viewType = "all", randomRange = 0,
		setNew = true,
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
	},

	
	default_area_swamp_Target01 = {
		gameObjectName = "marker_area_hos_s10091",		
	
		visibleArea = 2, viewType = "all", randomRange = 0,
		setNew = true,
		mapRadioName = "s0091_mprg1040",
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
	},

	
	target01_identify = {
		gameObjectName = "hos_s10091_0000",
		setImportant= true,
		setNew = true,
		visibleArea = 0, viewType = "map_and_world_only_icon",
		mapRadioName = "f1000_mprg0100",		
		langId = "marker_info_mission_target",
		randomRange = 0,
		announceLog = "updateMap",

	},

	
	default_area_swamp_Target02 = {
		gameObjectName = "marker_area_swamp_02",
		visibleArea = 2, viewType = "all", randomRange = 0,
		setNew = true,
		mapRadioName = "s0091_mprg1050",
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
	},

	
	executeUnit_give_area_swamp_Target02 = {
		gameObjectName = "hos_s10091_0001",
		visibleArea = 1, viewType = "all", randomRange = 0,
		setNew = true,
		mapRadioName = "s0091_mprg1050",
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
	},

	
	target02_identify = {
		gameObjectName = "hos_s10091_0001",
		setImportant= true,
		setNew = true,
		visibleArea = 0, viewType = "map_and_world_only_icon",
		mapRadioName = "f1000_mprg0100",		
		langId = "marker_info_mission_target",
		randomRange = 0,
		announceLog = "updateMap",
	},


	
	
	default_photo_Target02 = {
		photoId	= 10,
	
		photoRadioName = "s0091_mirg1020",
	},
	
	default_photo_Target01 = {
		photoId = 20,
	
		photoRadioName = "s0091_mirg1010",
		targetBgmCp = "mafr_swamp_cp",
	},

	default_no_photo_CFABody = {
	},
	default_photo_CFABody = {
		photoId = 30,
	
		photoRadioName = "s0091_mirg2010",
		announceLog = "updateMissionInfo_AddDocument",		
	},


	
	hud_photo_Target02 = {
		hudPhotoId = 10
	},
	hud_photo_Target01 = {
		hudPhotoId = 20
	},

	
	default_photo_Target02_Clear = {
		photoId	= 10,
	},

	default_photo_Target01_Clear = {
		photoId	= 20,
	},

	
	executeUnit_route_swamp = {
		showEnemyRoutePoints = {  groupIndex=0, width=120.0, langId="marker_target_forecast_path",
		radioGroupName = "s0091_rtrg1100",		
			points={
				Vector3( -58.12451171875, -4.2573704719543, 68.919036865234 ),
				Vector3( -161.56494140625, -2.9288182258606, -3.3200855255127 ),
				Vector3( -299.93505859375, -2.4859547615051, -9.6083221435547 ),
			}
		},
		announceLog = "updateMap",
	},

	
	executeUnit_route_swamp_clear = {
	},

	
	subGoal_Two_Targets_Left = {	
		subGoalId= 0,
	},





	subGoal_Escape = {	
		subGoalId= 2,
	},

	
	interrogation_on_HiddenHostage = {
		gameObjectName = "hos_s10091_0002",

		goalType = "none",	
		viewType = "map_and_world_only_icon", setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",		
		mapRadioName = "f1000_esrg0780",
	},

	
	interrogation_on_TruckDriver = {
		showEnemyRoutePoints = {  groupIndex=0, width=120.0, langId="marker_enemy_forecast_path",
			points={
				Vector3( 324.40661621094, -5.929536819458, -5.8989562988281 ),
				Vector3( 75.087341308594, -5.2855243682861, -15.540008544922 ),
				Vector3( -93.103515625, -4.2972888946533, 61.769470214844 ),
				Vector3( -303.86633300781, -1.0187397003174, -65.842056274414 ),
				Vector3( -547.64880371094, 0.33483695983887, -204.58541870117 ),
				Vector3( -749.74475097656, 0.24825859069824, -423.70031738281 ),
				Vector3( -944.34619140625, -13.511232376099, -310.06106567383 ),
			}
		},
		announceLog = "updateMap",
	},

	
	interrogation_NoNeed_HiddenHostage = {
	},

	
	missionTask_1_RecoverTarget01 = {	
		missionTask = { taskNo=1, isComplete=false },
	},
	missionTask_1_RecoverTarget01_clear = {
		missionTask = { taskNo=1, isNew=true, isComplete=true },
	},


	missionTask_2_RecoverTarget02 = {	
		missionTask = { taskNo=3, isComplete=false },
	},
	missionTask_2_RecoverTarget02_clear = {
		missionTask = { taskNo=3,  isNew=true,isComplete=true },
	},


	missionTask_3_bonus_RecoverExecuteUnit = {	
		missionTask = { taskNo=4, isComplete=false, isFirstHide=true },
	},
	missionTask_3_bonus_RecoverExecuteUnit_clear = {
		missionTask = { taskNo=4, isNew=true },
	},

	missionTask_4_bonus_RecoverHiddenHostage = {
		missionTask = { taskNo=5, isComplete=false, isFirstHide=true },
	},
	missionTask_4_bonus_RecoverHiddenHostage_clear = {
		missionTask = { taskNo=5, isNew=true },
	},



	missionTask_5_RecoverSearchUnit = {	
		missionTask = { taskNo=6, isComplete=false, isFirstHide=true },
	},
	missionTask_5_RecoverSearchUnit_clear = {
		missionTask = { taskNo=6, isNew=true,isComplete=true },
	},


	missionTask_6_RecoverTruckDriver = {	
		missionTask = { taskNo=7, isComplete=false, isFirstHide=true },
	},
	missionTask_6_RecoverTruckDriver_clear = {
		missionTask = { taskNo=7, isNew=true, isComplete=true },
	},


	announce_RecoverTarget01 = {
		announceLog = "recoverTarget",
	},

	announce_RecoverTarget02 = {
		announceLog = "recoverTarget",
	},

	
	announce_rescue_all = {
		announceLog = "achieveAllObjectives",
	}

}


this.missionStartPosition = {
	
	orderBoxList = {
		"box_s10091_00",
	},
	
	helicopterRouteList = {
		"lz_drp_flowStation_E0000|lz_drp_flowStation_E_0000",	
		
		"lz_drp_swamp_W0000|lz_drp_swamp_W_0000",
	},
}



this.missionObjectiveEnum = Tpp.Enum{
	"target01_identify",
	"default_area_swamp_Target01",
	"default_area_swampNorthForest",
	"swampNorthForest_Intel",
	"area_Intel_swampNorthForest_got",
	"default_photo_Target02",
	"default_photo_Target02_Clear",
	"target02_identify",
	"default_area_swamp_Target02",
	"interrogation_area_swampNorthForest",
	"interrogation_area_swamp_Target02",
	"executeUnit_give_area_swamp_Target02",
	"default_area_swamp",
	"default_photo_Target01",
	"default_photo_Target01_Clear",
	"default_no_photo_CFABody",
	"default_photo_CFABody",
	"executeUnit_route_swamp",
	"executeUnit_route_swamp_clear",

	"hud_photo_Target01",
	"hud_photo_Target02",

	"subGoal_Two_Targets_Left",
	"subGoal_Escape",

	
	"missionTask_1_RecoverTarget01",
	"missionTask_1_RecoverTarget01_clear",
	"missionTask_2_RecoverTarget02",
	"missionTask_2_RecoverTarget02_clear",
	
	"missionTask_3_bonus_RecoverExecuteUnit",
	"missionTask_3_bonus_RecoverExecuteUnit_clear",
	"missionTask_4_bonus_RecoverHiddenHostage",
	"interrogation_on_HiddenHostage",
	"interrogation_NoNeed_HiddenHostage",
	"missionTask_4_bonus_RecoverHiddenHostage_clear",
	
	"missionTask_5_RecoverSearchUnit",
	"missionTask_5_RecoverSearchUnit_clear",
	"interrogation_on_TruckDriver",
	"missionTask_6_RecoverTruckDriver",
	"missionTask_6_RecoverTruckDriver_clear",


	"announce_RecoverTarget01",
	"announce_RecoverTarget02",
	"announce_rescue_all",
}

this.missionObjectiveTree = {

			target01_identify = {											
					default_area_swamp_Target01 = {					
								area_Intel_swampNorthForest_got = {
												swampNorthForest_Intel = {
													interrogation_area_swampNorthForest = {			
														default_area_swampNorthForest = {		
														},
													},
												},
								},
					},
			},


			target02_identify = {											
				executeUnit_give_area_swamp_Target02 = {				
					default_area_swamp_Target02 = {					
						interrogation_area_swamp_Target02 = {			
							default_area_swamp = {					
							},
						},
					},
				},
			},

			executeUnit_route_swamp_clear = {
					executeUnit_route_swamp = {},			
			},

			default_photo_Target02_Clear = {
												default_photo_Target02 = {},			
			},
			default_photo_Target01_Clear = {
												default_photo_Target01 = {},			
			},
			default_photo_CFABody ={
				default_no_photo_CFABody = {},
			},
			
			subGoal_Escape = {
				subGoal_Two_Targets_Left = {},
			},

			
			missionTask_1_RecoverTarget01_clear = {
				missionTask_1_RecoverTarget01 ={},
			},
			missionTask_2_RecoverTarget02_clear = {
				missionTask_2_RecoverTarget02 ={},
			},
			missionTask_3_bonus_RecoverExecuteUnit_clear = {
				missionTask_3_bonus_RecoverExecuteUnit ={},
			},
			missionTask_4_bonus_RecoverHiddenHostage_clear = {
												missionTask_4_bonus_RecoverHiddenHostage ={},
			},
			interrogation_NoNeed_HiddenHostage = {
						interrogation_on_HiddenHostage = {},
			},

			missionTask_5_RecoverSearchUnit_clear = {
				missionTask_5_RecoverSearchUnit ={},
			},
			missionTask_6_RecoverTruckDriver_clear = {
					interrogation_on_TruckDriver = {
							missionTask_6_RecoverTruckDriver ={},
					},
			},

}













function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")


	
	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "_openingDemo" },
	}

	
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppCritterBird" )

	
	TppMission.RegisterMissionSystemCallback(

	{
		OnEstablishMissionClear = function( missionClearType )
			Fox.Log("****Mission clear. On estableish mission clear")

			local currentsequence = TppSequence.GetCurrentSequenceName()
			if ( currentsequence == "Seq_Game_MainGame" ) then
				Fox.Log("****Still_Seq_Game_MainGame_NeedtoPlayMissionClearRadio")
				s10091_radio.AllTargetsRescued()

			elseif ( currentsequence == "Seq_Game_SwampTarget" ) then
				Fox.Log("****Still_Seq_Game_SwampTarget_NeedtoPlayMissionClearRadio")
				s10091_radio.AllTargetsRescued()

			elseif ( currentsequence == "Seq_Game_ForestTarget" ) then
				Fox.Log("****Still_Seq_Game_ForestTarget_NeedtoPlayMissionClearRadio")
				s10091_radio.AllTargetsRescued()

			else
				Fox.Log(" NoNeedtoPlayMissionClearRadio")
			end


			
			TppMotherBaseManagement.UnlockedStaffsS10091()

			
			if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
				TppPlayer.PlayMissionClearCamera()
				TppMission.MissionGameEnd{
					loadStartOnResult = true,
					

				
					fadeDelayTime = 7,
					
					delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
				}
			else
				
				TppMission.MissionGameEnd{ loadStartOnResult = true }
			end
		end,
		
		OnRecovered = function( gameObjectId )
			Fox.Log("##** OnRecovered_is_coming ####")

			this.OnTargetRescued(gameObjectId)

			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_3_bonus_TARGET_LIST ) then
				svars.countMissionTask03TargetsNum = this.CountRecoveredMissionBonusTask3( this.missionTask_3_bonus_TARGET_LIST )
				
				this.UIUpdatesforMissionBonusTask3()
			end

			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_4_bonus_TARGET_LIST ) then
				TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}	
				TppMission.UpdateObjective{
					objectives = {"missionTask_4_bonus_RecoverHiddenHostage_clear",},
				}
				s10091_enemy.RemoveHighInterrogationSubTask()		
				svars.isHighInterrogationRemoved01		=	true		
			end

			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_5_TARGET_LIST ) then
				svars.countMissionTask05TargetsNum = this.CountRecoveredMissionTask5( this.missionTask_5_TARGET_LIST )
				
				this.UIUpdatesforMissionTask5()
			end

			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_6_TARGET_LIST ) then
				TppMission.UpdateObjective{
					objectives = {"missionTask_6_RecoverTruckDriver_clear",},
				}
				s10091_enemy.RemoveHighInterrogationSubTask06()		
				svars.isHighInterrogationRemoved06		=	true		
			end
		end,

		OnGameOver = this.OnGameOver,

	
		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,
	
	}

	)

	
	
	TppMarker.SetUpSearchTarget{

		{
			gameObjectName = TARGET_HOSTAGE.NORTH_FOREST,
			gameObjectType = "TppHostageUnique",
			messageName = TARGET_HOSTAGE.NORTH_FOREST,
			wideCheckRange	= 0.01,
			skeletonName = "SKL_004_HEAD",
			func = this.IdentifyOnTarget01		
		},
		{
			gameObjectName = TARGET_HOSTAGE.SWAMP,
			gameObjectType = "TppHostageUnique",
			messageName = TARGET_HOSTAGE.SWAMP,
			wideCheckRange	= 0.01,
			skeletonName = "SKL_004_HEAD",
			func = this.IdentifyOnTarget02		
		},

	}


	
	TppPlayer.AddTrapSettingForIntel{
		intelName = "Intel_Swamp",	
		autoIcon = true,
		identifierName = "GetIntelIdentifier",
		locatorName = "GetIntel_Swamp",		
		gotFlagName = "isTransceiverFound",		
		trapName = "Trap_for_IntelDemo",	

		markerObjectiveName = "swampNorthForest_Intel",	
		markerTrapName = "Trap_for_IntelMarker",	
	}










	
	TppClock.RegisterClockMessage( "OnNight", TppClock.DAY_TO_NIGHT )		
	TppClock.RegisterClockMessage( "OnMorning", TppClock.NIGHT_TO_DAY )		

end




this.OnEndMissionPrepareSequence = function ()
	Fox.Log("###***OnEndMissionPrepareSequence, Get10091StaffID NOW***")
	this.SetTargetStaffMissionPhoto()
end

this.SetTargetStaffMissionPhoto = function ()
	Fox.Log("###***SetTargetStaffMissionPhoto***")
	local photoId = 10
	for key, hostageName in pairs( TARGET_HOSTAGE ) do
		local gameObjectId = GameObject.GetGameObjectId( hostageName )
		local staffId = TppMotherBaseManagement.GetStaffIdFromGameObject{ gameObjectId = gameObjectId }
		TppUiCommand.SetAdditonalMissionPhotoId(photoId, true,  false, staffId, 0)
		photoId = photoId + 10
	end
end


function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

















	
	TppRevenge.RegisterMissionMineList( this.MISSION_REVENGE_MINE_LIST )


end


function this.OnGameOver( gameOverType )
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
			
		TppPlayer.SetTargetDeadCamera{ gameObjectName = mvars.deadNPCId }		
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end
end








function this.Messages()
	return
	StrCode32Table {
			Marker = {
















				nil
			},
		
		Weather = {
			{
				msg = "Clock",	sender = "OnMorning",
				func = function( sender, time )
				
					s10091_enemy.SetWolfRouteDayTime()

				
					if (svars.isSearchUnitSplitUp	== true) and (svars.isSearchUnitPullOut		== false) then	
						s10091_enemy.SearchUnitDayTime()
					end
				end
			},
			{
				msg = "Clock",	sender = "OnNight",
				func = function( sender, time )
				
					s10091_enemy.SetWolfRouteNightTime()

				
					if (svars.isSearchUnitSplitUp	== true) and (svars.isSearchUnitPullOut		== false) then	
						s10091_enemy.SearchUnitNightTime()
					end
				end
			},
		},
		Terminal = {
			{
				msg = "MbDvcActCallBuddy",
				func = function( buddyType, callOption )
					if	buddyType == BuddyType.DOG then			
						Fox.Log("###****PlayHasCalledD-Dog, DeleteOptionalRadio:f1000_oprg0115!!!!")
						s10091_radio.DeleteOptionalRadio( "f1000_oprg0115" )						
					else
						Fox.Log("###****PlayHasCalledOtherBuddies!!!!")
					end
				end,
			},
		},
		GameObject = {
			
			{
				msg = "RoutePoint2",
				func = function (gameObjectId, routeId ,routeNode, messageId )

					
					if messageId == StrCode32("ExecuteStart") then
						Fox.Log("****ExecuteStart*****")
						TppEnemy.SetSneakRoute( "sol_ExecuteUnit_0000", "rts_Execute0000" )
						TppEnemy.SetSneakRoute( "sol_ExecuteUnit_0001", "rts_Execute0001" )

						
						this.CheckWhoIsOnRouteReset( "rt_swamp_d_0000","rts_swamp_0000_ExecuteStepBack01" )
						this.CheckWhoIsOnRouteReset( "rt_swamp_n_0000","rts_swamp_0000_ExecuteStepBack01" )

						

						
						TppEnemy.SetCautionRoute( "sol_ExecuteUnit_0000", "rts_Execute0000" )
						TppEnemy.SetCautionRoute( "sol_ExecuteUnit_0001", "rts_Execute0001" )

					
					elseif messageId == StrCode32("Hos_Sitdown") then
						Fox.Log("****Hos_Sitdown*****")
						this.OnTarget01Sitdown()

					
					elseif messageId == StrCode32("ExecuteNow") then
						Fox.Log("****ExecuteNow*****")
						s10091_enemy.GoToExecute( "sol_ExecuteUnit_0000" )

					elseif messageId == StrCode32("ExecuteNow01") then
						Fox.Log("****ExecuteNow01*****")
						s10091_enemy.GoToExecute( "sol_ExecuteUnit_0001" )

					
					elseif messageId == StrCode32("SearchStart") then
						Fox.Log("****SearchStart*****")
						TppEnemy.SetSneakRoute( "sol_SwampWest_0002", "rts_OffCar0001" )
						TppEnemy.SetSneakRoute( "sol_SwampWest_0003", "rts_OffCar0002" )
						TppEnemy.SetSneakRoute( "sol_SwampWest_0004", "rts_OffCar0003" )


						
						TppEnemy.SetCautionRoute( "sol_SwampWest_0002", "rts_OffCar0001" )
						TppEnemy.SetCautionRoute( "sol_SwampWest_0003", "rts_OffCar0002" )
						TppEnemy.SetCautionRoute( "sol_SwampWest_0004", "rts_OffCar0003_c" )	



					
					elseif messageId == StrCode32("SplitUp1") then
						Fox.Log("****SplitUp1*****")
						
						svars.isSearchUnitSplitUp		= true
						this.SetRouteBasedOnTime()

					
					elseif messageId == StrCode32("CheckTime01") then
						Fox.Log("****CheckTime01*****")
						this.SetRouteBasedOnTime()

					elseif messageId == StrCode32("CheckTime02") then
						Fox.Log("****CheckTime02*****")
						this.SetRouteBasedOnTimeCheckTime02()	

					
					elseif messageId == StrCode32("NotFound") then
						Fox.Log("****Message: NotFound*****")
					
						this.CheckSwampBeforeCPRadio( gameObjectId )		

					
					elseif messageId == StrCode32("BackSwamp") then
						Fox.Log("****Message: BackSwamp*****")
						TppEnemy.UnsetSneakRoute(gameObjectId)
						TppEnemy.UnsetCautionRoute(gameObjectId)

					
					elseif messageId == StrCode32("SurroundCarArrive") then
						
						TppEnemy.SetSneakRoute( "sol_SwampWest_0005", "rts_OffCar0004" )
						TppEnemy.SetCautionRoute( "sol_SwampWest_0005", "rts_OffCar0004" )


					elseif messageId == StrCode32("ReturnPosition") then
						Fox.Log("****Message: ReturnPosition*****")
						
						s10091_enemy.ReturnPosition()

					end
				end
			},

			
				{
					msg = "RadioEnd",
					func = function( gameObjectId, cpGameObjectId, speechLabel, isSuccess )
						Fox.Log( "*** ConversationEnd ***")
						if speechLabel == StrCode32( "CPR0081" ) then
							s10091_enemy.SetSearchUnitOnVehicle()	

							
							s10091_enemy.SurroundersBacktoSwamp()

							
							s10091_enemy.TravelPlanFinal()			
							svars.isSearchUnitPullOut		= true
						else
							Fox.Log("***********NotSpeicalCP************")
						end
					end
				},


			{
				msg = "Carried",
				func = function ( gameObjectId , carriedState )

					local is_s0091_rtrg1090_Played = TppRadio.IsPlayed( "s0091_rtrg1090" )		
					local is_s0091_rtrg1135_Played = TppRadio.IsPlayed( "s0091_rtrg1135" )		

					if gameObjectId == GameObject.GetGameObjectId( "hos_s10091_0000" ) then
					
						if carriedState == 0 and svars.isThisHappened01 == false then			
							Fox.Log("****###Target01isOnCarrying_CountDownTimer*****")
							this.SetUpTimerForTarget01Monologue()
						else
							Fox.Log("****###Target01_Won't_Monologue*****")
						end

					elseif gameObjectId == GameObject.GetGameObjectId( "hos_s10091_0001" ) then
					
						if carriedState == 0 and svars.isThisHappened02 == false then			
							Fox.Log("****###Target02isOnCarrying_CountDownTimer*****")
							this.SetUpTimerForTarget02Monologue()	
						else
							Fox.Log("****###Target02_Won't_Monologue*****")
						end
					else
							Fox.Log("****###NoTargetGetCarried*****")
					end
				end
			},

			{
				msg = "MonologueEnd",
				func = function ( gameObjectId , label )
					Fox.Log("***###Message_monologueEnd***")

					local abductHostageId01 = GameObject.GetGameObjectId( TARGET_HOSTAGE.NORTH_FOREST )

					local GetStatusCommand = { id = "GetStatus",}

					local status_abductHostage01 = GameObject.SendCommand( abductHostageId01 , GetStatusCommand )
					local abductHostage_monologue_25 = { id="CallMonologue", label = "speech091_carry025", carry = true, }

					
					if gameObjectId == GameObject.GetGameObjectId( "hos_s10091_0000" ) and status_abductHostage01 == TppGameObject.NPC_STATE_CARRIED then
						
						Fox.Log("***###MapUpdated_Target02***")
						TppMission.UpdateObjective{
							objectives = { "default_area_swamp_Target02"},
						}
						svars.isFlagForA		=	true		

						if label == Fox.StrCode32("speech091_carry020") then
							GameObject.SendCommand( abductHostageId01, abductHostage_monologue_25 )
						else
								Fox.Log("***###Target01_NoMore_Monologue***")
						end

					else
						Fox.Log("****###NotTarget01MonologueEnd*****")
					end
				end
			},

			{
				msg = "LostHostage",
				func = function()
					Fox.Log("****LostHostage->UnsetRoutes!*****")
					s10091_enemy.UnSetExecuteUnitRoute()		

					
					this.CheckWhoIsOnRouteReset( "rts_swamp_0000_ExecuteStepBack01","" )
					

				end
			},
			
			{
					msg = "Unlocked", sender = TARGET_HOSTAGE.NORTH_FOREST,
					func = function()
						Fox.Log("###UnlockedTarget01###")
						
						if (svars.isExecuteUnitRouteChanged		== false)	then
							Fox.Log("##ExecuteHasMovedYet_Check_CanSaveOnGame###")

							
							if (svars.isFlagForB		== false)	then						
								Fox.Log("##1st_On_UnlockedSaveOnTarget01###")
								TppMission.UpdateCheckPoint{
									checkPoint = "CHK_Target01Unlock",
								}
							else
								Fox.Log("##AlreadySavedOnce_UnlockedSaveOnTarget01###")
							end

						else
							Fox.Log("##CanNotSaveOnGame_as_ExecuteUnitIsOnMoving###")
						end

						svars.isTarget01Unlocked = true
						svars.isFlagForB		= true

						s10091_enemy.RemoveHighInterrogation()	
						svars.isHighInterrogationRemoved00		=	true		

					end
			},
			
			{
					msg = "Unlocked", sender = TARGET_HOSTAGE.SWAMP,
					func = function()
						Fox.Log("###UnlockedTarget02###")
						
						if (svars.isExecuteUnitRouteChanged		== false)	then
							Fox.Log("##ExecuteHasMovedYet_Check_CanSaveOnGame###")

							
							if (svars.isFlagForC		== false)	then						
								Fox.Log("##1st_On_UnlockedSaveOnTarget02###")
								TppMission.UpdateCheckPoint{
									checkPoint = "CHK_Target02Unlock",
								}
							else
								Fox.Log("##AlreadySavedOnce_UnlockedSaveOnTarget02###")
							end

						else
							Fox.Log("##CanNotSaveOnGame_as_ExecuteUnitIsOnMoving###")
						end

						svars.isTarget02Unlocked = true
						svars.isFlagForC	= true
					end
			},

			
			{
				msg = "Fulton",
				sender = "sol_ExecuteUnit_0000",
				func = function()
					Fox.Log("****ExecuteUnit0_Fultoned*****")
					this.SetUpExecuteRadioTimer()
				end
			},
			{
				msg = "Fulton",
				sender = "sol_ExecuteUnit_0001",
				func = function()
					Fox.Log("****ExecuteUnit1_Fultoned*****")
					this.SetUpExecuteRadioTimer()
				end
			},

			
			{
				msg = "PlacedIntoVehicle",
				sender = "sol_ExecuteUnit_0000",
				func = function( s_characterId, s_rideVehicleID )
					this.OnExecuteUnitHeliRescued( s_characterId, s_rideVehicleID )
				end,
			},
			{
				msg = "PlacedIntoVehicle",
				sender = "sol_ExecuteUnit_0001",
				func = function( s_characterId, s_rideVehicleID )
					this.OnExecuteUnitHeliRescued( s_characterId, s_rideVehicleID )
				end,
			},

			
			{
				msg = "ChangePhase", sender = "mafr_swamp_cp",
				func = function (gameObjectId, phaseName)
					Fox.Log("###mafr_swamp_cp PHASE CHANGE!!!!")
					if (phaseName >= TppGameObject.PHASE_ALERT) then		
						Fox.Log("###mafr_swamp_cp PHASE:Alert")
						this.PauseAllTimer()	

					else
						Fox.Log("###mafr_swamp_cp PHASE:Sneak&Caution")
						this.RestartAllTimer()		

						
						s10091_enemy.SetSwampNearRoute()

					end
				end
			},

			
			{
				msg = "ChangePhase", sender = "mafr_swampWest_ob",
				func = function (gameObjectId, phaseName)
					Fox.Log("###mafr_swampWest_ob PHASE CHANGE!!!!")
					if (phaseName >= TppGameObject.PHASE_EVASION) or (phaseName >= TppGameObject.PHASE_ALERT) then
						Fox.Log("###mafr_swampWest_ob PHASE:Alert")
						this.PauseAllTimer()	

					else
						Fox.Log("###mafr_swampWest_ob  PHASE:Sneak&Caution")
						this.RestartAllTimer()		
					end
				end
			},

			
			{
					msg = "Unlocked", sender = "hos_s10091_0002",
					func = function()
						Fox.Log("###UnlockedSubTaskTarget###")
						if	svars.isHiddenHostageFound	== false		then
							s10091_enemy.RemoveHighInterrogationSubTask()	
							TppMission.UpdateObjective{
								objectives = {"interrogation_NoNeed_HiddenHostage",},
							}
							svars.isHiddenHostageFound	= true
						else

						end

						svars.isHighInterrogationRemoved01		=	true		
					end
			},


			
			{
					msg = "Dead", sender = "hos_s10091_0002",
					func = function()
						Fox.Log("###DeadOnSubTaskTarget###")
						s10091_enemy.RemoveHighInterrogationSubTask()	
						svars.isHighInterrogationRemoved01		=	true		
					end
			},
			
			{
				msg = "Dead",
				sender = TARGET_HOSTAGE.NORTH_FOREST,
				func = function( arg0, arg1 )

					if arg1 == GameObject.GetGameObjectId( "Player" ) then		
						Fox.Log("###CommonRadio_PlayerKilledTarget_f8000_gmov2500###")
						mvars.deadNPCId = TARGET_HOSTAGE.NORTH_FOREST,		
						TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.PLAYER_KILL_TARGET )	
					else
						mvars.deadNPCId = TARGET_HOSTAGE.NORTH_FOREST,		
						this.OnTargetDead()		
					end
				end
			},

			
			{
				msg = "Dead",
				sender = TARGET_HOSTAGE.SWAMP,
				func = function( arg0, arg1 )

					if arg1 == GameObject.GetGameObjectId( "Player" ) then		
						Fox.Log("###CommonRadio_PlayerKilledTarget_f8000_gmov2500###")
						mvars.deadNPCId = TARGET_HOSTAGE.SWAMP,		
						TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.PLAYER_KILL_TARGET )	
					else
						mvars.deadNPCId = TARGET_HOSTAGE.SWAMP,		
						this.OnTargetDead()		
					end

				end
			},

			
			{
				msg = "Dead",
				sender = "sol_Truck_Driver",
				func = function()
					Fox.Log("###Dead_on_sol_Truck_Driver!!!!###")
					s10091_enemy.RemoveHighInterrogationSubTask06()		
					svars.isHighInterrogationRemoved06		=	true		
				end
			},
			
			{
				msg = "Dead",
				sender = "sol_ExecuteUnit_0000",
				func = function()
					Fox.Log("###Dead_on_sol_ExecuteUnit_0000!!!!###")
					svars.isExecuteUnitDead00	= true

				end
			},
			
			{
				msg = "Dead",
				sender = "sol_ExecuteUnit_0001",
				func = function()
					Fox.Log("###Dead_on_sol_ExecuteUnit_0001!!!!###")
					svars.isExecuteUnitDead01	= true

				end
			},


		},
		
		Timer = {
			
			{
				msg = "Finish", sender = "Go_1stCar",
				func = function()
					
					if svars.isSearchUnit01OnMoving == false then	
						Fox.Log("***NoCarsOnMoving->1stCar_Travel")
						
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0002"), { id = "StartTravel", travelPlan="Travel_First_Car" } )
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0003"), { id = "StartTravel", travelPlan="Travel_First_Car" } )
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0004"), { id = "StartTravel", travelPlan="Travel_First_Car" } )

						

						
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_Truck_Driver"), { id = "StartTravel", travelPlan="Travel_Truck" } )

						svars.isSearchUnit01OnMoving = true	
					else
							Fox.Log("***1stCar_isAlreadyOnMoving")
					end
				end,
				option = { isExecDemoPlaying = true },
			},
			
			{
				msg = "Finish", sender = "Go_Execute",
				func = function()
					if (svars.isExecuteUnitRouteChanged		== false) then		
						Fox.Log("###Timer_Go_Execute!!!!###")
						if	TppEnemy.GetLifeStatus( "sol_ExecuteUnit_0000" ) == TppEnemy.LIFE_STATUS.NORMAL and
							TppEnemy.GetStatus( "sol_ExecuteUnit_0000" ) == EnemyState.NORMAL or						

							TppEnemy.GetLifeStatus( "sol_ExecuteUnit_0001" ) == TppEnemy.LIFE_STATUS.NORMAL and
							TppEnemy.GetStatus( "sol_ExecuteUnit_0001" ) == EnemyState.NORMAL then
							Fox.Log("###AtLeastExecuteUnitStillAlive!!!!###")
								TppEnemy.SetSneakRoute( "sol_ExecuteUnit_0000", "Second_Car" )
								TppEnemy.SetSneakRoute( "sol_ExecuteUnit_0001", "Second_Car" )

								
								TppEnemy.SetCautionRoute( "sol_ExecuteUnit_0000", "Second_Car" )
								TppEnemy.SetCautionRoute( "sol_ExecuteUnit_0001", "Second_Car" )

								svars.isExecuteUnitRouteChanged	= true			

								this.SwitchExecuteUnitRadio()	

								this.OffCheckPointSave()		
						else
							Fox.Log("###NonExecuteUnitSurived!!!!###")
						end
					else
						Fox.Log("###ExecuteUnit_Already_OnMoving!!!!###")

					end
				end,
			},
			
			{
				msg = "Finish", sender = "Go_Execute02",
				func = function()
					if (svars.isExecuteUnitRouteChanged		== false) then		
						Fox.Log("###Timer_Go_Execute02!!!!###")
						if	TppEnemy.GetLifeStatus( "sol_ExecuteUnit_0000" ) == TppEnemy.LIFE_STATUS.NORMAL and
							TppEnemy.GetStatus( "sol_ExecuteUnit_0000" ) == EnemyState.NORMAL or						

							TppEnemy.GetLifeStatus( "sol_ExecuteUnit_0001" ) == TppEnemy.LIFE_STATUS.NORMAL and
							TppEnemy.GetStatus( "sol_ExecuteUnit_0001" ) == EnemyState.NORMAL then
							Fox.Log("###AtLeastExecuteUnitStillAlive!!!!###")
								TppEnemy.SetSneakRoute( "sol_ExecuteUnit_0000", "Second_Car" )
								TppEnemy.SetSneakRoute( "sol_ExecuteUnit_0001", "Second_Car" )

								
								TppEnemy.SetCautionRoute( "sol_ExecuteUnit_0000", "Second_Car" )
								TppEnemy.SetCautionRoute( "sol_ExecuteUnit_0001", "Second_Car" )

								svars.isExecuteUnitRouteChanged	= true			

								this.SwitchExecuteUnitRadio()	

								this.OffCheckPointSave()		
						else
							Fox.Log("###NonExecuteUnitSurived!!!!###")
						end
					else
						Fox.Log("###ExecuteUnit_Already_OnMoving!!!!###")

					end
				end,
			},

			
			{
				msg = "Finish", sender = "Go_SurroundCar",
				func = function()
					Fox.Log("###Go_SurroundCar!!!!###")
					if svars.isSearchUnit02OnMoving == false then	
					
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0005"), { id = "StartTravel", travelPlan="Travel_Surround_Car" } )

						svars.isSearchUnit02OnMoving = true	
					else
						Fox.Log("***2ndSurroundCar_isAlreadyOnMoving")
					end
				end,
				option = { isExecDemoPlaying = true },
			},

			
			{
				msg = "Finish", sender = "NarrowSearchNow",
				func = function()
					if	svars.isSearchUnitPullOut		== false then		
						s10091_enemy.NarrowSearch()
						GkEventTimerManager.Start("Target01_Found", 90 )
					else
						Fox.Log("###SearchUnitHasAlreadyPullOut!!!!###")
					end
				end,
				option = { isExecDemoPlaying = true },
			},

			
			{
				msg = "Finish", sender = "Target01_Found",
				func = function()
					TppEnemy.SetSneakRoute( "sol_SwampWest_0002", "rts_d_SearchFinal" )

					TppEnemy.SetCautionRoute( "sol_SwampWest_0002", "rts_d_SearchFinal" )
				end,
				option = { isExecDemoPlaying = true },
			},
			
			{
				msg = "Finish", sender = "Target01_EnemyNotFoundInTime",
				func = function()
					Fox.Log("###Timer:Target01NotFoundbyEnemy###")
					this.TimeUpCheckSwampBeforeCPRadio()
				end,
			},
			
			{
				msg = "Finish", sender = "ExecuteRadio",
				func = function()
					if vars.isAfrikaansTranslatable == 1 then
						Fox.Log("###***YES_AfrikaansTranslatable!!!!###")
						if (svars.isExecuteRadioStarted	== false) then		

							local No19isPlayed = TppRadio.IsPlayed( "s0091_oprg1030" )		
							local No52isPlayed = TppRadio.IsPlayed( "s0091_rtrg2020" )		

							if ( No19isPlayed == false ) and (svars.isTarget02Marked	== false) and (svars.isTarget02Rescue	== false) then
								Fox.Log("###s0091_rtrg1110+s0091_rtrg1120!!!!###")
								s10091_radio.ExecuteUnitRescued03()

							else
								Fox.Log("###s0091_rtrg1110_ONLY!!!!###")
								s10091_radio.ExecuteUnitRescued01()
							end
						svars.isExecuteRadioStarted	 = true		

						end
					else
						Fox.Log("###***SORRY_NoAfrikaansTranslatable!!!!###")
					end
				end,
			},
			
			{
				msg = "Finish", sender = "LocationOnTarget02",
				func = function()
					





					local No47isPlayed = TppRadio.IsPlayed( "s0091_rtrg1120" )		

					
					if ( No47isPlayed == false ) and (svars.isTarget02Marked	== false) and (svars.isTarget02Rescue	== false) and (svars.isFlagForA		== false) then	
						Fox.Log("###s0091_rtrg2020###")
						s10091_radio.LocationOnTarget02First()
						svars.isFlagForA		=	true
					
					elseif ( No47isPlayed == false ) and (svars.isTarget02Marked	== false) and (svars.isTarget02Rescue	== false) and (svars.isFlagForA		== true) then	
						Fox.Log("###s0091_rtrg2025###")
						s10091_radio.LocationOnTarget02Second()
						svars.isFlagForA		=	true

					
					elseif ( No47isPlayed == true ) and (svars.isTarget02Marked	== false) and (svars.isTarget02Rescue	== false) then
						Fox.Log("###s0091_rtrg2025###")
						s10091_radio.LocationOnTarget02Second()

					else
						Fox.Log("###NoNeedInfoOnTarget02###")
					end
				end,
			},
			
			{
				msg = "Finish", sender = "CountDown_Target01_Monologue",
				func = function()
					Fox.Log("###TimerFinished:Target01_Monologue_Check_Monologue###")

					local gameObjectId = GameObject.GetGameObjectId( "TppHostageUnique", TARGET_HOSTAGE.NORTH_FOREST )
					local command = {	id = "GetStatus",	}
					local actionStatus = GameObject.SendCommand( gameObjectId, command )
					
					if actionStatus == TppGameObject.NPC_STATE_CARRIED then
						this.Target01CallMonologue()		
					else
						Fox.Log("***###HostageNotOnCarrying***")
					end
				end,
				option = { isExecDemoPlaying = true },
			},
			
			{
				msg = "Finish", sender = "CountDown_Target02_Monologue",
				func = function()
					Fox.Log("###TimerFinished:Target02_Monologue_Check_Monologue###")

					local gameObjectId = GameObject.GetGameObjectId( "TppHostageUnique", TARGET_HOSTAGE.SWAMP )
					local command = {	id = "GetStatus",	}
					local actionStatus = GameObject.SendCommand( gameObjectId, command )
					
					if actionStatus == TppGameObject.NPC_STATE_CARRIED then
						this.Target02CallMonologue()		
					else
						Fox.Log("***###HostageNotOnCarrying***")
					end

				end,
				option = { isExecDemoPlaying = true },
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
			nil
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
			
			{
				msg = "GetIntel", sender = "Intel_Swamp",
				func = function( intelNameHash )
					this.OnGetIntelSwamp( intelNameHash )
					this.PauseAllTimerIntelDemo()			
				end,
			},
			{	
				msg = "PressedFultonNgIcon",
				func = function ( id,charaId )
					Fox.Log("_________s10091_radio.messages.  PressedFultonNgIcon_____charaId : " ..  charaId)
					if charaId == GameObject.GetGameObjectId("hos_s10091_0001") then
						TppRadio.Play( "f1000_rtrg1600")
					end
				end
			},
		},

		Trap = {
			{
				msg = "Exit",
				sender = "trap_StartArea",
				func = function ()

				end
			}
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





this.SetUpTimer01 = function()
	if GkEventTimerManager.IsTimerActive( "Go_Execute" ) then
		
		GkEventTimerManager.Stop( "Go_Execute" )
		GkEventTimerManager.Start( "Go_Execute", GO_EXECUTE_TIMER )
	else
		
		GkEventTimerManager.Start( "Go_Execute", GO_EXECUTE_TIMER )
	end
end

this.SetUpTimer02 = function()
	if GkEventTimerManager.IsTimerActive( "NarrowSearchNow" ) then
		
		GkEventTimerManager.Stop( "NarrowSearchNow" )
		GkEventTimerManager.Start( "NarrowSearchNow", NARROW_SEARCH_TIMER )
	else
		
		GkEventTimerManager.Start( "NarrowSearchNow", NARROW_SEARCH_TIMER )
	end
end


this.SetUpTimer03 = function()
	if GkEventTimerManager.IsTimerActive( "Go_Execute" ) then
		
		GkEventTimerManager.Stop( "Go_Execute" )
		GkEventTimerManager.Start( "Go_Execute", 120 )
	else
		
		GkEventTimerManager.Start( "Go_Execute", 120 )
	end
end


this.SetUpTimer04 = function()
	if GkEventTimerManager.IsTimerActive( "Target01_EnemyNotFoundInTime" ) then
		
		GkEventTimerManager.Stop( "Target01_EnemyNotFoundInTime" )
		GkEventTimerManager.Start( "Target01_EnemyNotFoundInTime", GIVE_UP_SEARCHING_TARGET01 )
	else
		
		GkEventTimerManager.Start( "Target01_EnemyNotFoundInTime", GIVE_UP_SEARCHING_TARGET01 )
	end
end


this.SetUpTimer05 = function()
	if GkEventTimerManager.IsTimerActive( "Go_SurroundCar" ) then
		
		GkEventTimerManager.Stop( "Go_SurroundCar" )
		GkEventTimerManager.Start( "Go_SurroundCar", 25 )
	else
		
		GkEventTimerManager.Start( "Go_SurroundCar", 25 )
	end
end


this.SetUpTimer06 = function()
	if GkEventTimerManager.IsTimerActive( "Go_1stCar" ) then
		
		GkEventTimerManager.Stop( "Go_1stCar" )
		GkEventTimerManager.Start( "Go_1stCar", 5 )
	else
		
		GkEventTimerManager.Start( "Go_1stCar", 5 )
	end
end


this.SetUpExecuteRadioTimer = function()
	if GkEventTimerManager.IsTimerActive( "ExecuteRadio" ) then
		
		GkEventTimerManager.Stop( "ExecuteRadio" )
		GkEventTimerManager.Start( "ExecuteRadio", 15 )
	else
		
		GkEventTimerManager.Start( "ExecuteRadio", 15 )
	end
end

this.SetUpLocationOnTarget02RadioTimer = function()
	if GkEventTimerManager.IsTimerActive( "LocationOnTarget02" ) then
		
		GkEventTimerManager.Stop( "LocationOnTarget02" )
		GkEventTimerManager.Start( "LocationOnTarget02", 15 )
	else
		
		GkEventTimerManager.Start( "LocationOnTarget02", 15 )
	end
end





this.SetUpTimer01Heli = function()
	if GkEventTimerManager.IsTimerActive( "Go_Execute" ) then
		
		GkEventTimerManager.Stop( "Go_Execute" )
		GkEventTimerManager.Start( "Go_Execute", GO_EXECUTE_TIMER_HELI )
	else
		
		GkEventTimerManager.Start( "Go_Execute", GO_EXECUTE_TIMER_HELI )
	end
end

this.SetUpTimer02Heli = function()
	if GkEventTimerManager.IsTimerActive( "NarrowSearchNow" ) then
		
		GkEventTimerManager.Stop( "NarrowSearchNow" )
		GkEventTimerManager.Start( "NarrowSearchNow", NARROW_SEARCH_TIMER_HELI )
	else
		
		GkEventTimerManager.Start( "NarrowSearchNow", NARROW_SEARCH_TIMER_HELI )
	end
end


this.SetUpTimer05Heli = function()
	if GkEventTimerManager.IsTimerActive( "Go_SurroundCar" ) then
		
		GkEventTimerManager.Stop( "Go_SurroundCar" )
		GkEventTimerManager.Start( "Go_SurroundCar", 75 )
	else
		
		GkEventTimerManager.Start( "Go_SurroundCar", 75 )
	end
end


this.SetUpTimer06Heli = function()
	if GkEventTimerManager.IsTimerActive( "Go_1stCar" ) then
		
		GkEventTimerManager.Stop( "Go_1stCar" )
		GkEventTimerManager.Start( "Go_1stCar", 50 )
	else
		
		GkEventTimerManager.Start( "Go_1stCar", 50 )
	end
end


this.StopAllTimerContinue = function()
	Fox.Log("StopAllTimer_B/C Continue!!!")

	GkEventTimerManager.Stop( "Go_Execute" )
	GkEventTimerManager.Stop( "NarrowSearchNow" )
	GkEventTimerManager.Stop( "Go_1stCar" )
	GkEventTimerManager.Stop( "Go_SurroundCar" )
end

this.OffCheckPointSave = function()
	Fox.Log("OffCheckPointSave")
	TppCheckPoint.Disable{
		baseName = {
			"swamp",
			"swampWest",
			"swampSouth",
			"swampEast",
		}
	}
end


this.SetUpTimerForTarget01Monologue = function()
	if GkEventTimerManager.IsTimerActive( "CountDown_Target01_Monologue" ) then
		
		GkEventTimerManager.Stop( "CountDown_Target01_Monologue" )
		GkEventTimerManager.Start( "CountDown_Target01_Monologue", 8 )
	else
		
		GkEventTimerManager.Start( "CountDown_Target01_Monologue", 8 )
	end
end


this.SetUpTimerForTarget02Monologue = function()
	if GkEventTimerManager.IsTimerActive( "CountDown_Target02_Monologue" ) then
		
		GkEventTimerManager.Stop( "CountDown_Target02_Monologue" )
		GkEventTimerManager.Start( "CountDown_Target02_Monologue", 10 )
	else
		
		GkEventTimerManager.Start( "CountDown_Target02_Monologue", 10 )
	end
end


function this.OnTargetDead( s_characterId )
		Fox.Log("###CommonRadio_TargetDead_f8000_gmov0110###")
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )	
end


function this.OnTwoHostageRescued()
		Fox.Log( "****Check_If_All_TARGET_Are_Rescued!Get_Out!!!!*****" )
	if 	(svars.isTarget01Rescue		== true) and (svars.isTarget02Rescue	== true) then		
		Fox.Log( "****GoTo_Seq_Game_Escape!!!!*****" )
		TppSequence.SetNextSequence("Seq_Game_Escape")		

	elseif	(svars.isTarget01Rescue		== true) and (svars.isTarget02Rescue	== false) then	
		Fox.Log( "****GoTo_Seq_Game_SwampTarget!!!!*****" )
		TppSequence.SetNextSequence("Seq_Game_SwampTarget" )		
		Fox.Log("###Radio s0091_rtrg2010+ α###")
		this.PlayRadio001()		
		this.OnSwithOptionalRadio()		

	elseif	(svars.isTarget01Rescue		== false) and (svars.isTarget02Rescue	== true) then	
		Fox.Log( "****GoTo_Seq_Game_ForestTarget!!!!*****" )
		TppSequence.SetNextSequence("Seq_Game_ForestTarget" )	
		Fox.Log("###Radio s0091_rtrg2010+ α###")
		this.PlayRadio001()		
		this.OnSwithOptionalRadio()		

	else
		Fox.Log( "****WRONG_RescueCondition!!!!*****" )
	end

end


this.InsertTarget01HudPhoto = function()
	Fox.Log("###***InsertTarget01HudPhoto")
	if svars.isTarget01Marked == false then
		Fox.Log("###***Target01_NotMarkedYet_InsertTarget01HudPhoto")
		local gameObjectId = GameObject.GetGameObjectId( TARGET_HOSTAGE.NORTH_FOREST )
		local staffId = TppMotherBaseManagement.GetStaffIdFromGameObject{ gameObjectId = gameObjectId }
		TppUiCommand.ShowPictureInfoHud( "mb_staff", staffId, 3.0 )
	else
		Fox.Log("###***Target01_HasAlreadyMarked_NoNeedforHudPhoto")
	end
end



this.InsertTarget01HudPhotoAfterFulton = function()
	Fox.Log("###***InsertTarget01HudPhotoAfterFulton ")
	if svars.isTarget01Marked == false then
		Fox.Log("###***Target01_NotMarkedYet_InsertTarget01HudPhoto")
		TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )		
		local gameObjectId = GameObject.GetGameObjectId( TARGET_HOSTAGE.NORTH_FOREST )
		local staffId = TppMotherBaseManagement.GetStaffIdFromGameObject{ gameObjectId = gameObjectId }
		TppUiCommand.ShowPictureInfoHud( "mb_staff", staffId, 3.0 )
	else
		Fox.Log("###***Target01_HasAlreadyMarked_NoNeedforHudPhoto")
	end
end



this.InsertTarget02HudPhoto = function()
	Fox.Log("###***InsertTarget02HudPhoto")
	if svars.isTarget02Marked == false then
		Fox.Log("###***Target02_NotMarkedYet_InsertTarget01HudPhoto")
		local gameObjectId = GameObject.GetGameObjectId( TARGET_HOSTAGE.SWAMP )
		local staffId = TppMotherBaseManagement.GetStaffIdFromGameObject{ gameObjectId = gameObjectId }
		TppUiCommand.ShowPictureInfoHud( "mb_staff", staffId, 3.0 )
	else
		Fox.Log("###***Target02_HasAlreadyMarked_NoNeedforHudPhoto")
	end
end


this.IdentifyOnTarget01 = function()
	Fox.Log("*****!!!!IdentifyOnTarget01 !!!!")

	this.InsertTarget01HudPhoto()

	if 	(svars.isTarget01Rescue		== false)	then	
			s10091_radio.FoundTarget01()
	end

	
	TppMission.UpdateObjective{
		objectives = { "target01_identify" },
	}

	s10091_enemy.RemoveHighInterrogation()	
	svars.isHighInterrogationRemoved00		=	true		
	svars.isTarget01Marked		= true		

	this.OnSwithOptionalRadio()		
	this.SwitchIntelRadio()			
	s10091_radio.DeleteOptionalRadioOnTarget01()
	s10091_radio.DeleteOptionalRadioEnterForest()
end



this.IdentifyOnTarget02 = function()
	Fox.Log("*****!!!!IdentifyOnTarget02 !!!!")
	this.InsertTarget02HudPhoto()

	s10091_radio.FoundTarget02()

	
	TppMission.UpdateObjective{
		objectives = { "target02_identify" },
	}
	svars.isFlagForA		=	true		
	svars.isTarget02Marked		= true		

	this.OnSwithOptionalRadio()		
	s10091_radio.DeleteOptionalRadioEnterSwamp()
end




this.PlayRadio001 = function()
	local is_s0091_rtrg4010_Played = TppRadio.IsPlayed( "s0091_rtrg4010" )		

	if (is_s0091_rtrg4010_Played	==	false)	then
		Fox.Log("##**s0091_rtrg4010 hasnot been played Yet")

		
		if (svars.isTarget01Rescue	== false) and (svars.isTarget02Rescue	== true) and (svars.isTarget01Unlocked == true) then
			
			Fox.Log("#### Radio_s0091_rtrg2010")
			s10091_radio.RescueOneAntherIsUnlocked()

		elseif (svars.isTarget01Rescue == false) and (svars.isTarget02Rescue == true) and (svars.isTarget01Unlocked == false)	then
			
			Fox.Log("#### Radio_s0091_rtrg2010 + s0091_rtrg3010 ####")
			s10091_radio.NextTarget01Position()

		
		elseif (svars.isTarget01Rescue	== true) and (svars.isTarget02Rescue	== false) and (svars.isTarget02Unlocked == true) then
			
			Fox.Log("#### Radio_s0091_rtrg2010")
			
			this.SetUpLocationOnTarget02RadioTimer()

			s10091_radio.RescueOneAntherIsUnlocked()

		elseif (svars.isTarget01Rescue	== true) and (svars.isTarget02Rescue	== false) and (svars.isTarget02Unlocked	==	false)	then
			
			Fox.Log("#### Radio_s0091_rtrg2010 + s0091_rtrg2030 ####")
			
			this.SetUpLocationOnTarget02RadioTimer()

			s10091_radio.NextTarget02Position()
		else
			Fox.Log("#### Wrong_Flags!!!!")
		end
	else
		Fox.Log("##**s0091_rtrg4010 has Already been played, No more radio play!")
	end
end



this.UpdateTarget01AnnounceLog = function()
		Fox.Log("###*** UpdateTarget01AnnounceLog ####")
		
		TppMission.UpdateObjective{
			objectives = { "target01_identify", "announce_RecoverTarget01" },		
		}

		
		if svars.isTarget01Rescue == true or svars.isTarget02Rescue == true then
			svars.countMissionTask01TargetsNum = svars.countMissionTask01TargetsNum + 1
			TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.countMissionTask01TargetsNum, 2 )
		end

		TppMission.UpdateObjective{
			objectives = { "missionTask_1_RecoverTarget01_clear", "default_photo_Target01_Clear" },		
		}
		
end


this.UpdateTarget02AnnounceLog = function()
		Fox.Log("###*** UpdateTarget02AnnounceLog ####")
		
		TppMission.UpdateObjective{
			objectives = { "target02_identify", "announce_RecoverTarget02" },		
		}

		
		if svars.isTarget01Rescue == true or svars.isTarget02Rescue == true then
			svars.countMissionTask01TargetsNum = svars.countMissionTask01TargetsNum + 1
			TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.countMissionTask01TargetsNum, 2 )
		end

		TppMission.UpdateObjective{
			objectives = { "missionTask_2_RecoverTarget02_clear", "default_photo_Target02_Clear" },		
		}
		
end


this.SetRouteBasedOnTime = function()
	local timeOfDay = TppClock.GetTimeOfDay()
	if (timeOfDay == "day") and (svars.isSearchUnitPullOut		== false) then	
		s10091_enemy.SearchUnitDayTime()
	elseif (timeOfDay == "night") and (svars.isSearchUnitPullOut		== false) then	
		s10091_enemy.SearchUnitNightTime()
	else

	end
end

this.SetRouteBasedOnTimeCheckTime02 = function()
	local timeOfDay = TppClock.GetTimeOfDay()
	if (timeOfDay == "day") and (svars.isSearchUnitPullOut		== false) then	
		s10091_enemy.SearchUnit02DayTime()
	elseif (timeOfDay == "night") and (svars.isSearchUnitPullOut		== false) then	
		s10091_enemy.SearchUnit02NightTime()
	else

	end
end


this.OnTarget01Moving01 = function()
	if	(svars.isTarget01Unlocked == false) then
		Fox.Log( "*****OnTarget01Moving01*****")
		local gameObjectId = GameObject.GetGameObjectId( "hos_s10091_0000" )
		local command = {
			id = "SetSneakRoute",
			route = "rts_hos_ChangeRoute01",
		}
		GameObject.SendCommand( gameObjectId, command )
	end
end


















this.OnTarget01Sitdown = function()
	Fox.Log( "*****OnTarget01Sitdown*****")
	local gameObjectId = GameObject.GetGameObjectId( "hos_s10091_0000" )
	local command = {
		id = "SetSneakRoute",
		route = "",
	}
	GameObject.SendCommand( gameObjectId, command )
end



this.CheckSwampBeforeCPRadio = function( gameObjectId )
	
	local cpgameObjectId = { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_swamp_cp") }
	local command = { id = "GetPhase" }
	local phaseName = GameObject.SendCommand( cpgameObjectId, command )

	
	local aliveSoldier = s10091_enemy.CheckAliveEnemy()

	if	svars.isSearchUnitPullOut	== false	then

		if (phaseName == TppGameObject.PHASE_SNEAK) and ( aliveSoldier )then
			Fox.Log("***##SurroundUnitAlive&SNEAK PlayCPRadio!!!************")
			local gameObjectId = GameObject.GetGameObjectId(aliveSoldier)

			s10091_enemy.CPRadioNotFoundTarget( gameObjectId )

		else
			Fox.Log("***###PullOutWithOutNoRadio************")

			s10091_enemy.SetSearchUnitOnVehicle()	

			
			s10091_enemy.SurroundersBacktoSwamp()

			
			s10091_enemy.TravelPlanFinal()			
			svars.isSearchUnitPullOut		= true
		end
	else
		Fox.Log("***###SearchUnitAlreadyPullOut!************")
	end
end



this.TimeUpCheckSwampBeforeCPRadio = function()
	
	local cpgameObjectId = { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_swamp_cp") }
	local command = { id = "GetPhase" }
	local phaseName = GameObject.SendCommand( cpgameObjectId, command )

	
	local aliveSoldier = s10091_enemy.CheckAliveEnemy()

	if	svars.isSearchUnitPullOut	== false	then

		if (phaseName == TppGameObject.PHASE_SNEAK) and ( aliveSoldier )then
			Fox.Log("***###SwampInPhaseSNEAK PlayCPRadio!!!************")
			local gameObjectId = GameObject.GetGameObjectId(aliveSoldier)

			s10091_enemy.CPRadioNotFoundTarget( gameObjectId )

		else
			Fox.Log("***###PullOutWithOutNoRadio************")

			s10091_enemy.SetSearchUnitOnVehicle()	

			
			s10091_enemy.SurroundersBacktoSwamp()

			
			s10091_enemy.TravelPlanFinal()			
			svars.isSearchUnitPullOut		= true
		end
	else
		Fox.Log("***###SearchUnitAlreadyPullOut!************")
	end
end



this.OnSwithOptionalRadio = function()
	Fox.Log( "*****OnSwithOptionalRadio*****")
	if (svars.isTarget01Rescue	== true) and (svars.isTarget02Rescue	== true) then
		Fox.Log( "*****Swith->Set_s0091_oprg4000*****")
		TppRadio.SetOptionalRadio( "Set_s0091_oprg4000" )			

	elseif (svars.isTarget01Rescue	== true) and (svars.isTarget02Rescue	== false) then 						
		if (svars.isTarget02Marked	== false) then					
			Fox.Log( "*****Swith->Set_s0091_oprg2010*****")
			TppRadio.SetOptionalRadio( "Set_s0091_oprg2010" )
			s10091_radio.CheckDDogOptionalRadio()						

		else
			Fox.Log( "*****Swith->Set_s0091_oprg2500*****")
			TppRadio.SetOptionalRadio( "Set_s0091_oprg2500" )		
		end

	elseif (svars.isTarget02Rescue	== true) and (svars.isTarget01Rescue	== false) then					
		if (svars.isTarget01Marked	== false) then					
			Fox.Log( "*****Swith->Set_s0091_oprg2020*****")
			TppRadio.SetOptionalRadio( "Set_s0091_oprg2020" )		
			s10091_radio.CheckDDogOptionalRadio()						

		else
			Fox.Log( "*****Swith->Set_s0091_oprg2500*****")
			TppRadio.SetOptionalRadio( "Set_s0091_oprg2500" )		
		end

	else
		TppRadio.SetOptionalRadio( "Set_s0091_oprg1000" )			
		s10091_radio.CheckDDogOptionalRadio()						
	end
end




this.SwitchIntelRadio = function()
	Fox.Log("#### SwitchIntelRadio ####")
	local No01isPlayed = TppRadio.IsPlayed( "s0091_esrg1020" )

	if (svars.isTarget01Rescue	== false) then 		

		if No01isPlayed and (svars.isTarget01Marked	== false) then			
			Fox.Log( "*****Swith->s0091_esrg1030 + s0091_esrg1050*****")
			TppRadio.ChangeIntelRadio( s10091_radio.intelRadioList02 )

		elseif No01isPlayed and (svars.isTarget01Marked	== true) then		
			Fox.Log( "*****Swith->s0091_esrg1010 + s0091_esrg1050*****")
			TppRadio.ChangeIntelRadio( s10091_radio.intelRadioList03 )

		else						

		end

	else	
		Fox.Log( "*****Swith->Only  s0091_esrg1050*****")
		TppRadio.ChangeIntelRadio( s10091_radio.intelRadioList04 )

	end
end


this.SwitchExecuteUnitRadio = function()
	Fox.Log("#### SwitchExecuteUnitRadio ####")
	if	(svars.isTarget02Unlocked	==	false)	then
		Fox.Log("###***SwampDDisStillTraped_PlayRadio! ###")
		
		if (svars.isTarget01Rescue	== false) and (svars.isTarget02Rescue	== false) then
			Fox.Log("###Radio s0091_rtrg1105 ###")
			
			TppSound.SetPhaseBGM( "bgm_intel_team" )
			TppMusicManager.PostJingleEvent( 'SingleShot', 'sfx_s_bgm_change_situation' )	

			s10091_radio.ExecuteUnitOnMove02()
		
		elseif (svars.isTarget01Rescue	== true) and (svars.isTarget02Rescue	== true) then
			Fox.Log("###AllClear_NoNeedtoRemind_ExecuteUnitRadio ###")
		else
			Fox.Log("###Radio s0091_rtrg1100 ###")
			
			TppSound.SetPhaseBGM( "bgm_intel_team" )
			TppMusicManager.PostJingleEvent( 'SingleShot', 'sfx_s_bgm_change_situation' )	

			s10091_radio.ExecuteUnitOnMove01()
		end

	else
		Fox.Log("###***SwampDDisFree_NoNeedPlayRadio! ###")
	end
end


this.OffExecuteUnitRouteMap = function()
	Fox.Log("#### UIOffExecuteUnitRouteMap ####")

	
	if (svars.isExecuteUnitRescued00	== true) and (svars.isExecuteUnitRescued01	== true) then		
		Fox.Log("****BothRescued_MapUpdated_executeUnit_route_swamp_clear**")
		TppMission.UpdateObjective{
			objectives = { "executeUnit_route_swamp_clear" },
		}
	elseif (svars.isExecuteUnitDead00	== true) and (svars.isExecuteUnitDead01	== true) then		
		Fox.Log("****BothDead_MapUpdated_executeUnit_route_swamp_clear**")
		TppMission.UpdateObjective{
			objectives = { "executeUnit_route_swamp_clear" },
		}
	else
		Fox.Log("### ExecuteUnit one LEFT###")
	end

end


this.OnGetIntelSwamp = function( intelNameHash )
	if svars.isTransceiverFound		== false then

		TppPlayer.GotIntel( intelNameHash )
		local func = function()
			Fox.Log("#####GetIntel_Swamp######")

			
			svars.isTransceiverFound		= true
			this.RestartAllTimerIntelDemo()		
			
			if (svars.isExecuteUnitRouteChanged		== false)	then
				Fox.Log("##CanSaveOnGame###")


				
				this.OnSwampIntelRadio()

				TppMission.UpdateCheckPoint( "CHK_After_IntelDemo" )
			else
				Fox.Log("##CanNotSaveOnGame_as_ExecuteUnitIsOnMoving###")

				
				this.OnSwampIntelRadio()
			end

		end

		
		s10091_demo.GetIntel_Swamp(func)
	end
end


this.OnSwampIntelRadio = function()
	if (svars.isTarget01Marked	== false) and (svars.isTarget01Rescue	== false) then
		Fox.Log("***Radio_s0091_rtrg1070+s0091_rtrg1080***")
		TppMission.UpdateObjective{
			objectives = { "default_area_swamp_Target01"},
		}
		s10091_enemy.RemoveHighInterrogation()	
		svars.isHighInterrogationRemoved00		=	true		

		s10091_radio.GetTransceiver03()
	else
		Fox.Log("***Radio_s0091_rtrg1070***")
		s10091_radio.GetTransceiver01()
	end
end



this.PauseAllTimer = function()
	Fox.Log("#### 4TimerPause(Go_Execute/Go_Execute02/NarrowSearchNow/Target01_Found) ####")
	GkEventTimerManager.SetPaused( "Go_Execute", true )		
	GkEventTimerManager.SetPaused( "Go_Execute02", true )		
	GkEventTimerManager.SetPaused( "NarrowSearchNow", true )		
	GkEventTimerManager.SetPaused( "Target01_Found", true )			
end

this.RestartAllTimer = function()
	Fox.Log("#### 4TimerRestart(Go_Execute/Go_Execute02/NarrowSearchNow/Target01_Found) ####")
	GkEventTimerManager.SetPaused( "Go_Execute", false )
	GkEventTimerManager.SetPaused( "Go_Execute02", false )
	GkEventTimerManager.SetPaused( "NarrowSearchNow", false )
	GkEventTimerManager.SetPaused( "Target01_Found", false )
end


this.PauseAllTimerIntelDemo = function()
	Fox.Log("##** PauseAllTimerIntelDemo####")
	GkEventTimerManager.SetPaused( "Go_Execute", true )		
	GkEventTimerManager.SetPaused( "Go_Execute02", true )		
	GkEventTimerManager.SetPaused( "NarrowSearchNow", true )		
	GkEventTimerManager.SetPaused( "Target01_Found", true )			
	GkEventTimerManager.SetPaused( "Target01_EnemyNotFoundInTime", true )
	GkEventTimerManager.SetPaused( "ExecuteRadio", true )
	GkEventTimerManager.SetPaused( "LocationOnTarget02", true )
	GkEventTimerManager.SetPaused( "CountDown_Target01_Monologue", true )
	GkEventTimerManager.SetPaused( "CountDown_Target02_Monologue", true )
end

this.RestartAllTimerIntelDemo = function()
	Fox.Log("##** RestartAllTimerAfterIntelDemo####")
	GkEventTimerManager.SetPaused( "Go_Execute", false )		
	GkEventTimerManager.SetPaused( "Go_Execute02", false )		
	GkEventTimerManager.SetPaused( "NarrowSearchNow", false )		
	GkEventTimerManager.SetPaused( "Target01_Found", false )			
	GkEventTimerManager.SetPaused( "Target01_EnemyNotFoundInTime", false )
	GkEventTimerManager.SetPaused( "ExecuteRadio", false )
	GkEventTimerManager.SetPaused( "LocationOnTarget02", false )
	GkEventTimerManager.SetPaused( "CountDown_Target01_Monologue", false )
	GkEventTimerManager.SetPaused( "CountDown_Target02_Monologue", false )
end


this.DoesIncludeTarget = function( gameObjectId, targetList )
	Fox.Log("##** Checking_MissionTaskList ####")
	for i, targetName in ipairs( targetList ) do
		if GameObject.GetGameObjectId( targetName ) == gameObjectId then
			return true
		end
	end
	return false

end



this.CountRecoveredMissionBonusTask3 = function( targetList )
	Fox.Log("##** Count_MissionBonusTask3_number of people on the list ####")
	local count = 0	
	for i, targetName in ipairs( targetList ) do
		if TppEnemy.IsRecovered( targetName ) then
			count = count + 1
		end
	end
	return count
end


this.CountRecoveredMissionTask5 = function( targetList )
	Fox.Log("##** Count_MissionTask5_number of people on the list ####")
	local count = 0
	for i, targetName in ipairs( targetList ) do
		if TppEnemy.IsRecovered( targetName ) then
			count = count + 1
		end
	end
	return count
end




function this.UIUpdatesforMissionBonusTask3()
	Fox.Log("***UIUpdatesforMissionBonusTask3")
	if svars.countMissionTask03TargetsNum == 0	then
		Fox.Log("***None_ExecuteUnitRecovered")

	elseif 	 svars.countMissionTask03TargetsNum == 1 	then
		
		
		Fox.Log("***##OnlyOne_ExecuteUnitRecovered")

	elseif	 svars.countMissionTask03TargetsNum == 2 	then
		Fox.Log("***###missionTask_3_bonus_RecoverExecuteUnit_clear")
		TppResult.AcquireSpecialBonus{ first = { isComplete = true,},}	

		TppMission.UpdateObjective{
			objectives = {"missionTask_3_bonus_RecoverExecuteUnit_clear",},
		}

	else
		Fox.Log("svars.isExecuteUnitCount_clear is  ... WRONG VALUE !!")
	end

end


function this.UIUpdatesforMissionTask5()
	Fox.Log("***UIUpdatesforMissionTask5")
	if svars.countMissionTask05TargetsNum == 0	then
		Fox.Log("***None_SearchUnitRecovered")

	elseif 	svars.countMissionTask05TargetsNum == 1	then
	

	elseif	svars.countMissionTask05TargetsNum == 2	then
	

	elseif	svars.countMissionTask05TargetsNum == 3	then
	

	elseif svars.countMissionTask05TargetsNum == 4	then
		Fox.Log("***###missionTask_5_RecoverSearchUnit_clear")
		TppMission.UpdateObjective{
			objectives = {"missionTask_5_RecoverSearchUnit_clear",},
		}
	else
		Fox.Log("svars.isSearchUnitCount_clear is  ... WRONG VALUE !!")
	end

end


function this.OnTargetRescued( s_characterId )
	Fox.Log( "*****TARGETs_Rescued?*****")
	Fox.Log( "s10091_sequence.OnTargetDead( " .. s_characterId .. " )" )

	if s_characterId == GameObject.GetGameObjectId( "TppHostageUnique", TARGET_HOSTAGE.NORTH_FOREST ) and (svars.isTarget01Rescue	== false) then
		svars.isTarget01Rescue		= true		
		svars.isTarget01Marked		= true		

		GkEventTimerManager.Start( "Go_Execute02", GO_EXECUTE02_TIMER )		

		this.SwitchIntelRadio()		

		
		this.UpdateTarget01AnnounceLog()

		GkEventTimerManager.Start( "Target01_EnemyNotFoundInTime", GIVE_UP_SEARCHING_TARGET01 )		

		s10091_enemy.RemoveHighInterrogation()	
		svars.isHighInterrogationRemoved00		=	true		

		
		this.OnTwoHostageRescued()

	elseif s_characterId == GameObject.GetGameObjectId( "TppHostageUnique", TARGET_HOSTAGE.SWAMP ) and (svars.isTarget02Rescue	== false) then
		svars.isTarget02Rescue		= true		
		svars.isTarget02Marked		= true		

		
		this.UpdateTarget02AnnounceLog()		

		svars.isFlagForA		=	true		
		
		this.OnTwoHostageRescued()

	else
		Fox.Log( "*****NotTARGETs*****")
	end


end


function this.OnTargetRideVehicle( s_characterId, s_rideVehicleID )


	
	if Tpp.IsHelicopter(s_rideVehicleID) then
		Fox.Log( "PutInHeli" )
	
		if s_characterId == GameObject.GetGameObjectId( "TppHostageUnique", TARGET_HOSTAGE.NORTH_FOREST ) then
			svars.isTarget01Rescue		= true		
			

			this.SwitchIntelRadio()		

			
			this.UpdateTarget01AnnounceLog()		


			s10091_enemy.RemoveHighInterrogation()	
			svars.isHighInterrogationRemoved00		=	true		

		elseif s_characterId == GameObject.GetGameObjectId( "TppHostageUnique", TARGET_HOSTAGE.SWAMP ) then
			svars.isTarget02Rescue		= true		
			

			
			this.UpdateTarget02AnnounceLog()		

			svars.isFlagForA		=	true		
		end

	
		this.OnTwoHostageRescued()

	else
		Fox.Log( "IsNotHeli" )
		return
	end
end


function this.OnExecuteUnitRescued( s_characterId )
	Fox.Log( "*****Execute_Rescued*****")
	Fox.Log( "s10091_sequence.OnTargetDead( " .. s_characterId .. " )" )

	if s_characterId == GameObject.GetGameObjectId( "TppSoldier2", "sol_ExecuteUnit_0000" ) then
		svars.isExecuteUnitRescued00		= true		


	elseif s_characterId == GameObject.GetGameObjectId( "TppSoldier2", "sol_ExecuteUnit_0001" ) then
		svars.isExecuteUnitRescued01		= true		

	end
end


function this.OnExecuteUnitHeliRescued( self, s_characterId, s_rideVehicleID )
	Fox.Log( "*****Execute_Rescued*****")
	Fox.Log( "s10091_sequence.OnTargetDead( " .. s_characterId .. " )" )

	
	if Tpp.IsHelicopter(s_rideVehicleID) then
		this.OnExecuteUnitRescued( s_characterId )
	end
end






this.Target01CallMonologue = function()
	Fox.Log("#### s10091_Target01_CallMonologue ####" )
	local abductHostageId01 = GameObject.GetGameObjectId( TARGET_HOSTAGE.NORTH_FOREST )
	local abductHostage_monologue_20 = { id="CallMonologue", label = "speech091_carry020", carry = true, }
	local abductHostage_monologue_25 = { id="CallMonologue", label = "speech091_carry025", carry = true, }

	
	if (svars.isThisHappened01 == false) and (svars.isFlagForA == false) and (svars.isTarget02Unlocked == false ) then		
		Fox.Log("****###Target01_Start_to_Monologue_10*****")
		svars.isThisHappened01 = true
		GameObject.SendCommand( abductHostageId01, abductHostage_monologue_20 )

	elseif (svars.isThisHappened01 == false) and (svars.isFlagForA == true) then		
		Fox.Log("****###Target01_Won't_Monologue_20*****")
		svars.isThisHappened01 = true
		GameObject.SendCommand( abductHostageId01, abductHostage_monologue_25 )
	else
		Fox.Log("****###Target01_Won't_Monologue*****")
	end
end



this.Target02CallMonologue = function()
	Fox.Log("#### s10091_Target02_CallMonologue ####" )
	local abductHostageId02 = GameObject.GetGameObjectId( TARGET_HOSTAGE.SWAMP )
	local abductHostage_monologue_30 = { id="CallMonologue", label = "speech091_carry030", carry = true, }

		if svars.isThisHappened02 == false then			
			Fox.Log("****###Target02_Start_to_Monologue*****")
			svars.isThisHappened02 = true
			GameObject.SendCommand( abductHostageId02, abductHostage_monologue_30 )
		else
			Fox.Log("****###Target02_Won't_Monologue*****")
		end
end


this.CheckOnRemoveHighInterrogation = function()
	Fox.Log("#### CheckOnRemoveHighInterrogation ####" )
	if svars.isHighInterrogationRemoved00		==	true then

		s10091_enemy.RemoveHighInterrogation()	
	else
		Fox.Log("###*** NoNeedtoRemoveHighInterrogation ***")
	end

	if svars.isHighInterrogationRemoved01		==	true then

			s10091_enemy.RemoveHighInterrogationSubTask()		
	else
		Fox.Log("###*** NoNeedtoRemoveHighInterrogation ***")
	end

	if svars.isHighInterrogationRemoved06		==	true then
			s10091_enemy.RemoveHighInterrogationSubTask06()		
	else
		Fox.Log("###*** NoNeedtoRemoveHighInterrogation ***")
	end
end




this.CheckWhoIsOnRouteReset = function( routeName, NewrouteName)
	Fox.Log("!!!! s10091_enemy.CheckWhoIsOnRouteReset !!!!"..routeName)

	if routeName == nil then
		return
	end

	local gameObjectId = { type="TppSoldier2" } 
	local command = { id="GetGameObjectIdUsingRoute", route=routeName }
	local soldiers = GameObject.SendCommand( gameObjectId, command )
	Fox.Log( #soldiers )
	for i, soldier in ipairs(soldiers) do
		Fox.Log( string.format("0x%x", soldier) )
		GameObject.SendCommand( soldier, { id = "SetSneakRoute", route = NewrouteName } )			
		
	end

end




























































sequences.Seq_Game_MainGame = {

	Messages = function( self ) 
		return
		StrCode32Table {

			Trap = {
				
				{
					msg = "Enter",
					sender = "Trap_for_HosMoving01",
					func = function ()
						this.OnTarget01Moving01()
					end
				},









				
				
				{
					msg = "Enter",
					sender = "Trap_for_Radio0001",
					func = function ()
						Fox.Log("***Radio_s0091_rtrg1040***")
						s10091_radio.EnterSwampForestFirst()
					end
				},
				
				{
					msg = "Enter",
					sender = "Trap_for_Radio0002",
					func = function ()
						if (svars.isTarget01Marked	== false) and (svars.isTarget01Rescue	== false)  then		
							Fox.Log("***Radio_s0091_rtrg1060***")
							s10091_radio.EnterIntelForestArea()
						end

						s10091_radio.InsertOptionalRadioEnterForest()			
					end
				},
				
				{
					msg = "Exit",
					sender = "Trap_for_Radio0002",
					func = function ()
						s10091_radio.DeleteOptionalRadioEnterForest()		
					end
				},
				
				{
					msg = "Enter",
					sender = "Trap_for_Radio0003",
					func = function ()

						if	svars.isTarget02Unlocked	== false then				
							Fox.Log("***Radio_s0091_rtrg0020***")
							s10091_radio.ArrivedSwamp()
						else
							Fox.Log("***NoNeedfor_Radio_s0091_rtrg0020***")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = "Trap_for_OptionalRadio001",
					func = function ()
						s10091_radio.InsertOptionalRadioEnterSwamp()			
					end
				},
				{
					msg = "Exit",
					sender = "Trap_for_OptionalRadio001",
					func = function ()
						s10091_radio.DeleteOptionalRadioEnterSwamp()		
					end
				},





			},

			
			Radio = {
				{
					msg = "Finish",
					sender = "s0091_rtrg1040",
					func = s10091_radio.AfterEnterSwampForestFirst
				},

			
				{
					msg = "Finish",
					sender = "s0091_esrg1020",
					func = this.SwitchIntelRadio
				},


			

				
				{
					msg = "Finish",
					sender = "s0091_rtrg1070",
				
					func = function()
						Fox.Log("***MapUpdated_Target01***")
						TppMission.UpdateObjective{
							objectives = { "default_area_swamp_Target01"},
						}
						s10091_enemy.RemoveHighInterrogation()	
						svars.isHighInterrogationRemoved00		=	true		
					end
				},

			














				
				{
					msg = "Finish",
					sender = "s0091_rtrg1110",
				
					func = function()
						Fox.Log("***MapUpdated_Target02***")
						TppMission.UpdateObjective{
							objectives = { "executeUnit_give_area_swamp_Target02"},
						}
						svars.isFlagForA		=	true		
					end
				},





















				























			},


			GameObject = {
				
				{
					msg = "Fulton",
					sender = TARGET_HOSTAGE.NORTH_FOREST,
					func = function( gameObjectId )
						
						this.InsertTarget01HudPhotoAfterFulton()
						
					end
				},
				

















				
				{
					msg = "PlacedIntoVehicle",
					sender = { TARGET_HOSTAGE.NORTH_FOREST , TARGET_HOSTAGE.SWAMP },
					func = function( s_characterId, s_rideVehicleID )
						this.OnTargetRideVehicle( s_characterId, s_rideVehicleID )
					end,
				},

				nil
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		TppTelop.StartCastTelop()
		
		TppScriptBlock.LoadDemoBlock("intelDemo")

		
		TppMission.SetHelicopterDoorOpenTime( HELI_START_TIME )


		TppMission.UpdateObjective{
			objectives = {
				"default_photo_Target02",
				"default_photo_Target01",
				"default_no_photo_CFABody",
				"subGoal_Two_Targets_Left",
				
				"missionTask_1_RecoverTarget01",
				"missionTask_2_RecoverTarget02",
				
				"missionTask_3_bonus_RecoverExecuteUnit",
				"missionTask_4_bonus_RecoverHiddenHostage",
				
				"missionTask_5_RecoverSearchUnit",
				"missionTask_6_RecoverTruckDriver",
			},
		}

		this.SetTargetStaffMissionPhoto()

		
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = { "s0091_rtrg1010", "s0091_rtrg1020", "s0091_rtrg1030"},
			},
			objectives = { "default_area_swampNorthForest", "default_area_swamp" },
			options = { isMissionStart = true },
		}



		if ( TppMission.IsStartFromHelispace() == true ) then	
			Fox.Log("### Player Start Game From Helicopter ###")
			this.SetUpTimer01Heli()
			this.SetUpTimer02Heli()
			this.SetUpTimer05Heli()
			this.SetUpTimer06Heli()

		elseif ( TppMission.IsStartFromFreePlay() == true ) then
			Fox.Log("### Player Start Game From FreePlay ###")
			this.SetUpTimer01()
			this.SetUpTimer02()
			this.SetUpTimer05()
			this.SetUpTimer06()

		else
			Fox.Log("###*** Player Start Game From Unknown Way ###")
		end


		if TppSequence.GetContinueCount()	> 0 then
			
			Fox.Log("###Contiune_in_MainGame_Sequence!!! ###")
			this.StopAllTimerContinue()		

			
			
			if (svars.isTarget01Marked	== false) then
				Fox.Log("###Target01 Should not be Identified ###")
				
			end
			if (svars.isTarget02Marked	== false) then
				Fox.Log("###SwampTarget02 Should not be Identified ###")
				
			end
			


			
			if (svars.isTarget01Rescue	== false) and (svars.isTarget02Rescue	== false) then
				Fox.Log("###Radio s0091_rtrg1150 ###")
				s10091_radio.Continue01()

				this.SetUpTimer01()		
				this.SetUpTimer02()		
				this.SetUpTimer05()		
				this.SetUpTimer06()		

			
			elseif (svars.isTarget02Marked	== false) and (svars.isTarget02Rescue	== false)
					and (svars.isTarget01Rescue	== true) then
				Fox.Log("###Radio s0091_rtrg2040 ###")

				s10091_radio.Continue02()

				this.SetUpTimer03()		
				this.SetUpTimer04()		

			
			elseif (svars.isTarget01Marked	== false) and (svars.isTarget01Rescue	== false)
					and (svars.isTarget02Rescue	== true)then
				Fox.Log("###Radio s0091_rtrg3020 ###")

				s10091_radio.Continue03()

				this.SetUpTimer02()		
				this.SetUpTimer03()		

			
			
			elseif (svars.isTarget02Marked	== true) and (svars.isTarget02Rescue	== false) and (svars.isTarget01Rescue	== true) then
				Fox.Log("###Radio s0091_rtrg2050 ###")
				s10091_radio.Continue04()

				this.SetUpTimer03()		
				this.SetUpTimer04()		

			
			elseif (svars.isTarget01Marked	== true) and (svars.isTarget01Rescue	== false) and (svars.isTarget02Rescue	== true) then
				Fox.Log("###Radio s0091_rtrg2050 ###")
				s10091_radio.Continue04()

				this.SetUpTimer02()		
				this.SetUpTimer03()		

			else
				Fox.Log("###WrongContineConditions!!! ###")
			end

		else
			Fox.Log("###Normal_MissionStart!!! ###")

		end

		
		s10091_enemy.SetAllEnemyOnVehicle()

		
		s10091_enemy.DisableOccasionalChat()

		
		this.OnSwithOptionalRadio()

		
		this.CheckOnRemoveHighInterrogation()

		
		this.UIUpdatesforMissionBonusTask3()
		this.UIUpdatesforMissionTask5()































	end,

	OnLeave = function ()
		

	end,

}





sequences.Seq_Game_SwampTarget = {

	Messages = function( self ) 
		return
		StrCode32Table {

			
			Trap = {
				
				
				{
					msg = "Enter",
					sender = "Trap_for_Radio0003",
					func = function ()
						if	svars.isTarget02Unlocked	== false then			
							Fox.Log("***Radio_s0091_rtrg0020***")
							s10091_radio.ArrivedSwamp()
						else
							Fox.Log("***NoNeedfor_Radio_s0091_rtrg0020***")
						end
					end
				},
				
				{
					msg = "Enter",
					sender = "Trap_for_OptionalRadio001",
					func = function ()
						s10091_radio.InsertOptionalRadioEnterSwamp()			
					end
				},
				{
					msg = "Exit",
					sender = "Trap_for_OptionalRadio001",
					func = function ()
						s10091_radio.DeleteOptionalRadioEnterSwamp()		
					end
				},
			},

			
			Radio = {

			
				{
					msg = "Finish",
					sender = "s0091_esrg1020",
					func = this.SwitchIntelRadio
				},
			













				
				{
					msg = "Finish",
					sender = "s0091_rtrg1110",
				
					func = function()
						Fox.Log("***MapUpdated_Target02***")
						TppMission.UpdateObjective{
							objectives = { "executeUnit_give_area_swamp_Target02"},
						}
						svars.isFlagForA		=	true		
					end
				},











			},


			GameObject = {
				
				
				{
					msg = "Fulton",
					sender = TARGET_HOSTAGE.SWAMP,
					func = function( gameObjectId )
						
					end
				},
				
				{
					msg = "PlacedIntoVehicle",
					sender =  TARGET_HOSTAGE.SWAMP,
					func = function( s_characterId, s_rideVehicleID )
						this.OnTargetRideVehicle( s_characterId, s_rideVehicleID )
					end,
				},
				nil
			},
			nil
		}
	end,

	OnEnter = function()
		

		
		
		TppScriptBlock.LoadDemoBlock("intelDemo")

		
		this.SetTargetStaffMissionPhoto()

		if TppSequence.GetContinueCount()	> 0 then
			Fox.Log("###Contiune_in_SwampTarget_Sequence!!! ###")
			this.StopAllTimerContinue()		

			
			if (svars.isTarget01Rescue	== false) and (svars.isTarget02Rescue	== false) then
				Fox.Log("###Radio s0091_rtrg1150 ###")
				s10091_radio.Continue01()

				this.SetUpTimer01()		
				this.SetUpTimer02()		
				this.SetUpTimer05()		
				this.SetUpTimer06()		

			
			elseif (svars.isTarget02Marked	== false) and (svars.isTarget02Rescue	== false)
					and (svars.isTarget01Rescue	== true) then
				Fox.Log("###Radio s0091_rtrg2040 ###")

				s10091_radio.Continue02()

				this.SetUpTimer03()		
				this.SetUpTimer04()		

			
			elseif (svars.isTarget01Marked	== false) and (svars.isTarget01Rescue	== false)
					and (svars.isTarget02Rescue	== true)then
				Fox.Log("###Radio s0091_rtrg3020 ###")

				s10091_radio.Continue03()

				this.SetUpTimer02()		
				this.SetUpTimer03()		

			
			
			elseif (svars.isTarget02Marked	== true) and (svars.isTarget02Rescue	== false) and (svars.isTarget01Rescue	== true) then
				Fox.Log("###Radio s0091_rtrg2050 ###")
				s10091_radio.Continue04()

				this.SetUpTimer03()		
				this.SetUpTimer04()		

			
			elseif (svars.isTarget01Marked	== true) and (svars.isTarget01Rescue	== false) and (svars.isTarget02Rescue	== true) then
				Fox.Log("###Radio s0091_rtrg2050 ###")
				s10091_radio.Continue04()

				this.SetUpTimer02()		
				this.SetUpTimer03()		

			else
				Fox.Log("###WrongContineConditions!!! ###")
			end

		else
			Fox.Log("###Normal_MissionStart!!! ###")

		end

		
		s10091_enemy.SetAllEnemyOnVehicle()
		
		s10091_enemy.DisableOccasionalChat()

		
		this.OnSwithOptionalRadio()

		
		this.CheckOnRemoveHighInterrogation()

		
		this.UIUpdatesforMissionBonusTask3()
		this.UIUpdatesforMissionTask5()

			
		if svars.isSearchUnit01OnMoving == false then	
			Fox.Log("***NoCarsOnMoving->1stCar_Travel")
			
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0002"), { id = "StartTravel", travelPlan="Travel_First_Car" } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0003"), { id = "StartTravel", travelPlan="Travel_First_Car" } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0004"), { id = "StartTravel", travelPlan="Travel_First_Car" } )

			

			
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_Truck_Driver"), { id = "StartTravel", travelPlan="Travel_Truck" } )

			svars.isSearchUnit01OnMoving = true	
		else
				Fox.Log("***1stCar_isAlreadyOnMoving")
		end

		
		if svars.isSearchUnit02OnMoving == false then	
			Fox.Log("***NoCarsOnMoving->2ndSurroundCar_Travel")
			this.SetUpTimer05()
			svars.isSearchUnit02OnMoving = true	
		else
			Fox.Log("***2ndSurroundCar_isAlreadyOnMoving")
		end

	end,

	OnLeave = function ()
		

	end,

}








sequences.Seq_Game_ForestTarget = {

	Messages = function( self ) 
		return
		StrCode32Table {

			
			Trap = {
				
				{
					msg = "Enter",
					sender = "Trap_for_HosMoving01",
					func = function ()
						this.OnTarget01Moving01()
					end
				},









				
				
				{
					msg = "Enter",
					sender = "Trap_for_Radio0001",
					func = function ()
						Fox.Log("***Radio_s0091_rtrg1040***")
						s10091_radio.EnterSwampForestFirst()
					end
				},
				
				{
					msg = "Enter",
					sender = "Trap_for_Radio0002",
					func = function ()
						if (svars.isTarget01Marked	== false) and (svars.isTarget01Rescue	== false)  then		
							Fox.Log("***Radio_s0091_rtrg1060***")
							s10091_radio.EnterIntelForestArea()
						end

						s10091_radio.InsertOptionalRadioEnterForest()			
					end
				},
				
				{
					msg = "Exit",
					sender = "Trap_for_Radio0002",
					func = function ()
						s10091_radio.DeleteOptionalRadioEnterForest()		
					end
				},
			},

			
			Radio = {
				{
					msg = "Finish",
					sender = "s0091_rtrg1040",
					func = s10091_radio.AfterEnterSwampForestFirst
				},

			
				{
					msg = "Finish",
					sender = "s0091_esrg1020",
					func = this.SwitchIntelRadio
				},


			

				
				{
					msg = "Finish",
					sender = "s0091_rtrg1070",
				
					func = function()
						Fox.Log("***MapUpdated_Target01***")
						TppMission.UpdateObjective{
							objectives = { "default_area_swamp_Target01"},
						}
						s10091_enemy.RemoveHighInterrogation()	
						svars.isHighInterrogationRemoved00		=	true		
					end
				},











			},


			GameObject = {
				
				{
					msg = "Fulton",
					sender = TARGET_HOSTAGE.NORTH_FOREST,
					func = function( gameObjectId )
						
						this.InsertTarget01HudPhotoAfterFulton()
						
					end
				},
				
				{
					msg = "PlacedIntoVehicle",
					sender = TARGET_HOSTAGE.NORTH_FOREST,
					func = function( s_characterId, s_rideVehicleID )
						this.OnTargetRideVehicle( s_characterId, s_rideVehicleID )
					end,
				},
				nil
			},
			nil
		}
	end,

	OnEnter = function()
		

	
		
		TppScriptBlock.LoadDemoBlock("intelDemo")

		
		this.SetTargetStaffMissionPhoto()

		if TppSequence.GetContinueCount()	> 0 then
			Fox.Log("###Contiune_in_Seq_Game_ForestTarget!!! ###")
			this.StopAllTimerContinue()		

			
			if (svars.isTarget01Rescue	== false) and (svars.isTarget02Rescue	== false) then
				Fox.Log("###Radio s0091_rtrg1150 ###")
				s10091_radio.Continue01()

				this.SetUpTimer01()		
				this.SetUpTimer02()		
				this.SetUpTimer05()		
				this.SetUpTimer06()		

			
			elseif (svars.isTarget02Marked	== false) and (svars.isTarget02Rescue	== false)
					and (svars.isTarget01Rescue	== true) then
				Fox.Log("###Radio s0091_rtrg2040 ###")

				s10091_radio.Continue02()

				this.SetUpTimer03()		
				this.SetUpTimer04()		

			
			elseif (svars.isTarget01Marked	== false) and (svars.isTarget01Rescue	== false)
					and (svars.isTarget02Rescue	== true)then
				Fox.Log("###Radio s0091_rtrg3020 ###")

				s10091_radio.Continue03()

				this.SetUpTimer02()		
				this.SetUpTimer03()		

			
			
			elseif (svars.isTarget02Marked	== true) and (svars.isTarget02Rescue	== false) and (svars.isTarget01Rescue	== true) then
				Fox.Log("###Radio s0091_rtrg2050 ###")
				s10091_radio.Continue04()

				this.SetUpTimer03()		
				this.SetUpTimer04()		

			
			elseif (svars.isTarget01Marked	== true) and (svars.isTarget01Rescue	== false) and (svars.isTarget02Rescue	== true) then
				Fox.Log("###Radio s0091_rtrg2050 ###")
				s10091_radio.Continue04()

				this.SetUpTimer02()		
				this.SetUpTimer03()		

			else
				Fox.Log("###WrongContineConditions!!! ###")
			end

		else
			Fox.Log("###Normal_MissionStart!!! ###")

		end

		
		s10091_enemy.SetAllEnemyOnVehicle()


		
		s10091_enemy.DisableOccasionalChat()

		
		this.OnSwithOptionalRadio()

		
		this.CheckOnRemoveHighInterrogation()

		
		this.UIUpdatesforMissionBonusTask3()
		this.UIUpdatesforMissionTask5()

			
		if svars.isSearchUnit01OnMoving == false then	
			Fox.Log("***NoCarsOnMoving->1stCar_Travel")
			
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0002"), { id = "StartTravel", travelPlan="Travel_First_Car" } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0003"), { id = "StartTravel", travelPlan="Travel_First_Car" } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_SwampWest_0004"), { id = "StartTravel", travelPlan="Travel_First_Car" } )

			

			
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_Truck_Driver"), { id = "StartTravel", travelPlan="Travel_Truck" } )

			svars.isSearchUnit01OnMoving = true	
		else
				Fox.Log("***1stCar_isAlreadyOnMoving")
		end

		
		if svars.isSearchUnit02OnMoving == false then	
			Fox.Log("***NoCarsOnMoving->2ndSurroundCar_Travel")
			this.SetUpTimer05()
			svars.isSearchUnit02OnMoving = true	
		else
			Fox.Log("***2ndSurroundCar_isAlreadyOnMoving")
		end

	end,

	OnLeave = function ()
		

	end,

}






sequences.Seq_Game_Escape = {

	OnEnter = function()
		Fox.Log("######## Seq_Game_Escape.OnEnter ########")
		
		this.SetTargetStaffMissionPhoto()

		
		TppMission.UpdateObjective{
			objectives = { "subGoal_Escape" },
		}

		if TppSequence.GetContinueCount()	> 0 then
			Fox.Log("##ContinueOn: Seq_Game_Escape.OnEnter ########")
			TppRadio.Play("f1000_rtrg1396",{ delayTime = "short"})		
		else
			local is_s0091_rtrg4010_Played = TppRadio.IsPlayed( "s0091_rtrg4010" )		
			if (is_s0091_rtrg4010_Played	==	false)	then
				Fox.Log("##**s0091_rtrg4010 hasnot been played Yet")
				s10091_radio.AllTargetsRescued()
			else
				Fox.Log("##**s0091_rtrg4010 has Already been played, No more radio play!")
			end
		end
		TppMission.CanMissionClear()
		this.OnSwithOptionalRadio()			

		
		s10091_enemy.SetAllWolfBackNotice()
	end,
}




return this