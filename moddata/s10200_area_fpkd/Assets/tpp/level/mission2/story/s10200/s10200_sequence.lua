local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}






local TARGET_HOSTAGE_NAME 	= "hos_hillNorth_0000"
local TARGET_BONUS_HOSTAGE 	= "hos_hillNorth_0001"
local TARGET_VIP_NAME 		= "sol_hillNorth_0000"


local RETURN_UNIT01_MEM_01 	= "sol_hillNorth_0004"
local RETURN_UNIT01_MEM_02 	= "sol_hillNorth_0005"
local RETURN_UNIT01_MEM_03 	= "sol_hillNorth_0006"
local RETURN_UNIT01_MEM_04 	= "sol_hillNorth_0007"


local RETURN_UNIT02_MEM_01 	= "sol_hillNorth_0008"
local RETURN_UNIT02_MEM_02 	= "sol_hillNorth_0009"
local RETURN_UNIT02_MEM_03 	= "sol_hillNorth_0010"
local RETURN_UNIT02_MEM_04 	= "sol_hillNorth_0011"



this.TARGET_STATUS = Tpp.Enum{
	"NONE",
	"FOUND",
	"CAPTURED",
}






this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true

this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true








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
	isFoundHostage		= false,		
	isFoundLeader		= false,		
	isBonusHostageFound = false,		
	isFoundBoth			= false,		
	isCaptureLeader 	= false,		
	isCaptureHostage 	= false,		
	isKilledBonusHostage = false,		

	isUnit01Started 	= false,		
	isUnit01Returned	= false,		
	
	isUnit02Started 	= false,		
	isUnit02Returned	= false,		

	isRadioPlayed01 	= false,		
	isRadioPlayed02		= false,		
	isPlayerInTown		= false,		
	isReturnedUnitNo	= 0,			

	isStatusLeader		= this.TARGET_STATUS.NONE,			
	isStatusHostage		= this.TARGET_STATUS.NONE,			

	CollectiveCount		= 0,			
	FultonCHildCount	= 0,			

	
	sub_Flag_0000 = false,
	sub_Flag_0001 = false,
	sub_Flag_0002 = false,
	sub_Flag_0003 = false,
	sub_Flag_0004 = false,
	sub_Flag_0005 = false,
	sub_Flag_0006 = false,
	sub_Flag_0007 = false,
	sub_Flag_0008 = false,
	sub_Flag_0009 = false,

	sub_Flag_0010 = 0, 
	sub_Flag_0011 = 0, 
	sub_Flag_0012 = 0,
	sub_Flag_0013 = 0,
	sub_Flag_0014 = 0,
	sub_Flag_0015 = 0,
	sub_Flag_0016 = 0,
	sub_Flag_0017 = 0,
	sub_Flag_0018 = 0,
	sub_Flag_0019 = 0,
}




this.checkPointList = {
	"CHK_MissionStart",			
	nil
}

this.baseList = {
	"hillNorth",
	nil
}


this.counterList = {

	UNIT01_START_COUNT = 300,					
	UNIT02_START_COUNT = 270,					
	UNIT01_START_COUNT_ENTER_TRAP = 20,			
	UNIT02_START_COUNT_ENTER_TRAP = 1,			

}







this.missionObjectiveDefine = {

	default_missionObjective_Hostage = {
		gameObjectName = "10200_marker_HostageArea", mapRadioName = "s0200_mprg0020", visibleArea = 3, randomRange = 0, viewType = "all", setNew = false, announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},

	default_viewPoint = {
		gameObjectName = "10200_marker_viewpoint", mapRadioName = "f1000_mprg0180", visibleArea = 2, randomRange = 0, viewType = "map_only_icon", setNew = true, announceLog = "updateMap", langId = "marker_info_vantage_point",
	},

	default_itemArea = {
		gameObjectName = "10200_marker_item", visibleArea = 1, randomRange = 0, viewType = "map_only_icon", setNew = false, announceLog = "updateMap", langId = "marker_area_medicinal_plant",
	},

	default_Target_Leader = {
		gameObjectName = TARGET_VIP_NAME, visibleArea = 0, randomRange = 0, viewType = "map_and_world_only_icon", setImportant = true, setNew = false, announceLog = "updateMap",langId = "marker_info_mission_target",
	},

	default_Target_Hostage = {
		gameObjectName = TARGET_HOSTAGE_NAME, visibleArea = 0, randomRange = 0, viewType = "map_and_world_only_icon", setImportant = true, setNew = false, announceLog = "updateMap",langId = "marker_info_mission_target",
	},

	
	default_photo_target_10 = {
		photoId			= 10,	addFirst = true, photoRadioName = "s0200_mirg0030",
	},

	
	default_photo_target_20 = {
		photoId			= 20,	addFirst = true, photoRadioName = "s0200_mirg0020",
	},
	

	
	default_subGoal_CommitMission = {
		subGoalId= 0,
    },

	default_subGoal_Escape = {
		subGoalId= 3,
    },

    
	MissionTask_CaptureSubComand = { 
		missionTask = { taskNo=2, isNew=true, isComplete=false },
	},
	ClearTask_CaptureSubComand = { 
		missionTask = { taskNo=2, isComplete=true },
	},	

	MissionTask_CaptureChildLeader = { 
		missionTask = { taskNo=3, isNew=true, isComplete=false },
	},
   	ClearTask_CaptureChildLeader = { 
		missionTask = { taskNo=3, isComplete=true },
	},

	MissionTask_CaptureBonusHostage = { 
		missionTask = { taskNo=4, isNew=true, isFirstHide=true, isComplete=false },
	},
   	ClearTask_CaptureBonusHostage = { 
		missionTask = { taskNo=4, isComplete=true },
	},

	MissionTask_CaptureAllChildren = {
		missionTask = { taskNo=5, isNew=true, isFirstHide=true, isComplete=false },
	},
   	ClearTask_CaptureAllChildren = {
		missionTask = { taskNo=5, isComplete=true },
	},

	MissionTask_CaptureTargetWithVehicle = {
		missionTask = { taskNo=6, isNew=true, isFirstHide=true, isComplete=false },
	},
   	ClearTask_CaptureTargetWithVehicle = {
		missionTask = { taskNo=6, isComplete=true },
	},

	MissionTask_CollectFlower = {
		missionTask = { taskNo=7, isNew=true, isFirstHide=true, isComplete=false },
	},
   	ClearTask_CollectFlower = {
		missionTask = { taskNo=7, isComplete=true },
	},

	
	targetCpSetting = {
		targetBgmCp = "mafr_hillNorth_ob",
	},

	
	announce_rescue_ChildLeader = {
		announceLog = "recoverTarget",
	},

	announce_rescue_SubComand = {
		announceLog = "recoverTarget",
	},

    hud_photo_hostage = {
		hudPhotoId = 10 
    },

    hud_photo_cihld = {
		hudPhotoId = 20 
    },

}


this.specialBonus = {
    first = {
            missionTask = { taskNo = 4 },
    },
    second = {
            missionTask = { taskNo = 5 },
    }
}





this.missionObjectiveTree = {

	default_viewPoint = {},

	default_Target_Leader = {},

	default_Target_Hostage = {
		default_missionObjective_Hostage = {},
	},

	default_itemArea = {},

	
	default_photo_target_10 = {
	},

	default_photo_target_20 = {
	},

	
	default_subGoal_Escape = {
		default_subGoal_CommitMission = {},
	},

	
	ClearTask_CaptureSubComand = {
			MissionTask_CaptureSubComand = {},
	},	

   	ClearTask_CaptureChildLeader = {
		MissionTask_CaptureChildLeader = {},
	},

   	ClearTask_CaptureBonusHostage = {
		MissionTask_CaptureBonusHostage = {},
	},

   	ClearTask_CaptureAllChildren = {
		MissionTask_CaptureAllChildren = {},
	},

   	ClearTask_CaptureTargetWithVehicle = {
		MissionTask_CaptureTargetWithVehicle = {},
	},

   	ClearTask_CollectFlower = {
		MissionTask_CollectFlower = {},
	},

	targetCpSetting = {
	},

	
	announce_rescue_ChildLeader = {},
	announce_rescue_SubComand = {},

    hud_photo_hostage = {},
    hud_photo_cihld = {},

}




this.missionObjectiveEnum = Tpp.Enum{
	"default_missionObjective_Hostage",
	"default_viewPoint",
	"default_Target_Leader",
	"default_Target_Hostage",
	"default_itemArea",
	"default_photo_target_10",
	"default_photo_target_20",


	"default_subGoal_CommitMission",
	"default_subGoal_Escape",


	"MissionTask_CaptureSubComand",
	"ClearTask_CaptureSubComand",

	"MissionTask_CaptureChildLeader",
	"ClearTask_CaptureChildLeader",

	"MissionTask_CaptureBonusHostage",
	"ClearTask_CaptureBonusHostage",

	"MissionTask_CaptureAllChildren",
	"ClearTask_CaptureAllChildren",

	"MissionTask_CaptureTargetWithVehicle",
	"ClearTask_CaptureTargetWithVehicle",

	"MissionTask_CollectFlower",
	"ClearTask_CollectFlower",

	"targetCpSetting",

	"announce_rescue_ChildLeader",
	"announce_rescue_SubComand",
	"hud_photo_hostage",
	"hud_photo_cihld",
}


this.missionStartPosition = {
	
	orderBoxList = {
		"box_s10200_00",
	},
	
	helicopterRouteList = {
		"rt_drp_hillNorth_N_0000",
	},
}






function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	this.RegisterCallback()
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppEagle" ) 
	TppMarker.SetUpSearchTarget{ 
		{
		 	gameObjectName = TARGET_VIP_NAME, 
			gameObjectType = "TppSoldier2", 
			messageName = TARGET_VIP_NAME, 
			skeletonName = "SKL_004_HEAD", 
			objectives = "default_Target_Leader", 
			func = function()
				this.FoundLeader()
				TppMission.UpdateObjective{
					objectives = { "hud_photo_cihld"},
				}
			end
		},

		{
		 	gameObjectName = TARGET_HOSTAGE_NAME, 
			gameObjectType = "TppHostage2", 
			messageName = TARGET_HOSTAGE_NAME, 
			skeletonName = "SKL_004_HEAD", 
			objectives = "default_Target_Hostage", 
			func = function()
				this.FoundHostage()
				TppMission.UpdateObjective{
					objectives = { "hud_photo_hostage"},
				}
			end
		},
	}


end


function this.OnEstablishMissionClear( missionClearType )
	Fox.Log("*** " .. tostring(missionClearType) .. " OnEstablishMissionClear ***")
	
	s10200_radio.OnGameCleared()
	
	
    if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then

		
		local NULL_ID = GameObject.NULL_ID
		local command = { id = "GetVehicleGameObjectId" }
		local vehicleGameObjectId_1 = GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_HOSTAGE_NAME ), command )
		local vehicleGameObjectId_2 = GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_VIP_NAME ), command )
		if vehicleGameObjectId_1 ~= NULL_ID or vehicleGameObjectId_2 ~= NULL_ID then
			if vehicleGameObjectId_1 == vehicleGameObjectId_2 then
				Fox.Log(" ### TARGETS RIDE ON SAME VEHICLE ### ")
				TppMission.UpdateObjective{
					objectives = {
						"ClearTask_CaptureTargetWithVehicle" ,
					},
				}
			else
				Fox.Log(" ### TARGETS NOT RIDE ON SAME VEHICLE ### ")
			end
		else
			Fox.Log(" ### SOME TARGET NOT RIDE ON VEHICLE ### ")
		end
		
        TppPlayer.PlayMissionClearCamera()
        TppMission.MissionGameEnd{
			loadStartOnResult = true,
			
			fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,
			
			delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
        }
    else
		TppMission.MissionGameEnd{ loadStartOnResult = true }	
    end
	
end


function this.OnGameOver( gameOverType )
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
		
		TppPlayer.SetTargetDeadCamera{ gameObjectName = mvars.deadNPCId }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.PLAYER_KILL_CHILD_SOLDIER ) then
		TppPlayer.SetPlayerKilledChildCamera()
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end
end

function this.OnRecovered(gameObjectId)
	Fox.Log("### OnRecovered_is_coming ###")

	
	if Tpp.IsSoldier( gameObjectId ) then
		svars.FultonCHildCount = svars.FultonCHildCount + 1
		if svars.FultonCHildCount == 12 then
			TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}
		end
	else
		Fox.Log(" ### Not Child Soldier ### ")
	end

	
	if ( gameObjectId == GameObject.GetGameObjectId( TARGET_VIP_NAME )) then
		if( svars.isCaptureLeader == false ) then
			svars.isCaptureLeader = true
			svars.isStatusLeader = this.TARGET_STATUS.CAPTURED
			TppMission.UpdateObjective{
				objectives = {
					"announce_rescue_ChildLeader" ,
				},
			}
			svars.sub_Flag_0011 = svars.sub_Flag_0011 + 1
			TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.sub_Flag_0011, 2 )
			TppMission.UpdateObjective{
				objectives = {
					"ClearTask_CaptureChildLeader" ,
				},
			}
		end
	
	elseif ( gameObjectId == GameObject.GetGameObjectId( TARGET_HOSTAGE_NAME )) then
		if( svars.isCaptureHostage == false ) then
			svars.isCaptureHostage = true
			svars.isStatusHostage = this.TARGET_STATUS.CAPTURED
			TppMission.UpdateObjective{
				objectives = {
					"announce_rescue_SubComand" ,
				},
			}
			svars.sub_Flag_0011 = svars.sub_Flag_0011 + 1
			TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.sub_Flag_0011, 2 )
			TppMission.UpdateObjective{
				objectives = {
					"ClearTask_CaptureSubComand" ,
				},
			}
		end
	
	elseif ( gameObjectId == GameObject.GetGameObjectId( TARGET_BONUS_HOSTAGE )) then
		s10200_radio.BonusHostageCaptured()
		TppResult.AcquireSpecialBonus{ first = { isComplete = true,},}
	else
		Fox.Log(" ### Recovered : Unknown Charactor ### ")
	end

end

function this.OnSetMissionFinalScore()
	Fox.Log("### OnSetMissionFinalScore ###")
end


function this.RegisterCallback()

	Fox.Log("*** s10200_sequence.RegisterCallback() ***")

	local systemCallbackTable ={
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnGameOver = this.OnGameOver,
		OnRecovered = this.OnRecovered,
		OnSetMissionFinalScore = this.OnSetMissionFinalScore,
		CheckMissionClearFunction = function() return TppEnemy.CheckAllTargetClear() end,
		nil,
	}
	
	
	TppMission.RegisterMissionSystemCallback(systemCallbackTable)

end




function this.FoundHostage()
	s10200_radio.ConfirmedTargetHostage()
	s10200_enemy.DisableHighInterrogation_LocateHostage()
	svars.isStatusHostage = this.TARGET_STATUS.FOUND
end



function this.FoundLeader()
	s10200_radio.ConfirmedTargetLeader()
	s10200_enemy.DisableHighInterrogation_LocateLeader()
	svars.isStatusLeader = this.TARGET_STATUS.FOUND
end



function this.ContinueMission()
		if ( svars.isStatusHostage == this.TARGET_STATUS.NONE and svars.isStatusLeader == this.TARGET_STATUS.NONE ) then 
			if ( TppSequence.GetContinueCount() == 0 ) then
				TppMission.UpdateObjective{
					objectives = {
						"default_photo_target_10",
						"default_photo_target_20",
						"default_subGoal_CommitMission",
						"MissionTask_CaptureSubComand",
						"MissionTask_CaptureChildLeader",
						"MissionTask_CaptureBonusHostage",
						"MissionTask_CaptureAllChildren",
						"MissionTask_CaptureTargetWithVehicle",
						"MissionTask_CollectFlower",
					 },
				}

				TppMission.UpdateObjective{
					radio = {
					
						radioGroups = { "s0200_rtrg0010" },	
					},
					
					objectives = {
						"default_missionObjective_Hostage" ,
					},
				}
			else
				TppMission.UpdateObjective{
					objectives = {
						"default_photo_target_10",
						"default_photo_target_20",
						"default_subGoal_CommitMission",
						"MissionTask_CaptureSubComand",
						"MissionTask_CaptureChildLeader",
						"MissionTask_CaptureBonusHostage",
						"MissionTask_CaptureAllChildren",
						"MissionTask_CaptureTargetWithVehicle",
						"MissionTask_CollectFlower",
					 },
				}

				TppMission.UpdateObjective{
					radio = {
					
						radioGroups = { "s0200_oprg0020" },	
					},
					
					objectives = {
						"default_missionObjective_Hostage" ,
					},
				}
			end
		else
			s10200_radio.ContinueRadio ()
		end
end


function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
end


function this.LeaderCaptured()
	Fox.Log("LeaderCaptured")
	if( svars.isCaptureLeader == false ) then
		svars.isCaptureLeader = true
		svars.isStatusLeader = this.TARGET_STATUS.CAPTURED
			TppMission.UpdateObjective{
				objectives = {
					"announce_rescue_ChildLeader" ,
				},
			}
			svars.sub_Flag_0011 = svars.sub_Flag_0011 + 1
			TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.sub_Flag_0011, 2 )
			TppMission.UpdateObjective{
				objectives = {
					"ClearTask_CaptureChildLeader",
				},
			}
		
		if( svars.isCaptureHostage == true ) then
			TppSequence.SetNextSequence( "Seq_Game_Escape" )
		
		elseif( svars.isCaptureHostage == false ) then
			s10200_radio.LeaderCaptured()
			
			if(	TppMarker.GetSearchTargetIsFound( TARGET_HOSTAGE_NAME ) == true ) then
				TppRadio.SetOptionalRadio( "Set_s0200_oprg0020" )
			else
			
				TppRadio.SetOptionalRadio( "Set_s0200_oprg0060" )
			end
		end
	end
end


function this.HostageCaptured()
	Fox.Log("HostageCaptured")
	if( svars.isCaptureHostage == false ) then
		svars.isCaptureHostage = true
		svars.isStatusHostage = this.TARGET_STATUS.CAPTURED
		TppMission.UpdateObjective{
			objectives = {
				"announce_rescue_SubComand" ,
			},
		}
		svars.sub_Flag_0011 = svars.sub_Flag_0011 + 1
		TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.sub_Flag_0011, 2 )
		TppMission.UpdateObjective{
			objectives = {
				"ClearTask_CaptureSubComand" ,
			},
		}
		
		if( svars.isCaptureLeader == true ) then
			TppSequence.SetNextSequence("Seq_Game_Escape")
		
		elseif( svars.isCaptureLeader == false ) then
			s10200_radio.HostageCaptured()
			
			if(	TppMarker.GetSearchTargetIsFound( TARGET_VIP_NAME ) == true ) then
				TppRadio.SetOptionalRadio( "Set_s0200_oprg0050" )
			
			else
				TppRadio.SetOptionalRadio( "Set_s0200_oprg0030" )
			end
		end
	end
end


function this.UnitReturned()
	Fox.Log("UnitReturned")

	
	if( svars.isReturnedUnitNo == 0 ) then
		svars.isReturnedUnitNo = 1
		
		if( svars.isPlayerInTown == true ) then
			s10200_radio.ReturnUnitReturned()
		end
	
	elseif( svars.isReturnedUnitNo == 1 ) then
		svars.isReturnedUnitNo = 2
		
		if( svars.isPlayerInTown == true ) then
			s10200_radio.AnotherReturnUnitReturned()
		end
	end
end


function this.PlayerEnterTown()
	if( svars.isReturnedUnitNo == 1 ) then
		Fox.Log("isReturnedUnitNo == 1")
		
		if( TppRadio.IsPlayed( "ReturnUnitReturned" ) == false )then
			s10200_radio.ReturnUnitReturned() 
		end

	elseif( svars.isReturnedUnitNo == 2 )then
		Fox.Log("isReturnedUnitNo == 2")
			
		if( TppRadio.IsPlayed( "ReturnUnitReturned" ) == true )then
			
			if( TppRadio.IsPlayed( "AnotherReturnUnitReturned" ) == false )then
				s10200_radio.AnotherReturnUnitReturned()
			end

		
		elseif( TppRadio.IsPlayed( "ReturnUnitReturned" ) == false )then
			
			if( TppRadio.IsPlayed( "AnotherReturnUnitReturned" ) == false )then
				s10200_radio.ReturnUnitReturned() 
			end
		end
	end
end


function this.SetReturnUnitRoute(enemyId, sneakRouteId, cautionRouteId)
	TppEnemy.SetSneakRoute( enemyId, sneakRouteId )
	TppEnemy.SetCautionRoute( enemyId, cautionRouteId )
end


function this.UnSetReturnUnitRoute(enemyId)
	TppEnemy.UnsetSneakRoute( enemyId )
	TppEnemy.UnsetCautionRoute( enemyId )	
end


function this.HostageMove( routeId )
	local gameObjectId = GameObject.GetGameObjectId( "hos_hillNorth_0001" )
	local command = { id="SetSneakRoute", route=routeId, point=0 }
	GameObject.SendCommand( gameObjectId, command )
end

function this.HostageInDanger()
	Fox.Log("*** HostageInDanger ***")
	local isLookingTarget = Player.AddSearchTarget {
	    name = "BonusHostage",
        
        targetGameObjectTypeIndex = TppGameObject.GAME_OBJECT_TYPE_HOSTAGE2,
	    targetGameObjectName = "hos_hillNorth_0001",
	    offset = Vector3(0,0.25,0),
	    centerRange = 1.5,
	    lookingTime = 1,
	    distance = 60,
	    doWideCheck = false,
	    wideCheckRadius = 0.25,
	    wideCheckRange = 0.15,
	    doDirectionCheck = false,
	    directionCheckRange = 30,
	    doCollisionCheck = false,
	    checkImmediately = true,
	}

	if isLookingTarget == true then
		s10200_radio.BonusHostageInDanger()
	end
end


this.OffHighInterrogation = function()
	Fox.Log("*** HighInterrogation ***")
	TppInterrogation.RemoveHighInterrogation(
		GameObject.GetGameObjectId( "mafr_hillNorth_ob" ),
		{ 
			{ name = "enqt1000_101528", func = this.InterCall_TargetLeader, },
			{ name = "ENQT1000_1i1210", func = this.InterCall_TargetHostage, },	
		}
	)
end



this.OnRoutePoint = {

	ALL = function( gameObjectId, routeId ,routeNode, messageId )

		local messageIdList = { 
			[ Fox.StrCode32( "rts_lrrp_Unit01_Gather_0002_01_Last" ) ] = { soldierList = { "sol_hillNorth_0006", }, enemyName = "sol_hillNorth_0006", group = "groupE" },
			[ Fox.StrCode32( "rts_lrrp_Unit01_Gather_0002_03_Last" ) ] = { soldierList = { "sol_hillNorth_0007", }, enemyName = "sol_hillNorth_0007", group = "groupF" },
			[ Fox.StrCode32( "rts_lrrp_Unit01_Gather_0001_01_Last" ) ] = { soldierList = { "sol_hillNorth_0004", }, enemyName = "sol_hillNorth_0004", group = "groupG" },
			[ Fox.StrCode32( "rts_lrrp_Unit01_Gather_0001_02_Last" ) ] = { soldierList = { "sol_hillNorth_0005", }, enemyName = "sol_hillNorth_0005", group = "groupH" },

			[ Fox.StrCode32( "rts_lrrp_Unit02_Gather_0001_01_Last" ) ] = { soldierList = { "sol_hillNorth_0008", }, enemyName = "sol_hillNorth_0008", group = "groupI" },
			[ Fox.StrCode32( "rts_lrrp_Unit02_Gather_0001_02_Last" ) ] = { soldierList = { "sol_hillNorth_0009", }, enemyName = "sol_hillNorth_0009", group = "groupJ" },
			[ Fox.StrCode32( "rts_lrrp_Unit02_Gather_0002_01_Last" ) ] = { soldierList = { "sol_hillNorth_0010", }, enemyName = "sol_hillNorth_0010", group = "groupK" },
			[ Fox.StrCode32( "rts_lrrp_Unit02_Gather_0002_02_Last" ) ] = { soldierList = { "sol_hillNorth_0011", }, enemyName = "sol_hillNorth_0011", group = "groupL" },

			[ Fox.StrCode32( "talk_01_End" ) ] = { soldierList = { "sol_hillNorth_0000", }, enemyName = "sol_hillNorth_0000", group = "groupA" },
			[ Fox.StrCode32( "talk_02_End" ) ] = { soldierList = { "sol_hillNorth_0000", }, enemyName = "sol_hillNorth_0000", group = "groupA" },
		}

		local item = messageIdList[ messageId ]
		if item then
			s10200_enemy.RouteSetEnable( true, s10200_enemy.routeSets.mafr_hillNorth_ob.sneak_day[ item.group ] ) 
			s10200_enemy.RouteSetEnable( true, s10200_enemy.routeSets.mafr_hillNorth_ob.sneak_night[ item.group ] ) 
			s10200_enemy.InitialRouteSetGroup( item.soldierList, item.group ) 
			this.UnSetReturnUnitRoute ( item.enemyName ) 
		end

	end,



	
	[ Fox.StrCode32( "ReadyTalk_01" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		this.SetReturnUnitRoute( TARGET_VIP_NAME,	"rts_vip_talk_0001", "rts_vip_talk_0001")
	end,

	
	[ Fox.StrCode32( "ReadyTalk_02" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		this.SetReturnUnitRoute( TARGET_VIP_NAME,	"rts_vip_talk_0002", "rts_vip_talk_0002")
	end,



	
	[ Fox.StrCode32( "lrrp_Unit01_0000_End" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		if( svars.isUnit01Returned == false ) then
			svars.isUnit01Returned = true
		end

		this.SetReturnUnitRoute( RETURN_UNIT01_MEM_01,	"rts_lrrp_Unit01_Gather_0001_00","rts_lrrp_Unit01_Gather_0001_00")
		this.SetReturnUnitRoute( RETURN_UNIT01_MEM_02,	"rts_lrrp_Unit01_Gather_0001_00","rts_lrrp_Unit01_Gather_0001_00")
		this.SetReturnUnitRoute( RETURN_UNIT01_MEM_03,	"rts_lrrp_Unit01_Gather_0002_01","rts_lrrp_Unit01_Gather_0002_01")
		this.SetReturnUnitRoute( RETURN_UNIT01_MEM_04,	"rts_lrrp_Unit01_Gather_0002_02","rts_lrrp_Unit01_Gather_0002_02")
	end,

	
	[ Fox.StrCode32( "speech01" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		if mvars.Speech01Count == nil then
			mvars.Speech01Count = 0
			s10200_radio.Speech01()
			this.UnitReturned()
		end
	end,

	
	[ Fox.StrCode32( "speech02" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		if mvars.Speech02Count == nil then
			mvars.Speech02Count = 0
			s10200_radio.Speech02()
			this.UnitReturned()
		end
	end,

	
	[ Fox.StrCode32( "rts_lrrp_Unit01_Gather_0001_00_END" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		this.SetReturnUnitRoute( RETURN_UNIT01_MEM_01, "rts_lrrp_Unit01_Gather_0001_01","rts_lrrp_Unit01_Gather_0001_01")
		this.SetReturnUnitRoute( RETURN_UNIT01_MEM_02, "rts_lrrp_Unit01_Gather_0001_02","rts_lrrp_Unit01_Gather_0001_02")
	end,

	
	[ Fox.StrCode32( "rts_lrrp_Unit01_Gather_0002_02_End" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		this.SetReturnUnitRoute( RETURN_UNIT01_MEM_04, "rts_lrrp_Unit01_Gather_0002_03","rts_lrrp_Unit01_Gather_0002_03")
	end,


	
	
	[ Fox.StrCode32( "rts_lrrp_Unit02_0000_End" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		if( svars.isUnit02Returned == false ) then
			svars.isUnit02Returned = true
			this.HostageMove( "rt_hostage_0000" )
		end
		
		this.SetReturnUnitRoute( RETURN_UNIT02_MEM_01,	"rts_lrrp_Unit02_Gather_0001_00","rts_lrrp_Unit02_Gather_0001_00")
		this.SetReturnUnitRoute( RETURN_UNIT02_MEM_02,	"rts_lrrp_Unit02_Gather_0001_00","rts_lrrp_Unit02_Gather_0001_00")
		this.SetReturnUnitRoute( RETURN_UNIT02_MEM_03,	"rts_lrrp_Unit02_Gather_0002_00","rts_lrrp_Unit02_Gather_0002_00")
		this.SetReturnUnitRoute( RETURN_UNIT02_MEM_04,	"rts_lrrp_Unit02_Gather_0002_00","rts_lrrp_Unit02_Gather_0002_00")
	end,
	
	
	
	[ Fox.StrCode32( "to_rts_lrrp_Unit02_Gather_0001_01" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		this.SetReturnUnitRoute( RETURN_UNIT02_MEM_01, "rts_lrrp_Unit02_Gather_0001_01","rts_lrrp_Unit02_Gather_0001_01")
	end,
	
	
	[ Fox.StrCode32( "to_rts_lrrp_Unit02_Gather_0001_02" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		this.SetReturnUnitRoute( RETURN_UNIT02_MEM_02, "rts_lrrp_Unit02_Gather_0001_02","rts_lrrp_Unit02_Gather_0001_02")
	end,
	
	
	[ Fox.StrCode32( "rts_lrrp_Unit02_Gather_0002_00_End" ) ] = function( gameObjectId, routeId ,routeNode, messageId )
		this.SetReturnUnitRoute( RETURN_UNIT02_MEM_03, "rts_lrrp_Unit02_Gather_0002_01","rts_lrrp_Unit02_Gather_0002_01")
		this.SetReturnUnitRoute( RETURN_UNIT02_MEM_04, "rts_lrrp_Unit02_Gather_0002_02","rts_lrrp_Unit02_Gather_0002_02")
	end,
}




function this.Messages()
	return
	StrCode32Table {

		Player = {

			{
				msg = "OnPickUpCollection",
				func = function( playerGameObjectId, collectionUniqueId, collectionTypeId )
					Fox.Log(" ### PickUpCollection ### ")
					if collectionUniqueId == TppCollection.GetUniqueIdByLocatorName( "col_herb_l_s10200_0000" )
					or collectionUniqueId == TppCollection.GetUniqueIdByLocatorName( "col_herb_l_s10200_0001" )
					or collectionUniqueId == TppCollection.GetUniqueIdByLocatorName( "col_herb_l_s10200_0002" ) then
						Fox.Log(" ### PickUpCollection : TaskCollective ### ")
						svars.CollectiveCount = svars.CollectiveCount + 1
					else
						Fox.Log(" ### PickUpCollection : NotTaskCollective ### ")
					end
					
					if svars.CollectiveCount == 3 then
						s10200_enemy.DisableHighInterrogation_LocateFlowers()
						TppMission.UpdateObjective{
							objectives = { "ClearTask_CollectFlower" },
						}
					end
				end
			},

			{
				msg = "PressedFultonNgIcon",
				func = function ( arg1 , arg2 )
					if arg2 == GameObject.GetGameObjectId( TARGET_HOSTAGE_NAME ) then
						s10200_radio.FultonNG()
					else
						Fox.Log("No Setting Character ... ")
					end
				end
			},

			{	
				msg = "CqcHoldStart",
				func = function ( arg1 , arg2 )
					s10200_radio.CqcChild()
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
		},

		Trap = {
			
			{
				msg = "Exit",
				sender = "trap_ReturnUnit_Start",
				func = function()
					Fox.Log("TRAP : EXIT trap_ReturnUnit_Start")
					s10200_radio.LocateViewPoint()
					GkEventTimerManager.Start( "Unit01Start", this.counterList.UNIT01_START_COUNT )
					GkEventTimerManager.Start( "Unit02Start", this.counterList.UNIT02_START_COUNT )
				end
			},

			
			{
				msg = "Enter",
				sender = "trap_InterTown",
				func = function()
					Fox.Log("TRAP : ENTER trap_InterTown")
					svars.isPlayerInTown = true
					this.PlayerEnterTown()
				end
			},

			
			{
				msg = "Enter",
				sender = "trap_StartConv",
				func = function()
					Fox.Log("TRAP : ENTER trap_InterTown")
					TppEnemy.SetSneakRoute("sol_hillNorth_0000","rts_vip_talk_0000_0")
					TppEnemy.SetSneakRoute("sol_hillNorth_0002","rts_vip_talk_0000_1")
				end
			},


			
			{
				msg = "Exit",
				sender = "trap_InterTown",
				func = function()
					Fox.Log("TRAP : EXIT trap_InterTown")
					svars.isPlayerInTown = false
				end
			},

			
			{
				msg = "Enter",
				sender = "trap_ForceUnitReturn",
				func = function()
					Fox.Log("TRAP : ENTER trap_Unit01Gen")
					if ( svars.isUnit01Started == false) then
						GkEventTimerManager.Start( "Unit01Start_EnterTrap", this.counterList.UNIT01_START_COUNT_ENTER_TRAP )
					end
					if ( svars.isUnit02Started == false) then
						GkEventTimerManager.Start( "Unit02Start_EnterTrap", this.counterList.UNIT02_START_COUNT_ENTER_TRAP )
					end
				end
			},

			
			{
				msg = "Enter",
				sender = "trap_HostageArea",
				func = function()
					Fox.Log("TRAP : ENTER trap_HostageArea")
					TppRadio.SetOptionalRadio( "Set_s0200_oprg0020" )
					svars.isStatusHostage = this.TARGET_STATUS.FOUND
					TppMission.UpdateObjective{
						radio = {
							radioGroups = { "f1000_rtrg2080" },
						},
						
						objectives = { "default_Target_Hostage" }
					}
				end
			},

			
			{
				msg = "Enter",
				sender = "trap_BonusHostageArea",
				func = function()
					Fox.Log(" ### TRAP : ENTER trap_BonusHostageArea ### ")
					local lifeStatus = TppEnemy.GetLifeStatus( "hos_hillNorth_0001" )
					if ( svars.isKilledBonusHostage == false and lifeStatus == TppEnemy.LIFE_STATUS.DEAD ) then
						s10200_radio.BonusHostageAreaReached()
					end
				end
			},
		},

		Marker = {
			{
				msg = "ChangeToEnable",
				sender = "hos_hillNorth_0001",
				func = function ( arg0, arg1, arg2, arg3 )
					if arg3 == StrCode32("Player") then
						Fox.Log(" ### BonusHostageMarked ### ")
						svars.isBonusHostageFound = true
						s10200_radio.BonusHostageFound()
					end
				end
			}
		},

		Timer = {
			{
				msg = "Finish",
				sender = "Unit01Start",
				func = function()
					if ( svars.isUnit01Started == false) then
						s10200_enemy.UnitStart(s10200_enemy.UnitMember.Unit01, "travel_lrrp_Unit01")
						svars.isUnit01Started = true
					end
				end
			},

			{
				msg = "Finish",
				sender = "Unit01Start_EnterTrap",
				func = function()
					if ( svars.isUnit01Started == false) then
						s10200_enemy.UnitStart(s10200_enemy.UnitMember.Unit01, "travel_lrrp_Unit01")
						svars.isUnit01Started = true
					end
				end
			},
			
			{
				msg = "Finish",
				sender = "Unit02Start",
				func = function()
					if ( svars.isUnit02Started == false) then
						s10200_enemy.UnitStart(s10200_enemy.UnitMember.Unit02, "travel_lrrp_Unit02")
						TppRadio.ChangeIntelRadio( s10200_radio.intelRadioList_Unit02Started )
						svars.isUnit02Started = true
					end
				end
			},
			
			{
				msg = "Finish",
				sender = "Unit02Start_EnterTrap",
				func = function()
					if ( svars.isUnit02Started == false) then
						s10200_enemy.UnitStart(s10200_enemy.UnitMember.Unit02, "travel_lrrp_Unit02")
						TppRadio.ChangeIntelRadio( s10200_radio.intelRadioList_Unit02Started )
						svars.isUnit02Started = true
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

		Radio = {
			{	
				msg = "Finish",
				sender = { "s0200_oprg0030" },
				func = function()
					TppRadio.SetOptionalRadio( "Set_s0200_oprg0001" )
					TppMission.UpdateObjective{
						objectives = { "default_viewPoint" },
					}
				end
			},
		},

		GameObject = {
			{	
				msg = "RoutePoint2",
				func = function(gameObjectId, routeId ,routeNode, messageId )
					Fox.Log("RETURN UNIT : ROUTE MESSAGE")
					if this.OnRoutePoint[ messageId ] then
						this.OnRoutePoint[ messageId ]( gameObjectId, routeId ,routeNode, messageId )
					else
						this.OnRoutePoint[ "ALL" ]( gameObjectId, routeId ,routeNode, messageId )
					end
				end
			},

			{	
				msg = "RoutePoint2",
				sender = "hos_hillNorth_0001",
				func = function(gameObjectId, routeId ,routeNode, messageId )
					Fox.Log("HOSTAGE MOVED : ROUTE MESSAGE")
					if messageId == StrCode32("HostageArrived") then
						this.HostageInDanger()

						s10200_enemy.SetJackalRoute("rts_anml_wolf_0001")
					end
				end
			},
			
			
			{ 
				msg = "ChangePhase",
				func = function ( GameObjectId, phaseName )
					if ( phaseName == TppEnemy.PHASE.ALERT ) then
						s10200_radio.PhaseAlart()
					end
				end
			},

			{ 
				msg = "PlacedIntoVehicle", sender = TARGET_VIP_NAME,
				func = function(gameObjectId, VehicleId)
					if VehicleId == GameObject.GetGameObjectId( "TppHeli2", "SupportHeli" ) then
						Fox.Log("ENEMY: PlacedInSupportHeli")
						this.LeaderCaptured()
					end
				end
			},

			{ 
				msg = "Fulton", sender = TARGET_VIP_NAME,
				func = function()
					Fox.Log("ENEMY: EnemyFulton")
					if ( TppMarker.GetSearchTargetIsFound( TARGET_VIP_NAME ) == false ) then
						TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
						TppMission.UpdateObjective{ objectives = { "hud_photo_cihld" }, }
					end
					this.LeaderCaptured()
				end
			},

			{ 
				msg = "PlacedIntoVehicle", sender = TARGET_BONUS_HOSTAGE,
				func = function(gameObjectId, VehicleId)
					if VehicleId == GameObject.GetGameObjectId( "TppHeli2", "SupportHeli" ) then
						s10200_radio.BonusHostageCaptured()
					end
				end
			},

			{ 
				msg = "PlacedIntoVehicle", sender = TARGET_HOSTAGE_NAME,
				func = function(gameObjectId, VehicleId)
					if VehicleId == GameObject.GetGameObjectId( "TppHeli2", "SupportHeli" ) then
						Fox.Log("Hostage: PlacedInSupportHeli")
						this.HostageCaptured()
					end
				end
			},

			{ 
				msg = "Dead", sender = TARGET_HOSTAGE_NAME,
				func = function()
					mvars.deadNPCId = TARGET_HOSTAGE_NAME,
					TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )
				end
			},

			{ 
				msg = "Dead", sender = TARGET_VIP_NAME,
				func = function()
					TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )
				end
			},

			{ 
				msg = "Dead", sender = TARGET_BONUS_HOSTAGE,
				func = function( arg0, arg1 )
					Player.RemoveSearchTarget("BonusHostage")
					if arg1 == GameObject.GetGameObjectId( "Player" ) then
						svars.isKilledBonusHostage = true,
						s10200_radio.BonusHostageKilled()
					end
				end
			},

			{
				msg = "ConversationEnd",				
				func = function( cpGameObjectId, speechLabel, isSuccess )
					Fox.Log( "this.Messages(): ConversationEnd Message Received. gameObjectId:" ..
						tostring( gameObjectId ) .. ", speechLabel:" .. tostring( speechLabel ) .. ", isSuccess:" .. isSuccess )
					Fox.Log( "*** ConversationEnd ***")
					if speechLabel == Fox.StrCode32("CT10200_02") then

					elseif speechLabel == Fox.StrCode32("CT10200_03") then

					elseif speechLabel == Fox.StrCode32("CT10200_04") then
						TppEnemy.UnsetSneakRoute("sol_hillNorth_0000")
						TppEnemy.UnsetSneakRoute("sol_hillNorth_0002")
					else
						Fox.Log(" ### ConversationEnd with Unknown speechLabel ### ")
					end	
				end
			},

			{
				msg = "Carried", sender = TARGET_HOSTAGE_NAME,
				func = function ( gameObjectId , carriedState )
					Fox.Log(" ### Carried ### ")
					if carriedState == TppGameObject.NPC_CARRIED_STATE_START then
						s10200_radio.StartMonologue()
					end
				end
			},

			{
				msg = "MonologueEnd",
				func = function ( gameObjectId , label )
					svars.sub_Flag_0010 = svars.sub_Flag_0010 + 1
					local gameObjectId = GameObject.GetGameObjectId( TARGET_HOSTAGE_NAME )
					local command = { id = "GetStatus", }
					local status =	GameObject.SendCommand( gameObjectId, command )
					if status == TppGameObject.NPC_STATE_CARRIED then
						s10200_radio.StartMonologue()
					else
						Fox.Log(" ### No Longer Target Being Carried ### ")
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
	}
end






sequences.Seq_Game_MainGame = {


	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end
		
		TppRadio.SetOptionalRadio( "Set_s0200_oprg0000" )
		TppTelop.StartCastTelop()
		this.ContinueMission()
	end,
	
	OnLeave = function()
	end,
}

sequences.Seq_Game_Escape = {

	OnEnter = function() 
		this.OffHighInterrogation()
		TppMission.CanMissionClear()
		TppRadio.SetOptionalRadio( "Set_s0200_oprg0070" )
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = { "f1000_rtrg7010" },	
			},

			objectives = { "default_subGoal_Escape" }
		}
	end,
}




return this