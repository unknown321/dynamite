local this = {}

local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local GetGameObjectId = GameObject.GetGameObjectId

local MISSION_START_HELI_DOOR_OPEN_TIME  = 12	

local sequences = {}
local meetingNode =	0	




local VIP_MEETING_FIRST_MAX 	= 2		
local VIP_MEETING_FULLTON_MAX 	= 6		
local VIP_MEETING_KILL_MAX 		= 3		
local VIP_MEETING_LAST_MAX 		= 4		

local TASK_GUARD_MAX = 4	
local TASK_VIP_MAX = 3		



local BONUS_HOSTAGE_MAX =2 


local VIP_MEETING_WAIT_TIME = 60*10												
local VIP_MEETING_WAIT_TIME_HELI = 60*11										

this.meetingPart	=	Tpp.Enum{	
	"FIRST",		
	"FULLTON",		
	"KILL",			
	"LAST",			
	"AFTER_MEETING",
}

this.FieldVipSequence	=	Tpp.Enum{	
	"DepartureCp",			
	"Lrrp29ToFieldEast",		
	"FieldEastToLrrp01",		
	"Lrrp01ToVillageEast",		
	"VillageEastToLrrp32",		
	"Lrrp32ToVillage",			
	"VillageToTravelEnd",		
	"ArrivedVillage",			
	"WaitMeeting",				
	"StartMeeting",				
	"EndMeeting",				
	"StartReturnTravel",		
	"EndReturnTravel",			
	"SetMine",					
}

this.EnemyBaseVipSequence	=	Tpp.Enum{	
	"DepartureCp",				
	"Lrrp36ToVillageWest",		
	"VillageWestToLrrp32",		
	"Lrrp32ToVillage",			
	"VillageToTravelEnd",		
	"ArrivedVillage",			
	"WaitMeeting",				
	"StartMeeting",				
	"EndMeeting",				
	"StartReturnTravel",		
	"EndReturnTravel",			
	"SetMine",					
}

this.EliminateType	=	Tpp.Enum{	
	"KILL",				
	"FULLTON",			
	"FULLTON_FAILED",	
	"HELI",	
}
this.vipKillType	=	Tpp.Enum{	
	"NOT_VIP",				

	"KILL_IDENTIFIED",				
	"FULLTON_IDENTIFIED",			
	"FULLTON_FAILED_IDENTIFIED",	
	"HELI_IDENTIFIED",				

	"KILL_NOT_IDENTIFIED",				
	"FULLTON_NOT_IDENTIFIED",			
	"FULLTON_FAILED_NOT_IDENTIFIED",	
	"HELI_NOT_IDENTIFIED",				
}

this.TASK_GUARD_GROUP = {
	"sol_driver_field",					
	"sol_guard_field_0000",				
	"sol_driver_enemyBase",				
	"sol_guard_enemyBase_0000",			
}

this.TASK_HOSTAGE_GROUP	= {
	"hos_subTarget_0000",
	"hos_subTarget_0001",
}


this.TASK_VIP_GROUP = {
	"sol_vip_field",						
	"sol_vip_village",					
	"sol_vip_enemyBase",					
}



local TARGET_FIELD_VIP_NAME 	= "sol_vip_field"
local TARGET_VILLAGE_VIP_NAME 	= "sol_vip_village"
local TARGET_ENEMYBASE_VIP_NAME 	= "sol_vip_enemyBase"


local TIME_CLER_RADIO_WAIT_WITH_VIP = 13


local PHOTO_NAME = {
	FIELD_VIP		= 20,			
	VILLAGE_VIP		= 30,			
	ENEMY_BASE_VIP	= 40,			
	MEETING_POINT	= 10,			
}


local ENEMYBASE_VIP_GROUP = {
	s10041_enemy.ENEMY_NAME.ENEMYBASE_DRIVER,
	s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP,
	s10041_enemy.ENEMY_NAME.ENEMYBASE_GUARD_00,
}


local FIELD_VIP_GROUP = {
	s10041_enemy.ENEMY_NAME.FIELD_DRIVER,
	s10041_enemy.ENEMY_NAME.FIELD_VIP,
	s10041_enemy.ENEMY_NAME.FIELD_GUARD_00,
}



local GROUP_FIELD_VIP_ARRIVAL_ROUTE 	= 0
local GROUP_FIELD_VIP_DEPARTURE_ROUTE 	= 1
local GROUP_ENEMY_BASE_VIP_ARRIVAL_ROUTE 	= 2
local GROUP_ENEMY_BASE_VIP_DEPARTURE_ROUTE 	= 3

if debug then	
this.DEBUG_strCode32List = {


	"afgh_fieldWest_ob",
	"afgh_villageNorth_ob",
	"afgh_commWest_ob",
	"afgh_slopedWest_ob",	
	"afgh_slopedTown_cp",		

	"afgh_village_cp",
	"afgh_enemyBase_cp",
	"afgh_field_cp",
	"afgh_villageWest_ob",
	"afgh_fieldEast_ob",
	"afgh_villageWest_ob",


	"afgh_02_14_lrrp",
	"afgh_02_35_lrrp",

	"afgh_14_32_lrrp",
	"afgh_14_35_lrrp",

	"afgh_15_35_lrrp",
	"afgh_15_36_lrrp",

	"afgh_20_29_lrrp",
	"afgh_20_21_lrrp",


	"afgh_04_32_lrrp",
	"afgh_04_36_lrrp",


	"afgh_01_16_lrrp",
	"afgh_01_32_lrrp",
	"afgh_16_29_lrrp",



}
end	




this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true


this.MAX_PICKABLE_LOCATOR_COUNT	= 60	
this.MAX_PLACED_LOCATOR_COUNT = 118		








function this.OnLoad()
	Fox.Log("#### OnLoad ####")
	Fox.Log("#### New script 03 ####")

	TppSequence.RegisterSequences{
		

		
		"Seq_GameVipAssembleVillage",
		"Seq_CONVERSATION",	
		"Seq_GameEscape",	
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end




this.REVENGE_MINE_LIST = {"afgh_village", "afgh_enemyBase","afgh_slopedTown","afgh_field"}






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

	
	["afgh_field"] = {
		   
		   
		["trap_afgh_field_mine_north"] = {
			mineLocatorList = {
				"itm_missionMine_field_0003",
				"itm_missionMine_field_0004",
				"itm_missionMine_field_0005",
				"itm_missionMine_field_0006",
				"itm_missionMine_field_0007",
				"itm_missionMine_field_0009",
			},
		},
		["trap_afgh_field_mine_west"] = {
			mineLocatorList = {
				"itm_missionMine_field_0000",
				"itm_missionMine_field_0001",
				"itm_missionMine_field_0002",
				"itm_missionMine_field_0008",
			},
		},
	},
	["afgh_enemyBase"] = {
		   
		   
		["trap_afgh_enemyBase_mine_east"] = {
			mineLocatorList = {
				"itm_missionMine_enemyBase_0000",
				"itm_missionMine_enemyBase_0001",
				"itm_missionMine_enemyBase_0006",
				"itm_missionMine_enemyBase_0010",
				"itm_missionMine_enemyBase_0011",
				"itm_missionMine_enemyBase_0015",
			},
		},
		["trap_afgh_enemyBase_mine_south"] = {
			mineLocatorList = {

				"itm_missionMine_enemyBase_0002",
				"itm_missionMine_enemyBase_0003",
				"itm_missionMine_enemyBase_0007",
				"itm_missionMine_enemyBase_0008",
				"itm_missionMine_enemyBase_0009",
				"itm_missionMine_enemyBase_0016",

			},
		},
		["trap_afgh_enemyBase_mine_west"] = {
			mineLocatorList = {
				"itm_missionMine_enemyBase_0004",
				"itm_missionMine_enemyBase_0005",
				"itm_missionMine_enemyBase_0012",
				"itm_missionMine_enemyBase_0013",
				"itm_missionMine_enemyBase_0014",

			},
		},

	},
}




this.saveVarsList = {
	isMeetingAborted				= false,	
	meetingCount			= 1,	
	meetingPart				= 1,	

	travelCountField		=1,		
	travelCountEnemyBase	=1,		

	isCancelMeetingVillageVip			= false,	
	isCancelMeetingFieldVip			= false,	
	isCancelMeetingEnemyBaseVip		= false,	

	isCancelMeeting				= false,	
	isEndMeeting				= false,	

	isWaiting_villageVip		= false,
	isWaiting_fieldVip			= false,
	isWaiting_enemyBaseVip		= false,


	isReturn_fieldVip			= false,	
	isReturn_enemyBaseVip		= false,	


	isSetMine_fieldVip			= false,	
	isSetMine_enemyBaseVip		= false,	

	isAboutHostage		= false,	
	HostageRescue	=0, 			
	VipIdentified	=0, 			



	
	isIdentifiedFieldVip			= false,
	isIdentifiedVillageVip			= false,
	isIdentifiedEnemyBaseVip		= false,

	
	isRadioHearMeeting			= false,	

	
	isSkipToConversation		= false,	

	
	isReserve_01 = false,	
	isReserve_02 = false,	
	isReserve_03 = false,	
	isReserve_04 = false,	
	isReserve_05 = false,	
	isReserve_06 = false,	
	isReserve_07 = false,	
	isReserve_08 = false,	
	isReserve_09 = false,	
	isReserve_10 = false,	
	isReserve_11 = false,	
	isReserve_12 = false,	
	isReserve_13 = false,	
	isReserve_14 = false,	
	isReserve_15 = false,
	isReserve_16 = false,
	isReserve_17 = false,
	isReserve_18 = false,
	isReserve_19 = false,

	
	isReserve_20 = false,

	
	countEliminatedTarget = 0,			

	ldReserve_01 = 0,	
	ldReserve_02 = 0,	
	ldReserve_03 = 0,
	ldReserve_04 = 0,
	ldReserve_05 = 0,
	ldReserve_06 = 0,
	ldReserve_07 = 0,
	ldReserve_08 = 0,
	ldReserve_09 = 0,
	ldReserve_10 = 0,
	ldReserve_11 = 0,
	ldReserve_12 = 0,
	ldReserve_13 = 0,
	ldReserve_14 = 0,
	ldReserve_15 = 0,
	ldReserve_16 = 0,
	ldReserve_17 = 0,
	ldReserve_18 = 0,
	ldReserve_19 = 0,
	ldReserve_20 = 0,
}

this.missionVarsList = {
	EscapeRadioGroups,				
}


this.baseList = {
		"village",
		"enemyBase",
		"field",
   
		"slopedTown",		
		"remnantsNorth",

		"villageNorth",
		"villageEast",
		"villageWest",
		"fieldEast",
		"fieldWest",
		"slopedWest",
		"commWest",			
		nil
}


function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")
	
	TppRevenge.RegisterMissionMineList(this.MISSION_REVENGE_MINE_LIST)
end




local InterrogationCpList = {
	"afgh_village_cp",
	"afgh_enemyBase_cp",
	 "afgh_field_cp",

   "afgh_slopedTown_cp",		
	"afgh_fieldEast_ob",

	"afgh_commWest_ob",
	"afgh_slopedWest_ob",	





}



local HostageObList = {
	"afgh_fieldWest_ob",
	"afgh_villageNorth_ob",
	"afgh_commWest_ob",
	"afgh_slopedWest_ob",	
	"afgh_slopedTown_cp",		

	
	"afgh_village_cp",
	"afgh_enemyBase_cp",
	"afgh_field_cp",
	"afgh_villageWest_ob",
	"afgh_fieldEast_ob",
	"afgh_villageWest_ob",
}

local lrrpAllList = {

	
	"afgh_02_14_lrrp",
	"afgh_02_35_lrrp",

	
	"afgh_14_32_lrrp",
	"afgh_14_35_lrrp",

	
	"afgh_15_35_lrrp",
	"afgh_15_36_lrrp",

	
	"afgh_20_29_lrrp",
	"afgh_20_21_lrrp",


	
	"afgh_04_32_lrrp",
	"afgh_04_36_lrrp",

	
	"afgh_01_16_lrrp",
	"afgh_01_32_lrrp",
	"afgh_16_29_lrrp",
}

local lrrpMeetingPoint = {	

	
	"afgh_15_35_lrrp",
	"afgh_15_36_lrrp",
}

local lrrpVehicle = {	
	
	"afgh_14_32_lrrp",
	"afgh_14_35_lrrp",

	
	"afgh_02_14_lrrp",
	"afgh_02_35_lrrp",
}

local lrrpHostage = {	

	
	"afgh_20_29_lrrp",
	"afgh_20_21_lrrp",


	
	"afgh_04_32_lrrp",
	"afgh_04_36_lrrp",

	
	"afgh_01_16_lrrp",
	"afgh_01_32_lrrp",
	"afgh_16_29_lrrp",
}



function this.HighInterrogation()
	Fox.Log( "#####################HighInterrogation" )
	local sequence = TppSequence.GetCurrentSequenceName()

	if ( sequence == "Seq_GameVipAssembleVillage" ) then

		
		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( "afgh_village_cp" ),
		{
			{ name = s10041_enemy.LABEL_MEETING_POINT,		func = s10041_enemy.InterCall_MeetingPoint, },		
		} )


		
		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( "afgh_field_cp" ),
		{
			{ name =s10041_enemy.LABEL_POSITION_FIELD_VIP,		func = s10041_enemy.InterCall_fieldVipAway, },		
		} )

		
		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( "afgh_enemyBase_cp" ),
		{
			{ name = s10041_enemy.LABEL_POSITION_ENEMY_BASE_VIP,	func = s10041_enemy.InterCall_EnemyBaseVipAway, },		
		} )

		
		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( "afgh_fieldEast_ob" ),
		{
			{ name =s10041_enemy.LABEL_POSITION_FIELD_VIP,		func = s10041_enemy.InterCall_fieldVipAway, },		
		} )


		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( "afgh_villageEast_ob" ),
		{
			{ name =s10041_enemy.LABEL_POSITION_FIELD_VIP,		func = s10041_enemy.InterCall_fieldVipAway, },		

		} )

		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( "afgh_villageWest_ob" ),
		{
			{ name = s10041_enemy.LABEL_POSITION_ENEMY_BASE_VIP,	func = s10041_enemy.InterCall_EnemyBaseVipAway, },		
		} )

		
	
			
			TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( "afgh_slopedTown_cp" ),
			{
				{ name =s10041_enemy.LABEL_SLOPED_TOWN_HOSTAGE,		func = s10041_enemy.InterCall_SlopedTownHostages, },		
				{ name = s10041_enemy.LABEL_REACTION_OTHER_OB,		func = s10041_enemy.InterCall_DontKnowMeeting, },		
			} )

			
			for i, cp in pairs( HostageObList ) do
				Fox.Log( cp )
				TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( cp ),
				{
					{ name = s10041_enemy.LABEL_ABOUT_HOSTAGE,		func = s10041_enemy.InterCall_AboutHostages, },		
					{ name = s10041_enemy.LABEL_REACTION_OTHER_OB,		func = s10041_enemy.InterCall_DontKnowMeeting, },		
				} )
			end
			
			
			

			for i, cp in pairs( lrrpMeetingPoint ) do
				Fox.Log( cp )
				TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( cp ),
				{
					{ name = s10041_enemy.LABEL_MEETING_POINT_LRRP,		func = s10041_enemy.InterCall_MeetingPoint_lrrp, },		
					{ name = s10041_enemy.LABEL_POSITION_VEHICLE,		func = s10041_enemy.InterCall_Vehicle, },		
					{ name = s10041_enemy.LABEL_ABOUT_HOSTAGE,		func = s10041_enemy.InterCall_AboutHostages, },			
				} )
			end

			
			for i, cp in pairs( lrrpVehicle ) do
				Fox.Log( cp )
				TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( cp ),
				{
					{ name = s10041_enemy.LABEL_POSITION_VEHICLE,		func = s10041_enemy.InterCall_Vehicle, },		
					{ name = s10041_enemy.LABEL_ABOUT_HOSTAGE,		func = s10041_enemy.InterCall_AboutHostages, },			
					{ name = s10041_enemy.LABEL_MEETING_POINT_LRRP,		func = s10041_enemy.InterCall_MeetingPoint_lrrp, },		

				} )
			end


			
			for i, cp in pairs( lrrpHostage ) do
				Fox.Log( cp )
				TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( cp ),
				{
					{ name = s10041_enemy.LABEL_ABOUT_HOSTAGE,		func = s10041_enemy.InterCall_AboutHostages, },			
					{ name = s10041_enemy.LABEL_POSITION_VEHICLE,		func = s10041_enemy.InterCall_Vehicle, },		
					{ name = s10041_enemy.LABEL_MEETING_POINT_LRRP,		func = s10041_enemy.InterCall_MeetingPoint_lrrp, },		

				} )
			end

	

	else
		
		for i, cp in pairs( InterrogationCpList ) do
			TppInterrogation.ResetFlagHigh( GameObject.GetGameObjectId( cp ) )
		end
	end

	Fox.Log("End HighInterrogation")
end



function this.DeleteHighInterrogationAboutHostage()
	
	for i, cp in pairs( HostageObList ) do
		Fox.Log( cp )
		TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( cp ),
			{
				{ name = s10041_enemy.LABEL_ABOUT_HOSTAGE,		func = s10041_enemy.InterCall_AboutHostages, },		
			} )
	end
end


function this.DeleteHighInterrogationPositionHostage()
	
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_slopedTown_cp" ),
	{
			{ name =s10041_enemy.LABEL_SLOPED_TOWN_HOSTAGE,		func = s10041_enemy.InterCall_SlopedTownHostages, },		
	} )
end


function this.DeleteHighInterrogationVehicle()
	for i, cp in pairs( lrrpAllList ) do
		Fox.Log( cp )
		TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( cp ),
			{
					{ name = s10041_enemy.LABEL_POSITION_VEHICLE,		func = s10041_enemy.InterCall_Vehicle, },		
			} )
	end
end




function this.DeleteHighInterrogationMeetingPoint()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationMeetingPoint #### " )

	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_village_cp" ),
	{
			{ name = s10041_enemy.LABEL_MEETING_POINT,		func = s10041_enemy.InterCall_MeetingPoint, },		
	} )
	
	for i, cp in pairs( lrrpAllList ) do
		Fox.Log( cp )
		TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( cp ),
			{
				{ name = s10041_enemy.LABEL_MEETING_POINT_LRRP,		func = s10041_enemy.InterCall_MeetingPoint_lrrp, },		
			} )
	end
end



function this.DeleteHighInterrogationBeforeMeeting()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationBeforeMeeting #### " )

end


function this.AddHighInterrogationAfterMeeting()
	Fox.Log( "### s10041_sequence.AddHighInterrogationAfterMeeting #### " )

	
	if	TppEnemy.IsEliminated(s10041_enemy.ENEMY_NAME.FIELD_VIP) == false 
			and svars.isIdentifiedVillageVip == false then	
		Fox.Log( "### AddHighInterrogation positionVillageVip #### " )

		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( "afgh_village_cp" ),
		{
			{ name = s10041_enemy.LABEL_POSITION_VILLAGE_VIP ,		func = s10041_enemy.InterCall_VillageVip, },	
		} )
	end

	this.DeleteHighInterrogationMeetingPoint()	
	this.DeleteHighInterrogationBeforeMeeting()	


end


function this.DeleteHighInterrogationAfterMeeting()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationAfterMeeting #### " )


end



function this.HighInterrogationAbortMeeting()
	Fox.Log( "### s10041_sequence.HighInterrogationAbortMeeting #### " )



	this.DeleteHighInterrogationMeetingPoint()	
	this.DeleteHighInterrogationBeforeMeeting()	
	this.DeleteHighInterrogationAfterMeeting()	

	TppMission.UpdateObjective{	objectives = { "deleteMeetingMarker","marker_villageVip", nil  },}	

	
	if	TppEnemy.IsEliminated(s10041_enemy.ENEMY_NAME.VILLAGE_VIP) == false	
			and svars.isIdentifiedVillageVip == false then

		Fox.Log( "### AddHighInterrogation positionVillageVip #### " )

		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId( "afgh_village_cp" ),
		{
			{ name = s10041_enemy.LABEL_POSITION_VILLAGE_VIP ,		func = s10041_enemy.InterCall_VillageVip, },	
		} )
	end
end




function this.HighInterrogationFieldVipBack()	
	Fox.Log( "### s10041_sequence.HighInterrogationFieldVipBack #### " )


end


function this.HighInterrogationEnemyBaseVipBack()	
	Fox.Log( "### s10041_sequence.HighInterrogationEnemyBaseVipBack #### " )


end



function this.DeleteHighInterrogationFieldEastNotCome()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationFieldEastNotCome #### " )
		TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_fieldEast_ob" ),
		{
			{ name =s10041_enemy.LABEL_POSITION_FIELD_VIP,		func = s10041_enemy.InterCall_fieldVipAway, },		
		} )

end

function this.AddHighInterrogationFieldEastGone()
	Fox.Log( "### s10041_sequence.HighInterrogationFieldVipArrivedFieldEast #### " )


end
function this.DeleteHighInterrogationFieldEastGone()
	Fox.Log( "### s10041_sequence.HighInterrogationFieldVipArrivedFieldEast #### " )


end

function this.AddHighInterrogationFieldEastBack()
	Fox.Log( "### s10041_sequence.AddHighInterrogationFieldEastBack #### " )

end
function this.DeleteHighInterrogationFieldEastBack()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationFieldEastBack #### " )


end
function this.AddHighInterrogationFieldEastSetMine()
	Fox.Log( "### s10041_sequence.AddHighInterrogationFieldEastSetMine #### " )

end
function this.DeleteHighInterrogationFieldEastSetMine()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationFieldEastSetMine #### " )


end


function this.DeleteHighInterrogationVillageEastNotCome()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationVillageEastNotCome #### " )
		TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_villageEast_ob" ),
		{
			{ name =s10041_enemy.LABEL_POSITION_FIELD_VIP,		func = s10041_enemy.InterCall_fieldVipAway, },		
		} )

end

function this.AddHighInterrogationVillageEastGone()
	Fox.Log( "### s10041_sequence.AddHighInterrogationVillageEastGone #### " )

end
function this.DeleteHighInterrogationVillageEastGone()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationVillageEastGone #### " )

end

function this.AddHighInterrogationVillageEastBack()
	Fox.Log( "### s10041_sequence.AddHighInterrogationVillageEastBack #### " )

end
function this.DeleteHighInterrogationVillageEastBack()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationVillageEastBack #### " )


end
function this.AddHighInterrogationVillageEastSetMine()
	Fox.Log( "### s10041_sequence.AddHighInterrogationVillageEastSetMine #### " )

end
function this.DeleteHighInterrogationVillageEastSetMine()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationVillageEastSetMine #### " )

end



function this.DeleteHighInterrogationVillageWestNotCome()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationVillageWestNotCome #### " )
		TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_villageWest_ob" ),
		{
			{ name = s10041_enemy.LABEL_POSITION_ENEMY_BASE_VIP,	func = s10041_enemy.InterCall_EnemyBaseVipAway, },		
		} )

end

function this.AddHighInterrogationVillageWestGone()
	Fox.Log( "### s10041_sequence.AddHighInterrogationVillageWestGone #### " )

end
function this.DeleteHighInterrogationVillageWestGone()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationVillageWestGone #### " )

end

function this.AddHighInterrogationVillageWestBack()
	Fox.Log( "### s10041_sequence.AddHighInterrogationVillageWestBack #### " )

end
function this.DeleteHighInterrogationVillageWestBack()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationVillageWestBack #### " )

end
function this.AddHighInterrogationVillageWestSetMine()
	Fox.Log( "### s10041_sequence.AddHighInterrogationVillageWestSetMine #### " )

end
function this.DeleteHighInterrogationVillageWestSetMine()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationVillageWestSetMine #### " )


end

function this.DeleteHighInterrogationEnemyBase()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationEnemyBase #### " )
	
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_enemyBase_cp" ),
	{
			{ name = s10041_enemy.LABEL_POSITION_ENEMY_BASE_VIP,	func = s10041_enemy.InterCall_EnemyBaseVipAway, },		

	} )
end

function this.DeleteHighInterrogationField()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationField #### " )

	
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_field_cp" ),
	{
			{ name =s10041_enemy.LABEL_POSITION_FIELD_VIP,		func = s10041_enemy.InterCall_fieldVipAway, },		
	} )
end


function this.DeleteHighInterrogationVillageVipAll()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationVillageVipAll #### " )
	
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId( "afgh_village_cp" ),
	{
			{ name = s10041_enemy.LABEL_POSITION_VILLAGE_VIP ,		func = s10041_enemy.InterCall_VillageVip, },	
	} )

end

function this.HighInterrogationEnemyBaseVipReturnTravel()	
	Fox.Log( "### s10041_sequence.HighInterrogationEnemyBaseVipReturnTravel #### " )


end

function this.HighInterrogationFieldVipReturnTravel()	
	Fox.Log( "### s10041_sequence.HighInterrogationFieldVipReturnTravel #### " )

end




function this.DeleteHighInterrogationEnemyBaseVipAll()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationEnemyBaseVipAll #### " )
	
	this.DeleteHighInterrogationEnemyBase()

	
	
	this.DeleteHighInterrogationVillageWestGone()
	this.DeleteHighInterrogationVillageWestBack()	
	this.DeleteHighInterrogationVillageWestSetMine()	

end

function this.DeleteHighInterrogationFieldVipAll()
	Fox.Log( "### s10041_sequence.DeleteHighInterrogationFieldVipAll #### " )

	
	this.DeleteHighInterrogationField()

	
	
	this.DeleteHighInterrogationFieldEastNotCome()

	
	this.DeleteHighInterrogationVillageEastNotCome()


end









function this.VIPEliminateFunc(EliminateRadioType)
	local isTargetRemain	=3

	if	svars.isReserve_06 == true then
	
		isTargetRemain = isTargetRemain -1
		this.DeleteHighInterrogationFieldVipAll()

		
	end

	if svars.isReserve_07 == true then 

		isTargetRemain = isTargetRemain -1
		this.DeleteHighInterrogationEnemyBaseVipAll()

		
	end
	if svars.isReserve_05 == true then

		isTargetRemain = isTargetRemain -1
		this.DeleteHighInterrogationVillageVipAll()

		
	end



	if isTargetRemain ==0 then	
		Fox.Log( "### All VIP are Eliminated ! ###")
		this.EliminateThirdTarget(EliminateRadioType)

	elseif isTargetRemain ==1 then	
		Fox.Log( "### Some VIP are still remain " .. isTargetRemain .. " ###")

		this.EliminateSecondTarget(EliminateRadioType)	

	elseif isTargetRemain ==2 then	
		Fox.Log( "### Some VIP are still remain " .. isTargetRemain .. " ###")
		this.EliminateFirstTarget(EliminateRadioType)	

	else
		Fox.Log( "### Some VIP are still remain " .. isTargetRemain .. " ###")
	end
end

function this.EliminateThirdTarget(EliminateRadioType)
	Fox.Log( "### s10041_sequence.EliminateThirdTarget 111 ###")

	
	TppRadio.SetOptionalRadio( "Set_s0041_oprg0030" )
	
	TppRadio.ChangeIntelRadio( s10041_radio.intelRadioListGualdEliminated )


	if EliminateRadioType == this.vipKillType.KILL_IDENTIFIED then						
		mvars.EscapeRadioGroups = this.vipKillType.KILL_IDENTIFIED
		Fox.Log( "### KILL_IDENTIFIED ###")

	elseif EliminateRadioType == this.vipKillType.FULLTON_IDENTIFIED 	then			
		mvars.EscapeRadioGroups = this.vipKillType.FULLTON_IDENTIFIED
		Fox.Log( "### FULLTON_IDENTIFIED ###")

	elseif EliminateRadioType == this.vipKillType.HELI_IDENTIFIED then					
		mvars.EscapeRadioGroups = this.vipKillType.HELI_IDENTIFIED
		Fox.Log( "### HELI_IDENTIFIED ###")

	elseif EliminateRadioType == this.vipKillType.FULLTON_FAILED_IDENTIFIED then		
		mvars.EscapeRadioGroups = this.vipKillType.FULLTON_FAILED_IDENTIFIED
		Fox.Log( "### FULLTON_FAILED_IDENTIFIED ###")

	elseif EliminateRadioType == this.vipKillType.KILL_NOT_IDENTIFIED then				
		mvars.EscapeRadioGroups = this.vipKillType.KILL_NOT_IDENTIFIED
		Fox.Log( "### KILL_NOT_IDENTIFIED ###")

	elseif EliminateRadioType == this.vipKillType.FULLTON_NOT_IDENTIFIED				
			or EliminateRadioType == this.vipKillType.HELI_NOT_IDENTIFIED then			

		mvars.EscapeRadioGroups = this.vipKillType.HELI_NOT_IDENTIFIED
		Fox.Log( "### HELI_NOT_IDENTIFIED ###")

	elseif EliminateRadioType == this.vipKillType.FULLTON_FAILED_NOT_IDENTIFIED then	
		mvars.EscapeRadioGroups = this.vipKillType.FULLTON_FAILED_NOT_IDENTIFIED

		Fox.Log( "### FULLTON_FAILED_NOT_IDENTIFIED ###")

	else
		Fox.Log( "### Error Illegal target kill type ###")
		svars.EscapeRadioGroups = this.vipKillType.KILL_IDENTIFIED

	end
	TppSequence.SetNextSequence( "Seq_GameEscape" )
end


function this.EliminateSecondTarget(EliminateRadioType)
	Fox.Log( "### s10041_sequence.EliminateSecondTarget ###")


	if EliminateRadioType == this.vipKillType.KILL_IDENTIFIED then						
		s10041_radio.VipKill_2()
	elseif EliminateRadioType == this.vipKillType.FULLTON_IDENTIFIED 					
			or EliminateRadioType == this.vipKillType.HELI_IDENTIFIED then				
		s10041_radio.VipFullton_2()
	elseif EliminateRadioType == this.vipKillType.FULLTON_FAILED_IDENTIFIED then		
		s10041_radio.VipFulltonFailed_2()
	elseif EliminateRadioType == this.vipKillType.KILL_NOT_IDENTIFIED then				
		s10041_radio.VipKillNotIdentified_2()
	elseif EliminateRadioType == this.vipKillType.FULLTON_NOT_IDENTIFIED				
			or EliminateRadioType == this.vipKillType.HELI_NOT_IDENTIFIED then			
		s10041_radio.VipFulltonNotIdentified_2()
	elseif EliminateRadioType == this.vipKillType.FULLTON_FAILED_NOT_IDENTIFIED then	
		s10041_radio.VipFulltonFailedNotIdentified_2()
	else
		Fox.Log( "### Error Illegal target kill type ###")
	end

	
	if	TppEnemy.IsEliminated(s10041_enemy.ENEMY_NAME.FIELD_VIP) == true
			and	TppEnemy.IsEliminated(s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP) == true then
		TppRadio.SetOptionalRadio( "Set_s0041_oprg0050" )
	end
end

function this.EliminateFirstTarget(EliminateRadioType)
	Fox.Log( "### s10041_sequence.EliminateFirstTarget ###")

	if EliminateRadioType == this.vipKillType.KILL_IDENTIFIED then						
		s10041_radio.VipKill_1()
	elseif EliminateRadioType == this.vipKillType.FULLTON_IDENTIFIED 					
			or EliminateRadioType == this.vipKillType.HELI_IDENTIFIED then				
		s10041_radio.VipFullton_1()
	elseif EliminateRadioType == this.vipKillType.FULLTON_FAILED_IDENTIFIED then		
		s10041_radio.VipFulltonFailed_1()
	elseif EliminateRadioType == this.vipKillType.KILL_NOT_IDENTIFIED then				
		s10041_radio.VipKillNotIdentified_1()
	elseif EliminateRadioType == this.vipKillType.FULLTON_NOT_IDENTIFIED				
			or EliminateRadioType == this.vipKillType.HELI_NOT_IDENTIFIED then			
		s10041_radio.VipFulltonNotIdentified_1()
	elseif EliminateRadioType == this.vipKillType.FULLTON_FAILED_NOT_IDENTIFIED then	
		s10041_radio.VipFulltonFailedNotIdentified_1()
	else
		Fox.Log( "### Error Illegal target kill type ###")
	end
end









this.SetUpWaitingTimer = function()
	if GkEventTimerManager.IsTimerActive( "VipMeetingWaitTimer" ) then
		
		GkEventTimerManager.Stop( "VipMeetingWaitTimer")
		GkEventTimerManager.StartRaw( "VipMeetingWaitTimer", VIP_MEETING_WAIT_TIME )	
	else
		
		GkEventTimerManager.StartRaw( "VipMeetingWaitTimer", VIP_MEETING_WAIT_TIME )	
	end
end


this.SetUpWaitingTimerHeli = function()
	if GkEventTimerManager.IsTimerActive( "VipMeetingWaitTimer" ) then
		
		GkEventTimerManager.Stop( "VipMeetingWaitTimer")
		GkEventTimerManager.StartRaw( "VipMeetingWaitTimer", VIP_MEETING_WAIT_TIME_HELI )	
	else
		
		GkEventTimerManager.StartRaw( "VipMeetingWaitTimer", VIP_MEETING_WAIT_TIME_HELI )	
	end
end






this.Messages = function() 
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


			Weather = {
				{
					msg = "Clock",	sender = "OnMorning",
					func = function( sender, time )
						
						s10041_enemy.all_enemy_route_shift_Day()
					end
				},
				{
					msg = "Clock",	sender = "OnNight",
					func = function( sender, time )
						
						s10041_enemy.all_enemy_route_shift_Night()

					end
				},
			},

			Radio = {
				{	
					msg = "Finish",
					func = function (arg0)
						if arg0 ==	StrCode32("s0041_esrg0010") then
							Fox.Log("#### ESRG0010 Finish ####")
							if svars.isMeetingAborted == false then	
								s10041_radio.EspionageMeetingPointBeforeMeeting()
							end
						end
					end
				},
			},

			GameObject = {
				{
		
		
				msg = "RoutePoint2",
				func = function (nObjectId,nRouteId,nRouteNodeId,sendM)
					if	sendM == StrCode32("msgVIP_arrived") then	
					elseif sendM == StrCode32("msgTravelChangeCp") then

					elseif sendM == StrCode32("msgVIPwaiting") then
							Fox.Log("#### VIP_waiting ####")		
							s10041_enemy.SetWaitingVIP(nObjectId)
					elseif sendM == StrCode32("msgVIPConvStart") then	
					
					elseif	sendM == StrCode32("msgVIP_returnTravel") then	
						Fox.Log("#### VIP ready to ride vehicle ####")
						s10041_enemy.SetReturnRoute_VIP(nObjectId)
					elseif	sendM == StrCode32("msgVIP_ReturnTravelArrived") then	
						Fox.Log("#### VIP Return HomeOP ####")
						s10041_enemy.SetBackBaseRoute_VIP(nObjectId)
					elseif sendM == StrCode32("msgVIPtimeout") then	
						Fox.Log("#### Delayed VIP go back　####")
						

					
					elseif sendM == StrCode32("EB_PullBackAgain") then
						Fox.Log("####Messgae: EB_PullBackAgain ####")
						s10041_enemy.TransferCpStep( ENEMYBASE_VIP_GROUP, "lrrp_EnemyBaseToVillage_Return_Run", 3 )		

					
					elseif sendM == StrCode32("FD_PullBackAgain01") then
						Fox.Log("####Messgae: FD_PullBackAgain01_From_fieldEast ####")
						s10041_enemy.TransferCpStep( FIELD_VIP_GROUP,"lrrp_FieldToVillage_Return_Run", 5 )		

					
					elseif sendM == StrCode32("FD_PullBackAgain02") then
						Fox.Log("####Messgae: FD_PullBackAgain02_From_villageEast ####")
						s10041_enemy.TransferCpStep( FIELD_VIP_GROUP,"lrrp_FieldToVillage_Return_Run", 3 )		

					
					elseif sendM == StrCode32("EBVehBroken_Step0") then
						if	TppEnemy.IsVehicleBroken( "veh_s10041_VipEnemyBase" )	== true	then
							Fox.Log("###**** EBVehIsBroken Return_Run from Step0 Now ####")
							s10041_enemy.TransferCpStep( ENEMYBASE_VIP_GROUP,"lrrp_EnemyBaseToVillage_Return_Run", 0 )		
						else
							Fox.Log("###**** EBVehisStillAvaiable ####")
						end
					elseif sendM == StrCode32("EBVehBroken_Step1") then
						if	TppEnemy.IsVehicleBroken( "veh_s10041_VipEnemyBase" )	== true	then
							Fox.Log("###**** EBVehIsBroken Return_Run from Step1 Now ####")
							s10041_enemy.TransferCpStep( ENEMYBASE_VIP_GROUP,"lrrp_EnemyBaseToVillage_Return_Run", 1 )		
						else
							Fox.Log("###**** EBVehisStillAvaiable ####")
						end
					elseif sendM == StrCode32("EBVehBroken_Step2") then
						if	TppEnemy.IsVehicleBroken( "veh_s10041_VipEnemyBase" )	== true	then
							Fox.Log("###**** EBVehIsBroken Return_Run from Step2 Now ####")
							s10041_enemy.TransferCpStep( ENEMYBASE_VIP_GROUP,"lrrp_EnemyBaseToVillage_Return_Run", 2 )		
						else
							Fox.Log("###**** EBVehisStillAvaiable ####")
						end

					
					elseif sendM == StrCode32("FDVehBroken_Step0") then
						if	TppEnemy.IsVehicleBroken( "veh_s10041_VipField" )	== true	then
							Fox.Log("###**** FDVehIsBroken Return_Run from Step0 Now ####")
							s10041_enemy.TransferCpStep( FIELD_VIP_GROUP,"lrrp_FieldToVillage_Return_Run", 0 )		
						else
							Fox.Log("###**** FDVehisStillAvaiable ####")
						end
					elseif sendM == StrCode32("FDVehBroken_Step1") then
						if	TppEnemy.IsVehicleBroken( "veh_s10041_VipField" )	== true	then
							Fox.Log("###**** FDVehIsBroken Return_Run from Step1 Now ####")
							s10041_enemy.TransferCpStep( FIELD_VIP_GROUP,"lrrp_FieldToVillage_Return_Run", 1 )		
						else
							Fox.Log("###**** FDVehisStillAvaiable ####")
						end

					elseif sendM == StrCode32("FDVehBroken_Step2") then
						if	TppEnemy.IsVehicleBroken( "veh_s10041_VipField" )	== true	then
							Fox.Log("###**** FDVehIsBroken Return_Run from Step2 Now ####")
							s10041_enemy.TransferCpStep( FIELD_VIP_GROUP,"lrrp_FieldToVillage_Return_Run", 2 )		
						else
							Fox.Log("###**** FDVehisStillAvaiable ####")
						end


					
					elseif sendM == StrCode32("VipEB_NoVigilance") then
						Fox.Log("####Messgae: VipEB_NoVigilance ####")
						s10041_enemy.SetRelativeVehicleNoVigilance("veh_s10041_VipEnemyBase")		
					elseif sendM == StrCode32("VipFD_NoVigilance") then
						Fox.Log("####Messgae: VipFD_NoVigilance ####")
						s10041_enemy.SetRelativeVehicleNoVigilance("veh_s10041_VipField")		


					else

					end
				end
			},












				
				
			{
				msg = "Dead",
				sender = { 	s10041_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00,
							s10041_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01,
													},
				func = function (nGameObjectId,msg)
					this.eliminateHostage()
				end
			},

			{
				msg = "Dead",
				sender = { s10041_enemy.ENEMY_NAME.FIELD_VIP,
							s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP,
							s10041_enemy.ENEMY_NAME.VILLAGE_VIP,
							s10041_enemy.ENEMY_NAME.FIELD_DRIVER,
							s10041_enemy.ENEMY_NAME.FIELD_GUARD,
							s10041_enemy.ENEMY_NAME.ENEMYBASE_DRIVER,
							s10041_enemy.ENEMY_NAME.ENEMYBASE_GUARD,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_00,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_01,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_02,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_03,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_04,
													},
				func = function (nGameObjectId)
					Fox.Log("###Dead####")

					local EliminateType = this.EliminateType.KILL 
					local EliminateRadioType = s10041_enemy.EliminatedVIP( nGameObjectId ,EliminateType)	

					Fox.Log("###EliminateRadioType####" .. EliminateRadioType)

					if EliminateRadioType == 	this.vipKillType.NOT_VIP	then		
						Fox.Log("#### Common radio dead　####" .. EliminateRadioType)
					else
						this.VIPEliminateFunc(EliminateRadioType)	
					end
				end

			},
			{
				msg = "FultonFailed",	
		
					func = function (nGameObjectId,arg1,arg2,type)
					Fox.Log("####fulton failed "..type)
					if type == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then	
						local EliminateType = this.EliminateType.FULLTON_FAILED 
						local EliminateRadioType = s10041_enemy.EliminatedVIP( nGameObjectId ,EliminateType)	
						if EliminateRadioType == 	this.vipKillType.NOT_VIP	then		
							Fox.Log("#### Common radio FultonFailed　####" .. EliminateRadioType)
						else
							this.VIPEliminateFunc(EliminateRadioType)	
						end
					else																
						Fox.Log("#### Fulton Failed not FULTON_FAILED_TYPE_ON_FINISHED_RISE　####")
					end
				end

			},
			{
				msg = "Fulton",
				sender = { 	s10041_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00,
							s10041_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01,
													},
				func = function (nGameObjectId,msg)
					this.eliminateHostage()
				end
			},

			{
				msg = "Fulton",
				sender = { s10041_enemy.ENEMY_NAME.FIELD_VIP,
							s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP,
							s10041_enemy.ENEMY_NAME.VILLAGE_VIP,
						},
				func = function (nGameObjectId,msg)
					Fox.Log("###Fulton vip####")

					local EliminateType = this.EliminateType.FULLTON 
					local EliminateRadioType = s10041_enemy.EliminatedVIP( nGameObjectId ,EliminateType)	

					if EliminateRadioType == 	this.vipKillType.NOT_VIP	then		
						Fox.Log("#### Common radio Fulton　####" .. EliminateRadioType)
					else
						this.VIPEliminateFunc(EliminateRadioType)	
					end
				end
			},

			{
				msg = "Fulton",
				sender = { 	s10041_enemy.ENEMY_NAME.FIELD_DRIVER,
							s10041_enemy.ENEMY_NAME.FIELD_GUARD,
							s10041_enemy.ENEMY_NAME.ENEMYBASE_DRIVER,
							s10041_enemy.ENEMY_NAME.ENEMYBASE_GUARD,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_00,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_01,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_02,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_03,
							s10041_enemy.ENEMY_NAME.VILLAGE_GUARD_04,
						},
				func = function (nGameObjectId,msg)
					Fox.Log("###Fulton guard####")

					local EliminateType = this.EliminateType.FULLTON 
					local EliminateRadioType = s10041_enemy.EliminatedVIP( nGameObjectId ,EliminateType)	

					if EliminateRadioType == 	this.vipKillType.NOT_VIP	then		
						Fox.Log("#### Common radio Fulton　####" .. EliminateRadioType)
					end
				end
			},

			{
				msg = "Fulton",
				sender = { "veh_s10041_VipEnemyBase",	},
				func = function (nGameObjectId,msg)
					Fox.Log("###Fulton veh_s10041_VipEnemyBase####")

					svars.isReserve_04 = true	
					TppMission.UpdateObjective{	objectives = { "delete_veh_s10041_VipEnemyBase", nil  },}	

				end
			},
			{
				msg = "Fulton",
				sender = { "veh_s10041_VipField",	},
				func = function (nGameObjectId,msg)
					Fox.Log("###Fulton veh_s10041_VipField####")
					svars.isReserve_03 = true	
					TppMission.UpdateObjective{	objectives = { "delete_veh_s10041_VipField", nil  },}	

				end
			},
			{
				msg = "VehicleBroken",
				sender = { "veh_s10041_VipEnemyBase",	},
				func = function (nGameObjectId,msg)
					if msg ==StrCode32("End") then
						Fox.Log("###VehicleBroken veh_s10041_VipEnemyBase####")
						svars.isReserve_04 = true	
						TppMission.UpdateObjective{	objectives = { "delete_veh_s10041_VipEnemyBase", nil  },}	
					end
				end
			},
			{
				msg = "VehicleBroken",
				sender = { "veh_s10041_VipField",	},
				func = function (nGameObjectId,msg)
					if msg ==StrCode32("End") then
						Fox.Log("###VehicleBroken veh_s10041_VipField####")

						svars.isReserve_03 = true	
						TppMission.UpdateObjective{	objectives = { "delete_veh_s10041_VipField", nil  },}	

					end
				end
			},

			{	
				msg = "PlacedIntoVehicle" ,  sender = { s10041_enemy.ENEMY_NAME.FIELD_VIP,s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP,s10041_enemy.ENEMY_NAME.VILLAGE_VIP },
				func = function ( nGameObjectId , arg2 )
					Fox.Log("###PlacedIntoVehicle####")

					if arg2 == GameObject.GetGameObjectId("SupportHeli") then


						local EliminateType = this.EliminateType.HELI 
						local EliminateRadioType = s10041_enemy.EliminatedVIP( nGameObjectId ,EliminateType)	
						if EliminateRadioType == 	this.vipKillType.NOT_VIP	then		
							Fox.Log("#### Common radio PlacedIntoVehicle Heli ####" .. EliminateRadioType)
						else

							this.VIPEliminateFunc(EliminateRadioType)	
						end

					else	
						Fox.Log("#### PlacedIntoVehicle not Heli　####" .. EliminateRadioType)
					end
				end
			},

			{
				msg = "PlacedIntoVehicle" ,
				sender = { 	s10041_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_00,
							s10041_enemy.BONUS_HOSTAGE_NAME.HOSTAGE_01,
													},
				func = function ( nGameObjectId , arg2 )
					Fox.Log("###PlacedIntoVehicle####")
					if arg2 == GameObject.GetGameObjectId("SupportHeli") then
						this.eliminateHostage()
					else	
						Fox.Log("#### PlacedIntoVehicle not Heli　####" .. EliminateRadioType)
					end
				end
			},

		
			{
				msg = "RadioEnd",
				func = function( gameObjectId, cpGameObjectId, speechLabel, isSuccess )
					Fox.Log( "*** Message: RadioEnd ***")
					if speechLabel == StrCode32( "HQSP030" ) then
						Fox.Log("***********HQSP030_END!!!CPRadioFromVillageVIP change Flag************")
						svars.isReserve_20	= true
					elseif speechLabel == StrCode32( "HQSP020" ) then
						Fox.Log("***********HQSP020_END!!!CPRadioFromField************")

					elseif speechLabel == StrCode32( "HQSP040" ) then
						Fox.Log("***********END!!!CPRadioFromEnemyBase************")
					else
						Fox.Log("***HQSP040_NotSpeicalCPRadio************")
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


function this.eliminateHostage()
	Fox.Log("###eliminateHostage####")

	svars.HostageRescue=svars.HostageRescue+1
	if svars.HostageRescue >=2 then	
		svars.isAboutHostage=true	
		s10041_sequence.DeleteHighInterrogationAboutHostage()
		s10041_sequence.DeleteHighInterrogationPositionHostage()	
	end
end


function this.meetingManager()
	if svars.isCancelMeeting == false then	

		if svars.meetingPart == this.meetingPart.FIRST then
			this.meetingFirst()	

		elseif svars.meetingPart == this.meetingPart.FULLTON then
			this.meetingFullton()	

		elseif svars.meetingPart == this.meetingPart.KILL then

			this.meetingKill()	

		elseif svars.meetingPart == this.meetingPart.LAST then

			this.meetingLast()	

		else
			
			Fox.Log( "*** Meeting Error ***")

		end
	end
end

function this.meetingFirst()
	if (svars.meetingCount <	VIP_MEETING_FIRST_MAX) then	
		svars.meetingCount = svars.meetingCount +1
	elseif (svars.meetingCount <=	VIP_MEETING_FIRST_MAX) then	
	
		svars.meetingCount = 1
		if meetingNode == 0 then	
			svars.meetingPart	= this.meetingPart.FULLTON	
		else
			svars.isMeetingFullton	= this.meetingPart.KILL	
		end
	else
		Fox.Log( "*** Unknown Message ***")
		return nil	
	end
	s10041_enemy.StartMeeting3VIP()
end

function this.meetingFullton()
	Fox.Log( "### meetingCount " .. svars.meetingCount.. " ###")

	if (svars.meetingCount <	VIP_MEETING_FULLTON_MAX) then	
		svars.meetingCount = svars.meetingCount +1
	elseif (svars.meetingCount <=	VIP_MEETING_FULLTON_MAX) then	
		svars.meetingPart	= this.meetingPart.LAST	
		svars.meetingCount = 1
	else
		Fox.Log( "*** Unknown Message ***")
		return nil	
	end
	s10041_enemy.StartMeeting3VIP()
end

function this.meetingKill()
	Fox.Log( "### meetingCount " .. svars.meetingCount.. " ###")
	if (svars.meetingCount <	VIP_MEETING_KILL_MAX) then	
		svars.meetingCount = svars.meetingCount +1
	elseif (svars.meetingCount <=	VIP_MEETING_KILL_MAX) then	
		svars.meetingPart	= this.meetingPart.LAST	
		svars.meetingCount = 1
	else
		Fox.Log( "*** Unknown Message ***")
		return nil	
	end
	s10041_enemy.StartMeeting3VIP()
end

function this.meetingLast()
	Fox.Log( "### meetingCount " .. svars.meetingCount.. " ###")

	if (svars.meetingCount <	VIP_MEETING_LAST_MAX) then	
		svars.meetingCount = svars.meetingCount +1
	else		
		svars.meetingPart = this.meetingPart.AFTER_MEETING		
		this.AddHighInterrogationAfterMeeting()	
		s10041_enemy.EndMeeting()
		return nil
	end
	s10041_enemy.StartMeeting3VIP()
end






this.missionObjectiveDefine = {
	s10041_marker_village = {
		gameObjectName = "s10041_marker_village", visibleArea = 4, randomRange = 0,viewType="all", setNew = false,
		langId = "marker_info_mission_targetArea",
		mapRadioName = "s0041_mirg0040",
	},
	marker_meetingPoint = {
		gameObjectName = "s10041_marker_meetingPoint",visibleArea = 1, randomRange = 0,viewType="all", setNew = false,
		langId = "marker_info_mission_targetArea",
		mapRadioName = "s0041_mirg0040",
		announceLog = "updateMap",
	},
	marker_meetingPointIntel = {
		gameObjectName = "s10041_marker_meetingPointIntel", visibleArea = 1, randomRange = 0,viewType="all", setNew = true,
		langId = "marker_unkown_info",
		mapRadioName = "s0041_mprg0020",
		announceLog = "updateMap",
	},

	marker_villageVip = {
		gameObjectName = "s10041_marker_village", visibleArea = 5, randomRange = 0,viewType="all", setNew = false,
		langId = "marker_info_mission_targetArea",
		mapRadioName = "f1000_mprg0080",
		announceLog = "updateMap",
	},
	marker_fieldVip = {
		gameObjectName = "s10041_marker_field", visibleArea = 5, randomRange = 0,viewType="all", setNew = false,
		langId = "marker_info_mission_targetArea",
		mapRadioName = "f1000_mprg0075",

	},

	marker_enemyBaseVip = {
		gameObjectName = "s10041_marker_enemyBase", visibleArea = 5, randomRange = 0,viewType="all", setNew = false,
		langId = "marker_info_mission_targetArea",
		mapRadioName = "f1000_mprg0070",
		announceLog = "updateMap",
	},

	deleteMeetingMarker = {
		announceLog = "updateMap",
	},

	target_vip_village = {
		gameObjectName = "sol_vip_village", goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true,
		mapRadioName = "s0041_mprg0031",
		announceLog = "updateMap", langId = "marker_info_mission_target",

	},

	target_vip_field = {
		gameObjectName = "sol_vip_field", goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true,
		mapRadioName = "s0041_mprg0030",
		announceLog = "updateMap", langId = "marker_info_mission_target",
	},
	target_vip_enemyBase = {
		gameObjectName = "sol_vip_enemyBase", goalType = "attack", viewType = "map_and_world_only_icon", setNew = true, setImportant = true,
		mapRadioName = "s0041_mprg0032",
		announceLog = "updateMap", langId = "marker_info_mission_target",
	},



	marker_veh_s10041_VipEnemyBase = {
		gameObjectName = "veh_s10041_VipEnemyBase", goalType = "none", viewType = "map_and_world_only_icon", setNew = true, setImportant = false,
		announceLog = "updateMap", langId = "marker_info_vehicle_4wd",
	},
	delete_veh_s10041_VipEnemyBase = {},


	marker_veh_s10041_VipField = {
		gameObjectName = "veh_s10041_VipField", goalType = "none", viewType = "map_and_world_only_icon", setNew = true, setImportant = false,
		announceLog = "updateMap", langId = "marker_info_vehicle_4wd",
	},
	rv_missionClear = {
		announceLog = "updateMap",
	},
	delete_veh_s10041_VipField = {},


	
	default_photo_fieldVip = {
		photoId	= PHOTO_NAME.FIELD_VIP,
					addFirst = true,
					addSecond = false,
					isComplete = false,
					photoRadioName = "s0041_mirg0010", 
	},
	default_photo_villageVip = {
		photoId	= PHOTO_NAME.VILLAGE_VIP,
					addFirst = true,
					addSecond = false,
					isComplete = false,
					photoRadioName = "s0041_mirg0020",
					targetBgmCp = "afgh_village_cp",
	},
	default_photo_enemyBaseVip = {
		photoId	= PHOTO_NAME.ENEMY_BASE_VIP,
					addFirst = true,
					addSecond = false,
					isComplete = false,
					photoRadioName = "s0041_mirg0030",
	},
	default_photo_meetingPoint = {
		photoId	= PHOTO_NAME.MEETING_POINT,
					addFirst = false,
					addSecond = false,
					isComplete = false,
					photoRadioName = "s0041_mirg0040",
	},


	
	clear_photo_fieldVip = {
		photoId	= PHOTO_NAME.FIELD_VIP,
					addFirst = true,					
					addSecond = false,
					isComplete = false,

	},
	clear_photo_villageVip = {
		photoId	= PHOTO_NAME.VILLAGE_VIP,
					addFirst = true,					
					addSecond = false,
					isComplete = false,
	},
	clear_photo_enemyBaseVip = {
		photoId	= PHOTO_NAME.ENEMY_BASE_VIP,
					addFirst = true,					
					addSecond = false,
					isComplete = false,
	},
	clear_photo_meetingPoint = {
		photoId	= PHOTO_NAME.MEETING_POINT,
					addFirst = false,
					addSecond = false,
					isComplete = false,
	},
	
	target_area_cp = {
		targetBgmCp = "afgh_village_cp",
	},


	route_vip_field_arrival = {
		showEnemyRoutePoints = { groupIndex=GROUP_FIELD_VIP_ARRIVAL_ROUTE,
			width=200.0, langId="marker_target_forecast_path",
			radioGroupName = "f1000_mprg0260",	
			points={
				Vector3( 588.3,0.0,1163.0 ),
				Vector3( 739.0,0.0,1212.0 ),
				Vector3( 929.0,0.0,1261.7 ),
				Vector3( 1161.8,0.0,1408.5 ),
				Vector3( 1247.8,0.0,1733.9 ),
				Vector3( 956.9,0.0,1970.4 ),
				Vector3( 728.8,0.0,1940.4 ),
				Vector3( 455.6,0.0,2165.6 ),
			}
		},
	
		
		spySearch = { gameObjectName = s10041_enemy.ENEMY_NAME.FIELD_VIP, isNew=true, langId="marker_info_mission_target",	},

	},
	route_vip_field_departure = {
		showEnemyRoutePoints = { groupIndex=GROUP_ENEMY_BASE_VIP_ARRIVAL_ROUTE,
			width=200.0, langId="marker_target_forecast_path",
			radioGroupName = "f1000_mprg0260",	
			points={
				Vector3( 455.6,0.0,2165.6 ),	
				Vector3( 728.8,0.0,1940.4 ),	
				Vector3( 956.9,0.0,1970.4 ), 	
				Vector3( 1247.8,0.0,1733.9 ),	
				Vector3( 1161.8,0.0,1408.5 ),	
				Vector3( 929.0,0.0,1261.7 ),	
				Vector3( 739.0,0.0,1212.0 ),	
				Vector3( 588.3,0.0,1163.0 ),	
			}
		},
	
		
		spySearch = { gameObjectName = s10041_enemy.ENEMY_NAME.FIELD_VIP, isNew=true, langId="marker_info_mission_target",	} ,

	},




	route_vip_enemyBase_arrival = {
		showEnemyRoutePoints = { groupIndex=GROUP_ENEMY_BASE_VIP_DEPARTURE_ROUTE,
			width=200.0, langId="marker_target_forecast_path",
			radioGroupName = "f1000_mprg0260",	
				points={
		



















Vector3( 433.9,0.0,1126.8 ),


Vector3( 196.6,0.0,940.0 ),
Vector3(  0.8,0.0,902.0 ),
Vector3( -253.3,0.0,973.6 ),
Vector3( -506.6,0.0,826.4 ),
Vector3( -530.2,0.0,709.0 ),
Vector3( -481.7,0.0,560.6 ),


Vector3( -539.4,0.0,477.0 ),


			}
		},
		announceLog = "updateMap",
		
		spySearch = { gameObjectName = s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP, isNew=true, langId="marker_info_mission_target",	} ,
	},

	route_vip_enemyBase_departure = {
		showEnemyRoutePoints = { groupIndex=GROUP_ENEMY_BASE_VIP_DEPARTURE_ROUTE,
			width=200.0, langId="marker_target_forecast_path",
			radioGroupName = "f1000_mprg0260",	
			points={
	









Vector3( -539.4,0.0,477.0 ), Vector3( -481.7,0.0,560.6 ), Vector3( -530.2,0.0,709.0 ),
Vector3( -506.6,0.0,826.4 ), Vector3( -253.3,0.0,973.6 ), Vector3(	0.8,0.0,902.0 ),
Vector3( 196.6,0.0,940.0 ), Vector3( 450.5,0.0,1090.4 ),

			}
		},
		announceLog = "updateMap",
		
		spySearch = { gameObjectName = s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP, isNew=true, langId="marker_info_mission_target",	} ,

	},


	Area_marker_SubTarget = {
		gameObjectName = "s10041_marker_SubTarget", visibleArea = 4, randomRange = 0,viewType="all", setNew = false,
		langId = "marker_unkown_info",
		mapRadioName = "f1000_esrg0810",
	},

	
	hos_subTarget_0000 = {
		gameObjectName = "hos_subTarget_0000",
		goalType = "none",
		viewType = "map_and_world_only_icon", setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",
		mapRadioName = "f1000_esrg0810",
	},
	
	hos_subTarget_0001 = {
		gameObjectName = "hos_subTarget_0001",
		goalType = "none",
		viewType = "map_and_world_only_icon", setNew = true,
		announceLog = "updateMap",
		langId = "marker_hostage",
		mapRadioName = "f1000_esrg0810",
	},

	
	
	default_subGoal = {		
		subGoalId= 0,
	},
	escape_subGoal = {		
		announceLog = "updateMissionInfo",
		subGoalId= 3,
	},

	
	

		
		
		
		
		
		
		

	task0_default = {	missionTask = { taskNo=0, isComplete=false },},
	task1_default = {	missionTask = { taskNo=1, isComplete=false },},
	task2_default = {	missionTask = { taskNo=2, isComplete=false },},

	task3_default = {	missionTask = { taskNo=3, isNew=true, isComplete=false, isFirstHide=true },},
	task4_default = {	missionTask = { taskNo=4, isNew=true, isComplete=false, isFirstHide=true },},
	task5_default = {	missionTask = { taskNo=5, isNew=true, isComplete=false, isFirstHide=true },},
	task6_default = {	missionTask = { taskNo=6, isNew=true, isComplete=false, isFirstHide=true },},





	task0_complete = {	missionTask = { taskNo=0, isComplete=true},},
	task1_complete = {	missionTask = { taskNo=1, isComplete=true},},
	task2_complete = {	missionTask = { taskNo=2, isComplete=true},},

	task3_complete = {	missionTask = { taskNo=3, isComplete=true},},
	task4_complete = {	missionTask = { taskNo=4, isComplete=true},},

	task5_complete = {	missionTask = { taskNo=5, isComplete=true},},
	task6_complete = {	missionTask = { taskNo=6, isComplete=true},},

	announce_FirstTargetKilled = {announceLog = "eliminateTarget",},
	announce_FirstTargetRecovered = {announceLog = "recoverTarget",},

	announce_SecondTargetKilled = {announceLog = "eliminateTarget",},
	announce_SecondTargetRecovered = {announceLog = "recoverTarget",},

	announce_ThirdTargetKilled = {announceLog = "eliminateTarget",},
	announce_ThirdTargetRecovered = {announceLog = "recoverTarget",},

	announce_AllObjectiveFinish = {announceLog = "achieveAllObjectives",},

	
	hud_photo_field = {
		hudPhotoId = 20 
	},
	hud_photo_village = {
		hudPhotoId = 30 
	},
	hud_photo_enemyBase = {
		hudPhotoId = 40 
	},


}


this.specialBonus = {
		first = {
				missionTask = { taskNo = 3 },
				
		},
		second = {
				missionTask = { taskNo = 4 },
				
		}
}














this.missionObjectiveTree = {
	rv_missionClear = {
	},
	clear_photo_meetingPoint = {
		default_photo_meetingPoint = {},
	},
	clear_photo_fieldVip = {
		default_photo_fieldVip = {},
		target_vip_field = {
			marker_fieldVip = {
				route_vip_field_departure = {
					route_vip_field_arrival = {},
				},
			},

		},
		announce_SecondTargetKilled= {},
		announce_SecondTargetRecovered= {},
	},
	clear_photo_villageVip = {
		default_photo_villageVip = {},
		target_vip_village = {
			marker_villageVip={},
		},
		target_area_cp = {},

		announce_FirstTargetKilled= {},
		announce_FirstTargetRecovered= {},
	},
	clear_photo_enemyBaseVip = {
		default_photo_enemyBaseVip = {},
		target_vip_enemyBase = {
			marker_enemyBaseVip	={
				route_vip_enemyBase_departure = {
					route_vip_enemyBase_arrival={},
				},
			},
		},
		announce_ThirdTargetKilled= {},
		announce_ThirdTargetRecovered= {},
	},
	deleteMeetingMarker	={
		
		marker_meetingPointIntel	={			
			s10041_marker_village = {},
		},
	},
	hos_subTarget_0000={
		Area_marker_SubTarget = {},
	},
	hos_subTarget_0001={
		Area_marker_SubTarget = {},
	},
	task0_default = {},
	task1_default = {},
	task2_default  = {},

	task3_default = {},
	task4_default  = {},

	task5_default  = {},
	task6_default = {},

	task0_complete	= {},
	task1_complete	= {},
	task2_complete	= {},

	task3_complete	= {},
	task4_complete	= {},

	task5_complete	= {},
	task6_complete	= {},

	delete_veh_s10041_VipEnemyBase = {
		marker_veh_s10041_VipEnemyBase = {},
	},
	delete_veh_s10041_VipField = {
		marker_veh_s10041_VipField = {},
	},




	announce_AllObjectiveFinish= {},

}





this.missionObjectiveEnum = Tpp.Enum{
	"s10041_marker_village",
	"marker_meetingPoint",
	"marker_meetingPointIntel",
	"marker_villageVip",
	"marker_fieldVip",
	"marker_enemyBaseVip",
	"deleteMeetingMarker",
	"target_vip_village",
	"target_vip_field",
	"target_vip_enemyBase",
	"rv_missionClear",
	"default_photo_meetingPoint",
	"default_photo_fieldVip",
	"default_photo_villageVip",
	"default_photo_enemyBaseVip",
	"clear_photo_meetingPoint",
	"clear_photo_fieldVip",
	"clear_photo_villageVip",
	"clear_photo_enemyBaseVip",
	"target_area_cp",
	"route_vip_field_arrival",

	"route_vip_field_arrival",
	"route_vip_field_departure",
	"route_vip_enemyBase_arrival",
	"route_vip_enemyBase_departure",

	"Area_marker_SubTarget",

	"hos_subTarget_0000",
	"hos_subTarget_0001",

	"default_subGoal",
	"escape_subGoal",

	"task0_default",
	"task1_default",
	"task2_default",
	"task3_default",
	"task4_default",
	"task5_default",
	"task6_default",
	"task0_complete",
	"task1_complete",
	"task2_complete",
	"task3_complete",
	"task4_complete",
	"task5_complete",
	"task6_complete",
	"marker_veh_s10041_VipEnemyBase",
	"marker_veh_s10041_VipField",
	"delete_veh_s10041_VipEnemyBase",
	"delete_veh_s10041_VipField",

	"announce_FirstTargetKilled",
	"announce_FirstTargetRecovered",
	"announce_SecondTargetKilled",
	"announce_SecondTargetRecovered",
	"announce_ThirdTargetKilled",
	"announce_ThirdTargetRecovered",
	"announce_AllObjectiveFinish",
	"hud_photo_field",
	"hud_photo_village",
	"hud_photo_enemyBase",
}








this.checkPointList = {
	"CHK_MissionStart",
}

this.missionStartPosition = {
	orderBoxList = {
		"box_s10041_01",
		"box_s10041_02",
		"box_s10041_03",
	},

	
	helicopterRouteList = {
		"lz_drp_ruinsNorth_S0000|rt_drp_ruinsNorth_S_0000",

  		"lz_drp_enemyBase_S0000|rt_drp_enemyBase_S_0000",
  		"lz_drp_enemyBase_N0000|rt_drp_enemyBase_N_0000",
  		"lz_drp_enemyBase_I0000|rt_drp_enemyBase_I_0000",


   		"lz_drp_field_I0000|rt_drp_field_I_0000",
  		"lz_drp_field_W0000|rt_drp_field_W_0000",
  		"lz_drp_field_N0000|rt_drp_field_N_0000",

		"lz_drp_slopedTown_E0000|rt_drp_slopedTown_E_0000",
  		"lz_drp_slopedTown_I0000|rt_drp_slopedTown_I_0000",
	}
}







function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")


	
	this.RegiserMissionSystemCallback()

	
	TppMarker.SetUpSearchTarget{
		{ gameObjectName = TARGET_FIELD_VIP_NAME, gameObjectType = "TppSoldier2", messageName = TARGET_FIELD_VIP_NAME, skeletonName = "SKL_004_HEAD", func = this.UpdateMarkerFoundFieldVip, objectives = { "hud_photo_field" } },
		{ gameObjectName = TARGET_VILLAGE_VIP_NAME, gameObjectType = "TppSoldier2", messageName = TARGET_VILLAGE_VIP_NAME, skeletonName = "SKL_004_HEAD", func = this.UpdateMarkerFoundVillageVip, objectives = { "hud_photo_village" } },
		{ gameObjectName = TARGET_ENEMYBASE_VIP_NAME, gameObjectType = "TppSoldier2", messageName = TARGET_ENEMYBASE_VIP_NAME, skeletonName = "SKL_004_HEAD", func = this.UpdateMarkerFoundenemyBaseVip, objectives = { "hud_photo_enemyBase" } },
	}
	

	TppMission.RegisterMissionSystemCallback{

			OnSetMissionFinalScore = function( missionClearType )
			
				this.checkTaskAndSpecialBonus()
			end,

		
			CheckMissionClearFunction = function()
				return TppEnemy.CheckAllTargetClear()
			end,

			OnRecovered = function( gameObjectId )
				this.checkTaskAndSpecialBonus()
			end,
	}


































	
	TppRatBird.EnableRat()
	TppRatBird.EnableBird( "TppCritterBird" )
end

function this.checkTaskAndSpecialBonus()
	
	if TppEnemy.IsRecovered("sol_vip_village") == true and (svars.isReserve_08 == false) then			
		svars.isReserve_08 = true	
		TppMission.UpdateObjective{objectives = { "announce_FirstTargetRecovered" , nil},}	
		this.UpdateAnnounceLogAchieveObjeciveCount()									
		TppMission.UpdateObjective{	objectives = { "task0_complete", "clear_photo_villageVip", nil },}
	end
	if TppEnemy.IsRecovered("sol_vip_field") == true and (svars.isReserve_09 == false) then				
		svars.isReserve_09 = true	
		TppMission.UpdateObjective{objectives = { "announce_SecondTargetRecovered" , nil},}	
		this.UpdateAnnounceLogAchieveObjeciveCount()										
		TppMission.UpdateObjective{	objectives = { "task1_complete", "clear_photo_fieldVip", nil },	}
	end

	if TppEnemy.IsRecovered("sol_vip_enemyBase") == true and (svars.isReserve_10 == false) then			
		svars.isReserve_10 = true 
		TppMission.UpdateObjective{objectives = { "announce_ThirdTargetRecovered" , nil},}	
		this.UpdateAnnounceLogAchieveObjeciveCount()									
		TppMission.UpdateObjective{	objectives = { "task2_complete", "clear_photo_enemyBaseVip", nil },	}
	end
	
	local allRecovred = true
	for index, targetName in ipairs(this.TASK_VIP_GROUP) do
		if TppEnemy.IsRecovered(targetName) == false then
			allRecovred = false
		end
	end
	if allRecovred then
		Fox.Log("#### Bonus 2 complete ####")
		TppResult.AcquireSpecialBonus{	second = { isComplete = true,},}	
	end
	this.AnnounceAllObjectiveFinish()

	
	allRecovred = true
	for index, targetName in ipairs(this.TASK_GUARD_GROUP) do
		if TppEnemy.IsRecovered(targetName) == false then
			allRecovred = false
		end
	end
	if allRecovred then
		Fox.Log("#### Bonus 1 complete ####")
		TppResult.AcquireSpecialBonus{	first = { isComplete = true,},}	
	end

	
	allRecovred = true
	for index, targetName in ipairs(this.TASK_HOSTAGE_GROUP	) do
		if TppEnemy.IsRecovered(targetName) == false then
			allRecovred = false
		end
	end
	if allRecovred then
		
		TppMission.UpdateObjective{objectives = { "task6_complete", nil },}	
	end
end


this.UpdateAnnounceLogAchieveObjeciveCount = function()
	Fox.Log("##*** s10041_sequence.UpdateAnnounceLogAchieveObjeciveCount " )
	svars.countEliminatedTarget = svars.countEliminatedTarget + 1
	Fox.Log("##***VipIsEliminated: CountOn  " .. tostring(svars.countEliminatedTarget) )
	TppUI.ShowAnnounceLog( "achieveObjectiveCount", svars.countEliminatedTarget, 3 )		
end


function this.AnnounceAllObjectiveFinish()
	local isAllVipEliminated	=	true				
	for index, enemyName in pairs(this.TASK_VIP_GROUP) do
		if	TppEnemy.IsEliminated(enemyName) == false then
			isAllVipEliminated	=	false
		end
	end

	if isAllVipEliminated == true		
			and svars.isReserve_08 == true	
			and svars.isReserve_09 == true	
			and svars.isReserve_10 == true	then 
		Fox.Log("##** AllObjectiveCompleted ####")
		
		
	end
end


function this.UpdateMarkerFoundFieldVip()
	Fox.Log("#### Found field vip ####")
	s10041_radio.FoundFieldVip()
	TppMission.UpdateObjective{
		
	
	
	
		objectives = { "target_vip_field" },
	}
end

function this.UpdateMarkerFoundVillageVip()
	Fox.Log("#### Found village vip ####")
	s10041_radio.FoundVillageVip()
	TppMission.UpdateObjective{
		
	
	
	
		objectives = { "target_vip_village" },
	}
end

function this.UpdateMarkerFoundenemyBaseVip()
	Fox.Log("#### Found enemybase vip ####")
	s10041_radio.FoundEnemyBaseVip()

	TppMission.UpdateObjective{
		
	
	
	
		objectives = { "target_vip_enemyBase" },
	}
end


sequences.Seq_GameVipAssembleVillage = {

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		Fox.Log("#### StartCastTelop ####")
		TppTelop.StartCastTelop()
		Fox.Log("#### radioGroups ####")

		local radioGroups = s10041_radio.MissionStart()
		Fox.Log("#### openig radio ##")

		if ( TppMission.IsStartFromHelispace() == true ) then	
			Fox.Log("### Player Start Game From Helicopter ###")
			this.SetUpWaitingTimerHeli()

		elseif ( TppMission.IsStartFromFreePlay() == true ) then
			Fox.Log("### Player Start Game From FreePlay ###")
			this.SetUpWaitingTimer()
		else
			Fox.Log("###*** Player Start Game From Unknown Way ###")
		end


		
		if TppSequence.GetContinueCount() > 0 then
			TppRadio.Play( radioGroups)
		end
		
		TppMission.SetHelicopterDoorOpenTime( MISSION_START_HELI_DOOR_OPEN_TIME )
		
		TppMission.UpdateObjective{
			objectives = {
				"default_photo_meetingPoint",
				"default_photo_fieldVip",
				"default_photo_villageVip",
				"default_photo_enemyBaseVip",
				"default_subGoal",
				"task0_default",
				"task1_default",
				"task2_default",
				"task3_default",
				"task4_default",
				"task5_default",
				"task6_default",

			},
		}

		
		TppMission.UpdateObjective{
			radio = {
				radioGroups = {"s0041_rtrg0010"},
			},

			radioSecond = {
				radioGroups = {  "s0041_rtrg0020" }	
			},

		
			objectives = {
				"s10041_marker_village",
				"route_vip_enemyBase_arrival",
				"route_vip_field_arrival",
			},
			options = { isMissionStart = true },
		}

		Fox.Log("#### Disp Vip car route ####")
		s10041_enemy.CheckVipRouteMarker()	
		
		Fox.Log("#### Seq_GameVipAssembleVillage ####")
		this.HighInterrogation()

		if DEBUG then	
			if svars.isSkipToConversation == true then
				local PLAYER_POS = {
					pos = { 471.570, 320.538, 1142.396 },
					rotY = -163,
				}
				TppPlayer.Warp( PLAYER_POS )
			end
		end

	end,
	Messages = function( self )
		return


		StrCode32Table {

			Timer = {
				{
					msg = "Finish",
					sender = "VipMeetingWaitTimer",
					func = function()
						Fox.Log("#### MEETING TIMEOUT ####")
						s10041_enemy.StartMeeting()
					end
				},

				nil
			},

			GameObject = {
				{
		
		
					msg = "RoutePoint2",
					func = function (nObjectId,nRouteId,nRouteNodeId,sendM)
						if	sendM == StrCode32("msgVIP_arrived") then	
							Fox.Log("#### Message:VIP_arrived ####")
							s10041_enemy.SetMeetingRoute_VIP(nObjectId)

						
						
						elseif sendM == StrCode32("EBVip_TravelCount2") then	
							Fox.Log("#### Message: EBVip_TravelCount2####")
							svars.travelCountEnemyBase	= s10041_sequence.EnemyBaseVipSequence.Lrrp36ToVillageWest		

						elseif sendM == StrCode32("EBVip_TravelCount3") then	
							Fox.Log("#### Message: EBVip_TravelCount3####")
							svars.travelCountEnemyBase	= s10041_sequence.EnemyBaseVipSequence.VillageWestToLrrp32		

						elseif sendM == StrCode32("EBVip_TravelCount4") then	
							Fox.Log("#### Message: EBVip_TravelCount4####")
							svars.travelCountEnemyBase	= s10041_sequence.EnemyBaseVipSequence.Lrrp32ToVillage		

						elseif sendM == StrCode32("EBVip_TravelCount5") then	
							Fox.Log("#### Message: EBVip_TravelCount5####")
							svars.travelCountEnemyBase	= s10041_sequence.EnemyBaseVipSequence.VillageToTravelEnd		

						elseif sendM == StrCode32("EBVip_TravelCount6") then	
							Fox.Log("#### Message: EBVip_TravelCount6####")
							svars.travelCountEnemyBase	= s10041_sequence.EnemyBaseVipSequence.ArrivedVillage		
						

						
						
						elseif sendM == StrCode32("FDVip_TravelCount2") then	
							Fox.Log("#### Message: FDVip_TravelCount2####")
							svars.travelCountField	= s10041_sequence.FieldVipSequence.Lrrp29ToFieldEast		

						elseif sendM == StrCode32("FDVip_TravelCount3") then	
							Fox.Log("#### Message: FDVip_TravelCount3####")
							svars.travelCountField	= s10041_sequence.FieldVipSequence.FieldEastToLrrp01		

						elseif sendM == StrCode32("FDVip_TravelCount4") then	
							Fox.Log("#### Message: FDVip_TravelCount4####")
							svars.travelCountField	= s10041_sequence.FieldVipSequence.Lrrp01ToVillageEast		

						elseif sendM == StrCode32("FDVip_TravelCount5") then	
							Fox.Log("#### Message: FDVip_TravelCount5####")
							svars.travelCountField	= s10041_sequence.FieldVipSequence.VillageEastToLrrp32		

						elseif sendM == StrCode32("FDVip_TravelCount6") then	
							Fox.Log("#### Message: FDVip_TravelCount6####")
							svars.travelCountField	= s10041_sequence.FieldVipSequence.Lrrp32ToVillage		

						elseif sendM == StrCode32("FDVip_TravelCount7") then	
							Fox.Log("#### Message: FDVip_TravelCount7####")
							svars.travelCountField	= s10041_sequence.FieldVipSequence.VillageToTravelEnd		

						elseif sendM == StrCode32("FDVip_TravelCount8") then	
							Fox.Log("#### Message: FDVip_TravelCount8####")
							svars.travelCountField	= s10041_sequence.FieldVipSequence.ArrivedVillage		

						
						













						elseif sendM == StrCode32("VipEB_isVigilance") then
							
							Fox.Log("####Messgae: VipEB_isVigilance ####")
							s10041_enemy.SetRelativeVehicleVigilance("veh_s10041_VipEnemyBase")				

						elseif sendM == StrCode32("VipFD_isVigilance") then
							
							Fox.Log("####Messgae: VipFD_isVigilance ####")
							s10041_enemy.SetRelativeVehicleVigilance("veh_s10041_VipField")							

						elseif sendM == StrCode32("HideInVillageWest") then										
							Fox.Log("#### Message: HideInVillageWest####")
							if	svars.isCancelMeetingEnemyBaseVip == true	then								
								Fox.Log("#### Meeting got canceled, HideInVillageWest ####")
								s10041_enemy.SetEnemyBaseVIPRoutesInVillageWest( nObjectId )					
							else																					
								Fox.Log("#### NormalTravel NoNeed HideInVillageWest ####")
							end

						elseif sendM == StrCode32("HideInFieldEast") then										
							Fox.Log("#### Message: HideInFieldEast####")
							if	svars.isCancelMeetingFieldVip == true	then									
								Fox.Log("#### Meeting got canceled, HideInFieldEast ####")
								s10041_enemy.SetFieldVIPRoutesInFieldEast( nObjectId )						
							else																				
								Fox.Log("#### NormalTravel NoNeed HideInFieldEast ####")
							end

						elseif sendM == StrCode32("HideInVillageEast") then									
							Fox.Log("#### Message: HideInVillageEast####")
							if	svars.isCancelMeetingFieldVip == true	then									
								Fox.Log("#### Meeting got canceled, HideInVillageEast ####")
								s10041_enemy.SetFieldVIPRoutesInVillageEast( nObjectId )						
							else																				
								Fox.Log("#### NormalTravel NoNeed HideInVillageEast ####")
							end

						elseif sendM == StrCode32("msgVIPwaiting") then	
					
					

						elseif sendM == StrCode32("msgVIPConvStart") then
							TppSequence.SetNextSequence( "Seq_CONVERSATION" )		
							
						
							Fox.Log( "*** msgVIPConvStart ***")
						
						elseif sendM == StrCode32("msgVIPtimeout") then	

						elseif sendM == StrCode32( "set_lrrp_04_32_sneak" ) then		
							Fox.Log( "**## EB group start to join villageCP set_lrrp_04_32_sneak ***")
							local cpId = GameObject.GetGameObjectId( "TppCommandPost2", "afgh_04_32_lrrp" )
							local command = { id = "SetPhase", phase=0 }
							GameObject.SendCommand( cpId, command )
						elseif sendM == StrCode32( "set_lrrp_01_32_sneak" ) then		
							Fox.Log( "**## EB group start to join villageCP set_lrrp_01_32_sneak ***")
							local cpId = GameObject.GetGameObjectId( "TppCommandPost2", "afgh_01_32_lrrp" )
							local command = { id = "SetPhase", phase=0 }
							GameObject.SendCommand( cpId, command )
						else

						end
					end
				},
			
			
			
			
			
			
			
			
			
				{
					msg = "ConversationEnd",
					func = function( cpGameObjectId, speechLabel, isSuccess )
						Fox.Log( "this.Messages(): ConversationEnd Message Received. gameObjectId:" ..
							tostring( gameObjectId ) .. ", speechLabel:" .. tostring( speechLabel ) .. ", isSuccess:" .. isSuccess )

						if isSuccess ~= 0 then
						end
						













						
						if speechLabel == StrCode32( "CT10041_06" ) then
							Fox.Log( "**## TimeOut_villageVip_MonologueEND!!! ***")
							s10041_enemy.EndMeeting()
						end
						
						if speechLabel == StrCode32( "CT10041_07" ) then
							Fox.Log( "**## TimeOut_EnemyBaseVip_MonologueEND!!! ***")
							s10041_enemy.EndMeeting()
						end
						
						if speechLabel == StrCode32( "CT10041_05" ) then
							Fox.Log( "**## TimeOut_FieldVip_MonologueEND!!! ***")
							s10041_enemy.EndMeeting()
						end
					end
				},
				{
					
					msg = "ChangePhase",
					

					sender = { s10041_enemy.ENEMY_NAME.FIELD_VIP, s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP, s10041_enemy.ENEMY_NAME.VILLAGE_VIP,
					s10041_enemy.ENEMY_NAME.ENEMYBASE_DRIVER, s10041_enemy.ENEMY_NAME.ENEMYBASE_GUARD_00,
					s10041_enemy.ENEMY_NAME.FIELD_DRIVER, s10041_enemy.ENEMY_NAME.FIELD_GUARD_00 },

					func = function ( GameObjectId, phaseName )
						if ( phaseName >= TppEnemy.PHASE.ALERT) then
							if GameObjectId == GameObject.GetGameObjectId( s10041_enemy.ENEMY_NAME.FIELD_VIP) and
									svars.isCancelMeetingFieldVip == false then
								Fox.Log( "*** field vip change phase ***")
								s10041_enemy.CancelTravelFieldVip(phaseName)

							elseif GameObjectId == GameObject.GetGameObjectId( s10041_enemy.ENEMY_NAME.FIELD_DRIVER) and
									svars.isCancelMeetingFieldVip == false then
								Fox.Log( "*** field Driver change phase ***")
								s10041_enemy.CancelTravelFieldVip(phaseName)

							elseif GameObjectId == GameObject.GetGameObjectId( s10041_enemy.ENEMY_NAME.FIELD_GUARD_00) and
									svars.isCancelMeetingFieldVip == false then
								Fox.Log( "*** field Guard change phase ***")
								s10041_enemy.CancelTravelFieldVip(phaseName)

							elseif GameObjectId == GameObject.GetGameObjectId( s10041_enemy.ENEMY_NAME.ENEMYBASE_VIP) and
									svars.isCancelMeetingEnemyBaseVip == false then
								Fox.Log( "*** emenybase vip change phase ***")
								s10041_enemy.CancelTravelEnemyBaseVip(phaseName)

							elseif GameObjectId == GameObject.GetGameObjectId( s10041_enemy.ENEMY_NAME.ENEMYBASE_DRIVER) and
									svars.isCancelMeetingEnemyBaseVip == false then
								Fox.Log( "*** emenybase vip change phase ***")
								s10041_enemy.CancelTravelEnemyBaseVip(phaseName)

							elseif GameObjectId == GameObject.GetGameObjectId( s10041_enemy.ENEMY_NAME.ENEMYBASE_GUARD_00) and
									svars.isCancelMeetingEnemyBaseVip == false then
								Fox.Log( "*** emenybase vip change phase ***")
								s10041_enemy.CancelTravelEnemyBaseVip(phaseName)
							else
							end
						end

						if ( phaseName >= TppEnemy.PHASE.CAUTION) then
							if GameObjectId == GameObject.GetGameObjectId( s10041_enemy.ENEMY_NAME.VILLAGE_VIP) then
								Fox.Log( "*** village vip change phase ***")
								s10041_enemy.CpRadioVillageMain()
								s10041_enemy.AbortMeeting(phaseName)
						
						
						
							else 
							

							end
						else
						end
					end
				},
			},
		}
	end,
	OnLeave = function ()

	end,

}
sequences.Seq_CONVERSATION = {
	OnEnter = function()
		Fox.Log("#### Seq_CONVERSATION####")

		s10041_enemy.StartMeeting()	
		this.DeleteHighInterrogationBeforeMeeting()

		if TppSequence.GetContinueCount() == 0 then	
				Fox.Log("#### Seq_CONVERSATION first time ####")

			
		else	
			Fox.Log("#### Seq_CONVERSATION continue ####")

			local radioGroups = s10041_radio.SetContinueRadio()	
			TppRadio.Play(radioGroups)
		end
	end,
	Messages = function( self )
		return
		StrCode32Table {

			Subtitles = {
				{
					
					msg = "SubtitlesEndEventMessage",
					func = function( speechLabel, status )
						Fox.Log( "*** ####SubtitlesEndEventMessage ####***")
					
					
					
					
						if (speechLabel == SubtitlesCommand:ConvertToSubtitlesId( "grug5000_241010_0_enec_ru" )) then 
							svars.isRadioHearMeeting=true	
							TppMission.UpdateObjective{objectives = { "task5_complete" },}	
						end
					end
				},
			},

			GameObject = {
				{
					
					msg = "ConversationEnd",
					func = function( cpGameObjectId, speechLabel, isSuccess )
						Fox.Log( "this.Messages(): ConversationEnd Message Received. gameObjectId:" ..
							tostring( gameObjectId ) .. ", speechLabel:" .. tostring( speechLabel ) .. ", isSuccess:" .. isSuccess )
						Fox.Log( "*** ConversationEnd ***")

						if speechLabel ==s10041_enemy.voiceTable.Cancel.villageVip 
								or speechLabel ==s10041_enemy.voiceTable.Cancel.fieldVip
								or speechLabel ==s10041_enemy.voiceTable.Cancel.enemyBaseVip  then

							if speechLabel ==s10041_enemy.voiceTable.Cancel.villageVip then
								s10041_enemy.CpRadioVillageMain()
								return
							end
							if speechLabel ==s10041_enemy.voiceTable.Cancel.fieldVip  then
								s10041_enemy.CpRadioFieldVip()
								return
							end
							if speechLabel ==s10041_enemy.voiceTable.Cancel.enemyBaseVip  then
								s10041_enemy.CpRadioEnemyBaseVip()
								return
							end
						else
						
						
						
							this.meetingManager()
						end
					end
				},

		
		





















			},
		}
	end,
	OnLeave = function ()

	end,



}





sequences.Seq_GameEscape = {


	OnEnter = function()

		Fox.Log("#### Seq_GameEscape ####")
		this.HighInterrogation()

		TppMission.CanMissionClear()
		

		local radioGroups = s10041_radio.EscapeStartRadio()
		TppRadio.Play( radioGroups, { delayTime = "mid", isEnqueue = true } )


		
		TppMission.UpdateObjective{

		





			
			objectives = { "clear_photo_meetingPoint","escape_subGoal",nil },		
		}



		TppUiCommand.ShowHotZone()		
		TppRadio.SetOptionalRadio( "Set_s0041_oprg0030" )	
		TppRadio.ChangeIntelRadio( s10041_radio.intelRadioListAbortMeeting )


	end,

}



function this.OnEstablishMissionClear( missionClearType )
	Fox.Log("*** " .. tostring(missionClearType) .. " OnEstablishMissionClear ***")




	
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

	local isRadioVipFullton= s10041_enemy.CheckVipLife()

	if svars.isRadioHearMeeting == false then	
		if isRadioVipFullton == true then	
			s10041_radio.TelephoneRadioVipFullton()
		else										
			s10041_radio.TelephoneRadioAllVipDeid()
		end
	else										
		if svars.isReturn_fieldVip == true or	
			svars.isReturn_enemyBaseVip == true then	
			s10041_radio.TelephoneRadioSetMine()
		else
			s10041_radio.TelephoneRadioMeetingFinished()
		end
	end

	

end


function this.RegiserMissionSystemCallback()
	Fox.Log("*** RegiserMissionSystemCallback ***")


	local systemCallbackTable ={
		OnEstablishMissionClear = this.OnEstablishMissionClear,
		nil
	}

	
	TppMission.RegisterMissionSystemCallback(systemCallbackTable)

end




return this