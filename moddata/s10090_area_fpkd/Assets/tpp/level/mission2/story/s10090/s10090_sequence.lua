local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local IsTypeFunc = Tpp.IsTypeFunc
local IsTypeTable = Tpp.IsTypeTable
local IsTypeString = Tpp.IsTypeString
local GetGameObjectId = GameObject.GetGameObjectId
local NULL_ID = GameObject.NULL_ID

local sequences = {}





if DEBUG then


this.DEBUG_NO_PARASITES_APPEAR = false

end 





if DEBUG then

this.dbgMissionStartSettingTable	= {}

end 


this.commonFuncTable				= {}
this.vehicleSettingTable			= {}
this.conversationSettingTable		= {}
this.trapSettingTable				= {}
this.motorcadeSettingTable			= {}
this.timerSettingTable				= {}
this.checkSettingTable				= {}


local MARKER_NAME = {
	AREA_PFCAMPNORTH					= "s10090_marker_pfCampNorth",					
	AREA_PFCAMP							= "s10090_marker_pfCamp",						
	AREA_SWAMP							= "s10090_marker_swamp",						
	AREA_GOAL							= "s10090_marker_goal",							
}


local TRAP_NAME = {
	
	INTEL_SAVANNAH						= "s10090_trap_IntelAtsavannah",				
	INTEL_PFCAMPNORTH					= "s10090_trap_IntelAtpfCampNorth",				
	INTEL_PFCAMPEAST					= "s10090_trap_IntelAtpfCampEast",				
	INTEL_SWAMPEAST						= "s10090_trap_IntelAtswampEast",				
	INTEL_MARKER_SAVANNAH				= "s10090_trap_IntelMarkerAtsavannah",			
	INTEL_MARKER_PFCAMPNORTH			= "s10090_trap_IntelMarkerAtpfCampNorth",		
	INTEL_MARKER_PFCAMPEAST				= "s10090_trap_IntelMarkerAtpfCampEast",		
	INTEL_MARKER_SWAMPEAST				= "s10090_trap_IntelMarkerAtswampEast",			
	INTEL_LOADDEMO						= "s10090_trap_LoadDemoIntel",					
	
	ESCORTVEHICLE_START					= "s10090_trap_EscortVehicleStart",				
	
	MOTORCASE_START_PFCAMP				= "s10090_trap_MotorcaseArea01",				
	MOTORCASE_START_SWAMPSOUTH			= "s10090_trap_MotorcaseArea02",				
	MOTORCASE_START_SWAMP				= "s10090_trap_MotorcaseArea03",				
	
	ARRIVALATPFCAMPNORTH_01				= "s10090_trap_ArrivalAtpfCampNorth01",			
	ARRIVALATPFCAMPNORTH_02				= "s10090_trap_ArrivalAtpfCampNorth02",			
	ARRIVALATPFCAMP						= "s10090_trap_ArrivalAtpfCamp",				
	ARRIVALATSWAMP						= "s10090_trap_ArrivalAtswamp",					
	ARRIVALATFLOWSTATION				= "s10090_trap_ArrivalAtflowStation",			
	ARRIVALATTRANSPORTPOINT				= "s10090_trap_ArrivalAtTransportPoint",		
}


local INTEL_SENDER_NAME = {
	SAVANNAH							= "Intel_savannah",								
	PFCAMPNORTH							= "Intel_pfCampNorth",							
	PFCAMPEAST							= "Intel_pfCampEast",							
	SWAMPEAST							= "Intel_swampEast",							
}


this.TIMER_LIST = {
	
	ESCORT_START						= { timerName = "TimerEscortStart",					time = 240,					},
	ESCORT_START_STOP					= { timerName = "TimerEscortStart",								stop = true,	},
	ESCORT_WAV_START					= { timerName = "TimerEscortWavStart",				time = 1,					},
	ESCORT_WAV_DEAD						= { timerName = "TimerEscortWavDead",				time = 240,					},
	ESCORT_VEHICLE_START_01				= { timerName = "TimerEscortVehicleStart01",		time = 120,					},
	ESCORT_VEHICLE_START_02				= { timerName = "TimerEscortVehicleStart02",		time = 5,					},
	
	MOTORCADE_START_PFCAMP				= { timerName = "TimerMotorcadeStartpfCamp",		time = 180,					},
	MOTORCADE_START_PFCAMP_COMEBACK		= { timerName = "TimerMotorcadeStartpfCamp",		time = 10,					},
	MOTORCADE_STOP_PFCAMP				= { timerName = "TimerMotorcadeStartpfCamp",					stop = true,	},
	MOTORCADE_START_SWAMPSOUTH			= { timerName = "TimerMotorcadeStartswampSouth",	time = 150,					},
	MOTORCADE_START_SWAMPSOUTH_COMEBACK	= { timerName = "TimerMotorcadeStartswampSouth",	time = 10,					},
	MOTORCADE_START_SWAMP				= { timerName = "TimerMotorcadeStartswamp",			time = 150,					},
	MOTORCADE_START_SWAMP_COMEBACK		= { timerName = "TimerMotorcadeStartswamp",			time = 10,					},
	
	MOTORCADE_CHECK_PFCAMP				= { timerName = "TimerEscortVehicleEnd",			time = 2,					},
	MOTORCADE_CHECK_SWAMPSOUTH			= { timerName = "TimerMotorcadeCheckswampSouth",	time = 5,					},
	MOTORCADE_CHECK_SWAMP				= { timerName = "TimerMotorcadeCheckswamp",			time = 5,					},
	
	EVENT_SWAMPSOUTH01					= { timerName = "TimerActEvent_swampSouth01",		time = 2				,	},
	EVENT_SWAMPSOUTH02					= { timerName = "TimerActEvent_swampSouth02",		time = 10,					},
	
	CHECK_RANGE_TARGET					= { timerName = "TimerCheckParasites",				time = 1,	stop = true,	},
	CHECK_STOP_RANGE_TARGET				= { timerName = "TimerCheckParasites",							stop = true,	},
	
	RADIO_START_ARRIVALATAREA			= { timerName = "TimerRadioArea",					time = 90,					},
	RADIO_STOP_ARRIVALATAREA			= { timerName = "TimerRadioArea",								stop = true,	},
	
	DEBUG_MOTORCADE_START_PFCAMP		= { timerName = "TimerMotorcadeStartpfCamp",		time = 5,					},
	DEBUG_MOTORCADE_START_SWAMPSOUTH	= { timerName = "TimerMotorcadeStartswampSouth",	time = 5,					},
	DEBUG_MOTORCADE_START_SWAMP			= { timerName = "TimerMotorcadeStartswamp",			time = 5,					},
	DEBUG_EVENT_SWAMPSOUTH01			= { timerName = "TimerActEvent_swampSouth01",		time = 2,					},
	DEBUG_PARASITES						= { timerName = "TimerMotorcadeStartswampSouth",				stop = true,	},
	
	STOP_01								= { timerName = "TimerEscortStart",								stop = true,	},
	STOP_02								= { timerName = "TimerEscortWavStart",							stop = true,	},
	STOP_03								= { timerName = "TimerEscortWavDead",							stop = true,	},
	STOP_04								= { timerName = "TimerEscortVehicleStart01",					stop = true,	},
	STOP_05								= { timerName = "TimerEscortVehicleStart02",					stop = true,	},
	STOP_06								= { timerName = "TimerEscortVehicleEnd",						stop = true,	},
	STOP_07								= { timerName = "TimerMotorcadeStartpfCamp",					stop = true,	},
	STOP_08								= { timerName = "TimerMotorcadeStartswampSouth",				stop = true,	},
	STOP_09								= { timerName = "TimerMotorcadeStartswamp",						stop = true,	},
	STOP_10								= { timerName = "TimerActEvent_swampSouth01",					stop = true,	},
	STOP_11								= { timerName = "TimerActEvent_swampSouth02",					stop = true,	},
	STOP_12								= { timerName = "TimerCheckParasites",							stop = true,	},
	STOP_13								= { timerName = "TimerRadioArea",								stop = true,	},
}


this.COMMON_MESSAGE_LIST = {
	
	E_INIT								= "EnemyInit",									
	E_INIT_PFCAMPEAST					= "EnemyInitpfCampEast",						
	E_INIT_MESSAGE						= "EnemyInitMessage",							
	
	
	T_VS_PFCAMPEAST						= "TimerVehicleStartpfCampEast",				
	
	
	R_U_GUARD_VIGILANCE					= "UpdateVehicleVigilance",						
	
	
	R_VE_PFCAMP_GUARD01					= "VehicleEndpfCampGuard01",					
	R_VE_PFCAMP_GUARD02					= "VehicleEndpfCampGuard02",					
	T_VE_PFCAMP							= "TimerVehicleEndpfCamp",						
	
	
	R_PFCAMP_CPRADIO01					= "VehicleEndpfCampCpRadio01",					
	C_PFCAMP_ACT_MOVE01					= "CpRadioeEndpfCampActMove01",					
	R_PFCAMP_ACT_MOVE01					= "ActMoveEndpfCampActMove01",					
	R_PFCAMP_CONVERSATION01				= "ActMoveEndpfCampConversation01",				
	
	
	T_PFCAMP_ACT_MOVE01					= "TimerpfCampActMove01",						
	R_PFCAMP_CPRADIO02					= "ActMoveEndpfCampConversation02",				
	
	
	R_VP_PFCAMP_TRUCK					= "VehiclePreparepfCampTruck",					
	
	
	R_VS_PFCAMP_TRUCK					= "VehicleStartpfCampTruck",					
	R_VS_PFCAMP_MOTORCADE				= "VehicleStartpfCampAllTarget",				
	
	
	R_VE_SWAMPSOUTH_GUARD01				= "VehicleEndswampSouthGuard01",				
	R_VE_SWAMPSOUTH_GUARD02				= "VehicleEndswampSouthGuard02",				
	R_VE_SWAMPSOUTH_TARGET				= "VehicleEndswampSouthTarget",					
	
	
	T_SWAMPSOUTH_ACT_MOVE_START			= "TimerswampSouthActMove01",					
	T_SWAMPSOUTH_ACT_MOVE_END			= "TimerswampSouthActMove02",					
	
	
	R_SWAMPSOUTH_ACT_MOVE01				= "ActMoveEndswampSouthActMove01",				
	R_SWAMPSOUTH_CONVERSATION01			= "ActMoveEndswampSouthCon01",					
	
	
	T_VP_SWAMPSOUTH_TRUCK				= "VehiclePrepareswampSouthTruck",				
	T_VS_SWAMPSOUTH_MOTORCADE			= "VehicleStartswampSouthAllTarget",			
	
	
	R_VE_SWAMP_GUARD01					= "VehicleEndswampGuard01",						
	R_VE_SWAMP_GUARD02					= "VehicleEndswampGuard02",						
	R_VE_SWAMP_TARGET					= "VehicleEndswampTarget",						
	
	
	R_SWAMP_ACT_MOVE01					= "ActMoveEndswampActMove01",					
	R_SWAMP_CONVERSATION01				= "ActMoveEndswampConversation01",				
	C_SWAMP_CPRADIO01					= "ConversationEndswampCpRadio01",				
	
	
	T_VP_SWAMP_TRUCK					= "VehiclePrepareswampTruck",					
	T_VS_SWAMP_MOTORCADE				= "VehicleStartswampAllTarget",					
	
	
	R_VE_TRANSPORTPOINT_GUARD01			= "VehicleEndTransportGuard01",					
	R_VE_TRANSPORTPOINT_GUARD02			= "VehicleEndTransportGuard02",					
	
	R_VE_TRANSPORTPOINT_TARGET			= "VehicleEndTransportTarget",					
	R_TRANSPORTPOINT_TARGET_WAIT		= "ActMoveEndTransportTargetWait",				
	R_TRANSPORTPOINT_TARGET_CON			= "ActMoveEndTransportTargetCon",				
	R_TRANSPORTPOINT_TARGET_DEMO		= "CpRadioeEndTransportTargetDemo",				
	
	
	R_F_PFCAMP_ENTER					= "FlagUpdateEnterpfCamp",						
	R_F_PFCAMP_EXIT						= "FlagUpdateExitpfCamp",						
	R_F_SWAMP_ENTER						= "FlagUpdateEnterswamp",						
	R_F_SWAMP_EXIT						= "FlagUpdateExitswamp",						
	R_F_FLOWSTATION_ENTER				= "FlagUpdateEnterflowStation",					
	R_F_FLOWSTATION_EXIT				= "FlagUpdateExitflowStation",					
	
	
	R_R_SWAMP							= "Radioswamp",									
	R_R_SWAMPWEST						= "RadioswampWest",								
	
	
	T_VS_ESCORT_VEHICLE_01				= "TimerVehicleStartEscortVehicle01",			
	R_VE_ESCORT_VEHICLE_01				= "VehicleEndEscortVehicle01",					
	R_VW_ESCORT_VEHICLE_01				= "VehicleWaitEscortVehicle01",					
	R_VS_ESCORT_VEHICLE_01				= "VehicleStartEscortVehicle01",				
	R_VE_ESCORT_VEHICLE_02				= "VehicleEndEscortVehicle02",					
	T_VW_ESCORT_VEHICLE_01				= "TimerVehicleWaitEscortVehicle01",			
	R_VS_ESCORT_VEHICLE_02				= "VehicleStartEscortVehicle02",				
	R_VE_ESCORT_VEHICLE_03				= "VehicleEndEscortVehicle03",					
}


this.CONVERSATION_LIST = {
	PFCAMP_0001							= "HQSP050",									
	PFCAMP_0002							= "speech090_EV010",							
	PFCAMP_0003							= "HQSP060",									
	SWAMPSOUTH_0001						= "speech090_EV020",							
	SWAMP_0001							= "speech090_EV030",							
	SWAMP_0002							= "CPRSP070",									
	TRANSPORTPOINT_0001					= "HQSP070",									
}


this.RANGE_LIST = {
	IN_PARASITES_TO_PFCAMP_01			= 15,											
	IN_PARASITES_TO_PFCAMP_02			= 15,											
	IN_PARASITES_TO_TRANSPORTPOINT		= 35,											
	OUT_PARASITES						= 300,											
}


this.MISSIONTASK_LIST = {
	MAIN_SEARCH_ESCORT				= 0,												
	MAIN_SEARCH_TARGET				= 1,												
	MAIN_RECOVERED_TARGET			= 2,												
	SPECIALBONUS_ELIMINATE_SKULLS	= 3,												
	SPECIALBONUS_RECOVERED_DRIVER	= 4,												
	SUB_INTEL						= 5,												
	SUB_CONVERSATION_GHOST			= 6,												
	SUB_RECOVERED_ZRS				= 7,												
}

this.MISSIONTASK_COUNT_LIST = {
	SUB_RECOVERED_ZRS				= 3,												
}






this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PLACED_LOCATOR_COUNT = 80


this.MAX_PICKABLE_LOCATOR_COUNT = 20


this.EQUIP_MISSION_BLOCK_GROUP_SIZE = 1500000


this.REVENGE_MINE_LIST = { "mafr_savannah", "mafr_pfCamp", "mafr_swamp", "mafr_flowStation" }






this.ENUM_EVENT_VEHICLE_SEQUENCE = Tpp.Enum{
	
	"START",						
	
	"STOP_PFCAMPEAST",				
	"DRIVE_PFCAMPEAST01",			
	"DRIVE_PFCAMPEAST02",			
	
	"ENTER_PFCAMP",					
	"STOP_PFCAMP",					
	"CONVERSATION_PFCAMP",			
	"DRIVE_PFCAMP01",				
	"DRIVE_PFCAMP02",				
	"EXIT_PFCAMP",					
	
	"STOP_SWAMPSOUTH",				
	"CONVERSATION_SWAMPSOUTH",		
	"DRIVE_SWAMPSOUTH",				
	
	"ENTER_SWAMP",					
	"STOP_SWAMP",					
	"CONVERSATION_SWAMP",			
	"DRIVE_SWAMP",					
	"EXIT_SWAMP",					
	
	"ENTER_FLOWSTATION",			
	"STOP_FLOWSTATION",				
	"DRIVE_FLOWSTATION",			
	"EXIT_FLOWSTATION",				
	
	"STOP_TRANSPORTPOINT",			
	"WAIT_TRANSPORTPOINT",			
	"DEMO_TRANSPORTPOINT",			
	
	"ALL_TIMER",					
	"ALL_TIMER_STOP",				
	
	"DEBUG_DRIVE_PFCAMP",			
	"DEBUG_STOP_SWAMPSOUTH",		
	"DEBUG_DRIVE_SWAMPSOUTH",		
	"DEBUG_DRIVE_SWAMP",			
	"DEBUG_PARASITES",				
}


this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE = Tpp.Enum{
	
	"START",						
	
	"STOP_ESCORT01",				
	"DRIVE_ESCORT01",				
	
	"STOP_ESCORT02",				
	"WAIT_ESCORT02",				
	"DRIVE_ESCORT02",				
	
	"STOP_SWAMPSOUTH",				
	"WAIT_SWAMPSOUTH",				
	"DRIVE_SWAMPSOUTH",				
	
	"STOP_ESCORT03",				
}


this.ENUM_AREA = Tpp.Enum{
	
	"INTEL_SAVANNAH",				
	"INTEL_PFCAMPNORTH",			
	"INTEL_PFCAMPEAST",				
	"INTEL_SWAMPEAST",				
	
	"SAVANNAH",						
	"PFCAMP",						
	"SWAMP",						
	"FLOWSTATION",					
	"TRANSPORTPOINT",				
	
	"EVENT_PFCAMP",					
	"EVENT_SWAMPSOUTH",				
	"EVENT_SWAMP",					
	"EVENT_ALL"						
}


this.ENUM_VEHICLE_VALUE_TYPE = Tpp.Enum{
	"MARKINGFLAG",					
	"BROKENFLAG",					
	"FULTONFLAG",					
	"PRESENCE",						
}


this.ENUM_VEHICLE_CHECK_ACTION = Tpp.Enum{
	"DRIVE",
	"STOP",
}











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
	
	eventSequenceIndex					= 0,			
	
	areaTrapIndex						= 0,			
	isArrivalAtTransport				= false,		
	
	isMarkingVehicle01					= false,		
	isMarkingVehicle02					= false,		
	isMarkingVehicle03					= false,		
	
	isBrokenVehicle01					= false,		
	isBrokenVehicle02					= false,		
	isBrokenVehicle03					= false,		
	
	isFultonVehicle01					= false,		
	isFultonVehicle02					= false,		
	isFultonVehicle03					= false,		
	
	timeEndCount01						= 0,
	timeEndCount02						= 0,
	timeEndCount03						= 0,
	
	isEscortVehicleStart				= false,		
	
	motorcadeAreaTrapIndex				= 0,			
	
	vehicleConvoyIndex					= 0,			
	
	isLoadDemoIntelArea					= false,		
	isOnGetIntel						= false,		
	intelAreaTrapIndex					= 0,			
	
	isAppearanceParasites				= false,		
	isDyingAllParasites					= false,		
	
	highInterrogationIndex				= 0,			
	
	firstTargetDriverGameObjectId		= 0,			
	
	fultonZRSCount						= 0,			
	
	isDbgMissionStartIndex				= 0,			
	
	
	isReserveFlag_01					= false,		
	isReserveFlag_02					= false,		
	isReserveFlag_03					= false,		
	isReserveFlag_04					= false,		
	isReserveFlag_05					= false,		
	isReserveFlag_06					= false,		
	isReserveFlag_07					= false,		
	isReserveFlag_08					= false,		
	isReserveFlag_09					= false,		
	isReserveFlag_10					= false,
	
	reserveCount_01						= 0,			
	reserveCount_02						= 0,			
	reserveCount_03						= 0,			
	reserveCount_04						= 0,			
	reserveCount_05						= 0,
	reserveCount_06						= 0,
	reserveCount_07						= 0,
	reserveCount_08						= 0,
	reserveCount_09						= 0,
	reserveCount_10						= 0,
	
	isCheckPointAllDisable				= false,		
	isChangeToEnableZRS					= false,		
	isMissionStart						= false,		
	optionalRadioIndex					= 0,			
	isMissionComplete					= false,		
	parasiteDyingCount					= 0,			
}


this.checkPointList = {
	nil
}


this.baseList = {
	
	"savannah",
	"pfCamp",
	"swamp",
	"flowStation",
	
	"savannahEast",
	"pfCampNorth",
	"pfCampEast",
	"swampSouth",
	"swampEast",
	"swampWest",
}





this.missionObjectiveDefine = {
	
	
	default_area_pfCampNorth = {
		gameObjectName	= MARKER_NAME.AREA_PFCAMPNORTH,		visibleArea = 4, randomRange = 0,	viewType = "all",
		langId = "marker_information",						mapRadioName = "s0090_mprg0010",
		setNew = true,
		announceLog = "updateMap",
	},
	
	
	arrival_at_pfCampNorth = {
		gameObjectName	= MARKER_NAME.AREA_PFCAMPNORTH,		visibleArea = 4, randomRange = 0,	viewType = "all",
		langId = "marker_information",						mapRadioName = "s0090_mprg0020",
		setNew = false,
	},
	
	
	default_photo_targetVehicle = {
		photoId			= 10,								photoRadioName = "s0090_mirg0010",
	},
	default_photo_escortVehicle = {
		photoId			= 20,								photoRadioName = "s0090_mirg0020",
	},
	on_photo_missionComplete_01 = {
		photoId			= 10,
	},
	on_photo_missionComplete_02 = {
		photoId			= 20,
	},
	
	
	area_Intel_pfCampEast = {
		gameObjectName = "s10090_marker_intel_pfCampEast",
		setNew = true,
		announceLog = "updateMap",
	},
	
	area_Intel_pfCampNorth = {
		gameObjectName = "s10090_marker_intel_pfCampNorth",
		setNew = true,
		announceLog = "updateMap",
	},
	
	area_Intel_savannah = {
		gameObjectName = "s10090_marker_intel_savannah",
		setNew = true,
		announceLog = "updateMap",
	},
	
	area_Intel_swampEast = {
		gameObjectName = "s10090_marker_intel_swampEast",
		setNew = true,
		announceLog = "updateMap",
	},
	area_Intel_get = {

	},
	
	
	area_Interrogation_pfCamp = {
		gameObjectName	= MARKER_NAME.AREA_PFCAMP,		visibleArea = 4, randomRange = 0,	viewType = "all",
		langId = "marker_info_mission_targetArea",
		setNew = true,
		announceLog = "updateMap",
	},
	
	
	showEnemyRoute_01 = {
		showEnemyRoutePoints = { groupIndex = 0, width = 150.0, langId = "marker_target_forecast_path",
			points = {
				Vector3( 796.8,0.0,1232.7 ), Vector3( 895.3,0.0,1295.6 ), Vector3( 896.8,0.0,1518.6 ),
				Vector3( 1180.7,0.0,1506.3 ), Vector3( 1367.8,0.0,1466.5 ), Vector3( 1386.0,0.0,1287.7 ),
				Vector3( 1496.8,0.0,1186.8 ), Vector3( 1507.6,0.0,1026.0 ), Vector3( 1329.2,0.0,878.7 ),
				Vector3( 1237.3,0.0,774.7 ), Vector3( 1121.5,0.0,634.3 ), Vector3( 1223.6,0.0,517.3 ),
			},
		},
		announceLog = "updateMap",
	},
	showEnemyRoute_02 = {
		showEnemyRoutePoints = { groupIndex = 1, width = 150.0, langId = "marker_target_forecast_path",
			points = {
				Vector3( 341.2,0.0,367.1 ), Vector3( 398.0,0.0,424.2 ), Vector3( 416.2,0.0,484.1 ),
				Vector3( 424.7,0.0,559.7 ), Vector3( 456.0,0.0,616.2 ), Vector3( 504.6,0.0,678.9 ),
				Vector3( 519.5,0.0,735.5 ), Vector3( 543.8,0.0,778.4 ), Vector3( 577.6,0.0,825.2 ),
				Vector3( 617.2,0.0,850.2 ), Vector3( 585.5,0.0,989.4 ), Vector3( 589.9,0.0,1090.7 ),
				Vector3( 607.7,0.0,1146.8 ), Vector3( 615.9,0.0,1212.3 ), Vector3( 650.0,0.0,1261.8 ),
				Vector3( 725.7,0.0,1319.7 ), Vector3( 799.9,0.0,1357.5 ), Vector3( 851.1,0.0,1392.6 ),
			},
		},
	},
	showEnemyRoute_03 = {
		showEnemyRoutePoints = { groupIndex = 2, width = 150.0, langId = "marker_target_forecast_path",
			points = {
				Vector3( -90.9,0.0,66.6 ), Vector3( -25.1,0.0,34.0 ), Vector3( 74.4,0.0,39.9 ), 
				Vector3( 79.9,0.0,166.3 ), Vector3( 69.6,0.0,245.0 ), Vector3( 94.2,0.0,327.3 ), 
				Vector3( 177.9,0.0,360.4 ), Vector3( 325.7,0.0,361.3 ),
			},
		},
	},
	showEnemyRoute_04 = {
		showEnemyRoutePoints = { groupIndex = 3, width = 150.0, langId = "marker_target_forecast_path",
			points = {
				Vector3( -1235.0,0.0,65.0 ), Vector3( -1215.7,0.0,-32.9 ), Vector3( -1045.5,0.0,-133.3 ), 
				Vector3( -1005.1,0.0,-291.7 ), Vector3( -875.9,0.0,-391.2 ), Vector3( -684.3,0.0,-378.4 ), 
				Vector3( -529.8,0.0,-200.4 ), Vector3( -373.2,0.0,-121.7 ), Vector3( -234.8,0.0,15.4 ),
			},
		},
	},
	
	
	on_target_area_swamp = {
		gameObjectName	= MARKER_NAME.AREA_SWAMP,			visibleArea = 4, randomRange = 0,	viewType = "all",
		langId = "marker_info_mission_targetArea",			mapRadioName = "s0090_mprg0040",
		setNew = true,
		announceLog = "updateMap",
	},
	
	
	default_subGoal_missionStart = {
		subGoalId		= 0,
	},
	on_subGoal_missiontarget = {
		subGoalId		= 1,
	},
	on_subGoal_missionComplete = {
		subGoalId		= 2,
	},
	
	
	default_mainTask_search_escort = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SEARCH_ESCORT,		isNew = false,	isComplete = false },
	},
	default_mainTask_search_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SEARCH_TARGET,		isNew = false,	isComplete = false	},
	},
	default_mainTask_recovered_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_RECOVERED_TARGET,	isNew = false,	isComplete = false	},
	},
	on_mainTask_search_escort = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SEARCH_ESCORT,		isNew = true,	isComplete = true	},
	},
	on_mainTask_search_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_SEARCH_TARGET,		isNew = true,	isComplete = true	},
	},
	on_mainTask_recovered_target = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.MAIN_RECOVERED_TARGET,	isNew = true,	isComplete = true	},
	},
	
	
	default_subTask_intel = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_INTEL,				isNew = false,	isComplete = false,	isFirstHide = true },
	},
	default_subTask_conversation_ghost = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_CONVERSATION_GHOST,	isNew = false,	isComplete = false,	isFirstHide = true },
	},
	default_subTask_recovered_zrs = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_ZRS,		isNew = false,	isComplete = false,	isFirstHide = true },
	},
	on_subTask_intel = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_INTEL,				isNew = false,	isComplete = true,	},
	},
	on_subTask_conversation_ghost = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_CONVERSATION_GHOST,	isNew = false,	isComplete = true,	},
	},
	on_subTask_recovered_zrs = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SUB_RECOVERED_ZRS,		isNew = false,	isComplete = true,	},
	},
	
	
	
	on_target_vehicle = {
		gameObjectName = "veh_trc_0000",					goalType = "moving",				viewType = "map_and_world_only_icon",	setNew = true,	setImportant = true,	announceLog = "updateMap",
		langId = "marker_info_mission_target",				mapRadioName = "s0090_mprg0030",
	},
	
	on_escort_vehicle_01 = {
		gameObjectName = "veh_wav_0000",					goalType = "attack",				viewType = "map_and_world_only_icon",	setNew = true,	setImportant = true,	announceLog = "updateMap",
		langId = "marker_ene_tailing_trgt",
	},
	
	on_escort_vehicle_02 = {
		gameObjectName = "veh_wav_0001",					goalType = "attack",				viewType = "map_and_world_only_icon",	setNew = true,	setImportant = true,	announceLog = "updateMap",
		langId = "marker_ene_tailing_trgt",
	},
	
	
	on_missionComplete = {
	},
	
	
	announce_log_recoverTarget = {
		announceLog = "recoverTarget",
	},
	
	announce_log_achieveAllObjectives = {
		announceLog = "achieveAllObjectives",
	},
	
	on_escort_vehicle_01_b = {
		gameObjectName = "veh_wav_0000",					goalType = "attack",				viewType = "map_and_world_only_icon",	setNew = true,	setImportant = false,	announceLog = "updateMap",
		langId = "marker_info_APC",
	},
	
	on_escort_vehicle_02_b = {
		gameObjectName = "veh_wav_0001",					goalType = "attack",				viewType = "map_and_world_only_icon",	setNew = true,	setImportant = false,	announceLog = "updateMap",
		langId = "marker_info_APC",
	},
	
	default_subTask_skulls = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_ELIMINATE_SKULLS,	isNew = false,	isComplete = false,	isFirstHide = true },
	},
	on_subTask_skulls = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_ELIMINATE_SKULLS,	isNew = false,	isComplete = true,	},
	},
}











this.missionObjectiveTree = {
	on_missionComplete = {
		
		on_target_vehicle = {
				on_target_area_swamp = {
					area_Interrogation_pfCamp = {
						
						area_Intel_get = {
							area_Intel_pfCampNorth = {
								arrival_at_pfCampNorth = {
									default_area_pfCampNorth = {},
								},
							},
							area_Intel_pfCampEast = {
							},
							area_Intel_savannah = {
							},
							area_Intel_swampEast = {
							},
						},
				},
			},
			on_escort_vehicle_01_b = {
				on_escort_vehicle_01 = {},
			},
			on_escort_vehicle_02_b = {
				on_escort_vehicle_02 = {},
			},
		},
		
		showEnemyRoute_01 = {
		},
		showEnemyRoute_02 = {
		},
		showEnemyRoute_03 = {
		},
		showEnemyRoute_04 = {
		},
	},
	
	on_photo_missionComplete_01 = {
		default_photo_targetVehicle = {
		},
	},
	on_photo_missionComplete_02 = {
		default_photo_escortVehicle = {
		},
	},
	
	on_subGoal_missionComplete = {
		on_subGoal_missiontarget = {
			default_subGoal_missionStart = {
			},
		},
	},
	
	on_mainTask_search_escort = {
		default_mainTask_search_escort = {
		},
	},
	on_mainTask_search_target = {
		default_mainTask_search_target = {
		},
	},
	on_mainTask_recovered_target = {
		default_mainTask_recovered_target = {
		},
	},
	
	on_subTask_intel = {
		default_subTask_intel = {
		},
	},
	on_subTask_conversation_ghost = {
		default_subTask_conversation_ghost = {
		},
	},
	on_subTask_recovered_zrs = {
		default_subTask_recovered_zrs = {
		},
	},
	
	announce_log_recoverTarget = {
	},
	announce_log_achieveAllObjectives = {
	},
	
	on_subTask_skulls = {
		default_subTask_skulls = {
		},
	},
}





this.missionObjectiveEnum = Tpp.Enum{
	"default_area_pfCampNorth",
	"arrival_at_pfCampNorth",
	"default_photo_targetVehicle",
	"default_photo_escortVehicle",
	"on_photo_missionComplete_01",
	"on_photo_missionComplete_02",
	"area_Intel_pfCampEast",
	"area_Intel_pfCampNorth",
	"area_Intel_savannah",
	"area_Intel_swampEast",
	"area_Intel_get",
	"showEnemyRoute_01",
	"showEnemyRoute_02",
	"showEnemyRoute_03",
	"showEnemyRoute_04",
	"on_target_area_swamp",
	"default_subGoal_missionStart",
	"on_subGoal_missiontarget",
	"on_subGoal_missionComplete",
	"on_target_vehicle",
	"on_escort_vehicle_01",
	"on_escort_vehicle_02",
	"on_missionComplete",
	"area_Interrogation_pfCamp",
	
	"default_mainTask_search_escort",
	"default_mainTask_search_target",
	"default_mainTask_recovered_target",
	"on_mainTask_search_escort",
	"on_mainTask_search_target",
	"on_mainTask_recovered_target",
	
	"default_subTask_intel",
	"default_subTask_conversation_ghost",
	"default_subTask_recovered_zrs",
	"on_subTask_intel",
	"on_subTask_conversation_ghost",
	"on_subTask_recovered_zrs",
	
	"announce_log_recoverTarget",
	"announce_log_achieveAllObjectives",
	
	"on_escort_vehicle_01_b",
	"on_escort_vehicle_02_b",
	"default_subTask_skulls",
	"on_subTask_skulls",
}






this.missionStartPosition = {
	
	orderBoxList = {
		"box_s10090_00",
	},
	
	helicopterRouteList = {
		"lz_drp_pfCampNorth_S0000|rt_drp_pfCampNorth_S_0000",
	},
}






this.specialBonus = {
	first = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_ELIMINATE_SKULLS },
		pointList = {
					5000,	
					10000,	
					15000,	
					20000,	
		},
		maxCount = 4,
	},
	second = {
		missionTask = { taskNo = this.MISSIONTASK_LIST.SPECIALBONUS_RECOVERED_DRIVER },
	},
}






function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")
	
	
	this.RegiserMissionSystemCallback()
	
	
	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "Demo_ParasiteAppearance" },
	}
	
	
	TppRatBird.EnableBird( "TppCritterBird" )
	
	
	GkEventTimerManager.StopAll()
	
	
	this.SetUpVariable()
	
	
	this.SetUpAddTrap()
	
	
	this.SetUpVehicleTable()
	
	if DEBUG then
		
		this.SetUpDebugMissionStartTable()
	end
	
	
	this.SetUpMessageTable()
	
	
	this.SetUpConversationTable()
	
	
	this.SetUpMotorcadeSTable()
	
	
	this.SetUpTrapTable()
	
	
	this.SetUpTimerTable()
	
	
	this.SetUpCheckTable()

end


function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
	
	this.SetUpVariable()
	
	
	if svars.isAppearanceParasites == true then
		if svars.isDyingAllParasites == false then
			svars.isAppearanceParasites = false
		end
	end
	
	
	vars.playerDisableActionFlag = PlayerDisableAction.NONE
	
end


function this.OnTerminate()
	Fox.Log("*** OnTerminate ***")
end


function this.OnEndDeliveryWarp( stationUniqueId )
	Fox.Log("*** OnEndDeliveryWarp ***")
end




	

function this.RegiserMissionSystemCallback()
	Fox.Log("*** RegiserMissionSystemCallback ***")
	
	local systemCallbackTable ={
		
		OnEstablishMissionClear		= this.OnEstablishMissionClear,
		
		OnGameOver					= this.OnGameOver,
		
		OnRecovered					= this.OnRecovered,
		
		CheckMissionClearFunction	= function()
			return TppEnemy.CheckAllTargetClear()
		end,
		
		OnMissionGameEndFadeOutFinish = function()
			local gameObjectId = GetGameObjectId( s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )
			GameObject.SendCommand( gameObjectId, { id="Seize", options={ "Instant" }, } )	
		end,
		
		OnSetMissionFinalScore		= function()
		
		
		
			
			if vars.playerVehicleGameObjectId == GameObject.GetGameObjectId("veh_trc_0000") then
				TppMission.UpdateObjective{ objectives = {"on_mainTask_recovered_target",}, }
			end
		end,
		nil
	}
	
	
	TppMission.RegiserMissionSystemCallback(systemCallbackTable)
	
end


function this.OnEstablishMissionClear( missionClearType )
	Fox.Log("*** " .. tostring(missionClearType) .. " OnEstablishMissionClear ***")
	
	
	s10090_radio.TelephoneRadio()
	
	
	if this.IsAppearanceParasites() == true then
		
		this.SetExitParasites()
	end
	
	
	if ( missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT ) then
		TppTerminal.ReserveHelicopterSoundOnMissionGameEnd()
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


function this.OnGameOver( gameOverType )
	Fox.Log("*** " .. tostring(gameOverType) .. " OnGameOver ***")
	
	local blRetcode = false
	
	
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.S10090_TARGET_ESCAPE ) then
		local func = function() 
			TppMission.ShowGameOverMenu{}
		end
		
		TppScriptBlock.LoadDemoBlock( "Demo_TargetEscape" )
		
		s10090_demo.TargetEscape(func)
		blRetcode = true
	
	elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.S10090_TARGET_DEAD ) then
		
		TppPlayer.SetTargetTruckCamera{ gameObjectName = s10090_enemy.VEHICLE_NAME.TRUCK_TARGET }
		
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_S10090_TARGET_DEAD_TIME }
		blRetcode = true
	
	elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.S10090_TARGET_FULTON_FAILED ) then
		
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_S10090_TARGET_FULTON_FAILED_TIME }
		blRetcode = true
	end
	
	return blRetcode
	
end


function this.OnRecovered( s_gameObjectId )
	if Tpp.IsVehicle( s_gameObjectId ) then
		if s_gameObjectId == GameObject.GetGameObjectId("veh_trc_0000")	then
			s10090_radio.SetOptionalRadioUpdate( "Set_s0090_oprg0060" , true )
		end
	end
	if Tpp.IsSoldier( s_gameObjectId ) then
		local isSucces, gameObjectId = s10090_enemy.IsZRS( s_gameObjectId )
		if isSucces == true then
			if TppMission.IsEnableAnyParentMissionObjective( "on_subTask_recovered_zrs" ) == false then
				svars.fultonZRSCount = svars.fultonZRSCount + 1
				if svars.fultonZRSCount >= this.MISSIONTASK_COUNT_LIST.SUB_RECOVERED_ZRS then
					TppMission.UpdateObjective{
						objectives = {
							
							"on_subTask_recovered_zrs",
						},
					}
				end
			end
			if gameObjectId == svars.firstTargetDriverGameObjectId then
				
				TppResult.AcquireSpecialBonus{
					second = { isComplete = true },
				}
			end
		end
	end
end






function this.SetUpVariable()
	
	mvars.isNoStopConvoy					= false
	mvars.rangeEventSequenceIndex			= 0
	mvars.interEventSequenceIndex			= 0
	mvars.inRange							= 0
	mvars.outRange							= 0
	
	
	mvars.isConverStation01					= false
	mvars.isConverStation02					= false
	mvars.isConverStation03					= false
	
	
	mvars.isParasitesIntel					= false
	
end


function this.SetUpAddTrap()
	
	
	TppPlayer.AddTrapSettingForIntel{
		intelName			= INTEL_SENDER_NAME.SAVANNAH,
		autoIcon			= true,
		identifierName		= "GetIntelIdentifier",
		locatorName			= "GetIntel_savannah",
		gotFlagName			= "isOnGetIntel",
		trapName			= TRAP_NAME.INTEL_SAVANNAH,
		markerObjectiveName	= "area_Intel_savannah",
		markerTrapName		= TRAP_NAME.INTEL_MARKER_SAVANNAH,
	}
	
	
	TppPlayer.AddTrapSettingForIntel{
		intelName			= INTEL_SENDER_NAME.PFCAMPNORTH,
		autoIcon			= true,
		identifierName		= "GetIntelIdentifier",
		locatorName			= "GetIntel_pfCampNorth",
		gotFlagName			= "isOnGetIntel",
		trapName			= TRAP_NAME.INTEL_PFCAMPNORTH,
		markerObjectiveName	= "area_Intel_pfCampNorth",
		markerTrapName		= TRAP_NAME.INTEL_MARKER_PFCAMPNORTH,
	}
	
	
	TppPlayer.AddTrapSettingForIntel{
		intelName			= INTEL_SENDER_NAME.PFCAMPEAST,
		autoIcon			= true,
		identifierName		= "GetIntelIdentifier",
		locatorName			= "GetIntel_pfCampEast",
		gotFlagName			= "isOnGetIntel",
		trapName			= TRAP_NAME.INTEL_PFCAMPEAST,
		markerObjectiveName	= "area_Intel_pfCampEast",
		markerTrapName		= TRAP_NAME.INTEL_MARKER_PFCAMPEAST,
	}
	
	
	TppPlayer.AddTrapSettingForIntel{
		intelName			= INTEL_SENDER_NAME.SWAMPEAST,
		autoIcon			= true,
		identifierName		= "GetIntelIdentifier",
		locatorName			= "GetIntel_swampEast",
		gotFlagName			= "isOnGetIntel",
		trapName			= TRAP_NAME.INTEL_SWAMPEAST,
		markerObjectiveName	= "area_Intel_swampEast",
		markerTrapName		= TRAP_NAME.INTEL_MARKER_SWAMPEAST,
	}
	
end


function this.SetUpVehicleTable()
	
	
	this.vehicleSettingTable[StrCode32( s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )] = {
		vehicleGameObjectName		= s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,	
		objectives					= {},										
		isEscort					= false,									
		isMarkingSvarsName			= "isMarkingVehicle01",						
		isMarkingTargetSvarsName	= "isMarkingVehicle01",						
		isBrokenSvarsName			= "isBrokenVehicle01",						
		isFultonSvarsName			= "isFultonVehicle01",						
		isTarget					= true,										
		
		funcBeforeVehicleRide		= s10090_radio.SearchTargetVehicle,			
		funcAfterVehicleRide		= s10090_radio.TargetVehicleRide,			
		funcMarkerEnable			= s10090_radio.SearchTargetVehicle,			
	}
	
	this.vehicleSettingTable[StrCode32( s10090_enemy.VEHICLE_NAME.WEST_WAV01 )] = {
		vehicleGameObjectName		= s10090_enemy.VEHICLE_NAME.WEST_WAV01,		
		objectives					= {},										
		isEscort					= true,										
		isMarkingSvarsName			= "isMarkingVehicle02",						
		isMarkingTargetSvarsName	= "isMarkingVehicle01",						
		isBrokenSvarsName			= "isBrokenVehicle02",						
		isFultonSvarsName			= "isFultonVehicle02",						
		isTarget					= false,									
		
		funcMarkerEnable			= s10090_radio.SearchEscortVehicle,			
	}
	
	this.vehicleSettingTable[StrCode32( s10090_enemy.VEHICLE_NAME.WEST_WAV02 )] = {
		vehicleGameObjectName		= s10090_enemy.VEHICLE_NAME.WEST_WAV02,		
		objectives					= {},										
		isEscort					= true,										
		isMarkingSvarsName			= "isMarkingVehicle03",						
		isMarkingTargetSvarsName	= "isMarkingVehicle01",						
		isBrokenSvarsName			= "isBrokenVehicle03",						
		isFultonSvarsName			= "isFultonVehicle03",						
		isTarget					= false,									
		
		funcMarkerEnable			= s10090_radio.SearchEscortVehicle,			
	}
end

if DEBUG then


function this.SetUpDebugMissionStartTable()
	
	
	this.dbgMissionStartSettingTable[5] = {
		vehicle = {
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,		pos = Vector3( 764.267395, -11.906753, 1249.067993 ),	rotY = 1.0507769584656, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,		pos = Vector3( 767.497803, -11.907064, 1220.879272 ),	rotY = -2.1702251434326, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.VEHICLE_01,		pos = Vector3( 622.792297, -11.115735, 836.524353 ),	rotY = -1.2815088033676, },
		},
		func = {
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_PFCAMP_GUARD01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_PFCAMP_GUARD02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT02
													},
												} end },
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_01,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_02,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_03,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_04
													},
												} end },
		},
	}
	
	
	this.dbgMissionStartSettingTable[10] = {
		vehicle = {
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,		pos = Vector3( 762.038025, -11.864416, 1249.272827 ),	rotY = 1.0493788719177, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,		pos = Vector3( 767.497803, -11.907064, 1220.879272 ),	rotY = -2.1702251434326, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.VEHICLE_01,		pos = Vector3( 622.792297, -11.115735, 836.524353 ),	rotY = -1.2815088033676, },
		},
		func = {
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_PFCAMP_GUARD01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_PFCAMP_GUARD02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT02
													},
												} end },
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_01,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_02,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_03,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_04
													},
												} end },
			
			{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_PFCAMP end },
		},
	}
	
	
	this.dbgMissionStartSettingTable[15] = {
		vehicle = {
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,		pos = Vector3( 300.881897, -6.433638, 350.944427 ),		rotY = -1.8211283683777, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,		pos = Vector3( 323.328918, -6.780036, 357.718719 ),		rotY = -1.9797695875168, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,		pos = Vector3( 349.431732, -8.884431, 373.202087 ),		rotY = -2.2112121582031, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.VEHICLE_01,		pos = Vector3( 327.965607, -6.235871, 343.300598 ),		rotY = -1.7605882883072, },
		},
		func = {
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_GUARD01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_TARGET ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_GUARD02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT02
													},
												} end },
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_01,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_02,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_03,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_04
													},
												} end },
			
			{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_STOP_SWAMPSOUTH end },
		},
	}
	
	
	this.dbgMissionStartSettingTable[20] = {
		vehicle = {
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,		pos = Vector3( 300.881897, -6.433638, 350.944427 ),		rotY = -1.8211283683777, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,		pos = Vector3( 323.328918, -6.780036, 357.718719 ),		rotY = -1.9797695875168, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,		pos = Vector3( 349.431732, -8.884431, 373.202087 ),		rotY = -2.2112121582031, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.VEHICLE_01,		pos = Vector3( 327.965607, -6.235871, 343.300598 ),		rotY = -1.7605882883072, },
		},
		func = {
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_GUARD01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_TARGET ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_GUARD02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT02
													},
												} end },
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_01,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_02,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_03,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_04
													},
												} end },
			
			{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMPSOUTH end },
		},
	}
	
	
	this.dbgMissionStartSettingTable[25] = {
		vehicle = {
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,		pos = Vector3( -124.719315, -4.777594, 27.820532 ),		rotY = -2.6546440124512, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,		pos = Vector3( -89.963425, -4.726182, 59.074959 ),		rotY = -1.7438348531723, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,		pos = Vector3( -48.110550, -4.598232, 45.896687 ),		rotY = -1.0895439386368, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.VEHICLE_01,		pos = Vector3( 93.108734, -6.367922, -51.525677 ),		rotY = 1.4641401767731, },
		},
		func = {
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMP_GUARD01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMP_TARGET ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMP_GUARD02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT02
													},
												} end },
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_03 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_01,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_02,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_03,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_04
													},
												} end },
		},
	}
	
	
	this.dbgMissionStartSettingTable[30] = {
		vehicle = {
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,		pos = Vector3( -124.719315, -4.777594, 27.820532 ),		rotY = -2.6546440124512, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,		pos = Vector3( -89.963425, -4.726182, 59.074959 ),		rotY = -1.7438348531723, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,		pos = Vector3( -48.110550, -4.598232, 45.896687 ),		rotY = -1.0895439386368, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.VEHICLE_01,		pos = Vector3( 93.108734, -6.367922, -51.525677 ),		rotY = 1.4641401767731, },
		},
		func = {
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMP_GUARD01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMP_TARGET ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMP_GUARD02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT02
													},
												} end },
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_03 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_01,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_02,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_03,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_04
													},
												} end },
			
			{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMP end },
		},
	}
	
	
	this.dbgMissionStartSettingTable[40] = {
		
	}
	
	
	this.dbgMissionStartSettingTable[50] = {
		vehicle = {
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,		pos = Vector3( -1216.381714, -20.711853, 99.890167 ),	rotY = 0.0053758518770337, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,		pos = Vector3( -1247.686768, -20.185724, 102.716545 ),	rotY = -1.0661635398865, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,		pos = Vector3( -1215.166748, -20.292364, 75.945778 ),	rotY = 0.1592875868082, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.VEHICLE_01,		pos = Vector3( 93.108734, -6.367922, -51.525677 ),		rotY = 1.4641401767731, },
		},
		func = {
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_TRANSPORTPOINT_GUARD01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_TRANSPORTPOINT_TARGET ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_TRANSPORTPOINT_GUARD02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT02
													},
												} end },
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_03 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_01,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_02,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_03,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_04
													},
												} end },
			
			{ func = function() s10090_enemy.SetRelativeVehicle( s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET, true ) end },
		},
	}
	
	
	this.dbgMissionStartSettingTable[60] = {
		vehicle = {
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,		pos = Vector3( 300.881897, -6.433638, 350.944427 ),		rotY = -1.8211283683777, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,		pos = Vector3( 323.328918, -6.780036, 357.718719 ),		rotY = -1.9797695875168, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,		pos = Vector3( 349.431732, -8.884431, 373.202087 ),		rotY = -2.2112121582031, },
			{ gameObjectName = s10090_enemy.VEHICLE_NAME.VEHICLE_01,		pos = Vector3( 327.965607, -6.235871, 343.300598 ),		rotY = -1.7605882883072, },
		},
		func = {
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_GUARD01 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_TARGET ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01
													},
												} end },
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_GUARD02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT02
													},
												} end },
			
			{ func = function() this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_02 ),
													dbgEnemyIdTable = {
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_01,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_02,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_03,
														s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_04
													},
												} end },
			
			{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_PARASITES end },
		},
	}
end

end 


function this.SetUpMessageTable()
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.E_INIT_MESSAGE ) ] = {
		isSetSuccess = false,
		param = {
			{
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01,
					isMessageChangePhase = true,
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_PFCAMP02,
					isMessageChangePhase = true,
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_PFCAMP03,
					isMessageChangePhase = true,
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_PFCAMP04,
					isMessageChangePhase = true,
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_ESCORT01,
					isMessageChangePhase = true,
					messageEventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMPEAST02,
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_ESCORT02,
					isMessageChangePhase = true,
					messageEventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMPEAST02,
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_01,
					isMessageChangePhase = true,
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_02,
					isMessageChangePhase = true,
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_03,
					isMessageChangePhase = true,
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_ESCORT_VEHICLE_04,
					isMessageChangePhase = true,
				},
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.E_INIT ) ] = {
		isSetSuccess = false,
		param = {
			{
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01,
					routeId_d			 = "rts_zrs_pfCamp_ene01_d_0000",
					routeId_c			 = "rts_zrs_pfCamp_ene01_c_0000",
					routeId_a			 = "rts_zrs_pfCamp_ene01_a_0000",
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_PFCAMP02,
					routeId_d			 = "rts_zrs_pfCamp_ene02_d_0000",
					routeId_c			 = "rts_zrs_pfCamp_ene02_c_0000",
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_PFCAMP03,
					routeId_d			 = "rts_zrs_pfCamp_ene03_d_0000",
					routeId_c			 = "rts_zrs_pfCamp_ene03_c_0000",
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_PFCAMP04,
					routeId_d			 = "rts_zrs_pfCamp_ene04_d_0000",
					routeId_c			 = "rts_zrs_pfCamp_ene04_c_0000",
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_TRANSPORT01,
					routeId_d			 = "rts_zrs_transport_ene01_d_0000",
					routeId_c			 = "rts_zrs_transport_ene01_d_0000",
				},
				{	
					enemyId				 = s10090_enemy.ENEMY_NAME.ZRS_TRANSPORT02,
					routeId_d			 = "rts_zrs_transport_ene02_d_0000",
					routeId_c			 = "rts_zrs_transport_ene02_d_0000",
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.START end },
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_ESCORT01 end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.E_INIT_PFCAMPEAST ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				{	
					enemyId					= s10090_enemy.ENEMY_NAME.ZRS_ESCORT01,
					routeId_d				= "rts_v_r_pfCampEast_escort01",
					routeId_c				= "rts_v_r_pfCampEast_escort01",
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV01,
					isSetRelativeVehicle	= true,
					isrideFromBeginning		= true,
					isVigilance				= true,
				},	
				{	
					enemyId					= s10090_enemy.ENEMY_NAME.ZRS_ESCORT02,
					routeId_d				= "rts_v_r_pfCampEast_escort02",
					routeId_c				= "rts_v_r_pfCampEast_escort02",
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV02,
					isSetRelativeVehicle	= true,
					isrideFromBeginning		= true,
					isVigilance				= true,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMPEAST end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_VS_PFCAMPEAST ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					travelSetRouteIdTable	= {
												"rts_v_r_pfCampEast_escort01",
											},
					travelPlanName			= "travel_v_pfCampEast_to_pfCamp_escort01_01",
					travelSetCount			= 1,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV01,
					isPrepareVehicleConvoy	= true,
				},
				
				{
					travelSetRouteIdTable	= {
												"rts_v_r_pfCampEast_escort02",
											},
					travelPlanName			= "travel_v_pfCampEast_to_pfCamp_escort02_01",
					travelSetCount			= 1,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV02,
					isPrepareVehicleConvoy	= true,
				},
				
				{ registerConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMPEAST01 end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_U_GUARD_VIGILANCE ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					travelSetRouteIdTable	= { "rts_v_15to23_escort01_0000", },
					travelPlanName			= "travel_v_pfCampEast_to_pfCamp_escort01_02",
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
				},
				
				{
					travelSetRouteIdTable	= { "rts_v_15to23_escort02_0000", },
					travelPlanName			= "travel_v_pfCampEast_to_pfCamp_escort02_02",
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
				},
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMPEAST02 end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_PFCAMP_GUARD01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					beforeRouteIdTable		= { "rts_v_e_pfCamp_escort01"  },
					afterRouteIdTable_d		= { "rts_v_r_pfCamp_escort01" },
					afterRouteIdTable_c		= { "rts_v_r_pfCamp_escort01" },
					afterRouteIdTable_a		= { "rts_v_r_pfCamp_escort01" },
					isTravelPlanEnd			= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP end },
				
				{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_PFCAMP },
				{ timerList = this.TIMER_LIST.MOTORCADE_START_PFCAMP },
			},
		},
	}
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_PFCAMP_GUARD02 ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					beforeRouteIdTable		= { "rts_v_e_pfCamp_escort02" },
					afterRouteIdTable_d		= { "rts_v_r_pfCamp_escort02" },
					afterRouteIdTable_c		= { "rts_v_r_pfCamp_escort02" },
					afterRouteIdTable_a		= { "rts_v_r_pfCamp_escort02" },
					isTravelPlanEnd			= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP end },
				
				{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_PFCAMP },
				{ timerList = this.TIMER_LIST.MOTORCADE_START_PFCAMP },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_PFCAMP_CPRADIO01 ) ] = {
		isSetSuccess = false,
		param = {
			{
				{
					speechLabel = this.CONVERSATION_LIST.PFCAMP_0001,
					speakerRouteNameTable = { "rts_zrs_pfCamp_ene01_d_0000", },
					isCallRadio = true,
					stane = "Stand",
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP end },
			},
		},
	}
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.C_PFCAMP_ACT_MOVE01 ) ] = {
		isSetSuccess = false,
		param = {
			{
				
				{
					beforeRouteIdTable		= { "rts_pfCamp_ene01_d_0000" },
					afterRouteIdTable_d		= { "rts_pfCamp_ene01_d_0001" },
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_PFCAMP_ACT_MOVE01 ) ] = {
		isSetSuccess = false,
		param = {
			{
				
				{
					beforeRouteIdTable		= { "rts_pfCamp_ene01_d_0001" },
					afterRouteIdTable_d		= { "rts_pfCamp_ene01_d_0002" },
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP end },
			},
		},
	}
	

	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_PFCAMP_CONVERSATION01 ) ] = {
		isSetSuccess = false,
		param = {
			{
				{
					speechLabel = this.CONVERSATION_LIST.PFCAMP_0002,
					speakerRouteNameTable = { "rts_pfCamp_ene01_d_0002", },
					friendRouteNameTable = { "rts_zrs_pfCamp_ene01_d_0000" },
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_PFCAMP_ACT_MOVE01 ) ] = {
		isSetSuccess = false,
		param = {
			{
				
				{
					beforeRouteIdTable		= {
												"rts_zrs_pfCamp_ene01_d_0000",
												"rts_zrs_pfCamp_ene02_d_0000",
												"rts_zrs_pfCamp_ene03_d_0000",
												"rts_zrs_pfCamp_ene04_d_0000",
											},
					afterRouteIdTable_d		= { "rts_v_c_pfCamp_truck01" },
					afterRouteIdTable_c		= { "rts_v_c_pfCamp_truck01" },
					afterRouteIdTable_a		= { "rts_v_c_pfCamp_truck01" },
					setRouteCount			= 1,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP end },
			},
		},
	}
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_PFCAMP_CPRADIO02 ) ] = {
		isSetSuccess = false,
		param = {
			{
				{
					speechLabel = this.CONVERSATION_LIST.PFCAMP_0003,
					speakerRouteNameTable = { "rts_v_c_pfCamp_truck01", },
					isCallRadio = true,
					stane = "Stand",
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VP_PFCAMP_TRUCK ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					beforeRouteIdTable		= {
												"rts_v_c_pfCamp_truck01",
												"rts_zrs_pfCamp_ene01_d_0000",
												"rts_zrs_pfCamp_ene02_d_0000",
												"rts_zrs_pfCamp_ene03_d_0000",
												"rts_zrs_pfCamp_ene04_d_0000",
											},
					afterRouteIdTable_d		= { "rts_v_p_pfCamp_truck01" },
					afterRouteIdTable_c		= { "rts_v_p_pfCamp_truck01" },
					afterRouteIdTable_a		= { "rts_v_p_pfCamp_truck01" },
					setRouteCount			= 1,
				},
				
				{
					beforeRouteIdTable		= { "rts_pfCamp_ene01_d_0000", "rts_pfCamp_ene01_d_0001", "rts_pfCamp_ene01_d_0002" },
					afterRouteIdTable_d		= { "rts_pfCamp_ene01_d_0003" },
				},
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VS_PFCAMP_TRUCK ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					travelSetRouteIdTable	= {
												"rts_v_p_pfCamp_truck01",
											},
					travelPlanName			= "travel_v_pfCamp_to_swampSouth_truck01",
					travelSetCount			= 1,
					isTravelkeepInAlert		= true,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,
					isSetRelativeVehicle	= true,
					isVigilance				= true,
					
					isMessageChangePhase	= true,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMP01 end },
				
				{ timerList = this.TIMER_LIST.MOTORCADE_STOP_PFCAMP },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VS_PFCAMP_MOTORCADE ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					travelSetRouteIdTable	= {
												"rts_v_r_pfCamp_escort01",
											},
					travelPlanName			= "travel_v_pfCamp_to_swampSouth_escort01",
					travelSetCount			= 1,
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV01,
					isPrepareVehicleConvoy	= true,
				},
				
				{	
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,
					isPrepareVehicleConvoy	= true,
				},
				
				
				{
					travelSetRouteIdTable	= {
												"rts_v_r_pfCamp_escort02",
											},
					travelPlanName			= "travel_v_pfCamp_to_swampSouth_escort02",
					travelSetCount			= 1,
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV02,
					isPrepareVehicleConvoy	= true,
				},
				
				{ registerConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMP02 end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_GUARD01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					beforeRouteIdTable		= { "rts_v_e_swampSouth_escort01" },
					afterRouteIdTable_d		= { "rts_v_r_swampSouth_escort01" },
					afterRouteIdTable_c		= { "rts_v_r_swampSouth_escort01" },
					afterRouteIdTable_a		= { "rts_v_r_swampSouth_escort01" },
					isTravelPlanEnd			= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH end },
			},
			
			{
				
				{
					travelSetRouteIdTable	= { "rts_v_e_swampSouth_escort01", },
					travelPlanName			= "travel_v_swampSouth_to_swamp_escort01",
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMPSOUTH end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_TARGET ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					beforeRouteIdTable		= { "rts_v_e_swampSouth_truck01" },
					afterRouteIdTable_d		= { "rts_zrs_swampSouth_ene01_d_0000" },
					afterRouteIdTable_c		= { "rts_zrs_swampSouth_ene01_d_0000" },
					afterRouteIdTable_a		= { "rts_zrs_swampSouth_ene01_d_0000" },
					isTravelPlanEnd 		= true,
					
					isUnsetRelativeVehicle	= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ timerList = this.TIMER_LIST.EVENT_SWAMPSOUTH01 },
				{ timerList = this.TIMER_LIST.MOTORCADE_START_SWAMPSOUTH },
				{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_SWAMPSOUTH },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH end },
			},
			
			{
				
				{
					travelSetRouteIdTable	= { "rts_v_e_swampSouth_truck01", },
					travelPlanName			= "travel_v_swampSouth_to_swamp_truck01",
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMPSOUTH end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMPSOUTH_GUARD02 ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				
				{
					beforeRouteIdTable		= { "rts_v_e_swampSouth_escort02" },
					afterRouteIdTable_d		= { "rts_v_r_swampSouth_escort02" },
					afterRouteIdTable_c		= { "rts_v_r_swampSouth_escort02" },
					afterRouteIdTable_a		= { "rts_v_r_swampSouth_escort02" },
					isTravelPlanEnd			= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH end },
			},
			
			{
				
				{
					travelSetRouteIdTable	= { "rts_v_e_swampSouth_escort02", },
					travelPlanName			= "travel_v_swampSouth_to_swamp_escort02",
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMPSOUTH end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_SWAMPSOUTH_ACT_MOVE_START ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				
				{
					beforeRouteIdTable	= { 
											"rt_swampSouth_d_0004",
											"rt_swampSouth_d_0001",
											"rt_swampSouth_d_0002",
											"rt_swampSouth_d_0003",
											"rt_swampSouth_n_0004",
											"rt_swampSouth_n_0001",
											"rt_swampSouth_n_0002",
											"rt_swampSouth_n_0003",
											},
					afterRouteIdTable_d	= {
											"rts_swampSouth_ene01_d_0000",
											"rts_swampSouth_ene02_d_0000",
											"rts_swampSouth_ene03_d_0000",
											"rts_swampSouth_ene04_d_0000",
											},
				},
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_SWAMPSOUTH_ACT_MOVE_END ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				
				{
					beforeRouteIdTable	= {
											"rts_swampSouth_ene01_d_0000",
											"rts_swampSouth_ene02_d_0000",
											"rts_swampSouth_ene03_d_0000",
											"rts_swampSouth_ene04_d_0000",
											},
					afterRouteIdTable_d	= { "", },
				},
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_SWAMPSOUTH_ACT_MOVE01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					beforeRouteIdTable		= { "rts_swampSouth_ene01_d_0000",
												"rts_swampSouth_ene02_d_0000", "rts_swampSouth_ene03_d_0000", "rts_swampSouth_ene04_d_0000",
												"rts_swampSouth_ene05_d_0000", "rts_swampSouth_ene06_d_0000",
											},
					afterRouteIdTable_d		= { "rts_swampSouth_ene01_d_0001" },
					setRouteCount			= 1,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMPSOUTH end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_SWAMPSOUTH_CONVERSATION01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				{
					speechLabel = this.CONVERSATION_LIST.SWAMPSOUTH_0001,
					speakerRouteNameTable = { "rts_swampSouth_ene01_d_0001", },
					friendRouteNameTable = { "rts_zrs_swampSouth_ene01_d_0000" },
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMPSOUTH end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_VP_SWAMPSOUTH_TRUCK ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_zrs_swampSouth_ene01_d_0000"},
					afterRouteIdTable_d		= { "rts_v_r_swampSouth_truck01", },
					afterRouteIdTable_c		= { "rts_v_r_swampSouth_truck01", },
					afterRouteIdTable_a		= { "rts_v_r_swampSouth_truck01", },
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,
					isSetRelativeVehicle	= true,
					isVigilance				= true,
					
					isMessageChangePhase	= true,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMPSOUTH end },
				
				{ timerList = this.TIMER_LIST.ESCORT_VEHICLE_START_02 },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_VS_SWAMPSOUTH_MOTORCADE ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				
				{	
					travelSetRouteIdTable	= {
												"rts_v_r_swampSouth_escort01",
											},
					travelPlanName			= "travel_v_swampSouth_to_swamp_escort01",
					travelSetCount			= 1,
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV01,
					isPrepareVehicleConvoy	= true,
				},
				
				{
					travelSetRouteIdTable	= {
												"rts_v_r_swampSouth_truck01",
											},
					travelPlanName			= "travel_v_swampSouth_to_swamp_truck01",
					travelSetCount			= 1,
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,
					isPrepareVehicleConvoy	= true,
				},
				
				{
					travelSetRouteIdTable	= {
												"rts_v_r_swampSouth_escort02",
											},
					travelPlanName			= "travel_v_swampSouth_to_swamp_escort02",
					enemyRouteSetCoun		= 1,
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV02,
					isPrepareVehicleConvoy	= true,
				},
				
				{ registerConvoy = true },
				
				{ timerList = this.TIMER_LIST.EVENT_SWAMPSOUTH02 },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMPSOUTH end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMP_GUARD01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_v_e_swamp_escort01" },
					afterRouteIdTable_d		= { "rts_v_r_swamp_escort01" },
					afterRouteIdTable_c		= { "rts_v_r_swamp_escort01" },
					afterRouteIdTable_a		= { "rts_v_r_swamp_escort01" },
					isTravelPlanEnd			= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMP end },
			},
			
			{
				
				{
					travelSetRouteIdTable	= { "rts_v_e_swamp_escort01", },
					travelPlanName			= "travel_v_swamp_to_transport_escort01",
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMP end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMP_TARGET ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_v_e_swamp_truck01" },
					afterRouteIdTable_d		= { "rts_zrs_swamp_ene01_d_0000" },
					afterRouteIdTable_c		= { "rts_zrs_swamp_ene01_d_0000" },
					afterRouteIdTable_a		= { "rts_zrs_swamp_ene01_d_0000" },
					isTravelPlanEnd			= true,
					
					isUnsetRelativeVehicle	= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ timerList = this.TIMER_LIST.MOTORCADE_START_SWAMP },
				{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_SWAMP },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMP end },
				
				{ func = function() svars.isCheckPointAllDisable = true end },
				{ func = function() this.SetAllCheckPointVisible( false ) end },
			},
			
			{
				
				{
					travelSetRouteIdTable	= { "rts_v_e_swamp_truck01", },
					travelPlanName			= "travel_v_swamp_to_transport_truck01",
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMP end },
				
				{ func = function() svars.isCheckPointAllDisable = true end },
				{ func = function() this.SetAllCheckPointVisible( false ) end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_SWAMP_GUARD02 ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_v_e_swamp_escort02" },
					afterRouteIdTable_d		= { "rts_v_r_swamp_escort02" },
					afterRouteIdTable_c		= { "rts_v_r_swamp_escort02" },
					afterRouteIdTable_a		= { "rts_v_r_swamp_escort02" },
					isTravelPlanEnd			= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMP end },
			},
			
			{
				
				{
					travelSetRouteIdTable	= { "rts_v_e_swamp_escort02", },
					travelPlanName			= "travel_v_swamp_to_transport_escort02",
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMP end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_SWAMP_ACT_MOVE01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					beforeRouteIdTable		= { "rts_zrs_swamp_ene01_d_0000" },
					afterRouteIdTable_d		= { "rts_zrs_swamp_ene01_d_0001" },
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMP end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_SWAMP_CONVERSATION01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				{
					speechLabel = this.CONVERSATION_LIST.SWAMP_0001,
					speakerRouteNameTable = { "rts_zrs_swamp_ene01_d_0001", },
					friendRouteNameTable = { "rts_swamp_ene01_d_0000" },
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMP end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.C_SWAMP_CPRADIO01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				{
					speechLabel = this.CONVERSATION_LIST.SWAMP_0002,
					speakerRouteNameTable = { "rts_swamp_ene01_d_0000" },
					isCallRadio = true,
					stane = "Stand",
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMP end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_VP_SWAMP_TRUCK ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_zrs_swamp_ene01_d_0000", "rts_zrs_swamp_ene01_d_0001" },
					afterRouteIdTable_d		= { "rts_v_r_swamp_truck01", },
					afterRouteIdTable_c		= { "rts_v_r_swamp_truck01", },
					afterRouteIdTable_a		= { "rts_v_r_swamp_truck01", },
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,
					isSetRelativeVehicle	= true,
					isVigilance				= true,
					
					isMessageChangePhase	= true,
				},
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_VS_SWAMP_MOTORCADE ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					travelSetRouteIdTable	= {
												"rts_v_r_swamp_escort01",
											},
					travelPlanName			= "travel_v_swamp_to_transport_escort01",
					travelSetCount			= 1,
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV01,
					isPrepareVehicleConvoy	= true,
				},
				
				{
					travelSetRouteIdTable	= {
												"rts_v_r_swamp_truck01",
											},
					travelPlanName			= "travel_v_swamp_to_transport_truck01",
					travelSetCount			= 1,
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,
					isPrepareVehicleConvoy	= true,
				},
				
				{
					travelSetRouteIdTable	= {
												"rts_v_r_swamp_escort02",
											},
					travelPlanName			= "travel_v_swamp_to_transport_escort02",
					travelSetCount			= 1,
					isTravelkeepInAlert		= true,
					
					isMessageChangePhase	= true,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.WEST_WAV02,
					isPrepareVehicleConvoy	= true,
				},
				
				{ registerConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMP end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_TRANSPORTPOINT_GUARD01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_v_e_transport_escort01" },
					afterRouteIdTable_d		= { "rts_v_r_transport_escort01" },
					afterRouteIdTable_c		= { "rts_v_r_transport_escort01" },
					afterRouteIdTable_a		= { "rts_v_r_transport_escort01" },
					isTravelPlanEnd			= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_TRANSPORTPOINT_GUARD02 ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_v_e_transport_escort02" },
					afterRouteIdTable_d		= { "rts_v_r_transport_escort02" },
					afterRouteIdTable_c		= { "rts_v_r_transport_escort02" },
					afterRouteIdTable_a		= { "rts_v_r_transport_escort02" },
					isTravelPlanEnd			= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_TRANSPORTPOINT_TARGET ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_v_e_transport_truck01" },
					afterRouteIdTable_d		= { "rts_v_r_transport_truck01_0000" },
					afterRouteIdTable_c		= { "rts_v_r_transport_truck01_0000" },
					afterRouteIdTable_a		= { "rts_v_r_transport_truck01_0000" },
					isTravelPlanEnd			= true,
					
					isMessageChangePhase	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_TRANSPORTPOINT end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_TRANSPORTPOINT_TARGET_WAIT ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_v_r_transport_truck01_0000" },
					afterRouteIdTable_d		= { "rts_v_r_transport_truck01_0001" },
					afterRouteIdTable_c		= { "rts_v_r_transport_truck01_0001" },
					afterRouteIdTable_a		= { "rts_v_r_transport_truck01_0001" },
				},
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.WAIT_TRANSPORTPOINT end },
				
				{ func = function() this.CheckTransportPointGameOver() end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_TRANSPORTPOINT_TARGET_CON ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				{
					speechLabel = this.CONVERSATION_LIST.TRANSPORTPOINT_0001,
					speakerRouteNameTable = { "rts_v_r_transport_truck01_0001", },
					isCallRadio = true,
				},
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_TRANSPORTPOINT_TARGET_DEMO ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEMO_TRANSPORTPOINT end },
				
				{ func = function() this.CheckTransportPointGameOver() end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_F_PFCAMP_ENTER ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{ func = function()
					svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.ENTER_PFCAMP
					
					if svars.isMarkingVehicle02 == true		then
						TppMission.UpdateObjective{ objectives = { "on_escort_vehicle_01_b" }, }
					else
						Fox.Log("isMarkingVehicle02 == false ... Nothing Done !!")
					end
					
					if svars.isMarkingVehicle03 == true		then
						TppMission.UpdateObjective{ objectives = { "on_escort_vehicle_02_b" }, }
					else
						Fox.Log("isMarkingVehicle03 == false ... Nothing Done !!")
					end
				end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_F_PFCAMP_EXIT ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.EXIT_PFCAMP end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_F_SWAMP_ENTER ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.ENTER_SWAMP end },
			},
		},
	}
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_F_SWAMP_EXIT ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{ func = function()
					svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.EXIT_SWAMP
				end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_F_FLOWSTATION_ENTER ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.ENTER_FLOWSTATION end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_F_FLOWSTATION_EXIT ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{ func = function() svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.EXIT_FLOWSTATION end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_R_SWAMP ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{ func = function() this.OnArrivalAtTargetswamp() end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_R_SWAMPWEST ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{ func = function() this.OnArrivalAtTargetswampWest() end },
			},
		},
	}
	
	
	
	
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_VS_ESCORT_VEHICLE_01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{
				
				{
					travelSetRouteIdTable	= {
												"rts_escort01_d_0000",
												"rts_escort01_d_0001",
												"rts_escort01_d_0002",
												"rts_escort01_d_0003",
											},
					travelPlanName			= "travel_v_escort01_to_escort02",
					travelSetCount			= 4,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.VEHICLE_01,
					isSetRelativeVehicle	= true,
				},
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.DRIVE_ESCORT01 end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_01 ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= { "rts_v_escort02_0000" },
					afterRouteIdTable_d		= { "rts_escort02_d_0000", "rts_escort02_d_0001", "rts_escort02_d_0002", "rts_escort02_d_0003", },
					afterRouteIdTable_c		= { "rts_escort02_d_0000", "rts_escort02_d_0001", "rts_escort02_d_0002", "rts_escort02_d_0003", },
					isTravelPlanEnd			= true,
					
					isUnsetRelativeVehicle	= true,
				},
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_ESCORT02 end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VW_ESCORT_VEHICLE_01 ) ] = {
		eventSubSequenceIndex = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_ESCORT02,
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= {
												"rts_escort02_d_0000",
												"rts_escort02_d_0001",
												"rts_escort02_d_0002",
												"rts_escort02_d_0003",
											},
					afterRouteIdTable_d		= { "rts_r_escort02_0000" },
					afterRouteIdTable_c		= { "rts_r_escort02_0000" },
					travelSetCount			= 4,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.VEHICLE_01,
					isSetRelativeVehicle	= true,
				},
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.WAIT_ESCORT02 end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VS_ESCORT_VEHICLE_01 ) ] = {
		eventSubSequenceIndex = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.WAIT_ESCORT02,
		isSetSuccess = false,
		param = {
			
			{	
				{ unRegisterConvoy = true },
				
				{	
					rideVehicleName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,
					isPrepareVehicleConvoy = true,
				},
				{	
					rideVehicleName = s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,
					isPrepareVehicleConvoy = true,
				},
				{	
					rideVehicleName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,
					isPrepareVehicleConvoy = true,
				},
				
				{
					travelSetRouteIdTable	= {
												"rts_r_escort02_0000",
											},
					travelPlanName			= "travel_v_escort02_to_swampSouth",
					travelSetCount			= 4,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.VEHICLE_01,
					isPrepareVehicleConvoy	= true,
				},
				
				{ registerConvoy = true },
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.DRIVE_ESCORT02 end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_02 ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				
				{
					beforeRouteIdTable		= { "rts_v_escort02_05_0001" },
					afterRouteIdTable_d		= { "rts_zrs_swampSouth_ene02_d_0000", "rts_zrs_swampSouth_ene03_d_0000", "rts_zrs_swampSouth_ene04_d_0000", "rts_zrs_swampSouth_ene05_d_0000", },
					afterRouteIdTable_c		= { "rts_zrs_swampSouth_ene02_d_0000", "rts_zrs_swampSouth_ene03_d_0000", "rts_zrs_swampSouth_ene04_d_0000", "rts_zrs_swampSouth_ene05_d_0000", },
					setRouteCount			= 4,
					isTravelPlanEnd			= true,
					
					isUnsetRelativeVehicle	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH end },
			},
			
			{
				
				{
					travelSetRouteIdTable	= { "rts_v_escort02_05_0001", },
					travelPlanName			= "travel_v_swampSouth_to_escort03",
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.VEHICLE_01,
					isSetRelativeVehicle	= true,
					
					isMessageChangePhase	= true,
				},
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.DRIVE_SWAMPSOUTH end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.T_VW_ESCORT_VEHICLE_01 ) ] = {
		eventSubSequenceIndex = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH,
		isSetSuccess = false,
		param = {
			
			{	
				{
					beforeRouteIdTable		= {
												"rts_zrs_swampSouth_ene02_d_0000",
												"rts_zrs_swampSouth_ene03_d_0000",
												"rts_zrs_swampSouth_ene04_d_0000",
												"rts_zrs_swampSouth_ene05_d_0000",
											},
					afterRouteIdTable_d		= { "rts_v_r_swampSouth_vehicle01" },
					afterRouteIdTable_c		= { "rts_v_r_swampSouth_vehicle01" },
					travelSetCount			= 4,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.VEHICLE_01,
					isSetRelativeVehicle	= true,
				},
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.WAIT_SWAMPSOUTH end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VS_ESCORT_VEHICLE_02 ) ] = {
		eventSubSequenceIndex = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.WAIT_SWAMPSOUTH,
		isSetSuccess = false,
		param = {
			
			{	
				{ unRegisterConvoy = true },
				
				{	
					rideVehicleName = s10090_enemy.VEHICLE_NAME.WEST_WAV01,
					isPrepareVehicleConvoy = true,
				},
				{	
					rideVehicleName = s10090_enemy.VEHICLE_NAME.TRUCK_TARGET,
					isPrepareVehicleConvoy = true,
				},
				{	
					rideVehicleName = s10090_enemy.VEHICLE_NAME.WEST_WAV02,
					isPrepareVehicleConvoy = true,
				},
				
				{
					travelSetRouteIdTable	= {
												"rts_v_r_swampSouth_vehicle01",
											},
					travelPlanName			= "travel_v_swampSouth_to_escort03",
					travelSetCount			= 4,
					
					rideVehicleName			= s10090_enemy.VEHICLE_NAME.VEHICLE_01,
					isPrepareVehicleConvoy	= true,
				},
				
				{ registerConvoy = true },
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.DRIVE_ESCORT02 end },
			},
		},
	}
	
	
	this.commonFuncTable[ StrCode32( this.COMMON_MESSAGE_LIST.R_VE_ESCORT_VEHICLE_03 ) ] = {
		isSetSuccess = false,
		param = {
			
			{	
				
				{
					beforeRouteIdTable		= { "rts_v_escort03_0000" },
					afterRouteIdTable_d		= { "rts_escort03_d_0000", "rts_escort03_d_0001", "rts_escort03_d_0002", "rts_escort03_d_0003", },
					afterRouteIdTable_c		= { "rts_escort03_d_0000", "rts_escort03_d_0001", "rts_escort03_d_0002", "rts_escort03_d_0003", },
					setRouteCount			= 4,
					isTravelPlanEnd			= true,
					
					isUnsetRelativeVehicle	= true,
				},
				
				{ unRegisterConvoy = true },
				
				{ func = function() svars.reserveCount_01 = this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_ESCORT03 end },
			},
		},
	}
	
end


function this.SetUpConversationTable()
	
	
	
	
	this.conversationSettingTable[ StrCode32( this.CONVERSATION_LIST.PFCAMP_0001 ) ] = {
		succesMessage	= StrCode32( this.COMMON_MESSAGE_LIST.C_PFCAMP_ACT_MOVE01 ),					
		areaIndex		= this.ENUM_AREA.EVENT_PFCAMP,													
		
	}
	
	this.conversationSettingTable[ StrCode32( this.CONVERSATION_LIST.PFCAMP_0002 ) ] = {
		areaIndex		= this.ENUM_AREA.EVENT_PFCAMP,													
		isFinish		= true,																			
		
	}
	
	this.conversationSettingTable[ StrCode32( this.CONVERSATION_LIST.PFCAMP_0003 ) ] = {
		areaIndex		= this.ENUM_AREA.EVENT_PFCAMP,													
		isFinish		= true,																			
		
	}
	
	this.conversationSettingTable[ StrCode32( this.CONVERSATION_LIST.SWAMPSOUTH_0001 ) ] = {
		areaIndex		= this.ENUM_AREA.EVENT_SWAMPSOUTH,												
		isFinish		= true,																			
		
	}
	
	this.conversationSettingTable[ StrCode32( this.CONVERSATION_LIST.SWAMP_0001 ) ] = {
		areaIndex		= this.ENUM_AREA.EVENT_SWAMP,													
		succesMessage	= StrCode32( this.COMMON_MESSAGE_LIST.C_SWAMP_CPRADIO01 ),						
		
	}
	
	this.conversationSettingTable[ StrCode32( this.CONVERSATION_LIST.SWAMP_0002 ) ] = {
		areaIndex		= this.ENUM_AREA.EVENT_SWAMP,													
		isFinish		= true,																			
		
	}
	
	
	this.conversationSettingTable[ StrCode32( this.CONVERSATION_LIST.TRANSPORTPOINT_0001 ) ] = {
		isFinish		= true,																			
		succesMessage	= StrCode32( this.COMMON_MESSAGE_LIST.R_TRANSPORTPOINT_TARGET_DEMO ),			
		failureMessage	= StrCode32( this.COMMON_MESSAGE_LIST.R_TRANSPORTPOINT_TARGET_DEMO ),			
	}
	
	
	


end


function this.SetUpMotorcadeSTable()
	
	this.motorcadeSettingTable[StrCode32( TRAP_NAME.MOTORCASE_START_PFCAMP )] = {
		startPossibleTimerList			= this.TIMER_LIST.MOTORCADE_CHECK_PFCAMP,							
		areaIndex						= this.ENUM_AREA.EVENT_PFCAMP,										
		isAreaMvarsName					= "isConverStation01",												
		eventMessageId					= StrCode32( this.COMMON_MESSAGE_LIST.R_PFCAMP_CPRADIO01 ),			
		motorcadeMessageId				= StrCode32( this.COMMON_MESSAGE_LIST.R_VP_PFCAMP_TRUCK ),			
		isPhase							= true,																
		motorcadeComebackTimerList		= this.TIMER_LIST.MOTORCADE_START_PFCAMP_COMEBACK,					
		presenceEscortTimeList			= this.TIMER_LIST.ESCORT_WAV_DEAD,										
		timeEndSvarsName				= "timeEndCount01",
		timeEndMax						= 2,
		
		eventStartSequenceIndexTable	= {																	
											this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_PFCAMP,
										},
		eventSequenceIndexTable			= {																	
											this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP,
										},
		alertSequenceIndexTable			= {																	
											this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_PFCAMP,
										},
	}
	
	this.motorcadeSettingTable[StrCode32( TRAP_NAME.MOTORCASE_START_SWAMPSOUTH )] = {
		startPossibleTimerList			= this.TIMER_LIST.MOTORCADE_CHECK_SWAMPSOUTH,						
		areaIndex						= this.ENUM_AREA.EVENT_SWAMPSOUTH,									
		isAreaMvarsName					= "isConverStation02",												
		eventMessageId					= StrCode32( this.COMMON_MESSAGE_LIST.R_SWAMPSOUTH_ACT_MOVE01 ),	
		motorcadeMessageId				= StrCode32( this.COMMON_MESSAGE_LIST.T_VP_SWAMPSOUTH_TRUCK ),		
		isPhase							= true,																
		motorcadeComebackTimerList		= this.TIMER_LIST.MOTORCADE_START_SWAMPSOUTH_COMEBACK,				
		presenceEscortTimeList			= nil,																
		timeEndSvarsName				= "timeEndCount02",
		timeEndMax						= 2,
		
		eventStartSequenceIndexTable	= {																	
											this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_STOP_SWAMPSOUTH,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMPSOUTH,
										},
		eventSequenceIndexTable			= {																	
											this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMPSOUTH,
										},
		alertSequenceIndexTable			= {																	
											this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_STOP_SWAMPSOUTH,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMPSOUTH,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMPSOUTH,
										},
	}
	
	this.motorcadeSettingTable[StrCode32( TRAP_NAME.MOTORCASE_START_SWAMP )] = {
		startPossibleTimerList			= this.TIMER_LIST.MOTORCADE_CHECK_SWAMP,							
		areaIndex						= this.ENUM_AREA.EVENT_SWAMP,										
		isAreaMvarsName					= "isConverStation03",												
		eventMessageId					= StrCode32( this.COMMON_MESSAGE_LIST.R_SWAMP_ACT_MOVE01 ),			
		motorcadeMessageId				= StrCode32( this.COMMON_MESSAGE_LIST.T_VP_SWAMP_TRUCK ),			
		isPhase							= true,																
		motorcadeComebackTimerList		= this.TIMER_LIST.MOTORCADE_START_SWAMP_COMEBACK,					
		presenceEscortTimeList			= nil,																
		timeEndSvarsName				= "timeEndCount03",
		timeEndMax						= 2,
		
		eventStartSequenceIndexTable	= {																	
											this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMP,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMP,
										},
		eventSequenceIndexTable			= {																	
											this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMP,
										},
		alertSequenceIndexTable			= {																	
											this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMP,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMP,
											this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMP,
										},
	}

end


function this.SetUpTrapTable()
	
	
	this.trapSettingTable[StrCode32( TRAP_NAME.ARRIVALATPFCAMP )] = {
		areaIndex				= this.ENUM_AREA.PFCAMP,
		eventSequenceIndex		= this.ENUM_EVENT_VEHICLE_SEQUENCE.EXIT_PFCAMP,
	}
	this.trapSettingTable[StrCode32( TRAP_NAME.ARRIVALATSWAMP )] = {
		areaIndex				= this.ENUM_AREA.SWAMP,
		eventSequenceIndex		= this.ENUM_EVENT_VEHICLE_SEQUENCE.EXIT_SWAMP,
	}
	this.trapSettingTable[StrCode32( TRAP_NAME.ARRIVALATFLOWSTATION )] = {
		areaIndex				= this.ENUM_AREA.FLOWSTATION,
		eventSequenceIndex		= this.ENUM_EVENT_VEHICLE_SEQUENCE.EXIT_FLOWSTATION,
	}
	this.trapSettingTable[StrCode32( TRAP_NAME.ARRIVALATTRANSPORTPOINT )] = {
		areaIndex				= this.ENUM_AREA.TRANSPORTPOINT,
		eventSequenceIndexTable = {
			this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_TRANSPORTPOINT,
			this.ENUM_EVENT_VEHICLE_SEQUENCE.WAIT_TRANSPORTPOINT,
			this.ENUM_EVENT_VEHICLE_SEQUENCE.DEMO_TRANSPORTPOINT,
		}
	}
	
	
	this.trapSettingTable[StrCode32( TRAP_NAME.INTEL_SAVANNAH )] = {
		areaIndex = this.ENUM_AREA.INTEL_SAVANNAH,		intelName = INTEL_SENDER_NAME.SAVANNAH,		func = s10090_demo.GetIntel_savannah,
	}
	this.trapSettingTable[StrCode32( TRAP_NAME.INTEL_PFCAMPNORTH )] = {
		areaIndex = this.ENUM_AREA.INTEL_PFCAMPNORTH,	intelName = INTEL_SENDER_NAME.PFCAMPNORTH,	func = s10090_demo.GetIntel_pfCampNorth,
	}
	this.trapSettingTable[StrCode32( TRAP_NAME.INTEL_PFCAMPEAST )] = {
		areaIndex = this.ENUM_AREA.INTEL_PFCAMPEAST,	intelName = INTEL_SENDER_NAME.PFCAMPEAST,	func = s10090_demo.GetIntel_pfCampEast,
	}
	this.trapSettingTable[StrCode32( TRAP_NAME.INTEL_SWAMPEAST )] = {
		areaIndex = this.ENUM_AREA.INTEL_SWAMPEAST,		intelName = INTEL_SENDER_NAME.SWAMPEAST,	func = s10090_demo.GetIntel_swampEast,
	}
	
	
	this.trapSettingTable[StrCode32( TRAP_NAME.INTEL_MARKER_SAVANNAH )] = {
		isSvarsName = "isReserveFlag_02",
	}
	this.trapSettingTable[StrCode32( TRAP_NAME.INTEL_MARKER_PFCAMPNORTH )] = {
		isSvarsName = "isReserveFlag_03",
	}
	this.trapSettingTable[StrCode32( TRAP_NAME.INTEL_MARKER_PFCAMPEAST )] = {
		isSvarsName = "isReserveFlag_04",
	}
	this.trapSettingTable[StrCode32( TRAP_NAME.INTEL_MARKER_SWAMPEAST )] = {
		isSvarsName = "isReserveFlag_05",
	}
	
end


function this.SetUpTimerTable()
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMPEAST] = {
		timerTable = {
						{ flagSvarsName = "isEscortVehicleStart", timerList = this.TIMER_LIST.ESCORT_WAV_START, }
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_PFCAMP, },
						{ timerList = this.TIMER_LIST.MOTORCADE_START_PFCAMP, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_PFCAMP, },
						{ timerList = this.TIMER_LIST.MOTORCADE_START_PFCAMP, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.MOTORCADE_START_SWAMPSOUTH, },
						{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_SWAMPSOUTH, },
						{ timerList = this.TIMER_LIST.EVENT_SWAMPSOUTH01, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMPSOUTH] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.MOTORCADE_START_SWAMPSOUTH, },
						{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_SWAMPSOUTH, },
						{ timerList = this.TIMER_LIST.EVENT_SWAMPSOUTH01, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMP] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.MOTORCADE_START_SWAMP, },
						{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_SWAMP, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMP] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.MOTORCADE_START_SWAMP, },
						{ timerList = this.TIMER_LIST.MOTORCADE_CHECK_SWAMP, },
					},
	}
	
if DEBUG then
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_PFCAMP] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.DEBUG_MOTORCADE_START_PFCAMP, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_STOP_SWAMPSOUTH] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.MOTORCADE_START_SWAMPSOUTH, },
						{ timerList = this.TIMER_LIST.DEBUG_EVENT_SWAMPSOUTH01, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMPSOUTH] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.DEBUG_MOTORCADE_START_SWAMPSOUTH, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMP] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.DEBUG_MOTORCADE_START_SWAMP, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMP] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.DEBUG_MOTORCADE_START_SWAMP, },
					},
	}
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_PARASITES] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.DEBUG_EVENT_SWAMPSOUTH01, },
						{ timerList = this.TIMER_LIST.DEBUG_PARASITES, },
					},
	}
end
	
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.ALL_TIMER] = {
		timerTable = {
						
						{ timerList = this.TIMER_LIST.CHECK_RANGE_TARGET, },
						
						{ func = function() this.SetTimerEscortDead() end },
						
						{ func = function() this.SetTimerEscortWavStart() end },
						
						{ func = function() this.SetTimerEscortVehicleStartpfCamp() end },
						
						{ func = function() this.SetTimerEscortVehicleStartswampSouth() end },
					},
	}
	
	
	this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.ALL_TIMER_STOP] = {
		timerTable = {
						{ timerList = this.TIMER_LIST.STOP_01, },
						{ timerList = this.TIMER_LIST.STOP_02, },
						{ timerList = this.TIMER_LIST.STOP_03, },
						{ timerList = this.TIMER_LIST.STOP_04, },
						{ timerList = this.TIMER_LIST.STOP_05, },
						{ timerList = this.TIMER_LIST.STOP_06, },
						{ timerList = this.TIMER_LIST.STOP_07, },
						{ timerList = this.TIMER_LIST.STOP_08, },
						{ timerList = this.TIMER_LIST.STOP_09, },
						{ timerList = this.TIMER_LIST.STOP_10, },
						{ timerList = this.TIMER_LIST.STOP_11, },
						{ timerList = this.TIMER_LIST.STOP_12, },
						{ timerList = this.TIMER_LIST.STOP_13, },
					},
	}
	
end


function this.SetUpCheckTable()
	
	
	this.checkSettingTable = {
		
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.START,						isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_01,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMPEAST,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_01,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMPEAST01,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_01,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMPEAST02,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_01,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.ENTER_PFCAMP,				isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_01,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP,				isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_01,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_PFCAMP,		isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_01,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMP01,				isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_01,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_PFCAMP02,				isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_02,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.EXIT_PFCAMP,				isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMPSOUTH,	isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMPSOUTH,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.ENTER_SWAMP,				isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMP,					isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.CONVERSATION_SWAMP,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_SWAMP,				isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.EXIT_SWAMP,					isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.ENTER_FLOWSTATION,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_FLOWSTATION,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DRIVE_FLOWSTATION,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.EXIT_FLOWSTATION,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_TRANSPORTPOINT,		isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.WAIT_TRANSPORTPOINT,		isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEMO_TRANSPORTPOINT,		isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_PFCAMP,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_PFCAMP_01,		outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_STOP_SWAMPSOUTH,		isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMPSOUTH,		isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_DRIVE_SWAMP,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.DRIVE,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
		{ eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_PARASITES,			isCheckAction = this.ENUM_VEHICLE_CHECK_ACTION.STOP,		inRange = this.RANGE_LIST.IN_PARASITES_TO_TRANSPORTPOINT,	outRange = this.RANGE_LIST.OUT_PARASITES, },
	}
	
end


function this.check_parasiteFulton()

	local nowStorySeq	= TppStory.GetCurrentStorySequence()
 	local allowStorySeq	= TppDefine.STORY_SEQUENCE.CLEARD_METALLIC_ARCHAEA

	if ( nowStorySeq >= allowStorySeq ) then
 		Fox.Log("#### parasite Fulton OK !!")	
 		GameObject.SendCommand( { type="TppParasite2" }, { id="SetFultonEnabled", enabled=true } ) 
 	else
 		Fox.Log("#### parasite Fulton NG !!")	
 	end
end


function this.TargetSetting()
	
	if svars.isMarkingVehicle01 == false	then
		TppMarker.Disable( "veh_trc_0000","",true )
	else
		Fox.Log("isMarkingVehicle01 == true ... Nothing Done !!")
	end
	
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId("veh_trc_0000"), langId="marker_info_mission_target" }
end


function this.targetGuard_Setting()

	local wavId_01 = GameObject.GetGameObjectId( "TppVehicle2", "veh_wav_0000" )	
	local wavId_02 = GameObject.GetGameObjectId( "TppVehicle2", "veh_wav_0001" )	
	local targetTruck	= GameObject.GetGameObjectId( "TppVehicle2", "veh_trc_0000" )	
	local wav_driver_A	= "sol_ZRS_0000"		
	local wav_driver_B	= "sol_ZRS_0001"		
	local soldierId_A	= GameObject.GetGameObjectId("TppSoldier2", wav_driver_A )
	local soldierId_B	= GameObject.GetGameObjectId("TppSoldier2", wav_driver_B )
	local targetVehicle	= "veh_trc_0000"		
	local command		= { id="SetCommandAi", commandType = CommandAi.ESCORT, vehicle = targetVehicle, formationIndex = 0 } 
	
	if svars.isAppearanceParasites == false and svars.eventSequenceIndex >=9 and GameObject.SendCommand( targetTruck , { id="IsAlive", } ) then
		
		if GameObject.SendCommand( wavId_01 , { id="IsAlive", } ) then
			GameObject.SendCommand( soldierId_A, command ) 
		else
		end
		
		if GameObject.SendCommand( wavId_02 , { id="IsAlive", } ) then
			GameObject.SendCommand( soldierId_B, command )
		else
		end
	else
	end
end


function this.targetDriver_Clear( gameObjectId )
	
	if gameObjectId == svars.firstTargetDriverGameObjectId then
		this.targetGuard_Setting()
	else
	end
end


function this.EnableCommonOptionalRadio_OnOff()

	if svars.isAppearanceParasites == true	then
		TppRadio.EnableCommonOptionalRadio( false )
	else
		TppRadio.EnableCommonOptionalRadio( true )
	end
end







function this.Messages()
	return
	StrCode32Table {
		
		Player = {
			{	
				msg = "PlayerFulton",
				func = function( playerId, s_gameObjectId )
					
					if Tpp.IsVehicle( s_gameObjectId ) and this.IsFultonCargo() == false then
						local isAppearance = this.IsAppearanceParasites()
						
						if isAppearance == false then
							s10090_radio.NoEquipDevelopedFultonCargo( false )
						
						else
							
							if this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == true then
								local gameObjectId = GetGameObjectId( s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )
								if s_gameObjectId == gameObjectId then
									s10090_radio.NoEquipDevelopedFultonCargo( true )
								end
							end
						end
					end
				end
			},
			{	
			 	msg = "GetIntel",
				sender = {
						INTEL_SENDER_NAME.SAVANNAH,
						INTEL_SENDER_NAME.PFCAMPNORTH,
						INTEL_SENDER_NAME.PFCAMPEAST,
						INTEL_SENDER_NAME.SWAMPEAST,
						},
				func = function( intelNameHash )
					if svars.intelAreaTrapIndex ~= 0 then
						this.OnIntelDemo( intelNameHash )
					end
				end
			},
			{	
				msg = "OnVehicleRide_Start",
				func = function( playerId, type, gameObjectId )
					if type == 0 then
						this.OnVehicleAction{ gameObjectId = gameObjectId, actionType = "OnVehicleRide_Start" }
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
				func = function( instanceName, makerType, s_gameObjectId, identificationCode )
					this.OnChangeToEnable( instanceName, makerType, s_gameObjectId, identificationCode )
				end
			},
		},
		
		GameObject = {
			{	
				msg = "PlacedIntoVehicle" ,
				func = function ( gameObjectId , vehicleType )
					if vehicleType == GameObject.GetGameObjectId( "SupportHeli" ) then	
						if gameObjectId == svars.firstTargetDriverGameObjectId then
							this.targetGuard_Setting()
						end
					end
				end
			},
			{	
				msg = "Dead",
				func = function( gameObjectId )
					this.targetDriver_Clear( gameObjectId )
				end
			},
			{	
				msg = "RoutePoint2",
				func = function( gameObjectId, routeId, routeNodeIndex, messageId )
					
					this.OnCommonFunc{ gameObjectId = gameObjectId, routeId = routeId, routeNodeIndex = routeNodeIndex, messageId = messageId }
				end
			},
			{	
				msg = "ChangePhase",
				func = function( gameObjectId, phaseName )
					this.OnChangePhase( gameObjectId, phaseName )
				end
			},
			{	
				msg = "Fulton",
				func = function( s_gameObjectId )
					if Tpp.IsVehicle( s_gameObjectId ) then
						this.OnVehicleAction{ gameObjectId = s_gameObjectId, actionType = "Fulton" }
					end
					
					if s_gameObjectId == svars.firstTargetDriverGameObjectId then
						this.targetGuard_Setting()
					end
				end,
				option = { isExecDemoPlaying = true },
			},
			{	
				msg = "FultonFailedEnd", 
				func = function( gameObjectId, locatorName, locatorNameUpper, failureType )
					if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE and Tpp.IsVehicle( gameObjectId ) then
				
							this.OnVehicleAction{ gameObjectId = gameObjectId, actionType = "FultonFailedEnd" }
				
					end
				end
			},
			{	
				msg = "Neutralize",
				func = function( neutralizedGameObjectId, attackerGameObjectId, neutralizeType, NeutralizeCause )
					if neutralizeType == NeutralizeType.DEAD then
						if Tpp.IsVehicle( neutralizedGameObjectId ) then
							this.OnVehicleAction{ gameObjectId = neutralizedGameObjectId, actionType = "Broken", attackerGameObjectId = attackerGameObjectId }
						end
					end
				end
			},
			{	
				msg = "VehicleAction",
				func = function( gameObjectId, vehicleGameObjectId, actionType )
					if Tpp.IsVehicle( vehicleGameObjectId ) then
						this.OnEnemyVehicleAction{ gameObjectId = gameObjectId, vehicleGameObjectId = vehicleGameObjectId, actionType = actionType }
					end
				end
			},
			{	
				msg = "Observed",
				func = function( gameObjectId, observations )
					
					if bit.band( observations, Vehicle.observation.PLAYER_WILL_BREAK_VEHICLE ) == Vehicle.observation.PLAYER_WILL_BREAK_VEHICLE then
						this.OnEnemyVehicleAction{ vehicleGameObjectId = gameObjectId, actionType = "VehicleHalfBroken" }
					
					elseif bit.band( observations, Vehicle.observation.PLAYER_WILL_HARM_VEHICLE ) == Vehicle.observation.PLAYER_WILL_HARM_VEHICLE then
						this.OnEnemyVehicleAction{ vehicleGameObjectId = gameObjectId, actionType = "VehicleDamage" }
					
					elseif bit.band( observations, Vehicle.observation.PLAYER_WILL_HARM_VEHICLE ) == Vehicle.observation.PLAYER_STOPS_VEHICLE_BY_BREAKING_WHEELS then
						this.OnEnemyVehicleAction{ vehicleGameObjectId = gameObjectId, actionType = "CanNotMove" }
					end
				end
			},
			{	
				msg = "ConversationEnd",
				func = function( GameObjectId, speechLabel, isSuccess )
					this.OnConversationEnd( GameObjectId, speechLabel, isSuccess )
				end
			},
			{	
				msg = "MonologueEnd",
				func = function( GameObjectId, speechLabel, isSuccess )
					this.OnConversationEnd( GameObjectId, speechLabel, isSuccess )
				end
			},
			{	
				msg = "RadioEnd",
				func = function( GameObjectId, cpGameObjectId, speechLabel, isSuccess )
					this.OnConversationEnd( GameObjectId, speechLabel, isSuccess )
				end
			},
			{	
				msg = "Dying",
				func = function( gameObjectId )
					if s10090_enemy.IsParasites( gameObjectId ) then
						svars.parasiteDyingCount = svars.parasiteDyingCount + 1
						
						TppMission.UpdateObjective{ objectives = { "on_subTask_skulls", },}
						
						TppResult.AcquireSpecialBonus{
				        	first = { pointIndex = svars.parasiteDyingCount },
						}
					end
				end
			},
			{	
				msg = "DyingAll",
				func = function( GameObjectId )
					if svars.isDyingAllParasites == false then
						svars.isDyingAllParasites = true
						
						this.SetEndParasites()
					end
				end
			},
			{	
				msg = "StartedCombat",
				func = function( GameObjectId )
					s10090_sound.SetParasitesStartedCombat()
				end
			},
			{	
				msg = "StartedSearch",
				func = function( GameObjectId, type )
					s10090_sound.SetParasitesStartedSearch()
				end
			},
		},
		
		Trap = {
			{	
				msg = "Enter",
				sender = {
						TRAP_NAME.INTEL_MARKER_SAVANNAH,
						TRAP_NAME.INTEL_MARKER_PFCAMPNORTH,
						TRAP_NAME.INTEL_MARKER_PFCAMPEAST,
						TRAP_NAME.INTEL_MARKER_SWAMPEAST,
						},
				func = function( trapId )
					local intelDataSetting = this.trapSettingTable[trapId]
					if intelDataSetting then
						if this.IsMainSequence() == true and this.IsAppearanceParasites() == false then
							if svars[intelDataSetting.isSvarsName] == false then
								if svars.isOnGetIntel == false then
									s10090_radio.TrapBeforeGetIntel()
								else
									s10090_radio.TrapAfterGetIntel()
								end
								svars[intelDataSetting.isSvarsName] = true
							end
						end
					end
				end
			},
			{	
				msg = "Enter",
				sender = {
						TRAP_NAME.INTEL_SAVANNAH,
						TRAP_NAME.INTEL_PFCAMPNORTH,
						TRAP_NAME.INTEL_PFCAMPEAST,
						TRAP_NAME.INTEL_SWAMPEAST,
						},
				func = function( trapId )
					local intelDataSetting = this.trapSettingTable[trapId]
					if intelDataSetting then
						svars.intelAreaTrapIndex = intelDataSetting.areaIndex
					end
				end
			},
			{	
				msg = "Exit",
				sender = {
						TRAP_NAME.INTEL_SAVANNAH,
						TRAP_NAME.INTEL_PFCAMPNORTH,
						TRAP_NAME.INTEL_PFCAMPEAST,
						TRAP_NAME.INTEL_SWAMPEAST,
						},
				func = function()
					
					svars.intelAreaTrapIndex = 0
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.INTEL_LOADDEMO,
				func = function()
					svars.isLoadDemoIntelArea = true
					this.SetDemoLoad()
				end
			},
			{	
				msg = "Exit",
				sender = TRAP_NAME.INTEL_LOADDEMO,
				func = function()
					svars.isLoadDemoIntelArea = false
					this.SetDemoLoad()
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.ARRIVALATPFCAMPNORTH_01,
				func = function()
					if svars.isReserveFlag_06 == false	and svars.reserveCount_02 == 0 then
						if this.IsMainSequence() == true and this.IsAppearanceParasites() == false then
							if svars.isOnGetIntel == false then
								local radioGroups = s10090_radio.GetArrivalAtpfCampNorth()
								
								TppMission.UpdateObjective{
									radio = {
										radioGroups = radioGroups,
									},
									objectives = {
										
										"arrival_at_pfCampNorth",
									},
								}
								svars.isReserveFlag_06 = true
							end
						end
					end
				end
			},
			{	
				msg = "Enter",
				sender = TRAP_NAME.ARRIVALATPFCAMPNORTH_02,
				func = function()
					if svars.isReserveFlag_07 == false and svars.reserveCount_02 == 0  then
						if this.IsMainSequence() == true and this.IsAppearanceParasites() == false then
							if svars.isOnGetIntel == false then
								
								s10090_radio.ArrivalAtpfCampNorth()
								svars.isReserveFlag_07 = true
							end
						end
					end
				end
			},
			{	
				msg = "Enter",
				sender = {
						TRAP_NAME.ARRIVALATPFCAMP,
						TRAP_NAME.ARRIVALATSWAMP,
						TRAP_NAME.ARRIVALATFLOWSTATION,
						},
				func = function( trapId )
					if this.IsMainSequence() == true and this.IsAppearanceParasites() == false then
						
						if this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == false then
							local trapSetting = this.trapSettingTable[trapId]
							if trapSetting then
								svars.areaTrapIndex = trapSetting.areaIndex
							end
							
							this.SetTimer{ timerList = this.TIMER_LIST.RADIO_START_ARRIVALATAREA }
						end
					end
				end
			},
			{	
				msg = "Exit",
				sender = {
						TRAP_NAME.ARRIVALATPFCAMP,
						TRAP_NAME.ARRIVALATSWAMP,
						TRAP_NAME.ARRIVALATFLOWSTATION,
						},
				func = function( trapId )
					
					svars.areaTrapIndex = 0
					
					this.SetTimer{ timerList = this.TIMER_LIST.RADIO_STOP_ARRIVALATAREA }
				end
			},
			{	
				msg = "Enter",
				sender = {
						TRAP_NAME.ARRIVALATTRANSPORTPOINT,
						},
				func = function( trapId )
					svars.isArrivalAtTransport = true
					this.CheckTransportPointGameOver()
				end
			},
			{	
				msg = "Exit",
				sender = {
						TRAP_NAME.ARRIVALATTRANSPORTPOINT,
						},
				func = function( trapId )
					svars.isArrivalAtTransport = false
				end
			},
			{	
				msg = "Enter",
				sender = {
						TRAP_NAME.ESCORTVEHICLE_START,
						},
				func = function( trapId )
					this.OnEscortVehicleStart()
				end
			},
			{	
				msg = "Enter",
				sender = {
						TRAP_NAME.MOTORCASE_START_PFCAMP,
						TRAP_NAME.MOTORCASE_START_SWAMPSOUTH,
						TRAP_NAME.MOTORCASE_START_SWAMP,
						},
				func = function( trapId )
					local motorcaseSetting = this.motorcadeSettingTable[trapId]
					if motorcaseSetting then
						this.CheckMotorcadeStart{ areaIndex = motorcaseSetting.areaIndex, isSvarsUpdate = true }
					end
				end
			},
			{	
				msg = "Exit",
				sender = {
						TRAP_NAME.MOTORCASE_START_PFCAMP,
						TRAP_NAME.MOTORCASE_START_SWAMPSOUTH,
						TRAP_NAME.MOTORCASE_START_SWAMP,
						},
				func = function( trapId )
					local motorcaseSetting = this.motorcadeSettingTable[trapId]
					if motorcaseSetting then
						this.CheckMotorcadeStart{ areaIndex = motorcaseSetting.areaIndex, isSvarsUpdate = false }
					end
				end
			},
		},
		
		Timer = {
			
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.ESCORT_VEHICLE_START_01.timerName,
				func = function()
					if svars.isReserveFlag_08 == false then
						if svars.reserveCount_01 == this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_ESCORT01 then
							svars.isReserveFlag_08 = true
							this.OnCommonFunc{ messageId = Fox.StrCode32( this.COMMON_MESSAGE_LIST.T_VS_ESCORT_VEHICLE_01 ) }
						elseif svars.reserveCount_01 == this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_ESCORT01 then
							svars.isReserveFlag_08 = true
						end
					end
				end,
			},
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.ESCORT_VEHICLE_START_02.timerName,
				func = function()
					if svars.isReserveFlag_09 == false then
						if svars.reserveCount_01 == this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH then
							svars.isReserveFlag_09 = true
							this.OnCommonFunc{ messageId = Fox.StrCode32( this.COMMON_MESSAGE_LIST.T_VW_ESCORT_VEHICLE_01 ) }
						else
							svars.isReserveFlag_09 = true
						end
					end
				end,
			},
			
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.ESCORT_START.timerName,
				func = function()
					if svars.eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMPEAST then
						this.OnCommonFunc{ messageId = Fox.StrCode32( this.COMMON_MESSAGE_LIST.T_VS_PFCAMPEAST ) }
					end
				end,
			},
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.ESCORT_WAV_START.timerName,
				func = function()
					if svars.eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMPEAST then
						this.OnCommonFunc{ messageId = Fox.StrCode32( this.COMMON_MESSAGE_LIST.T_VS_PFCAMPEAST ) }
					end
				end,
			},
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.ESCORT_WAV_DEAD.timerName,
				func = function()
					if svars.eventSequenceIndex < this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP then
						
						this.OnCommonFunc{ messageId = Fox.StrCode32( this.COMMON_MESSAGE_LIST.T_PFCAMP_ACT_MOVE01 ) }
					end
				end,
			},
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.MOTORCADE_CHECK_PFCAMP.timerName,
				func = function()
					if svars.eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMP then
						this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_PFCAMP, isCheckEventStart = true }
					end
				end,
			},
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.MOTORCADE_CHECK_SWAMPSOUTH.timerName,
				func = function()
					if svars.eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH then
						this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_SWAMPSOUTH, isCheckEventStart = true }
					end
				end,
			},
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.MOTORCADE_CHECK_SWAMP.timerName,
				func = function()
					if svars.eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMP then
						this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_SWAMP, isCheckEventStart = true }
					end
				end,
			},
			
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.MOTORCADE_START_PFCAMP.timerName,
				func = function()
					this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_PFCAMP, isTimeEnd = true }
				end,
			},
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.MOTORCADE_START_SWAMPSOUTH.timerName,
				func = function()
					this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_SWAMPSOUTH, isTimeEnd = true }
				end,
			},
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.MOTORCADE_START_SWAMP.timerName,
				func = function()
					this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_SWAMP, isTimeEnd = true }
				end,
			},
			
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.EVENT_SWAMPSOUTH01.timerName,
				func = function()
					
					if svars.eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH then
						this.OnCommonFunc{ messageId = Fox.StrCode32( this.COMMON_MESSAGE_LIST.T_SWAMPSOUTH_ACT_MOVE_START ) }
					elseif DEBUG then
						
						if svars.eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_STOP_SWAMPSOUTH then
							svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH
							this.OnCommonFunc{ messageId = Fox.StrCode32( this.COMMON_MESSAGE_LIST.T_SWAMPSOUTH_ACT_MOVE_START ) }
						elseif svars.eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.DEBUG_PARASITES then
							svars.eventSequenceIndex = this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_SWAMPSOUTH
						end
					end
				end,
			},
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.EVENT_SWAMPSOUTH02.timerName,
				func = function()
					this.OnCommonFunc{ messageId = Fox.StrCode32( this.COMMON_MESSAGE_LIST.T_SWAMPSOUTH_ACT_MOVE_END ) }
				end,
			},
			
			{	
				msg = "Finish",
				sender = this.TIMER_LIST.CHECK_RANGE_TARGET.timerName,
				func = function()
					this.CheckTimerParasites()
				end,
			},
			
			{
				msg = "Finish",
				sender = this.TIMER_LIST.RADIO_START_ARRIVALATAREA.timerName,
				func = function()
					this.OnArrivalAtAreaTrap()
				end,
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
		},
		UI = {
			{
				msg = "EndFadeOut", sender = "TargetEscapeDemoFade",
				func = function()
					TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.S10090_TARGET_ESCAPE, TppDefine.GAME_OVER_RADIO.OTHERS )
				end,
			},
		},
		Subtitles = {
			{	msg = "SubtitlesEndEventMessage",                               
				func = function( speechLabel, status )
					Fox.Log( "####SubtitlesEndEventMessage ####")
					if		(speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf1000_094079_0_enec_af" ))			
						or	(speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf1000_094105_0_enec_af" ))			
						or	(speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "stpf1000_095211_0_cpa_af" )) then		

						svars.reserveCount_04	 = svars.reserveCount_04 + 1
						if svars.reserveCount_04 >= 3	then
							TppMission.UpdateObjective{ objectives = { "on_subTask_conversation_ghost",},}
						end
					end
				end
			},      
		},
		Demo = {
			{
				msg = "Finish",
				sender = "p41_050010",
				func = function()
					Fox.Log( "s10090_sequence.Messages(): Demo: Finish: p41_050010" )
					mvars.playingParasiteAppearanceDemo = false
				end,
				option = { isExecDemoPlaying = true },
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






function this.IsFultonCargo()
	if TppMotherBaseManagement.IsEquipDeveloped{ equipID = TppEquip.EQP_IT_Fulton_Cargo }	then
		return true
	else
		return false
	end









end


function this.IsAppearanceParasites()
	local blRetcode = false
	if svars.isAppearanceParasites == false then
		blRetcode = false
	else
		if svars.isDyingAllParasites == false then
			blRetcode = true
		else
			blRetcode = false
		end
	end
	return blRetcode
end



function this.IsMainSequence()
	local sequenceName	 = TppSequence.GetCurrentSequenceName()
	local blRetcode = false
	if sequenceName == "Seq_Game_MainGame" then
		blRetcode = true
	end
	return blRetcode
end


this.IsSequenceEnemyVehicleAction = function( isCheckAction )
	for i, params in ipairs( this.checkSettingTable ) do
		if svars.eventSequenceIndex == params.eventSequenceIndex then
			if isCheckAction == params.isCheckAction then
				return true
			end
			return false
		end
	end
	Fox.Warning(" IsSequenceEnemyVehicleAction : NoEventSequenceIndexName !! ")
	return false
end






function this.CheckTimerParasites()

	local gameObjectName	= s10090_enemy.VEHICLE_NAME.TRUCK_TARGET
	local vehiclePosition	= s10090_enemy.GetVehiclePosition( gameObjectName )
	
	if this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == true then
		return
	end
	
	if DEBUG then
		if this.DEBUG_NO_PARASITES_APPEAR == true then
			return
		end
	end
	
	
	if svars.isDyingAllParasites == false then
		local inRange, outRange = this.GetPlayerRange( "InRange" )
		if this.IsPlayerInRange( vehiclePosition, inRange ) then
			local demoEndFunction = function()
				this.SetStartParasites()	
				this.acpDriver_OnOffCheck()	
				TppMission.UpdateObjective{ objectives = {"on_target_vehicle","on_subGoal_missiontarget"}, }		
				svars.isMarkingVehicle01 = true
				TppUiCommand.InitAllEnemyRoutePoints()	
			end
			if svars.isAppearanceParasites == false then
				
				if s10090_enemy.IsVehicleStateFulton( s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == true then
					svars.isAppearanceParasites = true
					
					s10090_enemy.StartSearch()
					
					TppScriptBlock.LoadDemoBlock( "Demo_ParasiteAppearance" )
					
					s10090_sound.SetParasitesStart()
					
					mvars.playingParasiteAppearanceDemo = true
					s10090_demo.ParasiteAppearance( demoEndFunction )
					
					TppRadio.EnableCommonOptionalRadio( false )
				end
			end
		end
		if svars.isAppearanceParasites == false then
			
			this.SetTimer{ timerList = this.TIMER_LIST.CHECK_RANGE_TARGET  }
		end
	
	else
		
		this.SetTimer{ timerList = this.TIMER_LIST.CHECK_STOP_RANGE_TARGET  }
	end
end


function this.SetStartParasites()
	
	s10090_enemy.SetAppearParasites()
	
	this.SetAllCheckPointVisible( false )
	
	this.SetTimerSetting( true )
	

	
	s10090_radio.AppearParasites()
	
	vars.playerDisableActionFlag = PlayerDisableAction.TIME_CIGARETTE
	
	this.SetEnableIntelDemo( false )
	
	TppMission.StartBossBattle()
end


function this.SetEndParasites()
	
	s10090_enemy.SetExitParasites()
	

	
	this.SetTimerSetting( false )
	
	s10090_sound.SetParasitesEnd()
	
	local isFound = this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.FULTONFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) 
	s10090_radio.DyingParasites( isFound )
	
	vars.playerDisableActionFlag = PlayerDisableAction.NONE
	

	
	TppMission.FinishBossBattle()
end


function this.SetExitParasites()
	
	s10090_enemy.SetExitParasites()
	
	vars.playerDisableActionFlag = PlayerDisableAction.NONE
	
	TppMission.FinishBossBattle()
end


function this.acpDriver_OnOffCheck()
	
	if 		svars.isAppearanceParasites == true		then
		GameObject.SendCommand( GameObject.GetGameObjectId("sol_ZRS_0000") , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId("sol_ZRS_0001") , { id="SetEnabled", enabled=false } )
	elseif 	svars.isAppearanceParasites == false	then
		GameObject.SendCommand( GameObject.GetGameObjectId("sol_ZRS_0000") , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId("sol_ZRS_0001") , { id="SetEnabled", enabled=true } )
	else	
		GameObject.SendCommand( GameObject.GetGameObjectId("sol_ZRS_0000") , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId("sol_ZRS_0001") , { id="SetEnabled", enabled=true } )
	end
end


this.CheckTransportPointGameOver = function()
	local trapId		= StrCode32( TRAP_NAME.ARRIVALATTRANSPORTPOINT )
	local trapSetting	= this.trapSettingTable[trapId]
	local isDemo		= false
	if trapSetting then
		if trapSetting.eventSequenceIndexTable then
			for i, eventSequenceIndex in ipairs( trapSetting.eventSequenceIndexTable ) do
				
				if svars.eventSequenceIndex == eventSequenceIndex then
					
					if eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_TRANSPORTPOINT then
						isDemo = true
					
					elseif eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.WAIT_TRANSPORTPOINT then
						if svars.isArrivalAtTransport == true then
							this.OnCommonFunc{ messageId = StrCode32( this.COMMON_MESSAGE_LIST.R_TRANSPORTPOINT_TARGET_CON ) }
						end
						isDemo = true
					
					elseif eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.DEMO_TRANSPORTPOINT then
						if svars.isArrivalAtTransport == true then
							TppUI.FadeOut( TppUI.FADE_SPEED.FADE_NORMALSPEEDD, "TargetEscapeDemoFade" )
						end
						isDemo = true
					end
				end
			end
			
			if isDemo == false then
				if svars.isOnGetIntel == true and svars.isAppearanceParasites == false and svars.isFultonVehicle01 == false then
					s10090_radio.ArrivalAtTransportPoint()
				end
			end
		end
	end
end





function this.SetDemoLoad( demoName )
	local loadDemoName = demoName or nil
	if loadDemoName == nil then
		if	( svars.isLoadDemoIntelArea == false and svars.isOnGetIntel == false ) or 
			( svars.isLoadDemoIntelArea == false and svars.isOnGetIntel == true ) or 
			( svars.isLoadDemoIntelArea == true and svars.isOnGetIntel == true ) then
			if svars.isAppearanceParasites == false then
				loadDemoName = "Demo_ParasiteAppearance"
			else
				loadDemoName = "Demo_TargetEscape"
			end
		else
			loadDemoName = "Demo_GetIntel"
		end
	end
	
	TppScriptBlock.LoadDemoBlock( loadDemoName )
end






function this.SetTimerSetting( isAllStop )
	
	
	local function _SetTimer( timerTable )
		for i, param in ipairs( timerTable ) do
			local isTimerOn = true
			local isStop = param.isStop or true
			if param.flagSvarsName then
				if svars[param.flagSvarsName] == false then
					isTimerOn = false
				end
			end
			if param.func then
				param.func()
			end
			if param.timerList and isTimerOn == true then
				this.SetTimer{ timerName = param.timerList.timerName, time = param.timerList.time, stop = true  }
			end
		end
	end
	
	
	local timerSetting
	
	isAllStop = isAllStop or false
	if isAllStop == false then
		
		if this.timerSettingTable[svars.eventSequenceIndex] then
			timerSetting = this.timerSettingTable[svars.eventSequenceIndex]
			if timerSetting.timerTable then
				_SetTimer( timerSetting.timerTable )
			end
		end
		
		timerSetting = this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.ALL_TIMER]
		if timerSetting.timerTable then
			_SetTimer( timerSetting.timerTable )
		end
	else
		
		timerSetting = this.timerSettingTable[this.ENUM_EVENT_VEHICLE_SEQUENCE.ALL_TIMER_STOP]
		if timerSetting.timerTable then
			_SetTimer( timerSetting.timerTable )
		end
	end
end


function this.SetTimerEscortDead()
	local isFound01 = this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, s10090_enemy.VEHICLE_NAME.WEST_WAV01 )
	local isFound02 = this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, s10090_enemy.VEHICLE_NAME.WEST_WAV02 )
	if isFound01 == true and isFound02 == true then
		this.SetTimer{ timerList = this.TIMER_LIST.ESCORT_WAV_DEAD }
	end
end


function this.SetTimerEscortWavStart()
	if svars.isEscortVehicleStart == false then
		if svars.eventSequenceIndex == this.ENUM_EVENT_VEHICLE_SEQUENCE.STOP_PFCAMPEAST then
			this.SetTimer{ timerList = this.TIMER_LIST.ESCORT_START }
		end
	end
end


function this.SetTimerEscortVehicleStartpfCamp()
	if svars.isReserveFlag_08 == false then
		if svars.reserveCount_01 == this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.STOP_ESCORT01 then
			this.SetTimer{ timerList = this.TIMER_LIST.ESCORT_VEHICLE_START_01 }
		end
	end
end


function this.SetTimerEscortVehicleStartswampSouth()
	if svars.isReserveFlag_09 == false then
		if svars.reserveCount_01 == this.ENUM_EVENT_ESCORT_VEHICLE_SEQUENCE.WAIT_SWAMPSOUTH then
			this.SetTimer{ timerList = this.TIMER_LIST.ESCORT_VEHICLE_START_02 }
		end
	end
end






function this.SetCheckPoint()
	if svars.isCheckPointAllDisable == false then
		TppMission.UpdateCheckPointAtCurrentPosition()
	end
end


function this.SetAllCheckPointVisible( enabled )
	
	if svars.isCheckPointAllDisable == true then
		enabled = false
	end
	
	for i, baseName in ipairs( this.baseList ) do
		if enabled == false then
			TppCheckPoint.Disable{ baseName = baseName }
		elseif enabled == true then
			TppCheckPoint.Enable{ baseName = baseName }
		end
	end
end






this.OnCommonFunc = function( params )
	
	
	local function _OnCommonFunc_CheckSetEnemyId( setEnemyIdTable, gameObjectId )
		local isSccess = true
		for i, enemyId in ipairs( setEnemyIdTable ) do
			if enemyId == gameObjectId then
				isSccess = false
			end
		end
		return isSccess
	end
	
	
	local function _OnCommonFunc_SetRelativeVehicle( commonFunc, enemyId )
		if enemyId == nil then
			Fox.Error("_OnCommonFunc_SetRelativeVehicle No enemyId")
			return
		end
		if commonFunc.rideVehicleName and commonFunc.isSetRelativeVehicle == true then
			if not this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, commonFunc.rideVehicleName ) then
				
				s10090_enemy.SetRelativeVehicle( enemyId, commonFunc.rideVehicleName, commonFunc.isrideFromBeginning, commonFunc.isVigilance )
				return true
			end
		end
		return false
	end
	
	
	local function _OnCommonFunc_SetRouteEnemyId( commonFunc, enemyId, routeNum, setEnemyIdTable, setRouteCount )
		local isSucces = false
		local setCount = commonFunc.setRouteCount or 255
		if s10090_enemy.GetStatus( enemyId ) == true and _OnCommonFunc_CheckSetEnemyId( setEnemyIdTable, enemyId ) == true and setRouteCount < setCount then
			
			table.insert( setEnemyIdTable, enemyId )
			
			if commonFunc.afterRouteIdTable_d then
				if IsTypeTable( commonFunc.afterRouteIdTable_d ) then
					if commonFunc.afterRouteIdTable_d[ routeNum + 1 ] then
						TppEnemy.SetSneakRoute( enemyId, commonFunc.afterRouteIdTable_d[ routeNum + 1 ] )
						isSucces = true
					else
						TppEnemy.SetSneakRoute( enemyId, commonFunc.afterRouteIdTable_d[ routeNum ] )
					end
				else
					Fox.Error("Parameters support table only")
				end
			end
			
			if commonFunc.afterRouteIdTable_c then
				if IsTypeTable( commonFunc.afterRouteIdTable_c ) then
					if commonFunc.afterRouteIdTable_c[ routeNum + 1 ] then
						TppEnemy.SetCautionRoute( enemyId, commonFunc.afterRouteIdTable_c[ routeNum + 1 ] )
						isSucces = true
					else
						TppEnemy.SetCautionRoute( enemyId, commonFunc.afterRouteIdTable_c[ routeNum ] )
					end
				else
					Fox.Error("Parameters support table only")
				end
			end
			
			if commonFunc.afterRouteIdTable_a then
				if IsTypeTable( commonFunc.afterRouteIdTable_a ) then
					if commonFunc.afterRouteIdTable_a[ routeNum + 1 ] then
						TppEnemy.SetAlertRoute( enemyId, commonFunc.afterRouteIdTable_a[ routeNum + 1 ] )
						isSucces = true
					else
						TppEnemy.SetAlertRoute( enemyId, commonFunc.afterRouteIdTable_a[ routeNum ] )
					end
				else
					Fox.Error("Parameters support table only")
				end
			end
			
			_OnCommonFunc_SetRelativeVehicle( commonFunc, enemyId )
			
			if IsTypeString( enemyId ) then
				enemyId = GetGameObjectId( enemyId )
			end
			
			if commonFunc.isTravelPlanEnd == true then
				GameObject.SendCommand( enemyId, { id = "StartTravel", travelPlan = "", keepInAlert = false } )
			end
			
			if commonFunc.isUnsetRelativeVehicle == true then
				GameObject.SendCommand( enemyId, { id = "UnsetRelativeVehicle" } )
			end
			
			if isSucces == true then
				routeNum = routeNum + 1
			end
			
			setRouteCount = setRouteCount + 1
		end
		return routeNum, setEnemyIdTable, setRouteCount
	end
	
	
	local function _OnCommonFunc_SetRouteId( commonFunc, routeId, routeNum, setEnemyIdTable, setRouteCount )
		
		local gameObjectIdTable = s10090_enemy.GetGameObjectIdUsingRoute( routeId )
		for i, enemyId in ipairs( gameObjectIdTable ) do
			if s10090_enemy.GetStatus( enemyId ) == true and _OnCommonFunc_CheckSetEnemyId( setEnemyIdTable, enemyId ) == true then
				
				routeNum, setEnemyIdTable, setRouteCount = _OnCommonFunc_SetRouteEnemyId( commonFunc, enemyId, routeNum, setEnemyIdTable, setRouteCount )
			end
		end
		return routeNum, setEnemyIdTable, setRouteCount
	end
	
	local commonFuncTableList = this.commonFuncTable[ params.messageId ]
	
	if commonFuncTableList == nil then
		return
	end
	
	local convoyIdTable = {}
	local setEnemyIdTable = {}
	local setRouteCount = 0
	
	
	if commonFuncTableList.eventSequenceIndex then
		if svars.eventSequenceIndex ~= commonFuncTableList.eventSequenceIndex then
			return
		end
	end
	
	
	if commonFuncTableList.eventSubSequenceIndex then
		if svars.reserveCount_01 ~= commonFuncTableList.eventSubSequenceIndex then
			return
		end
	end
	
	if commonFuncTableList.param and commonFuncTableList.isSetSuccess == false then
		local commonFuncTable
		
		this.commonFuncTable[ params.messageId ].isSetSuccess = true
		
		if #commonFuncTableList.param == 1 then
			commonFuncTable = commonFuncTableList.param[1]
		else
			if mvars.isNoStopConvoy == true then
				commonFuncTable = commonFuncTableList.param[2]
			else
				commonFuncTable = commonFuncTableList.param[1]
			end
		end
		
		for i, commonFunc in ipairs( commonFuncTable ) do
			local isPrepareVehicleConvoy = false
			
			if commonFunc.enemyId then
				
				if commonFunc.routeId_d then
					TppEnemy.SetSneakRoute(		commonFunc.enemyId, commonFunc.routeId_d )
				end
				if commonFunc.routeId_c then
					TppEnemy.SetCautionRoute(	commonFunc.enemyId, commonFunc.routeId_c )
				end
				if commonFunc.routeId_a then
					TppEnemy.SetAlertRoute(		commonFunc.enemyId, commonFunc.routeId_a )
				end
				
				if commonFunc.isMessageChangePhase then
					if commonFunc.messageEventSequenceIndex then
						if svars.eventSequenceIndex >= commonFunc.messageEventSequenceIndex then
							s10090_enemy.SetEnemyMessage( commonFunc.enemyId, "ChangePhase", commonFunc.isMessageChangePhase )
						end
					else
						s10090_enemy.SetEnemyMessage( commonFunc.enemyId, "ChangePhase", commonFunc.isMessageChangePhase )
					end
				end
				
				_OnCommonFunc_SetRelativeVehicle( commonFunc, commonFunc.enemyId )
			
			elseif commonFunc.beforeRouteIdTable then
				local routeNum = 0
				if params.dbgEnemyIdTable then
					if IsTypeTable( params.dbgEnemyIdTable ) then
						for i, enemyId in ipairs( params.dbgEnemyIdTable ) do
							routeNum, setEnemyIdTable, setRouteCount = _OnCommonFunc_SetRouteEnemyId( commonFunc, enemyId, routeNum, setEnemyIdTable, setRouteCount )
						end
					else
						Fox.Error("Parameters support table only")
					end
				else
					if IsTypeTable( commonFunc.beforeRouteIdTable ) then
						for i, routeId in ipairs( commonFunc.beforeRouteIdTable ) do
							routeNum, setEnemyIdTable, setRouteCount = _OnCommonFunc_SetRouteId( commonFunc, routeId, routeNum, setEnemyIdTable, setRouteCount )
						end
					else
						Fox.Error("Parameters support table only")
					end
				end
			
			elseif commonFunc.travelSetRouteIdTable and commonFunc.travelPlanName then
				local travelSetRouteCount = 0
				local isTravelSuccess = false
				for i, beforeRouteId in ipairs( commonFunc.travelSetRouteIdTable ) do
					if isTravelSuccess == false then
						
						local gameObjectIdTable = s10090_enemy.GetGameObjectIdUsingRoute( beforeRouteId )
						for j, enemyId in ipairs( gameObjectIdTable ) do
							
							if s10090_enemy.GetStatus( enemyId ) == true and _OnCommonFunc_CheckSetEnemyId( setEnemyIdTable, enemyId ) == true then
								
								table.insert( setEnemyIdTable, enemyId )
								
								local iskeepInAlert = commonFunc.isTravelkeepInAlert or false
								GameObject.SendCommand( enemyId, { id = "StartTravel", travelPlan = commonFunc.travelPlanName, keepInAlert = iskeepInAlert } )
								
								if _OnCommonFunc_SetRelativeVehicle( commonFunc, enemyId ) == true then
									
									isPrepareVehicleConvoy = true
								end
								
								if commonFunc.isMessageChangePhase then
									s10090_enemy.SetEnemyMessage( enemyId, "ChangePhase", commonFunc.isMessageChangePhase )
								end
								
								if commonFunc.travelSetCount then
									travelSetRouteCount = travelSetRouteCount + 1
									if travelSetRouteCount >= commonFunc.travelSetCount then
										isTravelSuccess = true
										break
									end
								end
							end
						end
					end
				end
			end
			
			if commonFunc.speechLabel then
				local isMonologue	= commonFunc.isMonologue or false
				local isCallRadio	= commonFunc.isCallRadio or false
				if isCallRadio == false then
					s10090_enemy.RouteCallConversation( commonFunc.speakerRouteNameTable, commonFunc.friendRouteNameTable, commonFunc.speechLabel, isMonologue )
				else
					s10090_enemy.RouteCallRadio( commonFunc.speakerRouteNameTable, commonFunc.speechLabel, commonFunc.stane )
				end
			end
			
			if commonFunc.func then
				commonFunc.func()
			end
			
			if ( commonFunc.timerName and commonFunc.time ) or commonFunc.timerList then
				if commonFunc.timerList then
					this.SetTimer{ timerList = commonFunc.timerList }
				else
					local stop = commonFunc.time or false
					this.SetTimer{ timerName = commonFunc.timerName, time = commonFunc.time, stop = stop }
				end
			end
			
			if commonFunc.rideVehicleName and commonFunc.isPrepareVehicleConvoy == true then
				if not this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, commonFunc.rideVehicleName ) then
					local gameObjectId = GetGameObjectId( commonFunc.rideVehicleName )
					local isConvoySuccess = false
					if isPrepareVehicleConvoy == true then
						if gameObjectId == NULL_ID then
							Fox.Error( "Cannot get gameObjectId. rideVehicleName = " .. commonFunc.rideVehicleName )
						else
							isConvoySuccess = true
						end
					else
						
						local riderCount = s10090_enemy.GetVehicleRiderCount( gameObjectId )
						if riderCount > 0 then
							isConvoySuccess = true
						end
					end
					if isConvoySuccess == true then
						
						table.insert( convoyIdTable, gameObjectId )
					end
				end
			end
			
			if commonFunc.registerConvoy == true then
				if #convoyIdTable > 1 then
					GameObject.SendCommand( { type="TppVehicle2", }, { id = "RegisterConvoy", convoyId = convoyIdTable } )
					svars.vehicleConvoyIndex = convoyIdTable[1]
				end
			end
			
			if commonFunc.unRegisterConvoy == true then
				if svars.vehicleConvoyIndex ~= 0 then
					GameObject.SendCommand( { type="TppVehicle2", }, { id = "UnregisterConvoy", convoyId = svars.vehicleConvoyIndex } )
					svars.vehicleConvoyIndex = 0
				end
			end
		end
	end
	
	
	
	
	s10090_enemy.SetHighInterrogationCp()
	
	s10090_radio.SetOptionalRadioUpdate()
	
end


this.OnIntelDemo = function( intelNameHash )
	local demoEndfunction = function() 
		
		svars.isOnGetIntel = true
		
		
		if this.IsMainSequence() == true then
			local isFound01 = this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, s10090_enemy.VEHICLE_NAME.WEST_WAV01 )
			local isFound02 = this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.PRESENCE, s10090_enemy.VEHICLE_NAME.WEST_WAV02 )
			if isFound01 == true and isFound02 == true then
				
				s10090_radio.TrapAfterGetIntel()
				








			else
				
				s10090_radio.OnIntel()
				
				TppMission.UpdateObjective{
					objectives = {
						
						"on_subTask_intel",
						
						"showEnemyRoute_01",
						"showEnemyRoute_02",
						"showEnemyRoute_03",
						"showEnemyRoute_04",
						
					
					},
				}
			end
		
		else
			s10090_radio.TrapAfterGetIntel()
		end
		
		this.SetDemoLoad()
		
		this.SetTimerSetting( false )
		
		this.SetCheckPoint()
	end
	
	for i, params in pairs( this.trapSettingTable ) do
		if svars.intelAreaTrapIndex == params.areaIndex then
			TppPlayer.GotIntel( intelNameHash )
			
			TppScriptBlock.LoadDemoBlock( "Demo_GetIntel" )
			
			params.func( demoEndfunction )
			break
		end
	end
end


this.SetEnableIntelDemo = function( enabled )
	if enabled == false then
		if svars.isOnGetIntel == false then
			mvars.isParasitesIntel = true
			svars.isOnGetIntel = true
		end
	elseif enabled == true then
		if mvars.isParasitesIntel == true then
			svars.isOnGetIntel		= false
			mvars.isParasitesIntel	= false
		end
	end
end


this.OnChangePhase = function( gameObjectId, phaseName )
	
	if this.IsMainSequence() == true and this.IsAppearanceParasites() == false then
		if s10090_enemy.IsZRS( gameObjectId ) == true then
			
			if phaseName == TppGameObject.PHASE_ALERT then
				if mvars.isNoStopConvoy == false then
					mvars.isNoStopConvoy = true
					
					this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_ALL, isPhase = true }
					
					local isFound = this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )
					s10090_radio.AlertZRS( isFound )
				end
			end
		end
	end
end


this.OnChangeToEnable = function( instanceName, makerType, s_gameObjectId, identificationCode )
	
	if identificationCode == Fox.StrCode32("Player") then
		if Tpp.IsSoldier( s_gameObjectId ) then
			if this.IsAppearanceParasites() == false then
				
				if svars.isChangeToEnableZRS == false then
					local isSucces, gameObjectId	= s10090_enemy.IsZRS( s_gameObjectId )
					local isDriver					= s10090_enemy.IsDirver( s_gameObjectId )
					if isSucces == true and isDriver == false then
						s10090_radio.MarkingZRS()
						svars.isChangeToEnableZRS = true
					end
				end
			end
		elseif Tpp.IsVehicle( s_gameObjectId ) then
			
			if		s_gameObjectId == GameObject.GetGameObjectId( s10090_enemy.VEHICLE_NAME.WEST_WAV01 )	then
				svars.reserveCount_02 = 1
				if svars.eventSequenceIndex < s10090_sequence.ENUM_EVENT_VEHICLE_SEQUENCE.ENTER_PFCAMP	and svars.isAppearanceParasites ==	false	then
					TppMission.UpdateObjective{ objectives = { "on_escort_vehicle_01" }, }
				else
					TppMission.UpdateObjective{ objectives = { "on_escort_vehicle_01_b" }, }
				end
			elseif	s_gameObjectId == GameObject.GetGameObjectId( s10090_enemy.VEHICLE_NAME.WEST_WAV02 )	then
				svars.reserveCount_02 = 1
				if svars.eventSequenceIndex < s10090_sequence.ENUM_EVENT_VEHICLE_SEQUENCE.ENTER_PFCAMP	and svars.isAppearanceParasites ==	false	then
					TppMission.UpdateObjective{ objectives = { "on_escort_vehicle_02" }, }
				else
					TppMission.UpdateObjective{ objectives = { "on_escort_vehicle_02_b" }, }
				end
			
			elseif	s_gameObjectId == GameObject.GetGameObjectId( s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )	then
				TppMission.UpdateObjective{ objectives = { "on_target_vehicle" }, }
			else
				Fox.Log("No WEST_WAV01 or WEST_WAV02 ... Nothing Done !!")
			end
			this.OnVehicleAction{ gameObjectId = s_gameObjectId, actionType = "ChangeToEnable" }
		end
	end
end


this.OnEscortVehicleStart = function()
	if svars.isEscortVehicleStart == false then
		svars.isEscortVehicleStart = true
		this.SetTimer{ timerList = this.TIMER_LIST.ESCORT_WAV_START }
		this.SetTimer{ timerList = this.TIMER_LIST.ESCORT_START_STOP }
	end
end


this.OnArrivalAtAreaTrap = function()
	for i, param in pairs( this.trapSettingTable ) do
		if svars.areaTrapIndex == param.areaIndex then
			
			if this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == false and svars.isOnGetIntel == true then
				
				if svars.eventSequenceIndex >= param.eventSequenceIndex then
					s10090_radio.ArrivalAreaNoVehicleMarkerFound()
				end
				
				this.SetTimer{ timerList = this.TIMER_LIST.RADIO_START_ARRIVALATAREA }
			end
			break
		end
	end
end


this.OnArrivalAtTargetswamp = function()
	local isFound = this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )
	local radioGroups = s10090_radio.ArrivalAtTargetswamp( isFound )
	if radioGroups ~= nil then
		
		TppMission.UpdateObjective{
			radio = {
				radioGroups = radioGroups,
			},
			
			objectives = {"on_target_vehicle","on_subGoal_missiontarget"},
		}
		svars.isMarkingVehicle01 = true
	end
end


this.OnArrivalAtTargetswampWest = function()
	local isFound = this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )
	
	if isFound == true then
		s10090_radio.ArrivalAtTargetswampWest()
	end
end


this.OnConversationEnd = function( GameObjectId, speechLabel, isSuccess )
	local conversationSetting = this.conversationSettingTable[speechLabel]
	if conversationSetting == nil then
		return
	end
	local messageId = nil
	if isSuccess > 0 then
		local isFinish = conversationSetting.isFinish or false
		if isFinish == false then
			if conversationSetting.succesMessage then
				this.OnCommonFunc{ messageId = conversationSetting.succesMessage }
			end
		else
			if conversationSetting.areaIndex then
				
				this.CheckMotorcadeStart{ areaIndex = conversationSetting.areaIndex, isEventEnd = true, isConversationSucces = true }
			else
				if conversationSetting.succesMessage then
					this.OnCommonFunc{ messageId = conversationSetting.succesMessage }
				end
			end
		end
	else
		if conversationSetting.areaIndex then
			
			this.CheckMotorcadeStart{ areaIndex = conversationSetting.areaIndex, isEventEnd = true }
		else
			if conversationSetting.failureMessage then
				this.OnCommonFunc{ messageId = conversationSetting.failureMessage }
			end
		end
	end
end






function this.CheckMotorcadeStart( params )
	
	local function _CheckEnemyGetLifeStatus( motorcadeData )
		local blRetcode = false
		
		if svars.firstTargetDriverGameObjectId == 0 then
			svars.firstTargetDriverGameObjectId = GetGameObjectId( s10090_enemy.ENEMY_NAME.ZRS_PFCAMP01 )
		end
		
		local lifeStatus = s10090_enemy.GetLifeStatus( svars.firstTargetDriverGameObjectId ) 
		if svars.isDyingAllParasites == false then
			if lifeStatus == TppGameObject.NPC_LIFE_STATE_NORMAL then
				blRetcode = true
			end
		else
			if lifeStatus == TppGameObject.NPC_LIFE_STATE_FAINT then
				svars[motorcadeData.timeEndSvarsName] = svars[motorcadeData.timeEndSvarsName] - 1
			end
			if lifeStatus == TppGameObject.NPC_LIFE_STATE_NORMAL or lifeStatus == TppGameObject.NPC_LIFE_STATE_FAINT then
				blRetcode = true
			end
		end
		return blRetcode
	end
	
	
	local function _CheckAreaIndex( eventSequenceIndexTable )
		local blRetcode = false
		for i, eventSequenceIndex in ipairs( eventSequenceIndexTable ) do
			if svars.eventSequenceIndex == eventSequenceIndex then
				blRetcode = true
			end
		end
		return blRetcode
	end
	
	
	local function _IsStartPossibleTimerList( timerList )
		local blRetcode = false
		if not GkEventTimerManager.IsTimerActive( timerList.timerName ) then
			blRetcode = true
		end
		return blRetcode
	end
	
	if params.areaIndex == nil then
		return
	end
	
	local motorcadeData = nil
	local messageId = nil
	
	if params.isPhase == true then
		
		for i, motorcadeSetting in pairs( this.motorcadeSettingTable ) do
			if motorcadeSetting.isPhase == true then
				if _CheckAreaIndex( motorcadeSetting.alertSequenceIndexTable ) == true then
					
					messageId = motorcadeSetting.motorcadeMessageId
				end
			end
		end
	else
		
		for i, param in pairs( this.motorcadeSettingTable ) do
			if params.areaIndex == param.areaIndex then
				motorcadeData = param
				break
			end
		end
		if motorcadeData == nil then
			return
		end
		
		if params.isSvarsUpdate == true then
			svars.motorcadeAreaTrapIndex = motorcadeData.areaIndex
			if _CheckAreaIndex( motorcadeData.eventStartSequenceIndexTable ) == true then
				if _IsStartPossibleTimerList( motorcadeData.startPossibleTimerList ) then
					
					messageId = motorcadeData.eventMessageId
				end
			end
			mvars[motorcadeData.isAreaMvarsName] = true
		
		elseif params.isSvarsUpdate == false then
			svars.motorcadeAreaTrapIndex = 0
			mvars[motorcadeData.isAreaMvarsName] = false
		
		elseif params.isCheckEventStart == true then
			if svars.motorcadeAreaTrapIndex == motorcadeData.areaIndex then
				if _CheckAreaIndex( motorcadeData.eventStartSequenceIndexTable ) == true then
					if _IsStartPossibleTimerList( motorcadeData.startPossibleTimerList ) then
						
						messageId = motorcadeData.eventMessageId
					end
				end
			end
		
		elseif params.isEventEnd == true then
			
			messageId = motorcadeData.motorcadeMessageId
		
		elseif params.isTimeEnd == true then
			
			if _CheckAreaIndex( motorcadeData.eventStartSequenceIndexTable ) == true then
				
				messageId = motorcadeData.motorcadeMessageId
			
			elseif _CheckAreaIndex( motorcadeData.eventSequenceIndexTable ) == true then
				
				svars[motorcadeData.timeEndSvarsName] = svars[motorcadeData.timeEndSvarsName] + 1
				local timeEndCount = svars[motorcadeData.timeEndSvarsName]
				local isSucces = _CheckEnemyGetLifeStatus( motorcadeData )
				if isSucces == true and timeEndCount <= motorcadeData.timeEndMax then
					
					this.SetTimer{ timerList = motorcadeData.motorcadeComebackTimerList }
				else
					
					messageId = motorcadeData.motorcadeMessageId
				end
			end
		
		elseif params.isCheckFulton == true or params.isCheckBroken == true then
			
			this.SetTimerEscortDead()
		end
		
		
		if mvars.isNoStopConvoy == true then
			if _CheckAreaIndex( motorcadeData.alertSequenceIndexTable ) == true then
				
				messageId = motorcadeData.motorcadeMessageId
			end
		end
	end
	
	
	if messageId ~= nil then
		 this.OnCommonFunc{ messageId = messageId }
	end

end


function this.GetVehicleValue( valueType, vehicleName )
	for i, params in pairs( this.vehicleSettingTable ) do
		if vehicleName == params.vehicleGameObjectName then
			if valueType == this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG then
				return svars[params.isMarkingSvarsName]
			elseif valueType == this.ENUM_VEHICLE_VALUE_TYPE.BROKENFLAG then
				return svars[params.isBrokenSvarsName]
			elseif valueType == this.ENUM_VEHICLE_VALUE_TYPE.FULTONFLAG then
				return svars[params.isFultonSvarsName]
			elseif valueType == this.ENUM_VEHICLE_VALUE_TYPE.PRESENCE then
				if svars[params.isBrokenSvarsName] == true or svars[params.isFultonSvarsName] == true then
					return true
				end
			end
		end
	end
	return false
end


this.OnVehicleAction = function( params )
	local gameObjectName = s10090_enemy.GetVehicleGameObjectName( params.gameObjectId )
	local vehicleSetting =  this.vehicleSettingTable[ StrCode32( gameObjectName ) ]
	local actionType = params.actionType
	if vehicleSetting then
		if actionType == "OnVehicleRide_Start" or actionType == "ChangeToEnable" then
			this.OnVehicleMarker( vehicleSetting, actionType )
		elseif actionType == "Broken" then
			this.OnVehicleBroken( vehicleSetting, params.attackerGameObjectId )
		elseif actionType == "Fulton" then
			this.OnVehicleFulton( vehicleSetting )
		elseif actionType == "FultonFailedEnd" then
			this.OnVehicleFultonFailed( vehicleSetting )
		end
	end
end


this.OnVehicleMarker = function( vehicleSetting, actionType )
	local isSucces				= false
	local radioFunction
	local isPunkTargetVehicle	= s10090_enemy.IsVehicleStateSpeedDown( s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )
	local isAppearanceParasites = s10090_sequence.IsAppearanceParasites()
	
	if svars[vehicleSetting.isMarkingSvarsName] == false then
		if actionType == "OnVehicleRide_Start" and vehicleSetting.funcBeforeVehicleRide then
			isSucces = true
			radioFunction = vehicleSetting.funcBeforeVehicleRide
		elseif actionType == "ChangeToEnable" and vehicleSetting.funcMarkerEnable then
			isSucces = true
			radioFunction = vehicleSetting.funcMarkerEnable
		end
		if isSucces == true then
			svars[vehicleSetting.isMarkingSvarsName] = true
			
			TppMission.UpdateObjective{
				
				objectives = vehicleSetting.objectives,
			}
			
			if vehicleSetting.isEscort == false then
				TppMission.UpdateObjective{
					objectives = {
						
						"on_subGoal_missiontarget",
						
						"on_mainTask_search_target",
					},
				}
				
				TppSoundDaemon.PostEvent( "sfx_s_enemytag_main_tgt" )
			
			else
				if TppMission.IsEnableAnyParentMissionObjective( "on_mainTask_search_escort" ) == false then
					TppMission.UpdateObjective{
						objectives = {
							
							"on_mainTask_search_escort"
						},
					}
				end
			end
			
			radioFunction( actionType, isAppearanceParasites, isPunkTargetVehicle )
		end
	
	else
		if actionType == "OnVehicleRide_Start" and vehicleSetting.funcAfterVehicleRide then
			
			vehicleSetting.funcAfterVehicleRide( actionType, isAppearanceParasites, isPunkTargetVehicle )
		end
	end
end


function this.OnVehicleBroken( vehicleSetting, attackerGameObjectId )
	if vehicleSetting == nil then
		return
	end
	local gameObjectName = vehicleSetting.vehicleGameObjectName
	
	if gameObjectName == s10090_enemy.VEHICLE_NAME.TRUCK_TARGET then
		local radioName
		if Tpp.IsPlayer( attackerGameObjectId ) then
			if this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == false then
				radioName = TppDefine.GAME_OVER_RADIO.S10090_TARGET_DEAD_MARKING_OFF
			else
				radioName = TppDefine.GAME_OVER_RADIO.S10090_TARGET_DEAD_MARKING_ON
			end
		else
			radioName = TppDefine.GAME_OVER_RADIO.S10090_TARGET_DEAD
		end
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.S10090_TARGET_DEAD, radioName )
	
	elseif gameObjectName == s10090_enemy.VEHICLE_NAME.WEST_WAV01 or gameObjectName == s10090_enemy.VEHICLE_NAME.WEST_WAV02 then
		this.guardVehicle_check()
		if svars[vehicleSetting.isBrokenSvarsName] == false then
			svars[vehicleSetting.isBrokenSvarsName] = true
		end
		
		this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_PFCAMP, isCheckBroken = true }
	end
end


function this.OnVehicleFulton( vehicleSetting )
	if vehicleSetting == nil then
		return
	end
	local gameObjectName = vehicleSetting.vehicleGameObjectName
	
	if gameObjectName == s10090_enemy.VEHICLE_NAME.TRUCK_TARGET then
		if svars[vehicleSetting.isFultonSvarsName] == false then
			svars[vehicleSetting.isFultonSvarsName] = true
		end
		if this.IsMainSequence() == true then
			TppSequence.SetNextSequence("Seq_Game_Escape", { isExecDemoPlaying = true, })
		end
	
	elseif gameObjectName == s10090_enemy.VEHICLE_NAME.WEST_WAV01 or gameObjectName == s10090_enemy.VEHICLE_NAME.WEST_WAV02 then
		this.guardVehicle_check()
		
		if svars[vehicleSetting.isFultonSvarsName] == false then
			svars[vehicleSetting.isFultonSvarsName] = true
		end
		
		this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_PFCAMP, isCheckFulton = true }
	end
end


function this.OnVehicleFultonFailed( vehicleSetting )
	if vehicleSetting == nil then
		return
	end
	local gameObjectName = vehicleSetting.vehicleGameObjectName
	
	if gameObjectName == s10090_enemy.VEHICLE_NAME.TRUCK_TARGET then
		local radioNum
		if this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == false then
			radioNum = TppDefine.GAME_OVER_RADIO.S10090_TARGET_FULTON_FAILED_MARKING_OFF
		else
			radioNum = TppDefine.GAME_OVER_RADIO.S10090_TARGET_FULTON_FAILED_MARKING_ON
		end
		TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.S10090_TARGET_FULTON_FAILED, radioNum )
	
	elseif gameObjectName == s10090_enemy.VEHICLE_NAME.WEST_WAV01 or gameObjectName == s10090_enemy.VEHICLE_NAME.WEST_WAV02 then
		this.guardVehicle_check()
		
		if svars[vehicleSetting.isFultonSvarsName] == false then
			svars[vehicleSetting.isFultonSvarsName] = true
		end
		
		this.CheckMotorcadeStart{ areaIndex = this.ENUM_AREA.EVENT_PFCAMP, isCheckFulton = true }
	end
end


this.OnEnemyVehicleAction = function( params )
	local vehicleTable = {
		s10090_enemy.VEHICLE_NAME.WEST_WAV01,
		s10090_enemy.VEHICLE_NAME.WEST_WAV02,
	}
	local isStop = nil
	local vehicleGameObjectName = s10090_enemy.GetVehicleGameObjectName( params.vehicleGameObjectId )
	local vehicleSetting =  this.vehicleSettingTable[ StrCode32( vehicleGameObjectName ) ]
	if vehicleSetting then
		
		if vehicleSetting.isTarget == true then
			
			if params.actionType == TppGameObject.VEHICLE_ACTION_TYPE_GOT_IN_VEHICLE then
				isStop = false
				if params.gameObjectId then
					
					svars.firstTargetDriverGameObjectId = params.gameObjectId
				end
			
			elseif params.actionType == TppGameObject.VEHICLE_ACTION_TYPE_GOT_OUT_VEHICLE or params.actionType == TppGameObject.VEHICLE_ACTION_TYPE_FELL_OFF_VEHICLE then
				isStop = true
			
			elseif params.actionType == "VehicleDamage" then
				if this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == true then
					s10090_radio.VehicleDamage()
				end
			
			elseif params.actionType == "VehicleHalfBroken" then
				if this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == true then
					s10090_radio.VehicleHalfBroken()
				end
			
			elseif params.actionType == "CanNotMove" then
				if this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET ) == true then
					s10090_radio.VehicleCanNotMove()
				end
			end
			
			if isStop == false then
				if this.IsSequenceEnemyVehicleAction( this.ENUM_VEHICLE_CHECK_ACTION.DRIVE ) == true  or svars.isDyingAllParasites == true then
					s10090_enemy.SetFixedPointCombatVehicle( vehicleTable, isStop )
				end
			
			else
				if this.IsSequenceEnemyVehicleAction( this.ENUM_VEHICLE_CHECK_ACTION.DRIVE ) == true then
					s10090_enemy.SetFixedPointCombatVehicle( vehicleTable, isStop )
				end
			end
		end
	end
end

function this.guardVehicle_check()
	svars.reserveCount_03 = svars.reserveCount_03 + 1
	if svars.reserveCount_03 >= 2	then
		TppMission.UpdateObjective{
			objectives = { "on_photo_missionComplete_02",},
		}
	end
end





function this.IsPlayerInRange( position, range )
	local blRetcode = nil
	if position ~= nil then
		local playerPosition = Vector3( vars.playerPosX, vars.playerPosY, vars.playerPosZ )
		local lengthSqr = ( position - playerPosition ):GetLengthSqr()
		blRetcode = lengthSqr <= range * range
	else
		Fox.Error(" this.IsPlayerInRange : No Position")
	end
	return blRetcode
end


function this.GetPlayerRange()
	
	local function _GetPlayerRange( rangeType )
		return mvars.inRange, mvars.outRange
	end
	
	if svars.eventSequenceIndex == mvars.rangeEventSequenceIndex then
		return _GetPlayerRange( rangeType )
	else
		for i, playerInRangeTable in ipairs( this.checkSettingTable ) do
			if svars.eventSequenceIndex == playerInRangeTable.eventSequenceIndex then
				mvars.rangeEventSequenceIndex = svars.eventSequenceIndex
				if playerInRangeTable.inRange ~= nil then
					mvars.inRange = playerInRangeTable.inRange
				else
					Fox.Error(" this.GetPlayerRange : No playerInRangeTable.inRange")
				end
				if playerInRangeTable.outRange ~= nil then
					mvars.outRange = playerInRangeTable.outRange
				else
					Fox.Error(" this.GetPlayerRange : No playerInRangeTable.outRange")
				end
			end
		end
		return _GetPlayerRange( rangeType )
	end
end






function this.SetTimer( params )
	local timerName
	local time
	local stop
	if params.timerList then
		timerName	= params.timerList.timerName or nil
		time		= params.timerList.time or nil
		stop		= params.timerList.stop or false
	else
		timerName	= params.timerName or nil
		time		= params.time or nil
		stop		= params.stop or false
	end
	if stop == true then
		GkEventTimerManager.Stop( timerName )
	end
	if timerName == nil or time == nil then
		return
	end
	if not GkEventTimerManager.IsTimerActive( timerName ) then
		GkEventTimerManager.Start( timerName, time )
	end
end





sequences.Seq_Game_MainGame = {
	
	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
			TppCoder.SetWorldCenter(Vector3(393.69098, -5.8911133, 248.1272))
		end

		if svars.isMissionStart == false then
			TppMission.UpdateObjective{
				objectives = {
					
					"default_photo_targetVehicle",
					"default_photo_escortVehicle",
					
					"default_subGoal_missionStart",
					
					"default_mainTask_search_target",
					"default_mainTask_search_escort",
					"default_mainTask_recovered_target",
					
					"default_subTask_skulls",
					"default_subTask_intel",
					"default_subTask_conversation_ghost",
					"default_subTask_recovered_zrs",
				},
			}
			
			local isFound = this.IsFultonCargo()
			local radioGroups = s10090_radio.GetMissionStart( isFound )
			TppMission.UpdateObjective{
				radio = {
					radioGroups = radioGroups,
				},
				objectives = {
					
					"default_area_pfCampNorth",
				},
			}
			svars.isMissionStart = true
		else
			s10090_radio.ContinueMissionStart()
			TppMission.UpdateObjective{
				objectives = {"default_area_pfCampNorth",},
			}
		end
		
		this.SetTimerSetting( false )
		
		this.SetDemoLoad()
		
		s10090_sound.SetUp()
		
		TppTelop.StartCastTelop()
		
		this.check_parasiteFulton()
		
		this.acpDriver_OnOffCheck()
		
		this.TargetSetting()
		
		this.EnableCommonOptionalRadio_OnOff()
	end,
	
}

sequences.Seq_Game_Escape = {

	Messages = function( self )
		return
		StrCode32Table {
			Demo = {
				{
					msg = "Finish",
					sender = "p41_050010",
					func = function()
						Fox.Log( "sequences.Seq_Game_Escape.Messages(): Demo: Finish: p41_050010" )
						this.SetDemoLoad()
					end,
					option = { isExecDemoPlaying = true },
				},
			},
		}
	end,

	OnEnter = function()
		
		if svars.isMissionComplete == false then
			local isFound = this.GetVehicleValue( this.ENUM_VEHICLE_VALUE_TYPE.MARKINGFLAG, s10090_enemy.VEHICLE_NAME.TRUCK_TARGET )
			local radioGroups = s10090_radio.GetMissionComplete( isFound )
			TppMission.UpdateObjective{
				objectives = {
					
					"on_subGoal_missionComplete",
					
					"on_photo_missionComplete_01",
					"on_photo_missionComplete_02",
					
					"on_mainTask_recovered_target",
					
					"announce_log_recoverTarget",
					"announce_log_achieveAllObjectives",
				},
			}
			TppMission.UpdateObjective{
				radio = {
					radioGroups		= radioGroups,
					radioOptions	= { delayTime = "long" },
				},
				objectives = {
					
					"on_missionComplete",
				},
			}
			svars.isMissionComplete = true
		else
			s10090_radio.ContinueMissionClear()
		end
		
		TppMission.CanMissionClear()
		
		if not mvars.playingParasiteAppearanceDemo then
			this.SetDemoLoad()
		end
		
		s10090_sound.SetUp()
		
		this.check_parasiteFulton()
		
		this.acpDriver_OnOffCheck()
		
		this.TargetSetting()
		
		s10090_radio.SetOptionalRadioUpdate( "Set_s0090_oprg0060" , true )
		
		this.EnableCommonOptionalRadio_OnOff()
	end,
}




return this