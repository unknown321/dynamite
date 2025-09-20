local a = {}
local p = {}
p[TppDefine.LOCATION_ID.INIT] = { "/Assets/tpptest/pack/location/empty/empty.fpk" }
p[TppDefine.LOCATION_ID.AFGH] = { "/Assets/tpp/pack/location/afgh/afgh.fpk" }
p[TppDefine.LOCATION_ID.MAFR] = { "/Assets/tpp/pack/location/mafr/mafr.fpk" }
p[TppDefine.LOCATION_ID.CYPR] = { "/Assets/tpp/pack/location/cypr/cypr.fpk" }
p[TppDefine.LOCATION_ID.GNTN] = { "/Assets/tpp/pack/location/gntn/gntn.fpk" }
p[TppDefine.LOCATION_ID.OMBS] = { "/Assets/tpp/pack/location/ombs/ombs.fpk" }
p[TppDefine.LOCATION_ID.MTBS] = { "/Assets/tpp/pack/location/mtbs/mtbs.fpk" }
p[TppDefine.LOCATION_ID.HLSP] = { "/Assets/tpp/pack/location/hlsp/hlsp.fpk" }
p[TppDefine.LOCATION_ID.MBQF] = { "/Assets/tpp/pack/location/mbqf/mbqf.fpk" }
p[TppDefine.LOCATION_ID.FLYK] = { "/Assets/tpp/pack/location/flyk/flyk.fpk" }
p[TppDefine.LOCATION_ID.SAND_AFGH] = { "/Assets/tpp_sandbox/pack/game_core/stage/gc_afgh.fpk" }
p[TppDefine.LOCATION_ID.SAND_MAFR] = { "/Assets/tpp/pack/location/mafr/mafr.fpk" }
p[TppDefine.LOCATION_ID.SAND_MTBS] = { "/Assets/tpp_sandbox/pack/game_core/stage/gc_mtbs.fpk" }
local s = {}
s[1] = { "/Assets/tpp/pack/ui/gz/gz_pause_key_setting_data.fpk", "/Assets/tpp/pack/mission2/init/init.fpk" }
s[5] = function(p)
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/init/title.fpk")
end
s[10010] = function(p)
	if TppPackList.IsMissionPackLabel("afterMissionClearMovie") then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_SCRIPT)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10010/s10010_l02.fpk")
	else
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddLocationCommonScriptPack(p)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10010/s10010_l01.fpk")
		TppHostage2.SetHostageType({ gameObjectType = "TppHostageUnique", hostageType = "Ishmael" })
		if TppHostage2.SetHostageType then
			TppHostage2.SetHostageType({ gameObjectType = "TppHostage2", hostageType = "MobCyprus" })
			TppHostage2.SetHostageType({ gameObjectType = "TppHostageUnique2", hostageType = "MobCyprus" })
		end
		if TppHostage2.SetUniquePartsPath then
			local s = {
				awake_doctor = "/Assets/tpp/parts/chara/dct/dct1_main0_def_v00.parts",
				dct_p21_010410_0000 = "/Assets/tpp/parts/chara/dct/dct0_main0_def_v00.parts",
				dct_p21_010410_0001 = "/Assets/tpp/parts/chara/dct/dct0_main0_def_v00.parts",
				awake_nurse = "/Assets/tpp/parts/chara/nrs/nrs2_main0_def_v00.parts",
				nrs_p21_010360_0000 = "/Assets/tpp/parts/chara/nrs/nrs0_main0_def_v00.parts",
				nrs_p21_010410_0000 = "/Assets/tpp/parts/chara/nrs/nrs0_main0_def_v00.parts",
				nrs_p21_010410_0001 = "/Assets/tpp/parts/chara/nrs/nrs0_main0_def_v00.parts",
				nrs_p21_010410_0002 = "/Assets/tpp/parts/chara/nrs/nrs0_main0_def_v00.parts",
			}
			for p, s in pairs(s) do
				TppHostage2.SetUniquePartsPath({ gameObjectType = "TppHostageUnique2", locatorName = p, parts = s })
			end
			local s = { ish_p21_010410_0000 = "/Assets/tpp/parts/chara/ish/ish0_main0_def_v00.parts" }
			for p, s in pairs(s) do
				TppHostage2.SetUniquePartsPath({ gameObjectType = "TppHostage2", locatorName = p, parts = s })
			end
		end
		local s = { { 636, 0, 0, 1 } }
		local p = {
			{ 300, 1 },
			{ 301, 1 },
			{ 302, 1 },
			{ 303, 1 },
			{ 304, 1 },
			{ 305, 1 },
			{ 306, 1 },
			{ 307, 1 },
			{ 308, 1 },
			{ 309, 1 },
			{ 310, 1 },
			{ 311, 1 },
			{ 312, 1 },
			{ 313, 1 },
			{ 314, 1 },
			{ 315, 1 },
			{ 316, 1 },
			{ 317, 1 },
			{ 318, 1 },
			{ 319, 1 },
			{ 320, 1 },
			{ 321, 1 },
			{ 322, 1 },
			{ 323, 1 },
			{ 324, 1 },
			{ 325, 1 },
			{ 326, 1 },
			{ 327, 1 },
			{ 328, 1 },
			{ 329, 1 },
			{ 330, 1 },
			{ 331, 1 },
			{ 332, 1 },
			{ 333, 1 },
			{ 334, 1 },
			{ 337, 1 },
			{ 338, 1 },
			{ 339, 1 },
			{ 340, 1 },
			{ 341, 1 },
			{ 342, 1 },
			{ 343, 1 },
			{ 344, 1 },
			{ 345, 1 },
			{ 346, 1 },
			{ 347, 1 },
			{ 348, 1 },
			{ 349, 1 },
			{ 380, 1 },
			{ 381, 1 },
		}
		TppEneFova.AddUniquePackage({ type = "hostage", face = s, body = p })
	end
end
s[10020] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	if TppPackList.IsMissionPackLabel("afterMissionClearMovie") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10020/s10020_area02.fpk")
	else
		TppPackList.AddLocationCommonMissionAreaPack(p)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TRUCK)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TRUCK_MATERIAL)
		TppPackList.AddDefaultMissionAreaPack(p)
		local s = { { TppEnemyBodyId.oce0_main0_v00, 1 }, { TppEnemyBodyId.oce0_main0_v01, 1 } }
		TppEneFova.AddUniquePackage({ type = "hostage", body = s })
		do
			local s = "sol_enemyBase_0014"
			local s = { { type = "enemy", name = s, faceId = 635, bodyId = 273 } }
			TppEneFova.AddUniqueSettingPackage(s)
		end
	end

	vars.missionCode = 10020
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10030] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_WAIT)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.OCELOT)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MILLER)
	TppPackList.AddDefaultMissionAreaPack(p)
	local p = { { TppEnemyBodyId.oce0_main0_v00, 1 } }
	TppEneFova.AddUniquePackage({ type = "hostage", body = p })
end
s[10033] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "hos_s10033_0000"
		local s = { { type = "hostage", name = s, faceId = 602, bodyId = 110 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10033
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10036] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "sol_vip_0000"
		local s = { { type = "enemy", name = s, faceId = 600, bodyId = TppEnemyBodyId.svs0_unq_v010 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10036
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10040] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local a = "sol_s10040_0000"
		local p = "sol_s10040_0001"
		local s = "sol_s10040_0002"
		local s = {
			{ type = "enemy", name = a, faceId = 603, bodyId = TppEnemyBodyId.svs0_unq_v040 },
			{ type = "enemy", name = p, faceId = 604, bodyId = TppEnemyBodyId.svs0_unq_v050 },
			{ type = "enemy", name = s, faceId = 605, bodyId = TppEnemyBodyId.svs0_unq_v060 },
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10040
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10041] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local a = "sol_vip_field"
		local p = "sol_vip_village"
		local s = "sol_vip_enemyBase"
		local s = {
			{ type = "enemy", name = a, faceId = 637, bodyId = 268 },
			{ type = "enemy", name = p, faceId = 638, bodyId = 269 },
			{ type = "enemy", name = s, faceId = 639, bodyId = 270 },
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10041
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10043] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TRUCK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TRUCK_MATERIAL)
	TppPackList.AddDefaultMissionAreaPack(p)

	vars.missionCode = 10043
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10044] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TRUCK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_WAV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = { { 606, 1, 1, 0 } }
		local p = { { 258, 1 }, { TppEnemyBodyId.svs0_unq_v080, 1 } }
		if TppSoldierFace.OverwriteMissionFovaData ~= nil then
			TppSoldierFace.OverwriteMissionFovaData({ face = s, body = p })
		end
	end

	vars.missionCode = 10044
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10052] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_WAV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local p = "hos_target_0000"
		local s = "sol_s10052_transportVehicle_0000"
		local s = {
			{ type = "hostage", name = p, faceId = 607, bodyId = 200 },
			{
				type = "enemy",
				name = s,
				faceId = 608,
				bodyId = 263,
			},
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10052
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10054] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
	TppPackList.AddMissionPack(TppHelicopter.GetEnemyColoringPack(TppDefine.ENEMY_HELI_COLORING_TYPE.BLACK))
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TRUCK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TRUCK_AMMUNITION)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TRUCK_MATERIAL)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TANK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_WAV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_WAV_ROCKET)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local p = "hos_s10054_0002"
		local s = "hos_s10054_0004"
		local s = {
			{ type = "hostage", name = p, faceId = "female", bodyId = 113 },
			{ type = "hostage", name = s, faceId = "female", bodyId = 113 },
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10054
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10070] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	if TppPackList.IsMissionPackLabel("beforeMotherBaseDemo") then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.OCELOT)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MILLER)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HUEY)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10070/s10070_area04.fpk")
	elseif TppPackList.IsMissionPackLabel("beforeSahelanAttackDemo") then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HUEY)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.SAHELAN)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WALKERGEAR)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MANTIS)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10070/s10070_area03.fpk")
	elseif TppPackList.IsMissionPackLabel("afterSahelanTestDemo") then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_MISSION_AREA)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WALKERGEAR)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_DECOY)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10070/s10070_area02.fpk")
	else
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HUEY)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.SKULLFACE)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TRUCK)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WALKERGEAR)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10070/s10070_area01.fpk")
	end

	vars.missionCode = 10070
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10080] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	if TppPackList.IsMissionPackLabel("afterPumpStopDemo") then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WALKERGEAR)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10080/s10080_area02.fpk")
	else
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10080/s10080_area01.fpk")
	end

	vars.missionCode = 10080
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10086] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE_WOMAN)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "hos_mis_0000"
		local a = "hos_mis_0001"
		local p = "hos_mis_0002"
		local e = "hos_mis_0003"
		local t = "sol_interpreter"
		local i = "sol_interrogator"
		local s = {
			{ type = "hostage", name = s, faceId = 610, bodyId = 111 },
			{ type = "hostage", name = a, faceId = 611, bodyId = 111 },
			{ type = "hostage", name = p, faceId = 612, bodyId = 111 },
			{ type = "hostage", name = e, faceId = "female", bodyId = 113 },
			{ type = "enemy", name = t, faceId = 609, bodyId = 255 },
			{ type = "enemy", name = i, faceId = 629, bodyId = TppEnemyBodyId.pfs0_unq_v155 },
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10086
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10082] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WALKERGEAR)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TRUCK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TRUCK_ITEMBOX)
	TppPackList.AddDefaultMissionAreaPack(p)

	vars.missionCode = 10082
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10090] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TRUCK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TRUCK_HOOD)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV_CANNON)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV_MACHINE_GUN)
	TppPackList.AddDefaultMissionAreaPack(p)

	vars.missionCode = 10090
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10121] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TRUCK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_LV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WALKERGEAR)
	TppPackList.AddMissionPack(TppHelicopter.GetEnemyColoringPack(TppDefine.ENEMY_HELI_COLORING_TYPE.BLACK))
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local p = "sol_pfCamp_vip_0001"
		local s = "sol_pfCamp_vip_guard"
		local s = {
			{ type = "enemy", name = p, faceId = 617, bodyId = TppEnemyBodyId.pfa0_v00_b },
			{ type = "enemy", name = s, faceId = 618, bodyId = 254 },
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10121
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10091] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.RAVEN)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.JACKAL)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TRUCK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TRUCK_CONTAINER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_LV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = {
			{ type = "hostage", name = "hos_s10091_0001", faceId = "dd", bodyId = 176 },
			{ type = "hostage", name = "hos_s10091_0000", faceId = "dd", bodyId = 143 },
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10091
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10100] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV_CANNON)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_DECOY)
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/mis_com_mafr.fpk")
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local o = "sol_target_0000"
		local s = EnemyFova.INVALID_FOVA_VALUE
		local e = "hos_diamond_0000"
		local t = "hos_diamond_0001"
		local a = "hos_diamond_0002"
		local i = "hos_diamond_0003"
		local p = "hos_diamond_0004"
		local s = {
			{ type = "enemy", name = o, faceId = 616, bodyId = 251 },
			{ type = "hostage", name = e, faceId = s, bodyId = 130 },
			{ type = "hostage", name = t, faceId = s, bodyId = 131 },
			{ type = "hostage", name = a, faceId = s, bodyId = 132 },
			{ type = "hostage", name = i, faceId = s, bodyId = 133 },
			{ type = "hostage", name = p, faceId = s, bodyId = 134 },
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end
	TppHostage2.SetHostageType({ gameObjectType = "TppHostageUnique", hostageType = "MovingChild" })

	vars.missionCode = 10100
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10110] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_LV)
	if TppPackList.IsMissionPackLabel("AfterVolginDemo") then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MANTIS)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.VOLGIN)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10110/s10110_area02.fpk")
	else
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_MISSION_AREA)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.RAVEN)
		TppPackList.AddDefaultMissionAreaPack(p)
	end
	TppHostage2.SetHostageType({ gameObjectType = "TppHostageUnique", hostageType = "Naedoko" })
	TppHostage2.SetUniquePartsPath({
		gameObjectType = "TppHostageUnique",
		locatorName = "TppHostage2GameObjectLocator",
		parts = "/Assets/tpp/parts/chara/plh/plh3_main0_def_v00.parts",
	})
	TppHostage2.SetUniquePartsPath({
		gameObjectType = "TppHostageUnique",
		locatorName = "TppHostage2GameObjectLocator0000",
		parts = "/Assets/tpp/parts/chara/plh/plh2_main0_def_v00.parts",
	})
	local p = {
		"TppHostage2GameObjectLocator0001",
		"TppHostage2GameObjectLocator0002",
		"TppHostage2GameObjectLocator0003",
		"TppHostage2GameObjectLocator0004",
		"TppHostage2GameObjectLocator0005",
		"TppHostage2GameObjectLocator0006",
		"TppHostage2GameObjectLocator0007",
		"TppHostage2GameObjectLocator0008",
		"TppHostage2GameObjectLocator0009",
		"TppHostage2GameObjectLocator0010",
	}
	for p, s in ipairs(p) do
		TppHostage2.SetUniquePartsPath({
			gameObjectType = "TppHostageUnique",
			locatorName = s,
			parts = "/Assets/tpp/parts/chara/plh/plh0_main0_def_v00.parts",
		})
	end

	vars.missionCode = 10110
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10195] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_LV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "sol_dealer"
		local p = "sol_vip"
		local s = {
			{ type = "enemy", name = s, faceId = 614, bodyId = 250 },
			{
				type = "enemy",
				name = p,
				faceId = 615,
				bodyId = 256,
			},
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10195
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10115] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddDefaultMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MTBS_DECOY)
	TppPackList.AddFOBLayoutPack(p)
	do
		local a = "hos_s10115_0000"
		local t = "hos_s10115_0001"
		local e = "hos_s10115_0002"
		local i = "hos_s10115_0003"
		local s = "hos_s10115_0004"
		local p = "hos_s10115_0005"
		local s = {
			{ type = "hostage", name = a, faceId = "dd", bodyId = 143 },
			{ type = "hostage", name = t, faceId = "dd", bodyId = 143 },
			{ type = "hostage", name = e, faceId = "dd", bodyId = 143 },
			{ type = "hostage", name = i, faceId = "dd", bodyId = 143 },
			{ type = "hostage", name = s, faceId = "dd", bodyId = 143 },
			{ type = "hostage", name = p, faceId = "dd", bodyId = 143 },
		}
		TppEneFova.AddUniqueSettingPackage(s)
	end
end
s[10120] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.CHILD_SOLDIER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.LIQUID)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE_WOMAN)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "hos_mis_woman"
		local s = { { type = "hostage", name = s, faceId = "female", bodyId = 113 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10120
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10085] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE_WOMAN)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_LV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "hos_target_0000"
		local p = "hos_target_0001"
		local s = { { type = "hostage", name = s, faceId = 642, bodyId = 111 } }
		local p = { { type = "hostage", name = p, faceId = 643, bodyId = 113 } }
		TppEneFova.AddUniqueSettingPackage(s)
		TppEneFova.AddUniqueSettingPackage(p)
	end

	vars.missionCode = 10085
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10211] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_LV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "sol_mis_0000"
		local s = { { type = "enemy", name = s, faceId = 620, bodyId = 253 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10211
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10200] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.CHILD_SOLDIER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_LV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "hos_hillNorth_0000"
		local p = "sol_hillNorth_0004"
		local s = { { type = "hostage", name = s, faceId = 619, bodyId = 201 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10200
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10081] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MAFR_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_LV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TRUCK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TRUCK_ITEMBOX)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "hos_spy"
		local s = { { type = "hostage", name = s, faceId = "dd", bodyId = 201 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10081
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10130] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.CODETALKER)
	TppPackList.AddMissionPack(TppHelicopter.GetEnemyColoringPack(TppDefine.ENEMY_HELI_COLORING_TYPE.BLACK))
	TppPackList.AddMissionPack(TppHelicopter.GetEnemyColoringPack(TppDefine.ENEMY_HELI_COLORING_TYPE.RED))
	if TppPackList.IsMissionPackLabel("CamoParasiteAllKill") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/mis_com_mafr.fpk")
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV_CANNON)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10130/s10130_area02.fpk")
	elseif TppPackList.IsMissionPackLabel("CodeTalkerClearDemo") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10130/s10130_area03.fpk")
	else
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/mis_com_mafr.fpk")
		TppPackList.AddDefaultMissionAreaPack(p)
	end

	vars.missionCode = 10130
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10140] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	if TppPackList.IsMissionPackLabel("MBdemo") then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MILLER)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HUEY)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.OCELOT)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_WAIT)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10140/s10140_area01.fpk")
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/free/f30050/f30050_Buddy.fpk")
	elseif TppPackList.IsMissionPackLabel("AfterClear") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/mis_com_mafr.fpk")
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.OCELOT)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.CODETALKER)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10140/s10140_area00.fpk")
	else
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.CODETALKER)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/mis_com_mafr.fpk")
		TppPackList.AddDefaultMissionAreaPack(p)
	end

	vars.missionCode = 10140
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10150] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.XOF_SOLDIER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack(TppHelicopter.GetEnemyColoringPack(TppDefine.ENEMY_HELI_COLORING_TYPE.BLACK))
	if TppPackList.IsMissionPackLabel("SkullFaceAppearance") then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.SKULLFACE)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10150/s10150_area02.fpk")
	elseif TppPackList.IsMissionPackLabel("StartingSahelan") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10150/s10150_area03.fpk")
	else
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MANTIS)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10150/s10150_area01.fpk")
	end

	vars.missionCode = 10150
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10151] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	if TppPackList.IsMissionPackLabel("OkbEnding") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10151/s10151_area02.fpk")
	else
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10151/s10151_area01.fpk")
	end
	local p = { { 375, 1 }, { 376, 1 } }
	TppEneFova.AddUniquePackage({ type = "hostage", body = p })

	vars.missionCode = 10151
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10045] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WALKERGEAR)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "hos_vip_0000"
		local p = "sol_executioner_0000"
		local s = { { type = "hostage", name = s, faceId = 644, bodyId = 271 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10045
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10156] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.RAVEN)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.AFGH_HOSTAGE)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_LV)
	TppPackList.AddDefaultMissionAreaPack(p)

	vars.missionCode = 10156
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10093] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_LV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
	TppPackList.AddDefaultMissionAreaPack(p)
	do
		local s = "sol_vip_0000"
		local s = { { type = "enemy", name = s, faceId = 649, bodyId = 272 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10093
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10171] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV_MACHINE_GUN)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_WAV_CANNON)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.WEST_TANK)
	TppPackList.AddDefaultMissionAreaPack(p)
	TppPackList.AddMissionPack(TppHelicopter.GetEnemyColoringPack(TppDefine.ENEMY_HELI_COLORING_TYPE.BLACK))
	do
		local s = "sol_pfCamp_vip"
		local s = { { type = "enemy", name = s, faceId = 645, bodyId = 267 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end

	vars.missionCode = 10171
	vars.locationCode = TppDefine.LOCATION_ID.MAFR
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10230] = function(p)
	TppPackList.AddDefaultMissionAreaPack(p)
end
s[10240] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	if TppPackList.IsMissionPackLabel("InQuarantineFacility") then
		TppSoldier2.DisableMarkerModelEffect()
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10240/s10240_area02.fpk")
	else
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_WAIT)
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10240/s10240_area.fpk")
	end

	vars.missionCode = 10240
	vars.locationCode = TppDefine.LOCATION_ID.MBQF
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10050] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.QUIET)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.RAVEN)
	if TppPackList.IsMissionPackLabel("MotherBaseDemo") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/story/s10050/s10050_area01.fpk")
	else
		TppPackList.AddDefaultMissionAreaPack(p)
	end

	vars.missionCode = 10050
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10260] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ENEMY_HELI)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_TANK)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.EAST_WAV)
	TppPackList.AddMissionPack(TppHelicopter.GetEnemyColoringPack(TppDefine.ENEMY_HELI_COLORING_TYPE.BLACK))
	TppPackList.AddDefaultMissionAreaPack(p)

	vars.missionCode = 10260
	vars.locationCode = TppDefine.LOCATION_ID.AFGH
	TppPackList.AddMissionPack("/Assets/tpp/pack/coop/coop_essentials.fpk")
end
s[10280] = s[10010]
s[11043] = s[10043]
s[11041] = s[10041]
s[11054] = s[10054]
s[11085] = s[10085]
s[11082] = s[10082]
s[11090] = s[10090]
s[11036] = s[10036]
s[11033] = s[10033]
s[11050] = s[10050]
s[11091] = s[10091]
s[11195] = s[10195]
s[11211] = s[10211]
s[11140] = s[10140]
s[11200] = s[10200]
s[11080] = s[10080]
s[11171] = s[10171]
s[11121] = s[10121]
s[11115] = s[10115]
s[11130] = s[10130]
s[11044] = s[10044]
s[11052] = s[10052]
s[11151] = s[10151]
s[30010] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ORDER_BOX)
	if TppPackList.IsMissionPackLabel("recoverVolginDemo") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/free/f30010/f30011.fpk")
	else
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/free/f30010/f30010.fpk")
	end
end
s[30020] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddLocationCommonMissionAreaPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.ORDER_BOX)
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/free/f30020/f30020.fpk")
end
s[30050] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MTBS_MISSION_AREA)
	do
		if TppPackList.IsMissionPackLabel("AfterDemo") or TppPackList.IsMissionPackLabel("BattleHanger") then
			TppDemo.SetNextMBDemo(nil)
		else
			if not TppPackList.IsMissionPackLabel("USE_USER_SETTING") and TppDemo.CanUpdateMBDemo() then
				TppDemo.UpdateMBDemo()
				local s = TppDemo.GetMBDemoName()
				if TppDemo.IsQuestStart() and (not TppDemo.IsSortieMBDemo(s)) then
					TppDemo.SetNextMBDemo(nil)
				end
			end
		end
		local a = TppDemo.IsUseMBDemoStage(TppDemo.GetMBDemoName())
		if TppPackList.IsMissionPackLabel("DemoStage") then
			a = true
			TppDemo.SetNextMBDemo(nil)
		end
		if TppPackList.IsMissionPackLabel("BattleHanger") or TppDemo.IsBattleHangerDemo(TppDemo.GetMBDemoName()) then
			local s = string.format(
				"/Assets/tpp/pack/mission2/free/f30050/f30050_hanger_btg%.2d.fpk",
				TppStory.GetBattleGearDevelopLevel()
			)
			TppPackList.AddMissionPack(s)
			do
				local p = 378
				if TppStory.HueyHasKantokuGrass() then
					p = 379
				end
				local s = {}
				table.insert(s, {
					type = "hostage",
					name = "TppHuey2GameObjectLocator",
					faceId = EnemyFova.INVALID_FOVA_VALUE,
					bodyId = p,
				})
				TppEneFova.AddUniqueSettingPackage(s)
			end
			gvars.f30050_missionPackIndex = 2
		elseif a then
			TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/free/f30050/f30051.fpk")
			TppPackList.SetMissionPackLabelName("DemoStage")
			gvars.f30050_missionPackIndex = 1
		else
			do
				TppEneFova.AddUniquePackage({ type = "hostage", body = { { 371, 1 } } })
			end
			TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_WAIT)
			TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/free/f30050/f30050.fpk")
			TppPackList.AddFOBLayoutPack(p)
			gvars.f30050_missionPackIndex = 0
		end
	end
	TppHostage2.SetHostageType({ gameObjectType = "TppHostageUnique", hostageType = "Paz" })
end
s[30150] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/free/f30150/f30150.fpk")
end
s[30250] = function(p)
	TppPackList.AddLocationCommonScriptPack(p)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_WAIT)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/free/f30250/f30250.fpk")
	if TppHostage2.SetHostageType then
		TppHostage2.SetHostageType({ gameObjectType = "TppHostageUnique", hostageType = "Volgin" })
		TppHostage2.SetHostageType({ gameObjectType = "TppHostage2", hostageType = "Parasite" })
	end
	if TppHostage2.SetUniquePartsPath then
		local s = {
			hos_wmu00_0000 = "/Assets/tpp/parts/chara/wmu/wmu0_main0_def_v00.parts",
			hos_wmu00_0001 = "/Assets/tpp/parts/chara/wmu/wmu0_main0_def_v00.parts",
			hos_wmu01_0000 = "/Assets/tpp/parts/chara/wmu/wmu1_main0_def_v00.parts",
			hos_wmu01_0001 = "/Assets/tpp/parts/chara/wmu/wmu1_main0_def_v00.parts",
			hos_wmu03_0000 = "/Assets/tpp/parts/chara/wmu/wmu3_main0_def_v00.parts",
			hos_wmu03_0001 = "/Assets/tpp/parts/chara/wmu/wmu3_main0_def_v00.parts",
		}
		for s, p in pairs(s) do
			TppHostage2.SetUniquePartsPath({ gameObjectType = "TppHostage2", locatorName = s, parts = p })
		end
	end
end
s[40010] = function(p)
	if gvars.ini_isTitleMode then
		TppPackList.SetDefaultMissionPackLabelName()
	end
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/heli/heli_common_script.fpk")
	if TppPackList.IsMissionPackLabel("PS3Store") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/helispace_ps3store.fpk")
	elseif TppPackList.IsMissionPackLabel("avatarEdit") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddAvatarEditPack()
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/heli/h40010/h40010_avatar.fpk")
	else
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/heli/heli_ui.fpk")
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
		TppPackList.AddLocationCommonScriptPack(p)
		TppPackList.AddDefaultMissionAreaPack(p)
	end
	TppHostage2.SetHostageType({ gameObjectType = "TppHostage2", hostageType = "Mob" })
end
s[40020] = function(p)
	if gvars.ini_isTitleMode then
		TppPackList.SetDefaultMissionPackLabelName()
	end
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/heli/heli_common_script.fpk")
	if TppPackList.IsMissionPackLabel("PS3Store") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/helispace_ps3store.fpk")
	elseif TppPackList.IsMissionPackLabel("avatarEdit") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddAvatarEditPack()
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/heli/h40020/h40020_avatar.fpk")
	else
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/heli/heli_ui.fpk")
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
		TppPackList.AddLocationCommonScriptPack(p)
		TppPackList.AddDefaultMissionAreaPack(p)
	end
	TppHostage2.SetHostageType({ gameObjectType = "TppHostage2", hostageType = "Mob" })
end
s[40050] = function(p)
	if gvars.ini_isTitleMode then
		TppPackList.SetDefaultMissionPackLabelName()
	end
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/heli/heli_common_script.fpk")
	if TppPackList.IsMissionPackLabel("PS3Store") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/helispace_ps3store.fpk")
	elseif TppPackList.IsMissionPackLabel("avatarEdit") then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddAvatarEditPack()
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/heli/h40050/h40050_avatar.fpk")
	else
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/common/title_sequence.fpk")
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/heli/heli_ui.fpk")
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
		TppPackList.AddLocationCommonScriptPack(p)
		TppPackList.AddDefaultMissionAreaPack(p)
	end
	TppHostage2.SetHostageType({ gameObjectType = "TppHostage2", hostageType = "Mob" })
end
s[65020] = {
	"/Assets/tpp/pack/show/e3_2014/s65020/s65020_area.fpk",
	"/Assets/tpp/pack/location/afgh/pack_common/afgh_script.fpk",
}
s[65030] = { "/Assets/tpp/pack/show/e3_2014/s65030/s65030_area.fpk" }
s[65050] = { "/Assets/tpp/pack/show/e3_2014/s65050/s65050_area.fpk" }
s[65414] = { "/Assets/tpp/pack/show/gc_2014/s65414/s65414_area.fpk" }
s[65060] = function(p)
	TppPackList.AddMissionPack("/Assets/tpp/pack/show/tgs_2014/s65060/s65060_area.fpk")
	TppPackList.AddLocationCommonScriptPack(p)
	do
		local s = "hos_s65060_0000"
		local s = { { type = "hostage", name = s, faceId = 621, bodyId = 111 } }
		TppEneFova.AddUniqueSettingPackage(s)
	end
end
s[65415] = { "/Assets/tpp/pack/show/tgs_2014/s65415/s65415_area.fpk" }
s[65416] = { "/Assets/tpp/pack/show/tgs_2014/s65416/s65416_area.fpk" }
s[50050] = function(a)
	local i = TppEnemy.GetDDSuit()
	if TppMotherBaseManagement.GetMbsClusterSecurityIsEquipSwimSuit() then
		local p = TppMotherBaseManagement.GetMbsClusterSecuritySwimSuitInfo()
		local s
		if p == TppMotherBaseManagementConst.SWIM_SUIT_TYPE_1 then
			s = TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_SWIM_SUIT
		elseif p == TppMotherBaseManagementConst.SWIM_SUIT_TYPE_2 then
			s = TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_SWIM_SUIT2
		elseif p == TppMotherBaseManagementConst.SWIM_SUIT_TYPE_3 then
			s = TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_SWIM_SUIT3
		end
		TppPackList.AddMissionPack(s)
	elseif i == TppEnemy.FOB_DD_SUIT_SNEAKING then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_SNEAKING)
	elseif i == TppEnemy.FOB_DD_SUIT_BTRDRS then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_BTRDRS)
	elseif i == TppEnemy.FOB_PF_SUIT_ARMOR then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_ARMOR)
	else
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.DD_SOLDIER_ATTACKER)
	end
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.HELICOPTER)
	TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.MTBS_DECOY)
	if TppEnemy.IsHostageEventFOB() then
		TppPackList.AddMissionPack(TppDefine.MISSION_COMMON_PACK.FOB_HOSTAGE)
		do
			local s = {
				{ type = "hostage", name = "hos_o50050_event5_0000", faceId = 621, bodyId = 143 },
				{ type = "hostage", name = "hos_o50050_event5_0001", faceId = 640, bodyId = 143 },
				{ type = "hostage", name = "hos_o50050_event5_0002", faceId = 641, bodyId = 143 },
				{ type = "hostage", name = "hos_o50050_event5_0003", faceId = 646, bodyId = 143 },
			}
			TppEneFova.AddUniqueSettingPackage(s)
		end
	end
	if TppEnemy.IsZombieEventFOB() then
		TppSoldierFace.SetUseZombieFova({ enabled = true })
	end
	if TppEnemy.IsParasiteMetalEventFOB() then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/online/o50050/o50055_parasite_metal.fpk")
	end
	TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/online/o50050/o50050_additional.fpk")
	TppPackList.AddLocationCommonScriptPack(a)
	if TppEnemy.IsSpecialEventFOB() then
		TppPackList.AddMissionPack("/Assets/tpp/pack/mission2/online/o50050/o50055_area.fpk")
	else
		TppPackList.AddDefaultMissionAreaPack(a)
	end
	TppPackList.AddFOBLayoutPack(a)
end
function a.GetLocationPackagePath(a)
	local s = p[a]
	if s then
	end
	TppLocation.SetBuddyBlock(a)
	return s
end
function a.GetMissionPackagePath(p)
	TppPackList.SetUseDdEmblemFova(p)
	local a
	if s[p] == nil then
		a = TppPackList.MakeMissionPackList(p, TppPackList.MakeDefaultMissionPackList)
	elseif Tpp.IsTypeFunc(s[p]) then
		a = TppPackList.MakeMissionPackList(p, s[p])
	elseif Tpp.IsTypeTable(s[p]) then
		a = s[p]
	end
	return a
end
if Mission.SetLocationPackagePathFunc then
	Mission.SetLocationPackagePathFunc(a.GetLocationPackagePath)
end
if Mission.SetMissionPackagePathFunc then
	Mission.SetMissionPackagePathFunc(a.GetMissionPackagePath)
end
function a.IsStartHeliToMB() end
return a
