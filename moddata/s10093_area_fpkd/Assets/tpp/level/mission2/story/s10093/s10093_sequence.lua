






















local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}

this.requires = {}

this.DEBUG_strCode32List = {
	"gntn_cntn001_vrtn002_gim_n0000|srt_gntn_cntn001_vrtn002",
	"gntn_cntn001_vrtn002_gim_n0001|srt_gntn_cntn001_vrtn002",
	"Fulton",
	"EndFadeOut",
	"GameOverDemoFadeOutFinish_1st",
	"GameOverDemoFadeOutFinish_2nd",
}






this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PLACED_LOCATOR_COUNT = 25


this.MAX_PICKABLE_LOCATOR_COUNT = 25




this.REVENGE_MINE_LIST = {"mafr_lab",}
this.MISSION_REVENGE_MINE_LIST = {
	["mafr_lab"] = {
		decoyLocatorList = {
			"itm_revDecoy_lab_a_0005",
			"itm_revDecoy_lab_a_0006",
		},
		
		["trap_mafr_lab_mine_west"] = {
			mineLocatorList = {
				"itm_revMine_lab_a_0010",
				"itm_revMine_lab_a_0011",
				"itm_revMine_lab_a_0012",
				"itm_revMine_lab_a_0013",
				"itm_revMine_lab_a_0014",
			},
		},
		
		["trap_mafr_lab_mine_south"] = {
			mineLocatorList = {
				"itm_revMine_lab_a_0010",
				"itm_revMine_lab_a_0011",
				"itm_revMine_lab_a_0012",
				"itm_revMine_lab_a_0013",
				"itm_revMine_lab_a_0014",
			},
		},
	},
}





local SUPPORT_HELI		= "SupportHeli"
local ZRS_CAPTAIN		= "sol_vip_0000"
local DIAMOND_NAME		= "col_diamond_l_s10093_0000"



local TRAP_NAME = {
	
	CNTN001				= "trap_Container_A",
	CNTN002				= "trap_Container_B",
	
	IN_TENT				= "trap_ApproachIntelAtinTent",
	IN_TENT_ALERT		= "trap_ApproachIntelAtinTent_OnAlert",
	IN_TENT_MARKER		= "trap_intelMarkLabTent",
	
	IN_MANSION			= "trap_ApproachIntelAtinMansion",
	IN_MANSION_ALERT	= "trap_ApproachIntelAtinMansion_OnAlert",
	IN_MANSION_MARKER	= "trap_intelMarkLabMansion",
	
	EVENT_ROUTE_CHANGE	= "trap_Event_RouteChange",
	
	EVENT_JUNGLE_TALK	= "trap_Event_JungleTalk",

}


local INTEL_SENDER_NAME		= {
	IN_TENT				= "Intel_inTent",		
	IN_MANSION			= "Intel_inMansion",	
}


local MARKER_NAME = {
	INTEL_LAB_TENT		= "s10093_marker_intelFile_Tent",
	INTEL_LAB_MANSION	= "s10093_marker_intelFile_Mansion",
}


local PHOTO_NAME = {
	PHOTO_TARGET_A		= 10,								
	PHOTO_TARGET_B		= 20,								
}


local SUBGOAL_ID = {
	START				= 0,
	ESCAPE				= 1,
}


local TARGET_GIMMICK_NAME = {
	CNTN001				= "gntn_cntn001_vrtn001_gim_n0000|srt_gntn_cntn001_vrtn001",			
	CNTN002				= "gntn_cntn001_vrtn001_gim_n0001|srt_gntn_cntn001_vrtn001",			
}


local TARGET_GIMMICK_PATH = {
	CNTN001				= "/Assets/tpp/level/mission2/story/s10093/s10093_item.fox2",			
	CNTN002				= "/Assets/tpp/level/mission2/story/s10093/s10093_item.fox2",			
}


local TARGET_SEARCHTARGET_NAME_LIST = {
	CNTN001				= { MESSAGE = "missiontarget01", FOX2NAME = "/Assets/tpp/level/mission2/story/s10093/s10093_item.fox2" },
	CNTN002				= { MESSAGE = "missiontarget02", FOX2NAME = "/Assets/tpp/level/mission2/story/s10093/s10093_item.fox2" },
}


local COUNTER_LIST = {
	
	EMERGENCY_CALL_TIME = 7,
	
	TIME_OVER_COUNT = 540,
	TIME_OVER_RED_COUNT = 180,
	
	TIME_OVER_COUNT_MIN = 120,

	TIME_OVER_CLOCK_COUNT = 10800,
	TIME_OVER_CLOCK_RED_COUNT = 3600,
	
	DEBUG_COMMON_PRINT_2D_COUNT = 0,
}





local gimmickSettingTable = {}

gimmickSettingTable[StrCode32( TARGET_GIMMICK_NAME.CNTN001 )] = {
	
	gameObjectName			= TARGET_GIMMICK_NAME.CNTN001,
	gameObjectType			= "TppPermanentGimmickFultonableContainer",
	messageName				= TARGET_SEARCHTARGET_NAME_LIST.CNTN001.MESSAGE,
	offSet					= Vector3(0,1.5,0),
	fox2Name				= TARGET_SEARCHTARGET_NAME_LIST.CNTN001.FOX2NAME,
	doDirectionCheck		= false,
	
	markFlagName			= "isMarkTargetContainer001",
	getFlagName				= "isGetTargetContainer001",
}
gimmickSettingTable[StrCode32( TARGET_GIMMICK_NAME.CNTN002 )] = {
	
	gameObjectName			= TARGET_GIMMICK_NAME.CNTN002,
	gameObjectType			= "TppPermanentGimmickFultonableContainer",
	messageName				= TARGET_SEARCHTARGET_NAME_LIST.CNTN002.MESSAGE,
	offSet					= Vector3(0,1.5,0),
	fox2Name				= TARGET_SEARCHTARGET_NAME_LIST.CNTN002.FOX2NAME,
	doDirectionCheck		= false,
	
	markFlagName			= "isMarkTargetContainer002",
	getFlagName				= "isGetTargetContainer002",
}




this.saveVarsList = {
	
	isFirstRouteChange			= false,

	
	isMapGet					= false,

	
	isContainerAMarking			= false,
	isContainerBMarking			= false,

	
	isContainerAGet				= false,
	isContainerBGet				= false,

	
	isMarkTargetContainer001	= false,
	isGetTargetContainer001		= false,
	isMarkTargetContainer002	= false,
	isGetTargetContainer002		= false,

	
	isNoContainerANotice		= false,
	isNoContainerBNotice		= false,

	
	isEnemyInterrogation		= false,

	
	isCountDownStart			= false,

	
	isSneakBreak				= false,

	
	isChaseMode					= false,

	
	isClear						= false,

	
	isTrapEnterRouteChange		= false,
	isOnGetIntel_AtinTent		= false,
	isOnGetIntel_AtinMansion	= false,
	isTrapEnterJungleTalk		= false,

	

	displayTimeSec = COUNTER_LIST.TIME_OVER_COUNT,

	
	PlayerInBase				= false,

	PreliminaryFlag01			= false,	
	PreliminaryFlag02			= false,	
	PreliminaryFlag03			= false,	
	PreliminaryFlag04			= false,	
	PreliminaryFlag05			= false,	
	PreliminaryFlag06			= false,	
	PreliminaryFlag07			= false,	
	PreliminaryFlag08			= false,	
	PreliminaryFlag09			= false,	
	PreliminaryFlag10			= false,	
	PreliminaryFlag11			= false,	
	PreliminaryFlag12			= false,	
	PreliminaryFlag13			= false,	
	PreliminaryFlag14			= false,	
	PreliminaryFlag15			= false,	
	PreliminaryFlag16			= false,	
	PreliminaryFlag17			= false,	
	PreliminaryFlag18			= false,	
	PreliminaryFlag19			= false,	
	PreliminaryFlag20			= false,	

	PreliminaryValue01			= 0,		
	PreliminaryValue02			= 0,		
	PreliminaryValue03			= 0,		
	PreliminaryValue04			= 0,		
	PreliminaryValue05			= 0,		
	PreliminaryValue06			= 0,		
	PreliminaryValue07			= 0,		
	PreliminaryValue08			= 0,		
	PreliminaryValue09			= 0,		
	PreliminaryValue10			= 0,		

}




this.checkPointList = {
	"CHK_MissionStart",				
	"CHK_1stContainerGetAfter",		
	"CHK_2ndContainerGetAfter",		
	nil
}




this.baseList = {
	"lab",
	"labWest",
	"diamondNorth",
	nil
}






this.missionObjectiveDefine = {
	
	default_area_lab = {
		gameObjectName = "10093_marker_lab",
		visibleArea = 6,
		randomRange = 0,
		viewType = "all",
		setNew = false,
		announceLog = "updateMap",
		langId = "marker_info_mission_targetArea",
		mapRadioName = "s0093_mprg0010",
	},
	
	add_lab_enemy_map = {
		gameObjectName = "10093_marker_lab_map",
		visibleArea = 0,
		randomRange = 0,
		announceLog = "updateMap",
	},
	
	add_s10093_Container_A = {
		gimmickId = "lab_cntn001",
		goalType = "moving",
		viewType = "all",
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_container",
		mapRadioName = "f1000_mprg0095",
	},
	add_s10093_Container_B = {
		gimmickId = "lab_cntn002",
		goalType = "moving",
		viewType = "all",
		setImportant = true,
		announceLog = "updateMap",
		langId = "marker_container",
		mapRadioName = "f1000_mprg0095",
	},
	get_s10093_Container_A = {
	},
	get_s10093_Container_B = {
	},
	
	add_s10093_ZRS_Captain = { 
		gameObjectName = ZRS_CAPTAIN,
		goalType = "moving",
		viewType="map_and_world_only_icon",
		setNew = true,
		setImportant = true,
	},
	
	default_photo_target_a = {
		photoId	= PHOTO_NAME.PHOTO_TARGET_A,
		addFirst = true,
		photoRadioName = "s0093_mirg0010",
	},
	default_photo_target_b = {
		photoId	= PHOTO_NAME.PHOTO_TARGET_B,
		addFirst = true,
		photoRadioName = "s0093_mirg0020",
	},
	
	target_area_cp = {
		targetBgmCp = "mafr_labJungle_cp",
	},
	
	intermediate_target01 = {
		subGoalId = SUBGOAL_ID.START,
	},
	
	
	
	default_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = false },
	},
	
	default_missionTask_02 = {
		missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_03 = {
		missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_04 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_05 = {
		missionTask = { taskNo = 5, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	default_missionTask_06 = {
		missionTask = { taskNo = 6, isNew = true, isComplete = false, isFirstHide=true },
	},
	
	
	clear_missionTask_01 = {
		missionTask = { taskNo = 0, isNew = true, isComplete = true },
	},
	
	clear_missionTask_02 = {
		missionTask = { taskNo = 2, isNew = true, },
	},
	
	clear_missionTask_03 = {
		missionTask = { taskNo = 3, isNew = true, },
	},
	
	clear_missionTask_04 = {
		missionTask = { taskNo = 4, isNew = true, isComplete = true },
	},
	
	clear_missionTask_05 = {
		missionTask = { taskNo = 5, isNew = true, isComplete = true },
	},
	
	clear_missionTask_06 = {
		missionTask = { taskNo = 6, isNew = true, isComplete = true },
	},
	
	rv_missionClear = {
		photoId		= PHOTO_NAME.PHOTO_TARGET,
		addFirst = true,
		announceLog = "updateMap",
		subGoalId = SUBGOAL_ID.ESCAPE,
	},
	
	intelFile_lab_Tent = {
		gameObjectName = MARKER_NAME.INTEL_LAB_TENT,
	},
	intelFile_lab_Mansion = {
		gameObjectName = MARKER_NAME.INTEL_LAB_MANSION,
	},
	
	intelFile_lab_Tent_get = {
	},
	intelFile_lab_Mansion_get = {
	},
	
	announce_recoverTarget01 = {
		announceLog = "recoverTarget",
	},
	announce_recoverTarget02 = {
		announceLog = "recoverTarget",
	},
}




this.missionObjectiveTree = {
	rv_missionClear = {
		get_s10093_Container_A = {
			add_s10093_Container_A = {
				add_lab_enemy_map = {
					default_area_lab = {},
				},
			},
		},
		get_s10093_Container_B = {
			add_s10093_Container_B = {
				add_lab_enemy_map = {
					default_area_lab = {},
				},
			},
		},
		default_photo_target_a	= {},
		default_photo_target_b	= {},
		target_area_cp	= {},
		intermediate_target01 = {},
	},
	add_s10093_ZRS_Captain = {},
	clear_missionTask_01 = {
		default_missionTask_01 = {},
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
	clear_missionTask_06 = {
		default_missionTask_06 = {},
	},
	intelFile_lab_Tent_get = {
		intelFile_lab_Tent = {
		},
	},
	intelFile_lab_Mansion_get = {
		intelFile_lab_Mansion = {
		},
	},
	
	announce_recoverTarget01 = {
	},
	announce_recoverTarget02 = {
	},
}


this.missionObjectiveEnum = Tpp.Enum{
	"default_area_lab",
	"add_lab_enemy_map",
	"add_s10093_Container_A",
	"add_s10093_Container_B",
	"get_s10093_Container_A",
	"get_s10093_Container_B",
	"default_photo_target_a",
	"default_photo_target_b",
	"target_area_cp",
	"intermediate_target01",
	"rv_missionClear",
	"intelFile_lab_Tent_get",
	"intelFile_lab_Tent",
	"intelFile_lab_Mansion_get",
	"intelFile_lab_Mansion",
	"add_s10093_ZRS_Captain",
	"clear_missionTask_01",
	"default_missionTask_01",
	"clear_missionTask_02",
	"default_missionTask_02",
	"clear_missionTask_03",
	"default_missionTask_03",
	"clear_missionTask_04",
	"default_missionTask_04",
	"clear_missionTask_05",
	"default_missionTask_05",
	"clear_missionTask_06",
	"default_missionTask_06",
	"announce_recoverTarget01",
	"announce_recoverTarget02",
}

this.missionTask_5_TARGET_LIST = {
	ZRS_CAPTAIN,
}

this.specialBonus = {
	first = {
		missionTask = { taskNo = 2 },
	},
	second = {
		missionTask = { taskNo = 3 },
	}
}

this.missionStartPosition = {
	
	helicopterRouteList = {
		"lz_drp_lab_W0000|rt_drp_lab_W_0000",
		"lz_drp_lab_S0000|rt_drp_lab_S_0000",
	},
	
	orderBoxList = {
		"box_s10093_00",
		"box_s10093_01",
		"box_s10093_02",
	},
}


TppDefine.MISSION_QUEST_LIST = {
	[10093] = {
		"lab_q80700",
	},
} 





this.OnLoad = function()
	Fox.Log("#### s10093_sequence.OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Game_ContainerGetBefore", 
		"Seq_Game_ContainerAGetAfter", 
		"Seq_Game_ContainerBGetAfter", 
		
		"Seq_Game_Escape",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)

end

this.OnUpdate = function()
end


this.OnRestoreSVars = function ()

	
	local ret01, gameObjectId01 = TppGimmick.GetGameObjectId( "lab_cntn001" )
	if ret01 then
		TppPlayer.SetForceFultonPercent( gameObjectId01, 100 )
	end
	local ret02, gameObjectId02 = TppGimmick.GetGameObjectId( "lab_cntn002" )
	if ret02 then
		TppPlayer.SetForceFultonPercent( gameObjectId02, 100 )
	end

	
	
	if (svars.isEnemyInterrogation == false) then
		if (svars.isMapGet == false) then
			if ((TppMission.IsEnableAnyParentMissionObjective( "add_s10093_Container_A" ) == false) or 
				(TppMission.IsEnableAnyParentMissionObjective( "add_s10093_Container_B" ) == false)) then
				TppInterrogation.AddHighInterrogation(
					GameObject.GetGameObjectId( "mafr_lab_cp" ),
					{
						{ name = "enqt1000_106980", func = s10093_enemy.InterCall_container_pos01, },
						{ name = "enqt1000_106973", func = s10093_enemy.InterCall_captain_pos01, },
					}
				)
				TppInterrogation.AddHighInterrogation(
					GameObject.GetGameObjectId( "mafr_labJungle_cp" ),
					{
						{ name = "enqt1000_106980", func = s10093_enemy.InterCall_container_pos01, },
						{ name = "enqt1000_106973", func = s10093_enemy.InterCall_captain_pos01, },
					}
				)
			else
			end
		else
		end
	else
	end

	
	
	if ((svars.PreliminaryFlag03 == false) and (svars.PreliminaryFlag03 == false) and (svars.PreliminaryFlag05 == false)) then
		TppInterrogation.AddHighInterrogation(
			GameObject.GetGameObjectId( "mafr_lab_cp" ),
			{
				{ name = "enqt1000_106980", func = s10093_enemy.InterCall_container_pos01, },
				{ name = "enqt1000_106973", func = s10093_enemy.InterCall_capatin_pos01, },
			}
		)
		TppInterrogation.AddHighInterrogation(
			GameObject.GetGameObjectId( "mafr_labJungle_cp" ),
			{
				{ name = "enqt1000_106980", func = s10093_enemy.InterCall_container_pos01, },
				{ name = "enqt1000_106973", func = s10093_enemy.InterCall_capatin_pos01, },
			}
		)
	end

	
	Gimmick.SetFultonableContainerForMission( TARGET_GIMMICK_NAME.CNTN001,TARGET_SEARCHTARGET_NAME_LIST.CNTN001.FOX2NAME,0,false )
	Gimmick.SetFultonableContainerForMission( TARGET_GIMMICK_NAME.CNTN002,TARGET_SEARCHTARGET_NAME_LIST.CNTN002.FOX2NAME,0,false )

	
	TppRevenge.RegisterMissionMineList( this.MISSION_REVENGE_MINE_LIST )

	
	if(( svars.isNoContainerANotice == false ) and
		( svars.isNoContainerBNotice == false )) then
		
		TppEnemy.RegisterCombatSetting( s10093_enemy.combatSetting )
	elseif(( svars.isNoContainerANotice == true ) and
		( svars.isNoContainerBNotice == false )) then
		
		TppEnemy.RegisterCombatSetting( s10093_enemy.combatSetting01 )
	elseif(( svars.isNoContainerANotice == false ) and
		( svars.isNoContainerBNotice == true )) then
		
		TppEnemy.RegisterCombatSetting( s10093_enemy.combatSetting02 )
	elseif(( svars.isNoContainerANotice == true ) and
		( svars.isNoContainerBNotice == true )) then
		
		TppEnemy.RegisterCombatSetting( s10093_enemy.combatSetting03 )
	else
		
		TppEnemy.RegisterCombatSetting( s10093_enemy.combatSetting )
	end

end


this.OnEndMissionPrepareSequence = function ()

	
	if TppMission.IsMissionStart() then
		Fox.Log( "s10093_sequence ContainerRestore!!!!!" )
		this.commonContainerRestore()
	end

end





this.Messages = function() 
	return
	StrCode32Table {
		Player = {
			{
				msg = "PlayerCatchFulton",
				func = function( arg1,arg2 )		

					local sequence = TppSequence.GetCurrentSequenceName()
					
					if ( sequence == "Seq_Game_ContainerAGetAfter" )	then
						Fox.Log("RideOnContainer !!")
						
						svars.PreliminaryFlag06 = true
					elseif ( sequence == "Seq_Game_ContainerBGetAfter" )	then
						Fox.Log("RideOnContainer !!")
						
						svars.PreliminaryFlag06 = true
					elseif ( sequence == "Seq_Game_Escape" )	then
						Fox.Log("RideOnContainer !!")
						
						svars.PreliminaryFlag06 = true
					else
						Fox.Log("No RideOnContainer !!")
					end

				end
			},
			{
				msg = "GetIntel",
				sender = INTEL_SENDER_NAME.IN_TENT,
				func = function( intelNameHash )		
					Fox.Log( "#### s10093_sequence.GetIntelAtLabTent ####" )
					TppPlayer.GotIntel( intelNameHash )
					
					local func = function()
						this.commonMissionMapGet()
					end
					s10093_demo.GetIntel_inTent(func)
				end
			},
			{
				msg = "GetIntel",
				sender = INTEL_SENDER_NAME.IN_MANSION,
				func = function( intelNameHash )		
					Fox.Log( "#### s10093_sequence.GetIntelAtLabMansion ####" )
					TppPlayer.GotIntel( intelNameHash )
					
					local func = function()
						this.commonEnemyShiftGet()

						
						TppMission.UpdateObjective{
							objectives = { "clear_missionTask_04", },
						}

					end
					s10093_demo.GetIntel_inMansion(func)
				end
			},
			{
				
				msg = "LookingTarget",
				func = function( messageName, gameObjectId )
					this.CheckSearchTargetSimple( gameObjectId )
				end
			},
			{
				msg = "OnPickUpCollection",
				func = function( gameObjectId , collectionTypeId )
					
					Fox.Log( "#### s10093_sequence.onPickUpCollection ####" )
					Fox.Log("*** gameObjectId " .. tostring(gameObjectId) .. " ***")
					Fox.Log("*** collectionTypeId " .. tostring(collectionTypeId) .. " ***")
					if collectionTypeId == TppCollection.GetUniqueIdByLocatorName(DIAMOND_NAME) then
						Fox.Log( "#### s10093_sequence.onPickUpCollection TaskId ####" )
						
						TppMission.UpdateObjective{
							objectives = { "clear_missionTask_06" , },
						}
					else
						Fox.Log( "#### s10093_sequence.onPickUpCollection Not Target ####" )
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
		Marker = {
			{
				
				msg = "ChangeToEnable",
				func = function( gameObjectId, markType ,GameObjectId,MalkerById)
					Fox.Log("*** gameObjectId " .. tostring(gameObjectId) .. " ***")
					Fox.Log("*** makerType " .. tostring(markType) .. " ***")

					
					if markType == Fox.StrCode32("TYPE_ENEMY") then
						
						if MalkerById == StrCode32("Player")	then
							
							if ( svars.isEnemyInterrogation == false) then
								Fox.Log( "s10093_sequence No EnemyInterrogation !!!!!" )
								
								if (( TppMission.IsEnableMissionObjective( "add_s10093_Container_A" ) == false) or
									( TppMission.IsEnableMissionObjective( "add_s10093_Container_B" ) == false) or
									( TppMission.IsEnableMissionObjective( "get_s10093_Container_A" ) == false) or
									( TppMission.IsEnableMissionObjective( "get_s10093_Container_B" ) == false)) then
									if ( svars.PreliminaryFlag02 == false) then
										svars.PreliminaryFlag02 = true
										s10093_radio.InterrogationUrged()
									end
								else
									Fox.Log( "s10093_sequence add_s10093_Container_A and add_s10093_Container_B On !!!!!" )
								end
							else
								Fox.Log( "s10093_sequence EnemyInterrogation was !!!!!" )
							end
						else
							Fox.Log( "s10093_sequence Marked Not Enemy !!!!!" )
						end
					end
				end
			},
		},
		GameObject = {
			{
				msg = "Dead",
				sender = "sol_vip_0000",
				func = function ( GameObjectId01, GameObjectId02, phaseName )
					
					svars.PreliminaryFlag04 = true
					
					s10093_enemy.InterStop_captain_pos01()
				end
			},
			{
				msg = "ChangePhase",
				sender = "mafr_lab_cp",
				func = function ( GameObjectId, phaseName )
					if ( phaseName ~= TppGameObject.PHASE_SNEAK ) then
						this.commonSneakBreak()
					end
				end
			},
			{
				msg = "ChangePhase",
				sender = "mafr_labJungle_cp",
				func = function ( GameObjectId, phaseName )
					if ( phaseName ~= TppGameObject.PHASE_SNEAK ) then
						this.commonSneakBreak()
					end
				end
			},
			{
				msg = "ChangePhase",
				sender = "mafr_labWest_ob",
				func = function ( GameObjectId, phaseName )
					if ( phaseName ~= TppGameObject.PHASE_SNEAK ) then
						this.commonSneakBreak()
					end
				end
			},
			{
				msg = "ChangePhase",
				sender = "mafr_diamondNorth_ob",
				func = function ( GameObjectId, phaseName )
					if ( phaseName ~= TppGameObject.PHASE_SNEAK ) then
						this.commonSneakBreak()
					end
				end
			},
			{
				msg = "ChangePhase",
				sender = "mafr_19_29_lrrp",
				func = function ( GameObjectId, phaseName )
					if ( phaseName ~= TppGameObject.PHASE_SNEAK ) then
						this.commonSneakBreak()
					end
				end
			},
			{
				msg = "ChangePhase",
				sender = "mafr_18_19_lrrp",
				func = function ( GameObjectId, phaseName )
					if ( phaseName ~= TppGameObject.PHASE_SNEAK ) then
						this.commonSneakBreak()
					end
				end
			},
			
			{
				msg = "LostContainer",
				func = function ( GameObjectId, ContainerName )
					if ( ContainerName == StrCode32(TARGET_GIMMICK_NAME.CNTN001) ) then
						Fox.Log( "s10093_sequence LostContainer:Enemy No ContainerA Notice!!!!!" )
						svars.isNoContainerANotice = true
					elseif ( ContainerName == StrCode32(TARGET_GIMMICK_NAME.CNTN002) ) then
						Fox.Log( "s10093_sequence LostContainer:Enemy No ContainerB Notice!!!!!" )
						svars.isNoContainerBNotice = true
					else
						Fox.Log( "s10093_sequence LostContainer:Enemy Unkown Container Notice!!!!!" )
					end
					this.commonContainerNotice()
				end
			},
		},
		Radio = {
			
			
			{
				msg = "Finish",
				sender = "getContainer_2nd_enemy",
				func = function ()
					this.commonMissionTimeOverAfterB()
				end
			},
			
			{
				msg = "Finish",
				sender = "s0093_rtrg3020",
				func = function ()
					s10093_radio.XOFHeliNoStop()
				end
			},
			
			{
				msg = "Finish",
				sender = "s0093_rtrg0010",
				func = function ()
					s10093_radio.CargoFulton()
				end
			},
			
			{
				msg = "Finish",
				sender = "s0093_rtrg0034",
				func = function ()
					s10093_radio.JungleTalkAfter()
				end
			},
		},
		Timer = {
			
			{
				msg = "Finish",
				sender = "EmergencyCall",
				func = function ()
					this.commonEmergencyCall()
				end
			},
			
			{
				msg = "Finish",
				sender = "GameOverDemoPlay",
				func = function ()
					TppUI.FadeOut( TppUI.FADE_SPEED.FADE_NORMALSPEED, "GameOverDemoFadeOutFinish_2nd" ) 
				end,
				option = { isExecGameOver = true },
			},
			
			{
				msg = "Finish",
				sender = "HeliCamera",
				func = function ()
					
					TppPlayer.SetTargetHeliCamera{ gameObjectName = "EnemyHeli" , announceLog = "target_extract_failed" }
				end,
				option = { isExecGameOver = true },
			},
			
			{
				msg = "Finish",
				sender = "PlayerCamera",
				func = function ()
					
					s10093_enemy.EnemyHeliDisable()
					
					TppSoundDaemon.PostEvent( "sfx_e_heli_s10093_container" )
				end,
				option = { isExecGameOver = true },
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
		Trap = {
			
			{
				msg = "Enter",
				sender = TRAP_NAME.EVENT_JUNGLE_TALK,
				func = function ()
					if ( svars.isTrapEnterJungleTalk == false ) then
						svars.isTrapEnterJungleTalk = true
						s10093_radio.JungleTalk()
					end
				end
			},
		},
		UI = {
			{
				msg = "EndFadeOut",
				sender = "GameOverDemoFadeOutFinish_1st",
				func = function ()
					Fox.Log("######## s10093_sequence GameOverDemoFadeOutFinish_1st ########")
					this.MissionGameOverDemo()
				end,
				option = { isExecGameOver = true },
			},
			{
				msg = "EndFadeIn",
				sender = "GameOverDemoFadeInFinish",
				func = function ()
					Fox.Log("######## s10093_sequence GameOverDemoFadeInFinish ########")
				end,
				option = { isExecGameOver = true },
			},
			{
				msg = "EndFadeOut",
				sender = "GameOverDemoFadeOutFinish_2nd",
				func = function ()
					Fox.Log("######## s10093_sequence GameOverDemoFadeOutFinish_2nd ########")
					
					this.ResetCameraTarget()
					
					GkEventTimerManager.Start( "PlayerCamera", 0.3 )
				end,
				option = { isExecGameOver = true },
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

this.SetUpLocation = function ()
	Fox.Log("######## s10093_sequence SetUpLocation ########")
end






this.commonContainerRestore = function ()
	Gimmick.ResetGimmick(
		TppGameObject.GAME_OBJECT_TYPE_FULTONABLE_CONTAINER,
		TARGET_GIMMICK_NAME.CNTN001,
		TARGET_GIMMICK_PATH.CNTN001 )
	Gimmick.ResetGimmick(
		TppGameObject.GAME_OBJECT_TYPE_FULTONABLE_CONTAINER,
		TARGET_GIMMICK_NAME.CNTN002,
		TARGET_GIMMICK_PATH.CNTN002 )
end



this.commonMissionMapGet = function()
	
	

	
	
	svars.isMapGet = true
	
	svars.isOnGetIntel_AtinTent = true

	local sequence = TppSequence.GetCurrentSequenceName()
	if((sequence == "Seq_Game_ContainerGetBefore") or
		(sequence == "Seq_Game_ContainerAGetAfter") or
		(sequence == "Seq_Game_ContainerBGetAfter")) then

		if( svars.isEnemyInterrogation == true ) then
			
			s10093_radio.ContainerNoMarker()
		else
			if (( TppMission.IsEnableMissionObjective( "add_s10093_Container_A" ) == false) or
				( TppMission.IsEnableMissionObjective( "add_s10093_Container_B" ) == false)) then
				
				s10093_radio.ContainerMarkerFollow()
				this.commonMissionMapGetAfter()
			else
				
				s10093_radio.ContainerNoMarker()
			end
		end
	else
		
		s10093_radio.ContainerNoMarker()
	end

	
	svars.isEnemyInterrogation = true

	
	s10093_enemy.InterStop_container_pos01()

end



this.commonEnemyShiftGet = function()

	
	svars.isOnGetIntel_AtinMansion = true

	
	s10093_radio.EnemyShiftGet()

	
	this.commonEnemyShiftGetAfter()

end



this.commonMissionMapGetAfter = function()

	local objectivesTmp = ""

	
	if(( svars.isContainerAGet == false ) and ( svars.isContainerBGet == false ))then
		objectivesTmp = { "add_s10093_Container_A", "add_s10093_Container_B" }
	elseif(( svars.isContainerAGet == true ) and ( svars.isContainerBGet == false ))then
		objectivesTmp = { "add_s10093_Container_B" }
	elseif(( svars.isContainerAGet == false ) and ( svars.isContainerBGet == true ))then
		objectivesTmp = { "add_s10093_Container_A" }
	elseif(( svars.isContainerAGet == true ) and ( svars.isContainerBGet == true ))then
		objectivesTmp = {}
	end

	
	TppMission.UpdateObjective{
		
		objectives = objectivesTmp,
	}

	
	if(( svars.isContainerAGet == true ) and ( svars.isContainerBGet == true ))then
		Fox.Log( "s10093_sequence :Intel_File Invalid No Check Point!!!!!" )
	else
		Fox.Log( "s10093_sequence :Intel_File Validity Check Point!!!!!" )
		TppMission.UpdateCheckPointAtCurrentPosition()
	end

end



this.commonEnemyShiftGetAfter = function()
	
	
	Fox.Log( "s10093_sequence :All Enemy Marking!!!!!" )

	local j = 0
	for name, group in pairs( s10093_enemy.soldierDefine ) do
		j = j + 1
		for i = 1, #group do
			local EnemyTargetName = group[i]

			local gameObjectId = GameObject.GetGameObjectId( "TppSoldier2", EnemyTargetName )
			local command = {	id = "GetLifeStatus",	}
			local lifeStatus = GameObject.SendCommand( gameObjectId, command )

			if ( lifeStatus ~= TppGameObject.NPC_LIFE_STATE_DEAD ) then
				
				Fox.Log( "s10093_sequence Marking Enemy: " .. tostring(EnemyTargetName) )
				TppMarker.Enable( EnemyTargetName , 0, "none" , "map_and_world_only_icon" , 0 , false, false )
			else
				Fox.Log( "s10093_sequence Marking Enemy: " .. tostring(EnemyTargetName) .. " Dead" )
			end

		end
	end

	
	TppMission.UpdateCheckPointAtCurrentPosition()

end







this.EnemyInterrogationCaptain = function()
	TppMission.UpdateObjective{
		
		objectives = { "add_s10093_ZRS_Captain" },
	}
end



this.commonEnemyInterrogation = function()

	if( svars.isEnemyInterrogation == false ) then
		
		
		svars.isEnemyInterrogation = true
		if( svars.isMapGet == false ) then
			if(( svars.isContainerAGet == true ) and
				( svars.isContainerBGet == true )) then
				
			else
				
				this.commonEnemyInterrogationAfter()
			end
		else
			
		end
	else
		
	end

end



this.commonEnemyInterrogationAfter = function()

	local objectivesTmp = ""

	
	if(( svars.isContainerAGet == false ) and ( svars.isContainerBGet == false ))then
		objectivesTmp = { "add_s10093_Container_A", "add_s10093_Container_B" }
	elseif(( svars.isContainerAGet == true ) and ( svars.isContainerBGet == false ))then
		objectivesTmp = { "add_s10093_Container_B" }
	elseif(( svars.isContainerAGet == false ) and ( svars.isContainerBGet == true ))then
		objectivesTmp = { "add_s10093_Container_A" }
	elseif(( svars.isContainerAGet == true ) and ( svars.isContainerBGet == true ))then
		objectivesTmp = {}
	end

	
	s10093_radio.EnemyInterrogationKazuFollow()
	TppMission.UpdateObjective{
		
		objectives = objectivesTmp,
	}

end




this.commonEmergencyCall = function()

	Fox.Log( "s10093_sequence.Kazu Emergency Call !!!!!")

	
	s10093_radio.EmergencyCall()

	
	this.commonEmergencyCallAfter()

	
	TppRadio.SetOptionalRadio("Set_s0093_oprg3010")

end



this.commonEmergencyCallAfter = function()

	TppUI.StartDisplayTimer{
		svarsName = "displayTimeSec",
		cautionTimeSec = COUNTER_LIST.TIME_OVER_RED_COUNT,
	}
	
	TppUiCommand.SetDisplayTimerText( "timeCount_10093_00" )	

end




this.MissionGameOverDemo = function()

	Fox.Log( "s10093_sequence.MissionGameOverDemo !!!!!")

	
	s10093_enemy.EnemyHeliAround()

	
	TppUI.FadeIn( TppUI.FADE_SPEED.FADE_NORMALSPEED, "GameOverDemoFadeInFinish" )

	
	GkEventTimerManager.Start( "HeliCamera", 0.3 )

	
	GkEventTimerManager.Start( "GameOverDemoPlay", 7 )

end



this.ResetCameraTarget = function()

	Fox.Log( "s10093_sequence.ResetCameraTarget !!!!!")

	local gameObjectId = GameObject.GetGameObjectId( "Player" )
	Player.RequestToPlayCameraNonAnimation{
		characterId = gameObjectId, 
		isFollowPos = false,	
		isFollowRot = true,	
		followTime = 7,	
		followDelayTime = 0.1,	
		




		candidateRots = { {120, -50},},
		skeletonNames = {"SKL_004_HEAD",},	
		



		skeletonCenterOffsets = { Vector3(0,0,0), Vector3(0,0,0), Vector3(0,0,0), Vector3(0,0,0), Vector3(0,0,0) },
		skeletonBoundings = { Vector3(0,0.45,0), Vector3(0,0,0), Vector3(0,0,0), Vector3(0, -0.3,0), Vector3(0, -0.3, 0) },
		offsetPos = Vector3(0.4,1.3,-2.0),	
		focalLength = 30.0,	
		aperture = 10.000,	
		timeToSleep = 10,	
		fitOnCamera = false,	
		timeToStartToFitCamera = 0.01,	
		fitCameraInterpTime = 0.24,	
		diffFocalLengthToReFitCamera = 16,	
	}

end




this.commonMissionTimeOver = function()

	Fox.Log( "s10093_sequence.Withdrawal Enemy Arrival !!!!!")

	
	if( svars.isClear == false ) then

		Fox.Log( "s10093_sequence.Container Remain Mission Fail !!!!!")

		
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_ESCAPE_BY_HELI, TppDefine.GAME_OVER_RADIO.OTHERS )

	else

		Fox.Log( "s10093_sequence.Container Get Mission Ready To Clear !!!!!")

	end
end



this.commonMissionTimeOverAfterA = function()

	
	if( svars.isChaseMode == false ) then
		svars.isChaseMode = true



		this.commonMissionTimeOverAfterB()

	end

end



this.commonMissionTimeOverAfterB = function()

	
	s10093_radio.ContainerGetTeam_B2()

end






this.commonSneakBreak = function()

	Fox.Log( "s10093_sequence.Caution Or more !!!!!")

	
	if( svars.isSneakBreak == false ) then

		
		svars.isSneakBreak = true
		svars.isFirstRouteChange = true

		

		
		this.commonEnemyRouteShift()

	end

end




this.commonSneakBreakKazuRadio = function()

	
	s10093_radio.EnemySneakBreakK()

end




this.commonContainerNotice = function()

	
	if(( svars.isNoContainerANotice == true ) and
		( svars.isNoContainerBNotice == false )) then

		Fox.Log( "s10093_sequence LostContainer:Enemy No ContainerA Notice Radio !!!!!" )

		

		
		this.commonEnemyRouteShift()


	elseif(( svars.isNoContainerANotice == false ) and
		( svars.isNoContainerBNotice == true )) then

		Fox.Log( "s10093_sequence LostContainer:Enemy No ContainerB Notice Radio !!!!!" )

		

		
		this.commonEnemyRouteShift()

	elseif(( svars.isNoContainerANotice == true ) and
		( svars.isNoContainerBNotice == true )) then

		Fox.Log( "s10093_sequence LostContainer:Enemy No All Container Notice Radio !!!!!" )

		
		this.commonMissionTimeOverAfterA()

		
		s10093_enemy.ReadyToClear()

	
	Fox.Log( "s10093_sequence.Enemy Jungle Blockade Route&GuardTarget Change !!!!!")

	else

		Fox.Log( "s10093_sequence LostContainer:Funny Case !!!!!" )

		
		
		this.commonEnemyRouteShift()

	end
end




this.commonEnemyRouteShift = function()

	
	if(( svars.isNoContainerANotice == false ) and
		( svars.isNoContainerBNotice == false )) then

		Fox.Log( "s10093_sequence Sneak Break:Route&GuardTarget Change !!!!!" )

		
		
		s10093_enemy.RouteChangeOn()

	elseif(( svars.isNoContainerANotice == true ) and
		( svars.isNoContainerBNotice == false )) then

		Fox.Log( "s10093_sequence LostContainer:Enemy No ContainerA Notice Route&GuardTarget Change !!!!!" )

		
		
		s10093_enemy.ContainerAGetAfter()

	elseif(( svars.isNoContainerANotice == false ) and
		( svars.isNoContainerBNotice == true )) then

		Fox.Log( "s10093_sequence LostContainer:Enemy No ContainerB Notice Route&GuardTarget Change !!!!!" )

		
		
		s10093_enemy.ContainerBGetAfter()

	elseif(( svars.isNoContainerANotice == true ) and
		( svars.isNoContainerBNotice == true )) then

		Fox.Log( "s10093_sequence LostContainer:Enemy No All Container Notice Route&GuardTarget Change !!!!!" )

		
		
		s10093_enemy.ReadyToClear()

	else

		Fox.Log( "s10093_sequence LostContainer:Funny Case !!!!!" )

		
		s10093_enemy.RouteChangeOn()

	end

end



function this.SetSearchTarget()
	Fox.Log( "s10093_sequence SetSearchTarge" )
	for key, gimmickSetting in pairs(gimmickSettingTable)  do
		if not svars[gimmickSetting.getFlagName] then
			TppPlayer.SetSearchTarget(
				gimmickSetting.gameObjectName,
				gimmickSetting.gameObjectType,
				gimmickSetting.messageName,
				nil,
				gimmickSetting.offSet,
				gimmickSetting.fox2Name,
				gimmickSetting.doDirectionCheck
			)
		end
	end
end




function this.CheckSearchTarget( gameObjectId )


	local ret,gameObjectId01 = TppGimmick.GetGameObjectId( "lab_cntn001" )
	local ret,gameObjectId02 = TppGimmick.GetGameObjectId( "lab_cntn002" )

	Fox.Log( "s10093_sequence LookingTarget: " .. gameObjectId )
	Fox.Log( "s10093_sequence LookingTarget01: " .. gameObjectId01 )
	Fox.Log( "s10093_sequence LookingTarget02: " .. gameObjectId02 )

	local objectives
	local SearchTargetSettingData
	
	for key, SearchTargetSetting in pairs(gimmickSettingTable)  do

		Fox.Log( "s10093_sequence gimmickSettingTable LookingTarget: " .. SearchTargetSetting.gameObjectName )
		Fox.Log( "s10093_sequence gimmickSettingTable LookingTarget: " .. tostring(svars[SearchTargetSetting.markFlagName]) )

		if svars[SearchTargetSetting.markFlagName] == false then
			svars[SearchTargetSetting.markFlagName] = true
			SearchTargetSettingData = SearchTargetSetting

			if (gameObjectId == gameObjectId01) then
				Fox.Log("######## s10093_sequence LookingTarget Container_A ########")
				TppMission.UpdateObjective{
					
					objectives = { "add_s10093_Container_A", },
				}
				
				TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
			elseif (gameObjectId == gameObjectId02) then
				Fox.Log("######## s10093_sequence LookingTarget Container_B ########")
				TppMission.UpdateObjective{
					
					objectives = { "add_s10093_Container_B", },
				}
				
				TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
			else
				Fox.Log("######## s10093_sequence LookingTarget Not Container ########")
			end

			break
		else
			break
		end
	end
	
	if SearchTargetSettingData == nil then 
		return 
	end

end



function this.CheckSearchTargetSimple( gameObjectId )

	local ret,gameObjectId01 = TppGimmick.GetGameObjectId( "lab_cntn001" )
	local ret,gameObjectId02 = TppGimmick.GetGameObjectId( "lab_cntn002" )

	if (gameObjectId == gameObjectId01) then
		if(svars.isMarkTargetContainer001 == false) then
			Fox.Log("######## s10093_sequence LookingTarget Container_A ########")
			svars.isMarkTargetContainer001 = true
			TppMission.UpdateObjective{
				
				objectives = { "add_s10093_Container_A", },
			}
			
			TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
		end
	elseif (gameObjectId == gameObjectId02) then
		if(svars.isMarkTargetContainer002 == false) then
			Fox.Log("######## s10093_sequence LookingTarget Container_B ########")
			svars.isMarkTargetContainer002 = true
			TppMission.UpdateObjective{
				
				objectives = { "add_s10093_Container_B", },
			}
			
			TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
		end
	else
		Fox.Log("######## s10093_sequence LookingTarget Not Container ########")
	end
end










this.MissionPrepare = function()

	Fox.Log( "s10093_sequence MissionPrepare !!!!!" )

	


	
	TppRatBird.EnableRat()

	
	TppRatBird.EnableBird("TppStork")

	
	TppMission.RegisterMissionSystemCallback{
		OnSetMissionFinalScore = function( missionClearType )
			Fox.Log("!!!! s10093_mission.clear_missionTask_03 check !!!! isNoContainerANotice = " .. tostring(svars.isNoContainerANotice) )
			Fox.Log("!!!! s10093_mission.clear_missionTask_03 check !!!! isNoContainerBNotice = " .. tostring(svars.isNoContainerBNotice) )
			
			if(( svars.isNoContainerANotice == false ) and
				( svars.isNoContainerBNotice == false )) then
				
				TppMission.UpdateObjective{
					objectives = { "clear_missionTask_03", },
				}
				
				TppResult.AcquireSpecialBonus{
					second = { isComplete = true },
				}
			end
			
			if missionClearType == TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_FULTON_CONTAINER then
				
				TppMission.UpdateObjective{
					objectives = { "clear_missionTask_02", },
				}
				
				TppResult.AcquireSpecialBonus{
					first = { isComplete = true },
				}
			end
		end,
		OnEstablishMissionClear = function( missionClearType )
			Fox.Log("*** " .. missionClearType .. " OnEstablishMissionClear ***")
			
			Fox.Log("!!!! s10093_mission.clear !!!! missionClearType = " .. missionClearType )
			Fox.Log("*** OnEstablishMissionClear ***")
			
			s10093_radio.OnGameCleared()

			if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
				TppPlayer.PlayMissionClearCamera()
				TppMission.MissionGameEnd{
					loadStartOnResult = true,
					fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,
					delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
				}
			elseif missionClearType == TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_FULTON_CONTAINER then
				TppMission.MissionGameEnd{
					loadStartOnResult = true,
					delayTime = 4,
				}
			else
				TppMission.MissionGameEnd{ loadStartOnResult = true }
			end
		end,
		OnRecovered = function( gameObjectId )
			
			Fox.Log("##** OnRecovered_is_coming ####")
			if gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", ZRS_CAPTAIN ) then
				Fox.Log("##** OnRecovered ZRS_CAPTAIN ####")

				
				s10093_enemy.InterStop_captain_pos01()

				
				TppMission.UpdateObjective{
					objectives = { "clear_missionTask_05" , },
				}
			else
				Fox.Log("##** OnRecovered Not Target ####")
			end
		end,
		CheckMissionClearOnRideOnFultonContainer = function()
			local getContainer001, getContainer002 =  svars.isGetTargetContainer001, svars.isGetTargetContainer002
			Fox.Log("CheckMissionClearOnRideOnFultonContainer : isGetTargetContainer001 = " .. tostring(getContainer001) .. ", isGetTargetContainer002 = " .. tostring(getContainer002) )
			return ( getContainer001 or getContainer002)
		end,
		OnGameOver = this.OnGameOver,
	}

	
	
	TppPlayer.AddTrapSettingForIntel{
		intelName			= INTEL_SENDER_NAME.IN_TENT,	
		autoIcon			= true,
		identifierName		= "GetIntelIdentifier",
		locatorName			= "GetIntel_inTent",
		gotFlagName			= "isOnGetIntel_AtinTent",		
		trapName			= TRAP_NAME.IN_TENT,			
		markerObjectiveName	= "intelFile_lab_Tent",			
		markerTrapName		= TRAP_NAME.IN_TENT_MARKER,		

	}
	TppPlayer.AddTrapSettingForIntel{
		intelName			= INTEL_SENDER_NAME.IN_MANSION,	
		autoIcon			= true,
		identifierName		= "GetIntelIdentifier",
		locatorName			= "GetIntel_inMansion",
		gotFlagName			= "isOnGetIntel_AtinMansion",	
		trapName			= TRAP_NAME.IN_MANSION,			
		markerObjectiveName	= "intelFile_lab_Mansion",		
		markerTrapName		= TRAP_NAME.IN_MANSION_MARKER,	

	}

end

this.OnGameOver = function( gameOverType )
	Fox.Log("!!!! s10093_mission.OnGameOver !!!! gameOverType = " .. tostring(gameOverType) )
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_ESCAPE_BY_HELI ) then
		
		
		TppUI.FadeOut( TppUI.FADE_SPEED.FADE_NORMALSPEED, "GameOverDemoFadeOutFinish_1st" ) 

		TppMission.ShowGameOverMenu{
			delayTime = 17
		}
		return true
	end

end





this.OnSkipEnterCommon = function()
	Fox.Log( "=== s10093_sequence : OnSkipEnterCommon ===" )
	local sequence = TppSequence.GetCurrentSequenceName()
end


this.OnSkipUpdateCommon = function()
end


this.OnSkipLeaveCommon = function()
end






this.commonMissionFailure = function( esmanager, messageId, message )
end







sequences.Seq_Game_ContainerGetBefore = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				
				{
					msg = "Fulton",
					func = function ( GameObjectId, ContainerName )
						if ( ContainerName == StrCode32(TARGET_GIMMICK_NAME.CNTN001) ) or
							( ContainerName == StrCode32(TARGET_GIMMICK_NAME.CNTN002) ) then
							
							TppMission.UpdateObjective{
								objectives = { "announce_recoverTarget01" },
							}
							TppUI.ShowAnnounceLog( "achieveObjectiveCount", 1, 2 )
							if ( ContainerName == StrCode32(TARGET_GIMMICK_NAME.CNTN001) ) then
								sequences.Seq_Game_ContainerGetBefore.FuncContainerAGet()
							elseif ( ContainerName == StrCode32(TARGET_GIMMICK_NAME.CNTN002) ) then
								sequences.Seq_Game_ContainerGetBefore.FuncContainerBGet()
							end
						end
					end
				},
				
				{
					msg = "RadioEnd",
					func = function( GameObjectId, cpGameObjectId, speechLabel, isSuccess )
						Fox.Log( "*** ConversationEnd ***")
						if speechLabel == StrCode32( "CPR0570FOB" ) then
							sequences.Seq_Game_ContainerGetBefore.FuncRCKazuFollow()
						end
					end
				},
			},
			Radio = {
				
				{
					msg = "Finish",
					sender = "enemyRouteChange_Trap",
					func = function ()

					end
				},
			},
			Trap = {
				
				{
					msg = "Enter",
					sender = TRAP_NAME.EVENT_ROUTE_CHANGE,
					func = function ()
						Fox.Log( "s10093_sequence isTrapEnterRouteChange:" .. tostring(svars.isTrapEnterRouteChange) )
						if ( svars.isTrapEnterRouteChange == false ) then
							svars.isTrapEnterRouteChange = true
							sequences.Seq_Game_ContainerGetBefore.FuncRouteChange()

							
							GkEventTimerManager.Start( "ForEnemyHeli", 120 )

						end
					end
				},
			},
			Timer = {
				
				{
					msg = "Finish",
					sender = "ForEnemyHeli",
					func = function ()
						s10093_radio.ForEnemyHeli()
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

		Fox.Log( "s10093_sequence MissionStart !!!!!" )

		
		this.SetSearchTarget()

		
		
		TppRadio.SetOptionalRadio("Set_s0093_oprg0011")

		
		TppTelop.StartCastTelop()

		


		
		TppMission.UpdateObjective{
			objectives = { "default_photo_target_a","default_photo_target_b","target_area_cp", },
		}
		
		TppMission.UpdateObjective{
			objectives = { "default_missionTask_01", "default_missionTask_02", "default_missionTask_03", "default_missionTask_04", "default_missionTask_05", "default_missionTask_06", },
		}
		
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = { "s0093_rtrg0010" },	
			},
			
			objectives = { "default_area_lab", },
			options = { isMissionStart = true },
		}

		
		if TppSequence.GetContinueCount() > 0 then
			s10093_radio.ContinueMissionStart()
		else
			Fox.Log( "s10093_sequence No Continue !!!!!" )
		end

	end,

	OnLeave = function ()
		
		TppMission.UpdateCheckPointAtCurrentPosition()
	end,

	FuncRouteChange = function()
		
		if( svars.isFirstRouteChange == false ) then

			
			svars.isFirstRouteChange = true

			
			s10093_radio.EnemyRouteChangeE()

			
			Fox.Log( "s10093_sequence s10093_enemy.RouteChangeOn !!!!!" )
			s10093_enemy.RouteChangeOn()

		end
	end,

	FuncRCKazuFollow = function()
		
		s10093_radio.EnemyRouteChangeK()
	end,


	
	FuncContainerAGet = function()
		svars.isContainerAGet = true
		TppSequence.SetNextSequence( "Seq_Game_ContainerAGetAfter" )
	end,

	
	FuncContainerBGet = function()
		svars.isContainerBGet = true
		TppSequence.SetNextSequence( "Seq_Game_ContainerBGetAfter" )
	end,

}



sequences.Seq_Game_ContainerAGetAfter = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{
					msg = "Fulton",
					func = function ( GameObjectId, ContainerName )
						if ( ContainerName == StrCode32(TARGET_GIMMICK_NAME.CNTN002) ) then
							
							TppMission.UpdateObjective{
								objectives = { "announce_recoverTarget02" },
							}
							TppUI.ShowAnnounceLog( "achieveObjectiveCount", 2, 2 )
							
							TppMission.UpdateObjective{
								objectives = { "clear_missionTask_01", },
							}
							sequences.Seq_Game_ContainerAGetAfter.FuncContainerBGet()
						end
					end
				},
			},
			UI = {
				{
					msg = "DisplayTimerTimeUp",
					func = function ()
						this.commonMissionTimeOver()
					end
				},
				{
					msg = "DisplayTimerLap",
					func = function ( RestTime , PassTime )
						if	RestTime == 420		then	
							s10093_radio.MoreTimeOver01()
						elseif	RestTime == 300		then	
							s10093_radio.MoreTimeOver02()
						elseif	RestTime == 180		then	
							s10093_radio.MoreTimeOver03()
						else
							
						end
					end
				},
				nil
			},
			nil
		}
	end,

	OnEnter = function()

		
		this.SetSearchTarget()

		
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = "s0093_rtrg3010",
			},
			
			objectives = { 	"get_s10093_Container_A", },
		}

		
		if( svars.isCountDownStart == false ) then
			
			svars.isCountDownStart = true
			GkEventTimerManager.Start( "EmergencyCall", COUNTER_LIST.EMERGENCY_CALL_TIME )
		end

		
		if TppSequence.GetContinueCount() > 0 then

			Fox.Log( "s10093_sequence Continue Seq_Game_ContainerAGetAfter !!!!!" )

			
			if svars.displayTimeSec < COUNTER_LIST.TIME_OVER_COUNT_MIN then
				svars.displayTimeSec = COUNTER_LIST.TIME_OVER_COUNT_MIN
			end

			
			this.commonEmergencyCall()
		else
			Fox.Log( "s10093_sequence No Continue !!!!!" )
		end

	end,

	OnLeave = function ()
		
		TppMission.UpdateCheckPointAtCurrentPosition()
	end,

	
	FuncContainerBGet = function()
		svars.isClear = true
		svars.isContainerBGet = true
		TppSequence.SetNextSequence( "Seq_Game_Escape" )
	end,

}



sequences.Seq_Game_ContainerBGetAfter = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				
				{
					msg = "Fulton",
					func = function ( GameObjectId, ContainerName )
						if ( ContainerName == StrCode32(TARGET_GIMMICK_NAME.CNTN001) ) then
							
							TppMission.UpdateObjective{
								objectives = { "announce_recoverTarget02" },
							}
							TppUI.ShowAnnounceLog( "achieveObjectiveCount", 2, 2 )
							
							TppMission.UpdateObjective{
								objectives = { "clear_missionTask_01", },
							}
							sequences.Seq_Game_ContainerBGetAfter.FuncContainerAGet()
						end
					end
				},
			},
			UI = {
				{
					msg = "DisplayTimerTimeUp",
					func = function ()
						this.commonMissionTimeOver()
					end
				},
				{
					msg = "DisplayTimerLap",
					func = function ( RestTime , PassTime )
						if	RestTime == 420		then	
							s10093_radio.MoreTimeOver01()
						elseif	RestTime == 300		then	
							s10093_radio.MoreTimeOver02()
						elseif	RestTime == 180		then	
							s10093_radio.MoreTimeOver03()
						else
							
						end
					end
				},
				nil
			},
			nil
		}
	end,

	OnEnter = function()

		
		this.SetSearchTarget()

		
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = "s0093_rtrg3010",
			},
			
			objectives = { 	"get_s10093_Container_B", },
		}

		
		if( svars.isCountDownStart == false ) then
			
			svars.isCountDownStart = true
			GkEventTimerManager.Start( "EmergencyCall", COUNTER_LIST.EMERGENCY_CALL_TIME )
		end

		
		if TppSequence.GetContinueCount() > 0 then

			Fox.Log( "s10093_sequence Continue Seq_Game_ContainerBGetAfter !!!!!" )

			
			if svars.displayTimeSec < COUNTER_LIST.TIME_OVER_COUNT_MIN then
				svars.displayTimeSec = COUNTER_LIST.TIME_OVER_COUNT_MIN
			end

			
			this.commonEmergencyCall()
		else
			Fox.Log( "s10093_sequence No Continue !!!!!" )
		end

	end,

	OnLeave = function ()
		
		TppMission.UpdateCheckPointAtCurrentPosition()
	end,

	
	FuncContainerAGet = function()
		svars.isClear = true
		svars.isContainerAGet = true
		TppSequence.SetNextSequence( "Seq_Game_Escape" )
	end,

}



sequences.Seq_Game_Escape = {

	OnEnter = function()

		
		TppUiCommand.EraseDisplayTimer()			
		TppUiCommand.SetDisplayTimerText( "" )		

		
		TppRadio.SetOptionalRadio("Set_s0093_oprg4010")

		
		s10093_enemy.InterStop_container_pos01()

		
		TppMission.CanMissionClear()

		Fox.Log("!!!! s10093_mission.Escape check !!!! PreliminaryFlag06 = " .. tostring(svars.PreliminaryFlag06) )

		
		local EscapeRadio = ""
		if(svars.PreliminaryFlag06 == true)then
			
			EscapeRadio = "f1000_rtrg2500"
		else
			
			EscapeRadio = "s0093_rtrg4010"
		end

		
		TppMission.UpdateObjective{
			radio = {
				
				radioGroups = EscapeRadio,
			},
			
			objectives = { "rv_missionClear" },
		}

		
		TppUiCommand.ShowHotZone()

		
		if TppSequence.GetContinueCount() > 0 then
			s10093_radio.ContinueClearText()
		else
			Fox.Log( "s10093_sequence No Continue !!!!!" )
		end

	end,

	OnLeave = function()
	end,

	OnUpdate = function()
	end,

}




return this
