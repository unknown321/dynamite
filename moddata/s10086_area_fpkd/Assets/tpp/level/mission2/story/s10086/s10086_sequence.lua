local s10086_sequence = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}




s10086_sequence.CONVERSATION_TYPE = Tpp.Enum{
	"SWAMP_WEST_NEAR",
	"SWAMP_WEST",
	"SWAMP1",
	"SWAMP2",
	"SWAMP3",
	"TARGET",
}

local SPEECH_TABLE = {
	[ s10086_sequence.CONVERSATION_TYPE.SWAMP_WEST_NEAR ] = { id = "CT10086_01", message = "Interrogation1End" },
	[ s10086_sequence.CONVERSATION_TYPE.SWAMP_WEST ] = {
		id = {
			"CT10086_02",
			"CT10086_02_a",
			"CT10086_02_01",
			"CT10086_02_b",
			"CT10086_02_02",
			"CT10086_02_c",
			"CT10086_02_03",
			"CT10086_02_d",
			"CT10086_02_04",
			"CT10086_02_e",
			"CT10086_02_05",
			"CT10086_02_f",
			"CT10086_02_07",
			"CT10086_02_h",
			"CT10086_02_08",
			"CT10086_02_i",
			"CT10086_02_09",
		},
		message = "Interrogation2End",
	},
	[ s10086_sequence.CONVERSATION_TYPE.SWAMP1 ] = {
		id = {
			"CT10086_03_01",
			"CT10086_03_01_a",
			"CT10086_03_01_001",
			"CT10086_03_01_b",
			"CT10086_03_01_c",
			"CT10086_03_01_002",
			"CT10086_03_01_d",
			"CT10086_03_01_003",
			"CT10086_03_01_e",
			"CT10086_03_01_004",
			"CT10086_03_01_f",
			"CT10086_03_01_005",
			"CT10086_03_01_g",
			"CT10086_03_01_h",
			"CT10086_03_01_i",
			"CT10086_03_01_006",
			"CT10086_03_01_j",
			"CT10086_03_01_007",
		},
		message = "Interrogation3End",
	},
	[ s10086_sequence.CONVERSATION_TYPE.SWAMP2 ] = {
		id = {
			"CT10086_03_02",
			"CT10086_03_02_a",
			"CT10086_03_02_001",
			"CT10086_03_02_b",
			"CT10086_03_02_002",
			"CT10086_03_02_c",
			"CT10086_03_02_003",
			"CT10086_03_02_d",
			"CT10086_03_02_004",
			"CT10086_03_02_e",
			"CT10086_03_02_005",
			"CT10086_03_02_f",
			"CT10086_03_02_006",
			"CT10086_03_02_g",
			"CT10086_03_02_007",
		},
		message = "Interrogation3End",
	},
	[ s10086_sequence.CONVERSATION_TYPE.SWAMP3 ] = {
		id = {
			"CT10086_03_03",
			"CT10086_03_03_a",
			"CT10086_03_03_001",
			"CT10086_03_03_b",
			"CT10086_03_03_002",
			"CT10086_03_03_c",
			"CT10086_03_03_003",
			"CT10086_03_03_d",
			"CT10086_03_03_004",
			"CT10086_03_03_e",
			"CT10086_03_03_005",
		},
		message = "Interrogation3End",
	},
	[ s10086_sequence.CONVERSATION_TYPE.TARGET ] = {
		id = {
			"CT10086_04",
			"CT10086_04_a",
			"CT10086_04_001",
			"CT10086_04_b",
			"CT10086_04_002",
			"CT10086_04_c",
			"CT10086_04_003",
			"CT10086_04_d",
			"CT10086_04_004",
			"CT10086_04_e",
			"CT10086_04_005",
			"CT10086_04_f",
			"CT10086_04_006",
			"CT10086_04_g",
			"CT10086_04_007",
			"CT10086_04_h",
			"CT10086_04_008",
			"CT10086_04_i",
			"CT10086_04_009",
			"CT10086_04_j",
			"CT10086_04_010",
			"CT10086_04_k",
			"CT10086_04_011",
			"CT10086_04_l",
			"CT10086_04_012",
			"CT10086_04_m",
			"CT10086_04_013",
			"CT10086_04_n",
			"CT10086_04_014",
		},
		message = "Interrogation4End",
	},
}
local SPEECH_MESSAGE_MAP = {}
for interrogationId, interrogationTable in pairs( SPEECH_TABLE ) do
	local speechLabelList = interrogationTable.id
	if not Tpp.IsTypeTable( speechLabelList ) then
		speechLabelList = { speechLabelList }
	end
	SPEECH_MESSAGE_MAP[ Fox.StrCode32( speechLabelList[ #speechLabelList ] ) ] = Fox.StrCode32( interrogationTable.message )
end
local MONOLOGUE_TABLE = {}	


local MISSION_TASK_CONTAINER_LIST = {
	"swamp_cntn001",
	"swamp_cntn002",	
	"swamp_cntn003",
	"swamp_cntn004",
}



s10086_sequence.routeChangeTableRoot = {}
s10086_sequence.searchTargetTable = {}
s10086_sequence.afterRecognizeFuncTable = {}
s10086_sequence.CONVERSATION_ENEMY_TABLE = {}




s10086_sequence.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true








function s10086_sequence.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		"Seq_Game_SearchTarget",
		"Seq_Game_Escape",
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





s10086_sequence.missionStartPosition = {
	orderBoxList = {
		"box_s10086_00",
	},
	helicopterRouteList = {
		"lz_drp_swamp_S0000|rt_drp_swamp_S_0000",
		"lz_drp_swamp_I0000|rt_drp_swamp_I_0000",
	},
}




s10086_sequence.GetRecognizedFlagName = function( locatorName )

	Fox.Log( "s10086_sequence.GetRecognizedFlagName(): locatorName:" .. tostring( locatorName ) )
	return "is_" .. locatorName .. "_recognized"

end




s10086_sequence.GetRecoveredFlagName = function( locatorName )

	Fox.Log( "s10086_sequence.GetRecoveredFlagName(): locatorName:" .. tostring( locatorName ) )
	return "is_" .. locatorName .. "_recovered"

end


s10086_sequence.saveVarsList = {
	isInterpreterRescued		= false,	
	dayCount					= 0,		
	fakeHostageMarkedCount		= 0,		
	interpreterInterrogationCount = 0,	
	[ s10086_sequence.GetRecognizedFlagName( "sol_interpreter" ) ] = false,
	[ s10086_sequence.GetRecognizedFlagName( "hos_mis_0000" ) ] = false,
	[ s10086_sequence.GetRecognizedFlagName( "hos_mis_0001" ) ] = false,
	[ s10086_sequence.GetRecognizedFlagName( "hos_mis_0002" ) ] = false,
	[ s10086_sequence.GetRecognizedFlagName( "hos_mis_0003" ) ] = false,
	[ s10086_sequence.GetRecoveredFlagName( "sol_interpreter" ) ] = false,
	[ s10086_sequence.GetRecoveredFlagName( "hos_mis_0000" ) ] = false,
	[ s10086_sequence.GetRecoveredFlagName( "hos_mis_0001" ) ] = false,
	[ s10086_sequence.GetRecoveredFlagName( "hos_mis_0002" ) ] = false,
	[ s10086_sequence.GetRecoveredFlagName( "hos_mis_0003" ) ] = false,
	isTargetInRoom				= false,
	isTargetDead				= false,
	isPlayerInRoom				= false,
	nightCount					= 0,
	reservedNumber0000 = 0,	
	reservedNumber0001 = 0,	
	reservedNumber0002 = 0,	
	reservedNumber0003 = 0,
	reservedNumber0004 = 0,
	reservedNumber0005 = 0,
	reservedNumber0006 = 0,
	reservedNumber0007 = 0,
	reservedNumber0008 = 0,
	reservedNumber0009 = 0,
	reservedBoolean0000 = false,	
	reservedBoolean0001 = false,	
	reservedBoolean0002 = false,	
	reservedBoolean0003 = false,	
	reservedBoolean0004 = false,	
	reservedBoolean0005 = false,	
	reservedBoolean0006 = false,	
	reservedBoolean0007 = false,	
	reservedBoolean0008 = false,	
	reservedBoolean0009 = false,	
}


s10086_sequence.checkPointList = {
	"CHK_MissionStart",			
	nil,
}


s10086_sequence.baseList = {
	"swamp",
	"swampEast",
	"swampSouth",
	"swampWest",
	"pfCampNorth",
	nil
}





local PHOTO_ID_TARGET = 20
local PHOTO_ID_INTERPRETER = 10




s10086_sequence.missionObjectiveDefine = {
	marker_target = {
		gameObjectName = "hos_mis_0000", visibleArea = 2, randomRange = 2, setNew = true, langId = "marker_info_mission_targetArea", viewType = "all", announceLog = "updateMap",
	},
	marker_fake_target1 = {
		gameObjectName = "hos_mis_0001", visibleArea = 2, randomRange = 2, setNew = true, langId = "marker_info_mission_targetArea", viewType = "all", announceLog = "updateMap",
	},
	marker_fake_target2 = {
		gameObjectName = "hos_mis_0002", visibleArea = 2, randomRange = 2, setNew = true, langId = "marker_info_mission_targetArea", viewType = "all", announceLog = "updateMap",
	},
	marker_fake_target3 = {
		gameObjectName = "hos_mis_0003", visibleArea = 2, randomRange = 2, setNew = true, langId = "marker_info_mission_targetArea", viewType = "all", announceLog = "updateMap",
	},
	route_target = {
		announceLog = "updateMap",
		showEnemyRoutePoints = {
			groupIndex = 0,
			width=20.00,
			langId="marker_target_forecast_path",
			points={
				Vector3( -115.85575866699, 2.990758895874, -321.54989624023 ),
				Vector3( -132.09330749512, 3.5826728343964, -317.63549804688 ),
				Vector3( -163.95477294922, 2.7611389160156, -300.79254150391 ),
				Vector3( -193.12799072266, 2.3538358211517, -293.78698730469 ),
				Vector3( -242.83557128906, 3.3884887695313, -286.93399047852 ),
				Vector3( -261.02673339844, 1.9554288387299, -255.15124511719 ),
				Vector3( -305.95928955078, 1.9035339355469, -232.64987182617 ),
				Vector3( -302.08782958984, 0.558434009552, -209.62899780273 ),
				Vector3( -282.98208618164, 3.4641819000244, -170.91101074219 ),
				Vector3( -283.81005859375, 1.2120329141617, -154.86836242676 ),
				Vector3( -278.03060913086, -1.6714782714844, -118.15850830078 ),
				Vector3( -269.66156005859, -1.1539459228516, -114.61631774902 ),
				Vector3( -239.42652893066, 3.0134580135345, -114.07861328125 ),
				Vector3( -234.23693847656, 3.3264808654785, -110.8959197998 ),
				Vector3( -232.94926452637, 3.9811608791351, -91.375946044922 ),
				Vector3( -231.22561645508, 4.2421498298645, -83.185577392578 ),
			}
		},
	},
	marker_target_clear = {
		gameObjectName = "hos_mis_0000", viewType = "map_and_world_only_icon", setNew = true, setImportant = true,
		langId = "marker_info_mission_target", hudPhotoId = 10, announceLog = "updateMap",
	},
	marker_target_recovered = {
		announceLog = "updateMap",
	},
	marker_interpreter1 = {
		gameObjectName = "sol_interpreter",
		goalType = "moving", viewType = "all", visibleArea = 2, randomRange = 2,
		setImportant = true, setNew = true,
		mapRadioName = "s0086_mprg0010", announceLog = "updateMap", langId = "marker_enemyarea_trans",
	},
	marker_interpreter_clear = {
		gameObjectName = "sol_interpreter", goalType = "moving", viewType = "map_and_world_only_icon",
		setImportant = true, setNew = true, langId = "marker_ene_translator", hudPhotoId = 20, announceLog = "updateMap",
	},
	marker_interrogation = {
		gameObjectName = "marker_interrogation", goalType = "moving", viewType = "map", visibleArea = 0, randomRange = 0,  setNew = true, announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	marker_intel = {
		gameObjectName = "marker_intel", goalType = "moving", viewType = "all", visibleArea = 2, randomRange = 2,
		setNew = true, langId = "marker_information", announceLog = "updateMap", announceLog = "updateMap",
		
	},
	marker_intel_swamp = {
		gameObjectName = "marker_intel_swamp", announceLog = "updateMap",
	},
	marker_intel_swamp_get = {
		announceLog = "updateMap",
	},
	photo_interpreter = {
		photoId	= PHOTO_ID_INTERPRETER, addFirst = true, photoRadioName = "s0086_mirg0010",
	},
	photo_target = {
		photoId	= PHOTO_ID_TARGET, addFirst = true, photoRadioName = "s0086_mirg0020",
	},
	photo_interpreter_clear = {
		photoId	= PHOTO_ID_INTERPRETER,
	},
	photo_target_recovered = {
		photoId	= PHOTO_ID_TARGET,
	},

	
	subGoal_default = {
		subGoalId= 0,	
	},
	subGoal_recovery = {
		subGoalId= 1, 	
	},
	subGoal_escape = {
		subGoalId= 2, 	
	},

	
	missionTask_recognizeInterpreter = {	
		missionTask = { taskNo = 0, isNew = true, isComplete = false, isFirstHide = false, },
	},
	missionTask_recognizeTarget = {	
		missionTask = { taskNo = 1, isNew = true, isComplete = false, isFirstHide = false, },
	},
	missionTask_recoverTarget = {	
		missionTask = { taskNo = 2, isNew = true, isComplete = false, isFirstHide = false, },
	},
	missionTask_intel = {	
		missionTask = { taskNo = 3, isNew = true, isComplete = false, isFirstHide = true, },
	},
	missionTask_recoverAllHostage = {	
		missionTask = { taskNo = 4, isNew = true, isComplete = false, isFirstHide = true, },
	},
	missionTask_recoverContainer = {	
		missionTask = { taskNo = 5, isNew = true, isComplete = false, isFirstHide = true, },
	},
	missionTask_allInterrogation = {	
		missionTask = { taskNo = 6, isNew = true, isComplete = false, isFirstHide = true, },
	},
	
	missionTask_clear_recognizeInterpreter = {	
		missionTask = { taskNo = 0, isNew = false, isComplete = true, },
	},
	missionTask_clear_recognizeTarget = {	
		missionTask = { taskNo = 1, isNew = false, isComplete = true, },
	},
	missionTask_clear_recoverTarget = {	
		missionTask = { taskNo = 2, isNew = false, isComplete = true, },
	},
	missionTask_clear_intel = {	
		missionTask = { taskNo = 3, isNew = false, isComplete = true, },
	},
	missionTask_clear_recoverAllHostage = {	
		missionTask = { taskNo = 4, isNew = false, isComplete = true, },
	},
	missionTask_clear_recoverContainer = {	
		missionTask = { taskNo = 5, isNew = false, isComplete = true, },
	},
	missionTask_clear_allInterrogation = {	
		missionTask = { taskNo = 6, isNew = false, isComplete = true, },
	},

	marker_interpreter_recovered_again = {
		announceLog = "updateMap",
	},
	marker_interpreter_cleared_again = {
		gameObjectName = "sol_interpreter",
		goalType = "moving", viewType = "map_and_world_only_icon",
		setImportant = true, setNew = true, langId = "marker_ene_translator", hudPhotoId = 20, announceLog = "updateMap",
	},
	marker_interpreter_again = {
		gameObjectName = "sol_interpreter",
		goalType = "moving", viewType = "map_and_world_only_icon",
		setImportant = true, setNew = true, langId = "marker_ene_translator", announceLog = "updateMap",	},
	marker_interpreter_already = {
		gameObjectName = "sol_interpreter", goalType = "none", viewType = "map_and_world_only_icon", langId = "marker_ene_translator", announceLog = "updateMap",
	},
	marker_interpreter_none = {
		gameObjectName = "sol_interpreter", goalType = "none", viewType = "all", langId = "marker_ene_translator", announceLog = "updateMap",
	},
}











s10086_sequence.missionObjectiveTree = {

	marker_interpreter_recovered_again = {
		marker_interpreter_cleared_again = {
			marker_interpreter_again = {
				marker_target_recovered = {
					marker_target_clear = {
						marker_target = {
							marker_intel_swamp_get = {
								marker_intel_swamp = {
									marker_intel = {}
								},
							},
						},
						route_target = {},
						marker_interrogation = {},
						marker_interpreter_clear = {
							marker_interpreter1 = {},
						},
					},
				},
			},
		},
	},
	marker_fake_target1 = {},
	marker_fake_target2 = {},
	marker_fake_target3 = {},
	marker_interpreter_none = {},
	marker_interpreter_already = {},
	photo_interpreter_clear = {
		photo_interpreter = {},
	},
	photo_target_recovered = {
		photo_target = {},
	},

	
	subGoal_escape = {
		subGoal_recovery = {
			subGoal_default = {}
		},
	},

	
	missionTask_clear_recognizeInterpreter = {	
		missionTask_recognizeInterpreter = {},
	},
	missionTask_clear_recognizeTarget = {	
		missionTask_recognizeTarget = {},
	},
	missionTask_clear_recoverTarget = {	
		missionTask_recoverTarget = {
		},
	},
	missionTask_clear_intel = {	
		missionTask_intel = {},
	},
	missionTask_clear_recoverAllHostage = {	
		missionTask_recoverAllHostage = {},
	},
	missionTask_clear_recoverContainer = {	
		missionTask_recoverContainer = {},
	},
	missionTask_clear_allInterrogation = {	
		missionTask_allInterrogation = {},
	},

}

s10086_sequence.missionObjectiveEnum = Tpp.Enum{
	"marker_target",
	"marker_fake_target1",
	"marker_fake_target2",
	"marker_fake_target3",
	"route_target",
	"photo_target",
	"marker_target_clear",
	"photo_target_recovered",
	"marker_target_recovered",
	"marker_interpreter1",
	"photo_interpreter",
	"marker_interpreter_clear",
	"photo_interpreter_clear",
	"marker_interrogation",
	"marker_intel",
	"marker_intel_swamp",
	"marker_intel_swamp_get",

	
	"subGoal_default",
	"subGoal_recovery",
	"subGoal_escape",

	
	"missionTask_recognizeInterpreter",
	"missionTask_recognizeTarget",
	"missionTask_recoverTarget",
	"missionTask_intel",
	"missionTask_recoverAllHostage",
	"missionTask_recoverContainer",
	"missionTask_allInterrogation",
	
	"missionTask_clear_recognizeInterpreter",
	"missionTask_clear_recognizeTarget",
	"missionTask_clear_recoverTarget",
	"missionTask_clear_intel",
	"missionTask_clear_recoverAllHostage",
	"missionTask_clear_recoverContainer",
	"missionTask_clear_allInterrogation",

	"marker_interpreter_recovered_again",
	"marker_interpreter_cleared_again",
	"marker_interpreter_again",
	"marker_interpreter_none",
	"marker_interpreter_already",
}


s10086_sequence.specialBonus = {
	first = {
		missionTask = { taskNo = 3, },
	},
	second = {
		missionTask = { taskNo = 4, },
	}
}

s10086_sequence.MAX_PLACED_LOCATOR_COUNT = 20








function s10086_sequence.MissionPrepare()

	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	s10086_sequence.RegisterCallback()

	TppClock.RegisterClockMessage( "OnMorning", TppClock.DAY_TO_NIGHT )
	TppClock.RegisterClockMessage( "OnNight", TppClock.DAY_TO_NIGHT )
	TppClock.RegisterClockMessage( "OnMidNight", TppClock.NIGHT_TO_MIDNIGHT )
	TppClock.RegisterClockMessage( "At19", TppClock.ParseTimeString( "18:00:00", "number" ) )
	
	TppClock.RegisterClockMessage( "At23", TppClock.ParseTimeString( "23:00:00", "number" ) )
	
	
	TppClock.RegisterClockMessage( "At05", TppClock.ParseTimeString( "04:00:00", "number" ) )

	
	s10086_sequence.SetUpRouteChange()

	
	s10086_sequence.SetUpSearchTarget()

	
	s10086_sequence.SetUpMonologue()

	
	TppPlayer.AddTrapSettingForIntel{
		intelName = "Intel_swamp",
		autoIcon = true,
		identifierName = "GetIntelIdentifier",
		locatorName = "GetIntel_swamp",
		gotFlagName = "reservedBoolean0000",
		trapName = "trap_IntelArea",
		markerObjectiveName = "marker_intel_swamp",
		markerTrapName = "trap_InsideSwampBuilding",
	}

	TppRatBird.EnableRat()

end




function s10086_sequence.SetUpRouteChange()

	
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "start_of_rts_guard1_to_fake_target1_0000" ) ] = {	
		{ func = function() s10086_sequence.StartTimer( "Timer_WaitGuard1", 120 ) end, },
		{ func = function() s10086_enemy.HostageRideVehicle( s10086_enemy.FAKE_TARGET1_NAME, "veh_s10086_0000" ) end, },
		{ func = function() svars.reservedNumber0000 = 32 end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "ArriveAtFakeTarget1" ) ] = {	
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyName = s10086_enemy.INTERROGATOR_NAME, routeId = "rts_interrogator_interrogation1_0000", cautionRouteId = "rts_interrogator_interrogation1_0000", },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyName = s10086_enemy.INTERPRETER_NAME, routeId = "rts_interpreter_interrogation1_0000", cautionRouteId = "rts_interpreter_interrogation1_0000", },
		{ enemyName = s10086_enemy.GUARD1_NAME, routeId = "rts_guard1_to_fake_target1_0001", cautionRouteId = "rts_guard1_to_fake_target1_0001", },
		{ func = function() s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET1_NAME, "rts_fake_target1_to_fake_target1_0000", s10086_enemy.GUARD1_NAME ) end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "end_of_rts_guard1_to_fake_target1_0001" ) ] = {	
		{ enemyName = s10086_enemy.GUARD1_NAME, routeId = "rts_guard1_interrogation1_0000", cautionRouteId = "rts_guard1_interrogation1_0000", },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "end_of_rts_fake_target1_to_fake_target1_0000" ) ] = {	
		{ func = function() s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET1_NAME, "rts_fake_target1_interrogation_0000", s10086_enemy.GUARD1_NAME ) end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation1Ready" ) ] = {	
		{ func = function() s10086_sequence.StartTimer( "Timer_Interrogation1TimeOut", 120 ) end },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation1Start" ) ] = {	
		
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, func = function() s10086_sequence.CallConversation( s10086_sequence.CONVERSATION_TYPE.SWAMP_WEST_NEAR ) end },
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET1_NAME ), { id = "SetHostage2Flag", flag = "silent", on = true, } ) end, },
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation1End" ) ] = {	
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyName = s10086_enemy.INTERROGATOR_NAME, routeId = "rts_interpreter_to_fake_target2_0000", cautionRouteId = "rts_interpreter_to_fake_target2_c_0000", },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyName = s10086_enemy.INTERPRETER_NAME, routeId = "rts_interpreter_to_fake_target2_0000", cautionRouteId = "rts_interpreter_to_fake_target2_c_0000", },
		{ enemyName = s10086_enemy.GUARD1_NAME, routeId = "rts_guard1_to_fake_target3_0000", cautionRouteId = "rts_guard1_to_fake_target3_0000", },
		{
			func = function()
				GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET1_NAME ), { id = "SetFollowed", enable = true, } )
				s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET1_NAME, "rts_guard1_to_fake_target3_0000", s10086_enemy.GUARD1_NAME )
			end,
		},
		{ func = function() s10086_sequence.StopTimer( "Timer_WaitGuard1" ) end },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, func = function() s10086_sequence.StartTimer( "Timer_WaitInterpreter", 300 ) end },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, func = function() s10086_sequence.StartTimer( "Timer_WaitInterrogator", 300 ) end },
		{ func = function() s10086_sequence.StopTimer( "Timer_Interrogation1TimeOut" ) end },
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET1_NAME ), { id = "SetHostage2Flag", flag = "silent", on = false, } ) end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "StartToFakeTarget2" ) ] = {	
		{ func = function() svars.reservedNumber0000 = 47 end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "radio0000" ) ] = {	
		{ enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, func = function() s10086_radio.WarnHostageKilled() end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "radio0001" ) ] = {	
		{ enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, func = function() s10086_radio.AboutInterrogation() end, },
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "FakeTarget1StartedToMoveToInterrogation" ) ] = {	
		{ func = s10086_radio.OnFakeTarget1TakenAway },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "MoveFakeTarget1End" ) ] = {	
		{ enemyName = s10086_enemy.GUARD1_NAME, routeId = "rts_guard1_wait_0000", },
		{
			func = function()
				GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET1_NAME ), { id = "SetFollowed", enable = false, } )
				s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET1_NAME, "rts_fake_target1_wait_0000" )
			end,
		},
		{ func = s10086_radio.OnFakeTarget1FinishingMoving }
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "ArriveAtFakeTarget2" ) ] = {	
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyNameOnTheRoute = s10086_enemy.INTERROGATOR_NAME, enemyName = s10086_enemy.INTERROGATOR_NAME, routeId = "rts_interrogator_interrogation2_0000", cautionRouteId = "rts_interrogator_interrogation2_0000", },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, enemyName = s10086_enemy.INTERPRETER_NAME, routeId = "rts_interpreter_interrogation2_0000", cautionRouteId = "rts_interpreter_interrogation2_0000", },
		{ enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, enemyName = s10086_enemy.GUARD2_NAME, routeId = "rts_guard2_interrogation2_0000", cautionRouteId = "rts_guard2_interrogation2_0000", },
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation2Ready" ) ] = {	
		{ func = function() s10086_sequence.StartTimer( "Timer_Interrogation2TimeOut", 120 ) end },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation2Start" ) ] = {	
		{ enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, func = function() s10086_sequence.StopTimer( "Timer_WaitInterpreter" ) end },
		{ enemyNameOnTheRoute = s10086_enemy.INTERROGATOR_NAME, func = function() s10086_sequence.StopTimer( "Timer_WaitInterrogator" ) end },
		{ func = function() s10086_sequence.CallConversation( s10086_sequence.CONVERSATION_TYPE.SWAMP_WEST ) end },
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET2_NAME ), { id = "SetHostage2Flag", flag = "silent", on = true, } ) end, },
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation2End" ) ] = {	
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyName = s10086_enemy.INTERROGATOR_NAME, routeId = "rts_interpreter_to_fake_target3_0000", cautionRouteId = "rts_interpreter_to_fake_target3_c_0000", },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyName = s10086_enemy.INTERPRETER_NAME, routeId = "rts_interpreter_to_fake_target3_0000", cautionRouteId = "rts_interpreter_to_fake_target3_c_0000", },
		{ enemyName = s10086_enemy.GUARD2_NAME, routeId = "rts_guard2_execute2_0000", cautionRouteId = "rts_guard2_execute2_0000", },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, func = function() s10086_sequence.StartTimer( "Timer_WaitInterpreter", 700 ) end },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, func = function() s10086_sequence.StartTimer( "Timer_WaitInterrogator", 700 ) end },
		{ func = function() s10086_radio.OnFakeTargetInterrogationFinished( s10086_enemy.FAKE_TARGET2_NAME ) end, },
		{ func = function() s10086_sequence.StopTimer( "Timer_Interrogation2TimeOut" ) end },
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET2_NAME ), { id = "SetHostage2Flag", flag = "silent", on = false, } ) end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "WaitToExecute2End" ) ] = {	
		{ func = function() TppEnemy.UnsetSneakRoute( s10086_enemy.GUARD2_NAME ) end, },
		{ func = function() TppEnemy.UnsetCautionRoute( s10086_enemy.GUARD2_NAME ) end, },
		{ func = function() s10086_enemy.ExecuteHostage( s10086_enemy.GUARD2_NAME, s10086_enemy.FAKE_TARGET2_NAME ) end },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "StartToFakeTarget3" ) ] = {	
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "VehicleMoveFinished" ) ] = {	
		{
			func = function()
				svars.reservedNumber0000 = 0
				if svars.reservedBoolean0001 then
					s10086_enemy.ChangeInterrogatorsRoute()
				end
			end,
		}
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "ArriveAtFakeTarget3" ) ] = {	
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, enemyName = s10086_enemy.INTERPRETER_NAME, routeId = "rts_interpreter_interrogation3_0000", cautionRouteId = "rts_interpreter_interrogation3_0000", },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyNameOnTheRoute = s10086_enemy.INTERROGATOR_NAME, enemyName = s10086_enemy.INTERROGATOR_NAME, routeId = "rts_interrogator_interrogation3_0000", cautionRouteId = "rts_interrogator_interrogation3_0000", },
		{ func = function() s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET1_NAME, "rts_fake_target1_interrogation3_0000" ) end },
		{ func = function() s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET3_NAME, "rts_fake_target3_interrogation3_0000" ) end },
		{ enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, enemyName = s10086_enemy.GUARD1_NAME, routeId = "rts_guard1_interrogation3_0000", cautionRouteId = "rts_guard1_interrogation3_0000", },
		{ enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, enemyName = s10086_enemy.GUARD3_NAME, routeId = "rts_guard3_before_interrogation3_0000", cautionRouteId = "rts_guard3_before_interrogation3_0000", },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "end_of_rts_guard3_before_interrogation3_0000" ) ] = {	
		{ enemyName = s10086_enemy.GUARD3_NAME, routeId = "rts_guard3_interrogation3_0000", cautionRouteId = "rts_guard3_interrogation3_0000", },
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "mid_of_rts_fake_target1_interrogation3_0000" ) ] = {	
		{ enemyName = s10086_enemy.GUARD1_NAME, routeId = "rts_guard1_interrogation3_0001", cautionRouteId = "rts_guard1_interrogation3_0001", },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "end_of_rts_fake_target1_interrogation3_0000" ) ] = {	
		{ func = function() s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET1_NAME, "" ) end },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "mid_of_rts_fake_target3_interrogation3_0000" ) ] = {	
		{ enemyName = s10086_enemy.GUARD3_NAME, routeId = "rts_guard3_interrogation3_0001", cautionRouteId = "rts_guard3_interrogation3_0001", },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "end_of_rts_guard3_interrogation3_0001" ) ] = {	
		{ enemyName = s10086_enemy.GUARD3_NAME, routeId = "rts_guard3_interrogation3_0000", cautionRouteId = "rts_guard3_interrogation3_0000", },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "end_of_rts_fake_target3_interrogation3_0000" ) ] = {	
		{ func = function() s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET3_NAME, "" ) end },
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation3Ready" ) ] = {	
		{ func = function() s10086_sequence.StartTimer( "Timer_Interrogation3TimeOut", 180 ) end },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation3Start" ) ] = {	
		{ enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, func = function() s10086_sequence.StopTimer( "Timer_WaitInterpreter" ) end, },
		{ enemyNameOnTheRoute = s10086_enemy.INTERROGATOR_NAME, func = function() s10086_sequence.StopTimer( "Timer_WaitInterrogator" ) end, },
		{ func = function() s10086_sequence.OnInterrogation3Ready() end },
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET1_NAME ), { id = "SetHostage2Flag", flag = "silent", on = true, } ) end, },
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET3_NAME ), { id = "SetHostage2Flag", flag = "silent", on = true, } ) end, },
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation3End" ) ] = {	
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyName = s10086_enemy.INTERPRETER_NAME, routeId = "rts_interpreter_wait_0000", cautionRouteId = "rts_interpreter_wait_0000", },
		{ checkFunc = s10086_sequence.DoesNotBecomeAtNight, enemyName = s10086_enemy.INTERROGATOR_NAME, routeId = "rts_interpreter_wait_0000", cautionRouteId = "rts_interpreter_wait_0000", },
		{ enemyName = s10086_enemy.GUARD1_NAME, routeId = "rts_guard1_execute3_0000", cautionRouteId = "rts_guard1_execute3_0000", },
		{ enemyName = s10086_enemy.GUARD3_NAME, routeId = "rts_guard3_execute3_0000", cautionRouteId = "rts_guard3_execute3_0000", },
		{ func = function() s10086_radio.OnFakeTargetInterrogationFinished( s10086_enemy.FAKE_TARGET1_NAME ) end, },
		{ func = function() s10086_radio.OnFakeTargetInterrogationFinished( s10086_enemy.FAKE_TARGET3_NAME ) end, },
		{ func = function() s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET1_NAME, "" ) end },
		{ func = function() s10086_enemy.ChangeHostageRoute( s10086_enemy.FAKE_TARGET3_NAME, "" ) end },
		{ func = function() s10086_sequence.StopTimer( "Timer_Interrogation3TimeOut" ) end },
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET1_NAME ), { id = "SetHostage2Flag", flag = "silent", on = false, } ) end, },
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET3_NAME ), { id = "SetHostage2Flag", flag = "silent", on = false, } ) end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "WaitToExecute3End" ) ] = {	
		{ func = function() s10086_enemy.ExecuteHostage( s10086_enemy.GUARD1_NAME, s10086_enemy.FAKE_TARGET1_NAME ) end },
		{ func = function() s10086_enemy.ExecuteHostage( s10086_enemy.GUARD3_NAME, s10086_enemy.FAKE_TARGET3_NAME ) end },
		{ func = function() TppEnemy.UnsetSneakRoute( s10086_enemy.GUARD1_NAME ) end, },
		{ func = function() TppEnemy.UnsetCautionRoute( s10086_enemy.GUARD1_NAME ) end, },
		{ func = function() TppEnemy.UnsetSneakRoute( s10086_enemy.GUARD3_NAME ) end, },
		{ func = function() TppEnemy.UnsetCautionRoute( s10086_enemy.GUARD3_NAME ) end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "StartToTarget" ) ] = {	
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "ArriveAtTarget" ) ] = {	
		{ enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, enemyName = s10086_enemy.INTERPRETER_NAME, routeId = "rts_interpreter_interrogation4_0000", cautionRouteId = "rts_interpreter_interrogation4_0000", },
		{ enemyNameOnTheRoute = s10086_enemy.INTERROGATOR_NAME, enemyName = s10086_enemy.INTERROGATOR_NAME, routeId = "rts_interrogator_interrogation4_0000", cautionRouteId = "rts_interrogator_interrogation4_0000", },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "MoveTargetEnd" ) ] = {	
		{ enemyNameOnTheRoute = s10086_enemy.TARGET_NAME, enemyName = s10086_enemy.GUARD4_NAME, routeId = "rts_guard4_interrogation4_0000", cautionRouteId = "rts_guard4_interrogation4_0000", },
		{
			enemyNameOnTheRoute = s10086_enemy.TARGET_NAME,
			func = function()
				GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME ), { id = "SetFollowed", enable = false, } )
				s10086_enemy.ChangeHostageRoute( s10086_enemy.TARGET_NAME, "rts_target_interrogation_0000" )
				TppCheckPoint.Disable{ baseName = s10086_sequence.baseList, }
			end,
		},
		{ enemyNameOnTheRoute = s10086_enemy.TARGET_NAME, func = function() svars.isTargetInRoom = true end, }
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "end_of_rts_target_interrogation_0000" ) ] = {	
		{
			enemyNameOnTheRoute = s10086_enemy.TARGET_NAME,
			func = function()
				s10086_enemy.ChangeHostageRoute( s10086_enemy.TARGET_NAME, "" )
				svars.reservedBoolean0002 = true
			end,
		},
	}

	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation4Ready" ) ] = {	
		{ func = function() s10086_sequence.StartTimer( "Timer_Interrogation4TimeOut", 180 ) end },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation4Start" ) ] = {	
		{ enemyNameOnTheRoute = s10086_enemy.INTERPRETER_NAME, func = function() s10086_sequence.StopTimer( "Timer_WaitInterpreter" ) end },
		{ enemyNameOnTheRoute = s10086_enemy.INTERROGATOR_NAME, func = function() s10086_sequence.StopTimer( "Timer_WaitInterrogator" ) end },
		
		{
			func = function()
				if svars.reservedBoolean0002 then
					s10086_sequence.CallConversation( s10086_sequence.CONVERSATION_TYPE.TARGET )
				end
			end,
		},
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME ), { id = "SetHostage2Flag", flag = "silent", on = true, } ) end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "Interrogation4End" ) ] = {	
		{ enemyName = s10086_enemy.GUARD4_NAME, routeId = "rts_guard4_execute4_0000", cautionRouteId = "rts_guard4_execute4_0000", },
		{ func = function() TppEnemy.UnsetSneakRoute( s10086_enemy.INTERPRETER_NAME ) end, },
		{ func = function() TppEnemy.UnsetCautionRoute( s10086_enemy.INTERPRETER_NAME ) end, },
		{ func = function() TppEnemy.UnsetSneakRoute( s10086_enemy.INTERROGATOR_NAME ) end, },
		{ func = function() TppEnemy.UnsetCautionRoute( s10086_enemy.INTERROGATOR_NAME ) end, },
		{ func = function() s10086_sequence.StopTimer( "Timer_Interrogation4TimeOut" ) end },
		{ func = function() GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME ), { id = "SetHostage2Flag", flag = "silent", on = false, } ) end, },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "WaitToExecute4End" ) ] = {	
		{ func = function() s10086_enemy.ExecuteHostage( s10086_enemy.GUARD4_NAME, s10086_enemy.TARGET_NAME ) end },
		{ func = function() TppEnemy.UnsetSneakRoute( s10086_enemy.GUARD4_NAME ) end, },
		{ func = function() TppEnemy.UnsetCautionRoute( s10086_enemy.GUARD4_NAME ) end, },
	}


	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "guard1ExcecutionReady" ) ] = {	
		{ func = function() s10086_enemy.ExecuteHostage( s10086_enemy.GUARD1_NAME, s10086_enemy.FAKE_TARGET1_NAME ) end },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "guard2ExcecutionReady" ) ] = {	
		{ func = function() s10086_enemy.ExecuteHostage( s10086_enemy.GUARD2_NAME, s10086_enemy.FAKE_TARGET2_NAME ) end },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "guard3ExcecutionReady" ) ] = {	
		{ func = function() s10086_enemy.ExecuteHostage( s10086_enemy.GUARD3_NAME, s10086_enemy.FAKE_TARGET3_NAME ) end },
	}
	s10086_sequence.routeChangeTableRoot[ Fox.StrCode32( "guard4ExcecutionReady" ) ] = {	
		{ func = function() s10086_enemy.ExecuteHostage( s10086_enemy.GUARD4_NAME, s10086_enemy.TARGET_NAME ) end },
	}

end





function s10086_sequence.SetUpSearchTarget()

	
	s10086_sequence.searchTargetTable = {
		{
			gameObjectName = s10086_enemy.INTERPRETER_NAME,
			gameObjectType = "TppSoldier2",
			messageName = "OnRecognized",
			skeletonName = "SKL_004_HEAD",
			func = s10086_sequence.OnRecognized,
		},
		{
			gameObjectName = s10086_enemy.TARGET_NAME,
			gameObjectType = "TppHostage2",
			messageName = "OnRecognizedTarget",
			skeletonName = "SKL_004_HEAD",
			objectives = "marker_target_clear",
			func = s10086_sequence.OnRecognized,
		},
		{
			gameObjectName = s10086_enemy.FAKE_TARGET1_NAME,
			gameObjectType = "TppHostage2",
			messageName = "OnRecognizedFakeTarget1",
			skeletonName = "SKL_004_HEAD",
			func = s10086_sequence.OnRecognized,
			notImportant = true,
		},
		{
			gameObjectName = s10086_enemy.FAKE_TARGET2_NAME,
			gameObjectType = "TppHostage2",
			messageName = "OnRecognizedFakeTarget2",
			skeletonName = "SKL_004_HEAD",
			func = s10086_sequence.OnRecognized,
			notImportant = true,
		},
		{
			gameObjectName = s10086_enemy.FAKE_TARGET3_NAME,
			gameObjectType = "TppHostage2",
			messageName = "OnRecognizedFakeTarget3",
			skeletonName = "SKL_004_HEAD",
			func = s10086_sequence.OnRecognized,
			notImportant = true,
		},
	}

	
	TppMarker.SetUpSearchTarget( s10086_sequence.searchTargetTable )

end




function s10086_sequence.SetUpMonologue()

	s10086_sequence.CONVERSATION_ENEMY_TABLE = {
		[ s10086_sequence.CONVERSATION_TYPE.SWAMP_WEST_NEAR ] = {
			speaker = {
				enemyName = s10086_enemy.GUARD1_NAME,
				routeName = "rts_guard1_interrogation1_0000",
			},
			{
				enemyName = s10086_enemy.INTERPRETER_NAME,
				routeName = "rts_interpreter_interrogation1_0000",
				cautionRouteName = "rts_interpreter_interrogation1_0000",
			},
			{
				enemyName = s10086_enemy.FAKE_TARGET1_NAME,
				routeName = "rts_fake_target1_interrogation_0000",
			},
			friend = {
				enemyName = s10086_enemy.INTERROGATOR_NAME,
				routeName = "rts_interrogator_interrogation1_0000",
				cautionRouteName = "rts_interrogator_interrogation1_0000",
			},
		},
		[ s10086_sequence.CONVERSATION_TYPE.SWAMP_WEST ] = {
			speaker = {
				enemyName = s10086_enemy.INTERROGATOR_NAME,
				routeName = "rts_interrogator_interrogation2_0000",
				cautionRouteName ="rts_interrogator_interrogation2_0000",
			},
			{
				enemyName = s10086_enemy.INTERPRETER_NAME,
				routeName = "rts_interpreter_interrogation2_0000",
				cautionRouteName = "rts_interpreter_interrogation2_0000",
			},
			{
				enemyName = s10086_enemy.GUARD2_NAME,
				routeName = "rts_guard2_interrogation2_0000",
				cautionRouteName = "rts_guard2_interrogation2_0000",
			},
			friend = {
				enemyName = s10086_enemy.FAKE_TARGET2_NAME,
				identifierName = "s10086_area_sequence_DataIdentifier",
				key = "pos_interrogation2",
				hostage = true,
			},
		},
		[ s10086_sequence.CONVERSATION_TYPE.SWAMP1 ] = {
			speaker = {
				enemyName = s10086_enemy.INTERROGATOR_NAME,
				routeName = "rts_interrogator_interrogation3_0000",
				cautionRouteName = "rts_interrogator_interrogation3_0000",
			},
			{
				enemyName = s10086_enemy.INTERPRETER_NAME,
				routeName = "rts_interpreter_interrogation3_0000",
				cautionRouteName = "rts_interpreter_interrogation3_0000",
			},
			{
				enemyName = s10086_enemy.GUARD1_NAME,
				routeName = "rts_guard1_interrogation3_0000",
				cautionRouteName = "rts_guard1_interrogation3_0001",
			},
			{
				enemyName = s10086_enemy.GUARD3_NAME,
				routeName = "rts_guard3_interrogation3_0000",
				cautionRouteName = "rts_guard3_interrogation3_0000",
			},
			{
				enemyName = s10086_enemy.FAKE_TARGET3_NAME,
				routeName = "rts_fake_target3_interrogation3_0000",
				cautionRouteName = "rts_fake_target3_interrogation3_0000",
			},
			friend = {
				enemyName = s10086_enemy.FAKE_TARGET1_NAME,
				identifierName = "s10086_area_sequence_DataIdentifier",
				key = "pos_interrogation3",
				hostage = true,
			},
		},
		[ s10086_sequence.CONVERSATION_TYPE.SWAMP2 ] = {
			speaker = {
				enemyName = s10086_enemy.INTERROGATOR_NAME,
				routeName = "rts_interrogator_interrogation3_0000",
				cautionRouteName = "rts_interrogator_interrogation3_0000",
			},
			{
				enemyName = s10086_enemy.INTERPRETER_NAME,
				routeName = "rts_interpreter_interrogation3_0000",
				cautionRouteName = "rts_interpreter_interrogation3_0000",
			},
			{
				enemyName = s10086_enemy.GUARD1_NAME,
				routeName = "rts_guard1_interrogation3_0000",
				cautionRouteName = "rts_guard1_interrogation3_0001",
			},
			friend = {
				enemyName = s10086_enemy.FAKE_TARGET1_NAME,
				identifierName = "s10086_area_sequence_DataIdentifier",
				key = "pos_interrogation3",
				hostage = true,
			},
		},
		[ s10086_sequence.CONVERSATION_TYPE.SWAMP3 ] = {
			speaker = {
				enemyName = s10086_enemy.INTERROGATOR_NAME,
				routeName = "rts_interrogator_interrogation3_0000",
				cautionRouteName = "rts_interrogator_interrogation3_0000",
			},
			{
				enemyName = s10086_enemy.INTERPRETER_NAME,
				routeName = "rts_interpreter_interrogation3_0000",
				cautionRouteName = "rts_interpreter_interrogation3_0000",
			},
			{
				enemyName = s10086_enemy.GUARD3_NAME,
				routeName = "rts_guard3_interrogation3_0000",
				cautionRouteName = "rts_guard3_interrogation3_0000",
			},
			friend = {
				enemyName = s10086_enemy.FAKE_TARGET3_NAME,
				identifierName = "s10086_area_sequence_DataIdentifier",
				key = "pos_interrogation3",
				hostage = true,
			},
		},
		[ s10086_sequence.CONVERSATION_TYPE.TARGET ] = {
			speaker = {
				enemyName = s10086_enemy.INTERROGATOR_NAME,
				routeName = "rts_interrogator_interrogation4_0000",
				cautionRouteName = "rts_interrogator_interrogation4_0000",
			},
			{
				enemyName = s10086_enemy.INTERPRETER_NAME,
				routeName = "rts_interpreter_interrogation4_0000",
				cautionRouteName = "rts_interpreter_interrogation4_0000",
			},
			{
				enemyName = s10086_enemy.GUARD4_NAME,
				routeName = "rts_guard4_interrogation4_0000",
				cautionRouteName = "rts_guard4_interrogation4_0000",
			},
			friend = {
				enemyName = s10086_enemy.TARGET_NAME,
				identifierName = "s10086_area_sequence_DataIdentifier",
				key = "pos_interrogation4",
				hostage = true,
			},
		},
	}

	
	mvars.SPECIAL_MONOLOGUE_TABLE = {
		CT10086_02_a = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_02_b = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_02_c = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_02_d = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_02_e = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_02_f = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_02_h = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_02_i = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_01_a = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_01_b = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_01_c = {
			speaker = s10086_enemy.FAKE_TARGET3_NAME,
		},
		CT10086_03_01_d = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_01_e = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_01_f = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_01_g = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_01_h = {
			speaker = s10086_enemy.FAKE_TARGET3_NAME,
		},
		CT10086_03_01_i = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_01_j = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_02_a = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_02_b = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_02_c = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_02_d = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_02_e = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_02_f = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_02_g = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_03_a = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_03_b = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_03_c = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_03_d = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_03_03_e = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_a = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_b = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_c = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_d = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_e = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_f = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_g = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_h = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_i = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_j = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_k = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_l = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_m = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
		CT10086_04_n = {
			speaker = s10086_enemy.INTERPRETER_NAME,
		},
	}

	
	MONOLOGUE_TABLE = {
		CT10086_01 = { speaker = s10086_enemy.FAKE_TARGET1_NAME, speechLabel = "CT10086_01_01", },
	}

	mvars.currentMonologueTable = {}

end




function s10086_sequence.OnRestoreSVars()

	Fox.Log( "s10086_sequence.OnRestoreSVars()" )

end

function s10086_sequence.OnEndMissionPrepareSequence()

	Fox.Log( "s10086_sequence.OnEndMissionPrepareSequence()" )

	if svars.reservedBoolean0003 then
		s10086_sequence.StartTimer( "Timer_WaitInterpreter", 30 )
	end
	if svars.reservedBoolean0004 then
		s10086_sequence.StartTimer( "Timer_WaitInterrogator", 30 )
	end
	if svars.reservedBoolean0005 then
		s10086_sequence.StartTimer( "Timer_SealingToCancelFollwing", 30 )
	end
	if svars.reservedBoolean0006 then
		s10086_sequence.StartTimer( "Timer_WaitGuard1", 30 )
	end

end


function s10086_sequence.OnEstablishMissionClear( missionClearType )

	Fox.Log( "s10086_sequence.OnEstablishMissionClear(): missionClearType:" .. tostring( missionClearType ) )

	
	local OnEndMissionCredit
	if s10086_sequence.CountRecoveredFakeTarget() > 0 then
		s10086_radio.OnGameCleared1()
	else
		s10086_radio.OnGameCleared2()
	end

	
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


function s10086_sequence.OnGameOver( gameOverType )
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD ) then
		
		TppPlayer.SetTargetDeadCamera{ gameObjectName = s10086_enemy.TARGET_NAME }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	end
end


function s10086_sequence.OnDisappearGameEndAnnounceLog()

	Fox.Log( "s10086_sequence.OnDisappearGameEndAnnounceLog()" )

	
	local OnEndMissionCredit
	if s10086_sequence.CountRecoveredFakeTarget() > 0 then
		local gameObjectId = GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME )
		local staffId = TppMotherBaseManagement.GetStaffIdFromGameObject{ gameObjectId = gameObjectId, }
		TppMotherBaseManagement.ChangeStaffEnmityAndSection{ staffId = staffId, enmity = 15, }	
	end

	TppMission.ShowMissionResult()

end



function s10086_sequence.RegisterCallback()

	Fox.Log("*** s10086_sequence.RegisterCallback() ***")

	local systemCallbackTable ={
		OnEstablishMissionClear = s10086_sequence.OnEstablishMissionClear,
		OnGameOver = s10086_sequence.OnGameOver,
		OnEndMissionCredit = s10086_sequence.OnEndMissionCredit,
		CheckMissionClearFunction = function() return TppEnemy.CheckAllTargetClear() end,
		OnRecovered = s10086_sequence.OnRecovered,
		OnDisappearGameEndAnnounceLog = s10086_sequence.OnDisappearGameEndAnnounceLog,
		nil,
	}

	
	TppMission.RegisterMissionSystemCallback(systemCallbackTable)

end








function s10086_sequence.Messages()
	return
	StrCode32Table {
		GameObject = {
			{
				msg = "RoutePoint2",
				func = s10086_sequence.OnRoutePoint
			},
			{
				msg = "Dead",
				sender = s10086_enemy.INTERPRETER_NAME,
				func = function()
					Fox.Log( "s10086_sequence.Messages(): GameObject: Dead: sender: " .. tostring( s10086_enemy.INTERPRETER_NAME ) )
					if not s10086_sequence.IsRecognized( s10086_enemy.INTERPRETER_NAME ) then
						TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
						TppMission.UpdateObjective{ objectives = { "marker_interpreter_clear" }, }
					end
					svars.reservedBoolean0007 = true
				end,
			},
			{
				msg = "Dead",
				sender = s10086_enemy.TARGET_NAME,
				func = s10086_sequence.OnTargetDead,
			},
			{
				msg = "ChangePhase",
				func = s10086_sequence.OnChangePahse,
			},
			{
				msg = "Fulton",
				func = function( gameObjectId, containerName )
					Fox.Log( "s10086_sequence.Messages(): GameObject: Fulton: gameObjectId:" .. tostring( gameObjectId ) .. ", containerName:" .. tostring( containerName ) )
					if Tpp.IsFultonContainer( gameObjectId ) then
						for i, gimmickName in pairs( MISSION_TASK_CONTAINER_LIST ) do
							local ret, targetGameObjectId = TppGimmick.GetGameObjectId( gimmickName )
							if targetGameObjectId == GameObject.NULL_ID then
								Fox.Warning( "s10086_sequence.Messages(): targetGameObjectId is invalid value:" .. tostring( targetGameObjectId ) )
							else
								if gameObjectId == targetGameObjectId then
									svars.reservedNumber0002 = svars.reservedNumber0002 + 1
									if svars.reservedNumber0002 >= 4 then
										
										TppMission.UpdateObjective{
											objectives = {
												"missionTask_clear_recoverContainer",
											},
										}
									end
								end
							end
						end
					end
				end,
			},
			{
				msg = "FultonFailed",
				sender = s10086_enemy.TARGET_NAME,
				func = function( gameObjectId, locatorName, locatorNameUpper, failureType )
					
					
					if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
						
						TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )
					end
				end,
			},
			{
				msg = "Dead",
				sender = { s10086_enemy.GUARD1_NAME, s10086_enemy.GUARD2_NAME, s10086_enemy.GUARD3_NAME, s10086_enemy.GUARD4_NAME, },
				func = s10086_sequence.OnGuardEliminated,
			},
			{
				msg = "Fulton",
				sender = { s10086_enemy.GUARD1_NAME, s10086_enemy.GUARD2_NAME, s10086_enemy.GUARD3_NAME, s10086_enemy.GUARD4_NAME, },
				func = s10086_sequence.OnGuardEliminated,
			},
			{
				msg = "Fulton",
				sender = s10086_enemy.INTERPRETER_NAME,
				func = function()
					Fox.Log( "s10086_sequence.Messages(): GameObject: Fulton: sender: " .. tostring( s10086_enemy.INTERPRETER_NAME ) )
					if not s10086_sequence.IsRecognized( s10086_enemy.INTERPRETER_NAME ) then
						TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
						TppMission.UpdateObjective{ objectives = { "marker_interpreter_clear" }, }
					end
				end,
			},
			{
				msg = "FultonFailed",
				sender = s10086_enemy.INTERPRETER_NAME,
				func = function()
					Fox.Log( "s10086_sequence.Messages(): GameObject: FultonFailed: sender: " .. tostring( s10086_enemy.INTERPRETER_NAME ) )
					if not s10086_sequence.IsRecognized( s10086_enemy.INTERPRETER_NAME ) then
						TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
						TppMission.UpdateObjective{ objectives = { "marker_interpreter_clear" }, }
					end
				end,
			},
			{	
				msg = "ConversationEnd",
				func = function( gameObjectId, speechLabel, isSuccess )

					Fox.Log( "s10086_sequence.Messages(): ConversationEnd Message Received. gameObjectId:" ..
						tostring( gameObjectId ) .. ", speechLabel:" .. tostring( speechLabel ) .. ", isSuccess:" .. isSuccess )

					local conversationType, nextSpeechLabel, currentSpeechLabel, speakerId = s10086_sequence.GetNextSpeechLabel( speechLabel )
					
					if isSuccess == 1 then
						Fox.Log( "s10086_sequence.Messages(): ConversationEnd Message Received. conversationType:" .. tostring( conversationType ) .. 
							", nextSpeechLabel:" .. tostring( nextSpeechLabel ) .. ", currentSpeechLabel:" .. tostring( currentSpeechLabel ) .. ", speakerId:" .. tostring( speakerId ) )

						if speakerId and gameObjectId == GameObject.GetGameObjectId( speakerId ) or ( mvars.SPECIAL_MONOLOGUE_TABLE[ currentSpeechLabel ] and gameObjectId == GameObject.GetGameObjectId( mvars.SPECIAL_MONOLOGUE_TABLE[ currentSpeechLabel ].speaker ) ) then
							if conversationType and nextSpeechLabel then
								s10086_sequence.CallConversation( conversationType, nextSpeechLabel )
							else
								s10086_sequence.OnRoutePoint( s10086_enemy.INTERPRETER_NAME, nil, nil, SPEECH_MESSAGE_MAP[ speechLabel ] )
							end

							
							
							local monologueTable = MONOLOGUE_TABLE[ currentSpeechLabel ]
							if monologueTable then
								s10086_enemy.CallMonologue( monologueTable.speaker, monologueTable.speechLabel )
							end
						end
					elseif SPEECH_TABLE[ conversationType ] then
						s10086_sequence.OnRoutePoint( s10086_enemy.INTERPRETER_NAME, nil, nil, Fox.StrCode32( SPEECH_TABLE[ conversationType ].message ) )
					end

				end
			},
			{
				msg = "Carried",
				sender = {
					s10086_enemy.TARGET_NAME,
					s10086_enemy.FAKE_TARGET1_NAME,
					s10086_enemy.FAKE_TARGET2_NAME,
					s10086_enemy.FAKE_TARGET3_NAME,
				},
				func = s10086_sequence.OnHostageCarried
			},
			{
				msg = "MonologueEnd",
				func = function( gameObjectId )

					Fox.Log( "s10086_sequence.Messages(): MonologueEnd gameObjectId:" .. tostring( gameObjectId ) )

					if mvars.currentMonologueTable[ gameObjectId ] then
						local speechLabel = mvars.currentMonologueTable[ gameObjectId ]
						local conversationType, nextSpeechLabel, currentSpeechLabel, speakerId = s10086_sequence.GetNextSpeechLabel( Fox.StrCode32( speechLabel ) )
						Fox.Log( "s10086_sequence.Messages(): MonologueEnd: speechLabel:" .. tostring( speechLabel ) .. ", conversationType:" .. tostring( conversationType ) ..
							", nextSpeechLabel:" .. tostring( nextSpeechLabel ) .. ", currentSpeechLabel:" .. tostring( currentSpeechLabel ) .. ", speakerId:" .. tostring( speakerId ) )

						if conversationType and nextSpeechLabel then
							s10086_sequence.CallConversation( conversationType, nextSpeechLabel )
						else
							s10086_sequence.OnRoutePoint( s10086_enemy.INTERPRETER_NAME, nil, nil, Fox.StrCode32( SPEECH_MESSAGE_MAP[ speechLabel ] ) )
						end
						mvars.currentMonologueTable[ gameObjectId ] = nil
					end
				end,
			},
		},
		Marker = {
			{ 
				msg = "ChangeToEnable",
				func = s10086_sequence.OnMarked,
			},
		},
		Weather = {
			{
				msg = "Clock",	sender = "OnMorning",
				func = function( sender, time )

					Fox.Log( "Received Message: msg:Clock, sender:OnMorning" )
					svars.dayCount = svars.dayCount + 1

				end
			},
			{
				msg = "Clock",
				sender = { "At19", "At21", "At23", "At01", "At03", "At05", },
				func = function( sender, time )

					Fox.Log( "Received Message: Weather: Clock: sender:" .. tostring( sender ) .. ", time" .. tostring( time ) )

					if not svars.reservedBoolean0001 then
						
						s10086_sequence.StopTimer( "Timer_WaitInterpreter" )
						s10086_sequence.StopTimer( "Timer_WaitInterrogator" )
						s10086_sequence.StopTimer( "Timer_WaitGuard1" )

						
						s10086_enemy.ChangeVipRouteToNight()

						svars.nightCount = svars.nightCount + 1
						svars.reservedBoolean0001 = true
					else
						Fox.Log( "Received Message: Weather: Clock: ignore operation because the operation is already done." )
					end

				end
			},
			{
				msg = "Clock",	sender = "OnMidNight",
				func = function( sender, time )
					Fox.Log( "Received Message: msg:Clock, sender:OnMidNight" )
					
				end
			},
		},
		Trap = {
			{
				msg = "Enter",
				sender = "trap_TargetDead",
				func = function()

					svars.isPlayerInRoom = true

					if svars.isTargetInRoom and svars.isTargetDead then

						
						local soldiers = { s10086_enemy.INTERPRETER_NAME, s10086_enemy.INTERROGATOR_NAME, s10086_enemy.GUARD4_NAME }
						local command = { id = "SetEnabled", enabled = false }
						for i, soldierName in ipairs( soldiers ) do
							local gameObjectId = GameObject.GetGameObjectId( soldierName )
							GameObject.SendCommand( gameObjectId, command )
						end

						
						TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )

					end
				end
			},
			{
				msg = "Exit",
				sender = "trap_TargetDead",
				func = function()

					svars.isPlayerInRoom = false

				end
			},
		},
		Player = {
			{
				msg = "GetIntel",
				sender = "Intel_swamp",
				func = function( intelNameHash )

					Fox.Log( "s10086_sequence.Messages(): GetIntel: Intel_swamp: intelNameHash:" .. tostring( intelNameHash ) )

					TppPlayer.GotIntel( intelNameHash )

					local func = function()

						
						TppMission.UpdateObjective{
							objectives = { "marker_target", "marker_fake_target1", "marker_fake_target2", "marker_fake_target3", "missionTask_clear_intel", },
						}
						s10086_radio.OnIntelFileGotten()

						
						TppResult.AcquireSpecialBonus{ first = { isComplete = true, }, }

					end

					
					s10086_demo.PlayIntelDemo( func )

				end,
			},
			{	
				msg = "PlayerHoldWeapon",
				func = function( equipId, equipTypeId, isFlashLight, isShield )
					Fox.Log( "s10086_sequence.Messages(): Player: PlayerHoldWeapon: equipId:" .. tostring( equipId ) .. "equipTypeId" .. tostring( equipTypeId ) )
					s10086_radio.OnPlayerHoldActiveWeapon()
				end,
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
		Subtitles = {
			{	
				msg = "SubtitlesEndEventMessage",
				func = function( speechLabel, status )
					Fox.Log( "s10086_sequence.Messages(): Subtitles: SubtitlesEndEventMessage: speechLabel:" .. tostring( speechLabel ) .. ", status:" .. tostring( status ) )

					if speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf2000_151010_0_enec_af" ) then	
						Fox.Log( "s10086_sequence.Messages(): stpf2000_151010_0_enec_af is Finished." )
						svars.reservedNumber0001 = svars.reservedNumber0001 + 1
					elseif speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf2000_1x1010_0_eneb_af" ) then	
						Fox.Log( "s10086_sequence.Messages(): stpf2000_1x1010_0_eneb_af is Finished." )
						svars.reservedNumber0001 = svars.reservedNumber0001 + 1
					elseif speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf2000_2o1010_0_eneb_af" ) then	
						Fox.Log( "s10086_sequence.Messages(): stpf2000_2o1010_0_eneb_af is Finished." )
						svars.reservedNumber0001 = svars.reservedNumber0001 + 1
					elseif speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf2000_3g1010_0_eneb_af" ) then	
						Fox.Log( "s10086_sequence.Messages(): stpf2000_3g1010_0_eneb_af is Finished." )
						svars.reservedNumber0001 = svars.reservedNumber0001 + 1
					end

					if svars.reservedNumber0001 == 4 then
						TppMission.UpdateObjective{
							objectives = { "missionTask_clear_allInterrogation", },
						}
					end

					
					if speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf2000_1u1010_0_enea_af" ) then
						Fox.Log( "s10086_sequence.Messages(): Subtitles: SubtitlesEndEventMessage: this speechLabel is English Subtitles." )
						s10086_radio.OnInterrogation2Finished()
						s10086_sequence.StartTimer( "Timer_WaitToPlayInterrogationRadio3", 15 )
						s10086_sequence.StartTimer( "Timer_WaitToPlayInterrogationRadio", 30 )
						s10086_sequence.StartTimer( "Timer_WaitToPlayInterrogationRadio2", 45 )
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





function s10086_sequence.OnTargetDead( gameObjectId )

	Fox.Log( "s10086_sequence.OnTargetDead( " .. gameObjectId .. " )" )

	if	gameObjectId == GameObject.GetGameObjectId( "TppHostage2", s10086_enemy.TARGET_NAME ) then	
		if not svars.isPlayerInRoom and svars.isTargetInRoom then
			svars.isTargetDead = true
		else
			TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )	
		end

	end

end





function s10086_sequence.OnMarked( s_locatorName, markerType, targetGameObjectId, s_sourceLocatorName )

	Fox.Log( "s10086_sequence.OnMarked(): s_locatorName:" .. tostring( s_locatorName ) .. ", markerType:" .. tostring( markerType ) ..
		", targetGameObjectId:" .. tostring( targetGameObjectId ) .. ", s_sourceLocatorName:" .. tostring( s_sourceLocatorName ) )

	if s_sourceLocatorName == Fox.StrCode32( "Player" ) and targetGameObjectId == GameObject.GetGameObjectId( s10086_enemy.INTERPRETER_NAME ) then	
		svars.reservedBoolean0008 = true
		s10086_radio.OnInterpreterMarked()
	end

end





s10086_sequence.OnRoutePoint = function( gameObjectId, routeId, routeNodeIndex, messageId )

	Fox.Log( "s10086_sequence.OnRoutePoint( gameObjectId:" .. tostring( gameObjectId ) ..
				", routeId:" .. tostring( routeId ) .. ", routeNodeIndex:" .. tostring( routeNodeIndex ) .. ", messageId:" .. tostring( messageId ) ..  " )" )

	if Tpp.IsTypeString( gameObjectId ) then
		gameObjectId = GameObject.GetGameObjectId( gameObjectId )
	end

	local routeChangeTables = s10086_sequence.routeChangeTableRoot[ messageId ]
	if routeChangeTables then
		for i, routeChangeTable in ipairs( routeChangeTables ) do
			local funcCheck = not routeChangeTable.checkFunc or routeChangeTable.checkFunc()
			local routeCheck = not routeChangeTable.enemyNameOnTheRoute or GameObject.GetGameObjectId( routeChangeTable.enemyNameOnTheRoute ) == gameObjectId
			if funcCheck and routeCheck then
				if routeChangeTable.enemyName then
					if routeChangeTable.routeId then
						TppEnemy.SetSneakRoute( routeChangeTable.enemyName, routeChangeTable.routeId )
					end
					if routeChangeTable.cautionRouteId then
						s10086_enemy.SetCautionRoute( routeChangeTable.enemyName, routeChangeTable.cautionRouteId )
					end
					if routeChangeTable.alertRouteId then
						TppEnemy.SetAlertRoute( routeChangeTable.enemyName, routeChangeTable.alertRouteId )
					end
				end
				if routeChangeTable.func then
					routeChangeTable.func()
				end
			end
		end
	else
		Fox.Log( "s10086_sequence.OnRoutePoint(): There is no routeChangeTables!" )
	end

end




s10086_sequence.IsRecovered = function( inGameObjectId )

	Fox.Log( "s10086_sequence.IsRecovered(): inGameObjectId:" .. tostring( inGameObjectId ) )

	local locatorName
	local gameObjectId

	if Tpp.IsTypeString( inGameObjectId ) then
		locatorName = inGameObjectId
		gameObjectId = GameObject.GetGameObjectId( inGameObjectId )
	else
		gameObjectId = inGameObjectId
		locatorName = s10086_enemy.GetNpcName( gameObjectId )
	end

	Fox.Log( "s10086_sequence.IsRecovered(): locatorName:" .. tostring( locatorName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

	if locatorName then
		local flagName = s10086_sequence.GetRecoveredFlagName( locatorName )
		if flagName and svars[ flagName ] then
			return true
		end
	end

	return false

end




s10086_sequence.OnRecovered = function( inGameObjectId )

	Fox.Log( "s10086_sequence.OnRecovered(): gameObjectId:" .. tostring( inGameObjectId ) )

	local locatorName
	local gameObjectId

	if Tpp.IsTypeString( inGameObjectId ) then
		locatorName = inGameObjectId
		gameObjectId = GameObject.GetGameObjectId( inGameObjectId )
	else
		gameObjectId = inGameObjectId
		locatorName = s10086_enemy.GetNpcName( gameObjectId )
	end

	Fox.Log( "s10086_sequence.OnRecovered(): locatorName:" .. tostring( locatorName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

	if gameObjectId == GameObject.GetGameObjectId( s10086_enemy.INTERPRETER_NAME ) then	
		s10086_sequence.OnInterpreterRecovered()
	elseif s10086_enemy.IsFakeTarget( gameObjectId ) then
		s10086_sequence.OnFakeTargetRecovered()
	elseif gameObjectId == GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME ) then
		TppMission.UpdateObjective{ objectives = { "missionTask_clear_recoverTarget", }, }
	elseif Tpp.IsSoldier( gameObjectId ) then
		s10086_sequence.OnEnemyRecovered()
	end

	if s10086_sequence.IsAllFakeTargetRecovered() then
		TppMission.UpdateObjective{ objectives = { "missionTask_clear_recoverAllHostage", }, }	
	end

	
	if locatorName then
		local flagName = s10086_sequence.GetRecoveredFlagName( locatorName )
		if flagName then
			svars[ flagName ] = true
		end
	end

end





s10086_sequence.OnInterpreterRecovered = function()

	Fox.Log( "s10086_sequence.OnInterpreterRecovered()" )

	TppMission.UpdateObjective{ objectives = { "photo_interpreter_clear", }, }	

	s10086_radio.OnInterpreterRecovered()

	s10086_sequence.StartTimer( "Timer_InterpreterRecovered", 30 )
	svars.reservedNumber0002 = 1

end




s10086_sequence.CountRecoveredFakeTarget = function()

	Fox.Log( "s10086_sequence.CountRecoveredFakeTarget()" )

	local count = 0
	for i, fakeTargetName in ipairs( s10086_enemy.FAKE_TARGETS ) do
		if TppEnemy.IsRecovered( fakeTargetName ) then
			count = count + 1
		end
	end
	return count

end


function s10086_sequence.OnFakeTargetRecovered()

	Fox.Log( "s10086_sequence.OnFakeTargetRecovered()" )

	local recoveredFakeTargetCount = s10086_sequence.CountRecoveredFakeTarget()
	s10086_radio.OnFakeTargetRecovered( recoveredFakeTargetCount )

	
	if recoveredFakeTargetCount == 3 then
		if not s10086_sequence.IsRecognized( s10086_enemy.TARGET_NAME ) then	
			TppMission.UpdateObjective{ objectives = { "route_target", } }	
		end

		TppResult.AcquireSpecialBonus{ second = { isComplete = true, }, }	
	end

end





s10086_sequence.OnEnemyRecovered = function()

	Fox.Log( "s10086_sequence.OnEnemyRecovered()" )
	s10086_radio.OnEnemyRecovered()

end




s10086_sequence.OnInterpreterRecognized = function( messageName, gameObjectId )

	Fox.Log( "s10086_sequence.OnInterpreterRecognized(): messageName:" .. tostring( messageName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

	s10086_radio.OnInterpreterRecognized()	

	local objectiveList = { "missionTask_clear_recognizeInterpreter", }
	if TppSequence.GetCurrentSequenceName() == "Seq_Game_Escape" then
		table.insert( objectiveList, "marker_interpreter_cleared_again" )
		TppMarker.SetQuestMarker( s10086_enemy.INTERPRETER_NAME )
	else
		table.insert( objectiveList, "marker_interpreter_clear" )
	end
	TppMission.UpdateObjective{ objectives = objectiveList, }	

end




s10086_sequence.OnTargetRecognized = function( messageName, gameObjectId )

	Fox.Log( "s10086_sequence.OnTargetRecognized(): messageName:" .. tostring( messageName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

	s10086_radio.OnTargetRecognized()
	local radioGroup = s10086_radio.GetTargetRecognizedRadio()
	local objectiveList = { "subGoal_recovery", "missionTask_clear_recognizeTarget", }

	if svars.reservedBoolean0008 then
		Fox.Log( "s10086_sequence.OnTargetRecognized(): svars.reservedBoolean0008 is true." )
		table.insert( objectiveList, "marker_interpreter_already" )
		svars.reservedBoolean0009 = true
	else
		Fox.Log( "s10086_sequence.OnTargetRecognized(): svars.reservedBoolean0008 is false." )
		table.insert( objectiveList, "marker_interpreter_none" )
	end

	TppMission.UpdateObjective{ objectives = objectiveList, radio = { radioGroups = radioGroup, }, }	

end




s10086_sequence.OnFakeTargetRecognized = function( messageName, gameObjectId )

	Fox.Log( "s10086_sequence.OnFakeTargetRecognized(): messageName:" .. tostring( messageName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

	s10086_radio.OnFakeTargetRecognized( gameObjectId )	

end





s10086_sequence.OnRecognized = function( messageName, gameObjectId )

	Fox.Log( "s10086_sequence.OnRecognized(): messageName:" .. tostring( messageName ) .. ", gameObjectId:" .. tostring( gameObjectId ) )

	local flagName = s10086_sequence.GetRecognizedFlagName( s10086_enemy.GetNpcName( gameObjectId ) )
	svars[ flagName ] = true

	if not s10086_sequence.afterRecognizeFuncTable or not next( s10086_sequence.afterRecognizeFuncTable ) then
		



		s10086_sequence.afterRecognizeFuncTable = {
			[ GameObject.GetGameObjectId( s10086_enemy.INTERPRETER_NAME ) ] = s10086_sequence.OnInterpreterRecognized,
			[ GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME ) ] = s10086_sequence.OnTargetRecognized,
			[ GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET1_NAME ) ] = s10086_sequence.OnFakeTargetRecognized,
			[ GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET2_NAME ) ] = s10086_sequence.OnFakeTargetRecognized,
			[ GameObject.GetGameObjectId( s10086_enemy.FAKE_TARGET3_NAME ) ] = s10086_sequence.OnFakeTargetRecognized,
		}
	end

	local func = s10086_sequence.afterRecognizeFuncTable[ gameObjectId ]
	if func then
		func( messageName, gameObjectId )
	end

end






s10086_sequence.IsRecognized = function( locatorName )

	Fox.Log( "s10086_sequence.IsRecognized(): locatorName:" .. tostring( locatorName ) )

	local recognizedFlag = s10086_sequence.GetRecognizedFlagName( locatorName )
	return svars[ recognizedFlag ]

end




s10086_sequence.OnChangePahse = function( gameObjectId, newPhase, prePhase )

	Fox.Log( "s10086_sequence.OnChangePahse(): gameObjectId:" .. tostring( gameObjectId ) .. ", newPhase:" .. tostring( newPhase ) .. ", prePhase:" .. tostring( prePhase ) )

	local swampCpId = GameObject.GetGameObjectId( "mafr_swamp_cp" )
	local targetCpId = GameObject.GetGameObjectId( "mafr_target_ob" )
	local cpIdList = { swampCpId, targetCpId }
	local isSwampCp = gameObjectId == swampCpId
	local isTargetCp = gameObjectId == targetCpId

	if newPhase == TppGameObject.PHASE_ALERT then
		s10086_sequence.StartTimer( "Timer_CautionRadio", 5 )
	end

	local isAlert = ( prePhase == TppGameObject.PHASE_ALERT or prePhase == TppGameObject.PHASE_EVASION ) and
		( newPhase == TppGameObject.PHASE_CAUTION or newPhase == TppGameObject.PHASE_SNEAK )
	if ( isSwampCp or isTargetCp ) and isAlert then

		






		s10086_sequence.KillHostages()

		s10086_sequence.StopTimer( "Timer_SealingToCancelFollwing" )
		s10086_sequence.StartTimer( "Timer_SealingToCancelFollwing", 30 )

	end

	if newPhase == TppGameObject.PHASE_CAUTION then
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.INTERPRETER_NAME ), { id="SetRestrictNotice", enabled = true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.INTERROGATOR_NAME ), { id="SetRestrictNotice", enabled = true } )
	end

end




s10086_sequence.KillHostages = function( isLdTrigger )

	Fox.Log( "s10086_sequence.KillHostages()" )

	s10086_sequence.StopRouteTimeOutTimer()

	Fox.Log( "s10086_sequence.KillHostages(): Kill All Hostages." )

	














	s10086_sound.OnHostageKilled()

	
	

	s10086_sequence.StartTimer( "Timer_ToKillFakeTarget1", 15 )
	s10086_sequence.StartTimer( "Timer_ToKillFakeTarget2", 45 )
	s10086_sequence.StartTimer( "Timer_ToKillFakeTarget3", 75 )
	

	TppEnemy.SetSneakRoute( s10086_enemy.INTERROGATOR_NAME, "rts_interrogator_interrogation4_0001" )
	TppEnemy.SetCautionRoute( s10086_enemy.INTERROGATOR_NAME, "rts_interrogator_interrogation4_0001" )
	TppEnemy.SetSneakRoute( s10086_enemy.INTERPRETER_NAME, "rts_interpreter_interrogation4_0001" )
	TppEnemy.SetCautionRoute( s10086_enemy.INTERPRETER_NAME, "rts_interpreter_interrogation4_0001" )
	svars.reservedNumber0000 = 61

end




s10086_sequence.StopRouteTimeOutTimer = function()

	s10086_sequence.StopTimer( "Timer_WaitInterpreter" )
	s10086_sequence.StopTimer( "Timer_WaitInterrogator" )
	s10086_sequence.StopTimer( "Timer_WaitGuard1" )

end




s10086_sequence.OnGuardEliminated = function( guardId )

	
	local hostageName = s10086_enemy.GetHostageNameFromGuradName( guardId )

	
	s10086_enemy.SetHostageFlee( hostageName )

end




s10086_sequence.OnHostageCarried = function( hostageId )

	
	s10086_enemy.SetHostageFlee( hostageId )

end





s10086_sequence.OnInterrogation3Ready = function()

	Fox.Log( "s10086_sequence.OnInterrogation3Ready()" )

	local conversationTypeList = {
		s10086_sequence.CONVERSATION_TYPE.SWAMP1,
		s10086_sequence.CONVERSATION_TYPE.SWAMP2,
		s10086_sequence.CONVERSATION_TYPE.SWAMP3,
	}
	for i, conversationType in ipairs( conversationTypeList ) do
		if s10086_sequence.IsConversationReady( conversationType ) then
			Fox.Log( "s10086_sequence.OnInterrogation3Ready(): conversationType:" .. tostring( conversationType ) )
			s10086_sequence.CallConversation( conversationType )
			return
		else
			Fox.Log( "s10086_sequence.OnInterrogation3Ready(): ignore conversationType:" .. tostring( conversationType ) )
		end
	end

	s10086_sequence.OnRoutePoint( s10086_enemy.GUARD1_NAME, nil, nil, Fox.StrCode32( "Interrogation3End" ) )	


end




s10086_sequence.IsConversationReady = function( conversationType )

	Fox.Log( "s10086_sequence.IsConversationReady(): conversationType:" .. tostring( conversationType ) )

	local enemyList = s10086_sequence.CONVERSATION_ENEMY_TABLE[ conversationType ]	

	
	for i, enemyAndRouteTable in pairs( enemyList ) do
		local enemyName = enemyAndRouteTable.enemyName
		local isEnemyNormal = s10086_enemy.IsEnemyNormal( enemyName )

		local routeName = enemyAndRouteTable.routeName
		local cautionRouteName = enemyAndRouteTable.cautionRouteName
		local isOnRoute
		if routeName or cautionRouteName then
			isOnRoute = ( s10086_enemy.IsEnemyOnRoute( enemyName, routeName ) or s10086_enemy.IsEnemyOnRoute( enemyName, cautionRouteName ) )
		else
			isOnRoute = true
		end

		local identifierName = enemyAndRouteTable.identifierName
		local key = enemyAndRouteTable.key
		local isInRange
		if identifierName and key then
			local position, rotationY = Tpp.GetLocator( identifierName, key )
			isInRange = GameObject.SendCommand( GameObject.GetGameObjectId( enemyName ), { id = "IsInRange", range = 5, target = { position[ 1 ], position[ 2 ], position[ 3 ], }, } )
		else
			isInRange = true
		end

		Fox.Log( "s10086_sequence.IsConversationReady(): enemyName:" .. tostring( enemyName ) .. ", isEnemyNormal:" .. tostring( isEnemyNormal ) ..
			", isOnRoute:" .. tostring( isOnRoute ) .. ", isInRange:" .. tostring( isInRange ) )
		local result = isEnemyNormal and isOnRoute and isInRange
		if not result then
			return false
		end
	end

	return true

end





s10086_sequence.CallConversation = function( conversationType, targetSpeechLabel )

	Fox.Log( "s10086_sequence.CallConversation(): conversationType:" .. tostring( conversationType ) .. ", targetSpeechLabel:" .. tostring( targetSpeechLabel ) )

	local firstLabel = false	

	local speechLabel
	if targetSpeechLabel then
		speechLabel = targetSpeechLabel
	else
		if Tpp.IsTypeTable( SPEECH_TABLE[ conversationType ].id ) then
			speechLabel = SPEECH_TABLE[ conversationType ].id[ 1 ]
		else
			speechLabel = SPEECH_TABLE[ conversationType ].id
		end
		firstLabel = true	
	end

	
	if mvars.conversationStarted and mvars.conversationStarted[ speechLabel ] then
		Fox.Log( "s10086_sequence.CallConversation(): ignore operation because mvars.conversationStarted is true." )
		return
	end

	
	if not s10086_sequence.IsConversationReady( conversationType ) then
		Fox.Log( "s10086_sequence.CallConversation(): ignore operation because s10086_sequence.IsConversationReady() is false." )
		return
	end

	local speakerName = s10086_sequence.CONVERSATION_ENEMY_TABLE[ conversationType ].speaker.enemyName	
	local friendName = s10086_sequence.CONVERSATION_ENEMY_TABLE[ conversationType ].friend.enemyName	

	if not mvars.SPECIAL_MONOLOGUE_TABLE[ speechLabel ] then
		s10086_enemy.CallConversation( speakerName, friendName, speechLabel )
	else
		s10086_enemy.CallMonologue( mvars.SPECIAL_MONOLOGUE_TABLE[ speechLabel ].speaker, speechLabel, friendName )
	end

	if conversationType ~= s10086_sequence.CONVERSATION_TYPE.SWAMP_WEST_NEAR and s10086_enemy.IsFakeTarget( friendName ) and targetSpeechLabel == nil then	
		s10086_radio.OnFakeTargetInterrogationStarted( friendName )
	else
		Fox.Log( "s10086_sequence.CallConversation(): ignore to set intel radio." )
	end

	if speechLabel then
		if not mvars.conversationStarted then
			mvars.conversationStarted = {}
		end
		mvars.conversationStarted[ speechLabel ] = true
	end

end




s10086_sequence.GetNextSpeechLabel = function( s_speechLabel )

	for conversationType, speechTable in pairs( SPEECH_TABLE ) do
		local speechLabelList = speechTable.id
		if not Tpp.IsTypeTable( speechLabelList ) then
			speechLabelList = { speechLabelList }
		end

		
		local speakerId
		if s10086_sequence.CONVERSATION_ENEMY_TABLE[ conversationType ] then
			speakerId = s10086_sequence.CONVERSATION_ENEMY_TABLE[ conversationType ].speaker.enemyName
		end

		for i, label in ipairs( speechLabelList ) do
			if Fox.StrCode32( label ) == s_speechLabel then
				local key, value = next( speechLabelList, i )
				return conversationType, value, label, speakerId
			end
		end
	end

	return nil

end




s10086_sequence.IsDay = function()

	return TppClock.GetTimeOfDay() == "day"

end




s10086_sequence.DoesNotBecomeAtNight = function()

	return not svars.reservedBoolean0001

end





s10086_sequence.StartTimer = function( timerName, timerTime )

	Fox.Log( "s10086_sequence.StartTimer(): timerName:" .. tostring( timerName ) .. ", timerTime:" .. tostring( timerTime ) )

	if not GkEventTimerManager.IsTimerActive( timerName ) then
		GkEventTimerManager.Start( timerName, timerTime )
	end

	if timerName == "Timer_WaitInterpreter" then
		svars.reservedBoolean0003 = true
	elseif timerName == "Timer_WaitInterrogator" then
		svars.reservedBoolean0004 = true
	elseif timerName == "Timer_WaitGuard1" then
		svars.reservedBoolean0006 = true
	end

end




s10086_sequence.StopTimer = function( timerName )

	Fox.Log( "s10086_sequence.StopTimer(): timerName:" .. tostring( timerName ) )

	GkEventTimerManager.Stop( timerName )

	if timerName == "Timer_WaitInterpreter" then
		svars.reservedBoolean0003 = false
	elseif timerName == "Timer_WaitInterrogator" then
		svars.reservedBoolean0004 = false
	elseif timerName == "Timer_WaitGuard1" then
		svars.reservedBoolean0006 = false
	end

end




s10086_sequence.OnInterrogationLocationDetected = function()

	Fox.Log( "s10086_sequence.OnInterrogationLocationDetected()" )

	TppMission.UpdateObjective{ objectives = { "marker_interrogation", } }

end





s10086_sequence.OnInterpreterInterrogated = function()

	Fox.Log( "s10086_sequence.OnInterpreterInterrogated()" )

end





s10086_sequence.IsPhaseAlert = function()

	Fox.Log( "s10086_sequence.IsPhaseAlert()" )
	return not Tpp.IsNotAlert()

end




s10086_sequence.IsAllFakeTargetRecovered = function()

	Fox.Log( "s10086_sequence.IsAllFakeTargetRecovered()" )

	for i, fakeTargetName in ipairs( s10086_enemy.FAKE_TARGETS ) do
		if not TppEnemy.IsRecovered( fakeTargetName ) then
			return false
		end
	end

	return true

end




s10086_sequence.IsInterpreterDead = function()

	Fox.Log( "s10086_sequence.IsInterpreterDead()" )
	return svars.reservedBoolean0007

end





sequences.Seq_Game_SearchTarget = {

	Messages = function( self )
		return
		StrCode32Table {
			GameObject = {
				{	
					msg = "Fulton",
					sender = s10086_enemy.TARGET_NAME,
					func = self.OnTargetRecovered
				},
				{	
					msg = "PlacedIntoVehicle",
					sender = s10086_enemy.TARGET_NAME,
					func = function ( passengerId, vehicleId )

						Fox.Log( "sequences.Seq_Game_SearchTarget.Messages(): passengerId" .. tostring( passengerId ) .. ", vehicleId" .. tostring( vehicleId ) )

						if	vehicleId == GameObject.GetGameObjectId("SupportHeli") and
							passengerId == GameObject.GetGameObjectId( s10086_enemy.TARGET_NAME ) then

							self.OnTargetRecovered( passengerId )

						end

					end
				},
				{	
					msg = "Dead",
					sender = s10086_enemy.FAKE_TARGETS,
					func = self.OnFakeTargetKilled
				},
				{	
					msg = "Unlocked",
					sender = { s10086_enemy.FAKE_TARGET1_NAME, s10086_enemy.FAKE_TARGET2_NAME, s10086_enemy.FAKE_TARGET3_NAME, s10086_enemy.TARGET_NAME, },
					func = function( gameObjectId )
						local command = { id = "SetNoticeState", state = TppGameObject.HOSTAGE_NOTICE_STATE_FLEE }
						GameObject.SendCommand( gameObjectId, command )
					end
				},
				{	
					msg = "Dead",
					sender = s10086_enemy.INTERPRETER_NAME,
					func = self.OnInterpreterNeutralized,
				},
				{	
					msg = "Unconscious",
					sender = s10086_enemy.INTERPRETER_NAME,
					func = self.OnInterpreterNeutralized,
				},
				{	
					msg = "Holdup",
					sender = s10086_enemy.INTERPRETER_NAME,
					func = self.OnInterpreterNeutralized,
				},
				{	
					msg = "Dead",
					sender = s10086_enemy.INTERROGATOR_NAME,
					func = self.OnInterrogatorNeutralized,
				},
				{	
					msg = "Unconscious",
					sender = s10086_enemy.INTERROGATOR_NAME,
					func = self.OnInterrogatorNeutralized,
				},
				{	
					msg = "Holdup",
					sender = s10086_enemy.INTERROGATOR_NAME,
					func = self.OnInterrogatorNeutralized,
				},
			},
			Timer = {
				{	
					msg = "Finish",
					sender = "Timer_ToKillFakeTarget1",
					func = function()

						Fox.Log( "Timer_ToKillFakeTarget1" )

						
						s10086_enemy.CallCpRadio( "mafr_swamp_cp", "CPR0286_CP" )

						s10086_enemy.ExecuteHostage( s10086_enemy.GUARD1_NAME, s10086_enemy.FAKE_TARGET1_NAME )

					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_ToKillFakeTarget2",
					func = function()

						Fox.Log( "Timer_ToKillFakeTarget2" )
						s10086_enemy.ExecuteHostage( s10086_enemy.GUARD2_NAME, s10086_enemy.FAKE_TARGET2_NAME )

					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_ToKillFakeTarget3",
					func = function()

						Fox.Log( "Timer_ToKillFakeTarget3" )
						s10086_enemy.ExecuteHostage( s10086_enemy.GUARD3_NAME, s10086_enemy.FAKE_TARGET3_NAME )

					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_ToKillTarget",
					func = function()

						Fox.Log( "Timer_ToKillTarget" )
						s10086_enemy.ExecuteHostage( s10086_enemy.GUARD4_NAME, s10086_enemy.TARGET_NAME )

					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_WaitInterpreter",
					func = function()
						
						if s10086_enemy.IsEnemyNormal( s10086_enemy.INTERPRETER_NAME ) then
							s10086_sequence.StartTimer( "Timer_WaitInterpreter", 60 )
						else
							s10086_sequence.KillHostages( true )
						end
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_WaitInterrogator",
					func = function()
						
						if s10086_enemy.IsEnemyNormal( s10086_enemy.INTERROGATOR_NAME ) then
							s10086_sequence.StartTimer( "Timer_WaitInterrogator", 60 )
						else
							s10086_sequence.KillHostages( true )
						end
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_WaitGuard1",
					func = function()
						Fox.Log( "sequences.Seq_Game_SearchTarget.Messages(): Timer: Finish: Timer_WaitGuard1" )
						
						if s10086_enemy.IsEnemyNormal( { s10086_enemy.GUARD1_NAME, s10086_enemy.INTERPRETER_NAME, s10086_enemy.INTERROGATOR_NAME, } ) then
							s10086_sequence.StartTimer( "Timer_WaitGuard1", 60 )
						else
							s10086_sequence.OnRoutePoint( s10086_enemy.GUARD1_NAME, nil, nil, Fox.StrCode32( "Interrogation1End" ) )	
							s10086_enemy.SetCautionPhase()
						end
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_InterpreterRecovered",
					func = function()
						s10086_sequence.OnInterrogationLocationDetected()
						s10086_radio.AfterInterpreterRecovered()
						TppSave.UpdateMotherBaseStaffWithoutCheckpointSave()
						svars.reservedNumber0002 = 0
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_CautionRadio",
					func = function()
						s10086_radio.OnKillingTarget()
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_WaitToPlayInterrogationRadio",
					func = function()
						if Tpp.IsNotAlert then
							s10086_radio.OnDelayAfterInterrogationFinished()
						else
							s10086_sequence.StartTimer( "Timer_WaitToPlayInterrogationRadio", 10 )
						end
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_WaitToPlayInterrogationRadio2",
					func = function()
						if Tpp.IsNotAlert then
							s10086_radio.AfterInterpreterInterogated2()
						else
							s10086_sequence.StartTimer( "Timer_WaitToPlayInterrogationRadio2", 10 )
						end
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_WaitToPlayInterrogationRadio3",
					func = function()
						if Tpp.IsNotAlert then
							s10086_radio.OnEnglishSubtitlesShown()
						end
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_SealingToCancelFollwing",
					func = function()
						if not s10086_sequence.IsRecognized( s10086_enemy.TARGET_NAME ) then
							s10086_radio.OnSealedToCancelFollowing()
						end
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Interrogation1TimeOut",
					func = function()
						Fox.Log( "sequences.Seq_Game_SearchTarget.Messages(): Timer: Finish: Timer_Interrogation1TimeOut" )
						s10086_sequence.OnRoutePoint( s10086_enemy.GUARD1_NAME, nil, nil, Fox.StrCode32( "Interrogation1End" ) )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Interrogation2TimeOut",
					func = function()
						s10086_sequence.OnRoutePoint( s10086_enemy.INTERROGATOR_NAME, nil, nil, Fox.StrCode32( "Interrogation2End" ) )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Interrogation3TimeOut",
					func = function()
						s10086_sequence.OnRoutePoint( s10086_enemy.INTERROGATOR_NAME, nil, nil, Fox.StrCode32( "Interrogation3End" ) )
					end,
				},
				{	
					msg = "Finish",
					sender = "Timer_Interrogation4TimeOut",
					func = function()
						
					end,
				},
			},
			Sound = {
				{	
					msg = "ChangeBgmPhase",
					func = function ( bgmPhase )
						Fox.Log( "sequences.Seq_Game_SearchTarget.Messages(): Sound: ChangeBgmPhase: bgmPhase:" .. tostring( bgmPhase ) )

						if bgmPhase == TppSystem.BGM_PHASE_SNEAK_1 or
							bgmPhase == TppSystem.BGM_PHASE_SNEAK_2 or
							bgmPhase == TppSystem.BGM_PHASE_SNEAK_3 then

							local position, rotY = GameObject.SendCommand( GameObject.GetGameObjectId( s10086_enemy.INTERPRETER_NAME ), { id="GetPosition", } )	
							local distance = math.sqrt( TppMath.FindDistance( TppMath.Vector3toTable( position ), TppPlayer.GetPosition() ) )	

							if s10086_sequence.IsRecognized( s10086_enemy.INTERPRETER_NAME ) and distance < 100 then
								TppSound.SetPhaseBGM( "bgm_s10086_follow" )
							else
								TppSound.SetPhaseBGM( "bgm_s10086_normal" )
							end

						end
					end
				},
			},
			Radio = {
				{
					msg = "Finish",
					func = function( radioGroupNameHash )
						Fox.Log( "sequences.Seq_Game_SearchTarget.Messages(): Radio: Finish:" )
						if radioGroupNameHash == Fox.StrCode32( "s0086_oprg0090" ) then
							TppMission.UpdateObjective{ objectives = { "marker_intel", }, }
						end
					end,
				},
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
			TppCoder.SetWorldCenter(Vector3(-139.4411, -3.350814, 47.33446))
		end
		
		TppTelop.StartCastTelop()

		if TppSequence.GetContinueCount() == 0 then
			
			s10086_radio.OnSearchTargetSequenceEnter()
			
		else
			s10086_radio.MissionStart()
		end

		
		TppMission.UpdateObjective{
			objectives = {
				"photo_target",
				"photo_interpreter",
				"subGoal_default",
				"missionTask_recognizeInterpreter",
				"missionTask_recognizeTarget",
				"missionTask_recoverTarget",
				"missionTask_intel",
				"missionTask_recoverAllHostage",
				"missionTask_recoverContainer",
				"missionTask_allInterrogation",
			},
		}
		
		local radioGroup = s10086_radio.GetMissionStartRadio()
		TppMission.UpdateObjective{
			objectives = {
				"marker_interpreter1",
			},
			radio = {
				radioGroups = radioGroup
			},
		}

		
		s10086_sequence.StartTimer( "Timer_SealingToCancelFollwing", 900 )

		
		TppInterrogation.AddHighInterrogation(
			GameObject.GetGameObjectId( "mafr_swamp_cp" ),
			{ 
				{ name = "enqt1000_101524", func = s10086_enemy.InterCall_Intel, },	
			}
		)

		
		if svars.reservedNumber0002 == 1 then
			s10086_sequence.StartTimer( "Timer_InterpreterRecovered", 30 )
		end

	end,

	



	OnTargetRecovered = function( gameObjectId )

		Fox.Log( "s10086_sequence.sequences.Seq_Game_SearchTarget.OnTargetRecovered( " .. gameObjectId .. " )" )

		if gameObjectId == GameObject.GetGameObjectId( "TppHostage2", s10086_enemy.TARGET_NAME ) then				
			TppSequence.SetNextSequence("Seq_Game_Escape")
		end

	end,

	


	OnFakeTargetKilled = function( gameObjectId, killerId )

		Fox.Log( "s10086_sequence.sequences.Seq_Game_SearchTarget.OnFakeTargetDead(): gameObjectId:" .. tostring( gameObjectId ) .. ", killerId:" .. tostring( killerId ) )

		if killerId and GameObject.GetTypeIndex( killerId ) ~= TppGameObject.GAME_OBJECT_TYPE_PLAYER2 then
			s10086_radio.OnFakeTargetKilled()
		end

	end,

	



	OnInterpreterNeutralized = function( gameObjectId )

		Fox.Log( "s10086_sequence.OnInterpreterNeutralized( " .. tostring( gameObjectId ) .. " )" )

		if gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.INTERPRETER_NAME ) then	
			s10086_radio.OnTailingCanceled()
			s10086_sequence.StopTimer( "Timer_SealingToCancelFollwing" )
			s10086_sequence.StartTimer( "Timer_SealingToCancelFollwing", 300 )
		end

		svars.reservedBoolean0005 = true

		
		s10086_sequence.StartTimer( "Timer_WaitToPlayInterrogationRadio", 180 )
		s10086_sequence.StartTimer( "Timer_WaitToPlayInterrogationRadio2", 190 )

	end,

	OnInterrogatorNeutralized = function( gameObjectId )

		Fox.Log( "s10086_sequence.OnInterrogatorNeutralized( " .. tostring( gameObjectId ) .. " )" )

		if gameObjectId == GameObject.GetGameObjectId( "TppSoldier2", s10086_enemy.INTERROGATOR_NAME ) then	
			s10086_sequence.StopTimer( "Timer_SealingToCancelFollwing" )
			s10086_sequence.StartTimer( "Timer_SealingToCancelFollwing", 30 )
		end

		svars.reservedBoolean0005 = true

	end,

	OnLeave = function( self )

		Fox.Log( "sequences.Seq_Game_SearchTarget.OnLeave()" )
		TppMission.CanMissionClear()							

	end,

}


sequences.Seq_Game_Escape = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{
					msg = "HeliDoorClosed",
					sender = "SupportHeli",
					func = function()

					end
				},
				nil,
			},
			nil
		}
	end,

	OnEnter = function( self )

		Fox.Log( "sequences.Seq_Game_Escape.OnEnter()" )

		TppMission.UpdateObjective{ objectives = { "marker_target_clear", }, }

		local objectiveList = { "photo_target_recovered", "subGoal_escape", }

		local interpreterMarkerEnabled
		if TppMotherBaseManagement.IsExistStaff{ skill = "TranslateAfrikaans", } then
			table.insert( objectiveList, "marker_interpreter_recovered_again" )
		elseif TppEnemy.IsRecovered( s10086_enemy.INTERPRETER_NAME ) then
			table.insert( objectiveList, "marker_interpreter_recovered_again" )
			interpreterMarkerEnabled = true
		elseif s10086_sequence.IsRecognized( s10086_enemy.INTERPRETER_NAME ) then
			table.insert( objectiveList, "marker_interpreter_again" )
			interpreterMarkerEnabled = true
		elseif s10086_sequence.IsInterpreterDead() then
			table.insert( objectiveList, "marker_target_recovered" )
		elseif svars.reservedBoolean0009 then
			table.insert( objectiveList, "marker_interpreter_again" )
			interpreterMarkerEnabled = true
		else
			table.insert( objectiveList, "marker_target_recovered" )
		end

		if interpreterMarkerEnabled then
			TppMarker.SetQuestMarker( s10086_enemy.INTERPRETER_NAME )
		end

		local radioList = s10086_radio.GetTargetRecoveredRadio()
		TppMission.UpdateObjective{ objectives = objectiveList, radio = { radioGroups = radioList }, }
		s10086_radio.OnTargetRecovered()

		TppSound.SetPhaseBGM( "bgm_s10086_normal" )

	end,

}




return s10086_sequence
