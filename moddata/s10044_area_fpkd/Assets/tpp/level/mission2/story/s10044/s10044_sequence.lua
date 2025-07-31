local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}





local CONVOY_NUM = 2
local SUPPORT_HELI 			= "SupportHeli"

local TARGET_SENSHA = {
	FRONT = "veh_sensha",
	BACK = "veh_sensha0000",
}


this.MAX_PLACED_LOCATOR_COUNT = 22





this.missionTask_4_bonus_TARGET_LIST = {		
	"sol_enemyNorth_lvVIP",
}

this.missionTask_6_TARGET_LIST = {		
	"hos_s10044_0000",
}

this.missionTask_7_TARGET_LIST = {		
	"veh_sensha",
	"veh_sensha0000",
}

this.specialBonus = {
	first = {
		missionTask = { taskNo=4 },
	},
	second = {
		missionTask = { taskNo=5 },
	}
}






this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true





function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		"Seq_Game_Information",
		"Seq_Game_Convoy",
		"Seq_Game_Escape",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	isOnGetIntel = false,		
	isStartConvoy = false,		
	isStartCarRadio = false,	
	isVIPKilled = false,
	isDestroyedConvoy = false,	
	DestroyedConvoyNum = 0,		
	isInsideVIPRoom = false,	
	isConvoyReachedEnd = false,  
	isConvoyMustNotStop = false, 
	isConvoyOnFinalRoute = false, 
	isTruckBroken = false,
	
	isConvoyArrivedFort = false,		
	
	UniqueInterCount_FarPoint = 0,
	UniqueInterCount_NearPoint = 0,
	
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
	CountMinuteNum			= 0,
	CountMinute02Num		= 0,
	CountTaskList01Num		= 0,
	CountTaskList02Num		= 0,
	CountTaskList03Num		= 0,
	CountTaskList04Num		= 0,
	CountTaskList05Num		= 0,
	CountTaskList04Num		= 0,
	CountTaskList06Num		= 0,
	CountEnvent01Num		= 0,			
	CountEnvent02Num		= 0,
	CountEnvent03Num		= 0,
	CountEnvent03Num		= 0,
	isVipMarked = false,
	isCarryRPG = false,
}


this.checkPointList = {
	"CHK_CliffTown",
	nil
}

this.baseList = {
	
	"fort",
	"cliffTown",
	
	"cliffEast",
	"cliffWest",
	"enemyNorth",
	"fortSouth",
	"fortWest",
	nil
}




this.missionObjectiveDefine = {
	area_Intel_get = {},
	area_Intel = {
		gameObjectName = "s10044_marker_Intel",
	},
	default_area_clifftown = {
		gameObjectName = "s10044_marker_information",
		viewType = "all",
		visibleArea = 6,
		randomRange = 0,
		mapRadioName = "s0044_mprg0010",
		setNew = false,
		langId = "marker_information",	
		announceLog = "updateMap",
	},
	default_area_clifftown_convoy = {
		gameObjectName = "veh_sensha",
		viewType = "map_and_world_only_icon",
		setNew = false,
		goalType = "moving",
		setImportant = true,
		announceLog = "updateMap",
		mapRadioName = "f1000_mprg0100",
		langId = "marker_info_mission_target",	
	},
	default_area_clifftown_convoy2 = {
		gameObjectName = "veh_sensha0000",
		viewType = "map_and_world_only_icon",
		setNew = false,
		goalType = "moving",
		setImportant = true,
		announceLog = "updateMap",
		mapRadioName = "f1000_mprg0100",
		langId = "marker_info_mission_target",	
	},
	default_area_clifftown_VIP = {
		gameObjectName = "sol_enemyNorth_lvVIP",
		viewType = "map_and_world_only_icon",
		setNew = false, goalType = "moving",
		setImportant = true,
		mapRadioName = "f1000_mprg0100",
		langId = "marker_info_mission_target",	
		announceLog = "updateMap",
	},
	default_photo_vip = {
		photoId	= 10, addFirst = true,
		photoRadioName = "s0044_mirg0010",
	
	},
	hud_photo_vip = {
		hudPhotoId = 10
	},
	marker_hostage = {
		gameObjectName = this.missionTask_6_TARGET_LIST[1],
		goalType = "moving",viewType="map_and_world_only_icon",
		setNew = true, setImportant = false,
		langId = "marker_hostage",
		announceLog = "updateMap",
	},
	marker_battleVehicle = {
		gameObjectName = "veh_wheeledarmored",
		viewType="map_and_world_only_icon",
		setNew = true, setImportant = false,
		langId = "marker_info_APC",
		announceLog = "updateMap",
	},
	marker_infomation_jinmon = {
		gameObjectName = "s10044_marker_information_jinmon",
		viewType = "all",
		visibleArea = 1,
		randomRange = 0,
		setNew = true,
		langId = "marker_information",	
		announceLog = "updateMap",
	},
	complete_sensha_vip = {
		photoId	= 10,
		addFirst = true,
	},
	ShowEnemyRoute = {
		showEnemyRoutePoints = { groupIndex=0, width=200.0, langId="marker_target_forecast_path",
		radioGroupName = "s0044_mprg0040",		
			points={
				Vector3( 2142.2,0.0,-1717.9 ),
				Vector3( 2214.7,0.0,-1554.1 ), Vector3( 1961.4,0.0,-1475.9 ), Vector3( 1828.6,0.0,-1246.9 ),
				Vector3( 1278.3,0.0,-1322.6 ), Vector3( 832.0,0.0,-1347.5 ), Vector3( 711.3,0.0,-1053.1 ),
				Vector3( 516.4,0.0,-900.9 ), Vector3( 219.1,0.0,-961.9 ), Vector3( -166.7,0.0,-449.3 ),
			} ,
		},
	},
	
	All_Clear = {
	},
	subGoal_GetIntel = {	
		subGoalId= 0,
	},
	subGoal_EliminateAllTargets = {			
		subGoalId= 1,
	},
	subGoal_Escape = {	
		subGoalId= 4,
	},

	
	missionTask_1_GetIntel01 = {	
		missionTask = { taskNo=0, isComplete=false },
	},
	missionTask_1_GetIntel01_clear = {			
		missionTask = { taskNo=0, isNew=true, isComplete=true },
	},
	missionTask_2_EliminateVIP = {	
		missionTask = { taskNo=2, isComplete=false },
	},
	missionTask_2_EliminateVIP_clear = {		
		missionTask = { taskNo=2, isNew=true, isComplete=true },
	},
	missionTask_3_EliminateTanks = {	
		missionTask = { taskNo=3, isComplete=false },
	},
	missionTask_3_EliminateTanks_clear = {				
		missionTask = { taskNo=3, isNew=true, isComplete=true },
	},

	missionTask_4_bonus_RecoverVIP = {	
		missionTask = { taskNo=4, isComplete=false, isFirstHide=true },
	},
	missionTask_4_bonus_RecoverVIP_clear = {		
		missionTask = { taskNo=4, isNew=true },
	},
	missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort = {	
		missionTask = { taskNo=5, isComplete=false, isFirstHide=true },
	},
	missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort_clear = {		
		missionTask = { taskNo=5, isNew=true },
	},

	missionTask_6_RecoverHostage = {	
		missionTask = { taskNo=6, isComplete=false, isFirstHide=true },
	},
	missionTask_6_RecoverHostage_clear = {
		missionTask = { taskNo=6, isNew=true, isComplete=true },
	},
	missionTask_7_RecoverAllTanks = {	
		missionTask = { taskNo=7, isComplete=false, isFirstHide=true },
	},
	missionTask_7_RecoverAllTanks_clear = {
		missionTask = { taskNo=7, isNew=true, isComplete=true },
	},

	
	
	announce_RecoverVIP = {
		announceLog = "recoverTarget",
	},
	
	announce_EliminateVIP = {
		announceLog = "eliminateTarget",
	},
	
	announce_RecoverSensha = {
		announceLog = "recoverTarget",
	},
	
	announce_DestroySensha = {
		announceLog = "destroyTarget",
	},
	
	announce_rescue_all = {
		announceLog = "achieveAllObjectives",
	}
}

this.missionObjectiveTree = {
	All_Clear = {
		area_Intel_get = {
			area_Intel = {},
			marker_infomation_jinmon = {
				default_area_clifftown = {},
			},
		},
		
		default_area_clifftown_VIP = {
				default_area_clifftown = {},
		},

		default_area_clifftown_convoy2 = {
				default_area_clifftown = {},
		},

		default_area_clifftown_convoy = {
				default_area_clifftown = {},
		},
	},
	default_photo_vip = {},
	complete_sensha_vip = {},
	
	ShowEnemyRoute = {
	},
	
	subGoal_Escape ={
		subGoal_EliminateAllTargets = {
							subGoal_GetIntel ={},
		},
	},
	
	missionTask_1_GetIntel01_clear = {
		missionTask_1_GetIntel01 ={},
	},
	missionTask_2_EliminateVIP_clear = {
		missionTask_2_EliminateVIP ={},
	},
	missionTask_3_EliminateTanks_clear = {
		missionTask_3_EliminateTanks ={},
	},
	missionTask_4_bonus_RecoverVIP_clear = {
		missionTask_4_bonus_RecoverVIP ={},
	},
	missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort_clear = {
		missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort ={},
	},
	missionTask_6_RecoverHostage_clear = {
		missionTask_6_RecoverHostage ={},
	},
	missionTask_7_RecoverAllTanks_clear = {
		missionTask_7_RecoverAllTanks ={},
	},
	marker_hostage = {},
	marker_battleVehicle = {},
}

this.missionObjectiveEnum = Tpp.Enum{
	"area_Intel_get",
	"area_Intel",
	"default_area_clifftown",
	"default_area_clifftown_convoy",
	"default_area_clifftown_convoy2",
	"default_area_clifftown_VIP",
	"default_photo_vip",
	"hud_photo_vip",
	"complete_sensha_vip",
	"ShowEnemyRoute",
	"All_Clear",
	
	"subGoal_GetIntel",
	"subGoal_EliminateAllTargets",
	"subGoal_Escape",
	
	"missionTask_1_GetIntel01",
	"missionTask_1_GetIntel01_clear",
	"missionTask_2_EliminateVIP",
	"missionTask_2_EliminateVIP_clear",
	"missionTask_3_EliminateTanks",
	"missionTask_3_EliminateTanks_clear",

	"missionTask_4_bonus_RecoverVIP",
	"missionTask_4_bonus_RecoverVIP_clear",
	"missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort",
	"missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort_clear",

	"missionTask_6_RecoverHostage",
	"missionTask_6_RecoverHostage_clear",
	"missionTask_7_RecoverAllTanks",
	"missionTask_7_RecoverAllTanks_clear",

	"announce_RecoverVIP",
	"announce_EliminateVIP",
	"announce_RecoverSensha",
	"announce_DestroySensha",
	"announce_rescue_all",

	"marker_hostage",
	"marker_battleVehicle",
	"marker_infomation_jinmon",
}

this.missionStartPosition = {
	helicopterRouteList = {
		"lz_drp_cliffTown_N0000|rt_drp_clifftown_N_0000",
		"lz_drp_cliffTown_S0000|rt_drp_cliffTown_S_0000",
	},
	orderBoxList = {
		"box_s10044_00",
		"box_s10044_01",
	},
}





function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()

		
	TppPlayer.AddTrapSettingForIntel{
		intelName	= "Intel_showConvoy",
		autoIcon = true,
		identifierName = "GetIntelIdentifier",
		locatorName = "GetIntel_showConvoy",
		gotFlagName = "isOnGetIntel",
		trapName	= "trap_GetIntel_showConvoy",
		markerObjectiveName = "area_Intel",
		markerTrapName = "trap_IntelHouse",
	}

	
	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "_openingDemo" },
	}

	
	TppMarker.SetUpSearchTarget{
		{
			gameObjectName = "sol_enemyNorth_lvVIP",
			gameObjectType = "TppSoldier2",
			messageName = "sol_enemyNorth_lvVIP",
			skeletonName = "SKL_004_HEAD",
			offSet = Vector3(0,0,0),
			func = this.TargetVIPFound,
			objectives = { "hud_photo_vip" }
		},
		{
			gameObjectName = TARGET_SENSHA.FRONT,
			gameObjectType = "TppVehicle2",
			messageName = TARGET_SENSHA.FRONT,
			offSet = Vector3(0,1.5,-0.25),
			doDirectionCheck = false,
			func = function ()
				Fox.Log("###YELLOW TargetTankFound veh_sensha###")
				s10044_radio.PlayTargetTank01Identified()
				TppMission.UpdateObjective{
					objectives = { "default_area_clifftown_convoy" }
				}
			end
		},
		{
			gameObjectName = TARGET_SENSHA.BACK,
			gameObjectType = "TppVehicle2",
			messageName = TARGET_SENSHA.BACK,
			offSet = Vector3(0,1.5,-0.25),
			doDirectionCheck = false,
			func = function ()
				Fox.Log("###YELLOW TargetTankFound veh_sensha0000###")
				s10044_radio.PlayTargetTank02Identified()
				TppMission.UpdateObjective{
					objectives = { "default_area_clifftown_convoy2" }
				}
			end
		},
	}

	
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppEagle" )

	TppMission.RegisterMissionSystemCallback{
		OnEstablishMissionClear = function( missionClearType )
			
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

			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_4_bonus_TARGET_LIST ) then
				Fox.Log("##** VIP is being Extracting ####")
				
				this.VIPEliminateFunc()
				this.InsertcliffTownVipHudPhoto()
				
				
				TppMission.UpdateObjective{
					objectives = { "announce_RecoverVIP" },		
				}
				
				
				svars.CountEnvent01Num = svars.CountEnvent01Num + 1
				TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.CountEnvent01Num, 3 )
				
				TppMission.UpdateObjective{
					objectives = { "missionTask_4_bonus_RecoverVIP_clear" },
				}
				TppMission.UpdateObjective{
					objectives = { "missionTask_2_EliminateVIP_clear" },
				}
				TppResult.AcquireSpecialBonus{ first = { isComplete = true,},}	
				
				this.bonus5check()

			end

			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_6_TARGET_LIST ) then
				
				TppMission.UpdateObjective{
					objectives = { "missionTask_6_RecoverHostage_clear" },
				}
			end

			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_7_TARGET_LIST ) then
				local count = this.CountRecoveredMissionTask7( this.missionTask_7_TARGET_LIST )
				Fox.Log("##** Sensha is being Extracting ####")
				if count == 1 then
					
					s10044_radio.PlayFultonTank()
				end

				this.TankEliminateFunc(gameObjectId)
				
				
				TppMission.UpdateObjective{
					objectives = { "announce_RecoverSensha" },		
				}
				
				svars.CountEnvent01Num = svars.CountEnvent01Num + 1
				TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.CountEnvent01Num, 3 )
			
				
				this.UIUpdatesforMissionTask7( count )

				this.bonus5check()
			end

		end,

		
		CheckMissionClearFunction = function()
				return TppEnemy.CheckAllTargetClear()
		end,
	}
end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
end





function this.Messages()
	return
	StrCode32Table {
		Marker = {
			{
				msg = "ChangeToEnable", sender = TARGET_SENSHA.FRONT,		
				func = function( instanceName, makerType, s_gameObjectId, identificationCode )
					if identificationCode == Fox.StrCode32("Player") then
						Fox.Log("****1st Sensha is Marked****")
					else
						Fox.Log("###NoPlayersensha###")
					end
				end
			},
			{
				msg = "ChangeToEnable", sender = TARGET_SENSHA.BACK,			
				func = function( instanceName, makerType, s_gameObjectId, identificationCode )
					if identificationCode == Fox.StrCode32("Player") then
						Fox.Log("****2nd Sensha is Marked****")
					else
						Fox.Log("###NoPlayersensha0000###")
					end
				end
			},
		},
		Player = {
			{
				
				msg = "GetIntel",
				sender = "Intel_showConvoy",
				func = function( intelNameHash )
					this.FuncGetIntel( intelNameHash )
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
		GameObject = {
			{
				msg = "RoutePoint2", sender = { "sol_enemyNorth_sensha", "sol_enemyNorth_sensha0000", "sol_enemyNorth_lvVIP" },
				func = function (gameObjectId, routeId ,routeNode, messageId )
					if messageId == StrCode32("ConvoyArrivedFort") then
						Fox.Log("message: ConvoyArrivedFort")
						
						if gameObjectId == GameObject.GetGameObjectId("TppSoldier2", "sol_enemyNorth_lvVIP") then
								Fox.Log("##**VipArrivedFort")
								if	(svars.isConvoyArrivedFort	==	false)	and		(svars.isDestroyedConvoy == true )	then	
									Fox.Log("##**OnlyVipArrivedFort")
									svars.isConvoyArrivedFort		=	true		
									s10044_radio.PlayOnlyVipArrivedFort()			
									
									TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0040" )
									TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0050" )


								elseif	(svars.isConvoyArrivedFort	==	false)	and		(svars.isDestroyedConvoy == false )	then
									svars.isConvoyArrivedFort		=	true		
									s10044_radio.PlayTargetsArrivedFort()			
									
									TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0040" )
									TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0050" )

								else
									Fox.Log("ConvoyAlreadyArrivedFort_NoNeed_FlagChange&Radio")
								end

						
						elseif gameObjectId == GameObject.GetGameObjectId("TppSoldier2", "sol_enemyNorth_sensha") then
								Fox.Log("##**Shensha_ArrivedFort")
								if	svars.isConvoyArrivedFort	==	false	then
									svars.isConvoyArrivedFort		=	true		
									s10044_radio.PlayTargetsArrivedFort()			
									
									TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0040" )
									TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0050" )
								else
									Fox.Log("ConvoyAlreadyArrivedFort_NoNeed_FlagChange&Radio")
								end
								TppUiCommand.InitAllEnemyRoutePoints()
								this.AfterConvoyArrivedFortSensha()

						
						elseif gameObjectId == GameObject.GetGameObjectId("TppSoldier2", "sol_enemyNorth_sensha0000") then
								Fox.Log("##**Shensha0000_ArrivedFort")
								if	svars.isConvoyArrivedFort	==	false	then
									svars.isConvoyArrivedFort		=	true		
									s10044_radio.PlayTargetsArrivedFort()			
									
									TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0040" )
									TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0050" )
								else
									Fox.Log("ConvoyAlreadyArrivedFort_NoNeed_FlagChange&Radio")
								end
								TppUiCommand.InitAllEnemyRoutePoints()
								this.AfterConvoyArrivedFortSensha0000()
						else
							Fox.Log("##**Impossible!Who?!ArrivedFort?!")
						end

					elseif messageId == StrCode32("JoinCP") then
							if gameObjectId == GameObject.GetGameObjectId("TppSoldier2", "sol_enemyNorth_lvVIP") then
								Fox.Log("message: VipJoinCP")
								TppUiCommand.InitAllEnemyRoutePoints()
								this.JoinCPFort()
							else
							end
					else
						Fox.Log("OtherMessages_from_Convoy")
					end
				end
			},
			{
				msg = "RoutePoint2", sender = { "sol_enemyNorth_lv0000" },		
				func = function (gameObjectId, routeId ,routeNode, messageId )
					if messageId == StrCode32("JoinCP") then
						Fox.Log("message: JoinCP")
						TppUiCommand.InitAllEnemyRoutePoints()
						this.JoinCPFort()
					else
						Fox.Log("OtherMessages_from_Truck_vips")
					end
				end
			},
			{	msg = "Dead",
				func = function (nGameObjectId)
					if nGameObjectId == GameObject.GetGameObjectId("TppSoldier2", "sol_enemyNorth_lvVIP") then
						
						TppMission.UpdateObjective{
							objectives = { "announce_EliminateVIP" },		
						}
						
						svars.CountEnvent01Num = svars.CountEnvent01Num + 1
						TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.CountEnvent01Num, 3 )

						this.VIPEliminateFunc()
						this.InsertcliffTownVipHudPhoto()

						
						TppMission.UpdateObjective{
							objectives = { "missionTask_2_EliminateVIP_clear" }
						}

						this.bonus5check()
					else
						Fox.Log("non Vip")
					end
				end
			},
			



















			{	msg = "FultonFailedEnd",
				func = function(nGameObjectId,arg1,arg2,failureType)
					if (failureType ~= TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE) then
						
						return
					end
					
					if nGameObjectId == GameObject.GetGameObjectId("TppSoldier2", "sol_enemyNorth_lvVIP") then
						Fox.Log("FultonFail_On_Vip")
						s10044_radio.PlayTargetFultonFailed()
						this.VIPEliminateFunc()
						this.InsertcliffTownVipHudPhoto()

					elseif nGameObjectId ==  GameObject.GetGameObjectId("veh_sensha") or
						nGameObjectId ==  GameObject.GetGameObjectId("veh_sensha0000") then 	
						Fox.Log("FultonFail_On_Sensha")
						this.TankEliminateFunc(nGameObjectId)
						s10044_radio.PlayTargetFultonFailed()
					else
						Fox.Log("FultonFail_On_others")
					end
				end
			},
			{	msg = "PlacedIntoVehicle",
				func = function (nGameObjectId,arg2)
					if nGameObjectId == GameObject.GetGameObjectId("TppSoldier2", "sol_enemyNorth_lvVIP") and
					 svars.DestroyedConvoyNum >= CONVOY_NUM and
					 arg2 == GameObject.GetGameObjectId( SUPPORT_HELI ) then
						TppSequence.SetNextSequence("Seq_Game_Escape")
					end
				end
			},
			{	msg = "NoticeVehicleInvalid ",
				func = function (label)
					s10044_enemy.Escort(label)
				end
			},
			{	msg = "VehicleBroken",
				func = function(vid,brokenState)
					local strEnd = StrCode32("End")
					if vid ==  GameObject.GetGameObjectId("veh_sensha") or vid ==  GameObject.GetGameObjectId("veh_sensha0000") then
						Fox.Log("Target tanks destoryed!!!")
						if brokenState == strEnd then
							
							TppMission.UpdateObjective{
								objectives = { "announce_DestroySensha" },		
							}
							
							svars.CountEnvent01Num = svars.CountEnvent01Num + 1
							
							TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.CountEnvent01Num, 3 )
							
							if vid ==  GameObject.GetGameObjectId("veh_sensha") then
								Player.RemoveSearchTarget( TARGET_SENSHA.FRONT )
								Fox.Log("******RemoveSearchTargetsensha******")
							elseif vid ==  GameObject.GetGameObjectId("veh_sensha0000") then
								Player.RemoveSearchTarget( TARGET_SENSHA.BACK )
								Fox.Log("******RemoveSearchTargetsensha0000******")
							end
							
							this.TankEliminateFunc(vid)

							this.bonus5check()
						else
						Fox.Log("Wrong Message on VehicleBroken, no count???!!!")
						end
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





this.InsertcliffTownVipHudPhoto = function()
	Fox.Log("###***s10044_enemy.InsertcliffTownVipHudPhoto")
	Fox.Log("###***InsertcliffTownVipHudPhoto")
	if svars.isVipMarked == false then
		Fox.Log("###***NotIdentifyOn_cliffTownVip_Yet_InsertHudPhoto")
		TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
		TppMission.UpdateObjective{ objectives = { "hud_photo_vip" }, }
	else
		Fox.Log("###***cliffTownVip_HasAlreadyIdentified_NoNeedInsertHudPhoto")
	end
end

this.bonus5check = function()
		Fox.Log("bonus5check")
		if svars.CountEnvent01Num == 3 then
			Fox.Log("##** All 3 objectives cleared -> update bonus ####")
				
				if	svars.isConvoyArrivedFort		==	false	then

					Fox.Log("### CLEAR_missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort_clear ###")
					TppMission.UpdateObjective{
						objectives = { "missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort_clear" }
					}
					TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}	

				elseif	svars.isConvoyArrivedFort		==	true 	then

					Fox.Log("### FAIL_ON_missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort_clear ###")
				else
				end
		else
			Fox.Log("##** Tanks still remain ####")
		end
end

this.CheckGetRPG = function( backBlastWeapon )

	local blRetcode = false
	local missionName = TppMission.GetMissionName()

	if backBlastWeapon == true then
		blRetcode = true
	end
	


























	if missionName == "s11044" then
		blRetcode = true
	end

	return blRetcode
end


function this.TargetVIPFound()
	if	svars.isVipMarked == false then			
		Fox.Log("###Vip has not been marked YET, change Flag!###")
		svars.isVipMarked = true
	else
		Fox.Log("###Vip has already been marked###")
	end

	if	svars.isOnGetIntel == false and
		svars.isStartCarRadio == false then

		s10044_radio.PlayTargetIdentifiedWithoutInfo()
	else
		s10044_radio.PlayTargetIdentified()
	end

	
	

	TppMission.UpdateObjective{
		objectives = { "default_area_clifftown_VIP" }
	}
end





















function this.VIPEliminateFunc()
	
	
	Fox.Log("Enter function VIPEliminateFunc")
	if svars.isDestroyedConvoy == true then				
		Fox.Log("######function VIPEliminateFunc######")
		
		
		
		TppSequence.SetNextSequence("Seq_Game_Escape")
	else
		Fox.Log("/////////////function VIPEliminateFunc/////////////")
		
		
		if svars.DestroyedConvoyNum == 1 then
			Fox.Log("******function VIPEliminateFunc******")
			s10044_radio.PlayEliminateTheTank() 
		else				
			Fox.Log("............function VIPEliminateFunc............")
			s10044_radio.PlayEliminatedTarget() 
			s10044_radio.PlayEliminateTheTanks() 
		end
	end
end



this.CheckDestroyedConvoyNum = function(GameObjectId)

	
	if svars.isFlagForA == false and GameObjectId ==  GameObject.GetGameObjectId("veh_sensha") then
		svars.DestroyedConvoyNum = svars.DestroyedConvoyNum + 1
		svars.isFlagForA = true
	end
	
	
	if svars.isFlagForB == false and GameObjectId ==  GameObject.GetGameObjectId("veh_sensha0000") then
		svars.DestroyedConvoyNum = svars.DestroyedConvoyNum + 1
		svars.isFlagForB = true
	end

	
	Fox.Log("DestroyedConvoyNum=="..svars.DestroyedConvoyNum)
end


function this.TankEliminateFunc(GameObjectId)
	
	
	
	
	this.CheckDestroyedConvoyNum(GameObjectId)
	
	Fox.Log("svars.DestroyedConvoyNum = "..tostring(svars.DestroyedConvoyNum) )
		
	local isVipAlreadyEliminated = TppEnemy.IsEliminated("sol_enemyNorth_lvVIP")
	if svars.DestroyedConvoyNum >= CONVOY_NUM then		
		svars.isDestroyedConvoy = true
		
		TppMission.UpdateObjective{
			objectives = { "missionTask_3_EliminateTanks_clear" }
		}
		if isVipAlreadyEliminated == true then
			
			
			
			TppSequence.SetNextSequence("Seq_Game_Escape")
		else
			Fox.Log("******PlayEliminateVIP******")
			s10044_radio.PlayEliminateVIP()
		end
	else											
		if isVipAlreadyEliminated == true then
			s10044_radio.PlayEliminateTheTank()
		else
			s10044_radio.PlayEliminatedTarget()
		end
	end
end

function this.AfterConvoyArrivedFortSensha0000()
		Fox.Log("***set up special route for the sensha0000, second Tank")

		local command = { id = "StartTravel", travelPlan = "" }
		local gameObjectId2 = GameObject.GetGameObjectId( "sol_enemyNorth_sensha0000" )
		GameObject.SendCommand( gameObjectId2, command )
		TppEnemy.UnsetSneakRoute( gameObjectId2 )

		
		TppEnemy.SetSneakRoute( "sol_enemyNorth_sensha0000", "rts_shensha_afterarrivedfort0000" )
		TppEnemy.SetCautionRoute( "sol_enemyNorth_sensha0000", "rts_shensha_afterarrivedfort0000" )
end

function this.AfterConvoyArrivedFortSensha()
		Fox.Log("***set up special route for the sensha first Tank")

		local command = { id = "StartTravel", travelPlan = "" }
		local gameObjectId = GameObject.GetGameObjectId( "sol_enemyNorth_sensha" )
		GameObject.SendCommand( gameObjectId, command )
		TppEnemy.UnsetSneakRoute( gameObjectId )

		
		TppEnemy.SetSneakRoute( "sol_enemyNorth_sensha", "rts_shensha_afterarrivedfort" )
		TppEnemy.SetCautionRoute( "sol_enemyNorth_sensha", "rts_shensha_afterarrivedfort" )
end

function this.JoinCPFort()
		Fox.Log("***set two soldiers to common fort CP")
		

		local command = { id = "StartTravel", travelPlan = "travel_infort" }
		local gameObjectId = GameObject.GetGameObjectId( "sol_enemyNorth_lvVIP" )
		local gameObjectId2 = GameObject.GetGameObjectId( "sol_enemyNorth_lv0000" )
		GameObject.SendCommand( gameObjectId, command )
		GameObject.SendCommand( gameObjectId2, command )
		TppEnemy.UnsetSneakRoute( gameObjectId )
		TppEnemy.UnsetSneakRoute( gameObjectId2 )

		
		

		
		

		TppEnemy.UnsetCautionRoute( "sol_enemyNorth_lv0000" )
		TppEnemy.UnsetCautionRoute( "sol_enemyNorth_lvVIP" )
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


this.CountRecoveredMissionTask7 = function( targetList )
	Fox.Log("##** Count_MissionTask7_number of TANK on the list ####")
	local count = 0
	for i, targetName in ipairs( targetList ) do
		if TppEnemy.IsRecovered( targetName ) then
			count = count + 1
		end
	end
	return count
end


function this.UIUpdatesforMissionTask7( count )
	Fox.Log("***UIUpdatesforMissionTask7")
	if count == 0	then
		Fox.Log("***None_TankRecovered")

	elseif 	count == 1	then
	

	elseif	count == 2	then
		TppMission.UpdateObjective{
			objectives = {"missionTask_7_RecoverAllTanks_clear",},
		}
	else
		Fox.Log("svars.TANKCount_clear is  ... WRONG VALUE !!")
	end
end


function this.FuncGetIntel( intelNameHash )

	Fox.Log("Function intelNameHash intelNameHash intelNameHash")
	TppPlayer.GotIntel( intelNameHash )

	local func = function()

		TppMission.UpdateObjective{
			objectives = {"missionTask_1_GetIntel01_clear",},
		}
		TppRadio.ChangeIntelRadio( s10044_radio.intelRadioListAfterIntelDemo )		

		
		
		if svars.isDestroyedConvoy == false then
			if svars.isStartCarRadio == false then

				

				Fox.Log("Function FuncGetIntel FuncGetIntel FuncGetIntel")

				
				s10044_radio.PlayGetInfo()

				
				TppSequence.SetNextSequence("Seq_Game_Convoy")
				TppCheckPoint.UpdateAtCurrentPosition()
			else
				
				s10044_radio.PlayGetInfo_ButIknow()
				TppCheckPoint.UpdateAtCurrentPosition()
			end
		else
			
			s10044_radio.PlayGetInfo_ButItisWaste()
			TppCheckPoint.UpdateAtCurrentPosition()
		end
	end
		s10044_demo.PlayGetIntel(func)
end






sequences.Seq_Game_Information = {
	Messages = function( self ) 
		return
		StrCode32Table {

			
			Player = {
				{
					msg = "LandingFromHeli",
					func = function()
							local startHeli = TppMission.IsStartFromHelispace()
							Fox.Log("GetRpg "..tostring(svars.isCarryRPG).. "; startHeli"..tostring(startHeli) )

							if ( svars.isCarryRPG == false) and ( startHeli == true ) then
								Fox.Log("HELIDROPSTART Player is NOT carrying a RPG")
								TppRadio.Play("s0044_rtrg0300", {delayTime = 8, isEnqueue = true,})
							else
								Fox.Log("HELIDROPSTART Player is NOT carrying a RPG")
							end
					end
				}
			},
			Trap = {
				{
					
					msg = "Enter", 	sender = "trap_ApproachIntelAtcliffTown_OnAlert",	func = self.FuncApproachIntelAtcliffTown },
				{
					msg = "Enter", 	sender = "trap_ld_0000", func = self.FuncTrap0

				},
				{
					
					msg = "Enter", 	sender = "trap_help0000", func = function()
						svars.isInsideVIPRoom = true
					end
				},
				{
					
					msg = "Exit", 	sender = "trap_help0001", func = self.FuncIntelHelp
				},
			},
		nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		Fox.Log("mission start")

		TppTelop.StartCastTelop()

		TppScriptBlock.LoadDemoBlock("Demo_GetIntel")

		GameObject.SendCommand( { type="TppVehicle2", },
		{
				id						= "RegisterConvoy",
				convoyId		=
				{
						GameObject.GetGameObjectId( "TppVehicle2", "veh_sensha" ),
						GameObject.GetGameObjectId( "TppVehicle2", "veh_truck" ),
						GameObject.GetGameObjectId( "TppVehicle2", "veh_sensha0000" ),
				},
		} )
		TppMission.UpdateObjective{
				objectives = {
					
							"subGoal_GetIntel",
					
							"missionTask_1_GetIntel01",
							"missionTask_2_EliminateVIP",
							"missionTask_3_EliminateTanks",
							"missionTask_4_bonus_RecoverVIP",
							"missionTask_5_bonus_EliminateAllTargetsBeforeArrivedFort",
							"missionTask_6_RecoverHostage",
							"missionTask_7_RecoverAllTanks",
				},
			}
		TppMission.UpdateObjective{
			radio = {
				radioGroups = {"s0044_rtrg0010", "s0044_rtrg0020"},
				radioOptions = { priority = "strong",nil},
			},
			objectives = {"default_area_clifftown","default_photo_vip" },
			options = { isMissionStart = true },
		}

		local backBlastWeapon = Player.IsBlastWeaponBySlot( PlayerSlotType.PRIMARY_2 )
		









		Fox.Log("ORDERBOXSTART is Player carrying a RPG check")

		svars.isCarryRPG = this.CheckGetRPG( backBlastWeapon )
		local startFreeplay = TppMission.IsStartFromFreePlay()
		Fox.Log("GetRpg "..tostring(svars.isCarryRPG).. "; startFreeplay"..tostring(startFreeplay) )
		if ( svars.isCarryRPG == false) and ( startFreeplay == true ) then

			TppRadio.Play("s0044_rtrg0300", {delayTime = 8, isEnqueue = true,})
		else

			Fox.Log("ORDERBOXSTART Player is NOT carrying a RPG")
		end
		
		
		TppRadio.SetOptionalRadio( "Set_s0044_oprg0000" )
		
		
		
		if svars.isStartConvoy == true then
			
			TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0070" )
			TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0080" )
			
			
			s10044_enemy.RemoveInterrogation()

		end

		
		
		if	svars.isThisHappened01	==	true	then		
			TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0080" )
		end

		TppMission.SetHelicopterDoorOpenTime( 15 )
end,

	OnLeave = function ()
	end,

	FuncTrap0 = function()
		if	svars.isStartConvoy == false and
			svars.isDestroyedConvoy == false then

			svars.isStartConvoy = true
			

			if svars.isStartCarRadio == false then
				s10044_radio.PlayWhyareyougothere()
				
				TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0070" )
				TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0080" )
				
				s10044_enemy.RemoveInterrogation()
			end

			s10044_enemy.StartConvoyTofort()
		end
	end,

	
	FuncIntelHelp = function()
			if svars.isInsideVIPRoom == true and svars.isStartCarRadio == false then
				
				s10044_radio.PlayHelpRadioFromIntelTeam()
				svars.isStartCarRadio = true

			TppSequence.SetNextSequence("Seq_Game_Convoy")
		end
	end,

		
	FuncApproachIntelAtcliffTown = function()
		if svars.isOnGetIntel == false then
			local phase	=	TppEnemy.GetPhase("afgh_cliffTown_cp")
			if phase == TppEnemy.PHASE.ALERT then
				s10044_radio.CantGetIntelOnAlert()
			end
		end
	end
}

sequences.Seq_Game_Convoy = {

	Messages = function( self )
		return
		StrCode32Table {
		Timer = {
			
			{
				msg = "Finish",
				sender = "BGM",
				func = function ()
					s10044_sound.BGMChase()
				end
			},
		},
		nil
	}
	end,

	OnEnter = function()

		s10044_enemy.StartConvoyTofort()

		
		if svars.isOnGetIntel == true then
			Fox.Log("##**GotConvoyRouteInfoFromIntel")
			TppRadio.SetOptionalRadio( "Set_s0044_oprg0010" )
			
			
			if svars.isConvoyArrivedFort == true then
				TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0040" )
				TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0050" )
			end

			
			if TppSequence.GetContinueCount() > 0 then
				if	svars.isConvoyArrivedFort	==	false	then			
					s10044_radio.PlayContinue_GetInfo()		
				else
					s10044_radio.PlayTargetsArrivedFort()		
				end
			else
				Fox.Log("Not_On_Continue, ->No ContinueRadio")
			end
		else
			Fox.Log("##**GotConvoyRouteInfoFromMiller")
			if svars.isStartCarRadio == true then
				TppRadio.SetOptionalRadio( "Set_s0044_oprg0020" )

			
			if svars.isConvoyArrivedFort == true then
				TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0040" )
				TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet( "s0044_oprg0050" )
			end


				
				if TppSequence.GetContinueCount() > 0 then
					if	svars.isConvoyArrivedFort	==	false	then		
						s10044_radio.PlayContinue_ListenIntel()			
					else
						s10044_radio.PlayTargetsArrivedFort()		
					end
				else
					Fox.Log("Not_On_Continue, ->No ContinueRadio")
				end
			else
				
				Fox.Log("### ??? Invalid Status ###")
			end
		end

		
		
		TppMission.UpdateObjective{
			objectives = {
				"default_area_clifftown_convoy",
				"default_area_clifftown_convoy2",
				"default_area_clifftown_VIP",
				"ShowEnemyRoute",
				
				"subGoal_EliminateAllTargets",
			}
		}

		s10044_enemy.RemoveInterrogation()
		GkEventTimerManager.Start( "BGM", 26 )
	end,

}

sequences.Seq_Game_Escape = {
	OnEnter = function()

		TppMission.UpdateObjective{
				objectives = {
				"All_Clear",
				"complete_sensha_vip",
				"subGoal_Escape",
				"missionTask_3_EliminateTanks_clear",
			},
		}
		TppRadio.SetOptionalRadio( "Set_s0044_oprg0100" )		
		
		Fox.Log("### PlayMissionClear ###")
		s10044_radio.PlayMissionClear()		
		TppUiCommand.InitAllEnemyRoutePoints()
		TppMission.CanMissionClear()
	end,
}



return this