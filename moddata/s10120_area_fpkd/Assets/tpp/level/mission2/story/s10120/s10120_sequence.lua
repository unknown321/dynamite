local this = {}
local StrCode32 = Fox.StrCode32l
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}





local TARGET_ENEMY_NAME = "TppLiquid2"

this.missionTask_1_bonus_TARGET_LIST = {		
	"TppLiquid2",
}

this.missionTask_2_bonus_TARGET_LIST = {		
	"hos_mis_woman",
}

this.missionTask_4_TARGET_LIST = {		
	"col_diamond_l_s10120_0000",
}
this.missionTask_5_TARGET_LIST = {		
	"sol_outland_0000",
	"sol_outland_0001",
	"sol_outland_0002",
	"sol_outland_0003",
	"sol_outland_0004",
	"sol_outland_0005",
	"sol_outland_0006",
	"sol_outland_0007",
	"sol_outland_0008",
	"sol_outland_0009",
	"sol_outland_0010",
	"sol_outland_0011",
	"sol_outlandNorth_0000",
	"sol_outlandNorth_0001",
	"sol_outlandNorth_0002",
	"sol_outlandNorth_0003",
	"sol_outlandNorth_0004",
	"sol_outlandNorth_0005",
	"sol_outlandNorth_0006",
	"sol_outlandNorth_0007",
}


this.specialBonus = {
	first = {
		missionTask = { taskNo = 2 }, 
	},
	second = {
		missionTask = { taskNo = 3 }, 
	}
}


this.MAX_PLACED_LOCATOR_COUNT = 20


local LONG_RANGE_STANDARD = 50


this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true





function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		"Seq_Game_MainGame", 
		"Seq_Demo_LiquidFightBeforeCamera", 
		"Seq_Demo_LiquidFightBefore", 
		"Seq_Game_LiquidFight", 
		"Seq_Demo_LiquidFightAfter", 
		"Seq_Game_CallHeli", 
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	isLiquidDownInside = false,
	isPlayerSpottedMainGame = false, 
	isPlayerInFightArea = false,
	isKidsFightRoute = false,
	isKidsEscaping = false,
	isDiaFound = false,
	isLiquidUnconscious = false,
	
	UniqueInterCount_FarPoint = 0,
	
		
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
	
	isMissionTask1 = false,
}


this.checkPointList = {
	"CHK_BelowBoat",		
	"CHK_LiquidFight",		
	"CHK_CarryLiquid",  	
	nil
}

this.baseList = {
	
	"outland",
	
	"outlandEast",
	"outlandNorth",
	nil
}





this.missionObjectiveDefine = {

	default_area_outland_findwm = {
		gameObjectName = "s10120_marker_findwm",
		viewType = "all",
		visibleArea = 4,
		randomRange = 0,
		setNew = false,
		mapRadioName = "s0120_mprg0010",
		langId = "marker_info_mission_targetArea",
		announceLog = "updateMap",
	},
	default_area_outland_recoverliquid = {
		gameObjectName = "TppLiquid2",
		
		viewType = "map_and_world_only_icon",
		setNew = false,
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_chara_whitemanba",
		visibleArea = 0,
		randomRange = 0,
	},
	
	
	default_photo_wm = {
		photoId = 10, addFirst = true, addSecond = false, photoRadioName = "s0120_mirg0010", 
	},
	
	marker_info_hostage = {
		gameObjectName = this.missionTask_2_bonus_TARGET_LIST[1], 
		goalType = "moving",viewType="map_and_world_only_icon", 
		setNew = true, setImportant = false,
		langId = "marker_hostage",
		announceLog = "updateMap",
	},
	
	
	
	hud_photo_eli = {
		hudPhotoId = 10
	},
	
	
	subGoal_Find_WhiteMamba = {
		subGoalId= 0,
	},
	subGoal_CarryWhiteMambaToLZ = {	
		subGoalId= 2,
	},
	

	missionTask_1_RecoverWhiteManba = {	
		missionTask = { taskNo=1, isComplete=false },
	},
	missionTask_1_RecoverWhiteManba_clear = {
		missionTask = { taskNo=1, isNew=true, isComplete=true },
	},


	missionTask_2_bonus_RecoverHostage = {	
		missionTask = { taskNo=2, isComplete=false, isFirstHide=true },
	},
	missionTask_2_bonus_RecoverHostage_clear = {
		missionTask = { taskNo=2, isNew=true },
	},


	missionTask_3_bonus_NoDetected = {	
		missionTask = { taskNo=3, isComplete=false, isFirstHide=true },
	},
	missionTask_3_bonus_NoDetected_clear = {
		missionTask = { taskNo=3, isNew=true },
	},


	missionTask_4_RecoverDiamond = {	
		missionTask = { taskNo=4, isComplete=false, isFirstHide=true },
	},
	missionTask_4_RecoverDiamond_clear = {
		missionTask = { taskNo=4, isNew=true, isComplete=true },
	},

	missionTask_5_Recover13Children = {	
		missionTask = { taskNo=5, isComplete=false, isFirstHide=true },
	},
	missionTask_5_Recover13Children_clear = {
		missionTask = { taskNo=5, isNew=true, isComplete=true },
	},
	
	
	clear_photo_wm = {
		photoId = 10, addFirst = true, addSecond = false,
	},
}

this.missionObjectiveTree = {	
		default_area_outland_recoverliquid	= {
			default_area_outland_findwm = {
				
			},
		},
		default_photo_wm = {},
	
	missionTask_1_RecoverWhiteManba_clear = {
		missionTask_1_RecoverWhiteManba ={},
	},
	missionTask_2_bonus_RecoverHostage_clear = {
		missionTask_2_bonus_RecoverHostage ={},
	},
	missionTask_3_bonus_NoDetected_clear = {
		missionTask_3_bonus_NoDetected ={},
	},
	missionTask_4_RecoverDiamond_clear = {
		missionTask_4_RecoverDiamond ={},
	},
	missionTask_5_Recover13Children_clear = {
		missionTask_5_Recover13Children ={},
	},
	
	
	subGoal_CarryWhiteMambaToLZ = {	
			subGoal_Find_WhiteMamba = {},
	},
	marker_info_hostage = {},
	
	
	clear_photo_wm = {
		default_photo_wm = {},
	},
}

this.missionStartPosition = {
	helicopterRouteList = {
		"rt_drp_clifftown_N_0000",
		"rt_drp_clifftown_E_0000",
	},
	orderBoxList = {
		"box_s10120_00",
	},
}

this.missionObjectiveEnum = Tpp.Enum{
	"default_area_outland_recoverliquid",
	"default_area_outland_findwm",
	"default_photo_wm",
	"hud_photo_eli",
	

	"missionTask_1_RecoverWhiteManba",
	"missionTask_1_RecoverWhiteManba_clear",
	

	"missionTask_2_bonus_RecoverHostage",
	"missionTask_2_bonus_RecoverHostage_clear",

	"missionTask_3_bonus_NoDetected",
	"missionTask_3_bonus_NoDetected_clear",


	"missionTask_4_RecoverDiamond",
	"missionTask_4_RecoverDiamond_clear",

	"missionTask_5_Recover13Children",
	"missionTask_5_Recover13Children_clear",

	
	"subGoal_CarryWhiteMambaToLZ",
	"subGoal_Find_WhiteMamba",

	"marker_info_hostage",
	
	
	"clear_photo_wm",
}





function this.MissionPrepare()

	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	
	TppMission.RegisterMissionSystemCallback{
	
		OnEstablishMissionClear = function()
			gvars.mbFreeDemoPlayRequestFlag[TppDefine.MB_FREEPLAY_DEMO_REQUESTFLAG_DEFINE.PlayAfterWhiteMamba] = true 
			TppScriptBlock.LoadDemoBlock( "Demo_Liquid_HeliEscape" )

			local funcs = function()
				Player.SetPause()
				TppMission.MissionGameEnd()
			end
			svars.isMissionTask1 = true
			
			TppHero.AddTargetLifesavingHeroicPoint( false )
			
			s10120_demo.PlayLiquidTest3(funcs)
		end,
		
		OnSetMissionFinalScore = this.OnSetMissionFinalScore,
		
		OnGameOver = this.OnGameOver,
	
		
		OnRecovered = function( gameObjectId )
			Fox.Log("##** OnRecovered_is_coming ####")
			
			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_5_TARGET_LIST ) then
				svars.CountTaskList05Num = this.CountRecoveredMissionTask5( this.missionTask_5_TARGET_LIST )
				
				this.UIUpdatesforMissionTask5()
			end
			
			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_2_bonus_TARGET_LIST ) then
				
				TppResult.AcquireSpecialBonus{ first = { isComplete = true,},}	
				TppMission.UpdateObjective{
					objectives = { "missionTask_2_bonus_RecoverHostage_clear" },
				}
			end
			
			
			if this.DoesIncludeTarget( gameObjectId, this.missionTask_4_TARGET_LIST ) then
				TppMission.UpdateObjective{
					objectives = { "missionTask_4_RecoverDiamond_clear" },
				}
			end
		end,
	}
	
	
	local hour, minute, second = TppClock.GetTime( "time" ) 
	
	
	TppMarker.SetUpSearchTarget{
		{
			gameObjectName = "TppLiquid2", gameObjectType = "TppLiquid2", messageName = "TppLiquid2", skeletonName = "SKL_004_HEAD",
			func = this.WhiteMambaFound },	
		}
	
	TppClock.RegisterClockMessage( "OnSleepTime", "00:00:00" )
	TppClock.RegisterClockMessage( "OnWakeUpTime", "08:00:00" )

	
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppCritterBird" )	

end

function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
	TppCheckPoint.Enable{ baseName = { "outland", "outlandNorth" } }
	
end

function this.OnGameOver()
	Fox.Log("*** Enter OnGameOver function ***")
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
		Fox.Log("*** Enter OnGameOver function TARGET_DEAD ***")
		TppPlayer.SetTargetDeadCamera{ gameObjectName = mvars.deadNPCId }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.PLAYER_KILL_CHILD_SOLDIER ) then
		Fox.Log("*** Enter OnGameOver function PLAYER_KILL_CHILD_SOLDIER ***")
		TppPlayer.SetPlayerKilledChildCamera()
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end	
end


function this.ContinueMission()
	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
	GameObject.SendCommand(gameObjectId, { id="SetCombatEnabled", enabled=false })
	
	this.SetLiquidRouteWithTime()
	
	this.UIUpdatesforMissionTask5()
	
	local cpId = { type="TppCommandPost2" }
	local time = 150000000.0
	local command = { id = "SetGrenadeTime", time=time }
	GameObject.SendCommand( cpId, command )
end





function this.OnSetMissionFinalScore(missionClearType)
	Fox.Log("*** s10120:OnSetMissionFinalScore ***")
	
	if svars.isMissionTask1 == true then
		TppMission.UpdateObjective{
			objectives = { "missionTask_1_RecoverWhiteManba_clear" },
		}	
	end		
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


this.CountRecoveredMissionTask5 = function( targetList )
	Fox.Log("##** Count_MissionTask5_number of children on the list ####")
	
	svars.CountTaskList05Num = 0
	
	for i, targetName in ipairs( targetList ) do
		Fox.Log(targetName)
		Fox.Log(svars.CountTaskList05Num)
		if TppEnemy.IsRecovered( targetName ) then
			svars.CountTaskList05Num = svars.CountTaskList05Num +1
		end
	end
	
	return svars.CountTaskList05Num
end


function this.UIUpdatesforMissionTask5()
	Fox.Log("***UIUpdatesforMissionTask5")
	
	if svars.CountTaskList05Num >= 20	then
		TppMission.UpdateObjective{
			objectives = {"missionTask_5_Recover13Children_clear"},
		}
	else
		Fox.Log("Non missionTask_5_Recover13Children_clear")
	end
end

function this.WhiteMambaFound()

	
	if TppSequence.GetCurrentSequenceName() == "Seq_Game_MainGame" then
		
		TppMission.UpdateObjective{ objectives = { "default_area_outland_recoverliquid","hud_photo_eli" }}
		if svars.isLiquidUnconscious == false then
			
			s10120_radio.SetIntelRadioLiquidFound()
			
			TppRadio.PlayCommonRadio( TppDefine.COMMON_RADIO.SEARCH_TARGET_ENABLED )
		else
			Fox.Log("svars.isLiquidUnconscious == true ... Dont Play Radio & Dont Change Intel Radio")
		end
	else
		Fox.Log("TppSequence.GetCurrentSequenceName ~= Seq_Game_MainGame ... Not CompleteSearchTarget !!")
	end
end

this.FuncDeadLiquid = function( gameObjectId )
	Fox.Log("FuncDeadLiquid Liquid is killed")
	mvars.deadNPCId = TARGET_ENEMY_NAME
	TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.S10120_TARGET_DEAD )
	TppUiCommand.SetGameOverType( 'TimeParadox' )
end

this.FuncDeadChildSoldier = function( gameObjectId )
	local soldierType = TppEnemy.GetSoldierType( gameObjectId )
	if soldierType == EnemyType.TYPE_CHILD then
		Fox.Log("FuncDeadChildSoldier Child is killed")
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.PLAYER_KILL_CHILD_SOLDIER, TppDefine.GAME_OVER_RADIO.S10120_CHILD_DEAD )
	end
end

this.FuncUnconsciousLiquid = function( gameObjectId )
	Fox.Log("Liquid unconscious. Stop boss BGM.")
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "mafr_outland_cp" ) , { id = "SetPhase", phase = TppEnemy.PHASE.SNEAK } )
	TppMusicManager.PlaySceneMusic( "Stop_bgm_s10120_eli" )
	local currentSequence = TppSequence.GetCurrentSequenceName()
	local didFightStart = ( currentSequence == "Seq_Game_LiquidFight" )
	if ( didFightStart ) then
		Fox.Log("Liquid Unconscious during fight. Make kids escape.")
		this.MakeKidsEscape()
	end

	
	local playerDistance = this.FuncGetPlayerDistanceFromLiquid()
	if playerDistance > LONG_RANGE_STANDARD then
		s10120_radio.ClearLiquidFromFar()
	else
		s10120_radio.ClearLiquid()
	end
	s10120_radio.OptionalRadioCarryLZ()
	svars.isLiquidUnconscious = true	
end

this.FuncGetPlayerDistanceFromLiquid = function()
	local gameObjectId = { type="TppLiquid2", index=0 }
	local command = { id = "GetPlayerDistance" }
	local playerDistance = GameObject.SendCommand( gameObjectId, command )
	return playerDistance
end









function this.SetLiquidRouteWithTime()
	local time = TppClock.GetTime("string")
	local isSleepTime = (time > "00:00:00" and time < "08:00:00")
	if isSleepTime then
		
		local gameObjectId = { type="TppLiquid2", index=0 }
		local command = {id="SetRoute", route="rts_s10120_s_TppLiquid2", point=0}
		GameObject.SendCommand(gameObjectId, command)
	else
		
		Fox.Log("time:" .. time .. " -SetLiquidPatrolRoute")
		local gameObjectId = { type="TppLiquid2", index=0 }
		local command = {id="SetRoute", route="rts_s10120_d_TppLiquid2", point=0}
		GameObject.SendCommand(gameObjectId, command)		
	end	
end

function this.UnsetRouteSpecial(route)
	if (svars.isKidsEscaping == true ) then
		
		return
	end
	
	local gameObjectId = { type="TppSoldier2" } 
	local command = { id="GetGameObjectIdUsingRoute", route=route }
	local soldiers = GameObject.SendCommand( gameObjectId, command )
	Fox.Log( #soldiers )
					
	for i, soldier in ipairs(soldiers) do
		Fox.Log( string.format("0x%x", soldier) )
		TppEnemy.UnsetSneakRoute( soldier )
	end
end

function this.UnsetCommandAi()
	Fox.Log("Unset all kids command AI")
	for i, kid in ipairs(s10120_enemy.childSoldiersInTown) do	
		
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", kid )
		local command = { id="RemoveCommandAi", }
		GameObject.SendCommand( gameObjectId, command )
	end
end

function this.MakeKidsEscape()
	
	Fox.Log("Actually make kids escape!")
	
	this.UnsetCommandAi()
	
	svars.isKidsEscaping = true
	svars.isKidsFightRoute = false
	for i, kid in ipairs(s10120_enemy.childSoldiersInTown) do	
		
		
		local kidEscapeRoute = s10120_enemy.kidEscapeRoutes[i]

		
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", kid )
		GameObject.SendCommand( gameObjectId, { id="SetSneakRoute", route=kidEscapeRoute } )
		GameObject.SendCommand( gameObjectId, { id="SetCautionRoute", route=kidEscapeRoute } )
		GameObject.SendCommand( gameObjectId, { id="SetAlertRoute", route=kidEscapeRoute } )
		GameObject.SendCommand( gameObjectId, { id="SetPuppet", enabled=true } )
	end
	
end

function this.ForceLiquidUnconscious()
	local gameObjectId = { type="TppLiquid2", index=0 }
	GameObject.SendCommand(gameObjectId, {id="ForceUnconscious"} )
end

function this.SetKidsFightRoutes()
	if (svars.isKidsFightRoute == true ) then
		
		return
	end
	
	if (svars.isKidsEscaping == true ) then
		
		return
	end
	
	Fox.Log("set kid fight routes")
	svars.isKidsFightRoute = true
	for i, kid in ipairs(s10120_enemy.childSoldiersInTown) do	
		
		
		local kidFightRoute = s10120_enemy.kidFightRoutes[i]

		
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", kid )
		local command = { id="SetAlertRoute", route=kidFightRoute }
		GameObject.SendCommand( gameObjectId, command )
	end
end

function this.UnsetKidsFightRoutes()

	this.UnsetCommandAi()
	
	if (svars.isKidsFightRoute == false ) then
		
		return
	end
	
	if (svars.isKidsEscaping == true ) then
		
		return
	end
	
	Fox.Log("unset kid fight routes")
	svars.isKidsFightRoute = false
	for i, kid in ipairs(s10120_enemy.childSoldiersInTown) do	
		
		local kidFightRoute = ""

		
		local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", kid )
		local command = { id="SetAlertRoute", route=kidFightRoute }
		GameObject.SendCommand( gameObjectId, command )
	end
end

function this.UpdateEverything()
	
	if (svars.isKidsEscaping == true ) then
		
		return
	end
	
	local needToUseFightRoutes = false 
	
	local currentSequence = TppSequence.GetCurrentSequenceName()
	local didFightStart = ( currentSequence == "Seq_Game_LiquidFight" )
	if ( didFightStart and svars.isPlayerInFightArea ) then
		needToUseFightRoutes = true
	end
	
	local didPickUpLiquid = ( currentSequence == "Seq_Game_CallHeli" )

	if didPickUpLiquid == true then
		Fox.Log("UpdateEverything: make kids escape!")
		this.MakeKidsEscape()
	elseif needToUseFightRoutes == true then
		
		this.SetKidsFightRoutes()
	else
		
		this.UnsetKidsFightRoutes()		
	end	
	
end

function this.IsChildSoldierOrLiquid( gameObjectId )
	local soldierType = TppEnemy.GetSoldierType( gameObjectId )
	local liquidGameObjectId = GameObject.GetGameObjectId( "TppLiquid2" )
	if soldierType == EnemyType.TYPE_CHILD or gameObjectId == liquidGameObjectId then
		return true
	end	
	return false
end



function this.Messages()
	return
	StrCode32Table {
		Player = {
			{
				msg = "LiquidPutInHeli",
				func = function()
					TppMission.UpdateObjective{
						objectives = { "missionTask_1_RecoverWhiteManba_clear" },
					}
					TppMission.ReserveMissionClear{ nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE, missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER }
				end,	
			},
			{	
			 	msg = "OnPickUpCollection",
				func = function( playerGameObjectId, collectionUniqueId, collectionTypeId )
					if collectionUniqueId == TppCollection.GetUniqueIdByLocatorName( "col_diamond_l_s10120_0000" ) then
						TppMission.UpdateObjective{
							objectives = { "missionTask_4_RecoverDiamond_clear" },	
						}
					end
				end
			},
			{	
				msg = "PressedFultonNgIcon",
				func = function ( arg1 , arg2 )
					if this.IsChildSoldierOrLiquid( arg2 ) then
						s10120_radio.CantFultonChild()
					end
				end
			},
			{	
				msg = "CqcHoldStart",
				func = function ( arg1 , arg2 )
					if this.IsChildSoldierOrLiquid( arg2 ) then
						s10120_radio.CantHoldChild()
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
				sender = "trap_0002",
				func = function()
					TppSound.SetPhaseBGM( "bgm_liquid" )
				end,
			},
			{
				msg = "Enter",
				sender = "trap_0001",
				func = function()
						
					if TppEnemy.GetPhase("mafr_outland_cp") <= TppEnemy.PHASE.SNEAK then
						s10120_radio.GetIntoOutland()
						s10120_radio.DontKillKids()
					end
				end,
			},
			{
				msg = "Enter", 	sender = "trap_fight",
				func = function()
					svars.isPlayerInFightArea = true
					this.UpdateEverything()
				end,
			},
			{
				msg = "Exit", 	sender = "trap_fight",
				func = function()
					svars.isPlayerInFightArea = false
					this.UpdateEverything()
				end,
			},
		},
		GameObject = {
			{ 	
				msg = "Fulton",
				sender = "hos_mis_woman",
				Fox.Log("***missionTask_2_bonus_RecoverHostage_clear"),
				func = function()
					TppMission.UpdateObjective{
						objectives = { "missionTask_2_bonus_RecoverHostage_clear" },
					}
				end,
			},
			{	
				msg = "AimedFromPlayer",
				func = function( gameObjectId )
					
					Fox.Log("aim from player ".. gameObjectId )
					
					local slot = vars.currentInventorySlot
					local subIndex =  vars.currentSupportWeaponIndex
					local isNonActive = Player.IsNonActiveBySlot( slot, subIndex )
					if isNonActive == false then
						s10120_radio.DontAimChild()
					end
				end
			},
			{
				msg = "LiquidGhostKnockout",
				sender = "TppLiquid2",
				func = function()
						TppMission.UpdateObjective{
							objectives = { "missionTask_3_bonus_NoDetected_clear" },	
							TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}	
						}
				end,	
			},
			{
				msg = "Carried",
				sender = "TppLiquid2",
				func = function()
					local sequence = TppSequence.GetCurrentSequenceName()
					if not (sequence == "Seq_Game_CallHeli") then
						TppSequence.SetNextSequence("Seq_Game_CallHeli")
					end
				end,	
			},
			{ 	
				msg = "Unconscious",
				sender = "TppLiquid2",
				func = this.FuncUnconsciousLiquid 
			},
			{
				msg = "Dead",
				func = function( gameObjectId )
					Fox.Log("Enter DEAD MESSAGE: gameObjectId" .. tostring( gameObjectId ) )
					if gameObjectId ==  GameObject.GetGameObjectId ("TppLiquid2", "TppLiquid2") then 
						Fox.Log("Enter DEAD MESSAGE LIQUID")
						this.FuncDeadLiquid()
					else	
						Fox.Log("LOOP LOOP LOOP")
						for i, boyName in pairs( s10120_enemy.AllChildSoldier ) do
							local boyID = GameObject.GetGameObjectId( boyName )
							
							if gameObjectId == boyID then
								Fox.Log("Enter DEAD MESSAGE CHILD")
								this.FuncDeadChildSoldier()
							end
						end
					end
				end,
				option = { isExecGameOver = true }
			},
		}, 
		Timer = {
			{
				msg = "Finish", sender = "Timer_LiquidLZGo",
				func = function()
					local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
					GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name = "lzs_outland_Liquid" })
				end,
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
		Weather = {
			{
				
				msg = "Clock",
				sender = "OnSleepTime",
				func = function()
					Fox.Log("Liquid: Set OnSleepTime Route")
					this.SetLiquidRouteWithTime()
				end,
			},
			{
				
				msg = "Clock",
				sender = "OnWakeUpTime",
				func = function()
					Fox.Log("Liquid: Set OnWakeUpTime Route")
					this.SetLiquidRouteWithTime()
				end,
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
					msg = "LiquidChangePhase", func = self.FuncLiquidChangePhase
				},
			},
			Trap = {
				{	 
					msg = "Enter", sender = "trap_boat_out", func = function( trap, player )
						TppCheckPoint.Update
						{
						checkPoint = "CHK_BelowBoat",
						ignoreAlert = false,
						}
					end
				},
				{ 
					msg = "Enter", sender = "trap_liquid", func = function()

						local gameObjectId = { type="TppLiquid2", index=0 }
	 					local liquidLifeState = GameObject.SendCommand( gameObjectId, { id = "GetLifeStatus" } )
	 					local liquidPhase = GameObject.SendCommand( gameObjectId, { id = "GetPhase" } )
	 					local liquidChair = GameObject.SendCommand( gameObjectId, { id = "IsSittingInChair" } )
						local cpPhase = TppEnemy.GetPhase( "mafr_outland_cp" )
						
						Fox.Log( "entered stairs trap " .. tostring(liquidLifeState) .. "," .. tostring(liquidPhase) .. "," .. tostring(liquidChair) .. "," .. tostring(cpPhase) )
						
	 					if (cpPhase ~= TppEnemy.PHASE.ALERT) and liquidChair then
							
							Fox.Log("start pre-fight demo")
							TppSequence.SetNextSequence("Seq_Demo_LiquidFightBeforeCamera")
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
			TppCoder.SetWorldCenter(Vector3(-605.97375, 5.8471327, 855.3026))
		end

		TppTelop.StartCastTelop()
		
		TppScriptBlock.LoadDemoBlock( "Demo_Liquid_combat" )
		

		local startRadioGroup = s10120_radio.GetMissionStartRadioGroup()

		
		TppMission.UpdateObjective{
			objectives = { 
				"default_photo_wm",		
				"missionTask_1_RecoverWhiteManba",
				"missionTask_2_bonus_RecoverHostage",
				"missionTask_3_bonus_NoDetected",
				"missionTask_4_RecoverDiamond",
				"missionTask_5_Recover13Children",
				"subGoal_Find_WhiteMamba",
			},
		}
		
		TppMission.UpdateObjective{
			radio = {
				radioGroups = startRadioGroup,
			},
			objectives = { "default_area_outland_findwm" , }, 
		}

		
		if TppSequence.GetContinueCount() > 0 then
			
		end
		s10120_radio.OptionalRadioGoToOutland()
		s10120_radio.SetIntelRadioBeforeLiquidFight()	
		
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="DisableLandingZone", name = "lzs_outland_Liquid" })		
		
		this.ContinueMission()
		
		TppMission.SetHelicopterDoorOpenTime( 15 )
	end,

	OnLeave = function ()

	end,
	
	FuncLiquidChangePhase = function(GameObjectId, NewPhaseName)
	Fox.Log( "LiquidNewPhaseName : "  .. NewPhaseName )
		if NewPhaseName == TppLiquid2.LIQUID_PHASE_STARTED_FIGHT then
		
			TppCheckPoint.Update
				{
					checkPoint = "CHK_BelowBoat",
					ignoreAlert = true,
				}
		
			TppSequence.SetNextSequence("Seq_Game_LiquidFight")
		end
	end, 	
}

sequences.Seq_Demo_LiquidFightBeforeCamera = {

	OnEnter = function()
		local func = function() 
			Fox.Log( "SetNextSequence Seq_Demo_LiquidFightBefore"  )
			TppSequence.SetNextSequence("Seq_Demo_LiquidFightBefore") 
		
		Player.SetPadMask {
			
			settingName = "settingName",    
			
			except = false,                                 
			
			buttons = PlayerPad.ALL, 
			
			sticks = PlayerPad.STICK_L,     
			
			triggers = PlayerPad.TRIGGER_L, 
		}
			
		end
		Fox.Log( "PlayLiquidTest0"  )
		s10120_demo.PlayLiquidTest0(func)
		
	end,
	
	OnLeave = function ()
	end,
}

sequences.Seq_Demo_LiquidFightBefore = {
	
	OnEnter = function()
		local gameObjectId = { type="TppLiquid2", index=0 }
		GameObject.SendCommand( gameObjectId, { id = "InitiateCombat" } )
		
		this.SetKidsFightRoutes()
		local func = function() TppSequence.SetNextSequence("Seq_Game_LiquidFight") end
		s10120_demo.PlayLiquidTest(func)
		svars.isPlayerInFightArea = true
		
		TppMission.StartBossBattle()
	end,
	
	OnLeave = function ()

		Player.ResetPadMask {
			settingName = "settingName"
		}
		TppCheckPoint.Update {
			checkPoint = "CHK_LiquidFight", ignoreAlert = true,
		}
	end,
}

sequences.Seq_Game_LiquidFight = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{ 
					msg = "LiquidDefeatedByCqcInStartRoom", sender = "TppLiquid2", func = function ()
						svars.isLiquidDownInside = true
						TppSequence.SetNextSequence( "Seq_Demo_LiquidFightAfter" )
					end
				},
				{ 
					msg = "LiquidEnterCombatPhaseTwo", sender = "TppLiquid2", func = function ()
						TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10120_eli_sn")
						local randomNum = math.random()
						if randomNum < 0.666 then
							Fox.Log( randomNum .. " is less than " .. 0.666 .. " - make it rain" )
							WeatherManager.RequestWeather(TppDefine.WEATHER.RAINY, 20)
						else
							Fox.Log( randomNum .. " is greater than " .. 0.666 .. " - don't change weather" )
						end
						s10120_radio.OptionalRadioFightPhaseTwo()	
					end
				},
				{
					msg = "RoutePoint2",
					func = function (gameObjectId, routeId ,routeNode, messageId )
						if messageId == Fox.StrCode32( "ShootAtPlayerOnBoat" ) then
							Fox.Log("Set command ai")
							local command = { id="SetCommandAi", commandType = CommandAi.LIQUID_ASSIST, }
							GameObject.SendCommand( gameObjectId, command )							
						end
					end
				},
			},			
		}
	end,

	OnEnter = function()
		this.ContinueMission()
		this.UpdateEverything()
		Fox.Log("Enter Seq_Game_LiquidFight")
		TppScriptBlock.LoadDemoBlock( "Demo_Liquid_combatEnd" )
		TppMarker.Disable( "s10120_marker_findwm" )	

		TppMission.UpdateObjective{	
				objectives = { "clear_photo_wm", },
		}
		
		local gameObjectId = { type="TppLiquid2", index=0 }
		GameObject.SendCommand( gameObjectId, { id = "InitiateCombat" } )
		
		TppSound.SetSceneBGM("bgm_eli")
		TppMusicManager.PlaySceneMusic( "Play_bgm_s10120_eli" )
		TppSound.SetSceneBGMSwitch("Set_Switch_bgm_s10120_eli_al") 

		s10120_radio.OptionalRadioFightPhaseOne()
		s10120_radio.SetIntelRadioLiquidFightStarted()	
		
		
		if TppSequence.GetContinueCount() > 0 then
			s10120_radio.MissionContinueDuringLiquidFight()
		end
		
		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE 
		
		TppCheckPoint.Disable{ baseName = { "outland", "outlandNorth" } }
		
	end,
	
	OnLeave = function ()

	end,
}

sequences.Seq_Demo_LiquidFightAfter = {

	OnEnter = function()

		local funcs = {
			onEnd = function() 
				Fox.Log("Seq_Demo_LiquidFightAfter onEnd: go to Seq_Game_CallHeli")
				TppSequence.SetNextSequence( "Seq_Game_CallHeli" )
			end,
		}
		s10120_demo.PlayLiquidTest2(funcs)
	end,
	
	OnLeave = function ()		
	end,
}

sequences.Seq_Game_CallHeli = {

		Messages = function( self )
		return
		StrCode32Table {
			GameObject = {
				{
					msg = "RoutePoint2",
					func = function (gameObjectId, routeId ,routeNode, messageId)
						if messageId == Fox.StrCode32( "RemoveMarker" ) then
							local command = { id="SetMarkerEnabledCommand", alwaysDisable=true }
							GameObject.SendCommand( gameObjectId, command )		
						else
							Fox.Log("")				
						end
					end
				},
			},	
		}
	end,

	OnEnter = function()
		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE
		this.ForceLiquidUnconscious()
		this.MakeKidsEscape()
		this.ContinueMission()
		
		this.UpdateEverything()
		
		TppSound.StopSceneBGM() 
		
		
		if TppMarker.GetSearchTargetIsFound( TARGET_ENEMY_NAME ) == true	then
			Fox.Log("already TARGET_ENEMY_NAME TargetMark ON ... ")
		else	
			TppMarker.DisableSearchTarget( TARGET_ENEMY_NAME )
		end
		
		TppMission.UpdateObjective{	
				objectives = { "default_area_outland_recoverliquid","subGoal_CarryWhiteMambaToLZ","clear_photo_wm", },
			}
		TppCheckPoint.Update
			{
				checkPoint = "CHK_CarryLiquid", ignoreAlert = true,
			}
		

		TppScriptBlock.LoadDemoBlock( "Demo_Liquid_HeliEscape" )
		
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand(gameObjectId, { id="EnableLandingZone", name = "lzs_outland_Liquid" })
		
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand( gameObjectId, { id="SetLandingZnoeDoorFlag", name="lzs_outland_Liquid", leftDoor="Open", rightDoor="Close" } )
		
		if GkEventTimerManager.IsTimerActive("Timer_LiquidLZGo") then
		GkEventTimerManager.Stop("Timer_LiquidLZGo")
		end
		
		GkEventTimerManager.Start("Timer_LiquidLZGo", 2)
		
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_outland_N0000|lz_outland_N_0000" }
		
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_outland_S0000|lz_outland_S_0000" }
		
		
		s10120_radio.OptionalRadioCarryLZ()
		
		
		TppMission.FinishBossBattle()
		
		TppCheckPoint.Disable{ baseName = { "outland", "outlandNorth" } }
	end,
	
	OnLeave = function ()
	end,
}




return this
