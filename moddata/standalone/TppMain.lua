local e = {}
local s = Tpp.ApendArray
local n = Tpp.DEBUG_StrCode32ToString
local t = Tpp.IsTypeFunc
local i = Tpp.IsTypeTable
local M = TppScriptVars.IsSavingOrLoading
local f = ScriptBlock.UpdateScriptsInScriptBlocks
local m = Mission.GetCurrentMessageResendCount
local a = {}
local p = 0
local c = {}
local o = 0
local T = {}
local u = 0
local n = {}
local n = 0
local d = {}
local h = {}
local r = 0
local S = {}
local P = {}
local l = 0
local function n()
	if QuarkSystem.GetCompilerState() == QuarkSystem.COMPILER_STATE_WAITING_TO_LOAD then
		QuarkSystem.PostRequestToLoad()
		coroutine.yield()
		while QuarkSystem.GetCompilerState() == QuarkSystem.COMPILER_STATE_WAITING_TO_LOAD do
			coroutine.yield()
		end
	end
end
function e.DisableGameStatus()
	TppMission.DisableInGameFlag()
	Tpp.SetGameStatus({ target = "all", enable = false, except = { S_DISABLE_NPC = false }, scriptName = "TppMain.lua" })
end
function e.DisableGameStatusOnGameOverMenu()
	TppMission.DisableInGameFlag()
	Tpp.SetGameStatus({ target = "all", enable = false, scriptName = "TppMain.lua" })
end
function e.EnableGameStatus()
	TppMission.EnableInGameFlag()
	Tpp.SetGameStatus({
		target = {
			S_DISABLE_PLAYER_PAD = true,
			S_DISABLE_TARGET = true,
			S_DISABLE_NPC = true,
			S_DISABLE_NPC_NOTICE = true,
			S_DISABLE_PLAYER_DAMAGE = true,
			S_DISABLE_THROWING = true,
			S_DISABLE_PLACEMENT = true,
		},
		enable = true,
		scriptName = "TppMain.lua",
	})
end
function e.EnableGameStatusForDemo()
	TppDemo.ReserveEnableInGameFlag()
	Tpp.SetGameStatus({
		target = {
			S_DISABLE_PLAYER_PAD = true,
			S_DISABLE_TARGET = true,
			S_DISABLE_NPC = true,
			S_DISABLE_NPC_NOTICE = true,
			S_DISABLE_PLAYER_DAMAGE = true,
			S_DISABLE_THROWING = true,
			S_DISABLE_PLACEMENT = true,
		},
		enable = true,
		scriptName = "TppMain.lua",
	})
end
function e.EnableAllGameStatus()
	TppMission.EnableInGameFlag()
	Tpp.SetGameStatus({ target = "all", enable = true, scriptName = "TppMain.lua" })
end
function e.EnablePlayerPad()
	TppGameStatus.Reset("TppMain.lua", "S_DISABLE_PLAYER_PAD")
end
function e.DisablePlayerPad()
	TppGameStatus.Set("TppMain.lua", "S_DISABLE_PLAYER_PAD")
end
function e.EnablePause()
	TppPause.RegisterPause("TppMain.lua")
end
function e.DisablePause()
	TppPause.UnregisterPause("TppMain.lua")
end
function e.EnableBlackLoading(e)
	TppGameStatus.Set("TppMain.lua", "S_IS_BLACK_LOADING")
	if e then
		TppUI.StartLoadingTips()
	end
end
function e.DisableBlackLoading()
	TppGameStatus.Reset("TppMain.lua", "S_IS_BLACK_LOADING")
	TppUI.FinishLoadingTips()
end

function e.IsCoop(missionCode)
	local coops = {
		10020, -- 1
		10036, -- 3
		10043, -- 4
		10033, -- 5
		10040, -- 6
		10041, -- 7
		10044, -- 8
		10054, -- 9
		10052, -- 10
		10050, -- 11
		10070, -- 12
		10080, -- 13
		10086, -- 14
		10082, -- 15
		10090, -- 16
		10091, -- 17
		10100, -- 18
		10195, -- 19
		10110, -- 20
		10121, -- 21
		10120, -- 23
		10085, -- 24
		10200, -- 25
		10211, -- 26
		10081, -- 27
		10130, -- 28
		10140, -- 29
		10150, -- 30
		10151, -- 31
		10045, -- 32
		10093, -- 35
		10156, -- 38
		10171, -- 41
		10240, -- 43
		10260, -- 45
		10280, -- 46
	}

	for _, value in pairs(coops) do
		if value == missionCode then
			return true
		end
	end

	return false
end

function e.OnAllocate(n)
	-- If you are loading a mission from a checkpoint with already placed marker, game will attempt to restore
	-- that marker through tpp::ui::menu::UiDepend::ActUserMarkerSaveLoad function (not lua).
	-- Combined with co-op hacks, marker restoration will result in a hang.
	-- Markers can be also be loaded during initial game loading, breaking the process.
	-- Therefore, markers are accepted again at the end of TppMain.OnMissionCanStart for coop missions only.
	Dynamite.IgnoreMarkerRequests()

	TppWeather.OnEndMissionPrepareFunction()
	e.DisableGameStatus()
	e.EnablePause()
	TppClock.Stop()
	a = {}
	p = 0
	T = {}
	u = 0
	TppUI.FadeOut(TppUI.FADE_SPEED.FADE_MOMENT, nil, nil)
	TppSave.WaitingAllEnqueuedSaveOnStartMission()
	if TppMission.IsFOBMission(vars.missionCode) then
		TppMission.SetFOBMissionFlag() -- crashes 10033
		TppGameStatus.Set("Mission", "S_IS_ONLINE")
	elseif e.IsCoop(vars.missionCode) then
		if Dynamite.IsHost() then
			Dynamite.CreateHostSession()
		else
			--do nothing, client connects manually after host has finished loading the mission and called TppNetworkUtil.SessionEnableAccept(true)
		end

		TppGameStatus.Set("Mission", "S_IS_ONLINE")
	else
		TppGameStatus.Reset("Mission", "S_IS_ONLINE")
		Dynamite.StopNearestEnemyThread()
		Dynamite.ResetClientSessionState();

		--TppNetworkUtil.SessionDisconnectPreparingMembers() --breaks fob if uncommented
		--TppNetworkUtil.CloseSession() -- breaks fob if uncommented
	end
	Mission.Start()
	TppMission.WaitFinishMissionEndPresentation()
	TppMission.DisableInGameFlag()
	TppException.OnAllocate(n)
	TppClock.OnAllocate(n)
	TppTrap.OnAllocate(n)
	TppCheckPoint.OnAllocate(n)
	TppUI.OnAllocate(n)
	TppDemo.OnAllocate(n)
	TppScriptBlock.OnAllocate(n)
	TppSound.OnAllocate(n)
	TppPlayer.OnAllocate(n)
	TppMission.OnAllocate(n)
	TppTerminal.OnAllocate(n)
	TppEnemy.OnAllocate(n)
	TppRadio.OnAllocate(n)
	TppGimmick.OnAllocate(n)
	TppMarker.OnAllocate(n)
	TppRevenge.OnAllocate(n)
	e.ClearStageBlockMessage()
	TppQuest.OnAllocate(n)
	TppAnimal.OnAllocate(n)
	local function o()
		if TppLocation.IsAfghan() then
			if afgh then
				afgh.OnAllocate()
			end
		elseif TppLocation.IsMiddleAfrica() then
			if mafr then
				mafr.OnAllocate()
			end
		elseif TppLocation.IsCyprus() then
			if cypr then
				cypr.OnAllocate()
			end
		elseif TppLocation.IsMotherBase() then
			if mtbs then
				mtbs.OnAllocate()
			end
		end
	end
	o()
	if n.sequence then
		if f30050_sequence then
			function f30050_sequence.NeedPlayQuietWishGoMission()
				local i = TppQuest.IsCleard("mtbs_q99011")
				local n = not TppDemo.IsPlayedMBEventDemo("QuietWishGoMission")
				local e = TppDemo.GetMBDemoName() == nil
				return (i and n) and e
			end
		end
		if t(n.sequence.MissionPrepare) then
			n.sequence.MissionPrepare()
		end
		if t(n.sequence.OnEndMissionPrepareSequence) then
			TppSequence.SetOnEndMissionPrepareFunction(n.sequence.OnEndMissionPrepareSequence)
		end
	end
	for n, e in pairs(n) do
		if t(e.OnLoad) then
			e.OnLoad()
		end
	end
	do
		local a = {}
		for i, e in ipairs(Tpp._requireList) do
			if _G[e] then
				if _G[e].DeclareSVars then
					s(a, _G[e].DeclareSVars(n))
				end
			end
		end
		local o = {}
		for n, e in pairs(n) do
			if t(e.DeclareSVars) then
				s(o, e.DeclareSVars())
			end
			if i(e.saveVarsList) then
				s(o, TppSequence.MakeSVarsTable(e.saveVarsList))
			end
		end
		if OnlineChallengeTask then
			s(o, OnlineChallengeTask.DeclareSVars())
		end
		s(a, o)
		TppScriptVars.DeclareSVars(a)
		TppScriptVars.SetSVarsNotificationEnabled(false)
		while M() do
			coroutine.yield()
		end
		TppRadioCommand.SetScriptDeclVars()
		local t = vars.mbLayoutCode
		if gvars.ini_isTitleMode then
			TppPlayer.MissionStartPlayerTypeSetting()
		else
			if TppMission.IsMissionStart() then
				TppVarInit.InitializeForNewMission(n)
				TppPlayer.MissionStartPlayerTypeSetting()
				if not TppMission.IsFOBMission(vars.missionCode) then
					TppSave.VarSave(vars.missionCode, true)
				end
			else
				TppVarInit.InitializeForContinue(n)
			end
			TppVarInit.ClearIsContinueFromTitle()
		end
		TppUiCommand.ExcludeNonPermissionContents()
		TppStory.SetMissionClearedS10030()
		if not TppMission.IsDefiniteMissionClear() then
			TppTerminal.StartSyncMbManagementOnMissionStart()
		end
		if TppLocation.IsMotherBase() then
			if t ~= vars.mbLayoutCode then
				if vars.missionCode == 30050 then
					vars.mbLayoutCode = t
				else
					vars.mbLayoutCode = TppLocation.ModifyMbsLayoutCode(TppMotherBaseManagement.GetMbsTopologyType())
				end
			end
		end
		TppPlayer.FailSafeInitialPositionForFreePlay()
		e.StageBlockCurrentPosition(true)
		TppMission.SetSortieBuddy()
		if vars.missionCode ~= 10260 then
			TppMission.ResetQuietEquipIfUndevelop()
		end
		TppStory.UpdateStorySequence({ updateTiming = "BeforeBuddyBlockLoad" })
		if n.sequence then
			local e = n.sequence.DISABLE_BUDDY_TYPE
			if e then
				local n
				if i(e) then
					n = e
				else
					n = { e }
				end
				for n, e in ipairs(n) do
					TppBuddyService.SetDisableBuddyType(e)
				end
			end
		end
		if (vars.missionCode == 11043) or (vars.missionCode == 11044) then
			TppBuddyService.SetDisableAllBuddy()
		end
		if TppGameSequence.GetGameTitleName() == "TPP" then
			if n.sequence and n.sequence.OnBuddyBlockLoad then
				n.sequence.OnBuddyBlockLoad()
			end
			if TppLocation.IsAfghan() or TppLocation.IsMiddleAfrica() then
				TppBuddy2BlockController.Load()
			end
		end
		TppSequence.SaveMissionStartSequence()
		TppScriptVars.SetSVarsNotificationEnabled(true)
	end
	if n.enemy then
		if i(n.enemy.soldierPowerSettings) then
			TppEnemy.SetUpPowerSettings(n.enemy.soldierPowerSettings)
		end
	end
	TppRevenge.DecideRevenge(n)
	if TppEquip.CreateEquipMissionBlockGroup then
		if vars.missionCode > 6e4 then
			TppEquip.CreateEquipMissionBlockGroup({ size = (380 * 1024) * 24 })
		else
			TppPlayer.SetEquipMissionBlockGroupSize()
		end
	end
	if TppEquip.CreateEquipGhostBlockGroups then
		if TppSystemUtility.GetCurrentGameMode() == "MGO" then
			TppEquip.CreateEquipGhostBlockGroups({ ghostCount = 16 })
		elseif TppMission.IsFOBMission(vars.missionCode) then
			TppEquip.CreateEquipGhostBlockGroups({ ghostCount = 1 })
		end
	end

	if e.IsCoop(vars.missionCode) then
		TppPlayer.SetEquipMissionBlockGroupSize()
		TppEquip.CreateEquipGhostBlockGroups({ ghostCount = 1 })
	end

	TppEquip.StartLoadingToEquipMissionBlock()
	TppPlayer.SetMaxPickableLocatorCount()
	TppPlayer.SetMaxPlacedLocatorCount()
	TppEquip.AllocInstances({ instance = 60, realize = 60 })
	TppEquip.ActivateEquipSystem()
	if TppEnemy.IsRequiredToLoadDefaultSoldier2CommonPackage() then
		TppEnemy.LoadSoldier2CommonBlock()
	end
	if n.sequence then
		mvars.mis_baseList = n.sequence.baseList
		TppCheckPoint.RegisterCheckPointList(n.sequence.checkPointList)
	end
	if not TppMission.IsFOBMission(vars.missionCode) then
		TppPlayer.ForceChangePlayerFromOcelot()
	end
end
function e.OnInitialize(n)
	if TppMission.IsFOBMission(vars.missionCode) then
		TppMission.SetFobPlayerStartPoint()
	elseif TppMission.IsNeedSetMissionStartPositionToClusterPosition() then
		TppMission.SetMissionStartPositionMtbsClusterPosition()
		e.StageBlockCurrentPosition(true)
	else
		TppCheckPoint.SetCheckPointPosition()
	end
	if TppEnemy.IsRequiredToLoadSpecialSolider2CommonBlock() then
		TppEnemy.LoadSoldier2CommonBlock()
	end
	if TppMission.IsMissionStart() then
		TppTrap.InitializeVariableTraps()
	else
		TppTrap.RestoreVariableTrapState()
	end
	TppAnimalBlock.InitializeBlockStatus()
	if TppQuestList then
		TppQuest.RegisterQuestList(TppQuestList.questList)
		TppQuest.RegisterQuestPackList(TppQuestList.questPackList)
	end
	TppHelicopter.AdjustBuddyDropPoint()
	if n.sequence then
		local e = n.sequence.NPC_ENTRY_POINT_SETTING
		if i(e) then
			TppEnemy.NPCEntryPointSetting(e)
		end
	end
	TppLandingZone.OverwriteBuddyVehiclePosForALZ()
	if n.enemy then
		if i(n.enemy.vehicleSettings) then
			TppEnemy.SetUpVehicles()
		end
		if t(n.enemy.SpawnVehicleOnInitialize) then
			n.enemy.SpawnVehicleOnInitialize()
		end
		TppReinforceBlock.SetUpReinforceBlock()
	end
	for i, e in pairs(n) do
		if t(e.Messages) then
			n[i]._messageExecTable = Tpp.MakeMessageExecTable(e.Messages())
		end
	end
	if mvars.loc_locationCommonTable then
		mvars.loc_locationCommonTable.OnInitialize()
	end
	TppLandingZone.OnInitialize()
	for i, e in ipairs(Tpp._requireList) do
		if _G[e].Init then
			_G[e].Init(n)
		end
	end
	if OnlineChallengeTask then
		OnlineChallengeTask.Init()
	end
	if n.enemy then
		if GameObject.DoesGameObjectExistWithTypeName("TppSoldier2") then
			GameObject.SendCommand({ type = "TppSoldier2" }, { id = "CreateFaceIdList" })
		end
		if i(n.enemy.soldierDefine) then
			TppEnemy.DefineSoldiers(n.enemy.soldierDefine)
		end
		if n.enemy.InitEnemy and t(n.enemy.InitEnemy) then
			n.enemy.InitEnemy()
		end
		if i(n.enemy.soldierPersonalAbilitySettings) then
			TppEnemy.SetUpPersonalAbilitySettings(n.enemy.soldierPersonalAbilitySettings)
		end
		if i(n.enemy.travelPlans) then
			TppEnemy.SetTravelPlans(n.enemy.travelPlans)
		end
		TppEnemy.SetUpSoldiers()
		if i(n.enemy.soldierDefine) then
			TppEnemy.InitCpGroups()
			TppEnemy.RegistCpGroups(n.enemy.cpGroups)
			TppEnemy.SetCpGroups()
			if mvars.loc_locationGimmickCpConnectTable then
				TppGimmick.SetCommunicateGimmick(mvars.loc_locationGimmickCpConnectTable)
			end
		end
		if i(n.enemy.interrogation) then
			TppInterrogation.InitInterrogation(n.enemy.interrogation)
		end
		if i(n.enemy.useGeneInter) then
			TppInterrogation.AddGeneInter(n.enemy.useGeneInter)
		end
		if i(n.enemy.uniqueInterrogation) then
			TppInterrogation.InitUniqueInterrogation(n.enemy.uniqueInterrogation)
		end
		do
			local e
			if i(n.enemy.routeSets) then
				e = n.enemy.routeSets
				for e, n in pairs(e) do
					if not i(mvars.ene_soldierDefine[e]) then
					end
				end
			end
			if e then
				TppEnemy.RegisterRouteSet(e)
				TppEnemy.MakeShiftChangeTable()
				TppEnemy.SetUpCommandPost()
				TppEnemy.SetUpSwitchRouteFunc()
			end
		end
		if n.enemy.soldierSubTypes then
			TppEnemy.SetUpSoldierSubTypes(n.enemy.soldierSubTypes)
		end
		TppRevenge.SetUpEnemy()
		TppEnemy.ApplyPowerSettingsOnInitialize()
		TppEnemy.ApplyPersonalAbilitySettingsOnInitialize()
		TppEnemy.SetOccasionalChatList()
		TppEneFova.ApplyUniqueSetting()
		if n.enemy.SetUpEnemy and t(n.enemy.SetUpEnemy) then
			n.enemy.SetUpEnemy()
		end
		if TppMission.IsMissionStart() then
			TppEnemy.RestoreOnMissionStart2()
		else
			TppEnemy.RestoreOnContinueFromCheckPoint2()
		end
	end
	if not TppMission.IsMissionStart() then
		TppWeather.RestoreFromSVars()
		if not e.IsCoop(vars.missionCode) then
			TppMarker.RestoreMarkerLocator()
		end
	end
	TppPlayer.RestoreSupplyCbox()
	TppPlayer.RestoreSupportAttack()
	TppTerminal.MakeMessage()
	if n.sequence then
		local e = n.sequence.SetUpRoutes
		if e and t(e) then
			e()
		end
		TppEnemy.RegisterRouteAnimation()
		local e = n.sequence.SetUpLocation
		if e and t(e) then
			e()
		end
	end
	for n, e in pairs(n) do
		if e.OnRestoreSVars then
			e.OnRestoreSVars()
		end
	end
	--TppMission.RestoreShowMissionObjective()
	TppRevenge.SetUpRevengeMine()
	if TppPickable.StartToCreateFromLocators then
		TppPickable.StartToCreateFromLocators()
	end
	if TppPlaced and TppPlaced.StartToCreateFromLocators then
		TppPlaced.StartToCreateFromLocators()
	end
	if TppMission.IsMissionStart() then
		TppRadioCommand.RestoreRadioState()
	else
		TppRadioCommand.RestoreRadioStateContinueFromCheckpoint()
	end
	TppMission.SetPlayRecordClearInfo()
	TppChallengeTask.RequestUpdateAllChecker()
	TppMission.PostMissionOrderBoxPositionToBuddyDog()
	e.SetUpdateFunction(n)
	e.SetMessageFunction(n)
	TppQuest.UpdateActiveQuest()
	TppDevelopFile.OnMissionCanStart()
	if TppMission.GetMissionID() == 30010 or TppMission.GetMissionID() == 30020 then
		if TppQuest.IsActiveQuestHeli() then
			TppEnemy.ReserveQuestHeli()
		end
	end
	TppDemo.UpdateNuclearAbolitionFlag()
	TppQuest.AcquireKeyItemOnMissionStart()
end
function e.SetUpdateFunction(e)
	a = {}
	p = 0
	c = {}
	o = 0
	T = {}
	u = 0
	a = {
		TppMission.Update,
		TppSequence.Update,
		TppSave.Update,
		TppDemo.Update,
		TppPlayer.Update,
		TppMission.UpdateForMissionLoad,
		script_loader.Update,
	}
	p = #a
	for n, e in pairs(e) do
		if t(e.OnUpdate) then
			o = o + 1
			c[o] = e.OnUpdate
		end
	end
end
function e.OnEnterMissionPrepare()
	if TppMission.IsMissionStart() then
		TppScriptBlock.PreloadSettingOnMissionStart()
	end
	TppScriptBlock.ReloadScriptBlock()
end
function e.OnTextureLoadingWaitStart()
	if not TppMission.IsHelicopterSpace(vars.missionCode) then
		StageBlockCurrentPositionSetter.SetEnable(false)
	end
	gvars.canExceptionHandling = true
end
function e.OnMissionStartSaving() end
function e.OnMissionCanStart()
	if TppMission.IsMissionStart() then
		TppWeather.SetDefaultWeatherProbabilities()
		TppWeather.SetDefaultWeatherDurations()
		if (not gvars.ini_isTitleMode) and (not TppMission.IsFOBMission(vars.missionCode)) then
			TppSave.VarSave(nil, true)
		end
	end
	TppLocation.ActivateBlock()
	TppWeather.OnMissionCanStart()
	TppMarker.OnMissionCanStart()
	TppResult.OnMissionCanStart()
	TppQuest.InitializeQuestLoad()
	TppRatBird.OnMissionCanStart()
	TppMission.OnMissionStart()
	if mvars.loc_locationCommonTable then
		mvars.loc_locationCommonTable.OnMissionCanStart()
	end
	TppLandingZone.OnMissionCanStart()
	TppOutOfMissionRangeEffect.Disable(0)
	if TppLocation.IsMiddleAfrica() then
		TppGimmick.MafrRiverPrimSetting()
	end
	if MotherBaseConstructConnector.RefreshGimmicks then
		if vars.locationCode == TppDefine.LOCATION_ID.MTBS then
			MotherBaseConstructConnector.RefreshGimmicks()
		end
	end
	if vars.missionCode == 10240 and TppLocation.IsMBQF() then
		Player.AttachGasMask()
	end
	if vars.missionCode == 10150 then
		local e = TppSequence.GetMissionStartSequenceIndex()
		if (e ~= nil) and (e < TppSequence.GetSequenceIndex("Seq_Game_SkullFaceToPlant")) then
			if svars.mis_objectiveEnable[17] == false then
				Gimmick.ForceResetOfRadioCassetteWithCassette()
			end
		end
	end

	if e.IsCoop(vars.missionCode) then
		Dynamite.AcceptMarkerRequests()
	end
end
function e.OnMissionGameStart(n)
	TppClock.Start()
	if not gvars.ini_isTitleMode then
		PlayRecord.RegistPlayRecord("MISSION_START")
	end
	TppQuest.InitializeQuestActiveStatus()
	if mvars.seq_demoSequneceList[mvars.seq_missionStartSequence] then
		e.EnableGameStatusForDemo()
	else
		e.EnableGameStatus()
	end
	if Player.RequestChickenHeadSound ~= nil then
		Player.RequestChickenHeadSound()
	end
	TppTerminal.OnMissionGameStart()
	if TppSequence.IsLandContinue() then
		TppMission.EnableAlertOutOfMissionAreaIfAlertAreaStart()
	end
	TppSoundDaemon.ResetMute("Telop")
end
function e.ClearStageBlockMessage()
	StageBlock.ClearLargeBlockNameForMessage()
	StageBlock.ClearSmallBlockIndexForMessage()
end
function e.ReservePlayerLoadingPosition(n, s, o, t, i, p, a)
	e.DisableGameStatus()
	if n == TppDefine.MISSION_LOAD_TYPE.MISSION_FINALIZE then
		if t then
			TppHelicopter.ResetMissionStartHelicopterRoute()
			TppPlayer.ResetInitialPosition()
			TppPlayer.ResetMissionStartPosition()
			TppPlayer.ResetNoOrderBoxMissionStartPosition()
			TppMission.ResetIsStartFromHelispace()
			TppMission.ResetIsStartFromFreePlay()
		elseif s then
			if gvars.heli_missionStartRoute ~= 0 then
				TppPlayer.SetStartStatusRideOnHelicopter()
				if mvars.mis_helicopterMissionStartPosition then
					TppPlayer.SetInitialPosition(mvars.mis_helicopterMissionStartPosition, 0)
					TppPlayer.SetMissionStartPosition(mvars.mis_helicopterMissionStartPosition, 0)
				end
			else
				TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
				local e = TppDefine.NO_HELICOPTER_MISSION_START_POSITION[vars.missionCode]
				if e then
					TppPlayer.SetInitialPosition(e, 0)
					TppPlayer.SetMissionStartPosition(e, 0)
				else
					TppPlayer.ResetInitialPosition()
					TppPlayer.ResetMissionStartPosition()
				end
			end
			TppPlayer.ResetNoOrderBoxMissionStartPosition()
			TppMission.SetIsStartFromHelispace()
			TppMission.ResetIsStartFromFreePlay()
		elseif i then
			if TppLocation.IsMotherBase() then
				TppPlayer.SetStartStatusRideOnHelicopter()
			else
				TppPlayer.ResetInitialPosition()
				TppHelicopter.ResetMissionStartHelicopterRoute()
				TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
				TppPlayer.SetMissionStartPositionToCurrentPosition()
			end
			TppPlayer.ResetNoOrderBoxMissionStartPosition()
			TppMission.ResetIsStartFromHelispace()
			TppMission.ResetIsStartFromFreePlay()
			TppLocation.MbFreeSpecialMissionStartSetting(TppMission.GetMissionClearType())
		elseif o and TppLocation.IsMotherBase() then
			if gvars.heli_missionStartRoute ~= 0 then
				TppPlayer.SetStartStatusRideOnHelicopter()
			else
				TppPlayer.ResetInitialPosition()
				TppPlayer.ResetMissionStartPosition()
			end
			TppPlayer.ResetNoOrderBoxMissionStartPosition()
			TppMission.SetIsStartFromHelispace()
			TppMission.ResetIsStartFromFreePlay()
		else
			if o then
				if mvars.mis_orderBoxName then
					TppMission.SetMissionOrderBoxPosition()
					TppPlayer.ResetNoOrderBoxMissionStartPosition()
				else
					TppPlayer.ResetInitialPosition()
					TppPlayer.ResetMissionStartPosition()
					local e = {
						[10020] = { 1449.3460693359, 339.18698120117, 1467.4300537109, -104 },
						[10050] = { -1820.7060546875, 349.78659057617, -146.44400024414, 139 },
						[10070] = { -792.00512695313, 537.3740234375, -1381.4598388672, 136 },
						[10080] = { -439.28802490234, -20.472593307495, 1336.2784423828, -151 },
						[10140] = { 499.91635131836, 13.07358455658, 1135.1315917969, 79 },
						[10150] = { -1732.0286865234, 543.94067382813, -2225.7587890625, 162 },
						[10260] = { -1260.0454101563, 298.75305175781, 1325.6383056641, 51 },
					}
					e[11050] = e[10050]
					e[11080] = e[10080]
					e[11140] = e[10140]
					e[10151] = e[10150]
					e[11151] = e[10150]
					local e = e[vars.missionCode]
					if TppDefine.NO_ORDER_BOX_MISSION_ENUM[tostring(vars.missionCode)] and e then
						TppPlayer.SetNoOrderBoxMissionStartPosition(e, e[4])
					else
						TppPlayer.ResetNoOrderBoxMissionStartPosition()
					end
				end
				local e = TppDefine.NO_ORDER_FIX_HELICOPTER_ROUTE[vars.missionCode]
				if e then
					TppPlayer.SetStartStatusRideOnHelicopter()
					TppMission.SetIsStartFromHelispace()
					TppMission.ResetIsStartFromFreePlay()
				else
					TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
					TppHelicopter.ResetMissionStartHelicopterRoute()
					TppMission.ResetIsStartFromHelispace()
					TppMission.SetIsStartFromFreePlay()
				end
				local e = TppMission.GetMissionClearType()
				TppQuest.SpecialMissionStartSetting(e)
			else
				TppPlayer.ResetInitialPosition()
				TppPlayer.ResetMissionStartPosition()
				TppPlayer.ResetNoOrderBoxMissionStartPosition()
				TppMission.ResetIsStartFromHelispace()
				TppMission.ResetIsStartFromFreePlay()
			end
		end
	elseif n == TppDefine.MISSION_LOAD_TYPE.MISSION_ABORT then
		TppPlayer.ResetInitialPosition()
		TppHelicopter.ResetMissionStartHelicopterRoute()
		TppMission.ResetIsStartFromHelispace()
		TppMission.ResetIsStartFromFreePlay()
		if p then
			if i then
				TppPlayer.SetStartStatus(TppDefine.INITIAL_PLAYER_STATE.ON_FOOT)
				TppHelicopter.ResetMissionStartHelicopterRoute()
				TppPlayer.SetMissionStartPositionToCurrentPosition()
				TppPlayer.ResetNoOrderBoxMissionStartPosition()
			elseif t then
				TppPlayer.ResetMissionStartPosition()
			elseif vars.missionCode ~= 5 then
			end
		else
			if t then
				TppHelicopter.ResetMissionStartHelicopterRoute()
				TppPlayer.ResetInitialPosition()
				TppPlayer.ResetMissionStartPosition()
			elseif i then
				TppMission.SetMissionOrderBoxPosition()
			elseif vars.missionCode ~= 5 then
			end
		end
	elseif n == TppDefine.MISSION_LOAD_TYPE.MISSION_RESTART then
	elseif n == TppDefine.MISSION_LOAD_TYPE.CONTINUE_FROM_CHECK_POINT then
	end
	if s and a then
		Mission.AddLocationFinalizer(function()
			e.StageBlockCurrentPosition()
		end)
	else
		e.StageBlockCurrentPosition()
	end
end
function e.StageBlockCurrentPosition(e)
	if vars.initialPlayerFlag == PlayerFlag.USE_VARS_FOR_INITIAL_POS then
		StageBlockCurrentPositionSetter.SetEnable(true)
		StageBlockCurrentPositionSetter.SetPosition(vars.initialPlayerPosX, vars.initialPlayerPosZ)
	else
		StageBlockCurrentPositionSetter.SetEnable(false)
	end
	if TppMission.IsHelicopterSpace(vars.missionCode) then
		StageBlockCurrentPositionSetter.SetEnable(true)
		StageBlockCurrentPositionSetter.DisablePosition()
		if e then
			while not StageBlock.LargeAndSmallBlocksAreEmpty() do
				coroutine.yield()
			end
		end
	end
end
function e.OnReload(n)
	for i, e in pairs(n) do
		if t(e.OnLoad) then
			e.OnLoad()
		end
		if t(e.Messages) then
			n[i]._messageExecTable = Tpp.MakeMessageExecTable(e.Messages())
		end
	end
	if OnlineChallengeTask then
		OnlineChallengeTask.OnReload()
	end
	if n.enemy then
		if i(n.enemy.routeSets) then
			TppClock.UnregisterClockMessage("ShiftChangeAtNight")
			TppClock.UnregisterClockMessage("ShiftChangeAtMorning")
			TppEnemy.RegisterRouteSet(n.enemy.routeSets)
			TppEnemy.MakeShiftChangeTable()
		end
	end
	for i, e in ipairs(Tpp._requireList) do
		if _G[e].OnReload then
			_G[e].OnReload(n)
		end
	end
	if mvars.loc_locationCommonTable then
		mvars.loc_locationCommonTable.OnReload()
	end
	if n.sequence then
		TppCheckPoint.RegisterCheckPointList(n.sequence.checkPointList)
	end
	e.SetUpdateFunction(n)
	e.SetMessageFunction(n)
end
function e.OnUpdate(e)
	local e
	local i = a
	local n = c
	local e = T
	for e = 1, p do
		i[e]()
	end
	for e = 1, o do
		n[e]()
	end
	f()
end
function e.OnChangeSVars(e, i, n)
	for t, e in ipairs(Tpp._requireList) do
		if _G[e].OnChangeSVars then
			_G[e].OnChangeSVars(i, n)
		end
	end
end
function e.SetMessageFunction(e)
	d = {}
	r = 0
	S = {}
	l = 0
	for n, e in ipairs(Tpp._requireList) do
		if _G[e].OnMessage then
			r = r + 1
			d[r] = _G[e].OnMessage
		end
	end
	for n, i in pairs(e) do
		if e[n]._messageExecTable then
			l = l + 1
			S[l] = e[n]._messageExecTable
		end
	end
end
function e.OnMessage(n, e, i, a, p, t, o)
	local n = mvars
	local s = ""
	local T
	local u = Tpp.DoMessage
	local c = TppMission.CheckMessageOption
	local T = TppDebug
	local T = h
	local T = P
	local T = TppDefine.MESSAGE_GENERATION[e] and TppDefine.MESSAGE_GENERATION[e][i]
	if not T then
		T = TppDefine.DEFAULT_MESSAGE_GENERATION
	end
	local m = m()
	if m < T then
		return Mission.ON_MESSAGE_RESULT_RESEND
	end
	for n = 1, r do
		local s = s
		d[n](e, i, a, p, t, o, s)
	end
	for r = 1, l do
		local n = s
		u(S[r], c, e, i, a, p, t, o, n)
	end
	if OnlineChallengeTask then
		OnlineChallengeTask.OnMessage(e, i, a, p, t, o, s)
	end
	if n.loc_locationCommonTable then
		n.loc_locationCommonTable.OnMessage(e, i, a, p, t, o, s)
	end
	if n.order_box_script then
		n.order_box_script.OnMessage(e, i, a, p, t, o, s)
	end
	if n.animalBlockScript and n.animalBlockScript.OnMessage then
		n.animalBlockScript.OnMessage(e, i, a, p, t, o, s)
	end
end
function e.OnTerminate(e)
	if e.sequence then
		if t(e.sequence.OnTerminate) then
			e.sequence.OnTerminate()
		end
	end

	if TppGameStatus.IsSet("Mission", "S_IS_ONLINE") and e.IsCoop(vars.missionCode) then
		TppGameStatus.Reset("Mission", "S_IS_ONLINE")
		TppNetworkUtil.SessionDisconnectPreparingMembers()
		TppNetworkUtil.CloseSession()
		Dynamite.StopNearestEnemyThread()
		Dynamite.ResetClientSessionState()
	end
end
return e
