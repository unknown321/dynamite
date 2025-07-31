local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local TimerStart = GkEventTimerManager.Start

local sequences = {}




local	BOSS_QUIET				= "BossQuietGameObjectLocator"
local	SUPPORT_HELI			= "SupportHeli"
local	MARKER_NAME = {
	ESCAPE_GOAL	= "s10050_marker_EscapeGoal",	
	KILL_QUIET	= "s10050_marker_KillQuiet",	
}

local	resetGimmickIdTable = {
	
	"waterway_tower001",
	"waterway_tower001_link",
	"waterway_tower002",
	"waterway_tower002_link",
	"waterway_tower003",
	"waterway_tower003_link",
	
	"waterway_prst001_A",
	"waterway_prst001_A_link",
	"waterway_prst001_B",
	"waterway_prst001_B_link",
	"waterway_prst001_C",
	"waterway_prst002_A",
	"waterway_prst002_A_link",
	"waterway_prst002_B",
	"waterway_prst002_B_link",
	"waterway_prst002_C",
	"waterway_prst003_A",
	"waterway_prst003_A_link",
	"waterway_prst003_B",
	"waterway_prst003_B_link",
	"waterway_prst003_C",
	"waterway_prst004_A",
	"waterway_prst004_A_link",
	"waterway_prst004_B",
	"waterway_prst004_B_link",
	"waterway_prst004_C",
	"waterway_prst005_A",
	"waterway_prst005_A_link",
	"waterway_prst005_B",
	"waterway_prst005_B_link",
	"waterway_prst005_C",
	"waterway_prst006_A",
	"waterway_prst006_A_link",
	"waterway_prst006_B",
	"waterway_prst006_B_link",
	"waterway_prst006_C",
	"waterway_prst007_A",
	"waterway_prst007_A_link",
	"waterway_prst007_B",
	"waterway_prst007_B_link",
	"waterway_prst007_C",
	"waterway_prst008_A",
	"waterway_prst008_A_link",
	"waterway_prst008_B",
	"waterway_prst008_B_link",
	"waterway_prst008_C",
	

	
	"waterway_pillar001",
	"waterway_pillar002",
	"waterway_pillar003",
	"waterway_pillar004",
	"waterway_pillar005",
	"waterway_pillar006",
	"waterway_pillar007",
	"waterway_pillar008",
}


this.MISSION_START_INITIAL_ACTION = PlayerInitialAction.SQUAT
this.INITIAL_CAMERA_ROTATION = { 0, 120 }


this.DISABLE_BUDDY_TYPE = BuddyType.QUIET


this.NPC_ENTRY_POINT_SETTING = {
	[TppDefine.INIT_HELI_ROUTE] = {
		[EntryBuddyType.VEHICLE] = { Vector3(-1825.866, 350.025, -135.594), 90 }, 
		[EntryBuddyType.BUDDY] = { Vector3(-1825.085, 349.950, -142.179), 128.41 }, 
	},
}


this.hitRatioBonusParam = {
	hitRatioBaseScoreUnit = 300,
	limitHitRatioBonus = 50000,
}







function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Demo_MissionTitle",
		
		"Seq_Game_MainGame",
		
		"Seq_Demo_ConnectKillQuietGame",
		"Seq_Game_KillQuiet",
		"Seq_Demo_NotKillQuiet",
		
		"Seq_Game_Escape",

		"Seq_Demo_RideHeliWithQuiet",
		"Seq_Demo_GoToMotherBase",
		"Seq_Demo_ArrivedMotherBase",
		
		"Seq_Game_QuietDead",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	deathBulletCount		= 0,
	restoreState			= "None",	
	
	
	isLostPlayer			= false,	
	isUseDeathBullet		= false,	

	
	isKillMode				= false,	
	isQuietDown				= false,
	isPlayerStayInDemoTrap	= false,	
	isPlayerRideSomething	= false,	
	isPermitFultonRadio		= false,	
	isPlayerRideHeliWithQ	= false,	
	isQuietCarried			= false,
	isQuietRideHeli			= false,	
	isHeliClear				= false,	
	isQuietDead				= false,
	
	
	isQuietInjured			= false,
	
	
	isBreakPrst_1_A			= false,
	isBreakPrst_1_B			= false,
	isBreakPrst_2_A			= false,
	isBreakPrst_2_B			= false,
	isBreakPrst_3_A			= false,
	isBreakPrst_3_B			= false,
	isBreakPrst_4_A			= false,
	isBreakPrst_4_B			= false,
	isBreakPrst_5_A			= false,
	isBreakPrst_5_B			= false,
	isBreakPrst_6_A			= false,
	isBreakPrst_6_B			= false,
	isBreakPrst_7_A			= false,
	isBreakPrst_7_B			= false,
	isBreakPrst_8_A			= false,
	isBreakPrst_8_B			= false,

	
	isQuietReady				= false,	
	isPlayerStayInRestrictTrap	= false,	
	isRideOffInDemoTrap			= false,	
	isFirstTimeErase			= false,	
	isFirstTimeAntiHeli			= false,	
	isFinishKillGame			= false,	
	isRecovery					= false,	
	isMarked					= false,	
	isStayStartPos				= false,	
	isPlayAvoidQuiet_1			= false,	
}


this.baseList = {
	
	waterway,
	nil
}


this.checkPointList = {
	"CHK_NotKillQuiet",		
	"CHK_MovedToMB",		
	"CHK_E3_killQuiet",		
	"CHK_StartPos",			
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 2 },
	},
	second = {
		missionTask = { taskNo = 5 },
	}
}



this.missionObjectiveEnum = Tpp.Enum {
	"addMarker_KillQuietGame",
	"keepMarker_KillQuietGame",
	"deleteMarker_KillQuietGame",
	
	"default_subGoal_missionStart",
	"on_subGoal_afterKillGame",
	
	"default_missionTask_01",
	"default_missionTask_02",
	"default_missionTask_03",
	"default_missionTask_04",

	"appear_missionTask_02",
	
	"complete_missionTask_01",
	"complete_missionTask_02",
	"complete_missionTask_03",
	"complete_missionTask_04",
	
	"announce_defeatQuiet",
	"announce_achieveObjective",
}

this.missionObjectiveDefine = {
	
	
	addMarker_KillQuietGame = {
		gameObjectName = BOSS_QUIET,	goalType = "moving", setNew = false, viewType = "all",	announceLog = "updateMap",
	},
	keepMarker_KillQuietGame = {
	},
	
	deleteMarker_KillQuietGame = {
	},
	
	
	
	default_subGoal_missionStart = {
		subGoalId		= 0,	gameObjectName = MARKER_NAME.ESCAPE_GOAL,	goalType = "moving", viewType = "map", visibleArea = 1, randomRange = 0, 
	},
	
	on_subGoal_afterKillGame = {
		subGoalId		= 1,
	},
	
	
	
	default_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = false },
	},
	complete_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = true },
	},
	
	default_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = false, isComplete = false, isFirstHide = true },	
	},
	appear_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = false },	
	},
	complete_missionTask_02 = {
		missionTask = { taskNo = 1, isNew = true, isComplete = true },
	},
	
	default_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = false, isComplete = false, isFirstHide = true },
	},
	complete_missionTask_03 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = true },
	},
	
	default_missionTask_04 = {

		missionTask = { taskNo = 5, isNew = false, isComplete = false, isFirstHide = true },
	},
	complete_missionTask_04 = {

		missionTask = { taskNo = 5, isNew = true, isComplete = true },
	},
	
	announce_defeatQuiet = {
		announceLog = "eliminateTarget",
	},
	announce_achieveObjective= {
		announceLog = "achieveAllObjectives",
	},
}

this.missionObjectiveTree = {
	
	deleteMarker_KillQuietGame = {
		addMarker_KillQuietGame = {},
		keepMarker_KillQuietGame = {},
	},
	
	
	on_subGoal_afterKillGame = {
		default_subGoal_missionStart = {},
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
		default_missionTask_04 = {},
	},
	announce_defeatQuiet = {},
	announce_achieveObjective = {},
}






function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	this.RegisterMissionSystemCallback()

	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "Demo_NotKillQuiet" },
	}
	
	
	TppEquip.RequestLoadToEquipMissionBlock{ TppEquip.EQP_WP_West_hg_010 }
	
	
	TppRatBird.EnableRat() 
	TppRatBird.EnableBird( "TppStork" )
	
end



function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
	
	TppSound.SetSceneBGM("bgm_quiet")
	
	
	svars.isPlayerStayInDemoTrap = false
	svars.isPlayerRideSomething = false
	svars.isPlayerStayInRestrictTrap = false
	
	
	vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE
	
	
	TppCheckPoint.Disable{ baseName = "waterway" }

	
	
	if TppMission.IsMissionStart() then
		Fox.Log("##### s10050_sequence.OnRestoreSVars ##### Reset gimmick on mission start.")
		for i, gimmickId in pairs( resetGimmickIdTable ) do
			TppGimmick.ResetGimmick{ gimmickId = gimmickId, searchFromSaveData = true }
		end
	end
	
	
	local restoreSeq		= TppSequence.GetMissionStartSequenceName()	
	local ignoreSeqTable	= { "Seq_Demo_GoToMotherBase", "Seq_Demo_ArrivedMotherBase" }	
	
	if not(	restoreSeq == ignoreSeqTable[1]  or restoreSeq == ignoreSeqTable[2] ) then
		if( svars.restoreState == StrCode32("Dying") or svars.restoreState == StrCode32("Dead") ) then
			Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars : Execute Restore Quiet State! [ State = " .. tostring(svars.restoreState) .. " , sequence = " ..tostring(restoreSeq).. " ] ***")

			
			s10050_enemy.SetQuietExtraRoute("rts_demo_0000", "rts_kill_0000", "rts_recovery_0000", "rts_kill_0000")		

			
			local isEndKillGame = false
			if ( restoreSeq == "Seq_Game_Escape" ) then
				isEndKillGame = true
			end
			
			
			vars.playerDisableActionFlag = PlayerDisableAction.NONE
			
			
			local command = { id="RestoreState", state="state", index="index", isHandcuff=isEndKillGame }
			command.state = svars.restoreState
			command.index = 0			
			local gameObjectId = { type="TppBossQuiet2", index=0 }
			GameObject.SendCommand( gameObjectId, command )
			
			
			TppMission.CanMissionClear({ jingle = false })
			svars.isQuietReady = true

		else
			Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars : Not Execute Restore Quiet State! [ State = " .. tostring(svars.restoreState) .. " , sequence = " ..tostring(restoreSeq).. " ] ***")
		end
	end
end



function this.RegisterMissionSystemCallback()
	Fox.Log("##### s10050_sequence.RegisterMissionSystemCallback #####")

	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " RegisterMissionSystemCallback ***")

	
	local systemCallbackTable ={
		OnOutOfHotZoneMissionClear	= this.OnOutOfHotZoneMissionClear,	
		OnOutOfMissionArea			= this.OnOutOfMissionArea,			
		
		OnEstablishMissionClear		= this.OnEstablishMissionClear,		


		OnGameOver					= this.OnGameOver,					
		nil
	}
	
	TppMission.RegisterMissionSystemCallback(systemCallbackTable)

end



function this.OnOutOfHotZoneMissionClear()
	Fox.Log("##### s10050_sequence.OnOutOfHotZoneMissionClear ##### svars.isQuietCarried = " ..tostring(svars.isQuietCarried) )

	
	if ( svars.isQuietCarried ) then
		svars.isQuietRideHeli = true
		Fox.Log("##### s10050_sequence.OnOutOfHotZoneMissionClear ##### Execute Flag Control! [ isQuietRideHeli = "..tostring(svars.isQuietRideHeli).. " ]" )
		
	else
		Fox.Log("##### s10050_sequence.OnOutOfHotZoneMissionClear ##### Not Execute Flag Control." )
	end
	
	this.ReserveMissionClear()		
end



function this.OnOutOfMissionArea()
	Fox.Log("##### s10050_sequence.OnOutOfMissionArea ##### isQuietDown = " ..tostring(svars.isQuietDown).. ", isKillMode = " ..tostring(svars.isKillMode) )
	
	
	if ( svars.isQuietDown == false ) then
		
		if ( svars.isKillMode ) then
			Fox.Log("##### s10050_sequence.OnOutOfMissionArea ##### Mission Abort! TYPE : FORCED BREAK " )
			
			
			TppStory.MissionOpen( 10050 )					
			TppStory.DisableMissionNewOpenFlag( 10050 )		
			TppQuest.Clear( "waterway_q99010" )				

		
		else
			Fox.Log("##### s10050_sequence.OnOutOfMissionArea ##### Mission Abort! TYPE : TURN BACK " )
			
			
		end
	else
		
		Fox.Log("##### s10050_sequence.OnOutOfMissionArea ##### UNKNOWN ERROR!! " )
	end
	
	
	TppPlayer.SetNoOrderBoxMissionStartPositionToCurrentPosition()	
	TppMission.AbortMission{ nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_FREE, }

end



function this.OnEstablishMissionClear( missionClearType )
	Fox.Log("##### s10050_sequence.OnEstablishMissionClear ##### clearType = " ..tostring( missionClearType ) )
	
	
	if vars.missionCode == 11050 then
		TppTerminal.AcquireKeyItem{
			dataBaseId = TppMotherBaseManagementConst.DESIGN_3014,	
			pushReward = true,
		}
		TppTerminal.AcquireKeyItem{
			dataBaseId = TppMotherBaseManagementConst.DESIGN_3015,	
			pushReward = true,
		}
	end
	
	
	if ( svars.isQuietDead == false and svars.isQuietRideHeli == true ) then
		TppMission.UpdateObjective{	objectives = {"announce_achieveObjective"} }
		TppMission.UpdateObjective{	objectives = {"complete_missionTask_02"} }	
		
		TppSequence.SetNextSequence( "Seq_Demo_RideHeliWithQuiet", { isExecMissionClear = true } )
		
	
	else
		
		
		TppBuddyService.SetBuddyCommonFlag(BuddyCommonFlag.BOSS_QUIET_KILL)

		
		if ( missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT ) then
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
	
end



function this.OnEndMissionCredit()
	Fox.Log("##### s10050_sequence.OnEndMissionCredit #####")

	
	if ( svars.isQuietDead == false and svars.isQuietRideHeli == true ) then
		
		
	
	else
		TppMission.ShowMissionReward()
	end
end



function this.OnEndMissionReward()
	Fox.Log("##### s10050_sequence.OnEndMissionReward #####")
	TppMission.MissionFinalize()
end



function this.OnGameOver()
	Fox.Log("##### s10050_sequence.OnGameOver #####")
end



function this.ReserveMissionClear()
	Fox.Log("##### s10050_sequence.ReserveMissionClear #####")
	TppStory.MissionOpen( 10050 )					
	TppStory.DisableMissionNewOpenFlag( 10050 )		
	
	
	TppQuest.Clear( "waterway_q99010" )
	
	
	if ( svars.isQuietDead == false and svars.isQuietRideHeli == true ) then
		TppMission.ReserveMissionClear{ nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE, missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER }
		
	
	elseif ( svars.isQuietDead == true and svars.isHeliClear == true ) then
		TppMission.ReserveMissionClear{ nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI, missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER }
		
	
	else
		TppMission.ReserveMissionClear{ nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_FREE, missionClearType = TppDefine.MISSION_CLEAR_TYPE.ON_FOOT }
	end
end


function this.OnTerminate()
	Fox.Log("##### s10050_sequence.OnTerminate #####")
	
	TppUiStatusManager.ClearStatus("AnnounceLog")
	
	
	vars.playerDisableActionFlag = PlayerDisableAction.NONE
	
	
	Player.ResetPadMask {settingName = "KillQuietGame"	}
	Player.ResetPadMask {settingName = "restrictPlayerActionBeforeDemo"	}
	
	
	TppGameStatus.Reset("s10050_sequence.lua", "S_DISABLE_PLAYER_DAMAGE")
end








function this.Messages()

	if TppPackList.IsMissionPackLabel( "MotherBaseDemo" ) then
		
		return
		
	else
		return
		StrCode32Table {
			GameObject = {
				{	msg =	"PlacedIntoVehicle",	sender =	BOSS_QUIET,		func =	this.QuietRideHeli,	},			
				{	msg =	"Dead",					sender =	BOSS_QUIET,		func =	this.QuietDead,	},				
				{	msg =	"Carried",				sender =	BOSS_QUIET,		func =	this.QuietCarried,	},			
				{	msg =	"HeliDoorClosed",		sender =	SUPPORT_HELI,	func =	this.CloseDoorForNextSeq, },	
				nil
			},
			Player = {
				{	msg =	"RideHelicopter",									func = this.PlayerRideHeli	},			
				{	msg =	"RideHelicopterWithHuman",		 					func = 									
					function()
						Fox.Log( "#### s10050_sequence.Messages ### RideHelicopterWithHuman" )
						svars.isPlayerRideHeliWithQ = true
					end
				},
				{	msg =	"WarpEnd",											func =
					function()
						if (mvars.isPlayerWarpBeforeDemoPlay) then
							TppSequence.SetNextSequence("Seq_Demo_ConnectKillQuietGame")
							mvars.isPlayerWarpBeforeDemoPlay = false
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
			Demo = {
				
				{	msg =	"SetQuietKillGame",									func = this.SetQuietKillGameOnPlayingDemo,	option = { isExecDemoPlaying = true } },
				nil
			},
			Timer = {
				{ msg = "Finish",	sender = "timer_execDemoPrepareFunction",	func = 	function()	this.FadeOutForDemoPlay()	end	},
				{ msg = "Finish",	sender = "timer_startDemo",					func =
					function()

						
						if svars.isQuietDead then
							
							local ridingGameObjectId = vars.playerVehicleGameObjectId
							if Tpp.IsVehicle(ridingGameObjectId) then
								GameObject.SendCommand( ridingGameObjectId,	{ id = "ForceStop", enabled = false, } )
							end
							
							Player.ResetPadMask {
								settingName	= "restrictPlayerActionBeforeDemo_AtDemoPrepare", 
							}
							TppUI.HideAccessIcon()
							return
						end
						
						mvars.isPlayerWarpBeforeDemoPlay = true
						local gameObjectId = { type="TppPlayer2", index=0 }
						local command = { id = "WarpAndWaitBlock", pos={-1680.074, 354.7, -308.524}, rotY=166.28 }
						GameObject.SendCommand( gameObjectId, command )
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
				{	msg = "Finish",		sender = "s0050_esrg1030",	func = function ()	s10050_radio.SetRadioFromSituation()	end	},
			},
			Subtitles = {
				{	msg = "SubtitlesEndEventMessage", 							func =
					function( speechLabel, status )
						local checkSubtitles = {
							[1] = SubtitlesCommand:ConvertToSubtitlesId("qtrc1000_100263_0_miller"),	
							[2] = SubtitlesCommand:ConvertToSubtitlesId("qtrc1000_100326_0_miller"),	
						}

						if ( speechLabel == checkSubtitles[1] ) then
							Fox.Log( "#### s10050_sequence.Messages #### SubtitlesEndEventMessage::"..tostring(speechLabel))
							TppMission.UpdateObjective{
								radio = {
									radioGroups =	{ "s0050_rtrg1060", },
									radioOptions =	{ delayTime = "short" },
								},
								objectives = {
									"keepMarker_KillQuietGame",
								},
							}
							
							
							this.ActivateDD(true)

						elseif ( speechLabel == checkSubtitles[2] ) then
							Fox.Log( "#### s10050_sequence.Messages #### SubtitlesEndEventMessage::"..tostring(speechLabel))
							svars.isPermitFultonRadio = true
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
end


this.EnablePadMaskKillQuietGame = function ( enabled )

	if ( enabled ) then
		Fox.Log( "#### s10050_sequence.EnablePadMaskKillQuietGame ### Enabled" )
		Player.SetPadMask {
			settingName = "KillQuietGame",
			except	=	true,					
			buttons =	PlayerPad.FIRE	+ 		
						PlayerPad.STOCK,		
			sticks	=	PlayerPad.STICK_R	+	
						PlayerPad.TRIGGER_R,	
		}		
	else
		Fox.Log( "#### s10050_sequence.EnablePadMaskKillQuietGame ### Disabled" )
		Player.ResetPadMask {
			settingName = "KillQuietGame"
		}
	end

end


this.SetQuietKillGameOnPlayingDemo = function ()
	Fox.Log( "#### s10050_sequence.SetQuietKillGameOnPlayingDemo ###" )
	
	Player.SetCurrentItemIndex{	itemIndex = 0 }

	
	GameObject.SendCommand( { type="TppPlayer2", index=PlayerInfo.GetLocalPlayerIndex() }, { id="SetSpecialAttackMode", enabled = true, type = "KillQuiet" } )

	
	Player.ChangeEquip{
		equipId = TppEquip.EQP_WP_West_hg_010,	
		stock = 1,								
		ammo = 1,								
		suppressorLife = 0,						
		isSuppressorOn = false,					
		isLightOn = false,						
		dropPrevEquip = false,					
		temporaryChange = true,					
	}
end



this.CallHeliAndSettings = function()
	Fox.Log( "#### s10050_sequence.CallHeliAndSettings ###" )

	


	
	
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI)
	GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name="lzs_waterway_I_0000" })
	
	
	this.EnableHeliPullOut(false)
	
	
	s10050_radio.CallHeli()
end


this.EnableHeliPullOut = function(flag)
	Fox.Log( "#### s10050_sequence.EnableHeliPullOut ### flag = " ..tostring(flag) )
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI)

	if(flag) then
		GameObject.SendCommand(gameObjectId, { id="EnablePullOut" })
	else
		GameObject.SendCommand(gameObjectId, { id="DisablePullOut" })
	end

end


this.QuietRideHeli = function(gameObjectId, vehicleId)

	if vehicleId == GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI ) then				
		if gameObjectId == GameObject.GetGameObjectId( "TppBossQuiet2", BOSS_QUIET ) then	

			Fox.Log( "#### s10050_sequence.QuietRideHeli ### Quiet Ride Heli!! ")
			svars.isQuietRideHeli = true
			
			
			local gameObjectId = GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI)
			GameObject.SendCommand(gameObjectId, { id="SetTakeOffWaitTime", time=0 })
			
			TppMission.UpdateObjective{	objectives = {"announce_achieveObjective"} }
			TppMission.UpdateObjective{	objectives = {"complete_missionTask_02"} }
			TppMission.UpdateObjective{	objectives = {"on_subGoal_afterKillGame"} }
			
			
			s10050_radio.PleaseRideHeli()

		end
	else
		Fox.Log( "#### s10050_sequence.QuietRideHeli ### Not Quiet or Not Heli!! gameObjectId = " ..gameObjectId.. ", vehicleId = " ..vehicleId )
		return
	end
	
end




this.QuietDown = function()
	Fox.Log( "#### s10050_sequence.QuietDown ### isPlayerStayInDemoTrap = "..tostring(svars.isPlayerStayInDemoTrap) )
	
	
	TppRadioCommand.StopDirect()

	
	TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_ed")

	TppMission.UpdateObjective{	objectives = {"announce_defeatQuiet",}}
	TppMission.UpdateObjective{	objectives = {"complete_missionTask_01",}}

	
	TppMission.UpdateObjective{
		radio = {
			radioGroups =	{ "s0050_rtrg1050", },
			radioOptions =	{ delayTime = "long" },
		},
		objectives = {
			"appear_missionTask_02",
			"addMarker_KillQuietGame",
		},
	}

	svars.isQuietDown = true
	TppMission.CanMissionClear({ jingle = false })	
	svars.restoreState = StrCode32("Dying")			

	
	s10050_radio.SetRadioFromSituation()	
	TppRadio.SetOptionalRadio("Set_s0050_oprg5000")

	
	if not (svars.isQuietInjured) then
		TppResult.AcquireSpecialBonus{ first = { isComplete = true }, }
		
		
		if not(TppBuddyService.DidObtainBuddyType( BuddyType.QUIET ))then
			if not(TppStory.IsMissionCleard(10260))then
				TppBuddyService.AddFriendlyPoint(BuddyFriendlyType.QUIET,2)	
			end
		end
	end
	
	if (svars.isPlayerStayInRestrictTrap) then
		this.RestrictPlayerActionBeforeDemo()
	end
end


this.QuietCarried = function(gameObjectId, carriedState)
	Fox.Log( "#### s10050_sequence.QuietCarried ### gameObjectId = " ..tostring(gameObjectId).. ", carriedState = " ..tostring(carriedState) )

	local	CarryStart	= 0
	local	CarryEnd	= 1
	
	if(carriedState == CarryStart)then
		svars.isQuietCarried = true
	elseif(carriedState == CarryEnd)then
		svars.isQuietCarried = false
	end

	Fox.Log( "#### s10050_sequence.QuietCarried ### svars.isQuietCarried = " ..tostring(svars.isQuietCarried) )
end


this.QuietDead = function(deadId, attackerId)
	Fox.Log( "#### s10050_sequence.QuietDead ### deadId = " ..tostring(deadId).. ", attackerId = " ..tostring(attackerId) )

	svars.isQuietDead = true

	
	TppUI.FadeIn(TppUI.FADE_SPEED.FADE_NORMALSPEED)

	
	local func = function()
		
		GameObject.SendCommand( { type="TppPlayer2", index=PlayerInfo.GetLocalPlayerIndex() }, { id="SetSpecialAttackMode", enabled = false, type = "KillQuiet" } )
		
		
		this.EnableHeliPullOut(true)
		
		
		s10050_enemy.StartQuietDeadEffect()
		
		
		TppSequence.SetNextSequence("Seq_Game_QuietDead")
	end
	
	
	local currentSeq = TppSequence.GetCurrentSequenceName()
	Fox.Log( "#### s10050_sequence.QuietDead ### sequence = " ..tostring(currentSeq) )

	
	if ( currentSeq == "Seq_Game_KillQuiet" ) then
		s10050_demo.PlayDemo_QuietDied(func)	
	else
		func()									
	end

end



this.PlayerRideHeli = function()
	Fox.Log( "#### s10050_sequence.PlayerRideHeli ### Player Ride Heli!! ")

	
	if (svars.isQuietRideHeli == true) then
		Fox.Log( "#### s10050_sequence.PlayerRideHeli ### Heli EnablePullOut!! [ isQuietRideHeli = " ..tostring(svars.isQuietRideHeli).. " ]")
		TppMission.UpdateObjective{	objectives = { "complete_missionTask_02", }, }	
		this.EnableHeliPullOut(true)		
	
	
	else
		Fox.Log( "#### s10050_sequence.PlayerRideHeli ### Heli DisablePullOut!! Because, Quiet Doesn't Ride.")
		
		
		if(svars.isQuietDead == false)then
			s10050_radio.PleasePutOnQuiet()
		end
	end		
end


this.CloseDoorForNextSeq = function()
	if ( svars.isQuietRideHeli == true or svars.isQuietDead == true) then
		Fox.Log( "#### s10050_sequence.CloseDoorForNextSeq ### [ isQuietRideHeli = " ..tostring(svars.isQuietRideHeli).. " ], [isQuietDead = " ..tostring(svars.isQuietDead).. " ] ")

		svars.isHeliClear = true		
		this.ReserveMissionClear()		
	else
		Fox.Log( "#### s10050_sequence.CloseDoorForNextSeq ### Unknown State!!")
	end
end


this.CheckPlayDemo_NotKillQuiet = function()
	
	if ( svars.isQuietReady ) then
		Fox.Log( "#### s10050_sequence.CheckPlayDemo_NotKillQuiet ### isQuietReady = " ..tostring(svars.isQuietReady))

		
		if ( this.CheckPlayerRideSomething() ) then
			
			Fox.Log( "#### s10050_sequence.CheckPlayDemo_NotKillQuiet ### Demo does'nt Play! Player ride something!" )
			svars.isPlayerStayInDemoTrap = true
			
			
			Player.SetPadMask {
				settingName	= "restrictPlayerActionBeforeDemo_AtDemoPrepare", 
				except		= true,
			}	
			local ridingGameObjectId = vars.playerVehicleGameObjectId
			
			
			if Tpp.IsHorse(ridingGameObjectId) then
				
				GameObject.SendCommand( ridingGameObjectId,	{ id = "HorseForceStop" } )
			elseif( Tpp.IsPlayerWalkerGear(ridingGameObjectId) )then
				
				GameObject.SendCommand( ridingGameObjectId,	{ id = "ForceStop", enabled = true } )
			elseif Tpp.IsVehicle(ridingGameObjectId) then
				
				GameObject.SendCommand( ridingGameObjectId,	{ id = "ForceStop", enabled = true, } )
			end
			
			
			TppUI.FadeOut( TppUI.FADE_SPEED.FADE_NORMALSPEED )
			
			TimerStart( "timer_execDemoPrepareFunction", 2)
			
		
		else
			
			if ( svars.isPlayerStayInDemoTrap ) then
				Fox.Log( "#### s10050_sequence.CheckPlayDemo_NotKillQuiet ### isPlayerStayInDemoTrap = "..tostring(svars.isPlayerStayInDemoTrap) )		

				
				this.RestrictPlayerActionBeforeDemo()
				
				
				this.RequestToMoveBeforeDemo()
				
			
			else
				TppSequence.SetNextSequence("Seq_Demo_ConnectKillQuietGame")
			end
		end
			

	
	else
		
		svars.isPlayerStayInDemoTrap = true
	end
	
end


this.CheckPlayerRideSomething = function()
	local playerState		= Player.GetGameObjectIdIsRiddenToLocal()
	local notRideSomething	= 65535	
	
	if ( playerState == notRideSomething ) then
		return false
	else
		return true
	end
end


this.RestrictPlayerActionBeforeDemo = function()
	
	vars.playerDisableActionFlag	= PlayerDisableAction.RUN
									+ PlayerDisableAction.CARRY
									+ PlayerDisableAction.FULTON
									+ PlayerDisableAction.BEHIND
									+ PlayerDisableAction.TIME_CIGARETTE
									
	
	Player.RequestToSetTargetStance(PlayerStance.STAND)
	
	
	Player.SetPadMask {
		settingName	= "restrictPlayerActionBeforeDemo",    
		except		= false,                                 
		buttons		= PlayerPad.STANCE
					+ PlayerPad.EVADE,
	}
end


this.RequestToMoveBeforeDemo = function()

	Player.RequestToMoveToPosition{
		name		= "RequestToMoveBeforeDemo",
		position	= Vector3(-1679.955, 353.897, -308.274),
		direction	= 150,
		moveType	= PlayerMoveType.WALK,
		timeout		= 10,
	}
	
	vars.playerDisableActionFlag	= PlayerDisableAction.RUN
									+ PlayerDisableAction.CARRY
									+ PlayerDisableAction.FULTON
									+ PlayerDisableAction.BEHIND
									+ PlayerDisableAction.RIDE_VEHICLE

	
	Player.SetPadMask {
		settingName	= "restrictPlayerActionBeforeDemo_AtRequestMove", 
		except		= true,
	}	
	
	
end

this.FadeOutForDemoPlay = function()
	local seFlag = false
	
	TppUI.ShowAccessIcon()
	
	
	local ridingGameObjectId = vars.playerVehicleGameObjectId
	if Tpp.IsVehicle(ridingGameObjectId) then
		GameObject.SendCommand( ridingGameObjectId,	{ id = "ForceStop", enabled = false, } )
	end

	
	Player.ResetPadMask {
		settingName	= "restrictPlayerActionBeforeDemo_AtDemoPrepare", 
	}

	
	if svars.isQuietDead then
		TppUI.HideAccessIcon()
		return
	end
	
	
	if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
		TppBuddyService.SetIgnoreDisableNpc( true )
		this.ActivateDD(true)
	
	else
		TppBuddy2BlockController.DeleteBuddy()
		seFlag = true
	end
	
	
	if Tpp.IsVehicle(ridingGameObjectId) then
		this.ForceSeizeVehicle()
		seFlag = true
	end
	
	
	this.WarpEtceteraForDemo()
	
	if seFlag then
		TppSoundDaemon.PostEvent( 'sfx_m_fulton_6_lift_up_2d', 'Loading' )
	end
	
	
	TimerStart( "timer_startDemo", 4)
end

this.ActivateDD = function( activateFlag )
	local gameObjectId	= { type="TppBuddyDog2", index=0 }
	local command		= { id = "LuaAiStayAndSnarl" }		

	if ( activateFlag ) then
		
		local pos1 = Vector3(-1683.261, 353.897, -304.249)	
		local pos2 = Vector3(-1676.751, 353.897, -311.425)	

		command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2, ignoreMarker = true }
	end
	
	
	if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
		Fox.Log("#### s10050_sequence.ActivateDD #### [ "..tostring(activateFlag).." ]")
		GameObject.SendCommand( gameObjectId, command )
	else
		Fox.Log("#### s10050_sequence.ActivateDD #### [ not execute! ] because DD not exist...")
	end
end

this.ForceSeizeVehicle = function()
	local vehicleId = { type="TppVehicle2", index=0 }
	if ( GameObject.SendCommand( vehicleId, { id="IsAlive", } ) ) then
		GameObject.SendCommand( vehicleId, { id="Seize", options={ "Instant", }, } )
	end
end

this.WarpEtceteraForDemo = function()
	local warpPos_Horse	= Vector3{-1710.002, 355.106, -154.825}
	local warpPos_WG	= {-1683.011, 353.945, -298.070}
	local warpRot	= 3
	local command = {}
	
	if not(mvars.executeThisFunc) then
		
		local gameObjectId = GameObject.GetGameObjectIdByIndex( "TppVehicle2",0 )
		if ( GameObject.SendCommand( gameObjectId, { id="IsAlive", } ) ) then
			GameObject.SendCommand( gameObjectId, { id="SetPosition", position=Vector3{-1825.866, 350.025, -135.594}, rotY=90, } )
		end
		
		
		local gameObjectId = GameObject.GetGameObjectIdByIndex( "TppHorse2",0 )
		if gameObjectId ~= GameObject.NULL_ID then
			command = { id = "SetCallHorse", startPosition=warpPos_Horse, goalPosition=warpPos_Horse, }	
			GameObject.SendCommand( gameObjectId, command )
		end
		
		
		gameObjectId = GameObject.GetGameObjectIdByIndex( "TppWalkerGear2",0 )
		if gameObjectId ~= GameObject.NULL_ID then
			command = { id = "SetPosition", pos=warpPos_WG, rotY=warpRot, }
			GameObject.SendCommand( gameObjectId, command )
		end
		
		
		mvars.executeThisFunc = true
	end
end

this.CheckNeutralizeCauseForMissionTask = function(neutralizeCause)
	if (neutralizeCause == NeutralizeCause.HANDGUN				or
		neutralizeCause == NeutralizeCause.SUBMACHINE_GUN		or
		neutralizeCause == NeutralizeCause.ASSAULT_RIFLE		or
		neutralizeCause == NeutralizeCause.SHOTGUN				or
		neutralizeCause == NeutralizeCause.MACHINE_GUN			or
		neutralizeCause == NeutralizeCause.SNIPER_RIFLE		or
		neutralizeCause == NeutralizeCause.MISSILE				or
		neutralizeCause == NeutralizeCause.GRENADE				or
		neutralizeCause == NeutralizeCause.MINE					or
		neutralizeCause == NeutralizeCause.ROCKET_ARM			or
		neutralizeCause == NeutralizeCause.ASSIST				or
		neutralizeCause == NeutralizeCause.QUIET				or
		neutralizeCause == NeutralizeCause.D_WALKER_GEAR		or
		neutralizeCause == NeutralizeCause.VEHICLE				or
		neutralizeCause == NeutralizeCause.SUPPORT_HELI		or
		neutralizeCause == NeutralizeCause.NO_KILL				or
		neutralizeCause == NeutralizeCause.NO_KILL_BULLET		)	then
		return false
	else
		return true
	end
end





sequences.Seq_Demo_MissionTitle = {
	Messages = function( self ) 
		return
		StrCode32Table {
			UI = {
				{
					
					msg = "StartMissionTelopFadeOut",
					func = function ()
						Fox.Log("#### s10050_sequence.Messages #### StartMissionTelopFadeOut")
						TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "FadeInOnGameStart")
						TppMain.EnableGameStatus()	
						TppSequence.SetNextSequence("Seq_Game_MainGame")
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()
		TppUI.StartMissionTelop()
		local vehicleId = { type="TppVehicle2", index=0 }
		if( GameObject.SendCommand( vehicleId, { id="IsAlive", } ) )then
			GameObject.SendCommand( vehicleId, { id="SetPosition", position=Vector3(-1825.866, 350.025, -135.594), rotY=90, } )
		end
	end,

	OnLeave = function ()
		TppMission.UpdateCheckPoint("CHK_StartPos")		
	end,
}


sequences.Seq_Game_MainGame = {
	
	
	Messages = function( self )
		return
		StrCode32Table {
			Player = {
				{	msg = "OnVehicleRide_Start",											func =
					function(playerId, rideFlag, vehicleId)
						local getOff = 1
						if( rideFlag == getOff ) then
							if(svars.isPlayerStayInDemoTrap)then
								
								
								
							end
						end
					end
				},
				{	msg = "FinishMovingToPosition",											func =
					function(name)
						Fox.Log( "#### s10050_sequence.Messages #### FinishMovingToPosition::RequestToMoveBeforeDemo" )
						Player.ResetPadMask {
							settingName = "restrictPlayerActionBeforeDemo_AtRequestMove"
						}
						TppSequence.SetNextSequence("Seq_Demo_ConnectKillQuietGame")
					end
				},
			},
			GameObject = {
				
				{	msg =	"QuietStartSniping",											func =
					function()
						Fox.Log( "#### s10050_sequence.Messages #### QuietStartSniping [ isUseDeathBullet = " ..tostring(svars.isUseDeathBullet).. " ]")
						svars.isLostPlayer = false
						
						
						if( svars.isUseDeathBullet )then
							
						else
							
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_nt")
						end
						
						s10050_radio.SetRadioFromSituation()
					end
				},
				
				{	msg =	"QuietStartUseDeathBullet",										func =
					function()
						Fox.Log( "#### s10050_sequence.Messages #### QuietStartUseDeathBullet ")
						
						TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_al")
					end
				},
				
				{	msg =	"QuietThroughLaserSight",										func =
					function()
						Fox.Log( "#### s10050_sequence.Messages #### QuietThroughLaserSight ")
						svars.isUseDeathBullet = true
						s10050_radio.BeCarefulDeathBullet()
						
						s10050_radio.SetRadioFromSituation()
					end
				},
				
				{	msg =	"QuietFinishUseDeathBullet",									func =
					function()
						Fox.Log( "#### s10050_sequence.Messages #### FinishUseDeathBullet [ isLostPlayer = " ..tostring(svars.isLostPlayer).. " ]")
						svars.isUseDeathBullet = false
						
						
						if( svars.isLostPlayer )then
							
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_sn")
						else
							
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_nt")
						end
						
						s10050_radio.SetRadioFromSituation()
					end
				},
				
				{	msg =	"QuietLostPlayer",												func =
					function()
						Fox.Log( "#### s10050_sequence.Messages #### QuietLostPlayer [ isUseDeathBullet = " ..tostring(svars.isUseDeathBullet).. " ]")
						svars.isLostPlayer = true
						
						
						if( svars.isUseDeathBullet )then
							
						else
							
							TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_sn")
						end
						
						s10050_radio.SetRadioFromSituation()
					end
				},
				
				{	msg =	"QuietEraseMarker",		sender =	BOSS_QUIET,					func =
					function()
						Fox.Log( "#### s10050_sequence.Messages #### QuietEraseMarker")
						if not( svars.isFirstTimeErase ) then
							if not(svars.isQuietDown) then
								s10050_radio.EraseMarkerReaction()
								svars.isFirstTimeErase = true	
							end
						end
						
						s10050_radio.SetRadioFromSituation()
					end
				},
				
				{	msg =	"Damage",				sender =	BOSS_QUIET,					func =
					function()
						svars.isQuietInjured = true
					end
				},
				
				{	msg =	"Unconscious",			sender =	BOSS_QUIET,					func =	this.QuietDown	},
				
				{	msg =	"Neutralize",			sender =	BOSS_QUIET,					func =	
					function(quietId,sourceId,neutralizeType,neutralizeCause)
						Fox.Log( "#### s10050_sequence.Messages #### Neutralize [ Source : "..tostring(sourceId).. " ] [ Neutralize Type : " ..tostring(neutralizeType).. " ] [ Neutralize Cause : " ..tostring(neutralizeCause).. " ]")
						if( this.CheckNeutralizeCauseForMissionTask(neutralizeCause) ) then
							Fox.Log( "#### s10050_sequence.Messages #### Neutralize [ Task Complete! ]")
							TppResult.AcquireSpecialBonus{ second = { isComplete = true }, }
						end
						
						TppMission.UpdateCheckPoint("CHK_StartPos")
					end
				},
				
				{	msg =	"Dying",				sender =	BOSS_QUIET,					func =
					function()
						svars.isQuietReady = true
						
						
						if(svars.isPlayerStayInDemoTrap)then
							this.CheckPlayDemo_NotKillQuiet()
						else
							
							vars.playerDisableActionFlag = PlayerDisableAction.NONE
						end
						
						if(svars.isPlayerStayInRestrictTrap)then
							this.RestrictPlayerActionBeforeDemo()
						end
					end
				},
				
				{	msg =	"QuietRecovery",		sender =	BOSS_QUIET,					func =
					function(objectId, flag)
						local recoveryStart	= 1
						local recoveryEnd	= 0
						if ( flag == recoveryStart ) then
							Fox.Log( "#### s10050_sequence.Messages #### QuietRecovery [Start]")
							svars.isRecovery = true
						elseif ( flag == recoveryEnd ) then
							Fox.Log( "#### s10050_sequence.Messages #### QuietRecovery [End]")
							svars.isRecovery = false
						end
						
						s10050_radio.SetRadioFromSituation()
					end
				},
				nil
			},
			Trap = {
				{	msg =	"Enter",			sender =	"trap_quietEyeOpen",			func =	s10050_enemy.QuietEyeOpen		},	
				{	msg =	"Enter",			sender =	"trap_quietKillModeOn",			func =	s10050_enemy.QuietKillModeOn	},	
				{	msg =	"Enter",			sender =	"trap_quietKillModeOff",		func =	s10050_enemy.QuietKillModeOff	},	
				
				{	msg =	"Enter",			sender =	"trap_playDemo_NotKillQuiet",	func =	this.CheckPlayDemo_NotKillQuiet	},	
				{	msg =	"Exit",				sender =	"trap_playDemo_NotKillQuiet",	func =										
					function()	svars.isPlayerStayInDemoTrap = false	end
				},
				
				{	msg =	"Enter",			sender =	"trap_restrictPlayerAction",	func =	
					function()
						if (svars.isQuietDown) then
							this.RestrictPlayerActionBeforeDemo()
						end
						svars.isPlayerStayInRestrictTrap = true
					end
				},
				{	msg =	"Exit",				sender =	"trap_restrictPlayerAction",	func =
					function()
						vars.playerDisableActionFlag = PlayerDisableAction.NONE
						Player.ResetPadMask {
							settingName = "restrictPlayerActionBeforeDemo"
						}
						svars.isPlayerStayInRestrictTrap = false
					end
				},
				
				{	msg =	"Exit",				sender =	"trap_checkStayStartPos",		func =	function()	svars.isStayStartPos = false	end	},
				nil
			},
			Timer = {
				{	msg = "Finish",				sender =	"timer_checkStayStartPos",		func =
					function()
						local isPlaying = TppRadioCommand.IsPlayingRadio()

						
						if (svars.isStayStartPos and not(svars.isQuietDown) ) then
							if ( isPlaying ) then
								
								TimerStart( "timer_checkStayStartPos", 30)
							else
								s10050_radio.PleaseAwayFromHere()
							end
						end
					end
				},
				{	msg = "Finish",				sender =	"timer_battleTime",		func =
					function()
						if not(svars.isQuietDown) then
							s10050_radio.AvoidQuiet()
							
							TimerStart( "timer_battleTime", 300)
						end
					end
				},
			},
			nil
		}
	end,
	
	OnLeave = function()
		vars.playerDisableActionFlag = PlayerDisableAction.NONE
		Player.ResetPadMask {
			settingName = "restrictPlayerActionBeforeDemo"
		}
	end,
	
	
	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		Fox.Log( "#### s10050_sequence.OnEnter ####" )
		
		
		TppCassette.Acquire{ cassetteList = {"tp_m_10050_01"}, isShowAnnounceLog = { delayTimeSec = 2.0 } }
		
		
		TppMission.StartBossBattle()

		
		svars.isStayStartPos = true
		TimerStart( "timer_checkStayStartPos", 120)	

		
		TppMission.UpdateObjective{
			objectives = {
				"default_missionTask_01",
				"default_missionTask_02",
				"default_missionTask_03",
				"default_missionTask_04",
			},
		}
		
		
		if (TppQuest.IsOpen("sovietBase_q99020") and not(TppQuest.IsCleard("sovietBase_q99020"))) then
			TimerStart( "timer_battleTime", 600)	
			TppMission.UpdateObjective{	objectives = {	"default_subGoal_missionStart",	},	}
		end
		
		s10050_radio.StartGame()
		s10050_radio.SetRadioFromSituation()	
		
		
		if( svars.restoreState == StrCode32("Dying") or svars.restoreState == StrCode32("Dead") ) then
			this.QuietDown()
			
		
		else
			TppTelop.StartCastTelop()
			TppSound.SetSceneBGMSwitch("Set_Switch_bgm_boss_phase_nt")
			
			
			vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE
			
			
			s10050_enemy.QuietForceCombatMode()

			
			s10050_enemy.SetQuietSnipeRoute(
				"rts_snipe_0000",					
				"rts_snipe_0001"					
			)
			s10050_enemy.SetQuietExtraRoute(
				"rts_demo_0000",					
				"rts_kill_0000",					
				"rts_recovery_0000",				
				"rts_kill_0000"						
			)
			s10050_enemy.SetQuietRelayRoute(
				"rts_relay_0000"					
			)
			
			
			TppRadio.SetOptionalRadio("Set_s0050_oprg1000")
			
			
			TppScriptBlock.LoadDemoBlock("Demo_NotKillQuiet")
			
			
			TppHelicopter.SetDisableLandingZone{ landingZoneName = "lzs_waterway_I_0000" }
		end
	end,
}




sequences.Seq_Demo_ConnectKillQuietGame = {
	OnEnter = function()
		TppUI.HideAccessIcon()
		
		if (svars.isQuietDead) then
			TppSequence.SetNextSequence("Seq_Game_QuietDead")
		else
			
			Player.RequestToSetTargetStance(PlayerStance.STAND)

			
			TppUI.FadeIn(TppUI.FADE_SPEED.FADE_NORMALSPEED)
		
			
			TppMission.UpdateObjective{ objectives = { "deleteMarker_KillQuietGame", }, }
			
			
			TppUiStatusManager.SetStatus( "AnnounceLog", "SUSPEND_LOG" )
			
			
			if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
				
				TppBuddyService.SetIgnoreDisableNpc( true )
				this.ActivateDD(true)
			else
				
				
			end
			
			local func = function()
				TppSequence.SetNextSequence("Seq_Game_KillQuiet")
			end
			
			s10050_demo.PlayDemo_ConnectKillQuietGame(func)
		end
	end,
}




sequences.Seq_Game_KillQuiet = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Timer = {
				{ msg = "Finish",	sender = "timer_NotKillQuiet",	func = 	function()	TppSequence.SetNextSequence("Seq_Demo_NotKillQuiet")	end	},
			},
			nil
		}
	end,
	
	OnEnter = function()
		
		TppGameStatus.Set("s10050_sequence.lua", "S_DISABLE_PLAYER_DAMAGE")
		
		if( svars.isQuietDead ) then
			TppSequence.SetNextSequence("Seq_Game_QuietDead")
		else
			
			this.WarpEtceteraForDemo()
			
			
			this.ActivateDD(true)
			
			
			this.EnablePadMaskKillQuietGame(true)
			
			
			vars.playerDisableActionFlag = PlayerDisableAction.MARKING
			
			
			TppUiStatusManager.SetStatus( "AnnounceLog", "SUSPEND_LOG" )
			
			
			TimerStart( "timer_NotKillQuiet", 15)
			s10050_radio.KillQuietGame()
			
			
			svars.isFinishKillGame = true		
		end
	end,
	
	OnLeave = function()
		
		this.EnablePadMaskKillQuietGame(false)
		
		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE
		
		
		TppGameStatus.Reset("s10050_sequence.lua", "S_DISABLE_PLAYER_DAMAGE")
	end,
}




sequences.Seq_Demo_NotKillQuiet = {
	OnEnter = function()
		
		TppUiStatusManager.SetStatus( "AnnounceLog", "SUSPEND_LOG" )

		local func = function()
			TppSequence.SetNextSequence("Seq_Game_Escape")
		end
		
		if( not svars.isQuietDead ) then
			
			s10050_demo.PlayDemo_NotKillQuiet(func)
		else
			TppSequence.SetNextSequence("Seq_Game_QuietDead")
		end
	end,
}




sequences.Seq_Game_Escape = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Player = {
				{ msg = "PressedFultonNgIcon",	func =
					function()
						if ( svars.isPermitFultonRadio ) then	s10050_radio.DoNotFulton()	end
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()
		
		TppMission.FinishBossBattle()
		
		
		TppUiStatusManager.UnsetStatus( "AnnounceLog", "SUSPEND_LOG" )
		
		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE
		
		
		this.ActivateDD(false)

		
		TppMission.UpdateObjective{	objectives = {"deleteMarker_KillQuietGame"} }
		
		
		TppHelicopter.SetEnableLandingZone{ landingZoneName = "lzs_waterway_I_0000" }

		
		this.CallHeliAndSettings()

		
		TppRadio.SetOptionalRadio("Set_s0050_oprg6000")
		
		svars.isQuietCarried = true
		
		
		TppMission.UpdateCheckPoint("CHK_NotKillQuiet")
	end,
}




sequences.Seq_Demo_RideHeliWithQuiet = {
	Messages = function( self ) 
		return
		StrCode32Table {
			Timer = {
				{ msg = "Finish",	sender = "timer_startSE",	option = { isExecMissionClear = true, },	func =
					function()
						
						Fox.Log( "#### s10050_sequence.Seq_Demo_RideHeliWithQuiet::timer_startSE ### svars.isHeliClear = "..tostring(svars.isHeliClear) )
						if ( svars.isHeliClear == false ) then
							TppSound.PostEventForFultonRecover()
						end
					end
				},
				{ msg = "Finish",	sender = "timer_startDemoHeli",	option = { isExecMissionClear = true, },	func =
					function()
						Fox.Log( "#### s10050_sequence.Seq_Demo_RideHeliWithQuiet::timer_startDemo ###" )
						TppUI.HideAccessIcon()
						TppSound.StopSceneBGM()
						TppSound.EndJingleOnClearHeli()
						TppDemo.ReserveInTheBackGround{ demoName = "Demo_RideHeliWithQuiet" }
						local func = function()
							TppSoundDaemon.SetMuteInstant( 'Loading' )
							TppMission.MissionGameEnd{ loadStartOnResult = true }
						end
						
						s10050_demo.PlayDemo_RideHeliWithQuiet(func)
					end
				},
			},
			nil
		}
	end,

	OnEnter = function()
		
		TppUI.FadeOut( TppUI.FADE_SPEED.FADE_NORMALSPEED )
		TppUI.ShowAccessIcon()
		
		
		TppHero.SetAndAnnounceHeroicOgrePoint{ heroicPoint = 60, ogrePoint = -60 }
		
		
		
		gvars.mbFreeDemoPlayRequestFlag[TppDefine.MB_FREEPLAY_DEMO_REQUESTFLAG_DEFINE.PlayAfterQuietBattle] = true
				
		
		if TppBuddyService.CheckBuddyCommonFlag( BuddyCommonFlag.BUDDY_QUIET_LOST )
		and TppStory.IsMissionCleard(10260) then
			if vars.missionCode == 10050 then 
				
				TppStory.UpdateCounterReunionQuiet()
				
				if TppStory.CanReunionQuiet() then
					TppStory.RequestReunionQuiet()
				end
			end
		else
			
			
			TppBuddy2BlockController.SetObtainedBuddyType( BuddyType.QUIET )
				
			if not TppQuest.IsCleard("mtbs_q99011") then
				if TppStory.GetElapsedMissionCount( TppDefine.ELAPSED_MISSION_EVENT.QUIET_VISIT_MISSION ) == TppDefine.ELAPSED_MISSION_COUNT.INIT then
					
					Fox.Log("First quiet obtain. Start elapsed mission event.")
					
					TppStory.StartElapsedMissionEvent( TppDefine.ELAPSED_MISSION_EVENT.QUIET_VISIT_MISSION, TppDefine.INIT_ELAPSED_MISSION_COUNT.QUIET_VISIT_MISSION + 1)
				end
			end
		end
		
		
		
		
		TimerStart( "timer_startSE", 1)
		
		
		if ( svars.isHeliClear ) then
			TimerStart( "timer_startDemoHeli", 2)
		else
			
			TimerStart( "timer_startDemoHeli", 10)
		end
	end,
}



sequences.Seq_Game_QuietDead = {
	OnEnter = function()
		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE
		Player.ResetPadMask {settingName = "restrictPlayerActionBeforeDemo"	}
		Player.ResetPadMask {settingName = "restrictPlayerActionBeforeDemo_AtRequestMove"	}
		Player.ResetPadMask {settingName = "restrictPlayerActionBeforeDemo_AtDemoPrepare"	}
	
		
		if (svars.restoreState == StrCode32("Dead")) then
			Fox.Log( "#### s10050_sequence.Seq_Game_QuietDead ### restoreState = "..tostring(svars.restoreState) )
			s10050_enemy.StartQuietDeadEffect()
		end

		
		this.ActivateDD(false)
		
		
		TppMission.FinishBossBattle()

		
		TppBuddyService.SetBuddyCommonFlag(BuddyCommonFlag.BOSS_QUIET_KILL)

		TppMission.UpdateObjective{	objectives = {"deleteMarker_KillQuietGame"} }
		TppMission.UpdateObjective{	objectives = {"announce_achieveObjective"} }
		TppMission.UpdateObjective{	objectives = {"complete_missionTask_02"} }
		
		
		TppMission.UpdateObjective{
			radio = {
				radioGroups = {	"s0050_rtrg3010", "s0050_rtrg3020", },
				radioOptions =	{ delayTime = "short" },
			},
			objectives = {
				"on_subGoal_afterKillGame",
			},
		}
		
		
		s10050_radio.SetRadioFromSituation()	
		
		
		if (TppQuest.IsOpen("sovietBase_q99020") and not(TppQuest.IsCleard("sovietBase_q99020"))) then
			TppRadio.SetOptionalRadio("Set_s0050_oprg7000")
		else
			TppRadio.SetOptionalRadio("Set_s0050_oprg7005")		
		end

		
		svars.restoreState = StrCode32("Dead")

		
		if (svars.isFinishKillGame)then
			
			TppMission.UpdateCheckPoint("CHK_NotKillQuiet")
		else
			
			TppMission.UpdateCheckPoint("CHK_StartPos")
		end
		
		
		svars.killCount = svars.killCount + 1
		Tpp.IncrementPlayData( "totalKillCount" )

		if vars.missionCode == 10050 then 
			
			TppStory.ResetCounterReunionQuiet()
		end
		
	end,
}



return this