local e = {}
local p = Fox.StrCode32
local n = Tpp.IsTypeFunc
local s = Tpp.IsTypeTable
local o = Tpp.IsTypeString
local l = Tpp.IsTypeNumber
local r = GameObject.GetGameObjectId
local T = GameObject.GetGameObjectIdByIndex
local n = TppGameObject.GAME_OBJECT_TYPE_VEHICLE
local a = GameObject.NULL_ID
local t = GameObject.SendCommand
local n = Tpp.DEBUG_StrCode32ToString
local _ = "quest_cp"
local d = EnemySubType or {}
local function u(e)
	local t = {}
	for n, i in ipairs(e) do
		if s(i) then
			t[n] = u(i)
		else
			local e = r(e[n])
			if e and e ~= a then
				t[e] = n
			end
		end
	end
	return t
end
function e.Messages()
	return Tpp.StrCode32Table({
		Player = { { msg = "RideHelicopterWithHuman", func = e._RideHelicopterWithHuman } },
		GameObject = {
			{ msg = "Dead", func = e._OnDead },
			{ msg = "PlacedIntoVehicle", func = e._PlacedIntoVehicle },
			{ msg = "Damage", func = e._OnDamage },
			{ msg = "RoutePoint2", func = e._DoRoutePointMessage },
			{ msg = "LostControl", func = e._OnHeliBroken },
			{ msg = "VehicleBroken", func = e._OnVehicleBroken, option = { isExecDemoPlaying = true } },
			{ msg = "WalkerGearBroken", func = e._OnWalkerGearBroken },
			{ msg = "ChangePhaseForAnnounce", func = e._AnnouncePhaseChange },
			{
				msg = "InterrogateUpHero",
				func = function(n)
					local e = e.GetSoldierType(n)
					if e ~= EnemyType.TYPE_DD then
						TppTrophy.Unlock(30)
					end
					PlayRecord.RegistPlayRecord("PLAYER_INTERROGATION")
				end,
			},
		},
		Weather = {
			{
				msg = "Clock",
				sender = "ShiftChangeAtNight",
				func = function(n, n)
					e.ShiftChangeByTime("shiftAtNight")
				end,
			},
			{
				msg = "Clock",
				sender = "ShiftChangeAtMorning",
				func = function(n, n)
					e.ShiftChangeByTime("shiftAtMorning")
				end,
			},
			{
				msg = "Clock",
				sender = "ShiftChangeAtMidNight",
				func = function(n, n)
					e.ShiftChangeByTime("shiftAtMidNight")
				end,
			},
		},
	})
end
e.POWER_SETTING = {
	"NO_KILL_WEAPON",
	"ARMOR",
	"SOFT_ARMOR",
	"SNIPER",
	"SHIELD",
	"MISSILE",
	"MG",
	"SHOTGUN",
	"SMG",
	"HELMET",
	"NVG",
	"GAS_MASK",
	"GUN_LIGHT",
	"STRONG_WEAPON",
	"STRONG_PATROL",
	"STRONG_NOTICE_TRANQ",
	"FULTON_SPECIAL",
	"FULTON_HIGH",
	"FULTON_LOW",
	"COMBAT_SPECIAL",
	"COMBAT_HIGH",
	"COMBAT_LOW",
	"STEALTH_SPECIAL",
	"STEALTH_HIGH",
	"STEALTH_LOW",
	"HOLDUP_SPECIAL",
	"HOLDUP_HIGH",
	"HOLDUP_LOW",
}
e.PHASE = { SNEAK = 0, CAUTION = 1, EVASION = 2, ALERT = 3, MAX = 4 }
e.ROUTE_SET_TYPES = { "sneak_day", "sneak_night", "caution", "hold", "travel", "sneak_midnight", "sleep" }
e.LIFE_STATUS = { NORMAL = 0, DEAD = 1, DYING = 2, SLEEP = 3, FAINT = 4 }
e.ACTION_STATUS = { NORMAL = 0, FULTON_RECOVERD = 1, HOLD_UP_STAND = 2, HOLD_UP_CROWL = 3, NOW_CARRYING = 4 }
e.SOLDIER_DEFINE_RESERVE_TABLE_NAME = Tpp.Enum({ "lrrpTravelPlan", "lrrpVehicle" })
e.TAKING_OVER_HOSTAGE_LIST =
	{ "hos_takingOver_0000", "hos_takingOver_0001", "hos_takingOver_0002", "hos_takingOver_0003" }
e.ROUTE_SET_TYPETAG = {}
e.subTypeOfCpTable = {
	SOVIET_A = {
		afgh_field_cp = true,
		afgh_remnants_cp = true,
		afgh_tent_cp = true,
		afgh_fieldEast_ob = true,
		afgh_fieldWest_ob = true,
		afgh_remnantsNorth_ob = true,
		afgh_tentEast_ob = true,
		afgh_tentNorth_ob = true,
		afgh_01_16_lrrp = true,
		afgh_29_20_lrrp = true,
		afgh_29_16_lrrp = true,
		afgh_village_cp = true,
		afgh_slopedTown_cp = true,
		afgh_commFacility_cp = true,
		afgh_enemyBase_cp = true,
		afgh_commWest_ob = true,
		afgh_ruinsNorth_ob = true,
		afgh_slopedWest_ob = true,
		afgh_villageEast_ob = true,
		afgh_villageEast_ob = true,
		afgh_villageNorth_ob = true,
		afgh_villageWest_ob = true,
		afgh_enemyEast_ob = true,
		afgh_01_13_lrrp = true,
		afgh_02_14_lrrp = true,
		afgh_32_01_lrrp = true,
		afgh_32_04_lrrp = true,
		afgh_32_14_lrrp = true,
		afgh_34_02_lrrp = true,
		afgh_34_13_lrrp = true,
		afgh_35_02_lrrp = true,
		afgh_35_14_lrrp = true,
		afgh_35_15_lrrp = true,
		afgh_36_04_lrrp = true,
		afgh_36_15_lrrp = true,
		afgh_36_06_lrrp = true,
	},
	SOVIET_B = {
		afgh_bridge_cp = true,
		afgh_fort_cp = true,
		afgh_cliffTown_cp = true,
		afgh_bridgeNorth_ob = true,
		afgh_bridgeWest_ob = true,
		afgh_cliffEast_ob = true,
		afgh_cliffSouth_ob = true,
		afgh_cliffWest_ob = true,
		afgh_enemyNorth_ob = true,
		afgh_fortSouth_ob = true,
		afgh_fortWest_ob = true,
		afgh_slopedEast_ob = true,
		afgh_powerPlant_cp = true,
		afgh_sovietBase_cp = true,
		afgh_plantSouth_ob = true,
		afgh_plantWest_ob = true,
		afgh_sovietSouth_ob = true,
		afgh_waterwayEast_ob = true,
		afgh_citadel_cp = true,
		afgh_citadelSouth_ob = true,
	},
	PF_A = {
		mafr_outland_cp = true,
		mafr_outlandEast_ob = true,
		mafr_outlandNorth_ob = true,
		mafr_01_20_lrrp = true,
		mafr_03_20_lrrp = true,
		mafr_flowStation_cp = true,
		mafr_swamp_cp = true,
		mafr_pfCamp_cp = true,
		mafr_savannah_cp = true,
		mafr_swampEast_ob = true,
		mafr_swampWest_ob = true,
		mafr_swampSouth_ob = true,
		mafr_pfCampEast_ob = true,
		mafr_pfCampNorth_ob = true,
		mafr_savannahEast_ob = true,
		mafr_chicoVilWest_ob = true,
		mafr_hillSouth_ob = true,
		mafr_02_21_lrrp = true,
		mafr_02_22_lrrp = true,
		mafr_05_23_lrrp = true,
		mafr_06_16_lrrp = true,
		mafr_06_22_lrrp = true,
		mafr_06_24_lrrp = true,
		mafr_13_15_lrrp = true,
		mafr_13_16_lrrp = true,
		mafr_13_24_lrrp = true,
		mafr_15_16_lrrp = true,
		mafr_15_23_lrrp = true,
		mafr_16_23_lrrp = true,
		mafr_16_24_lrrp = true,
		mafr_23_33_lrrp = true,
	},
	PF_B = { mafr_factory_cp = true, mafr_lab_cp = true, mafr_labWest_ob = true, mafr_19_29_lrrp = true },
	PF_C = {
		mafr_banana_cp = true,
		mafr_diamond_cp = true,
		mafr_hill_cp = true,
		mafr_savannahNorth_ob = true,
		mafr_savannahWest_ob = true,
		mafr_bananaEast_ob = true,
		mafr_bananaSouth_ob = true,
		mafr_hillNorth_ob = true,
		mafr_hillWest_ob = true,
		mafr_hillWestNear_ob = true,
		mafr_factorySouth_ob = true,
		mafr_factoryWest_ob = true,
		mafr_diamondNorth_ob = true,
		mafr_diamondSouth_ob = true,
		mafr_diamondWest_ob = true,
		mafr_07_09_lrrp = true,
		mafr_07_24_lrrp = true,
		mafr_08_10_lrrp = true,
		mafr_08_25_lrrp = true,
		mafr_09_25_lrrp = true,
		mafr_10_11_lrrp = true,
		mafr_10_18_lrrp = true,
		mafr_10_26_lrrp = true,
		mafr_11_10_lrrp = true,
		mafr_11_12_lrrp = true,
		mafr_11_26_lrrp = true,
		mafr_12_14_lrrp = true,
		mafr_14_27_lrrp = true,
		mafr_17_27_lrrp = true,
		mafr_18_26_lrrp = true,
		mafr_27_30_lrrp = true,
	},
}
e.subTypeOfCp = {}
for t, n in pairs(e.subTypeOfCpTable) do
	for n, a in pairs(n) do
		e.subTypeOfCp[n] = t
	end
end
local n = TppEnemyBodyId or {}
e.childBodyIdTable = {
	n.chd0_v00,
	n.chd0_v01,
	n.chd0_v02,
	n.chd0_v03,
	n.chd0_v05,
	n.chd0_v06,
	n.chd0_v07,
	n.chd0_v08,
	n.chd0_v09,
	n.chd0_v10,
	n.chd0_v11,
}
e.bodyIdTable = {
	SOVIET_A = {
		ASSAULT = { n.svs0_rfl_v00_a, n.svs0_rfl_v00_a, n.svs0_rfl_v01_a, n.svs0_mcg_v00_a },
		ASSAULT_OB = { n.svs0_rfl_v02_a, n.svs0_mcg_v02_a },
		SNIPER = { n.svs0_snp_v00_a },
		SHOTGUN = { n.svs0_rfl_v00_a, n.svs0_rfl_v01_a },
		SHOTGUN_OB = { n.svs0_rfl_v02_a },
		MG = { n.svs0_mcg_v00_a, n.svs0_mcg_v01_a },
		MG_OB = { n.svs0_mcg_v02_a },
		MISSILE = { n.svs0_rfl_v00_a },
		SHIELD = { n.svs0_rfl_v00_a },
		ARMOR = { n.sva0_v00_a },
		RADIO = { n.svs0_rdo_v00_a },
	},
	SOVIET_B = {
		ASSAULT = { n.svs0_rfl_v00_b, n.svs0_rfl_v00_b, n.svs0_rfl_v01_b, n.svs0_mcg_v00_b },
		ASSAULT_OB = { n.svs0_rfl_v02_b, n.svs0_mcg_v02_b },
		SNIPER = { n.svs0_snp_v00_b },
		SHOTGUN = { n.svs0_rfl_v00_b, n.svs0_rfl_v01_b },
		SHOTGUN_OB = { n.svs0_rfl_v02_b },
		MG = { n.svs0_mcg_v00_b, n.svs0_mcg_v01_b },
		MG_OB = { n.svs0_mcg_v02_b },
		MISSILE = { n.svs0_rfl_v00_b },
		SHIELD = { n.svs0_rfl_v00_b },
		ARMOR = { n.sva0_v00_a },
		RADIO = { n.svs0_rdo_v00_b },
	},
	PF_A = {
		ASSAULT = { n.pfs0_rfl_v00_a, n.pfs0_mcg_v00_a },
		ASSAULT_OB = { n.pfs0_rfl_v00_a, n.pfs0_rfl_v01_a, n.pfs0_mcg_v00_a },
		SNIPER = { n.pfs0_snp_v00_a },
		SHOTGUN = { n.pfs0_rfl_v00_a },
		SHOTGUN_OB = { n.pfs0_rfl_v00_a, n.pfs0_rfl_v01_a },
		MG = { n.pfs0_mcg_v00_a },
		MISSILE = { n.pfs0_rfl_v00_a },
		SHIELD = { n.pfs0_rfl_v00_a },
		ARMOR = { n.pfa0_v00_b },
		RADIO = { n.pfs0_rdo_v00_a },
	},
	PF_B = {
		ASSAULT = { n.pfs0_rfl_v00_b, n.pfs0_mcg_v00_b },
		ASSAULT_OB = { n.pfs0_rfl_v00_b, n.pfs0_rfl_v01_b, n.pfs0_mcg_v00_b },
		SNIPER = { n.pfs0_snp_v00_b },
		SHOTGUN = { n.pfs0_rfl_v00_b },
		SHOTGUN_OB = { n.pfs0_rfl_v00_b, n.pfs0_rfl_v01_b },
		MG = { n.pfs0_mcg_v00_b },
		MISSILE = { n.pfs0_rfl_v00_b },
		SHIELD = { n.pfs0_rfl_v00_b },
		ARMOR = { n.pfa0_v00_a },
		RADIO = { n.pfs0_rdo_v00_b },
	},
	PF_C = {
		ASSAULT = { n.pfs0_rfl_v00_c, n.pfs0_mcg_v00_c },
		ASSAULT_OB = { n.pfs0_rfl_v00_c, n.pfs0_rfl_v01_c, n.pfs0_mcg_v00_c },
		SNIPER = { n.pfs0_snp_v00_c },
		SHOTGUN = { n.pfs0_rfl_v00_c },
		SHOTGUN_OB = { n.pfs0_rfl_v00_c, n.pfs0_rfl_v01_c },
		MG = { n.pfs0_mcg_v00_c },
		MISSILE = { n.pfs0_rfl_v00_c },
		SHIELD = { n.pfs0_rfl_v01_c },
		ARMOR = { n.pfa0_v00_c },
		RADIO = { n.pfs0_rdo_v00_c },
	},
	DD_A = { ASSAULT = { n.dds3_main0_v00 } },
	DD_FOB = { ASSAULT = { n.dds5_main0_v00 } },
	DD_PW = { ASSAULT = { n.dds0_main1_v00 } },
	SKULL_CYPR = { ASSAULT = { n.wss0_main0_v00 } },
	SKULL_AFGH = { ASSAULT = { n.wss4_main0_v00 } },
	CHILD = { ASSAULT = e.childBodyIdTable },
}
e.weaponIdTable = {
	SOVIET_A = {
		NORMAL = {
			HANDGUN = TppEquip.EQP_WP_East_hg_010,
			SMG = TppEquip.EQP_WP_East_sm_010,
			ASSAULT = TppEquip.EQP_WP_East_ar_010,
			SNIPER = TppEquip.EQP_WP_East_sr_011,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_011,
			MG = TppEquip.EQP_WP_East_mg_010,
			MISSILE = TppEquip.EQP_WP_East_ms_010,
			SHIELD = TppEquip.EQP_SLD_SV,
		},
		STRONG = {
			HANDGUN = TppEquip.EQP_WP_East_hg_010,
			SMG = TppEquip.EQP_WP_East_sm_020,
			ASSAULT = TppEquip.EQP_WP_East_ar_030,
			SNIPER = TppEquip.EQP_WP_East_sr_020,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_020,
			MG = TppEquip.EQP_WP_East_mg_010,
			MISSILE = TppEquip.EQP_WP_Com_ms_010,
			SHIELD = TppEquip.EQP_SLD_SV,
		},
	},
	PF_A = {
		NORMAL = {
			HANDGUN = TppEquip.EQP_WP_West_hg_010,
			SMG = TppEquip.EQP_WP_West_sm_010,
			ASSAULT = TppEquip.EQP_WP_West_ar_010,
			SNIPER = TppEquip.EQP_WP_West_sr_011,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_011,
			MG = TppEquip.EQP_WP_West_mg_010,
			MISSILE = TppEquip.EQP_WP_West_ms_010,
			SHIELD = TppEquip.EQP_SLD_PF_01,
		},
		STRONG = {
			HANDGUN = TppEquip.EQP_WP_West_hg_010,
			SMG = TppEquip.EQP_WP_West_sm_020,
			ASSAULT = TppEquip.EQP_WP_West_ar_020,
			SNIPER = TppEquip.EQP_WP_West_sr_020,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_020,
			MG = TppEquip.EQP_WP_West_mg_010,
			MISSILE = TppEquip.EQP_WP_Com_ms_010,
			SHIELD = TppEquip.EQP_SLD_PF_01,
		},
	},
	PF_B = {
		NORMAL = {
			HANDGUN = TppEquip.EQP_WP_West_hg_010,
			SMG = TppEquip.EQP_WP_West_sm_010,
			ASSAULT = TppEquip.EQP_WP_West_ar_010,
			SNIPER = TppEquip.EQP_WP_West_sr_011,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_011,
			MG = TppEquip.EQP_WP_West_mg_010,
			MISSILE = TppEquip.EQP_WP_West_ms_010,
			SHIELD = TppEquip.EQP_SLD_PF_00,
		},
		STRONG = {
			HANDGUN = TppEquip.EQP_WP_West_hg_010,
			SMG = TppEquip.EQP_WP_West_sm_020,
			ASSAULT = TppEquip.EQP_WP_West_ar_020,
			SNIPER = TppEquip.EQP_WP_West_sr_020,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_020,
			MG = TppEquip.EQP_WP_West_mg_010,
			MISSILE = TppEquip.EQP_WP_Com_ms_010,
			SHIELD = TppEquip.EQP_SLD_PF_00,
		},
	},
	PF_C = {
		NORMAL = {
			HANDGUN = TppEquip.EQP_WP_West_hg_010,
			SMG = TppEquip.EQP_WP_West_sm_010,
			ASSAULT = TppEquip.EQP_WP_West_ar_010,
			SNIPER = TppEquip.EQP_WP_West_sr_011,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_011,
			MG = TppEquip.EQP_WP_West_mg_010,
			MISSILE = TppEquip.EQP_WP_West_ms_010,
			SHIELD = TppEquip.EQP_SLD_PF_02,
		},
		STRONG = {
			HANDGUN = TppEquip.EQP_WP_West_hg_010,
			SMG = TppEquip.EQP_WP_West_sm_020,
			ASSAULT = TppEquip.EQP_WP_West_ar_020,
			SNIPER = TppEquip.EQP_WP_West_sr_020,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_020,
			MG = TppEquip.EQP_WP_West_mg_010,
			MISSILE = TppEquip.EQP_WP_Com_ms_010,
			SHIELD = TppEquip.EQP_SLD_PF_02,
		},
	},
	DD = nil,
	SKULL_CYPR = { NORMAL = { HANDGUN = TppEquip.EQP_WP_West_hg_020, SMG = TppEquip.EQP_WP_East_sm_030 } },
	SKULL = {
		NORMAL = {
			HANDGUN = TppEquip.EQP_WP_West_hg_020,
			SMG = TppEquip.EQP_WP_West_sm_020,
			ASSAULT = TppEquip.EQP_WP_West_ar_030,
			SNIPER = TppEquip.EQP_WP_West_sr_020,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_011,
			MG = TppEquip.EQP_WP_West_mg_020,
			MISSILE = TppEquip.EQP_WP_West_ms_010,
			SHIELD = TppEquip.EQP_SLD_PF_02,
		},
		STRONG = {
			HANDGUN = TppEquip.EQP_WP_West_hg_020,
			SMG = TppEquip.EQP_WP_West_sm_020,
			ASSAULT = TppEquip.EQP_WP_West_ar_030,
			SNIPER = TppEquip.EQP_WP_West_sr_020,
			SHOTGUN = TppEquip.EQP_WP_Com_sg_020,
			MG = TppEquip.EQP_WP_West_mg_020,
			MISSILE = TppEquip.EQP_WP_Com_ms_010,
			SHIELD = TppEquip.EQP_SLD_PF_02,
		},
	},
	CHILD = { NORMAL = { HANDGUN = TppEquip.EQP_WP_East_hg_010, ASSAULT = TppEquip.EQP_WP_East_ar_020 } },
}
e.gunLightWeaponIds = {
	[TppEquip.EQP_WP_Com_sg_011] = TppEquip.EQP_WP_Com_sg_011_FL,
	[TppEquip.EQP_WP_Com_sg_020] = TppEquip.EQP_WP_Com_sg_020_FL,
	[TppEquip.EQP_WP_West_ar_010] = TppEquip.EQP_WP_West_ar_010_FL,
	[TppEquip.EQP_WP_West_ar_020] = TppEquip.EQP_WP_West_ar_020_FL,
	[TppEquip.EQP_WP_East_ar_010] = TppEquip.EQP_WP_East_ar_010_FL,
	[TppEquip.EQP_WP_East_ar_030] = TppEquip.EQP_WP_East_ar_030_FL,
}
local n = MbsDevelopedEquipType or {}
e.DDWeaponIdInfo = {
	HANDGUN = { { equipId = TppEquip.EQP_WP_West_hg_010 } },
	SMG = {
		{ equipId = TppEquip.EQP_WP_East_sm_04b, isNoKill = true, developedEquipType = n.SM_2040_NOKILL, developId = 2102 },
		{ equipId = TppEquip.EQP_WP_East_sm_04a, isNoKill = true, developedEquipType = n.SM_2040_NOKILL, developId = 2101 },
		{ equipId = TppEquip.EQP_WP_East_sm_049, isNoKill = true, developedEquipType = n.SM_2040_NOKILL, developId = 2100 },
		{ equipId = TppEquip.EQP_WP_East_sm_047, isNoKill = true, developedEquipType = n.SM_2040_NOKILL, developId = 2044 },
		{ equipId = TppEquip.EQP_WP_East_sm_045, isNoKill = true, developedEquipType = n.SM_2040_NOKILL, developId = 2043 },
		{ equipId = TppEquip.EQP_WP_East_sm_044, isNoKill = true, developedEquipType = n.SM_2040_NOKILL, developId = 2042 },
		{ equipId = TppEquip.EQP_WP_East_sm_043, isNoKill = true, developedEquipType = n.SM_2040_NOKILL, developId = 2041 },
		{ equipId = TppEquip.EQP_WP_East_sm_042, isNoKill = true, developedEquipType = n.SM_2040_NOKILL, developId = 2040 },
		{ equipId = TppEquip.EQP_WP_West_sm_01b, developedEquipType = n.SM_2014, developId = 2072 },
		{ equipId = TppEquip.EQP_WP_West_sm_01a, developedEquipType = n.SM_2014, developId = 2071 },
		{ equipId = TppEquip.EQP_WP_West_sm_019, developedEquipType = n.SM_2014, developId = 2070 },
		{ equipId = TppEquip.EQP_WP_West_sm_017, developedEquipType = n.SM_2014, developId = 2014 },
		{ equipId = TppEquip.EQP_WP_West_sm_016, developedEquipType = n.SM_2010, developId = 2013 },
		{ equipId = TppEquip.EQP_WP_West_sm_015, developedEquipType = n.SM_2010, developId = 2012 },
		{ equipId = TppEquip.EQP_WP_West_sm_014, developedEquipType = n.SM_2010, developId = 2011 },
		{ equipId = TppEquip.EQP_WP_West_sm_010, developedEquipType = n.SM_2010, developId = 2010 },
	},
	SHOTGUN = {
		{ equipId = TppEquip.EQP_WP_Com_sg_038, isNoKill = true, developedEquipType = n.SG_4027_NOKILL, developId = 4028 },
		{ equipId = TppEquip.EQP_WP_Com_sg_030, isNoKill = true, developedEquipType = n.SG_4027_NOKILL, developId = 4027 },
		{ equipId = TppEquip.EQP_WP_Com_sg_025, isNoKill = true, developedEquipType = n.SG_4035_NOKILL, developId = 4037 },
		{ equipId = TppEquip.EQP_WP_Com_sg_024, isNoKill = true, developedEquipType = n.SG_4035_NOKILL, developId = 4036 },
		{ equipId = TppEquip.EQP_WP_Com_sg_023, isNoKill = true, developedEquipType = n.SG_4035_NOKILL, developId = 4035 },
		{ equipId = TppEquip.EQP_WP_Com_sg_018, developedEquipType = n.SG_4040, developId = 4044 },
		{ equipId = TppEquip.EQP_WP_Com_sg_016, developedEquipType = n.SG_4040, developId = 4043 },
		{ equipId = TppEquip.EQP_WP_Com_sg_015, developedEquipType = n.SG_4040, developId = 4042 },
		{ equipId = TppEquip.EQP_WP_Com_sg_020, developedEquipType = n.SG_4040, developId = 4041 },
		{ equipId = TppEquip.EQP_WP_Com_sg_013, developedEquipType = n.SG_4040, developId = 4040 },
		{ equipId = TppEquip.EQP_WP_Com_sg_011, developedEquipType = n.SG_4020, developId = 4020 },
	},
	ASSAULT = {
		{ equipId = TppEquip.EQP_WP_West_ar_07b, isNoKill = true, developedEquipType = n.AR_3060_NOKILL, developId = 3132 },
		{ equipId = TppEquip.EQP_WP_West_ar_07a, isNoKill = true, developedEquipType = n.AR_3060_NOKILL, developId = 3131 },
		{ equipId = TppEquip.EQP_WP_West_ar_079, isNoKill = true, developedEquipType = n.AR_3060_NOKILL, developId = 3130 },
		{ equipId = TppEquip.EQP_WP_West_ar_077, isNoKill = true, developedEquipType = n.AR_3060_NOKILL, developId = 3064 },
		{ equipId = TppEquip.EQP_WP_West_ar_075, isNoKill = true, developedEquipType = n.AR_3060_NOKILL, developId = 3063 },
		{ equipId = TppEquip.EQP_WP_West_ar_070, isNoKill = true, developedEquipType = n.AR_3060_NOKILL, developId = 3062 },
		{ equipId = TppEquip.EQP_WP_West_ar_063, isNoKill = true, developedEquipType = n.AR_3060_NOKILL, developId = 3061 },
		{ equipId = TppEquip.EQP_WP_West_ar_060, isNoKill = true, developedEquipType = n.AR_3060_NOKILL, developId = 3060 },
		{ equipId = TppEquip.EQP_WP_West_ar_05b, developedEquipType = n.AR_3036, developId = 3102 },
		{ equipId = TppEquip.EQP_WP_West_ar_05a, developedEquipType = n.AR_3036, developId = 3101 },
		{ equipId = TppEquip.EQP_WP_West_ar_059, developedEquipType = n.AR_3036, developId = 3100 },
		{ equipId = TppEquip.EQP_WP_West_ar_057, developedEquipType = n.AR_3036, developId = 3042 },
		{ equipId = TppEquip.EQP_WP_West_ar_050, developedEquipType = n.AR_3036, developId = 3038 },
		{ equipId = TppEquip.EQP_WP_West_ar_055, developedEquipType = n.AR_3036, developId = 3037 },
		{ equipId = TppEquip.EQP_WP_West_ar_010, developedEquipType = n.AR_3036, developId = 3036 },
		{ equipId = TppEquip.EQP_WP_West_ar_042, developedEquipType = n.AR_3030, developId = 3031 },
		{ equipId = TppEquip.EQP_WP_West_ar_040 },
	},
	SNIPER = {
		{ equipId = TppEquip.EQP_WP_West_sr_04b, isNoKill = true, developedEquipType = n.SR_6037_NOKILL, developId = 6132 },
		{ equipId = TppEquip.EQP_WP_West_sr_04a, isNoKill = true, developedEquipType = n.SR_6037_NOKILL, developId = 6131 },
		{ equipId = TppEquip.EQP_WP_West_sr_049, isNoKill = true, developedEquipType = n.SR_6037_NOKILL, developId = 6130 },
		{ equipId = TppEquip.EQP_WP_West_sr_048, isNoKill = true, developedEquipType = n.SR_6037_NOKILL, developId = 6039 },
		{ equipId = TppEquip.EQP_WP_West_sr_047, isNoKill = true, developedEquipType = n.SR_6037_NOKILL, developId = 6038 },
		{ equipId = TppEquip.EQP_WP_West_sr_037, isNoKill = true, developedEquipType = n.SR_6037_NOKILL, developId = 6037 },
		{ equipId = TppEquip.EQP_WP_East_sr_034, isNoKill = true, developedEquipType = n.SR_6005_NOKILL, developId = 6006 },
		{ equipId = TppEquip.EQP_WP_East_sr_033, isNoKill = true, developedEquipType = n.SR_6005_NOKILL, developId = 6008 },
		{ equipId = TppEquip.EQP_WP_East_sr_032, isNoKill = true, developedEquipType = n.SR_6005_NOKILL, developId = 6005 },
		{ equipId = TppEquip.EQP_WP_West_sr_02b, developedEquipType = n.SR_6030, developId = 6102 },
		{ equipId = TppEquip.EQP_WP_West_sr_02a, developedEquipType = n.SR_6030, developId = 6101 },
		{ equipId = TppEquip.EQP_WP_West_sr_029, developedEquipType = n.SR_6030, developId = 6100 },
		{ equipId = TppEquip.EQP_WP_West_sr_027, developedEquipType = n.SR_6030, developId = 6033 },
		{ equipId = TppEquip.EQP_WP_West_sr_020, developedEquipType = n.SR_6030, developId = 6032 },
		{ equipId = TppEquip.EQP_WP_West_sr_014, developedEquipType = n.SR_6030, developId = 6031 },
		{ equipId = TppEquip.EQP_WP_West_sr_013, developedEquipType = n.SR_6030, developId = 6030 },
		{ equipId = TppEquip.EQP_WP_West_sr_011, developedEquipType = n.SR_6010, developId = 6010 },
	},
	MG = {
		{ equipId = TppEquip.EQP_WP_West_mg_03b, developedEquipType = n.MG_7000, developId = 7052 },
		{ equipId = TppEquip.EQP_WP_West_mg_03a, developedEquipType = n.MG_7000, developId = 7051 },
		{ equipId = TppEquip.EQP_WP_West_mg_039, developedEquipType = n.MG_7000, developId = 7050 },
		{ equipId = TppEquip.EQP_WP_West_mg_037, developedEquipType = n.MG_7000, developId = 7004 },
		{ equipId = TppEquip.EQP_WP_West_mg_030, developedEquipType = n.MG_7000, developId = 7003 },
		{ equipId = TppEquip.EQP_WP_West_mg_024, developedEquipType = n.MG_7000, developId = 7002 },
		{ equipId = TppEquip.EQP_WP_West_mg_023, developedEquipType = n.MG_7000, developId = 7001 },
		{ equipId = TppEquip.EQP_WP_West_mg_020, developedEquipType = n.MG_7000, developId = 7e3 },
	},
	MISSILE = {
		{ equipId = TppEquip.EQP_WP_West_ms_02b, isNoKill = true, developedEquipType = n.MS_8013_NOKILL, developId = 8072 },
		{ equipId = TppEquip.EQP_WP_West_ms_02a, isNoKill = true, developedEquipType = n.MS_8013_NOKILL, developId = 8071 },
		{ equipId = TppEquip.EQP_WP_West_ms_029, isNoKill = true, developedEquipType = n.MS_8013_NOKILL, developId = 8070 },
		{ equipId = TppEquip.EQP_WP_West_ms_020, isNoKill = true, developedEquipType = n.MS_8013_NOKILL, developId = 8013 },
		{ equipId = TppEquip.EQP_WP_Com_ms_02b, developedEquipType = n.MS_8020, developId = 8052 },
		{ equipId = TppEquip.EQP_WP_Com_ms_02a, developedEquipType = n.MS_8020, developId = 8051 },
		{ equipId = TppEquip.EQP_WP_Com_ms_029, developedEquipType = n.MS_8020, developId = 8050 },
		{ equipId = TppEquip.EQP_WP_Com_ms_026, developedEquipType = n.MS_8020, developId = 8023 },
		{ equipId = TppEquip.EQP_WP_Com_ms_020, developedEquipType = n.MS_8020, developId = 8022 },
		{ equipId = TppEquip.EQP_WP_Com_ms_024, developedEquipType = n.MS_8020, developId = 8021 },
		{ equipId = TppEquip.EQP_WP_Com_ms_023, developedEquipType = n.MS_8020, developId = 8020 },
	},
	SHIELD = { { equipId = TppEquip.EQP_SLD_DD, developedEquipType = n.SD_9000, developId = 9e3 } },
	GRENADE = {
		{ equipId = TppEquip.EQP_SWP_Grenade_G08, developedEquipType = n.GRENADE, developId = 11122 },
		{ equipId = TppEquip.EQP_SWP_Grenade_G07, developedEquipType = n.GRENADE, developId = 11121 },
		{ equipId = TppEquip.EQP_SWP_Grenade_G06, developedEquipType = n.GRENADE, developId = 11120 },
		{ equipId = TppEquip.EQP_SWP_Grenade_G05, developedEquipType = n.GRENADE, developId = 10045 },
		{ equipId = TppEquip.EQP_SWP_Grenade_G04, developedEquipType = n.GRENADE, developId = 10044 },
		{ equipId = TppEquip.EQP_SWP_Grenade_G03, developedEquipType = n.GRENADE, developId = 10043 },
		{ equipId = TppEquip.EQP_SWP_Grenade_G02, developedEquipType = n.GRENADE, developId = 10042 },
		{ equipId = TppEquip.EQP_SWP_Grenade_G01, developedEquipType = n.GRENADE, developId = 10041 },
		{ equipId = TppEquip.EQP_SWP_Grenade },
	},
	STUN_GRENADE = {
		{ equipId = TppEquip.EQP_SWP_StunGrenade_G06, isNoKill = true, developedEquipType = n.STUN_GRENADE, developId = 11152 },
		{ equipId = TppEquip.EQP_SWP_StunGrenade_G05, isNoKill = true, developedEquipType = n.STUN_GRENADE, developId = 11151 },
		{ equipId = TppEquip.EQP_SWP_StunGrenade_G04, isNoKill = true, developedEquipType = n.STUN_GRENADE, developId = 11150 },
		{ equipId = TppEquip.EQP_SWP_StunGrenade_G03, isNoKill = true, developedEquipType = n.STUN_GRENADE, developId = 10063 },
		{ equipId = TppEquip.EQP_SWP_StunGrenade_G02, isNoKill = true, developedEquipType = n.STUN_GRENADE, developId = 10062 },
		{ equipId = TppEquip.EQP_SWP_StunGrenade_G01, isNoKill = true, developedEquipType = n.STUN_GRENADE, developId = 10061 },
		{ equipId = TppEquip.EQP_SWP_StunGrenade, isNoKill = true, developedEquipType = n.STUN_GRENADE, developId = 10060 },
	},
	SNEAKING_SUIT = {
		{ equipId = 9, isNoKill = true, developedEquipType = n.SNEAKING_SUIT, developId = 19302 },
		{ equipId = 8, isNoKill = true, developedEquipType = n.SNEAKING_SUIT, developId = 19301 },
		{ equipId = 7, isNoKill = true, developedEquipType = n.SNEAKING_SUIT, developId = 19300 },
		{ equipId = 6, isNoKill = true, developedEquipType = n.SNEAKING_SUIT, developId = 19042 },
		{ equipId = 5, isNoKill = true, developedEquipType = n.SNEAKING_SUIT, developId = 19057 },
		{ equipId = 4, isNoKill = true, developedEquipType = n.SNEAKING_SUIT, developId = 19056 },
		{ equipId = 3, isNoKill = true, developedEquipType = n.SNEAKING_SUIT, developId = 19052 },
		{ equipId = 2, isNoKill = true, developedEquipType = n.SNEAKING_SUIT, developId = 19051 },
		{ equipId = 1, isNoKill = true, developedEquipType = n.SNEAKING_SUIT, developId = 19050 },
	},
	BATTLE_DRESS = {
		{ equipId = 9, developedEquipType = n.BATTLE_DRESS, developId = 19352 },
		{ equipId = 8, developedEquipType = n.BATTLE_DRESS, developId = 19351 },
		{ equipId = 7, developedEquipType = n.BATTLE_DRESS, developId = 19350 },
		{ equipId = 6, developedEquipType = n.BATTLE_DRESS, developId = 19043 },
		{ equipId = 5, developedEquipType = n.BATTLE_DRESS, developId = 19059 },
		{ equipId = 4, developedEquipType = n.BATTLE_DRESS, developId = 19058 },
		{ equipId = 3, developedEquipType = n.BATTLE_DRESS, developId = 19055 },
		{ equipId = 2, developedEquipType = n.BATTLE_DRESS, developId = 19054 },
		{ equipId = 1, developedEquipType = n.BATTLE_DRESS, developId = 19053 },
	},
}
do
	e.ROUTE_SET_TYPETAG[p("day")] = "day"
	e.ROUTE_SET_TYPETAG[p("night")] = "night"
	e.ROUTE_SET_TYPETAG[p("caution")] = "caution"
	e.ROUTE_SET_TYPETAG[p("hold")] = "hold"
	e.ROUTE_SET_TYPETAG[p("travel")] = "travel"
	e.ROUTE_SET_TYPETAG[p("new")] = "new"
	e.ROUTE_SET_TYPETAG[p("old")] = "old"
	e.ROUTE_SET_TYPETAG[p("midnight")] = "midnight"
	e.ROUTE_SET_TYPETAG[p("sleep")] = "sleep"
end
e.DEFAULT_HOLD_TIME = 60
e.DEFAULT_TRAVEL_HOLD_TIME = 15
e.DEFAULT_SLEEP_TIME = 300
e.FOB_DD_SUIT_ATTCKER = 1
e.FOB_DD_SUIT_SNEAKING = 2
e.FOB_DD_SUIT_BTRDRS = 3
e.FOB_PF_SUIT_ARMOR = 4
function e._ConvertSoldierNameKeysToId(e)
	local t = {}
	local n = {}
	Tpp.MergeTable(n, e)
	for n, s in pairs(n) do
		if o(n) then
			local i = r("TppSoldier2", n)
			if i ~= a then
				table.insert(t, n)
				e[i] = s
			end
		end
	end
	for t, n in ipairs(t) do
		e[n] = nil
	end
end
function e._SetUpSoldierTypes(t, n)
	for a, n in ipairs(n) do
		if s(n) then
			e._SetUpSoldierTypes(t, n)
		else
			mvars.ene_soldierTypes[n] = EnemyType["TYPE_" .. t]
		end
	end
end
function e.SetUpSoldierTypes(n)
	for n, t in pairs(n) do
		e._SetUpSoldierTypes(n, t)
	end
end
function e._SetUpSoldierSubTypes(t, n)
	for a, n in ipairs(n) do
		if s(n) then
			e._SetUpSoldierSubTypes(t, n)
		else
			local e = r("TppSoldier2", n)
			mvars.ene_soldierSubType[e] = t
		end
	end
end
function e.SetUpSoldierSubTypes(n)
	for n, t in pairs(n) do
		e._SetUpSoldierSubTypes(n, t)
	end
end
function e.SetUpPowerSettings(e)
	mvars.ene_missionSoldierPowerSettings = e
	local n = {}
	for t, e in pairs(e) do
		for e, t in pairs(e) do
			local e = e
			if Tpp.IsTypeNumber(e) then
				e = t
			end
			n[e] = true
		end
	end
	mvars.ene_missionRequiresPowerSettings = n
end
function e.ApplyPowerSettingsOnInitialize()
	local n = mvars.ene_missionSoldierPowerSettings
	for n, t in pairs(n) do
		local n = r(n)
		if n == a then
		else
			e.ApplyPowerSetting(n, t)
		end
	end
end
function e.DisablePowerSettings(e)
	local n = { ASSAULT = true, HANDGUN = true }
	mvars.ene_disablePowerSettings = {}
	for t, e in ipairs(e) do
		if n[e] then
		else
			mvars.ene_disablePowerSettings[e] = true
		end
	end
	if mvars.ene_disablePowerSettings.SMG then
		mvars.ene_disablePowerSettings.MISSILE = true
		mvars.ene_disablePowerSettings.SHIELD = true
	end
end
function e.SetUpPersonalAbilitySettings(e)
	mvars.ene_missionSoldierPersonalAbilitySettings = e
end
function e.ApplyPersonalAbilitySettingsOnInitialize()
	local n = mvars.ene_missionSoldierPersonalAbilitySettings
	for n, t in pairs(n) do
		local n = r(n)
		if n == a then
		else
			e.ApplyPersonalAbilitySettings(n, t)
		end
	end
end
function e.SetSoldierType(n, e)
	mvars.ene_soldierTypes[n] = e
	GameObject.SendCommand(n, { id = "SetSoldier2Type", type = e })
end
function e.GetSoldierType(n)
	local e = TppMission.GetMissionID()
	if n == nil or n == a then
		if e == 10080 or e == 11080 then
			return EnemyType.TYPE_PF
		end
		for n, e in pairs(mvars.ene_soldierTypes) do
			if e then
				return e
			end
		end
	else
		if mvars.ene_soldierTypes then
			local e = mvars.ene_soldierTypes[n]
			if e then
				return e
			end
		end
	end
	if (e == 10150 or e == 10151) or e == 11151 then
		return EnemyType.TYPE_SKULL
	end
	local e = EnemyType.TYPE_SOVIET
	if TppLocation.IsAfghan() then
		e = EnemyType.TYPE_SOVIET
	elseif TppLocation.IsMiddleAfrica() then
		e = EnemyType.TYPE_PF
	elseif TppLocation.IsMotherBase() or TppLocation.IsMBQF() then
		e = EnemyType.TYPE_DD
	elseif TppLocation.IsCyprus() then
		e = EnemyType.TYPE_SKULL
	end
	return e
end
function e.SetSoldierSubType(e, n)
	mvars.ene_soldierSubType[e] = n
end
function e.GetSoldierSubType(t, a)
	local n = TppMission.GetMissionID()
	if n == 10115 or n == 11115 then
		return "DD_PW"
	end
	if TppMission.IsFOBMission(n) then
		return "DD_FOB"
	end
	local n = nil
	if mvars.ene_soldierSubType then
		n = mvars.ene_soldierSubType[t]
	end
	if n == nil then
		n = e.GetDefaultSoldierSubType(a)
	end
	return n
end
function e.GetCpSubType(t)
	if mvars.ene_soldierIDList then
		local n = mvars.ene_soldierIDList[t]
		if n ~= nil then
			for n, t in pairs(n) do
				return e.GetSoldierSubType(n)
			end
		end
	end
	if mvars.ene_cpList then
		local n = mvars.ene_cpList[t]
		local e = e.subTypeOfCp[n]
		if e ~= nil then
			return e
		end
	end
	return e.GetSoldierSubType(nil)
end
function e.GetDefaultSoldierSubType(n)
	if n == nil then
		n = e.GetSoldierType(nil)
	end
	if TppLocation.IsCyprus() then
		return "SKULL_CYPR"
	end
	if n == EnemyType.TYPE_SOVIET then
		return "SOVIET_A"
	elseif n == EnemyType.TYPE_PF then
		return "PF_A"
	elseif n == EnemyType.TYPE_DD then
		return "DD_A"
	elseif n == EnemyType.TYPE_SKULL then
		return "SKULL_AFGH"
	elseif n == EnemyType.TYPE_CHILD then
		return "CHILD_A"
	else
		return "SOVIET_A"
	end
	return nil
end
function e._CreateDDWeaponIdTable(p, s, o)
	local r = { NORMAL = {} }
	local t = r.NORMAL
	mvars.ene_ddWeaponCount = 0
	t.IS_NOKILL = {}
	local e = e.DDWeaponIdInfo
	for a, e in pairs(e) do
		for n, e in ipairs(e) do
			local n = false
			local i = e.developedEquipType
			if i == nil then
				n = true
			elseif e.isNoKill and not o then
				n = false
			else
				local e = e.developId
				local e = TppMotherBaseManagement.GetEquipDevelopRank(e)
				if s >= e and p[i] >= e then
					n = true
				end
			end
			if n then
				mvars.ene_ddWeaponCount = mvars.ene_ddWeaponCount + 1
				if t[a] then
				else
					t[a] = e.equipId
					if e.isNoKill then
						t.IS_NOKILL[a] = true
					end
				end
			end
		end
	end
	return r
end
function e.GetDDWeaponCount()
	return mvars.ene_ddWeaponCount
end
function e.ClearDDParameter()
	e.weaponIdTable.DD = nil
end
function e.PrepareDDParameter(t, a)
	if TppMotherBaseManagement.GetMbsDevelopedEquipGradeTable == nil then
		e.weaponIdTable.DD =
			{ NORMAL = { HANDGUN = TppEquip.EQP_WP_West_hg_010, ASSAULT = TppEquip.EQP_WP_West_ar_040 } }
		return
	end
	local i = TppMotherBaseManagement.GetMbsDevelopedEquipGradeTable()
	t = t or 9999
	if gvars.ini_isTitleMode then
		e.ClearDDParameter()
	end
	if e.weaponIdTable.DD ~= nil then
	else
		e.weaponIdTable.DD = e._CreateDDWeaponIdTable(i, t, a)
	end
	local a = i[n.FULTON_16001]
	local i = i[n.FULTON_16008]
	if a > t then
		a = t
	end
	if i > t then
		i = t
	end
	local n = 0
	if a >= 4 then
		n = 3
	elseif a >= 3 then
		n = 2
	elseif a >= 1 then
		n = 1
	end
	local t = false
	if i ~= 0 then
		t = true
	end
	e.weaponIdTable.DD.NORMAL.FULTON_LV = n
	e.weaponIdTable.DD.NORMAL.WORMHOLE_FULTON = t
end
function e.SetUpDDParameter()
	if not GameObject.DoesGameObjectExistWithTypeName("TppSoldier2") then
		return
	end
	local t = { type = "TppCommandPost2" }
	local n = {
		id = "SetFultonLevel",
		fultonLevel = e.weaponIdTable.DD.NORMAL.FULTON_LV,
		isWormHole = e.weaponIdTable.DD.NORMAL.WORMHOLE_FULTON,
	}
	GameObject.SendCommand(t, n)
	if
		(e.weaponIdTable.DD.NORMAL.SNEAKING_SUIT and e.weaponIdTable.DD.NORMAL.SNEAKING_SUIT >= 3)
		or (e.weaponIdTable.DD.NORMAL.BATTLE_DRESS and e.weaponIdTable.DD.NORMAL.BATTLE_DRESS >= 3)
	then
		TppRevenge.SetHelmetAll()
	end
	local n = e.weaponIdTable.DD.NORMAL.GRENADE or TppEquip.EQP_SWP_Grenade
	local e = e.weaponIdTable.DD.NORMAL.STUN_GRENADE or TppEquip.EQP_None
	GameObject.SendCommand({ type = "TppSoldier2" }, { id = "RegistGrenadeId", grenadeId = n, stunId = e })
end
function e.GetWeaponIdTable(t, a)
	local n = {}
	local n = {}
	if t == EnemyType.TYPE_SOVIET then
		n = e.weaponIdTable.SOVIET_A
	elseif t == EnemyType.TYPE_PF then
		n = e.weaponIdTable.PF_A
		if a == "PF_B" then
			n = e.weaponIdTable.PF_B
		elseif a == "PF_C" then
			n = e.weaponIdTable.PF_C
		end
	elseif t == EnemyType.TYPE_DD then
		n = e.weaponIdTable.DD
	elseif t == EnemyType.TYPE_SKULL then
		if a == "SKULL_CYPR" then
			n = e.weaponIdTable.SKULL_CYPR
		else
			n = e.weaponIdTable.SKULL
		end
	elseif t == EnemyType.TYPE_CHILD then
		n = e.weaponIdTable.CHILD
	else
		n = e.weaponIdTable.SOVIET_A
	end
	return n
end
function e.GetWeaponId(t, i)
	local a, p, s
	local n = e.GetSoldierType(t)
	local r = e.GetSoldierSubType(t, n)
	local t = TppMission.GetMissionID()
	if (t == 10080 or t == 11080) and n == EnemyType.TYPE_CHILD then
		return TppEquip.EQP_WP_Wood_ar_010, TppEquip.EQP_WP_West_hg_010, nil
	end
	local t = e.GetWeaponIdTable(n, r)
	if t == nil then
		return nil, nil, nil
	end
	local n = {}
	if TppRevenge.IsUsingStrongWeapon() and t.STRONG then
		n = t.STRONG
	else
		n = t.NORMAL
	end
	s = TppEquip.EQP_None
	p = n.HANDGUN
	local o = {}
	if TppRevenge.IsUsingStrongSniper() and t.STRONG then
		o = t.STRONG
	else
		o = t.NORMAL
	end
	local r = {}
	if TppRevenge.IsUsingStrongMissile() and t.STRONG then
		r = t.STRONG
	else
		r = t.NORMAL
	end
	if i.SNIPER and o.SNIPER then
		a = o.SNIPER
	elseif i.SHOTGUN and n.SHOTGUN then
		a = n.SHOTGUN
	elseif i.MG and n.MG then
		a = n.MG
	elseif i.SMG and n.SMG then
		a = n.SMG
	else
		a = n.ASSAULT
	end
	if i.SHIELD and n.SHIELD then
		s = n.SHIELD
	elseif i.MISSILE and r.MISSILE then
		s = r.MISSILE
	end
	if i.GUN_LIGHT then
		local e = e.gunLightWeaponIds[a]
		a = e or a
	end
	return a, p, s
end
function e.GetBodyId(t, o, r, a)
	local i
	local n = {}
	if o == EnemyType.TYPE_SOVIET then
		n = e.bodyIdTable.SOVIET_A
		if r == "SOVIET_B" then
			n = e.bodyIdTable.SOVIET_B
		end
	elseif o == EnemyType.TYPE_PF then
		n = e.bodyIdTable.PF_A
		if r == "PF_B" then
			n = e.bodyIdTable.PF_B
		elseif r == "PF_C" then
			n = e.bodyIdTable.PF_C
		end
	elseif o == EnemyType.TYPE_DD then
		n = e.bodyIdTable.DD_A
		if r == "DD_FOB" then
			n = e.bodyIdTable.DD_FOB
		elseif r == "DD_PW" then
			n = e.bodyIdTable.DD_PW
		end
	elseif o == EnemyType.TYPE_SKULL then
		if e.bodyIdTable[r] then
			n = e.bodyIdTable[r]
		else
			n = e.bodyIdTable.SKULL_AFGH
		end
	elseif o == EnemyType.TYPE_CHILD then
		n = e.bodyIdTable.CHILD
	else
		n = e.bodyIdTable.SOVIET_A
	end
	if n == nil then
		return nil
	end
	local e = function(n, e)
		if #e == 0 then
			return e[1]
		end
		return e[(n % #e) + 1]
	end
	if a.ARMOR and n.ARMOR then
		return e(t, n.ARMOR)
	end
	if (mvars.ene_soldierLrrp[t] or a.RADIO) and n.RADIO then
		return e(t, n.RADIO)
	end
	if a.MISSILE and n.MISSILE then
		return e(t, n.MISSILE)
	end
	if a.SHIELD and n.SHIELD then
		return e(t, n.SHIELD)
	end
	if a.SNIPER and n.SNIPER then
		i = e(t, n.SNIPER)
	elseif a.SHOTGUN and n.SHOTGUN then
		if a.OB and n.SHOTGUN_OB then
			i = e(t, n.SHOTGUN_OB)
		else
			i = e(t, n.SHOTGUN)
		end
	elseif a.MG and n.MG then
		if a.OB and n.MG_OB then
			i = e(t, n.MG_OB)
		else
			i = e(t, n.MG)
		end
	elseif n.ASSAULT then
		if a.OB and n.ASSAULT_OB then
			i = e(t, n.ASSAULT_OB)
		else
			i = e(t, n.ASSAULT)
		end
	end
	return i
end
function e.GetFaceId(n, e, n, n)
	if e == EnemyType.TYPE_SKULL then
		return EnemyFova.INVALID_FOVA_VALUE
	elseif e == EnemyType.TYPE_DD then
		return EnemyFova.INVALID_FOVA_VALUE
	elseif e == EnemyType.TYPE_CHILD then
		return 630
	end
	return nil
end
function e.GetBalaclavaFaceId(t, e, t, n)
	if e == EnemyType.TYPE_SKULL then
		return EnemyFova.NOT_USED_FOVA_VALUE
	elseif e == EnemyType.TYPE_DD then
		if n.HELMET then
			return TppEnemyFaceId.dds_balaclava0
		else
			return TppEnemyFaceId.dds_balaclava2
		end
	end
	return nil
end
function e.IsSniper(e)
	local e = mvars.ene_soldierPowerSettings[e]
	if e ~= nil and e.SNIPER then
		return true
	end
	return false
end
function e.IsMissile(e)
	local e = mvars.ene_soldierPowerSettings[e]
	if e ~= nil and e.MISSILE then
		return true
	end
	return false
end
function e.IsShield(e)
	local e = mvars.ene_soldierPowerSettings[e]
	if e ~= nil and e.SHIELD then
		return true
	end
	return false
end
function e.IsArmor(e)
	local e = mvars.ene_soldierPowerSettings[e]
	if e ~= nil and e.ARMOR then
		return true
	end
	return false
end
function e.IsHelmet(e)
	local e = mvars.ene_soldierPowerSettings[e]
	if e ~= nil and e.HELMET then
		return true
	end
	return false
end
function e.IsNVG(e)
	local e = mvars.ene_soldierPowerSettings[e]
	if e ~= nil and e.NVG then
		return true
	end
	return false
end
function e.AddPowerSetting(n, a)
	local t = mvars.ene_soldierPowerSettings[n] or {}
	for a, n in pairs(a) do
		t[a] = n
	end
	e.ApplyPowerSetting(n, t)
end
function e.ApplyPowerSetting(t, i)
	if t == a then
		return
	end
	local r = e.GetSoldierType(t)
	local a = e.GetSoldierSubType(t, r)
	local n = {}
	for e, t in pairs(i) do
		if Tpp.IsTypeNumber(e) then
			n[t] = true
		else
			n[e] = t
		end
	end
	local o = { SMG = true, MG = true, SHOTGUN = true, SNIPER = true, MISSILE = true, SHIELD = true }
	for e, t in pairs(o) do
		if n[e] and not mvars.revenge_loadedEquip[e] then
			n[e] = nil
		end
	end
	if r == EnemyType.TYPE_SKULL then
		if a == "SKULL_CYPR" then
			n.SNIPER = nil
			n.SHOTGUN = nil
			n.MG = nil
			n.SMG = true
			n.GUN_LIGHT = true
		else
			n.HELMET = true
			n.SOFT_ARMOR = true
		end
	end
	if n.ARMOR and not TppRevenge.CanUseArmor(a) then
		n.ARMOR = nil
	end
	if n.QUEST_ARMOR then
		n.ARMOR = true
	end
	if n.ARMOR then
		n.SNIPER = nil
		n.SHIELD = nil
		n.MISSILE = nil
		n.SMG = nil
		if not n.SHOTGUN and not n.MG then
			if mvars.revenge_loadedEquip.MG then
				n.MG = true
			elseif mvars.revenge_loadedEquip.SHOTGUN then
				n.SHOTGUN = true
			end
		end
		if n.MG then
			n.SHOTGUN = nil
		end
		if n.SHOTGUN then
			n.MG = nil
		end
	end
	if n.MISSILE or n.SHIELD then
		n.SNIPER = nil
		n.SHOTGUN = nil
		n.MG = nil
		n.SMG = true
	end
	if n.GAS_MASK then
		if a ~= "DD_FOB" then
			n.HELMET = nil
			n.NVG = nil
		end
	end
	if n.NVG then
		if a ~= "DD_FOB" then
			n.HELMET = nil
			n.GAS_MASK = nil
		end
	end
	if n.HELMET then
		if a ~= "DD_FOB" then
			n.GAS_MASK = nil
			n.NVG = nil
		end
	end
	mvars.ene_soldierPowerSettings[t] = n
	i = n
	local n = 0
	local o = e.GetBodyId(t, r, a, i)
	local p = e.GetFaceId(t, r, a, i)
	local l = e.GetBalaclavaFaceId(t, r, a, i)
	local r, s, e = e.GetWeaponId(t, i)
	if i.HELMET then
		n = n + WearEquip.HELMET
	end
	if i.GAS_MASK then
		n = n + WearEquip.GAS_MASK
	end
	if i.NVG then
		n = n + WearEquip.NVG
	end
	if i.SOFT_ARMOR then
		n = n + WearEquip.SOFT_ARMOR
	end
	if (r ~= nil or secondaryWeapon ~= nil) or e ~= nil then
		GameObject.SendCommand(t, { id = "SetEquipId", primary = r, secondary = s, tertiary = e })
	end
	GameObject.SendCommand(t, { id = "ChangeFova", bodyId = o, faceId = p, balaclavaFaceId = l })
	GameObject.SendCommand(t, { id = "SetWearEquip", flag = n })
	local e = {
		SOVIET_A = d.SOVIET_A,
		SOVIET_B = d.SOVIET_B,
		PF_A = d.PF_A,
		PF_B = d.PF_B,
		PF_C = d.PF_C,
		DD_A = d.DD_A,
		DD_FOB = d.DD_FOB,
		DD_PW = d.DD_PW,
		CHILD_A = d.CHILD_A,
		SKULL_AFGH = d.SKULL_AFGH,
		SKULL_CYPR = d.SKULL_CYPR,
	}
	GameObject.SendCommand(t, { id = "SetSoldier2SubType", type = e[a] })
end
function e.ApplyPersonalAbilitySettings(e, n)
	if e == a then
		return
	end
	mvars.ene_soldierPersonalAbilitySettings[e] = n
	GameObject.SendCommand(e, { id = "SetPersonalAbility", ability = n })
end
function e.SetOccasionalChatList()
	if not GameObject.DoesGameObjectExistWithTypeName("TppSoldier2") then
		return
	end
	local e = {}
	table.insert(e, "USSR_story_04")
	table.insert(e, "USSR_story_05")
	table.insert(e, "USSR_story_06")
	table.insert(e, "USSR_story_07")
	table.insert(e, "USSR_story_08")
	table.insert(e, "USSR_story_15")
	table.insert(e, "USSR_story_16")
	table.insert(e, "USSR_story_17")
	table.insert(e, "USSR_story_18")
	table.insert(e, "USSR_story_19")
	table.insert(e, "PF_story_01")
	table.insert(e, "PF_story_04")
	table.insert(e, "PF_story_05")
	table.insert(e, "PF_story_06")
	table.insert(e, "PF_story_07")
	table.insert(e, "PF_story_08")
	table.insert(e, "PF_story_12")
	table.insert(e, "PF_story_13")
	table.insert(e, "PF_story_14")
	table.insert(e, "PF_story_15")
	table.insert(e, "MB_story_07")
	table.insert(e, "MB_story_08")
	table.insert(e, "MB_story_18")
	table.insert(e, "MB_story_19")
	local n = gvars.str_storySequence
	if n < TppDefine.STORY_SEQUENCE.CLEARD_RESCUE_HUEY then
		table.insert(e, "USSR_story_01")
		table.insert(e, "USSR_story_02")
		table.insert(e, "USSR_story_03")
	end
	if not TppBuddyService.DidObtainBuddyType(BuddyType.QUIET) and not TppStory.IsMissionCleard(10050) then
		table.insert(e, "USSR_story_10")
	end
	if n >= TppDefine.STORY_SEQUENCE.CLEARD_FIND_THE_SECRET_WEAPON then
		table.insert(e, "USSR_story_11")
	end
	if
		n >= TppDefine.STORY_SEQUENCE.CLEARD_FIND_THE_SECRET_WEAPON
		and n < TppDefine.STORY_SEQUENCE.CLEARD_RESCUE_HUEY
	then
		table.insert(e, "USSR_story_12")
		table.insert(e, "USSR_story_13")
	end
	if
		n >= TppDefine.STORY_SEQUENCE.CLEARD_FIND_THE_SECRET_WEAPON
		and n < TppDefine.STORY_SEQUENCE.CLEARD_SKULLFACE
	then
		table.insert(e, "USSR_story_14")
	end
	if
		n >= TppDefine.STORY_SEQUENCE.CLEARD_DESTROY_THE_FLOW_STATION
		and n < TppDefine.STORY_SEQUENCE.CLEARD_METALLIC_ARCHAEA
	then
		table.insert(e, "PF_story_02")
	end
	if
		n >= TppDefine.STORY_SEQUENCE.CLEARD_DESTROY_THE_FLOW_STATION
		and n < TppDefine.STORY_SEQUENCE.CLEARD_ELIMINATE_THE_COMMANDER
	then
		table.insert(e, "PF_story_03")
	end
	if
		n >= TppDefine.STORY_SEQUENCE.CLEARD_DESTROY_THE_FLOW_STATION
		and n < TppDefine.STORY_SEQUENCE.CLEARD_SKULLFACE
	then
		table.insert(e, "PF_story_09")
	end
	if
		n >= TppDefine.STORY_SEQUENCE.CLEARD_DESTROY_THE_FLOW_STATION
		and n < TppDefine.STORY_SEQUENCE.CLEARD_CODE_TALKER
	then
		table.insert(e, "PF_story_10")
	end
	if n >= TppDefine.STORY_SEQUENCE.CLEARD_DESTROY_THE_FLOW_STATION then
		table.insert(e, "PF_story_11")
	end
	if
		(n >= TppDefine.STORY_SEQUENCE.CLEARD_FIND_THE_SECRET_WEAPON and TppResult.GetTotalNeutralizeCount() < 10)
		and TppResult.IsTotalPlayStyleStealth()
	then
		table.insert(e, "MB_story_01")
	end
	if
		n >= TppDefine.STORY_SEQUENCE.CLEARD_FIND_THE_SECRET_WEAPON
		and TppMotherBaseManagement.GetOgrePoint() >= 5e4
	then
		table.insert(e, "MB_story_02")
	end
	if
		TppMotherBaseManagement.IsOpenedSection({ section = "Security" })
		and TppMotherBaseManagement.GetSectionLv({ section = "Security" }) < 20
	then
		table.insert(e, "MB_story_03")
	end
	if
		n >= TppDefine.STORY_SEQUENCE.CLEARD_ELIMINATE_THE_POWS
		and n < TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS
	then
		table.insert(e, "MB_story_04")
	end
	if TppTerminal.IsBuiltAnimalPlatform() then
		table.insert(e, "MB_story_05")
	end
	if TppBuddyService.DidObtainBuddyType(BuddyType.QUIET) and not TppBuddyService.IsDeadBuddyType(BuddyType.QUIET) then
		table.insert(e, "MB_story_09")
	end
	if
		(TppBuddyService.DidObtainBuddyType(BuddyType.DOG) and not TppBuddyService.CanSortieBuddyType(BuddyType.DOG))
		and not TppBuddyService.IsDeadBuddyType(BuddyType.DOG)
	then
		table.insert(e, "MB_story_10")
	end
	if
		(TppBuddyService.DidObtainBuddyType(BuddyType.DOG) and TppBuddyService.CanSortieBuddyType(BuddyType.DOG))
		and not TppBuddyService.IsDeadBuddyType(BuddyType.DOG)
	then
		table.insert(e, "MB_story_11")
	end
	if TppMotherBaseManagement.IsPandemicEventMode() then
		table.insert(e, "MB_story_12")
	end
	if n >= TppDefine.STORY_SEQUENCE.CLEARD_OKB_ZERO and n < TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then
		table.insert(e, "MB_story_13")
	end
	if n >= TppDefine.STORY_SEQUENCE.CLEARD_OKB_ZERO then
		table.insert(e, "MB_story_14")
	end
	if n >= TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then
		table.insert(e, "MB_story_15")
	end
	if gvars.pazLookedPictureCount >= 1 and gvars.pazLookedPictureCount < 10 then
		table.insert(e, "MB_story_16")
	end
	if TppDemo.IsPlayedMBEventDemo("DecisionHuey") then
		table.insert(e, "MB_story_17")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.FULTON) == 1 then
		table.insert(e, "USSR_revenge_01")
		table.insert(e, "PF_revenge_01")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.FULTON) >= 2 then
		table.insert(e, "USSR_revenge_02")
		table.insert(e, "PF_revenge_02")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) == 1 then
		table.insert(e, "USSR_revenge_03")
		table.insert(e, "PF_revenge_03")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) == 2 then
		table.insert(e, "USSR_revenge_04")
		table.insert(e, "PF_revenge_04")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) == 3 then
		table.insert(e, "USSR_revenge_05")
		table.insert(e, "PF_revenge_05")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH) == 1 then
		table.insert(e, "USSR_revenge_06")
		table.insert(e, "PF_revenge_06")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH) == 2 then
		table.insert(e, "USSR_revenge_07")
		table.insert(e, "PF_revenge_07")
	end
	if
		TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.HEAD_SHOT) == 0
		and TppRevenge.GetRevengePoint(TppRevenge.REVENGE_TYPE.HEAD_SHOT) >= 50
	then
		table.insert(e, "USSR_revenge_08")
		table.insert(e, "PF_revenge_08")
	end
	if
		TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.VEHICLE) == 0
		and TppRevenge.GetRevengePoint(TppRevenge.REVENGE_TYPE.VEHICLE) >= 50
	then
		table.insert(e, "USSR_revenge_09")
		table.insert(e, "PF_revenge_09")
	end
	if
		TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.VEHICLE) == 0
		and TppRevenge.GetRevengePoint(TppRevenge.REVENGE_TYPE.VEHICLE) >= 50
	then
		table.insert(e, "USSR_revenge_10")
		table.insert(e, "PF_revenge_10")
	end
	if
		TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.LONG_RANGE) == 0
		and TppRevenge.GetRevengePoint(TppRevenge.REVENGE_TYPE.LONG_RANGE) >= 50
	then
		table.insert(e, "USSR_revenge_11")
		table.insert(e, "PF_revenge_11")
	end
	if
		TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.NIGHT_S) == 0
		and TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.NIGHT_C) == 0
	then
		if
			TppRevenge.GetRevengePoint(TppRevenge.REVENGE_TYPE.NIGHT_S) >= 50
			or TppRevenge.GetRevengePoint(TppRevenge.REVENGE_TYPE.NIGHT_C) >= 50
		then
			table.insert(e, "USSR_revenge_12")
			table.insert(e, "PF_revenge_12")
		end
	end
	if
		TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH) == 3
		and TppRevenge.GetRevengePoint(TppRevenge.REVENGE_TYPE.TRANQ) > 0
	then
		table.insert(e, "USSR_revenge_13")
		table.insert(e, "PF_revenge_13")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH) >= 3 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.MINE) then
			table.insert(e, "USSR_counter_01")
			table.insert(e, "PF_counter_01")
		end
	end
	if
		TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.HEAD_SHOT) >= 1
		and TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.HEAD_SHOT) <= 9
	then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.HELMET) then
			table.insert(e, "USSR_counter_03")
			table.insert(e, "PF_counter_03")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.HEAD_SHOT) == 10 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.HELMET) then
			table.insert(e, "USSR_counter_04")
			table.insert(e, "PF_counter_04")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) >= 1 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.SOFT_ARMOR) then
			table.insert(e, "USSR_counter_05")
			table.insert(e, "PF_counter_05")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) >= 1 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.SHIELD) then
			table.insert(e, "USSR_counter_06")
			table.insert(e, "PF_counter_06")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.NIGHT_S) >= 1 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.NVG) then
			table.insert(e, "USSR_counter_07")
			table.insert(e, "PF_counter_07")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.NIGHT_C) >= 1 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.GUN_LIGHT) then
			table.insert(e, "USSR_counter_08")
			table.insert(e, "PF_counter_08")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) >= 3 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.ARMOR) then
			table.insert(e, "USSR_counter_10")
			table.insert(e, "PF_counter_10")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) >= 3 then
		table.insert(e, "USSR_counter_11")
		table.insert(e, "PF_counter_11")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) >= 3 then
		table.insert(e, "USSR_counter_12")
		table.insert(e, "PF_counter_12")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) >= 3 then
		table.insert(e, "USSR_counter_13")
		table.insert(e, "PF_counter_13")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) >= 3 then
		table.insert(e, "USSR_counter_14")
		table.insert(e, "PF_counter_14")
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) >= 3 then
		if
			not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.SHOTGUN)
			or not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.MG)
		then
			table.insert(e, "USSR_counter_15")
			table.insert(e, "PF_counter_15")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.LONG_RANGE) >= 2 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.SNIPER) then
			table.insert(e, "USSR_counter_16")
			table.insert(e, "PF_counter_16")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.VEHICLE) == 1 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.MISSILE) then
			table.insert(e, "USSR_counter_17")
			table.insert(e, "PF_counter_17")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.VEHICLE) >= 2 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.MISSILE) then
			table.insert(e, "USSR_counter_18")
			table.insert(e, "PF_counter_18")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH) >= 2 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.DECOY) then
			table.insert(e, "USSR_counter_19")
			table.insert(e, "PF_counter_19")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.STEALTH) >= 1 then
		if not TppRevenge.IsBlocked(TppRevenge.BLOCKED_TYPE.CAMERA) then
			table.insert(e, "USSR_counter_20")
			table.insert(e, "PF_counter_20")
		end
	end
	if TppRevenge.GetRevengeLv(TppRevenge.REVENGE_TYPE.COMBAT) >= 3 then
		table.insert(e, "USSR_counter_22")
	end
	local n = { type = "TppSoldier2" }
	GameObject.SendCommand(n, { id = "SetConversationList", list = e })
end
function e.SetSaluteVoiceList()
	if not GameObject.DoesGameObjectExistWithTypeName("TppSoldier2") then
		return
	end
	local r = {}
	local i = {}
	local t = {}
	local p = {}
	local e = {}
	local s = {}
	table.insert(e, "EVF010")
	table.insert(e, "salute0180")
	table.insert(e, "salute0220")
	table.insert(e, "salute0310")
	table.insert(e, "salute0320")
	table.insert(t, "salute0410")
	table.insert(t, "salute0420")
	local a = gvars.str_storySequence
	if TppMotherBaseManagement.GetOgrePoint() >= 5e4 then
		table.insert(i, "salute0080")
	elseif Player.GetSmallFlyLevel() >= 5 then
		table.insert(i, "salute0050")
	elseif Player.GetSmallFlyLevel() >= 3 then
		table.insert(i, "salute0040")
	else
		table.insert(i, "salute0060")
	end
	local o = TppMotherBaseManagement.GetStaffCount()
	local n = 0
	n = n + TppMotherBaseManagement.GetSectionStaffCountLimit({ section = TppMotherBaseManagementConst.SECTION_COMBAT })
	n = n + TppMotherBaseManagement.GetSectionStaffCountLimit({
			section = TppMotherBaseManagementConst.SECTION_DEVELOP,
		})
	n = n + TppMotherBaseManagement.GetSectionStaffCountLimit({
			section = TppMotherBaseManagementConst.SECTION_BASE_DEV,
		})
	n = n + TppMotherBaseManagement.GetSectionStaffCountLimit({
			section = TppMotherBaseManagementConst.SECTION_SUPPORT,
		})
	n = n + TppMotherBaseManagement.GetSectionStaffCountLimit({ section = TppMotherBaseManagementConst.SECTION_SPY })
	n = n + TppMotherBaseManagement.GetSectionStaffCountLimit({
			section = TppMotherBaseManagementConst.SECTION_MEDICAL,
		})
	n = n + TppMotherBaseManagement.GetSectionStaffCountLimit({
			section = TppMotherBaseManagementConst.SECTION_SECURITY,
		})
	local n = o / n
	if n < 0.2 then
		table.insert(e, "salute0100")
	elseif n < 0.4 then
		table.insert(e, "salute0090")
	elseif n > 0.8 then
		table.insert(e, "salute0120")
	end
	if TppMotherBaseManagement.GetGmp() < 0 then
		table.insert(e, "salute0150")
	end
	if TppMotherBaseManagement.GetDevelopableEquipCount() > 8 then
		table.insert(e, "salute0160")
	end
	if
		(
			TppMotherBaseManagement.GetResourceUsableCount({ resource = "CommonMetal" }) < 500
			or TppMotherBaseManagement.GetResourceUsableCount({ resource = "FuelResource" }) < 200
		) or TppMotherBaseManagement.GetResourceUsableCount({ resource = "BioticResource" }) < 200
	then
		table.insert(e, "salute0170")
	end
	if TppMotherBaseManagement.IsBuiltFirstFob() then
		table.insert(e, "salute0190")
	end
	if TppTerminal.IsReleaseSection("Combat") then
		table.insert(e, "salute0200")
	end
	if
		TppMotherBaseManagement.IsOpenedSectionFunc({
			sectionFuncId = TppMotherBaseManagementConst.SECTION_FUNC_ID_SUPPORT_BATTLE,
		})
	then
		local n = TppMotherBaseManagement.GetSectionFuncRank({
			sectionFuncId = TppMotherBaseManagementConst.SECTION_FUNC_ID_SUPPORT_BATTLE,
		})
		if n >= TppMotherBaseManagementConst.SECTION_FUNC_RANK_E then
			table.insert(e, "salute0230")
		end
	end
	if
		(TppBuddyService.DidObtainBuddyType(BuddyType.DOG) and not TppBuddyService.CanSortieBuddyType(BuddyType.DOG))
		and not TppBuddyService.IsDeadBuddyType(BuddyType.DOG)
	then
		table.insert(e, "salute0240")
	end
	if
		(
			TppBuddyService.DidObtainBuddyType(BuddyType.QUIET)
			and not TppBuddyService.CanSortieBuddyType(BuddyType.QUIET)
		) and not TppBuddyService.IsDeadBuddyType(BuddyType.QUIET)
	then
		table.insert(e, "salute0250")
	end
	if
		TppMotherBaseManagement.GetResourceUsableCount({ resource = "Plant2000" }) < 100
		or TppMotherBaseManagement.GetResourceUsableCount({ resource = "Plant2005" }) < 100
	then
		table.insert(e, "salute0260")
	end
	if a == TppDefine.STORY_SEQUENCE.CLEARD_TAKE_OUT_THE_CONVOY then
		table.insert(t, "salute0270")
	end
	if
		TppMotherBaseManagement.IsPandemicEventMode()
		or a == TppDefine.STORY_SEQUENCE.CLEARD_FLAG_MISSIONS_BEFORE_MURDER_INFECTORS
	then
		table.insert(t, "salute0280")
	end
	if a == TppDefine.STORY_SEQUENCE.CLEARD_ELIMINATE_THE_POWS then
		table.insert(t, "salute0290")
	end
	if TppTerminal.IsBuiltAnimalPlatform() then
		table.insert(e, "salute0300")
	end
	if a == TppDefine.STORY_SEQUENCE.CLEARD_RESCUE_INTEL_AGENTS then
		table.insert(t, "salute0330")
	end
	if a >= TppDefine.STORY_SEQUENCE.CLEARD_METALLIC_ARCHAEA and a <= TppDefine.STORY_SEQUENCE.CLEARD_OKB_ZERO then
		table.insert(t, "salute0340")
	end
	if a == TppDefine.STORY_SEQUENCE.CLEARD_MURDER_INFECTORS then
		table.insert(t, "salute0350")
		table.insert(t, "salute0360")
	end
	if a >= TppDefine.STORY_SEQUENCE.CLEARD_THE_TRUTH then
		table.insert(e, "salute0370")
	end
	if TppUiCommand.IsBirthDay() then
		table.insert(r, "salute0380")
	end
	local e = { high = { normal = r, once = i }, mid = { normal = t, once = p }, low = { normal = e, once = s } }
	local n = { type = "TppSoldier2" }
	GameObject.SendCommand(n, { id = "SetSaluteVoiceList", list = e })
end
function e.RequestLoadWalkerGearEquip()
	TppEquip.RequestLoadToEquipMissionBlock({ TppEquip.EQP_WP_West_hg_010 })
end
function e.SetSoldier2CommonPackageLabel(e)
	mvars.ene_soldier2CommonBlockPackageLabel = e
end
function e.AssignUniqueStaffType(e)
	if not s(e) then
		return
	end
	local t = e.locaterName
	local i = e.gameObjectId
	local n = e.uniqueStaffTypeId
	local s = e.alreadyExistParam
	if not l(n) then
		return
	end
	if (not l(i)) and (not o(t)) then
		return
	end
	local e
	if l(i) then
		e = i
	elseif o(t) then
		e = r(t)
	end
	if not TppDefine.IGNORE_EXIST_STAFF_CHECK[n] then
		if TppMotherBaseManagement.IsExistStaff({ uniqueTypeId = n }) then
			if s then
				local e = { gameObjectId = e }
				for n, t in pairs(s) do
					e[n] = t
				end
				TppMotherBaseManagement.RegenerateGameObjectStaffParameter(e)
				return
			else
				return
			end
		end
	end
	if e ~= a then
		TppMotherBaseManagement.RegenerateGameObjectStaffParameter({ gameObjectId = e, staffType = "Unique", uniqueTypeId = n })
	end
end
function e.IsActiveSoldierInRange(n, e)
	local e = { id = "IsActiveSoldierInRange", position = n, range = e }
	return t({ type = "TppSoldier2" }, e)
end
function e._SetOutOfArea(n, t)
	if s(n) then
		for a, n in ipairs(n) do
			e._SetOutOfArea(n, t)
		end
	else
		local e = r("TppSoldier2", n)
		table.insert(t, e)
	end
end
function e.SetOutOfArea(a, i)
	local n = {}
	e._SetOutOfArea(a, n)
	local e = { id = "SetOutOfArea", soldiers = n, isOut = i }
	t({ type = "TppSoldier2" }, e)
end
function e.SetEliminateTargets(t, n)
	mvars.ene_eliminateTargetList = {}
	mvars.ene_eliminateHelicopterList = {}
	mvars.ene_eliminateVehicleList = {}
	mvars.ene_eliminateWalkerGearList = {}
	local i = {}
	if Tpp.IsTypeTable(n) then
		if Tpp.IsTypeTable(n.exceptMissionClearCheck) then
			for n, e in pairs(n.exceptMissionClearCheck) do
				i[e] = true
			end
		end
	end
	for t, n in pairs(t) do
		local t = r(n)
		if t ~= a then
			if Tpp.IsSoldier(t) then
				if not i[n] then
					mvars.ene_eliminateTargetList[t] = n
				end
				e.RegistHoldRecoveredState(n)
				e.SetTargetOption(n)
			elseif Tpp.IsEnemyHelicopter(t) then
				if not i[n] then
					mvars.ene_eliminateHelicopterList[t] = n
				end
			elseif Tpp.IsVehicle(t) then
				if not i[n] then
					mvars.ene_eliminateVehicleList[t] = n
				end
				e.RegistHoldRecoveredState(n)
				e.RegistHoldBrokenState(n)
			elseif Tpp.IsEnemyWalkerGear(t) then
				if not i[n] then
					mvars.ene_eliminateWalkerGearList[t] = n
				end
				e.RegistHoldRecoveredState(n)
			end
			if i[n] then
			end
		end
	end
end
function e.DeleteEliminateTargetSetting(n)
	if not mvars.ene_eliminateTargetList then
		return
	end
	local e = r(n)
	if e == a then
		return
	end
	if mvars.ene_eliminateTargetList[e] then
		mvars.ene_eliminateTargetList[e] = nil
		local e = r("TppSoldier2", n)
		if e == a then
		else
			t(e, { id = "ResetSoldier2Flag" })
		end
	elseif mvars.ene_eliminateHelicopterList[e] then
		mvars.ene_eliminateHelicopterList[e] = nil
	elseif mvars.ene_eliminateVehicleList[e] then
		mvars.ene_eliminateVehicleList[e] = nil
	elseif mvars.ene_eliminateWalkerGearList[e] then
		mvars.ene_eliminateWalkerGearList[e] = nil
	else
		return
	end
	return true
end
function e.SetRescueTargets(t, n)
	mvars.ene_rescueTargetList = {}
	mvars.ene_rescueTargetOptions = n or {}
	for t, n in pairs(t) do
		local t = r(n)
		if t ~= a then
			mvars.ene_rescueTargetList[t] = n
			e.RegistHoldRecoveredState(n)
		end
	end
end
function e.SetVipHostage(n)
	e.SetRescueTargets(n)
end
function e.SetExcludeHostage(e)
	mvars.ene_excludeHostageGameObjectId = r(e)
end
function e.GetAllHostages()
	local e = { "TppHostage2", "TppHostageUnique", "TppHostageUnique2" }
	local s = TppGameObject.NPC_STATE_DISABLE
	local o = {}
	for e, r in ipairs(e) do
		local e = 1
		local i = 0
		while i < e do
			local n = T(r, i)
			if n == a then
				break
			end
			if e == 1 then
				e = t({ type = r }, { id = "GetMaxInstanceCount" })
				if not e or e < 1 then
					break
				end
			end
			local e = true
			if mvars.ene_excludeHostageGameObjectId and mvars.ene_excludeHostageGameObjectId == n then
				e = false
			end
			if e then
				local e = t(n, { id = "GetLifeStatus" })
				local t = t(n, { id = "GetStatus" })
				if (t ~= s) and (e ~= TppGameObject.NPC_LIFE_STATE_DEAD) then
					table.insert(o, n)
				end
			end
			i = i + 1
		end
	end
	return o
end
function e.GetAllActiveEnemyWalkerGear()
	local r = {}
	local e = 1
	local n = 0
	while n < e do
		local i = T("TppCommonWalkerGear2", n)
		if i == a then
			break
		end
		if e == 1 then
			e = t({ type = "TppCommonWalkerGear2" }, { id = "GetMaxInstanceCount" })
			if not e or e < 1 then
				break
			end
		end
		local a = t(i, { id = "IsBroken" })
		local e = t(i, { id = "IsFultonCaptured" })
		if (a == false) and (e == false) then
			table.insert(r, i)
		end
		n = n + 1
	end
	return r
end
function e.SetChildTargets(n)
	mvars.ene_childTargetList = {}
	for t, n in pairs(n) do
		local t = r(n)
		if t ~= a then
			mvars.ene_childTargetList[t] = n
			e.SetTargetOption(n)
		end
	end
end
function e.SetTargetOption(e)
	local e = r(e)
	if e == a then
	else
		t(e, { id = "SetVip" })
		t(e, { id = "SetForceRealize" })
		t(e, { id = "SetIgnoreSupportBlastInUnreal", enabled = true })
	end
end
function e.LetCpHasTarget(n, t)
	local e
	if l(n) then
		e = n
	elseif o(n) then
		e = r(n)
	else
		return
	end
	if e == a then
		return
	end
	GameObject.SendCommand(e, { id = "SetCpMissionTarget", enable = t })
end
function e.GetPhase(e)
	local n = r(e)
	return t(n, { id = "GetPhase", cpName = e })
end
function e.GetPhaseByCPID(e)
	return t(e, { id = "GetPhase", cpName = mvars.ene_cpList[e] })
end
function e.GetLifeStatus(e)
	if not e then
		return
	end
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	return t(e, { id = "GetLifeStatus" })
end
function e.GetActionStatus(e)
	if not e then
		return
	end
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	return t(e, { id = "GetActionStatus" })
end
function e.GetStatus(n)
	local e
	if o(n) then
		e = r(n)
	else
		e = n
	end
	if e ~= a then
		return t(e, { id = "GetStatus" })
	else
		return
	end
end
function e.IsEliminated(n)
	local t = e.GetLifeStatus(n)
	local n = e.GetStatus(n)
	return e._IsEliminated(t, n)
end
function e.IsNeutralized(n)
	local t = e.GetLifeStatus(n)
	local n = e.GetStatus(n)
	return e._IsNeutralized(t, n)
end
function e.IsRecovered(e)
	if not mvars.ene_recoverdStateIndexByName then
		return
	end
	local n
	if o(e) then
		n = mvars.ene_recoverdStateIndexByName[e]
	elseif l(e) then
		n = mvars.ene_recoverdStateIndexByGameObjectId[e]
	end
	if n then
		return svars.ene_isRecovered[n]
	end
end
function e.ChangeLifeState(n)
	if not Tpp.IsTypeTable(n) then
		return "Support table only"
	end
	local e = n.lifeState
	local t = 0
	local i = 4
	if not ((e > t) and (e < i)) then
		return "lifeState must be index"
	end
	local n = n.targetName
	if not o(n) then
		return "targetName must be string"
	end
	local t = r(n)
	if t ~= a then
		GameObject.SendCommand(t, { id = "ChangeLifeState", state = e })
	else
		return "Cannot get gameObjectId. targetName = " .. tostring(n)
	end
end
function e.SetSneakRoute(e, s, n, r)
	if not e then
		return
	end
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	n = n or 0
	local i = false
	if Tpp.IsTypeTable(r) then
		i = r.isRelaxed
	end
	if e ~= a then
		t(e, { id = "SetSneakRoute", route = s, point = n, isRelaxed = i })
	end
end
function e.UnsetSneakRoute(e)
	if not e then
		return
	end
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	if e ~= a then
		t(e, { id = "SetSneakRoute", route = "" })
	end
end
function e.SetCautionRoute(e, i, n, r)
	if not e then
		return
	end
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	n = n or 0
	if e ~= a then
		t(e, { id = "SetCautionRoute", route = i, point = n })
	end
end
function e.UnsetCautionRoute(e)
	if not e then
		return
	end
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	if e ~= a then
		t(e, { id = "SetCautionRoute", route = "" })
	end
end
function e.SetAlertRoute(e, i, n, r)
	if not e then
		return
	end
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	n = n or 0
	if e ~= a then
		t(e, { id = "SetAlertRoute", enabled = true, route = i, point = n })
	end
end
function e.UnsetAlertRoute(e)
	if not e then
		return
	end
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	if e ~= a then
		t(e, { id = "SetAlertRoute", enabled = false, route = "" })
	end
end
function e.RegistRoutePointMessage(e)
	if not s(e) then
		return
	end
	mvars.ene_routePointMessage = mvars.ene_routePointMessage or {}
	mvars.ene_routePointMessage.main = mvars.ene_routePointMessage.main or {}
	mvars.ene_routePointMessage.sequence = mvars.ene_routePointMessage.sequence or {}
	local n = {}
	n[p("GameObject")] = Tpp.StrCode32Table(e.messages)
	local n = (Tpp.MakeMessageExecTable(n))[p("GameObject")]
	local e = e.sequenceName
	if e then
		mvars.ene_routePointMessage.sequence[e] = mvars.ene_routePointMessage.sequence[e] or {}
		Tpp.MergeTable(mvars.ene_routePointMessage.sequence[e], n, true)
	else
		Tpp.MergeTable(mvars.ene_routePointMessage.main, n, true)
	end
end
function e.IsBaseCp(e)
	if not mvars.ene_baseCpList then
		return
	end
	return mvars.ene_baseCpList[e]
end
function e.IsOuterBaseCp(e)
	if not mvars.ene_outerBaseCpList then
		return
	end
	return mvars.ene_outerBaseCpList[e]
end
function e.ChangeRouteSets(n, a)
	mvars.ene_routeSetsTemporary = mvars.ene_routeSets
	mvars.ene_routeSetsPriorityTemporary = mvars.ene_routeSetsPriority
	e.MergeRouteSetDefine(n)
	mvars.ene_routeSets = {}
	mvars.ene_routeSetsPriority = {}
	mvars.ene_routeSetsFixedShiftChange = {}
	e.UpdateRouteSet(mvars.ene_routeSetsDefine)
	local n = { { { "old", "immediately" }, { "new", "immediately" } } }
	for e, a in pairs(mvars.ene_cpList) do
		t(e, { id = "ChangeRouteSets" })
		t(e, { id = "ShiftChange", schedule = n })
	end
end
function e.InitialRouteSetGroup(e)
	local i = r(e.cpName)
	local o = e.groupName
	if not s(e.soldierList) then
		return
	end
	local n = {}
	for t, e in pairs(e.soldierList) do
		local e = r(e)
		if e ~= a then
			n[t] = e
		end
	end
	if i == a then
		return
	end
	t(i, { id = "AssignSneakRouteGroup", soldiers = n, group = o })
end
function e.RegisterHoldTime(e, n)
	local e = r(e)
	if e == a then
		return
	end
	mvars.ene_holdTimes[e] = n
end
function e.ChangeHoldTime(n, t)
	local n = r(n)
	if n == a then
		return
	end
	mvars.ene_holdTimes[n] = t
	e.MakeShiftChangeTable()
end
function e.RegisterSleepTime(e, n)
	local e = r(e)
	if e == a then
		return
	end
	mvars.ene_sleepTimes[e] = n
end
function e.ChangeSleepTime(n, t)
	local n = r(n)
	if n == a then
		return
	end
	mvars.ene_sleepTimes[n] = t
	e.MakeShiftChangeTable()
end
function e.NoShifhtChangeGruopSetting(e, n)
	local e = r(e)
	if e == a then
		return
	end
	mvars.ene_noShiftChangeGroupSetting[e] = mvars.ene_noShiftChangeGroupSetting[e] or {}
	mvars.ene_noShiftChangeGroupSetting[e][p(n)] = true
end
function e.RegisterCombatSetting(a)
	local function i(t, e)
		local n = {}
		for e, a in pairs(e) do
			n[e] = a
			if t[e] then
				n[e] = t[e]
			end
		end
		return n
	end
	if not s(a) then
		return
	end
	for n, e in pairs(a) do
		if e.USE_COMMON_COMBAT and mvars.loc_locationCommonCombat then
			if mvars.loc_locationCommonCombat[n] then
				if e.combatAreaList then
					e.combatAreaList = i(e.combatAreaList, mvars.loc_locationCommonCombat[n].combatAreaList)
				else
					e = mvars.loc_locationCommonCombat[n]
				end
			end
		end
		if e.combatAreaList and s(e.combatAreaList) then
			for t, e in pairs(e.combatAreaList) do
				for t, e in pairs(e) do
					if e.guardTargetName and e.locatorSetName then
						TppCombatLocatorProvider.RegisterCombatLocatorSetToCpforLua({
							cpName = n,
							locatorSetName = e.guardTargetName,
						})
						TppCombatLocatorProvider.RegisterCombatLocatorSetToCpforLua({
							cpName = n,
							locatorSetName = e.locatorSetName,
						})
					end
				end
			end
			local t = { type = "TppCommandPost2" }
			local e = { id = "SetCombatArea", cpName = n, combatAreaList = e.combatAreaList }
			GameObject.SendCommand(t, e)
		else
			for t, e in ipairs(e) do
				TppCombatLocatorProvider.RegisterCombatLocatorSetToCpforLua({ cpName = n, locatorSetName = e })
			end
		end
	end
end
function e.SetEnable(e)
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	if e ~= a then
		t(e, { id = "SetEnabled", enabled = true })
	end
end
function e.SetDisable(e, n)
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	if e ~= a then
		t(e, { id = "SetEnabled", enabled = false, noAssignRoute = n })
	end
end
function e.SetEnableRestrictNotice(e)
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	if e ~= a then
		t(e, { id = "SetRestrictNotice", enabled = true })
	end
end
function e.SetDisableRestrictNotice(e)
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	if e ~= a then
		t(e, { id = "SetRestrictNotice", enabled = false })
	end
end
function e.RealizeParasiteSquad()
	if not s(mvars.ene_parasiteSquadList) then
		return
	end
	for n, e in pairs(mvars.ene_parasiteSquadList) do
		local e = r("TppParasite2", e)
		if e ~= a then
			t(e, { id = "Realize" })
		end
	end
end
function e.UnRealizeParasiteSquad()
	if not s(mvars.ene_parasiteSquadList) then
		return
	end
	for n, e in pairs(mvars.ene_parasiteSquadList) do
		local e = r("TppParasite2", e)
		if e ~= a then
			t(e, { id = "Unrealize" })
		end
	end
end
function e.OnAllocate(n)
	e.SetMaxSoldierStateCount(TppDefine.DEFAULT_SOLDIER_STATE_COUNT)
	if n.enemy then
		e.SetMaxSoldierStateCount(n.enemy.MAX_SOLDIER_STATE_COUNT)
	end
	if TppCommandPost2 then
		TppCommandPost2.SetSVarsKeyNames({ names = "cpNames", flags = "cpFlags" })
	end
	TppSoldier2.SetSVarsKeyNames({
		name = "solName",
		state = "solState",
		flagAndStance = "solFlagAndStance",
		weapon = "solWeapon",
		location = "solLocation",
		marker = "solMarker",
		fovaSeed = "solFovaSeed",
		faceFova = "solFaceFova",
		bodyFova = "solBodyFova",
		cp = "solCp",
		cpRoute = "solCpRoute",
		scriptSneakRoute = "solScriptSneakRoute",
		scriptCautionRoute = "solScriptCautionRoute",
		scriptAlertRoute = "solScriptAlertRoute",
		routeNodeIndex = "solRouteNodeIndex",
		routeEventIndex = "solRouteEventIndex",
		travelName = "solTravelName",
		travelStepIndex = "solTravelStepIndex",
		optionalNamesName = "solOptName",
		optionalParam1Name = "solOptParam1",
		optionalParam2Name = "solOptParam2",
		passengerInfoName = "passengerInfoName",
		passengerFlagName = "passengerFlagName",
		passengerNameName = "passengerNameName",
		noticeObjectType = "noticeObjectType",
		noticeObjectPosition = "noticeObjectPosition",
		noticeObjectOwnerName = "noticeObjectOwnerName",
		noticeObjectOwnerId = "noticeObjectOwnerId",
		noticeObjectAttachId = "noticeObjectAttachId",
		randomSeed = "solRandomSeed",
	})
	if TppSoldierFace ~= nil then
		if TppSoldierFace.ConvertFova2PathToFovaFile ~= nil then
			TppSoldierFace.ConvertFova2PathToFovaFile()
		end
	end
	if TppHostage2 then
		if TppHostage2.SetSVarsKeyNames2 then
			TppHostage2.SetSVarsKeyNames2({
				name = "hosName",
				state = "hosState",
				flagAndStance = "hosFlagAndStance",
				weapon = "hosWeapon",
				location = "hosLocation",
				marker = "hosMarker",
				fovaSeed = "hosFovaSeed",
				faceFova = "hosFaceFova",
				bodyFova = "hosBodyFova",
				scriptSneakRoute = "hosScriptSneakRoute",
				routeNodeIndex = "hosRouteNodeIndex",
				routeEventIndex = "hosRouteEventIndex",
				optionalParam1Name = "hosOptParam1",
				optionalParam2Name = "hosOptParam2",
				randomSeed = "hosRandomSeed",
			})
		end
	end
	mvars.ene_disablePowerSettings = {}
	mvars.ene_soldierTypes = {}
	if n.enemy then
		if n.enemy.syncRouteTable and SyncRouteManager then
			SyncRouteManager.Create(n.enemy.syncRouteTable)
		end
		if n.enemy.OnAllocate then
			n.enemy.OnAllocate()
		end
		mvars.ene_funcRouteSetPriority = n.enemy.GetRouteSetPriority
		if n.enemy.hostageDefine then
			mvars.ene_hostageDefine = n.enemy.hostageDefine
		end
		if n.enemy.vehicleDefine then
			mvars.ene_vehicleDefine = n.enemy.vehicleDefine
		end
		if n.enemy.vehicleSettings then
			e.RegistVehicleSettings(n.enemy.vehicleSettings)
		end
		if s(n.enemy.disablePowerSettings) then
			e.DisablePowerSettings(n.enemy.disablePowerSettings)
		end
		if n.enemy.soldierTypes then
			e.SetUpSoldierTypes(n.enemy.soldierTypes)
		end
	end
	mvars.ene_soldierPowerSettings = {}
	mvars.ene_missionSoldierPowerSettings = {}
	mvars.ene_missionRequiresPowerSettings = {}
	mvars.ene_soldierPersonalAbilitySettings = {}
	mvars.ene_missionSoldierPersonalAbilitySettings = {}
	mvars.ene_soldier2CommonBlockPackageLabel = "default"
	mvars.ene_questTargetList = {}
	mvars.ene_questVehicleList = {}
	mvars.ene_questGetLoadedFaceTable = {}
	mvars.ene_questArmorId = 0
	mvars.ene_questBalaclavaId = 0
	mvars.ene_isQuestSetup = false
	mvars.ene_isQuestHeli = false
end
function e.DeclareSVars(t)
	local n = 0
	local e = TppMission.GetMissionID()
	if TppMission.IsFOBMission(e) then
		n = TppDefine.MAX_UAV_COUNT
	end
	local e = 0
	if t.enemy then
		local n = t.enemy.soldierDefine
		if n ~= nil then
			for n, n in pairs(n) do
				e = e + 1
			end
		end
	end
	if e == 1 then
		e = 2
	end
	mvars.ene_cpCount = e
	local n = {
		{
			name = "cpNames",
			arraySize = e,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "cpFlags",
			arraySize = e,
			type = TppScriptVars.TYPE_UINT8,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solName",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solState",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT8,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solFlagAndStance",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solWeapon",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solLocation",
			arraySize = mvars.ene_maxSoldierStateCount * 4,
			type = TppScriptVars.TYPE_FLOAT,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solMarker",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_RETRY,
		},
		{
			name = "solFovaSeed",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solFaceFova",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solBodyFova",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solCp",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solCpRoute",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solScriptSneakRoute",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solScriptCautionRoute",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solScriptAlertRoute",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solRouteNodeIndex",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solRouteEventIndex",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solTravelName",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solTravelStepIndex",
			arraySize = mvars.ene_maxSoldierStateCount,
			type = TppScriptVars.TYPE_UINT8,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solOptName",
			arraySize = TppDefine.DEFAULT_SOLDIER_OPTION_VARS_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solOptParam1",
			arraySize = TppDefine.DEFAULT_SOLDIER_OPTION_VARS_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solOptParam2",
			arraySize = TppDefine.DEFAULT_SOLDIER_OPTION_VARS_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "passengerInfoName",
			arraySize = TppDefine.DEFAULT_PASSAGE_INFO_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "passengerFlagName",
			arraySize = TppDefine.DEFAULT_PASSAGE_FLAG_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "passengerNameName",
			arraySize = TppDefine.DEFAULT_PASSAGE_FLAG_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "passengerVehicleNameName",
			arraySize = TppDefine.DEFAULT_PASSAGE_INFO_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "noticeObjectType",
			arraySize = TppDefine.DEFAULT_NOTICE_INFO_COUNT,
			type = TppScriptVars.TYPE_UINT8,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "noticeObjectPosition",
			arraySize = TppDefine.DEFAULT_NOTICE_INFO_COUNT * 3,
			type = TppScriptVars.TYPE_FLOAT,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "noticeObjectOwnerName",
			arraySize = TppDefine.DEFAULT_NOTICE_INFO_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "noticeObjectOwnerId",
			arraySize = TppDefine.DEFAULT_NOTICE_INFO_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "noticeObjectAttachId",
			arraySize = TppDefine.DEFAULT_NOTICE_INFO_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "solRandomSeed",
			arraySize = 1,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosName",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosState",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT8,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosFlagAndStance",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosWeapon",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosLocation",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT * 4,
			type = TppScriptVars.TYPE_FLOAT,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosMarker",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_RETRY,
		},
		{
			name = "hosFovaSeed",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosFaceFova",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosBodyFova",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosScriptSneakRoute",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosRouteNodeIndex",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosRouteEventIndex",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosOptParam1",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosOptParam2",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "hosRandomSeed",
			arraySize = TppDefine.DEFAULT_HOSTAGE_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliName",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliLocation",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT * 4,
			type = TppScriptVars.TYPE_FLOAT,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliCp",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliFlag",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliSneakRoute",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliCautionRoute",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliAlertRoute",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliRouteNodeIndex",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliRouteEventIndex",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "enemyHeliMarker",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_RETRY,
		},
		{
			name = "enemyHeliLife",
			arraySize = TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "ene_wkrg_name",
			arraySize = 4,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "ene_wkrg_life",
			arraySize = 4,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "ene_wkrg_partslife",
			arraySize = 4 * 24,
			type = TppScriptVars.TYPE_UINT8,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "ene_wkrg_location",
			arraySize = 4 * 4,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "ene_wkrg_bulletleft",
			arraySize = 4 * 2,
			type = TppScriptVars.TYPE_UINT16,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "ene_wkrg_marker",
			arraySize = 4 * 2,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_RETRY,
		},
		{
			name = "ene_holdRecoveredStateName",
			arraySize = TppDefine.MAX_HOLD_RECOVERED_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "ene_isRecovered",
			arraySize = TppDefine.MAX_HOLD_RECOVERED_STATE_COUNT,
			type = TppScriptVars.TYPE_BOOL,
			value = false,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "ene_holdBrokenStateName",
			arraySize = TppDefine.MAX_HOLD_VEHICLE_BROKEN_STATE_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "ene_isVehicleBroken",
			arraySize = TppDefine.MAX_HOLD_VEHICLE_BROKEN_STATE_COUNT,
			type = TppScriptVars.TYPE_BOOL,
			value = false,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "liquidLifeStatus",
			arraySize = 1,
			type = TppScriptVars.TYPE_UINT8,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "liquidMarker",
			arraySize = 1,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_RETRY,
		},
		{
			name = "uavName",
			arraySize = n,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "uavIsDead",
			arraySize = n,
			type = TppScriptVars.TYPE_UINT8,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "uavMarker",
			arraySize = n,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_RETRY,
		},
		{
			name = "uavCp",
			arraySize = n,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "uavPatrolRoute",
			arraySize = n,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "uavCombatRoute",
			arraySize = n,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "securityCameraCp",
			arraySize = TppDefine.MAX_SECURITY_CAMERA_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		{
			name = "securityCameraMarker",
			arraySize = TppDefine.MAX_SECURITY_CAMERA_COUNT,
			type = TppScriptVars.TYPE_UINT32,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_RETRY,
		},
		{
			name = "securityCameraFlag",
			arraySize = TppDefine.MAX_SECURITY_CAMERA_COUNT,
			type = TppScriptVars.TYPE_UINT8,
			value = 0,
			save = true,
			sync = false,
			wait = false,
			category = TppScriptVars.CATEGORY_MISSION,
		},
		nil,
	}
	if Vehicle.svars then
		local e = Vehicle.instanceCountMax
		if mvars.ene_vehicleDefine and mvars.ene_vehicleDefine.instanceCount then
			e = mvars.ene_vehicleDefine.instanceCount
		end
		Tpp.ApendArray(n, Vehicle.svars({ instanceCount = e }))
	end
	return n
end
function e.ResetSoldier2CommonBlockPackageLabel()
	gvars.ene_soldier2CommonPackageLabelIndex = TppDefine.DEFAULT_SOLIDER2_COMMON_PACKAGE
end
function e.RegisterSoldier2CommonMotionPackagePath(n)
	local t = TppDefine.SOLIDER2_COMMON_PACK[n]
	local a = TppDefine.SOLIDER2_COMMON_PACK_PREREQUISITES[n]
	if t then
		if o(n) then
			gvars.ene_soldier2CommonPackageLabelIndex = p(n)
		else
			gvars.ene_soldier2CommonPackageLabelIndex = n
		end
	else
		t = TppDefine.SOLIDER2_COMMON_PACK.default
		a = TppDefine.SOLIDER2_COMMON_PACK_PREREQUISITES.default
		e.ResetSoldier2CommonBlockPackageLabel()
	end
	TppSoldier2CommonBlockController.SetPackagePathWithPrerequisites({ path = t, prerequisites = a })
end
function e.IsRequiredToLoadSpecialSolider2CommonBlock()
	if p(mvars.ene_soldier2CommonBlockPackageLabel) ~= TppDefine.DEFAULT_SOLIDER2_COMMON_PACKAGE then
		return true
	else
		return false
	end
end
function e.IsRequiredToLoadDefaultSoldier2CommonPackage()
	local e = p(mvars.ene_soldier2CommonBlockPackageLabel)
	if e == TppDefine.DEFAULT_SOLIDER2_COMMON_PACKAGE then
		return true
	else
		return false
	end
end
function e.IsLoadedDefaultSoldier2CommonPackage()
	if gvars.ene_soldier2CommonPackageLabelIndex == TppDefine.DEFAULT_SOLIDER2_COMMON_PACKAGE then
		return true
	else
		return false
	end
end
function e.LoadSoldier2CommonBlock()
	e.RegisterSoldier2CommonMotionPackagePath(mvars.ene_soldier2CommonBlockPackageLabel)
	while not TppSoldier2CommonBlockController.IsReady() do
		coroutine.yield()
	end
end
function e.UnloadSoldier2CommonBlock()
	TppSoldier2CommonBlockController.SetPackagePathWithPrerequisites({})
end
function e.SetMaxSoldierStateCount(e)
	if Tpp.IsTypeNumber(e) and (e > 0) then
		mvars.ene_maxSoldierStateCount = e
	end
end
function e.RestoreOnMissionStart2()
	local t = 0
	local a = 0
	if EnemyFova ~= nil then
		if EnemyFova.INVALID_FOVA_VALUE ~= nil then
			t = EnemyFova.INVALID_FOVA_VALUE
			a = EnemyFova.INVALID_FOVA_VALUE
		end
	end
	local n = 0
	if mvars.ene_cpList ~= nil then
		for t, e in pairs(mvars.ene_cpList) do
			if n < mvars.ene_cpCount then
				svars.cpNames[n] = p(e)
				svars.cpFlags[n] = 0
				n = n + 1
			end
		end
	end
	for e = 0, mvars.ene_maxSoldierStateCount - 1 do
		svars.solName[e] = 0
		svars.solState[e] = 0
		svars.solFlagAndStance[e] = 0
		svars.solWeapon[e] = 0
		svars.solLocation[e * 4 + 0] = 0
		svars.solLocation[e * 4 + 1] = 0
		svars.solLocation[e * 4 + 2] = 0
		svars.solLocation[e * 4 + 3] = 0
		svars.solMarker[e] = 0
		svars.solFovaSeed[e] = 0
		svars.solFaceFova[e] = t
		svars.solBodyFova[e] = a
		svars.solCp[e] = 0
		svars.solCpRoute[e] = GsRoute.ROUTE_ID_EMPTY
		svars.solScriptSneakRoute[e] = GsRoute.ROUTE_ID_EMPTY
		svars.solScriptCautionRoute[e] = GsRoute.ROUTE_ID_EMPTY
		svars.solScriptAlertRoute[e] = GsRoute.ROUTE_ID_EMPTY
		svars.solRouteNodeIndex[e] = 0
		svars.solRouteEventIndex[e] = 0
		svars.solTravelName[e] = 0
		svars.solTravelStepIndex[e] = 0
	end
	for e = 0, TppDefine.DEFAULT_SOLDIER_OPTION_VARS_COUNT - 1 do
		svars.solOptName[e] = 0
		svars.solOptParam1[e] = 0
		svars.solOptParam2[e] = 0
	end
	if svars.passengerInfoName ~= nil then
		for e = 0, TppDefine.DEFAULT_PASSAGE_INFO_COUNT - 1 do
			svars.passengerInfoName[e] = 0
		end
	end
	if svars.passengerFlagName ~= nil then
		for e = 0, TppDefine.DEFAULT_PASSAGE_FLAG_COUNT - 1 do
			svars.passengerFlagName[e] = 0
		end
	end
	if svars.passengerNameName ~= nil then
		for e = 0, TppDefine.DEFAULT_PASSAGE_FLAG_COUNT - 1 do
			svars.passengerNameName[e] = 0
		end
	end
	if svars.passengerNameName ~= nil then
		for e = 0, TppDefine.DEFAULT_PASSAGE_FLAG_COUNT - 1 do
			svars.passengerNameName[e] = 0
		end
	end
	e._RestoreOnMissionStart_Hostage2()
	for e = 0, TppDefine.DEFAULT_ENEMY_HELI_STATE_COUNT - 1 do
		svars.enemyHeliName = 0
		svars.enemyHeliLocation[0] = 0
		svars.enemyHeliLocation[1] = 0
		svars.enemyHeliLocation[2] = 0
		svars.enemyHeliLocation[3] = 0
		svars.enemyHeliCp = 0
		svars.enemyHeliFlag = 0
		svars.enemyHeliSneakRoute = 0
		svars.enemyHeliCautionRoute = 0
		svars.enemyHeliAlertRoute = 0
		svars.enemyHeliRouteNodeIndex = 0
		svars.enemyHeliRouteEventIndex = 0
		svars.enemyHeliMarker = 0
		svars.enemyHeliLife = 0
	end
	for e = 0, TppDefine.MAX_SECURITY_CAMERA_COUNT - 1 do
		svars.securityCameraCp[e] = 0
		svars.securityCameraMarker[e] = 0
		svars.securityCameraFlag[e] = 0
	end
end
function e.RestoreOnContinueFromCheckPoint2()
	do
		local e = { type = "TppCommandPost2" }
		t(e, { id = "RestoreFromSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppSoldier2", 0) ~= a then
		local e = { type = "TppSoldier2" }
		t(e, { id = "RestoreFromSVars" })
	end
	e._RestoreOnContinueFromCheckPoint_Hostage2()
	if GameObject.GetGameObjectIdByIndex("TppEnemyHeli", 0) ~= a then
		local e = { type = "TppEnemyHeli" }
		t(e, { id = "RestoreFromSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppVehicle2", 0) ~= a then
		t({ type = "TppVehicle2" }, { id = "RestoreFromSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppCommonWalkerGear2", 0) ~= a then
		t({ type = "TppCommonWalkerGear2" }, { id = "RestoreFromSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppLiquid2", 0) ~= a then
		t({ type = "TppLiquid2" }, { id = "RestoreFromSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppUav", 0) ~= a then
		t({ type = "TppUav" }, { id = "RestoreFromSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppSecurityCamera2", 0) ~= a then
		t({ type = "TppSecurityCamera2" }, { id = "RestoreFromSVars" })
	end
end
function e.RestoreOnContinueFromCheckPoint()
	e._RestoreOnContinueFromCheckPoint_Hostage()
end
function e.RestoreOnMissionStart()
	e._RestoreOnMissionStart_Hostage()
end
function e.StoreSVars(i)
	local n = false
	if i then
		n = true
	end
	do
		local e = { type = "TppCommandPost2" }
		t(e, { id = "StoreToSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppSoldier2", 0) ~= a then
		local e = { type = "TppSoldier2" }
		t(e, { id = "StoreToSVars", markerOnly = n })
	end
	e._StoreSVars_Hostage(n)
	if GameObject.GetGameObjectIdByIndex("TppEnemyHeli", 0) ~= a then
		t({ type = "TppEnemyHeli" }, { id = "StoreToSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppVehicle2", 0) ~= a then
		t({ type = "TppVehicle2" }, { id = "StoreToSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppCommonWalkerGear2", 0) ~= a then
		t({ type = "TppCommonWalkerGear2" }, { id = "StoreToSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppLiquid2", 0) ~= a then
		t({ type = "TppLiquid2" }, { id = "StoreToSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppUav", 0) ~= a then
		t({ type = "TppUav" }, { id = "StoreToSVars" })
	end
	if GameObject.GetGameObjectIdByIndex("TppSecurityCamera2", 0) ~= a then
		t({ type = "TppSecurityCamera2" }, { id = "StoreToSVars" })
	end
end
function e.PreMissionLoad(n, t)
	e.InitializeHostage2()
	TppEneFova.PreMissionLoad(n, t)
end
function e.InitializeHostage2()
	if TppHostage2.ClearHostageType then
		TppHostage2.ClearHostageType()
	end
	if TppHostage2.ClearUniquePartsPath then
		TppHostage2.ClearUniquePartsPath()
	end
end
function e.Init(n)
	mvars.ene_routeAnimationGaniPathTable = {
		{ "SoldierLookWatch", "/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_a.gani" },
		{ "SoldierWipeFace", "/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_d.gani" },
		{ "SoldierYawn", "/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_f.gani" },
		{ "SoldierSneeze", "/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_g.gani" },
		{ "SoldierFootStep", "/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_h.gani" },
		{ "SoldierCough", "/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_i.gani" },
		{ "SoldierScratchHead", "/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_o.gani" },
		{ "SoldierHungry", "/Assets/tpp/motion/SI_game/fani/bodies/enem/enemasr/enemasr_s_pat_idl_act_p.gani" },
		nil,
	}
	mvars.ene_eliminateTargetList = {}
	mvars.ene_routeSets = {}
	mvars.ene_noShiftChangeGroupSetting = {}
	e.messageExecTable = Tpp.MakeMessageExecTable(e.Messages())
	e.RegistCommonRoutePointMessage()
	if n.enemy then
		if n.enemy.parasiteSquadList then
			mvars.ene_parasiteSquadList = n.enemy.parasiteSquadList
		end
		if n.enemy.USE_COMMON_REINFORCE_PLAN then
			mvars.ene_useCommonReinforcePlan = true
		end
	end
	if mvars.loc_locationCommonTravelPlans then
		mvars.ene_lrrpNumberDefine = {}
		for e, n in pairs(mvars.loc_locationCommonTravelPlans.lrrpNumberDefine) do
			mvars.ene_lrrpNumberDefine[e] = n
		end
		mvars.ene_cpLinkDefine =
			e.MakeCpLinkDefineTable(mvars.ene_lrrpNumberDefine, mvars.loc_locationCommonTravelPlans.cpLinkMatrix)
		mvars.ene_defaultTravelRouteGroup = mvars.loc_locationCommonTravelPlans.defaultTravelRouteGroup
		local e
		if n.enemy and n.enemy.lrrpNumberDefine then
			e = n.enemy.lrrpNumberDefine
		end
		if e then
			for n, e in ipairs(n.enemy.lrrpNumberDefine) do
				local n = #mvars.ene_lrrpNumberDefine + 1
				mvars.ene_lrrpNumberDefine[n] = e
				mvars.ene_lrrpNumberDefine[e] = n
			end
		end
		if n.enemy and n.enemy.cpLink then
			local t = n.enemy.cpLink
			for e, n in pairs(t) do
				mvars.ene_cpLinkDefine[e] = mvars.ene_cpLinkDefine[e] or {}
				for a, n in ipairs(mvars.ene_lrrpNumberDefine) do
					mvars.ene_cpLinkDefine[n] = mvars.ene_cpLinkDefine[n] or {}
					if t[e][n] then
						mvars.ene_cpLinkDefine[e][n] = true
						mvars.ene_cpLinkDefine[n][e] = true
					else
						mvars.ene_cpLinkDefine[e][n] = false
						mvars.ene_cpLinkDefine[n][e] = false
					end
				end
			end
		end
	end
	local e
	local n = TppStory.GetCurrentStorySequence()
	if n >= TppDefine.STORY_SEQUENCE.CLEARD_METALLIC_ARCHAEA then
		e = true
	else
		e = false
	end
	local n = { "TppBossQuiet2", "TppParasite2" }
	for t, n in ipairs(n) do
		if GameObject.DoesGameObjectExistWithTypeName(n) then
			GameObject.SendCommand({ type = n }, { id = "SetFultonEnabled", enabled = e })
		end
	end
end
function e.RegistCommonRoutePointMessage() end
function e.OnReload(n)
	e.messageExecTable = Tpp.MakeMessageExecTable(e.Messages())
	e.RegistCommonRoutePointMessage()
	if n.enemy then
		e.SetUpCommandPost()
		e.SetUpSwitchRouteFunc()
	end
end
function e.OnMessage(t, n, a, s, o, i, r)
	Tpp.DoMessage(e.messageExecTable, TppMission.CheckMessageOption, t, n, a, s, o, i, r)
end
function e.DefineSoldiers(n)
	mvars.ene_soldierDefine = {}
	Tpp.MergeTable(mvars.ene_soldierDefine, n, true)
	mvars.ene_soldierIDList = {}
	mvars.ene_cpList = {}
	mvars.ene_baseCpList = {}
	mvars.ene_outerBaseCpList = {}
	mvars.ene_holdTimes = {}
	mvars.ene_sleepTimes = {}
	mvars.ene_lrrpTravelPlan = {}
	mvars.ene_lrrpVehicle = {}
	for i, t in pairs(n) do
		local n = r(i)
		if n == a then
		else
			mvars.ene_cpList[n] = i
			mvars.ene_holdTimes[n] = e.DEFAULT_HOLD_TIME
			mvars.ene_sleepTimes[n] = e.DEFAULT_SLEEP_TIME
			mvars.ene_soldierIDList[n] = {}
			if t.lrrpTravelPlan then
				mvars.ene_lrrpTravelPlan[n] = t.lrrpTravelPlan
			end
			if t.lrrpVehicle then
				mvars.ene_lrrpVehicle[n] = t.lrrpVehicle
			end
			for t, i in pairs(t) do
				if o(t) then
					if not e.SOLDIER_DEFINE_RESERVE_TABLE_NAME[t] then
					end
				else
					local e = r(i)
					if e == a then
					else
						mvars.ene_soldierIDList[n][e] = t
					end
				end
			end
		end
	end
end
function e.SetUpSoldiers()
	if not s(mvars.ene_soldierDefine) then
		return
	end
	local o = TppMission.GetMissionID()
	for i, n in pairs(mvars.ene_soldierDefine) do
		local n = r(i)
		if n == a then
		else
			if string.sub(i, -4) == "lrrp" then
				t(n, { id = "SetLrrpCp" })
			end
			local a = string.sub(i, -2)
			if a == "ob" then
				GameObject.SendCommand(n, { id = "SetOuterBaseCp" })
				mvars.ene_outerBaseCpList[n] = true
			end
			if a == "cp" then
				local t = true
				if i == "mafr_outland_child_cp" then
					t = false
				end
				if t then
					e.AddCpIntelTrapTable(i)
					mvars.ene_baseCpList[n] = true
				end
			end
			TppEmblem.SetUpCpEmblemTag(i, n)
			if mvars.loc_locationSiren then
				local e = mvars.loc_locationSiren[i]
				if e then
					t(n, { id = "SetCpSirenType", type = e.sirenType, pos = e.pos })
				end
			end
			local e
			if (o == 10150 or o == 10151) or o == 11151 then
				e = { id = "SetCpType", type = CpType.TYPE_AMERICA }
			elseif TppLocation.IsAfghan() then
				e = { id = "SetCpType", type = CpType.TYPE_SOVIET }
			elseif TppLocation.IsMiddleAfrica() then
				e = { id = "SetCpType", type = CpType.TYPE_AFRIKAANS }
			elseif TppLocation.IsMotherBase() or TppLocation.IsMBQF() then
				e = { id = "SetCpType", type = CpType.TYPE_AMERICA }
			end
			if e then
				GameObject.SendCommand(n, e)
			end
		end
	end
	for e, n in pairs(mvars.ene_cpList) do
		if mvars.ene_baseCpList[e] then
			local e = mvars.ene_soldierDefine[n]
			for n, e in ipairs(e) do
				local e = r(e)
				if e == a then
				else
					t(e, { id = "AddRouteAssignMember" })
				end
			end
		end
	end
	for i, n in pairs(mvars.ene_cpList) do
		if not mvars.ene_baseCpList[i] then
			local e = mvars.ene_soldierDefine[n]
			for n, e in ipairs(e) do
				local e = r(e)
				if e == a then
				else
					t(e, { id = "AddRouteAssignMember" })
				end
			end
		end
	end
	e.AssignSoldiersToCP()
end
function e.AssignSoldiersToCP()
	local r = TppMission.GetMissionID()
	e._ConvertSoldierNameKeysToId(mvars.ene_soldierTypes)
	mvars.ene_soldierSubType = mvars.ene_soldierSubType or {}
	mvars.ene_soldierLrrp = mvars.ene_soldierLrrp or {}
	local n = e.subTypeOfCp
	for a, p in pairs(mvars.ene_soldierIDList) do
		local i = mvars.ene_cpList[a]
		local o = n[i]
		local s = false
		for n, p in pairs(p) do
			t(n, { id = "SetCommandPost", cp = i })
			if mvars.ene_lrrpTravelPlan[a] then
				t(n, { id = "SetLrrp", travelPlan = mvars.ene_lrrpTravelPlan[a] })
				mvars.ene_soldierLrrp[n] = true
				if mvars.ene_lrrpVehicle[a] then
					local e = GameObject.GetGameObjectId("TppVehicle2", mvars.ene_lrrpVehicle[a])
					local e = { id = "SetRelativeVehicle", targetId = e, rideFromBeginning = true }
					t(n, e)
				end
			end
			local t
			local e = e.GetSoldierType(n)
			t = { id = "SetSoldier2Type", type = e }
			GameObject.SendCommand(n, t)
			if (e ~= EnemyType.TYPE_SKULL and e ~= EnemyType.TYPE_CHILD) and o then
				mvars.ene_soldierSubType[n] = o
			end
			if r ~= 10080 and r ~= 11080 then
				if e == EnemyType.TYPE_CHILD then
					s = true
				end
			end
		end
		if s then
			t(a, { id = "SetChildCp" })
		end
	end
end
function e.InitCpGroups()
	mvars.ene_cpGroups = {}
end
function e.RegistCpGroups(n)
	e.SetCommonCpGroups()
	if s(n) then
		for e, n in pairs(n) do
			mvars.ene_cpGroups[e] = mvars.ene_cpGroups[e] or {}
			for t, n in pairs(n) do
				table.insert(mvars.ene_cpGroups[e], n)
			end
		end
	end
end
function e.SetCommonCpGroups()
	if not s(mvars.loc_locationCommonCpGroups) then
		return
	end
	for n, t in pairs(mvars.loc_locationCommonCpGroups) do
		if s(t) then
			mvars.ene_cpGroups[n] = {}
			for e, a in pairs(mvars.ene_soldierDefine) do
				if t[e] then
					table.insert(mvars.ene_cpGroups[n], e)
				end
			end
		end
	end
end
function e.SetCpGroups()
	local e = { type = "TppCommandPost2" }
	local n = { id = "SetCpGroups", cpGroups = mvars.ene_cpGroups }
	t(e, n)
end
function e.RegistVehicleSettings(e)
	if not s(e) then
		return
	end
	mvars.ene_vehicleSettings = e
	local n = 0
	for e, e in pairs(e) do
		n = n + 1
	end
	mvars.ene_vehicleDefine = mvars.ene_vehicleDefine or {}
	mvars.ene_vehicleDefine.instanceCount = n
end
function e.SpawnVehicles(n)
	for t, n in ipairs(n) do
		e.SpawnVehicle(n)
	end
end
function e.SpawnVehicle(e)
	if not s(e) then
		return
	end
	if e.id ~= "Spawn" then
		e.id = "Spawn"
	end
	local n = e.locator
	if not n then
		return
	end
	local e = GameObject.SendCommand({ type = "TppVehicle2" }, e)
	if not e then
	end
end
function e.RespawnVehicle(e)
	if not s(e) then
		return
	end
	if e.id ~= "Respawn" then
		e.id = "Respawn"
	end
	local n = e.name
	if not n then
		return
	end
	local e = GameObject.SendCommand({ type = "TppVehicle2" }, e)
	if not e then
	end
end
function e.DespawnVehicles(n)
	for t, n in ipairs(n) do
		e.DespawnVehicle(n)
	end
end
function e.DespawnVehicle(e)
	if not s(e) then
		return
	end
	if e.id ~= "Despawn" then
		e.id = "Despawn"
	end
	local n = e.locator
	if not n then
		return
	end
	local e = GameObject.SendCommand({ type = "TppVehicle2" }, e)
	if not e then
	end
end
function e.SetUpVehicles()
	if mvars.ene_vehicleSettings == nil then
		return
	end
	for n, e in pairs(mvars.ene_vehicleSettings) do
		if (o(n) and s(e)) and e.type then
			local n = { id = "Spawn", locator = n, type = e.type }
			if e.subType then
				n.subType = e.subType
			end
			t({ type = "TppVehicle2" }, n)
		end
	end
end
function e.AddCpIntelTrapTable(e)
	mvars.ene_cpIntelTrapTable = mvars.ene_cpIntelTrapTable or {}
	mvars.ene_cpIntelTrapTable[e] = "trap_intel_" .. e
end
function e.GetCpIntelTrapTable()
	return mvars.ene_cpIntelTrapTable
end
function e.GetCurrentRouteSetType(t, i, r)
	local a = function(n, e)
		if not e then
			e = TppClock.GetTimeOfDayIncludeMidNight()
		end
		local e = "sneak" .. ("_" .. e)
		if n then
			local n = not next(mvars.ene_routeSets[n].sneak_midnight)
			if e == "sneak_midnight" and n then
				e = "sneak_night"
			end
		end
		return e
	end
	if t == 0 then
		t = false
	end
	local n
	if t then
		local t = e.ROUTE_SET_TYPETAG[t]
		if t == "travel" then
			return "travel"
		end
		if t == "hold" then
			return "hold"
		end
		if t == "sleep" then
			return "sleep"
		end
		if i == e.PHASE.SNEAK then
			n = a(r, t)
		else
			n = "caution"
		end
	else
		if i == e.PHASE.SNEAK then
			n = a(r)
		else
			n = "caution"
		end
	end
	return n
end
function e.GetPrioritizedRouteTable(e, n, t, r)
	local i = {}
	local a = t[e]
	if not s(a) then
		return
	end
	if mvars.ene_funcRouteSetPriority then
		i = mvars.ene_funcRouteSetPriority(e, n, t, r)
	else
		local t = 0
		for a, e in ipairs(a) do
			if n[e] then
				local e = #n[e]
				if e > t then
					t = e
				end
			end
		end
		local e = 1
		for t = 1, t do
			for r, a in ipairs(a) do
				local n = n[a]
				if n then
					local n = n[t]
					if n and Tpp.IsTypeTable(n) then
						i[e] = n
						e = e + 1
					end
				end
			end
		end
		for r = 1, t do
			for a, t in ipairs(a) do
				local n = n[t]
				if n then
					local n = n[r]
					if n and not Tpp.IsTypeTable(n) then
						i[e] = n
						e = e + 1
					end
				end
			end
		end
	end
	return i
end
function e.RouteSelector(n, i, a)
	local t = mvars.ene_routeSets[n]
	if t == nil then
		return { "dummyRoute" }
	end
	if a == p("immediately") then
		if i == p("old") then
			local t = e.GetCurrentRouteSetType(nil, e.GetPhaseByCPID(n), n)
			return e.GetPrioritizedRouteTable(
				n,
				mvars.ene_routeSetsTemporary[n][t],
				mvars.ene_routeSetsPriorityTemporary
			)
		else
			local a = e.GetCurrentRouteSetType(nil, e.GetPhaseByCPID(n), n)
			return e.GetPrioritizedRouteTable(n, t[a], mvars.ene_routeSetsPriority)
		end
	end
	if a == p("SYS_Sneak") then
		local i = e.GetCurrentRouteSetType(nil, e.PHASE.SNEAK, n)
		return e.GetPrioritizedRouteTable(n, t[i], mvars.ene_routeSetsPriority, a)
	end
	if a == p("SYS_Caution") then
		local i = e.GetCurrentRouteSetType(nil, e.PHASE.CAUTION, n)
		return e.GetPrioritizedRouteTable(n, t[i], mvars.ene_routeSetsPriority, a)
	end
	local i = e.GetCurrentRouteSetType(i, e.GetPhaseByCPID(n), n)
	local a = t[i][a]
	if a then
		return a
	else
		if i == "hold" then
			local a = e.GetCurrentRouteSetType(nil, e.GetPhaseByCPID(n), n)
			return e.GetPrioritizedRouteTable(n, t[a], mvars.ene_routeSetsPriority)
		else
			local a = e.GetCurrentRouteSetType(nil, e.GetPhaseByCPID(n), n)
			return e.GetPrioritizedRouteTable(n, t[a], mvars.ene_routeSetsPriority)
		end
	end
end
e.STR32_CAN_USE_SEARCH_LIGHT = p("CanUseSearchLight")
e.STR32_CAN_NOT_USE_SEARCH_LIGHT = p("CanNotUseSearchLight")
e.STR32_IS_GIMMICK_BROKEN = p("IsGimmickBroken")
e.STR32_IS_NOT_GIMMICK_BROKEN = p("IsNotGimmickBroken")
function e.SetUpSwitchRouteFunc()
	if not GameObject.DoesGameObjectExistWithTypeName("TppSoldier2") then
		return
	end
	t({ type = "TppSoldier2" }, { id = "SetSwitchRouteFunc", func = e.SwitchRouteFunc })
end
function e.SwitchRouteFunc(a, n, t, a, a)
	if n == e.STR32_CAN_USE_SEARCH_LIGHT then
		local e = mvars.gim_gimmackNameStrCode32Table[t]
		if TppGimmick.IsBroken({ gimmickId = e }) then
			return false
		else
			if TppClock.GetTimeOfDay() ~= "night" then
				return false
			end
			return true
		end
	end
	if n == e.STR32_CAN_NOT_USE_SEARCH_LIGHT then
		local e = mvars.gim_gimmackNameStrCode32Table[t]
		if TppGimmick.IsBroken({ gimmickId = e }) then
			return true
		else
			if TppClock.GetTimeOfDay() ~= "night" then
				return true
			end
			return false
		end
	end
	if n == e.STR32_IS_GIMMICK_BROKEN then
		local e = mvars.gim_gimmackNameStrCode32Table[t]
		if TppGimmick.IsBroken({ gimmickId = e }) then
			return true
		else
			return false
		end
	end
	if n == e.STR32_IS_NOT_GIMMICK_BROKEN then
		local e = mvars.gim_gimmackNameStrCode32Table[t]
		if TppGimmick.IsBroken({ gimmickId = e }) then
			return false
		else
			return true
		end
	end
	return true
end
function e.SetUpCommandPost()
	if not s(mvars.ene_soldierIDList) then
		return
	end
	for n, a in pairs(mvars.ene_cpList) do
		t(n, { id = "SetRouteSelector", func = e.RouteSelector })
	end
end
function e.RegisterRouteAnimation()
	if TppRouteAnimationCollector then
		TppRouteAnimationCollector.ClearGaniPath()
		TppRouteAnimationCollector.RegisterGaniPath(mvars.ene_routeAnimationGaniPathTable)
	end
end
function e.MergeRouteSetDefine(o)
	local function i(n, t)
		if t.priority then
			mvars.ene_routeSetsDefine[n].priority = {}
			mvars.ene_routeSetsDefine[n].fixedShiftChangeGroup = {}
			for e = 1, #t.priority do
				mvars.ene_routeSetsDefine[n].priority[e] = t.priority[e]
			end
		end
		if t.fixedShiftChangeGroup then
			for e = 1, #t.fixedShiftChangeGroup do
				mvars.ene_routeSetsDefine[n].fixedShiftChangeGroup[e] = t.fixedShiftChangeGroup[e]
			end
		end
		for a, e in pairs(e.ROUTE_SET_TYPES) do
			mvars.ene_routeSetsDefine[n][e] = mvars.ene_routeSetsDefine[n][e] or {}
			if t[e] then
				for t, a in pairs(t[e]) do
					mvars.ene_routeSetsDefine[n][e][t] = {}
					if s(a) then
						for i, a in ipairs(a) do
							mvars.ene_routeSetsDefine[n][e][t][i] = a
						end
					end
				end
			end
		end
	end
	for e, n in pairs(o) do
		mvars.ene_routeSetsDefine[e] = mvars.ene_routeSetsDefine[e] or {}
		local n = n
		if n.walkergearpark then
			local e = r(e)
			t(e, { id = "SetWalkerGearParkRoute", routes = n.walkergearpark })
		end
		if mvars.loc_locationCommonRouteSets then
			if mvars.loc_locationCommonRouteSets[e] then
				if mvars.loc_locationCommonRouteSets[e].outofrain then
					local a = r(e)
					if n.outofrain then
						t(a, { id = "SetOutOfRainRoute", routes = n.outofrain })
					else
						t(a, { id = "SetOutOfRainRoute", routes = mvars.loc_locationCommonRouteSets[e].outofrain })
					end
				end
			end
			if n.USE_COMMON_ROUTE_SETS then
				if mvars.loc_locationCommonRouteSets[e] then
					i(e, mvars.loc_locationCommonRouteSets[e])
				end
			end
		end
		i(e, n)
	end
end
function e.UpdateRouteSet(n)
	for n, t in pairs(n) do
		local n = r(n)
		if n == a then
		else
			mvars.ene_routeSets[n] = mvars.ene_routeSets[n] or {}
			if t.priority then
				mvars.ene_routeSetsPriority[n] = {}
				mvars.ene_routeSetsFixedShiftChange[n] = {}
				for e = 1, #t.priority do
					mvars.ene_routeSetsPriority[n][e] = p(t.priority[e])
				end
			end
			if t.fixedShiftChangeGroup then
				for e = 1, #t.fixedShiftChangeGroup do
					mvars.ene_routeSetsFixedShiftChange[n][p(t.fixedShiftChangeGroup[e])] = e
				end
			end
			if mvars.ene_noShiftChangeGroupSetting[n] then
				for t, e in pairs(mvars.ene_noShiftChangeGroupSetting[n]) do
					mvars.ene_routeSetsFixedShiftChange[n][t] = e
				end
			end
			for a, e in pairs(e.ROUTE_SET_TYPES) do
				mvars.ene_routeSets[n][e] = mvars.ene_routeSets[n][e] or {}
				if t[e] then
					for t, a in pairs(t[e]) do
						mvars.ene_routeSets[n][e][p(t)] = mvars.ene_routeSets[n][e][p(t)] or {}
						if type(a) == "number" then
						else
							for a, i in ipairs(a) do
								mvars.ene_routeSets[n][e][p(t)][a] = i
							end
						end
					end
				end
			end
		end
	end
end
function e.RegisterRouteSet(n)
	mvars.ene_routeSetsDefine = {}
	e.MergeRouteSetDefine(n)
	mvars.ene_routeSets = {}
	mvars.ene_routeSetsPriority = {}
	mvars.ene_routeSetsFixedShiftChange = {}
	e.UpdateRouteSet(mvars.ene_routeSetsDefine)
	TppClock.RegisterClockMessage("ShiftChangeAtNight", TppClock.DAY_TO_NIGHT)
	TppClock.RegisterClockMessage("ShiftChangeAtMorning", TppClock.NIGHT_TO_DAY)
	TppClock.RegisterClockMessage("ShiftChangeAtMidNight", TppClock.NIGHT_TO_MIDNIGHT)
end
function e._InsertShiftChangeUnit(t, a, n)
	for e, i in pairs(mvars.ene_shiftChangeTable[t]) do
		if n[e] and next(n[e]) then
			if n[e].hold then
				mvars.ene_shiftChangeTable[t][e][a * 2 - 1] = { n[e].start, n[e].hold, holdTime = n[e].holdTime }
				mvars.ene_shiftChangeTable[t][e][a * 2] = { n[e].hold, n[e].goal }
			else
				mvars.ene_shiftChangeTable[t][e][a * 2 - 1] = { n[e].start, n[e].goal }
				mvars.ene_shiftChangeTable[t][e][a * 2] = "dummy"
			end
		end
	end
end
function e._GetShiftChangeRouteGroup(n, o, a, l, s, i, p, t)
	local e = (o - a) + 1
	local r = a
	if t[n[a]] then
		e = r
	else
		local i = 0
		for a = 1, a do
			if t[n[a]] then
				i = i + 1
			end
		end
		e = e + i
		local a = 0
		for i = e, o do
			if t[n[i]] then
				a = a + 1
			end
		end
		e = e - a
		local a = e
		local i = 0
		local r = t[n[a]]
		while r do
			i = i + 1
			a = a - 1
			r = t[n[a]]
		end
		e = e - i
	end
	local a = n[e]
	local t = "default"
	if l[i] then
		t = i
	end
	local e = nil
	if p then
		e = "default"
		if s[i] then
			e = i
		end
	end
	local n = n[r]
	return a, t, e, n
end
function e._MakeShiftChangeUnit(t, i, n, r, o, d, l, a, T, u, _)
	if mvars.ene_noShiftChangeGroupSetting[t] and mvars.ene_noShiftChangeGroupSetting[t][n] then
		return nil
	end
	local n, i, e, a = e._GetShiftChangeRouteGroup(i, a, T, r, d, n, o, _)
	local e = {}
	for n, t in pairs(mvars.ene_shiftChangeTable[t]) do
		e[n] = {}
	end
	if (i ~= "default") or (s(r[p("default")]) and next(r[p("default")])) then
		e.shiftAtNight.start = { "day", n }
		e.shiftAtNight.hold = { "hold", i }
		e.shiftAtNight.holdTime = mvars.ene_holdTimes[t]
		e.shiftAtNight.goal = { "night", a }
		e.shiftAtMorning.hold = { "hold", i }
		e.shiftAtMorning.holdTime = mvars.ene_holdTimes[t]
		e.shiftAtMorning.goal = { "day", a }
	else
		e.shiftAtNight.start = { "day", n }
		e.shiftAtNight.goal = { "night", a }
		e.shiftAtMorning.goal = { "day", a }
	end
	if o then
		e.shiftAtMidNight.start = { "night", n }
		e.shiftAtMidNight.hold = { "sleep", i }
		e.shiftAtMidNight.holdTime = mvars.ene_sleepTimes[t]
		if l then
			e.shiftAtMidNight.goal = { "midnight", a }
		else
			e.shiftAtMidNight.goal = { "night", n }
		end
		e.shiftAtMorning.start = { "midnight", n }
	else
		e.shiftAtMorning.start = { "night", n }
	end
	return e
end
function e.MakeShiftChangeTable()
	mvars.ene_shiftChangeTable = {}
	for n, t in pairs(mvars.ene_routeSetsPriority) do
		if not s(t) then
			return
		end
		local r = false
		local o = false
		if next(mvars.ene_routeSets[n].sleep) then
			mvars.ene_shiftChangeTable[n] = { shiftAtNight = {}, shiftAtMorning = {}, shiftAtMidNight = {} }
			r = true
			if next(mvars.ene_routeSets[n].sneak_midnight) then
				o = true
			end
		else
			mvars.ene_shiftChangeTable[n] = { shiftAtNight = {}, shiftAtMorning = {} }
		end
		local p = mvars.ene_routeSets[n].hold
		local s = nil
		if r then
			s = mvars.ene_routeSets[n].sleep
		end
		local a = 1
		local l = #t
		for _, d in ipairs(t) do
			local i
			i = e._MakeShiftChangeUnit(n, t, d, p, r, s, o, l, _, a, mvars.ene_routeSetsFixedShiftChange[n])
			if i then
				e._InsertShiftChangeUnit(n, a, i)
				a = a + 1
			end
		end
	end
end
function e.ShiftChangeByTime(n)
	if TppLocation.IsMotherBase() or TppLocation.IsMBQF() then
		return
	end
	if not s(mvars.ene_shiftChangeTable) then
		return
	end
	for a, e in pairs(mvars.ene_shiftChangeTable) do
		if e[n] then
			t(a, { id = "ShiftChange", schedule = e[n] })
		end
	end
end
local function d(n, e, a)
	local t = t(a, { id = "GetPosition" })
	local e = e - t
	local e = e:GetLengthSqr()
	if e > n then
		return false
	else
		return true
	end
end
function e.MakeCpLinkDefineTable(t, n)
	local e = {}
	for a = 1, #n do
		local i = Tpp.SplitString(n[a], "	")
		local n = t[a]
		if n then
			e[n] = e[n] or {}
			for a, i in pairs(i) do
				local t = t[a]
				if t then
					e[n][t] = e[n][t] or {}
					local a = false
					if tonumber(i) > 0 then
						a = true
					end
					e[n][t] = a
				end
			end
		end
	end
	return e
end
function e.MakeReinforceTravelPlan(i, a, p, n, t)
	if not Tpp.IsTypeTable(t) then
		return
	end
	local a = a[n]
	if a == nil then
		return
	end
	mvars.ene_travelPlans = mvars.ene_travelPlans or {}
	local r = 0
	for r, t in pairs(t) do
		if mvars.ene_soldierDefine[t] then
			if a[t] then
				local o = i[n]
				local r = i[t]
				local a = "rp_" .. (n .. ("_From_" .. t))
				mvars.ene_travelPlans[a] = mvars.ene_travelPlans[a] or {}
				local s = string.format("rp_%02dto%02d", r, o)
				local e = e.GetFormattedLrrpCpNameByLrrpNum(o, r, p, i)
				mvars.ene_travelPlans[a] = { { cp = e, routeGroup = { "travel", s } }, { cp = n, finishTravel = true } }
				mvars.ene_reinforcePlans[a] = { { toCp = n, fromCp = t, type = "respawn" } }
			end
		end
	end
end
function e.MakeTravelPlanTable(T, _, d, t, n, l)
	if
		((not Tpp.IsTypeTable(n) or not Tpp.IsTypeTable(n[1])) or not Tpp.IsTypeString(t))
		or (n[1].cp == nil and n[1].base == nil)
	then
		return
	end
	mvars.ene_travelPlans = mvars.ene_travelPlans or {}
	mvars.ene_travelPlans[t] = mvars.ene_travelPlans[t] or {}
	local o = mvars.ene_travelPlans[t]
	local p = #n
	local i, r
	if (not n.ONE_WAY) and n[#n].base then
		i = n[#n]
	end
	for t = 1, p do
		local a
		if n.ONE_WAY and (t == p) then
			a = true
		end
		if n[t].base then
			if t == 1 then
				r = n[t]
			else
				i = n[t - 1]
				r = n[t]
			end
			e.AddLinkedBaseTravelCourse(T, _, d, l, o, i, r, a)
		elseif n[t].cp then
			local n = n[t]
			if s(n) then
				e.AddTravelCourse(o, n, a)
			end
		end
	end
end
function e.AddLinkedBaseTravelCourse(d, l, o, i, s, a, t, p)
	local n
	if a and a.base then
		n = a.base
	end
	local a = t.base
	local r = false
	if n then
		r = l[n][a]
	end
	if r then
		local n, t = e.GetFormattedLrrpCpName(n, a, o, d)
		local n = { cp = n, routeGroup = { "travel", t } }
		e.AddTravelCourse(s, n)
	elseif n == nil then
	end
	local o
	if t.wait then
		o = t.wait
	else
		o = i
	end
	local i
	if t.routeGroup and Tpp.IsTypeTable(t.routeGroup) then
		i = { t.routeGroup[1], t.routeGroup[2] }
	else
		local t
		local e = mvars.ene_defaultTravelRouteGroup
		if ((e and r) and e[n]) and Tpp.IsTypeTable(e[n][a]) then
			t = e[n][a]
		end
		if t then
			i = { t[1], t[2] }
		else
			i = { "travel", "lrrpHold" }
		end
	end
	local n = { cp = a, routeGroup = i, wait = o }
	e.AddTravelCourse(s, n, p)
end
function e.GetFormattedLrrpCpNameByLrrpNum(e, n, i, t)
	local t, a
	if e < n then
		t = e
		a = n
	else
		t = n
		a = e
	end
	local t = string.format("%s_%02d_%02d_lrrp", i, t, a)
	local e = string.format("lrrp_%02dto%02d", e, n)
	return t, e
end
function e.GetFormattedLrrpCpName(t, a, i, n)
	local t = n[t]
	local a = n[a]
	return e.GetFormattedLrrpCpNameByLrrpNum(t, a, i, n)
end
function e.AddTravelCourse(t, e, n)
	if n then
		e.finishTravel = true
	else
		e.finishTravel = nil
	end
	table.insert(t, e)
end
function e.SetTravelPlans(i)
	mvars.ene_reinforcePlans = {}
	mvars.ene_travelPlans = {}
	if mvars.loc_locationCommonTravelPlans then
		local n = TppLocation.GetLocationName()
		if n then
			local t = mvars.ene_lrrpNumberDefine
			local a = mvars.ene_cpLinkDefine
			for r, i in pairs(i) do
				e.MakeTravelPlanTable(t, a, n, r, i, e.DEFAULT_TRAVEL_HOLD_TIME)
			end
			local i = mvars.loc_locationCommonTravelPlans.reinforceTravelPlan
			if mvars.ene_useCommonReinforcePlan and i then
				for i, r in pairs(i) do
					if mvars.ene_soldierDefine[i] then
						e.MakeReinforceTravelPlan(t, a, n, i, r)
					end
				end
			end
		end
	else
		mvars.ene_travelPlans = i
	end
	t({ type = "TppSoldier2" }, { id = "SetTravelPlan", travelPlan = mvars.ene_travelPlans })
	if next(mvars.ene_reinforcePlans) then
		t({ type = "TppCommandPost2" }, { id = "SetReinforcePlan", reinforcePlan = mvars.ene_reinforcePlans })
	end
end
function e.RegistHoldBrokenState(n)
	if not o(n) then
		return
	end
	local t = r(n)
	if t == a then
		return
	end
	local e = e.AddBrokenStateList(n)
	if not e then
		return
	end
	mvars.ene_vehicleBrokenStateIndexByName = mvars.ene_vehicleBrokenStateIndexByName or {}
	mvars.ene_vehicleBrokenStateIndexByName[n] = e
	mvars.ene_vehicleBrokenStateIndexByGameObjectId = mvars.ene_vehicleBrokenStateIndexByGameObjectId or {}
	mvars.ene_vehicleBrokenStateIndexByGameObjectId[t] = e
end
function e.AddBrokenStateList(n)
	local e
	local a = p(n)
	for t = 0, (TppDefine.MAX_HOLD_VEHICLE_BROKEN_STATE_COUNT - 1) do
		local n = svars.ene_holdBrokenStateName[t]
		if (n == 0) or (n == a) then
			e = t
			break
		end
	end
	if e then
		svars.ene_holdBrokenStateName[e] = a
		return e
	else
		return
	end
end
function e._OnHeliBroken(n, t)
	if t == p("Start") then
		e.PlayTargetEliminatedRadio(n)
	end
end
function e._OnVehicleBroken(n, t)
	e.SetVehicleBroken(n)
	if t == p("End") then
		e.PlayTargetEliminatedRadio(n)
	end
end
function e._OnWalkerGearBroken(t, n)
	if n == p("End") then
		e.PlayTargetEliminatedRadio(t)
	end
end
function e.SetVehicleBroken(e)
	if not mvars.ene_vehicleBrokenStateIndexByGameObjectId then
		return
	end
	local e = mvars.ene_vehicleBrokenStateIndexByGameObjectId[e]
	if e then
		svars.ene_isVehicleBroken[e] = true
	end
end
function e.IsVehicleBroken(e)
	local n
	if o(e) then
		n = mvars.ene_vehicleBrokenStateIndexByName[e]
	elseif l(e) then
		n = mvars.ene_vehicleBrokenStateIndexByGameObjectId[e]
	end
	if n then
		return svars.ene_isVehicleBroken[n]
	end
end
function e.IsVehicleAlive(n)
	local e
	if o(n) then
		e = r(n)
	elseif l(n) then
		e = n
	end
	if e == a then
		return
	end
	return t(e, { id = "IsAlive" })
end
function e.PlayTargetRescuedRadio(n)
	local t = e.IsEliminateTarget(n)
	local e = e.IsRescueTarget(n)
	if t then
		TppRadio.PlayCommonRadio(TppDefine.COMMON_RADIO.TARGET_ELIMINATED)
	elseif e then
		TppRadio.PlayCommonRadio(TppDefine.COMMON_RADIO.TARGET_RECOVERED)
	end
end
function e.PlayTargetEliminatedRadio(n)
	local e = e.IsEliminateTarget(n)
	if e then
		TppRadio.PlayCommonRadio(TppDefine.COMMON_RADIO.TARGET_ELIMINATED)
	end
end
function e.RegistHoldRecoveredState(n)
	if not o(n) then
		return
	end
	local t = r(n)
	if t == a then
		return
	end
	local e = e.AddRecoveredStateList(n)
	if not e then
		return
	end
	mvars.ene_recoverdStateIndexByName = mvars.ene_recoverdStateIndexByName or {}
	mvars.ene_recoverdStateIndexByName[n] = e
	mvars.ene_recoverdStateIndexByGameObjectId = mvars.ene_recoverdStateIndexByGameObjectId or {}
	mvars.ene_recoverdStateIndexByGameObjectId[t] = e
end
function e.AddRecoveredStateList(n)
	local e
	local a = p(n)
	for n = 0, (TppDefine.MAX_HOLD_RECOVERED_STATE_COUNT - 1) do
		local t = svars.ene_holdRecoveredStateName[n]
		if (t == 0) or (t == a) then
			e = n
			break
		end
	end
	if e then
		svars.ene_holdRecoveredStateName[e] = a
		return e
	else
		return
	end
end
function e.SetRecovered(e)
	if not mvars.ene_recoverdStateIndexByGameObjectId then
		return
	end
	local e = mvars.ene_recoverdStateIndexByGameObjectId[e]
	if e then
		svars.ene_isRecovered[e] = true
	end
end
function e.ExecuteOnRecoveredCallback(n, s, r, o, a, i, t)
	if not mvars.ene_recoverdStateIndexByGameObjectId then
		return
	end
	local e = mvars.ene_recoverdStateIndexByGameObjectId[n]
	if not e then
		return
	end
	local e
	if TppMission.systemCallbacks and TppMission.systemCallbacks.OnRecovered then
		e = TppMission.systemCallbacks.OnRecovered
	end
	if not e then
		return
	end
	if not TppMission.CheckMissionState(true, false, true, false) then
		return
	end
	e(n, s, r, o, a, i, t)
end
local T = 10 * 10
function e.CheckAllVipClear(n)
	return e.CheckAllTargetClear(n)
end
function e.CheckAllTargetClear(n)
	local n = mvars
	local e = e
	local a = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
	TppHelicopter.SetNewestPassengerTable()
	local t = {
		{ n.ene_eliminateTargetList, e.CheckSoldierEliminateTarget, "EliminateTargetSoldier" },
		{ n.ene_eliminateHelicopterList, e.CheckHelicopterEliminateTarget, "EliminateTargetHelicopter" },
		{ n.ene_eliminateVehicleList, e.CheckVehicleEliminateTarget, "EliminateTargetVehicle" },
		{ n.ene_eliminateWalkerGearList, e.CheckWalkerGearEliminateTarget, "EliminateTargetWalkerGear" },
		{ n.ene_childTargetList, e.CheckRescueTarget, "childTarget" },
	}
	if n.ene_rescueTargetOptions then
		if not n.ene_rescueTargetOptions.orCheck then
			table.insert(t, { n.ene_rescueTargetList, e.CheckRescueTarget, "RescueTarget" })
		end
	end
	for e = 1, #t do
		local e, t, n = t[e][1], t[e][2], t[e][3]
		if s(e) and next(e) then
			for n, e in pairs(e) do
				if not t(n, a, e) then
					return false
				end
			end
		end
	end
	if n.ene_rescueTargetOptions and n.ene_rescueTargetOptions.orCheck then
		local t = false
		for n, i in pairs(n.ene_rescueTargetList) do
			if e.CheckRescueTarget(n, a, i) then
				t = true
			end
		end
		return t
	end
	return true
end
function e.CheckSoldierEliminateTarget(n, i, a)
	local a = t(n, { id = "GetLifeStatus" })
	local t = t(n, { id = "GetStatus" })
	if e._IsEliminated(a, t) then
		return true
	elseif e._IsNeutralized(a, t) then
		if d(T, i, n) then
			return true
		else
			return false
		end
	end
	return false
end
function e.CheckHelicopterEliminateTarget(e, n, n)
	local e = GameObject.SendCommand(e, { id = "IsBroken" })
	if e then
		return true
	else
		return false
	end
end
function e.CheckVehicleEliminateTarget(n, t, t)
	if e.IsRecovered(n) then
		return true
	elseif e.IsVehicleBroken(n) then
		return true
	else
		return false
	end
end
function e.CheckWalkerGearEliminateTarget(e, n, n)
	local n = GameObject.SendCommand(e, { id = "IsBroken" })
	if n then
		return true
	elseif GameObject.SendCommand(e, { id = "IsFultonCaptured" }) then
		return true
	else
		return false
	end
end
function e.CheckRescueTarget(n, t, a)
	if e.IsRecovered(n) then
		return true
	elseif d(T, t, n) then
		return true
	elseif TppHelicopter.IsInHelicopter(n) then
		return true
	else
		return false
	end
end
function e.FultonRecoverOnMissionGameEnd()
	if mvars.ene_soldierIDList == nil then
		return
	end
	local i = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
	local n = 10
	local t = TppMission.GetMissionID()
	if TppMission.IsFOBMission(t) then
		n = 0
	end
	local a = n * n
	local n
	if Tpp.IsHelicopter(vars.playerVehicleGameObjectId) then
		n = false
	else
		n = true
	end
	local t = e.GetAllActiveEnemyWalkerGear()
	for t, e in pairs(t) do
		if d(a, i, e) then
			local t = { id = "GetResourceId" }
			local t = GameObject.SendCommand(e, t)
			TppTerminal.OnFulton(e, nil, nil, t, true, n, PlayerInfo.GetLocalPlayerIndex())
		end
	end
	TppHelicopter.SetNewestPassengerTable()
	TppTerminal.OnRecoverByHelicopterAlreadyGetPassengerList()
	for r, t in pairs(mvars.ene_soldierIDList) do
		for t, r in pairs(t) do
			if d(a, i, t) and (not e.IsQuestNpc(t)) then
				e.AutoFultonRecoverNeutralizedTarget(t, n)
			end
		end
	end
	local t = e.GetAllHostages()
	for r, t in pairs(t) do
		if ((not TppHelicopter.IsInHelicopter(t)) and d(a, i, t)) and (not e.IsQuestNpc(t)) then
			local e = TppMotherBaseManagement.GetStaffIdFromGameObject({ gameObjectId = t })
			TppTerminal.OnFulton(t, nil, nil, e, true, n, PlayerInfo.GetLocalPlayerIndex())
		end
	end
	TppHelicopter.ClearPassengerTable()
end
function e.AutoFultonRecoverNeutralizedTarget(n, a)
	local t = t(n, { id = "GetLifeStatus" })
	if t == e.LIFE_STATUS.SLEEP or t == e.LIFE_STATUS.FAINT then
		local e
		e = TppMotherBaseManagement.GetStaffIdFromGameObject({ gameObjectId = n })
		TppTerminal.OnFulton(n, nil, nil, e, nil, a, PlayerInfo.GetLocalPlayerIndex())
	end
end
function e.CheckQuestTargetOnOutOfActiveArea(n)
	if not s(n) then
		return
	end
	local o = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
	local t = 10
	local i = t * t
	local t = false
	for n, n in pairs(n) do
		local n = r(soliderName)
		if n ~= a then
			if d(i, o, n) then
				t = true
				e.AutoFultonRecoverNeutralizedTarget(n)
			end
		end
	end
	return t
end
function e.ChangeRouteUsingGimmick(e, n, a, n)
	local n = TppGimmick.GetRouteConnectedGimmickId(e)
	if (n ~= nil) and TppGimmick.IsBroken({ gimmickId = n }) then
		local n
		for e, t in pairs(mvars.ene_soldierIDList) do
			if t[a] then
				n = e
				break
			end
		end
		if n then
			local e = { id = "SetRouteEnabled", routes = { e }, enabled = false }
			t(n, e)
		end
	else
		mvars.ene_usingGimmickRouteEnemyList = mvars.ene_usingGimmickRouteEnemyList or {}
		mvars.ene_usingGimmickRouteEnemyList[e] = mvars.ene_usingGimmickRouteEnemyList[e] or {}
		mvars.ene_usingGimmickRouteEnemyList[e] = a
		t(a, { id = "SetSneakRoute", route = e })
	end
end
function e.DisableUseGimmickRouteOnShiftChange(a, e)
	if not s(e) then
		return
	end
	if mvars.ene_usingGimmickRouteEnemyList == nil then
		return
	end
	for n, e in pairs(e) do
		local n = p(e)
		local n = mvars.ene_usingGimmickRouteEnemyList[n]
		if n then
			t(n, { id = "SetSneakRoute", route = "" })
		end
		local n = mvars.gim_routeGimmickConnectTable[p(e)]
		if (n ~= nil) and TppGimmick.IsBroken({ gimmickId = n }) then
			local e = { id = "SetRouteEnabled", routes = { e }, enabled = false }
			t(a, e)
		end
	end
end
function e.IsEliminateTarget(e)
	local a = mvars.ene_eliminateTargetList and mvars.ene_eliminateTargetList[e]
	local n = mvars.ene_eliminateHelicopterList and mvars.ene_eliminateHelicopterList[e]
	local t = mvars.ene_eliminateVehicleList and mvars.ene_eliminateVehicleList[e]
	local e = mvars.ene_eliminateWalkerGearList and mvars.ene_eliminateWalkerGearList[e]
	local e = ((a or n) or t) or e
	return e
end
function e.IsRescueTarget(e)
	local e = mvars.ene_rescueTargetList and mvars.ene_rescueTargetList[e]
	return e
end
function e.IsChildTarget(e)
	local e = mvars.ene_childTargetList and mvars.ene_childTargetList[e]
	return e
end
function e.IsChildHostage(e)
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	local e = GameObject.SendCommand(e, { id = "IsChild" })
	return e
end
function e.IsFemaleHostage(e)
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	local e = GameObject.SendCommand(e, { id = "isFemale" })
	return e
end
function e.AddTakingOverHostage(n)
	local a = GameObject.GetTypeIndex(n)
	if a ~= TppGameObject.GAME_OBJECT_TYPE_HOSTAGE2 then
		return
	end
	if e.IsRecovered(n) then
		return
	end
	if TppHelicopter.IsInHelicopter(n) then
		return
	end
	if mvars.ene_ignoreTakingOverHostage and mvars.ene_ignoreTakingOverHostage[n] then
		return
	end
	if e.IsRescueTarget(n) then
		return
	end
	local t = t(n, { id = "GetMarkerEnabled" })
	if t then
		e._AddTakingOverHostage(n)
	end
end
function e._AddTakingOverHostage(n)
	if gvars.ene_takingOverHostageCount >= TppDefine.MAX_TAKING_OVER_HOSTAGE_COUNT then
		return
	end
	local e = gvars.ene_takingOverHostageCount
	local a = t(n, { id = "GetPosition" })
	local o, r = t(n, { id = "GetStaffId", divided = true })
	local i = t(n, { id = "GetFaceId" })
	local n = t(n, { id = "GetKeepFlagValue" })
	gvars.ene_takingOverHostagePositions[e * 3 + 0] = a:GetX()
	gvars.ene_takingOverHostagePositions[e * 3 + 1] = a:GetY()
	gvars.ene_takingOverHostagePositions[e * 3 + 2] = a:GetZ()
	gvars.ene_takingOverHostageStaffIdsUpper[e] = o
	gvars.ene_takingOverHostageStaffIdsLower[e] = r
	gvars.ene_takingOverHostageFaceIds[e] = i
	gvars.ene_takingOverHostageFlags[e] = n
	gvars.ene_takingOverHostageCount = gvars.ene_takingOverHostageCount + 1
end
function e.IsNeedHostageTakingOver(e)
	if TppMission.IsSysMissionId(vars.missionCode) then
		return false
	end
	if TppMission.IsHelicopterSpace(e) then
		return false
	end
	if TppLocation.IsAfghan() or TppLocation.IsMiddleAfrica() then
		return true
	else
		return false
	end
end
function e.ResetTakingOverHostageInfo()
	gvars.ene_takingOverHostageCount = 0
	for e = 0, TppDefine.MAX_TAKING_OVER_HOSTAGE_COUNT - 1 do
		for n = 0, 2 do
			gvars.ene_takingOverHostagePositions[e * 3 + n] = 0
		end
		gvars.ene_takingOverHostageStaffIdsUpper[e] = 0
		gvars.ene_takingOverHostageStaffIdsLower[e] = 0
		gvars.ene_takingOverHostageFaceIds[e] = 0
		gvars.ene_takingOverHostageFlags[e] = 0
	end
end
function e.SpawnTakingOverHostage(n)
	if not s(n) then
		return
	end
	for t, n in ipairs(n) do
		e._SpawnTakingOverHostage(t - 1, n)
	end
end
function e._SpawnTakingOverHostage(n, e)
	local e = r(e)
	if e == a then
		return
	end
	if n < gvars.ene_takingOverHostageCount then
		local a = gvars.ene_takingOverHostageStaffIdsUpper[infoIndex]
		local i = gvars.ene_takingOverHostageStaffIdsLower[infoIndex]
		t(e, { id = "SetStaffId", divided = true, staffId = a, staffId2 = i })
		if TppMission.IsMissionStart() then
			t(e, { id = "SetEnabled", enabled = true })
			local a = Vector3(
				gvars.ene_takingOverHostagePositions[n * 3],
				gvars.ene_takingOverHostagePositions[n * 3 + 1],
				gvars.ene_takingOverHostagePositions[n * 3 + 2]
			)
			t(e, { id = "Warp", position = a })
			t(e, { id = "SetFaceId", faceId = gvars.ene_takingOverHostageFaceIds[n] })
			t(e, { id = "SetKeepFlagValue", keepFlagValue = gvars.ene_takingOverHostageFlags[n] })
		end
	else
		t(e, { id = "SetEnabled", enabled = false })
	end
end
function e.SetIgnoreTakingOverHostage(e)
	if not s(e) then
		return
	end
	mvars.ene_ignoreTakingOverHostage = mvars.ene_ignoreTakingOverHostage or {}
	for n, e in ipairs(e) do
		local e = r(e)
		if e ~= a then
			mvars.ene_ignoreTakingOverHostage[e] = true
		else
			return
		end
	end
end
function e.SetIgnoreDisableNpc(n, i)
	local e
	if l(n) then
		e = n
	elseif o(n) then
		e = r(n)
	else
		return
	end
	if e == a then
		return
	end
	t(e, { id = "SetIgnoreDisableNpc", enable = i })
	return true
end
function e.NPCEntryPointSetting(e)
	local e = e[gvars.heli_missionStartRoute]
	if not e then
		return
	end
	for e, n in pairs(e) do
		local t, n = n[1], n[2]
		TppBuddyService.SetMissionEntryPosition(e, t)
		TppBuddyService.SetMissionEntryRotationY(e, n)
	end
end
function e.SetupQuestEnemy()
	local t = "quest_cp"
	local n = "gt_quest_0000"
	if mvars.ene_soldierDefine.quest_cp == nil then
		return
	end
	for n, e in ipairs(mvars.ene_soldierDefine.quest_cp) do
		local e = GameObject.GetGameObjectId("TppSoldier2", e)
		if e ~= a then
			GameObject.SendCommand(e, { id = "SetEnabled", enabled = false })
		end
	end
	TppCombatLocatorProvider.RegisterCombatLocatorSetToCpforLua({ cpName = t, locatorSetName = n })
end
function e.OnAllocateQuest(e, n, a)
	local function i(e, n)
		local t = "SetNone"
		if s(n) and s(e) then
			TppSoldierFace.SetAndConvertExtendFova({ face = n, body = e })
			t = "SetFaceAndBody"
		elseif s(n) then
			TppSoldierFace.SetAndConvertExtendFova({ face = n })
			t = "SetFace"
		elseif s(e) then
			TppSoldierFace.SetAndConvertExtendFova({ body = e })
			t = "SetBody"
		end
		return t
	end
	if n == nil and e == nil then
		return
	end
	a = a or false
	if a == false then
		local t
		local a = i(e, n)
		if a == "SetFaceAndBody" then
			t = { id = "InitializeAndAllocateExtendFova", face = n, body = e }
		elseif a == "SetFace" then
			t = { id = "InitializeAndAllocateExtendFova", face = n }
		elseif a == "SetBody" then
			t = { id = "InitializeAndAllocateExtendFova", body = e }
		end
		GameObject.SendCommand({ type = "TppSoldier2" }, t)
		GameObject.SendCommand({ type = "TppCorpse" }, t)
	else
		if e then
			local n = {}
			for t, e in ipairs(e) do
				local t = e[1]
				if l(t) then
					table.insert(n, e[1])
				end
			end
			TppSoldierFace.SetBodyFovaUserType({ hostage = hostageBodyTable })
		end
		local t = i(e, n)
		if t == "SetFaceAndBody" then
			TppSoldierFace.ReserveExtendFovaForHostage({ face = n, body = e })
		elseif t == "SetFace" then
			TppSoldierFace.ReserveExtendFovaForHostage({ face = n })
		elseif t == "SetBody" then
			TppSoldierFace.ReserveExtendFovaForHostage({ body = e })
		end
	end
end
function e.OnAllocateQuestFova(n)
	local a = {}
	local t = {}
	local s = false
	local o = false
	local p = false
	local d = false
	mvars.ene_questArmorId = 0
	mvars.ene_questBalaclavaId = 0
	if n.isQuestBalaclava == true then
		local e = {}
		if TppLocation.IsAfghan() then
			mvars.ene_questBalaclavaId = TppDefine.QUEST_FACE_ID_LIST.AFGH_BALACLAVA
		elseif TppLocation.IsMiddleAfrica() then
			mvars.ene_questBalaclavaId = TppDefine.QUEST_FACE_ID_LIST.MAFR_BALACLAVA
		end
		mvars.ene_questGetLoadedFaceTable = TppSoldierFace.GetLoadedFaceTable({})
		if mvars.ene_questGetLoadedFaceTable ~= nil then
			local n = #mvars.ene_questGetLoadedFaceTable
			if mvars.ene_questBalaclavaId ~= 0 and n > 0 then
				e = { mvars.ene_questBalaclavaId, TppDefine.QUEST_ENEMY_MAX, 0 }
				table.insert(a, e)
				o = true
			end
		end
	end
	if n.isQuestArmor == true then
		local e = {}
		if TppLocation.IsAfghan() then
			mvars.ene_questArmorId = TppDefine.QUEST_BODY_ID_LIST.AFGH_ARMOR
		elseif TppLocation.IsMiddleAfrica() then
			if n.soldierSubType == "PF_A" then
				mvars.ene_questArmorId = TppDefine.QUEST_BODY_ID_LIST.MAFR_ARMOR_CFA
			elseif n.soldierSubType == "PF_B" then
				mvars.ene_questArmorId = TppDefine.QUEST_BODY_ID_LIST.MAFR_ARMOR_ZRS
			elseif n.soldierSubType == "PF_C" then
				mvars.ene_questArmorId = TppDefine.QUEST_BODY_ID_LIST.MAFR_ARMOR_RC
			end
		end
		if mvars.ene_questArmorId ~= 0 then
			e = { mvars.ene_questArmorId, TppDefine.QUEST_ENEMY_MAX, 0 }
			table.insert(t, e)
			s = true
		end
	end
	if (n.enemyList and Tpp.IsTypeTable(n.enemyList)) and next(n.enemyList) then
		for n, e in pairs(n.enemyList) do
			if e.enemyName then
				if e.bodyId then
					local n = 1
					local e = { e.bodyId, n, 0 }
					table.insert(t, e)
					s = true
				end
				if e.faceId then
					local n = 1
					local e = { e.faceId, n, 0 }
					table.insert(a, e)
					o = true
				end
			end
		end
	end
	if (n.hostageList and Tpp.IsTypeTable(n.hostageList)) and next(n.hostageList) then
		for n, e in pairs(n.hostageList) do
			if e.hostageName then
				if e.bodyId then
					local n = 1
					local e = { e.bodyId, 0, n }
					table.insert(t, e)
					p = true
				end
				if e.faceId then
					local n = 1
					local e = { e.faceId, 0, n }
					table.insert(a, e)
					d = true
				end
				if e.isFaceRandom then
					local e = TppQuest.GetRandomFaceId()
					if e then
						local n = 1
						local e = { e, 0, n }
						table.insert(a, e)
						d = true
					end
				end
			end
		end
	end
	if p == true then
		local a = {}
		local n = false
		for t, e in ipairs(t) do
			if e[3] >= 1 then
				local e = e[1]
				if l(e) then
					table.insert(a, e)
					n = true
				end
			end
		end
		if n == true then
			TppSoldierFace.SetBodyFovaUserType({ hostage = hostageBodyTable })
		end
	end
	local i = "SetNone"
	if ((s == true or o == true) or p == true) or d == true then
		local n = s or p
		local e = o or d
		if n == true and e == true then
			TppSoldierFace.SetAndConvertExtendFova({ face = a, body = t })
			i = "SetFaceAndBody"
		elseif e == true then
			TppSoldierFace.SetAndConvertExtendFova({ face = a })
			i = "SetFace"
		elseif n == true then
			TppSoldierFace.SetAndConvertExtendFova({ body = t })
			i = "SetBody"
		end
	end
	local r
	if s == true or o == true then
		if i == "SetFaceAndBody" then
			r = { id = "InitializeAndAllocateExtendFova", face = a, body = t }
		elseif i == "SetFace" then
			r = { id = "InitializeAndAllocateExtendFova", face = a }
		elseif i == "SetBody" then
			r = { id = "InitializeAndAllocateExtendFova", body = t }
		end
		if r then
			GameObject.SendCommand({ type = "TppSoldier2" }, r)
			GameObject.SendCommand({ type = "TppCorpse" }, r)
		end
	end
	if p == true or d == true then
		if i == "SetFaceAndBody" then
			TppSoldierFace.ReserveExtendFovaForHostage({ face = a, body = t })
		elseif i == "SetFace" then
			TppSoldierFace.ReserveExtendFovaForHostage({ face = a })
		elseif i == "SetBody" then
			TppSoldierFace.ReserveExtendFovaForHostage({ body = t })
		end
	end
	local n = n.heliList
	if (n and Tpp.IsTypeTable(n)) and next(n) then
		e.LoadQuestHeli(n[1].coloringType)
	end
end
function e.OnActivateQuest(n)
	if n == nil then
		return
	end
	if mvars.ene_isQuestSetup == false then
		mvars.ene_questTargetList = {}
		mvars.ene_questVehicleList = {}
	end
	local t = false
	if (n.targetList and Tpp.IsTypeTable(n.targetList)) and next(n.targetList) then
		e.SetupActivateQuestTarget(n.targetList)
		t = true
	end
	if (n.vehicleList and Tpp.IsTypeTable(n.vehicleList)) and next(n.vehicleList) then
		e.SetupActivateQuestVehicle(n.vehicleList, n.targetList)
		t = true
	end
	if (n.heliList and Tpp.IsTypeTable(n.heliList)) and next(n.heliList) then
		e.SetupActivateQuestHeli(n.heliList)
		t = true
	end
	if (n.cpList and Tpp.IsTypeTable(n.cpList)) and next(n.cpList) then
		e.SetupActivateQuestCp(n.cpList)
		t = true
	end
	if (n.enemyList and Tpp.IsTypeTable(n.enemyList)) and next(n.enemyList) then
		e.SetupActivateQuestEnemy(n.enemyList)
		t = true
	end
	if n.isQuestZombie == true then
		local e = { type = "TppSoldier2" }
		GameObject.SendCommand(e, { id = "RegistSwarmEffect" })
		t = true
	end
	if (n.hostageList and Tpp.IsTypeTable(n.hostageList)) and next(n.hostageList) then
		e.SetupActivateQuestHostage(n.hostageList)
		t = true
	end
	if t == true then
		mvars.ene_isQuestSetup = true
	end
end
function e.SetupActivateQuestTarget(n)
	if mvars.ene_isQuestSetup == false then
		for n, t in pairs(n) do
			local n = t
			if o(n) then
				n = GameObject.GetGameObjectId(n)
			end
			if n == a then
			else
				e.SetQuestEnemy(n, true)
				TppMarker.SetQuestMarker(t)
			end
		end
	end
end
function e.SetupActivateQuestVehicle(n, t)
	if mvars.ene_isQuestSetup == false then
		mvars.ene_questVehicleList = {}
		e.SpawnVehicles(n)
		for a, n in ipairs(n) do
			if n.locator then
				local e = { id = "Despawn", locator = n.locator }
				table.insert(mvars.ene_questVehicleList, e)
			end
			for a, t in ipairs(t) do
				if n.locator == t then
					e.SetQuestEnemy(n.locator, true)
					TppMarker.SetQuestMarker(n.locator)
				else
					e.SetQuestEnemy(n.locator, false)
				end
			end
		end
	end
end
function e.SetupActivateQuestHeli(t)
	if mvars.ene_isQuestSetup == false then
		if not e.IsQuestHeli() then
			return
		end
		local i = false
		for n, t in ipairs(t) do
			if t.routeName then
				local n = GameObject.GetGameObjectId(TppReinforceBlock.REINFORCE_HELI_NAME)
				if n == a then
				else
					GameObject.SendCommand(n, { id = "RequestRoute", route = t.routeName })
					GameObject.SendCommand(n, { id = "DisablePullOut" })
					i = true
					e.SetQuestEnemy(n, false)
				end
			end
		end
		if i == true then
			e.ActivateQuestHeli(t.coloringType)
		end
	end
end
function e.SetupActivateQuestCp(e)
	if mvars.ene_isQuestSetup == false then
		for n, e in pairs(e) do
			if not e.cpName then
			else
				local n = e.cpName
				if o(n) then
					n = GameObject.GetGameObjectId(n)
				end
				if n == a then
				else
					if e.isNormalCp == true then
						GameObject.SendCommand(n, { id = "SetNormalCp" })
					end
					if e.isOuterBaseCp == true then
						GameObject.SendCommand(n, { id = "SetOuterBaseCp" })
					end
					if e.isMarchCp == true then
						GameObject.SendCommand(n, { id = "SetMarchCp" })
					end
					if ((e.cpPosition_x and e.cpPosition_y) and e.cpPosition_z) and e.cpPosition_r then
						GameObject.SendCommand(
							n,
							{ id = "SetCpPosition", x = e.cpPosition_x, y = e.cpPosition_y, z = e.cpPosition_z, r = e.cpPosition_r }
						)
					end
					if e.gtName then
						if ((not e.gtPosition_x or not e.gtPosition_y) or not e.gtPosition_z) or not e.gtPosition_r then
						end
						local a = { type = "TppCommandPost2" }
						local r = e.gtPosition_x or e.cpPosition_x
						local i = e.gtPosition_y or e.cpPosition_y
						local t = e.gtPosition_z or e.cpPosition_z
						local n = e.gtPosition_r or e.cpPosition_r
						GameObject.SendCommand(
							a,
							{ id = "SetLocatorPosition", name = e.gtName, x = r, y = i, z = t, r = n }
						)
					end
				end
			end
		end
	end
end
function e.SetupActivateQuestEnemy(p)
	local i = 1
	local function s(n, r)
		local t = n.enemyName
		if o(t) then
			t = GameObject.GetGameObjectId(t)
		end
		if t == a then
		else
			if r == false then
				if mvars.ene_isQuestSetup == false then
					if n.soldierType then
						e.SetSoldierType(t, n.soldierType)
					end
					if n.soldierSubType then
						e.SetSoldierSubType(t, n.soldierSubType)
					else
						if TppLocation.IsMiddleAfrica() then
						end
					end
					local a = true
					if n.powerSetting then
						for n, e in ipairs(n.powerSetting) do
							if e == "QUEST_ARMOR" then
								if mvars.ene_questArmorId == 0 then
									a = false
								end
							end
						end
					end
					if a == true then
						local n = n.powerSetting or { nil }
						e.ApplyPowerSetting(t, n)
					else
						e.ApplyPowerSetting(t, { nil })
					end
					if n.cpName then
						GameObject.SendCommand(t, { id = "SetCommandPost", cp = n.cpName })
					end
					if (n.staffTypeId or n.skill) or n.uniqueTypeId then
						local a = n.staffTypeId or TppDefine.STAFF_TYPE_ID.NORMAL
						local e = n.skill or false
						local n = n.uniqueTypeId or false
						if e == false and n == false then
							TppMotherBaseManagement.RegenerateGameObjectStaffParameter({ gameObjectId = t, staffTypeId = a })
						elseif e ~= false and o(e) then
							TppMotherBaseManagement.RegenerateGameObjectStaffParameter({
								gameObjectId = t,
								staffTypeId = a,
								skill = e,
							})
						elseif n ~= false then
							TppMotherBaseManagement.RegenerateGameObjectStaffParameter({
								gameObjectId = t,
								staffType = "Unique",
								uniqueTypeId = n,
							})
						end
					else
						if mvars.ene_questTargetList[t] then
							TppMotherBaseManagement.RegenerateGameObjectQuestStaffParameter({ gameObjectId = t })
						end
					end
					if n.voiceType then
						if
							((n.voiceType == "ene_a" or n.voiceType == "ene_b") or n.voiceType == "ene_c")
							or n.voiceType == "ene_d"
						then
							GameObject.SendCommand(t, { id = "SetVoiceType", voiceType = n.voiceType })
						end
					else
						local n = { "ene_a", "ene_b", "ene_c", "ene_d" }
						local e = math.random(4)
						local e = n[e]
						GameObject.SendCommand(t, { id = "SetVoiceType", voiceType = e })
					end
				end
				if n.bodyId or n.faceId then
					local e = n.faceId or false
					local n = n.bodyId or false
					if l(n) and l(e) then
						GameObject.SendCommand(t, { id = "ChangeFova", bodyId = n, faceId = e })
					elseif l(e) then
						GameObject.SendCommand(t, { id = "ChangeFova", faceId = e })
					elseif l(n) then
						GameObject.SendCommand(t, { id = "ChangeFova", bodyId = n })
					end
				end
				if n.isBalaclava == true then
					if mvars.ene_questGetLoadedFaceTable ~= nil then
						local e = mvars.ene_questGetLoadedFaceTable
						local e = #mvars.ene_questGetLoadedFaceTable
						if e > 0 and mvars.ene_questBalaclavaId ~= 0 then
							local e = mvars.ene_questGetLoadedFaceTable[i]
							if mvars.ene_questGetLoadedFaceTable[i + 1] then
								i = i + 1
							else
								i = 1
							end
							if n.soldierSubType == "PF_A" or n.soldierSubType == "PF_C" then
								GameObject.SendCommand(t, { id = "ChangeFova", isScarf = true })
							else
								GameObject.SendCommand(
									t,
									{ id = "ChangeFova", balaclavaFaceId = mvars.ene_questBalaclavaId, faceId = e }
								)
							end
						end
					end
				end
				if mvars.ene_isQuestSetup == false then
					if n.route_d then
						e.SetSneakRoute(t, n.route_d)
					end
					if n.route_c then
						e.SetCautionRoute(t, n.route_c)
					end
					if n.route_a then
						e.SetAlertRoute(t, n.route_a)
					end
					if n.rideFromVehicleId then
						local e = n.rideFromVehicleId
						if o(e) then
							e = GameObject.GetGameObjectId(e)
						end
						GameObject.SendCommand(t, { id = "SetRelativeVehicle", targetId = e, rideFromBeginning = true })
					end
					if n.isZombie then
						GameObject.SendCommand(
							t,
							{ id = "SetZombie", enabled = true, isMsf = false, isZombieSkin = true, isHagure = true }
						)
					end
					if n.isMsf then
						GameObject.SendCommand(t, { id = "SetZombie", enabled = true, isMsf = true })
					end
					if n.isZombieUseRoute then
						GameObject.SendCommand(t, { id = "SetZombieUseRoute", enabled = true })
					end
					if n.isBalaclava == true then
						GameObject.SendCommand(t, { id = "SetSoldier2Flag", flag = "highRank", on = true })
					end
					GameObject.SendCommand(t, { id = "SetEnabled", enabled = true })
					e.SetQuestEnemy(t, false)
				end
			else
				local e = n.isDisable or false
				if e == true then
					GameObject.SendCommand(t, { id = "SetEnabled", enabled = false })
				end
			end
		end
	end
	for n, e in pairs(p) do
		if e.enemyName then
			s(e, false)
		elseif e.setCp then
			local n = r(e.setCp)
			if n == a then
			else
				local n = nil
				for t, a in pairs(mvars.ene_cpList) do
					if a == e.setCp then
						n = t
					end
				end
				if n then
					for n, t in pairs(mvars.ene_soldierIDList[n]) do
						local e = { enemyName = n, isDisable = e.isDisable }
						s(e, true)
					end
				end
			end
		end
	end
end
function e.SetupActivateQuestHostage(n)
	local r = TppLocation.IsAfghan()
	local i = TppLocation.IsMiddleAfrica()
	for t, n in pairs(n) do
		if n.hostageName then
			local t = n.hostageName
			if o(t) then
				t = GameObject.GetGameObjectId(t)
			end
			if t == a then
			else
				if mvars.ene_isQuestSetup == false then
					if (n.staffTypeId or n.skill) or n.uniqueTypeId then
						local a = n.staffTypeId or TppDefine.STAFF_TYPE_ID.NORMAL
						local e = n.skill or false
						local n = n.uniqueTypeId or false
						if e == false and n == false then
							TppMotherBaseManagement.RegenerateGameObjectStaffParameter({ gameObjectId = t, staffTypeId = a })
						elseif e ~= false and o(e) then
							TppMotherBaseManagement.RegenerateGameObjectStaffParameter({
								gameObjectId = t,
								staffTypeId = a,
								skill = e,
							})
						elseif n ~= false then
							TppMotherBaseManagement.RegenerateGameObjectStaffParameter({
								gameObjectId = t,
								staffType = "Unique",
								uniqueTypeId = n,
							})
						end
					else
						if mvars.ene_questTargetList[t] then
							TppMotherBaseManagement.RegenerateGameObjectQuestStaffParameter({ gameObjectId = t })
						end
					end
					if n.voiceType then
						if s(n.voiceType) then
							local e = #n.voiceType
							local e = math.random(e)
							local e = n.voiceType[e]
							if ((e == "hostage_a" or e == "hostage_b") or e == "hostage_c") or e == "hostage_d" then
								GameObject.SendCommand(t, { id = "SetVoiceType", voiceType = e })
							end
						else
							local e = n.voiceType
							if ((e == "hostage_a" or e == "hostage_b") or e == "hostage_c") or e == "hostage_d" then
								GameObject.SendCommand(t, { id = "SetVoiceType", voiceType = e })
							end
						end
					else
						local n = { "hostage_a", "hostage_b", "hostage_c", "hostage_d" }
						local e = math.random(4)
						local e = n[e]
						GameObject.SendCommand(t, { id = "SetVoiceType", voiceType = e })
					end
					if n.langType then
						GameObject.SendCommand(t, { id = "SetLangType", langType = n.langType })
					else
						if e.IsFemaleHostage(t) == false then
							if r == true then
								GameObject.SendCommand(t, { id = "SetLangType", langType = "russian" })
							elseif i == true then
								GameObject.SendCommand(t, { id = "SetLangType", langType = "afrikaans" })
							end
						else
							GameObject.SendCommand(t, { id = "SetLangType", langType = "english" })
						end
					end
					if n.path then
						GameObject.SendCommand(
							t,
							{
								id = "SpecialAction",
								action = "PlayMotion",
								path = n.path,
								autoFinish = false,
								enableMessage = true,
								commandId = Fox.StrCode32("CommandA"),
								enableGravity = false,
								enableCollision = false,
							}
						)
					end
					e.SetQuestEnemy(t, false)
				end
				if (n.bodyId or n.faceId) or n.isFaceRandom then
					local e = n.faceId or false
					local a = n.bodyId or false
					if n.isFaceRandom then
						e = TppQuest.GetRandomFaceId()
					end
					if l(a) and l(e) then
						GameObject.SendCommand(t, { id = "ChangeFova", bodyId = a, faceId = e })
					elseif l(e) then
						GameObject.SendCommand(t, { id = "ChangeFova", faceId = e })
					elseif l(a) then
						GameObject.SendCommand(t, { id = "ChangeFova", bodyId = a })
					end
				end
			end
		end
	end
end
function e.OnDeactivateQuest(n)
	if mvars.ene_isQuestSetup == true then
		if (n.vehicleList and Tpp.IsTypeTable(n.vehicleList)) and next(n.vehicleList) then
			e.SetupDeactivateQuestVehicle(n.vehicleList)
		end
		if (n.heliList and Tpp.IsTypeTable(n.heliList)) and next(n.heliList) then
			e.SetupDeactivateQuestQuestHeli(n.heliList)
		end
		if (n.cpList and Tpp.IsTypeTable(n.cpList)) and next(n.cpList) then
			e.SetupDeactivateQuestCp(n.cpList)
		end
		if n.isQuestZombie == true then
			local e = { type = "TppSoldier2" }
			GameObject.SendCommand(e, { id = "UnregistSwarmEffect" })
		end
		if (n.enemyList and Tpp.IsTypeTable(n.enemyList)) and next(n.enemyList) then
			e.SetupDeactivateQuestEnemy(n.enemyList)
		end
		if (n.hostageList and Tpp.IsTypeTable(n.hostageList)) and next(n.hostageList) then
			e.SetupDeactivateQuestHostage(n.hostageList)
		end
		if not mvars.qst_isMissionEnd then
			local e = e.CheckQuestAllTarget(n.questType, nil, nil, true)
			TppQuest.ClearWithSave(e)
		end
	end
end
function e.SetupDeactivateQuestVehicle(e) end
function e.SetupDeactivateQuestQuestHeli(e) end
function e.SetupDeactivateQuestCp(e) end
function e.SetupDeactivateQuestEnemy(n)
	for n, t in pairs(n) do
		if t.enemyName then
			local n = t.enemyName
			if o(n) then
				n = GameObject.GetGameObjectId(n)
			end
			if n == a then
			else
				local a = { type = "TppCorpse" }
				if e.CheckQuestDistance(n) then
					if TppMission.CheckMissionState(true, false, true, false) then
						e.AutoFultonRecoverNeutralizedTarget(n, true)
					end
				end
				if t.bodyId or t.faceId then
					local e =
						{ id = "ChangeFova", faceId = EnemyFova.INVALID_FOVA_VALUE, bodyId = EnemyFova.INVALID_FOVA_VALUE }
					GameObject.SendCommand(n, e)
					local e = {
						id = "ChangeFovaCorpse",
						name = t.enemyName,
						faceId = EnemyFova.INVALID_FOVA_VALUE,
						bodyId = EnemyFova.INVALID_FOVA_VALUE,
					}
					GameObject.SendCommand(a, e)
				end
				if e.CheckQuestDistance(n) then
					if TppMission.CheckMissionState(true, false, true, false) then
						GameObject.SendCommand(n, { id = "RequestVanish" })
						GameObject.SendCommand(a, { id = "RequestDisableWithFadeout", name = t.enemyName })
					end
				end
			end
		elseif t.setCp then
		end
	end
end
function e.SetupDeactivateQuestHostage(n)
	for n, t in pairs(n) do
		if t.hostageName then
			local n = t.hostageName
			if o(n) then
				n = GameObject.GetGameObjectId(n)
			end
			if n == a then
			else
				if e.CheckQuestDistance(n) then
					if TppMission.CheckMissionState(true, false, true, false) then
						local e = TppMotherBaseManagement.GetStaffIdFromGameObject({ gameObjectId = n })
						TppTerminal.OnFulton(n, nil, nil, e, nil, true)
					end
				end
				if t.bodyId or t.faceId then
					local e =
						{ id = "ChangeFova", faceId = EnemyFova.INVALID_FOVA_VALUE, bodyId = EnemyFova.INVALID_FOVA_VALUE }
					GameObject.SendCommand(n, e)
				end
				if e.CheckQuestDistance(n) then
					if TppMission.CheckMissionState(true, false, true, false) then
						GameObject.SendCommand(n, { id = "RequestVanish" })
					end
				end
			end
		end
	end
end
function e.OnTerminateQuest(n)
	if mvars.ene_isQuestSetup == true then
		if (n.vehicleList and Tpp.IsTypeTable(n.vehicleList)) and next(n.vehicleList) then
			e.SetupTerminateQuestVehicle(n.vehicleList)
		end
		if (n.heliList and Tpp.IsTypeTable(n.heliList)) and next(n.heliList) then
			e.SetupTerminateQuestHeli(n.heliList)
		end
		if (n.cpList and Tpp.IsTypeTable(n.cpList)) and next(n.cpList) then
			e.SetupTerminateQuestCp(n.cpList)
		end
		if n.isQuestZombie == true then
			local e = { type = "TppSoldier2" }
			GameObject.SendCommand(e, { id = "UnregistSwarmEffect" })
		end
		if (n.enemyList and Tpp.IsTypeTable(n.enemyList)) and next(n.enemyList) then
			if GameObject.GetGameObjectIdByIndex("TppSoldier2", 0) ~= a then
				e.SetupTerminateQuestEnemy(n.enemyList)
			end
		end
		if (n.hostageList and Tpp.IsTypeTable(n.hostageList)) and next(n.hostageList) then
			e.SetupTerminateQuestHostage(n.hostageList)
		end
	end
	if GameObject.GetGameObjectIdByIndex("TppSoldier2", 0) ~= a then
		local e = { type = "TppSoldier2" }
		GameObject.SendCommand(e, { id = "FreeExtendFova" })
	end
	if GameObject.GetGameObjectIdByIndex("TppCorpse", 0) ~= a then
		local e = { type = "TppCorpse" }
		GameObject.SendCommand(e, { id = "FreeExtendFova" })
	end
	TppSoldierFace.ClearExtendFova()
	TppSoldierFace.ReserveExtendFovaForHostage({})
	mvars.ene_questTargetList = {}
	mvars.ene_questVehicleList = {}
	mvars.ene_isQuestSetup = false
end
function e.SetupTerminateQuestVehicle(n)
	e.DespawnVehicles(mvars.ene_questVehicleList)
end
function e.SetupTerminateQuestHeli(n)
	e.DeactivateQuestHeli()
	e.UnloadQuestHeli()
end
function e.SetupTerminateQuestCp(e) end
function e.SetupTerminateQuestEnemy(s)
	local p = TppLocation.IsAfghan()
	local i = TppLocation.IsMiddleAfrica()
	local function t(n, t)
		local e = n.enemyName
		if o(e) then
			e = GameObject.GetGameObjectId(e)
		end
		if e == a then
		else
			if t == false then
				local t = { type = "TppCorpse" }
				GameObject.SendCommand(e, { id = "SetEnabled", enabled = false })
				GameObject.SendCommand(e, { id = "SetCommandPost", cp = "quest_cp" })
				GameObject.SendCommand(
					e,
					{ id = "SetZombie", enabled = false, isMsf = false, isZombieSkin = true, isHagure = false }
				)
				GameObject.SendCommand(e, { id = "SetZombieUseRoute", enabled = false })
				GameObject.SendCommand(e, { id = "SetEverDown", enabled = false })
				GameObject.SendCommand(e, { id = "SetSoldier2Flag", flag = "highRank", on = false })
				GameObject.SendCommand(e, { id = "Refresh" })
				GameObject.SendCommand(t, { id = "RequestVanish", name = n.enemyName })
				if n.powerSetting then
					for i, a in ipairs(n.powerSetting) do
						if a == "QUEST_ARMOR" then
							local a = {
								id = "ChangeFova",
								faceId = EnemyFova.INVALID_FOVA_VALUE,
								bodyId = EnemyFova.INVALID_FOVA_VALUE,
							}
							GameObject.SendCommand(e, a)
							local e = {
								id = "ChangeFovaCorpse",
								name = n.enemyName,
								faceId = EnemyFova.INVALID_FOVA_VALUE,
								bodyId = EnemyFova.INVALID_FOVA_VALUE,
							}
							GameObject.SendCommand(t, e)
						end
					end
				end
				if p == true then
					GameObject.SendCommand(e, { id = "SetSoldier2Type", type = EnemyType.TYPE_SOVIET })
				elseif i == true then
					GameObject.SendCommand(e, { id = "SetSoldier2Type", type = EnemyType.TYPE_PF })
				end
			else
				local n = n.isDisable or false
				if n == true then
					GameObject.SendCommand(e, { id = "SetEnabled", enabled = true })
				end
			end
		end
	end
	for n, e in pairs(s) do
		if e.enemyName then
			t(e, false)
			TppUiCommand.UnRegisterIconUniqueInformation(GameObject.GetGameObjectId(e.enemyName))
		elseif e.setCp then
			local n = r(e.setCp)
			if n == a then
			else
				local n = nil
				for a, t in pairs(mvars.ene_cpList) do
					if t == e.setCp then
						n = a
					end
				end
				if n then
					for n, a in pairs(mvars.ene_soldierIDList[n]) do
						local e = { enemyName = n, isZombie = e.isZombie, isMsf = e.isMsf, isDisable = e.isDisable }
						t(e, true)
					end
				end
			end
		end
	end
end
function e.SetupTerminateQuestHostage(e) end
function e.CheckQuestDistance(e)
	if Tpp.IsSoldier(e) or Tpp.IsHostage(e) then
		local t = Vector3(vars.playerPosX, vars.playerPosY, vars.playerPosZ)
		local n = 10
		local n = n * n
		if d(n, t, e) then
			return true
		end
	end
	return false
end
function e.CheckQuestNpcLifeStatus(e)
	if e ~= nil then
		local e = GameObject.SendCommand(e, { id = "GetLifeStatus" })
		if e == TppGameObject.NPC_LIFE_STATE_DEAD then
			return false
		else
			return true
		end
	end
end
function e.IsQuestInHelicopter()
	TppHelicopter.SetNewestPassengerTable()
	for e, n in pairs(mvars.ene_questTargetList) do
		if TppHelicopter.IsInHelicopter(e) then
			return true
		end
	end
	return false
end
function e.IsQuestInHelicopterGameObjectId(n)
	TppHelicopter.SetNewestPassengerTable()
	for e, t in pairs(mvars.ene_questTargetList) do
		if TppHelicopter.IsInHelicopter(e) then
			if e == n then
				return true
			end
		end
	end
	return false
end
function e.IsQuestTarget(e)
	if mvars.ene_isQuestSetup == false then
		return false
	end
	if not next(mvars.ene_questTargetList) then
		return false
	end
	for n, t in pairs(mvars.ene_questTargetList) do
		if t.isTarget == true then
			if e == n then
				return true
			end
		end
	end
	return false
end
function e.IsQuestNpc(e)
	for n, t in pairs(mvars.ene_questTargetList) do
		if e == n then
			return true
		end
	end
	return false
end
function e.GetQuestCount()
	local n = 0
	local e = 0
	for a, t in pairs(mvars.ene_questTargetList) do
		if t.isTarget == true then
			n = n + 1
			if t.messageId ~= "None" then
				e = e + 1
			end
		end
	end
	return e, n
end
function e.SetQuestEnemy(e, n)
	if o(e) then
		e = GameObject.GetGameObjectId(e)
	end
	if e == a then
	end
	if not mvars.ene_questTargetList[e] then
		local n = { messageId = "None", isTarget = n }
		mvars.ene_questTargetList[e] = n
	end
end
function e.CheckDeactiveQuestAreaForceFulton()
	if mvars.ene_isQuestSetup == false then
		return
	end
	if not next(mvars.ene_questTargetList) then
		return
	end
	for n, t in pairs(mvars.ene_questTargetList) do
		if Tpp.IsSoldier(n) or Tpp.IsHostage(n) then
			if e.CheckQuestDistance(n) then
				if e.CheckQuestNpcLifeStatus(n) then
					GameObject.SendCommand(n, { id = "RequestForceFulton" })
					TppRadio.Play("f1000_rtrg5140")
					TppSoundDaemon.PostEvent("sfx_s_rescue_pow")
				else
					GameObject.SendCommand(n, { id = "RequestDisableWithFadeout" })
				end
			end
		end
	end
end
function e.CheckQuestAllTarget(p, S, T, a, t)
	local n = TppDefine.QUEST_CLEAR_TYPE.NONE
	local l = a or false
	local c = t or false
	local u = false
	local r = 0
	local a = 0
	local o = 0
	local s = 0
	local d = 0
	local i = 0
	local t = true
	local _ = false
	local f = TppQuest.GetCurrentQuestName()
	if TppQuest.IsEnd(f) then
		return n
	end
	if mvars.ene_questTargetList[T] then
		local e = mvars.ene_questTargetList[T]
		if e.messageId ~= "None" and e.isTarget == true then
			_ = true
		elseif e.isTarget == false then
			_ = true
		end
		e.messageId = S or "None"
		u = true
	end
	if (l == false and c == false) and u == false then
		return n
	end
	for n, p in pairs(mvars.ene_questTargetList) do
		local _ = false
		local T = p.isTarget or false
		if l == true then
			if Tpp.IsSoldier(n) or Tpp.IsHostage(n) then
				if e.CheckQuestDistance(n) then
					p.messageId = "Fulton"
					a = a + 1
					_ = false
					t = true
				end
			end
		end
		if T == true then
			if _ == false then
				local e = p.messageId
				if e ~= "None" then
					if e == "Fulton" then
						a = a + 1
						t = true
					elseif e == "InHelicopter" then
						i = i + 1
						t = true
					elseif e == "FultonFailed" then
						o = o + 1
						t = true
					elseif (e == "Dead" or e == "VehicleBroken") or e == "LostControl" then
						s = s + 1
						t = true
					elseif e == "Vanished" then
						d = d + 1
						t = true
					end
				end
				if l == true then
					t = false
				end
			end
			r = r + 1
		end
	end
	if _ == true then
		t = false
	end
	if r > 0 then
		if p == TppDefine.QUEST_TYPE.RECOVERED then
			if a + i >= r then
				n = TppDefine.QUEST_CLEAR_TYPE.CLEAR
			elseif o > 0 or s > 0 then
				n = TppDefine.QUEST_CLEAR_TYPE.FAILURE
			elseif a + i > 0 then
				if t == true then
					n = TppDefine.QUEST_CLEAR_TYPE.UPDATE
				end
			end
		elseif p == TppDefine.QUEST_TYPE.ELIMINATE then
			if ((a + o) + s) + i >= r then
				n = TppDefine.QUEST_CLEAR_TYPE.CLEAR
			elseif ((a + o) + s) + i > 0 then
				if t == true then
					n = TppDefine.QUEST_CLEAR_TYPE.UPDATE
				end
			end
		elseif p == TppDefine.QUEST_TYPE.MSF_RECOVERED then
			if a >= r or i >= r then
				n = TppDefine.QUEST_CLEAR_TYPE.CLEAR
			elseif (o > 0 or s > 0) or d > 0 then
				n = TppDefine.QUEST_CLEAR_TYPE.FAILURE
			end
		end
	end
	if c == true then
		if n == TppDefine.QUEST_CLEAR_TYPE.NONE or n == TppDefine.QUEST_CLEAR_TYPE.UPDATE then
			n = TppDefine.QUEST_CLEAR_TYPE.NONE
		end
	end
	return n
end
function e.ReserveQuestHeli()
	local e = r("TppCommandPost2", _)
	TppRevenge.SetEnabledSuperReinforce(false)
	mvars.ene_isQuestHeli = true
end
function e.UnreserveQuestHeli()
	local e = r("TppCommandPost2", _)
	TppReinforceBlock.FinishReinforce(e)
	TppReinforceBlock.UnloadReinforceBlock(e)
	TppRevenge.SetEnabledSuperReinforce(true)
	mvars.ene_isQuestHeli = false
end
function e.LoadQuestHeli(n)
	local e = r("TppCommandPost2", _)
	TppReinforceBlock.LoadReinforceBlock(TppReinforceBlock.REINFORCE_TYPE.HELI, e, n)
end
function e.UnloadQuestHeli()
	local e = r("TppCommandPost2", _)
	TppReinforceBlock.UnloadReinforceBlock(e)
end
function e.ActivateQuestHeli(n)
	local e = r("TppCommandPost2", _)
	if not TppReinforceBlock.IsLoaded() then
		TppReinforceBlock.LoadReinforceBlock(TppReinforceBlock.REINFORCE_TYPE.HELI, e, n)
	end
	TppReinforceBlock.StartReinforce(e)
end
function e.DeactivateQuestHeli()
	local e = r("TppCommandPost2", _)
	TppReinforceBlock.FinishReinforce(e)
end
function e.IsQuestHeli()
	return mvars.ene_isQuestHeli
end
function e.GetDDSuit()
	local n = TppDefine.FOB_EVENT_ID_LIST.ARMOR
	local t = TppServerManager.GetEventId()
	for a, n in ipairs(n) do
		if t == n then
			return e.FOB_PF_SUIT_ARMOR
		end
	end
	local n = e.weaponIdTable.DD.NORMAL.SNEAKING_SUIT
	if n and n > 0 then
		return e.FOB_DD_SUIT_SNEAKING
	end
	local n = e.weaponIdTable.DD.NORMAL.BATTLE_DRESS
	if n and n > 0 then
		return e.FOB_DD_SUIT_BTRDRS
	end
	return e.FOB_DD_SUIT_ATTCKER
end
function e.IsHostageEventFOB()
	local n = TppDefine.FOB_EVENT_ID_LIST.HOSTAGE
	local e = TppServerManager.GetEventId()
	for t, n in ipairs(n) do
		if e == n then
			return true
		end
	end
	return false
end
function e.IsZombieEventFOB()
	local e = TppDefine.FOB_EVENT_ID_LIST.ZOMBIE
	local n = TppServerManager.GetEventId()
	for t, e in ipairs(e) do
		if n == e then
			return true
		end
	end
	return false
end
function e.IsParasiteMetalEventFOB()
	local e = TppDefine.FOB_EVENT_ID_LIST.PARASITE_METAL
	local n = TppServerManager.GetEventId()
	for t, e in ipairs(e) do
		if n == e then
			return true
		end
	end
	return false
end
function e.IsSpecialEventFOB()
	return e.IsParasiteMetalEventFOB()
end
function e._OnDead(n, i)
	local a
	if i then
		a = Tpp.IsPlayer(i)
	end
	local i = e.IsEliminateTarget(n)
	local r = e.IsRescueTarget(n)
	if a then
		if Tpp.IsHostage(n) then
			if e.IsChildHostage(n) then
				if TppMission.GetMissionID() ~= 10100 then
					TppMission.ReserveGameOverOnPlayerKillChild(n)
				end
			else
				if not i and not r then
					TppRadio.PlayCommonRadio(TppDefine.COMMON_RADIO.HOSTAGE_DEAD)
				end
			end
		end
	end
	if Tpp.IsSoldier(n) then
		local e = e.GetSoldierType(n)
		if e == EnemyType.TYPE_CHILD then
			TppMission.ReserveGameOverOnPlayerKillChild(n)
		end
	end
	if Tpp.IsHostage(n) and TppMission.GetMissionID() ~= 10100 then
		local e = t(n, { id = "IsChild" })
		if e then
			TppMission.ReserveGameOverOnPlayerKillChild(n)
		end
	end
	e.PlayTargetEliminatedRadio(n)
end
function e._OnRecoverNPC(n, t)
	e._PlayRecoverNPCRadio(n)
end
function e._PlayRecoverNPCRadio(n)
	local t = e.IsEliminateTarget(n)
	local a = e.IsRescueTarget(n)
	if Tpp.IsSoldier(n) and not t then
		TppRadio.PlayCommonRadio(TppDefine.COMMON_RADIO.ENEMY_RECOVERED)
	elseif Tpp.IsHostage(n) and not a then
		TppRadio.PlayCommonRadio(TppDefine.COMMON_RADIO.HOSTAGE_RECOVERED)
	else
		e.PlayTargetRescuedRadio(n)
	end
end
function e._OnFulton(n, a, a, t)
	e._OnRecoverNPC(n, t)
end
function e._OnDamage(a, n, t)
	if e.IsRescueTarget(a) then
		e._OnDamageOfRescueTarget(n, t)
	end
end
function e._OnDamageOfRescueTarget(e, n)
	if TppDamage.IsActiveByAttackId(e) then
		if Tpp.IsPlayer(n) then
			TppRadio.PlayCommonRadio(TppDefine.COMMON_RADIO.HOSTAGE_DAMAGED_FROM_PC)
		end
	end
end
function e._PlacedIntoVehicle(t, n, a)
	if Tpp.IsHelicopter(n) then
		e.PlayTargetRescuedRadio(t)
	end
end
function e._RideHelicopterWithHuman(t, n, t)
	e.PlayTargetRescuedRadio(n)
end
function e._AnnouncePhaseChange(n, t)
	local n = e.GetCpSubType(n)
	local e = "cmmn_ene_soviet"
	if n == "SOVIET_A" or n == "SOVIET_B" then
		e = "cmmn_ene_soviet"
	elseif n == "PF_A" then
		e = "cmmn_ene_cfa"
	elseif n == "PF_B" then
		e = "cmmn_ene_zrs"
	elseif n == "PF_C" then
		e = "cmmn_ene_coyote"
	elseif n == "DD_A" then
		return
	elseif n == "DD_PW" then
		e = "cmmn_ene_pf"
	elseif n == "DD_FOB" then
		e = "cmmn_ene_pf"
	elseif n == "SKULL_AFGH" then
		e = "cmmn_ene_xof"
	elseif n == "SKULL_CYPR" then
		return
	elseif n == "CHILD_A" then
		return
	end
	if t == TppGameObject.PHASE_ALERT then
		TppUiCommand.AnnounceLogViewLangId("announce_phase_to_alert", e)
	elseif t == TppGameObject.PHASE_EVASION then
		TppUiCommand.AnnounceLogViewLangId("announce_phase_to_evasion", e)
	elseif t == TppGameObject.PHASE_CAUTION then
		TppUiCommand.AnnounceLogViewLangId("announce_phase_to_caution", e)
	elseif t == TppGameObject.PHASE_SNEAK then
		TppUiCommand.AnnounceLogViewLangId("announce_phase_to_sneak", e)
	end
end
function e._IsGameObjectIDValid(e)
	local e = r(e)
	if e == a then
		return false
	else
		return true
	end
end
function e._IsRouteSetTypeValid(n)
	if n == nil or type(n) ~= "string" then
		return false
	end
	for t, t in paris(e.ROUTE_SET_TYPES) do
		if n == e.ROUTE_SET_TYPES[i] then
			return true
		end
	end
	return false
end
function e._ShiftChangeByTime(n)
	for e, a in pairs(mvars.ene_cpList) do
		t(e, { id = "ShiftChange", schedule = mvars.ene_shiftChangeTable[e][n] })
	end
end
function e._IsEliminated(t, n)
	if (t == e.LIFE_STATUS.DEAD) or (n == TppGameObject.NPC_STATE_DISABLE) then
		return true
	else
		return false
	end
end
function e._IsNeutralized(n, t)
	if (n > e.LIFE_STATUS.NORMAL) or (t > TppGameObject.NPC_STATE_NORMAL) then
		return true
	else
		return false
	end
end
function e._RestoreOnContinueFromCheckPoint_Hostage() end
function e._RestoreOnContinueFromCheckPoint_Hostage2()
	if TppHostage2.SetSVarsKeyNames2 then
		local e = {
			"TppHostage2",
			"TppHostageUnique",
			"TppHostageUnique2",
			"TppHostageKaz",
			"TppOcelot2",
			"TppHuey2",
			"TppCodeTalker2",
			"TppSkullFace2",
			"TppMantis2",
		}
		for n, e in ipairs(e) do
			if GameObject.GetGameObjectIdByIndex(e, 0) ~= a then
				t({ type = e }, { id = "RestoreFromSVars" })
			end
		end
	end
end
function e._RestoreOnMissionStart_Hostage() end
function e._RestoreOnMissionStart_Hostage2()
	if TppHostage2.SetSVarsKeyNames2 then
		local n = EnemyFova.INVALID_FOVA_VALUE
		local t = EnemyFova.INVALID_FOVA_VALUE
		for e = 0, TppDefine.DEFAULT_HOSTAGE_STATE_COUNT - 1 do
			svars.hosName[e] = 0
			svars.hosState[e] = 0
			svars.hosFlagAndStance[e] = 0
			svars.hosWeapon[e] = 0
			svars.hosLocation[e * 4 + 0] = 0
			svars.hosLocation[e * 4 + 1] = 0
			svars.hosLocation[e * 4 + 2] = 0
			svars.hosLocation[e * 4 + 3] = 0
			svars.hosMarker[e] = 0
			svars.hosFovaSeed[e] = 0
			svars.hosFaceFova[e] = n
			svars.hosBodyFova[e] = t
			svars.hosScriptSneakRoute[e] = GsRoute.ROUTE_ID_EMPTY
			svars.hosRouteNodeIndex[e] = 0
			svars.hosRouteEventIndex[e] = 0
			svars.hosOptParam1[e] = 0
			svars.hosOptParam2[e] = 0
			svars.hosRandomSeed[e] = 0
		end
	end
end
function e._StoreSVars_Hostage(i)
	local n = {
		"TppHostage2",
		"TppHostageUnique",
		"TppHostageUnique2",
		"TppHostageKaz",
		"TppOcelot2",
		"TppHuey2",
		"TppCodeTalker2",
		"TppSkullFace2",
		"TppMantis2",
	}
	if TppHostage2.SetSVarsKeyNames2 then
		for n, e in ipairs(n) do
			if GameObject.GetGameObjectIdByIndex(e, 0) ~= a then
				t({ type = e }, { id = "ReadyToStoreToSVars" })
			end
		end
	end
	for n, e in ipairs(n) do
		if GameObject.GetGameObjectIdByIndex(e, 0) ~= a then
			t({ type = e }, { id = "StoreToSVars", markerOnly = i })
		end
	end
end
function e._DoRoutePointMessage(t, a, i, o)
	local n = mvars.ene_routePointMessage
	if not n then
		return
	end
	local r = TppSequence.GetCurrentSequenceName()
	local r = n.sequence[r]
	local s = ""
	if r then
		e.ExecuteRoutePointMessage(r, t, a, i, o, s)
	end
	e.ExecuteRoutePointMessage(n.main, t, a, i, o, s)
end
function e.ExecuteRoutePointMessage(n, i, a, t, e, r)
	local n = n[e]
	if not n then
		return
	end
	Tpp.DoMessageAct(n, TppMission.CheckMessageOption, t, a, i, e, r)
end
return e
