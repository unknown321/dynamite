local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local TimerStart = GkEventTimerManager.Start

this.DEBUG_strCode32List = {
	"wmu_s10140_0000",
	"wmu_s10140_0001",
	"wmu_s10140_0002",
	"wmu_s10140_0003",
}

local sequences = {}





this.MISSION_START_INITIAL_WEATHER  = TppDefine.WEATHER.CLOUDY


this.NPC_ENTRY_POINT_SETTING = {
	[TppDefine.INIT_HELI_ROUTE] = {
		[EntryBuddyType.VEHICLE] = { Vector3(723.530, -11.217, 1073.911), 19.24 }, 
		[EntryBuddyType.BUDDY] = { Vector3(724.232, -11.217, 1083.777), 12.44 }, 
	},
}




local CODETALKER		= "CodeTalker"
local OCELOT			= "Ocelot"
local SUPPORT_HELI		= "SupportHeli"
local BOSS_CLEAR_COUNT	= 4 


this.fogLvTable = {
	"None",		
	"Sparse",	
	"Dense"		
}





function this.OnLoad()
	Fox.Log("#### OnLoad ####")
	TppSequence.RegisterSequences{
		"Seq_Demo_Opening",
		"Seq_Demo_CodeTalker_Evacuate",

		"Seq_Game_MainGame",
		"Seq_Game_Escape",

		"Seq_Demo_Inside_Heli",
		"Seq_Demo_TorturedHueyAtMB",
		"Seq_Demo_GoToLastMission",
		"Seq_Demo_PandemicConverge",
		
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	
	isNearCodeTalker		= false,	
	isStayClearTrap			= false,	
	isArrivedHeli			= false,	
	
	
	isBittenByZombies		= false,	
	recoveryCountParasites	= 0,		

	
	isFinishFirstRadio		= false,	
	outOfHotzoneCount		= 0,		
	nearCodeTalkerCount		= 0,		
	bossDyingNum			= 0, 		
	
	
	isPrintLog				= false,	
	isPlayDemo				= false,	
	isSkipDemo				= false,	
}


this.checkPointList = {
	"CHK_BossBattleStart",	
	"CHK_AfterClear",		
	"CHK_MBdemo",			
	nil
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 2 },
	},
	second = {
		missionTask = { taskNo = 3 },
		pointList = {
			3000,
			5000,
			7000,
			10000,
		},
	}
}



 
this.missionObjectiveEnum = Tpp.Enum {
	
	"subGoal_defeatParasites",
	"subGoal_recoveryCodeTalker",
	
	
	"default_missionTask_01",
	"default_missionTask_02",
	"default_missionTask_03",
	"default_missionTask_04",

	"appear_missionTask_02",
	"appear_missionTask_04",
	
	"complete_missionTask_01",
	"complete_missionTask_02",
	"complete_missionTask_03",
	"complete_missionTask_04",
	
	"announce_defeatParasites",
	"announce_achieveObjective",
	
	"guardTarget_Codetalker",
	"guardTarget_Codetalker_disable"
}

this.missionObjectiveDefine = {
	
	subGoal_defeatParasites = {
		subGoalId = 0,
	},
	subGoal_recoveryCodeTalker = {
		subGoalId = 1,
	},
	
	
	default_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = false },
	},
	complete_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = true },
	},
	
	default_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = true },
	},
	appear_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false },	
	},
	complete_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = true },
	},
	
	default_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide = true },
	},
	complete_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = true },
	},
	
	default_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide = true },
	},
	appear_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = false },	
	},
	complete_missionTask_04 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = true },
	},
	
	announce_defeatParasites = {
		announceLog = "eliminateTarget",
	},
	announce_achieveObjective= {
		announceLog = "achieveAllObjectives",
	},
	guardTarget_Codetalker = {
		gameObjectName = CODETALKER, goalType = "defend", setImportant = true, viewType = "map_and_world_only_icon", langId="marker_chara_codetalker",
	},
	guardTarget_Codetalker_disable = {},
}

this.missionObjectiveTree = {
	
	subGoal_recoveryCodeTalker = {
		subGoal_defeatParasites = {},
	},
	
	
	complete_missionTask_01 = {
		default_missionTask_01 = {},
	},
	complete_missionTask_02 = {
		appear_missionTask_02 = {
			default_missionTask_02 = {},
		},
	},
	complete_missionTask_03 = {
		default_missionTask_03 = {},
	},
	complete_missionTask_04 = {
		appear_missionTask_04 = {
			default_missionTask_04 = {},
		},
	},
	
	announce_defeatParasites = {},
	announce_achieveObjective = {},
	
	guardTarget_Codetalker_disable = {
		guardTarget_Codetalker = {},
	},
}





this.VARIABLE_TRAP_SETTING = {
	
	{ name = "trig_hotZone", 	type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE, packLabel = { "default" }, } ,
	{ name = "trig_innerZone", 	type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE, packLabel = { "default" }, } ,
	{ name = "trig_outerZone", 	type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE, packLabel = { "default" }, } ,
	{ name = "trig_parasiteCombatArea", 	type = TppDefine.TRAP_TYPE.TRIGGER, initialState = TppDefine.TRAP_STATE.DISABLE, packLabel = { "default" }, } ,
}






function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare !!!! ***")

	this.RegisterMissionSystemCallback()

	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "Demo_Opening" },
	}
	

end


function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
	if TppMission.IsMissionStart() then
	 	
		TppWeather.RequestWeather( TppDefine.WEATHER.FOGGY, 0, {fogDensity=0.01} )
	end
	
end



function this.RegisterMissionSystemCallback()
	local missionName = TppMission.GetMissionName()
	Fox.Log("#### " .. tostring(missionName) .. "_sequence.RegisterMissionSystemCallback ####")

	
	local systemCallbackTable ={
		OnOutOfMissionArea			= this.OnOutOfMissionArea,		
		OnEstablishMissionClear		= this.OnEstablishMissionClear,	
		OnEndMissionCredit			= this.OnEndMissionCredit,		
		OnEndMissionReward			= this.OnEndMissionReward,		
		OnGameOver					= this.OnGameOver,				
		OnSetMissionFinalScore		= this.OnSetMissionFinalScore,	
		OnDisappearGameEndAnnounceLog = function()
			TppDemo.ReserveInTheBackGround{ demoName = "Demo_Inside_Heli" }
			TppMission.ShowMissionResult()
		end,
		nil
	}
	
	TppMission.RegisterMissionSystemCallback(systemCallbackTable)
end


function this.OnSetMissionFinalScore()
end


function this.OnOutOfMissionArea()
	Fox.Log("#### s10140_sequence.OnOutOfMissionArea ####")
	TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.OUTSIDE_OF_MISSION_AREA, TppDefine.GAME_OVER_RADIO.OTHERS )	
end


function this.OnEstablishMissionClear()
	Fox.Log("#### s10140_sequence.OnEstablishMissionClear ####")
	
	
	
	TppTerminal.AcquireKeyItem{
		dataBaseId = TppMotherBaseManagementConst.DESIGN_3003,
		pushReward = true,
	}
	
end


function this.OnEndMissionCredit()
	Fox.Log("#### s10140_sequence.OnEndMissionCredit ####")
	TppSequence.ReserveNextSequence( "Seq_Demo_Inside_Heli", { isExecMissionClear = true })

	
	TppScriptBlock.LoadDemoBlock(
		"Demo_Inside_Heli",
		false 
	)

	TppMission.DisablePauseForShowResult()				

	TppMission.Reload{
		isNoFade				= true,
		missionPackLabelName	= "AfterClear",
	}

	TppMission.UpdateCheckPoint("CHK_AfterClear")		
end


function this.OnEndMissionReward()
	Fox.Log("#### s10140_sequence.OnEndMissionReward ####")
	
	
	TppSequence.ReserveNextSequence( "Seq_Demo_PandemicConverge", { isExecMissionClear = true })

	TppScriptBlock.LoadDemoBlock(
		"Demo_PandemicConverge",
		false 
	)
	
	
	TppMission.Reload{
		isNoFade				= true,
		missionPackLabelName	= "MBdemo",	
		locationCode			= TppDefine.LOCATION_ID.MTBS,
		layoutCode				= TppDefine.OFFLINE_MOHTER_BASE_LAYOUT_CODE,
		clusterId				= 7,	
		OnEndFadeOut			= function()
			MotherBaseStage.LockCluster(7)
			TppPlayer.SetInitialPosition({-163.605, 0.000, -2098.350},0)
		end
	}
	
	TppMission.UpdateCheckPoint("CHK_MBdemo")
end


function this.OnGameOver( gameOverType )
	Fox.Log("#### s10140_sequence.OnGameOver ####")
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
		
		TppPlayer.SetTargetDeadCamera{ gameObjectName = CODETALKER }	
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.HELICOPTER_DESTROYED ) then
		
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		TppUiCommand.SetGameOverType('TimeParadox')
		return true
	end
end


function this.ReserveMissionClear()
	Fox.Log("#### s10140_sequence.ReserveMissionClear ####")
	TppMission.ReserveMissionClear{
		missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
		nextMissionId = 40050,
	}
end


function this.OnTerminate()
	Fox.Log("##### s10140_sequence.OnTerminate #####")
	TppWeather.CancelRequestWeather( TppDefine.WEATHER.SUNNY, 5 )
	vars.playerDisableActionFlag = PlayerDisableAction.NONE
	TppUiCommand.StartTelopCast()	
end




function this.Messages()
	return
	StrCode32Table {
		GameObject = {
			{	msg =	"Dead",									func =	this.CheckDeadNPC,},
			{	msg =	"Fulton",								func =	this.CheckFultonNPC,},
			nil
		},
		Demo = {
			
			{	msg =	"SetZombieOnDemo",
				func =	function()
					s10140_enemy.SetZombie("zmb_s10140_0000")
				end,
				option = { isExecDemoPlaying = true }
			},
			{	msg =	"p41_060220_QuietWarp",
				func =	function()
					this.SetBuddyQuietPositionOnDemo()
				end,
				option = { isExecDemoPlaying = true }
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


this.SetBuddyQuietPositionOnDemo = function()
	local warpPos = Vector3(582.7172,2.733719,1175.847)
	local warpRot = 0.0

	local gameObjectType = "TppBuddyQuiet2"
	local doesExist = GameObject.DoesGameObjectExistWithTypeName( gameObjectType )	
	
	
	if ( doesExist ) then
		Fox.Log( "#### s10140_sequence.SetBuddyQuietPositionOnDemo #### Buddy Quiet Exist! warpPos = " ..tostring(warpPos).. ", warpRot = " ..tostring(warpRot) )
		local gameObjectId = GameObject.GetGameObjectIdByIndex(gameObjectType, 0)
		GameObject.SendCommand(gameObjectId, { id = "WarpToPosition", position = warpPos, rotationY = warpRot })
	else
		Fox.Log( "#### s10140_sequence.SetBuddyQuietPositionOnDemo #### Buddy Quiet Not Exist..." )	
	end
end


this.CheckDeadNPC = function( characterId, attackerId )
	Fox.Log( "#### s10140_sequence.CheckDeadNPC #### characterId = " .. characterId .. ", attackerId = ".. attackerId )

	
	if characterId == GameObject.GetGameObjectId( "TppCodeTalker2", CODETALKER ) then
		Fox.Log( "#### s10140_sequence.CheckDeadNPC #### Execute GameOver. Because CodeTalker Died!" )
		if attackerId == 0 then
			s10140_radio.PlayerKillFriend("codetalker")
		end
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )
		
	else
		Fox.Log( "#### s10140_sequence.CheckDeadNPC #### Not Execute GameOver. Because Normal NPC Died!" )
	end
end


this.CheckFultonNPC = function( characterId )
	Fox.Log( "#### s10140_sequence.CheckFultonNPC #### characterId = " .. characterId )

	
	if 	characterId == GameObject.GetGameObjectId( "TppParasite2", "wmu_s10140_0000" ) or
		characterId == GameObject.GetGameObjectId( "TppParasite2", "wmu_s10140_0001" ) or
		characterId == GameObject.GetGameObjectId( "TppParasite2", "wmu_s10140_0002" ) or
		characterId == GameObject.GetGameObjectId( "TppParasite2", "wmu_s10140_0003" ) then

		Fox.Log( "#### s10140_sequence.CheckFultonNPC #### Parasites Recoveried!" )
		svars.recoveryCountParasites = svars.recoveryCountParasites + 1
		TppResult.AcquireSpecialBonus{ second = { isComplete = true, pointIndex = svars.recoveryCountParasites }, }
	else
		Fox.Log( "#### s10140_sequence.CheckFultonNPC #### Not Execute This Function. Because Normal NPC Recovered..." )
	end
end


this.CheckMissionTask_02 = function()
	Fox.Log( "#### s10140_sequence.CheckMissionTask_02 #### svars.isBittenByZombies = "..tostring(svars.isBittenByZombies) )
	if not(svars.isBittenByZombies) then
		Fox.Log( "#### s10140_sequence.CheckMissionTask_02 #### Mission Task Completed!" )
		TppResult.AcquireSpecialBonus{ first = { isComplete = true }, }			
	end
end


this.CheckMissionTask_04 = function()
	Fox.Log( "#### s10140_sequence.CheckMissionTask_04 #### svars.recoveryCountParasites = "..tostring(svars.recoveryCountParasites) )
	if ( svars.recoveryCountParasites == BOSS_CLEAR_COUNT ) then
		Fox.Log( "#### s10140_sequence.CheckMissionTask_04 #### Mission Task Completed!" )
	else
		Fox.Log( "#### s10140_sequence.CheckMissionTask_04 #### Mission Task Updated." )
	end
end


this.SetEnabledHeli = function (flag)
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI)
	if gameObjectId ~= NULL_ID then
		Fox.Log( "#### s10140_sequence.SetEnabledHeli #### flag = " .. tostring(flag) )
		GameObject.SendCommand( gameObjectId, { id = "SetEnabled", enabled = flag} )
	end
end


function this.CallHeli()
	Fox.Log("#### s10140_sequence.CallHeli ####")
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI)
	GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name="lzs_pfCamp_Mid_0000" })	
	GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })										
	GameObject.SendCommand(gameObjectId, { id="DisableDescentToLandingZone" })							
	
	TppSound.SkipDecendingLandingZoneJingle()
	TppSound.SkipDecendingLandingZoneWithOutCanMissionClearJingle()
end


function this.CheckMissionClear()
	Fox.Log("#### s10140_sequence.CheckMissionClear #### isNearCodeTalke = "..tostring(svars.isNearCodeTalker).. ", isArrivedHeli = "..tostring(svars.isArrivedHeli).. ", isStayClearTrap = "..tostring(svars.isStayClearTrap))	

	
	if ( svars.isNearCodeTalker and svars.isArrivedHeli ) then
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI)
		GameObject.SendCommand(gameObjectId, { id="EnableDescentToLandingZone" })
		TppSound.StopSceneBGM()

		
		TppMission.UpdateObjective{
			objectives = {
				"announce_achieveObjective",
				"complete_missionTask_02",
				"guardTarget_Codetalker_disable",
			},
		}
		s10140_radio.ArrivedHeli()

		
		Player.SetPadMask {
			settingName = "MissionClear",
			except = true,
			sticks = PlayerPad.STICK_R,
		}		

		
		TppMusicManager.PostJingleEvent( "SingleShot", "Play_bgm_mission_heli_descent")
		this.StartTimer("timer_fade", 5)


		
		TppHero.AddTargetLifesavingHeroicPoint( false, true )
		
	
	elseif ( svars.isArrivedHeli ) then
		s10140_radio.PleasePutOnCodeTalker()
		
	
	else
	
	end
end


this.StartTimer = function( timerName, timerTime )
	Fox.Log( "#### s10140_sequence.StartTimer #### timerName = " ..tostring(timerName).. ", timerTime = " .. tostring(timerTime))
	if not GkEventTimerManager.IsTimerActive( timerName ) then
		GkEventTimerManager.Start( timerName, timerTime )
	end
end


this.SetLimitationForIDORID = function(setFlag)
	Fox.Log( "#### s10140_sequence.SetLimitationForIDORID #### Limitation = " ..tostring(setFlag))
	
	if ( setFlag ) then
		TppTerminal.SetActiveTerminalMenu{
			TppTerminal.MBDVCMENU.MBM,
			TppTerminal.MBDVCMENU.MBM_REWORD,
			TppTerminal.MBDVCMENU.MBM_CUSTOM,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_WEAPON,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_ARMS,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_ARMS_HELI,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_ARMS_VEHICLE,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_HORSE,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_DOG,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_QUIET,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_WALKER,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_BUDDY_BATTLE,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_DESIGN,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_DESIGN_EMBLEM,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_DESIGN_BASE,
			TppTerminal.MBDVCMENU.MBM_CUSTOM_AVATAR,
			TppTerminal.MBDVCMENU.MBM_DEVELOP,
			TppTerminal.MBDVCMENU.MBM_DEVELOP_WEAPON,
			TppTerminal.MBDVCMENU.MBM_DEVELOP_ARMS,
			TppTerminal.MBDVCMENU.MBM_RESOURCE,
			TppTerminal.MBDVCMENU.MBM_STAFF,
			TppTerminal.MBDVCMENU.MBM_COMBAT,
			TppTerminal.MBDVCMENU.MBM_BASE,
			TppTerminal.MBDVCMENU.MBM_BASE_SECURITY,
			TppTerminal.MBDVCMENU.MBM_BASE_EXPANTION,
			TppTerminal.MBDVCMENU.MBM_DB,
			TppTerminal.MBDVCMENU.MBM_DB_ENCYCLOPEDIA,
			TppTerminal.MBDVCMENU.MBM_DB_KEYITEM,
			TppTerminal.MBDVCMENU.MBM_DB_CASSETTE,
			TppTerminal.MBDVCMENU.MBM_LOG,
			TppTerminal.MBDVCMENU.MSN,
			TppTerminal.MBDVCMENU.MSN_EMERGENCIE_N,
			TppTerminal.MBDVCMENU.MSN_EMERGENCIE_F,
			TppTerminal.MBDVCMENU.MSN_DROP,
			TppTerminal.MBDVCMENU.MSN_DROP_BULLET,
			TppTerminal.MBDVCMENU.MSN_DROP_WEAPON,
			TppTerminal.MBDVCMENU.MSN_DROP_LOADOUT,
			TppTerminal.MBDVCMENU.MSN_DROP_VEHICLE,
			TppTerminal.MBDVCMENU.MSN_BUDDY,
			TppTerminal.MBDVCMENU.MSN_BUDDY_HORSE,
			TppTerminal.MBDVCMENU.MSN_BUDDY_HORSE_DISMISS,
			TppTerminal.MBDVCMENU.MSN_BUDDY_DOG,
			TppTerminal.MBDVCMENU.MSN_BUDDY_DOG_DISMISS,
			TppTerminal.MBDVCMENU.MSN_BUDDY_QUIET_SCOUT,
			TppTerminal.MBDVCMENU.MSN_BUDDY_QUIET_ATTACK,
			TppTerminal.MBDVCMENU.MSN_BUDDY_QUIET_DISMISS,
			TppTerminal.MBDVCMENU.MSN_BUDDY_WALKER,
			TppTerminal.MBDVCMENU.MSN_BUDDY_WALKER_DISMISS,
			TppTerminal.MBDVCMENU.MSN_BUDDY_BATTLE,
			TppTerminal.MBDVCMENU.MSN_BUDDY_BATTLE_DISMISS,
			TppTerminal.MBDVCMENU.MSN_BUDDY_EQUIP,
			TppTerminal.MBDVCMENU.MSN_ATTACK,
			TppTerminal.MBDVCMENU.MSN_ATTACK_ARTILLERY,
			TppTerminal.MBDVCMENU.MSN_ATTACK_SMOKE,
			TppTerminal.MBDVCMENU.MSN_ATTACK_SLEEP,
			TppTerminal.MBDVCMENU.MSN_ATTACK_CHAFF,
			TppTerminal.MBDVCMENU.MSN_ATTACK_WEATHER,
			TppTerminal.MBDVCMENU.MSN_ATTACK_WEATHER_SANDSTORM,
			TppTerminal.MBDVCMENU.MSN_ATTACK_WEATHER_STORM,
			TppTerminal.MBDVCMENU.MSN_ATTACK_WEATHER_CLEAR,
			TppTerminal.MBDVCMENU.MSN_MISSIONLIST,
			TppTerminal.MBDVCMENU.MSN_SIDEOPSLIST,
			TppTerminal.MBDVCMENU.MSN_LOCATION,
			TppTerminal.MBDVCMENU.MSN_RETURNMB,
			TppTerminal.MBDVCMENU.MSN_FOB,
			TppTerminal.MBDVCMENU.MSN_FRIEND,
			TppTerminal.MBDVCMENU.MSN_LOG ,
		}	
	
	else
		TppTerminal.SetActiveTerminalMenu {
			TppTerminal.MBDVCMENU.ALL,
		}
	end
end


this.SetMeshForRustyTank = function()




end


this.ActivateDD = function( activateFlag )
	local gameObjectId	= { type="TppBuddyDog2", index=0 }
	local command		= { id = "LuaAiStayAndSnarl" }		

	if ( activateFlag ) then
		
		local pos1 = Vector3(733.022, -12.017, 1085.288)	
		local pos2 = Vector3(731.059, -12.017, 1094.948)	
		command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2, useMarker = true}
	end
	
	
	if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
		Fox.Log("#### s10050_sequence.ActivateDD #### [ "..tostring(activateFlag).." ]")
		GameObject.SendCommand( gameObjectId, command )
	else
		Fox.Log("#### s10050_sequence.ActivateDD #### [ not execute! ] because DD not exist...")
	end
end


this.CheckNgAction = function ( actor, target, type )
	Fox.Log("#### s10050_sequence.CheckNgAction #### actor = [ "..actor.." ], target = [ "..target.." ], type = [ "..type.." ]")
	
	local target_codetalker	= GameObject.GetGameObjectId( "TppCodeTalker2", CODETALKER )
	local target_parasite	= {
		[1] = GameObject.GetGameObjectId( "TppParasite2", "wmu_s10140_0000" ),
		[2] = GameObject.GetGameObjectId( "TppParasite2", "wmu_s10140_0001" ),
		[3] = GameObject.GetGameObjectId( "TppParasite2", "wmu_s10140_0002" ),
		[4] = GameObject.GetGameObjectId( "TppParasite2", "wmu_s10140_0003" ),
	}
	
	if( target == target_codetalker ) then
		
		s10140_radio.TakeAwayFromCodeTalker("action")
	elseif( target == target_parasite[1] or target == target_parasite[2] or target == target_parasite[3] or target == target_parasite[4] ) then
		if ( type == "fulton" ) then
			
			s10140_radio.NotYetFultonSkulls()
		end
	end
end



sequences.Seq_Demo_Opening = {
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					
					msg = "StartMissionTelopFadeOut",
					func = function ()
						Fox.Log("#### s10140_sequence.Seq_Demo_Opening::Messages #### StartMissionTelopFadeOut")
						
						
						local func2 = function()
							TppSequence.SetNextSequence("Seq_Demo_CodeTalker_Evacuate")
						end
						s10140_demo.PlayDemo_Opening(func2)
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()
	 	
		TppWeather.RequestWeather( TppDefine.WEATHER.CLOUDY, 0, {fogDensity=0.01} )
		TppUI.StartMissionTelop()
	end,

	OnLeave = function ()
	 	
		TppWeather.RequestWeather( TppDefine.WEATHER.FOGGY, 0, {fogDensity=0.01} )
	end,
}

sequences.Seq_Demo_CodeTalker_Evacuate = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Demo = {
				
				{	msg =	"p41_060220_StartTelop",
					func =	function()
						TppTelop.StartCastTelop()
					end,
					option = { isExecDemoPlaying = true }
				},
				







				nil
			},
			nil
		}
	end,
	
	OnEnter = function()
		this.SetMeshForRustyTank()
		local func = function() TppSequence.SetNextSequence("Seq_Game_MainGame") end
		s10140_demo.PlayDemo_CodeTalker_Evacuate(func)
	end,
}

sequences.Seq_Game_MainGame = {
	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{	msg = "Dying",								func = self.CountDyingParaUnit	},	
				{	msg = "StartedCombat",						func = self.StartBossBattle		},	
				{	msg = "StartedSmokeAction",					func = function() s10140_radio.BeCarefulRustyGus() end	},	
			},
			Player = {
				
				{	msg = "ZombBiteConnect",					func = function() svars.isBittenByZombies = true end },
				{	msg = "PressedCarryNgIcon",					func = function( arg1, arg2 ) this.CheckNgAction( arg1, arg2, "carry" )	end	},	
				{	msg = "PressedFultonNgIcon",				func = function( arg1, arg2 ) this.CheckNgAction( arg1, arg2, "fulton" )	end	},	
			},
			Radio = {
				{	msg = "Finish", sender = "s0140_rtrg1010",	func = function() svars.isFinishFirstRadio = true end },
			},
			Trap = {
				{	msg = "Enter", sender = "trap_codeTalker",	func = 	function()	s10140_radio.TakeAwayFromCodeTalker("trap")	end	},
				{	msg = "Exit", sender = "trap_codeTalker",	func = 	function()	s10140_radio.TakeAwayFromCodeTalker("trap")	end	},
			},
			Throwing = {
				
				{	msg = "NotifyStartWarningFlare",			func = function() s10140_radio.UseWarningFlare() end },
			},
			Terminal = {
				{	msg	= "MbDvcActSelectNonActiveMenu",		func=
					function(menuId)
						Fox.Log("#### s10140_sequence.Messages::MbDvcActSelectNonActiveMenu #### "..tostring(menuId))
						if ( menuId == StrCode32(TppTerminal.MBDVCMENU.MSN_HELI) or menuId == StrCode32(TppTerminal.MSN_HELI_RENDEZVOUS) )then
							s10140_radio.UseWarningFlare()
						end
					end
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

		this.SetMeshForRustyTank()
		this.ActivateDD(true)

		
		TppWeather.RequestWeather( TppDefine.WEATHER.FOGGY, 0, {fogDensity=0.01} )

		

			TppTelop.StartMissionObjective()


		TppMission.StartBossBattle()	

		
		TppTrap.Enable("trig_hotZone")
		TppTrap.Enable("trig_innerZone")
		TppTrap.Enable("trig_outerZone")
		TppTrap.Enable("trig_parasiteCombatArea")
		
		s10140_enemy.StartCombatParasite()												
		this.SetEnabledHeli(false)														
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lzs_pfCamp_Mid_0000" }	
		s10140_enemy.ProhibitCodeTalkerUnlock(true)										
		TppLandingZone.DisableUnlockLandingZoneOnMission(true)							
				
		
		TppSound.SetSceneBGM("bgm_metallic")
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10140_metallic_sn")

		
		TppRadio.SetOptionalRadio("Set_s0140_oprg1010")

		
		this.SetLimitationForIDORID(true)
		
		
		TppMission.UpdateObjective{
			objectives = {
				"subGoal_defeatParasites",
				"default_missionTask_01",
				"default_missionTask_02",
				"default_missionTask_03",
				"default_missionTask_04",
				"guardTarget_Codetalker",
			},
		}
		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE				
		s10140_radio.StartGame()														
		s10140_enemy.CheckEnableFultonParasite()										
		TppMission.UpdateCheckPoint("CHK_BossBattleStart")								
	end,
	
	OnLeave = function ()
		
		this.SetLimitationForIDORID(false)
		
		s10140_enemy.FogSetting(this.fogLvTable[1])

	end,

	
	
	StartBossBattle = function()
		Fox.Log("#### s10140_sequence.StartBossBattle ####")
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10140_metallic_al")
	end,

	
	
	CountDyingParaUnit = function( gameObjectId )
		local isSucces = s10140_enemy.CheckParasiteMessage(gameObjectId)
		if isSucces == true then
			svars.bossDyingNum = svars.bossDyingNum + 1
		end
		Fox.Log("#### s10140_sequence.CountDyingParaUnit #### dying count = "..svars.bossDyingNum)

		if svars.bossDyingNum >= BOSS_CLEAR_COUNT then
			Fox.Log("#### s10140_sequence.CountDyingParaUnit #### all dying!! go next sequence")
			TppSequence.SetNextSequence("Seq_Game_Escape")
		end
	end,
}

sequences.Seq_Game_Escape = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Trap = {
				
				{ msg =	"Enter",			sender =	"trap_checkClear",
					func =	function()
						svars.isStayClearTrap = true
						this.CheckMissionClear()
					end
				},
				
				{ msg =	"Exit",				sender =	"trap_checkClear",
					func =	function()
						svars.isStayClearTrap = false
					end
				},
			},
			Timer = {
				{ msg = "Finish",				sender = "timer_cigarette",
					func = 	function()
						Fox.Log( "#### s10140_sequence.Seq_Game_Escape #### Messages : timer_cigarette / Finish" )
						vars.playerDisableActionFlag = PlayerDisableAction.NONE	
					end
				},
				{ msg = "Finish",				sender = "timer_bgm",
					func = 	function()
						Fox.Log( "#### s10140_sequence.Seq_Game_Escape #### Messages : timer_bgm / Finish" )
						TppSound.SetSceneBGM( "bgm_post_metallic" )
					end
				},
				
				{ msg = "Finish",				sender = "timer_fade",
					func = 	function()
						Fox.Log( "#### s10140_sequence.Seq_Game_Escape #### Messages : timer_fade / Finish" )
						
						this.ReserveMissionClear()
						TppMission.MissionGameEnd()
						
					end
				},
				{ msg = "Finish",				sender = "timer_clear",
					func = 	function()
						Fox.Log( "#### s10140_sequence.Seq_Game_Escape #### Messages : timer_clear / Finish" )
						this.ReserveMissionClear()
						TppMission.MissionGameEnd()
					end
				},
			},
			GameObject = {
				{ msg =	"Carried",					sender = CODETALKER,
					func =	function()
						svars.isNearCodeTalker = true
					end
				},
				{
					msg = "Damage",			sender = SUPPORT_HELI,	func = function()	s10140_radio.PlayerAttackHeli()	end
				},
				{
					msg = "LostControl",			sender = SUPPORT_HELI,
					func = function(gameObjectId, state, gameObject)
						Fox.Log("#### s10140_sequence.Seq_Game_Escape.Messages #### LostControl : SUPPORT_HELI, state = " ..tostring(state) )
						
						
						if (state == StrCode32("Start") ) then
							s10140_radio.PlayerKillFriend("heli")
						
						elseif (state == StrCode32("End") ) then
							TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.HELICOPTER_DESTROYED, TppDefine.GAME_OVER_RADIO.PLAYER_DESTROY_HELI )
						end
					end
				},
				{
					msg = "ArrivedAtLandingZoneWaitPoint",	sender = SUPPORT_HELI,
					func = function()
						Fox.Log("#### s10140_sequence.Seq_Game_Escape.Messages #### ArrivedAtLandingZoneWaitPoint : SUPPORT_HELI")
						svars.isArrivedHeli = true
						
						TppRadio.SetOptionalRadio("Set_s0140_oprg2020")
						if (svars.isStayClearTrap ) then
							this.CheckMissionClear()
						end
					end
				},
				
				{	msg =	"PlayerGetNear",										func =
					function()
						Fox.Log( "#### s10140_sequence.Messages::PlayerGetNear ####" )
						svars.isNearCodeTalker = true
					end
				},
				
				{	msg =	"PlayerGetAway",										func =
					function()
						Fox.Log( "#### s10140_sequence.Messages::PlayerGetAway ####" )
						svars.isNearCodeTalker = false
					end
				},	
				nil
			},
			Radio = {
				{	msg = "Finish",	sender = "s0140_rtrg2020",	func =
					function()
						
						
					end
				},
			},
		}
	end,

	OnEnter = function()
		TppMission.UpdateObjective{
			objectives = {
				"announce_defeatParasites",
				"complete_missionTask_01",
			},
		}

		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10140_metallic_ed")
		this.StartTimer("timer_cigarette", 16)
		this.StartTimer("timer_bgm", 9)
		this.SetMeshForRustyTank()
		this.ActivateDD(false)
		
		TppMission.FinishBossBattle()	

		
		TppTrap.Enable("trig_hotZone")
		TppTrap.Enable("trig_innerZone")
		TppTrap.Enable("trig_outerZone")
		TppTrap.Enable("trig_parasiteCombatArea")

		s10140_enemy.FogSetting(this.fogLvTable[1])										
		s10140_enemy.UnsetAllZombies(s10140_enemy.soldierDefine.s10140_zombies_cp)		

		s10140_enemy.ProhibitCodeTalkerUnlock(false)									
		
		this.SetEnabledHeli(true)														
		TppHelicopter.SetEnableLandingZone{ landingZoneName = "lzs_pfCamp_Mid_0000" }	
		this.CallHeli()																	

		
		TppMission.UpdateObjective{
			radio = {
				radioGroups = { "s0140_rtrg2010", "s0140_rtrg2020", } ,
				radioOptions = { priority = "strong" },
			},
			objectives = {
				"subGoal_recoveryCodeTalker",
				"appear_missionTask_02",
			},
		}

		
		TppRadio.SetOptionalRadio("Set_s0140_oprg2010")

		this.CheckMissionTask_02()
		
	end,
}

sequences.Seq_Demo_Inside_Heli = {
	OnEnter = function()
		TppWeather.CancelRequestWeather()

		local func = function()
			
			Fox.Log("#### s10140_sequence.Seq_Demo_Inside_Heli ####")
			TppMission.ShowMissionReward()
		end
		s10140_demo.PlayDemo_Inside_Heli( func )
	end,
}

sequences.Seq_Demo_PandemicConverge = {
	OnEnter = function(self)
		TppPlayer.Refresh()
		TppWeather.CancelRequestWeather()
		svars.isPlayDemo = false
		svars.isPrintLog = false
		TppUI.ShowAccessIcon()

		
		if  (vars.buddyType == BuddyType.DOG or vars.buddyType == BuddyType.QUIET) then
			if ( TppBuddyService.IsDeadBuddyType( BuddyType.DOG ) )
			or (	
					( vars.buddyType == BuddyType.QUIET ) and
					( TppBuddyService.CheckBuddyCommonFlag( BuddyCommonFlag.BUDDY_QUIET_LOST ) or TppBuddyService.CheckBuddyCommonFlag( BuddyCommonFlag.BUDDY_QUIET_HOSPITALIZE ) )
				)
			then
				Fox.Log( "#### s10140_sequence.Seq_Demo_PandemicConverge #### Controled Buddy Exist. But DD is dead!" )
				svars.isPlayDemo = true
				self.PlayDemo()
			else
				Fox.Log( "#### s10140_sequence.Seq_Demo_PandemicConverge #### Controled Buddy Exist. [ buddyType = "..vars.buddyType.." ]" )
				TppBuddy2BlockController.Load()
			end
		else
			Fox.Log( "#### s10140_sequence.Seq_Demo_PandemicConverge #### Controled Buddy Not Exist..." )
			svars.isPlayDemo = true
			self.PlayDemo()
		end
	end,
	
	OnUpdate = function(self)
		
		if (TppBuddy2BlockController.IsBlockActive()) then
			if not(svars.isPrintLog) then
				Fox.Log( "#### s10140_sequence.Seq_Demo_PandemicConverge::OnUpdate #### TppBuddy2BlockController.IsBlockActive()" )
				svars.isPrintLog = true
			end
			if not(svars.isPlayDemo) then
				svars.isPlayDemo = true
				self.PlayDemo()
			end
		end
	end,
	
	PlayDemo = function()
		TppUI.HideAccessIcon()
		local func = function()
			TppDemo.ReserveInTheBackGround{ demoName = "Demo_TorturedHueyAtMB" }
			TppSequence.SetNextSequence("Seq_Demo_TorturedHueyAtMB", { isExecMissionClear = true } )
		end
		s10140_demo.PlayDemo_PandemicConverge( func )
	end,
}

sequences.Seq_Demo_TorturedHueyAtMB = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Timer = {
				{ 	msg = "Finish",sender = "TelopTimer",
					func = function()
						
						TppUiCommand.RegistInfoTypingText( "lang",	4, "area_demo_mb" )
						TppUiCommand.RegistInfoTypingText( "lang",	5, "area_demo_room101" )
						TppUiCommand.ShowInfoTypingText()
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil
			},
			Demo = {
				{ 	msg = "Play",
					func = function()
						GkEventTimerManager.Start( "TelopTimer", 2 )
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil
			},
			nil
		}
	end,

	OnEnter = function()
		TppPlayer.Refresh()
		TppWeather.CancelRequestWeather()
		local func = function()
			Fox.Log("#### s10140_sequence.Seq_Demo_TorturedHueyAtMB ####")
			TppSequence.SetNextSequence("Seq_Demo_GoToLastMission", { isExecMissionClear = true } )
		end
		s10140_demo.PlayDemo_TorturedHueyAtMB( func )
	end,
	
	OnLeave = function()
		TppUiCommand.HideInfoTypingText()
	end,
}

sequences.Seq_Demo_GoToLastMission = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Timer = {
				{ 	msg = "Finish",sender = "TelopTimer",
					func = function()
						
						TppUiCommand.RegistInfoTypingText( "lang",	4, "area_demo_mb" )
						TppUiCommand.RegistInfoTypingText( "lang",	5, "platform_main" )
						TppUiCommand.ShowInfoTypingText()
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil
			},
			Demo = {
				{ 	msg = "Play",
					func = function()
						GkEventTimerManager.Start( "TelopTimer", 2 )
					end,
					option = {
						isExecDemoPlaying = true,
						isExecMissionClear = true,
					},
				},
				nil
			},
			nil
		}
	end,

	OnEnter = function()
		TppPlayer.Refresh()
		TppWeather.CancelRequestWeather()
		local func = function()
			Fox.Log("#### s10140_sequence.Seq_Demo_GoToLastMission ####")
			TppMission.MissionFinalize( { isNoFade = true } )
		end
		s10140_demo.PlayDemo_GoToLastMission( func )
	end,
	
	OnLeave = function()
		TppUiCommand.HideInfoTypingText()
	end,
}



return this