local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table

local sequences = {}
local TimerStart = GkEventTimerManager.Start



local TARGET_ENEMY_NAME		= "sol_target_0000"
local SUPPORT_HELI			= "SupportHeli"			
local ENEMY_HELI			= "EnemyHeli"			

local EVENT_DOOR_BOY		= "mafr_gate002_vrtn002_gim_n0001|srt_mafr_gate002_vrtn002"
local EVENT_DOOR_DEMO		= "mafr_gate002_vrtn001_gim_n0000|srt_mafr_gate002_vrtn001"
local EVENT_DOOR_PATH		= "/Assets/tpp/level/location/mafr/block_large/diamond/mafr_diamond_gimmick.fox2"
local CAVE_DOOR_DATA		= "mafr_gate002_vrtn002_gim_n0003|srt_mafr_gate002_vrtn002"	
local CAVE_DOOR_PATH		= "/Assets/tpp/level/location/mafr/block_large/diamond/mafr_diamond_gimmick.fox2"	

local NORMAL_DOOR_A			= "mafr_fenc005_door001_gim_n0000|srt_mafr_fenc005_door001"
local NORMAL_DOOR_B			= "mafr_fenc005_door001_gim_n0001|srt_mafr_fenc005_door001"
local NORMAL_DOOR_C			= "mafr_gate002_vrtn002_gim_n0002|srt_mafr_gate002_vrtn002"
local NORMALE_DOOR_PATH		= "/Assets/tpp/level/location/mafr/block_large/diamond/mafr_diamond_gimmick.fox2"

local CHECK_ENEMY_POS		= {1427.132, 126.410, -1519.600} 
local CHECK_ENEMY_RANGE		= 30	


local AllTarget_CNT			= 6

local SNIPER_CNT			= 5

local gameObjectType_boy	= "TppHostageUnique"
local TARGET_INJURY_BOY 	= "hos_diamond_0000"	
local TARGET_NORMAL_BOY_A	= "hos_diamond_0001"	
local TARGET_NORMAL_BOY_B	= "hos_diamond_0002"	
local TARGET_NORMAL_BOY_C	= "hos_diamond_0003"	
local TARGET_NORMAL_BOY_D	= "hos_diamond_0004"	
local ORDER_ENABLE_RANGE	= 20					
local ORDER_IGNORE_RANGE	= 25					
local INJURY_BOY_RANGE		= 10					
local TIME_DISTANCE_CHECK	= 10					

local DIA_ADD_ENEMY_A		= "sol_diamondSouth_0000"
local DIA_ADD_ENEMY_B		= "sol_diamondSouth_0001"
local DIA_ADD_ENEMY_C		= "sol_diamondSouth_0002"
local DIA_ADD_ENEMY_D		= "sol_diamondSouth_0003"
local DIA_ADD_ENEMY_E		= "sol_diamondSouth_0004"
local DIA_ADD_ENEMY_F		= "sol_diamondSouth_0005"


this.MAX_PICKABLE_LOCATOR_COUNT = 35

this.MAX_PLACED_LOCATOR_COUNT = 50



this.REVENGE_MINE_LIST = {}
if TppLocation.IsMiddleAfrica() then
this.REVENGE_MINE_LIST = {"mafr_banana","mafr_diamond"}
this.MISSION_REVENGE_MINE_LIST = {
	["mafr_banana"] = {
		
		["trap_mafr_banana_mine_east"] = {
			mineLocatorList = {
				"itm_revMine_banana_a_0013",
				"itm_revMine_banana_a_0014",
			},
		},
		["trap_mafr_banana_mine_south"] = {
			mineLocatorList = {
				"itm_revMine_banana_a_0010",
				"itm_revMine_banana_a_0011",
				"itm_revMine_banana_a_0012",
			},
		},
		
		decoyLocatorList = {
			"itm_revDecoy_banana_a_0005",
			"itm_revDecoy_banana_a_0006",
		},
	},
	["mafr_diamond"] = {
		
		["trap_mafr_diamond_mine_north"] = {
			mineLocatorList = {
				"itm_revMine_diamond_a_0010",
			},
		},
		["trap_mafr_diamond_mine_west"] = {
			mineLocatorList = {
				"itm_revMine_diamond_a_0011",
				"itm_revMine_diamond_a_0012",
				"itm_revMine_diamond_a_0013",
				"itm_revMine_diamond_a_0014",
			},
		},
		
		decoyLocatorList = {
			"itm_revDecoy_diamond_a_0005",
			"itm_revDecoy_diamond_a_0006",
		},
	},
}
end



if TppLocation.IsMiddleAfrica() then
this.VARIABLE_TRAP_SETTING = {
	{ name = "trap_CHK_s10100_01", type = TppDefine.TRAP_TYPE.NORMAL , initialState = TppDefine.TRAP_STATE.DISABLE, },
	{ name = "trap_CHK_s10100_02", type = TppDefine.TRAP_TYPE.NORMAL , initialState = TppDefine.TRAP_STATE.DISABLE, },
	{ name = "trap_CHK_s10100_03", type = TppDefine.TRAP_TYPE.NORMAL , initialState = TppDefine.TRAP_STATE.DISABLE, },
	{ name = "trap_CHK_s10100_04", type = TppDefine.TRAP_TYPE.NORMAL , initialState = TppDefine.TRAP_STATE.DISABLE, },
	{ name = "trap_CHK_s10100_05", type = TppDefine.TRAP_TYPE.NORMAL , initialState = TppDefine.TRAP_STATE.DISABLE, }
}
end




this.command_A0000_move = {	id = "SetSneakRoute",	route = "rts_boyA_0000_move",	}
this.command_A0000_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0000_wait",	}
this.command_A0001_move = {	id = "SetSneakRoute",	route = "rts_boyA_0001_move",	}
this.command_A0001_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0001_wait",	}
this.command_A0002_move = {	id = "SetSneakRoute",	route = "rts_boyA_0002_move",	}
this.command_A0002_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0002_wait",	}
this.command_A0003_move = {	id = "SetSneakRoute",	route = "rts_boyA_0003_move",	}
this.command_A0003_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0003_wait",	}
this.command_A0004_move = {	id = "SetSneakRoute",	route = "rts_boyA_0004_move",	}
this.command_A0004_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0004_wait",	}
this.command_A0005_move = {	id = "SetSneakRoute",	route = "rts_boyA_0005_move",	}
this.command_A0005_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0005_wait",	}
this.command_A0006_move = {	id = "SetSneakRoute",	route = "rts_boyA_0006_move",	}
this.command_A0006_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0006_wait",	}
this.command_A0007_move = {	id = "SetSneakRoute",	route = "rts_boyA_0007_move",	}
this.command_A0007_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0007_wait",	}
this.command_A0008_move = {	id = "SetSneakRoute",	route = "rts_boyA_0008_move",	}
this.command_A0008_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0008_wait",	}
this.command_A0009_move = {	id = "SetSneakRoute",	route = "rts_boyA_0009_move",	}
this.command_A0009_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0009_wait",	}
this.command_A0010_move = {	id = "SetSneakRoute",	route = "rts_boyA_0010_move",	}
this.command_A0010_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0010_wait",	}
this.command_A0011_move = {	id = "SetSneakRoute",	route = "rts_boyA_0011_move",	}
this.command_A0011_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0011_wait",	}
this.command_A0012_move = {	id = "SetSneakRoute",	route = "rts_boyA_0012_move",	}
this.command_A0012_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0012_wait",	}
this.command_A0013_move = {	id = "SetSneakRoute",	route = "rts_boyA_0013_move",	}
this.command_A0013_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0013_wait",	}
this.command_A0014_move = {	id = "SetSneakRoute",	route = "rts_boyA_0014_move",	}
this.command_A0014_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0014_wait",	}
this.command_A0015_move = {	id = "SetSneakRoute",	route = "rts_boyA_0015_move",	}
this.command_A0015_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0015_wait",	}
this.command_A0016_move = {	id = "SetSneakRoute",	route = "rts_boyA_0016_move",	}
this.command_A0016_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0016_wait",	}
this.command_A0017_move = {	id = "SetSneakRoute",	route = "rts_boyA_0017_move",	}
this.command_A0017_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0017_wait",	}
this.command_A0018_move = {	id = "SetSneakRoute",	route = "rts_boyA_0018_move",	}
this.command_A0018_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0018_wait",	}
this.command_A0019_move = {	id = "SetSneakRoute",	route = "rts_boyA_0019_move",	}
this.command_A0019_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0019_wait",	}
this.command_A0020_move = {	id = "SetSneakRoute",	route = "rts_boyA_0020_move",	}
this.command_A0020_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0020_wait",	}
this.command_A0021_move = {	id = "SetSneakRoute",	route = "rts_boyA_0021_move",	}
this.command_A0021_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0021_wait",	}
this.command_A0022_move = {	id = "SetSneakRoute",	route = "rts_boyA_0022_move",	}
this.command_A0022_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0022_wait",	}
this.command_A0023_move = {	id = "SetSneakRoute",	route = "rts_boyA_0023_move",	}
this.command_A0023_wait = {	id = "SetSneakRoute",	route = "rts_boyA_0023_wait",	}
this.command_A0024_move = {	id = "SetSneakRoute",	route = "rts_boyA_0024_move",	}

this.command_A0024_wait = {	id = "SetSneakRoute",	route = "",	}

this.command_B0000_move = {	id = "SetSneakRoute",	route = "rts_boyB_0000_move",	}
this.command_B0000_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0000_wait",	}
this.command_B0001_move = {	id = "SetSneakRoute",	route = "rts_boyB_0001_move",	}
this.command_B0001_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0001_wait",	}
this.command_B0002_move = {	id = "SetSneakRoute",	route = "rts_boyB_0002_move",	}
this.command_B0002_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0002_wait",	}
this.command_B0003_move = {	id = "SetSneakRoute",	route = "rts_boyB_0003_move",	}
this.command_B0003_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0003_wait",	}
this.command_B0004_move = {	id = "SetSneakRoute",	route = "rts_boyB_0004_move",	}
this.command_B0004_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0004_wait",	}
this.command_B0005_move = {	id = "SetSneakRoute",	route = "rts_boyB_0005_move",	}
this.command_B0005_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0005_wait",	}
this.command_B0006_move = {	id = "SetSneakRoute",	route = "rts_boyB_0006_move",	}
this.command_B0006_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0006_wait",	}
this.command_B0007_move = {	id = "SetSneakRoute",	route = "rts_boyB_0007_move",	}
this.command_B0007_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0007_wait",	}
this.command_B0008_move = {	id = "SetSneakRoute",	route = "rts_boyB_0008_move",	}
this.command_B0008_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0008_wait",	}
this.command_B0009_move = {	id = "SetSneakRoute",	route = "rts_boyB_0009_move",	}
this.command_B0009_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0009_wait",	}
this.command_B0010_move = {	id = "SetSneakRoute",	route = "rts_boyB_0010_move",	}
this.command_B0010_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0010_wait",	}
this.command_B0011_move = {	id = "SetSneakRoute",	route = "rts_boyB_0011_move",	}
this.command_B0011_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0011_wait",	}
this.command_B0012_move = {	id = "SetSneakRoute",	route = "rts_boyB_0012_move",	}
this.command_B0012_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0012_wait",	}
this.command_B0013_move = {	id = "SetSneakRoute",	route = "rts_boyB_0013_move",	}
this.command_B0013_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0013_wait",	}
this.command_B0014_move = {	id = "SetSneakRoute",	route = "rts_boyB_0014_move",	}
this.command_B0014_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0014_wait",	}
this.command_B0015_move = {	id = "SetSneakRoute",	route = "rts_boyB_0015_move",	}
this.command_B0015_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0015_wait",	}
this.command_B0016_move = {	id = "SetSneakRoute",	route = "rts_boyB_0016_move",	}
this.command_B0016_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0016_wait",	}
this.command_B0017_move = {	id = "SetSneakRoute",	route = "rts_boyB_0017_move",	}
this.command_B0017_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0017_wait",	}
this.command_B0018_move = {	id = "SetSneakRoute",	route = "rts_boyB_0018_move",	}
this.command_B0018_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0018_wait",	}
this.command_B0019_move = {	id = "SetSneakRoute",	route = "rts_boyB_0019_move",	}
this.command_B0019_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0019_wait",	}
this.command_B0020_move = {	id = "SetSneakRoute",	route = "rts_boyB_0020_move",	}
this.command_B0020_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0020_wait",	}
this.command_B0021_move = {	id = "SetSneakRoute",	route = "rts_boyB_0021_move",	}
this.command_B0021_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0021_wait",	}
this.command_B0022_move = {	id = "SetSneakRoute",	route = "rts_boyB_0022_move",	}
this.command_B0022_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0022_wait",	}
this.command_B0023_move = {	id = "SetSneakRoute",	route = "rts_boyB_0023_move",	}
this.command_B0023_wait = {	id = "SetSneakRoute",	route = "rts_boyB_0023_wait",	}
this.command_B0024_move = {	id = "SetSneakRoute",	route = "rts_boyB_0024_move",	}

this.command_B0024_wait = {	id = "SetSneakRoute",	route = "",	}

this.command_C0000_move = {	id = "SetSneakRoute",	route = "rts_boyC_0000_move",	}
this.command_C0000_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0000_wait",	}
this.command_C0001_move = {	id = "SetSneakRoute",	route = "rts_boyC_0001_move",	}
this.command_C0001_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0001_wait",	}
this.command_C0002_move = {	id = "SetSneakRoute",	route = "rts_boyC_0002_move",	}
this.command_C0002_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0002_wait",	}
this.command_C0003_move = {	id = "SetSneakRoute",	route = "rts_boyC_0003_move",	}
this.command_C0003_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0003_wait",	}
this.command_C0004_move = {	id = "SetSneakRoute",	route = "rts_boyC_0004_move",	}
this.command_C0004_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0004_wait",	}
this.command_C0005_move = {	id = "SetSneakRoute",	route = "rts_boyC_0005_move",	}
this.command_C0005_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0005_wait",	}
this.command_C0006_move = {	id = "SetSneakRoute",	route = "rts_boyC_0006_move",	}
this.command_C0006_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0006_wait",	}
this.command_C0007_move = {	id = "SetSneakRoute",	route = "rts_boyC_0007_move",	}
this.command_C0007_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0007_wait",	}
this.command_C0008_move = {	id = "SetSneakRoute",	route = "rts_boyC_0008_move",	}
this.command_C0008_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0008_wait",	}
this.command_C0009_move = {	id = "SetSneakRoute",	route = "rts_boyC_0009_move",	}
this.command_C0009_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0009_wait",	}
this.command_C0010_move = {	id = "SetSneakRoute",	route = "rts_boyC_0010_move",	}
this.command_C0010_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0010_wait",	}
this.command_C0011_move = {	id = "SetSneakRoute",	route = "rts_boyC_0011_move",	}
this.command_C0011_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0011_wait",	}
this.command_C0012_move = {	id = "SetSneakRoute",	route = "rts_boyC_0012_move",	}
this.command_C0012_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0012_wait",	}
this.command_C0013_move = {	id = "SetSneakRoute",	route = "rts_boyC_0013_move",	}
this.command_C0013_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0013_wait",	}
this.command_C0014_move = {	id = "SetSneakRoute",	route = "rts_boyC_0014_move",	}
this.command_C0014_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0014_wait",	}
this.command_C0015_move = {	id = "SetSneakRoute",	route = "rts_boyC_0015_move",	}
this.command_C0015_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0015_wait",	}
this.command_C0016_move = {	id = "SetSneakRoute",	route = "rts_boyC_0016_move",	}
this.command_C0016_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0016_wait",	}
this.command_C0017_move = {	id = "SetSneakRoute",	route = "rts_boyC_0017_move",	}
this.command_C0017_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0017_wait",	}
this.command_C0018_move = {	id = "SetSneakRoute",	route = "rts_boyC_0018_move",	}
this.command_C0018_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0018_wait",	}
this.command_C0019_move = {	id = "SetSneakRoute",	route = "rts_boyC_0019_move",	}
this.command_C0019_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0019_wait",	}
this.command_C0020_move = {	id = "SetSneakRoute",	route = "rts_boyC_0020_move",	}
this.command_C0020_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0020_wait",	}
this.command_C0021_move = {	id = "SetSneakRoute",	route = "rts_boyC_0021_move",	}
this.command_C0021_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0021_wait",	}
this.command_C0022_move = {	id = "SetSneakRoute",	route = "rts_boyC_0022_move",	}
this.command_C0022_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0022_wait",	}
this.command_C0023_move = {	id = "SetSneakRoute",	route = "rts_boyC_0023_move",	}
this.command_C0023_wait = {	id = "SetSneakRoute",	route = "rts_boyC_0023_wait",	}
this.command_C0024_move = {	id = "SetSneakRoute",	route = "rts_boyC_0024_move",	}

this.command_C0024_wait = {	id = "SetSneakRoute",	route = "",	}

this.command_D0000_move = {	id = "SetSneakRoute",	route = "rts_boyD_0000_move",	}
this.command_D0000_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0000_wait",	}
this.command_D0001_move = {	id = "SetSneakRoute",	route = "rts_boyD_0001_move",	}
this.command_D0001_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0001_wait",	}
this.command_D0002_move = {	id = "SetSneakRoute",	route = "rts_boyD_0002_move",	}
this.command_D0002_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0002_wait",	}
this.command_D0003_move = {	id = "SetSneakRoute",	route = "rts_boyD_0003_move",	}
this.command_D0003_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0003_wait",	}
this.command_D0004_move = {	id = "SetSneakRoute",	route = "rts_boyD_0004_move",	}
this.command_D0004_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0004_wait",	}
this.command_D0005_move = {	id = "SetSneakRoute",	route = "rts_boyD_0005_move",	}
this.command_D0005_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0005_wait",	}
this.command_D0006_move = {	id = "SetSneakRoute",	route = "rts_boyD_0006_move",	}
this.command_D0006_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0006_wait",	}
this.command_D0007_move = {	id = "SetSneakRoute",	route = "rts_boyD_0007_move",	}
this.command_D0007_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0007_wait",	}
this.command_D0008_move = {	id = "SetSneakRoute",	route = "rts_boyD_0008_move",	}
this.command_D0008_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0008_wait",	}
this.command_D0009_move = {	id = "SetSneakRoute",	route = "rts_boyD_0009_move",	}
this.command_D0009_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0009_wait",	}
this.command_D0010_move = {	id = "SetSneakRoute",	route = "rts_boyD_0010_move",	}
this.command_D0010_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0010_wait",	}
this.command_D0011_move = {	id = "SetSneakRoute",	route = "rts_boyD_0011_move",	}
this.command_D0011_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0011_wait",	}
this.command_D0012_move = {	id = "SetSneakRoute",	route = "rts_boyD_0012_move",	}
this.command_D0012_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0012_wait",	}
this.command_D0013_move = {	id = "SetSneakRoute",	route = "rts_boyD_0013_move",	}
this.command_D0013_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0013_wait",	}
this.command_D0014_move = {	id = "SetSneakRoute",	route = "rts_boyD_0014_move",	}
this.command_D0014_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0014_wait",	}
this.command_D0015_move = {	id = "SetSneakRoute",	route = "rts_boyD_0015_move",	}
this.command_D0015_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0015_wait",	}
this.command_D0016_move = {	id = "SetSneakRoute",	route = "rts_boyD_0016_move",	}
this.command_D0016_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0016_wait",	}
this.command_D0017_move = {	id = "SetSneakRoute",	route = "rts_boyD_0017_move",	}
this.command_D0017_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0017_wait",	}
this.command_D0018_move = {	id = "SetSneakRoute",	route = "rts_boyD_0018_move",	}
this.command_D0018_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0018_wait",	}
this.command_D0019_move = {	id = "SetSneakRoute",	route = "rts_boyD_0019_move",	}
this.command_D0019_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0019_wait",	}
this.command_D0020_move = {	id = "SetSneakRoute",	route = "rts_boyD_0020_move",	}
this.command_D0020_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0020_wait",	}
this.command_D0021_move = {	id = "SetSneakRoute",	route = "rts_boyD_0021_move",	}
this.command_D0021_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0021_wait",	}
this.command_D0022_move = {	id = "SetSneakRoute",	route = "rts_boyD_0022_move",	}
this.command_D0022_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0022_wait",	}
this.command_D0023_move = {	id = "SetSneakRoute",	route = "rts_boyD_0023_move",	}
this.command_D0023_wait = {	id = "SetSneakRoute",	route = "rts_boyD_0023_wait",	}
this.command_D0024_move = {	id = "SetSneakRoute",	route = "rts_boyD_0024_move",	}

this.command_D0024_wait = {	id = "SetSneakRoute",	route = "",	}



this.missionObjectiveEnum = Tpp.Enum {
	"default_area_banana",
	"default_area_banana_2nd",
	"reduce_area_banana",
	"reduce_area_banana_2nd",
	"default_boySoldiers",
	"reduce_boySoldiers",
	"target_banana",
	"target_boyHostage01",
	"target_boyHostage02",
	"target_boyHostage03",	
	"target_boyHostage04",
	"target_boyHostage05",
	"rv_diamond",
	"default_photo_bananaTarget",
	"clear_photo_bananaTarget",
	"default_photo_diamond",
	"clear_photo_diamond",
	"default_subGoal",
	"bananaTargetClear_subGoal",
	"boyHostages_subGoal",	
	"bananaTarget_subGoal",
	"escape_subGoal",
	"missionTask_1_bananaTarget",
	"missionTask_1_bananaTarget_clear",
	"missionTask_2_diamondTarget",
	"missionTask_2_diamondTarget_clear",
	"missionTask_3_boyHostages_hide",
	"missionTask_3_boyHostages",
	"missionTask_3_boyHostages_clear",
	"missionTask_4_bananaTarget_collect",	
	"missionTask_4_bananaTarget_collect_clear",
	"missionTask_5_perfectEscape",
	"missionTask_5_perfectEscape_clear",
	"missionTask_6_BrokenEnemyHeli",
	"missionTask_6_BrokenEnemyHeli_clear",
	"missionTask_7_sniperAllCollect",
	"missionTask_7_sniperAllCollect_clear",
	"missionTask_8_AcpAllCollect",
	"missionTask_8_AcpAllCollect_clear",
	"subTask_ACP01",	
	"subTask_ACP02",
	"subTask_ACP03",
	"reduce_boySoldiers_interro",
	"snipaerA_Area",
	"snipaerB_Area",
	"log_targetEliminate",
	"log_targetRecover",
	"log_targetRecover_b01",
	"log_targetRecover_b02",
	"log_targetRecover_b03",	
	"log_targetRecover_b04",
	"log_targetRecover_b05",
	"log_achieveObjective",
}





local boyHostagesName_TABLE = {
	TARGET_NORMAL_BOY_A,
	TARGET_NORMAL_BOY_B,
	TARGET_NORMAL_BOY_C,
	TARGET_NORMAL_BOY_D,
}

local cpId_TABLE = {
	"s10100_sniperA_cp",
	"s10100_sniperB_cp",
	"mafr_banana_cp",
	"mafr_diamond_cp",
	"mafr_diamondSwamp_cp",
	"mafr_diamondRiver_cp",
	"mafr_tracking_cp",
	"mafr_bananaEast_ob",
	"mafr_bananaSouth_ob",
	"mafr_diamondNorth_ob",
	"mafr_diamondSouth_ob",
	"mafr_diamondWest_ob",
	"mafr_savannahNorth_ob",
	"mafr_savannahWest_ob",
	"mafr_04_25_lrrp",
	"mafr_04_07_lrrp",
	"mafr_04_09_lrrp",
	"mafr_07_09_lrrp",
	"mafr_08_10_lrrp",
	"mafr_08_25_lrrp",
	"mafr_09_25_lrrp",
	"mafr_10_11_lrrp",
	"mafr_10_26_lrrp",
	"mafr_18_26_lrrp",
	"s10100_wavAreaOut_cp",
}

this.specialBonus = {
        first = {
                missionTask = { taskNo = 3 },
        },
        second = {
                missionTask = { taskNo = 4 },
        }
}



this.ENABLE_DEFAULT_HELI_MISSION_CLEAR = true








function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences{
		
		"Seq_Game_BeforeRescueBoy",			
		"Seq_Game_AfterRescueBoy",			
		"Seq_Game_Escape",					
		
		"Seq_Demo_Brank",					
		"Seq_Demo_MeetBoySoldier",			
		nil
	}
	TppSequence.RegisterSequenceTable(sequences)
end





this.saveVarsList = {
	isTargetClear			= false,			
	isTargetAttestation		= false,			
	isTargetInterrogation	= false,			
	isEnemyHeliClear		= false,			
	isAarClear				= false,			
	
	isFallDown					= false,		
	isSurprise					= false,		
	isPrisonBreak				= false,		
	isBoyOnHeli					= false,		
	isBoyHostagesCount_arrival	= 0,			
	isBoyHostagesCount_clear	= 0,			
	isBoyHostagesProgress		= 0,			
	isPassPointProgress			= 0,			
	isBoyHostagesCount_noMove	= 4,			
	isOrderApproval				= false,		
	isBoyHostagesRC_inCave01	= false,		
	isBoyHostages_AutoMoveStop_01	= false,	
	isBoyHostages_AutoMoveStop_02	= false,	
	isBoyHostages_AutoMoveStop_03	= false,	
	isBoyHostages_AutoMoveStop_04	= false,	
	isBoyHostages_AutoMoveStop_05	= false,	
	isBoyHostage_A_moveState	= 0,			
	isBoyHostage_B_moveState	= 0,			
	isBoyHostage_C_moveState	= 0,			
	isBoyHostage_D_moveState	= 0,			
	
	isFarDistanceOrderNG		= false,		
	
	isCollect_Injury			= false,		
	isCollect_YellowHood		= false,		
	isCollect_Aflo				= false,		
	isCollect_ShortAflo			= false,		
	isCollect_BlackCoat			= false,		
	
	isOrder_CNT_01				= 0,
	isOrder_CNT_02				= 0,
	
	isAddEnemy_diamondSouth		= false,		
	isEnemy_diamond				= false,		
	isWavFulton_CNT				= 0,			
	isPursuersEnemyEnable		= false,		
	isBoyHostages_Enable		= false,
	isSniperCollect_CNT			= 0,			
	isAcpCollect_CNT			= 0,			
	isCalledSupportHeli			= false,		
	isDemoDoor_Alert			= false,
	isDemoDoor_Enemy			= false,
	isInBanana					= false,
	isBoyHostagesFLTN_CNT		= 0,
	isChaseEnemyCondition		= false,
	isPassPoint_showGuide		= false,		
	isShowGuide_CNT				= 0,			
	
	isReserveFlag_01		= false,		
	isReserveFlag_02		= false,		
	isReserveFlag_03		= false,		
	isReserveFlag_04		= false,		
	isReserveFlag_05		= false,		
	isReserveFlag_06		= false,		
	isReserveFlag_07		= false,		
	isReserveFlag_08		= false,		
	isReserveFlag_09		= false,		
	isReserveFlag_10		= false,		
	isReserveFlag_CNT_01	= 0,			
	isReserveFlag_CNT_02	= 0,			
	isReserveFlag_CNT_03	= 0,			
	isReserveFlag_CNT_04	= 0,			
	isReserveFlag_CNT_05	= 0,			
	isReserveFlag_11		= false,		
	isReserveFlag_12		= false,		
	isReserveFlag_13		= false,		
	isReserveFlag_14		= false,		
	isReserveFlag_15		= false,		
	isReserveFlag_CNT_06	= 0,			
	isReserveFlag_CNT_07	= 0,			
	isReserveFlag_CNT_08	= 0,			
	isReserveFlag_CNT_09	= 0,			
	isReserveFlag_CNT_10	= 0,
	isReserveFlag_16		= false,		
	isReserveFlag_17		= false,		
}


this.checkPointList = {
	"CHK_MissionStart",		
	"CHK_MeetBoyHostages",	
	"CHK_MotherBaseDemo",	
	
	"CHK_DBG_StartPoint_01",
	nil
}

if TppLocation.IsMiddleAfrica() then
	this.baseList = {
		"banana",
		"diamond",
		"bananaEast",
		"bananaSouth",
		"diamondNorth",
		"diamondSouth",
		"diamondWest",
		"savannahNorth",
		"savannahWest",
		nil
	}
end






if TppLocation.IsMiddleAfrica() then
this.missionObjectiveDefine = {
	
	default_area_banana = {	
		gameObjectName = "Marker_banana", visibleArea = 4, randomRange = 0, setNew = false, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea", mapRadioName = "s0100_mprg0010",
	},
	default_area_banana_2nd = {	
		gameObjectName = "Marker_banana", visibleArea = 4, randomRange = 0, setNew = false, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea", mapRadioName = "s0100_mprg0010",
	},
	reduce_area_banana = {	
		gameObjectName = "Marker_banana_reduce", visibleArea = 2, randomRange = 0, setNew = false, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea", mapRadioName = "s0100_mprg0010",
	},
	reduce_area_banana_2nd = {	
		gameObjectName = "Marker_banana_reduce", visibleArea = 2, randomRange = 0, setNew = false, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea", mapRadioName = "s0100_mprg0010",
	},
	default_boySoldiers = {	
		gameObjectName = "Marker_diamond", visibleArea = 5, randomRange = 0, setNew = false, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea", mapRadioName = "s0100_mprg0020",
	},
	reduce_boySoldiers = {	
		gameObjectName = "Marker_diamond_02", visibleArea = 3, randomRange = 0, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	target_banana = {	
		hudPhotoId = 10 
	},
	target_boyHostage01 = {	
		gameObjectName = TARGET_INJURY_BOY , goalType = "defend", viewType = "map_and_world_only_icon", setImportant = true, langId="marker_info_mission_target",
	},
	target_boyHostage02 = {	
		gameObjectName = TARGET_NORMAL_BOY_A , goalType = "defend", viewType = "map_and_world_only_icon", setImportant = true, langId="marker_info_mission_target",
	},
	target_boyHostage03 = {	
		gameObjectName = TARGET_NORMAL_BOY_B , goalType = "defend", viewType = "map_and_world_only_icon", setImportant = true, langId="marker_info_mission_target",
	},
	target_boyHostage04 = {	
		gameObjectName = TARGET_NORMAL_BOY_C , goalType = "defend", viewType = "map_and_world_only_icon", setImportant = true, langId="marker_info_mission_target",
	},
	target_boyHostage05 = {	
		gameObjectName = TARGET_NORMAL_BOY_D , goalType = "defend", viewType = "map_and_world_only_icon", setImportant = true, langId="marker_info_mission_target",
	},
	rv_diamond = {	
		gameObjectName = "Marker_diamondRV", goalType = "moving", viewType = "all", announceLog = "updateMap", langId="marker_info_LZ", mapRadioName = "s0100_mprg0040",
	},
	
	default_photo_bananaTarget = {	
			photoId = 10, addFirst = true, photoRadioName = "s0100_mirg1010",
			targetBgmCp = "mafr_banana_cp",
	},
	clear_photo_bananaTarget = {	
			photoId = 10, addFirst = true,
	
	},
	default_photo_diamond = {	
			photoId = 20, photoRadioName = "s0100_mirg1030",
			targetBgmCp = "mafr_diamond_cp",
	
	},
	clear_photo_diamond = {	
			photoId = 20,
	
	},
	
	default_subGoal = {	
		subGoalId= 0,
	},
	bananaTargetClear_subGoal = {	
		subGoalId= 1,
	},
	boyHostages_subGoal = {	
		subGoalId= 2,
	},
	bananaTarget_subGoal = {	
		subGoalId= 3,
	},
	escape_subGoal = {	
		subGoalId= 4,
	},
	
	missionTask_1_bananaTarget = {	
		missionTask = { taskNo=0, isNew=true, isComplete=false },
	},
	missionTask_1_bananaTarget_clear = {
		missionTask = { taskNo=0, isNew=true, isComplete=true },
	},
	missionTask_2_diamondTarget = {	
		missionTask = { taskNo=1, isNew=true, isComplete=false },
	},
	missionTask_2_diamondTarget_clear = {
		missionTask = { taskNo=1, isNew=true, isComplete=true },
	},
	missionTask_3_boyHostages_hide = {	
		missionTask = { taskNo=2, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_3_boyHostages = {	
		missionTask = { taskNo=2, isNew=true, isComplete=false, },
	},
	missionTask_3_boyHostages_clear = {
		missionTask = { taskNo=2, isNew=true, isComplete=true },
	},
	missionTask_4_bananaTarget_collect = {	
		missionTask = { taskNo=3, isNew=true, isComplete=false, isFirstHide=true  },
	},
	missionTask_4_bananaTarget_collect_clear = {
		missionTask = { taskNo=3, isNew=true },
	},
	missionTask_5_perfectEscape = {	
		missionTask = { taskNo=4, isNew=true, isComplete=false, isFirstHide=true  },
	},
	missionTask_5_perfectEscape_clear = {
		missionTask = { taskNo=4, isNew=true },
	},
	missionTask_6_BrokenEnemyHeli = {	
		missionTask = { taskNo=5, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_6_BrokenEnemyHeli_clear = {
		missionTask = { taskNo=5, isNew=true, isComplete=true },
	},
	missionTask_7_sniperAllCollect = {	
		missionTask = { taskNo=6, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_7_sniperAllCollect_clear = {
		missionTask = { taskNo=6, isNew=true, isComplete=true },
	},
	missionTask_8_AcpAllCollect = {	
		missionTask = { taskNo=7, isNew=true, isComplete=false, isFirstHide=true },
	},
	missionTask_8_AcpAllCollect_clear = {
		missionTask = { taskNo=7, isNew=true, isComplete=true },
	},
	subTask_ACP01 = {	
		gameObjectName = "veh_s10100_0000" , goalType = "attack", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_info_APC",
	},
	subTask_ACP02 = {	
		gameObjectName = "veh_s10100_0001" , goalType = "attack", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_info_APC",
	},
	subTask_ACP03 = {	
		gameObjectName = "veh_s10100_0002" , goalType = "attack", viewType = "map_and_world_only_icon", setNew = false, announceLog = "updateMap", langId="marker_info_APC",
	},
	reduce_boySoldiers_interro = {	
		gameObjectName = "Marker_diamond_02", visibleArea = 4, randomRange = 0, setNew = true, viewType = "all", announceLog = "updateMap", langId = "marker_info_mission_targetArea",
	},
	snipaerA_Area = {	
		gameObjectName = "Marker_sniperA", visibleArea = 4, randomRange = 0, goalType = "moving", setNew = true, viewType = "map_only_icon", announceLog = "updateMap", langId = "marker_information",
	},
	snipaerB_Area = {	
		gameObjectName = "Marker_sniperB", visibleArea = 4, randomRange = 0, goalType = "moving", setNew = true, viewType = "map_only_icon", announceLog = "updateMap", langId = "marker_information",
	},
	log_targetEliminate = {	
		announceLog = "eliminateTarget",
	},
	log_targetRecover = {	
		announceLog = "recoverTarget",
	},
	log_targetRecover_b01 = {	
		announceLog = "recoverTarget",
	},
	log_targetRecover_b02 = {	
		announceLog = "recoverTarget",
	},
	log_targetRecover_b03 = {	
		announceLog = "recoverTarget",
	},
	log_targetRecover_b04 = {	
		announceLog = "recoverTarget",
	},
	log_targetRecover_b05 = {	
		announceLog = "recoverTarget",
	},
	log_achieveObjective = {	
		announceLog = "achieveAllObjectives",
	},
}
this.missionObjectiveTree = {
	rv_diamond = {
		default_area_banana = {},
		reduce_area_banana = {},
		reduce_boySoldiers = {			
			reduce_boySoldiers_interro = {
				default_boySoldiers = {},
			},
		},
	},
	target_banana = {
		default_area_banana = {},		
		reduce_area_banana = {},
	},
	reduce_area_banana = {
		default_area_banana = {},		
	},
	default_area_banana_2nd = {
		rv_diamond = {},
	},
	reduce_area_banana_2nd = {
		rv_diamond = {},
	},
	clear_photo_diamond = {
		default_photo_diamond = {},
	},
	clear_photo_bananaTarget = {
		default_photo_bananaTarget = {},
	},
	escape_subGoal = {
		bananaTarget_subGoal = {
			boyHostages_subGoal = {
				bananaTargetClear_subGoal = {
					default_subGoal = {},
				},
			},
		},
	},
	missionTask_1_bananaTarget_clear = {
		missionTask_1_bananaTarget = {},
	},
	missionTask_2_diamondTarget_clear = {
		missionTask_2_diamondTarget = {},
	},
	missionTask_3_boyHostages_clear = {
		missionTask_3_boyHostages = {
			missionTask_3_boyHostages_hide = {},
		},
	},
	missionTask_4_bananaTarget_collect_clear = {
		missionTask_4_bananaTarget_collect = {},
	},
	missionTask_5_perfectEscape_clear = {
		missionTask_5_perfectEscape = {},
	},
	missionTask_6_BrokenEnemyHeli_clear = {
		missionTask_6_BrokenEnemyHeli = {},
	},
	missionTask_7_sniperAllCollect_clear = {
		missionTask_7_sniperAllCollect = {},
	},
	missionTask_8_AcpAllCollect_clear = {
		missionTask_8_AcpAllCollect = {},
	},
}
end
if TppLocation.IsMiddleAfrica() then
this.missionStartPosition = {
		helicopterRouteList = {
			"lz_drp_savannahWest_N0000|lz_drp_savannahWest_N_0000",	
			"lz_drp_banana_I0000|rt_drp_banana_I_0000",					
			"lz_drp_diamond_I0000|rt_drp_diamond_I_0000",				
		},
		orderBoxList = {
			"box_s10100_00",
			"box_s10100_02",
		},
}
end



function this.missionInfoChange()

	local sequence = TppSequence.GetCurrentSequenceName()
	
	if		sequence == "Seq_Game_BeforeRescueBoy"	then
		TppUiCommand.SetMisionInfoCurrentStoryNo(0)
	elseif	sequence == "Seq_Game_AfterRescueBoy"	then
		if svars.isBoyHostagesCount_clear ~= 5		then
			TppUiCommand.SetMisionInfoCurrentStoryNo(1)
		else
			if svars.isTargetClear == false	then
				TppUiCommand.SetMisionInfoCurrentStoryNo(2)
			else
				Fox.Log("missionInfo No Change...")
			end
		end
	else
		Fox.Log("missionInfo No Change...")
	end
end



function this.AddMapIconText()
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId("veh_s10100_0000"), langId="marker_info_APC" }
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId("veh_s10100_0001"), langId="marker_info_APC" }
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId("veh_s10100_0002"), langId="marker_info_APC" }
end



function this.ifBoyRecover_escapeSequence()

	if svars.isBoyHostagesCount_clear >=1 then
		TppSequence.SetNextSequence("Seq_Game_Escape")	
	else
		Fox.Log("svars.isBoyHostagesCount_clear = 0")
	end
end




function this.annouceLog_achieveObjective()
	if svars.isBoyHostagesCount_clear >= 1	and svars.isTargetClear == true then
		TppMission.UpdateObjective{ objectives = { "log_achieveObjective" }, }
	else
		Fox.Log("Nothing Done !!")
	end
end

function this.log_targetCollect_INJRY()
	if svars.isReserveFlag_11 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_11 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end
function this.log_targetCollect_INJRY_hz()
	if svars.isReserveFlag_11 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_11 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end

function this.log_targetCollect_A()

	if svars.isReserveFlag_12 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_12 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end
function this.log_targetCollect_A_hz()

	if svars.isReserveFlag_12 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_12 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end

function this.log_targetCollect_B()

	if svars.isReserveFlag_13 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_13 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end
function this.log_targetCollect_B_hz()

	if svars.isReserveFlag_13 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_13 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end

function this.log_targetCollect_C()

	if svars.isReserveFlag_14 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_14 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end
function this.log_targetCollect_C_hz()

	if svars.isReserveFlag_14 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_14 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end

function this.log_targetCollect_D()

	if svars.isReserveFlag_15 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_15 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end
function this.log_targetCollect_D_hz()

	if svars.isReserveFlag_15 == false	then
		if svars.isReserveFlag_16 == false		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 , AllTarget_CNT )
		elseif svars.isReserveFlag_16 == true		then
			TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isReserveFlag_CNT_02 + 1 , AllTarget_CNT )
		else
			Fox.Error("svars.isTargetClear is WRONG VALUE !!")
		end
		svars.isReserveFlag_15 = true
	else
		Fox.Log("NOthing Done!!")
	end
	this.boyRecover_commonAnnouceLog()
end

function this.annouceLog_targetCollect()
	TppUI.ShowAnnounceLog( "recoverTargetCount" , svars.isBoyHostagesCount_clear + 1 , AllTarget_CNT )
end

function this.bananaTarget_dead_AnnounceLog()
	
	TppMission.UpdateObjective{ objectives = { "log_targetEliminate" }, }
	
	this.annouceLog_achieveObjective()
	
	TppMission.UpdateObjective{ objectives = { "bananaTargetClear_subGoal" },}
	
	TppMission.UpdateObjective{ objectives = { "missionTask_1_bananaTarget_clear" }, }

	this.ifBoyRecover_escapeSequence()	
end

function this.bananaTarget_collect_AnnounceLog()
	
	this.annouceLog_targetCollect()
	
	this.annouceLog_achieveObjective()
	
	TppMission.UpdateObjective{ objectives = { "bananaTargetClear_subGoal" },}
	
	if svars.isReserveFlag_16 == true	then
		
		TppMission.UpdateObjective{ objectives = { "missionTask_1_bananaTarget_clear","missionTask_4_bananaTarget_collect_clear" }, }
		
		TppResult.AcquireSpecialBonus{ first = { isComplete = true,},}
	else
	end
	this.ifBoyRecover_escapeSequence()	
end

function this.boyRecover_commonAnnouceLog()
	
	this.annouceLog_achieveObjective()
	
	TppMission.UpdateObjective{ objectives = { "missionTask_3_boyHostages_clear"},}
	
	if svars.isBoyHostagesCount_clear >= 5	then
		
		if svars.isPrisonBreak == false		then
			TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}	
			TppMission.UpdateObjective{
				objectives = {"missionTask_5_perfectEscape_clear",},
			}
		else
			Fox.Log("isPrisonBreak == true ... SpecialBonus no get ...")
		end
		
		if svars.isReserveFlag_06 == true	then
			Fox.Log("Nothing Done !!")
		else
			
			if svars.isTargetClear == false		then
				s10100_radio.nextBananaTarget()
			else
				if svars.isReserveFlag_CNT_07 == 0	then
					if Tpp.IsHelicopter(vars.playerVehicleGameObjectId) then	
						s10100_radio.rideOnHeli_Advice02()
					else
						s10100_radio.rideOnHeli_Advice01()
					end
					svars.isReserveFlag_CNT_07 = 1
				else
					Fox.Log("isReserveFlag_CNT_07 ~= 0 ... Nothing Done !!")
				end
			end
		end
	else
		Fox.Log("Nothing Done !!")
	end
end

function this.boyHostages_logCheck()

	if svars.isReserveFlag_06 == false	then
		
		if svars.isCollect_Injury == true	then
			this.log_targetCollect_INJRY()
		else
		end
		
		if svars.isCollect_YellowHood == true	then
			this.log_targetCollect_A()
		else
		end	
		
		if svars.isCollect_Aflo == true		then
			this.log_targetCollect_B()
		else
		end
		
		if svars.isCollect_ShortAflo == true	then
			this.log_targetCollect_C()
		else
		end
		
		if svars.isCollect_BlackCoat == true	then
			this.log_targetCollect_D()
		else
		end
	elseif svars.isReserveFlag_06 == true	then
		
		if svars.isCollect_Injury == true	then
			this.log_targetCollect_INJRY_hz()
		else
		end
		
		if svars.isCollect_YellowHood == true	then
			this.log_targetCollect_A_hz()
		else
		end	
		
		if svars.isCollect_Aflo == true		then
			this.log_targetCollect_B_hz()
		else
		end
		
		if svars.isCollect_ShortAflo == true	then
			this.log_targetCollect_C_hz()
		else
		end
		
		if svars.isCollect_BlackCoat == true	then
			this.log_targetCollect_D_hz()
		else
		end
	else
		Fox.Log("svars.isReserveFlag_06 = WRONG VALUE !!")
	end
end



function this.supportHeli_waitTimeSetting()

	local sequence = TppSequence.GetCurrentSequenceName()
	
	if sequence ~= "Seq_Game_BeforeRescueBoy"	then
		if svars.isTargetClear == true	and svars.isBoyHostagesCount_clear < 5 then
			GameObject.SendCommand(
				{ type="TppHeli2", index = GameObject.GetGameObjectId( SUPPORT_HELI ), },
				{ id="SetTakeOffWaitTime", time=10 }
			)
		elseif svars.isTargetClear == true	and svars.isBoyHostagesCount_clear >= 5 then
			GameObject.SendCommand(
				{ type="TppHeli2", index = GameObject.GetGameObjectId( SUPPORT_HELI ), },
				{ id="SetTakeOffWaitTime", time=0 }
			)
		else
			GameObject.SendCommand(
				{ type="TppHeli2", index = GameObject.GetGameObjectId( SUPPORT_HELI ), },
				{ id="SetTakeOffWaitTime", time=5 }
			)
		end
	else
		Fox.Log("Nothig Done !!")
	end
end



function this.callVoice_enemyDown()

	local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVB080" }
	local lifeStateCommand	= { id = "GetLifeStatus", }
	local lifeStatus_A		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , lifeStateCommand )
	local lifeStatus_B		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , lifeStateCommand )
	local lifeStatus_C		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , lifeStateCommand )
	local lifeStatus_D		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , lifeStateCommand )
	local lifeStatus_INJURY		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , lifeStateCommand )

	if		svars.isReserveFlag_CNT_03 == 0 or	svars.isReserveFlag_CNT_03 == 5		then			
		if lifeStatus_INJURY == TppGameObject.NPC_LIFE_STATE_NORMAL	then
			GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , voice )		
		else
			Fox.Log("Nothing Done !!")
		end
		svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
	elseif	svars.isReserveFlag_CNT_03 == 1 or	svars.isReserveFlag_CNT_03 == 6		then			
		if lifeStatus_B == TppGameObject.NPC_LIFE_STATE_NORMAL	then
			GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , voice )	
		else
			Fox.Log("Nothing Done !!")
		end
		svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
	elseif	svars.isReserveFlag_CNT_03 == 2 or	svars.isReserveFlag_CNT_03 == 7		then			
		if lifeStatus_A == TppGameObject.NPC_LIFE_STATE_NORMAL	then
			GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , voice )	
		else
			Fox.Log("Nothing Done !!")
		end
		svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1						
	elseif	svars.isReserveFlag_CNT_03 == 3 or	svars.isReserveFlag_CNT_03 == 8		then			
		if lifeStatus_C == TppGameObject.NPC_LIFE_STATE_NORMAL	then
			GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , voice )	
		else
			Fox.Log("Nothing Done !!")
		end
		svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1						
	elseif	svars.isReserveFlag_CNT_03 == 4		then												
		if lifeStatus_D == TppGameObject.NPC_LIFE_STATE_NORMAL	then
			GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , voice )	
		else
			Fox.Log("Nothing Done !!")
		end
		svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
	elseif	svars.isReserveFlag_CNT_03 == 9		then												
		if lifeStatus_D == TppGameObject.NPC_LIFE_STATE_NORMAL	then
			GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , voice )	
		else
			Fox.Log("Nothing Done !!")
		end
		svars.isReserveFlag_CNT_03 = 0
	else
		svars.isReserveFlag_CNT_03 = 0
	end
end



function this.controlGuide_orderChild()

	
	if svars.isCollect_YellowHood == false or svars.isCollect_Aflo == false or svars.isCollect_ShortAflo == false or svars.isCollect_BlackCoat == false	then
		
		if svars.isShowGuide_CNT <= 5	then
			TppUI.ShowControlGuide{ actionName = "ORDER_CHILD", continue = false }
			svars.isShowGuide_CNT = svars.isShowGuide_CNT + 1
		else
			Fox.Log("isShowGuide_CNT >= 6 ... No Show Guide ...")
		end
	else
		Fox.Log("Move boyHostages All Clollect ... No Show Guide ...")
	end
end



function this.BGM_Setting()
	local sequence = TppSequence.GetCurrentSequenceName()

	if ( sequence ~= "Seq_Game_BeforeRescueBoy" )	then		
		if svars.isPrisonBreak == true		then
			if svars.isPursuersEnemyEnable == true		then	
				TppSound.SetPhaseBGM( "bgm_kids_escape_heli" )
			else
				TppSound.SetPhaseBGM( "bgm_kids_escape_kids" )
			end
		else
			TppSound.SetPhaseBGM( "bgm_kids_escape_normal" )
		end
	else
		TppSound.ResetPhaseBGM() 	
	end
end



function this.afterDemo_SneakPhase()

	for i, cpId in pairs( cpId_TABLE ) do
		local cpId_GID			= GameObject.GetGameObjectId( "TppCommandPost2" , cpId )
		local SetSneakPhase		= { id = "SetPhase", phase = 0 }
		GameObject.SendCommand( cpId_GID, SetSneakPhase )
	end
end



function this.checkPoint_OnOff()

	local sequence = TppSequence.GetCurrentSequenceName()

	if sequence ~= "Seq_Game_BeforeRescueBoy"	then
		TppCheckPoint.Disable{ baseName = { "diamond",} }
	else
	end
end



function this.pursuersEnemyEnable()

	if svars.isPrisonBreak == true	and svars.isPursuersEnemyEnable == false	then

		local cpId = { type="TppCommandPost2" }
		local time = 180.0
		local granado_NG = { id = "SetGrenadeTime", time=time }

		svars.isPursuersEnemyEnable = true
		this.BGM_Setting()
		
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondHill_0000" ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondHill_0001" ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondHill_0002" ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondHill_0003" ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondHill_0005" ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondHill_0006" ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondHill_0008" ) , { id="SetEnabled", enabled=true } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondHill_0009" ) , { id="SetEnabled", enabled=true } )
		
		
		TppEnemy.SetSneakRoute( "sol_diamondHill_0000" , "rts_hill0000_00" )
		TppEnemy.SetCautionRoute( "sol_diamondHill_0000" , "rts_hill0000_00" )
		TppEnemy.SetAlertRoute( "sol_diamondHill_0000" , "rts_hill0000_00" )
		
		TppEnemy.SetSneakRoute( "sol_diamondHill_0001" , "rts_hill0001_00" )
		TppEnemy.SetCautionRoute( "sol_diamondHill_0001" , "rts_hill0001_00" )
		TppEnemy.SetAlertRoute( "sol_diamondHill_0001" , "rts_hill0001_00" )
		
		TppEnemy.SetSneakRoute( "sol_diamondHill_0002" , "rts_hill0002_00" )
		TppEnemy.SetCautionRoute( "sol_diamondHill_0002" , "rts_hill0002_00" )
		TppEnemy.SetAlertRoute( "sol_diamondHill_0002" , "rts_hill0002_00" )
		
		TppEnemy.SetSneakRoute( "sol_diamondHill_0003" , "rts_hill0003_00" )
		TppEnemy.SetCautionRoute( "sol_diamondHill_0003" , "rts_hill0003_00" )
		TppEnemy.SetAlertRoute( "sol_diamondHill_0003" , "rts_hill0003_00" )
		
		TppEnemy.SetSneakRoute( "sol_diamondHill_0005" , "rts_hill0005_00" )
		TppEnemy.SetCautionRoute( "sol_diamondHill_0005" , "rts_hill0005_00" )
		TppEnemy.SetAlertRoute( "sol_diamondHill_0005" , "rts_hill0005_00" )
		
		TppEnemy.SetSneakRoute( "sol_diamondHill_0006" , "rts_hill0006_00" )
		TppEnemy.SetCautionRoute( "sol_diamondHill_0006" , "rts_hill0006_00" )
		TppEnemy.SetAlertRoute( "sol_diamondHill_0006" , "rts_hill0006_00" )
		
		TppEnemy.SetSneakRoute( "sol_diamondHill_0008" , "rts_hill0008_00" )
		TppEnemy.SetCautionRoute( "sol_diamondHill_0008" , "rts_hill0008_00" )
		TppEnemy.SetAlertRoute( "sol_diamondHill_0008" , "rts_hill0008_00" )
		
		TppEnemy.SetSneakRoute( "sol_diamondHill_0009" , "rts_hill0009_00" )
		TppEnemy.SetCautionRoute( "sol_diamondHill_0009" , "rts_hill0009_00" )
		TppEnemy.SetAlertRoute( "sol_diamondHill_0009" , "rts_hill0009_00" )
		
		GameObject.SendCommand( cpId, granado_NG )
	else
		Fox.Log("svars.isPrisonBreak == false ... Nothing Done !!")
	end
end



function this.orderCommand_OnOff_2()

	Fox.Log("orderCommand_OnOff_2!!")

	local orderCommand = { id = "SetPlayerDistanceCheck", enabled = true, near = ORDER_ENABLE_RANGE, far = ORDER_IGNORE_RANGE }
	
	GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ), orderCommand )
	GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ), orderCommand )
	GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ), orderCommand )
	GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ), orderCommand )
end



function this.orderCommand_OnOff()

	local sequence = TppSequence.GetCurrentSequenceName()

	if ( sequence == "Seq_Game_AfterRescueBoy" ) or ( sequence == "Seq_Game_Escape" )	then
		if svars.isBoyHostagesCount_clear >=0 and svars.isBoyHostagesCount_clear <=4	then
			Player.SetCallMenuEventCategoryType( CallMenuEventCategoryType.RescueBoy )		
		else
			Player.SetCallMenuEventCategoryType( CallMenuEventCategoryType.None )			
		end
	else
		Player.SetCallMenuEventCategoryType( CallMenuEventCategoryType.None )			
	end

end



function this.boyHostages_continueRoute()

	local sequence = TppSequence.GetCurrentSequenceName()

	if sequence == "Seq_Game_AfterRescueBoy" and svars.isBoyHostagesProgress == 0	then

		local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVN340" }
		local gameObjectType_boy	= "TppHostageUnique"
		local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
		local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
		local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
		local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		

		GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0004" ) , voice )
		GameObject.SendCommand( gameObjectId_A , this.command_A0000_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0000_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0000_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0000_move )
		svars.isBoyHostage_A_moveState	= 1
		svars.isBoyHostage_B_moveState	= 1
		svars.isBoyHostage_C_moveState	= 1
		svars.isBoyHostage_D_moveState	= 1	
		svars.isReserveFlag_05 = false		
	else
	end
end




function this.boyHostages_fallDown( gameObjectId )

	local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVR012" }		

	if svars.isFallDown == false	then		
		GameObject.SendCommand( gameObjectId , {
			id="SpecialAction",
			action="PlayMotion",
			path="/Assets/tpp/motion/SI_game/fani/bodies/chd1/chd1/chd1_q_fwk_srip.gani",
			autoFinish=true,
			enableMessage=true,
			enableGravity=true,
			enableCollision=true,
		} )
		GameObject.SendCommand( gameObjectId , voice )	
		svars.isFallDown = true
	else
		Fox.Log("Nothing Done !!")
	end
end

function this.boyHostages_surprise( gameObjectId )

	local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVR050" }		

	if svars.isSurprise == false	then
		GameObject.SendCommand( gameObjectId , {
			id="SpecialAction",
			action="PlayMotion",
			path="/Assets/tpp/motion/SI_game/fani/bodies/chd1/chd1/chd1_q_dis_front.gani",
			autoFinish=true,
			enableMessage=true,
			enableGravity=true,
			enableCollision=true,
		} )
		GameObject.SendCommand( gameObjectId , voice )	
		svars.isSurprise = true
	else
		Fox.Log("Nothing Done !!")
	end
end



function this.demoEventDoor_FullOpen()
	Fox.Log("Event Door Enable")
	Fox.Log("Event Door Setting OFF")
	Gimmick.SetEventDoorInvisible( EVENT_DOOR_BOY , EVENT_DOOR_PATH , false )	
	Gimmick.SetEventDoorInvisible( EVENT_DOOR_DEMO , EVENT_DOOR_PATH , false )	
	Gimmick.SetEventDoorLock( EVENT_DOOR_BOY , EVENT_DOOR_PATH , false , 1 )	
	Gimmick.SetEventDoorLock( EVENT_DOOR_DEMO , EVENT_DOOR_PATH , false , -1 )	
end




function this.OptRadioControl()

	local sequence = TppSequence.GetCurrentSequenceName()

	if		sequence == "Seq_Game_BeforeRescueBoy"	then
		if svars.isTargetClear == true	then
			s10100_radio.optionalRadio_20()
		else
			if svars.isInBanana == true		then
				if svars.isTargetAttestation == true	then
					s10100_radio.optionalRadio_40()
				else
					s10100_radio.optionalRadio_30()
				end
			else
				s10100_radio.optionalRadio_10()
			end
		end
	elseif	sequence == "Seq_Game_AfterRescueBoy"	then
		if	svars.isBoyHostagesCount_clear >= 5		then
			if svars.isTargetClear == false		then
				if svars.isInBanana == true		then
					if svars.isTargetAttestation == true	then
						s10100_radio.optionalRadio_40()
					else
						s10100_radio.optionalRadio_30()
					end
				else
					s10100_radio.optionalRadio_60()
				end
			else
			end
		else
			s10100_radio.optionalRadio_50()
		end
	elseif	sequence == "Seq_Game_Escape"	then
		s10100_radio.optionalRadio_70()
	else
	end
end



function this.interroBananaTarget_OFF()		
	TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("mafr_banana_cp"),
	{ 
		{ name = "enqt1000_101528",		func = s10100_enemy.InterCall_targetPosition, },
	} )
end
function this.boyHostages_Enable()	

	local sequence = TppSequence.GetCurrentSequenceName()

	if ( sequence == "Seq_Game_BeforeRescueBoy" )	then
		GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0000" ) , { id="SetEnabled", enabled = false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0001" ) , { id="SetEnabled", enabled = false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0002" ) , { id="SetEnabled", enabled = false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0003" ) , { id="SetEnabled", enabled = false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0004" ) , { id="SetEnabled", enabled = false } )
	else
		if svars.isBoyHostages_Enable == false	then
			svars.isBoyHostages_Enable = true
			GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0000" ) , { id="SetEnabled", enabled = true } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0001" ) , { id="SetEnabled", enabled = true } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0002" ) , { id="SetEnabled", enabled = true } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0003" ) , { id="SetEnabled", enabled = true } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0004" ) , { id="SetEnabled", enabled = true } )
		else
		end
	end
end

function this.OrderWait_allClear()
	
	for i, boyName in pairs( boyHostagesName_TABLE ) do
		local boyHostagesGID = GameObject.GetGameObjectId( boyName )
		GameObject.SendCommand( boyHostagesGID, {
			id="SpecialAction",
			action="",
			path="/Assets/tpp/motion/SI_game/fani/bodies/enet/enetnon/enetnon_ful_idl.gani",
			autoFinish=false,
			enableMessage=true,
			enableGravity=false,
			enableCollision=false,
		} )
	end
	Player.ChangeCallMenuItemWaitRescueBoy()	
end

function this.diamondAround_keepCaution()

	local cpId_diamond			= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamond_cp") }
	local cpId_diamondSwamp		= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamondSwamp_cp") }
	local cpId_diamonddiamond	= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamondRiver_cp") }
	local cpId_tracking			= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_tracking_cp") }
	local KeepCaution_ON		= { id = "SetKeepCaution", enable = true }
	GameObject.SendCommand( cpId_diamond		, KeepCaution_ON )
	GameObject.SendCommand( cpId_diamondSwamp	, KeepCaution_ON )
	GameObject.SendCommand( cpId_diamonddiamond	, KeepCaution_ON )
	GameObject.SendCommand( cpId_tracking		, KeepCaution_ON )
	
	s10100_radio.escapePerceived()		
end

function this.diamondAround_keepCaution_off()

	local cpId_diamond			= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamond_cp") }
	local cpId_diamondSwamp		= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamondSwamp_cp") }
	local cpId_diamonddiamond	= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamondRiver_cp") }
	local cpId_tracking			= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_tracking_cp") }
	local KeepCaution_OFF		= { id = "SetKeepCaution", enable = false }
	GameObject.SendCommand( cpId_diamond		, KeepCaution_OFF )
	GameObject.SendCommand( cpId_diamondSwamp	, KeepCaution_OFF )
	GameObject.SendCommand( cpId_diamonddiamond	, KeepCaution_OFF )
	GameObject.SendCommand( cpId_tracking		, KeepCaution_OFF )
end

this.OnEndMissionReward = function()
	Fox.Log("OnEndMissionReward")
	TppMission.MissionFinalize()
end

function this.OnGameOver()
	if TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.TARGET_DEAD )	then
		Fox.Log("gameover patarn is TARGET_DEAD ")
		TppPlayer.SetTargetDeadCamera{ gameObjectName = mvars.deadNPCId }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	elseif TppMission.CheckGameOverDemo( TppDefine.GAME_OVER_TYPE.PLAYER_KILL_CHILD_SOLDIER )	then
		Fox.Log("gameover patarn is TARGET_DEAD by Player")
		TppPlayer.SetTargetDeadCamera{ gameObjectName = mvars.deadNPCId }
		TppMission.ShowGameOverMenu{ delayTime = TppDefine.GAME_OVER_TARGET_DEAD_DEMO_TIME }
		return true
	else
		Fox.Log("gameover patarn is not TARGET_DEAD ")
	end

end

function this.photoCompleteCheck()

	local sequence = TppSequence.GetCurrentSequenceName()

	
	if ( svars.isTargetClear == true )	then
		TppMission.UpdateObjective{			
			objectives = { "clear_photo_bananaTarget" },
		}
	else
		Fox.Log(" svars.isTargetClear == false ")
	end
	
	if ( sequence == "Seq_Game_BeforeRescueBoy" ) then
		
	else
		TppMission.UpdateObjective{			
			objectives = { "clear_photo_diamond" },
		}
	end
end

function this.bananaTargetAttestation( messageName, gameObjectId , msg )

	
	svars.isTargetAttestation = true	
	s10100_radio.ChangeIntelRadio_attestationBananaTarget()	
	this.OptRadioControl()
	TppMission.UpdateObjective{
			objectives = { "target_banana" },
	}
	TppUiCommand.RegisterIconUniqueInformation{ markerId=GameObject.GetGameObjectId(TARGET_ENEMY_NAME), langId="marker_info_mission_target" }
	this.interroBananaTarget_OFF()	
	
	if msg == "LookingTarget"	then	
		s10100_radio.discoveryTarget()			
	elseif msg == "Carried"				
		or msg == "Restraint"	then	
		s10100_radio.beforeAttestationAction()	
	else
		Fox.Log(" msg not found ")
	end
	
end

function this.After_bananaTargetClear()
	svars.isTargetClear = true							
	svars.isTargetAttestation = true
	TppMarker.Disable( "Marker_banana" )				
	this.photoCompleteCheck()							
	s10100_radio.ChangeIntelRadio_clearBananaTarget()	
	this.OptRadioControl()								
	this.interroBananaTarget_OFF()
	this.ifBoyRecover_escapeSequence()
	TimerStart( "timer_bananaTarget", 10 )				
end

function this.After_bananaTargetClearRadio()

	local sequence = TppSequence.GetCurrentSequenceName()

	if ( sequence == "Seq_Game_BeforeRescueBoy" ) then
		
		s10100_radio.diamondAnnounce()						
	elseif ( sequence == "Seq_Game_AfterRescueBoy" )	then
		
	elseif ( sequence == "Seq_Game_Escape" ) then
		
		s10100_radio.rideOnHeli_Escape()					
	else
		Fox.Log("this Sequence is DemoSequence ... noRadio")
	end
end




function this.injuryBoy_forceDead()
	local gameObjectId = GameObject.GetGameObjectId( TARGET_INJURY_BOY )
	local forceDead = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DEAD }
	GameObject.SendCommand( gameObjectId, forceDead )
end

function this.movingBoy_A_forceDead()

	local gameObjectId = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )
	local forceDead = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DEAD }
	GameObject.SendCommand( gameObjectId, forceDead )
end

function this.movingBoy_B_forceDead()

	local gameObjectId = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )
	local forceDead = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DEAD }
	GameObject.SendCommand( gameObjectId, forceDead )
end

function this.movingBoy_C_forceDead()

	local gameObjectId = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )
	local forceDead = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DEAD }
	GameObject.SendCommand( gameObjectId, forceDead )
end

function this.movingBoy_D_forceDead()

	local gameObjectId = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )
	local forceDead = { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_DEAD }
	GameObject.SendCommand( gameObjectId, forceDead )
end



function this.boyHostages_unconsiousCheck()

	local CNT_Flag			= 0
	local lifeStateCommand	= { id = "GetLifeStatus", }
	local hostageId_A		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )
	local hostageId_B		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )
	local hostageId_C		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )
	local hostageId_D		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )
	local lifeStatus_A		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , lifeStateCommand )
	local lifeStatus_B		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , lifeStateCommand )
	local lifeStatus_C		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , lifeStateCommand )
	local lifeStatus_D		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , lifeStateCommand )

	if svars.isReserveFlag_05 == false	then
		
		if	lifeStatus_A ~= TppGameObject.NPC_LIFE_STATE_NORMAL		and svars.isBoyHostage_A_moveState ~= 2		then
			CNT_Flag = CNT_Flag + 1
		else
		end
		
		if	lifeStatus_B ~= TppGameObject.NPC_LIFE_STATE_NORMAL		and svars.isBoyHostage_B_moveState ~= 2		then
			CNT_Flag = CNT_Flag + 1
		else
		end
		
		if	lifeStatus_C ~= TppGameObject.NPC_LIFE_STATE_NORMAL		and svars.isBoyHostage_C_moveState ~= 2		then
			CNT_Flag = CNT_Flag + 1
		else
		end
		
		if	lifeStatus_D ~= TppGameObject.NPC_LIFE_STATE_NORMAL		and svars.isBoyHostage_D_moveState ~= 2		then
			CNT_Flag = CNT_Flag + 1
		else
		end
		
		if CNT_Flag > 0		then
			s10100_radio.dontComeBoys()
			svars.isReserveFlag_05 = true
		else
		end
	else
		Fox.Log("svars.isReserveFlag_05 == true ... NoRadio")
	end
end



function this.boyHostagesDiscoveriedEscape()
	Fox.Log("svars.isEnemy_diamond == "..tostring(svars.isEnemy_diamond).." !!")
	if svars.isEnemy_diamond == false and svars.isPrisonBreak == false	then
		local cpId = { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamond_cp") }
		local command = { id = "RequestRadio", label="CPR0230", memberId ="sol_diamond_0000" }
		GameObject.SendCommand( cpId , command )
	else
		Fox.Log("diamod CP is Annihilated !! ... Nopthing Done ...")
	end	
end



function this.AutoComingSupportHeli()

	local gameObjectId = GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI )

	
	if svars.isCalledSupportHeli == false	then
		svars.isCalledSupportHeli = true
		GameObject.SendCommand(gameObjectId, { id="CallToLandingZoneAtName", name="lz_diamond_S_s10100" })
		s10100_radio.nearRv()	
	else
		Fox.Log("svars.isCalledSupportHeli == true ... Nothing Done !!")
	end
end



function this.enemyHeliRoute()

	local sequence					= TppSequence.GetCurrentSequenceName()
	local gameObjectId				= GameObject.GetGameObjectId("TppEnemyHeli", ENEMY_HELI )
	local Sneak_BeforeRescueBoy		= { id="SetSneakRoute"		, route="eneHeli_DefaultRoute",		point=0	, warp = true }
	local Sneak_AfterRescueBoy_01	= { id="SetSneakRoute"		, route="eneHeli_afterBoysRoute",	point=0	, warp = true  }
	local Sneak_AfterRescueBoy_02	= { id="SetSneakRoute"		, route="eneHeli_SearchHostages",	point=0	, warp = true  }
	local Sneak_AfterRescueBoy_03	= { id="SetSneakRoute"		, route="eneHeli_banana",			point=0	, warp = true  }
	local Caution_BeforeRescueBoy	= { id="SetCautionRoute"	, route="eneHeli_DefaultRoute",		point=0	, warp = true  }
	local Caution_AfterRescueBoy_01	= { id="SetCautionRoute"	, route="eneHeli_afterBoysRoute",	point=0	, warp = true  }
	local Caution_AfterRescueBoy_02	= { id="SetCautionRoute"	, route="eneHeli_SearchHostages",	point=0	, warp = true  }
	local Caution_AfterRescueBoy_03	= { id="SetCautionRoute"	, route="eneHeli_banana",			point=0	, warp = true  }

	if svars.isEnemyHeliClear == false	then
		if ( sequence == "Seq_Game_BeforeRescueBoy" ) then
			GameObject.SendCommand( gameObjectId, Sneak_BeforeRescueBoy )
			GameObject.SendCommand( gameObjectId, Caution_BeforeRescueBoy )
		elseif ( sequence == "Seq_Game_AfterRescueBoy" ) or ( sequence == "Seq_Game_Escape" )then
			
			if svars.isPrisonBreak == false		then
				GameObject.SendCommand( gameObjectId, Sneak_AfterRescueBoy_01 )
				GameObject.SendCommand( gameObjectId, Caution_AfterRescueBoy_01 )
			elseif svars.isPrisonBreak == true		then
				if svars.isBoyHostagesProgress >= 20 or svars.isReserveFlag_08 == true	then
					GameObject.SendCommand( gameObjectId, Sneak_AfterRescueBoy_03 )
					GameObject.SendCommand( gameObjectId, Caution_AfterRescueBoy_03 )
				else
					GameObject.SendCommand( gameObjectId, Sneak_AfterRescueBoy_02 )
					GameObject.SendCommand( gameObjectId, Caution_AfterRescueBoy_02 )
				end
			else
				Fox.Log("isPrisonBreak is WRONG VALUE !!")
			end
		else
			Fox.Log("this Sequence is not Seq_Game_BeforeRescueBoy or Seq_Game_AfterRescueBoy")
		end
	else
		Fox.Log("ENEMY_HELI is Dead ... No Route Change ...")
	end
end

function this.common_boyHostages_Moving()

	
	if		svars.isBoyHostage_A_moveState ~= 2	then
		svars.isBoyHostage_A_moveState = 1
		Fox.Log("isBoyHostage_A_moveState is "..svars.isBoyHostage_A_moveState.." !!")
	else
		Fox.Log("isBoyHostage_A_moveState == 2 ... Nothing Done !!")
	end
	
	if		svars.isBoyHostage_B_moveState ~= 2	then
		svars.isBoyHostage_B_moveState = 1
		Fox.Log("isBoyHostage_B_moveState is "..svars.isBoyHostage_B_moveState.." !!")
	else
		Fox.Log("isBoyHostage_B_moveState == 2 ... Nothing Done !!")
	end
	
	if		svars.isBoyHostage_C_moveState ~= 2	then
		svars.isBoyHostage_C_moveState = 1
		Fox.Log("isBoyHostage_C_moveState is "..svars.isBoyHostage_C_moveState.." !!")
	else
		Fox.Log("isBoyHostage_C_moveState == 2 ... Nothing Done !!")
	end
	
	if		svars.isBoyHostage_D_moveState ~= 2	then
		svars.isBoyHostage_D_moveState = 1
		Fox.Log("isBoyHostage_D_moveState is "..svars.isBoyHostage_D_moveState.." !!")
	else
		Fox.Log("isBoyHostage_D_moveState == 2 ... Nothing Done !!")
	end
end


function this.BoyHostage_A_WaitingRouteChange()

	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )
	
	if svars.isBoyHostage_A_moveState ~= 2 	then
		svars.isBoyHostage_A_moveState = 0
	else
		Fox.Log("isBoyHostage_A_moveState == 2 ... Nothing Done !!")
	end

	if		svars.isBoyHostagesProgress == 0		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0000_wait )
	elseif	svars.isBoyHostagesProgress == 1		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0001_wait )
	elseif	svars.isBoyHostagesProgress == 2		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0002_wait )
	elseif	svars.isBoyHostagesProgress == 3		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0003_wait )
	elseif	svars.isBoyHostagesProgress == 4		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0004_wait )
	elseif	svars.isBoyHostagesProgress == 5		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0005_wait )
	elseif	svars.isBoyHostagesProgress == 6		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0006_wait )
	elseif	svars.isBoyHostagesProgress == 7		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0007_wait )
	elseif	svars.isBoyHostagesProgress == 8		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0008_wait )
	elseif	svars.isBoyHostagesProgress == 9		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0009_wait )
	elseif	svars.isBoyHostagesProgress == 10		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0010_wait )
	elseif	svars.isBoyHostagesProgress == 11		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0011_wait )
	elseif	svars.isBoyHostagesProgress == 12		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0012_wait )
	elseif	svars.isBoyHostagesProgress == 13		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0013_wait )
	elseif	svars.isBoyHostagesProgress == 14		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0014_wait )
	elseif	svars.isBoyHostagesProgress == 15		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0015_wait )
	elseif	svars.isBoyHostagesProgress == 16		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0016_wait )
	elseif	svars.isBoyHostagesProgress == 17		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0017_wait )
	elseif	svars.isBoyHostagesProgress == 18		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0018_wait )
	elseif	svars.isBoyHostagesProgress == 19		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0019_wait )
	elseif	svars.isBoyHostagesProgress == 20		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0020_wait )
	elseif	svars.isBoyHostagesProgress == 21		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0021_wait )
	elseif	svars.isBoyHostagesProgress == 22		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0022_wait )
	elseif	svars.isBoyHostagesProgress == 23		then
		GameObject.SendCommand( gameObjectId_A , this.command_A0023_wait )
	else
		Fox.Log("isBoyHostagesProgress is WRONG VALUE !!")
	end
end

function this.BoyHostage_B_WaitingRouteChange()

	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )
	
	if svars.isBoyHostage_B_moveState ~= 2 	then
		svars.isBoyHostage_B_moveState = 0
	else
		Fox.Log("isBoyHostage_B_moveState == 2 ... Nothing Done !!")
	end

	if		svars.isBoyHostagesProgress == 0		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0000_wait )
	elseif	svars.isBoyHostagesProgress == 1		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0001_wait )
	elseif	svars.isBoyHostagesProgress == 2		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0002_wait )
	elseif	svars.isBoyHostagesProgress == 3		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0003_wait )
	elseif	svars.isBoyHostagesProgress == 4		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0004_wait )
	elseif	svars.isBoyHostagesProgress == 5		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0005_wait )
	elseif	svars.isBoyHostagesProgress == 6		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0006_wait )
	elseif	svars.isBoyHostagesProgress == 7		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0007_wait )
	elseif	svars.isBoyHostagesProgress == 8		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0008_wait )
	elseif	svars.isBoyHostagesProgress == 9		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0009_wait )
	elseif	svars.isBoyHostagesProgress == 10		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0010_wait )
	elseif	svars.isBoyHostagesProgress == 11		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0011_wait )
	elseif	svars.isBoyHostagesProgress == 12		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0012_wait )
	elseif	svars.isBoyHostagesProgress == 13		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0013_wait )
	elseif	svars.isBoyHostagesProgress == 14		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0014_wait )
	elseif	svars.isBoyHostagesProgress == 15		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0015_wait )
	elseif	svars.isBoyHostagesProgress == 16		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0016_wait )
	elseif	svars.isBoyHostagesProgress == 17		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0017_wait )
	elseif	svars.isBoyHostagesProgress == 18		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0018_wait )
	elseif	svars.isBoyHostagesProgress == 19		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0019_wait )
	elseif	svars.isBoyHostagesProgress == 20		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0020_wait )
	elseif	svars.isBoyHostagesProgress == 21		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0021_wait )
	elseif	svars.isBoyHostagesProgress == 22		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0022_wait )
	elseif	svars.isBoyHostagesProgress == 23		then
		GameObject.SendCommand( gameObjectId_B , this.command_B0023_wait )
	else
		Fox.Log("isBoyHostagesProgress is WRONG VALUE !!")
	end
end

function this.BoyHostage_C_WaitingRouteChange()

	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )
	
	if svars.isBoyHostage_C_moveState ~= 2 	then
		svars.isBoyHostage_C_moveState = 0
	else
		Fox.Log("isBoyHostage_C_moveState == 2 ... Nothing Done !!")
	end

	if		svars.isBoyHostagesProgress == 0		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0000_wait )
	elseif	svars.isBoyHostagesProgress == 1		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0001_wait )
	elseif	svars.isBoyHostagesProgress == 2		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0002_wait )
	elseif	svars.isBoyHostagesProgress == 3		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0003_wait )
	elseif	svars.isBoyHostagesProgress == 4		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0004_wait )
	elseif	svars.isBoyHostagesProgress == 5		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0005_wait )
	elseif	svars.isBoyHostagesProgress == 6		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0006_wait )
	elseif	svars.isBoyHostagesProgress == 7		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0007_wait )
	elseif	svars.isBoyHostagesProgress == 8		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0008_wait )
	elseif	svars.isBoyHostagesProgress == 9		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0009_wait )
	elseif	svars.isBoyHostagesProgress == 10		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0010_wait )
	elseif	svars.isBoyHostagesProgress == 11		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0011_wait )
	elseif	svars.isBoyHostagesProgress == 12		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0012_wait )
	elseif	svars.isBoyHostagesProgress == 13		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0013_wait )
	elseif	svars.isBoyHostagesProgress == 14		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0014_wait )
	elseif	svars.isBoyHostagesProgress == 15		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0015_wait )
	elseif	svars.isBoyHostagesProgress == 16		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0016_wait )
	elseif	svars.isBoyHostagesProgress == 17		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0017_wait )
	elseif	svars.isBoyHostagesProgress == 18		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0018_wait )
	elseif	svars.isBoyHostagesProgress == 19		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0019_wait )
	elseif	svars.isBoyHostagesProgress == 20		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0020_wait )
	elseif	svars.isBoyHostagesProgress == 21		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0021_wait )
	elseif	svars.isBoyHostagesProgress == 22		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0022_wait )
	elseif	svars.isBoyHostagesProgress == 23		then
		GameObject.SendCommand( gameObjectId_C , this.command_C0023_wait )
	else
		Fox.Log("isBoyHostagesProgress is WRONG VALUE !!")
	end
end

function this.BoyHostage_D_WaitingRouteChange()

	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )
	
	if svars.isBoyHostage_D_moveState ~= 2 	then
		svars.isBoyHostage_D_moveState = 0
	else
		Fox.Log("isBoyHostage_D_moveState == 2 ... Nothing Done !!")
	end

	if		svars.isBoyHostagesProgress == 0		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0000_wait )
	elseif	svars.isBoyHostagesProgress == 1		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0001_wait )
	elseif	svars.isBoyHostagesProgress == 2		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0002_wait )
	elseif	svars.isBoyHostagesProgress == 3		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0003_wait )
	elseif	svars.isBoyHostagesProgress == 4		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0004_wait )
	elseif	svars.isBoyHostagesProgress == 5		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0005_wait )
	elseif	svars.isBoyHostagesProgress == 6		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0006_wait )
	elseif	svars.isBoyHostagesProgress == 7		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0007_wait )
	elseif	svars.isBoyHostagesProgress == 8		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0008_wait )
	elseif	svars.isBoyHostagesProgress == 9		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0009_wait )
	elseif	svars.isBoyHostagesProgress == 10		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0010_wait )
	elseif	svars.isBoyHostagesProgress == 11		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0011_wait )
	elseif	svars.isBoyHostagesProgress == 12		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0012_wait )
	elseif	svars.isBoyHostagesProgress == 13		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0013_wait )
	elseif	svars.isBoyHostagesProgress == 14		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0014_wait )
	elseif	svars.isBoyHostagesProgress == 15		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0015_wait )
	elseif	svars.isBoyHostagesProgress == 16		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0016_wait )
	elseif	svars.isBoyHostagesProgress == 17		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0017_wait )
	elseif	svars.isBoyHostagesProgress == 18		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0018_wait )
	elseif	svars.isBoyHostagesProgress == 19		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0019_wait )
	elseif	svars.isBoyHostagesProgress == 20		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0020_wait )
	elseif	svars.isBoyHostagesProgress == 21		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0021_wait )
	elseif	svars.isBoyHostagesProgress == 22		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0022_wait )
	elseif	svars.isBoyHostagesProgress == 23		then
		GameObject.SendCommand( gameObjectId_D , this.command_D0023_wait )
	else
		Fox.Log("isBoyHostagesProgress is WRONG VALUE !!")
	end
end

function this.boyHostages_to2ndPassPoint()

	local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVC250" }
	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		

	GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0004" ) , voice )
	GameObject.SendCommand( gameObjectId_A , this.command_A0003_move )
	GameObject.SendCommand( gameObjectId_B , this.command_B0003_move )
	GameObject.SendCommand( gameObjectId_C , this.command_C0003_move )
	GameObject.SendCommand( gameObjectId_D , this.command_D0003_move )
	svars.isBoyHostagesCount_arrival = 0	
	svars.isBoyHostagesProgress = svars.isBoyHostagesProgress + 1
	svars.isFarDistanceOrderNG = false
	svars.isFallDown = false
	svars.isSurprise = false
	svars.isReserveFlag_05 = false
	this.common_boyHostages_Moving()
end

function this.boyHostages_to3rdPassPoint()

	local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVN340" }
	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		

	GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0003" ) , voice )
	GameObject.SendCommand( gameObjectId_A , this.command_A0007_move )
	GameObject.SendCommand( gameObjectId_B , this.command_B0007_move )
	GameObject.SendCommand( gameObjectId_C , this.command_C0007_move )
	GameObject.SendCommand( gameObjectId_D , this.command_D0007_move )
	
	svars.isBoyHostagesCount_arrival = 0	
	svars.isBoyHostagesProgress = svars.isBoyHostagesProgress + 1
	svars.isFarDistanceOrderNG = false
	svars.isFallDown = false
	svars.isSurprise = false
	svars.isReserveFlag_05 = false
	this.common_boyHostages_Moving()
end

function this.boyHostages_to4thPassPoint()

	local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVC250" }
	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0001" ) , voice )
	GameObject.SendCommand( gameObjectId_A , this.command_A0010_move )
	GameObject.SendCommand( gameObjectId_B , this.command_B0010_move )
	GameObject.SendCommand( gameObjectId_C , this.command_C0010_move )
	GameObject.SendCommand( gameObjectId_D , this.command_D0010_move )
	if svars.isReserveFlag_CNT_08 == 1 then
		TppTrap.Disable("trap_CHK_s10100_03")	
		svars.isReserveFlag_CNT_08 = 2
	else
	end
	svars.isBoyHostagesCount_arrival = 0	
	svars.isBoyHostagesProgress = svars.isBoyHostagesProgress + 1
	svars.isFarDistanceOrderNG = false
	svars.isFallDown = false
	svars.isSurprise = false
	svars.isReserveFlag_05 = false
	this.common_boyHostages_Moving()
end

function this.boyHostages_to5thPassPoint()

	local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVN340" }
	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		
	
	GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0002" ) , voice )
	GameObject.SendCommand( gameObjectId_A , this.command_A0015_move )
	GameObject.SendCommand( gameObjectId_B , this.command_B0015_move )
	GameObject.SendCommand( gameObjectId_C , this.command_C0015_move )
	GameObject.SendCommand( gameObjectId_D , this.command_D0015_move )
	
	svars.isBoyHostagesCount_arrival = 0	
	svars.isBoyHostagesProgress = svars.isBoyHostagesProgress + 1
	svars.isFarDistanceOrderNG = false
	svars.isFallDown = false
	svars.isSurprise = false
	svars.isReserveFlag_05 = false
	this.common_boyHostages_Moving()
end

function this.boyHostages_lastDush()

	local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVC260" }		
	local gameObjectId_Heli	= GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI )
	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		
	local DashCommand		= { id = "SetHostage2Flag", flag = "childDash", on = true, }					
	local scaredProhibition = { id = "SetHostage2Flag", flag = "disableScared", on = true, }				
	
	GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , voice )
	GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , voice )
	GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , voice )
	GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , voice )
	
	GameObject.SendCommand( gameObjectId_A , scaredProhibition )
	GameObject.SendCommand( gameObjectId_B , scaredProhibition )
	GameObject.SendCommand( gameObjectId_C , scaredProhibition )
	GameObject.SendCommand( gameObjectId_D , scaredProhibition )
	
	GameObject.SendCommand( gameObjectId_A , DashCommand )
	GameObject.SendCommand( gameObjectId_B , DashCommand )
	GameObject.SendCommand( gameObjectId_C , DashCommand )
	GameObject.SendCommand( gameObjectId_D , DashCommand )
	GameObject.SendCommand( gameObjectId_A , this.command_A0024_move )
	GameObject.SendCommand( gameObjectId_B , this.command_B0024_move )
	GameObject.SendCommand( gameObjectId_C , this.command_C0024_move )
	GameObject.SendCommand( gameObjectId_D , this.command_D0024_move )
	
	svars.isFallDown = false
	svars.isSurprise = false
	svars.isReserveFlag_05 = false
	
	if svars.isReserveFlag_CNT_09 == 1	then
		TppTrap.Disable("trap_CHK_s10100_05")	
		svars.isReserveFlag_CNT_09 = 2
	else
	end
	Player.SetCallMenuEventCategoryType( CallMenuEventCategoryType.None )		
	svars.isBoyHostagesCount_arrival = 0	
	svars.isBoyHostagesProgress = svars.isBoyHostagesProgress + 1
	this.common_boyHostages_Moving()
	if svars.isPrisonBreak == true and svars.isPursuersEnemyEnable == false	then
		this.pursuersEnemyEnable()		
	else
		Fox.Log("svars.isPursuersEnemyEnable == true ... Nothing Done !!")
	end
	
	
	GameObject.SendCommand( gameObjectId_Heli , { id="CallToLandingZoneAtName", name="lz_diamond_S_s10100" })
end

function this.isBoyHostagesProgress_RouteChange01()

	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		
	local voice_A				= { id="CallVoice", dialogueName="DD_chsol", parameter="EVC250" }
	local voice_B				= { id="CallVoice", dialogueName="DD_chsol", parameter="EVN340" }
	svars.isReserveFlag_05 = false

	if svars.isBoyHostagesProgress == 0 then
		if svars.isBoyHostagesRC_inCave01 == true	then
			GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0002" ) , voice_A )
			GameObject.SendCommand( gameObjectId_A , this.command_A0001_move )
			GameObject.SendCommand( gameObjectId_B , this.command_B0001_move )
			GameObject.SendCommand( gameObjectId_C , this.command_C0001_move )
			GameObject.SendCommand( gameObjectId_D , this.command_D0001_move )
			svars.isBoyHostagesCount_arrival = 0	
			svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
			this.common_boyHostages_Moving()
		else
			Fox.Log("Untill PC near T Road in CAVE ... boyHostages Dont Move")
		end
	elseif svars.isBoyHostagesProgress == 1 then
		local caveDoor_state	= Gimmick.IsDoorLocking ( CAVE_DOOR_DATA , CAVE_DOOR_PATH )	

		if svars.isBoyHostagesCount_arrival == svars.isBoyHostagesCount_noMove	then
			Fox.Log("caveDoor_state is "..tostring(caveDoor_state))
			if caveDoor_state == true	then	
				Fox.Log("caveDoor is LOCK ... boyHostages is not RoutChange")
			else								
				Fox.Log("caveDoor is UNLOCK ... boyHostages is RoutChange !!")
				GameObject.SendCommand( GameObject.GetGameObjectId( "hos_diamond_0001" ) , voice_B )
				GameObject.SendCommand( gameObjectId_A , this.command_A0002_move )
				GameObject.SendCommand( gameObjectId_B , this.command_B0002_move )
				GameObject.SendCommand( gameObjectId_C , this.command_C0002_move )
				GameObject.SendCommand( gameObjectId_D , this.command_D0002_move )
				svars.isBoyHostagesCount_arrival = 0	
				svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
				this.common_boyHostages_Moving()
			end
		else
			Fox.Log("Active BoyHostages is not arrival ... ")
		end
	elseif svars.isBoyHostagesProgress == 2 then
		Fox.Log("Nothing Done")
	elseif svars.isBoyHostagesProgress == 3 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0004_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0004_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0004_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0004_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 4 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0005_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0005_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0005_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0005_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 5 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0006_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0006_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0006_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0006_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 6 then
		Fox.Log("Nothing Done")
	elseif svars.isBoyHostagesProgress == 7 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0008_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0008_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0008_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0008_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 8 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0009_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0009_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0009_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0009_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 9 then
		Fox.Log("Nothing Done")
	else
		Fox.Log("isBoyHostagesProgress is WRONG VALUE !!")
	end
end

function this.isBoyHostagesProgress_RouteChange02()

	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		

	svars.isReserveFlag_05 = false

	if svars.isBoyHostagesProgress == 10 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0011_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0011_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0011_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0011_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 11 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0012_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0012_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0012_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0012_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 12 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0013_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0013_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0013_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0013_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 13 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0014_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0014_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0014_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0014_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 14 then
		Fox.Log("Nothing Done")
	elseif svars.isBoyHostagesProgress == 15 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0016_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0016_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0016_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0016_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		svars.isChaseEnemyCondition = true
		this.common_boyHostages_Moving()
		this.boyHostagesDiscoveriedEscape()		
	elseif svars.isBoyHostagesProgress == 16 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0017_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0017_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0017_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0017_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 17 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0018_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0018_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0018_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0018_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 18 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0019_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0019_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0019_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0019_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 19 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0020_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0020_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0020_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0020_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	else
		Fox.Log("isBoyHostagesProgress is WRONG VALUE !!")
	end
end

function this.isBoyHostagesProgress_RouteChange03()

	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		

	svars.isReserveFlag_05 = false

	if svars.isBoyHostagesProgress == 20 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0021_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0021_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0021_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0021_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
		this.AutoComingSupportHeli()	
	elseif svars.isBoyHostagesProgress == 21 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0022_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0022_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0022_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0022_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 22 then
		GameObject.SendCommand( gameObjectId_A , this.command_A0023_move )
		GameObject.SendCommand( gameObjectId_B , this.command_B0023_move )
		GameObject.SendCommand( gameObjectId_C , this.command_C0023_move )
		GameObject.SendCommand( gameObjectId_D , this.command_D0023_move )
		svars.isBoyHostagesCount_arrival = 0	
		svars.isBoyHostagesProgress = svars.isBoyHostagesProgress +1
		this.common_boyHostages_Moving()
	elseif svars.isBoyHostagesProgress == 23 then
		Fox.Log("Nothing Done")
	else
		Fox.Log("isBoyHostagesProgress is WRONG VALUE !!")
	end
end

function this.boyHostages_RouteChangeCheck()

	Fox.Log("svars.isBoyHostagesCount_arrival = "..svars.isBoyHostagesCount_arrival.." !!")
	Fox.Log("svars.isBoyHostagesCount_noMove = "..svars.isBoyHostagesCount_noMove.." !!")

	if svars.isBoyHostagesCount_arrival == svars.isBoyHostagesCount_noMove	then	
		Fox.Log("svars.isBoyHostagesProgress = "..svars.isBoyHostagesProgress.." !!")
		
		if		svars.isBoyHostagesProgress >= 0 and svars.isBoyHostagesProgress <= 9	then
			this.isBoyHostagesProgress_RouteChange01()
		elseif	svars.isBoyHostagesProgress >= 10	and svars.isBoyHostagesProgress <= 19	then
			this.isBoyHostagesProgress_RouteChange02()
		elseif	svars.isBoyHostagesProgress >= 20	then
			this.isBoyHostagesProgress_RouteChange03()
		else
			Fox.Log("isBoyHostagesProgress is WRONG VALUE !!")
		end
	else																			
		Fox.Log("Active BoyHostages is not arrival ... ")
		this.boyHostages_unconsiousCheck()
	end
end

function this.boyHostages_passPointWaitCheck()

	Fox.Log("svars.isBoyHostagesCount_arrival = "..svars.isBoyHostagesCount_arrival.." !!")
	Fox.Log("svars.isBoyHostagesCount_noMove = "..svars.isBoyHostagesCount_noMove.." !!")
	
	if svars.isBoyHostagesCount_arrival == svars.isBoyHostagesCount_noMove	then	
		Fox.Log("svars.isBoyHostagesProgress = "..svars.isBoyHostagesProgress.." !!")
		Fox.Log("svars.isPassPointProgress = "..svars.isPassPointProgress.." !!")
		Player.ChangeCallMenuItemGoRescueBoy()		
		
		if		svars.isBoyHostagesProgress == 2 and svars.isPassPointProgress == 0	then
			svars.isPassPointProgress = 1
		elseif	svars.isBoyHostagesProgress == 2 and svars.isPassPointProgress == 1	then
			s10100_radio.boyHostages_tutorial01()	
			if svars.isBoyHostages_AutoMoveStop_01 == true	then
				Player.ChangeCallMenuItemWaitRescueBoy()	
				this.boyHostages_to2ndPassPoint()
			else
			end
		elseif	svars.isBoyHostagesProgress == 6 and svars.isPassPointProgress == 1	then
			svars.isPassPointProgress = 2
		elseif	svars.isBoyHostagesProgress == 6 and svars.isPassPointProgress == 2	then
			
			if svars.isBoyHostages_AutoMoveStop_02 == true	then
				Player.ChangeCallMenuItemWaitRescueBoy()	
				this.boyHostages_to3rdPassPoint()
			else
				if svars.isPassPoint_showGuide == false		then
					this.controlGuide_orderChild()
					svars.isPassPoint_showGuide = true
				else
					Fox.Log("isPassPoint_showGuide = true ... No Show Guide ...")
				end
			end
		elseif	svars.isBoyHostagesProgress == 9 and svars.isPassPointProgress == 2	then
			svars.isPassPointProgress = 3
		elseif	svars.isBoyHostagesProgress == 9 and svars.isPassPointProgress == 3	then
			if svars.isReserveFlag_CNT_08 == 0	then
				TppTrap.Enable("trap_CHK_s10100_03")		
				svars.isReserveFlag_CNT_08 = 1
			else
			end
			if svars.isBoyHostages_AutoMoveStop_03 == true	then
				Player.ChangeCallMenuItemWaitRescueBoy()	
				this.boyHostages_to4thPassPoint()
			else
				if svars.isPassPoint_showGuide == false		then
					this.controlGuide_orderChild()
					svars.isPassPoint_showGuide = true
				else
					Fox.Log("isPassPoint_showGuide = true ... No Show Guide ...")
				end
			end
		elseif	svars.isBoyHostagesProgress == 14 and svars.isPassPointProgress == 3	then
			svars.isPassPointProgress = 4
		elseif	svars.isBoyHostagesProgress == 14 and svars.isPassPointProgress == 4	then
			
			if svars.isBoyHostages_AutoMoveStop_04 == true	then
				Player.ChangeCallMenuItemWaitRescueBoy()	
				this.boyHostages_to5thPassPoint()
			else
				if svars.isPassPoint_showGuide == false		then
					this.controlGuide_orderChild()
					svars.isPassPoint_showGuide = true
				else
					Fox.Log("isPassPoint_showGuide = true ... No Show Guide ...")
				end
			end
		elseif	svars.isBoyHostagesProgress == 23 and svars.isPassPointProgress == 4	then
			svars.isPassPointProgress = 5
		elseif	svars.isBoyHostagesProgress == 23 and svars.isPassPointProgress == 5	then
			if svars.isReserveFlag_CNT_09 == 0 then
				TppTrap.Enable("trap_CHK_s10100_05")		
				svars.isReserveFlag_CNT_09 = 1
			else
			end
			if svars.isBoyHostages_AutoMoveStop_05 == true	then
				this.boyHostages_lastDush()
			else
				if svars.isPassPoint_showGuide == false		then
					this.controlGuide_orderChild()
					svars.isPassPoint_showGuide = true
				else
					Fox.Log("isPassPoint_showGuide = true ... No Show Guide ...")
				end
			end
		else
			Fox.Log("isBoyHostagesProgress & isPassPointProgress is Not Mach ... ")
		end
	else
		Fox.Log("Active BoyHostages is not arrival ... ")
		this.boyHostages_unconsiousCheck()
	end

end


function this.boyHostage_A_noMove()

	if		svars.isBoyHostage_A_moveState == 0		then	
		svars.isBoyHostagesCount_arrival = svars.isBoyHostagesCount_arrival - 1
		svars.isBoyHostagesCount_noMove = svars.isBoyHostagesCount_noMove - 1
		svars.isBoyHostage_A_moveState = 2
	elseif	svars.isBoyHostage_A_moveState == 1		then	
		svars.isBoyHostagesCount_noMove = svars.isBoyHostagesCount_noMove - 1
		svars.isBoyHostage_A_moveState = 2
	elseif	svars.isBoyHostage_A_moveState == 2	 or svars.isBoyHostage_A_moveState == 3	then	
		Fox.Log("boyHostage_A is noMove ... Nothing Done !!")
	else
		Fox.Error("isBoyHostage_A_moveState is WRONG VALUE !!")
	end
	Fox.Log("isBoyHostage_A_moveState is "..svars.isBoyHostage_A_moveState.." !! 0:Wait 1:moving 2:noMove")
end

function this.boyHostage_B_noMove()

	if		svars.isBoyHostage_B_moveState == 0		then	
		svars.isBoyHostagesCount_arrival = svars.isBoyHostagesCount_arrival - 1
		svars.isBoyHostagesCount_noMove = svars.isBoyHostagesCount_noMove - 1
		svars.isBoyHostage_B_moveState = 2
	elseif	svars.isBoyHostage_B_moveState == 1		then	
		svars.isBoyHostagesCount_noMove = svars.isBoyHostagesCount_noMove - 1
		svars.isBoyHostage_B_moveState = 2
	elseif	svars.isBoyHostage_B_moveState == 2	 or svars.isBoyHostage_B_moveState == 3	then	
		Fox.Log("boyHostage_B is noMove ... Nothing Done !!")
	else
		Fox.Error("isBoyHostage_B_moveState is WRONG VALUE !!")
	end
	Fox.Log("isBoyHostage_B_moveState is "..svars.isBoyHostage_B_moveState.." !! 0:Wait 1:moving 2:noMove")
end

function this.boyHostage_C_noMove()

	if		svars.isBoyHostage_C_moveState == 0		then	
		svars.isBoyHostagesCount_arrival = svars.isBoyHostagesCount_arrival - 1
		svars.isBoyHostagesCount_noMove = svars.isBoyHostagesCount_noMove - 1
		svars.isBoyHostage_C_moveState = 2
	elseif	svars.isBoyHostage_C_moveState == 1		then	
		svars.isBoyHostagesCount_noMove = svars.isBoyHostagesCount_noMove - 1
		svars.isBoyHostage_C_moveState = 2
	elseif	svars.isBoyHostage_C_moveState == 2	 or svars.isBoyHostage_C_moveState == 3	then	
		Fox.Log("boyHostage_C is noMove ... Nothing Done !!")
	else
		Fox.Error("isBoyHostage_C_moveState is WRONG VALUE !!")
	end
	Fox.Log("isBoyHostage_C_moveState is "..svars.isBoyHostage_C_moveState.." !! 0:Wait 1:moving 2:noMove")
end

function this.boyHostage_D_noMove()

	if		svars.isBoyHostage_D_moveState == 0		then	
		svars.isBoyHostagesCount_arrival = svars.isBoyHostagesCount_arrival - 1
		svars.isBoyHostagesCount_noMove = svars.isBoyHostagesCount_noMove - 1
		svars.isBoyHostage_D_moveState = 2
	elseif	svars.isBoyHostage_D_moveState == 1		then	
		svars.isBoyHostagesCount_noMove = svars.isBoyHostagesCount_noMove - 1
		svars.isBoyHostage_D_moveState = 2
	elseif	svars.isBoyHostage_D_moveState == 2	 or svars.isBoyHostage_D_moveState == 3	then	
		Fox.Log("boyHostage_D is noMove ... Nothing Done !!")
	else
		Fox.Error("isBoyHostage_D_moveState is WRONG VALUE !!")
	end
	Fox.Log("isBoyHostage_D_moveState is "..svars.isBoyHostage_D_moveState.." !! 0:Wait 1:moving 2:noMove")
end

function this.common_boyHostagesClearDisposal( gameObjectId )

	svars.isBoyHostagesCount_clear = svars.isBoyHostagesCount_clear + 1
	Fox.Log("svars.isBoyHostagesCount_clear = "..svars.isBoyHostagesCount_clear.." !!")

	this.checkPoint_OnOff()					
	this.OptRadioControl()

	
	if		gameObjectId == GameObject.GetGameObjectId( TARGET_INJURY_BOY )	then
		svars.isCollect_Injury = true
	elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )	then
		svars.isCollect_YellowHood = true
	elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )	then
		svars.isCollect_Aflo = true
	elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )	then
		svars.isCollect_ShortAflo = true
	elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )	then
		svars.isCollect_BlackCoat = true
	else
	end
	
	if svars.isBoyHostagesCount_clear == 0	then
		Fox.Log("Kaishu shitanoni svars.isBoyHostagesCount_clear = 0 ni natteiru YO !!")
	elseif ( svars.isBoyHostagesCount_clear >= 1 ) and ( svars.isBoyHostagesCount_clear <= 4 ) then	
		
		if svars.isBoyHostagesCount_clear == 1	then
			s10100_radio.BoyFultonSuccess_01()
		elseif svars.isBoyHostagesCount_clear == 2	then
			s10100_radio.BoyFultonSuccess_02()
		elseif svars.isBoyHostagesCount_clear == 3	then
			s10100_radio.BoyFultonSuccess_03()
		elseif svars.isBoyHostagesCount_clear == 4	then
			s10100_radio.BoyFultonSuccess_04()
		else
		end
		
		if svars.isTargetClear == true		then
			TppSequence.SetNextSequence("Seq_Game_Escape")
		else
			Fox.Log("Not Sequence Change !! ... isTargetClear == false ")
		end
	elseif svars.isBoyHostagesCount_clear >= 5	then
		s10100_radio.BoyFultonSuccess_05()
		this.missionInfoChange()
		TimerStart( "timer_boyHostagesCollect_2", 10 )		
		
		if svars.isTargetClear == true	then
			TppSequence.SetNextSequence("Seq_Game_Escape")
		else
			svars.isReserveFlag_07 = true
			Fox.Log("isTargetClear == false ... Nothing Done !!")
		end
	else
		Fox.Log("svars.isBoyHostagesCount_clear is WRONG VALUE !!")
	end
	if GkEventTimerManager.IsTimerActive("timer_boyHostagesCollect") then
	else
		TimerStart( "timer_boyHostagesCollect", 10 )		
	end
	
	if svars.isReserveFlag_CNT_08 == 1	then
		TppTrap.Disable("trap_CHK_s10100_03")	
		svars.isReserveFlag_CNT_08 = 2
	else
	end
	if svars.isReserveFlag_CNT_09 == 1	then
		TppTrap.Disable("trap_CHK_s10100_05")	
		svars.isReserveFlag_CNT_09 = 2
	else
	end
end

function this.ReserveMissionClear()
	TppMission.ReserveMissionClear{
				nextMissionId		= TppDefine.SYS_MISSION_ID.MTBS_FREE,
				missionClearType	= TppDefine.MISSION_CLEAR_TYPE.ON_FOOT
			}
end

function this.ContainerMissionClear()
	TppMission.ReserveMissionClear{
		missionClearType = TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_FULTON_CONTAINER,
		nextMissionId = TppDefine.SYS_MISSION_ID.MTBS_FREE,
	}
end

function this.boyHostages_BCD_ForcedScare_ON()

	local voice				= { id="CallVoice", dialogueName="DD_chsol", parameter="POWV_0230" }		
	local lifeStateCommand	= { id = "GetLifeStatus", }
	local ForceScared_ON	= { id = "SetForceScared", scared=true }
	local hostageId_B		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )
	local hostageId_C		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )
	local hostageId_D		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )
	local hostageId_E		= GameObject.GetGameObjectId( TARGET_INJURY_BOY )
	local lifeStatus_B		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , lifeStateCommand )
	local lifeStatus_C		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , lifeStateCommand )
	local lifeStatus_D		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , lifeStateCommand )
	local lifeStatus_E		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , lifeStateCommand )
	
	
	
	if	lifeStatus_B == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , voice )	
		GameObject.SendCommand( hostageId_B , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_B is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_C == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , voice )	
		GameObject.SendCommand( hostageId_C , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_C is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_D == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , voice )	
		GameObject.SendCommand( hostageId_D , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_D is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_E == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , voice )	
		GameObject.SendCommand( hostageId_E , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_E is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
end

function this.boyHostages_ACD_ForcedScare_ON()

	local voice				= { id="CallVoice", dialogueName="DD_chsol", parameter="POWV_0230" }		
	local lifeStateCommand	= { id = "GetLifeStatus", }
	local ForceScared_ON	= { id = "SetForceScared", scared=true }
	local hostageId_A		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )
	local hostageId_C		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )
	local hostageId_D		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )
	local hostageId_E		= GameObject.GetGameObjectId( TARGET_INJURY_BOY )
	local lifeStatus_A		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , lifeStateCommand )
	local lifeStatus_C		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , lifeStateCommand )
	local lifeStatus_D		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , lifeStateCommand )
	local lifeStatus_E		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , lifeStateCommand )
	
	
	
	if	lifeStatus_A == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , voice )	
		GameObject.SendCommand( hostageId_A , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_A is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_C == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , voice )	
		GameObject.SendCommand( hostageId_C , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_C is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_D == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , voice )	
		GameObject.SendCommand( hostageId_D , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_D is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_E == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , voice )	
		GameObject.SendCommand( hostageId_E , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_E is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
end

function this.boyHostages_ABD_ForcedScare_ON()

	local voice				= { id="CallVoice", dialogueName="DD_chsol", parameter="POWV_0230" }		
	local lifeStateCommand	= { id = "GetLifeStatus", }
	local ForceScared_ON	= { id = "SetForceScared", scared=true }
	local hostageId_A		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )
	local hostageId_B		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )
	local hostageId_D		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )
	local hostageId_E		= GameObject.GetGameObjectId( TARGET_INJURY_BOY )
	local lifeStatus_A		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , lifeStateCommand )
	local lifeStatus_B		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , lifeStateCommand )
	local lifeStatus_D		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , lifeStateCommand )
	local lifeStatus_E		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , lifeStateCommand )
	
	
	
	if	lifeStatus_A == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , voice )	
		GameObject.SendCommand( hostageId_A , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_A is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_B == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , voice )	
		GameObject.SendCommand( hostageId_B , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_B is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_D == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , voice )	
		GameObject.SendCommand( hostageId_D , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_D is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_E == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , voice )	
		GameObject.SendCommand( hostageId_E , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_E is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
end

function this.boyHostages_ABC_ForcedScare_ON()

	local voice				= { id="CallVoice", dialogueName="DD_chsol", parameter="POWV_0230" }		
	local lifeStateCommand	= { id = "GetLifeStatus", }
	local ForceScared_ON	= { id = "SetForceScared", scared=true }
	local hostageId_A		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )
	local hostageId_B		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )
	local hostageId_C		= GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )
	local hostageId_E		= GameObject.GetGameObjectId( TARGET_INJURY_BOY )
	local lifeStatus_A		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , lifeStateCommand )
	local lifeStatus_B		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , lifeStateCommand )
	local lifeStatus_C		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , lifeStateCommand )
	local lifeStatus_E		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , lifeStateCommand )
	
	
	
	if	lifeStatus_A == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , voice )	
		GameObject.SendCommand( hostageId_A , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_A is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_B == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , voice )	
		GameObject.SendCommand( hostageId_B , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_B is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_C == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , voice )	
		GameObject.SendCommand( hostageId_C , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_C is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
	
	if	lifeStatus_E == TppGameObject.NPC_LIFE_STATE_NORMAL	then
		GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , voice )	
		GameObject.SendCommand( hostageId_E , ForceScared_ON )
	else
		Fox.Log("TARGET_NORMAL_BOY_E is not NPC_LIFE_STATE_NORMAL ... Nothing Done !!")
	end
end



function this.hill0000_routeChange()
	
	TppEnemy.UnsetAlertRoute("sol_diamondHill_0000")
	
	TppEnemy.SetSneakRoute( "sol_diamondHill_0000" , "rts_hill0000_01" )
	TppEnemy.SetCautionRoute( "sol_diamondHill_0000" , "rts_hill0000_01" )
end
function this.hill0001_routeChange()
	
	TppEnemy.UnsetAlertRoute("sol_diamondHill_0001")
	
	TppEnemy.SetSneakRoute( "sol_diamondHill_0001" , "rts_hill0001_01" )
	TppEnemy.SetCautionRoute( "sol_diamondHill_0001" , "rts_hill0001_01" )
end
function this.hill0002_routeChange()
	
	TppEnemy.UnsetAlertRoute("sol_diamondHill_0002")
	
	TppEnemy.SetSneakRoute( "sol_diamondHill_0002" , "rts_hill0002_01" )
	TppEnemy.SetCautionRoute( "sol_diamondHill_0002" , "rts_hill0002_01" )
end
function this.hill0003_routeChange()
	
	TppEnemy.UnsetAlertRoute("sol_diamondHill_0003")
	
	TppEnemy.SetSneakRoute( "sol_diamondHill_0003" , "rts_hill0003_01" )
	TppEnemy.SetCautionRoute( "sol_diamondHill_0003" , "rts_hill0003_01" )
end
function this.hill0005_routeChange()
	
	TppEnemy.UnsetAlertRoute("sol_diamondHill_0005")
	
	TppEnemy.SetSneakRoute( "sol_diamondHill_0005" , "rts_hill0005_01" )
	TppEnemy.SetCautionRoute( "sol_diamondHill_0005" , "rts_hill0005_01" )
end
function this.hill0006_routeChange()
	
	TppEnemy.UnsetAlertRoute("sol_diamondHill_0006")
	
	TppEnemy.SetSneakRoute( "sol_diamondHill_0006" , "rts_hill0006_01" )
	TppEnemy.SetCautionRoute( "sol_diamondHill_0006" , "rts_hill0006_01" )
end
function this.hill0008_routeChange()
	
	TppEnemy.UnsetAlertRoute("sol_diamondHill_0008")
	
	TppEnemy.SetSneakRoute( "sol_diamondHill_0008" , "rts_hill0008_01" )
	TppEnemy.SetCautionRoute( "sol_diamondHill_0008" , "rts_hill0008_01" )
end
function this.hill0009_routeChange()
	
	TppEnemy.UnsetAlertRoute("sol_diamondHill_0009")
	
	TppEnemy.SetSneakRoute( "sol_diamondHill_0009" , "rts_hill0009_01" )
	TppEnemy.SetCautionRoute( "sol_diamondHill_0009" , "rts_hill0009_01" )
end






function this.MissionPrepare()
	local largeBlockNames = { "mafr_diamond" }
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " MissionPrepare ***")

	StageBlock.AddLargeBlockNameForMessage(largeBlockNames)	
	TppRatBird.EnableRat()	
	TppRatBird.EnableBird( "TppEagle" ) 

	TppMission.RegisterMissionSystemCallback{
		
		OnEndDeliveryWarp = function( stationUniqueId )
			local sequence = TppSequence.GetCurrentSequenceName() 
			if		stationUniqueId == TppPlayer.GetStationUniqueId( "banana" )	then
				Fox.Log("RT-Radio Trap Enter!!")
				svars.isInBanana = true
				if svars.isTargetClear == false		then
					s10100_radio.arrived_banana()			
					this.OptRadioControl()
				else
					Fox.Log("svars.isTargetClear == true ... Nothing Done !!")
				end
			elseif	stationUniqueId == TppPlayer.GetStationUniqueId( "diamond" )	then
				if ( sequence == "Seq_Game_BeforeRescueBoy" ) then
					s10100_radio.arrived_diamond()			
					s10100_radio.ChangeIntelRadio_inToDiamond()	
				else
					Fox.Log("No Setting Sequence ... Noting Done !!")
				end
			else
				Fox.Log("No Setting DANBO-RU STATION ... Noting Done !!")
			end
		end,
		
		CheckMissionClearFunction = function()
			return TppEnemy.CheckAllTargetClear()
		end,
		OnEstablishMissionClear = function( missionClearType )
			TppDemo.SetNextMBDemo( "ArrivedMotherBaseChildren" )	
			
			gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_Injury] 		= svars.isCollect_Injury
			gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_YellowHood]	= svars.isCollect_YellowHood
			gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_Aflo] 			= svars.isCollect_Aflo
			gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_ShortAflo] 	= svars.isCollect_ShortAflo
			gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_BlackCoat] 	= svars.isCollect_BlackCoat
			
			if svars.isCollect_Injury == true	then
				gvars.s10100_boyEscape[TppDefine.S10100_BOY_ENUM.Collect_Injury] = true
			else
				Fox.Log("svars.isCollect_Injury == false ... gvars dont save ... ")
			end
			if svars.isCollect_YellowHood == true	then
				gvars.s10100_boyEscape[TppDefine.S10100_BOY_ENUM.Collect_YellowHood] = true
			else
				Fox.Log("svars.isCollect_YellowHood == false ... gvars dont save ... ")
			end
			if svars.isCollect_Aflo == true	then
				gvars.s10100_boyEscape[TppDefine.S10100_BOY_ENUM.Collect_Aflo] = true
			else
				Fox.Log("svars.isCollect_Aflo == false ... gvars dont save ... ")
			end
			if svars.isCollect_ShortAflo == true	then
				gvars.s10100_boyEscape[TppDefine.S10100_BOY_ENUM.Collect_ShortAflo] = true
			else
				Fox.Log("svars.isCollect_ShortAflo == false ... gvars dont save ... ")
			end
			if svars.isCollect_BlackCoat == true	then
				gvars.s10100_boyEscape[TppDefine.S10100_BOY_ENUM.Collect_BlackCoat] = true
			else
				Fox.Log("svars.isCollect_BlackCoat == false ... gvars dont save ... ")
			end
			
			
			TppTerminal.AcquireKeyItem{
				dataBaseId = TppMotherBaseManagementConst.DESIGN_3013,
				pushReward = true,
			}
			
			if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
				TppTerminal.ReserveHelicopterSoundOnMissionGameEnd()	
				TppPlayer.PlayMissionClearCamera()
				TppMission.MissionGameEnd{
					loadStartOnResult = false,
					
					fadeDelayTime = TppPlayer.MISSION_CLEAR_CAMERA_FADE_DELAY_TIME,
					
					delayTime = TppPlayer.MISSION_CLEAR_CAMERA_DELAY_TIME,
				}
			else
				TppMission.MissionGameEnd{ loadStartOnResult = false }
			end
		end,
		
		OnOutOfHotZoneMissionClear = this.ReserveMissionClear, 		
		OnFultonContainerMissionClear = this.ContainerMissionClear,	
		
		OnRecovered = function( gameObjectId )
			if 		gameObjectId == GameObject.GetGameObjectId( TARGET_INJURY_BOY )	then
				svars.isCollect_Injury = true
				gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_Injury] 		= svars.isCollect_Injury
				svars.isReserveFlag_CNT_02 = svars.isReserveFlag_CNT_02 + 1
				
				if svars.isReserveFlag_CNT_02 ~= svars.isReserveFlag_CNT_06 and svars.isReserveFlag_06 == false	then
					this.log_targetCollect_INJRY()
				else
					Fox.Log("Nothing Done !!")
				end
			elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )	then
				svars.isCollect_YellowHood = true
				gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_YellowHood]	= svars.isCollect_YellowHood
				svars.isReserveFlag_CNT_02 = svars.isReserveFlag_CNT_02 + 1
				
				if svars.isReserveFlag_CNT_02 ~= svars.isReserveFlag_CNT_06 and svars.isReserveFlag_06 == false	then
					this.log_targetCollect_A()
				else
					Fox.Log("Nothing Done !!")
				end
			elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )	then
				svars.isCollect_Aflo = true
				gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_Aflo] 			= svars.isCollect_Aflo
				svars.isReserveFlag_CNT_02 = svars.isReserveFlag_CNT_02 + 1
				
				if svars.isReserveFlag_CNT_02 ~= svars.isReserveFlag_CNT_06 and svars.isReserveFlag_06 == false	then
					this.log_targetCollect_B()
				else
					Fox.Log("Nothing Done !!")
				end
			elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )	then
				svars.isCollect_ShortAflo = true
				gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_ShortAflo] 	= svars.isCollect_ShortAflo
				svars.isReserveFlag_CNT_02 = svars.isReserveFlag_CNT_02 + 1
				
				if svars.isReserveFlag_CNT_02 ~= svars.isReserveFlag_CNT_06 and svars.isReserveFlag_06 == false	then
					this.log_targetCollect_C()
				else
					Fox.Log("Nothing Done !!")
				end
			elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )	then
				svars.isCollect_BlackCoat = true
				gvars.s10100_boyEscapeCurrentPlay[TppDefine.S10100_BOY_ENUM.Collect_BlackCoat] 	= svars.isCollect_BlackCoat
				svars.isReserveFlag_CNT_02 = svars.isReserveFlag_CNT_02 + 1
				
				if svars.isReserveFlag_CNT_02 ~= svars.isReserveFlag_CNT_06 and svars.isReserveFlag_06 == false	then
					this.log_targetCollect_D()
				else
					Fox.Log("Nothing Done !!")
				end
			elseif gameObjectId == GameObject.GetGameObjectId( TARGET_ENEMY_NAME ) then
				svars.isTargetClear = true
				svars.isReserveFlag_16 = true
				
				if svars.isReserveFlag_06 == true or svars.isReserveFlag_10 == true then
					if	svars.isReserveFlag_10 == true	then
						Fox.Log("Nothin Done !!")
					else
						
						this.annouceLog_targetCollect()
					end
					
					this.annouceLog_achieveObjective()
					
					TppMission.UpdateObjective{ objectives = { "missionTask_1_bananaTarget_clear","missionTask_4_bananaTarget_collect_clear" }, }
					
					TppResult.AcquireSpecialBonus{ first = { isComplete = true,},}
				else
					Fox.Log("Nothing Done !!")
				end
			elseif gameObjectId == GameObject.GetGameObjectId( "sol_sniperA_0000" ) or gameObjectId == GameObject.GetGameObjectId( "sol_sniperA_0001" ) or gameObjectId == GameObject.GetGameObjectId( "sol_sniperA_0002" )
				or gameObjectId == GameObject.GetGameObjectId( "sol_sniperB_0000" ) or gameObjectId == GameObject.GetGameObjectId( "sol_sniperB_0001" )	then
				
					svars.isSniperCollect_CNT = svars.isSniperCollect_CNT + 1
					
					if svars.isSniperCollect_CNT >= SNIPER_CNT	then
						TppMission.UpdateObjective{
							objectives = { "missionTask_7_sniperAllCollect_clear",},
						}
					else
					end
			elseif gameObjectId == GameObject.GetGameObjectId( "veh_s10100_0000" ) or gameObjectId == GameObject.GetGameObjectId( "veh_s10100_0001" ) or gameObjectId == GameObject.GetGameObjectId( "veh_s10100_0002" )	then

					svars.isAcpCollect_CNT = svars.isAcpCollect_CNT + 1
					
					if svars.isAcpCollect_CNT >= 3	then
						TppMission.UpdateObjective{
							objectives = { "missionTask_8_AcpAllCollect_clear",},
						}
					else
					end
			else
				Fox.Log("NO SETTING CHARACTER !!")
			end
			
			if svars.isReserveFlag_06 == true	then
				if svars.isBoyHostagesCount_clear ~= svars.isReserveFlag_CNT_02	then
					
					this.boyHostages_logCheck()
					
					this.annouceLog_achieveObjective()
					
					TppMission.UpdateObjective{ objectives = { "missionTask_3_boyHostages_clear"},}
					if svars.isReserveFlag_CNT_02 == 5 and svars.isPrisonBreak == false		then
						TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}	
						TppMission.UpdateObjective{
							objectives = {"missionTask_5_perfectEscape_clear",},
						}
					else
						Fox.Log("isPrisonBreak == true ... SpecialBonus no get ...")
					end
				else
					Fox.Log("Nothing Done !!")
				end
			else
			end
        end,
        OnSetMissionFinalScore = function( missionClearType )
			
			if missionClearType == TppDefine.MISSION_CLEAR_TYPE.ON_FOOT then
				svars.isReserveFlag_06 = true
			






			else
			end
        end,
		OnEndMissionReward = this.OnEndMissionReward,			
		OnGameOver = this.OnGameOver							
	}

	
	TppScriptBlock.PreloadRequestOnMissionStart{
		{ demo_block = "Demo_MeetBoySoldier" },
	}
	
	if TppLocation.IsMiddleAfrica() then
		
		TppMarker.SetUpSearchTarget{
			
			{
				gameObjectName = TARGET_ENEMY_NAME,
				gameObjectType = "TppSoldier2",
				messageName = TARGET_ENEMY_NAME,
				skeletonName = "SKL_004_HEAD",
				func = this.bananaTargetAttestation,
			},	
		}
	end
end


function this.OnRestoreSVars()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** " .. tostring(missionName) .. " OnRestoreSVars ***")

	if TppLocation.IsMiddleAfrica() then
		TppRevenge.RegisterMissionMineList( this.MISSION_REVENGE_MINE_LIST )	
	else
		Fox.Log("Location is not MiddleAfrica ... Do Not Revenge Setting !!")
	end
end

function this.AddHighInterrogation()

	local sequence = TppSequence.GetCurrentSequenceName() 

	if ( sequence == "Seq_Game_BeforeRescueBoy" ) then
		
		if svars.isTargetClear == true or svars.isTargetAttestation == true or svars.isTargetInterrogation == true then
			TppInterrogation.ResetFlagHigh( GameObject.GetGameObjectId("mafr_banana_cp"))
		else
			TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("mafr_banana_cp"),
			{ 
				{ name = "enqt1000_101528",		func = s10100_enemy.InterCall_targetPosition, },
			} )
		end
		if svars.isReserveFlag_02 == false then
			TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("mafr_diamond_cp"),
			{ 
				{ name = "enqt1000_1i1210",		func = s10100_enemy.InterCall_hostagePosition, },
			} )
		else
			TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("mafr_diamond_cp"),
			{ 
				{ name = "enqt1000_1i1210",		func = s10100_enemy.InterCall_hostagePosition, },
			} )
		end
	else
		TppInterrogation.ResetFlagHigh( GameObject.GetGameObjectId("mafr_banana_cp"))
		TppInterrogation.ResetFlagHigh( GameObject.GetGameObjectId("mafr_diamond_cp"))
	end
	
	
	if svars.isReserveFlag_01 == false	then
		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("mafr_diamondWest_ob"),
		{ 
			{ name = "enqt1000_1c1010",		func = s10100_enemy.InterCall_acpPosition, },
		} )
	else
	end
	
	if svars.isReserveFlag_03 == false	then
		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("mafr_diamondNorth_ob"),
		{ 
			{ name = "enqt1000_101521",		func = s10100_enemy.InterCall_sniperA, },
		} )
	else
	end
	if svars.isReserveFlag_04 == false	then	
		TppInterrogation.AddHighInterrogation( GameObject.GetGameObjectId("mafr_diamondSouth_ob"),
		{ 
			{ name = "enqt1000_101521",		func = s10100_enemy.InterCall_sniperB, },
		} )
	else
	end
end

function this.boyHostages_prisonBreak()
	local prisonBreak_A = { type = "TppHostageUnique" , index = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) }
	local prisonBreak_B = { type = "TppHostageUnique" , index = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) }
	local prisonBreak_C = { type = "TppHostageUnique" , index = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) }
	local prisonBreak_D = { type = "TppHostageUnique" , index = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) }
	local prisonBreak_E = { type = "TppHostageUnique" , index = GameObject.GetGameObjectId( TARGET_INJURY_BOY ) }
	local prisonBreak = { id = "SetNoticeState", state = TppGameObject.HOSTAGE_NOTICE_STATE_FLEE }
	local unlockFalse = { id = "SetHostage2Flag", flag = "unlocked", on = false, }
	local unlockTrue = { id = "SetHostage2Flag", flag = "unlocked", on = true, }
	local ScaredMessage_ON = { id = "SetHostage2Flag", flag = "enableScaredMessage", on = true, }
	GameObject.SendCommand( prisonBreak_A , prisonBreak )
	GameObject.SendCommand( prisonBreak_B , prisonBreak )
	GameObject.SendCommand( prisonBreak_C , prisonBreak )
	GameObject.SendCommand( prisonBreak_D , prisonBreak )
	GameObject.SendCommand( prisonBreak_E , prisonBreak )
	
	GameObject.SendCommand( prisonBreak_A , unlockFalse )
	GameObject.SendCommand( prisonBreak_B , unlockFalse )
	GameObject.SendCommand( prisonBreak_C , unlockFalse )
	GameObject.SendCommand( prisonBreak_D , unlockFalse )
	GameObject.SendCommand( prisonBreak_E , unlockTrue )
	
	GameObject.SendCommand( prisonBreak_A , ScaredMessage_ON )
	GameObject.SendCommand( prisonBreak_B , ScaredMessage_ON )
	GameObject.SendCommand( prisonBreak_C , ScaredMessage_ON )
	GameObject.SendCommand( prisonBreak_D , ScaredMessage_ON )
	GameObject.SendCommand( prisonBreak_E , ScaredMessage_ON )
end



















function this.boyHostages_carrySetting()

	local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy , TARGET_NORMAL_BOY_A )			
	local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy , TARGET_NORMAL_BOY_B )			
	local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy , TARGET_NORMAL_BOY_C )			
	local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy , TARGET_NORMAL_BOY_D )			
	
	local lifeStateCommand	= { id = "GetLifeStatus", }
	local lifeStatus_A		= GameObject.SendCommand( gameObjectId_A, lifeStateCommand )
	local lifeStatus_B		= GameObject.SendCommand( gameObjectId_B, lifeStateCommand )
	local lifeStatus_C		= GameObject.SendCommand( gameObjectId_C, lifeStateCommand )
	local lifeStatus_D		= GameObject.SendCommand( gameObjectId_D, lifeStateCommand )
	local CarryNG			= {	id = "SetHostage2Flag", flag = "disableUnlock", on = true, }				
	local CarryOK			= {	id = "SetHostage2Flag", flag = "disableUnlock", on = false, }				
	
	if lifeStatus_A	~= 0 or svars.isBoyHostage_A_moveState == 3		then
			GameObject.SendCommand( gameObjectId_A , CarryOK )
	else
			GameObject.SendCommand( gameObjectId_A , CarryNG )
	end
	if lifeStatus_B	~= 0 or svars.isBoyHostage_B_moveState == 3		then
		GameObject.SendCommand( gameObjectId_B , CarryOK )			
	else
		GameObject.SendCommand( gameObjectId_B , CarryNG )
	end
	if lifeStatus_C	~= 0 or svars.isBoyHostage_C_moveState == 3		then
		GameObject.SendCommand( gameObjectId_C , CarryOK )			
	else
		GameObject.SendCommand( gameObjectId_C , CarryNG )
	end
	if lifeStatus_D	~= 0 or svars.isBoyHostage_C_moveState == 3		then
		GameObject.SendCommand( gameObjectId_D , CarryOK )			
	else
		GameObject.SendCommand( gameObjectId_D , CarryNG )
	end
end

function this.common_sequenceDisposal()
	local cpId_diamond			= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamond_cp") }
	local cpId_diamondSwamp		= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamondSwamp_cp") }
	local cpId_diamonddiamond	= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_diamondRiver_cp") }
	local cpId_tracking			= { type="TppCommandPost2", index = GameObject.GetGameObjectId("mafr_tracking_cp") }
	local KeepCaution_ON		= { id = "SetKeepCaution", enable = true }
	
	if svars.isPrisonBreak == true	then
		GameObject.SendCommand( cpId_diamond		, KeepCaution_ON )
		GameObject.SendCommand( cpId_diamondSwamp	, KeepCaution_ON )
		GameObject.SendCommand( cpId_diamonddiamond	, KeepCaution_ON )
		GameObject.SendCommand( cpId_tracking		, KeepCaution_ON )
	else
		Fox.Log("isPrisonBreak == false ... SNEAK PHASE")
	end
	this.checkPoint_OnOff()					
	this.boyHostages_Enable()				
	this.boyHostages_carrySetting()			
	this.boyHostages_prisonBreak()			

	this.orderCommand_OnOff()				
	this.boyHostages_continueRoute()		
	this.AddHighInterrogation()				
	this.photoCompleteCheck()				
	this.enemyHeliRoute()					
	this.BGM_Setting()						
	this.AddMapIconText()					
	this.missionInfoChange()				
	
	this.OptRadioControl()					
	
end




function this.Messages()
	return
	StrCode32Table {
		Block = {
			{
				msg = "OnChangeLargeBlockState",
				func = function( blockName , state )
					local sequence = TppSequence.GetCurrentSequenceName()
					if blockName == Fox.StrCode32( "mafr_diamond" ) and state == StageBlock.ACTIVE	then
						if ( sequence == "Seq_Game_BeforeRescueBoy" )	then
							Fox.Log("Event Door Setting ON")
							Gimmick.SetEventDoorLock( EVENT_DOOR_BOY , EVENT_DOOR_PATH , true , 0 )	
							Gimmick.SetEventDoorLock( EVENT_DOOR_DEMO , EVENT_DOOR_PATH , true , 0 )	
						elseif ( sequence ~= "Seq_Game_BeforeRescueBoy" )	then
							
							Gimmick.SetEventDoorLock( NORMAL_DOOR_A , NORMALE_DOOR_PATH , false, 0 )	
							Gimmick.SetEventDoorLock( NORMAL_DOOR_B , NORMALE_DOOR_PATH , false, 0 )	
							Gimmick.SetEventDoorLock( NORMAL_DOOR_C , NORMALE_DOOR_PATH , false, 0 )	
						else
							Fox.Log("Nothing Done !!")
						end
					else
						Fox.Log("Nothing Done !!")
					end
				end,
			},
		},
		GameObject = {
			{	
				msg = "AimedFromPlayer",
				func = function( gameObjectId )
					local phase_diamond			= TppEnemy.GetPhase("mafr_diamond_cp")
					local phase_diamondSwamp	= TppEnemy.GetPhase("mafr_diamondSwamp_cp")
					local phase_diamondRiver	= TppEnemy.GetPhase("mafr_diamondRiver_cp")
					local phase_diamondHill		= TppEnemy.GetPhase("mafr_tracking_cp")
					local voice_A	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVC010" }	
					local voice_B	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVC011" }	

					if phase_diamond == TppEnemy.PHASE.ALERT or phase_diamondSwamp == TppEnemy.PHASE.ALERT or phase_diamondRiver == TppEnemy.PHASE.ALERT or phase_diamondHill == TppEnemy.PHASE.ALERT then
						if		svars.isReserveFlag_CNT_03 == 0		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , voice_A )
							svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1 
						elseif	svars.isReserveFlag_CNT_03 == 1		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , voice_B )
							svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
						elseif	svars.isReserveFlag_CNT_03 == 2		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , voice_B )
							svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
						elseif	svars.isReserveFlag_CNT_03 == 3		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , voice_A )
							svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
						elseif	svars.isReserveFlag_CNT_03 == 4		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , voice_B )
							svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
						elseif	svars.isReserveFlag_CNT_03 == 5		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , voice_A )
							svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
						elseif	svars.isReserveFlag_CNT_03 == 6		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , voice_A )
							svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
						elseif	svars.isReserveFlag_CNT_03 == 7		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , voice_B )
							svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
						elseif	svars.isReserveFlag_CNT_03 == 8		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , voice_B )
							svars.isReserveFlag_CNT_03 = svars.isReserveFlag_CNT_03 + 1
						elseif	svars.isReserveFlag_CNT_03 == 9		then					
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , voice_A )
							svars.isReserveFlag_CNT_03 = 0
						else
							svars.isReserveFlag_CNT_03 = 0
						end
					else
						Fox.Log("Nothing Done !!")
					end
				end
			},
			{	
					msg = "CalledFromStandby", sender = SUPPORT_HELI,
					func = function()
						svars.isCalledSupportHeli = true
					end
			},
			{	
					msg = "RadioEnd",
					func = function( gameObjectId , cpId , label, succeed)
						if label == Fox.StrCode32("CPR0230") and svars.isPrisonBreak == false	then
							svars.isPrisonBreak = true			
							this.BGM_Setting()					
							s10100_radio.escapePerceived()		
							this.diamondAround_keepCaution()	
							if svars.isChaseEnemyCondition == true	then
								
								GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0000" ) , { id="SetEnabled", enabled=true } )
								GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0001" ) , { id="SetEnabled", enabled=true } )
								GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0002" ) , { id="SetEnabled", enabled=true } )
								GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0003" ) , { id="SetEnabled", enabled=true } )
								
								TppEnemy.SetSneakRoute( "sol_tracking_A_0000"  , "rts_tracking_A_0000" )
								TppEnemy.SetCautionRoute( "sol_tracking_A_0000"  , "rts_tracking_A_0000" )
								TppEnemy.SetSneakRoute( "sol_tracking_A_0001"  , "rts_tracking_A_0000" )
								TppEnemy.SetCautionRoute( "sol_tracking_A_0001"  , "rts_tracking_A_0000" )
								TppEnemy.SetSneakRoute( "sol_tracking_A_0002"  , "rts_tracking_A_0000" )
								TppEnemy.SetCautionRoute( "sol_tracking_A_0002"  , "rts_tracking_A_0000" )
								TppEnemy.SetSneakRoute( "sol_tracking_A_0003"  , "rts_tracking_A_0000" )
								TppEnemy.SetCautionRoute( "sol_tracking_A_0003"  , "rts_tracking_A_0000" )
							else
								Fox.Log("isChaseEnemyCondition == false ... ChaseEnemy Dont Enable ... ")
							end
						else
							Fox.Log("No Setting CP_RADIO")
						end
					end
			},
			{	
					msg = "BreakGimmick",
					func = function( gameObjectId , gameObjectName , name)
						
						if		gameObjectName == Fox.StrCode32("mafr_wtct002_vrtn001_gim_n0000|srt_mafr_wtct002")	then
							s10100_radio.ChangeIntelRadio_brokenBananaTower()
						
						elseif	gameObjectName == Fox.StrCode32("afgh_gnrt002_vrtn001_gim_n0000|srt_afgh_gnrt002_vrtn001")	then
							s10100_radio.ChangeIntelRadio_brokenHATSUDENKI()
						
						elseif	gameObjectName == Fox.StrCode32("mafr_fenc005_door004_gim_n0000|srt_mafr_fenc005_door004")	then
							s10100_radio.ChangeIntelRadio_brokenFrontGate()
						else
							Fox.Log("BreakGimmick MSG ... No Setting GIMMICK !!")
						end
					end
			},
			{	
					msg = "StartedDiscovery",
					func = function( gameObjectId , state )
						if		gameObjectId == GameObject.GetGameObjectId("sol_diamondHill_0000")	then
							this.hill0000_routeChange()
						elseif	gameObjectId == GameObject.GetGameObjectId("sol_diamondHill_0001")	then
							this.hill0001_routeChange()
						elseif	gameObjectId == GameObject.GetGameObjectId("sol_diamondHill_0002")	then
							this.hill0002_routeChange()
						elseif	gameObjectId == GameObject.GetGameObjectId("sol_diamondHill_0003")	then
							this.hill0003_routeChange()
						elseif	gameObjectId == GameObject.GetGameObjectId("sol_diamondHill_0005")	then
							this.hill0005_routeChange()
						elseif	gameObjectId == GameObject.GetGameObjectId("sol_diamondHill_0006")	then
							this.hill0006_routeChange()
						elseif	gameObjectId == GameObject.GetGameObjectId("sol_diamondHill_0008")	then
							this.hill0008_routeChange()
						elseif	gameObjectId == GameObject.GetGameObjectId("sol_diamondHill_0009")	then
							this.hill0009_routeChange()
						else
							Fox.Log("MSG = StartedDiscovery ... NO SETTING ENEMY")
						end
					end
			},
			{
				msg = "LostControl",
				func = function ( gameObjectId, state, Attacker )
					
					if	gameObjectId == GameObject.GetGameObjectId( ENEMY_HELI )	then
						if state == StrCode32("Start")	then
							svars.isEnemyHeliClear = true
						elseif state == StrCode32("End")	then
							
							
							TppMission.UpdateObjective{
								objectives = {"missionTask_6_BrokenEnemyHeli_clear",},
							}
						else
							Fox.Log("state is WRONG VALUE !!")
						end
					
					elseif gameObjectId == GameObject.GetGameObjectId( SUPPORT_HELI ) then
						if state == StrCode32("Start")	then
							Fox.Log("SUPPORT HELI LOST CONTROL START !!")
						elseif state == StrCode32("End")	then
						










						end
					else
						Fox.Log("No Setting HeliID ... ")
					end
				end
			},
			{	
				msg = "CommandPostAnnihilated",
				func = function ( cpID )
					
					if		cpID == GameObject.GetGameObjectId( "mafr_diamondSouth_ob" )	then
						svars.isAddEnemy_diamondSouth = true
					elseif	cpID == GameObject.GetGameObjectId( "mafr_diamond_cp" )	then
						svars.isEnemy_diamond = true
					elseif	cpID == GameObject.GetGameObjectId( "s10100_sniperA_cp" )	then
						TppMarker.Disable("Marker_sniperA")
						TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("mafr_diamondNorth_ob"),
						{ 
							{ name = "enqt1000_101521",		func = s10100_enemy.InterCall_sniperA, },
						} )
					elseif	cpID == GameObject.GetGameObjectId( "s10100_sniperB_cp" )	then
						TppMarker.Disable("Marker_sniperB")
						TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("mafr_diamondSouth_ob"),
						{ 
							{ name = "enqt1000_101521",		func = s10100_enemy.InterCall_sniperB, },
						} )
					else
						Fox.Log("No Setting Cp ... ")
					end
				end
			},
			{	
				msg = "Conscious",
				func = function ( GameObjectId )
					
					if GameObjectId == GameObject.GetGameObjectId( DIA_ADD_ENEMY_A ) or GameObjectId == GameObject.GetGameObjectId( DIA_ADD_ENEMY_B )	or GameObjectId == GameObject.GetGameObjectId( DIA_ADD_ENEMY_C )
					or GameObjectId == GameObject.GetGameObjectId( DIA_ADD_ENEMY_D ) or GameObjectId == GameObject.GetGameObjectId( DIA_ADD_ENEMY_E ) or GameObjectId == GameObject.GetGameObjectId( DIA_ADD_ENEMY_F ) then
						svars.isAddEnemy_diamondSouth = false
					
					elseif GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0000" ) or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0001" )	or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0002" ) or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0003" ) 
					or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0004" ) or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0005" )or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0006" ) or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0007" )
					or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0008" ) or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0009" ) or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0010" ) or GameObjectId == GameObject.GetGameObjectId( "sol_diamond_0011" )
					or GameObjectId == GameObject.GetGameObjectId( "sol_diamondSwamp_0000" ) or GameObjectId == GameObject.GetGameObjectId( "sol_diamondSwamp_0001" ) or GameObjectId == GameObject.GetGameObjectId( "sol_diamondSwamp_0002" )or GameObjectId == GameObject.GetGameObjectId( "sol_diamondSwamp_0003" ) then
						svars.isEnemy_diamond = false
					
					elseif	GameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)	then
						local gameObjectId	= GameObject.GetGameObjectId( gameObjectType_boy ,TARGET_NORMAL_BOY_A)
						local CarryNG			= {	id = "SetHostage2Flag", flag = "disableUnlock", on = true, }
						GameObject.SendCommand( gameObjectId , CarryNG )
					elseif	GameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)	then
						local gameObjectId	= GameObject.GetGameObjectId( gameObjectType_boy ,TARGET_NORMAL_BOY_B)
						local CarryNG			= {	id = "SetHostage2Flag", flag = "disableUnlock", on = true, }
						GameObject.SendCommand( gameObjectId , CarryNG )
					elseif	GameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)	then
						local gameObjectId	= GameObject.GetGameObjectId( gameObjectType_boy ,TARGET_NORMAL_BOY_C)
						local CarryNG			= {	id = "SetHostage2Flag", flag = "disableUnlock", on = true, }
						GameObject.SendCommand( gameObjectId , CarryNG )
					elseif	GameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)	then
						local gameObjectId	= GameObject.GetGameObjectId( gameObjectType_boy ,TARGET_NORMAL_BOY_D)
						local CarryNG			= {	id = "SetHostage2Flag", flag = "disableUnlock", on = true, }
						GameObject.SendCommand( gameObjectId , CarryNG )
					else
						Fox.Log("No Setting Enemy ... ")
					end
				end
			},
			{
				msg = "RoutePoint2" ,
				func = function ( gameObjectId , routeID , nodeNo , msgID )
					local unlockTrue		= { id = "SetHostage2Flag", flag = "unlocked", on = true, }
					local enemyHeliId		= GameObject.GetGameObjectId("TppEnemyHeli", ENEMY_HELI )
					local bananatarget		= GameObject.GetGameObjectId( "TppSoldier2", TARGET_ENEMY_NAME )				
					local gameObjectId_A	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A )		
					local gameObjectId_B	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B )		
					local gameObjectId_C	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C )		
					local gameObjectId_D	= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D )		
					
					local DownCommand		= { id = "ChangeLifeState", state = TppGameObject.NPC_LIFE_STATE_FAINT, stance = EnemyStance.STANCE_SUPINE }
					local everDownCommand	= { id = "SetEverDown", enabled=true }
					
					local Sneak_jointRoute01	= { id="SetSneakRoute"		, route="eneHeli_jointRoute01",		point=0	}
					local Caution_jointRoute01	= { id="SetCautionRoute"	, route="eneHeli_jointRoute01",		point=0	}
					local Sneak_jointRoute10	= { id="SetSneakRoute"		, route="eneHeli_jointRoute10",		point=0	}
					local Caution_jointRoute10	= { id="SetCautionRoute"	, route="eneHeli_jointRoute10",		point=0	}
					local Sneak_jointRoute20	= { id="SetSneakRoute"		, route="eneHeli_jointRoute20",		point=0	}
					local Caution_jointRoute20	= { id="SetCautionRoute"	, route="eneHeli_jointRoute20",		point=0	}
					local Sneak_jointRoute30	= { id="SetSneakRoute"		, route="eneHeli_jointRoute30",		point=0	}
					local Caution_jointRoute30	= { id="SetCautionRoute"	, route="eneHeli_jointRoute30",		point=0	}
					local Sneak_jointRoute40	= { id="SetSneakRoute"		, route="eneHeli_jointRoute40",		point=0	}
					local Caution_jointRoute40	= { id="SetCautionRoute"	, route="eneHeli_jointRoute40",		point=0	}
					local Sneak_jointRoute50	= { id="SetSneakRoute"		, route="eneHeli_jointRoute50",		point=0	}
					local Caution_jointRoute50	= { id="SetCautionRoute"	, route="eneHeli_jointRoute50",		point=0	}
					local Sneak_SearchHostages		= { id="SetSneakRoute"		, route="eneHeli_SearchHostages",		point=0	}
					local Caution_SearchHostages	= { id="SetCautionRoute"	, route="eneHeli_SearchHostages",		point=0	}
					local Sneak_jointBanana01		= { id="SetSneakRoute"		, route="eneHeli_jointBanana01",		point=0	}
					local Caution_jointBanana01		= { id="SetCautionRoute"	, route="eneHeli_jointBanana01",		point=0	}
					local Sneak_jointBanana02		= { id="SetSneakRoute"		, route="eneHeli_jointBanana02",		point=0	}
					local Caution_jointBanana02		= { id="SetCautionRoute"	, route="eneHeli_jointBanana02",		point=0	}
					local Sneak_eneHeli_banana		= { id="SetSneakRoute"		, route="eneHeli_banana",		point=5	}
					local Caution_eneHeli_banana	= { id="SetCautionRoute"	, route="eneHeli_banana",		point=5	}
					
					if	msgID == Fox.StrCode32( "commonArrivedMessage" ) then
						svars.isBoyHostagesCount_arrival = svars.isBoyHostagesCount_arrival + 1
						svars.isPassPoint_showGuide = false
						if 		gameObjectId == gameObjectId_A	then
							this.BoyHostage_A_WaitingRouteChange()
						elseif	gameObjectId == gameObjectId_B	then
							this.BoyHostage_B_WaitingRouteChange()
						elseif	gameObjectId == gameObjectId_C	then
							this.BoyHostage_C_WaitingRouteChange()
						elseif	gameObjectId == gameObjectId_D	then
							this.BoyHostage_D_WaitingRouteChange()
						else
							Fox.Log("gameObjectId is not boyHostages ...")
						end
					elseif	msgID == Fox.StrCode32( "commonWaitMessage" )	then
						this.boyHostages_RouteChangeCheck()	
					elseif	msgID == Fox.StrCode32( "passPointWaitMessage" )	then
						this.boyHostages_passPointWaitCheck()
					elseif	msgID == Fox.StrCode32( "lz_arrive_boyA" )	then
						svars.isBoyHostage_A_moveState = 3
						this.boyHostages_carrySetting()
						GameObject.SendCommand( gameObjectId_A , this.command_A0024_wait )	
						GameObject.SendCommand( gameObjectId_A , unlockTrue )
						s10100_radio.boyOnHeli_advice()
					elseif	msgID == Fox.StrCode32( "lz_arrive_boyB" )	then
						svars.isBoyHostage_B_moveState = 3
						this.boyHostages_carrySetting()
						GameObject.SendCommand( gameObjectId_B , this.command_B0024_wait )
						GameObject.SendCommand( gameObjectId_B , unlockTrue )
						s10100_radio.boyOnHeli_advice()
					elseif	msgID == Fox.StrCode32( "lz_arrive_boyC" )	then
						svars.isBoyHostage_C_moveState = 3
						this.boyHostages_carrySetting()
						GameObject.SendCommand( gameObjectId_C , this.command_C0024_wait )
						GameObject.SendCommand( gameObjectId_C , unlockTrue )
						s10100_radio.boyOnHeli_advice()	
					elseif	msgID == Fox.StrCode32( "lz_arrive_boyD" )	then
						svars.isBoyHostage_D_moveState = 3
						this.boyHostages_carrySetting()
						GameObject.SendCommand( gameObjectId_D , this.command_D0024_wait )
						GameObject.SendCommand( gameObjectId_D , unlockTrue )
						s10100_radio.boyOnHeli_advice()
					elseif	msgID == Fox.StrCode32( "loadLaugh" )	then
					
					
					
					elseif	msgID == Fox.StrCode32( "wav0000_routeChange_01" )	then
						s10100_enemy.wav0000_GO_02()
					elseif	msgID == Fox.StrCode32( "wav0000_routeChange_02" )	then
						s10100_enemy.wav0000_GO_01()
					elseif	msgID == Fox.StrCode32( "wav0001_routeChange_01" )	then
						s10100_enemy.wav0001_GO_02()
					elseif	msgID == Fox.StrCode32( "wav0001_routeChange_02" )	then
						s10100_enemy.wav0001_GO_01()
					elseif	msgID == Fox.StrCode32( "wav0002_routeChange_01" )	then
						s10100_enemy.wav0002_GO_02()
					elseif	msgID == Fox.StrCode32( "wav0002_routeChange_02" )	then
						s10100_enemy.wav0002_GO_01()
					elseif	msgID == Fox.StrCode32( "pursuersRadio_A" )	then
						
						if Tpp.IsHelicopter(vars.playerVehicleGameObjectId) then
							Fox.Log("PC in SupportHeli ... No Play Radio !!")
						else
							s10100_radio.stopPursuer()
						end
					elseif	msgID == Fox.StrCode32( "pursuersRadio_B" )	then
						
						if Tpp.IsHelicopter(vars.playerVehicleGameObjectId) then
							Fox.Log("PC in SupportHeli ... No Play Radio !!")
						else
							s10100_radio.reinforcementAppearance()
						end
					elseif	msgID == Fox.StrCode32( "hill0000_routeMSG" )	then
						this.hill0000_routeChange()
					elseif	msgID == Fox.StrCode32( "hill0001_routeMSG" )	then
						this.hill0001_routeChange()
					elseif	msgID == Fox.StrCode32( "hill0002_routeMSG" )	then
						this.hill0002_routeChange()
					elseif	msgID == Fox.StrCode32( "hill0003_routeMSG" )	then
						this.hill0003_routeChange()
					elseif	msgID == Fox.StrCode32( "hill0005_routeMSG" )	then
						this.hill0005_routeChange()
					elseif	msgID == Fox.StrCode32( "hill0006_routeMSG" )	then
						this.hill0006_routeChange()
					elseif	msgID == Fox.StrCode32( "hill0008_routeMSG" )	then
						this.hill0008_routeChange()
					elseif	msgID == Fox.StrCode32( "hill0009_routeMSG" )	then
						this.hill0009_routeChange()
					
					elseif	msgID == Fox.StrCode32( "eneHeli_jointRoute01" )	then
						if svars.isPrisonBreak == true	then
							GameObject.SendCommand( gameObjectId, Sneak_jointRoute01 )
							GameObject.SendCommand( gameObjectId, Caution_jointRoute01 )
						else
							Fox.Log("Nothing Done !!")
						end
					elseif	msgID == Fox.StrCode32( "eneHeli_jointRoute10" )	then
						if svars.isPrisonBreak == true	then
							GameObject.SendCommand( gameObjectId, Sneak_jointRoute10 )
							GameObject.SendCommand( gameObjectId, Caution_jointRoute10 )
						else
							Fox.Log("Nothing Done !!")
						end
					elseif	msgID == Fox.StrCode32( "eneHeli_jointRoute20" )	then
						if svars.isPrisonBreak == true	then
							GameObject.SendCommand( gameObjectId, Sneak_jointRoute20 )
							GameObject.SendCommand( gameObjectId, Caution_jointRoute20 )
						else
							Fox.Log("Nothing Done !!")
						end
					elseif	msgID == Fox.StrCode32( "eneHeli_jointRoute30" )	then
						if svars.isPrisonBreak == true	then
							GameObject.SendCommand( gameObjectId, Sneak_jointRoute30 )
							GameObject.SendCommand( gameObjectId, Caution_jointRoute30 )
						else
							Fox.Log("Nothing Done !!")
						end
					elseif	msgID == Fox.StrCode32( "eneHeli_jointRoute40" )	then
						if svars.isPrisonBreak == true	then
							GameObject.SendCommand( gameObjectId, Sneak_jointRoute40 )
							GameObject.SendCommand( gameObjectId, Caution_jointRoute40 )
						else
							Fox.Log("Nothing Done !!")
						end
					elseif	msgID == Fox.StrCode32( "eneHeli_jointRoute50" )	then
						if svars.isPrisonBreak == true	then
							GameObject.SendCommand( gameObjectId, Sneak_jointRoute50 )
							GameObject.SendCommand( gameObjectId, Caution_jointRoute50 )
						else
							Fox.Log("Nothing Done !!")
						end
					elseif	msgID == Fox.StrCode32( "SearchHostages_routeChange" )	then
						GameObject.SendCommand( enemyHeliId, Sneak_SearchHostages )
						GameObject.SendCommand( enemyHeliId, Caution_SearchHostages )
					elseif	msgID == Fox.StrCode32( "eneHeli_jointBanana01" )	then
						if svars.isBoyHostagesProgress >= 20 or svars.isReserveFlag_08 == true	then
							GameObject.SendCommand( enemyHeliId, Sneak_jointBanana01 )
							GameObject.SendCommand( enemyHeliId, Caution_jointBanana01 )
						else
							Fox.Log("Nothing Done !!")
						end
					elseif	msgID == Fox.StrCode32( "eneHeli_jointBanana02" )	then
						if svars.isBoyHostagesProgress >= 20 or svars.isReserveFlag_08 == true	then
							GameObject.SendCommand( enemyHeliId, Sneak_jointBanana02 )
							GameObject.SendCommand( enemyHeliId, Caution_jointBanana02 )
						else
							Fox.Log("Nothing Done !!")
						end
					elseif	msgID == Fox.StrCode32( "eneHeli_jointBanana01_2" )	then
						GameObject.SendCommand( enemyHeliId, Sneak_jointBanana01 )
						GameObject.SendCommand( enemyHeliId, Caution_jointBanana01 )
					elseif	msgID == Fox.StrCode32( "eneHeli_banana" )	then
						GameObject.SendCommand( enemyHeliId, Sneak_eneHeli_banana )
						GameObject.SendCommand( enemyHeliId, Caution_eneHeli_banana )
					
					elseif	msgID == Fox.StrCode32( "TrackinEnemy_MSG" )	then
						TppEnemy.SetSneakRoute( "sol_tracking_A_0000"  , "rts_tracking_A_0001" )
						TppEnemy.SetCautionRoute( "sol_tracking_A_0000"  , "rts_tracking_A_0001" )
						TppEnemy.SetSneakRoute( "sol_tracking_A_0001"  , "rts_tracking_A_0002" )
						TppEnemy.SetCautionRoute( "sol_tracking_A_0001"  , "rts_tracking_A_0002" )
						TppEnemy.SetSneakRoute( "sol_tracking_A_0002"  , "rts_tracking_A_0003" )
						TppEnemy.SetCautionRoute( "sol_tracking_A_0002"  , "rts_tracking_A_0003" )
						TppEnemy.SetSneakRoute( "sol_tracking_A_0003"  , "rts_tracking_A_0004" )
						TppEnemy.SetCautionRoute( "sol_tracking_A_0003"  , "rts_tracking_A_0004" )
					elseif	msgID == Fox.StrCode32( "fallDown" )	then
						this.boyHostages_fallDown( gameObjectId )
					elseif	msgID == Fox.StrCode32( "surprise" )	then
						this.boyHostages_surprise( gameObjectId )
					else
						Fox.Log("No Setting RouteMessage ...")
					end
				end
			},
			{	
				msg = "ChangePhase" ,
				func = function ( cpID , phase )
					Fox.Log("changePhase cpID is "..cpID.." !! (0:SNEAK 1:CAUTION 2:EVASION 3:ALERT)")
					if cpID == GameObject.GetGameObjectId("mafr_banana_cp") then
						Fox.Log("Phase is "..phase.." !!")
						if		phase == TppGameObject.PHASE_SNEAK		then
							Fox.Log("Re-Setting TARGET_ENEMY = groupA !!")
							
							TppEnemy.InitialRouteSetGroup {
								cpName = "mafr_banana_cp",
								soldierList = { TARGET_ENEMY_NAME },
								groupName = "groupA"
							}
						elseif	phase == TppGameObject.PHASE_CAUTION	then
							Fox.Log("TARGET_ENEMY ONLY CAUTION ROUTE !!")
							
							TppEnemy.SetCautionRoute( TARGET_ENEMY_NAME , "rts_target_c_0000" )
						elseif	phase == TppGameObject.PHASE_EVASION	then
						elseif	phase == TppGameObject.PHASE_ALERT		then
						else
							Fox.Error("CP CHANGE WRONG PHASE !!")
						end
					else
						Fox.Log("No Setting CP ... Check cpID ...")
					end
				end
			},
			{	
				msg = "Fulton" ,
				func = function ( gameObjectId )
					Fox.Log("Fulton SUCCESS!!")
					
					if gameObjectId == GameObject.GetGameObjectId(TARGET_ENEMY_NAME)			then
						if svars.isTargetAttestation == true	then
							s10100_radio.targetCollect()					
						else
							TppMission.UpdateObjective{ objectives = { "target_banana" }, }
							TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
							s10100_radio.targetCollectBeforeAttestation()	
							svars.isTargetAttestation = true				
						end
						this.After_bananaTargetClear()						
					
					elseif gameObjectId == GameObject.GetGameObjectId(TARGET_INJURY_BOY)			then
						svars.isCollect_Injury = true
						svars.isReserveFlag_CNT_06 = svars.isReserveFlag_CNT_06 + 1
						this.common_boyHostagesClearDisposal( gameObjectId )
					
					elseif gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)			then
						svars.isCollect_YellowHood = true
						this.boyHostage_A_noMove()
						svars.isReserveFlag_CNT_06 = svars.isReserveFlag_CNT_06 + 1
						this.common_boyHostagesClearDisposal( gameObjectId )
					
					elseif gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)			then
						svars.isCollect_Aflo = true
						this.boyHostage_B_noMove()
						svars.isReserveFlag_CNT_06 = svars.isReserveFlag_CNT_06 + 1
						this.common_boyHostagesClearDisposal( gameObjectId )
					
					elseif gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)			then
						svars.isCollect_ShortAflo = true
						this.boyHostage_C_noMove()
						svars.isReserveFlag_CNT_06 = svars.isReserveFlag_CNT_06 + 1
						this.common_boyHostagesClearDisposal( gameObjectId )
					
					elseif gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)			then
						svars.isCollect_BlackCoat = true
						this.boyHostage_D_noMove()
						svars.isReserveFlag_CNT_06 = svars.isReserveFlag_CNT_06 + 1
						this.common_boyHostagesClearDisposal( gameObjectId )
					
					elseif gameObjectId == GameObject.GetGameObjectId("veh_s10100_0000")
						or gameObjectId == GameObject.GetGameObjectId("veh_s10100_0001") or gameObjectId == GameObject.GetGameObjectId("veh_s10100_0002") then

						svars.isWavFulton_CNT = svars.isWavFulton_CNT + 1
						Fox.Log("svars.isWavFulton_CNT is "..svars.isWavFulton_CNT.." !!")
						
						if svars.isWavFulton_CNT >= 3	then
							TppMission.UpdateObjective{
								objectives = {"missionTask_8_AcpAllCollect",},
							}
						else
							Fox.Log("WAV FLUTON < 3 ... Nothing Done !!")
						end
					
					else
						Fox.Log("Character is not SettingCharacter ...")
					end
				end
			},
			{	
				msg = "FultonFailedEnd" ,
				func = function ( gameObjectId , locatorname , locatorNameUpper , failureType )
					Fox.Log("Fulton FAILDED ... ")
					
					if gameObjectId == GameObject.GetGameObjectId(TARGET_ENEMY_NAME) then
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE	then
							svars.isReserveFlag_09 = true
							if svars.isTargetAttestation == true	then
								s10100_radio.targetFulton_Fail()					
							else
								TppMission.UpdateObjective{ objectives = { "target_banana" }, }
								TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
								s10100_radio.targetFulton_FailBeforeAttestation()	
								svars.isTargetAttestation = true					
							end
							this.After_bananaTargetClear()							
						else
							Fox.Log("failureType ~= FULTON_FAILED_TYPE_ON_FINISHED_RISE ... Nothing Done !!")
						end
					
					elseif gameObjectId == GameObject.GetGameObjectId(TARGET_INJURY_BOY)	or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)
					or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)	or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)
					or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)	then
						if failureType == TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE	then
							TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.PLAYER_KILL_CHILD_SOLDIER, TppDefine.GAME_OVER_RADIO.PLAYER_KILL_CHILD_SOLDIER )	
						else
							Fox.Log("failureType ~= FULTON_FAILED_TYPE_ON_FINISHED_RISE ... Nothing Done !!")
						end
					
					else
						Fox.Log("Character is not SettingCharacter ...")
					end
				end
			},
			{	
				msg = "Unconscious" ,
				func = function ( gameObjectId , attackGameObjectId )
					Fox.Log("Unconscious gameObjectId is"..gameObjectId.." !!")
					
					if gameObjectId == GameObject.GetGameObjectId(TARGET_INJURY_BOY)	or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)
					or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)	or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)
					or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)	then
						
						if gameObjectId == GameObject.GetGameObjectId(TARGET_INJURY_BOY)			then
							Fox.Log("Nothing Done ... ")
						elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)	then
							Fox.Log("TARGET_NORMAL_BOY_A Unconscious ...")
							this.boyHostages_carrySetting()
							
						elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)	then
							Fox.Log("TARGET_NORMAL_BOY_B Unconscious ...")
							this.boyHostages_carrySetting()
							
						elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)	then
							Fox.Log("TARGET_NORMAL_BOY_C Unconscious ...")
							this.boyHostages_carrySetting()
							
						elseif	 gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)	then
							Fox.Log("TARGET_NORMAL_BOY_D Unconscious ...")
							this.boyHostages_carrySetting()
							
						else
							Fox.Log("Not BoyTarget Character ... ")
						end
					
					elseif gameObjectId == GameObject.GetGameObjectId(TARGET_ENEMY_NAME) then
						Fox.Log("isTargetAttestation is"..tostring(svars.isTargetAttestation).." !!")
						if svars.isTargetAttestation == true	then
							s10100_radio.unconsciousTarget()
						else
							Fox.Log("bananaTarget is before Attestation ... Nothing done ...")
						end
					
					else
						this.callVoice_enemyDown()
						Fox.Log("Not ClearTarget Character ... ")
					end
				end
			},
			{	
				msg = "PlacedIntoVehicle" ,
				func = function ( gameObjectId , vehicleType )
					
					if vehicleType == GameObject.GetGameObjectId( SUPPORT_HELI ) then
						
						if gameObjectId == GameObject.GetGameObjectId(TARGET_INJURY_BOY)			then
							this.common_boyHostagesClearDisposal( gameObjectId )
						
						elseif gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)			then
							this.boyHostage_A_noMove()
							this.common_boyHostagesClearDisposal( gameObjectId )
						
						elseif gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)			then
							this.boyHostage_B_noMove()
							this.common_boyHostagesClearDisposal( gameObjectId )
						
						elseif gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)			then
							this.boyHostage_C_noMove()
							this.common_boyHostagesClearDisposal( gameObjectId )
						
						elseif gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)			then
							this.boyHostage_D_noMove()
							this.common_boyHostagesClearDisposal( gameObjectId )
						
						elseif gameObjectId == GameObject.GetGameObjectId(TARGET_ENEMY_NAME) then
							svars.isReserveFlag_10 = true
							if svars.isTargetAttestation == true	then
								s10100_radio.targetCollect()					
							else
								s10100_radio.targetCollectBeforeAttestation()	
								svars.isTargetAttestation = true				
							end
							this.After_bananaTargetClear()						
						
						else
							Fox.Log("Character is not SettingCharacter ...")
						end
					else	
						Fox.Log("Not SUPPORT_HELI ... ")
					end
				end
			},
			{	
				msg = "Damage" ,
				func = function ( gameObjectId , attackId , attackGameObjectId )
					Fox.Log("gameObjectId = "..gameObjectId.." !!")
					Fox.Log("attackId = "..attackId.." !!")
					
					if gameObjectId == GameObject.GetGameObjectId(TARGET_INJURY_BOY)	or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)
					or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)	or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)
					or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)	then
						local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="EVN380" }		
						
						if attackGameObjectId == 0 then		
							if TppDamage.IsActiveByAttackId( attackId )	== false	then
								Fox.Log(" NonKillAttack ")
							else
								Fox.Log(" from PC !! ")
								
								if		gameObjectId == GameObject.GetGameObjectId(TARGET_INJURY_BOY)		then
									this.injuryBoy_forceDead()
									mvars.deadNPCId = TARGET_INJURY_BOY
								elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)	then
									this.movingBoy_A_forceDead()
									mvars.deadNPCId = TARGET_NORMAL_BOY_A
								elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)	then
									this.movingBoy_B_forceDead()
									mvars.deadNPCId = TARGET_NORMAL_BOY_B
								elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)	then
									this.movingBoy_C_forceDead()
									mvars.deadNPCId = TARGET_NORMAL_BOY_C
								elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)	then
									this.movingBoy_D_forceDead()
									mvars.deadNPCId = TARGET_NORMAL_BOY_D
								else
									Fox.Log("Damage from PC Character is not boyHostages ... ")
								end
								TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.PLAYER_KILL_CHILD_SOLDIER, TppDefine.GAME_OVER_RADIO.PLAYER_KILL_CHILD_SOLDIER )	
							end
						else								
							if svars.isReserveFlag_CNT_05 == 0	then
								GameObject.SendCommand( gameObjectId , voice )	
								svars.isReserveFlag_CNT_05 = svars.isReserveFlag_CNT_05 + 1
							elseif svars.isReserveFlag_CNT_05 >= 1 and 	svars.isReserveFlag_CNT_05 <= 5 then
								svars.isReserveFlag_CNT_05 = svars.isReserveFlag_CNT_05 + 1
							else
								svars.isReserveFlag_CNT_05 = 0
							end
						end
					
					else
						Fox.Log("damage Character is not boyHostages ...")
					end
				end
			},
			{	
				msg = "Dead" ,
				func = function ( gameObjectId , attackGameObjectId , phase , flag )
					Fox.Log("Dead gameObjectId is "..gameObjectId.." !!")
					
					if gameObjectId == GameObject.GetGameObjectId(TARGET_INJURY_BOY)	or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)
						or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)	or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)
						or gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)	then
						
						Fox.Log("boyHostages Die ...")
						if attackGameObjectId == 0	then
							
						else
							
							if		gameObjectId == GameObject.GetGameObjectId(TARGET_INJURY_BOY)		then
								mvars.deadNPCId = TARGET_INJURY_BOY
							elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_A)	then
								mvars.deadNPCId = TARGET_NORMAL_BOY_A
							elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_B)	then
								mvars.deadNPCId = TARGET_NORMAL_BOY_B
							elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_C)	then
								mvars.deadNPCId = TARGET_NORMAL_BOY_C
							elseif	gameObjectId == GameObject.GetGameObjectId(TARGET_NORMAL_BOY_D)	then
								mvars.deadNPCId = TARGET_NORMAL_BOY_D
							else
								Fox.Log("Dead Character is not boyHostages ... ")
							end
							TppMission.ReserveGameOver( TppDefine.GAME_OVER_TYPE.TARGET_DEAD, TppDefine.GAME_OVER_RADIO.TARGET_DEAD )	
						end
					
					elseif gameObjectId == GameObject.GetGameObjectId(TARGET_ENEMY_NAME) then
						
						if svars.isReserveFlag_09 == false	then
							if svars.isReserveFlag_10 == false	then			
								if svars.isTargetAttestation == true	then
									s10100_radio.targetKill()					
								else
									TppMission.UpdateObjective{ objectives = { "target_banana" }, }
									TppSoundDaemon.PostEvent( 'sfx_s_enemytag_main_tgt' )
									s10100_radio.targetKillBeforeAttestation()	
								end
								this.After_bananaTargetClear()					
							elseif svars.isReserveFlag_10 == true	then		
								this.bananaTarget_dead_AnnounceLog()			
							else
								Fox.Log("Hoken De AnnounceLog Wo Dasu YO")
								this.bananaTarget_dead_AnnounceLog()			
							end
						else
							Fox.Log("Nothing Done !!")
						end
					
					else
						this.callVoice_enemyDown()
						Fox.Log("DeadCharacter is not SettingCharacter ...")
					end
				end
			},
			{	
				msg = "ScaredStart" ,
				func = function ( hostageId )
					Player.ChangeCallMenuItemGoRescueBoy()	
				end
			},
			{	
				msg = "ScaredEnd" ,
				func = function ( gameObjectId )
					Player.ChangeCallMenuItemWaitRescueBoy()	
				end
			},
			{	
				msg = "DiscoveryHostage" ,
				func = function ( hostageId )
					local voice				= { id="CallVoice", dialogueName="DD_chsol", parameter="POWV_0260" }		
					local lifeStateCommand	= { id = "GetLifeStatus" }
					local lifeStatus_A		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , lifeStateCommand )
					local lifeStatus_B		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , lifeStateCommand )
					local lifeStatus_C		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , lifeStateCommand )
					local lifeStatus_D		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , lifeStateCommand )
					local lifeStatus_E		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , lifeStateCommand )
					this.controlGuide_orderChild()			
					s10100_radio.boyDiscoveried()
					
					if		hostageId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )	then
						if	lifeStatus_A == TppGameObject.NPC_LIFE_STATE_NORMAL	then
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , voice )	
							this.boyHostages_BCD_ForcedScare_ON()
						else
							Fox.Log("TARGET_NORMAL_BOY_A is not NPC_LIFE_STATE_NORMAL ... Another Boys Not Scare ... ")
						end
					elseif	hostageId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )	then
						if	lifeStatus_B == TppGameObject.NPC_LIFE_STATE_NORMAL	then
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , voice )	
							this.boyHostages_ACD_ForcedScare_ON()
						else
							Fox.Log("TARGET_NORMAL_BOY_B is not NPC_LIFE_STATE_NORMAL ... Another Boys Not Scare ... ")
						end
					elseif	hostageId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )	then
						if	lifeStatus_C == TppGameObject.NPC_LIFE_STATE_NORMAL	then
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , voice )	
							this.boyHostages_ABD_ForcedScare_ON()
						else
							Fox.Log("TARGET_NORMAL_BOY_C is not NPC_LIFE_STATE_NORMAL ... Another Boys Not Scare ... ")
						end
					elseif	hostageId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )	then
						if	lifeStatus_D == TppGameObject.NPC_LIFE_STATE_NORMAL	then
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , voice )	
							this.boyHostages_ABC_ForcedScare_ON()
						else
							Fox.Log("TARGET_NORMAL_BOY_D is not NPC_LIFE_STATE_NORMAL ... Another Boys Not Scare ... ")
						end
					elseif	hostageId == GameObject.GetGameObjectId( TARGET_INJURY_BOY )	then
						if	lifeStatus_E == TppGameObject.NPC_LIFE_STATE_NORMAL	then
							GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_INJURY_BOY ) , voice )	
						else
							Fox.Log("TARGET_INJURY_BOY is not NPC_LIFE_STATE_NORMAL ... ")
						end
					else
						Fox.Log("Discoveried Hostage is not BoyHostages ...")
					end
				end
			},
			{	
				msg = "PlayerGetNear" ,
				func = function ( gameObjectId )
					local PlayerGetNear_CNT = 0
					
					local lifeStateCommand	= { id = "GetLifeStatus", }
					local lifeStatus_A		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , lifeStateCommand )
					local lifeStatus_B		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , lifeStateCommand )
					local lifeStatus_C		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , lifeStateCommand )
					local lifeStatus_D		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , lifeStateCommand )
					
					local GetNotice_command = { id = "GetNoticeState" }
					local noticeState_A = GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , GetNotice_command )
					local noticeState_B = GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , GetNotice_command )
					local noticeState_C = GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , GetNotice_command )
					local noticeState_D = GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , GetNotice_command )
					
					Fox.Log("lifeState_A is "..lifeStatus_A.." !!")
					Fox.Log("isCollect_YellowHood is "..tostring(svars.isCollect_YellowHood).." !!")
					
					if		gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) and lifeStatus_A == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isCollect_YellowHood == false	then
						PlayerGetNear_CNT = PlayerGetNear_CNT + 1
					else
						Fox.Log("A_Nothin Done !!")
					end
					
					if		gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) and lifeStatus_B == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isCollect_Aflo == false	then
						PlayerGetNear_CNT = PlayerGetNear_CNT + 1
					else
						Fox.Log("B_Nothin Done !!")
					end				
					
					if		gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) and lifeStatus_C == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isCollect_ShortAflo == false	then
						PlayerGetNear_CNT = PlayerGetNear_CNT + 1
					else
						Fox.Log("C_Nothin Done !!")
					end
					
					if		gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) and lifeStatus_D == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isCollect_BlackCoat == false	then
						PlayerGetNear_CNT = PlayerGetNear_CNT + 1
					else
						Fox.Log("D_Nothin Done !!")
					end
					
					Fox.Log("PlayerGetNear_CNT = "..PlayerGetNear_CNT.." !!")
					if		PlayerGetNear_CNT == 0	then
						Player.DisableCallMenuItemRescueBoy()	
					elseif	PlayerGetNear_CNT >= 1	then		
						Player.EnableCallMenuItemRescueBoy()	
					











					else
						Fox.Error("PlayerGetNear_CNT is WRONG VALUE !!")
					end
				end
			},
			{	
				msg = "PlayerGetAway" ,
				func = function ( gameObjectId )
					local PlayerGetAway_CNT = 0
					
					local lifeStateCommand	= { id = "GetLifeStatus", }
					local lifeStatus_A		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) , lifeStateCommand )
					local lifeStatus_B		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) , lifeStateCommand )
					local lifeStatus_C		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) , lifeStateCommand )
					local lifeStatus_D		= GameObject.SendCommand( GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) , lifeStateCommand )
					
					if		gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) and lifeStatus_A == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isCollect_YellowHood == false	then
						PlayerGetAway_CNT = PlayerGetAway_CNT + 1
					else
						Fox.Log("A_Nothin Done !!")
					end
					
					if		gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) and lifeStatus_B == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isCollect_Aflo == false	then
						PlayerGetAway_CNT = PlayerGetAway_CNT + 1
					else
						Fox.Log("B_Nothin Done !!")
					end				
					
					if		gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) and lifeStatus_C == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isCollect_ShortAflo == false	then
						PlayerGetAway_CNT = PlayerGetAway_CNT + 1
					else
						Fox.Log("C_Nothin Done !!")
					end
					
					if		gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D ) and lifeStatus_D == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isCollect_BlackCoat == false	then
						PlayerGetAway_CNT = PlayerGetAway_CNT + 1
					else
						Fox.Log("D_Nothin Done !!")
					end
					
					Fox.Log("PlayerGetAway_CNT = "..PlayerGetAway_CNT.." !!")
					if			PlayerGetAway_CNT == 0	then
						Fox.Log("Nothin Done !!")
					elseif		PlayerGetAway_CNT >= 1	then
						Player.DisableCallMenuItemRescueBoy()				
						this.OrderWait_allClear()							
						
						if svars.isBoyHostagesProgress == 2	 and svars.isPassPointProgress == 1	 and svars.isBoyHostages_AutoMoveStop_01 == true then
							this.boyHostages_to2ndPassPoint()
						elseif svars.isBoyHostagesProgress == 6	 and svars.isPassPointProgress == 2	and svars.isBoyHostages_AutoMoveStop_02 == true then
							this.boyHostages_to3rdPassPoint()
						elseif svars.isBoyHostagesProgress == 9 and svars.isPassPointProgress == 3	and svars.isBoyHostages_AutoMoveStop_03 == true then
							this.boyHostages_to4thPassPoint()
						elseif svars.isBoyHostagesProgress == 14 and svars.isPassPointProgress == 4 and svars.isBoyHostages_AutoMoveStop_04 == true then
							this.boyHostages_to5thPassPoint()
						elseif svars.isBoyHostagesProgress == 23 and svars.isPassPointProgress == 5 and svars.isBoyHostages_AutoMoveStop_05 == true then
							this.boyHostages_lastDush()
						else
						end
					else
						Fox.Error("PlayerGetAway_CNT is WRONG VALUE !!")
					end
				end
			},
			{	
				msg = "Carried" ,
				func = function ( gameObjectId , carriedState )
					
					local lifeState_TARGET_INJURY_BOY		= GameObject.SendCommand( GameObject.GetGameObjectId( gameObjectType_boy, TARGET_INJURY_BOY ) , { id = "GetLifeStatus" } )
					local lifeState_TARGET_NORMAL_BOY_A		= GameObject.SendCommand( GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_A ) , { id = "GetLifeStatus" } )
					local lifeState_TARGET_NORMAL_BOY_B		= GameObject.SendCommand( GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_B ) , { id = "GetLifeStatus" } )
					local lifeState_TARGET_NORMAL_BOY_C		= GameObject.SendCommand( GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_C ) , { id = "GetLifeStatus" } )
					local lifeState_TARGET_NORMAL_BOY_D		= GameObject.SendCommand( GameObject.GetGameObjectId( gameObjectType_boy, TARGET_NORMAL_BOY_D ) , { id = "GetLifeStatus" } )
				
					if gameObjectId == GameObject.GetGameObjectId( TARGET_INJURY_BOY ) or gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )
					or gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B ) or gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )
					or gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )	then
						local voice	= { id="CallVoice", dialogueName="DD_chsol", parameter="POWV_0060" }		
						if 		carriedState == 0	then	
							Fox.Log("Nothing Done !!")
						elseif	carriedState == 1	then	
							Fox.Log("Nothing Done !!")
						elseif	carriedState == 2	then	
							if		gameObjectId == GameObject.GetGameObjectId( TARGET_INJURY_BOY )	then
								if lifeState_TARGET_INJURY_BOY == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isReserveFlag_CNT_04 == 0	then
									svars.isReserveFlag_CNT_04 = svars.isReserveFlag_CNT_04 + 1
									GameObject.SendCommand( gameObjectId , voice )
								else
									svars.isReserveFlag_CNT_04 = 0
								end
							elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )	then
								if lifeState_TARGET_NORMAL_BOY_A == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isReserveFlag_CNT_04 == 0	then
									svars.isReserveFlag_CNT_04 = svars.isReserveFlag_CNT_04 + 1
									GameObject.SendCommand( gameObjectId , voice )
								else
									svars.isReserveFlag_CNT_04 = 0
								end
							elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )	then
								if lifeState_TARGET_NORMAL_BOY_B == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isReserveFlag_CNT_04 == 0	then
									svars.isReserveFlag_CNT_04 = svars.isReserveFlag_CNT_04 + 1
									GameObject.SendCommand( gameObjectId , voice )
								else
									svars.isReserveFlag_CNT_04 = 0
								end
							elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )	then
								if lifeState_TARGET_NORMAL_BOY_C == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isReserveFlag_CNT_04 == 0	then
									svars.isReserveFlag_CNT_04 = svars.isReserveFlag_CNT_04 + 1
									GameObject.SendCommand( gameObjectId , voice )
								else
									svars.isReserveFlag_CNT_04 = 0
								end
							elseif	gameObjectId == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )	then
								if lifeState_TARGET_NORMAL_BOY_D == TppGameObject.NPC_LIFE_STATE_NORMAL and svars.isReserveFlag_CNT_04 == 0	then
									svars.isReserveFlag_CNT_04 = svars.isReserveFlag_CNT_04 + 1
									GameObject.SendCommand( gameObjectId , voice )
								else
									svars.isReserveFlag_CNT_04 = 0
								end
							else
								Fox.Log("Nothing Done !!")
							end
						else
							Fox.Log("Nothing Done !!")
						end
					else
						Fox.Log("Nothing Done !!")
					end
				end
			},
			nil
		},
		Radio = {
			{	
				msg = "Finish" , sender = "s0100_rtrg1020",
				func = function ()
					TppMission.UpdateObjective{
						objectives = { "default_area_banana","default_boySoldiers",},
					}
				end
			},
			{	
				msg = "Finish" , sender = "s0100_rtrg0040",
				func = function ()
					this.controlGuide_orderChild()
				end
			},
			{	
				msg = "Finish" , sender = "s0100_esrg1060",
				func = function ()
					TppMission.UpdateObjective{
						objectives = { "reduce_boySoldiers",},
					}
					TppInterrogation.RemoveHighInterrogation( GameObject.GetGameObjectId("mafr_diamond_cp"),
					{ 
						{ name = "enqt1000_1i1210",		func = s10100_enemy.InterCall_hostagePosition, },
					} )
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg1561",
				func = function ()
					this.boyHostages_logCheck()
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg1562",
				func = function ()
					this.boyHostages_logCheck()
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg1563",
				func = function ()
					this.boyHostages_logCheck()
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg1564",
				func = function ()
					this.boyHostages_logCheck()
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg1565",
				func = function ()
					this.boyHostages_logCheck()
				end
			},
			{	
				msg = "Finish" , sender = "s0100_rtrg2180",
				func = function ()
					if svars.isTargetAttestation == true	then
						Fox.Log("isTargetAttestation == true ... Nothing Done ...")
					else
						if svars.isTargetInterrogation == true	then
							TppMission.UpdateObjective{
								objectives = { "bananaTarget_subGoal", "reduce_area_banana_2nd" },
							}
						else
							TppMission.UpdateObjective{
								objectives = {  "bananaTarget_subGoal", "default_area_banana_2nd" },
							}
						end
					end
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg2400",
				func = function ()
					this.After_bananaTargetClearRadio()
					this.bananaTarget_dead_AnnounceLog()		
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg2390",
				func = function ()
					this.After_bananaTargetClearRadio()
					this.bananaTarget_dead_AnnounceLog()		
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg2410",
				func = function ()
					this.After_bananaTargetClearRadio()
					this.bananaTarget_collect_AnnounceLog()		
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg2370",
				func = function ()
					this.After_bananaTargetClearRadio()
					this.bananaTarget_collect_AnnounceLog()		
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg2430",
				func = function ()
					this.After_bananaTargetClearRadio()
					this.bananaTarget_dead_AnnounceLog()		
				end
			},
			{	
				msg = "Finish" , sender = "f1000_rtrg2425",
				func = function ()
					this.After_bananaTargetClearRadio()
					this.bananaTarget_dead_AnnounceLog()		
				end
			},
			nil
		},
		Timer = {
			{
				msg = "Finish",	sender = "timer_boyHostagesCollect",	
				func = function()
					TppMission.UpdateObjective{ objectives = { "missionTask_3_boyHostages_clear"},}
				end
			},
			{
				msg = "Finish",	sender = "timer_boyHostagesCollect_2",	
				func = function()
					if svars.isPrisonBreak == false		then
						TppResult.AcquireSpecialBonus{ second = { isComplete = true,},}	
						TppMission.UpdateObjective{
							objectives = {"missionTask_5_perfectEscape_clear",},
						}
					else
						Fox.Log("isPrisonBreak == true ... SpecialBonus no get ...")
					end
				end
			},
			{
				msg = "Finish",	sender = "timer_bananaTarget",	
				func = function()
					local sequence	= TppSequence.GetCurrentSequenceName()
					if 		sequence == "Seq_Game_BeforeRescueBoy"	then
						TppMission.UpdateObjective{ objectives = { "bananaTargetClear_subGoal" },}
					else
						Fox.Log("sequence is not Seq_Game_BeforeRescueBoy ... nothing Done !!")
					end
					if svars.isReserveFlag_16 == true	then
						TppMission.UpdateObjective{ objectives = { "missionTask_1_bananaTarget_clear","missionTask_4_bananaTarget_collect_clear" }, }
					else
						TppMission.UpdateObjective{ objectives = { "missionTask_1_bananaTarget_clear" }, }
					end
				end
			},
			{
				msg = "Finish",	sender = "timer_JingleCharred",	
				func = function()
					local phase_diamondSwamp	= TppEnemy.GetPhase("mafr_diamondSwamp_cp")
					local checkInCamera = Player.AddSearchTarget{
						name					= "charred_locator",
						dataIdentifierName		= "jingle_Identifier",
						keyName					= "jingle_charred",
						distance				= 15,
						checkImmediately		= true,
					}
					
					if checkInCamera == true and Player.GetGameObjectIdIsRiddenToLocal() == 65535 and Player.IsOnTheLoadingPlatform() == false and phase_diamondSwamp == TppEnemy.PHASE.SNEAK		then
						
						if PlayerInfo.OrCheckStatus{ PlayerStatus.DASH, PlayerStatus.BINOCLE, } then
							TimerStart( "timer_JingleCharred", 1 )		
						else	
							
							TppSoundDaemon.PostEvent( 'sfx_s_bgm_dead_body' )
							
							Player.StartTargetConstrainCamera {
								cameraType = PlayerCamera.Around,		
								force = false,							
								fixed = false,							
								recoverPreOrientation = false,			
								dataIdentifierName = "jingle_Identifier",	
								keyName = "jingle_charred",				
								interpTime = 1.0,						
								time = 3,								
								focalLength = 32.0,						
								focalLengthInterpTime = 1.5,			
								minDistance = 5.0,						
								maxDistanve = 20.0,						
								doCollisionCheck = true,				
							}
							svars.isReserveFlag_17 = true
							GkEventTimerManager.Stop( "timer_JingleCharred" )	
						end
					else
						TimerStart( "timer_JingleCharred", 1 )		
					end
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
		Trap = {
			{	
				msg = "Enter",
				sender = "farAway_TRAP",
				func = function ()
					local caveDoor_state	= Gimmick.IsDoorLocking ( CAVE_DOOR_DATA , CAVE_DOOR_PATH )	
					local sequence			= TppSequence.GetCurrentSequenceName()
					
					if 		sequence ~= "Seq_Game_BeforeRescueBoy" and svars.isPassPointProgress == 0 and caveDoor_state == true then
						Gimmick.SetEventDoorLock( CAVE_DOOR_DATA , CAVE_DOOR_PATH , false, 0 )	
					else
						Fox.Log("Nothing Done!!")
					end
				end
			},
			{	
				msg = "Enter",
				sender = "EventDoor_Trap",
				func = function ()
					local sequence = TppSequence.GetCurrentSequenceName()
					if 		sequence == "Seq_Game_BeforeRescueBoy" then
						Fox.Log("Event Door Setting ON")
						Gimmick.SetEventDoorLock( EVENT_DOOR_BOY , EVENT_DOOR_PATH , true , 0 )	
						Gimmick.SetEventDoorLock( EVENT_DOOR_DEMO , EVENT_DOOR_PATH , true , 0 )	
					else
						Fox.Log("NOthing Done !!")
					end
				end
			},
			{	
				msg = "Enter",
				sender = "jingleCharredTrap",
				func = function ()
					if svars.isReserveFlag_17 == false	then
						TimerStart( "timer_JingleCharred", 1 )		
					else
						Fox.Log("Nothing Done !!")
					end
				end
			},
			{	
				msg = "Exit",
				sender = "jingleCharredTrap",
				func = function ()
					GkEventTimerManager.Stop( "timer_JingleCharred" )	
				end
			},
			{	
				msg = "Enter",
				sender = "carryInjuryBoyHostage",
				func = function ()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence ~= "Seq_Game_BeforeRescueBoy" then
						s10100_radio.carryInjuryBoyHostage()
					else
						Fox.Log("Seq_Game_BeforeRescueBoy ... Nothing Done !!")
					end
				end
			},
			{	
				msg = "Enter",
				sender = "boyHostagesRC_inCave01",
				func = function ()
					local sequence			= TppSequence.GetCurrentSequenceName()
					
					local gameObjectId		= GameObject.GetGameObjectId( gameObjectType_boy, TARGET_INJURY_BOY )			
					local GetLife_command	= { id = "GetLifeStatus" }
					local lifeState			= GameObject.SendCommand( gameObjectId , GetLife_command )

					if sequence ~= "Seq_Game_BeforeRescueBoy" then
						svars.isBoyHostagesRC_inCave01 = true							
						
						Fox.Log("TARGET_INJURY_BOY lifeState is "..lifeState.." !!")
						if lifeState == TppGameObject.NPC_LIFE_STATE_NORMAL	then
							local isInRangeFlag = GameObject.SendCommand( gameObjectId, {
							id="IsInRange",
							range = INJURY_BOY_RANGE,
							target = { vars.playerPosX, vars.playerPosY, vars.playerPosZ },
							} )
							Fox.Log(tostring(isInRangeFlag))
							if isInRangeFlag == true  then	
								Fox.Log("TARGET_INJURY_BOY Position IN INJURY_BOY_RANGE from PC")
							else								
								if svars.isBoyHostagesProgress == 0 or svars.isBoyHostagesProgress == 1	then
									if svars.isCollect_Injury == false	then
										if TppMotherBaseManagement.IsEquipDeveloped{ equipID = TppEquip.EQP_IT_Fulton_WormHole } == false then
											s10100_radio.injury_boyHostage()
										else
											Fox.Log("NOthing Done !!")
										end
									else
										Fox.Log("NOthing Done !!")
									end
								else
									Fox.Log("isBoyHostagesProgress >= 2 ... TARGET_INJURY_BOY is IGNORE !!")
								end
							end
						else
							Fox.Log("TARGET_INJURY_BOY is Not NPC_LIFE_STATE_NORMAL...")
						end
					else
						Fox.Log("Seq_Game_BeforeRescueBoy ... Nothing Done !!")
					end
				end
			},
			{	
				msg = "Enter",
				sender = "boyHostagesRC_inCave02",
				func = function ()
					local sequence			= TppSequence.GetCurrentSequenceName()
					if sequence ~= "Seq_Game_BeforeRescueBoy" then
						if svars.isBoyHostagesCount_clear ~= 5	then
							s10100_radio.gameOver_announce()
						else
							Fox.Log("boyHostages All Collect ... Nothing Done !!")
						end
					else
						Fox.Log("Seq_Game_BeforeRescueBoy ... Nothing Done !!")
					end
				end
			},
			{	
				msg = "Enter",
				sender = "trap_CHK_s10100_01",
				func = function ()
					TppCheckPoint.UpdateAtCurrentPosition()
				end
			},
			{	
				msg = "Enter",
				sender = "trap_CHK_s10100_02",
				func = function ()
					
				end
			},
			{	
				msg = "Enter",
				sender = "trap_CHK_s10100_03",
				func = function ()
					TppCheckPoint.UpdateAtCurrentPosition()
				end
			},
			{	
				msg = "Enter",
				sender = "trap_CHK_s10100_04",
				func = function ()
				
				end
			},
			{	
				msg = "Enter",
				sender = "trap_CHK_s10100_05",
				func = function ()
					TppCheckPoint.UpdateAtCurrentPosition()
				end
			},
			{	
				msg = "Enter",
				sender = "farAway_boyHostages01",
				func = function ()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence ~= "Seq_Game_BeforeRescueBoy" and svars.isBoyHostagesCount_clear == 0 and svars.isPrisonBreak == false then
						s10100_radio.awayFrom_boyHostages()
					else
						Fox.Log("Nothing Done !!")
					end
				end
			},
			{	
				msg = "Enter",
				sender = "farAway_boyHostages02",
				func = function ()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence ~= "Seq_Game_BeforeRescueBoy" and svars.isBoyHostagesCount_clear == 0 and svars.isPrisonBreak == false then
						s10100_radio.detourRv()
					else
						Fox.Log("Nothing Done !!")
					end
				end
			},
			{	
				msg = "Enter",
				sender = "diamondHill_AddEnemy",
				func = function ()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence ~= "Seq_Game_BeforeRescueBoy"	then
						this.pursuersEnemyEnable()
					else
						Fox.Log("Nothing Done !!")
					end
				end
			},
			{	
				msg = "Enter",
				sender = "ComeToSupportHeli",
				func = function ()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence ~= "Seq_Game_BeforeRescueBoy" and svars.isBoyHostagesCount_clear < 5	then
						this.AutoComingSupportHeli()
						svars.isReserveFlag_08 = true
					else
						Fox.Log("Nothing Done !!")
					end
				end
			},
			{	
				msg = "Enter",
				sender = "DiscoveriedBoyHostages",
				func = function ()
					local sequence = TppSequence.GetCurrentSequenceName()
					if sequence ~= "Seq_Game_BeforeRescueBoy" and svars.isBoyHostagesCount_clear < 5	then
						svars.isChaseEnemyCondition = true
						this.boyHostagesDiscoveriedEscape()
					else
						Fox.Log("Nothing Done !!")
					end
				end
			},
			{	
				msg = "Enter", sender = "inToDiamond",
				func = function ()
					s10100_radio.ChangeIntelRadio_inToDiamond()
				end
			},
			{	
				msg = "Enter", sender = "inToDiamond_CAVE",
				func = function ()
					s10100_radio.ChangeIntelRadio_inToDiamond_Cave()
				end
			},
			{	
				msg = "Enter", sender = "trap_intel_mafr_banana_cp",
				func = function ()
					Fox.Log("RT-Radio Trap Enter!!")
					if TppPlayer.IsDeliveryWarping() == false	then
						svars.isInBanana = true
						if svars.isTargetClear == false		then
							s10100_radio.arrived_banana()			
							this.OptRadioControl()
						else
						end
					elseif TppPlayer.IsDeliveryWarping() == true	then
						Fox.Log("DANBO-RU WARP ... Nothing Done !!")
					else
						Fox.Error("TppPlayer.IsDeliveryWarping() is WRONG VALUE !!")
					end
				end
			},
			{	
				msg = "Exit", sender = "trap_intel_mafr_banana_cp",
				func = function ()
					svars.isInBanana = false
					this.OptRadioControl()
				end
			},			
			{	
				msg = "Enter", sender = "boyHostages_WaitUnlock01",
				func = function ()
					Fox.Log("boyHostages_WaitUnlock01 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_01 = true
				end
			},
			{	
				msg = "Enter", sender = "boyHostages_WaitUnlock02",
				func = function ()
					Fox.Log("boyHostages_WaitUnlock02 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_02 = true
				end
			},
			{	
				msg = "Enter", sender = "boyHostages_WaitUnlock03",
				func = function ()
					Fox.Log("boyHostages_WaitUnlock03 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_03 = true
				end
			},
			{	
				msg = "Enter", sender = "boyHostages_WaitUnlock04",
				func = function ()
					Fox.Log("boyHostages_WaitUnlock04 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_04 = true
				end
			},
			{	
				msg = "Enter", sender = "boyHostages_WaitUnlock05",
				func = function ()
					Fox.Log("boyHostages_WaitUnlock05 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_05 = true
				end
			},
			{	
				msg = "Enter", sender = "boyHostages_WaitLock01",
				func = function ()
					Fox.Log("boyHostages_WaitLock01 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_01 = false
				end
			},
			{	
				msg = "Enter", sender = "boyHostages_WaitLock02",
				func = function ()
					Fox.Log("boyHostages_WaitLock02 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_02 = false
				end
			},
			{	
				msg = "Enter", sender = "boyHostages_WaitLock03",
				func = function ()
					Fox.Log("boyHostages_WaitLock03 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_03 = false
				end
			},
			{	
				msg = "Enter", sender = "boyHostages_WaitLock04",
				func = function ()
					Fox.Log("boyHostages_WaitLock04 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_04 = false
				end
			},
			{	
				msg = "Enter", sender = "boyHostages_WaitLock05",
				func = function ()
					Fox.Log("boyHostages_WaitLock05 Trap Enter!!")
					svars.isBoyHostages_AutoMoveStop_05 = false
				end
			},
			nil
		},
		Player = {
			{
				msg = "PressedFultonNgIcon",
				func = function ( arg1 , arg2 )
					if arg2 == GameObject.GetGameObjectId( TARGET_INJURY_BOY )	or arg2 == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A ) or arg2 == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )
						or arg2 == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C ) or arg2 == GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )	then
		
						if		svars.isBoyHostagesFLTN_CNT == 0	then
							s10100_radio.BoyFultonNg_01()
							svars.isBoyHostagesFLTN_CNT = svars.isBoyHostagesFLTN_CNT + 1
						elseif	svars.isBoyHostagesFLTN_CNT == 1	then
							s10100_radio.BoyFultonNg_02()
							svars.isBoyHostagesFLTN_CNT = svars.isBoyHostagesFLTN_CNT + 1
						elseif	svars.isBoyHostagesFLTN_CNT == 2	then
							if TppMotherBaseManagement.IsEquipDeveloped{ equipID = TppEquip.EQP_IT_Fulton_Child } == true then
								s10100_radio.BoyFultonNg_01()
								svars.isBoyHostagesFLTN_CNT = 1
							else
								s10100_radio.BoyFultonNg_03()		
								svars.isBoyHostagesFLTN_CNT = 0
							end
						else
							s10100_radio.BoyFultonNg_01()
						end
					else
						Fox.Log("No Setting Character ... ")
					end
				end
			},
			{	
				msg = "RideHelicopter" ,
				func = function ()
					this.supportHeli_waitTimeSetting()
					local sequence = TppSequence.GetCurrentSequenceName() 
					if ( sequence == "Seq_Game_BeforeRescueBoy" ) then
						s10100_radio.notClearFactor_onHeli()
					else
						if svars.isBoyHostagesCount_clear < 5	then
							s10100_radio.not_AllBoysClear_toHotZone()
						else
							Fox.Log("Not Game Sequence ... ")
						end
					end
					
					if svars.isTargetClear == true and svars.isBoyHostagesCount_clear > 0 and svars.isBoyHostagesCount_clear < 5	then
						TppSound.SetStartHeliClearJingleName( "Play_bgm_mission_clear_heli_sad" )
					else
						Fox.Log("Nothing Done !!")
					end
				end
			},
			{	
				msg = "CallMenuMessage_RescueBoyGo",
				func = function ()
					local hostageId_A = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_A )
					local hostageId_B = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_B )
					local hostageId_C = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_C )
					local hostageId_D = GameObject.GetGameObjectId( TARGET_NORMAL_BOY_D )
					local ForceScared_OFF = { id="SetForceScared", scared=false, time=30.0 }

					Fox.Log("ORDER Go!Go!Go!")
					this.OrderWait_allClear()
					
					GameObject.SendCommand( hostageId_A, ForceScared_OFF )
					GameObject.SendCommand( hostageId_B, ForceScared_OFF )
					GameObject.SendCommand( hostageId_C, ForceScared_OFF )
					GameObject.SendCommand( hostageId_D, ForceScared_OFF )
					
					if svars.isBoyHostagesProgress == 2 and svars.isPassPointProgress == 1	then
						this.boyHostages_to2ndPassPoint()
					elseif svars.isBoyHostagesProgress == 6 and svars.isPassPointProgress == 2	then
						this.boyHostages_to3rdPassPoint()
					elseif svars.isBoyHostagesProgress == 9 and svars.isPassPointProgress == 3	then
						this.boyHostages_to4thPassPoint()
					elseif svars.isBoyHostagesProgress == 14 and svars.isPassPointProgress == 4	then
						this.boyHostages_to5thPassPoint()
					elseif svars.isBoyHostagesProgress == 23 and svars.isPassPointProgress == 5	then
						this.boyHostages_lastDush()
					else
						Fox.Log("boyHostages are not arrive hill ... ")
					end
				end
			},
			{	
				msg = "CallMenuMessage_RescueBoyWait",
				func = function ()
					Fox.Log("ORDER Wait!!")
					
					for i, boyName in pairs( boyHostagesName_TABLE ) do
						local boyHostagesGID = GameObject.GetGameObjectId( boyName )
						GameObject.SendCommand( boyHostagesGID, {
							id="SpecialAction",
							action="ChildProne",
							path="/Assets/tpp/motion/SI_game/fani/bodies/enet/enetnon/enetnon_ful_idl.gani",
							autoFinish=false,
							enableMessage=true,
							enableGravity=false,
							enableCollision=false,
						} )
					end
					Player.ChangeCallMenuItemGoRescueBoy()		
				end
			},
			{	
				msg = "CallMenuMessage_ShowCallMenu",
				func = function ()
					Fox.Log("Open CallMenu !!")
					local sequence = TppSequence.GetCurrentSequenceName() 
					if sequence ~= "Seq_Game_BeforeRescueBoy"	then
						
						if Player.IsEnableCallMenuItemRescueBoy() == false	and svars.isFarDistanceOrderNG == false then
							svars.isFarDistanceOrderNG = true
							s10100_radio.farmessFrom_boyHostages()	
						else
						end
					else
						Fox.Log("Nothing Done!!")
					end
				end
			},
			{	
				msg = "CallMenuMessage_HideCallMenu",
				func = function ()
					Fox.Log("Close CallMenu !!")
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
	}
end




sequences.Seq_Game_BeforeRescueBoy = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Player = {
				{
					msg = "CheckEventDoorNgIcon",
					func = function(playerId,doorId)
						Fox.Log("player in event door")
						local isPlaying = TppRadioCommand.IsPlayingRadio()
						local result,checkAlert,checkEnemy = TppDemo.CheckEventDemoDoor(doorId,CHECK_ENEMY_POS,CHECK_ENEMY_RANGE)
						
						if result == true then
							Fox.Log("check is ok")
							if svars.isDemoDoor_Alert == true	then
									s10100_radio.Alert_off()
									svars.isDemoDoor_Alert = false
							else
								if svars.isDemoDoor_Enemy == true	then
									s10100_radio.enemy_off()
									svars.isDemoDoor_Enemy = false
								else
								end
							end
						elseif checkAlert == false then
							Fox.Log("check is ng. alert")
							if isPlaying == false	then
								s10100_radio.dontPicking_Alert()
								svars.isDemoDoor_Alert = true
								svars.isDemoDoor_Enemy = false
							else
							end
						elseif checkEnemy == false then
							Fox.Log("check is ng. enemy")
							if isPlaying == false	then
								s10100_radio.dontPicking_Enemy()
								svars.isDemoDoor_Enemy = true	
								svars.isDemoDoor_Alert = false
							else
							end
						end
					end
				},
				{
					msg = "StartEventDoorPicking",
					func = function ()
						Fox.Log("Event door Open!!")
						TppUiStatusManager.SetStatus( "ActionIcon", "NO_INVALID" )
						TppSequence.SetNextSequence("Seq_Demo_Brank")
					end
				},
			},
			Trap = {
				{
					msg = "Enter",
					sender = "trap_intel_mafr_diamond_cp",
					func = function ()
						Fox.Log("RT-Radio Trap Enter!!")
						if TppPlayer.IsDeliveryWarping() == false	then
							s10100_radio.arrived_diamond()			
						elseif TppPlayer.IsDeliveryWarping() == true	then
							Fox.Log("DANBO-RU WARP ... Nothing Done !!")
						else
							Fox.Error("TppPlayer.IsDeliveryWarping() is WRONG VALUE !!")
						end
					end
				},
				nil
			},
			nil
		}
	end,

	OnEnter = function()
		if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") then
			TppCoder.SetWorldCenter(Vector3(1120.6532, 141.28583, -1303.0184))
			TppNetworkUtil.SessionEnableAccept( true )
			Dynamite.StartNearestEnemyThread()
		end

		Fox.Log("Seq_Game_BeforeRescueBoy")
		TppTelop.StartCastTelop()	
		
		TppMission.UpdateObjective{
			objectives = { "default_photo_bananaTarget","default_photo_diamond","default_subGoal",},
		}
		
		TppMission.UpdateObjective{
			objectives = { "missionTask_1_bananaTarget","missionTask_2_diamondTarget","missionTask_3_boyHostages_hide","missionTask_4_bananaTarget_collect",
					"missionTask_5_perfectEscape","missionTask_6_BrokenEnemyHeli","missionTask_7_sniperAllCollect","missionTask_8_AcpAllCollect",},
		}
		
		if TppSequence.GetContinueCount() == 0 then			
			TppMission.UpdateObjective{
				radio = { radioGroups = "s0100_rtrg1010", },
				
				objectives = { "default_area_banana","default_boySoldiers",},
				options = { isMissionStart = true },
			}
		else
			if svars.isTargetClear == true	then
				s10100_radio.CTN_NoBoys()
			else
				s10100_radio.CTN_NoBananaNoBoys()
			end
		end
		TppScriptBlock.LoadDemoBlock("Demo_MeetBoySoldier")	
		this.common_sequenceDisposal()							
		
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSwamp_0002" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSwamp_0003" ) , { id="SetEnabled", enabled=false } )
		
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondRiver_0004" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondRiver_0005" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondRiver_0006" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondRiver_0007" ) , { id="SetEnabled", enabled=false } )
		
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0000" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0001" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0002" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0003" ) , { id="SetEnabled", enabled=false } )
	end,

	OnLeave = function ()
	end,
}


sequences.Seq_Game_AfterRescueBoy = {

	OnEnter = function()
		Fox.Log("Seq_Game_AfterRescueBoy")
		this.common_sequenceDisposal()										
		this.orderCommand_OnOff_2()											
		s10100_radio.ChangeIntelRadio_afterBoyHostages()					
		
		TppMission.UpdateObjective{
			objectives = { "target_boyHostage01" , "target_boyHostage02" , "target_boyHostage03" , "target_boyHostage04" , "target_boyHostage05" , "boyHostages_subGoal", "missionTask_3_boyHostages" },
		}
		
		TppMission.UpdateObjective{ objectives = { "rv_diamond" }, }
		
		TppMission.UpdateObjective{ objectives = { "missionTask_2_diamondTarget_clear" }, }
		
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSouth_0000" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSouth_0001" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSouth_0002" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSouth_0003" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSouth_0004" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSouth_0005" ) , { id="SetEnabled", enabled=false } )
		
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0000" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0001" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0002" ) , { id="SetEnabled", enabled=false } )
		GameObject.SendCommand( GameObject.GetGameObjectId( "sol_tracking_A_0003" ) , { id="SetEnabled", enabled=false } )
		
		if svars.isAddEnemy_diamondSouth == false	then
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondRiver_0004" ) , { id="SetEnabled", enabled=true } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondRiver_0005" ) , { id="SetEnabled", enabled=true } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSwamp_0002" ) , { id="SetEnabled", enabled=true } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondRiver_0006" ) , { id="SetEnabled", enabled=true } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondRiver_0007" ) , { id="SetEnabled", enabled=true } )
			GameObject.SendCommand( GameObject.GetGameObjectId( "sol_diamondSwamp_0003" ) , { id="SetEnabled", enabled=true } )
		else
			Fox.Log("svars.isAddEnemy_diamondSouth is TRUE ... Nothing Done !!")
		end
		
		if TppSequence.GetContinueCount() == 0 then
			s10100_radio.purposeChange()
			this.afterDemo_SneakPhase()		
		else
			if	svars.isBoyHostagesCount_clear ~= 5		then
				if svars.isBoyHostagesProgress ~= 2 and svars.isPassPointProgress ~= 1	then
					s10100_radio.CTN_BoysToRV()
				else
					Fox.Log("Another RTRG souding ... Nothing Done !!")
				end
			else
				s10100_radio.nextBananaTarget()
			end
		end
	end,

	OnLeave = function ()
	end,
}


sequences.Seq_Game_Escape = {

	Messages = function( self ) 
		return
		StrCode32Table {
			GameObject = {
				{	
					msg = "HeliDoorClosed" , sender = SUPPORT_HELI,
					func = function ()
						
						if Tpp.IsHelicopter(vars.playerVehicleGameObjectId) then
							TppMission.ReserveMissionClear{
								nextMissionId 		= TppDefine.SYS_MISSION_ID.MTBS_FREE,
								missionClearType	= TppDefine.MISSION_CLEAR_TYPE.RIDE_ON_HELICOPTER
							}
						else
							Fox.Log("Pc is not ride SUPPORT_HELI")
						end
					end
				},
				nil	
			},
		}
	end,

	OnEnter = function()
		local gameObjectId = GameObject.GetGameObjectId("TppHeli2", SUPPORT_HELI )
		GameObject.SendCommand(gameObjectId, { id="EnablePullOut" })	
		TppMission.UpdateObjective{
			objectives = { "escape_subGoal" },
		}
		
		TppMission.CanMissionClear()			
		this.common_sequenceDisposal()			
		TppMarker.Disable( "Marker_diamondRV" )	
		TppRadio.EnableCommonOptionalRadio( false )	
		this.orderCommand_OnOff_2()				
		
		
		if TppSequence.GetContinueCount() == 0 then
			











		else
			if svars.isBoyHostagesCount_clear == 5	then
				s10100_radio.rideOnHeli_Escape()
			else
				Fox.Log("Nothing Done !!")
			end
		end
	end,
	
	OnLeave = function ()
	end,
}

sequences.Seq_Demo_Brank = {

	OnEnter = function()
		local func_init = function()
			TppUiStatusManager.SetStatus( "ActionIcon", "NO_INVALID" )
		end
		local func_end = function()
			TppUiStatusManager.UnsetStatus( "ActionIcon", "NO_INVALID" )
			TppSequence.SetNextSequence("Seq_Demo_MeetBoySoldier")
		end
		s10100_demo.Demo_Brank_30( func_init , func_start , func_end )
	end,
	
	OnLeave = function ()
		
	end,
}

sequences.Seq_Demo_MeetBoySoldier = {

	Messages = function( self ) 
		return
		StrCode32Table {
			Demo = {
				{	
					msg = "Play",
					func = function( demoId )
						Fox.Log("Demo_MeetBoySoldier Play !!")
						TppCollection.SetAllCollectionInvisible()	
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "FinishMotion",
					func = function( demoId )
						Fox.Log("Demo_MeetBoySoldier Finish !!")
						TppCollection.SetAllCollectionInvisible( isInvisible )	
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "Skip",
					func = function( demoId )
						Fox.Log("Demo_MeetBoySoldier Skip !!")
						this.demoEventDoor_FullOpen()
						TppCollection.SetAllCollectionInvisible( isInvisible )	
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "p41_020020_envModel_visOff",
					func = function( demoId )
						Fox.Log("Demo MSG [ p41_020020_envModel_visOff ]!!")
						Gimmick.SetEventDoorInvisible( EVENT_DOOR_BOY , EVENT_DOOR_PATH , true )	
						Gimmick.SetEventDoorInvisible( EVENT_DOOR_DEMO , EVENT_DOOR_PATH , true )	
					end,
					option = { isExecDemoPlaying = true },
				},
				{	
					msg = "p41_020020_envModel_visOn",
					func = function( demoId )
						Fox.Log("Demo MSG [ p41_020020_envModel_visOn ]!!")
						this.demoEventDoor_FullOpen()
				
					end,
					option = { isExecDemoPlaying = true },
				},
			},		
		}
	end,

	OnEnter = function()
		this.boyHostages_Enable()	
		local func_init = function()
		end
		local func_end = function()
			TppSequence.SetNextSequence("Seq_Game_AfterRescueBoy")
		end
		s10100_demo.Demo_MeetBoySoldier( func_init , func_start , func_end )
	end,
	
	OnLeave = function ()
		
		Gimmick.SetEventDoorLock( NORMAL_DOOR_A , NORMALE_DOOR_PATH , false, 0 )	
		Gimmick.SetEventDoorLock( NORMAL_DOOR_B , NORMALE_DOOR_PATH , false, 0 )	
		Gimmick.SetEventDoorLock( NORMAL_DOOR_C , NORMALE_DOOR_PATH , false, 0 )	
		
		TppMission.UpdateCheckPoint("CHK_MeetBoyHostages")
	end,
}








return this