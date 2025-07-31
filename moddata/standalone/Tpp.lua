local e = {}
local i = Fox.StrCode32
local t = type
local I = GameObject.GetGameObjectId
local d = GameObject.GetTypeIndex
local C = TppGameObject.GAME_OBJECT_TYPE_PLAYER2
local b = TppGameObject.GAME_OBJECT_TYPE_SOLDIER2
local m = TppGameObject.GAME_OBJECT_TYPE_COMMAND_POST2
local n = TppGameObject.GAME_OBJECT_TYPE_HOSTAGE2
local n = TppGameObject.GAME_OBJECT_TYPE_HOSTAGE_UNIQUE
local n = TppGameObject.GAME_OBJECT_TYPE_HOSTAGE_UNIQUE2
local P = TppGameObject.GAME_OBJECT_TYPE_HELI2
local h = TppGameObject.GAME_OBJECT_TYPE_ENEMY_HELI
local A = TppGameObject.GAME_OBJECT_TYPE_HORSE2
local E = TppGameObject.GAME_OBJECT_TYPE_VEHICLE
local G = TppGameObject.GAME_OBJECT_TYPE_WALKERGEAR2
local S = TppGameObject.GAME_OBJECT_TYPE_COMMON_WALKERGEAR2
local M = TppGameObject.GAME_OBJECT_TYPE_VOLGIN2
local O = TppGameObject.GAME_OBJECT_TYPE_MARKER2_LOCATOR
local g = TppGameObject.GAME_OBJECT_TYPE_BOSSQUIET2
local B = TppGameObject.GAME_OBJECT_TYPE_PARASITE2
local L = TppGameObject.GAME_OBJECT_TYPE_SECURITYCAMERA2
local T = TppGameObject.GAME_OBJECT_TYPE_UAV
local c = TppGameMode.GetUserMode
local s = TppGameMode.U_KONAMI_LOGIN
local o = TppNetworkUtil.GetOnlineChallengeTaskVersion
local D = TppGameObject.PHASE_ALERT
local p = GameObject.NULL_ID
local n = bit.bnot
local n, n, n = bit.band, bit.bor, bit.bxor
e.requires = {
	"/Assets/tpp/script/lib/TppDefine.lua",
	"/Assets/tpp/script/lib/TppMath.lua",
	"/Assets/tpp/script/lib/TppSave.lua",
	"/Assets/tpp/script/lib/TppLocation.lua",
	"/Assets/tpp/script/lib/TppSequence.lua",
	"/Assets/tpp/script/lib/TppWeather.lua",
	"/Assets/tpp/script/lib/TppDbgStr32.lua",
	"/Assets/tpp/script/lib/TppDebug.lua",
	"/Assets/tpp/script/lib/TppClock.lua",
	"/Assets/tpp/script/lib/TppUI.lua",
	"/Assets/tpp/script/lib/TppResult.lua",
	"/Assets/tpp/script/lib/TppSound.lua",
	"/Assets/tpp/script/lib/TppTerminal.lua",
	"/Assets/tpp/script/lib/TppMarker.lua",
	"/Assets/tpp/script/lib/TppRadio.lua",
	"/Assets/tpp/script/lib/TppPlayer.lua",
	"/Assets/tpp/script/lib/TppHelicopter.lua",
	"/Assets/tpp/script/lib/TppScriptBlock.lua",
	"/Assets/tpp/script/lib/TppMission.lua",
	"/Assets/tpp/script/lib/TppStory.lua",
	"/Assets/tpp/script/lib/TppDemo.lua",
	"/Assets/tpp/script/lib/TppEnemy.lua",
	"/Assets/tpp/script/lib/TppGeneInter.lua",
	"/Assets/tpp/script/lib/TppInterrogation.lua",
	"/Assets/tpp/script/lib/TppGimmick.lua",
	"/Assets/tpp/script/lib/TppMain.lua",
	"/Assets/tpp/script/lib/TppDemoBlock.lua",
	"/Assets/tpp/script/lib/TppAnimalBlock.lua",
	"/Assets/tpp/script/lib/TppCheckPoint.lua",
	"/Assets/tpp/script/lib/TppPackList.lua",
	"/Assets/tpp/script/lib/TppQuest.lua",
	"/Assets/tpp/script/lib/TppTrap.lua",
	"/Assets/tpp/script/lib/TppReward.lua",
	"/Assets/tpp/script/lib/TppRevenge.lua",
	"/Assets/tpp/script/lib/TppReinforceBlock.lua",
	"/Assets/tpp/script/lib/TppEneFova.lua",
	"/Assets/tpp/script/lib/TppFreeHeliRadio.lua",
	"/Assets/tpp/script/lib/TppHero.lua",
	"/Assets/tpp/script/lib/TppTelop.lua",
	"/Assets/tpp/script/lib/TppRatBird.lua",
	"/Assets/tpp/script/lib/TppMovie.lua",
	"/Assets/tpp/script/lib/TppAnimal.lua",
	"/Assets/tpp/script/lib/TppException.lua",
	"/Assets/tpp/script/lib/TppTutorial.lua",
	"/Assets/tpp/script/lib/TppLandingZone.lua",
	"/Assets/tpp/script/lib/TppCassette.lua",
	"/Assets/tpp/script/lib/TppEmblem.lua",
	"/Assets/tpp/script/lib/TppDevelopFile.lua",
	"/Assets/tpp/script/lib/TppPaz.lua",
	"/Assets/tpp/script/lib/TppRanking.lua",
	"/Assets/tpp/script/lib/TppTrophy.lua",
	"/Assets/tpp/script/lib/TppMbFreeDemo.lua",
	"/Assets/tpp/script/lib/script_loader.lua",
}
function e.IsTypeFunc(e)
	return t(e) == "function"
end
local f = e.IsTypeFunc
function e.IsTypeTable(e)
	return t(e) == "table"
end
local a = e.IsTypeTable
function e.IsTypeString(e)
	return t(e) == "string"
end
local n = e.IsTypeString
function e.IsTypeNumber(e)
	return t(e) == "number"
end
local n = e.IsTypeNumber
function e.Enum(e)
	if e == nil then
		return
	end
	if #e == 0 then
		return e
	end
	for n = 1, #e do
		e[e[n]] = n
	end
	return e
end
function e.IsMaster()
	do
		return true
	end
end
function e.IsQARelease()
	return (Fox.GetDebugLevel() == Fox.DEBUG_LEVEL_QA_RELEASE)
end
function e.SplitString(e, l)
	local t = {}
	local n
	local e = e
	while true do
		n = string.find(e, l)
		if n == nil then
			table.insert(t, e)
			break
		else
			local l = string.sub(e, 0, n - 1)
			table.insert(t, l)
			e = string.sub(e, n + 1)
		end
	end
	return t
end
function e.StrCode32Table(n)
	local r = {}
	for n, l in pairs(n) do
		local n = n
		if t(n) == "string" then
			n = i(n)
		end
		if t(l) == "table" then
			r[n] = e.StrCode32Table(l)
		else
			r[n] = l
		end
	end
	return r
end
function e.ApendArray(e, n)
	for t, n in pairs(n) do
		e[#e + 1] = n
	end
end
function e.MergeTable(l, e, n)
	local n = l
	for e, t in pairs(e) do
		if l[e] == nil then
			n[e] = t
		else
			n[e] = t
		end
	end
	return n
end
function e.IsOnlineMode()
	return (c() == s)
end
function e.IsValidLocalOnlineChallengeTaskVersion()
	return (o() == gvars.localOnlineChallengeTaskVersion)
end
function e.BfsPairs(r)
	local i, n, t = { r }, 1, 1
	local function o(l, e)
		local e, l = e, nil
		while true do
			e, l = next(i[n], e)
			if a(l) then
				t = t + 1
				i[t] = l
			end
			if e then
				return e, l
			else
				n = n + 1
				if n > t then
					return
				end
			end
		end
	end
	return o, r, nil
end
e._DEBUG_svars = {}
e._DEBUG_gvars = {}
function e.MakeMessageExecTable(n)
	if n == nil then
		return
	end
	if next(n) == nil then
		return
	end
	local e = {}
	local T = i("msg")
	local d = i("func")
	local u = i("sender")
	local _ = i("option")
	for n, l in pairs(n) do
		e[n] = e[n] or {}
		for l, r in pairs(l) do
			local l, s, c, o = l, nil, nil, nil
			if f(r) then
				c = r
			elseif a(r) and f(r[d]) then
				l = i(r[T])
				local e = {}
				if (t(r[u]) == "string") or (t(r[u]) == "number") then
					e[1] = r[u]
				elseif a(r[u]) then
					e = r[u]
				end
				s = {}
				for l, e in pairs(e) do
					if t(e) == "string" then
						if n == i("GameObject") then
							s[l] = I(e)
							if msgSndr == p then
							end
						else
							s[l] = i(e)
						end
					elseif t(e) == "number" then
						s[l] = e
					end
				end
				c = r[d]
				o = r[_]
			end
			if c then
				e[n][l] = e[n][l] or {}
				if next(s) ~= nil then
					for r, t in pairs(s) do
						e[n][l].sender = e[n][l].sender or {}
						e[n][l].senderOption = e[n][l].senderOption or {}
						if e[n][l].sender[t] then
						end
						e[n][l].sender[t] = c
						if o and a(o) then
							e[n][l].senderOption[t] = o
						end
					end
				else
					if e[n][l].func then
					end
					e[n][l].func = c
					if o and a(o) then
						e[n][l].option = o
					end
				end
			end
		end
	end
	return e
end
function e.DoMessage(n, p, s, i, o, a, t, l, r)
	if not n then
		return
	end
	local n = n[s]
	if not n then
		return
	end
	local n = n[i]
	if not n then
		return
	end
	local i = true
	e.DoMessageAct(n, p, o, a, t, l, r, i)
end
function e.DoMessageAct(e, i, n, r, l, a, t)
	if e.func then
		if i(e.option) then
			e.func(n, r, l, a)
		end
	end
	local t = e.sender
	if t and t[n] then
		if i(e.senderOption[n]) then
			t[n](n, r, l, a)
		end
	end
end
function e.GetRotationY(e)
	if not e then
		return
	end
	if t(e.Rotate) == "function" then
		local e = e:Rotate(Vector3(0, 0, 1))
		local e = foxmath.Atan2(e:GetX(), e:GetZ())
		return TppMath.RadianToDegree(e)
	end
end
function e.GetLocator(n, t)
	local n, t = e.GetLocatorByTransform(n, t)
	if n ~= nil then
		return TppMath.Vector3toTable(n), e.GetRotationY(t)
	else
		return nil
	end
end
function e.GetLocatorByTransform(t, n)
	local e = e.GetDataWithIdentifier(t, n, "TransformData")
	if e == nil then
		return
	end
	local e = e.worldTransform
	return e.translation, e.rotQuat
end
function e.GetDataWithIdentifier(n, e, t)
	local e = DataIdentifier.GetDataWithIdentifier(n, e)
	if e == NULL then
		return
	end
	if e:IsKindOf(t) == false then
		return
	end
	return e
end
function e.GetDataBodyWithIdentifier(e, t, n)
	local e = DataIdentifier.GetDataBodyWithIdentifier(e, t)
	if e.data == nil then
		return
	end
	if e.data:IsKindOf(n) == false then
		return
	end
	return e
end
function e.SetGameStatus(n)
	if not a(n) then
		return
	end
	local t = n.enable
	local l = n.scriptName
	local e = n.target
	local n = n.except
	if t == nil then
		return
	end
	if e == "all" then
		e = {}
		for n, t in pairs(TppDefine.UI_STATUS_TYPE_ALL) do
			e[n] = t
		end
		for n, t in pairs(TppDefine.GAME_STATUS_TYPE_ALL) do
			e[n] = t
		end
	elseif a(e) then
		e = e
	else
		return
	end
	if a(n) then
		for n, t in pairs(n) do
			e[n] = t
		end
	end
	if t then
		for n, t in pairs(TppDefine.GAME_STATUS_TYPE_ALL) do
			if e[n] then
				TppGameStatus.Reset(l, n)
			end
		end
		for n, t in pairs(TppDefine.UI_STATUS_TYPE_ALL) do
			local t = e[n]
			local e = mvars.ui_unsetUiSetting
			if a(e) and e[n] then
				TppUiStatusManager.UnsetStatus(n, e[n])
			else
				if t then
					TppUiStatusManager.ClearStatus(n)
				end
			end
		end
	else
		for n, t in pairs(TppDefine.UI_STATUS_TYPE_ALL) do
			local e = e[n]
			if e then
				TppUiStatusManager.SetStatus(n, e)
			else
				TppUiStatusManager.ClearStatus(n)
			end
		end
		for n, t in pairs(TppDefine.GAME_STATUS_TYPE_ALL) do
			local e = e[n]
			if e then
				TppGameStatus.Set(l, n)
			end
		end
	end
end
function e.GetAllDisableGameStatusTable()
	local e = {}
	for n, t in pairs(TppDefine.UI_STATUS_TYPE_ALL) do
		e[n] = false
	end
	for n, t in pairs(TppDefine.GAME_STATUS_TYPE_ALL) do
		e[n] = false
	end
	return e
end
function e.GetHelicopterStartExceptGameStatus()
	local e = {}
	e.EquipPanel = false
	e.AnnounceLog = false
	e.HeadMarker = false
	e.WorldMarker = false
	return e
end
local function n(e, n)
	if e == nil then
		return
	end
	if e == p then
		return
	end
	local e = d(e)
	if e == n then
		return true
	else
		return false
	end
end
function e.IsPlayer(e)
	return n(e, C)
end
function e.IsLocalPlayer(e)
	if e == PlayerInfo.GetLocalPlayerIndex() then
		return true
	else
		return false
	end
end
function e.IsSoldier(e)
	return n(e, b)
end
function e.IsCommandPost(e)
	return n(e, m)
end
function e.IsHostage(e)
	if e == nil then
		return
	end
	if e == p then
		return
	end
	local e = d(e)
	return TppDefine.HOSTAGE_GM_TYPE[e]
end
function e.IsVolgin(e)
	return n(e, M)
end
function e.IsHelicopter(e)
	return n(e, P)
end
function e.IsEnemyHelicopter(e)
	return n(e, h)
end
function e.IsHorse(e)
	return n(e, A)
end
function e.IsVehicle(e)
	return n(e, E)
end
function e.IsPlayerWalkerGear(e)
	return n(e, G)
end
function e.IsEnemyWalkerGear(e)
	return n(e, S)
end
function e.IsUav(e)
	return n(e, T)
end
function e.IsFultonContainer(e)
	return n(e, TppGameObject.GAME_OBJECT_TYPE_FULTONABLE_CONTAINER)
end
function e.IsMortar(e)
	return n(e, TppGameObject.GAME_OBJECT_TYPE_MORTAR)
end
function e.IsGatlingGun(e)
	return n(e, TppGameObject.GAME_OBJECT_TYPE_GATLINGGUN)
end
function e.IsMachineGun(e)
	return n(e, TppGameObject.GAME_OBJECT_TYPE_MACHINEGUN)
end
function e.IsFultonableGimmick(e)
	if e == nil then
		return
	end
	if e == p then
		return
	end
	local e = d(e)
	return TppDefine.FULTONABLE_GIMMICK_TYPE[e]
end
function e.GetBuddyTypeFromGameObjectId(e)
	if e == nil then
		return
	end
	if e == p then
		return
	end
	local e = d(e)
	return TppDefine.BUDDY_GM_TYPE_TO_BUDDY_TYPE[e]
end
function e.IsMarkerLocator(e)
	return n(e, O)
end
function e.IsAnimal(e)
	if e == nil then
		return
	end
	if e == p then
		return
	end
	local e = d(e)
	return TppDefine.ANIMAL_GAMEOBJECT_TYPE[e]
end
function e.IsBossQuiet(e)
	return n(e, g)
end
function e.IsParasiteSquad(e)
	return n(e, B)
end
function e.IsSecurityCamera(e)
	return n(e, L)
end
function e.IsGunCamera(e)
	if e == p then
		return false
	end
	local t = { id = "IsGunCamera" }
	local n = false
	n = GameObject.SendCommand(e, t)
	return n
end
function e.IsUAV(e)
	return n(e, T)
end
function e.IncrementPlayData(e)
	if gvars[e] == nil then
		return
	end
	if gvars[e] < TppDefine.MAX_32BIT_UINT then
		gvars[e] = gvars[e] + 1
	end
end
function e.IsNotAlert()
	if vars.playerPhase < D then
		return true
	else
		return false
	end
end
function e.IsPlayerStatusNormal()
	local e = vars
	if e.playerLife > 0 and e.playerStamina > 0 then
		return true
	else
		return false
	end
end
function e.AreaToIndices(e)
	local n, r, l, t = e[1], e[2], e[3], e[4]
	local e = {}
	for n = n, l do
		for t = r, t do
			table.insert(e, { n, t })
		end
	end
	return e
end
function e.CheckBlockArea(e, t, n)
	local a, e, r, l = e[1], e[2], e[3], e[4]
	if (((t >= a) and (t <= r)) and (n >= e)) and (n <= l) then
		return true
	end
	return false
end
function e.FillBlockArea(n, e, t, a, l, r)
	for e = e, a do
		n[e] = n[e] or {}
		for t = t, l do
			n[e][t] = r
		end
	end
end
function e.GetCurrentStageSmallBlockIndex()
	local e = 2
	local n, t = StageBlock.GetCurrentMinimumSmallBlockIndex()
	return (n + e), (t + e)
end
function e.IsLoadedSmallBlock(l, t)
	local n = 4
	local e, r = StageBlock.GetCurrentMinimumSmallBlockIndex()
	local a = e + n
	local n = e + n
	return ((e <= l and a >= l) and r <= t) and n >= t
end
function e.IsLoadedLargeBlock(e)
	local n = i(e)
	local e = StageBlock.GetLoadedLargeBlocks(0)
	for t, e in pairs(e) do
		if e == n then
			return true
		end
	end
	return false
end
function e.GetLoadedLargeBlock()
	local e = StageBlock.GetLoadedLargeBlocks(0)
	for n, e in pairs(e) do
		return e
	end
	return nil
end
function e.GetChunkIndex(t, n)
	local e
	if n then
		e = Chunk.INDEX_MGO
	else
		e = TppDefine.LOCATION_CHUNK_INDEX_TABLE[t]
		if e == nil then
		end
		return e
	end
	return e
end
function e.StartWaitChunkInstallation(n)
	Chunk.PrefetchChunk(n)
	Chunk.SetChunkInstallSpeed(Chunk.INSTALL_SPEED_FAST)
	e.ClearChunkInstallPopupUpdateTime()
end
local l = 1
local n = 0
function e.ShowChunkInstallingPopup(t, r)
	local e = Time.GetFrameTime()
	n = n - e
	if n > 0 then
		return
	end
	n = n + l
	if n < 0 then
		n = 0
	end
	local n = Fox.GetPlatformName()
	local e = Chunk.GetChunkInstallationEta(t)
	if e and n == "PS4" then
		if e > 86400 then
			e = 86400
		end
		TppUiCommand.SetErrorPopupParam(e)
	end
	local e = Chunk.GetChunkInstallationRate(t)
	if e and n == "XboxOne" then
		TppUiCommand.SetErrorPopupParam(e * 1e4, "None", 2)
	end
	local e
	if r then
		e = Popup.TYPE_ONE_CANCEL_BUTTON
	else
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
	end
	TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.NOW_INSTALLING, e)
end
function e.ClearChunkInstallPopupUpdateTime()
	n = 0
end
function e.GetFormatedStorageSizePopupParam(e)
	local n = 1024
	local t = 1024 * n
	local l = 1024 * t
	local a, r, l = e / l, e / t, e / n
	local n = 0
	local t = ""
	if a >= 1 then
		n = a * 100
		t = "G"
	elseif r >= 1 then
		n = r * 100
		t = "M"
	elseif l >= 1 then
		n = l * 100
		t = "K"
	else
		return e, "", 0
	end
	local e = math.ceil(n)
	return e, t, 2
end
function e.PatchDlcCheckCoroutine(r, l, a, e)
	if e == nil then
		e = PatchDlc.PATCH_DLC_TYPE_MGO_DATA
	end
	local n = { [PatchDlc.PATCH_DLC_TYPE_MGO_DATA] = true, [PatchDlc.PATCH_DLC_TYPE_TPP_COMPATIBILITY_DATA] = true }
	if not n[e] then
		Fox.Hungup("Invalid dlc type.")
		return false
	end
	local function n(e) end
	local function t()
		if TppUiCommand.IsShowPopup() then
			TppUiCommand.ErasePopup()
			while TppUiCommand.IsShowPopup() do
				n("waiting popup closed...")
				coroutine.yield()
			end
		end
	end
	local function i()
		while TppSave.IsSaving() do
			n("waiting saving end...")
			coroutine.yield()
		end
	end
	i()
	PatchDlc.StartCheckingPatchDlc(e)
	if PatchDlc.IsCheckingPatchDlc() then
		if not a then
			t()
			local n =
				{ [PatchDlc.PATCH_DLC_TYPE_MGO_DATA] = 5100, [PatchDlc.PATCH_DLC_TYPE_TPP_COMPATIBILITY_DATA] = 5150 }
			local e = n[e]
			TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
			TppUiCommand.ShowErrorPopup(e)
		end
		while PatchDlc.IsCheckingPatchDlc() do
			n("waiting checking PatchDlc end...")
			coroutine.yield()
			TppUI.ShowAccessIconContinue()
		end
	end
	t()
	if PatchDlc.DoesExistPatchDlc(e) then
		if r then
			r()
		end
		return true
	else
		if l then
			l()
		end
		return false
	end
end
function e.IsPatchDlcValidPlatform(e)
	local n = {
		[PatchDlc.PATCH_DLC_TYPE_MGO_DATA] = { Xbox360 = true, PS3 = true, PS4 = true },
		[PatchDlc.PATCH_DLC_TYPE_TPP_COMPATIBILITY_DATA] = { Xbox360 = true, PS3 = true, PS4 = true },
	}
	local e = n[e]
	if not e then
		Fox.Hungup("Invalid dlc type.")
		return false
	end
	local n = Fox.GetPlatformName()
	if e[n] then
		return true
	else
		return false
	end
end
function e.ClearDidCancelPatchDlcDownloadRequest()
	if vars.didCancelPatchDlcDownloadRequest == 1 then
		vars.didCancelPatchDlcDownloadRequest = 0
		vars.isPersonalDirty = 1
		TppSave.CheckAndSavePersonalData()
	end
end
function e.DEBUG_DunmpBlockArea(t, l, e)
	local n = "       "
	for e = 1, e do
		n = n .. string.format("%02d,", e)
	end
	for l = 1, l do
		local n = ""
		for e = 1, e do
			n = n .. string.format("%02d,", t[l][e])
		end
	end
end
function e.DEBUG_DumpTable(r, n)
	if n == nil then
	end
	if t(r) ~= "table" then
		return
	end
	local l = ""
	if n then
		for e = 0, n do
			l = l .. " "
		end
	end
	for r, l in pairs(r) do
		if t(l) == "table" then
			local n = n or 0
			n = n + 1
			e.DEBUG_DumpTable(l, n)
		else
			if t(l) == "number" then
			end
		end
	end
end
function e.DEBUG_Where(e)
	local e = debug.getinfo(e + 1)
	if e then
		return e.short_src .. (":" .. e.currentline)
	end
	return "(unknown)"
end
function e.DEBUG_StrCode32ToString(e)
	if e ~= nil then
		local n
		if TppDbgStr32 then
			n = TppDbgStr32.DEBUG_StrCode32ToString(e)
		end
		if n then
			return n
		else
			if t(e) == "string" then
			end
			return tostring(e)
		end
	else
		return "nil"
	end
end
function e.DEBUG_Fatal(e, e) end
function e.DEBUG_SetPreference(n, t, l)
	local n = Preference.GetPreferenceEntity(n)
	if n == nil then
		return
	end
	if n[t] == nil then
		return
	end
	Command.SetProperty({ entity = n, property = t, value = l })
end
e._requireList = {}
do
	for t, n in ipairs(e.requires) do
		local n = e.SplitString(n, "/")
		local n = string.sub(n[#n], 1, #n[#n] - 4)
		local t = { TppMain = true, TppDemoBlock = true, mafr_luxury_block_list = true }
		if not t[n] then
			e._requireList[#e._requireList + 1] = n
		end
	end
end
return e
