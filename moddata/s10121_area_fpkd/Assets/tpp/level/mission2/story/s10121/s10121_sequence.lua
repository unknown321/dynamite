local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}





local TARGET_ENEMY_NAME = "sol_pfCamp_vip_0001"
local SUB_TARGET_ENEMY_NAME = "sol_pfCamp_vip_guard"

local MISSION_BLUE_PRINT_NAME = "col_develop_Highprecision_SMG"
local SUB_TASK_BLUE_PRINT_NUMBER = TppTerminal.BLUE_PRINT_LOCATOR_TABLE[ MISSION_BLUE_PRINT_NAME ]

local SNIPER_01 = "sol_pfCamp_snp_0000"
local SNIPER_02 = "sol_pfCamp_snp_0001"

local WG_RIDER_01 = "sol_pfCamp_0100"
local WG_RIDER_02 = "sol_pfCamp_0101"
local WG_RIDER_03 = "sol_pfCamp_0102"
local WG_RIDER_04 = "sol_pfCamp_0103" 


local DEV_DOC_POSITION_FOR_CONTINUE = Vector3( 840.216, -11.7, 1198.875 )




this.characterIdList = {
	ContainerA			= "gntn_cntn001_vrtn001_gim_n0005|srt_gntn_cntn001_vrtn001",						
	ContainerB			= "gntn_cntn001_vrtn001_gim_n0006|srt_gntn_cntn001_vrtn001",						
	ContainerC			= "gntn_cntn001_vrtn001_gim_n0007|srt_gntn_cntn001_vrtn001",						
}




local ENEMY_HELI_STATE = {
	NORMAL				= 0,
	LOST_CONTROL_START	= 1,
	LOST_CONTROL_END	= 2,
}





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
	isEnemyHeliStart = false,
	isEnemyHeliArrived = false,
	isEnemyHeliReturn = false,
	isEnemyVIPUnite	= false,
	isEnemyVipStartInspection = false, 
	isEnemyVIPRideHeli = false,
	isTargetCaptured = false,
	isSubTargetCaptured = false,

	isListen1stTalk = false,
	isListen2ndTalk = false,
	isListen3rdTalk = false,

	CollectiveCount = 0,

	
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

	
	enemyHeliState = ENEMY_HELI_STATE.NORMAL,	
}


this.checkPointList = {
	"CHK_MissionStart",		
	nil
}

this.baseList = {
	"pfCamp",
	"pfCampEast",
	"chicoVilWest",
	nil
}


this.REVENGE_MINE_LIST = {"mafr_pfCamp"}



this.counterList = {

}












this.missionObjectiveDefine = {
	default_Target_pfCamp = {
		gameObjectName = "10121_marker_pfCamp", visibleArea = 5, randomRange = 0, viewType = "all", setNew = false, announceLog = "updateMap", langId = "marker_info_mission_targetArea"
	},
	
	default_Target_Area = {
		gameObjectName = "10121_marker_Leader", mapRadioName = "f1000_mprg0075", visibleArea = 4, randomRange = 0, viewType = "map_only_icon", setNew = true, announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},

	default_Target = {
		gameObjectName = TARGET_ENEMY_NAME, visibleArea = 0, randomRange = 0, viewType = "map_and_world_only_icon", setImportant = true, setNew = true, announceLog = "updateMap", langId = "marker_info_mission_target",
	},

	default_Sub_Target = {
		gameObjectName = SUB_TARGET_ENEMY_NAME, visibleArea = 0, randomRange = 0, viewType = "map_and_world_only_icon", setImportant = true, setNew = true, announceLog = "updateMap", langId = "marker_ene_wp_supplier",
	},
	
	default_photo_target_10 = {
		photoId			= 10,	addFirst = true, photoRadioName = "s0121_mirg2010",
	},
	
	default_photo_target_20 = {
		photoId			= 20,	addFirst = true, photoRadioName = "s0121_mirg2020",
	},
	
	
	Inspection_route = {
		showEnemyRoutePoints = {  groupIndex=0, width=30.0, langId="marker_target_forecast_path",
		radioGroupName = "s0121_rtrg2030",
			points={
		        Vector3( 801.140625, 4.1427264213562, 1220.462890625 ),
				Vector3( 721.26000976563, -3.2176079750061, 1138.4881591797 ),
				Vector3( 792.44403076172, -11.612465858459, 1105.0075683594 ),
				Vector3( 978.30334472656, -11.612465858459, 1212.9724121094 ),
				Vector3( 965.67395019531, -2.4375014305115, 1255.083984375 ),
				Vector3( 801.140625, 4.1427264213562, 1220.462890625 ),
			}
		},
		announceLog = "updateMap",
	},


	
	default_subGoal_SearchAndDestroy = {
		subGoalId= 0,
    },

	default_subGoal_FollowDealer = {
		subGoalId= 1,
    },

	default_subGoal_RejectCFA = {
		subGoalId= 3,
    },

	default_subGoal_Escape = {
		subGoalId= 4,
    },

	
	MissionTask_LocateDealer = { 
		missionTask = { taskNo=0, isNew=true, isComplete=false },
	},
	ClearTask_LocateDealer = { 
		missionTask = { taskNo=0, isComplete=true },
	},
	MissionTask_LocateCFA = {
		missionTask = { taskNo=1, isNew=true, isComplete=false },
	},
	ClearTask_LocateCFA = {
		missionTask = { taskNo=1, isComplete=true },
	},
	MissionTask_RejectCFA = {
		missionTask = { taskNo=2, isNew=true, isComplete=false },
	},
	ClearTask_RejectCFA = {
		missionTask = { taskNo=2, isComplete=true },
	},
	MissionTask_CaptureCFA = {
		missionTask = { taskNo=3, isNew=true, isFirstHide=true, isComplete=false },
	},
	ClearTask_CaptureCFA = {
		missionTask = { taskNo=3,},
	},
	MissionTask_CaptureDealer = {
		missionTask = { taskNo=4, isNew=true, isFirstHide=true, isComplete=false },
	},
	ClearTask_CaptureDealer = {
		missionTask = { taskNo=4,},
	},
	MissionTask_ListenAllDialogue = {
		missionTask = { taskNo=5, isNew=true, isFirstHide=true, isComplete=false },
	},
	ClearTask_ListenAllDialogue = {
		missionTask = { taskNo=5, isComplete=true },
	},

	MissionTask_StealHeliCargo = {
		missionTask = { taskNo=6, isNew=true, isFirstHide=true, isComplete=false },
	},
	ClearTask_StealHeliCargo = {
		missionTask = { taskNo=6, isComplete=true },
	},
	MissionTask_GetContainer = {
		missionTask = { taskNo=7, isNew=true, isFirstHide=true, isComplete=false },
	},
	ClearTask_GetContainer = {
		missionTask = { taskNo=7, isComplete=true },
	},

	
	targetCpSetting = {
		targetBgmCp = "mafr_pfCamp_cp",
	},

	
	announce_rescue_EliminateTarget = {
		announceLog = "eliminateTarget",
	},

	announce_rescue_RecoverTarget = {
		announceLog = "recoverTarget",
	},
	
	announce_ObjectiveComplete = {
		announceLog = "achieveAllObjectives",
	},

	announce_MissionFailed = {
		announceLog = "target_eliminate_failed",
	},

	default_viewpoint = {
		gameObjectName = "10121_marker_viewpoint", mapRadioName = "s0121_mprg2010", visibleArea = 2, randomRange = 0, viewType = "map_only_icon", setNew = true, announceLog = "updateMap", langId = "marker_info_vantage_point",
	},

    hud_photo_target = {
		hudPhotoId = 10 
    },

    hud_photo_sub_target = {
		hudPhotoId = 20 
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

	default_Target = {
		default_Sub_Target = {
			default_Target_Area = {
				default_Target_pfCamp = {},
			},
		},
	},

	Inspection_route = {
	},

	
	default_photo_target_10 = {
	},

	
	default_photo_target_20 = {
	},

	default_subGoal_Escape = {
		default_subGoal_RejectCFA = {
			default_subGoal_FollowDealer = {
				default_subGoal_SearchAndDestroy = {},
			},
		},
	},

	ClearTask_LocateDealer = {
		MissionTask_LocateDealer = {},
	},

	ClearTask_LocateCFA = {
		MissionTask_LocateCFA = {},
	},

	ClearTask_RejectCFA = {
		MissionTask_RejectCFA = {},
	},

	ClearTask_CaptureCFA = {
		MissionTask_CaptureCFA = {},
	},

	ClearTask_CaptureDealer = {
		MissionTask_CaptureDealer = {},
	},

	ClearTask_ListenAllDialogue = {
		MissionTask_ListenAllDialogue = {},
	},

	ClearTask_StealHeliCargo = {
		MissionTask_StealHeliCargo = {},
	},

	ClearTask_GetContainer = {
		MissionTask_GetContainer = {},
	},

	targetCpSetting = {},

	announce_rescue_EliminateTarget = {},
	announce_rescue_RecoverTarget = {},
	announce_ObjectiveComplete = {},
	announce_MissionFailed = {},

	default_viewpoint = {},

    hud_photo_target = {},
    hud_photo_sub_target = {},

}



this.missionObjectiveEnum = Tpp.Enum{
	"default_Target_pfCamp",
	"default_Target_Area",
	"default_Target",
	"default_Sub_Target",
	"default_photo_target_10",
	"default_photo_target_20",
	"Inspection_route",

	
	"default_subGoal_SearchAndDestroy",
	"default_subGoal_FollowDealer",
	"default_subGoal_RejectCFA",
	"default_subGoal_Escape",

	
	"MissionTask_LocateDealer",
	"MissionTask_LocateCFA",
	"MissionTask_RejectCFA",
	"MissionTask_CaptureCFA",
	"MissionTask_CaptureDealer",
	"MissionTask_ListenAllDialogue",
	"MissionTask_StealHeliCargo",
	"MissionTask_GetContainer",

	"ClearTask_LocateDealer",
	"ClearTask_LocateCFA",
	"ClearTask_RejectCFA",
	"ClearTask_CaptureCFA",
	"ClearTask_CaptureDealer",
	"ClearTask_ListenAllDialogue",
	"ClearTask_StealHeliCargo",
	"ClearTask_GetContainer",

	"targetCpSetting",

	"announce_rescue_EliminateTarget",
	"announce_rescue_RecoverTarget",
	"announce_ObjectiveComplete",
	"announce_MissionFailed",

	"default_viewpoint",

    "hud_photo_target",
    "hud_photo_sub_target",
}


this.missionStartPosition = {

	
	orderBoxList = {
		"box_s10121_00",
	},
	
	helicopterRouteList = {
		"rt_drp_pfcamp_N_0000",
	},
}






function this.MissionPrepare()
	TppEnemy.RequestLoadWalkerGearEquip()
	
	if TppMission.IsHardMission( vars.missionCode ) then
		TppMission.RegistDiscoveryGameOver()
	end

	this.RegisterCallback()
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppStork" ) 
	TppSound.ResetPhaseBGM()
	local missionName = TppMission.GetMissionName()
	Fox.Log("### " .. tostring(missionName) .. " MissionPrepare ###")
	TppMarker.SetUpSearchTarget{
		{
			gameObjectName = TARGET_ENEMY_NAME, 
			gameObjectType = "TppSoldier2", 
			messageName = TARGET_ENEMY_NAME, 
			skeletonName = "SKL_004_HEAD", 
			objectives = "default_Target", 
			func = function()
				s10121_radio.ConfirmedTarget()
				TppRadio.SetOptionalRadio( "Set_s0121_oprg0030" )
				if ( svars.sub_Flag_0001 == false ) then
					TppEnemy.SetAlertRoute( TARGET_ENEMY_NAME,	"rts_vip_evacuate_0000" )
				end
				TppMission.UpdateObjective{
					objectives = { "default_subGoal_RejectCFA","ClearTask_LocateCFA", "hud_photo_target" },
				}
			end
		},
		
		{
		 	gameObjectName = SUB_TARGET_ENEMY_NAME, 
			gameObjectType = "TppSoldier2", 
			messageName = SUB_TARGET_ENEMY_NAME, 
			skeletonName = "SKL_004_HEAD", 
			objectives = "default_Sub_Target", 
			func = function()
				s10121_radio.ConfirmedSubTarget()
				TppMission.UpdateObjective{
					objectives = { "ClearTask_LocateDealer", "hud_photo_sub_target" },
				}
			end
		},
	}

end


function this.OnEstablishMissionClear( missionClearType )
	Fox.Log("### " .. tostring(missionClearType) .. " OnEstablishMissionClear ###")
	
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
	
end

function this.OnDisappearGameEndAnnounceLog()
	Fox.Log("### OnDisappearGameEndAnnounceLog ###")
	
	
	if ( svars.isTargetCaptured == true ) and ( svars.isSubTargetCaptured == false )  then
		s10121_radio.OnGameCleared_CapturePFLeader()
	
	elseif ( svars.isTargetCaptured == false ) and ( svars.isSubTargetCaptured == true )  then
		s10121_radio.OnGameCleared_CaptureArmsDealer()
	
	elseif ( svars.isTargetCaptured == true ) and ( svars.isSubTargetCaptured == true )  then
		s10121_radio.OnGameCleared_CaptureBoth()
	end
	TppMission.ShowMissionResult()
end


function this.OnGameOver( gameOverType )
	Fox.Log("### " .. tostring(gameOverType) .. " OnGameOver ###")
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_ESCAPE_BY_HELI ) then
		
		TppPlayer.SetTargetHeliCamera{ gameObjectName = "EnemyHeli" }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true

	elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_ESCAPE ) then
		
		TppPlayer.SetTargetHeliCamera{ gameObjectName = TARGET_ENEMY_NAME }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end
end


function this.OnRecovered( gameObjectId )
	Fox.Log("### OnRecovered_is_coming ###")
	if ( gameObjectId == GameObject.GetGameObjectId( TARGET_ENEMY_NAME )) then
		Fox.Log("### isTargetCaptured ###")
		if (svars.isTargetCaptured == false) then
			svars.isTargetCaptured = true
			TppSequence.SetNextSequence("Seq_Game_Escape")
			TppMission.UpdateObjective{
				objectives = { "announce_rescue_RecoverTarget","announce_ObjectiveComplete", },
			}
			TppMission.UpdateObjective{
				objectives = { "ClearTask_RejectCFA","ClearTask_CaptureCFA", },
			}
			TppResult.AcquireSpecialBonus{ first = { isComplete = true,},}
		end
	elseif ( gameObjectId == GameObject.GetGameObjectId( SUB_TARGET_ENEMY_NAME )) then
		Fox.Log("### isSubTargetCaptured ###")
		if(svars.isSubTargetCaptured == false) then
			svars.isSubTargetCaptured = true
			TppMission.UpdateObjective{
				objectives = { "ClearTask_CaptureDealer" },
			}
			TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}
		end
	end
end


function this.RegisterCallback()

	Fox.Log("### s10121_sequence.RegisterCallback() ###")

	local systemCallbackTable ={
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnGameOver = this.OnGameOver,
		OnRecovered = this.OnRecovered,
		OnDisappearGameEndAnnounceLog = this.OnDisappearGameEndAnnounceLog,
		CheckMissionClearFunction = function() return TppEnemy.CheckAllTargetClear() end,
		nil,
	}
	
	
	TppMission.RegisterMissionSystemCallback(systemCallbackTable)

end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("### " .. tostring(missionName) .. " OnRestoreSVars ###")
end


function this.ContinueMission()

	if svars.sub_Flag_0002 == true then 
		s10121_radio.ContinueVipEscaping()
	elseif svars.sub_Flag_0002 == false then
		if( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == false ) and ( TppMarker.GetSearchTargetIsFound( SUB_TARGET_ENEMY_NAME ) == false )then
			if ( svars.isEnemyHeliStart == true and svars.isEnemyHeliReturn == false ) then 
				s10121_radio.EnemyHeliStartAfterMBMissionClear()
			elseif ( svars.isEnemyHeliStart == true and svars.isEnemyHeliReturn == true ) then 
				s10121_radio.EnemyHeliReturn()
				this.SetEnemyHeliRoute("enemyHeli01_return")
				this.SetEnemyHeliCautionRoute("enemyHeli01_return")
				this.SetEnemyHeliAlertRoute("enemyHeli01_return")
			elseif ( svars.isEnemyHeliStart == true and svars.isEnemyHeliArrived == true ) then 
				s10121_radio.ContinueHeliArrived()
			else
				TppMission.UpdateObjective{
					
					objectives = { 
						"default_photo_target_10","default_photo_target_20","default_subGoal_SearchAndDestroy",	"MissionTask_LocateDealer",	"MissionTask_LocateCFA","MissionTask_RejectCFA",
						"MissionTask_CaptureCFA","MissionTask_CaptureDealer","MissionTask_ListenAllDialogue","MissionTask_StealHeliCargo","MissionTask_GetContainer",
					},
				}

				TppMission.UpdateObjective{
					radio = {
						
						radioGroups = { "s0121_rtrg1010" },
					},
					
					objectives = { 
						"default_Target_pfCamp",
					},
				}
				TppRadio.SetOptionalRadio( "Set_s0121_oprg0000" )
			end
		elseif( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == true ) and ( TppMarker.GetSearchTargetIsFound( SUB_TARGET_ENEMY_NAME ) == false )then
			s10121_radio.ContinueVipFound()
		elseif( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == false ) and ( TppMarker.GetSearchTargetIsFound( SUB_TARGET_ENEMY_NAME ) == true )then
			s10121_radio.ContinueSubVipFound()
		end
	end

	local EVENT_MISSION_OCCUR_COUNT = 40 
	local EVENT_MISSION_OCCUR_COUNT_FROM_HELI = 70
	local ENEMY_HELI_START_COUNT = 110 
	local ENEMY_HELI_START_COUNT_FROM_HELI = 140

	if TppStory.IsAlwaysOpenRetakeThePlatform() == false then
		Fox.Log("### Emergency Mission will Occur ###")
		svars.sub_Flag_0003 = true
		ENEMY_HELI_START_COUNT = 180
		ENEMY_HELI_START_COUNT_FROM_HELI = 210
	else
		Fox.Log("### Emergency Mission will Not Occur ###")		
	end

	if Tpp.IsHelicopter(vars.playerVehicleGameObjectId) then
		Fox.Log("### IsHelicopter ###")
		local dropRouteName = TppHelicopter.GetMissionStartHelicopterRoute()
		if dropRouteName == StrCode32("lz_drp_pfCamp_I0000|rt_drp_pfCamp_I_0000") then
			Fox.Log("### IsHelicopter:IsAssaultDropLandingZone ###")
			EVENT_MISSION_OCCUR_COUNT_FROM_HELI = 20
			ENEMY_HELI_START_COUNT_FROM_HELI = 60
		end
	end

	if 	svars.isEnemyHeliStart == false then
		TppMission.StartEmergencyMissionTimer{
			openTimer = {
				name = "EventMissionOccurTimer",
				timeSecFromHeli = EVENT_MISSION_OCCUR_COUNT_FROM_HELI,
				timeSecFromLand = EVENT_MISSION_OCCUR_COUNT,
			},
			closeTimer = {
				name = "EnemyHeliStartTimer",
				timeSecFromHeli = ENEMY_HELI_START_COUNT_FROM_HELI,
				timeSecFromLand = ENEMY_HELI_START_COUNT,
			},
		}
	end

	Fox.Log("### " .. tostring(EVENT_MISSION_OCCUR_COUNT) .. "  ###")
	Fox.Log("### " .. tostring(ENEMY_HELI_START_COUNT) .. "  ###")
	Fox.Log("### " .. tostring(EVENT_MISSION_OCCUR_COUNT_FROM_HELI) .. "  ###")
	Fox.Log("### " .. tostring(ENEMY_HELI_START_COUNT_FROM_HELI) .. "  ###")

end




function this.CallCpRadio ( labelName )
	local gameObjectId = GameObject.GetGameObjectId( "mafr_pfCamp_cp" )
	local command = { id = "RequestRadio", label= labelName, 	memberId = memberGameObjectId }
	GameObject.SendCommand( gameObjectId, command )
end


function this.ChangePhase(Phase)
	local gameObjectId = GameObject.GetGameObjectId( "mafr_pfCamp_cp" )
	local command = { id = "SetPhase", phase=Phase }
	GameObject.SendCommand( gameObjectId, command )
end


function this.SetVipRoute( vipRouteId, subvipRouteId )
	TppEnemy.SetSneakRoute( TARGET_ENEMY_NAME, vipRouteId )
	TppEnemy.SetSneakRoute( SUB_TARGET_ENEMY_NAME, subvipRouteId )
end


function this.SetVipCautionRoute( vipRouteId )
	TppEnemy.SetCautionRoute( TARGET_ENEMY_NAME, vipRouteId )
	TppEnemy.SetCautionRoute( SUB_TARGET_ENEMY_NAME, vipRouteId )
end


function this.SetVipAlertRoute( vipRouteId )
	TppEnemy.SetAlertRoute( TARGET_ENEMY_NAME, vipRouteId )
	TppEnemy.SetAlertRoute( SUB_TARGET_ENEMY_NAME, vipRouteId )
end


function this.SetRestrictNotice( enemyName, flag )
	local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", enemyName )
	local command = { id="SetRestrictNotice", enabled = flag }
	GameObject.SendCommand( gameObjectId, command )
end


function this.SetEnemyHeliRoute ( routeId )
	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id = "SetSneakRoute", route = routeId })
end


function this.SetEnemyHeliCautionRoute ( routeId )
	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id = "SetCautionRoute", route = routeId })
end


function this.SetEnemyHeliAlertRoute ( routeId )
	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id = "SetAlertRoute", route = routeId })
end

function this.HeliRestrictNotice ()
	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id = "SetRestrictNotice", enabled = true })
end


function this.UnsetEnemyHeliCautionRoute ()
	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id = "SetCautionRoute", enabled = false })
end


function this.UnsetEnemyHeliAlertRoute ()
	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id = "SetAlertRoute", enabled = false })
end


function this.VanishEnemyHeli ()
	local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
	GameObject.SendCommand(gameObjectId, { id="Unrealize" })
end


function this.IsOpenRetakeThePlatformWithEmergency()
	if TppStory.IsMissionOpen( 10115 ) then
		if TppStory.IsAlwaysOpenRetakeThePlatform() then
			return false
		else
			return true
		end
	else
		return false
	end
end


function this.EventMissionOccur()
	Fox.Log("FUNC : EVENT MISSION OCCUR: 10115")
	svars.sub_Flag_0000 = true 
	TppStory.CheckAndOpenRetakeThePlatform()
end


function this.EventMissionCancel()
	Fox.Log("FUNC : EVENT MISSION CANCEL: 10115")
	svars.sub_Flag_0000 = false
	TppRadio.SetOptionalRadio( "Set_s0121_oprg0010" )
	TppStory.FailedRetakeThePlatformIfOpened()
end

function this.EnemyHeliStartMoving()
	if TppSequence.GetCurrentSequenceIndex() == TppSequence.GetSequenceIndex("Seq_Game_MainGame") then
		if TppEnemy.GetPhase("mafr_pfCamp_cp") == TppEnemy.PHASE.SNEAK then
			
			if ( svars.isEnemyHeliStart == false and svars.isEnemyHeliReturn == false ) then
				TppMission.UpdateObjective{
					objectives = { 
						"default_subGoal_FollowDealer",
					 },
				}
				this.SetEnemyHeliRoute("enemyHeli01_come")
				this.SetEnemyHeliCautionRoute("enemyHeli01_return")
				this.SetEnemyHeliAlertRoute("enemyHeli01_return")
				s10121_enemy.HeliDisablePullOut()
				svars.isEnemyHeliStart = true
			end
			
			if this.IsOpenRetakeThePlatformWithEmergency() then
				s10121_radio.EnemyHeliStartBeforeMBMissionClear()
			else
				s10121_radio.EnemyHeliStartAfterMBMissionClear()
			end
		elseif TppEnemy.GetPhase("mafr_pfCamp_cp") >= TppEnemy.PHASE.CAUTION then
			TppMission.UpdateObjective{
				objectives = { "default_subGoal_RejectCFA",},
			}
			if this.IsOpenRetakeThePlatformWithEmergency() then
				s10121_radio.EnemyHeliNotStartBeforeMBMissionClear()	
			else			
				s10121_radio.EnemyHeliNotStartAfterMBMissionClear()	
			end
			if( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == false ) then
				TppRadio.SetOptionalRadio( "Set_s0121_oprg0040" )
			end
		end
	elseif TppSequence.GetCurrentSequenceIndex() == TppSequence.GetSequenceIndex("Seq_Game_Escape") then
		Fox.Log(" ### Nothing To Say ### ")
	end
	
	this.EventMissionCancel()
end

function this.HeliItemDrop( continuePosition )
	Fox.Log(" ### HeliItemDrop ### ")
	local downposition = continuePosition
	if downposition == nil then
		local gameObjectId = GameObject.GetGameObjectId( "EnemyHeli" )
		local command = { id = "GetPosition" }
		downposition = GameObject.SendCommand( gameObjectId, command )
	end

	TppPickable.DropItem{
		equipId =  TppEquip.EQP_IT_DevelopmentFile,
		number = SUB_TASK_BLUE_PRINT_NUMBER,
		position = downposition,          
		rotation = Quat.RotationY( 0 ),         
		linearVelocity = Vector3( 0, 2, 0 ),    
		angularVelocity = Vector3( 0, 2, 0 )    
	}
end


this.OffHighInterrogation = function()
	Fox.Log("### HighInterrogation ###")
	TppInterrogation.RemoveHighInterrogation(
		GameObject.GetGameObjectId( "mafr_pfCamp_cp" ),
		{ 
			{ name = "enqt1000_101528", func = this.InterCall_Target, },
		}
	)
end







function this.Messages()
	return
	StrCode32Table {
		Player = {
			{	
				msg = "OnPickUpWeapon",
				func = function( playerGameObjectId, equipId, number )
					Fox.Log( "OnPickUpWeapon playerGameObjectId: " .. tostring(playerGameObjectId) .. " equipId: " .. tostring(equipId) .. " number: " .. tostring(number) )
					if equipId == TppEquip.EQP_IT_DevelopmentFile and number == SUB_TASK_BLUE_PRINT_NUMBER then
						
						TppMission.UpdateObjective{
							objectives = { "ClearTask_StealHeliCargo" },
						}
						
						
						TppTerminal.PickUpBluePrint( nil, SUB_TASK_BLUE_PRINT_NUMBER )
						
						svars.enemyHeliState = ENEMY_HELI_STATE.LOST_CONTROL_END
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
		},

		Trap = {
			{
				msg = "Enter",
				sender = "trap_pfCamp",
				func = function ()
					Fox.Log(" ### TRAP ENTER: trap_pfCamp ### ")
					if svars.isEnemyVipStartInspection == false then
						s10121_radio.ArrivedpfCampEarly()
					elseif svars.isEnemyVipStartInspection == true then
						s10121_radio.ArrivedpfCamp()
					end
				end,
			},
		},

		Radio = {
			{	
				msg = "Finish",
				sender = "s0121_oprg2020",
				func = function()
					TppMission.UpdateObjective{
						objectives = { "default_viewpoint" },
					}
				end
			},

			{	
				msg = "Finish",
				sender = "f1000_rtrg1010",
				func = function()
					
					TppUI.ShowControlGuide{ actionName = "MB_DEVICE" }
				end
			},

			{
				msg = "Finish",
				sender = "s0121_rtrg2250",
				func = function()
					TppMission.UpdateObjective{
						objectives = { "default_Target_Area",},
					}
				end
			},
		},

		Subtitles = {
			{	
				msg = "SubtitlesEndEventMessage",				
				func = function( speechLabel, status )
					Fox.Log( "### SubtitlesEndEventMessage ###")
					
					if (speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "wrec6000_1e1010_0_ened_af" )) then
						svars.isListen1stTalk = true
						s10121_radio.ListenDialogue_01()

					
					elseif (speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "wrec6000_1m1010_0_ened_af" )) then
						svars.isListen2ndTalk = true
						s10121_radio.ListenDialogue_02()

					
					elseif (speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "wrec6000_2q1010_0_ened_af" )) then
						svars.isListen3rdTalk = true
						s10121_radio.ListenDialogue_03()

					
					elseif (speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "wrec6000_3b1010_0_ened_af" )) then
						s10121_radio.ListenDialogue_04()
						if( svars.isListen1stTalk == true ) and ( svars.isListen2ndTalk == true ) and( svars.isListen3rdTalk == true ) then
							TppMission.UpdateObjective{objectives = { "ClearTask_ListenAllDialogue" },}
						else
							Fox.Log(" ### Missing Some Dialogue To listen ### ")
						end
					end
				end
			},	
		},

		Timer = {
			
			{
				msg = "Finish",
				sender = "EnemyHeliStartTimer",
				func = function ()
					this.EnemyHeliStartMoving()
				end
			},

			{
				msg = "Finish",
				sender = "EventMissionOccurTimer",
				func = function ()
					this.EventMissionOccur()
				end
			},

			{
				msg = "Finish",
				sender = "UniteLimit",
				func = function ()
					Fox.Log("### Unite Time Limit ### ")
					if svars.isEnemyVIPUnite == false then
						Fox.Log("### Unite Not Finish In Time : Phase Goes Caution ### ")
						if TppEnemy.GetPhase("mafr_pfCamp_cp") == TppEnemy.PHASE.SNEAK then
							this.ChangePhase(TppGameObject.PHASE_CAUTION)
						end
					else
						Fox.Log("### Unite Finished In Time : Start Inspection ### ")
					end
				end
			},


			{
				msg = "Finish",
				sender = "GetInEnemyHeliLimit",
				func = function ()
					Fox.Log("### GetInEnemyHeliLimit Time Limit ### ")
					svars.sub_Flag_0001 = false 
					svars.sub_Flag_0002 = true
					if svars.sub_Flag_0010 == 2 then
						Fox.Log("### GetInEnemyHeliLimit Finished In Time ### ")
					elseif svars.sub_Flag_0010 == 1 then
						Fox.Log("### GetInEnemyHeliLimit Finished Not In Time ### ")
						if TppEnemy.GetPhase("mafr_pfCamp_cp") == TppEnemy.PHASE.SNEAK then
							this.ChangePhase(TppGameObject.PHASE_CAUTION)
							this.CallCpRadio("CPR0580") 
						end
						this.SetEnemyHeliRoute ("enemyHeli02_gone")
						this.SetEnemyHeliCautionRoute("enemyHeli02_gone") 
						this.SetEnemyHeliAlertRoute("enemyHeli02_gone") 
					
					end
					
					if svars.sub_Flag_0004 == false then
						TppEnemy.SetCautionRoute( TARGET_ENEMY_NAME, "rts_vip_c_0000" )
						TppEnemy.UnsetAlertRoute( TARGET_ENEMY_NAME )
					end

					
					if svars.sub_Flag_0005 == false then
						TppEnemy.SetCautionRoute( SUB_TARGET_ENEMY_NAME, "rts_sub_vip_c_0000" )
						TppEnemy.UnsetAlertRoute( SUB_TARGET_ENEMY_NAME )
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
				msg = "Dead", sender = TARGET_ENEMY_NAME,
				func = function ()
					Fox.Log("Target Dead")
					TppSound.ResetPhaseBGM()
					TppSequence.SetNextSequence("Seq_Game_Escape")
					TppMission.UpdateObjective{
						objectives = { "announce_rescue_EliminateTarget","announce_ObjectiveComplete",},
					}
					TppMission.UpdateObjective{
						objectives = { "ClearTask_RejectCFA" },
					}

					if ( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == false ) then
						TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
						TppMission.UpdateObjective{ objectives = { "hud_photo_target" }, }
					end
				end
			},

			{	
				msg = "Dead", sender = SUB_TARGET_ENEMY_NAME,
				func = function ()
					if ( TppMarker.GetSearchTargetIsFound( SUB_TARGET_ENEMY_NAME ) == false ) then
						TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
						TppMission.UpdateObjective{ objectives = { "hud_photo_sub_target" }, }
					end
				end
			},

			{	
				msg = "PlacedIntoVehicle", sender = TARGET_ENEMY_NAME,
				func = function(gameObjectId, VehicleId)
					if VehicleId == GameObject.GetGameObjectId( "TppHeli2", "SupportHeli" ) then
						TppSequence.SetNextSequence("Seq_Game_Escape")
						TppMission.UpdateObjective{
							objectives = { "announce_rescue_RecoverTarget","announce_ObjectiveComplete",},
						}
						TppMission.UpdateObjective{
							objectives = { "ClearTask_RejectCFA" },
						}
					end
				end
			},

			{
				msg = "Damage", sender = SUB_TARGET_ENEMY_NAME,
				func= function()
					Fox.Log(" ### Conscious : SUB_TARGET_ENEMY_NAME ### ")
					
					if (svars.isEnemyVIPUnite == false) and (TppMarker.GetSearchTargetIsFound( SUB_TARGET_ENEMY_NAME ) == true) then
						if TppEnemy.GetPhase("mafr_pfCamp_cp") == TppEnemy.PHASE.SNEAK then
							s10121_radio.DownSubTarget()
						end
					end
				end
			},

			{ 
				msg = "Fulton", sender = TARGET_ENEMY_NAME,
				func = function()
					Fox.Log("ENEMY: EnemyFulton")
					if ( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == false ) then
						TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
						TppMission.UpdateObjective{ objectives = { "hud_photo_target" }, }
					end

				end
			},

			{ 
				msg = "Fulton", sender = SUB_TARGET_ENEMY_NAME,
				func = function()
					Fox.Log("ENEMY: EnemyFulton")
					if ( TppMarker.GetSearchTargetIsFound( SUB_TARGET_ENEMY_NAME ) == false ) then
						TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
						TppMission.UpdateObjective{ objectives = { "hud_photo_sub_target" }, }
					end

				end
			},

			
			{	
				msg = "Fulton",
				func = function ( GameObjectId, ContainerName )
					if ( ContainerName == StrCode32(this.characterIdList.ContainerA) )
					or ( ContainerName == StrCode32(this.characterIdList.ContainerB) )
					or ( ContainerName == StrCode32(this.characterIdList.ContainerC) ) then
						Fox.Log(" ### Fulton : TaskContainer ### ")
						svars.CollectiveCount = svars.CollectiveCount + 1
					else
						Fox.Log(" ### Fulton : NotTaskContainer ### ")
					end
					
					if svars.CollectiveCount == 3 then
						TppMission.UpdateObjective{
							objectives = { "ClearTask_GetContainer" },
						}
					end
				end
			},

			{
				msg = "RoutePoint2",
				sender = SUB_TARGET_ENEMY_NAME,
				func = function (gameObjectId, routeId ,routeNode, messageId )
					Fox.Log("VIP MOVE ROUND")
					if messageId == StrCode32("Sub_Vip_Arrived") then
						this.SetVipRoute( "rts_talk01_vip","rts_talk01_subvip" )
						svars.isEnemyVIPUnite = true
					
					elseif messageId == StrCode32("rts_sub_vip_c_0000_arrived") then
						this.SetRestrictNotice( SUB_TARGET_ENEMY_NAME, false )

					elseif messageId == StrCode32("Kari_EnemyHeliRide") then
						TppEnemy.SetSneakRoute( SUB_TARGET_ENEMY_NAME, "rts_vip_0005_kari01" )
						TppEnemy.SetCautionRoute( SUB_TARGET_ENEMY_NAME, "rts_vip_0005_kari01" )
						TppEnemy.SetAlertRoute( SUB_TARGET_ENEMY_NAME, "rts_vip_0005_kari01" )
					else
						Fox.Log("End")
					end
				end
			},

			{
				msg = "RoutePoint2",
				sender = TARGET_ENEMY_NAME,
				func = function (gameObjectId, routeId ,routeNode, messageId )
					Fox.Log("VIP MOVE ROUND")
					
					if messageId == StrCode32("Conv01_Start") then
						s10121_radio.SpeechAtMeeting()
					
					elseif messageId == StrCode32("rts_vip_c_0000_arrived") then
						this.SetRestrictNotice( TARGET_ENEMY_NAME, false )
					
					elseif messageId == StrCode32("markerDisable") then
						TppMarker.Disable( "10121_marker_Leader" )
						
						TppEnemy.SetSneakRoute( WG_RIDER_03,"rts_walkergear_0002_2" )
						TppEnemy.SetSneakRoute( WG_RIDER_04,"rts_walkergear_0003_2" )
						if( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == false ) and ( TppMarker.GetSearchTargetIsFound( SUB_TARGET_ENEMY_NAME ) == false )then
							s10121_radio.MarkerUnavailable()
						elseif( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == false ) and ( TppMarker.GetSearchTargetIsFound( SUB_TARGET_ENEMY_NAME ) == true )then
							s10121_radio.InspactionStarted()
						else
							Fox.Log(" ### nothing to say ### ")
						end
						svars.isEnemyVipStartInspection = true
					
					elseif messageId == StrCode32("vip_route_0000_End") then
						this.SetVipRoute( "rts_talk02_vip","rts_talk02_subvip" )
						s10121_enemy.SetRelativeVehicle( TARGET_ENEMY_NAME,"TppVehicleLocator0001")
						s10121_enemy.SetRelativeVehicle( SUB_TARGET_ENEMY_NAME,"TppVehicleLocator0001")

					
					elseif messageId == StrCode32("Conv02_Start") then
						s10121_radio.SpeechAtFirstDock()

					
					elseif messageId == StrCode32("vip_route_0001_End") then
						this.SetVipRoute( "rts_talk03_vip","rts_talk03_subvip" )

					
					elseif messageId == StrCode32("Conv03_Start") then
						s10121_radio.SpeechAtNextDock()

					
					elseif messageId == StrCode32("vip_route_0002_End") then
						this.SetVipRoute( "rts_vip_0003","rts_vip_0003" )
					
					elseif messageId == StrCode32("vip_route_0003_End") then
						this.SetVipRoute( "rts_talk04_vip","rts_talk04_subvip" )
						this.SetEnemyHeliRoute ("enemyHeli02_come")
						this.HeliRestrictNotice()
						this.SetEnemyHeliCautionRoute("enemyHeli02_come")
						this.SetEnemyHeliAlertRoute("enemyHeli02_come")
						s10121_radio.EnemyHeliComing()
						TppRadio.SetOptionalRadio( "Set_s0121_oprg0050" )
						TppSound.SetPhaseBGM("bgm_chase_phase")
					
					elseif messageId == StrCode32("Conv04_Start") then
						s10121_radio.SpeechEndInspection()
					
					elseif messageId == StrCode32("Kari_EnemyHeliRide") then
						TppEnemy.SetSneakRoute( TARGET_ENEMY_NAME, "rts_vip_0005_kari00" )
						TppEnemy.SetCautionRoute( TARGET_ENEMY_NAME, "rts_vip_0005_kari00" ) 
						TppEnemy.SetAlertRoute( TARGET_ENEMY_NAME, "rts_vip_0005_kari00" )	 

						TppEnemy.SetSneakRoute( SUB_TARGET_ENEMY_NAME, "rts_vip_0005_kari01" )
						TppEnemy.SetCautionRoute( SUB_TARGET_ENEMY_NAME, "rts_vip_0005_kari01" ) 
						TppEnemy.SetAlertRoute( SUB_TARGET_ENEMY_NAME, "rts_vip_0005_kari01" )	 

					elseif messageId == StrCode32("Vip_StartEscaping") then
						s10121_radio.TargetEvacuating()
						s10121_enemy.SetRelativeVehicle( TARGET_ENEMY_NAME,"TppVehicleLocator0002")
						TppRadio.SetOptionalRadio( "Set_s0121_oprg0060" )

					elseif messageId == StrCode32("Kari_vip_evacuated") then
						TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_ESCAPE, TppDefine.GAME_OVER_RADIO.OTHERS )

					elseif messageId == StrCode32("WG_Shift02") then
						TppEnemy.SetSneakRoute( WG_RIDER_04,"rts_walkergear_0003" )

					elseif messageId == StrCode32("WG_Shift03") then
						TppEnemy.SetSneakRoute( WG_RIDER_01,"rts_walkergear_0000_3" )
						TppEnemy.SetSneakRoute( WG_RIDER_02,"rts_walkergear_0001_2" )

					elseif messageId == StrCode32("WG_Shift04") then
						TppEnemy.SetSneakRoute( WG_RIDER_01,"rts_walkergear_0000_2" )
						TppEnemy.SetSneakRoute( WG_RIDER_02,"rts_walkergear_0001" )
					end
				end
			},

			{
				msg = "GetInEnemyHeli",
				func = function( gameObjectId )
					Fox.Log(" ### GetInEnemyHeli ### ")
					if gameObjectId == GameObject.GetGameObjectId( TARGET_ENEMY_NAME ) then
						Fox.Log(" ### TARGET GET IN HELI ### ")
						svars.sub_Flag_0010 = svars.sub_Flag_0010 + 1
						s10121_radio.EnemyHeliRidden()
						svars.sub_Flag_0004 = true
					end

					if gameObjectId == GameObject.GetGameObjectId( SUB_TARGET_ENEMY_NAME ) then
						if svars.isEnemyHeliArrived == true then
							Fox.Log(" ### SUB TARGET GET IN HELI ### ")
							svars.sub_Flag_0010 = svars.sub_Flag_0010 + 1
							svars.sub_Flag_0005 = true
						end
					end


					if svars.sub_Flag_0010 == 2 then
						svars.sub_Flag_0001 = false 
						svars.sub_Flag_0002 = true 
						this.SetEnemyHeliRoute ("enemyHeli02_gone")
						this.SetEnemyHeliCautionRoute("enemyHeli02_gone") 
						this.SetEnemyHeliAlertRoute("enemyHeli02_gone") 
					elseif svars.sub_Flag_0010 == 1 then
						GkEventTimerManager.StartRaw( "GetInEnemyHeliLimit", 10 )
					end
				end
			},

			{
				msg = "ConversationEnd",				
				func = function( cpGameObjectId, speechLabel, isSuccess )
					Fox.Log( "this.Messages(): ConversationEnd Message Received. gameObjectId:" ..
						tostring( gameObjectId ) .. ", speechLabel:" .. tostring( speechLabel ) .. ", isSuccess:" .. isSuccess )
					Fox.Log( "### ConversationEnd ###")
					if speechLabel == Fox.StrCode32("speech121_EV010") then
						this.SetVipRoute( "rts_vip_0000","rts_vip_0000" )

					elseif speechLabel == Fox.StrCode32("speech121_EV020") then
						this.SetVipRoute( "rts_vip_0001","rts_vip_0001" )

					elseif speechLabel == Fox.StrCode32("speech121_EV030")then
						this.SetVipRoute( "rts_vip_0002","rts_vip_0002" )

					elseif speechLabel == Fox.StrCode32("speech121_EV040") then
						
						if svars.sub_Flag_0006 == false then
							svars.sub_Flag_0001 = true 
							this.SetVipRoute( "rts_vip_0004","rts_vip_0004" )
							this.SetVipCautionRoute( "rts_vip_c_0004" )
							this.SetVipAlertRoute( "rts_vip_c_0004" )
							s10121_radio.EnemyHeliRiding()
						
						else
							
							this.SetVipRoute( "rts_vip_c_0000","rts_sub_vip_c_0000" )
							TppEnemy.SetCautionRoute( TARGET_ENEMY_NAME, "rts_vip_c_0000" )
							TppEnemy.SetCautionRoute( SUB_TARGET_ENEMY_NAME, "rts_sub_vip_c_0000" )
						end
						this.OffHighInterrogation()
					else
						Fox.Log(" ### ConversationEnd with Unknown speechLabel ### ")
					end	
				end
			},

			{
				msg = "RoutePoint2",
				sender = "sol_pfCamp_0012",
				func = function (gameObjectId, routeId ,routeNode, messageId )
					local SoldierId = "sol_pfCamp_0012"
					if messageId == StrCode32("rts_vehicle_0000_End") then
						TppEnemy.SetSneakRoute( SoldierId, "rts_vehicle_0001" )
						s10121_enemy.SetRelativeVehicle( SoldierId,"TppVehicleLocator0000")

					elseif messageId == StrCode32("rts_vehicle_0001_End") then
						TppEnemy.SetSneakRoute( SoldierId, "rts_vehicle_0002" )
						TppEnemy.SetCautionRoute( SoldierId, "rts_vehicle_0002" )

					elseif messageId == StrCode32("rts_vehicle_0002_End") then
						TppEnemy.SetSneakRoute( SoldierId, "rts_vehicle_0003" )
						TppEnemy.UnsetCautionRoute( SoldierId,"rts_vehicle_0002" )
						s10121_enemy.SetRelativeVehicle( SoldierId,"TppVehicleLocator0000")

					elseif messageId == StrCode32("rts_vehicle_0003_End") then
						TppEnemy.SetSneakRoute( SoldierId, "rts_vehicle_0004" )
						TppEnemy.SetCautionRoute( SoldierId, "rts_vehicle_0004" )

					elseif messageId == StrCode32("rts_vehicle_0004_End") then
						TppEnemy.SetSneakRoute( SoldierId, "rts_vehicle_0005" )
						TppEnemy.UnsetCautionRoute( SoldierId,"rts_vehicle_0004" )

					elseif messageId == StrCode32("rts_vehicle_0005_End") then
						TppEnemy.SetSneakRoute( SoldierId, "rts_vehicle_0000" )

					end
				end
			},

			{
				msg = "RoutePoint2",
				sender = "EnemyHeli",
				func = function (gameObjectId, routeId ,routeNode, messageId )
					Fox.Log("EnemyHeliMove")
					if messageId == StrCode32("EnemyHeli01Coming") then
						s10121_radio.EnemyHeliStart()

					elseif messageId == StrCode32("enemyHelireturn") then
						s10121_radio.EnemyHeliReturn()
						TppMission.UpdateObjective{
							objectives = { "default_subGoal_RejectCFA",},
						}

					elseif messageId == StrCode32("enemyHeli01_return_End") then
						this.VanishEnemyHeli ()	

					elseif messageId == StrCode32("sinpersSalute") then
						TppEnemy.SetSneakRoute( SNIPER_01,"rts_pfCamp_snp_0000_greeting" )
						TppEnemy.SetSneakRoute( SNIPER_02,"rts_pfCamp_snp_0001_greeting" )

					elseif messageId == StrCode32("EnemyHeli01Landing") then
						s10121_radio.VisiterArrived()
						svars.isEnemyHeliArrived = true
						this.UnsetEnemyHeliCautionRoute ()
						this.UnsetEnemyHeliAlertRoute ()

					elseif messageId == StrCode32("EnemyHeli01Arrived") then
						this.SetEnemyHeliRoute ("enemyHeli01_gone")
						TppEnemy.SetSneakRoute( SUB_TARGET_ENEMY_NAME, "rts_sub_vip_0000" )		
						TppEnemy.SetCautionRoute( SUB_TARGET_ENEMY_NAME, "rts_sub_vip_c_0000" )		
						TppEnemy.UnsetAlertRoute( SUB_TARGET_ENEMY_NAME )
						GkEventTimerManager.StartRaw( "UniteLimit", 120 )

					elseif messageId == StrCode32("enemyHeli01_gone_End") then
						this.SetEnemyHeliRoute ("enemyHeli01_Search")
						s10121_radio.EnemyHeliJoinGuard()
						TppEnemy.SetSneakRoute( SNIPER_01,"rts_pfCamp_snp_0000" )
						TppEnemy.SetSneakRoute( SNIPER_02,"rts_pfCamp_snp_0001" )

					elseif messageId == StrCode32("EnemyHeli02Arrived") then
						svars.isEnemyVIPRideHeli = true

					elseif messageId == StrCode32("EnemyHeliEscaped") then
						if ( svars.sub_Flag_0004 == true ) then
							TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_ESCAPE_BY_HELI,TppDefine.GAME_OVER_RADIO.OTHERS )
						end
					end
				end
			},

			{
				msg = "LostControl",
				sender = "EnemyHeli",
				func = function( arg0 , state )
				Fox.Log(" ### LostControl ### ")
					if (state == StrCode32("End") ) then
						this.HeliItemDrop()	
						svars.enemyHeliState = ENEMY_HELI_STATE.LOST_CONTROL_END	
					elseif ( state == StrCode32("Start") ) then
						if ( svars.sub_Flag_0001 == true ) then
							TppEnemy.SetCautionRoute( TARGET_ENEMY_NAME,"rts_vip_c_0000" )
							TppEnemy.SetCautionRoute( SUB_TARGET_ENEMY_NAME,"rts_vip_c_0000" )
							TppEnemy.UnsetAlertRoute( TARGET_ENEMY_NAME )
							TppEnemy.UnsetAlertRoute(SUB_TARGET_ENEMY_NAME )
						end
						TppEnemy.SetSneakRoute( SNIPER_01,"rts_pfCamp_snp_0000" )
						TppEnemy.SetSneakRoute( SNIPER_02,"rts_pfCamp_snp_0001" )
						svars.enemyHeliState = ENEMY_HELI_STATE.LOST_CONTROL_START	
						svars.sub_Flag_0006 = true 
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






sequences.Seq_Game_MainGame = {
	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{
					msg = "ChangePhase",
					sender = "mafr_pfCamp_cp",
					func = function ( GameObjectId, phaseName )
						this.OffHighInterrogation()
						
						if ( phaseName ~= TppEnemy.PHASE.SNEAK and svars.isEnemyHeliStart == false and svars.isEnemyHeliArrived == false ) then
							this.CallCpRadio("CPR0560") 
						
						elseif ( phaseName ~= TppEnemy.PHASE.SNEAK and svars.isEnemyHeliStart == true and svars.isEnemyHeliArrived == false ) then
							this.CallCpRadio("CPR0560") 
							svars.isEnemyHeliReturn = true
							if( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == false ) then
								TppRadio.SetOptionalRadio( "Set_s0121_oprg0040" )
							end
						
						elseif ( phaseName ~= TppEnemy.PHASE.SNEAK and svars.isEnemyHeliArrived == true ) then
							if mvars.CPRadioCounter == nil then
								mvars.CPRadioCounter = 0
							end
							if mvars.CPRadioCounter == 0 then
								mvars.CPRadioCounter = 1
								this.CallCpRadio("CPR0570") 
							elseif mvars.CPRadioCounter == 1 then
								mvars.CPRadioCounter = 2
								this.CallCpRadio("CPR0560") 
							else
								Fox.Log("### Nothing To Say ###")
							end
						else
							Fox.Log( "### Change Phase ###" )
						end

						if ( phaseName == TppEnemy.PHASE.CAUTION )then
							this.SetRestrictNotice( TARGET_ENEMY_NAME, true )
							this.SetRestrictNotice( SUB_TARGET_ENEMY_NAME, true )
						else
							this.SetRestrictNotice( TARGET_ENEMY_NAME, false )
							this.SetRestrictNotice( SUB_TARGET_ENEMY_NAME, false )
						end

						if ( phaseName ~= TppEnemy.PHASE.SNEAK )then
							if( TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == true ) then
								TppRadio.ChangeIntelRadio( s10121_radio.intelRadioList_FoundTarget )
							end

							if( TppMarker.GetSearchTargetIsFound( SUB_TARGET_ENEMY_NAME ) == true )then
								TppRadio.ChangeIntelRadio( s10121_radio.intelRadioList_FoundSubTargetAfterVipFound )
							end
						end
					end
				},
			}
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
			TppCoder.SetWorldCenter(Vector3(1135.1866, -11.809448, 1165.9508))
		end

		this.ContinueMission()
		TppTelop.StartCastTelop()
		
		if svars.enemyHeliState == ENEMY_HELI_STATE.LOST_CONTROL_START then
			this.HeliItemDrop( DEV_DOC_POSITION_FOR_CONTINUE )
		end
	end,
	
	OnLeavesso = function ()
	end,
}

sequences.Seq_Game_Escape = {

	OnEnter = function()
		TppMission.CanMissionClear()
		this.OffHighInterrogation()
		TppMission.UpdateObjective{
			radio = {
				radioGroups = { "f1000_rtrg1375" },	
			},
			objectives = { "default_subGoal_Escape" },
		}
		TppRadio.SetOptionalRadio( "Set_s0121_oprg0100" )

		if ( svars.sub_Flag_0000 == true and svars.sub_Flag_0003 == true ) then
			TppStory.FailedRetakeThePlatformIfOpened()
			TppRadio.Play( "f1000_rtrg1030", { isEnqueue = true, delayTime = 1.0 } )
			svars.sub_Flag_0000 = false
		end
	end,
}




return this