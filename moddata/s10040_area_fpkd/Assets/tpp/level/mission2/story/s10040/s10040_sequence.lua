local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}





local HOSTAGE_NAME = "hos_s10040_0000"
local HONEY_BEE_NAME = "itm_wpn_s10040_000"
local HONEY_BEE_ID = TppDefine.HONEY_BEE_EQUIP_ID
local GIMMICK_PATH = "/Assets/tpp/level/mission2/story/s10040/s10040_item.fox2"
local ROOM_BOX = "afgh_wdbx002_wdbx001_ex1_gim_n0000|srt_afgh_wdbx002_wdbx001"
local BOSS_CLEAR_COUNT = 4 

local NUM_SNIPER	= 2	


local TIME_START_TAKE = 1*24*60*60/20	
local TIME_SERCH1		=	20
local TIME_SERCH2		=	10
local TIME_RESCUE		=	4
local TIME_HELI_TO_FADE	= 2
local TIME_HELI_CALL	= 5
local TIME_GO_BOSS		= 9
local TIME_RADIO_BOSS	= 10 - 4
local TIME_HIDE_HELI	= 20
local TIME_GO_FORT 		= 10
local TIME_COUNT_HELI	= 60/20 * 60 


local MESSAGE_ROUTE = {
	LRRP1	= "ArrivalLRRP1",	
	OB1		= "ArrivalOB1",		
	LRRP2	= "ArrivalLRRP2",	
	OB2		= "ArrivalOB2",		
	LRRP3	= "ArrivalLRRP3",	
	FORT 	= "ArrivalAtFort",
	SERCH1	= "ArrivalSerch1",
	ROOM1 	= "TimeUpRoom1",
	ATTACK1	= "ArrivalAttack1",
	SERCH2	= "ArrivalSerch2",
	ROOM2 	= "TimeUpRoom2",
	ATTACK2	= "ArrivalAttack2",
	ROOM 	= "ArrivalAtRoom",
	DEMO1 	= "GoToRoomDemo1",
	DEMO2 	= "GoToRoomDemo2",
	HELI 	= "ArrivalHeli",
	HB		= "ArrivalHoneyBee",
	HURRY	= "BackToHeliRoute",
	PUT		= "PutHostage",
	GET		= "GetHoneyBee",
	WAIT1	= "WaitHostage",
	HOSTAGE = "HostageFortWait",
}

local IDEN_DEMO = "demo_position"
local DEMO_POS = {
	FORT	= "demoPos_Fort",
	EAST 	= "demoPos_East",
	WEST	= "demoPos_West",
	HOS		= "demoPos_hosFort",
}
local IDEN_LOCATOR = "s10040_Identifier"
local IDEN_KEY_LOCATOR = "locator_honey_bee"
local DIST_HONEY_BEE = 5*5
local DIST_GAMEOVER = 50000 

local WEATER_CHANGE_TIME = 5



this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true
this.MAX_PLACED_LOCATOR_COUNT = 30
this.EQUIP_MISSION_BLOCK_GROUP_SIZE = 1720000







function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Game_MainGame",
		"Seq_Demo_SkullFace",
		"Seq_Demo_SkullFace2",
		"Seq_Game_BossBattle",
		"Seq_Game_Escape",
		"Seq_Demo_HeliClear",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	
	eventSequenceNum	= 0,
	bossSequenceNum		= 0,
	bossDyingNum		= 0, 	
	rescueHostageNum	= 0,	
	countinuNum			= 0,	
	sinperNum			= 0,	
	
	isGetInfoHoneyBee 	= false,	
	isGetInfoHostage 	= false,	
	
	isGetMissile 		= false,
	isDownBoss			= false,
	isBreakBox			= false,
	
	isMarkHostage		= false,
	isDeadHostage		= false,
	
	enemyDownNum		= 0, 
	
	isDemoArea			= false,
	isDemoArea2			= false,
	
	isForceClear		= false, 
	
	isDebugCheck	= 0,

	isFlag00	= false,	
	isFlag01	= false,	
	isFlag02	= false,	
	isFlag03	= false,	
	isFlag04	= false,	
	isFlag05	= false,	
	isFlag06	= false,
	isFlag07	= false,
	isFlag08	= false,
	isFlag09	= false,
	numFlag00 = 0,			
	numFlag01 = 0,
	numFlag02 = 0,
	numFlag03 = 0,
	numFlag04 = 0,
	numFlag05 = 0,
	numFlag06 = 0,
	numFlag07 = 0,
	numFlag08 = 0,
	numFlag09 = 0,

}

this.EVENT_SEQUENCE = Tpp.Enum{
	"ATTACK",	
	"DRIVE",	
	"PRE_WAIT",
	"WAIT_FORT",
	"ATTACK0",
	"TAKE1",	
	"SERCH1",
	"ATTACK1",
	"TAKE2",
	"SERCH2",
	"ATTACK2",
	"TAKE3",
	"ROOM1",	
	"GET_MISSILE",
	"ROOM2",  
	"BACK_HELI",
}


this.BOSS_SEQUENCE = Tpp.Enum{
	"STAY",
	"DEMO",
	"BATTLE",
	"DEAD",
	"RUN",
}

this.checkPointList = {
	"CHK_demoStart",	
	"CHK_bridge",
	"CHK_hostage",
	"CHK_missile",
	"CHK_fort",
	"CHK_boss",
	"CHK_escape",
	"CHK_fortSerch",
	"CHK_fortSerch1",
	"CHK_fortSerch2",
	"CHK_honeyBee",
	"CHK_fort_enter",
	nil
}

this.baseList = {
	
	"fort",
	"bridge",
	
	"fortSouth",
	"fortWest",
	"bridgeNorth",
	"bridgeWest",
	
	"cliffSouth",
	"cliffWest",
	"slopedEast",
	nil
}






this.missionObjectiveDefine = {
	
	default_area_fort = {
		gameObjectName = "default_area_fort", visibleArea = 5, randomRange = 0, viewType="all",
		setNew = false,
		announceLog = "updateMap",
		mapRadioName = "s0040_mprg1010",
		langId = "marker_info_mission_targetArea",
		subGoalId = 0
	},
	marker_area_bridge = {
		gameObjectName = "marker_area_bridge", visibleArea = 4, randomRange = 2,viewType="all",
		setNew = false,
		announceLog = "updateMap",
		mapRadioName = "s0040_mprg1020",
		
	},
	marker_honey_bee = {
		gameObjectName = "marker_honey_bee", visibleArea = 0, randomRange = 0, viewType="all",
		setNew = true,
		announceLog = "updateMap",
		setImportant = true,
		mapRadioName = "s0040_mprg3010",
		langId = "marker_info_mission_target",
		
	},
	marker_hostage = {
		gameObjectName = HOSTAGE_NAME, goalType = "moving",viewType="map_and_world_only_icon", 
		setNew = true, setImportant = true,
		langId = "marker_hostage_hamid",
	},
	marker_about_bridge = {
		gameObjectName = "marker_about_bridge", visibleArea = 8, randomRange = 3,viewType="all",
		setNew = true,
		announceLog = "updateMap",
		
	},

	
	default_photo_honeyBee = {
		photoId			= 10,
		targetBgmCp = "afgh_fort_cp",
		photoRadioName = "s0040_mirg0010",
		
	},
	get_photo_honeyBee = {
		photoId			= 10,
		subGoalId 		= 2,
		
	},

	
	
	default_missionTask_00 = { missionTask = { taskNo = 0, isNew = true, isComplete = false, isFirstHide = false },},	
	
	default_missionTask_01 = { missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = true },},	
	open_missionTask_01    = { missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = false },},	






	
	default_missionTask_02 = { missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide = true },},	
	
	default_missionTask_03 = { missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide = true },},	
	
	default_missionTask_04 = { missionTask = { taskNo = 4, isNew = true, isComplete = false, isFirstHide = true },},	
	
	default_missionTask_05 = { missionTask = { taskNo = 5, isNew = true, isComplete = false, isFirstHide = true },},	

	
	clear_missionTask_00 = { missionTask = { taskNo = 0, isNew = true, isComplete = true },},	
	
	clear_missionTask_01 = { missionTask = { taskNo = 1, isNew = true, isComplete = true},},	






	
	clear_missionTask_02 = { missionTask = { taskNo = 3, isNew = true, isComplete = true},},	
	
	clear_missionTask_03 = { missionTask = { taskNo = 2, isNew = true, isComplete = true},},	

	
	clear_missionTask_04 = { missionTask = { taskNo = 4, isNew = true, isComplete = true },},	
	
	clear_missionTask_05 = { missionTask = { taskNo = 5, isNew = true, isComplete = true },},	

	announce_all_clear = {announceLog = "achieveAllObjectives",},
	
}

this.missionObjectiveTree = {
	get_photo_honeyBee = {
		marker_honey_bee = {
			default_area_fort = {},

		},
		default_photo_honeyBee = {},
	},
	marker_hostage = {
		marker_area_bridge = {
			marker_about_bridge = {},
		},
	},
	clear_missionTask_00 = {
		default_missionTask_00 = {},
	},
	clear_missionTask_01 = {
		open_missionTask_01 = {
			default_missionTask_01 = {},
		},
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
	announce_all_clear = {},

}
this.missionStartPosition = {
		helicopterRouteList = {
			"lz_drp_slopedTownEast_E0000|rt_drp_slopedTownEast_E_0000",
			"lz_drp_fort_I0000|rt_drp_fort_I_0000"
		},
		orderBoxList = {
			"box_s10040_00",
		},
}

this.NPC_ENTRY_POINT_SETTING = {
	[ Fox.StrCode32("lz_drp_slopedTownEast_E0000|rt_drp_slopedTownEast_E_0000") ] = {
		[EntryBuddyType.VEHICLE] = { Vector3(1196.641, 313.488, -10.100), TppMath.DegreeToRadian( 60 ) }, 
		[EntryBuddyType.BUDDY] = { Vector3(1193.896, 313.871, -6.326), TppMath.DegreeToRadian( 60 ) }, 
	},
}

this.missionObjectiveEnum = Tpp.Enum{
	"default_area_fort",
	"marker_area_bridge",
	"marker_honey_bee",
	"marker_hostage",
	"get_photo_honeyBee",
	"marker_about_bridge",
	"default_photo_honeyBee",
	"default_missionTask_00",
	"default_missionTask_01",
	"default_missionTask_02",
	"default_missionTask_03",
	"default_missionTask_04",
	"default_missionTask_05",
	"clear_missionTask_00",
	"clear_missionTask_01",
	"clear_missionTask_02",
	"clear_missionTask_03",
	"clear_missionTask_04",	
	"clear_missionTask_05",	
	"open_missionTask_01",
	"announce_all_clear",
}



this.specialBonus = {
	first = { 
		
		missionTask = { taskNo = 1 },
		pointList = {
			5000,
			10000,
			15000,
			20000,
        },
		
	},
	second = { 
		
		missionTask = { taskNo = 2 },
		pointList = {
			1000,
			1000,
			2000,
			2000,
			3000,
			3000,
			3000,
			5000,
        },
		
	},
}









function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	
	TppMission.RegiserMissionSystemCallback{
		OnSetMissionFinalScore = function()
			
			local count = 0
			count = Player.GetAmmoStockBySlot( 1, 0 )
			if count < 0 then
				count = 0
			elseif count > 8 then
				count = 8
			end
			
			
			if count > 0 then
				
				TppMission.UpdateObjective{	objectives = { "clear_missionTask_03", nil },	}
				
				for i=1, count do
					TppResult.AcquireSpecialBonus{
				        second = {  pointIndex = i },
					}
				end
			end
		end,
		OnEstablishMissionClear = function()
			GkEventTimerManager.Start("Timer_MissionEnd",2)
		end,
		OnEndMissionCredit = function()
			TppScriptBlock.LoadDemoBlock( "Demo_Clear" )
			TppSequence.SetNextSequence("Seq_Demo_HeliClear",{ isExecMissionClear = true } )		
		end,






		OnEndDeliveryWarp = function(stationUniqueId)
			local currentSequence = TppSequence.GetCurrentSequenceName()

			
	        if stationUniqueId == TppPlayer.GetStationUniqueId( "fort" ) and currentSequence == "Seq_Game_MainGame" then
                Fox.Log("Delivery warp at frot")
				s10040_radio.PlayInFort()
	        elseif stationUniqueId == TppPlayer.GetStationUniqueId( "bridge" ) and currentSequence == "Seq_Game_BossBattle" then
	        	this.DeadParasiteSquad(nil)
	        end		
		end,


		OnGameOver = this.OnGameOver
	}

end



function this.OnEndMissionPrepareSequence()
	local nextSequence = TppSequence.GetSequenceIndex( TppSequence.GetMissionStartSequenceName() ) 

	
	if nextSequence == TppSequence.GetSequenceIndex("Seq_Game_BossBattle") then
		this.ChangeWeatherForBoss("battle")
	end

	if nextSequence == TppSequence.GetSequenceIndex("Seq_Game_MainGame") and svars.isGetMissile == true then
		this.ChangeWeatherForBoss("getHoneyBee")
	end
end



this.CheckClearDemoPos = function()
	Fox.Log("check positon clear demo")
	local gameObjectId =  GameObject.GetGameObjectId("TppHeli2","SupportHeli")
	local route = GameObject.SendCommand(gameObjectId, { id="GetUsingRoute" })

	local south = Fox.StrCode32("rt_rtn_fort_S_0000")	
	local west  = Fox.StrCode32("rt_rtn_fort_W_0000")	
	local east  = Fox.StrCode32("rt_rtn_fort_E_0000")	

	if route == west then
		Fox.Log("match : west")
		return DEMO_POS.WEST
	elseif route == east then
		Fox.Log("match : east")
		return DEMO_POS.EAST
	else
		Fox.Log("not match")
		return false
	end

end
function this.OnGameOver()
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.S10040_ARRIVAL_HONEY_BEE ) then

		Fox.Log("check player position")
		if this.CheckDistPlayerToLocator(IDEN_DEMO, DEMO_POS.FORT ) < DIST_GAMEOVER then
			Fox.Log("position is ok. play demo")
			
			s10040_demo.PlayEnemyHeli(func)
	        return true
		else
			Fox.Log("not play demo. because player is far from game over area.")
			TppMission.ShowGameOverMenu{}
		end
	end
end




this.CheckDistPlayerToLocator = function(iden, key)
	
	local position1 = TppPlayer.GetPosition()
	local position2, rotQuat = Tpp.GetLocatorByTransform( iden, key )
	local point2 = TppMath.Vector3toTable( position2 )

	local dist = 0
	dist = TppMath.FindDistance( position1, point2 )
	Fox.Log("player dist = "..dist )

	return dist
end


this.CheckLookHostage = function()
	Fox.Log("CheckLookHostage")
	local check = Player.AddSearchTarget {
	        name = "missionTarget",

	        targetGameObjectTypeIndex = TppGameObject.GAME_OBJECT_TYPE_HOSTAGE_UNIQUE,
	        targetGameObjectName = "hos_s10040_0000",

	        offset = Vector3(0,0.25,0),
	        centerRange = 0.9,
	        distance = 150,

	        doWideCheck = false,
			wideCheckRadius = 0.25,
			wideCheckRange = 0.15,
	        doDirectionCheck = false,
			directionCheckRange = 180,
	        doCollisionCheck = true,
	        checkImmediately = true,

	}
	Fox.Log( tostring(check) )
	return check
end

this.CallGameOver = function()
	TppScriptBlock.LoadDemoBlock( "Demo_EnemyHeli" )
	TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.S10040_ARRIVAL_HONEY_BEE , TppDefine.GAME_OVER_RADIO.S10040_ARRIVAL_HONEY_BEE )

end



this.BGMChangePhaseLevel = function()
	Fox.Log("change BGM. check svars.")

	if svars.eventSequenceNum >= this.EVENT_SEQUENCE.GET_MISSILE or svars.isGetMissile == true then
		Fox.Log("set phase BGM level 2")
		TppSound.SetPhaseBGM( "bgm_cave_level2" )
	else
		Fox.Log("set phase BGM level 1")
		TppSound.SetPhaseBGM( "bgm_cave_level1" )

	end

end





function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	
	this.ChangeWeatherForBoss()

	if svars.isMarkHostage == false	then
		TppMarker.Disable( HOSTAGE_NAME,"",true )
	end

end








function this.Messages()
	return
	StrCode32Table {
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
		GameObject = {
			{
				msg = "Dead", sender = HOSTAGE_NAME,
				func = function(id,attackerId)
					Fox.Log(" hostage is dead")
					if svars.isDeadHostage == false then
						svars.isDeadHostage = true
						s10040_radio.PlayDeadHostage(attackerId)
					end
				end
			},
			{
				
				msg = "LostControl", sender = "EnemyHeli",
				func = function()
					
					Fox.Log("heli is down")
					TppMission.UpdateObjective{	objectives = { 	"clear_missionTask_05", nil }, }	

				end
			},
			{
				
				msg = "Fulton",
				func = function(gameObjectId)
					this.CheckSubTaskSniper(gameObjectId)
				end
			},
			{
				msg = "PlacedIntoVehicle",
				func = function(gameObjectId, s_rideVehicleID)
					if Tpp.IsHelicopter(s_rideVehicleID) then
						this.CheckSubTaskSniper(gameObjectId)
					end
				end
			},
			{
				msg = "RouteEventFaild", sender = {"sol_s10040_0000", "sol_s10040_0001", "sol_s10040_0002"},
				func = function(gameObjectId,routeId,failureType)
					Fox.Log("route event faild "..routeId)
					if failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_PICK_UP_HONEY_BEE then
						Fox.Log("honey bee is gone")
						s10040_enemy.ChangeRouteNotHoneyBee()
					elseif svars.eventSequenceNum < this.EVENT_SEQUENCE.WAIT_FORT  then
						if failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_VEHICLE_GET_IN then
							Fox.Log("can not get in vehicle")						
							s10040_enemy.StartTravelWalk()

						elseif failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_LOST_VEHICLE_HOSTAGE_PUT_IN
						 or failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_LOST_VEHICLE_HOSTAGE_TAKE_OUT_OF then
							Fox.Log("vehicle is gone")						
							s10040_enemy.StartTravelWalk()

						elseif failureType == TppGameObject.ROUTE_EVENT_FAILED_TYPE_LOST_HOSTAGE_TAKE_OUT_OF_VEHICLE then
							
							
							
						end
					end
				end
			},
			
			{
				msg = "ConversationEnd", sender = {"sol_s10040_0000", "sol_s10040_0001", "sol_s10040_0002"},
				func = function(gameObjectId,label,flag)
					Fox.Log("end talk : "..label )
					s10040_enemy.ChangeRouteAiAct(label)
				end
			},
		},
		Trap = {
			{
				msg = "Enter", sender = "trap_demo_area",
				func = function()
					Fox.Log("enter in demo area")
					svars.isDemoArea = true
				end
			},
			{
				msg = "Exit", sender = "trap_demo_area",
				func = function()
					Fox.Log("exit in demo area")
					svars.isDemoArea = false
				end
			},
			{
				msg = "Enter", sender = "trap_demo_area2",
				func = function()
					Fox.Log("enter in demo area")
					svars.isDemoArea2 = true
				end
			},
			{
				msg = "Exit", sender = "trap_demo_area2",
				func = function()
					Fox.Log("exit in demo area")
					svars.isDemoArea2 = false
				end
			},
			{ msg = "Enter",sender = "trap_fort_candle", func = function() Gimmick.EnableCandleWind(true) end },
			{ msg = "Exit", sender = "trap_fort_candle", func = function() Gimmick.EnableCandleWind(false) end },
		},
		Timer = {
			{
				msg = "Finish", sender = "Timer_MissionEnd",
				func = function()
					TppMission.MissionGameEnd{ loadStartOnResult = false }
				end,
				option = { isExecMissionClear = true },
				
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





this.ChangeDemoBlock = function()
	Fox.Log("change demo block. check flag")

	if svars.eventSequenceNum > this.EVENT_SEQUENCE.ROOM2 then		
		Fox.Log("d03")
		TppScriptBlock.LoadDemoBlock( "Demo_EnemyHeli" )
	elseif svars.eventSequenceNum > this.EVENT_SEQUENCE.SERCH1 then		
		Fox.Log("d02")
		TppScriptBlock.LoadDemoBlock( "Demo_FindHoneyBee1" )
	else		
		Fox.Log("d01")
		TppScriptBlock.LoadDemoBlock( "Demo_AttackHostage1" )
	end
end


this.SetDogStopAI = function(enable)
	local gameObjectId = { type="TppBuddyDog2", index=0 }
    local command = { id = "LuaAiStayAndSnarl" }

	if enable == true then
	    local pos1=Vector3(2178.588, 464.519, -1483.900) 
	    local pos2=Vector3(2197.536, 462.589, -1506.360) 
	    command = { id = "LuaAiStayAndSnarl", position=pos1, look=pos2 }
	end

    if GameObject.GetGameObjectIdByIndex( "TppBuddyDog2",0 ) ~= GameObject.NULL_ID then
      GameObject.SendCommand( gameObjectId, command )
    end	
end





this.DeadParasiteSquad = function(radioType)
	Fox.Log("Parasite is dead")
	if svars.bossSequenceNum < this.BOSS_SEQUENCE.DEAD then
		svars.bossSequenceNum = this.BOSS_SEQUENCE.DEAD

		this.ChangeWeatherForBoss()

		GameObject.SendCommand( { type="TppParasite2" }, { id="StartWithdrawal" } ) 

		
		if radioType == "dead" then
			s10040_radio.PlayBossDown()
		else
			svars.isFlag05 = true
		end
		s10040_sound.BGMParasitesEnd()

		TppSequence.SetNextSequence("Seq_Game_Escape")
	else
	end
end



this.ChangeWeatherForBoss = function(enable)
	Fox.Log("this.ChangeWeatherForBoss")
	
	
	if enable == "battle" then
		Fox.Log("FOG start")
		TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 0.01,{ fogDensity=0.15,fogType=WeatherManager.FOG_TYPE_EERIE } ) 
	elseif enable == "beforeDemo" then	
		Fox.Log("FOG before demo")
		TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 4,{ fogDensity=5, fogType=WeatherManager.FOG_TYPE_EERIE, } )
	elseif enable == "getHoneyBee" then	
		Fox.Log("FOG after get honey bee")
		TppWeather.ForceRequestWeather( TppDefine.WEATHER.FOGGY, 9,{ fogDensity=0.005, fogType=WeatherManager.FOG_TYPE_EERIE, } )
	else
		Fox.Log("FOG stop")
		TppWeather.CancelForceRequestWeather()
	end

end



this.CheckGetHoneyBee = function()
	Fox.Log("check Player have a Honey Bee.")
	if vars.weapons[TppDefine.WEAPONSLOT.PRIMARY_BACK] == HONEY_BEE_ID then
		return true
	else
		return false
	end

end


this.GetInfoOfHostage = function()
	Fox.Log("Get hostage in cliffTown.")
	svars.rescueHostageNum = svars.rescueHostageNum + 1

	if svars.rescueHostageNum == 1 then
		Fox.Log("get infromation ...about")
		s10040_radio.PlayInfoHostage1()
		TppMission.UpdateObjective{
			objectives = { "marker_about_bridge", nil },
		}
	elseif svars.rescueHostageNum == 2 then
		Fox.Log("get information of ROA hostage")
		svars.isGetInfoHostage = true
		s10040_radio.UnregisterORadioAboutHostage()
		s10040_radio.PlayInfoHostage2()
		TppMission.UpdateObjective{
			objectives = { "marker_area_bridge", nil },
		}
	elseif svars.rescueHostageNum == 3 then
		Fox.Log("no infomation")
		s10040_radio.PlayInfoHostage3()
	else
		Fox.Error("hostage count error"..count)
	end

end

this.GetMissile = function(player,id)
	Fox.Log("get weapon. check id this is "..id..". Honey bee is "..HONEY_BEE_ID )
	if id == HONEY_BEE_ID then
		Fox.Log("get hoeny bee")
		return true
	else
		Fox.Log("not hoey bee")
		return false
	end
end

this.GetInformation = function(radioId)
	Fox.Log("Fulton ROUA hostage")
	svars.isGetInfoHoneyBee = true
	s10040_radio.ORadioSet30()
	s10040_radio.InsertORadioAboutHostage()
end






this.StartDrive = function()
	Fox.Log("start take, finish demo")
	Fox.Log("check svars. "..svars.eventSequenceNum.." : "..this.EVENT_SEQUENCE.DRIVE )
	if svars.eventSequenceNum < this.EVENT_SEQUENCE.DRIVE then
		svars.eventSequenceNum = this.EVENT_SEQUENCE.DRIVE

		
		s10040_enemy.PutHostageOnVehicle()
		if svars.isMarkHostage and svars.isFlag03 == true 
	 	and svars.isDeadHostage == false 
	 	and svars.isGetInfoHoneyBee == false 
	 	and this.CheckLookHostage() == true then
			s10040_radio.PlayRideOnVehicle()
		end
	end
end



this.ChangeRouteEndTalk = function()
	Fox.Log("ChangeRouteEndTalk")
	if svars.eventSequenceNum > this.EVENT_SEQUENCE.TAKE3 then
		
		Fox.Log("TAKE3")
		s10040_enemy.SerchRoomNoDemo()
	elseif svars.eventSequenceNum >= this.EVENT_SEQUENCE.SERCH2 then
		
		Fox.Log("SERCH2")
		s10040_enemy.EndFind2()
	elseif svars.eventSequenceNum >= this.EVENT_SEQUENCE.SERCH1 then
		
		Fox.Log("SERCH1")
		s10040_enemy.EndFind1()
	elseif svars.eventSequenceNum >= this.EVENT_SEQUENCE.ATTACK0 then
		
		
		Fox.Log("Start take")
		if s10040_enemy.ChangeRouteSetsTake() then 
			if svars.isGetMissile == false 
			and this.CheckLookHostage() == true then
				s10040_radio.PlayHostageTakeStart()
			else
				GkEventTimerManager.Start( "Timer_RadioStartTake", 2 )
			end
		end
	end
end


this.CheckRescueDemo = function()
	Fox.Log("check resuce demo function")
	if svars.isDemoArea == false and svars.isDemoArea2 == false then
		Fox.Log("not in demo area")
		return false
	end

	
	if Tpp.IsNotAlert() == false then
		Fox.Log("phase is no")
		return false
	end

	
	if svars.isGetInfoHoneyBee == true then
		return false
	end

	
	if svars.isFlag04 == true then
		return false
	end
	
	return true
end









this.ChangeRouteTake = function(objectId,message)
	Fox.Log("ChangeRouteTake : "..message )
	local currentSequence = TppSequence.GetCurrentSequenceName()

	
	
	if ( message == StrCode32(MESSAGE_ROUTE.LRRP1)  ) then
		s10040_enemy.SetCpTakeEnemy("afgh_33_37_lrrp")
		return
	elseif( message == StrCode32(MESSAGE_ROUTE.OB1)  ) then
		s10040_enemy.SetCpTakeEnemy("afgh_bridgeNorth_ob")
		return
	elseif( message == StrCode32(MESSAGE_ROUTE.LRRP2)  ) then
		s10040_enemy.SetCpTakeEnemy("afgh_12_37_lrrp")
		return
	elseif( message == StrCode32(MESSAGE_ROUTE.OB2)  ) then
		s10040_enemy.SetCpTakeEnemy("afgh_fortSouth_ob")
		return
	elseif( message == StrCode32(MESSAGE_ROUTE.LRRP3)  ) then
		s10040_enemy.SetCpTakeEnemy("afgh_12_31_lrrp")
		return
	end

	
	if( message == StrCode32(MESSAGE_ROUTE.HELI)  )then
		Fox.Log("Game Over Check from Heli")
		if s10040_enemy.CheckEnemyPoint() then
			Fox.Log("check OK")
			this.CallGameOver()
		else
			Fox.Log("check NG")
		end

		return

	elseif( message == StrCode32(MESSAGE_ROUTE.HB)  )then
		Fox.Log("Game Over Check from Enemy")		
		if s10040_enemy.CheckEnemyHeliPoint(objectId) then
			Fox.Log("check OK ")
			this.CallGameOver()
		else
			Fox.Log("check NG")
		end

		return

	end

	
	if( message == StrCode32(MESSAGE_ROUTE.WAIT1)  )then
		Fox.Log("wait a hostage")
		if svars.isDeadHostage == true then
			s10040_enemy.EnemyRideOnVehicle()
		end
	end
	
	if( message == StrCode32(MESSAGE_ROUTE.GET)  )then
		Fox.Log("Get HoneyBee. change return route for demo")
		TppEnemy.SetSneakRoute( objectId, 	"rts_GetHoneyBee_1003", 0 )
		TppEnemy.SetCautionRoute( objectId, 	"rts_GetHoneyBee_1003", 0 )
	end

	
	if( message == StrCode32(MESSAGE_ROUTE.HURRY)  )then
		Fox.Log("back to heli. hurry up radio.") 
		s10040_radio.PlayEnemyNearHeli()
		return
	end

	
	if ( message == StrCode32(MESSAGE_ROUTE.FORT)  ) then
		if svars.isGetInfoHoneyBee == true or svars.isDeadHostage == true then
			Fox.Log("enemy arrive in fort without hostage. go to hoken route")
			s10040_enemy.SetCpTakeEnemy("afgh_fort_cp")
			s10040_enemy.RouteSetForSerch(s10040_enemy.TakeRoute.Hoken)
			return
		end
	end
	
	
	if svars.isGetInfoHoneyBee then
		Fox.Log("not route change. because ROA was resuced")
		if 	svars.eventSequenceNum <= this.EVENT_SEQUENCE.DRIVE then
			s10040_enemy.StartTravelDrive()
		else
			s10040_enemy.RouteSetForSerch(s10040_enemy.TakeRoute.Hoken)
		end
		return
	end

	if ( message == StrCode32(MESSAGE_ROUTE.FORT)  ) then
		Fox.Log("arrival at fort. go to wait route")
		s10040_enemy.SetCpTakeEnemy("afgh_fort_cp")
		
		
		if svars.eventSequenceNum == this.EVENT_SEQUENCE.PRE_WAIT then
			svars.eventSequenceNum = this.EVENT_SEQUENCE.ATTACK0
			s10040_enemy.WaitFort()
			this.ChangeRouteEndTalk()
			
		
		elseif svars.eventSequenceNum <= this.EVENT_SEQUENCE.WAIT_FORT then
			svars.eventSequenceNum = this.EVENT_SEQUENCE.WAIT_FORT
			s10040_enemy.WaitFort()
		else
			Fox.Log("sequence is over")
		end

	elseif( message == StrCode32(MESSAGE_ROUTE.SERCH1)  )then
		Fox.Log("arrival at find point 1.start find")
		svars.eventSequenceNum = this.EVENT_SEQUENCE.SERCH1
		s10040_enemy.StartSerch1()
		GkEventTimerManager.Start("Timer_Serch1", TIME_SERCH1)

	elseif( message == StrCode32(MESSAGE_ROUTE.ROOM1) )then
		Fox.Log("time up. to sech attack1")
		s10040_enemy.SerchAttack1()

	elseif (message == StrCode32(MESSAGE_ROUTE.ATTACK1) ) then
		Fox.Log("arrival at find point 2.start find")
		if 	svars.eventSequenceNum < this.EVENT_SEQUENCE.ATTACK1 then
			svars.eventSequenceNum = this.EVENT_SEQUENCE.ATTACK1
			s10040_enemy.ChangeRouteAiAct()
		end

	elseif( message == StrCode32(MESSAGE_ROUTE.SERCH2)  )then
		Fox.Log("arrival at find point 2.start find")
		svars.eventSequenceNum = this.EVENT_SEQUENCE.SERCH2
		this.ChangeDemoBlock()
		s10040_enemy.StartSerch2()
		GkEventTimerManager.Start("Timer_Serch2", TIME_SERCH2)

	elseif( message == StrCode32(MESSAGE_ROUTE.ROOM2) )then
		Fox.Log("time up. to sech attack2 route")
		s10040_enemy.SerchAttack2()

	elseif (message == StrCode32(MESSAGE_ROUTE.ATTACK2) ) then
		Fox.Log("arrival at find point 2.start find")
		if svars.eventSequenceNum < this.EVENT_SEQUENCE.ATTACK2 then
			svars.eventSequenceNum = this.EVENT_SEQUENCE.ATTACK2
			s10040_enemy.ChangeRouteAiAct()
		end
	elseif( message == StrCode32(MESSAGE_ROUTE.ROOM)  )then
		Fox.Log("arrival at room. wait for demo")
		this.ChangeDemoBlock()
		s10040_enemy.WaitRoom()

	elseif( message == StrCode32(MESSAGE_ROUTE.DEMO1)  )then
		Fox.Log("set. go to demo 1")

		if Tpp.IsNotAlert() then
			Fox.Log("alert check is ok")
		else
			Fox.Log("alert. no play demo. change route")
			svars.eventSequenceNum = this.EVENT_SEQUENCE.ROOM1 
			s10040_enemy.SerchRoom()	
			
			return false
		end

		
		Fox.Log("svars = "..svars.eventSequenceNum..", eventId = "..this.EVENT_SEQUENCE.ROOM1 )
		if svars.eventSequenceNum < this.EVENT_SEQUENCE.ROOM1 then 
			svars.eventSequenceNum = this.EVENT_SEQUENCE.ROOM1 

			
			if s10040_enemy.CheckConditionRoomDemo() then

				s10040_enemy.SerchRoomWait() 
				local func = function()	
		
					s10040_enemy.SerchRoom() 
				
				end
				GkEventTimerManager.Start("Timer_Knee", 2)


				s10040_demo.PlayFindHoneyBee1(func)
			else
				Fox.Log("condition is bad. not play demo, do AI route")
				s10040_enemy.ChangeRouteAiAct()
			end
		else
			Fox.Log("svars is wrong")
		end

	elseif( message == StrCode32(MESSAGE_ROUTE.DEMO2)  )then
		Fox.Log("set. go to demo 2")

		if Tpp.IsNotAlert() then
			Fox.Log("alert check is ok")
		else
			Fox.Log("alert.no play demo. route change")
			svars.eventSequenceNum = this.EVENT_SEQUENCE.GET_MISSILE
			
			return false
		end

		if svars.eventSequenceNum < this.EVENT_SEQUENCE.GET_MISSILE then
			svars.eventSequenceNum = this.EVENT_SEQUENCE.GET_MISSILE
			Fox.Log("get honey bee.")

			this.BGMChangePhaseLevel()

			local func = function() 
				this.ChangeDemoBlock()
				if this.CheckDistPlayerToLocator("s10040_Identifier","locator_honey_bee") < 100 * 100 then
					s10040_radio.PlayEnemyFoundHoneyBee()
				end
				svars.numFlag00 = 1
				GkEventTimerManager.Start("Timer_CountBackToHeli",TIME_COUNT_HELI)
			end

			local enemyDeadFlag, enemyDeadCount = s10040_enemy.CheckEnemyAllDead()
			if enemyDeadCount > 0 then
				Fox.Log("no demo. becouse enemy not enogh")
				s10040_enemy.ExecuteHostage()
				s10040_enemy.BackToHeliWait()
			else
				Fox.Log("play demo.")
				s10040_enemy.BackToHeliWait()
				s10040_demo.PlayFindHoneyBee2(func)
			end
		end
		
	
	elseif( message == StrCode32(MESSAGE_ROUTE.PUT)  )then
		s10040_enemy.StartTravelDrive()
	else
		Fox.Log("unknow message!")
	end

	
	if currentSequence == "Seq_Game_Escape" and svars.eventSequenceNum >= this.EVENT_SEQUENCE.WAIT_FORT then
		
		Fox.Log("go to hoken route. because escape sequence")
		s10040_enemy.RouteSetForSerch(s10040_enemy.TakeRoute.Hoken)
		s10040_enemy.ChangeRouteHostage()
		return
	end

end

this.CheckSubTaskSniper = function(gameObjectId)
	local isSniper = TppEnemy.IsSniper( gameObjectId )
	local isInBridge = s10040_enemy.CheckCpFromEnemy( gameObjectId )
	Fox.Log("isSniper = "..tostring(isSniper) )
	Fox.Log("isInBridge = "..tostring(isInBridge) )
	if ( isSniper == true ) and ( isInBridge == true ) then
		svars.sinperNum = svars.sinperNum + 1						
		Fox.Log("get sniper. "..tostring(svars.sinperNum) )
		
		if svars.sinperNum >= NUM_SNIPER then
			Fox.Log("Get sniper soldier. sub task update")
	        TppMission.UpdateObjective{	objectives = { 	"clear_missionTask_04", nil }, }
	    end
	end
end



sequences.Seq_Game_MainGame = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{ 
					msg = "ChangePhase",	 	sender = "afgh_bridge_cp",
					func = function(cpId, phase, beforePhase)
						
						
						if ( svars.eventSequenceNum <= this.EVENT_SEQUENCE.DRIVE ) then
							if ( phase >= TppGameObject.PHASE_CAUTION ) then
								Fox.Log("set SetRestrictNotice")
								local flag = true
								GameObject.SendCommand( GameObject.GetGameObjectId( "sol_s10040_0000" ),	{ id = "SetRestrictNotice", enabled = flag }  ) 
								GameObject.SendCommand( GameObject.GetGameObjectId( "sol_s10040_0001" ),	{ id = "SetRestrictNotice", enabled = flag }  ) 
								GameObject.SendCommand( GameObject.GetGameObjectId( "sol_s10040_0002" ),	{ id = "SetRestrictNotice", enabled = flag }  ) 
							end 
						end
					end 
				},
				{
					msg = "Fulton", sender = HOSTAGE_NAME,
					func = function()
						GkEventTimerManager.Start("Timer_GetHostage",6)
					end
				},
				{
					msg = "PlacedIntoVehicle",sender = HOSTAGE_NAME,
					func = function (s_characterId, s_rideVehicleID)
						if Tpp.IsHelicopter(s_rideVehicleID) then
							GkEventTimerManager.Start("Timer_GetHostage",10)
						
						end
					end
				},
				{
					msg = "Carried", sender = HOSTAGE_NAME,
					func = function( gameObjectId, flag )
						Fox.Log("msg carried")
						if flag == 0 and TppEnemy.GetLifeStatus( HOSTAGE_NAME ) ~= TppEnemy.LIFE_STATUS.DEAD and svars.isGetInfoHoneyBee == false then 
							svars.isFlag04 = true
							s10040_radio.PlayToDoFulton()
						end
					end
				},
				{	
					msg = "RoutePoint2", sender = {"sol_s10040_0000","sol_s10040_0001","sol_s10040_0002"},
					func = function(objectId,routeId,routeNode,message)
						Fox.Log("get message RoutePoint2 : "..message )
						this.ChangeRouteTake(objectId,message)
					end
				},
				{	
					msg = "RoutePoint2", sender = HOSTAGE_NAME,
					func = function(objectId,routeId,routeNode,message)
						Fox.Log("get message RoutePoint2 hostage: "..message )
						if ( message == StrCode32(MESSAGE_ROUTE.HOSTAGE)  ) then
							s10040_enemy.ChangeRouteHostage()
							
						
						elseif ( message == StrCode32(MESSAGE_ROUTE.ROOM)  )then
							Fox.Log("set stand stance. hostage")
							local gameObjectId = GameObject.GetGameObjectId( "hos_s10040_0000" )
							GameObject.SendCommand( gameObjectId, {
								id="SpecialAction",
								action="PlayStance",
								stance="Stand"
							} )		
						end
						
					end
				},

				{
					msg = "StartedCombat", sender = "EnemyHeli",
					func = function()
						Fox.Log("started combat heli")
						
					end
				},
				nil
			},
			Player = {
				{
					msg = "PressedFultonIcon",
					func = function(player, targetId)
						self.UnlokedHostage(targetId)
					end
				},
				{
					msg = "PressedCarryIcon",
					func = function(player, targetId)
						self.UnlokedHostage(targetId)
					end
				},
				{ 
					msg = "OnPickUpWeapon",
					func = function(player,id)
						if this.GetMissile(player,id) then
							s10040_radio.PlayGetHoneyBee()
							svars.isGetMissile = true
							TppMarker.Disable( "marker_honey_bee" )
							TppSound.PostJingleOnCanMissionClear()
							this.BGMChangePhaseLevel()
							this.ChangeWeatherForBoss("getHoneyBee")

							
							TppMission.UpdateObjective{	objectives = { "clear_missionTask_00", nil },	}	
							TppMission.UpdateObjective{	objectives = { "default_missionTask_01", nil },	}	
							TppMission.UpdateObjective{ objectives = { "get_photo_honeyBee", nil }, }	

							
							s10040_enemy.EnemyHeliHideRoute()

							
							TppScriptBlock.LoadDemoBlock( "Demo_SkullFace" )

							TppMission.UpdateCheckPoint{ 
								checkPoint ="CHK_honeyBee",
								ignoreAlert = true 
							}
						else
							Fox.Log("not do.no honey bee")
						end
					end
				},

			},
			Trap = {
				{
					msg = "Enter", sender = "trap_radio_fort",
					func = function()
						s10040_radio.PlayInFort()
					end
				},
				{
					msg = "Enter", sender = "trap_bgm_cave",
					func = function() this.BGMChangePhaseLevel() end
				},
				{
					msg = "Exit", sender = "trap_bgm_cave",
					func = function() s10040_sound.BGMPhaseReset() end
				},
				{
					msg = "Enter", sender = "trap_demo_bridge",
					func = self.StartAttackDemo
				},
				{
					msg = "Enter", sender = "trap_radio_bridge",
					func = function()
						s10040_radio.PlayInBridge()
					end
				},

				{
					msg = "Enter", sender = "trap_start_take",
					func = function()
						
						if svars.eventSequenceNum < this.EVENT_SEQUENCE.WAIT_FORT then
							Fox.Log("skip talk. go next route")
							svars.eventSequenceNum = this.EVENT_SEQUENCE.PRE_WAIT
						
						elseif svars.eventSequenceNum == this.EVENT_SEQUENCE.WAIT_FORT then
							Fox.Log("go next route")
							svars.eventSequenceNum = this.EVENT_SEQUENCE.ATTACK0
							this.ChangeRouteEndTalk()
						else
							Fox.Log("event sequence is over")
						end
					end
				},
				{
					msg = "Enter", sender = "trap_radio_room",
					func = function() 
						
						if (svars.isGetMissile == true ) or ( svars.eventSequenceNum >= this.EVENT_SEQUENCE.TAKE3 ) then
							Fox.Log("not play radio. because found missile")
						else
							s10040_radio.PlayHintOfRoom()
						end
					end
				},
				{
					msg = "Enter", sender = "trap_radio_taking",
					func = function()
						if s10040_enemy.CheckHostageInRoom1() 
						and this.CheckLookHostage() == true and svars.isGetMissile == false then
							s10040_radio.PlayGoToRescueHostage()
						else
							GkEventTimerManager.Start( "Timer_RadioRescueHostage", 2)
						end
					end
				},
				{
					msg = "Enter", sender = "trap_radio_cliffTown",
					func = function()
						s10040_radio.PlayInCliffTown()
					end
				},

				{
					msg = "Enter", sender = "trap_start_boss",
					func = function()
						Fox.Log("in trap. trap_start_boss")
						if this.CheckGetHoneyBee() then
							
							TppScriptBlock.LoadDemoBlock( "Demo_SkullFace" )
							this.ChangeWeatherForBoss("beforeDemo")
							TppEffectWeatherParameterMediator.StartAdditionalFogNearDistanceEnvelope( -4, 4.0, 12.0, 4.0 )
							GkEventTimerManager.Start("Timer_beforeDemo",2+1)							
							GkEventTimerManager.Start("Timer_GoToSkullDemo", 1)
							Player.RequestToSetCameraFocalLengthAndDistance {
						        distance = 6, 
						        interpTime = 4 
							}
							Player.RequestToSetCameraRotation({rotX = 20, rotY = 0, interpTime = 3 })
							Player.RequestToSetTargetStance(PlayerStance.STAND) 
							Player.SetPadMask {
							        
							        settingName = "NoMove",    
							        
							        except = false,                                 
							        
							        buttons = PlayerPad.ALL,
							        
							        sticks = PlayerPad.STICK_L,     
							        
							        triggers = PlayerPad.TRIGGER_L, 
							}
							
						end
					end
				},
				{
					msg = "Enter", sender = "trap_boss_sneek",
					func = function() 
						if this.CheckGetHoneyBee() then
							Fox.Log("start boss effect")
							s10040_sound.BGMParasitesOP()

						end
					end
				},
				{
					msg = "Enter", sender = "trap_CHK_fort_10040",
					func = function( trap, player )
						Fox.Log( "TppCheckPoint trap on enter" )
						if svars.isFlag00 == false then
							svars.isFlag00 = true
							TppMission.UpdateCheckPoint{ 
								checkPoint ="CHK_fort_enter",
								ignoreAlert = false
							}
						end
					end
				},
				{
					msg = "Enter", sender = "trap_demo_honeyBee",
					func = function()
						if svars.isFlag02 == false 
						and svars.eventSequenceNum < this.EVENT_SEQUENCE.GET_MISSILE then
							svars.isFlag02 = true
							
							local demoBlockName = TppScriptBlock.GetCurrentPackListName( "demo_block" )
							
							if demoBlockName == "Demo_FindHoneyBee1" and s10040_demo.CheckIsPlayHostageAttack() == false and Tpp.IsNotAlert() then 
								local endFunc = function()
									TppBuddyService.SetIgnoreDisableNpc( false )
									s10040_radio.PlayFindRoom()
								end
								TppBuddyService.SetIgnoreDisableNpc( true )
								s10040_demo.PlayYuruConCamera2(endFunc)
							else	
								Fox.Log("can not play demo. use command camera")
								s10040_radio.PlayFindRoom()
								Player.StartTargetConstrainCamera {
							        cameraType = PlayerCamera.Around,
							        force = true,
							        fixed = true,
							        recoverPreOrientation = false,
							        dataIdentifierName = "s10040_Identifier",
							        keyName = "locator_honey_bee",
							        interpTime = 0.6,
							        interpTimeToRecover = 0.2,
							        areaSize = 1.0,
							        time = 2,
							        cameraOffset = Vector3(0.4, 0.0, 0.4),
							        cameraOffsetInterpTime = 0.2,
							        targetOffset = Vector3(0.0,0.0,0.0),
							        targetOffsetInterpTime = 0.3,

							        minDistance = 0.1,
							        maxDistanve = 10.0,
								}
							end
						end
					end
				},
				{
					msg = "Enter", sender = "trap_checkInBridge",
					func = function() 
						Fox.Log("trap_checkInBridge enter") 
						svars.isFlag03 = true
					end
				},
				{
					msg = "Exit", sender = "trap_checkInBridge",
					func = function() 
						Fox.Log("trap_checkInBridge exit") 
						svars.isFlag03 = false
					end
				},
			},
			Marker = {
				{ 
					msg = "ChangeToEnable", sender = HOSTAGE_NAME, 
					func = self.FoundHostagePlayRadio,
				},	
				nil
			},
			Timer = {
				{
					msg = "Finish", sender = "Timer_Stand",
					func = function()
						Fox.Log("set knee stance. hostage")
						local gameObjectId = GameObject.GetGameObjectId( "hos_s10040_0000" )
						GameObject.SendCommand( gameObjectId, {
								id="SpecialAction",
								action="PlayStance",
								stance="Stand"
						} )		
					end
				},
				{
					msg = "Finish", sender = "Timer_Knee",
					func = function()
						Fox.Log("set knee stance. hostage")
						local gameObjectId = GameObject.GetGameObjectId( "hos_s10040_0000" )
						GameObject.SendCommand( gameObjectId, {
								id="SpecialAction",
								action="PlayStance",
								stance="Knee"
						} )		
					end
				},
				{
					msg = "Finish", sender = "Timer_RadioRescueHostage",
					func = function()
						if s10040_enemy.CheckHostageInRoom1() 
						and this.CheckLookHostage() == true then
							s10040_radio.PlayGoToRescueHostage()
						end
					end				
				},
				{
					msg = "Finish", sender = "Timer_RadioStartTake",
					func = function()
						if svars.isGetMissile == false 
						and this.CheckLookHostage() == true then
							s10040_radio.PlayHostageTakeStart()
						end
					end	
				},

				{
					msg = "Finish", sender = "Timer_GoToSkullDemo",
					func = function()
						TppSoundDaemon.PostEvent( 'sfx_s_whiteout_eerrie' ) 
					end
				},
				{
					msg = "Finish", sender = "Timer_GetHostage",
					func = self.FultonHostage
				},
				{
					msg = "Finish", sender = "Timer_Serch1",
					func = function()
						Fox.Log("message : Timer_Serch1")
						this.ChangeRouteTake( nil,StrCode32(MESSAGE_ROUTE.ROOM1) )
					end
				},
				{
					msg = "Finish", sender = "Timer_Serch2",
					func = function()
						Fox.Log("message : Timer_Serch2")
						this.ChangeRouteTake( nil,StrCode32(MESSAGE_ROUTE.ROOM2) )
					end
				},
				{
					msg = "Finish", sender = "Timer_beforeDemo",
					func = function()
						Player.ResetPadMask {
    					    settingName = "NoMove"
						}
						TppUiCommand.RemovedAllUserMarker()
						TppSequence.SetNextSequence("Seq_Demo_SkullFace") 
					end
				},
				{
					msg = "Finish", sender = "Timer_GoToFort",
					func = function()
						this.StartDrive()
					end
				},
				{
					msg = "Finish", sender = "Timer_CountBackToHeli",
					func = function()
						
						
						
						if s10040_enemy.CheckEnemyAllDead() == true or svars.isGetMissile == true then
							return
						end
						
						svars.numFlag00 = svars.numFlag00 + 1
						
						if svars.numFlag00 == 18 then
							
							s10040_radio.PlayEnemyNearHeli()
						end
						
						if svars.numFlag00 > 24 + 1 then 
							this.CallGameOver()
						else
							GkEventTimerManager.Stop("Timer_CountBackToHeli")
							GkEventTimerManager.Start("Timer_CountBackToHeli",TIME_COUNT_HELI)
						end
					end
				}

			},
			Demo = {
				{
					msg = "p31_020025_003_prsDead",
					func = function()
						s10040_enemy.DieHostage()
					end
				
				}
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(1870.4761, 481.7555, -878.9668))
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		Fox.Log("mission start")
		TppTelop.StartCastTelop()

		
		Gimmick.ResetGimmick( TppGameObject.GAME_OBJECT_TYPE_IMPORTANT_BREAKABLE, ROOM_BOX, GIMMICK_PATH )

		TppRadio.EnableCommonOptionalRadio(true)
		
		if svars.numFlag00 > 0 then
			GkEventTimerManager.Stop("Timer_CountBackToHeli")
			GkEventTimerManager.Start("Timer_CountBackToHeli",TIME_COUNT_HELI)
		end
		if svars.numFlag00 > 12 then
			svars.numFlag00 = 12
		end

		if TppSequence.GetContinueCount() == 0 and svars.isGetMissile == false then
			s10040_radio.ORadioSet01()
		end
		
		this.ChangeDemoBlock()
		
		TppMission.UpdateObjective{
			objectives = { 
				"default_missionTask_00", 
				"default_missionTask_01", 
				"default_missionTask_02", 
				"default_missionTask_03", 
				"default_missionTask_04", 
				"default_missionTask_05", 
				"default_photo_honeyBee",
				nil
			},
		}	

		
		s10040_radio.PlayMissionStart()


		if svars.eventSequenceNum > this.EVENT_SEQUENCE.DRIVE then 
			Fox.Log("set cp fort. becuse event seqence over drive sequence")
			s10040_enemy.SetCpTakeEnemy("afgh_fort_cp")
		end

		
		if svars.eventSequenceNum > this.EVENT_SEQUENCE.DRIVE then
			this.StartDrive()
		end

		
		if svars.eventSequenceNum < this.EVENT_SEQUENCE.BACK_HELI then
			s10040_enemy.EnemyHeliAround()
		end
	
		if DEBUG then
			
			if svars.isDebugCheck == 100 then
				this.CallGameOver()
			end

			
			if svars.isDebugCheck == 70 then	
				Fox.Log("debug put Honey Bee")
				TppPickable.DEBUG_DropWeapon( TppEquip.EQP_WP_HoneyBee ) 
				s10040_sound.BGMParasitesOP()
			end
		end

	end,



	
	StartAttackDemo =function()

		if svars.eventSequenceNum < this.EVENT_SEQUENCE.ATTACK then
			svars.eventSequenceNum = this.EVENT_SEQUENCE.ATTACK
			
			
			local enemyDeadFlag, enemyDeadCount = s10040_enemy.CheckEnemyAllDead()

			if Tpp.IsNotAlert() and enemyDeadCount == 0 then
				local func = function() 
					local time = TIME_GO_FORT
					
					if svars.isDeadHostage == true then
						time = 1
					end

					local gameObjectId = GameObject.GetGameObjectId( "hos_s10040_0000" )
					GameObject.SendCommand( gameObjectId, {
							id="SpecialAction",
							action="",
					} )	

					GkEventTimerManager.Start("Timer_GoToFort", time)
				end

				GkEventTimerManager.Start("Timer_Stand", 2)
				s10040_demo.PlayAttackHostage(func)
			else
				Fox.Log("not play demo. alert")
				this.StartDrive()
			end
		end
	end,

	FoundHostagePlayRadio = function( instanceName, makerType, s_gameObjectId, identificationCode)
		Fox.Log("Fond Target")
		if identificationCode == Fox.StrCode32("Player") then
			svars.isMarkHostage = true
			TppMission.UpdateObjective{ objectives = { "marker_hostage", nil }, }

			if svars.eventSequenceNum < this.EVENT_SEQUENCE.DRIVE and (svars.isGetInfoHoneyBee == false) then
				Fox.Log("play before take")
				s10040_radio.PlayFoundHostage()
			elseif svars.eventSequenceNum >= this.EVENT_SEQUENCE.DRIVE and (svars.isGetInfoHoneyBee == false) then
				Fox.Log("play after take")
				s10040_radio.PlayFoundHostageTaking()
			end
		else
			Fox.Log("marking by buddy")
		end

	end,

	UnlokedHostage = function( gameObjectId )
		Fox.Log("Rescue ROUA hostage")
		
		
		if this.CheckRescueDemo() 
		 and (gameObjectId == GameObject.GetGameObjectId( HOSTAGE_NAME ) ) 
		 and svars.isDeadHostage == false then
			this.GetInformation()

			local func = function() 
				s10040_radio.PlayAfterRescue() 
				local gameObjectId = GameObject.GetGameObjectId( HOSTAGE_NAME )
				local command = { id="SetHostage2Flag", flag="unlocked", on=true }
				GameObject.SendCommand( gameObjectId, command )
				
				
				if svars.eventSequenceNum <= this.EVENT_SEQUENCE.DRIVE then
					Fox.Log("go to fort. enemys lost hostage. before drive")
					s10040_enemy.EnemyRideOnVehicle()
				else
					
					Fox.Log("go to hoken route. play demo in fort")
					s10040_enemy.RouteSetForSerch(s10040_enemy.TakeRoute.Hoken)
				end
			end
			local startFunc = function()
				local gameObjectId = GameObject.GetGameObjectId( HOSTAGE_NAME )
				local command = { id="SetHostage2Flag", flag="unlocked", on=true }
				GameObject.SendCommand( gameObjectId, command )
			end
			s10040_demo.PlayRescueHostage(func,IDEN_DEMO,DEMO_POS.HOS,startFunc)
		else
			Fox.Log("not demo location")
		end
	end,

	FultonHostage = function(gameObjectId)
		if svars.isGetInfoHoneyBee then
			Fox.Log("all redy get infomation for honey bee")
		else
			s10040_radio.PlayFultonHost()
			this.GetInformation()
		end

		
		TppMission.UpdateObjective{	objectives = { "clear_missionTask_02", nil },	}

	end,
}

sequences.Seq_Demo_SkullFace = {

	OnEnter = function()
		
		local EndFunc = function()
			this.ChangeWeatherForBoss("battle")
			TppSequence.SetNextSequence("Seq_Demo_SkullFace2")
		end

		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
		GameObject.SendCommand( gameObjectId, { id="ChangeToIdleState" } )

		local gameObjectId =  GameObject.GetGameObjectId("EnemyHeli")
		GameObject.SendCommand(gameObjectId, { id="Unrealize" })

		svars.bossSequenceNum = this.BOSS_SEQUENCE.DEMO

		s10040_demo.PlaySkullFace(EndFunc)
	end,

}
sequences.Seq_Demo_SkullFace2 = {
	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "svs_zombi_01",
					func = function()
						Fox.Log("get message form demo. chagne enemy to zombie")
						
						local gameObjectId = GameObject.GetGameObjectId("TppSoldier2","sol_fort_0000")
						local command = { id = "SetZombie", enabled=true, isZombieSkin=true }
						GameObject.SendCommand( gameObjectId, command )
					end,
					option = { isExecDemoPlaying  = true }
				},
			},
			nil
		}
	end,
	OnEnter = function()
		Fox.Log("load demoblock skull2")
		TppScriptBlock.LoadDemoBlock( "Demo_SkullFace2" )
		local EndFunc = function()
			this.ChangeWeatherForBoss(false)
			TppSequence.SetNextSequence("Seq_Game_BossBattle")
		end

		s10040_enemy.DisableHostageAndEnemy()
		
		local enemyId = "sol_fort_0000"
		TppEnemy.SetDisable( enemyId )
		TppEnemy.SetEnable( enemyId )

		svars.bossSequenceNum = this.BOSS_SEQUENCE.DEMO
		
		TppWeather.RequestWeather( TppDefine.WEATHER.FOGGY, 1,{ fogDensity=0.15, fogType=WeatherManager.FOG_TYPE_EERIE } )
		s10040_demo.PlaySkullFace2(EndFunc)

	end,

	OnLeave = function()
		TppMission.UpdateCheckPoint{ 
			checkPoint ="CHK_boss",
			ignoreAlert = true 
		}
	end
}

sequences.Seq_Game_BossBattle = {
	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{
					msg = "Dying",
					func = self.CountDyingParaUnit
				},
				{
					msg = "Damage", 
					func = function ( gameObjectId, attackId )
						if s10040_enemy.CheckParasiteMessage(gameObjectId) == true then
							Fox.Log("check attack id")
							if attackId == TppDamage.ATK_80002 or
							attackId == TppDamage.ATK_80004 or
							 attackId == TppDamage.ATK_80006 or
							 attackId == TppDamage.ATK_80103 or
							 attackId == TppDamage.ATK_80104 or
							 attackId == TppDamage.ATK_80116 or
							 attackId == TppDamage.ATK_80124 or
							 attackId == TppDamage.ATK_80125 or
							 attackId == TppDamage.ATK_80203 or
							 attackId == TppDamage.ATK_80204 or
							 attackId == TppDamage.ATK_80205 or
							 attackId == TppDamage.ATK_80206 or
							 attackId == TppDamage.ATK_80303 or
							 attackId == TppDamage.ATK_80304 or
							 attackId == TppDamage.ATK_80305 or
							 attackId == TppDamage.ATK_80306 or
							 attackId == TppDamage.ATK_HoneyBee then
							 	svars.isFlag01 = true
								s10040_radio.UsedHoneyBee()
							end
						
						end
					end
				},
				{
					msg = "ArrivedAtLandingZoneWaitPoint",
					func = function(gameObjectId, lzName)
						
						if lzName == Fox.StrCode32("lzs_fort_S_000") then
							local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
							GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name="lzs_fort_W_0000" })							
							
						end
					end
				},
			},
			Trap = {
				{
					msg = "Exit", sender = "trap_run_from_boss",
					func = function()
						this.DeadParasiteSquad(nil)
					end
				},
				{
					msg = "Enter", sender = "trap_boss_area",
					func = function()
						
						local gameObjectId = GameObject.GetGameObjectId( "TppParasite2","wmu_s10040_0000" )
						GameObject.SendCommand( gameObjectId, { id="SetDeterrentEnabled", enabled=false } )
					end
				},
				{
					msg = "Exit", sender = "trap_boss_area",
					func = function()
						
						local gameObjectId = GameObject.GetGameObjectId( "TppParasite2","wmu_s10040_0000" )
						GameObject.SendCommand( gameObjectId, { id="SetDeterrentEnabled", enabled=true } )
					end
				},
			},
			Block = {
				{
					msg = "OnScriptBlockStateTransition",
					func = self.SetRealizeParasite
				}
			},
			Timer = {
				{
					msg = "Finish", sender = "Timer_PlayBossRadio",
					func = self.PlayBossRadio
				},
			},
			nil
		}
	end,

	PlayBossRadio = function()
		if svars.bossSequenceNum == this.BOSS_SEQUENCE.BATTLE and svars.isFlag01 == false then
			s10040_radio.PlayUseHoneyBee()
		end
	end,

	
	SetRealizeParasite = function(block, state)
		
		local blockName = TppScriptBlock.GetCurrentPackListName( "demo_block" )
		if blockName == "Demo_Parasite" and state == ScriptBlock.TRANSITION_ACTIVATED then
			Fox.Log("demo block is ok. start boss battle")
			GameObject.SendCommand( { type="TppParasite2" }, { id="StartCombat", position=Vector3(2119.874, 456.582, -1753.959), radius=30.0 } ) 

			
			local nowStorySeq	= TppStory.GetCurrentStorySequence()
			local allowStorySeq	= TppDefine.STORY_SEQUENCE.CLEARD_METALLIC_ARCHAEA	
			
			if ( nowStorySeq >= allowStorySeq ) then
				Fox.Log("#### CheckEnableFultonParasite #### Enable!")	
				GameObject.SendCommand( { type="TppParasite2" }, { id="SetFultonEnabled", enabled=true } ) 
			else
				Fox.Log("#### CheckEnableFultonParasite #### Disable...")	
			end
			
			svars.bossSequenceNum = this.BOSS_SEQUENCE.BATTLE
			GkEventTimerManager.Stop("Timer_PlayBossRadio")
			GkEventTimerManager.Start("Timer_PlayBossRadio", TIME_RADIO_BOSS)	
			s10040_radio.PlayBossEncounter()
			s10040_sound.BGMParasitesAlert()
			this.ChangeWeatherForBoss(false)
			return true
		else
			
			return false					
		end


	end,


	CountDyingParaUnit = function(id)
		if s10040_enemy.CheckParasiteMessage(id)then
			svars.bossDyingNum = svars.bossDyingNum + 1
			Fox.Log("parasite dying : "..svars.bossDyingNum )
			
			TppResult.AcquireSpecialBonus{
	        	first = { pointIndex = svars.bossDyingNum },
			}
			Fox.Log("update objective")
			TppMission.UpdateObjective{	objectives = { 	"clear_missionTask_01", nil }, }	
		end


		if svars.bossDyingNum >= BOSS_CLEAR_COUNT then
			Fox.Log("all dying!! go next sequence")

			this.DeadParasiteSquad("dead")


		end
	end,


	OnEnter = function()
		Fox.Log("load parasite block")
		
		
		TppRadio.EnableCommonOptionalRadio(false)
		this.SetDogStopAI(true)
		TppScriptBlock.LoadDemoBlock( "Demo_Parasite" )
		s10040_enemy.ChangeStateEnemyInFort()

		TppMission.UpdateObjective{
			objectives = { "get_photo_honeyBee","open_missionTask_01", nil },
		}

		s10040_radio.SetIntelRadioZombie()

		
		vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE
		
		Fox.Log("disable LZ")
		TppLandingZone.DisableUnlockLandingZoneOnMission(true)
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_fort_I0000|lz_fort_I_0000" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_slopedTownEast_E0000|lz_slopedTownEast_E_0000" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_bridge_S0000|lz_bridge_S_0000" }

		
		TppMission.StartBossBattle()
		
	end,
		
	OnLeave = function()
		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE

		
		TppMission.FinishBossBattle()

		TppMission.UpdateCheckPoint{ 
			checkPoint ="CHK_escape",
			ignoreAlert = true 
		}
	end,

}


sequences.Seq_Game_Escape = {
	Messages = function( self )
		return
		StrCode32Table {
			Player = {
				{
					msg = "RideHelicopter",
					func = self.CheckClearStatus
				},
			},
			GameObject = {
				{ 
					msg = "RoutePoint2", 		sender = "SupportHeli",	
					func = self.GoToClear
				},
				{	
					msg = "RoutePoint2", sender = {"sol_s10040_0000","sol_s10040_0001","sol_s10040_0002"},
					func = function(objectId,routeId,routeNode,message)
						Fox.Log("get message RoutePoint2 : "..message )
						this.ChangeRouteTake(objectId,message)
					end
				},
				{
					msg = "DescendToLandingZone",
					func = function()
						if this.CheckGetHoneyBee() then
							s10040_radio.PlayLZwithHoneyBee()
							TppSound.PostJingleOnDecendingLandingZone()
						else
							s10040_radio.PlayLZwithoutHoneyBee()
							TppMusicManager.PostJingleEvent( "SingleShot", "Play_bgm_mission_heli_descent_short" )
						end
					end
				
				},
			},
			Timer = {
				{
					msg = "Finish", sender = "Timer_ClearToFade",
					func = function()
						
						GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="Recover" } ) 
						TppMission.ReserveMissionClear{
							missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
							nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI
						}
					end
				},
				{
					msg = "Finish", sender = "Timer_HeliCall",
					func = function()
						
						local gameObjectId = GameObject.GetGameObjectId("TppHeli2", "SupportHeli")
						GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name="lz_fort_W0000|lz_fort_W_0000" })
						GameObject.SendCommand(gameObjectId, { id="EnableDescentToLandingZone" })
					end
				},
				{
					msg = "Finish", sender = "Timer_RadioCall",
					func = function()
						s10040_radio.PlayBossEnd()
					end
				},
			},
			nil
		}
	end,
	OnEnter = function()
		
		if TppSequence.GetContinueCount() == 0 then
			if svars.isFlag05 == true then
				
				GkEventTimerManager.Start("Timer_RadioCall", 5)
				
				GkEventTimerManager.Start("Timer_HeliCall", TIME_HELI_CALL+7)
			else
			
				GkEventTimerManager.Start("Timer_HeliCall", TIME_HELI_CALL+4)
			end
		else
			s10040_radio.PlayContinueEsc()
			
			GkEventTimerManager.Start("Timer_HeliCall", TIME_HELI_CALL)
		end

		
		vars.playerDisableActionFlag = PlayerDisableAction.NONE


		TppWeather.ForceRequestWeather( TppDefine.WEATHER.SUNNY, 6 )

		s10040_enemy.ChangeStateEnemyInFort(false)
		TppRadio.EnableCommonOptionalRadio(true)
		s10040_radio.ORadioSet50()
		s10040_radio.UnsetIntelRadioZombie()
				
		
		TppLandingZone.DisableUnlockLandingZoneOnMission(false)
		if TppGimmick.IsBroken{ gimmickId = "fort_aacr001", searchFromSaveData = false  } then
			Fox.Log("AAC is break. open LZ")
			TppHelicopter.SetEnableLandingZone{ landingZoneName = "lz_fort_I0000|lz_fort_I_0000" }
		else
			Fox.Log("AAC is not break.")
		end
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_slopedTownEast_E0000|lz_slopedTownEast_E_0000" }
		TppHelicopter.SetDisableLandingZone{ landingZoneName = "lz_bridge_S0000|lz_bridge_S_0000" }

		local gameObjectId =  GameObject.GetGameObjectId("EnemyHeli")
		GameObject.SendCommand(gameObjectId, { id="Unrealize" })

		Fox.Log("enable LZ")		
		this.SetDogStopAI(false)

		
		TppSound.SkipDecendingLandingZoneWithOutCanMissionClearJingle()
		
		if DEBUG and svars.isDebugCheck >= 200 and svars.isDebugCheck < 300 then
			Fox.Log("debug 200")

			local route = "rt_rtn_fort_S_0001"
			local pos = {2132.750, 458.273, -1694.524}
			if svars.isDebugCheck == 210 then
				route = "rt_rtn_fort_W_0000"
				pos = {1645.153, 472.150, -1288.155}
			elseif svars.isDebugCheck == 220 then
				route = "rt_rtn_fort_E_0000"
				pos = {1662.393, 484.449, -1337.184}
			end
			Fox.Log(route)
			GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="RequestRoute", route = route } ) 
			MissionTest.WarpPlayer{  pos = pos }

			TppMission.ReserveMissionClear{
				missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER,
				nextMissionId = TppDefine.SYS_MISSION_ID.AFGH_HELI
			}
		end

	end,

	
	GoToClear = function()
		Fox.Log("Heli position is close door")
		if svars.mis_canMissionClear then
			Fox.Log("Go To Rsulte")
			TppMission.UpdateObjective{	objectives = { 	"announce_all_clear", nil }, }
			GkEventTimerManager.Start("Timer_ClearToFade", TIME_HELI_TO_FADE)
		else
			Fox.Log("game over. becouse not can_mission_clear")
			TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.OUTSIDE_OF_MISSION_AREA, TppDefine.GAME_OVER_RADIO.OTHERS )
		end
	end,

	
	CheckClearStatus = function()
		Fox.Log("Player ride on Heli. Check is Player have Honey Bee")
		if this.CheckGetHoneyBee()  then
			Fox.Log("Check OK.Go to can mission clear.")
			svars.mis_canMissionClear = true

			GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetGettingOutEnabled", enabled=false } ) 
			GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetTakeOffWaitTime", time=0 } ) 

		else
			Fox.Log("dont take HONEY BEE")
			GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetTakeOffWaitTime", time=5 } ) 
			GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetGettingOutEnabled", enabled=true } )

		end
	end,

}

sequences.Seq_Demo_HeliClear = {
	OnEnter = function()
		Fox.Log("Play clear demo")
		local func = function()
			TppMission.ShowMissionReward()
			Player.SetPause()
		end
		GameObject.SendCommand( { type="TppHeli2", index=0, }, { id="SetDemoToIdleEnabled", enabled=true } )
		
		local key = this.CheckClearDemoPos()
		s10040_demo.PlayMissionCear(IDEN_DEMO, key, func)
	end,

}



return this