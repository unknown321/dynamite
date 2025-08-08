local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}


local HINT_RADIO_TIMER = 60*5			
local HINT_RADIO_TIMER_HELI = 340						

local FINAL_REINFORCE = 60*6			
local FINAL_REINFORCE_HELI = 400			





	HELI_START_TIME			= 17


this.FILM_CASE_PATTERN = {
	INIT = -1,
	A = 0,
	B = 1,
	C = 2,
	[0] = "A",
	[1] = "B",
	[2] = "C",
}


this.FILM_CASE_LOCATOR_NAME = {
	[this.FILM_CASE_PATTERN.A] = "itm_s10156_A",
	[this.FILM_CASE_PATTERN.B] = "itm_s10156_B",
	[this.FILM_CASE_PATTERN.C] = "itm_s10156_C",
}


this.FILM_CASE_RADIOLOCATOR_NAME = {
	[this.FILM_CASE_PATTERN.A] = "rds_s10156_A",
	[this.FILM_CASE_PATTERN.B] = "rds_s10156_B",
	[this.FILM_CASE_PATTERN.C] = "rds_s10156_C",
}


this.FILM_CASE_PATTERN_PHOTO = {
	[this.FILM_CASE_PATTERN.A] = "default_photo_A_Pattern",
	[this.FILM_CASE_PATTERN.B] = "default_photo_B_Pattern",
	[this.FILM_CASE_PATTERN.C] = "default_photo_C_Pattern",
}


this.FILM_CASE_PATTERN_PHOTO_CLEARVERSION = {
	[this.FILM_CASE_PATTERN.A] = "default_photo_A_ClearVersion",
	[this.FILM_CASE_PATTERN.B] = "default_photo_B_ClearVersion",
	[this.FILM_CASE_PATTERN.C] = "default_photo_C_ClearVersion",
}

	
this.FILM_CASE_PATTERN_AREAMARKER_CLEARVERSION = {
	[this.FILM_CASE_PATTERN.A] = "AreaMarker_A_ClearVersion",
	[this.FILM_CASE_PATTERN.B] = "AreaMarker_B_ClearVersion",
	[this.FILM_CASE_PATTERN.C] = "AreaMarker_C_ClearVersion",
}


this.FILM_CASE_FOUND_ROUTE = {
	[this.FILM_CASE_PATTERN.A] = "rts_Case_Found_A",
	[this.FILM_CASE_PATTERN.B] = "rts_Case_Found_B",
	[this.FILM_CASE_PATTERN.C] = "rts_Case_Found_C",
}


this.FILM_CASE_DESTROYED_ROUTE = {
	[this.FILM_CASE_PATTERN.A] = "rts_Case_Destroyed_A",
	[this.FILM_CASE_PATTERN.B] = "rts_Case_Destroyed_B",
	[this.FILM_CASE_PATTERN.C] = "rts_Case_Destroyed_C",
}


this.missionTask_4_TARGET_LIST = {
	"hos_s10156_0000",
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 1 },
	},
	second = {
		missionTask = { taskNo = 2 },
	}
}




this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PLACED_LOCATOR_COUNT = 20







function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		

		
		"Seq_Game_MainGame",
		"Seq_Game_Escape",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end






this.saveVarsList = {
	isCaseFound = false,		
	filmCasePattern = this.FILM_CASE_PATTERN.INIT,

	isReinforcement01Start	=	false,	
	isReinforcement02Start	=	false,	
	isReinforcement03Start	=	false,	
	isReinforcement04Start	=	false,	

	
	isReinforcementArrived = false,		
	isruinsConquered = false,			
	
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
	"CHK_MissionStart",		
	"CHK_GetItem",				
	nil
}



this.baseList = {
	"fieldEast",
	"ruinsNorth",
	"villageEast",
	"ruins",
	nil
}






this.missionObjectiveDefine = {
	
	default_mission_intel = {
		gameObjectName = "Intel",
		visibleArea = 3, randomRange = 0, viewType = "all",
		setNew = true,
		mapRadioName = "s0156_mprg0010",		
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
	},

	default_viewPoint = {
		gameObjectName = "10156_marker_viewpoint", visibleArea = 1, randomRange = 0, viewType = "map_only_icon", setNew = true, announceLog = "updateMap", langId = "marker_info_vantage_point",
	},

	Arrived_viewPoint = {
	},

	
	AreaMarker_A_ClearVersion = {
		gameObjectName = "AreaMarker_ClearVersion_A",
		visibleArea = 0, randomRange = 0, viewType = "all",
		setNew = true,
		setImportant = true,
		langId = "marker_info_mission_target",
		announceLog = "updateMap",
	},
	AreaMarker_B_ClearVersion = {
		gameObjectName = "AreaMarker_ClearVersion_B",
		visibleArea = 0, randomRange = 0, viewType = "all",
		setNew = true,
		setImportant = true,
		langId = "marker_info_mission_target",
		announceLog = "updateMap",
	},
	AreaMarker_C_ClearVersion = {
		gameObjectName = "AreaMarker_ClearVersion_C",
		visibleArea = 0, randomRange = 0, viewType = "all",
		setNew = true,
		setImportant = true,
		langId = "marker_info_mission_target",
		announceLog = "updateMap",
	},

	
	default_photo_A_Pattern = {
		photoId	= 10,
		photoRadioName = "s0156_mirg1010",
	},
	default_photo_A_ClearVersion = {
		photoId	= 40,
		photoRadioName = "s0156_mirg1020",
		announceLog = "updateMissionInfo_AddDocument",
	},

	default_photo_B_Pattern = {
		photoId = 20,
		photoRadioName = "s0156_mirg1010",
	},

	default_photo_B_ClearVersion = {
		photoId	= 50,
		photoRadioName = "s0156_mirg1020",
		announceLog = "updateMissionInfo_AddDocument",
	},

	default_photo_C_Pattern = {
		photoId	= 30,
		photoRadioName = "s0156_mirg1010",
	},

	default_photo_C_ClearVersion = {
		photoId	= 60,
		photoRadioName = "s0156_mirg1020",
		announceLog = "updateMissionInfo_AddDocument",
	},

	
	subGoal_Find_Target = {
		subGoalId= 0,
	},
	subGoal_Escape = {	
		subGoalId= 1,
	},
	
	interrogation_on_HiddenHostage = {
		gameObjectName = "hos_s10156_0000",
		goalType = "none",	
		viewType = "map_and_world_only_icon", setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",		
	},
	
	interrogation_NoNeed_HiddenHostage = {
	},


	missionTask_1_RecoverTarget = {	
		missionTask = { taskNo=0, isNew=true, isComplete=false },
	},
	missionTask_1_RecoverTarget_clear = {
		missionTask = { taskNo=0, isNew=true, isComplete=true },
	},


	missionTask_2_bonus_ruinsConquered = {	
		missionTask = { taskNo=1, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_2_bonus_ruinsConquered_clear = {	
		missionTask = { taskNo=1, isNew=true },
	},

	missionTask_3_bonus_RecoverTarget_beforeReinforcementArrived = {
		missionTask = { taskNo=2, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_3_bonus_RecoverTarget_beforeReinforcementArrived_clear = {	
		missionTask = { taskNo=2, isNew=true },
	},



	missionTask_4_rescueHostage = {	
		missionTask = { taskNo=3, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_4_rescueHostage_clear = {	
		missionTask = { taskNo=3, isNew=true, isComplete=true },
	},


	missionTask_5_vultureCollected = {	
		missionTask = { taskNo=4, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_5_vultureCollected_clear = {
		missionTask = { taskNo=4, isNew=true, isComplete=true },
	},


	announce_RecoverFilmCase = {
		announceLog = "recoveredFilmCase",		
	},
	announce_RecoverTarget = {
		announceLog = "recoverTarget",		
	},
	
	announce_Complete = {
		announceLog = "achieveAllObjectives",
	}
}

this.missionObjectiveEnum = Tpp.Enum{
	"default_mission_intel",
	"default_viewPoint",
	"Arrived_viewPoint",

	"default_photo_A_Pattern",
	"default_photo_A_ClearVersion",

	"default_photo_B_Pattern",
	"default_photo_B_ClearVersion",

	"default_photo_C_Pattern",
	"default_photo_C_ClearVersion",

	"AreaMarker_A_ClearVersion",
	"AreaMarker_B_ClearVersion",
	"AreaMarker_C_ClearVersion",

	"subGoal_Find_Target",
	"subGoal_Escape",

	"interrogation_on_HiddenHostage",
	"interrogation_NoNeed_HiddenHostage",

	
	"missionTask_1_RecoverTarget",
	"missionTask_1_RecoverTarget_clear",
	"missionTask_2_bonus_ruinsConquered",
	"missionTask_2_bonus_ruinsConquered_clear",
	"missionTask_3_bonus_RecoverTarget_beforeReinforcementArrived",
	"missionTask_3_bonus_RecoverTarget_beforeReinforcementArrived_clear",
	"missionTask_4_rescueHostage",
	"missionTask_4_rescueHostage_clear",
	"missionTask_5_vultureCollected",
	"missionTask_5_vultureCollected_clear",

	
	"announce_RecoverFilmCase",
	"announce_RecoverTarget",
	"announce_Complete",
}

this.missionObjectiveTree = {

			Arrived_viewPoint ={
				default_viewPoint ={},
			},

			AreaMarker_A_ClearVersion = {
				default_mission_intel = {},
			},

			AreaMarker_B_ClearVersion = {
				default_mission_intel = {},
			},

			AreaMarker_C_ClearVersion = {
				default_mission_intel = {},
			},

			default_photo_A_ClearVersion = {
				default_photo_A_Pattern = {},
			},

			default_photo_B_ClearVersion = {
				default_photo_B_Pattern = {},
			},

			default_photo_C_ClearVersion = {
				default_photo_C_Pattern = {},
			},

			subGoal_Escape = {
				subGoal_Find_Target = {},
			},

			
			missionTask_1_RecoverTarget_clear = {
				missionTask_1_RecoverTarget ={},
				AreaMarker_A_ClearVersion = {},		
				AreaMarker_B_ClearVersion = {},
				AreaMarker_C_ClearVersion ={},
				default_mission_intel = {},
			},
			missionTask_2_bonus_ruinsConquered_clear = {
				missionTask_2_bonus_ruinsConquered ={},
			},
			missionTask_3_bonus_RecoverTarget_beforeReinforcementArrived_clear = {
				missionTask_3_bonus_RecoverTarget_beforeReinforcementArrived ={},
			},
			missionTask_4_rescueHostage_clear = {
				missionTask_4_rescueHostage ={},
			},
			missionTask_5_vultureCollected_clear = {
				missionTask_5_vultureCollected ={},
			},

			interrogation_NoNeed_HiddenHostage = {
						interrogation_on_HiddenHostage = {},
			},

			announce_Complete = {},
}



this.missionStartPosition = {

	
	orderBoxList = {
		"box_s10156_00",
	
	},

	
	helicopterRouteList = {
		"lz_drp_ruins_S0000|rt_drp_ruins_S_0000",			
		"lz_drp_village_E0000|rt_drp_village_E_0000",			
	},

}









function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppEagle" )

	
	

	TppMission.RegisterMissionSystemCallback(
	{
		OnEstablishMissionClear = function( missionClearType )
			Fox.Log("****Mission clear. On estableish mission clear")
			
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
		end,
		
		OnRecovered = function( gameObjectId )
			Fox.Log("##** OnRecovered_is_coming ####")

			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_4_TARGET_LIST ) then
				TppMission.UpdateObjective{
					objectives = {"missionTask_4_rescueHostage_clear",},
				}
				s10156_enemy.RemoveHighInterrogation01()		
			end
		end,

		OnGameOver = this.OnGameOver,
	}
	)

end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	if TppMission.IsMissionStart() then
		this.DecideFilmCasePattern()
		this.EnableFilmCase()
	end
end





this.OnEndMissionPrepareSequence = function ()

	
	if TppMission.IsMissionStart() then
		Fox.Log("*** OnEndMissionPrepareSequence + MissionStart ***")
		this.Reset10156Gimmick()	

	end
end


function this.OnGameOver( gameOverType )
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
			
		TppPlayer.SetTargetDeadCamera{ gameObjectId = mvars.deadNPCId }		
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end
end




function this.Reset10156Gimmick()
	Fox.Log("*** ResetAll10156Gimmick ***")
	
	Gimmick.ResetGimmickData ( "afgh_pott003_gim_i0000|TppSharedGimmick_afgh_pott003", "/Assets/tpp/level/mission2/story/s10156/s10156_item.fox2" )
	Gimmick.ResetGimmickData ( "mafr_lamp001_gim_i0000|TppSharedGimmick_mafr_lamp001", "/Assets/tpp/level/mission2/story/s10156/s10156_item.fox2" )
	
	Gimmick.ResetGimmickData ( "hw00_gim_i0000|TppPermanentGimmick_hw00_main0_def", "/Assets/tpp/level/mission2/story/s10156/s10156_item.fox2" )

	
	Gimmick.ResetGimmickData ( "afgh_book001_vrtn003_gim_i0000|TppSharedGimmick_afgh_book001_vrtn003", "/Assets/tpp/level/mission2/story/s10156/s10156_animal.fox2" )
	Gimmick.ResetGimmickData ( "afgh_cupp001_gim_i0000|TppSharedGimmick_afgh_cupp001", "/Assets/tpp/level/mission2/story/s10156/s10156_animal.fox2" )
	Gimmick.ResetGimmickData ( "afgh_dish006_vrtn002_gim_i0000|TppSharedGimmick_afgh_dish006_vrtn002", "/Assets/tpp/level/mission2/story/s10156/s10156_animal.fox2" )
	Gimmick.ResetGimmickData ( "afgh_pott005_gim_i0000|TppSharedGimmick_afgh_pott005", "/Assets/tpp/level/mission2/story/s10156/s10156_animal.fox2" )


end




function this.DecideFilmCasePattern()
	if svars.filmCasePattern == this.FILM_CASE_PATTERN.INIT then
		local rand = math.random(0,2)
		Fox.Log("DecideFilmCasePattern : new pattern " .. this.FILM_CASE_PATTERN[rand] )
		svars.filmCasePattern = rand
	else
		Fox.Log("DecideFilmCasePattern : continue pattern " .. this.FILM_CASE_PATTERN[svars.filmCasePattern] )
	end
end




function this.EnableFilmCase()
	if svars.filmCasePattern == this.FILM_CASE_PATTERN.INIT then
		Fox.Error("Film case pattern is not decided yet.")
		return
	end

	for i = this.FILM_CASE_PATTERN.A, this.FILM_CASE_PATTERN.C do
		local filmCaseLocatorName = this.FILM_CASE_LOCATOR_NAME[i]
		local filmCaseRadioLocatorName = this.FILM_CASE_RADIOLOCATOR_NAME[i]
		if svars.filmCasePattern == i then
			Fox.Log("filmCaseLocatorName = " .. tostring(filmCaseLocatorName) .. ", enable = true" )
			TppPickable.SetEnableByLocatorName( filmCaseLocatorName, true )
			TppRadioCommand.SetEnableEspionageRadioTarget{ name = { filmCaseRadioLocatorName }, enable = true }
			TppPickable.SetDisablePhysicalMove( filmCaseLocatorName, isDisable )	

		else
			Fox.Log("filmCaseLocatorName = " .. tostring(filmCaseLocatorName) .. ", enable = false" )
			TppPickable.SetEnableByLocatorName( filmCaseLocatorName, false )
			TppRadioCommand.SetEnableEspionageRadioTarget{ name = { filmCaseRadioLocatorName} , enable = false }
		end
	end
end




function this.GetCurrentFilmCaseLocatorName()
	if svars.filmCasePattern == this.FILM_CASE_PATTERN.INIT then
		Fox.Error("Film case patterb is not decided yet.")
		return
	end

	return this.FILM_CASE_LOCATOR_NAME[svars.filmCasePattern]
end




function this.GetCurrentFilmCasePatternPhotoName()
	if svars.filmCasePattern == this.FILM_CASE_PATTERN.INIT then
		Fox.Error("Film case patterb is not decided yet.")
		return
	end

	return this.FILM_CASE_PATTERN_PHOTO[svars.filmCasePattern]
end





function this.GetCurrentFilmCasePatternClearVersionPhotoName()
	if svars.filmCasePattern == this.FILM_CASE_PATTERN.INIT then
		Fox.Error("Film case patterb is not decided yet.")
		return
	end

	return this.FILM_CASE_PATTERN_PHOTO_CLEARVERSION[svars.filmCasePattern]
end




function this.GetCurrentFilmCasePatternClearVersionAreaMarker()
	if svars.filmCasePattern == this.FILM_CASE_PATTERN.INIT then
		Fox.Error("Film case patterb is not decided yet.")
		return
	end

	return this.FILM_CASE_PATTERN_AREAMARKER_CLEARVERSION[svars.filmCasePattern]
end




function this.GetCurrentFilmCasePatternDestroyRouteName()
	if svars.filmCasePattern == this.FILM_CASE_PATTERN.INIT then
		Fox.Error("Film case patterb is not decided yet.")
		return
	end

	return this.FILM_CASE_DESTROYED_ROUTE[svars.filmCasePattern]
end





function this.GetCurrentFilmCasePatternFoundRouteName()
	if svars.filmCasePattern == this.FILM_CASE_PATTERN.INIT then
		Fox.Error("Film case patterb is not decided yet.")
		return
	end

	return this.FILM_CASE_FOUND_ROUTE[svars.filmCasePattern]
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






function this.Messages()
	return
	StrCode32Table {

		GameObject = {

			
			{
				msg = "CommandPostAnnihilated",
				sender = "afgh_Ruins_cp",
				func = function ()
					Fox.Log("***ruinsConquered")
					if svars.isruinsConquered == false then
						svars.isruinsConquered		= true
						TppMission.UpdateObjective{
							objectives = { "missionTask_2_bonus_ruinsConquered_clear" },	
						}
						TppResult.AcquireSpecialBonus{ first = { isComplete = true,},}	
					else
						Fox.Log("***Not_ruinsConquered")
					end
				end
			},

			{
				
				msg = "Fulton",
				func = function( gameObjectId )
					local animalType = GameObject.GetTypeIndex( gameObjectId )
					if animalType == TppGameObject.GAME_OBJECT_TYPE_EAGLE then
						Fox.Log("***vultureCollected_clear")
						TppMission.UpdateObjective{
							objectives = { "missionTask_5_vultureCollected_clear" },	
						}
					end
				end
			},

			
			{
				msg = "ChangePhase", sender = "afgh_Ruins_cp",
				func = function (gameObjectId, phaseName)
					Fox.Log("###afgh_Ruins_cp PHASE CHANGE!!!!")
					if (phaseName >= TppGameObject.PHASE_ALERT) then		
						Fox.Log("###afgh_Ruins_cp PHASE:Alert")
						this.SendRevengeHeli()
					else
						Fox.Log("###afgh_Ruins_cp NOT:Alert")
					end
				end
			},
			
			{
				msg = "RoutePoint2",
				func = function (gameObjectId, routeId ,routeNode, messageId )

					if messageId == StrCode32("JoinRuins01") then
						Fox.Log("****Message_JoinRuins01*****")
						
					

					elseif messageId == StrCode32("ReinforcementArrived") then
						Fox.Log("****Message_ReinforcementArrived*****")
						if svars.isReinforcementArrived == false then
							svars.isReinforcementArrived		= true 
						end

				
				
				

					end
				end
			},
		},

		Trap = {
			










		},
		Timer = {
				
				{
				msg = "Finish", sender = "1st_Car",
				func = function()
					Fox.Log("TimerFinished_First_Car!!!")
					if svars.isReinforcement01Start == false then	
					
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_Reinforce_0001"), { id = "StartTravel", travelPlan="Travel_First_Car" } )
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_Reinforce_0002"), { id = "StartTravel", travelPlan="Travel_First_Car" } )
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_Reinforce_0003"), { id = "StartTravel", travelPlan="Travel_First_Car" } )

						svars.isReinforcement01Start = true	
					else
						Fox.Log("Reinforcement01OnMoving!!!")
					end
				end
				},
				
				{
				msg = "Finish", sender = "2nd_Car",
				func = function()
					Fox.Log("TimerFinished_2nd_Car!!!!")
					if svars.isReinforcement02Start == false then	
						
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_fieldEast_0001"), { id = "StartTravel", travelPlan="Travel_Second_Car" } )
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_fieldEast_0002"), { id = "StartTravel", travelPlan="Travel_Second_Car" } )
						svars.isReinforcement02Start = true	
					else
						Fox.Log("Reinforcement02OnMoving!!!")
					end
				end
				},
				
				{
				msg = "Finish", sender = "Final_Reinforce",
				func = function()
					Fox.Log("TimerFinished_Final_Reinforce!!!!")
					if svars.isReinforcement03Start == false then	

						
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_villageEast_0002"), { id = "StartTravel", travelPlan="Travel_Final_Reinforce" } )
						GameObject.SendCommand( GameObject.GetGameObjectId( "sol_villageEast_0003"), { id = "StartTravel", travelPlan="Travel_Final_Reinforce" } )
						svars.isReinforcement03Start = true	
					else
						Fox.Log("ReinforcementFinalOnMoving!!!")
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




this.DisablePhysicalMoveOnLocators = function()
	TppPickable.SetDisablePhysicalMove( "itm_s10156_A", isDisable )
	TppPickable.SetDisablePhysicalMove( "itm_s10156_B", isDisable )
	TppPickable.SetDisablePhysicalMove( "itm_s10156_C", isDisable )
end

this.UnSetReinforce01Route = function()
	Fox.Log( "****UnSetReinforce01Routee*****")

	TppEnemy.UnsetSneakRoute( "sol_Reinforce_0001" )
	TppEnemy.UnsetSneakRoute( "sol_Reinforce_0002" )
	TppEnemy.UnsetSneakRoute( "sol_Reinforce_0003" )

	TppEnemy.UnsetCautionRoute( "sol_Reinforce_0001" )
	TppEnemy.UnsetCautionRoute( "sol_Reinforce_0002" )
	TppEnemy.UnsetCautionRoute( "sol_Reinforce_0003" )

end


this.GetFilmCase = function(player,id)
	Fox.Log("****Got item. check id this is " .. tostring(id) .. ". FilmCase is ".. tostring(TppEquip.EQP_IT_FilmCase) )
	if id == TppEquip.EQP_IT_FilmCase then
		Fox.Log("***Got_FilmCase")
		return true
	else
		Fox.Log("Not_got_FilmCase")
		return false
	end
end



this.SetUpTimer01 = function()
	if GkEventTimerManager.IsTimerActive( "1st_Car" ) then
		
		GkEventTimerManager.Stop( "1st_Car" )
		GkEventTimerManager.Start( "1st_Car", 15 )
	else
		
		GkEventTimerManager.Start( "1st_Car", 15 )
	end
end

this.SetUpTimer02 = function()
	if GkEventTimerManager.IsTimerActive( "2nd_Car" ) then
		
		GkEventTimerManager.Stop( "2nd_Car" )
		GkEventTimerManager.Start( "2nd_Car", 70 )
	else
		
		GkEventTimerManager.Start( "2nd_Car", 70 )
	end
end

this.SetUpTimer03 = function()
	if GkEventTimerManager.IsTimerActive( "Final_Reinforce" ) then
		
		GkEventTimerManager.Stop( "Final_Reinforce" )
		GkEventTimerManager.Start( "Final_Reinforce", FINAL_REINFORCE )
	else
		
		GkEventTimerManager.Start( "Final_Reinforce", FINAL_REINFORCE )
	end
end

this.SetUpTimer04 = function()
	if GkEventTimerManager.IsTimerActive( "Loop_Timer" ) then
		
		GkEventTimerManager.Stop( "Loop_Timer" )
		GkEventTimerManager.Start( "Loop_Timer", 400 )
	else
		
		GkEventTimerManager.Start( "Loop_Timer", 400 )
	end
end

this.SetUpTimer03Continue = function()
	if GkEventTimerManager.IsTimerActive( "Final_Reinforce" ) then
		
		GkEventTimerManager.Stop( "Final_Reinforce" )
		GkEventTimerManager.Start( "Final_Reinforce", 100 )
	else
		
		GkEventTimerManager.Start( "Final_Reinforce", 100 )
	end
end

this.SetUpTimer04Continue  = function()
	if GkEventTimerManager.IsTimerActive( "Loop_Timer" ) then
		
		GkEventTimerManager.Stop( "Loop_Timer" )
		GkEventTimerManager.Start( "Loop_Timer", 120 )
	else
		
		GkEventTimerManager.Start( "Loop_Timer", 120 )
	end
end

this.SetUpTimerHintRadio = function()
	if GkEventTimerManager.IsTimerActive( "HintRadio" ) then
		
		GkEventTimerManager.Stop( "HintRadio" )
		GkEventTimerManager.Start( "HintRadio", HINT_RADIO_TIMER )
	else
		
		GkEventTimerManager.Start( "HintRadio", HINT_RADIO_TIMER )
	end
end


this.SetUpTimer01HeliStart = function()
	if GkEventTimerManager.IsTimerActive( "1st_Car" ) then
		
		GkEventTimerManager.Stop( "1st_Car" )
		GkEventTimerManager.Start( "1st_Car", 55 )
	else
		
		GkEventTimerManager.Start( "1st_Car", 55 )
	end
end

this.SetUpTimer02HeliStart = function()
	if GkEventTimerManager.IsTimerActive( "2nd_Car" ) then
		
		GkEventTimerManager.Stop( "2nd_Car" )
		GkEventTimerManager.Start( "2nd_Car", 110 )
	else
		
		GkEventTimerManager.Start( "2nd_Car", 110 )
	end
end

this.SetUpTimer03HeliStart = function()
	if GkEventTimerManager.IsTimerActive( "Final_Reinforce" ) then
		
		GkEventTimerManager.Stop( "Final_Reinforce" )
		GkEventTimerManager.Start( "Final_Reinforce", FINAL_REINFORCE_HELI )
	else
		
		GkEventTimerManager.Start( "Final_Reinforce", FINAL_REINFORCE_HELI )
	end
end

this.SetUpTimer04HeliStart = function()
	if GkEventTimerManager.IsTimerActive( "Loop_Timer" ) then
		
		GkEventTimerManager.Stop( "Loop_Timer" )
		GkEventTimerManager.Start( "Loop_Timer", 440 )
	else
		
		GkEventTimerManager.Start( "Loop_Timer", 440 )
	end
end

this.SetUpTimerHintRadioHeliStart = function()
	if GkEventTimerManager.IsTimerActive( "HintRadio" ) then
		
		GkEventTimerManager.Stop( "HintRadio" )
		GkEventTimerManager.Start( "HintRadio", HINT_RADIO_TIMER_HELI )
	else
		
		GkEventTimerManager.Start( "HintRadio", HINT_RADIO_TIMER_HELI )
	end
end



this.SetUpAllTimerStart = function()
	Fox.Log("### SetUpAllTimerStart ###")

	if svars.isReinforcement01Start == false then	
		this.SetUpTimer01()
	else
		Fox.Log("### Reinforcement01AlreadyOnMoving ###")
	end

	if svars.isReinforcement02Start == false then	
		this.SetUpTimer02()
	else
		Fox.Log("### Reinforcement02AlreadyOnMoving ###")
	end

	if svars.isReinforcement03Start == false then	
		this.SetUpTimer03()
	else
		Fox.Log("### Reinforcement03AlreadyOnMoving ###")
	end

	this.SetUpTimer04()
	this.SetUpTimerHintRadio()

end


this.SetUpAllTimerHeliStart = function()
	Fox.Log("### SetUpAllTimerHeliStart ###")
	if svars.isReinforcement01Start == false then	
		this.SetUpTimer01HeliStart()
	else
		Fox.Log("### Reinforcement01AlreadyOnMoving ###")
	end

	if svars.isReinforcement02Start == false then	
		this.SetUpTimer02HeliStart()
	else
		Fox.Log("### Reinforcement02AlreadyOnMoving ###")
	end

	if svars.isReinforcement03Start == false then	
		this.SetUpTimer03HeliStart()
	else
		Fox.Log("### Reinforcement03AlreadyOnMoving ###")
	end

	this.SetUpTimer04HeliStart()
	this.SetUpTimerHintRadioHeliStart()

end


this.SendRevengeHeli = function()
	Fox.Log("***###CheckOnRevengeHeli************")
	local gameObjectId = { type="TppCommandPost2", index = GameObject.GetGameObjectId("afgh_Ruins_cp") }
	local command = { id = "RequestForceReinforce" }
	GameObject.SendCommand( gameObjectId, command )
end





















sequences.Seq_Game_MainGame = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {

				
				
				{
					msg = "RoutePoint2",
					func = function (gameObjectId, routeId ,routeNode, messageId )

						if messageId == StrCode32("MissionFail") then
							
								Fox.Log("***********TapeCheckFlag************")
								if svars.isCaseFound == false then
									Fox.Log("***********MissionFail************")
									mvars.deadNPCId = gameObjectId,		
									TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.S10156_FILMCASE_DESTROYED )	

								elseif svars.isCaseFound == true then
									Fox.Log("***********TapeNotFound************")
									GameObject.SendCommand( gameObjectId, { id = "SetSneakRoute", route = "" } )
									GameObject.SendCommand( gameObjectId, { id = "SetCautionRoute", route = "" } )
								end

						elseif messageId == StrCode32("TapeFound") then
								Fox.Log("***********TapeFoundFlagCheck************")
								if svars.isCaseFound == false then
									Fox.Log("***********TapeisNotFoundbyPlayerYet_GoDestroy************")

									
									s10156_enemy.CPRadioTargetDiscovered( gameObjectId )

								else
									Fox.Log("***********TapeHasBeenFoundbyPlayer************")
									GameObject.SendCommand( gameObjectId, { id = "SetSneakRoute", route = "" } )
									GameObject.SendCommand( gameObjectId, { id = "SetCautionRoute", route = "" } )
								end

						end
					end
				},

			
				{
					msg = "RadioEnd",
					func = function( gameObjectId, cpGameObjectId, speechLabel, isSuccess )
						Fox.Log( "*** ConversationEnd ***")
						if speechLabel == StrCode32( "CPRSP030" ) then
							if svars.isCaseFound == false then
								Fox.Log("***********GoDestroy************")

								
								local destroyrouteName = this.GetCurrentFilmCasePatternDestroyRouteName()
								GameObject.SendCommand( gameObjectId, { id = "SetSneakRoute", route = destroyrouteName } )
								GameObject.SendCommand( gameObjectId, { id = "SetCautionRoute", route = destroyrouteName } )

							else
								Fox.Log("***********WHAAAATT!!!_TapeHasBeenFoundbyPlayer************")
								GameObject.SendCommand( gameObjectId, { id = "SetSneakRoute", route = "" } )
								GameObject.SendCommand( gameObjectId, { id = "SetCautionRoute", route = "" } )

							end

						else
							Fox.Log("***********NotSpeicalCP************")
						end
					end
				},

				
				{
						msg = "Unlocked", sender = "hos_s10156_0000",
						func = function()
							Fox.Log("###UnlockedSubTaskTarget###")
							s10156_enemy.RemoveHighInterrogation01()		
							TppMission.UpdateObjective{
								objectives = {"interrogation_NoNeed_HiddenHostage",},
							}
						end
				},
				nil
			},

			
			Player = {
				{
					msg = "OnPickUpWeapon",
					func = function (player,id)
					Fox.Log("***Player_Got_FilmCase!!!!!!!!!!!")
						if this.GetFilmCase(player,id) then
							svars.isCaseFound = true

							TppMission.UpdateObjective{
								objectives = { "announce_RecoverFilmCase", "announce_RecoverTarget", "announce_Complete", "Arrived_viewPoint" },
							}
							TppMission.UpdateObjective{
								objectives = { "missionTask_1_RecoverTarget_clear" },	
							}
							






							if svars.isReinforcementArrived == false then
								TppMission.UpdateObjective{
									objectives = { "missionTask_3_bonus_RecoverTarget_beforeReinforcementArrived_clear" },	
								}
								TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}	

							end

							TppSequence.SetNextSequence( "Seq_Game_Escape" )
						else
							Fox.Log("***Not_FilmCase")
						end

					end
				},
			nil
			},

			Radio = {
				{
					msg = "Finish",
					sender = "s0156_esrg0010",
					func = function()
						Fox.Log("**SwitchTo_s10156_radio.intelRadioList02!!!!")
						TppRadio.ChangeIntelRadio( s10156_radio.intelRadioList02 )
					end
				},
				{
					msg = "Finish",
					sender = "s0156_esrg0030",
					func = function()
						Fox.Log("**intelRadioOnFilmCaseFinished_updateObjective!!!!")

						local finalLocation = this.GetCurrentFilmCasePatternClearVersionAreaMarker()
						TppMission.UpdateObjective{
							objectives = { finalLocation },
						}
					end
				},
				{
					msg = "Finish",
					sender = "s0156_rtrg0040",
					func = function()
						Fox.Log("**UpdateViewPointLocation!!!!")
						TppMission.UpdateObjective{
							objectives = { "default_viewPoint" },
						}
					end
				},

			},
			Trap = {
				{
					msg = "Enter",
					sender = "trap_viewPoint",
					func = function ()
						Fox.Log("***Enter_Trap_for_ViewPoint")
						s10156_radio.ViewPointRadio()
					end
				},
				{
					msg = "Enter",
					sender = "trap_viewPointArrived",
					func = function ()
						Fox.Log("***Clear_the_viewPointMarker")

					end
				}

			},
			
			Timer = {
				{
					msg = "Finish", sender = "Loop_Timer",
					func = function()
						Fox.Log("Loop_Timer!!!!")
						
						local soldierName = s10156_enemy.CheckAliveEnemy("afgh_Ruins_cp")

						
					
						local foundrouteName = this.GetCurrentFilmCasePatternFoundRouteName()

						if soldierName then
							
							s10156_enemy.CheckRouteAndCancel( foundrouteName )

							
							TppEnemy.SetSneakRoute( soldierName, foundrouteName )
							TppEnemy.SetCautionRoute( soldierName, foundrouteName )
						end

						
						GkEventTimerManager.Start( "Loop_Timer", 180 )
					end
				},

				{
					msg = "Finish", sender = "HintRadio",
					func = function()
						Fox.Log("***UpdateClearVersionHintPhoto!!!!")

						svars.isThisHappened01	= true		

						local is_s0156_esrg0030_Played = TppRadio.IsPlayed( "s0156_esrg0030" )

						if	(is_s0156_esrg0030_Played	==	false)	then
							Fox.Log("***s0156_esrg0030notPlayed_UpdatePhoto!!!!")
							
							TppRadio.SetOptionalRadio( "Set_s0156_oprg0020" )

							local clearversionphotoName = this.GetCurrentFilmCasePatternClearVersionPhotoName()
						
							TppMission.UpdateObjective{
								objectives = { clearversionphotoName },
								radio = {
									radioGroups = { "s0156_rtrg0030"},
								},
							}

						else
							Fox.Log("***s0156_esrg0030HasAlreadyPlayed!!!!")
						end
					end
				},
				nil
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(1235.5691, 331.89337, 1474.544))
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		TppTelop.StartCastTelop()
		
		TppSound.SetPhaseBGM( "bgm_cave_level2" )

		local photoName = this.GetCurrentFilmCasePatternPhotoName()

		TppMission.UpdateObjective{
			objectives = { "subGoal_Find_Target",
						photoName,
						"missionTask_1_RecoverTarget",
						"missionTask_2_bonus_ruinsConquered",
						"missionTask_3_bonus_RecoverTarget_beforeReinforcementArrived",
						"missionTask_4_rescueHostage",
						"missionTask_5_vultureCollected",
			},
		}
		TppMission.UpdateObjective{
			objectives = { "default_mission_intel" },
			options = { isMissionStart = true },
			radio = {
				
				radioGroups = { "s0156_rtrg0010"},
			},
		}

		
		s10156_enemy.DisableOccasionalChat()

		
		s10156_enemy.SetAllEnemyOnVehicle()


		if ( TppMission.IsStartFromHelispace() == true ) then	
			Fox.Log("### Player Start Game From Helicopter ###")
			this.SetUpAllTimerHeliStart()

		elseif ( TppMission.IsStartFromFreePlay() == true ) then
			Fox.Log("### Player Start Game From FreePlay ###")
			this.SetUpAllTimerStart()
		else
			Fox.Log("##!! ERROR!!!!Player Start Game From Unknown Way ###")
		end

		
		TppRadio.SetOptionalRadio( "Set_s0156_oprg0010" )

		
		TppMission.SetHelicopterDoorOpenTime( HELI_START_TIME )

		this.DisablePhysicalMoveOnLocators()		

		if TppSequence.GetContinueCount()	> 0 then
			Fox.Log("###***In_Continue_Condition!!! ###")
			
			if	svars.isThisHappened01	== true	then			
				Fox.Log("### ClearPhoto Hint Might haven been updated ###")
				TppRadio.Play( { "s0156_rtrg0030", }, {isEnqueue = true } )
				this.SetUpTimer03Continue()
				this.SetUpTimer04Continue()
				GkEventTimerManager.Stop( "HintRadio" )		
				TppRadio.SetOptionalRadio( "Set_s0156_oprg0020" )

				
				local clearversionphotoName = this.GetCurrentFilmCasePatternClearVersionPhotoName()
				TppMission.UpdateObjective{
					objectives = { clearversionphotoName },
				}
			else
				Fox.Log("### No ClearPhoto updated Yet###")
				TppRadio.Play( "s0156_rtrg0020" )
				this.SetUpAllTimerStart()

			end
		else
			Fox.Log("###***New_MissionStart ###")

		end

	end,

	OnLeave = function ()
		
		
	end,

}

sequences.Seq_Game_Escape = {

	OnEnter = function()
		TppMission.UpdateObjective{
			objectives = { "subGoal_Escape" },	
		}
		s10156_radio.CanMissionClearRadio()
		
		TppRadio.SetOptionalRadio( "Set_s0156_oprg0040" )

		GkEventTimerManager.Stop( "Loop_Timer" )
		TppMission.CanMissionClear()

	end,
}



return this
