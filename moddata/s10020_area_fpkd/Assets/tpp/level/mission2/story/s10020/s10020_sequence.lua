                                                                                                                                                                                        
local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}
local TimerStart = GkEventTimerManager.Start




this.MAX_PICKABLE_LOCATOR_COUNT = 80


this.MAX_PLACED_LOCATOR_COUNT = 100


this.MISSION_START_INITIAL_WEATHER  = TppDefine.WEATHER.SUNNY


if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
	this.SKIP_TEXTURE_LOADING_WAIT = true
end





local TARGET_HOSTAGE_NAME 		= "s10020_hostage_miller"		
local FIRST_LZ_NAME		 		= "lzs_slopedTown_E_0000"		
local DRIVER_WAITTIME		 	= 30							
local MILLER_POS			 	= {537.1232,335.1187,28.18954}	
local MILLER_CHECK_RANGE		= 10							
local MISSION_STARTTIME			= "14:06:00"					







function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		"Seq_Demo_ArrivalInAfghanistan"	,		
		"Seq_Game_IDroidTutorial",				
		"Seq_Game_IDroidTutorial_opened" ,		
		"Seq_Game_BinocularsTutorial",			
		"Seq_Game_ZoomTutorial",				
		"Seq_Game_IntelRadioTutorial",			
		"Seq_Game_CustumMarkerTutorial",		
		"Seq_Demo_RescueMillerExplanation",		
		"Seq_Game_RescueMiller",				
		"Seq_Demo_RescueMiller",				
		"Seq_Game_Escape",						
		"Seq_Demo_ParasiteAppearance",			
		"Seq_Game_EscapeFromParasites",			
		"Seq_Demo_EscapeWithMillerOnHeli",		
		"Seq_Demo_MissionClearMovie",			
		"Seq_Game_DebugPlayMovie",	
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {

	DayCount = 0,


	AttackParaUnitCount = 0,


	InterrogateCount = 0,
	

	isOnGetIntel 					= false ,	
	isOnGetIntel_AtVillage			= false ,	
	isOnGetIntel_AtComm				= false ,	

	isPickedUpMiller				= false ,	
				
	isStartedCombat					= false ,	
	isParaUnitFound					= false ,	
	isEscapeComplete				= false ,	
	isKilledParaUnit				= false ,	
	isFoggy							= false ,	
	
	isRideOn_Miller					= false ,	
	isFirstLZonHeli					= false ,	
	isInFirstLZonHeli				= false ,	
	
	isVehicle_startTravel			= false ,	
	
	isCantPickupMiller				= false ,	
	
	isParaUnitAppearanceDemo		= false ,	
	
	isAfghBGM_on					= false ,	
			

	isOcelotSay_Right				= false ,
	isOcelotSay_Left				= false ,
	isOcelotSay_Up					= false ,
	isOcelotSay_Down				= false ,	
	isCheckRotationStart			= false ,	
	isEspionageRadio				= false ,	
	

	isTutorial_Wall					= false ,	
	isTutorial_Jump					= false ,	
	isTutorial_Crawl				= false ,	
	isTutorial_Elude				= false ,	
	isTutorial_Behind				= false ,	
	isTutorial_OnLiftEnemy			= false ,	
	isTutorial_Horse_Accel			= false ,	
	isTutorial_Horse_Hide			= false ,	
	isTutorial_Horse_Hiding			= false ,	
	isTutorial_CallHorseEnd 		= false ,	
	isTutorial_Marking				= false ,	
	isTutorial_LowStance			= false ,	
	isTutorial_CustumMarker			= false ,	
	isTutolial_OptionalRadio		= false ,	

	isTutorial_animal				= false ,	
	isTutolial_HeliRide				= false ,	
	isTutorial_InVillageEp			= false ,	
	
	is_Evasion						= false ,	
	isDontPutMiller					= false ,	

	isInFirstOB						= false ,	
	isInVillageEp					= false ,	
	isInFarEp						= false ,	

	isArriveAtVillageBuild2F		= false ,	




	isMillerMonologue1				= false ,	
	isMillerMonologue2				= false ,	
	isMillerMonologue3				= false ,	
	isMillerMonologue4				= false ,	
	isMillerMonologue5				= false ,	
	isMillerMonologue6				= false ,	


	DebugCheck						= 0 ,

	isCanPlayParasiteDemo			= false	,	

	isPlayParaUnitDiscoverDemo		= false ,	

	isVehicle_startedTravel			= false ,	
}


this.checkPointList = {
	"CHK_MissionStart",				
	"CHK_GetIntelatVillage",		
	"CHK_GetIntelatComm",			
	"CHK_PickedUp_miller",			
	"CHK_ParasiteAppearance",		
nil

}

if not TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then

this.baseList = {
	"commFacility",
	"village",
	"enemyBase",
	"slopedTown",
	
	"ruinsNorth",
	"villageEast",
	"villageWest",
	"villageNorth",	
	"slopedWest",	
	"commWest",
	nil
}
end


this.CollectionList = {
	{ index = 1, min = TppCollection.TYPE_DIAMOND_SMALL,	max = TppCollection.TYPE_DIAMOND_LARGE		},	
	{ index = 2, min = TppCollection.TYPE_MATERIAL_CM_0,	max = TppCollection.TYPE_MATERIAL_BR_7		},	
	{ index = 3, min = TppCollection.TYPE_HERB_G_CRESCENT,	max = TppCollection.TYPE_HERB_HAOMA			},	
}


this.MISSION_REVENGE_MINE_LIST = {
        ["afgh_slopedTown"] = {
                ["trap_revMine_slopedTown_South"] = {
                        mineLocatorList = {
                                "itms_revMine_slopedTown_c_0000",
                                "itms_revMine_slopedTown_c_0001",
                                "itms_revMine_slopedTown_c_0002",
                                "itms_revMine_slopedTown_c_0003",
                                "itms_revMine_slopedTown_c_0004",
                        },
                },
        },
        ["afgh_village"] = {
                ["trap_revMine_village_West"] = {
                        mineLocatorList = {
                                "itms_revMine_village_c_0000",
                                "itms_revMine_village_c_0001",
                                "itms_revMine_village_c_0002",
                                "itms_revMine_village_c_0003",
                                "itms_revMine_village_c_0004",
                        },
                },
        },
}







if not TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
this.missionObjectiveDefine = {
	
	
	tutolial_area_slopedTown = {
		gameObjectName = "s10020_marker_slopedTown", visibleArea = 5, viewType = "all", randomRange = 0, setNew = false, 
		langId = "marker_info_mission_targetArea",
	},	
	
	default_area_slopedTown = {
		gameObjectName = "s10020_marker_slopedTown", visibleArea = 5, viewType = "all", randomRange = 0, setNew = false, 
		langId = "marker_info_mission_targetArea", 
		mapRadioName = "s0020_mprg0020",
		targetBgmCp = "afgh_slopedTown_cp",
	},	
	default_area_village = {
		gameObjectName = "s10020_marker_village", visibleArea = 4, viewType = "map_only_icon",randomRange = 0, setNew = false, 
		langId = "marker_information", 
		mapRadioName = "s0020_mprg0040",
		targetBgmCp = "afgh_slopedTown_cp",
	},
	
	getIntel_area_slopedTown = {
		gameObjectName = "s10020_marker_miller", visibleArea = 1, goalType = "moving_fix" ,
		viewType = "all",randomRange = 0, setNew = false, 
		langId = "marker_chara_miller",
		mapRadioName = "s0020_esrg3025",
		targetBgmCp = "afgh_slopedTown_cp",
	},

	
	goto_firstLZ = {
		gameObjectName = TARGET_HOSTAGE_NAME,
		langId = "marker_chara_miller",
	},
	
	rideon_heli = {

	},
	
	missionComplete = {		
		announceLog = "achieveAllObjectives",
	},

	
	
	photo_miller = {
		photoId			= 10,
		addFirst		= true,	
		photoRadioName	= "s0020_mirg0010"
	},
	
	photo_Intel_village = {

	},
	
	photo_Intel_com = {

	},

	
	
	announce_Intel = {
		announceLog = "updateMap",
	},
	
	announce_Intel_addDoc = {
	},

	
	area_Intel_village = {
		gameObjectName = "s10020_marker_Intel_village", 
	},
	area_Intel_village_get = {
	},
	area_Intel_com = {
		gameObjectName = "s10020_marker_Intel_com", 
	},
	area_Intel_com_get = {
	},
	
	
	subGoal_default = {		
		subGoalId= 0,
	},
	subGoal_gotoLZ = {		
		subGoalId= 1,
	},
	subGoal_rideHeli = {		
		subGoalId= 2,
	},

	
	
	default_missionTask_01 = {	
		missionTask = { taskNo = 0, isNew = true, isComplete = false },
	},
	clear_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = true },
	},
	
	default_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false },
	},
	clear_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = true },
	},
	
	default_missionTask_03 = {	
		missionTask = { taskNo = 2, isNew = true, isComplete = false ,isFirstHide=true },
	},
	clear_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = true },
	},
	
	default_missionTask_04 = {	
		missionTask = { taskNo = 3, isNew = true, isComplete = false ,isFirstHide=true },
	},
	clear_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = true },
	},
	
	default_missionTask_05 = {	
		missionTask = { taskNo = 4, isNew = true, isComplete = false ,isFirstHide=true },
	},
	clear_missionTask_05 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = true },
	},
	
	default_missionTask_06 = {	
		missionTask = { taskNo = 5, isNew = true, isComplete = false ,isFirstHide=true },
	},
	clear_missionTask_06 = {
		missionTask = { taskNo = 5, isNew = true, isComplete = true },
	},
	
	targetExtract = {		
		announceLog = "recoverTarget",
	},

	
	photo_miller_afterRescue = {
		photoId			= 10,
		addFirst		= true,	
	},

}
end



this.missionObjectiveEnum = Tpp.Enum{
	"tutolial_area_slopedTown",
	"default_area_slopedTown",
	"default_area_village",
	"getIntel_area_slopedTown",
	"goto_firstLZ",
	"rideon_heli",
	"missionComplete",
	"photo_miller",
	"photo_Intel_village",
	"photo_Intel_com",
	"announce_Intel",
	"announce_Intel_addDoc",
	"area_Intel_village",
	"area_Intel_village_get",
	"area_Intel_com",  
	"area_Intel_com_get",
	"subGoal_default",
	"subGoal_gotoLZ",
	"subGoal_rideHeli",
	"default_missionTask_01",
	"default_missionTask_02",
	"default_missionTask_03",
	"default_missionTask_04",
	"default_missionTask_05",
	"default_missionTask_06",
	"clear_missionTask_01",
	"clear_missionTask_02",
	"clear_missionTask_03",
	"clear_missionTask_04",
	"clear_missionTask_05",
	"clear_missionTask_06",
	"targetExtract",
	"photo_miller_afterRescue",
}











if not TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
this.missionObjectiveTree = {
	
	missionComplete = {
		targetExtract ={
			rideon_heli = {
				goto_firstLZ = {								
					getIntel_area_slopedTown = {				
						default_area_slopedTown = {				
							tutolial_area_slopedTown = {},		
							},
					},
				},
			},
		},
	},
	
	area_Intel_village_get = {		
		area_Intel_village = {					
			default_area_village = {},			
		},
	},
	area_Intel_com_get = {		
		area_Intel_com = {	
		},
	},	
	
	photo_miller_afterRescue = {				
		photo_miller = {},						
	},
	photo_Intel_village = {},					
	photo_Intel_com = {},						

	
	clear_missionTask_01 = {
		default_missionTask_01,
	},	
	clear_missionTask_02 = {
		default_missionTask_02,
	},	
	clear_missionTask_03 = {
		default_missionTask_03,
	},	
	clear_missionTask_04 = {
		default_missionTask_04,
	},	
	clear_missionTask_05 = {
		default_missionTask_05,
	},	
	clear_missionTask_06 = {
		default_missionTask_06,
	},	

}
end



this.missionTask_3_bonus_TARGET_LIST = {	
	s10020_enemy.ENEMY_NAME.ELITE,
}
this.missionTask_4_TARGET_LIST = {	
	s10020_enemy.ENEMY_NAME.VEHICLE,
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 2 },
	},
	second = {
		missionTask = { taskNo = 3 },
	}
}




this.NPC_ENTRY_POINT_SETTING = {
	[TppDefine.INIT_HELI_ROUTE] = {
		[EntryBuddyType.VEHICLE] = { Vector3(1165.031, 314.096, 1401.649), TppMath.DegreeToRadian(-2.0) }, 
		[EntryBuddyType.BUDDY] = { Vector3(-488.708, -12.176, 1140.744), TppMath.DegreeToRadian(80.0) }, 
	},
}





if not TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
this.VARIABLE_TRAP_SETTING = {
		
        { name = "trap_ApproachIntelAtComm", 		type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.ENABLE, } ,
        { name = "trap_ApproachIntelAtVillage", 	type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.ENABLE, } ,
        
        { name = "trap_ArriveAtVillageBuild2F", 		type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.ENABLE, } ,
        { name = "trap_ArriveAtCommBuild", 	type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.ENABLE, } ,
        
        { name = "trap_ApproachIntelAtVillage_OnAlert", 		type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.ENABLE, } ,
        { name = "trap_ApproachIntelAtComm_OnAlert", 	type = TppDefine.TRAP_TYPE.NORMAL, initialState = TppDefine.TRAP_STATE.ENABLE, } ,
}
end









if TppStory.IsMissionCleard( 10020 )  == false then
	this.playerInitialWeaponTable = {
		{ secondary     = "EQP_WP_10101",	magazine = TppDefine.INIT_MAG.HANDGUN_DEFAULT },
		{ primaryHip    = "EQP_WP_30101",	magazine = TppDefine.INIT_MAG.ASSAULT_DEFAULT },
		{ primaryBack   = "EQP_None" },
		{ support   	= "EQP_SWP_Grenade" },
		{ support   	= "EQP_SWP_Magazine" },
	}
	this.playerInitialItemTable = {
		"EQP_IT_TimeCigarette", "EQP_IT_Nvg", "EQP_None",
	}
end






function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	
	TppMission.RegisterMissionSystemCallback{
		OnEstablishMissionClear = TppMission.MissionGameEnd,
		OnEndMissionReward = function()
			TppSequence.SetNextSequence( "Seq_Demo_EscapeWithMillerOnHeli", { isExecMissionClear = true })
		end,
		OnDisappearGameEndAnnounceLog = function()
			TppDemo.ReserveInTheBackGround{ demoName = "Demo_EscapeWithMillerOnHeli" }
			TppMission.ShowMissionResult()
		end,
		OnOutOfMissionArea = function()
			if TppStory.IsMissionCleard( 10020 )  == true then
				
				TppMission.AbortForOutOfMissionArea{ isNoSave = false }
			else
				
				TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.OUTSIDE_OF_MISSION_AREA, TppDefine.GAME_OVER_RADIO.S10020_OUT_OF_MISSION_AREA )
			end
		end,
		
		OnRecovered = function( gameObjectId )
			Fox.Log("##** OnRecovered_is_coming ####")
			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_3_bonus_TARGET_LIST ) then
				TppResult.AcquireSpecialBonus{ first = { isComplete = true,},}	
			end
			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_4_TARGET_LIST ) then
				TppMission.UpdateObjective{	objectives = { "clear_missionTask_06"},		}
			end
		end,
		
		OnGameOver = this.OnGameOver

	}
	
	if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
	else
		
		TppScriptBlock.PreloadRequestOnMissionStart{
			{ demo_block = "Demo_ArrivalInAfghanistan" },
		}
		


		
		TppPlayer.AddTrapSettingForIntel{
			intelName = "Intel_village",
			autoIcon = true,
			identifierName = "GetIntelIdentifier",
			locatorName = "GetIntel_village",
			gotFlagName = "isOnGetIntel_AtVillage",
			trapName = "trap_ApproachIntelAtVillage",
			markerObjectiveName = "area_Intel_village",
			markerTrapName = "trap_ArriveAtVillageBuild2F",
		}
		
		TppPlayer.AddTrapSettingForIntel{
			intelName = "Intel_comm", 
			autoIcon = true,
			identifierName = "GetIntelIdentifier",
			locatorName = "GetIntel_commFacility",
			gotFlagName = "isOnGetIntel_AtComm",
			trapName = "trap_ApproachIntelAtComm",
			markerObjectiveName = "area_Intel_com",
			markerTrapName = "trap_ArriveAtCommBuild",
		}
		
		
		TppRatBird.EnableRat()
		TppRatBird.EnableBird( "TppCritterBird" )

	end
end






function this.OnGameOver()
	
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
		
		TppPlayer.SetTargetDeadCamera{ gameObjectName = TARGET_HOSTAGE_NAME }

		
		TppUiCommand.SetGameOverType( 'TimeParadox' )
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }

		return true
	end
	
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.S10020_TARGET_TIMEOVERDEAD ) then
		
		local func = function() 
			
			TppUiCommand.SetGameOverType( 'TimeParadox' )
			TppMission.ShowGameOverMenu{}
		end
		s10020_demo.TimeOverDeadMiller(func)
		return true
	end
end


function this.OnBuddyBlockLoad()
	Fox.Log("s10020_sequence.OnBuddyBlockLoad()")
	
	if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
	else
		if TppMission.IsMissionStart() then
			
			vars.buddyType = BuddyType.HORSE
			
			
			
			
			TppBuddy2BlockController.ReserveCallBuddy(
				BuddyType.HORSE,	
				BuddyInitStatus.NORMAL,	
				Vector3(1458.916,360.3217,1428.54),	
				0.0	
			)
		end
	end
end


function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
	else
		
		if svars.DayCount > 3 then
			svars.DayCount = 2
		end
	
		if TppMission.IsMissionStart() then		
			
			TppPlayer.Refresh(true)
		end
		
		
		TppRevenge.RegisterMissionMineList(this.MISSION_REVENGE_MINE_LIST)
		
		
		Fox.Log("#### s10020_sequence.SetAllStaffParam ####")
		TppEnemy.AssignUniqueStaffType{
			locaterName = TARGET_HOSTAGE_NAME,
			uniqueStaffTypeId = TppDefine.UNIQUE_STAFF_TYPE_ID.MILLER,
		}
		
		if DEBUG then
			
			if svars.DebugCheck == 10 then
				svars.DayCount = 5	
			end
		end	
	end		

end




function this.OnTerminate()
	
	TppUiStatusManager.UnsetStatus( "BossGaugeHead", "INVALID" )
end


function this.ReserveMissionClear()
	local nextMissionId
	if TppStory.IsMissionCleard( vars.missionCode ) then
		nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI
	else
		nextMissionId = 10030
	end

	TppMission.ReserveMissionClear{
		missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,	
		nextMissionId = nextMissionId,
	}
end









function this.Messages()
	
	if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
		return
	end
	return
	StrCode32Table {
		Player = {
			{ msg = "RideHelicopter",		 			func = this.FuncPlayerRideOnHeli },						
			{ msg = "IconRideHelicopterStartShown",		func = this.FuncHeliIcon		 },						
			{ msg = "OnPickUpCollection",				func = this.FuncPickUpCollection },
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
			{ msg = "Dead", 			sender = TARGET_HOSTAGE_NAME, func = this.FuncDeadMiller },			
			{ msg = "Damage", 			sender = TARGET_HOSTAGE_NAME, func = this.FuncDamageMiller },			
			{ msg = "HeliDoorClosed", 	 	func = this.FuncCheckEscapeWithMiller },							
			{ msg = "LostControl", 	 		func = this.FuncHeliLostControl },									
			{ msg = "ArrivedAtLandingZoneWaitPoint", 	func = this.FuncHeliArrivalLZ },						
			{ msg = "DescendToLandingZone", 	func = this.FuncHeliArrivalLZ_down },							
			{ msg = "StartedMoveToLandingZone", 		func = this.FuncHeliChangeLZ },							
			{ msg = "PlacedIntoVehicle",			func = this.FuncRideOnHeli_Miller		},					
			{ msg = "RoutePoint2", 		sender = "SupportHeli",		func = this.FuncCheckEscapeWithMiller		},		
		},
		Terminal = {
			{ msg = "MbDvcActCallRescueHeli", 	func = this.FuncHeliForceRouteOff		},						
		},	
		Trap	= {
			{ msg = "Enter", 	sender = "trap_CanPlayParasiteDemoArea",		func = function() svars.isCanPlayParasiteDemo = true end },	
			{ msg = "Exit", 	sender = "trap_CanPlayParasiteDemoArea",		func = function() svars.isCanPlayParasiteDemo = false end },		
		},
		Throwing = {
			{ msg = "NotifyStartWarningFlare",	func = this.FuncHeliForceRouteOff		},						
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


this.DoesIncludeTarget = function( gameObjectId, targetList )
	Fox.Log("##** Checking_MissionTaskList ####")
	for i, targetName in ipairs( targetList ) do
		if GameObject.GetGameObjectId( targetName ) == gameObjectId then
			return true
		end
	end
	return false

end


this.FuncTutorial_MBMenuMask = function()
	TppTerminal.SetActiveTerminalMenu {
		TppTerminal.MBDVCMENU.MSN_LOG	
	}
	
	TppUiStatusManager.SetStatus( "Subjective", "SUPPORT_NO_USE" )
end

this.FuncTutorial_MBMenuMaskReset = function()
	TppTerminal.SetActiveTerminalMenu {
		TppTerminal.MBDVCMENU.ALL,
	}
	
	TppUiStatusManager.UnsetStatus( "Subjective", "SUPPORT_NO_USE" )	
end


this.FuncTutorial_AllPadMaskReset = function()
	Player.ResetPadMask {settingName = "All"	}
	Player.ResetPadMask {settingName = "IDroidOpen_PadMask"	}
	Player.ResetPadMask {settingName = "Bino_PadMask"		}	
	Player.ResetPadMask {settingName = "BinoZoom_PadMask"	}		
	Player.ResetPadMask {settingName = "EspionageRadio_PadMask"	}	
	Player.ResetPadMask {settingName = "CustumMarker_PadMask"	}
			
	
	TppUiStatusManager.UnsetStatus( "PauseMenu", "INVALID" )

end


this.FuncTutorial_Skip = function()

	
	TppGameStatus.Reset( "s10020","S_ENABLE_TUTORIAL_PAUSE" )
	
	
	this.FuncTutorial_AllPadMaskReset()

	
	TppUiStatusManager.UnsetStatus( "CallMenu", "INVALID" )
	
	TppSequence.SetNextSequence("Seq_Demo_RescueMillerExplanation")
end


this.FuncEscapeWithMillerOnHeli = function()
	
	TppUiCommand.UnregisterAllMapRadios()
	this.ReserveMissionClear()
end	


this.FuncDeadMiller = function( gameObjectId , AttackerId)
	local AttackerIsPlayer = Tpp.IsPlayer( AttackerId )
	if AttackerIsPlayer == true then
		
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.S10020_TARGET_KILL)
	else
		
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.S10020_TARGET_DEAD)
	end
end


this.FuncDamageMiller = function( gameObjectId, AttackId , AttackerId )

	if Tpp.IsPlayer( AttackerId ) == false then
		return	
	end
	if AttackId == TppDamage.ATK_Push then
		return 
	elseif AttackId == TppDamage.ATK_BlastWind then
		return 
	elseif AttackId == TppDamage.ATK_Smoke then
		return 
	elseif AttackId == TppDamage.ATK_SmokeOccurred then
		return 
	elseif AttackId == TppDamage.ATK_SleepGus then
		return 
	elseif AttackId == TppDamage.ATK_SleepGusOccurred then
		return 
	end	
	
	if svars.isPickedUpMiller then
		
		s10020_radio.DontAttackMiller_afterMeets()
	else
		
		s10020_radio.DontAttackMiller()
	end
end


this.FuncMillerLock =  function( )
	Fox.Log("s10020_sequence.OnFuncMillerLock")
	local gameObjectType = "TppHostageKaz"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, TARGET_HOSTAGE_NAME)
	local command_Lock = {
			id = "SetHostage2Flag",
			flag = "disableUnlock",       
			on = true,
	}	
	GameObject.SendCommand( gameObjectId, command_Lock )			
end

this.FuncMillerUnLock =  function()
	Fox.Log("s10020_sequence.OnFuncMillerUnLock")
	local gameObjectType = "TppHostageKaz"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, TARGET_HOSTAGE_NAME)
	local command_UnLock = {
			id = "SetHostage2Flag",
			flag = "disableUnlock",       
			on = false,
	}			
	GameObject.SendCommand( gameObjectId, command_UnLock )		
end

this.FuncMillerUnLocked =  function()
	Fox.Log("s10020_sequence.OnFuncMillerUnLocked")
	local gameObjectType = "TppHostageKaz"
	local gameObjectId = GameObject.GetGameObjectId(gameObjectType, TARGET_HOSTAGE_NAME)
	local command_UnLock = {
			id = "SetHostage2Flag",
			flag = "unlocked",       
			on = true,
	}			
	GameObject.SendCommand( gameObjectId, command_UnLock )		
end


this.FuncCheckCanPickupMiller = function()
	local phase	=	TppEnemy.GetPhase("afgh_slopedTown_cp")
	local checkEnemy = TppEnemy.IsActiveSoldierInRange( MILLER_POS, MILLER_CHECK_RANGE )	
	if phase == TppEnemy.PHASE.ALERT and checkEnemy then
		TimerStart( "CheckCanPickupMiller", 5)
		this.FuncMillerLock()	
		svars.isCantPickupMiller = true
	else
		this.FuncMillerUnLock()		
		svars.isCantPickupMiller = false
	end
end


this.FuncDisableIntel = function()
	TppTrap.Disable( "trap_ApproachIntelAtComm" )
	TppTrap.Disable( "trap_ApproachIntelAtVillage" )	
	TppTrap.Disable( "trap_ApproachIntelAtVillage_OnAlert" )
	TppTrap.Disable( "trap_ApproachIntelAtComm_OnAlert" )	
	TppTrap.Disable( "trap_ArriveAtVillageBuild2F" )
	TppTrap.Disable( "trap_ArriveAtCommBuild" )	
end


this.FuncGetIntel = function()
	
	TppRadio.SetOptionalRadio( "Set_s0020_oprg2010" )
	
	
	TppRadioCommand.SetEnableEspionageRadioTarget{ name= { "erl_slopedTpwn_MirrorHouse" }, enable = false }
	TppRadioCommand.SetEnableEspionageRadioTarget{ name= { "erl_slopedTpwn_MirrorHouse_Intel" }, enable = true }

	this.FuncDisableIntel()
end


this.FuncHeliForceRouteOff = function()
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	GameObject.SendCommand( gameObjectId, { id="SetForceRoute", enabled=false }) 
end


this.FuncHeliChangeLZ = function(objectId,LZname)
	
	this.FuncHeliForceRouteOff()
	
	if LZname == StrCode32(FIRST_LZ_NAME) then	
	else
		
		svars.isFirstLZonHeli = false
	end
end


this.FuncHeliArrivalLZ = function(objectId,LZname)
	
	if svars.isFoggy == false then
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="EnableDescentToLandingZone" })		
	else
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="DisableDescentToLandingZone" })		
	end
	
	
	if LZname == StrCode32(FIRST_LZ_NAME) then	
		
		svars.isFirstLZonHeli = true
		
		
		if svars.isPickedUpMiller == true then
			if svars.isEscapeComplete	== false	then
				local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
				GameObject.SendCommand(gameObjectId, { id="DisableDescentToLandingZone" })		
			end
		end
		
		
		if svars.isPickedUpMiller == true then
			if svars.isInFirstLZonHeli == true then
				this.FuncParasiteBattleStart() 
			end
		end

	end
end
	

this.FuncParasiteBattleStart = function()
	if svars.isParaUnitAppearanceDemo == false then
		svars.isInFirstLZonHeli = true
		
		
		if svars.isFirstLZonHeli == true then
			
			local checkRange = 10
			if this.FuncCheckisInRange_Miller(checkRange)  then 
				
				TppSequence.SetNextSequence("Seq_Demo_ParasiteAppearance")
			else
				
				s10020_radio.DontPutMiller()
			end
		end
	end
end


this.FuncRideOnHeli_Miller = function(gameObjectId, VehicleId)
	
	local millerId = GameObject.GetGameObjectId(TARGET_HOSTAGE_NAME)
	local heliId = GameObject.GetGameObjectId("SupportHeli")
		
	if gameObjectId == millerId then	
		if VehicleId == heliId then
			svars.isRideOn_Miller = true
			
			TppScriptBlock.LoadDemoBlock("Demo_EscapeWithMillerOnHeli")

			
			TppHero.AddTargetLifesavingHeroicPoint( false, true )
			
			
			TppMission.UpdateObjective{
				objectives = { "targetExtract"},
			}
			
			TppMission.UpdateObjective{
				objectives = { "missionComplete"},
			}
			
			TppMission.UpdateObjective{
				objectives = {"clear_missionTask_02"},
			}
			if svars.isParaUnitFound == false then
				
				TppResult.AcquireSpecialBonus{
					second = { isComplete = true },
				}	
			end

		end	
	end		
end


this.FuncPlayerRideOnHeli = function()
	if svars.isPickedUpMiller == true then
		if svars.isRideOn_Miller == true then	
		
			local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
			GameObject.SendCommand(gameObjectId, { id="EnablePullOut" })	

			
			TppSound.StartJingleOnClearHeli()
			
		else
		
			s10020_radio.PutOnMirrorOnHeli()
		end
	end		
end


this.FuncHeliArrivalLZ_down = function()
	if svars.isPickedUpMiller == true then
		if svars.isFoggy == false then
			if svars.isTutolial_HeliRide == false then
				s10020_radio.Tutorial_PutOnMirrorOnHeli()
				
				
				TppSound.PostJingleOnDecendingLandingZone()
				
				
				TppMission.UpdateObjective{
					objectives = { "rideon_heli" , "subGoal_rideHeli" },
				}
				
				svars.isTutolial_HeliRide = true
			end
		end
	end
end


this.FuncHeliIcon = function()

end


this.FuncCheckEscapeWithMiller = function()
	
	if svars.isRideOn_Miller == true then
		
		this.FuncEscapeWithMillerOnHeli()

	else
	
		TppMission.AbortForRideOnHelicopter{ isNoSave = true }
	end
end	


this.FuncHeliLostControl = function(heliId,state,attakerId)

	
	if state == StrCode32("Start") then
		svars.isFirstLZonHeli = false
	end	
	
	if TppStory.IsMissionCleard( 10020 )  == false then
		
		if state == StrCode32("End") then
			
			if Tpp.IsPlayer( attakerId ) == true then
				
				TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.HELICOPTER_DESTROYED, TppDefine.GAME_OVER_RADIO.S10020_PLAYER_DESTROY_HELI)		
			else
				
				TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.HELICOPTER_DESTROYED, TppDefine.GAME_OVER_RADIO.S10020_RIDING_HELI_DESTROYED)
			end
		end
	end
end	


this.SwitchEnableCpSoldiers =  function(soldierList, switch)

	local GetGameObjectId = GameObject.GetGameObjectId
	local SendCommand = GameObject.SendCommand
	local command = { id="SetEnabled", enabled = switch }

	for idx = 1, table.getn(soldierList) do
		local gameObjectId = GetGameObjectId("TppSoldier2", soldierList[idx])
		if gameObjectId ~= NULL_ID then
			SendCommand( gameObjectId, command )
		end
	end
end


this.ExitParaUnit =  function(soldierList, switch)
	
	TppSound.StopSceneBGM("bgm_parasites")
		
	
	GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite0"), { id="StartWithdrawal" })
	GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite1"), { id="StartWithdrawal" })
	GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite2"), { id="StartWithdrawal" })
	GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite3"), { id="StartWithdrawal" })

	
	TppWeather.CancelForceRequestWeather()
	TppWeather.CancelRequestWeather( TppDefine.WEATHER.SUNNY , 3)		
	
	WeatherManager.PauseNewWeatherChangeRandom(false)
	
	svars.isFoggy = false
	
	svars.isStartedCombat = false
	
	TppMission.FinishBossBattle()
			
	
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	GameObject.SendCommand(gameObjectId, { id="EnableDescentToLandingZone" })
	
	GameObject.SendCommand(gameObjectId, { id="SetSearchLightForcedType", type="Off" } ) 
	
	GameObject.SendCommand( gameObjectId, { id="SetForceRoute", enabled=false }) 

	
	this.FuncFultonSetting()
	
end


this.FuncPickUpCollection = function( playerId, UniqueId, CollectionTypeId )

	Fox.Log("Get collection "..UniqueId..":"..CollectionTypeId )
	
	if UniqueId == TppCollection.GetUniqueIdByLocatorName( "col_diamond_s_s10020_0000" ) then
		TppMission.UpdateObjective{
			objectives = { "clear_missionTask_05"},
		}
	end

	
	for i, params in ipairs( this.CollectionList ) do
		if CollectionTypeId >= params.min and CollectionTypeId <= params.max then
			if params.index == 1 then
				
				s10020_radio.Tutorial_Diamond()
			elseif params.index == 2 then
				
				s10020_radio.Tutorial_Resources()
			elseif params.index == 3 then
				
				s10020_radio.Tutorial_Plant()
			end
		end
	end
end

this.FuncForceVehiclesStop = function()
	
	local ridingGameObjectId = vars.playerVehicleGameObjectId
	if Tpp.IsHorse(ridingGameObjectId) then
		
		GameObject.SendCommand( ridingGameObjectId, { id = "HorseForceStop" } )
	elseif Tpp.IsVehicle(ridingGameObjectId) then
		
		local vehicleType = GameObject.SendCommand( ridingGameObjectId, { id="GetVehicleType", } )
		GameObject.SendCommand( ridingGameObjectId, { id="ForceStop", enabled=true, } )
	elseif ( Tpp.IsPlayerWalkerGear(ridingGameObjectId) or Tpp.IsEnemyWalkerGear(ridingGameObjectId) ) then
		
		GameObject.SendCommand( ridingGameObjectId, { id = "ForceStop", enabled = true } )
	else
		
	end
end

this.FuncForceVehiclesStop_disable = function()
	
	local ridingGameObjectId = vars.playerVehicleGameObjectId
	if Tpp.IsHorse(ridingGameObjectId) then
		
	elseif Tpp.IsVehicle(ridingGameObjectId) then
		
		local vehicleType = GameObject.SendCommand( ridingGameObjectId, { id="GetVehicleType", } )
		GameObject.SendCommand( ridingGameObjectId, { id="ForceStop", enabled=false, } )
	elseif ( Tpp.IsPlayerWalkerGear(ridingGameObjectId) or Tpp.IsEnemyWalkerGear(ridingGameObjectId) ) then
		
		GameObject.SendCommand( ridingGameObjectId, { id = "ForceStop", enabled = false } )
	else
		
	end
end



this.FuncCheckisInRange_Miller = function(CheckRange)
	local gameObjectId = GameObject.GetGameObjectId("TppHostageKaz", TARGET_HOSTAGE_NAME)
	local isInRangeflag = GameObject.SendCommand( gameObjectId, {
		id="IsInRange",
		range = CheckRange,
		target = { vars.playerPosX, vars.playerPosY, vars.playerPosZ },
	} )	
	return isInRangeflag
end



this.FuncCheckStatus_MillerCarried = function()
	local gameObjectId = GameObject.GetGameObjectId("TppHostageKaz", TARGET_HOSTAGE_NAME)
	local command = {	id = "GetStatus",	}
	local actionStatus = GameObject.SendCommand( gameObjectId, command )

	if actionStatus == TppGameObject.NPC_STATE_CARRIED then
		
		return true
	else
		return false
	end
end


this.FuncChangeDamageRate_Miller = function(damageRate)
	Fox.Log("s10020:ChangeDamageRate_Miller")
	local gameObjectId = GameObject.GetGameObjectId( TARGET_HOSTAGE_NAME )
	local command = { id = "SetEnemyDamageRate", rate= damageRate }
	GameObject.SendCommand( gameObjectId, command )
end


this.FuncFultonSetting = function()
	
	if TppStory.IsMissionCleard( 10020 )  == true then
		vars.playerDisableActionFlag = PlayerDisableAction.NONE 
	else
		vars.playerDisableActionFlag = PlayerDisableAction.FULTON 
	end
end

this.FuncFultonSetting_noTimeCigarette = function()
	if TppStory.IsMissionCleard( 10020 )  == true then
		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE
	else
		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE + PlayerDisableAction.FULTON
	end		 
end		


this.FuncBuddyDogWarp = function()
	if TppBuddy2BlockController.GetActiveBuddyType() == BuddyType.DOG then
		local gameObjectId = { type="TppBuddyDog2", index=0 }
		local command = { id = "SetWarpPosition", pos = Vector3( 540.217, 335.125, 29.102 ), }
		GameObject.SendCommand( gameObjectId, command )	
	end
end


this.FuncDisableSpecialAction = function()
	local gameObjectId = GameObject.GetGameObjectId( TARGET_HOSTAGE_NAME )
	local command = { id="SpecialAction", action="" }
	GameObject.SendCommand( gameObjectId, command )

	local command = { id="SetHostage2Flag", flag="disableVoice", on=false }
	GameObject.SendCommand( gameObjectId, command )
end







sequences.Seq_Demo_ArrivalInAfghanistan = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end
		
		return
		StrCode32Table {
			UI = {
				{
					
					msg = "StartMissionTelopFadeOut",
					func = function ()
						Fox.Log("!!!!!!!!!!!!!!!!! s10020_sequence: StartMissionTelopFadeOut !!!!!!!!!!!!!!!")
						self.OnEndMissionTelop()
					end
				},
			},
			nil
		}
	end,


	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(629.3156, 337.89716, 713.4539))
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		Fox.Log("#### s10020:Enter Seq_Demo_ArrivalInAfghanistan ####")
		
		
		TppClock.SetTime( MISSION_STARTTIME )

		
		TppDataUtility.SetVisibleDataFromIdentifier( "id_village_rnpt", "afgh_rnpt001_0000", true , true )

		
		TppUI.StartMissionTelop(s10020,true,true)
		
		
		Player.SetPadMask {  settingName = "All", except = true, buttons =  PlayerPad.STOCK,	sticks = PlayerPad.STICK_R,  }		

	end,
	
	OnEndMissionTelop = function()
		local funcs = {
			onEnd = function() TppSequence.SetNextSequence("Seq_Game_IDroidTutorial")	end,
		}
		s10020_demo.ArrivalInAfghanistan(funcs)	
	end,
		
	OnLeave = function()
		
		this.FuncTutorial_AllPadMaskReset()
		
		
		if TppStory.IsMissionCleard( 10020 )  == true then
			TppGameStatus.Set( "s10020","S_ENABLE_TUTORIAL_PAUSE" )
		end	
	end,
}




sequences.Seq_Game_IDroidTutorial = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end
		
		return
		StrCode32Table {
			GameObject = {
				{ msg = "MonologueEnd", 	func = self.FuncHud_OpenIDriod },
			},
			Terminal = {
				{ msg = "MbDvcActOpenTop", 	func = 	function() 
						TppSequence.SetNextSequence("Seq_Game_IDroidTutorial_opened") end },	
			},				
			Timer = {
				{ msg = "Finish",	sender = "timer_suggestOpenIdroid",				func = 	self.FuncSuggestOpenIdroid	},
				{ msg = "Finish",	sender = "timer_skipTutorial_IDT",				func = 	this.FuncTutorial_Skip	},
			},	
			UI = {
				{ msg = "PauseMenuSkipTutorial",		func = this.FuncTutorial_Skip	},
			},
			nil
		}
	end,
	
	OnEnter = function()
		Fox.Log("#### s10020:Enter Seq_Game_IDroidTutorial ####")
		
		TppMission.UpdateObjective{
			objectives = { 
				"tutolial_area_slopedTown" , 
				"photo_miller" , 
				"subGoal_default" , 
				"default_missionTask_01" , 
				"default_missionTask_02" ,
				"default_missionTask_03" , 
				"default_missionTask_04" , 
				"default_missionTask_05" , 
				"default_missionTask_06"
			},
		}
		
		local gameObjectId = GameObject.GetGameObjectId( "TppOcelot2", "Ocelot" )
		local command = { id = "ChangeFova", bodyId = TppEnemyBodyId.oce0_main0_v01, demoBodyId=TppEnemyBodyId.oce0_main0_v00, }
		GameObject.SendCommand( gameObjectId, command )
		
		
		TppWeather.SetWeatherProbabilitiesAfghNoSandStorm()
		
		
		Player.SetPadMask {  settingName = "All", except = true, buttons =  PlayerPad.STOCK,	sticks = PlayerPad.STICK_R,  }		

		
		TppUiCommand.RequestMbDvcOpenCondition{ isMapFocusMissionArea=true }
		
		TppUiCommand.SetMbMapPhotoRealModeByForce(false)
		
		TppUiCommand.SetMbTopModeToMapByForce()
		
		TppUiCommand.SetMbMapZoomLevelByForce(0)

		
		TppDataUtility.CreateEffectFromId( "FxLocator_fx_tpp_flrdia03_s1" )

		
		this.FuncTutorial_MBMenuMask()
		
		
		TppRadioCommand.SetEnableEspionageRadioTarget{ name= 
		{ 	"erl_binotutolial_village",
			"erl_village_canal" , 
			"erl_village_IntelHouse",
			"erl_slopedTpwn_MirrorHouse",
			"erl_slopedTpwn_MirrorHouse_Intel",
			"erl_flag",
			"erl_Center",
		}, enable = false }

		
		TppUiStatusManager.SetStatus( "MbMap", "BLOCK_RADIO" )

		
		s10020_radio.Tutorial_start()

		
		TppUiStatusManager.SetStatus( "ActionIcon", "INVALID" )

		
		TppUiStatusManager.SetStatus( "Subjective", "MARKER_HELP_OFF" )
		
		
		Player.SetEnableDOFInSubjectiveCameraAtGen7(true)
		
	end,
	
	
	FuncHud_OpenIDriod = function(GameObjectId,speechLabel,isSuccess)

		
		TppUI.ShowControlGuide{ actionName = "MB_DEVICE", continue = false }

		this.FuncTutorial_AllPadMaskReset()
		Player.SetPadMask {
			settingName = "IDroidOpen_PadMask",    
			except = true,                                 
			buttons = PlayerPad.MB_DEVICE + PlayerPad.STOCK,
			sticks = PlayerPad.STICK_R, 
		}

		TimerStart( "timer_suggestOpenIdroid", 10)	
		
		if (speechLabel == StrCode32("MRTS_001") and isSuccess ~= 0 ) then
			
			TimerStart( "timer_skipTutorial_IDT", 300)
		end
	end,
	
	
	FuncSuggestOpenIdroid = function()
		
		this.FuncTutorial_AllPadMaskReset()
		Player.SetPadMask {  settingName = "All", except = true, buttons =  PlayerPad.STOCK,	sticks = PlayerPad.STICK_R,  }		
		
		
		s10020_radio.SuggestOpenIdroid()
	end,
	
	OnLeave = function()
		
		this.FuncTutorial_AllPadMaskReset()
		
		this.FuncTutorial_MBMenuMaskReset()
	end,
	
}

sequences.Seq_Game_IDroidTutorial_opened = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end
		
		return
		StrCode32Table {
			GameObject = {
				{ msg = "MonologueEnd", 			func = self.FuncHud_CloseIDriod },	
				},
			Terminal = {
				{ msg = "MbDvcActCloseTop", func = 	function() 
						TppSequence.SetNextSequence("Seq_Game_BinocularsTutorial") end },	
			},				
			Timer = {
				{ msg = "Finish",	sender = "timer_OpenIDriod",						func = 	self.FuncOpenIDriod	},
				{ msg = "Finish",	sender = "timer_suggestCloseIdroid",				func = 	self.FuncSuggestCloseIdroid	},
				{ msg = "Finish",	sender = "timer_CloseIdroid",						func = 	self.FuncCloseIDriod	},
				{ msg = "Finish",	sender = "timer_skipTutorial_IDTo",					func = 	this.FuncTutorial_Skip	},
			},
			UI = {
				{ msg = "PauseMenuSkipTutorial",		func = this.FuncTutorial_Skip	},
			},
			nil
		}
	end,
	
	OnEnter = function()
		Fox.Log("#### s10020:Enter Seq_Game_IDroidTutorial_opened ####")
		
		Player.SetPadMask {  settingName = "All", except = true, buttons =  PlayerPad.STOCK,	sticks = PlayerPad.STICK_R,  }		

		
		TppUiStatusManager.SetStatus( "PauseMenu", "INVALID" )

		
		TppUiCommand.SetEnableMenuCancelClose( false )

		
		this.FuncTutorial_MBMenuMask()
		
		TimerStart( "timer_OpenIDriod", 1.5)	

	end,
	
	FuncOpenIDriod = function()
		
		s10020_radio.OpenedIdroid()
	end,
	
	
	FuncCloseIDriod = function()
		
		s10020_radio.CloseIdroid()	
	
		
		TppUI.ShowControlGuide{ actionName = "MB_DEVICE", continue = false }
		
		
		TimerStart( "timer_suggestCloseIdroid", 12)	
	end,
	
	
	FuncSuggestCloseIdroid = function()
		
		this.FuncTutorial_AllPadMaskReset()
		Player.SetPadMask {  settingName = "All", except = true, buttons =  PlayerPad.STOCK,	sticks = PlayerPad.STICK_R,  }		
	
		
		s10020_radio.SuggestCloseIdroid()
		
		TimerStart( "timer_suggestCloseIdroid", 15)			

	end,
	
	
	FuncHud_CloseIDriod = function(GameObjectId,speechLabel,isSuccess)
		
		if (speechLabel == StrCode32("MRTS_003") and isSuccess ~= 0 ) then		
			
			this.FuncTutorial_AllPadMaskReset()	
			Player.SetPadMask {
				settingName = "IDroidOpen_PadMask",    
				except = true,                                 
				buttons = PlayerPad.MB_DEVICE + PlayerPad.STOCK,
				sticks = PlayerPad.STICK_R,     
			}
			
			TppUiCommand.SetEnableMenuCancelClose( true )
			
			TimerStart( "timer_skipTutorial_IDTo", 300)
			
			TimerStart( "timer_CloseIdroid", 8)			

		elseif (speechLabel == StrCode32("MRTS_004") and isSuccess ~= 0 ) then
			
			TppUI.ShowControlGuide{ actionName = "MB_DEVICE", continue = false }
			
			
			Player.ResetPadMask {  settingName = "All"	}	
			Player.SetPadMask {
				settingName = "IDroidOpen_PadMask",    
				except = true,                                 
				buttons = PlayerPad.MB_DEVICE + PlayerPad.STOCK,
				sticks = PlayerPad.STICK_R,     
			}	
		end
	end,

	OnLeave = function()
		
		this.FuncTutorial_AllPadMaskReset()
		
		this.FuncTutorial_MBMenuMaskReset()
	end,
}



sequences.Seq_Game_BinocularsTutorial = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end

		return
		StrCode32Table {
			GameObject = {
				{ msg = "MonologueEnd", 			func = self.FuncHud_UseBino },	
				},
			Player = {
				{ 	msg = "OnBinocularsMode",	
				func = function() TppSequence.SetNextSequence("Seq_Game_ZoomTutorial") end, },	
			},
			
			Timer = {
				{ msg = "Finish",	sender = "timer_suggestUseBino",					func = 	self.FuncSuggestUseBino	},
				{ msg = "Finish",	sender = "timer_skipTutorial_BT",					func = 	this.FuncTutorial_Skip	},
			},
			UI = {
				{ msg = "PauseMenuSkipTutorial",		func = this.FuncTutorial_Skip	},
			},
			nil
		}
	end,
	
	OnEnter = function()
		Fox.Log("#### s10020:Enter Seq_Game_BinocularsTutorial ####")
		
		
		Player.SetPadMask {  settingName = "All", except = true, buttons =  PlayerPad.STOCK,	sticks = PlayerPad.STICK_R,  }		
		
		
		this.FuncTutorial_MBMenuMask()
		
		
		s10020_radio.Tutorial_Binoculars()

		TimerStart( "timer_suggestUseBino", 12)
		
	end,
	
	
	FuncHud_UseBino = function(GameObjectId,speechLabel,isSuccess)
		
		TppUI.ShowControlGuide{ actionName = "BINO", continue = false }
			
		
		this.FuncTutorial_AllPadMaskReset()
		Player.SetPadMask {
			settingName = "Bino_PadMask",    
			except = true,                                 
			buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK,
			sticks = PlayerPad.STICK_R,     
		}
			
		if (speechLabel == StrCode32("MRTS_005") and isSuccess ~= 0 ) then		
			TimerStart( "timer_skipTutorial_BT", 300)
		end
	end,
	
	
	FuncSuggestUseBino = function()
		
		this.FuncTutorial_AllPadMaskReset()
		Player.SetPadMask {  settingName = "All", except = true, buttons =  PlayerPad.STOCK,	sticks = PlayerPad.STICK_R,  }		

		
		s10020_radio.SuggestUseBino()
		
		
		TimerStart( "timer_suggestUseBino", 20)
	end,
	
	OnLeave = function()
		
		this.FuncTutorial_AllPadMaskReset()
	end,
}


sequences.Seq_Game_ZoomTutorial = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end
		
		return
		StrCode32Table {
			GameObject = {
				{ msg = "MonologueEnd", 			func = self.FuncHud_Zoom },	
			},
			Player = {
			},
			Timer = {
				{ msg = "Finish",	sender = "timer_suggestUseZoom",					func = 	self.FuncSuggestUseZoom	},
				{ msg = "Finish",	sender = "timer_skipTutorial_ZT",					func = 	this.FuncTutorial_Skip	},
			},
			Radio = {
				{ msg = "EspionageRadioCandidate", 
					func = function( gameObjectId ) 
						if gameObjectId == GameObject.GetGameObjectId("erl_binotutolial_village") then
							TppSequence.SetNextSequence("Seq_Game_IntelRadioTutorial")
						end
					end,
				}
			},
			UI = {
				{ msg = "PauseMenuSkipTutorial",		func = this.FuncTutorial_Skip	},
			},
			nil
		}
	end,
	
	OnEnter = function()
		Fox.Log("#### s10020:Enter Seq_Game_ZoomTutorial ####")

		
		this.FuncTutorial_MBMenuMask()
		
		
		Player.SetPadMask {
			settingName = "Bino_PadMask",    
			except = true,                                 
			buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK,
			sticks = PlayerPad.STICK_R,     
		}

		
		s10020_radio.Tutorial_UseZoom()	

		
		TppRadioCommand.SetEnableEspionageRadio( false )
		
		TppRadioCommand.ForceHideEspionageIcon( true )
		
		
		TppRadioCommand.SetEnableEspionageRadioTarget{ name= { "erl_binotutolial_village" }, enable = true }

		
		TppPlayer.CheckRotationSetting{
				
				{
					directionX = 0,
					directionRangeX = 25,
					directionY = -150,
					directionRangeY = 35,
					func = function( checkResult )
						if checkResult == true then
							if PlayerInfo.OrCheckStatus{ PlayerStatus.BINOCLE, } then
								
								s10020_radio.Tutorial_MoreLeft()
							end
						end
					end,
				},
				
				{
					directionX = 0,
					directionRangeX = 20,
					directionY = -75,
					directionRangeY = 30,
					func = function( checkResult )
						if checkResult == true then
							if PlayerInfo.OrCheckStatus{ PlayerStatus.BINOCLE, } then
								
								s10020_radio.Tutorial_MoreRight()
							end
						end
					end,
				},
				
				{
					directionX = -25,
					directionRangeX = 20,
					directionY = -90,
					directionRangeY = 60,
					func = function( checkResult )
						if checkResult == true then
							if PlayerInfo.OrCheckStatus{ PlayerStatus.BINOCLE, } then
								
								s10020_radio.Tutorial_MoreDown()
							end
						end
					end,
				},
				
				{
					directionX = 25,
					directionRangeX = 20,
					directionY = -90,
					directionRangeY = 60,
					func = function( checkResult )
						if checkResult == true then
							if PlayerInfo.OrCheckStatus{ PlayerStatus.BINOCLE, } then
								
								s10020_radio.Tutorial_MoreUp()
							end
						end
					end,
				}
			}
	end,
	
	OnUpdate = function()
		if svars.isCheckRotationStart == true then
			TppPlayer.CheckRotation()
		end
	end,

	
	FuncHud_Zoom = function(GameObjectId,speechLabel,isSuccess)
		
		if (speechLabel == StrCode32("MRTS_007") and isSuccess ~= 0 ) then	 
			svars.isCheckRotationStart = true

			TimerStart( "timer_skipTutorial_ZT", 300)			

		elseif (speechLabel == StrCode32("MRTS_006") and isSuccess ~= 0 ) then	 
			
			TppUI.ShowControlGuide{ actionName = "BINO", continue = false }
			
			TimerStart( "timer_suggestUseZoom", 12)
		end	
		if (speechLabel == StrCode32("MRTS_007") and isSuccess ~= 0 ) or 
			(speechLabel == StrCode32("MRTS_013") and isSuccess ~= 0 ) then	 
			
			TppUI.ShowControlGuide{ actionName = "BINO_ZOOM", continue = false }
			
			TimerStart( "timer_suggestUseZoom", 12)
		end			
		
	end,

	
	FuncSuggestUseZoom = function()
		
		if PlayerInfo.AndCheckStatus{ PlayerStatus.BINOCLE } then
			local zoomRate = PlayerVars.cameraZoomRate
			if zoomRate == 1.5 or zoomRate == 3 then
				
				s10020_radio.SuggestUseZoom()
			else
				
				TimerStart( "timer_suggestUseZoom", 12)			
			end
		else
			
			s10020_radio.SuggestUseBino()
		end
	end,
	
	OnLeave = function()
		
		this.FuncTutorial_AllPadMaskReset()
		
		this.FuncTutorial_MBMenuMaskReset()
	end,	
}



sequences.Seq_Game_IntelRadioTutorial = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end
		
		return
		StrCode32Table {
			GameObject = {
				{ msg = "MonologueEnd", 			func = self.FuncHud_EspionageRadio },	
			},
			Player = {
			},
			Timer = {
				{ msg = "Finish",	sender = "timer_suggestEspionageRadio",				func = 	self.FuncSuggestEspionageRadio	},
				{ msg = "Finish",	sender = "timer_skipTutorial_IRT",					func = 	this.FuncTutorial_Skip	},
			},
			Radio = {
				{ msg = "EspionageRadioPlay", sender = "MessageOnly",		
					func = function() 
							
							TppRadioCommand.SetEnableEspionageRadioTarget{ name= { "erl_binotutolial_village" }, enable = false }
							TppRadioCommand.SetEnableEspionageRadio( false )
							
							svars.isEspionageRadio = true
							s10020_radio.EspionageRadio()
						end, },
			},
			UI = {
				{ msg = "PauseMenuSkipTutorial",		func = this.FuncTutorial_Skip	},
			},
			nil
		}
	end,

	OnEnter = function()
		Fox.Log("#### s10020:Enter Seq_Game_IntelRadioTutorial ####")
		
		this.FuncTutorial_MBMenuMask()		
		
		
		Player.SetPadMask {
			settingName = "Bino_PadMask",    
			except = true,                                 
			buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK,
			sticks = PlayerPad.STICK_R,     
		}
		
		TppUiStatusManager.SetStatus( "CallMenu", "INVALID" )

		
		s10020_radio.Tutorial_EspionageRadio()
				
	end,
	
	
	FuncHud_EspionageRadio = function(GameObjectId,speechLabel,isSuccess)

		if (speechLabel == StrCode32("MRTS_014") and isSuccess ~= 0 ) then	 
			TimerStart( "timer_skipTutorial_IRT", 300)
		end
		if (speechLabel == StrCode32("MRTS_014") and isSuccess ~= 0 ) or 
			(speechLabel == StrCode32("MRTS_015") and isSuccess ~= 0 ) then	 
			
			this.FuncTutorial_AllPadMaskReset()
	
			Player.SetPadMask {
				settingName = "EspionageRadio_PadMask",    
				except = true,                                 
				buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK + PlayerPad.CALL,
				sticks = PlayerPad.STICK_R,    
			}
		
			
			TppRadioCommand.SetEnableEspionageRadio( true )
			
			TppRadioCommand.ForceHideEspionageIcon( false )
			
			TppUI.ShowControlGuide{ actionName = "OPTIONALRADIO", continue = false }
			
			TimerStart( "timer_suggestEspionageRadio", 30)
			
		elseif (speechLabel == StrCode32("MRTS_006") and isSuccess ~= 0 ) then	 
			
			TppRadioCommand.SetEnableEspionageRadio( true )
			
			TppUI.ShowControlGuide{ actionName = "BINO", continue = false }
			
			TimerStart( "timer_suggestEspionageRadio", 12)	
			
		elseif (speechLabel == StrCode32("MRTS_016") and isSuccess ~= 0 ) then	 
			
			TppSequence.SetNextSequence("Seq_Game_CustumMarkerTutorial")
		end

	end,


	FuncSuggestEspionageRadio = function()
		
		TppRadioCommand.SetEnableEspionageRadio( false )
		
		
		if PlayerInfo.AndCheckStatus{ PlayerStatus.BINOCLE } then
			if svars.isEspionageRadio == false then
				
				s10020_radio.SuggestEspionageRadio()
			end
		else
			
			s10020_radio.SuggestUseBino()
		end
	end,
	
	OnLeave = function()
		this.FuncTutorial_AllPadMaskReset()
		
		this.FuncTutorial_MBMenuMaskReset()
	end,
}


sequences.Seq_Game_CustumMarkerTutorial = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end
		
		return
		StrCode32Table {
			GameObject = {
				{ msg = "MonologueEnd", 			func = self.FuncHud_CustumMarker },	
			},
			Player = {
				{ msg = "PutMarkerWithBinocle", 			func = self.FuncCheckCustumMarker },
			},
			Timer = {
				{ msg = "Finish",	sender = "timer_skipTutorial_CT",						func = 	this.FuncTutorial_Skip	},
				{ msg = "Finish",	sender = "timer_suggestCustumMarker",					func = 	self.FuncSuggestCustumMarker	},
			},
			Radio = {
				{ msg = "Finish", sender = "s0020_esrg0010",	
					func = function() TppSequence.SetNextSequence("Seq_Demo_RescueMillerExplanation") end, },
			},
			UI = {
				{ msg = "PauseMenuSkipTutorial",		func = this.FuncTutorial_Skip	},
			},
			nil
		}
	end,

	OnEnter = function()
		Fox.Log("#### s10020:Enter Seq_Game_CustumMarkerTutorial ####")
		
		this.FuncTutorial_MBMenuMask()
		
		Player.SetPadMask {
			settingName = "EspionageRadio_PadMask",    
			except = true,                                 
			buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK + PlayerPad.CALL,
			sticks = PlayerPad.STICK_R,     
		}
		
		TppRadioCommand.SetEnableEspionageRadio( false )
		
		
		TppUiStatusManager.SetStatus( "CallMenu", "INVALID" )
		
		
		s10020_radio.Tutorial_CustumMarker()

	end,
	
	
	FuncHud_CustumMarker = function(GameObjectId,speechLabel,isSuccess)
		
		if (speechLabel == StrCode32("MRTS_017") and isSuccess ~= 0 ) then	 
			TimerStart( "timer_skipTutorial_CT", 300)
		end
		if (speechLabel == StrCode32("MRTS_017") and isSuccess ~= 0 ) or 
			(speechLabel == StrCode32("MRTS_018") and isSuccess ~= 0 ) then
			
			this.FuncTutorial_AllPadMaskReset()
			
			
			TppUiStatusManager.UnsetStatus( "Subjective", "MARKER_HELP_OFF" )
			TppUiStatusManager.UnsetStatus( "Subjective", "MARKER_HELP_NO_USE" )
			
			
			GkEventTimerManager.Stop( "timer_suggestCustumMarker")
			GkEventTimerManager.Start( "timer_suggestCustumMarker", 20 )
			
			
			TppUI.ShowControlGuide{ actionName = "CUSTUMMARKER", continue = false }
			
			this.FuncTutorial_AllPadMaskReset()				
			Player.SetPadMask {
				settingName = "CustumMarker_PadMask",    
				except = true,                                 
				buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK + PlayerPad.CALL + PlayerPad.BUTTON_PLACE_MARKER,
				sticks = PlayerPad.STICK_R,     
			}
		
		elseif	(speechLabel == StrCode32("MRTS_019") and isSuccess ~= 0 )	then
			
			this.FuncTutorial_AllPadMaskReset()
			
			
			TppUiStatusManager.UnsetStatus( "Subjective", "MARKER_HELP_OFF" )
			TppUiStatusManager.UnsetStatus( "Subjective", "MARKER_HELP_NO_USE" )

			
			GkEventTimerManager.Stop( "timer_suggestCustumMarker")
			GkEventTimerManager.Start( "timer_suggestCustumMarker", 20 )

			this.FuncTutorial_AllPadMaskReset()				
			Player.SetPadMask {
				settingName = "CustumMarker_PadMask",    
				except = true,                                 
				buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK + PlayerPad.CALL + PlayerPad.BUTTON_PLACE_MARKER,
				sticks = PlayerPad.STICK_R,     
			}
		
		elseif (speechLabel == StrCode32("MRTS_006") and isSuccess ~= 0 ) then	 
			
			TppUiStatusManager.UnsetStatus( "Subjective", "MARKER_HELP_NO_USE" )

			this.FuncTutorial_AllPadMaskReset()				
			Player.SetPadMask {
				settingName = "CustumMarker_PadMask",    
				except = true,                                 
				buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK + PlayerPad.CALL + PlayerPad.BUTTON_PLACE_MARKER,
				sticks = PlayerPad.STICK_R,     
			}

			
			TppUI.ShowControlGuide{ actionName = "BINO", continue = false }
			
			
			GkEventTimerManager.Stop( "timer_suggestCustumMarker")
			GkEventTimerManager.Start( "timer_suggestCustumMarker", 12 )
			
		elseif (speechLabel == StrCode32("MRTS_020") and isSuccess ~= 0 ) then	 
			
			TppSequence.SetNextSequence("Seq_Demo_RescueMillerExplanation")
		end
		
	end,


	FuncSuggestCustumMarker = function()
		
		this.FuncTutorial_AllPadMaskReset()
		Player.SetPadMask {
			settingName = "EspionageRadio_PadMask",    
			except = true,                                 
			buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK + PlayerPad.CALL,
			sticks = PlayerPad.STICK_R,     
		}	
		
		
		TppUiStatusManager.SetStatus( "Subjective", "MARKER_HELP_NO_USE" )

		
		if PlayerInfo.AndCheckStatus{ PlayerStatus.BINOCLE } then
			
			s10020_radio.SuggestCustumMarker()
		else
			
			s10020_radio.SuggestUseBino()
		end
	end,
	
	
	FuncCheckCustumMarker = function(markerX,markerY,markerZ)

		if 	markerX > 384 	and
			markerX < 768 	and
			markerZ > 1024 	and
			markerZ < 1280	then
			
			
			s10020_radio.SuccessCustumMarker()
		
			
			this.FuncTutorial_AllPadMaskReset()
			Player.SetPadMask {
				settingName = "EspionageRadio_PadMask",    
				except = true,                                 
				buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK + PlayerPad.CALL,
				sticks = PlayerPad.STICK_R,     
			}		
			
			TppUiStatusManager.SetStatus( "Subjective", "MARKER_HELP_NO_USE" )

		else
			
			this.FuncTutorial_AllPadMaskReset()
			Player.SetPadMask {
				settingName = "EspionageRadio_PadMask",    
				except = true,                                 
				buttons = PlayerPad.MB_DEVICE + PlayerPad.SUBJECT + PlayerPad.STOCK + PlayerPad.CALL,
				sticks = PlayerPad.STICK_R,     
			}
			
			TppUiStatusManager.SetStatus( "Subjective", "MARKER_HELP_NO_USE" )

			
			s10020_radio.ThisisNotVillage()
		end
	end,

	OnLeave = function()
		
		this.FuncTutorial_AllPadMaskReset()
		
		this.FuncTutorial_MBMenuMaskReset()
		
		TppUiStatusManager.UnsetStatus( "Subjective", "MARKER_HELP_NO_USE" )

		
		TppGameStatus.Reset( "s10020","S_ENABLE_TUTORIAL_PAUSE" )
		
	end,
}




sequences.Seq_Demo_RescueMillerExplanation = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end
		
		return
		StrCode32Table {
			Demo = {
				{ msg = "p31_010010_BackGroundChange", 			
				func = function()
					
					TppDataUtility.SetVisibleDataFromIdentifier( "id_village_rnpt", "afgh_rnpt001_0000", false , true )
				end,
				option = { isExecDemoPlaying = true },
				},	
			},
			nil
		}
	end,
	
	OnEnter = function()
		Fox.Log("#### s10020:Enter Seq_Demo_RescueMillerExplanation ####")

		
		Player.SetEnableDOFInSubjectiveCameraAtGen7(false)

		
		TppDataUtility.DestroyEffectFromId( "FxLocator_fx_tpp_flrdia03_s1" )

		local func = function()
			
			TppScriptBlock.LoadDemoBlock("Demo_RescueMiller")
			TppSequence.SetNextSequence("Seq_Game_RescueMiller") 
		end
		s10020_demo.RescueMillerExplanation(func)
	
	end,

	OnLeave = function()
		
		TppDataUtility.SetVisibleDataFromIdentifier( "id_village_rnpt", "afgh_rnpt001_0000", false , true )

		
		TppMission.UpdateObjective{
			
			objectives = { "default_area_village" ,"default_area_slopedTown" },
		}
		
		
		TppRadio.SetOptionalRadio( "Set_s0020_oprg6010" )

		
		TppMission.UpdateCheckPoint("CHK_MissionStart")
	end,	
	
}



sequences.Seq_Game_RescueMiller = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end
		
		return
		StrCode32Table {
			Player = {
				{ msg = "OnBehind",		 	func = self.FuncTutorial_Behind },	
				{ msg = "OnElude",		 	func = self.FuncTutorial_Elude },	
				{ msg = "OnCrawl",		 	func = self.FuncTutorial_Crawl },	
				{ msg = "OnInjury",		 	func = self.FuncTutorial_Injury },	
				{ msg = "HostageUnlock", 	func = self.FuncRescueMiller },			
			
				{ msg = "GetIntel",			sender = "Intel_village",		func = self.FuncGetIntelAtVillage },
				{ msg = "GetIntel", 		sender = "Intel_comm",			func = self.FuncGetIntelAtComm },	
				
				{ msg = "OnBinocularsMode",	func = self.FuncVillageEP_Radio },		

				{ msg = "SetMarkerBySearch", func = self.FuncOnMarkingEnemy },						 
			},
			GameObject = {
				{ msg = "Dead", 			func = self.FuncNeutralizeEnemy },									
				{ msg = "Unconscious",	 	func = self.FuncNeutralizeEnemy },									
				{ msg = "Carried",	 		func = self.FuncLiftEnemy },										
				{ msg = "DisableTranslate",	 	func = self.FuncInterrogateCount },								
				
				{ msg = "ChangePhase",	 	sender = "afgh_village_cp", 	func = self.FuncChangePhaseEvasion },	
				{ msg = "ChangePhase",	 	sender = "afgh_slopedTown_cp", 	func = function() this.FuncCheckCanPickupMiller() end,},

				{ msg = "PlayerHideHorse",	 func = self.FuncHorseHiding },	
			},
			
			Trap = {
				
				{ msg = "Enter", 	sender = "trap_ApproachIntelAtVillage_OnAlert",		func = self.FuncApproachIntelAtVillage },	
				
				{ msg = "Enter", 	sender = "trap_ApproachIntelAtComm_OnAlert",		func = self.FuncApproachIntelAtComm },	
				{ msg = "Enter", 	sender = "trap_ArriveAtVillage_EP",			func = self.FuncArriveAtVillage_EP },
				{ msg = "Enter", 	sender = "trap_ArriveAtVillage_EP2",		func = function()	svars.isInVillageEp = true	end, },
				{ msg = "Exit", 	sender = "trap_ArriveAtVillage_EP2",		func = function()	svars.isInVillageEp = false	end, },
				{ msg = "Enter", 	sender = "trap_ArriveFarEP",				func = function()	svars.isInFarEp = true	end, },
				{ msg = "Exit", 	sender = "trap_ArriveFarEP",				func = function()	svars.isInFarEp = false	end, },

				{ msg = "Enter", 	sender = "trap_ApproachMiller",				func = self.FuncApproachMillerOnAlert_Radio },
				{ msg = "Enter", 	sender = "trap_ApproachMiller_check",		func = self.FuncApproachMillerOnAlert },
	
				{ msg = "Enter", 	sender = "trap_ArriveAtCommFacility",		func = self.FuncArriveAtCommFacility },
				{ msg = "Exit", 	sender = "trap_ArriveAtCommFacility",		func = self.FuncExitAtCommFacility },

				{ msg = "Enter", 	sender = "trap_ApproachWayToEnemyBase",		func = self.FuncApproachWayToEnemyBase },
				{ msg = "Enter", 	sender = "trap_ArriveAtEnemyBase",			func = self.FuncArriveAtEnemyBase },
				{ msg = "Enter", 	sender = "trap_ArriveAtSlopedTown",			func = self.FuncArriveAtSlopedTown },
				{ msg = "Enter", 	sender = "trap_ArriveAtVillage",			func = self.FuncArriveAtVillage },
				{ msg = "Enter", 	sender = "trap_ApproachVillage",			func = self.FuncApproachVillage },
				{ msg = "Enter", 	sender = "trap_LowStance",					func = self.FuncLowStance },

				{ msg = "Enter", 	sender = "trap_NotUseBino",					func = self.FuncNotUseBinoArriveAtVillage },
							
				{ msg = "Enter", 	sender = "trap_ArriveAtFirstOB",			func = self.FuncArriveAtFirstOB },
				{ msg = "Exit", 	sender = "trap_ArriveAtFirstOB",			func = function()	svars.isInFirstOB = false	end },
				{ msg = "Enter", 	sender = "trap_ArriveAtOB",					func = self.FuncArriveAtOB },
				{ msg = "Enter", 	sender = "trap_ArriveAtWall",				func = self.FuncArriveAtwall },
				
				{ msg = "Enter", 	sender = "trap_LeaveFromVillage",			func = self.FuncLeaveFromVillage },
				{ msg = "Enter", 	sender = "trap_MovingByWalk",				func = self.FuncMovingByWalk },
				{ msg = "Enter", 	sender = "trap_Advice",						func = self.FuncTutolialOptionalRadio },

				{ msg = "Enter", 	sender = "trap_Ruins",						func = self.FuncBasicTutolial },	
				{ msg = "Enter", 	sender = "trap_ArriveAtClimb",				func = self.FuncArriveAtClimb },	
				{ msg = "Enter", 	sender = "trap_ArriveAtJump",				func = self.FuncTutolialJump },	
				
				{ msg = "Enter", 	sender = "trap_ArriveAtVillageBuild",		func = self.Func_ArriveAtVillageBuild },	
				{ msg = "Enter", 	sender = "trap_ArriveAtVillageBuild2F",		func = self.Func_ArriveAtVillageBuild2F },	
				
				{ msg = "Enter", 	sender = "trap_ArriveAtMillerRoom",			func = self.FuncArriveAtMillerHouse_Intel },		
				{ msg = "Exit", 	sender = "trap_ArriveAtMillerRoom",			func = self.FuncArriveAtMillerHouse_Intel_exit },	
			},
			Timer = {
				{ msg = "Finish",	sender = "HowToRiddenHorse",				func = 	self.FuncRiddenHorse	},
				{ msg = "Finish",	sender = "DriverStart",						func = 	self.FuncVehicleStartTravel	},	
				{ msg = "Finish",	sender = "CheckCanPickupMiller",			func = 	this.FuncCheckCanPickupMiller	},	
				
			},
			Weather = {
				{ msg = "Clock",	sender = "DayCount",						func = 	self.FuncDayCount	},

				{ msg = "Clock",	sender = "MirrorRoomLight_On",				func = 	self.FuncMirrorRoomLight_On	},
				{ msg = "Clock",	sender = "MirrorRoomLight_Off",				func = 	self.FuncMirrorRoomLight_Off	},
				{ msg = "Clock",	sender = "VehicleStartTravel",				func = 	self.FuncVehicleStartTravel	},			
			},
			Marker = {

			},
			Terminal = {
			},
			Sound = {
				{ msg = "ChangeBgmPhase",	 	func = self.FuncChangePhaseStopBGM },
			},
			Radio = {
				{ msg = "Finish", sender = "s0020_rtrg2010",	func = self.FuncGetIntel_Hud  },				
				{ msg = "Finish", sender = "s0020_rtrg2020",	func = self.FuncGetIntel_Hud  },				
				{ msg = "Finish", sender = "f1000_rtrg2730",	func = self.FuncTutolialOptionalRadio_Hud },	
				{ msg = "Finish", sender = "s0020_rtrg0270",	func = self.FuncTutolialOptionalRadio_Hud },	
				{ msg = "Finish", sender = "f1000_rtrg3000",	func = self.FuncTutolialGetOffHorse },			
				{ msg = "Finish", sender = "s0020_rtrg0260",	func = self.FuncTutolialGetOffHorse },			
				{ msg = "Finish", sender = "f1000_rtrg2970",	func = self.FuncTutorial_Callhorse_Hud },		
				{ msg = "Finish", sender = "s0020_rtrg0130",	func = self.FuncTutorial_Injury_Hud },			
				{ msg = "Finish", sender = "s0020_rtrg0132",	func = self.FuncLowStance_Hud },				
 				{ msg = "Finish", sender = "f1000_rtrg2740",	func = self.FuncTutolialAtFirstOB },		
				{ msg = "Finish", sender = "f1000_rtrg3020",	func = self.FuncPutCustumMarker_Hud },			
				{ msg = "Finish", sender = "f1000_rtrg2010",	func = self.FuncHorseHide },		
				{ msg = "Finish", sender = "s0020_oprg0080",	func = function() TppUI.ShowControlGuide{ actionName = "EQUIPMENT_WP", continue = false } end },		
				{ msg = "Finish", sender = "s0020_oprg0090",	
					func =	function() 
						
						
						TppTutorial.DispGuide( "COVER", TppTutorial.DISPLAY_OPTION.TIPS_IGONORE_DISPLAY )
					end },		
				{ msg = "Finish", sender = "s0020_oprg0120",	
					func = function() 
						
						
						TppTutorial.DispGuide( "HORSE_HIDEACTION", TppTutorial.DISPLAY_OPTION.TIPS_IGONORE_DISPLAY )
					end },
				{ msg = "Finish", sender = "s0020_oprg0110",	
					func = function() 
						
						
						TppTutorial.DispGuide( "ACTION_MAKENOISE", TppTutorial.DISPLAY_OPTION.TIPS_IGONORE_DISPLAY )
					end },	
				{ msg = "Finish", sender = "f1000_oprg0085",	
					func = function() 
						
						
						TppTutorial.DispGuide( "WEAPON_RANGE", TppTutorial.DISPLAY_OPTION.TIPS_IGONORE_DISPLAY )
					end },	
				{ msg = "EspionageRadioCandidate", 	func = self.FuncTutolialCustumMarker_map },
			},
			nil
		}
	end,
	
	OnEnter = function()
		Fox.Log("#### s10020:Enter Seq_Game_RescueMiller ####")

		
		this.FuncFultonSetting()

		
		TppClock.RegisterClockMessage( "DayCount" , MISSION_STARTTIME )		
		TppClock.RegisterClockMessage( "MirrorRoomLight_On","18:15:00" )			
		TppClock.RegisterClockMessage( "MirrorRoomLight_Off","06:15:00" )			
		TppClock.RegisterClockMessage( "VehicleStartTravel","17:30:00" )			

		
        TppUiStatusManager.UnsetStatus( "CallMenu", "INVALID" )
        
		
		TppUiStatusManager.UnsetStatus( "MbMap", "BLOCK_RADIO" )

		
		TppUiStatusManager.UnsetStatus( "ActionIcon", "INVALID" )

		
		TppUiStatusManager.UnsetStatus( "Subjective", "MARKER_HELP_OFF" )
	
		
		TppRadioCommand.ForceHideEspionageIcon( false )

		
		this.FuncTutorial_MBMenuMaskReset()

		
		TppSound.StopSceneBGM()	
		
		
		TppRadio.ChangeIntelRadio( s10020_radio.intelRadioList_mission )

		
		TppRadioCommand.SetEnableEspionageRadio( true )
		TppRadioCommand.SetEnableEspionageRadioTarget{ name= 
			{ 	"erl_binotutolial_village",	
				"erl_slopedTpwn_MirrorHouse",
				"erl_slopedTpwn_MirrorHouse_Intel" 
			}, enable = false }
		TppRadioCommand.SetEnableEspionageRadioTarget{ name= 
			{ 	"erl_village_canal" , 
				"erl_village_IntelHouse",
				"erl_flag",
				"erl_Center",
			}, enable = true }

		
		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("afgh_enemyBase_cp"),
			{ 
				{ name = "enqt1000_106939", func = s10020_enemy.InterCall_TargetPlace_enemyBase, },
			}
		)
		
		
		local ContinueCount = TppSequence.GetContinueCount()
		if ContinueCount == 0	then
			
			svars.isAfghBGM_on = true
			TppSound.SetSceneBGM("bgm_afghanistan")
			
			
			TppSoundDaemon.PostEvent( "sfx_m_fulton_6_lift_up_oce" )

			
			
			TppTelop.StartMissionObjective()
			
			
			TimerStart( "HowToRiddenHorse", 3)
			
		elseif	ContinueCount == 1 or 
			ContinueCount == 2 or 
			ContinueCount >= 6 then	
			
			if svars.isOnGetIntel  == true then
				s10020_radio.Continue_rescueMirror()	
			else
				s10020_radio.Continue_gotoVillage()	
			end
		
		elseif ContinueCount == 3 then 
			s10020_radio.ContinueTutorial_camof()	
		elseif ContinueCount == 4 then 
			s10020_radio.ContinueTutorial_dontMakeSound()	
		elseif ContinueCount == 5 then 
			s10020_radio.ContinueTutorial_lookYourMap()	
		end

		
		if svars.isVehicle_startTravel == true then
			if svars.isVehicle_startedTravel	== false then
				s10020_enemy.StartTravel()
				svars.isVehicle_startedTravel	= true
			end
		end
			
	end,
	
	
	
	FuncRescueMiller = function( timing, gameObjectId )
		local millerId = GameObject.GetGameObjectId(TARGET_HOSTAGE_NAME)
		
		
		if gameObjectId == millerId then	
			if svars.DayCount >= 4 then
				
				TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.S10020_TARGET_TIMEOVERDEAD , TppDefine.GAME_OVER_RADIO.S10020_TARGET_TIMEOVERDEAD )
			else
				
				if timing == TppDefine.HOSTAGE_UNLOCK_START and  gameObjectId == millerId then
					TppSequence.SetNextSequence( "Seq_Demo_RescueMiller" )
				end	
			end
		else
			
		end
	end,
	
	FuncMillerAlertLock =  function( cpName , PhaseName )
		
		if PhaseName == TppEnemy.PHASE.ALERT then
			this.FuncMillerLock()					
		else
			this.FuncMillerUnLock()		
		end
	end, 	
	

	
	FuncGetIntelAtVillage = function( intelNameHash )
		TppPlayer.GotIntel( intelNameHash )
		svars.isOnGetIntel = true
		
		local func = function() 
			
			TppMission.UpdateObjective{
				objectives = { "getIntel_area_slopedTown" , "photo_Intel_village" ,"clear_missionTask_01"},
			}
			
			this.FuncGetIntel()
			
			
			svars.isVehicle_startTravel	= true
			TimerStart( "DriverStart", DRIVER_WAITTIME)
			
			
			TppMission.UpdateCheckPoint("CHK_GetIntelatVillage")
			
			
			if svars.isOnGetIntel_AtComm == true and svars.isOnGetIntel_AtVillage == true then

			else
				s10020_radio.ObtainIntelAtVillage()
			end				

		end
		
		
		s10020_demo.GetIntel_village(func)
	end,

	
	FuncGetIntelAtComm = function( intelNameHash )
		TppPlayer.GotIntel( intelNameHash )
		svars.isOnGetIntel = true
		local func = function() 
			
			TppMission.UpdateObjective{
				objectives = { "getIntel_area_slopedTown", "photo_Intel_com" ,"clear_missionTask_01"},
			}
			
			this.FuncGetIntel()
		
			
			TppMission.UpdateCheckPoint("CHK_GetIntelatComm")

			
			if svars.isOnGetIntel_AtComm == true and svars.isOnGetIntel_AtVillage == true then

			else
				s10020_radio.ObtainIntelAtCommfacility()
			end			

		end
		
		s10020_demo.GetIntel_commFacility(func)	
	end,
	
	FuncGetIntel_Hud = function()
		TppUI.ShowControlGuide{ actionName = "MB_DEVICE", continue = false }
		
		if svars.isOnGetIntel_AtComm == true and svars.isOnGetIntel_AtVillage == true then
		else
			TppMission.UpdateObjective{
				objectives = { "announce_Intel" },
			}
		end
	end,

	
	FuncInterrogateCount = function()
		svars.InterrogateCount = svars.InterrogateCount + 1
	
		if svars.InterrogateCount == 1 then
			s10020_radio.NeedTranslater1()
		elseif svars.InterrogateCount == 3 then
			s10020_radio.NeedTranslater2()
		elseif svars.InterrogateCount == 5 then
			s10020_radio.NeedTranslater3()
		end	
		
	end,
	

	
	FuncTutolialCustumMarker_map = function( gameObjectId ) 
		if svars.isTutorial_CustumMarker == false then
			if gameObjectId == GameObject.GetGameObjectId("erl_village_IntelHouse") then
				s10020_radio.PutCustumMarker()
				svars.isTutorial_CustumMarker  = true
			end
		end
	end,
	FuncPutCustumMarker_Hud = function( ) 
	end,
	
	
	FuncTutolialOptionalRadio = function()
		if svars.isTutolial_OptionalRadio == false then
			s10020_radio.OptionalRadio()
		end
	end,

	FuncTutolialOptionalRadio_Hud = function()
		
		TppUI.ShowControlGuide{ actionName = "ADVICE", continue = false }	
		
		
		TppTutorial.DispGuide( "RADIO_ESPIONAGE", TppTutorial.DISPLAY_OPTION.TIPS_IGONORE_DISPLAY )
	end,
	
	
	FuncRiddenHorse = function()
		if svars.isTutorial_Horse_Accel == false then
			if TppBuddy2BlockController.GetActiveBuddyType() == BuddyType.HORSE then
				
				local gameObjectId 		= {type="TppHorse2", group=0, index=0}
				local command 			= {	id = "GetRidePlayer",	}
				local ridePlayer 		= GameObject.SendCommand( gameObjectId, command )
				if ridePlayer == 1 then
					
					TppUI.ShowControlGuide{ actionName = "HORSE_RUN", continue = false }	
					
					TppTutorial.DispGuide( "RIDE_HORSE", TppTutorial.DISPLAY_OPTION.PAUSE_CONTROL )
					svars.isTutorial_Horse_Accel = true
				end
			end
		end		
	end,

	
	FuncHorseHide = function()
		if svars.isTutorial_Horse_Hide == false then
			if TppBuddy2BlockController.GetActiveBuddyType() == BuddyType.HORSE then
				
				local gameObjectId 		= {type="TppHorse2", group=0, index=0}
				local command 			= {	id = "GetRidePlayer",	}
				local ridePlayer 		= GameObject.SendCommand( gameObjectId, command )
				if ridePlayer == 1 then	
					
					TppUI.ShowControlGuide{ actionName = "HORSE_HIDE", continue = false }	
					svars.isTutorial_Horse_Hide = true
				end
			end
		end
	end,

	
	FuncHorseHiding = function()
		if svars.isTutorial_Horse_Hiding == false then
			
			TppUI.ShowControlGuide{ actionName = "HORSE_HIDE_CHANGE", continue = false }
			svars.isTutorial_Horse_Hiding = true
		end
	end,
	
	
	FuncTutorial_Crawl = function()
		if svars.isTutorial_Crawl == false then
		
			


		end
	end,

	
	FuncTutorial_Elude = function()
		if svars.isTutorial_Elude == false then
		
			


			
			svars.isTutorial_Elude = true
		end
	end,

	
	FuncTutorial_Behind = function()
		if svars.isTutorial_Behind == false then
			
			TppUI.ShowControlGuide{ actionName = "COVER_ATTACK", continue = false }	
			TppUI.ShowControlGuide{ actionName = "LOOK_IN", continue = false }		

			svars.isTutorial_Behind = true
		end
	end,

	
	FuncArriveAtwall = function()
		if svars.isTutorial_Wall == false then
			
			TppUI.ShowControlGuide{ actionName = "STEP_FENCE", continue = false }	
			svars.isTutorial_Wall = true
		end
	end,
	
	
	FuncTutolialJump = function()
		if svars.isTutorial_Jump == false then
			
			TppUI.ShowControlGuide{ actionName = "JUMP", continue = false }	
			svars.isTutorial_Jump = true
		end
	end,

	
	FuncTutorial_Injury = function()
		s10020_radio.Tutorial_cure()
	end,
	
	FuncTutorial_Injury_Hud = function()
		
		TppUI.ShowControlGuide{ actionName = "CURE", continue = false }	
	end,
	
	
	FuncNeutralizeEnemy = function( GameObjectId, AttakerId, AnimalId )
		local gameObjectType = GameObject.GetTypeIndex(GameObjectId)
		local AttackerIsPlayer = Tpp.IsPlayer( AttakerId )
		
		if Tpp.IsSoldier( GameObjectId ) == true then	
			if AttackerIsPlayer == true then
				s10020_radio.Tutorial_NeutralizeEnemy()
			end
		elseif gameObjectType == TppGameObject.GAME_OBJECT_TYPE_GOAT then	
			if AttackerIsPlayer == true then
				s10020_radio.Tutorial_Animal()
			end
		end
	end,
	
	
	FuncLiftEnemy = function()
		if svars.isTutorial_OnLiftEnemy == false then
			svars.isTutorial_OnLiftEnemy = true
		end
	end,

	
	FuncOnMarkingEnemy = function(typeId)



		if svars.isTutorial_Marking == false  then
			
			if typeId == TppGameObject.GAME_OBJECT_TYPE_SOLDIER2	then
				s10020_radio.tutorial_marking()
				
				svars.isTutorial_Marking = true
			end
		end
	end,
	
	FuncTutolialAtFirstOB = function()
		if svars.isInFirstOB == true then
			s10020_radio.TutolialAtFirstOB()
			svars.isTutolial_OptionalRadio = true
		end
	end,
	
	
	FuncChangePhaseStopBGM = function(PhaseName)
		if svars.isAfghBGM_on == true then
			if PhaseName >= TppSystem.BGM_PHASE_SNEAK_1 then
				TppSound.StopSceneBGM()
				svars.isAfghBGM_on = false
			end
		end
	end,
	
	
	FuncChangePhaseEvasion = function( cpName, PhaseName )
		Fox.Log(tostring(PhaseName) )
		if PhaseName == TppEnemy.PHASE.EVASION then

			svars.is_Evasion	= true
		end
	end, 
	
	
	FuncChangePhaseCaution = function( cpName , PhaseName )
		if PhaseName >= TppEnemy.PHASE.CAUTION then
			if svars.is_Evasion == true then

			end
		end
	end, 
	

	
	FuncBasicTutolial = function()
		s10020_radio.Tutorial_Ruins()
	end,
 
	
	FuncArriveAtClimb = function()
		s10020_radio.Tutorial_Climb()
	end, 
	
	
	FuncApproachVillage = function()
		
		if 	svars.isOnGetIntel == false	 then
			s10020_radio.ApproachVillage()
			
			TppRadio.SetOptionalRadio( "Set_s0020_oprg0010" )
		end
	end,

	
	FuncArriveAtVillage_EP = function()
		
		if 	svars.isOnGetIntel == false	 then
			if svars.isTutorial_InVillageEp == false then
				s10020_radio.ArriveAtVillage_EP()
				svars.isTutorial_InVillageEp = true
			end
		end
	end,
	
	
	FuncTutolialGetOffHorse = function()
		
		if 	svars.isOnGetIntel == false	 then

			TppTutorial.DispGuide( "BINO_MARKING", TppTutorial.DISPLAY_OPTION.TIPS_IGONORE_DISPLAY )
			TppUI.ShowControlGuide{ actionName = "BINO", continue = false }

		end
	end,
	
	
	FuncVillageEP_Radio = function()
		
		if 	svars.isOnGetIntel == false	 then
			
			if svars.isInVillageEp == true then
				s10020_radio.UseBinoOnEP()
			end		
			
			
			if svars.isInFarEp == true then
				s10020_radio.ArriveAtVillage_farEP_useBino()
			end		
		end
	end,
	
	
	FuncArriveAtVillage = function()
		
		if 	svars.isOnGetIntel == false	 then
			
			if svars.isTutorial_InVillageEp == false then
				s10020_radio.NotUseBinoArriveVillage()
				svars.isTutorial_InVillageEp = true
			end
		end
	end,
	
	
	FuncLowStance = function()
		if svars.isTutorial_LowStance == false then
			s10020_radio.Tutorial_lowStance()
			svars.isTutorial_LowStance = true
		end
	end,
	
	FuncLowStance2 = function()
		if svars.isTutorial_LowStance == false then
			s10020_radio.Tutorial_lowStance()
			svars.isTutorial_LowStance = true
		else
			s10020_radio.ContinueTutorial_dontMakeSound()				
		end
	end,
	
	FuncLowStance_Hud = function()
		TppTutorial.DispGuide( "COMOF_STANCE", TppTutorial.DISPLAY_OPTION.TIPS_IGONORE_DISPLAY )





	end,
	
	
	FuncNotUseBinoArriveAtVillage = function()
		if svars.isTutorial_Marking == false then


		end
	end,
		
	
	FuncArriveAtFirstOB = function()
		s10020_radio.ArriveAtFirstOB()
		svars.isInFirstOB = true
	end,

	
	Func_ArriveAtVillageBuild = function()
		
		if svars.isOnGetIntel == false then 
			if svars.isTutorial_CustumMarker == false then
				s10020_radio.NotUseBinoIntoIntelBuild()
				svars.isTutorial_CustumMarker  = true
			end
		end
	end,

	
	Func_ArriveAtVillageBuild2F = function()
		
		if svars.isOnGetIntel  == false then
			if svars.isArriveAtVillageBuild2F == false then
				s10020_radio.InIntelHouse()
				svars.isArriveAtVillageBuild2F  = true
			end
		end
	end,
	
	
	FuncArriveAtOB = function()
		s10020_radio.ArriveAtOB()
	end,
	
	
	FuncApproachWayToEnemyBase = function()
		if Player.IsOnTheLoadingPlatform() then
		else
		 
			s10020_radio.ApproachWayToEnemyBase()
		end
	end,
	
	
	FuncArriveAtSlopedTown = function()
		if svars.isOnGetIntel == true then
			
			s10020_radio.ArriveAtSlopedTown_Intel()
			
			TppRadio.SetOptionalRadio( "Set_s0020_oprg3030" )
		else
			
			s10020_radio.ArriveAtSlopedTown_NoIntel()	
			
			TppRadio.SetOptionalRadio( "Set_s0020_oprg3010" )
		end
	end,

	
	FuncArriveAtMillerHouse_Intel = function()
		if svars.isOnGetIntel == true then
			TppMarker.Disable( "s10020_marker_miller" ) 
			s10020_radio.ArriveAtMillerHouse_Intel()
		end
	end,
	
	FuncArriveAtMillerHouse_Intel_exit = function()
		if svars.isOnGetIntel == true then
			TppMarker.Enable( "s10020_marker_miller", 1, "moving_fix", "all", 0 ) 
		end
	end,

	
	FuncArriveAtCommFacility = function()
		if svars.isOnGetIntel == true then
			
			s10020_radio.ArriveAtCommFacility_intel()
		else
			
			s10020_radio.ArriveAtCommFacility_NoIntel()	
			
			TppRadio.SetOptionalRadio( "Set_s0020_oprg1010" )
		end
	end,
	
	FuncExitAtCommFacility = function()
		if svars.isOnGetIntel == true then
			
		else
			
			
			TppRadio.SetOptionalRadio( "Set_s0020_oprg0010" )
		end
	end,
	
	
	FuncArriveAtEnemyBase = function()
		if svars.isOnGetIntel == true then
			
			s10020_radio.ArriveAtEnemyBase_Intel()
		else
			
			s10020_radio.ArriveAtEnemyBase_NoIntel()	
		end
	end,

	
	FuncLeaveFromVillage = function()
		if svars.isTutorial_CallHorseEnd == false then
			
			if svars.isArriveAtVillageBuild2F == true then
				
				if Player.GetGameObjectIdIsRiddenToLocal() == 65535 and 
				Player.IsOnTheLoadingPlatform() == false then	
					s10020_radio.Tutorial_Callhorse()
					svars.isTutorial_CallHorseEnd = true
				end
			end
		end
	end,

	
	FuncMovingByWalk = function()
		if svars.isTutorial_CallHorseEnd == false then
			
			if Player.GetGameObjectIdIsRiddenToLocal() == 65535 and 
			Player.IsOnTheLoadingPlatform() == false then	
				s10020_radio.Tutorial_Callhorse()
				svars.isTutorial_CallHorseEnd = true
			end
		end
	end,
	
	FuncTutorial_Callhorse_Hud = function()
		
		TppUI.ShowControlGuide{ actionName = "HORSE_CALL", continue = false }
	end,
	
	
	FuncApproachIntelAtVillage = function()
		if svars.isOnGetIntel_AtVillage == false then
			local phase	=	TppEnemy.GetPhase("afgh_village_cp")
			if phase == TppEnemy.PHASE.ALERT then
				s10020_radio.CantGetIntelOnAlert()
			end
		end
	end,

	
	FuncApproachIntelAtComm = function()
		if svars.isOnGetIntel_AtComm == false then
			local phase	=	TppEnemy.GetPhase("afgh_commFacility_cp")
			if phase == TppEnemy.PHASE.ALERT then
				s10020_radio.CantGetIntelOnAlert()
			end
		end
	end,

	
	
	
	
	FuncApproachMillerOnAlert = function()
	
		this.FuncCheckCanPickupMiller()
		
		local phase	=	TppEnemy.GetPhase("afgh_slopedTown_cp")
		local checkEnemy = TppEnemy.IsActiveSoldierInRange( MILLER_POS, MILLER_CHECK_RANGE )	

		if phase == TppEnemy.PHASE.ALERT and checkEnemy then
			if svars.isCantPickupMiller == false then
				TimerStart( "CheckCanPickupMiller", 5)
			end
		else
		end
	end,
	
	FuncApproachMillerOnAlert_Radio = function()
		if svars.isCantPickupMiller == true then
			s10020_radio.CantMeetsKazOnAlert()
		end
	end,



	
	FuncFirstNight = function()

		s10020_radio.FirstNight()
	end,
	
	
	FuncMirrorRoomLight_On =function()
		
		if svars.isOnGetIntel == false then 
			TppRadioCommand.SetEnableEspionageRadioTarget{ name= { "erl_slopedTpwn_MirrorHouse" }, enable = true }
		end
	end,
	FuncMirrorRoomLight_Off =function()
		
		if svars.isOnGetIntel == false then 
			TppRadioCommand.SetEnableEspionageRadioTarget{ name= { "erl_slopedTpwn_MirrorHouse" }, enable = false }
		end
	end,

	
	FuncDayCount = function()
		svars.DayCount = svars.DayCount + 1
		
		if svars.DayCount == 1 then
			s10020_radio.OneDayCourse()
			
			TppWeather.SetDefaultWeatherProbabilities()
		
		elseif svars.DayCount == 2 then
			s10020_radio.TwoDayCourse()
		
		elseif svars.DayCount == 3 then
			s10020_radio.ThreeDayCourse()
			
			local targetId =  GameObject.GetGameObjectId("TppHostageKaz", TARGET_HOSTAGE_NAME)
			GameObject.SendCommand( targetId, {
				id="SpecialAction",
				action="kaz_dead",
				interpFrame=60,
			} )
		end
	end,

	
	FuncVehicleStartTravel =function()
		if svars.isVehicle_startedTravel	== false then
			s10020_enemy.StartTravel()
			svars.isVehicle_startedTravel	= true
		end
	end,
}



sequences.Seq_Demo_RescueMiller = {
	OnEnter = function()

		local func = function() 
			
			this.FuncBuddyDogWarp()
			
			TppScriptBlock.LoadDemoBlock("Demo_ParasiteAppearance")
			TppSequence.SetNextSequence("Seq_Game_Escape") 
		end
		s10020_demo.RescueMiller(func)
	end,
	
	OnLeave = function()
	
		TppMission.UpdateCheckPoint{	
				checkPoint 		= "CHK_PickedUp_miller",
				ignoreAlert 	= true,
			}
	end,	
}




sequences.Seq_Game_Escape = {

	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end

		return
		StrCode32Table {
			Player = {
				
				{ msg = "PlayerCallEnd_PLM0020_005", 	func = function() 	TimerStart( "timer_MillerMonologue3", 1) end  },		
			},
			GameObject = {
				{ msg = "MonologueEnd", 				func = self.FuncCanReactionForMiller },	
			},
			Trap = {
				{ msg = "Enter", 	sender = "trap_ParasiteBattleStart",		func = this.FuncParasiteBattleStart },
				{ msg = "Exit", 	sender = "trap_ParasiteBattleStart",		func = function() svars.isInFirstLZonHeli = false end  },
				{ msg = "Enter", 	sender = "trap_ParasiteBattleStart_miller",		func = this.FuncParasiteBattleStart },
				{ msg = "Enter", 	sender = "trap_MillerSpeak_01",				func = self.FuncMillerMonologue1 },	
				{ msg = "Enter", 	sender = "trap_MillerSpeak_02",				func = self.FuncMillerMonologue2 },	

				{ msg = "Enter", 	sender = "trap_MillerSpeak_04",				func = self.FuncMillerMonologue4 },	
				{ msg = "Enter", 	sender = "trap_StartSparseFog",				func = self.FuncStartSparseFog },	
				{ msg = "Exit", 	sender = "trap_StartSparseFog",				func = self.FuncEndSparseFog },	
				{ msg = "Enter", 	sender = "trap_StartDenseFog",				func = self.FuncStartDenseFog },	
				{ msg = "Exit", 	sender = "trap_StartDenseFog",				func = self.FuncEndDenseFog },	

			},
			Timer = {
				{ msg = "Finish",	sender = "checkMirrorStatus",				func = 	self.FuncCheckMirrorStatus	},
				{ msg = "Finish",	sender = "timer_CanReactionForMiller",		func = 	self.FuncCanReactionForMiller_Over	},
				{ msg = "Finish",	sender = "timer_MillerMonologue3",		func = 	self.FuncMillerMonologue3	},
			},

			nil
		}
	end,
	
	OnEnter = function()
		
		svars.isPickedUpMiller = true
		
		
		TppMarker.Enable( TARGET_HOSTAGE_NAME, 0, "none", "map_and_world_only_icon", 0,true, false )

		
		this.FuncMillerUnLocked()
		
		this.FuncDisableSpecialAction()

		
		TppWeather.RequestWeather( TppDefine.WEATHER.CLOUDY )

		
		TppMission.UpdateObjective{
			radio = {
				radioGroups = "s0020_rtrg4030",		
			},
			objectives = { "goto_firstLZ" , "subGoal_gotoLZ" ,	"area_Intel_village_get" ,	"area_Intel_com_get" , "photo_miller_afterRescue"},
			}
		
		
		TppRadio.SetOptionalRadio( "Set_s0020_oprg4010" )
		
		
		TppSound.SetPhaseBGM( "kaz_rescue" )
		
		
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name="lzs_slopedTown_E_0000" })
		GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })					
		GameObject.SendCommand(gameObjectId, { id="DisableDescentToLandingZone" })		
		
		
		if TppStory.IsMissionCleard( 10020 )  == false then
			local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
			GameObject.SendCommand(gameObjectId, { id="SetCombatEnabled", enabled=false })
		end
		
		
		if svars.isFirstLZonHeli == true	then
			local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
			GameObject.SendCommand(gameObjectId, { id="DisableDescentToLandingZone" })		
		end

		
		TppSound.SkipDecendingLandingZoneWithOutCanMissionClearJingle()

		
		this.FuncDisableIntel()

		
		TimerStart( "checkMirrorStatus", 10)

		
		TppCheckPoint.Disable{ baseName = { "slopedTown", "commFacility", "village", "enemyBase", 
											"slopedWest", "villageNorth","commWest","ruinsNorth","villageEast","villageWest",} }
		
	end,

	
	FuncCheckMirrorStatus = function()
		if svars.isDontPutMiller == false then	
			if this.FuncCheckStatus_MillerCarried() then
				
				TimerStart( "checkMirrorStatus", 10)
			else
				
				local checkRange = 20
			
				if not this.FuncCheckisInRange_Miller(checkRange)  then 
					
					s10020_radio.DontPutMiller()
					TimerStart( "checkMirrorStatus", 10)
					svars.isDontPutMiller = true				
				else
					
					TimerStart( "checkMirrorStatus", 10)
				end
			end
		end
	end,

	
	FuncMillerMonologue1 = function()
		if svars.isMillerMonologue1 == false then
			s10020_radio.MillerMonologue1()	
			svars.isMillerMonologue1 = true
		end
	end,
	FuncMillerMonologue2 = function()
		if svars.isMillerMonologue2 == false then
			s10020_radio.MillerMonologue2()	
			svars.isMillerMonologue2 = true
		end
	end,
	FuncMillerMonologue3 = function()
		if svars.isMillerMonologue3 == false then
			s10020_radio.MillerMonologue3()	
			svars.isMillerMonologue3 = true
		end
	end,
	FuncMillerMonologue4 = function()
		if svars.isMillerMonologue4 == false then
			s10020_radio.MillerMonologue4()	
			svars.isMillerMonologue4 = true
		end
	end,
	
	FuncCanReactionForMiller = function(GameObjectId,speechLabel,isSuccess)
		if (speechLabel == StrCode32("KZCT_0020") and isSuccess ~= 0 ) then	 
			Player.RegisterActionButtonVoice("PLM0020_005","PlayerCallEnd_PLM0020_005","DD_Player")
			TimerStart( "timer_CanReactionForMiller", 2)
		end
	end,
	
	FuncCanReactionForMiller_Over = function()
		Player.UnregisterActionButtonVoice()
	end,

	
	FuncStartSparseFog = function()
		TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 10, { fogDensity = 0.015 } )
		TppSoundDaemon.PostEvent( "env_mist_weak" )
	end,
	
	FuncEndSparseFog = function()
		TppWeather.CancelForceRequestWeather( TppDefine.WEATHER.CLOUDY )
	end,
	
	FuncStartDenseFog = function()
		TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 5, { fogDensity = 0.09 } )
		TppSoundDaemon.PostEvent( "env_mist_thick" )
	end,
	
	FuncEndDenseFog = function()
		TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 10, { fogDensity = 0.015 } )
	end,
	

}



sequences.Seq_Demo_ParasiteAppearance = {
	OnEnter = function()
	
		svars.isParaUnitAppearanceDemo = true

		
		s10020_radio.ResetSpeech_Miller()
		
		
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite0"), { id="StartGuard" })
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite2"), { id="StartGuard" })
		
		
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="Realize" })
		GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name="lzs_villageNorth_N_0000" })

		
		TppSound.SetSceneBGM("bgm_parasites")
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10020_parasites_sp")
		
		 
		GameObject.SendCommand( { type="TppParasite2" }, { id="SetFogActionEnabled", enabled=false } )		
		
		TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 10, { fogDensity = 0.015 } )

		
		this.FuncForceVehiclesStop()

		
		TppSound.SkipDecendingLandingZoneWithOutCanMissionClearJingle()
		
		local func = function() 
			TppSequence.SetNextSequence("Seq_Game_EscapeFromParasites") 
		end
		s10020_demo.ParasiteAppearance(func)

	end,
	
	OnLeave = function()
		
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10020_parasites_sn")
		
		
		TppMission.UpdateCheckPoint("CHK_ParasiteAppearance")

	end,	
}



sequences.Seq_Game_EscapeFromParasites = {
	Messages = function( self ) 
		
		if TppPackList.IsMissionPackLabel( "afterMissionClearMovie" ) then
			return
		end
		
		return
		StrCode32Table {
			Player = {
			},
			GameObject = {
				{ msg = "Damage",						func = self.FuncDontFightParaUnit		},					
				{ msg = "StartedDiscovery",				func = self.FuncParaUnitDiscover		},					
				{ msg = "StartedCombat",				func = self.FuncEscapeFromParaUnit		},					
				{ msg = "DyingAll",						func = self.FuncKillparaUnit		},						
			},
			Trap = {
				{ msg = "Enter", 	sender = "trap_MillerSpeak_06",			func = self.FuncMillerSpeak6 },	
				{ msg = "Enter", 	sender = "trap_EscapeComplete",			func = self.FuncEscapeComplete },	
				{ msg = "Enter", 	sender = "trap_CantEscapeByWalk",		func = self.FuncCantEscapeByWalk },	
				{ msg = "Enter", 	sender = "trap_SetDeterrent",			func = self.FuncSetDeterrent },	
				{ msg = "Enter", 	sender = "trap_HeliForceRouteOff",		func = this.FuncHeliForceRouteOff },	
				{ msg = "Enter", 	sender = "trap_HeliForceRouteOff2",		func = this.FuncHeliForceRouteOff },	
			},
			Timer = {
				{ msg = "Finish",	sender = "checkMirrorStatus_para",				
					func = 	function() 
							if this.FuncCheckStatus_MillerCarried() then
							else
								if svars.isDontPutMiller == false then	
								
									local checkRange = 10
									if not this.FuncCheckisInRange_Miller(checkRange) then 
										
										s10020_radio.DontPutMiller()
										svars.isDontPutMiller = true				
									end
								end
							end
							TimerStart( "checkMirrorStatus_para", 5)	
						end,
				},
				{ msg = "Finish",	sender = "checkMirrorStatus_afterParaDemo",		
					func = 	function() 
							if this.FuncCheckStatus_MillerCarried() then
							else
								
								if svars.isStartedCombat == true then		
									local checkRange = 30
									if not this.FuncCheckisInRange_Miller(checkRange)  then 
										local targetId =  GameObject.GetGameObjectId("TppHostageKaz", TARGET_HOSTAGE_NAME) 
										GameObject.SendCommand( { type="TppParasite2" }, { id="StartTargetKill", targetId=targetId } ) 
									end	
								end
							end
							TimerStart( "checkMirrorStatus_afterParaDemo", 10)	
						end,
				},			
				{ msg = "Finish",	sender = "heliForceRouteOff",					func = 	this.FuncHeliForceRouteOff	},
			},
			Weather = {
				{ msg = "ChangeWeather",				func = self.FuncFogCleared		},							
			},		
			Demo = {
				{	
					msg = "PlayInit",
					func = function(demoId)
						Fox.Log("#### s10020  constTarget is " .. mvars.constCameraTarget)
						if 	mvars.constCameraTarget then
							TppDemoUtility.AddSubjectMapping( "Parasite0", mvars.constCameraTarget )
						end
					end,
					option = { isExecDemoPlaying = true },
				},
			},
			Radio = {
				{ msg = "Finish", sender = "s0020_rtrg5050",	func = self.FuncCantEscapeByWalk_hud  },				
			},
			nil
		}
	end,
	
	OnEnter = function()
		
		TppMarker.Enable( TARGET_HOSTAGE_NAME, 0, "none", "map_and_world_only_icon", 0,true, false )
		
		
		this.FuncChangeDamageRate_Miller(0.25)
				
		
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_village_cp , 			false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_slopedTown_cp , 		false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_commFacility_cp , 	false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_enemyBase_cp , 		false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_ruinsNorth_ob , 		false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_commWest_ob , 		false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_villageNorth_ob , 	false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_villageWest_ob , 		false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_slopedWest_ob , 		false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_02_14_lrrp , 			false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_02_34_lrrp , 			false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_14_35_lrrp , 			false)
		this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_15_36_lrrp , 			false)
		
		
		local params = {
			sightDistance = 20,
			sightVertical = 36.0,
			sightHorizontal = 48.0,
		}
		GameObject.SendCommand( { type="TppParasite2" }, { id="SetParameters", params=params } ) 
		
		
		if TppStory.IsMissionCleard( 10140 )  == true then
			GameObject.SendCommand( { type="TppParasite2" }, { id="SetFultonEnabled", enabled=true } )
		end
		
		
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite0"), { id="StartSearch" })
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite1"), { id="StartSearch" })
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite2"), { id="StartSearch" })
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite3"), { id="StartSearch" })	
		
		GameObject.SendCommand( { type="TppParasite2" }, { id="SetFogActionEnabled", enabled=false } )
		
		
		TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 0, { fogDensity = 0.015 } )
		
		svars.isFoggy = true
		
		
		
		if TppStory.IsMissionCleard( 10020 )  == false then
			TppUiStatusManager.SetStatus( "BossGaugeHead", "INVALID" )			
		else
			TppUiStatusManager.UnsetStatus( "BossGaugeHead", "INVALID" )
		end

		
		TppMission.StartBossBattle()
		
		
		if TppBuddy2BlockController.GetActiveBuddyType() == BuddyType.HORSE then
			if Player.GetGameObjectIdIsRiddenToLocal() == 65535 and 
				Player.IsOnTheLoadingPlatform() == false then	
				local gameObjectId = {type="TppHorse2", group=0, index=0}
				local command = {
					id = "SetCallHorse",
					startPosition = Vector3( 856.598, 316.444, -45.575 ), 	
					goalPosition = Vector3( 843.663, 312.744, -20.053 ) 	
				}
				GameObject.SendCommand( gameObjectId, command )
			end
		end

		
		svars.isDontPutMiller = false
		
		TimerStart( "checkMirrorStatus_para", 5)
		
		
		TimerStart( "heliForceRouteOff", 240)	

		
		this.FuncForceVehiclesStop_disable()
	
		
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10020_parasites_sn")

		
		TppCheckPoint.Disable{ baseName = { "slopedTown", "commFacility", "village", "enemyBase", 
											"slopedWest", "villageNorth","commWest","ruinsNorth","villageEast","villageWest",} }

		
		
		
		
		
		if TppStory.IsMissionCleard( 10020 )  == true then
			vars.playerDisableActionFlag = PlayerDisableAction.REFLEXMODE + PlayerDisableAction.TIME_CIGARETTE
		else
			vars.playerDisableActionFlag = PlayerDisableAction.REFLEXMODE + PlayerDisableAction.TIME_CIGARETTE + PlayerDisableAction.FULTON
		end		 
		
		
		TppSound.SkipDecendingLandingZoneWithOutCanMissionClearJingle()
		
		
		TppRadio.SetOptionalRadio( "Set_s0020_oprg5010" )
		
		
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name="lzs_villageNorth_N_0000" })
		GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })	
		GameObject.SendCommand(gameObjectId, { id="DisableDescentToLandingZone" })		
		GameObject.SendCommand(gameObjectId, { id="SetSearchLightForcedType", type="On" } ) 
		
		GameObject.SendCommand(gameObjectId, { id="SetForceRoute", route="rts_apr_villageNorth_N_0001" , point = 2 })
		GameObject.SendCommand(gameObjectId, { id="SetRequestedLandingZoneToCurrent" } ) 
		
		svars.isCanPlayParasiteDemo = true
		
		s10020_radio.GoToNewRVPointWithMiller()

	end,

	OnLeave = function()
	end,	

	
	FuncParaUnitDiscover = function(gameObjectId,reason)
		
		svars.isParaUnitFound = true
		
		if svars.isPlayParaUnitDiscoverDemo == false then
			
			if svars.isCanPlayParasiteDemo == true then
				local paraUnit0 = GameObject.GetGameObjectId("TppParasite2", "Parasite0")	
				local paraUnit1 = GameObject.GetGameObjectId("TppParasite2", "Parasite1")	
				local paraUnit2 = GameObject.GetGameObjectId("TppParasite2", "Parasite2")	
				local paraUnit3 = GameObject.GetGameObjectId("TppParasite2", "Parasite3")	

				if 	gameObjectId == paraUnit0 then
					mvars.constCameraTarget = "Parasite0"
				elseif gameObjectId == paraUnit1 then
					mvars.constCameraTarget = "Parasite1"
				elseif gameObjectId == paraUnit2 then
					mvars.constCameraTarget = "Parasite2"
				elseif gameObjectId == paraUnit3 then
					mvars.constCameraTarget = "Parasite3"
				end
				
				local startfunc = function() 
				end
				local endfunc = function() 
					TimerStart( "checkMirrorStatus_afterParaDemo", 10)	
				end		

				svars.isPlayParaUnitDiscoverDemo = true
				s10020_demo.ParasiteDiscover_upper(startfunc,endfunc)	

			end
		end
	end,

	
	FuncEscapeFromParaUnit = function()
		
		TppWeather.CancelForceRequestWeather()
		TppWeather.RequestWeather( TppDefine.WEATHER.FOGGY, { fogDensity = 0.0 } )
		
		
		
		this.FuncFultonSetting_noTimeCigarette()
		
		
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10020_parasites_al")
		
		s10020_radio.EscapeFromParaUnit()		
		svars.isStartedCombat = true
	end,
	
	
	FuncSetDeterrent = function()
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite0"), { id="SetDeterrentEnabled" ,enabled="true"})
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite1"), { id="SetDeterrentEnabled" ,enabled="true"})
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite2"), { id="SetDeterrentEnabled" ,enabled="true"})
		GameObject.SendCommand(GameObject.GetGameObjectId("TppParasite2", "Parasite3"), { id="SetDeterrentEnabled" ,enabled="true"})
	end,

	
	FuncCantEscapeByWalk = function()
		
		if svars.isEscapeComplete == false then	
			
			if svars.isStartedCombat == true then	
				
				if Player.GetGameObjectIdIsRiddenToLocal() == 65535 and 
				Player.IsOnTheLoadingPlatform() == false then	
					s10020_radio.CantEscapeByWalk()
				end
			end
		end
	end,
	FuncCantEscapeByWalk_hud = function()
		
		if svars.isTutorial_CallHorseEnd == false then
			
			TppUI.ShowControlGuide{ actionName = "HORSE_CALL", continue = false }
		end
	end,

	
	FuncDontFightParaUnit = function(gameObjectId,Id)
		local paraUnit0 = GameObject.GetGameObjectId("TppParasite2", "Parasite0")
		local paraUnit1 = GameObject.GetGameObjectId("TppParasite2", "Parasite1")
		local paraUnit2 = GameObject.GetGameObjectId("TppParasite2", "Parasite2")
		local paraUnit3 = GameObject.GetGameObjectId("TppParasite2", "Parasite3")

		if paraUnit0 == gameObjectId or 
		paraUnit1 == gameObjectId or
		paraUnit2 == gameObjectId or 
		paraUnit3 == gameObjectId then
			svars.AttackParaUnitCount = svars.AttackParaUnitCount + 1
			
			if svars.AttackParaUnitCount == 16 then
				s10020_radio.DontFightParaUnit()		
			end
		end
	end,

	
	FuncCheckMillerRange = function()
		
		if this.FuncCheckStatus_MillerCarried() then
		else
			if svars.isDontPutMiller == false then	
			
				local checkRange = 10
				if not this.FuncCheckisInRange_Miller(checkRange) then 
					
					s10020_radio.DontPutMiller()
					svars.isDontPutMiller = true				
				end
			end

			
			if svars.isStartedCombat == true then		
				local checkRange = 30
				if not this.FuncCheckisInRange_Miller(checkRange)  then 
					local targetId =  GameObject.GetGameObjectId("TppHostageKaz", TARGET_HOSTAGE_NAME) 
					GameObject.SendCommand( { type="TppParasite2" }, { id="StartTargetKill", targetId=targetId } ) 
				end	
			end
		end
	end,
	
	
	FuncEscapeComplete = function()
		if svars.isEscapeComplete == false then
			
			this.ExitParaUnit()
			
			this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_village_cp , 			true)
			this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_slopedTown_cp , 		true)
			this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_commFacility_cp , 	true)
			this.SwitchEnableCpSoldiers( s10020_enemy.soldierDefine.afgh_enemyBase_cp , 		true)
			
			svars.isEscapeComplete = true
		end
	end,

	
	FuncKillparaUnit = function()
		if svars.isKilledParaUnit == false then
			
			this.ExitParaUnit()
			
			s10020_radio.MillerKoParaUnit()
			svars.isKilledParaUnit = true
		end
	end,

	
	FuncFogCleared = function(weatherId)
		if svars.isEscapeComplete == true then
			if weatherId == TppDefine.WEATHER.SUNNY  then
				
				s10020_radio.EscapeComplete()
			end
		end
	end,
	
	
	FuncMillerSpeak6 = function()
		if svars.isEscapeComplete == true then
			if svars.isMillerMonologue6 == false then
				s10020_radio.MillerMonologue_EscapeComplete()	
				svars.isMillerMonologue6 = true
			end	
		end
	end,

}



sequences.Seq_Demo_EscapeWithMillerOnHeli = {
	OnEnter = function()
		local func = function()
			TppSequence.ReserveNextSequence( "Seq_Demo_MissionClearMovie", { isExecMissionClear = true } )

			
			TppMission.UpdateCheckPoint{	
				checkPoint = "CHK_ParasiteAppearance",
				permitHelicopter = true,
			}	
			
			local locationCode, layoutCode, clusterId
			if TppMission.GetNextMissionCodeForMissionClear() == 10030 then
				locationCode = TppDefine.LOCATION_ID.MTBS
				layoutCode = TppDefine.OFFLINE_MOHTER_BASE_LAYOUT_CODE
				clusterId = TppDefine.CLUSTER_DEFINE.Command
			end
			
			TppMission.Reload{
				isNoFade = true,
				locationCode = locationCode, 
				layoutCode = layoutCode,
				clusterId = clusterId,
				showLoadingTips = false,
				missionPackLabelName = "afterMissionClearMovie",
			}
		end
		s10020_demo.EscapeWithMillerOnHeli(func)
	end,
}



sequences.Seq_Demo_MissionClearMovie = {
	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppGameStatus.Reset("Mission", "S_IS_ONLINE")
			TppNetworkUtil.SessionDisconnectPreparingMembers()
			TppNetworkUtil.CloseSession()
			Dynamite.ResetClientSessionState()
			Dynamite.StopNearestEnemyThread()
		end
		TppMovie.Play{
			videoName = "p31_010055_movie",	
			onEnd = function()
				
				local ignoreMtbsLoadLocationForce
				if TppMission.GetNextMissionCodeForMissionClear() == 10030 then
					ignoreMtbsLoadLocationForce = true
				else
					
					TppUI.SetFadeColorToBlack()
				end
				TppMission.MissionFinalize{ isNoFade = true , showLoadingTips = false, ignoreMtbsLoadLocationForce = ignoreMtbsLoadLocationForce }
			end,
			memoryPool = "p31_010055_movie",
		}
	end,
}



if DEBUG then
sequences.Seq_Game_DebugPlayMovie = {

	OnEnter = function()
		TppMovie.Play{
			videoName = "p31_010055_movie",	
			onEnd = function()
				TppMission.MissionFinalize{ isNoFade = true }
			end,
		}
	end,
}
end



return this
