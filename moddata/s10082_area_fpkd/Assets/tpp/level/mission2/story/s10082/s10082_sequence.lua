local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local IsTypeFunc = Tpp.IsTypeFunc
local IsTypeTable = Tpp.IsTypeTable
local IsTypeString = Tpp.IsTypeString
local GetGameObjectId = GameObject.GetGameObjectId
local NULL_ID = GameObject.NULL_ID

local sequences = {}




this.markingSettingTable = {}

local MAX_COUNT_DESTROY_WALKERGEAR = 4
local MAX_COUNT_RECOVER_WALKERGEAR = 4
local MAX_COUNT_RECOVER_HOSTAGE = 2


this.MISSIONTASK_LIST = {
	MAIN_BREAK_TARGET					= 1,												
	SPECIALBONUS_RECOVERED_HOSTAGE		= 2,												
	SPECIALBONUS_RECOVERED_WALKERGEAR	= 3,												
	SUB_RECOVERED_DIGITALIS				= 4,												
	SUB_RECOVERED_TRUCK					= 5,												
}





this.WALKERGEARTABLE = {

	"wkr_WalkerGear_0000",
	"wkr_WalkerGear_0001",
	"wkr_WalkerGear_0002",
	"wkr_WalkerGear_0003",
}


this.BONUSHOSTAGETABLE = {
	"hos_s10082_0000",
	"hos_s10082_0001",
}


 this.SUBTASKTRUCKTABLE = {
	"veh_s10082_0000",
}






this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PLACED_LOCATOR_COUNT = 15








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
    {
        name = "isOnplayer_Savannah",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "iswalkerGearMarking",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "isMarkingWalkerGear00",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "isMarkingWalkerGear01",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "isMarkingWalkerGear02",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "isMarkingWalkerGear03",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "iswalkerGearBroken00",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "iswalkerGearBroken01",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "iswalkerGearBroken02",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "iswalkerGearBroken03",
        arraySize = 1,
        type = TppScriptVars.TYPE_BOOL,
        value = false,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "walkerGearBrokenCount",
        arraySize = 1,
        type = TppScriptVars.TYPE_UINT32,
        value = 0,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "walkerGearBrokenradioCount",
        arraySize = 1,
        type = TppScriptVars.TYPE_UINT32,
        value = 0,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "WG_FultonCount",
        arraySize = 1,
        type = TppScriptVars.TYPE_UINT32,
        value = 0,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
    {
        name = "recoverhostageCount",
        arraySize = 1,
        type = TppScriptVars.TYPE_UINT32,
        value = 0,
        save = true,
        sync = false,
        wait = false,
        category = TppScriptVars.CATEGORY_MISSION,
    },
}


this.checkPointList = {
	"CHK_MissionStart",		
	nil
}


this.baseList = {
	
	"savannah",
	
	"savannahEast",
	"savannahWest",
	"swampEast",
	"pfCampNorth",
	nil
}
this.REVENGE_MINE_LIST = {"mafr_savannah"}






this.missionObjectiveDefine = {
	
	default_area_savannah = {
		gameObjectName	= "s10082_marker_savannah", visibleArea = 5, randomRange = 0, viewType = "all", setNew = false, announceLog = "updateMap",
		mapRadioName = "s0082_mprg2010", langId = "marker_info_mission_targetArea",
	},
	
	rv_missionClear = {
		announceLog = "updateMap",
	},
	
	on_Search_WalkerGear_00 = {
		gameObjectName = "wkr_WalkerGear_0000",	 goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true,
		langId = "marker_info_mission_target",
	},
	
	on_Search_WalkerGear_01 = {
		gameObjectName = "wkr_WalkerGear_0001",	 goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true,
		langId = "marker_info_mission_target",
	},
	
	on_Search_WalkerGear_02 = {
		gameObjectName = "wkr_WalkerGear_0002",	 goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true,
		langId = "marker_info_mission_target",
	},
	
	on_Search_WalkerGear_03 = {
		gameObjectName = "wkr_WalkerGear_0003",	 goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true,
		langId = "marker_info_mission_target",
	},
	
	on_hostage_00
	 = {
		gameObjectName = "hos_s10082_0000",	 goalType = "none", viewType = "map_and_world_only_icon", setNew = true, announceLog = "updateMap",
		langId = "marker_hostage",
	},
	
	on_hostage_01 = {
		gameObjectName = "hos_s10082_0001",	 goalType = "none", viewType = "map_and_world_only_icon", setNew = true, announceLog = "updateMap",
		langId = "marker_hostage",
	},
	
	
	default_photo_target = {
		photoId	= 10, photoRadioName = "s0082_mirg2010"
	},
	
	default_photo_savannah = {
		photoId	= 20
	},
	
	
	targetCpSetting = {
		targetBgmCp = "mafr_savannah_cp",
	},
	
	
	default_subGoal_missionStart = {
		subGoalId		= 0,
	},
	on_subGoal_missionComplete = {
		subGoalId		= 1,
	},

	
	
	default_mainTask_break_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_BREAK_TARGET,					isNew = false,	isComplete = false,	},
	},
	on_mainTask_break_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_BREAK_TARGET,					isNew = true,	isComplete = true,	},
	},
	
	
	default_specialbonus_recovered_hostage = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_HOSTAGE,		isNew = false,	isComplete = false,	isFirstHide = true },
	},
	default_specialbonus_recovered_walkergear = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_WALKERGEAR,	isNew = false,	isComplete = false, isFirstHide = true },
	},
	on_specialbonus_recovered_hostage = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_HOSTAGE,		isNew = true,	},
	},
	on_specialbonus_recovered_walkergear = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_WALKERGEAR,	isNew = true,	},
	},
	
	
	default_subTask_recovered_digitalis = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_DIGITALIS,			isNew = false,	isComplete = false,	isFirstHide = true },
	},
	default_subTask_recovered_truck = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_TRUCK,				isNew = false,	isComplete = false,	isFirstHide = true },
	},
	on_subTask_recovered_digitalis = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_DIGITALIS,			isNew = true,	isComplete = true,	},
	},
	on_subTask_recovered_truck = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_TRUCK,			isNew = true,	isComplete = true,	},
	},

	
	
	announce_destroy_target00 = {
		announceLog="destroyTarget",
	},
	announce_destroy_target01 = {
		announceLog="destroyTarget",
	},
	announce_destroy_target02 = {
		announceLog="destroyTarget",
	},
	announce_destroy_target03 = {
		announceLog="destroyTarget",
	},
	announce_recovered_target00 = {
		announceLog="recoverTarget",
	},
	announce_recovered_target01 = {
		announceLog="recoverTarget",
	},
	announce_recovered_target02 = {
		announceLog="recoverTarget",
	},
	announce_recovered_target03 = {
		announceLog="recoverTarget",
	},
	
	announce_recovered_hostage = {
		announceLog = "achieveAllObjectives",
	},
}











this.missionObjectiveTree = {
	rv_missionClear = {
		default_area_savannah = {},
		on_Search_WalkerGear_00 = {},
		on_Search_WalkerGear_01 = {},
		on_Search_WalkerGear_02 = {},
		on_Search_WalkerGear_03 = {},
	},
	default_photo_target = {
	},
	default_photo_savannah = {
	},
	
	targetCpSetting = {
	},

	
	default_subGoal_missionStart = {},
	on_subGoal_missionComplete = {},

	
	on_hostage_00 = {},
	on_hostage_01 = {},

	
	on_mainTask_break_target = {},
	
	
	on_specialbonus_recovered_hostage = {},
	on_specialbonus_recovered_walkergear = {},
	
	
	on_subTask_recovered_digitalis = {},
	on_subTask_recovered_truck = {},
	
	announce_destroy_target00 = {},
	announce_destroy_target01 = {},
	announce_destroy_target02 = {},
	announce_destroy_target03 = {},
	announce_recovered_target00 = {},
	announce_recovered_target01 = {},
	announce_recovered_target02 = {},
	announce_recovered_target03 = {},
	announce_recovered_hostage = {},
}





this.missionObjectiveEnum = Tpp.Enum{
	"default_area_savannah",
	"rv_missionClear",
	"default_photo_target",
	"default_photo_savannah",
	"on_Search_WalkerGear_00",
	"on_Search_WalkerGear_01",
	"on_Search_WalkerGear_02",
	"on_Search_WalkerGear_03",
	"on_hostage_00",
	"on_hostage_01",
	"targetCpSetting",
	
	"default_subGoal_missionStart",
	"on_subGoal_missionComplete",

	
	"default_mainTask_break_target",
	"on_mainTask_break_target",
	
	"default_specialbonus_recovered_hostage",
	"default_specialbonus_recovered_walkergear",
	"on_specialbonus_recovered_hostage",
	"on_specialbonus_recovered_walkergear",
	
	"default_subTask_recovered_digitalis",
	"default_subTask_recovered_truck",
	"on_subTask_recovered_digitalis",
	"on_subTask_recovered_truck",
	
	
	"announce_destroy_target00",
	"announce_destroy_target01",
	"announce_destroy_target02",
	"announce_destroy_target03",
	"announce_recovered_target00",
	"announce_recovered_target01",
	"announce_recovered_target02",
	"announce_recovered_target03",
	"announce_recovered_hostage",
}






this.missionStartPosition = {
	
	orderBoxList = {
		"box_s10082_00",
	},
	
	helicopterRouteList = {
		"lz_pfCampNorth_S0000",
		"lz_drp_savannah_I0000",
	},
}





this.specialBonus = {
	first = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_HOSTAGE,	},
	},
	second = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_WALKERGEAR, },
	},
}





function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	
	
	TppRatBird.EnableBird( "TppCritterBird" )
	
	TppRatBird.EnableRat() 
	
	if TppMission.IsHardMission( vars.missionCode ) then
		TppMission.RegistDiscoveryGameOver()
	end
	
	TppMission.RegisterMissionSystemCallback{
		CheckMissionClearFunction = function()
			local gameObjectId = { type="TppCommonWalkerGear2" }
			local command = { id = "CountEnemyGearNearPlayer" }
			local fultonableCount = GameObject.SendCommand( gameObjectId, command )	
			if svars.WG_FultonCount + svars.walkerGearBrokenCount + fultonableCount == 4 then	
				TppMission.UpdateObjective{
					objectives = {
						"on_mainTask_break_target",
					}
				}
				TppMission.CanMissionClear()
				return true
			end
		end,
		
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
			
		TppRadio.RequestBlackTelephoneRadio( "f6000_rtrg0230" )	
	end,
	
	


	OnSetMissionFinalScore = function( missionClearType )
		
		if vars.playerVehicleGameObjectId ~= NULL_ID then
			if vars.playerVehicleGameObjectId == GameObject.GetGameObjectId( "TppVehicle2" , "veh_s10082_0000" ) then
				Fox.Log("##** OnEstablishMissionClear VEHICLE_NAME ####")
				
				TppMission.UpdateObjective{
					objectives = {
						"on_subTask_recovered_truck",
					},
				}
			end
		end
	end,

	
	OnRecovered = function( gameObjectId )
		local function _IsTaget( s_gameObjectId, gameObjectNameTable )
			for i, gameObjectName in ipairs( gameObjectNameTable ) do
				local gameObjectId = GetGameObjectId( gameObjectName )
				if s_gameObjectId == gameObjectId then
					return true
				end
			end
			return false
		end
	
		if Tpp.IsEnemyWalkerGear( gameObjectId ) then
			
			if _IsTaget( gameObjectId, this.WALKERGEARTABLE ) then
				
				svars.WG_FultonCount = svars.WG_FultonCount + 1
				s10082_radio.walkerGearFultonCount()
				
				TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.WG_FultonCount + svars.walkerGearBrokenCount, MAX_COUNT_RECOVER_WALKERGEAR ) 
				this.WG_Annihilated()
				
				if svars.WG_FultonCount == MAX_COUNT_RECOVER_WALKERGEAR then
					TppMission.UpdateObjective{
						objectives = {
							 "on_specialbonus_recovered_walkergear",
						 }
					 }
					 
					TppResult.AcquireSpecialBonus{
						second = { isComplete = true },
					}
				end
			end
			
			elseif Tpp.IsHostage( gameObjectId ) then
				if _IsTaget( gameObjectId, this.BONUSHOSTAGETABLE ) then
					
					svars.recoverhostageCount = svars.recoverhostageCount + 1
					
					
					if svars.recoverhostageCount == MAX_COUNT_RECOVER_HOSTAGE then
						TppMission.UpdateObjective{
							objectives = {
								"on_specialbonus_recovered_hostage",
							}
						}
						
						TppResult.AcquireSpecialBonus{
							first = { isComplete = true },
						}
					end
				end
			end
		end,
	}
	
	
	TppEnemy.RequestLoadWalkerGearEquip()
	
	
	
	
	this.markingSettingTable[StrCode32( "wkr_WalkerGear_0000" )] = {
		walkerGearGameObjectName		= "wkr_WalkerGear_0000", 
		objectives					= { "on_Search_WalkerGear_00" },
		isMarkingSvarsName			= "isMarkingWalkerGear00",
	}
	
	this.markingSettingTable[StrCode32( "wkr_WalkerGear_0001" )] = {
		walkerGearGameObjectName		= "wkr_WalkerGear_0001", 
		objectives					= { "on_Search_WalkerGear_01" },
		isMarkingSvarsName			= "isMarkingWalkerGear01",
	}
	
	this.markingSettingTable[StrCode32( "wkr_WalkerGear_0002" )] = {
		walkerGearGameObjectName		= "wkr_WalkerGear_0002", 
		objectives					= { "on_Search_WalkerGear_02" },
		isMarkingSvarsName			= "isMarkingWalkerGear02",
	}
	
	this.markingSettingTable[StrCode32( "wkr_WalkerGear_0003" )] = {
		walkerGearGameObjectName		= "wkr_WalkerGear_0003", 
		objectives					= { "on_Search_WalkerGear_03" },
		isMarkingSvarsName			= "isMarkingWalkerGear03",
	}
	
end




function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
end


function this.OnGameOver( gameOverType )
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
end


function this.RegiserMissionSystemCallback()
	Fox.Log("*** RegiserMissionSystemCallback ***")
	
	local systemCallbackTable ={
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		OnGameOver = this.OnGameOver,
		nil
	}
	
	
	TppMission.RegiserMissionSystemCallback(systemCallbackTable)
	
end









function this.Messages()
	return
	StrCode32Table {
		GameObject = {
			{	
				msg = "Fulton", 
				sender = "veh_s10082_0000",
				func = function()
					if TppMission.IsEnableAnyParentMissionObjective( "on_subTask_recovered_truck" ) == false then
						TppMission.UpdateObjective{
							objectives = {
								"on_subTask_recovered_truck",
							},
						}
					end
				end,
			},
		},		
		Marker = {
			{	
				msg = "ChangeToEnable",
				sender = "wkr_WalkerGear_0000",
				func = function( instanceName, makerType, gameObjectId, markerId )
					if markerId == StrCode32("Player") then
						local WalkerGearGameObjectId = GetGameObjectId( "wkr_WalkerGear_0000" )
						this.Search_WalkerGear( WalkerGearGameObjectId )
					else
						Fox.Log(" markerId is not Player ")
					end
				end
			},
			{	
				msg = "ChangeToEnable",
				sender = "wkr_WalkerGear_0001",
				func = function( instanceName, makerType, gameObjectId, markerId  )
					if markerId == StrCode32("Player") then
						local WalkerGearGameObjectId = GetGameObjectId( "wkr_WalkerGear_0001" )
						this.Search_WalkerGear( WalkerGearGameObjectId )
					else
						Fox.Log(" markerId is not Player ")
					end
				end
			},
			{	
				msg = "ChangeToEnable",
				sender = "wkr_WalkerGear_0002",
				func = function( instanceName, makerType, gameObjectId, markerId  )
					if markerId == StrCode32("Player") then
						local WalkerGearGameObjectId = GetGameObjectId( "wkr_WalkerGear_0002" )
						this.Search_WalkerGear( WalkerGearGameObjectId )
					else
						Fox.Log(" markerId is not Player ")
					end
				end
			},
			{	
				msg = "ChangeToEnable",
				sender = "wkr_WalkerGear_0003",
				func = function( instanceName, makerType, gameObjectId, markerId  )
					if markerId == StrCode32("Player") then
						local WalkerGearGameObjectId = GetGameObjectId( "wkr_WalkerGear_0003" )
						this.Search_WalkerGear( WalkerGearGameObjectId )
					else
						Fox.Log(" markerId is not Player ")
					end
				end
			},
		},
		
		Player = {
			{   
				msg = "OnPickUpCollection",
				func = function( playerGameObjectId, collectionUniqueId, collectionTypeId )
					if collectionUniqueId == TppCollection.GetUniqueIdByLocatorName( "col_herb_r_s10082_0000" ) then
                        
						TppMission.UpdateObjective{
							objectives = { "on_subTask_recovered_digitalis" },
						}
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


this.Search_WalkerGear = function( gameObjectId )
	for i, markingSetting in pairs( this.markingSettingTable ) do
		local WalkerGearGameObjectId = GetGameObjectId( markingSetting.walkerGearGameObjectName )
		local command = { id = "IsEnemyRiding" }
		local isEnemyRiding = GameObject.SendCommand( WalkerGearGameObjectId, command )
		
		if gameObjectId == WalkerGearGameObjectId then
			
			if svars.iswalkerGearMarking == false then
				svars.iswalkerGearMarking = true
				s10082_radio.Search_WalkerGear()
			else
			end
			if svars[markingSetting.isMarkingSvarsName] == false then
				svars[markingSetting.isMarkingSvarsName] = true
				
				TppMission.UpdateObjective{
					objectives = markingSetting.objectives,
				}
				
				TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
				return
			end
		end
	end
end
	
	this.walkerGearBrokenmessage = function()
	
		if svars.WG_FultonCount + svars.walkerGearBrokenCount == 1 then
			s10082_radio.walkerGearBrokenCount()
			this.WG_Annihilated()
			
		elseif svars.WG_FultonCount + svars.walkerGearBrokenCount == 2 then
			s10082_radio.walkerGearBrokenCount()
			this.WG_Annihilated()
			
		elseif svars.WG_FultonCount + svars.walkerGearBrokenCount == 3 then
			s10082_radio.walkerGearBrokenCountLast()
			this.WG_Annihilated()
			
		elseif svars.WG_FultonCount + svars.walkerGearBrokenCount == 4 then
			this.WG_Annihilated()
		end
		
	end



	this.WG_Annihilated = function()
		if svars.WG_FultonCount + svars.walkerGearBrokenCount == 4 then
			TppMission.UpdateObjective{
				objectives = {
					"on_mainTask_break_target",
				}
			}
			TppSequence.SetNextSequence("Seq_Game_Escape")		
		end
	end

this.HighInterrogation = function()
local sequence = TppSequence.GetCurrentSequenceName() 
	if ( sequence == "Seq_Game_MainGame" ) then
			
			TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("mafr_savannah_cp"),
			{ 
				{ name = "enqt1000_1i1210", func = s10082_enemy.InterCall_sol_savannah00, },
				{ name = "enqt1000_1i1310", func = s10082_enemy.InterCall_sol_savannah01, },
			} )
	else
		
		TppInterrogation.ResetFlagHigh( GameObject.GetGameObjectId("mafr_savannah_cp"))
	end
end	





sequences.Seq_Game_MainGame = {

	Messages = function( self ) 
			return
		StrCode32Table {
			GameObject = {
				
				{	
					msg = "WalkerGearBroken", 
					sender = "wkr_WalkerGear_0000",
					func = function (gameObjectId , state)
						TppMission.UpdateObjective{
							objectives = {
								"announce_destroy_target00",
							}
						}
						self.walkerGearBrokenCount(gameObjectId , state)
					end
				},
				
				{	
					msg = "WalkerGearBroken", 
					sender = "wkr_WalkerGear_0001",
					func = function (gameObjectId , state)
						TppMission.UpdateObjective{
							objectives = {
								"announce_destroy_target01",
							}
						}
						self.walkerGearBrokenCount(gameObjectId , state)
					end
				},
				
				{	
					msg = "WalkerGearBroken", 
					sender = "wkr_WalkerGear_0002",
					func = function (gameObjectId , state)
						TppMission.UpdateObjective{
							objectives = {
								"announce_destroy_target02",
							}
						}
						self.walkerGearBrokenCount(gameObjectId , state)
					end
				},
				
				{	
					msg = "WalkerGearBroken", 
					sender = "wkr_WalkerGear_0003",
					func = function (gameObjectId , state)
						TppMission.UpdateObjective{
							objectives = {
								"announce_destroy_target03",
							}
						}
						self.walkerGearBrokenCount(gameObjectId , state)
					end
				},
				
				
				{ 
					msg = "FultonFailed",
					sender = "wkr_WalkerGear_0000",
					func = function( gameObjectId , locatorName , locatorNameUpper , failureType )
						Fox.Log( "FultonFailed " .. "GameObjectId: " .. tostring(gameObjectId) .. " locator: " .. tostring(locatorName) .. " failureType " .. tostring(failureType) )
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then	
							
							self.walkerGearBrokenCount( gameObjectId )
						end
					end
				},
				
				
				{	
					msg = "Fulton", 
					sender = "wkr_WalkerGear_0000",
					func = function (gameObjectId , state)
						TppMission.UpdateObjective{
							objectives = {
								"announce_recovered_target00",
							}
						}
					end
				},
				
				{	
					msg = "Fulton", 
					sender = "wkr_WalkerGear_0001",
					func = function (gameObjectId , state)
						TppMission.UpdateObjective{
							objectives = {
								"announce_recovered_target01",
							}
						}
					end
				},
				
				{	
					msg = "Fulton", 
					sender = "wkr_WalkerGear_0002",
					func = function (gameObjectId , state)
						TppMission.UpdateObjective{
							objectives = {
								"announce_recovered_target02",
							}
						}
					end
				},
				
				{	
					msg = "Fulton", 
					sender = "wkr_WalkerGear_0003",
					func = function (gameObjectId , state)
						TppMission.UpdateObjective{
							objectives = {
								"announce_recovered_target03",
							}
						}
					end
				},
				{	
					msg = "ChangePhase", 
					func = self.savannahChangePhase,
				},
			},				
			Trap = {
				{
					msg = "Enter",
					sender = "trig_On_Player_Savannah",
					func = function()
						if svars.isOnplayer_Savannah == false then	
							svars.isOnplayer_Savannah = true	
							s10082_radio.ArrivedSavannah()
						end
					end,
				},
				
				{
					msg = "Enter",
					sender = "trap_ChangeAlertRadio",
					func = function()
						mvars.isInSavannah = true
						if TppEnemy.GetPhase("mafr_savannah_cp") == TppEnemy.PHASE.ALERT then
							s10082_radio.AlertOptionalRadio()
						else
						end
					end,
					option = { isExecMissionPrepare = true }
				},
				{
					msg = "Exit",
					sender = "trap_ChangeAlertRadio",
					func = function()
						mvars.isInSavannah = false
					end,
					option = { isExecMissionPrepare = true }
				},
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
			TppCoder.SetWorldCenter(Vector3(826.1266, 2.253296, -70.4859))
		end

		TppRadio.SetOptionalRadio( "Set_s0082_oprg0010" )	
		
		if mvars.isInSavannah == true then
			mvars.isInSavannah = true
		else
			mvars.isInSavannah = false
		end
		
		if TppSequence.GetContinueCount() == 0 then	 
			TppTelop.StartCastTelop()	
			
			TppMission.UpdateCheckPoint("CHK_MissionStart_Player")
			TppMission.UpdateObjective{
			
				objectives = { 
							
							"default_mainTask_break_target",
							
							"default_specialbonus_recovered_hostage",
							"default_specialbonus_recovered_walkergear",
							
							"default_subTask_recovered_digitalis",
							"default_subTask_recovered_truck",
							nil
					}
				}
			
			TppMission.UpdateObjective{
			
				radio = {
					radioGroups = "s0082_rtrg2010",
				},
				
				objectives = { "default_area_savannah",
								"default_photo_target", 
								"default_photo_savannah",
								"targetCpSetting",
								
								"default_subGoal_missionStart",
								nil
					}
				}
			
			TppMission.SetHelicopterDoorOpenTime( 20 )
			this.HighInterrogation()
		else
			s10082_radio.Continue()
		end
	end,
	
	
	walkerGearBrokenCount = function (gameObjectId, state)
		if state == StrCode32("Start")	then
			svars.walkerGearBrokenCount = svars.walkerGearBrokenCount + 1
			svars.walkerGearBrokenradioCount = svars.walkerGearBrokenradioCount + 1
			TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.WG_FultonCount + svars.walkerGearBrokenCount, MAX_COUNT_DESTROY_WALKERGEAR ) 
			this.walkerGearBrokenmessage()
		elseif state == StrCode32("End") then
		end
	end,
	
	savannahChangePhase = function( cpName, PhaseName )
		if TppEnemy.GetPhase("mafr_savannah_cp") == TppEnemy.PHASE.ALERT and mvars.isInSavannah == true then
			s10082_radio.AlertOptionalRadio()
		elseif TppEnemy.GetPhase("mafr_savannah_cp") == TppEnemy.PHASE.ALERT and mvars.isInSavannah == false then
			TppRadio.SetOptionalRadio( "Set_s0082_oprg0050" )
		elseif TppEnemy.GetPhase("mafr_pfCampNorth_ob") == TppEnemy.PHASE.ALERT and mvars.isInSavannah == false then
			TppRadio.SetOptionalRadio( "Set_s0082_oprg0050" )
		elseif TppEnemy.GetPhase("mafr_savannahEast_ob") == TppEnemy.PHASE.ALERT and mvars.isInSavannah == false then
			TppRadio.SetOptionalRadio( "Set_s0082_oprg0050" )
		elseif TppEnemy.GetPhase("mafr_savannahWest_ob") == TppEnemy.PHASE.ALERT and mvars.isInSavannah == false then
			TppRadio.SetOptionalRadio( "Set_s0082_oprg0050" )
		elseif TppEnemy.GetPhase("mafr_swampEast_ob") == TppEnemy.PHASE.ALERT and mvars.isInSavannah == false then
			TppRadio.SetOptionalRadio( "Set_s0082_oprg0050" )
		elseif TppEnemy.GetPhase("mafr_savannah_cp") < TppEnemy.PHASE.ALERT and svars.WG_FultonCount + svars.walkerGearBrokenCount <= 4 then
			s10082_radio.countermeasurewalkerGear()
		else
			s10082_radio.countermeasurewalkerGear()
		end
	end,
}

sequences.Seq_Game_Escape = {

	OnEnter = function()
	
	TppMission.CanMissionClear()
	s10082_radio.MissionClear()
	this.HighInterrogation()
	
	
	TppRadio.SetOptionalRadio( "Set_s0082_oprg0040" )
	
	
	TppMission.UpdateObjective{
			
			objectives = { "rv_missionClear", 
							"on_subGoal_missionComplete",
			},
		}
	end,
}




return this