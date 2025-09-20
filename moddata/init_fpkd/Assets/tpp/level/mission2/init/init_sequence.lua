local this = {}
local StrCode32 = Fox.StrCode32
local StrCode32Table = Tpp.StrCode32Table
local TimerStart = GkEventTimerManager.Start

local IS_QA_RELEASE
if Fox.GetDebugLevel() == Fox.DEBUG_LEVEL_QA_RELEASE then
	IS_QA_RELEASE = true
end

local sequences = {}

this.SKIP_TEXTURE_LOADING_WAIT = true
this.NO_LOAD_UI_DEFAULT_BLOCK = true
this.NO_RESULT = true

local ERROR_POPUP_ID = {

	INSTALL_DATA_BROKEN = 7001,

	INSTALL_FAILED = 7005,

	INSTALL_NOSPACE = 7006,

	DOWNLOAD_INSTALL_START = 7070,

	DOWNLOAD_INSTALL_CANCEL = 7071,

	DOWNLOAD_INSTALL_NEED_SIGN_IN = 7072,

	DOWNLOAD_INSTALL_INSTALLING = 7073,

	DLC_ERROR_NETWORK = 9020,
}

local function GetInstallSizeMargin()
	local platformName = Fox.GetPlatformName()
	if platformName == "PS3" then
		return 256 * 1024 + 4 * 1024 * 1024 + 64 * 1024 * 1024
	end

	return 0
end

local function DebugPrintState(state)
	if DebugText then
		DebugText.Print(DebugText.NewContext(), tostring(state))
	end
end

local function IsPlaystationFamily()
	local platformName = Fox.GetPlatformName()
	if platformName == "PS3" or platformName == "PS4" then
		return true
	end
	return false
end

local function GetSavingSlotStorySequence()
	local globalSlotForSaving =
		{ TppDefine.SAVE_SLOT.SAVING, TppDefine.SAVE_FILE_INFO[TppScriptVars.CATEGORY_GAME_GLOBAL].slot }
	return TppScriptVars.GetVarValueInSlot(globalSlotForSaving, "gvars", "str_storySequence", 0)
end

local sequenceTime = 0

function this.OnLoad()
	Fox.Log("#### OnLoad ####")

	TppSequence.RegisterSequences({

		"Seq_Demo_Start",

		"Seq_Demo_SelectLanguage",
		"Seq_Demo_ChangeLanguage",
		"Seq_Demo_BrightnessSetting",

		"Seq_Demo_WaitCopyRightLogo",

		"Seq_Demo_SetInitialLanguage",

		"Seq_Demo_SetSavedLanguage",

		"Seq_Demo_SetConsoleLanguage",

		"Seq_Demo_StartCheckNecessaryStorageSpace",
		"Seq_Demo_CheckNecessaryStorageSpace",
		"Seq_Demo_CheckStorageFreeSpaceSize",
		"Seq_Demo_CheckNecessarySaveDataSize",
		"Seq_Demo_CheckNecessaryTrophyInstallationSize",
		"Seq_Error_ShowNecessaryStorageSpaceSize",
		"Seq_Error_CannotGetSaveDataNecessaryStorageSpaceSize",

		"Seq_Demo_CheckInstalled",
		"Seq_Demo_StartInstall",
		"Seq_Demo_CheckInstalledErrorBroken",
		"Seq_Demo_CheckInstalledErrorNoHdd",
		"Seq_Demo_InstallDiscInsertCheck",
		"Seq_Demo_Install",
		"Seq_Demo_InstallFailed",

		"Seq_Demo_DownloadInstall",
		"Seq_Demo_DownloadInstall_SignIn",
		"Seq_Demo_DownloadInstall_Installing",
		"Seq_Demo_DownloadInstall_NeedSignIn",
		"Seq_Demo_DownloadInstall_Cancel",

		"Seq_Demo_GameDiscInsertCheck",

		"Seq_Demo_InstallTrophy",
		"Seq_Error_TrophyInstallFailed",

		"Seq_Demo_ConfirmAutoSave",

		"Seq_Demo_StartSignIn",
		"Seq_Demo_SignIn",
		"Seq_Demo_NotSignIn",
		"Seq_Demo_SelectStorage",
		"Seq_Demo_NoStorageSelected",

		"Seq_Demo_CreateOrLoadSaveData",
		"Seq_Demo_SaveDataError",
		"Seq_Demo_RetryCreateOrLoadSaveData",

		"Seq_Demo_UseBackUpLoadGameSaveData",

		"Seq_Error_WriteSaveDataResultNoSpacePS4",
		"Seq_Error_WriteSaveDataResultNoSpace",
		"Seq_Error_WriteSaveDataResultNoSpaceShowPopUp",
		"Seq_Error_WriteSaveDataResultUnknown",
		"Seq_Error_WriteSaveDataResultInvalidStorage",
		"Seq_Error_LoadSaveDataVersionError",

		"Seq_Demo_LogInKonamiServer",
		"Seq_Demo_CheckDlc",
		"Seq_Demo_ShowDlcError",
		"Seq_Demo_ShowDlcErrorNetwork",
		"Seq_Demo_ShowDlcAnnouncePopup",
		"Seq_Demo_CheckPatchDlcForInvitation",
		"Seq_Demo_CheckPatchDlc",
		"Seq_Demo_CheckMgoInvitation",
		"Seq_Demo_CheckMgoChunkInstallation",
		"Seq_Demo_GoToMgo",
		"Seq_Demo_CheckCompatibilityPatchDlc",
		"Seq_Demo_CheckBootTypeMgo",
		"Seq_Demo_GoToGz",
		"Seq_Demo_CheckBootGz",
		"Seq_Demo_Init",
		"Seq_Demo_StartTitle",
		"Seq_Demo_ShowKonamiAndFoxLogo",
	})
	TppSequence.RegisterSequenceTable(sequences)
end

function this.MissionPrepare()
	local missionName = TppMission.GetMissionName()
	Fox.Log("*** init MissionPrepare ***")
	if TppEquip.IsCommonBlockActive ~= nil then
		while not TppEquip.IsCommonBlockActive() do
			Fox.Log("init_sequence.MissionPrepare(): Wait Loading EquipCommonBlock.")
			coroutine.yield()
		end
	end

	PatchDlc.AllocateMemoryForRequest()

	TppMission.AlwaysMissionCanStart()
end

function this.StartPreTitleSequence()
	local slot = TppDefine.SAVE_FILE_INFO[TppScriptVars.CATEGORY_GAME_GLOBAL].slot
	TppScriptVars.CopySlot(slot, { TppDefine.SAVE_SLOT.SAVING, slot })
	TppScriptVars.LoadVarsFromSlot(
		TppDefine.SAVE_SLOT.GLOBAL,
		TppDefine.VARS_GROUP_GAME_DATA_ON_START_MISSION,
		TppScriptVars.CATEGORY_GAME_GLOBAL
	)

	--	if not TppSave.IsNewGame() then
	--		TppSequence.SetNextSequence("Seq_Demo_ShowKonamiAndFoxLogo")
	--	else

	SplashScreen.Delete(SplashScreen.GetSplashScreenWithName("konamiLogo"))
	SplashScreen.Delete(SplashScreen.GetSplashScreenWithName("kjpLogo"))
	SplashScreen.Delete(SplashScreen.GetSplashScreenWithName("foxLogo"))
	this._StartPreTitleSequence()
	--	end
end

function this._StartPreTitleSequence()
	gvars.canExceptionHandling = false
	TppUiCommand.ErasePopup()
	TppUiCommand.StartPreTitleSequence()
end

function this.IsWindowsEditor()
	if gvars.DEBUG_initMissionToTitle then
		return false
	end
	if (Fox.GetPlatformName() == "Windows") and Editor then
		return true
	else
		return false
	end
end

function this.IsNeedStorageSpaceCheck()
	local platform = Fox.GetPlatformName()
	if platform == "PS3" then
		return true
	else
		return false
	end
end

function this.IsNeedTrophyInstallation()
	local platform = Fox.GetPlatformName()
	if (platform == "PS3") or (platform == "PS4") then
		return true
	else
		return false
	end
end

function this.IsNeedGameInstallation()
	local platform = Fox.GetPlatformName()
	if (platform == "Xbox360") or (platform == "PS3") then
		return true
	else
		return false
	end
end

function this.SelectLanguageAndGoSequence(sequenceName, onEndChangeLanguageFunc)
	mvars.init_afterSelectLanguageSequenceName = sequenceName
	mvars.init_onEndChangeLanguageFunc = onEndChangeLanguageFunc
	mvars.init_afterChangeLanguageSequenceName = nil
	TppSequence.SetNextSequence("Seq_Demo_SelectLanguage")
end

function this.ChangeLanguageAndGoSequence(sequenceName)
	mvars.init_afterChangeLanguageSequenceName = sequenceName
	mvars.init_afterSelectLanguageSequenceName = nil
	mvars.init_onEndChangeLanguageFunc = nil
	TppSequence.SetNextSequence("Seq_Demo_ChangeLanguage")
end

function this.ShowLoadingSaveDataPopUp()
	TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
	TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.LOADING_SAVE_DATA)
end

function this.ShowMakingSaveDataPopUp()
	TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
	TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.MAKE_NEW_SAVE_DATA)
end

sequences.Seq_Demo_Start = {
	OnEnter = function(self)
		TppClock.Stop()
		TppException.isLoadedInitMissionOnSignInUserChanged = nil
		Fox.Log("### Seq_Demo_Start ###")

		if IS_QA_RELEASE or DEBUG then
			if MissionTest and MissionTest.qaReleaseEntryFunction then
				TppSequence.SetNextSequence("Seq_Demo_Init")
				return
			end
		end

		if DEBUG then
			if this.IsWindowsEditor() then
				TppSoundDaemon.LoadRegidentStreamData()
				TppSequence.SetNextSequence("Seq_Demo_CreateOrLoadSaveData")
				return
			end

			if not gvars.DEBUG_initMissionToTitle then
				TppSequence.SetNextSequence("Seq_Demo_CheckInstalled")
				return
			end
		end

		TppSequence.SetNextSequence("Seq_Demo_WaitCopyRightLogo")
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_SelectLanguage = {
	OnEnter = function(self)
		TppUiCommand.ShowLangPopup()
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Now select language ...")
		end
		if not TppUiCommand.IsShowLangPopup() then
			TppSequence.SetNextSequence("Seq_Demo_ChangeLanguage")
		end
	end,
}

sequences.Seq_Demo_ChangeLanguage = {
	OnEnter = function(self)
		TppUiCommand.ChangeLanguage()
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Now wait change language ...")
		end

		TppUI.ShowAccessIconContinue()

		if TppUiCommand.IsChangeLanguage and TppUiCommand.IsChangeLanguage() then
			return
		end

		if mvars.init_afterSelectLanguageSequenceName then
			TppSequence.SetNextSequence("Seq_Demo_BrightnessSetting")
		else
			TppSequence.SetNextSequence(mvars.init_afterChangeLanguageSequenceName)
		end
	end,
}

sequences.Seq_Demo_BrightnessSetting = {
	OnEnter = function(self)
		TppUiCommand.OpenBrightnessSetting()
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Now wait brightness setting end...")
		end

		if not TppUiCommand.IsEndBrightnessSetting() then
			return
		end

		if mvars.init_onEndChangeLanguageFunc then
			mvars.init_onEndChangeLanguageFunc()
		end

		TppSequence.SetNextSequence(mvars.init_afterSelectLanguageSequenceName)
	end,
}

sequences.Seq_Demo_WaitCopyRightLogo = {
	OnUpdate = function(self)
		local screen = SplashScreen.GetSplashScreenWithName("cesa")
		if not screen then
			local konamiLogoScreenId = SplashScreen.Create(
				"konamiLogo",
				"/Assets/tpp/ui/ModelAsset/sys_logo/Pictures/common_konami_logo_clp_nmp.ftex",
				640,
				640
			)

			local kjpLogoScreenId = SplashScreen.Create(
				"kjpLogo",
				"/Assets/tpp/ui/ModelAsset/sys_logo/Pictures/common_kjp_logo_clp_nmp.ftex",
				640,
				640
			)

			local foxLogoScreenId = SplashScreen.Create(
				"foxLogo",
				"/Assets/tpp/ui/ModelAsset/sys_logo/Pictures/common_fox_logo_clp_nmp.ftex",
				640,
				640
			)

			TppSequence.SetNextSequence("Seq_Demo_SetInitialLanguage")
		else
			if DebugText then
				local context = DebugText.NewContext()
				DebugText.Print(context, "Waiting CesaCopyRightLogo ...")
			end
		end
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_SetInitialLanguage = {
	OnEnter = function(self)
		local platform = Fox.GetPlatformName()
		if platform == "XboxOne" or platform == "Xbox360" then
			TppSequence.SetNextSequence("Seq_Demo_SetConsoleLanguage")
		else
			TppSequence.SetNextSequence("Seq_Demo_SetSavedLanguage")
		end
	end,
}

this.langCoroutine = nil

local function SetSavedLanguage()
	TppSave.LoadConfigDataFromSaveFile()
	while TppScriptVars.IsSavingOrLoading() do
		DebugPrintState("loading CONFIG file...")
		coroutine.yield()
	end
	local result = TppScriptVars.GetLastResult()
	if result ~= TppScriptVars.RESULT_OK then
		return "Seq_Demo_SetConsoleLanguage"
	end
	TppScriptVars.LoadVarsFromSlot(
		TppDefine.SAVE_SLOT.CONFIG,
		TppScriptVars.GROUP_BIT_VARS,
		TppScriptVars.CATEGORY_CONFIG
	)

	TppUiCommand.SetLoadIndicatorVisible(true)
	TppUiCommand.ChangeLanguage()
	while TppUiCommand.IsChangeLanguage() do
		DebugPrintState("changing language...")
		coroutine.yield()
	end
	TppUiCommand.SetLoadIndicatorVisible(false)

	return "Seq_Demo_StartCheckNecessaryStorageSpace"
end

sequences.Seq_Demo_SetSavedLanguage = {
	OnEnter = function(self)
		self.nextSequence = nil
		this.langCoroutine = coroutine.create(SetSavedLanguage)
	end,
	OnLeave = function(self)
		this.langCoroutine = nil

		TppUiCommand.SetLoadIndicatorVisible(false)
	end,
	OnUpdate = function(self)
		if this.langCoroutine then
			local status, ret1 = coroutine.resume(this.langCoroutine)
			if not status then
				Fox.Log("init_sequence", string.format("error on SetSavedLanguage. %s", tostring(ret1)))
				self.nextSequence = "Seq_Demo_SetConsoleLanguage"
				this.langCoroutine = nil
				return
			end
			if coroutine.status(this.langCoroutine) == "dead" then
				self.nextSequence = ret1
				this.langCoroutine = nil
			end
		else
			TppSequence.SetNextSequence(self.nextSequence)
		end
	end,
	nextSequence = nil,
}

sequences.Seq_Demo_SetConsoleLanguage = {
	OnEnter = function(self)
		TppUiCommand.SetPlatformLanguage()
		TppUiCommand.ChangeLanguage()
		TppUiCommand.SetLoadIndicatorVisible(true)
	end,
	OnLeave = function(self)
		TppUiCommand.SetLoadIndicatorVisible(false)
	end,
	OnUpdate = function(self)
		if TppUiCommand.IsChangeLanguage() then
			if DebugText then
				DebugText.Print(DebugText.NewContext(), "Set Language with Console Setting...")
			end
			return
		end

		TppUiCommand.SetLoadIndicatorVisible(false)
		TppSequence.SetNextSequence("Seq_Demo_StartCheckNecessaryStorageSpace")
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_StartCheckNecessaryStorageSpace = {
	OnEnter = function(self)
		if not this.IsNeedStorageSpaceCheck() then
			TppSequence.SetNextSequence("Seq_Demo_CheckInstalled")
			return
		end

		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.CHECKING_STORAGE_FREE_SPACE_SIZE)

		TppSequence.SetNextSequence("Seq_Demo_CheckNecessaryStorageSpace")
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Start check necessary storage space")
		end
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_CheckNecessaryStorageSpace = {
	OnEnter = function(self)
		if not mvars.init_storageFreeSpaceSize then
			TppSequence.SetNextSequence("Seq_Demo_CheckStorageFreeSpaceSize")
			return
		end

		if gvars.gameDataLoadingResult ~= TppDefine.SAVE_FILE_LOAD_RESULT.OK then
			if not mvars.init_needRemainMakeSaveDataSize then
				TppSequence.SetNextSequence("Seq_Demo_CheckNecessarySaveDataSize")
				return
			end
		end

		if this.IsNeedTrophyInstallation() then
			if not mvars.init_needRemainTrophyInstallationSize then
				TppSequence.SetNextSequence("Seq_Demo_CheckNecessaryTrophyInstallationSize")
				return
			end
		end

		if this.IsNeedGameInstallation() then
			if not mvars.init_doneInstallationCheck then
				TppSequence.SetNextSequence("Seq_Demo_CheckInstalled")
				return
			end

			if (not Installer.IsInstalled()) and not mvars.init_needRemainInstallationSize then
				local necessaryStorageSpaceSize = Installer.GetInstallationSize() - Installer.GetInstalledSize()

				necessaryStorageSpaceSize = necessaryStorageSpaceSize + GetInstallSizeMargin()

				Fox.Log("Game installation necessaryStorageSpaceSize = " .. tostring(necessaryStorageSpaceSize))
				mvars.init_needRemainInstallationSize = necessaryStorageSpaceSize
			end
		end

		local necessaryStorageSpaceSize = 0
		if mvars.init_needRemainInstallationSize then
			necessaryStorageSpaceSize = necessaryStorageSpaceSize + mvars.init_needRemainInstallationSize
		end
		if mvars.init_needRemainMakeSaveDataSize then
			necessaryStorageSpaceSize = necessaryStorageSpaceSize + mvars.init_needRemainMakeSaveDataSize
		end
		if mvars.init_needRemainTrophyInstallationSize then
			necessaryStorageSpaceSize = necessaryStorageSpaceSize + mvars.init_needRemainTrophyInstallationSize
		end
		mvars.init_necessaryStorageSpaceSize = necessaryStorageSpaceSize

		TppUiCommand.ErasePopup()
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Check necessary storage space : ")
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.CHECKING_STORAGE_FREE_SPACE_SIZE,
					func = function()
						if mvars.init_storageFreeSpaceSize >= mvars.init_necessaryStorageSpaceSize then
							TppSequence.SetNextSequence("Seq_Demo_StartInstall")
						else
							TppSequence.SetNextSequence("Seq_Error_ShowNecessaryStorageSpaceSize")
						end
					end,
				},
			},
		})
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_CheckStorageFreeSpaceSize = {
	OnEnter = function(self)
		TppScriptVars.RequestNecessaryStorageSpace()
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Check necessary storage space : checking storage free space size.")
		end

		if TppScriptVars.IsSavingOrLoading() then
			return
		end

		local freeSize = TppScriptVars.GetFreeStorageSpaceSize()
		mvars.init_storageFreeSpaceSize = freeSize
		Fox.Log("FreeStorageSpaceSize = " .. tostring(freeSize))
		TppSequence.SetNextSequence("Seq_Demo_CheckNecessaryStorageSpace")
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_CheckNecessarySaveDataSize = {
	OnEnter = function(self)
		TppScriptVars.RequestNecessaryStorageSpace()
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Check necessary storage space : cheking save data size.")
		end

		if TppScriptVars.IsSavingOrLoading() then
			return
		end
		local result = TppScriptVars.GetLastResult()
		if result == TppScriptVars.RESULT_OK then
			local necessaryStorageSpaceSize = TppScriptVars.GetNecessaryStorageSpaceSize()
			Fox.Log("Save data ecessaryStorageSpaceSize = " .. tostring(necessaryStorageSpaceSize))
			mvars.init_needRemainMakeSaveDataSize = necessaryStorageSpaceSize
			TppSequence.SetNextSequence("Seq_Demo_CheckNecessaryStorageSpace")
		else
			TppSequence.SetNextSequence("Seq_Error_CannotGetSaveDataNecessaryStorageSpaceSize")
		end
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_CheckNecessaryTrophyInstallationSize = {
	OnEnter = function(self)
		Trophy.TrophyDiskCheck()
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Check necessary storage space : trophy installation size.")
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			Network = {
				{
					msg = "TrophySpaceChecked",
					func = function(result, necessaryStorageSpaceSize)
						if necessaryStorageSpaceSize >= 0 then
							Fox.Log("Trophy necessaryStorageSpaceSize = " .. tostring(necessaryStorageSpaceSize))
							mvars.init_needRemainTrophyInstallationSize = necessaryStorageSpaceSize
						end
						TppSequence.SetNextSequence("Seq_Demo_CheckNecessaryStorageSpace")
					end,
				},
			},
		})
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Error_ShowNecessaryStorageSpaceSize = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		local necessaryStorageSpaceSize = mvars.init_necessaryStorageSpaceSize
		local sizeValue, unitLetter, dotPosition = Tpp.GetFormatedStorageSizePopupParam(necessaryStorageSpaceSize)
		TppUiCommand.SetErrorPopupParam(sizeValue, unitLetter, dotPosition)
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.SAVE_FAILED_NOT_ENOUGH_STORAGE_CAPACITY)
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Show necessary storage space size")
		end
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Error_CannotGetSaveDataNecessaryStorageSpaceSize = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.SAVE_FAILED_UNKNOWN_REASON)
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Save data necessary storage space check error. call Tago san.")
		end
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_CheckInstalled = {
	OnEnter = function(self)
		if not this.IsNeedGameInstallation() then
			TppSequence.SetNextSequence("Seq_Demo_StartInstall")
			return
		end

		if this.IsNeedStorageSpaceCheck() then
			Fox.Log("Skip ShowErrorPopup because already showing storage space check.")
		else
			TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
			TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.NOW_INSTALLATION_CHECKING)
		end
		Installer.StartCheckingInstallation()
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Check already installed ...")
		end

		if Installer.IsCheckingInstallation() then
			TppUI.ShowAccessIconContinue()
			return
		end

		mvars.init_doneInstallationCheck = true

		if this.IsNeedStorageSpaceCheck() then
			if DEBUG then
				if gvars.DEBUG_initMissionToTitle then
					TppSequence.SetNextSequence("Seq_Demo_CheckNecessaryStorageSpace")
				else
					TppSequence.SetNextSequence("Seq_Demo_StartInstall")
				end
				return
			end
			TppSequence.SetNextSequence("Seq_Demo_CheckNecessaryStorageSpace")
		else
			TppUiCommand.ErasePopup()
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.NOW_INSTALLATION_CHECKING,
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_StartInstall")
					end,
				},
			},
		})
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_StartInstall = {
	OnEnter = function(self)
		if not this.IsNeedGameInstallation() then
			if this.IsNeedTrophyInstallation() then
				TppSequence.SetNextSequence("Seq_Demo_InstallTrophy")
			else
				TppSequence.SetNextSequence("Seq_Demo_ConfirmAutoSave")
			end
			return
		end

		if Installer.IsInstalled() then
			mvars.alreadyInstalled = true
			TppSequence.SetNextSequence("Seq_Demo_GameDiscInsertCheck")
		else
			if Installer.GetCheckInstallationResult then
				local result = Installer.GetCheckInstallationResult()
				if result == Installer.CHECK_INSTALLATION_RESULT_BROKEN then
					TppSequence.SetNextSequence("Seq_Demo_CheckInstalledErrorBroken")
					return
				elseif result == Installer.CHECK_INSTALLATION_RESULT_NO_HDD then
					TppSequence.SetNextSequence("Seq_Demo_CheckInstalledErrorNoHdd")
					return
				end
				TppSequence.SetNextSequence("Seq_Demo_InstallDiscInsertCheck")
			else
				TppSequence.SetNextSequence("Seq_Demo_InstallDiscInsertCheck")
			end
		end
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Install start ...")
		end
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_CheckInstalledErrorBroken = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(ERROR_POPUP_ID.INSTALL_DATA_BROKEN)
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_CheckInstalledErrorNoHdd = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.CANNOT_FIND_HDD)
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_InstallDiscInsertCheck = {
	OnEnter = function(self)
		if Installer.GetCurrentDisc() ~= Installer.DISC_INSTALL then
			Fox.Log("Seq_Demo_InstallDiscInsertCheck")
			TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
			TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.INSERT_INSTALL_DISK_WHEN_NOT_INSTALLED)
			Installer.StartChangingDisc(Installer.DISC_INSTALL)
		else
			TppSequence.SetNextSequence("Seq_Demo_Install")
		end
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Check inserted install disk ...")
		end

		if Installer.IsChangingDisc() then
			return
		end

		if Installer.GetCurrentDisc() ~= Installer.DISC_INSTALL then
			Installer.StartChangingDisc(Installer.DISC_INSTALL)
			return
		end

		TppUiCommand.ErasePopup()
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.INSERT_INSTALL_DISK_WHEN_NOT_INSTALLED,
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_Install")
					end,
				},
			},
		})
	end,

	OnLeave = function(self) end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_Install = {
	OnEnter = function(self)
		if Installer.IsDownloadDeployment and Installer.IsDownloadDeployment() then
			TppSequence.SetNextSequence("Seq_Demo_DownloadInstall")
			return
		end

		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.NOW_INSTALLING)
		Installer.StartInstalling()
		self.updateTimer = 0
	end,

	OnUpdate = function(self)
		if Installer.IsDownloadDeployment and Installer.IsDownloadDeployment() then
			return
		end

		local installationSize = Installer.GetInstallationSize()
		local installedSize = Installer.GetInstalledSize()
		if installationSize < 1 then
			installationSize = 1
		end
		local installRate = (installedSize / installationSize)

		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(
				context,
				string.format(
					"Now installing ... : installedSize %d KB, installationSize %d KB, install rate %02.2f percent.",
					installedSize / 1024,
					installationSize / 1024,
					installRate
				)
			)
		end

		local dt = Time.GetFrameTime()
		self.updateTimer = self.updateTimer - dt

		if Installer.IsInstalling() then
			if self.updateTimer <= 0 then
				self.updateTimer = self.updateTimer + 1
				if self.updateTimer < 0 then
					self.updateTimer = 0
				end

				TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
				TppUiCommand.SetErrorPopupParam(installRate * 10000, "None", 2)
				TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.NOW_INSTALLING)
			end

			TppUI.ShowAccessIconContinue()
			return
		end

		TppUiCommand.ErasePopup()
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.NOW_INSTALLING,
					func = function()
						local installResult = Installer.GetInstallResult()
						if installResult == Installer.INSTALL_RESULT_OK then
							TppSequence.SetNextSequence("Seq_Demo_GameDiscInsertCheck")
						else
							TppSequence.SetNextSequence("Seq_Demo_InstallFailed")
						end
					end,
				},
			},
		})
	end,

	updateTimer = 0,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_InstallFailed = {
	OnEnter = function(self)
		local installResult = Installer.GetInstallResult()

		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		if installResult == Installer.INSTALL_RESULT_NOSPACE then
			local necessaryStorageSpaceSize = Installer.GetInstallationSize() - Installer.GetInstalledSize()

			necessaryStorageSpaceSize = necessaryStorageSpaceSize + GetInstallSizeMargin()

			local sizeValue, unitLetter, dotPosition = Tpp.GetFormatedStorageSizePopupParam(necessaryStorageSpaceSize)
			TppUiCommand.SetErrorPopupParam(sizeValue, unitLetter, dotPosition)
			TppUiCommand.ShowErrorPopup(ERROR_POPUP_ID.INSTALL_NOSPACE)
		elseif installResult == Installer.INSTALL_RESULT_NOHDD then
			TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.CANNOT_FIND_HDD)
		else
			TppUiCommand.ShowErrorPopup(ERROR_POPUP_ID.INSTALL_FAILED)
		end
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Install failed ...")
		end
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_DownloadInstall = {
	OnEnter = function(self)
		TppUiCommand.ShowErrorPopup(ERROR_POPUP_ID.DOWNLOAD_INSTALL_START, Popup.TYPE_ONE_BUTTON)
	end,
	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = ERROR_POPUP_ID.DOWNLOAD_INSTALL_START,
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_DownloadInstall_SignIn")
					end,
				},
			},
		})
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_DownloadInstall_SignIn = {
	OnEnter = function(self)
		local padIndex = TppUiCommand.GetPopupAllPadNo()
		SignIn.StartSignIn(padIndex)
	end,
	OnUpdate = function(self)
		if SignIn.GetSignInState() ~= SignIn.SIGN_IN_STATE_BUSY then
			if SignIn.IsSignedIn() then
				TppSequence.SetNextSequence("Seq_Demo_DownloadInstall_Installing")
			else
				TppSequence.SetNextSequence("Seq_Demo_DownloadInstall_NeedSignIn")
			end
		end
	end,
}

sequences.Seq_Demo_DownloadInstall_Installing = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(ERROR_POPUP_ID.DOWNLOAD_INSTALL_INSTALLING)

		Installer.StartInstalling()
	end,
	OnUpdate = function(self)
		if TppUiCommand.IsShowPopup() then
			if Installer.IsInstalling() then
				TppUI.ShowAccessIconContinue()
			else
				TppUiCommand.ErasePopup()
			end
		else
			local result = Installer.GetInstallResult()
			local nextSequence = "Seq_Demo_InstallFailed"
			if result == Installer.INSTALL_RESULT_OK then
				nextSequence = "Seq_Demo_GameDiscInsertCheck"
			elseif result == Installer.INSTALL_RESULT_NOT_SIGN_IN then
				nextSequence = "Seq_Demo_DownloadInstall_NeedSignIn"
			elseif result == Installer.INSTALL_RESULT_CANCEL then
				nextSequence = "Seq_Demo_DownloadInstall_Cancel"
			end
			TppSequence.SetNextSequence(nextSequence)
		end
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_DownloadInstall_NeedSignIn = {
	OnEnter = function(self)
		TppUiCommand.ShowErrorPopup(ERROR_POPUP_ID.DOWNLOAD_INSTALL_NEED_SIGN_IN, Popup.TYPE_ONE_BUTTON)
	end,
	OnUpdate = function(self)
		if TppUiCommand.IsShowPopup() then
		else
			TppSequence.SetNextSequence("Seq_Demo_DownloadInstall_SignIn")
		end
	end,
}

sequences.Seq_Demo_DownloadInstall_Cancel = {
	OnEnter = function(self)
		TppUiCommand.ShowErrorPopup(ERROR_POPUP_ID.DOWNLOAD_INSTALL_CANCEL, Popup.TYPE_ONE_BUTTON)
	end,
	OnUpdate = function(self)
		if TppUiCommand.IsShowPopup() then
		else
			TppSequence.SetNextSequence("Seq_Demo_DownloadInstall_SignIn")
		end
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_GameDiscInsertCheck = {
	OnEnter = function(self)
		if Installer.GetCurrentDisc() ~= Installer.DISC_GAME then
			Installer.StartChangingDisc(Installer.DISC_GAME)

			TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
			if mvars.alreadyInstalled then
				TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.INSERT_GAME_DISK_WHEN_ALREADY_INSTALLED)
			else
				TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.INSERT_GAME_DISK_WHEN_INSTALL_END)
			end
		else
			if this.IsNeedTrophyInstallation() then
				TppSequence.SetNextSequence("Seq_Demo_InstallTrophy")
			else
				TppSequence.SetNextSequence("Seq_Demo_ConfirmAutoSave")
			end
		end
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Check game disk inserted ...")
		end

		if Installer.IsChangingDisc() then
			return
		end

		if Installer.GetCurrentDisc() ~= Installer.DISC_GAME then
			Installer.StartChangingDisc(Installer.DISC_GAME)
			return
		end

		TppUiCommand.ErasePopup()
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = {
						TppDefine.ERROR_ID.INSERT_GAME_DISK_WHEN_ALREADY_INSTALLED,
						TppDefine.ERROR_ID.INSERT_GAME_DISK_WHEN_INSTALL_END,
					},
					func = function()
						if this.IsNeedTrophyInstallation() then
							TppSequence.SetNextSequence("Seq_Demo_InstallTrophy")
						else
							TppSequence.SetNextSequence("Seq_Demo_ConfirmAutoSave")
						end
					end,
				},
			},
		})
	end,

	ignoreSignInUserChanged = true,
}

local TROPHY_INSTALL_RESULT_SUCCESS = 1

sequences.Seq_Demo_InstallTrophy = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.TROPHY_INSTALLING)
		Trophy.TrophyInstall()
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Now installing Trophy ...")
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			Network = {
				{
					msg = "TrophyInstalled",
					func = function(result)
						mvars.init_trophyInstallResult = result
						TppUiCommand.ErasePopup()
					end,
				},
			},
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.TROPHY_INSTALLING,
					func = function()
						if mvars.init_trophyInstallResult == TROPHY_INSTALL_RESULT_SUCCESS then
							TppSequence.SetNextSequence("Seq_Demo_ConfirmAutoSave")
						else
							TppSequence.SetNextSequence("Seq_Error_TrophyInstallFailed")
						end
					end,
				},
			},
		})
	end,
}

sequences.Seq_Error_TrophyInstallFailed = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.TROPHY_INSTALL_FAILED)
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), { 1.0, 0.0, 0.0 }, "Trophy install failed ...")
		end
	end,
}

sequences.Seq_Demo_ConfirmAutoSave = {
	OnEnter = function(self)
		TppSoundDaemon.LoadRegidentStreamData()

		if SignIn.PresetUserIdExists and SignIn.PresetUserIdExists() then
			TppSequence.SetNextSequence("Seq_Demo_StartSignIn")
			return
		end

		--		if IsPlaystationFamily() then
		--			sequenceTime = 0
		--			TppUiCommand.SetPopupType( "POPUP_TYPE_NO_BUTTON_NO_EFFECT" )
		--			TppUiCommand.ShowErrorPopup( TppDefine.ERROR_ID.CONFIRM_AUTO_SAVE )
		--		else
		--			TppUiCommand.SetPopupAllPad()
		--			TppUiCommand.ShowErrorPopup( TppDefine.ERROR_ID.CONFIRM_AUTO_SAVE, Popup.TYPE_ONE_BUTTON )
		--		end
		TppSequence.SetNextSequence("Seq_Demo_StartSignIn")
	end,

	OnUpdate = function(self)
		if IsPlaystationFamily() then
			if sequenceTime > 4 then
				TppUiCommand.ErasePopup()
			end
			sequenceTime = sequenceTime + Time.GetFrameTime()
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.CONFIRM_AUTO_SAVE,
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_StartSignIn")
					end,
				},
			},
		})
	end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_StartSignIn = {
	OnEnter = function(self)
		Fox.Log("### Seq_Demo_StartSignIn ###")
		if not SignIn.IsStartupProcessCompleted() then
			TppSequence.SetNextSequence("Seq_Demo_SignIn")
		else
			if DEBUG then
				if not gvars.DEBUG_initMissionToTitle then
					TppSave.ForbidSave()
					TppSequence.SetNextSequence("Seq_Demo_Init")
					return
				end
			end
			if SignIn.ClearPresetUserId then
				SignIn.ClearPresetUserId()
			end
			TppSequence.SetNextSequence("Seq_Demo_CreateOrLoadSaveData")
		end
	end,
}

sequences.Seq_Demo_SignIn = {
	OnEnter = function(self)
		Fox.Log("### Seq_Demo_SignIn ###")

		local platform = Fox.GetPlatformName()
		if platform == "Xbox360" then
			if SignIn.GetPresetUserId and SignIn.PresetUserIdExists then
				if SignIn.PresetUserIdExists() then
					local userId = SignIn.GetPresetUserId()
					Fox.Log("init", "sign in with preset userId:" .. tostring(userId))
					SignIn.StartSignIn(userId)
					SignIn.ClearPresetUserId()
					return
				end
			end
		elseif platform == "XboxOne" then
			if SignIn.GetPresetUserId and SignIn.PresetUserIdExists then
				if SignIn.PresetUserIdExists() then
					local userId = SignIn.GetPresetUserId()
					Fox.Log("init", "sign in with preset userId:" .. tostring(userId))
					local error = SignIn.StartSignInWithUserId(userId)
					SignIn.ClearPresetUserId()
					if error then
						TppSequence.SetNextSequence("Seq_Demo_ConfirmAutoSave")
					end
					return
				end
			end
		end

		local padIndex = TppUiCommand.GetPopupAllPadNo()
		Fox.Log("Set padIndex = " .. tostring(padIndex))

		SignIn.StartSignIn(padIndex)
	end,

	OnUpdate = function(self)
		if DebugText then
			local context = DebugText.NewContext()
			DebugText.Print(context, "Signing In ...")
		end

		if SignIn.GetSignInState() ~= SignIn.SIGN_IN_STATE_BUSY then
			if SignIn.IsSignedIn() then
				TppSequence.SetNextSequence("Seq_Demo_SelectStorage")
			else
				TppSequence.SetNextSequence("Seq_Demo_NotSignIn")
			end
		end
	end,
}

sequences.Seq_Demo_NotSignIn = {
	OnEnter = function(self)
		Fox.Log("### Seq_Demo_NotSignIn ###")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.START_NOT_SIGN_IN, Popup.TYPE_ONE_BUTTON)
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.START_NOT_SIGN_IN,
					func = function()
						local select = TppUiCommand.GetPopupSelect()
						if select == Popup.SELECT_OK then
							TppSave.ForbidSave()
							this.SelectLanguageAndGoSequence("Seq_Demo_CheckPatchDlc")
						else
							TppSequence.SetNextSequence("Seq_Demo_SignIn")
						end
					end,
				},
			},
		})
	end,
}

sequences.Seq_Demo_SelectStorage = {
	OnEnter = function(self)
		Fox.Log("### Seq_Demo_SelectStorage ###")
		SignIn.StartSelectGameSaveStorage()
	end,

	OnUpdate = function(self)
		if SignIn.GetStorageSelectionState() ~= SignIn.STORAGE_SELECTION_STATE_BUSY then
			if SignIn.IsStorageSelected() then
				TppSequence.SetNextSequence("Seq_Demo_CreateOrLoadSaveData")
			else
				TppSequence.SetNextSequence("Seq_Demo_NoStorageSelected")
			end
		end
	end,

	OnLeave = function(self, nextSequenceName)
		if nextSequenceName ~= "Seq_Demo_NoStorageSelected" then
			if SignIn then
				SignIn.SetStartupProcessCompleted(true)
			end
		end
	end,
}

sequences.Seq_Demo_NoStorageSelected = {
	OnEnter = function(self)
		Fox.Log("### Seq_Demo_NoStorageSelected ###")
		TppUiCommand.SetPopupSelectNegative()
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.NOT_SELECT_STORAGE, Popup.TYPE_TWO_BUTTON)
	end,

	OnLeave = function(self, nextSequenceName)
		if SignIn then
			SignIn.SetStartupProcessCompleted(true)
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.NOT_SELECT_STORAGE,
					func = function()
						local select = TppUiCommand.GetPopupSelect()
						if select == Popup.SELECT_OK then
							TppSave.ForbidSave()
							this.SelectLanguageAndGoSequence("Seq_Demo_CheckPatchDlc")
						else
							TppSequence.SetNextSequence("Seq_Demo_SelectStorage")
						end
					end,
				},
			},
		})
	end,
}

this.saveCoroutine = nil

local function SearchSaveDataExistAreaList()
	local fileName = TppSave.GetGameSaveFileName()
	local currentArea = TppGameSequence.GetShortTargetArea()
	local areas = TppGameSequence.GetShortTargetAreaList()

	local foundAreas = {}
	for i, area in ipairs(areas) do
		Fox.Log("SearchSaveDataExistAreaList : area = " .. tostring(area))
		TppScriptVars.RequestAreaFileExistence(area, fileName)
		while TppScriptVars.IsSavingOrLoading() do
			coroutine.yield()
		end
		local result = TppScriptVars.GetLastResult()
		if result == TppScriptVars.RESULT_OK then
			if TppScriptVars.GetFileExistence() then
				foundAreas[#foundAreas + 1] = area
			end
		else
			Fox.Log(
				"SearchSaveDataExistAreaList : TppScriptVars.GetLastResult is not TppScriptVars.RESULT_OK. result = "
					.. tostring(result)
			)
		end
	end
	return foundAreas
end

local function ImportAnotherAreaSaveData(
	foundAreas,
	SAVE_FILE_CONFIG,
	SAVE_FILE_PERSONAL,
	SAVE_FILE_GAME,
	SAVE_FILE_COUNT,
	loadFuncs,
	fileExists,
	tempSaveConfig
)
	local function ClosePopupAndWait()
		if TppUiCommand.IsShowPopup() then
			TppUiCommand.ErasePopup()
			while TppUiCommand.IsShowPopup() do
				DebugPrintState("waiting popup closed...")
				coroutine.yield()
			end
		end
	end
	local function RestoreTempSavedConfingAndVarSave()
		for index, value in pairs(tempSaveConfig) do
			Fox.Log("RestoreTempSavedConfing : index = " .. tostring(index) .. ", value = " .. tostring(value))
			vars.optionSelectedIndices[index] = value
		end
		TppSave.VarSaveConfig()
	end

	ClosePopupAndWait()

	TppUiCommand.ShowAreaPopup(foundAreas)
	while TppUiCommand.IsShowAreaPopup() do
		DebugPrintState("waiting area popup close...")
		coroutine.yield()
	end
	local importArea = TppUiCommand.GetAreaPopupResult()
	if importArea == "new" then
		TppVarInit.ClearAllVarsAndSlot()
		RestoreTempSavedConfingAndVarSave()
		return importArea
	end

	this.ShowLoadingSaveDataPopUp()

	local fileNames = {
		[SAVE_FILE_CONFIG] = TppDefine.CONFIG_SAVE_FILE_NAME,
		[SAVE_FILE_PERSONAL] = TppDefine.PERSONAL_DATA_SAVE_FILE_NAME,
		[SAVE_FILE_GAME] = TppSave.GetGameSaveFileName(),
	}

	local loadCheckFuncs = {
		[SAVE_FILE_CONFIG] = function()
			TppScriptVars.LoadVarsFromSlot(
				TppDefine.SAVE_SLOT.CONFIG,
				TppScriptVars.GROUP_BIT_VARS,
				TppScriptVars.CATEGORY_CONFIG
			)

			RestoreTempSavedConfingAndVarSave()
		end,
		[SAVE_FILE_PERSONAL] = function()
			TppScriptVars.LoadVarsFromSlot(
				TppDefine.SAVE_SLOT.PERSONAL,
				TppScriptVars.GROUP_BIT_VARS,
				TppScriptVars.CATEGORY_PERSONAL
			)
		end,
		[SAVE_FILE_GAME] = function()
			TppSave.CopyGameDataFromSavingSlot()
		end,
	}

	local importSaveFuncs = {
		[SAVE_FILE_CONFIG] = function()
			return TppSave.SaveConfigData(false, true)
		end,
		[SAVE_FILE_PERSONAL] = function()
			return TppSave.SavePersonalData(false, true)
		end,
		[SAVE_FILE_GAME] = function()
			return TppSave.SaveImportedGameData()
		end,
	}

	local importExistCount = 0
	local importFileExists = { false, false, false }
	local importFileLoaded = { false, false, false }

	for i = 1, SAVE_FILE_COUNT do
		Fox.Log(
			"TppScriptVars.RequestAreaFileExistence( " .. tostring(importArea) .. ", " .. tostring(fileNames[i]) .. " )"
		)
		TppScriptVars.RequestAreaFileExistence(importArea, fileNames[i])
		while TppScriptVars.IsSavingOrLoading() do
			DebugPrintState("ImportAnotherAreaSaveData : check file existence: " .. fileNames[i])
			coroutine.yield()
		end

		local result = TppScriptVars.GetLastResult()
		if result == TppScriptVars.RESULT_OK then
			importFileExists[i] = TppScriptVars.GetFileExistence()
		else
			Fox.Log("TppScriptVars.GetLastResult is not TppScriptVars.RESULT_OK. result = " .. tostring(result))
			return false
		end
	end

	for i = 1, SAVE_FILE_COUNT do
		if importFileExists[i] then
			local ret = loadFuncs[i](importArea)
			if ret == TppScriptVars.READ_FAILED then
				return false
			end

			Fox.Log(
				"ImportAnotherAreaSaveData : import save data load "
					.. tostring(fileNames[i])
					.. ", importArea = "
					.. tostring(importArea)
			)

			while TppScriptVars.IsSavingOrLoading() do
				DebugPrintState(
					"ImportAnotherAreaSaveData : import save data load "
						.. tostring(fileNames[i])
						.. ", importArea = "
						.. tostring(importArea)
				)
				coroutine.yield()
			end

			local result = TppScriptVars.GetLastResult()
			if (result == TppScriptVars.RESULT_OK) or (result == TppScriptVars.RESULT_ERROR_LOAD_BACKUP) then
				loadCheckFuncs[i]()
				importFileLoaded[i] = true
			else
				Fox.Log("TppScriptVars.GetLastResult is not TppScriptVars.RESULT_OK. result = " .. tostring(result))
				return false
			end
		end
	end

	ClosePopupAndWait()
	this.ShowMakingSaveDataPopUp()

	for i = 1, SAVE_FILE_COUNT do
		if importFileLoaded[i] then
			local ret = importSaveFuncs[i]()
			if ret == TppScriptVars.WRITE_FAILED then
				return false
			end

			Fox.Log(
				"ImportAnotherAreaSaveData : Save loaded import save data: "
					.. fileNames[i]
					.. ", importArea = "
					.. tostring(importArea)
			)
			while TppScriptVars.IsSavingOrLoading() do
				DebugPrintState(
					"ImportAnotherAreaSaveData : Save loaded import save data: "
						.. fileNames[i]
						.. ", importArea = "
						.. tostring(importArea)
				)
				coroutine.yield()
			end

			local result = TppScriptVars.GetLastResult()
			if result == TppScriptVars.RESULT_OK then
				fileExists[i] = true
			else
				Fox.Log("TppScriptVars.GetLastResult is not TppScriptVars.RESULT_OK. result = " .. tostring(result))
				return false
			end
		end
	end

	return importArea
end

local function CreateOrLoadSaveData()
	local DebugText = DebugText
	local function DebugPrintState(state)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "CreateOrLoadSaveData: " .. tostring(state))
		end
	end
	local function ClosePopupAndWait()
		if TppUiCommand.IsShowPopup() then
			TppUiCommand.ErasePopup()
			while TppUiCommand.IsShowPopup() do
				DebugPrintState("waiting popup closed...")
				coroutine.yield()
			end
		end
	end
	local function ChangeLanguage()
		TppUiCommand.ChangeLanguage()
		while TppUiCommand.IsChangeLanguage() do
			DebugPrintState("change language")
			coroutine.yield()
		end
	end

	local SAVE_FILE_CONFIG = 1
	local SAVE_FILE_PERSONAL = 2
	local SAVE_FILE_GAME = 3
	local SAVE_FILE_COUNT = 3

	local fileNames = {
		[SAVE_FILE_CONFIG] = TppDefine.CONFIG_SAVE_FILE_NAME,
		[SAVE_FILE_PERSONAL] = TppDefine.PERSONAL_DATA_SAVE_FILE_NAME,
		[SAVE_FILE_GAME] = TppSave.GetGameSaveFileName(),
	}

	local saveFuncs = {
		[SAVE_FILE_CONFIG] = function()
			TppSave.VarSaveConfig()
			return TppSave.SaveConfigData(true, true)
		end,
		[SAVE_FILE_PERSONAL] = function()
			TppSave.VarSavePersonalData()
			return TppSave.SavePersonalData(false, true)
		end,
		[SAVE_FILE_GAME] = function()
			gvars.gameDataLoadingResult = TppDefine.SAVE_FILE_LOAD_RESULT.NOT_EXIST_FILE
			return TppSave.MakeNewGameSaveData()
		end,
	}

	local loadFuncs = {
		[SAVE_FILE_CONFIG] = function(area)
			return TppSave.LoadConfigDataFromSaveFile(area)
		end,
		[SAVE_FILE_PERSONAL] = function(area)
			return TppSave.LoadPersonalDataFromSaveFile(area)
		end,
		[SAVE_FILE_GAME] = function(area)
			return TppSave.LoadGameDataFromSaveFile(area)
		end,
	}

	local loadCheckFuncs = {
		[SAVE_FILE_CONFIG] = function()
			TppScriptVars.LoadVarsFromSlot(
				TppDefine.SAVE_SLOT.CONFIG,
				TppScriptVars.GROUP_BIT_VARS,
				TppScriptVars.CATEGORY_CONFIG
			)
		end,
		[SAVE_FILE_PERSONAL] = function() end,
		[SAVE_FILE_GAME] = function()
			TppSave.CheckGameSaveDataLoadResult()
		end,
	}

	gvars.gameDataLoadingResult = TppDefine.SAVE_FILE_LOAD_RESULT.NOT_EXIST_FILE

	local existCount = 0
	local fileExists = { false, false, false }
	local fileCorrupt = { false, false, false }
	local fileLoaded = { false, false, false }
	local ownerError = false
	local fileCorruptError = false
	for i = 1, SAVE_FILE_COUNT do
		Fox.Log("TppScriptVars.RequestFileExistence[" .. tostring(i) .. "]:" .. tostring(fileNames[i]))
		TppScriptVars.RequestFileExistence(fileNames[i])
		while TppScriptVars.IsSavingOrLoading() do
			DebugPrintState("check file existence: " .. fileNames[i])
			coroutine.yield()
		end

		local result = TppScriptVars.GetLastResult()
		if result == TppScriptVars.RESULT_OK then
			local exists = TppScriptVars.GetFileExistence()
			fileExists[i] = exists
			if exists then
				existCount = existCount + 1
			end
		elseif result == TppScriptVars.RESULT_ERROR_OWNER then
			ownerError = true
		elseif result == TppScriptVars.RESULT_ERROR_FILE_CORRUPT then
			fileCorrupt[i] = true
			fileCorruptError = true
		else
			return "Seq_Demo_SaveDataError"
		end
	end

	if fileCorruptError then
		if fileCorrupt[SAVE_FILE_GAME] then
			TppUiCommand.SetPopupSelectNegative()
			TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.LOAD_RESULT_FILE_CORRUPT_ERROR, Popup.TYPE_TWO_BUTTON)
			while TppUiCommand.IsShowPopup() do
				DebugPrintState("waiting file-corrupt popup closed...")
				coroutine.yield()
			end
			local popupSelect = TppUiCommand.GetPopupSelect()
			if popupSelect == Popup.SELECT_OK then
				for i = 1, SAVE_FILE_COUNT do
					fileExists[i] = false
				end
				existCount = 0
			else
				return "Seq_Demo_RetryCreateOrLoadSaveData"
			end
		else
			TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.LOAD_RESULT_CONFIG_FILE_CORRUPT_ERROR, Popup.TYPE_ONE_BUTTON)
			while TppUiCommand.IsShowPopup() do
				DebugPrintState("waiting file-corrupt popup closed...")
				coroutine.yield()
			end
		end
	elseif ownerError then
		TppUiCommand.SetPopupSelectNegative()
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.LOAD_RESULT_OWNER_ERROR, Popup.TYPE_TWO_BUTTON)
		coroutine.yield()
		while TppUiCommand.IsShowPopup() do
			DebugPrintState("waiting owner-error popup closed...")
			coroutine.yield()
		end
		local popupSelect = TppUiCommand.GetPopupSelect()
		if popupSelect == Popup.SELECT_OK then
			for i = 1, SAVE_FILE_COUNT do
				fileExists[i] = false
			end
			existCount = 0
		else
			return "Seq_Demo_RetryCreateOrLoadSaveData"
		end
	end

	if existCount < SAVE_FILE_COUNT and Fox.GetPlatformName() == "Xbox360" then
		TppScriptVars.RequestNecessaryStorageSpace()
		while TppScriptVars.IsSavingOrLoading() do
			DebugPrintState("checking necessary storage space...")
			coroutine.yield()
		end

		local result = TppScriptVars.GetLastResult()
		if result == TppScriptVars.RESULT_OK then
			local necessarySize = TppScriptVars.GetNecessaryStorageSpaceSize()
			local freeSize = TppScriptVars.GetFreeStorageSpaceSize()
			if necessarySize > 0 and necessarySize > freeSize then
				return "Seq_Error_WriteSaveDataResultNoSpace"
			end
		else
			return "Seq_Demo_SaveDataError"
		end
	end

	if not fileExists[SAVE_FILE_GAME] then
		if InvitationManager.IsAccepted() then
			InvitationManager.ResetAccept()

			TppUiCommand.ShowErrorPopup(5004, Popup.TYPE_ONE_BUTTON)
			while TppUiCommand.IsShowPopup() do
				DebugPrintState("cannot accept invitation")
				coroutine.yield()
			end
		end
	end

	if not fileExists[SAVE_FILE_CONFIG] then
		TppUiCommand.ShowLangPopup()
		while TppUiCommand.IsShowLangPopup() do
			DebugPrintState("select language")
			coroutine.yield()
		end

		ChangeLanguage()

		TppUiCommand.OpenBrightnessSetting()
		while not TppUiCommand.IsEndBrightnessSetting() do
			DebugPrintState("set brightness")
			coroutine.yield()
		end
	end

	if existCount ~= SAVE_FILE_COUNT then
		this.ShowMakingSaveDataPopUp()
	end

	for i = 1, SAVE_FILE_COUNT do
		if not fileExists[i] then
			local ret = saveFuncs[i]()
			if ret == TppScriptVars.WRITE_FAILED then
				return "Seq_Demo_SaveDataError"
			end

			while TppScriptVars.IsSavingOrLoading() do
				DebugPrintState("create initial file: " .. fileNames[i])
				coroutine.yield()
			end

			local result = TppScriptVars.GetLastResult()
			if result == TppScriptVars.RESULT_OK then
			elseif result == TppScriptVars.RESULT_ERROR_NOSPACE then
				return "Seq_Error_WriteSaveDataResultNoSpace"
			elseif result == TppScriptVars.RESULT_ERROR_INVALID_STORAGE then
				return "Seq_Error_WriteSaveDataResultInvalidStorage"
			else
				return "Seq_Demo_SaveDataError"
			end
		end
	end

	ClosePopupAndWait()

	if (not fileExists[SAVE_FILE_GAME]) and IsPlaystationFamily() then
		this.ShowLoadingSaveDataPopUp()
		local foundAreas = SearchSaveDataExistAreaList()
		if next(foundAreas) then
			local tempSaveConfig = {
				[0] = vars.optionSelectedIndices[0],
				[22] = vars.optionSelectedIndices[22],
			}

			local IMPORT_RESULT_FAILED = false
			local result
			repeat
				result = ImportAnotherAreaSaveData(
					foundAreas,
					SAVE_FILE_CONFIG,
					SAVE_FILE_PERSONAL,
					SAVE_FILE_GAME,
					SAVE_FILE_COUNT,
					loadFuncs,
					fileExists,
					tempSaveConfig
				)

				ClosePopupAndWait()

				if result == IMPORT_RESULT_FAILED then
					TppUiCommand.ShowErrorPopup(1121, Popup.TYPE_ONE_BUTTON)
				elseif result ~= "new" then
					TppUiCommand.ShowErrorPopup(1120, Popup.TYPE_ONE_BUTTON)
				end

				while TppUiCommand.IsShowPopup() do
					DebugPrintState("waiting import result popup close...")
					coroutine.yield()
				end

			until result ~= IMPORT_RESULT_FAILED
		end
	end

	if existCount > 0 then
		this.ShowLoadingSaveDataPopUp()
	end

	for i = 1, SAVE_FILE_COUNT do
		fileCorrupt[i] = false
	end
	fileCorruptError = false

	for i = 1, SAVE_FILE_COUNT do
		if fileExists[i] then
			local ret = loadFuncs[i]()
			if ret == TppScriptVars.READ_FAILED then
				return "Seq_Demo_SaveDataError"
			end

			while TppScriptVars.IsSavingOrLoading() do
				DebugPrintState("load " .. tostring(fileNames[i]))
				coroutine.yield()
			end

			local result = TppScriptVars.GetLastResult()
			if result == TppScriptVars.RESULT_OK then
				loadCheckFuncs[i]()
				fileLoaded[i] = true
			elseif result == TppScriptVars.RESULT_ERROR_LOAD_BACKUP then
				loadCheckFuncs[i]()
				fileLoaded[i] = true
			elseif result == TppScriptVars.RESULT_ERROR_FILE_CORRUPT then
				fileCorrupt[i] = true
				fileCorruptError = true
			elseif result == TppScriptVars.RESULT_ERROR_NOSPACE then
				return "Seq_Error_LoadSaveDataVersionError"
			else
				return "Seq_Demo_SaveDataError"
			end
		end
	end

	ClosePopupAndWait()

	if fileCorruptError then
		if fileCorrupt[SAVE_FILE_GAME] then
			TppUiCommand.SetPopupSelectNegative()
			TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.LOAD_RESULT_FILE_CORRUPT_ERROR, Popup.TYPE_TWO_BUTTON)
			while TppUiCommand.IsShowPopup() do
				DebugPrintState("waiting file-corrupt popup closed...")
				coroutine.yield()
			end
			local popupSelect = TppUiCommand.GetPopupSelect()
			if popupSelect == Popup.SELECT_OK then
			else
				return "Seq_Demo_RetryCreateOrLoadSaveData"
			end
		else
			TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.LOAD_RESULT_CONFIG_FILE_CORRUPT_ERROR, Popup.TYPE_ONE_BUTTON)
			while TppUiCommand.IsShowPopup() do
				DebugPrintState("waiting file-corrupt popup closed...")
				coroutine.yield()
			end
		end

		for i = 1, SAVE_FILE_COUNT do
			if fileCorrupt[i] then
				local ret = saveFuncs[i]()
				if ret == TppScriptVars.WRITE_FAILED then
					return "Seq_Demo_SaveDataError"
				end

				while TppScriptVars.IsSavingOrLoading() do
					DebugPrintState("create recovery file: " .. fileNames[i])
					coroutine.yield()
				end

				local result = TppScriptVars.GetLastResult()
				if result == TppScriptVars.RESULT_OK then
				elseif result == TppScriptVars.RESULT_ERROR_NOSPACE then
					return "Seq_Error_WriteSaveDataResultNoSpace"
				elseif result == TppScriptVars.RESULT_ERROR_INVALID_STORAGE then
					return "Seq_Error_WriteSaveDataResultInvalidStorage"
				else
					return "Seq_Demo_SaveDataError"
				end
			end
		end
	end

	if fileExists[SAVE_FILE_CONFIG] then
		ChangeLanguage()
	end

	if fileExists[SAVE_FILE_GAME] and not fileCorrupt[SAVE_FILE_GAME] then
		local result = gvars.gameDataLoadingResult
		if result == TppDefine.SAVE_FILE_LOAD_RESULT.OK then
		elseif result == TppDefine.SAVE_FILE_LOAD_RESULT.OK_LOAD_BACKUP then
			return "Seq_Demo_UseBackUpLoadGameSaveData"
		elseif result == TppDefine.SAVE_FILE_LOAD_RESULT.DIFFER_FROM_CURRENT_VERSION then
			return "Seq_Error_LoadSaveDataVersionError"
		else
			return "Seq_Demo_SaveDataError"
		end
	end

	return "Seq_Demo_LogInKonamiServer"
end

sequences.Seq_Demo_CreateOrLoadSaveData = {
	OnEnter = function(self)
		self.nextSequence = nil
		this.saveCoroutine = coroutine.create(CreateOrLoadSaveData)
	end,
	OnLeave = function(self)
		this.saveCoroutine = nil
	end,
	OnUpdate = function(self)
		if this.saveCoroutine then
			local status, ret1 = coroutine.resume(this.saveCoroutine)
			if not status then
				Fox.Error("init_sequence", string.format("error on CreateOnLoadSaveData. %s", tostring(ret1)))
				self.nextSequence = "Seq_Demo_SaveDataError"
				this.saveCoroutine = nil
				return
			end

			if coroutine.status(this.saveCoroutine) == "dead" then
				Fox.Log("CreateOrLoadSaveData() finished. next: " .. tostring(ret1))
				self.nextSequence = ret1
				this.saveCoroutine = nil
				return
			end
		else
			if TppUiCommand.IsShowPopup() then
				if DebugText then
					DebugText.Print(DebugText.NewContext(), "waiting popup closed...")
				end
				TppUiCommand.ErasePopup()
			else
				TppSequence.SetNextSequence(self.nextSequence)
			end
		end
	end,
	nextSequence = nil,
}

sequences.Seq_Demo_SaveDataError = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.SAVE_FAILED_UNKNOWN_REASON)
	end,
	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "SaveDataError")
		end
	end,
}

sequences.Seq_Demo_RetryCreateOrLoadSaveData = {
	OnEnter = function(self)
		TppSequence.SetNextSequence("Seq_Demo_CreateOrLoadSaveData")
	end,
}

sequences.Seq_Error_WriteSaveDataResultNoSpacePS4 = {
	OnEnter = function(self)
		TppScriptVars.ShowNoSpaceDialog()
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), { 1.0, 0.0, 0.0 }, "Save data result error : no space ps4.")
		end

		if TppScriptVars.IsShowingNoSpaceDialog() then
			return
		end

		TppSequence.SetNextSequence("Seq_Demo_CreateOrLoadSaveData")
	end,
}

sequences.Seq_Error_WriteSaveDataResultNoSpace = {
	OnEnter = function(self)
		if Fox.GetPlatformName() == "PS4" then
			TppSequence.SetNextSequence("Seq_Error_WriteSaveDataResultNoSpacePS4")
			return
		end

		TppScriptVars.RequestNecessaryStorageSpace()
	end,

	OnUpdate = function(self)
		if Fox.GetPlatformName() == "PS4" then
			return
		end

		if DebugText then
			DebugText.Print(
				DebugText.NewContext(),
				{ 1.0, 0.0, 0.0 },
				"Save data result error : checking storage space."
			)
		end

		TppUI.ShowAccessIconContinue()

		if TppScriptVars.IsSavingOrLoading() then
			return
		end

		local result = TppScriptVars.GetLastResult()
		if result == TppScriptVars.RESULT_OK then
			TppSequence.SetNextSequence("Seq_Error_WriteSaveDataResultNoSpaceShowPopUp")
		else
			TppSequence.SetNextSequence("Seq_Error_WriteSaveDataResultUnknown")
		end
	end,
}

sequences.Seq_Error_WriteSaveDataResultNoSpaceShowPopUp = {
	OnEnter = function(self)
		local buttunSetting = Popup.TYPE_ONE_BUTTON
		if this.IsNeedStorageSpaceCheck() then
			TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
			buttunSetting = nil
		end

		local necessarySize = TppScriptVars.GetNecessaryStorageSpaceSize()
		local sizeValue, unitLetter, dotPosition = Tpp.GetFormatedStorageSizePopupParam(necessarySize)
		TppUiCommand.SetErrorPopupParam(sizeValue, unitLetter, dotPosition)
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.SAVE_FAILED_NOT_ENOUGH_STORAGE_CAPACITY, buttunSetting)
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(
				DebugText.NewContext(),
				{ 1.0, 0.0, 0.0 },
				"Save data result error : checking storage space."
			)
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{

					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.SAVE_FAILED_NOT_ENOUGH_STORAGE_CAPACITY,
					func = function(errorId)
						TppSequence.SetNextSequence("Seq_Demo_SelectStorage")
					end,
				},
			},
		})
	end,
}

sequences.Seq_Error_WriteSaveDataResultInvalidStorage = {
	OnEnter = function(self)
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.SAVE_FAILED_CANNOT_FIND_STORAGE, Popup.TYPE_ONE_BUTTON)
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), { 1.0, 0.0, 0.0 }, "Save data result error : invalid storage.")
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{

					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.SAVE_FAILED_CANNOT_FIND_STORAGE,
					func = function(errorId)
						TppSequence.SetNextSequence("Seq_Demo_SelectStorage")
					end,
				},
			},
		})
	end,
}

sequences.Seq_Error_WriteSaveDataResultUnknown = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.SAVE_FAILED_UNKNOWN_REASON)
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), { 1.0, 0.0, 0.0 }, "Save data result error.")
		end
	end,
}

function this.OnReadSaveDataError()
	mvars.init_isSaveDataReadError = true
	TppUiCommand.ErasePopup()
end

sequences.Seq_Demo_UseBackUpLoadGameSaveData = {
	OnEnter = function(self)
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.LOAD_RESULT_BACKUP_ERROR, Popup.TYPE_ONE_BUTTON)
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), { 1.0, 0.0, 0.0 }, "Save data write error. use back up data.")
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "PopupClose",
					sender = TppDefine.ERROR_ID.LOAD_RESULT_BACKUP_ERROR,
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_LogInKonamiServer")
					end,
				},
			},
		})
	end,
}

sequences.Seq_Error_LoadSaveDataVersionError = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(TppDefine.ERROR_ID.LOAD_RESULT_VERSION_ERROR)
	end,
}

sequences.Seq_Demo_LogInKonamiServer = {
	Messages = function(self)
		return StrCode32Table({
			Network = {
				{
					msg = "EndLogin",
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_CheckPatchDlcForInvitation")
					end,
				},
			},
		})
	end,

	OnEnter = function(self)
		TppScriptVars.LoadVarsFromSlot(
			TppDefine.SAVE_SLOT.PERSONAL,
			TppScriptVars.GROUP_BIT_VARS,
			TppScriptVars.CATEGORY_PERSONAL
		)
		if DEBUG then
			TppSequence.SetNextSequence("Seq_Demo_CheckPatchDlcForInvitation")
			return
		end
		TppServerManager.StartLogin()
	end,
}

sequences.Seq_Demo_CheckDlc = {
	OnEnter = function(self)
		Dlc.StartCheckingDlc()
	end,
	OnUpdate = function(self)
		if Dlc.IsCheckingDlc() then
			if DebugText then
				DebugText.Print(DebugText.NewContext(), "Checking DLC...")
			end
			TppUI.ShowAccessIconContinue()
		else
			if Dlc.GetLastError() == DlcError.E_OK then
				TppSequence.SetNextSequence("Seq_Demo_ShowDlcAnnouncePopup")
			else
				TppSequence.SetNextSequence("Seq_Demo_ShowDlcError")
			end
		end
	end,
}

sequences.Seq_Demo_ShowDlcError = {
	OnEnter = function(self)
		local dlcError = Dlc.GetLastError()
		if dlcError == DlcError.E_NETWORK then
			TppSequence.SetNextSequence("Seq_Demo_ShowDlcErrorNetwork")
		else
			TppSequence.SetNextSequence("Seq_Demo_ShowDlcAnnouncePopup")
		end
	end,
}

sequences.Seq_Demo_ShowDlcErrorNetwork = {
	OnEnter = function(self)
		TppUiCommand.ShowErrorPopup(ERROR_POPUP_ID.DLC_ERROR_NETWORK, Popup.TYPE_ONE_BUTTON)
	end,
	OnUpdate = function(self)
		if TppUiCommand.IsShowPopup() then
		else
			TppSequence.SetNextSequence("Seq_Demo_ShowDlcAnnouncePopup")
		end
	end,
}

sequences.Seq_Demo_ShowDlcAnnouncePopup = {
	OnEnter = function(self)
		TppUiCommand.ShowDlcAnnouncePopup()
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Showing dlc announce popup ...")
		end
	end,

	Messages = function(self)
		return StrCode32Table({
			UI = {
				{
					msg = "EndDlcAnnounce",
					func = function()
						TppSequence.SetNextSequence("Seq_Demo_CheckPatchDlc")
					end,
				},
			},
		})
	end,
	OnLeave = function(self)
		TppSave.CheckAndSavePersonalData()
	end,
}

sequences.Seq_Demo_CheckPatchDlcForInvitation = {
	OnEnter = function(self)
		if not InvitationManager.IsAccepted() then
			TppSequence.SetNextSequence("Seq_Demo_CheckMgoInvitation")
			return
		end

		PatchDlc.StartCheckingPatchDlc()
		if not PatchDlc.IsCheckingPatchDlc() then
			TppSequence.SetNextSequence("Seq_Demo_CheckMgoInvitation")
			return
		end
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(5100)
	end,
	OnUpdate = function(self)
		if PatchDlc.IsCheckingPatchDlc() then
			return
		end
		TppUiCommand.ErasePopup()
		if TppUiCommand.IsShowPopup() then
			return
		end
		TppSequence.SetNextSequence("Seq_Demo_CheckMgoInvitation")
	end,
}

local function CommonPatchDlcCheckCoroutine(
	dlcType,
	DidCanceledDownloadRequest,
	OnCancelDownloadRequestFunc,
	popUpId_ConfirmDownloadRequest,
	popUpId_DownloadRequestFailed
)
	local function DebugPrintState(state)
		if DebugText then
			local debugDlcTypeText = Tpp.DEBUG_debugDlcTypeTextTable[dlcType]
			DebugText.Print(
				DebugText.NewContext(),
				"CommonPatchDlcCheckCoroutine: dltType = " .. tostring(debugDlcTypeText) .. ", " .. tostring(state)
			)
		end
	end
	local function notExistPatchDlcFunc()
		if not SignIn.IsOnlineSignedIn() then
			return
		end

		if DidCanceledDownloadRequest() then
			Fox.Log("PatchDlc download request cancel, because already canceled. dlcType = " .. tostring(dlcType))
			return
		end

		if not Tpp.IsPatchDlcValidPlatform(dlcType) then
			Fox.Error("Invalid platform. Stop PatchDlc down load request. platform = " .. tostring(platform))
			return false
		end

		TppUiCommand.ShowErrorPopup(popUpId_ConfirmDownloadRequest, Popup.TYPE_TWO_BUTTON)

		while TppUiCommand.IsShowPopup() do
			DebugPrintState("waiting popup closed...")
			coroutine.yield()
		end

		local popUpSelect = TppUiCommand.GetPopupSelect()
		if popUpSelect ~= Popup.SELECT_OK then
			OnCancelDownloadRequestFunc()
			while TppSave.IsSaving() do
				DebugPrintState("waiting saving end...")
				coroutine.yield()
			end
			return false
		end

		PatchDlc.RequestDownloadingPatchDlc(dlcType)
		while PatchDlc.IsRequestingDownloadingPatchDlc() do
			DebugPrintState("PatchDlc download requesting ...")
			TppUI.ShowAccessIconContinue()
			coroutine.yield()
		end

		if PatchDlc.GetRequestDownloadingResult() ~= PatchDlc.REQUEST_DOWNLOADING_RESULT_OK then
			TppUiCommand.ShowErrorPopup(popUpId_DownloadRequestFailed, Popup.TYPE_ONE_BUTTON)

			while TppUiCommand.IsShowPopup() do
				DebugPrintState("waiting popup closed...")
				coroutine.yield()
			end
		end
	end

	return Tpp.PatchDlcCheckCoroutine(nil, notExistPatchDlcFunc, nil, dlcType)
end

sequences.Seq_Demo_CheckPatchDlc = {
	OnEnter = function(self)
		local function InitPatchDlcCheck()
			local function DidCancelMgoPathDlcDownloadRequest()
				Fox.Log("DidCancelMgoPathDlcDownloadRequest")
				if vars.didCancelPatchDlcDownloadRequest == 1 then
					return true
				else
					return false
				end
			end
			local function OnDenyMgoPathDlcDownloadRequest()
				Fox.Log("OnDenyMgoPathDlcDownloadRequest")
				vars.didCancelPatchDlcDownloadRequest = 1
				vars.isPersonalDirty = 1
				TppSave.CheckAndSavePersonalData()
			end

			local popUpId_ConfirmDownloadRequest = 5101

			local popUpId_DownloadRequestFailed = 5102
			return CommonPatchDlcCheckCoroutine(
				PatchDlc.PATCH_DLC_TYPE_MGO_DATA,
				DidCancelMgoPathDlcDownloadRequest,
				OnDenyMgoPathDlcDownloadRequest,
				popUpId_ConfirmDownloadRequest,
				popUpId_DownloadRequestFailed
			)
		end
		mvars.init_patchDlcCheckCoroutine = coroutine.create(InitPatchDlcCheck)
	end,

	OnUpdate = function(self)
		if mvars.init_patchDlcCheckCoroutine then
			local status, ret1 = coroutine.resume(mvars.init_patchDlcCheckCoroutine)

			if not TppGameSequence.IsMaster() then
				if not status then
					Fox.Hungup("Script error in InitPatchDlcCheck")
				end
			end

			if (coroutine.status(mvars.init_patchDlcCheckCoroutine) == "dead") or not status then
				mvars.init_patchDlcCheckCoroutine = nil
				TppSequence.SetNextSequence("Seq_Demo_CheckCompatibilityPatchDlc")
				return ret1
			end
		end
	end,

	OnLeave = function(self) end,

	ignoreSignInUserChanged = true,
}

sequences.Seq_Demo_CheckMgoInvitation = {
	OnEnter = function(self)
		if not InvitationManager.IsAccepted() then
			TppSequence.SetNextSequence("Seq_Demo_CheckDlc")
			return
		end

		if TppException.IsDisabledMgoInChinaKorea() then
			TppUiCommand.ShowErrorPopup(5013, Popup.TYPE_ONE_BUTTON)
			return
		end

		local storySequence = GetSavingSlotStorySequence()

		if not TppStory.CanPlayMgo(storySequence) then
			TppUiCommand.ShowErrorPopup(5004, Popup.TYPE_ONE_BUTTON)
			return
		end

		if not PatchDlc.DoesExistPatchDlc() then
			TppUiCommand.ShowErrorPopup(5006, Popup.TYPE_ONE_BUTTON)
			return
		end

		if not InvitationManager.IsCurrentUserInvited() then
			TppUiCommand.ShowErrorPopup(5005, Popup.TYPE_ONE_BUTTON)
			return
		end

		TppSequence.SetNextSequence("Seq_Demo_CheckMgoChunkInstallation")
	end,

	OnUpdate = function(self)
		if TppUiCommand.IsShowPopup() then
			return
		end

		TppSequence.SetNextSequence("Seq_Demo_CheckDlc")
	end,

	OnLeave = function(self, nextSequenceName)
		if nextSequenceName == "Seq_Demo_CheckDlc" then
			if not InvitationManager.IsAccepted() then
				InvitationManager.EnableMessage(true)
			else
				TppException.CancelMgoInvitation()
			end
		end
	end,
}

sequences.Seq_Demo_CheckMgoChunkInstallation = {
	OnEnter = function(self)
		if Chunk.GetChunkState(Chunk.INDEX_MGO) == Chunk.STATE_INSTALLED then
			TppSequence.SetNextSequence("Seq_Demo_GoToMgo")
			return
		end

		Tpp.StartWaitChunkInstallation(Chunk.INDEX_MGO)
		Tpp.ShowChunkInstallingPopup(Chunk.INDEX_MGO, true)
	end,

	OnUpdate = function(self)
		if Chunk.GetChunkState(Chunk.INDEX_MGO) == Chunk.STATE_INSTALLED then
			Fox.Log("Install Chunk Index:" .. tostring(self.chunkIndex))

			if TppUiCommand.IsShowPopup(TppDefine.ERROR_ID.NOW_INSTALLING) then
				TppUiCommand.ErasePopup()
				return
			end

			TppSequence.SetNextSequence("Seq_Demo_GoToMgo")
			return
		end

		Tpp.ShowChunkInstallingPopup(Chunk.INDEX_MGO, true)

		TppUI.ShowAccessIconContinue()

		if not TppUiCommand.IsShowPopup(TppDefine.ERROR_ID.NOW_INSTALLING) then
			if InvitationManager.IsAccepted() then
				TppSequence.SetNextSequence("Seq_Demo_CheckDlc")
			else
				TppSequence.SetNextSequence("Seq_Demo_Init")
			end
		end
	end,

	OnLeave = function(self, nextSequenceName)
		if nextSequenceName == "Seq_Demo_CheckDlc" then
			TppException.CancelMgoInvitation()
		end
	end,
}

sequences.Seq_Demo_GoToMgo = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		local popUpId
		if InvitationManager.IsAccepted() then
			popUpId = 5000
		else
			popUpId = 5050
		end
		TppUiCommand.ShowErrorPopup(popUpId)
		mvars.init_invitationAcceptedShowTime = 2.0
		TppException.isNowGoingToMgo = true
	end,
	OnUpdate = function(self)
		if mvars.init_invitationAcceptedShowTime then
			mvars.init_invitationAcceptedShowTime = mvars.init_invitationAcceptedShowTime - Time.GetFrameTime()
			if mvars.init_invitationAcceptedShowTime <= 0 then
				TppUiCommand.ErasePopup()
			end
		end

		if TppUiCommand.IsShowPopup() then
			return
		end

		if mvars.init_invitationAcceptedShowTime then
			Mission.SwitchApplication("mgo")
			return
		end
	end,
}

sequences.Seq_Demo_CheckCompatibilityPatchDlc = {
	OnEnter = function(self)
		local function CompatibilityPatchDlcCoroutine()
			local function DidCancelCompatibilityPatchDlcDownloadRequest()
				Fox.Log("DidCancelCompatibilityPatchDlcDownloadRequest")
				if vars.didCancelFobPatchDlcDownloadRequest == 1 then
					return true
				else
					return false
				end
			end
			local function OnDenyCompatibilityPatchDlcDownloadRequest()
				Fox.Log("OnDenyCompatibilityPatchDlcDownloadRequest")
				vars.didCancelFobPatchDlcDownloadRequest = 1
				vars.isPersonalDirty = 1
				TppSave.CheckAndSavePersonalData()
			end

			local popUpId_ConfirmDownloadRequest = 5151

			local popUpId_DownloadRequestFailed = 5152
			return CommonPatchDlcCheckCoroutine(
				PatchDlc.PATCH_DLC_TYPE_TPP_COMPATIBILITY_DATA,
				DidCancelCompatibilityPatchDlcDownloadRequest,
				OnDenyCompatibilityPatchDlcDownloadRequest,
				popUpId_ConfirmDownloadRequest,
				popUpId_DownloadRequestFailed
			)
		end
		mvars.init_CompatibilityPatchDlcCoroutine = coroutine.create(CompatibilityPatchDlcCoroutine)
	end,

	GoNextSequence = function(self)
		TppSequence.SetNextSequence("Seq_Demo_CheckBootTypeMgo")
	end,

	OnUpdate = function(self)
		if mvars.init_CompatibilityPatchDlcCoroutine then
			local status, ret1 = coroutine.resume(mvars.init_CompatibilityPatchDlcCoroutine)

			if not TppGameSequence.IsMaster() then
				if not status then
					Fox.Hungup("Script error in CompatibilityPatchDlcCoroutine")
				end
			end

			if (coroutine.status(mvars.init_CompatibilityPatchDlcCoroutine) == "dead") or not status then
				mvars.init_CompatibilityPatchDlcCoroutine = nil
				self.GoNextSequence()
				return ret1
			end
		end
	end,
}

sequences.Seq_Demo_CheckBootTypeMgo = {
	OnEnter = function(self)
		if (not TppUiCommand.IsBootTypeMGO()) or Mission.IsBootedFromMgo() then
			self.GoCheckBootGz()
			return
		else
			if (not Tpp.IsMaster()) and this.IsWindowsEditor() then
				self.GoCheckBootGz()
				return
			end
		end

		local storySequence = GetSavingSlotStorySequence()

		if not TppStory.CanPlayMgo(storySequence) then
			TppUiCommand.ShowErrorPopup(5051, Popup.TYPE_ONE_BUTTON)
			return
		end

		if not PatchDlc.DoesExistPatchDlc() then
			TppUiCommand.ShowErrorPopup(5103, Popup.TYPE_ONE_BUTTON)
			return
		end

		TppSequence.SetNextSequence("Seq_Demo_CheckMgoChunkInstallation")
	end,

	OnUpdate = function(self)
		if TppUiCommand.IsShowPopup() then
			return
		end

		self.GoCheckBootGz()
	end,

	GoCheckBootGz = function(self)
		TppSequence.SetNextSequence("Seq_Demo_CheckBootGz")
	end,

	OnLeave = function(self, nextSequenceName) end,
}

sequences.Seq_Demo_CheckBootGz = {
	OnEnter = function(self)
		if (not Tpp.IsMaster()) and this.IsWindowsEditor() then
			self.GoInitSequence()
			return
		end

		local storySequence = GetSavingSlotStorySequence()

		if IsPlaystationFamily() and (not Mission.IsBootedFromGz()) and (not TppStory.CanPlayMgo(storySequence)) then
			TppUiCommand.ShowErrorPopup(9030, Popup.TYPE_TWO_BUTTON)
			return
		end

		self.GoInitSequence()
	end,

	OnUpdate = function(self)
		if TppUiCommand.IsShowPopup() then
			return
		end

		local popUpSelect = TppUiCommand.GetPopupSelect()
		if popUpSelect == Popup.SELECT_OK then
			TppSequence.SetNextSequence("Seq_Demo_GoToGz")
		else
			self.GoInitSequence()
		end
	end,

	GoInitSequence = function(self)
		TppSequence.SetNextSequence("Seq_Demo_Init")
	end,

	OnLeave = function(self, nextSequenceName) end,
}

sequences.Seq_Demo_GoToGz = {
	OnEnter = function(self)
		TppUiCommand.SetPopupType("POPUP_TYPE_NO_BUTTON_NO_EFFECT")
		TppUiCommand.ShowErrorPopup(9031)
		mvars.init_goingToGzDialogShowTime = 2.0
	end,
	OnUpdate = function(self)
		if mvars.init_goingToGzDialogShowTime then
			mvars.init_goingToGzDialogShowTime = mvars.init_goingToGzDialogShowTime - Time.GetFrameTime()
			if mvars.init_goingToGzDialogShowTime <= 0 then
				TppUiCommand.ErasePopup()
			end
		end

		if TppUiCommand.IsShowPopup() then
			return
		end

		if mvars.init_goingToGzDialogShowTime then
			Mission.SwitchApplication("gz")
			return
		end
	end,
}

sequences.Seq_Demo_Init = {
	OnEnter = function(self)
		if SignIn then
			SignIn.SetStartupProcessCompleted(true)
		end
		TppUiCommand.CreateEmblem("MyEmblem")
		AvatarPreloadTextureDaemon.PreloadRequestForLocalPlayer()
	end,

	OnUpdate = function(self)
		if DebugText then
			DebugText.Print(DebugText.NewContext(), "Crating emblem Data ...")
		end

		TppUI.ShowAccessIconContinue()

		if TppUiCommand.IsCreatingEmblem() then
			return
		end

		TppSequence.SetNextSequence("Seq_Demo_StartTitle")
	end,
}

sequences.Seq_Demo_StartTitle = {
	OnEnter = function(self)
		if Tpp.IsMaster() then
			Fox.Log("init mission : StartPreTitleSequence for master")
			this.StartPreTitleSequence()
		elseif gvars.DEBUG_initMissionToTitle then
			Fox.Log("init mission : StartPreTitleSequence for debug")
			this.StartPreTitleSequence()
		else
			local platform = Fox.GetPlatformName()
			if Selector then
				if platform ~= "Windows" or not Editor then
					tpp_editor_menu2.StartTestStage(60000)
					return
				else
					local mode = Fox.GetActMode()
					if mode == "GAME" then
						Fox.SetActMode("EDIT")
					end
					TppUI.FadeIn(TppUI.FADE_SPEED.FADE_MOMENT)
					TppSoundDaemon.ResetMute("Loading")
				end
			else
				self.StartQARelealsePreTitleSequence()
			end
		end
	end,

	StartQARelealsePreTitleSequence = function()
		Fox.Log("init mission : StartQARelealsePreTitleSequence")
		if MissionTest and MissionTest.qaReleaseEntryFunction then
			MissionTest.qaReleaseEntryFunction()
		else
			this.StartPreTitleSequence()
		end
	end,
}

sequences.Seq_Demo_ShowKonamiAndFoxLogo = {
	OnEnter = function(self)
		Fox.Log("### Seq_Demo_ShowKonamiAndFoxLogo ###")
		local konamiLogoScreenId = SplashScreen.GetSplashScreenWithName("konamiLogo")
		local kjpLogoScreenId = SplashScreen.GetSplashScreenWithName("kjpLogo")
		local foxLogoScreenId = SplashScreen.GetSplashScreenWithName("foxLogo")

		local function StateCallback(screenId, state)
			if state == SplashScreen.STATE_DELETE then
				Fox.Log("konamiLogoScreen is deleted. show fox logo.")
				SplashScreen.Show(kjpLogoScreenId, 1.0, 4.0, 1.0)
			end
		end
		SplashScreen.SetStateCallback(konamiLogoScreenId, StateCallback)

		local function StateCallback(screenId, state)
			if state == SplashScreen.STATE_DELETE then
				Fox.Log("konamiLogoScreen is deleted. show fox logo.")
				SplashScreen.Show(foxLogoScreenId, 1.0, 4.0, 1.0)
			end
		end
		SplashScreen.SetStateCallback(kjpLogoScreenId, StateCallback)

		SplashScreen.Show(konamiLogoScreenId, 1.0, 4.0, 1.0)

		this._StartPreTitleSequence()
	end,
}

return this
