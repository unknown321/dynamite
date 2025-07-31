local script_loader = {}
local master_key = nil -- master key, see init
local reload_key = nil -- see init
local helpers = require("helpers")
local LIP = require("LIP")
local keys = {}
local modules = {}
local initialized = false
local playSound = false

function script_loader.read_config()
	local config_path = helpers.get_game_path() .. "\\dynamite\\dynamite.ini"
	if helpers.readable(config_path) == nil then
		return nil
	end

	local config = LIP.load(config_path)
	return config
end

function script_loader.apply_config()
	local t = script_loader.read_config()
	if t == nil then
		helpers.log("Cannot read config", true)
		return
	end

	helpers.log("Binding keys..", true)
	modules = {}
	keys = {}
	for k, v in pairs(t) do
		if string.sub(k, 1, #"Keys PlayerPad.") == "Keys PlayerPad." then
			-- reload modules
			-- this check is important so different functions from the same
			-- module can use upvalues together. Without it there will be trouble
			local sanitizedModule = v["Module"]:match("^%s*(.-)%s*$")

			if modules[sanitizedModule] == nil then
				if helpers.searchpath(sanitizedModule, package.path) == nil then
					helpers.log("Module " .. sanitizedModule .. " not found on disk, using built-in reference")
					modules[sanitizedModule] = package.loaded[sanitizedModule]
				else
					helpers.log("Reloading module " .. sanitizedModule .. " from disk")
					package.loaded[sanitizedModule] = nil
					local ok = false
					local f = function()
						return require(sanitizedModule)
					end

					ok, modules[sanitizedModule] = xpcall(f, script_loader.error_handler)
					if not ok then
						helpers.log("Require module'" .. sanitizedModule .. "': fail", true, "e")
					end

					if modules[sanitizedModule] == nil then
						helpers.log("Require module'" .. sanitizedModule .. "': nil", true, "e")
					end
				end
			end

			local sanitizedFunction = v["Function"]:match("^%s*(.-)%s*$")

			local keyName = k:sub(#"Keys " + 1)
			-- get numcode for pressed key and put it into table along with function
			local playerKey = loadstring("return " .. keyName)()

			keys[playerKey] = modules[sanitizedModule][sanitizedFunction]
			helpers.log("Key: " .. keyName .. " -> " .. sanitizedModule .. "." .. sanitizedFunction)
		end
	end

	helpers.log("Keys bound", true)
end

function script_loader.error_handler(err)
	helpers.log("ERROR: " .. tostring(err), true, "e")
end

function script_loader.init(force)
	if script_loader.initialized and not force then
		return
	end

	helpers.log("Initializing")

	local t = script_loader.read_config()
	if t == nil then
		helpers.log("Cannot read config", true)
		script_loader.initialized = true
		return
	end

	script_loader.playSound = t["Misc"]["PlaySound"]:match("^%s*(.-)%s*$")

	script_loader.master_key = PlayerPad.ZOOM_CHANGE
	local key_name = t["Dynamite"]["MasterKey"]
	if key_name ~= nil then
		local sanKey = key_name:match("^%s*(.-)%s*$")
		if string.sub(sanKey, 1, #"PlayerPad.") == "PlayerPad." then
			script_loader.master_key = loadstring("return " .. sanKey)()
			helpers.log("Master key: " .. sanKey)
		else
			helpers.log("Invalid master key: " .. key_name .. ", using PlayerPad.ZOOM_CHANGE (default)")
		end
	else
		helpers.log("Master key: PlayerPad.ZOOM_CHANGE")
	end

	script_loader.reload_key = PlayerPad.ACTION
	key_name = t["Dynamite"]["ReloadKey"]
	if key_name ~= nil then
		local sanKey = key_name:match("^%s*(.-)%s*$")
		if string.sub(sanKey, 1, #"PlayerPad.") == "PlayerPad." then
			script_loader.reload_key = loadstring("return " .. sanKey)()
			helpers.log("Reload key: " .. sanKey)
		else
			helpers.log("Invalid reload key: " .. key_name .. ", using PlayerPad.ACTION (default)")
		end
	else
		helpers.log("Reload key: PlayerPad.ACTION")
	end

	script_loader.initialized = true
	helpers.log("Initialized")

	script_loader.apply_config()
end

function script_loader.OnAllocate() end

function script_loader.OnInitialize() end

function script_loader.Update()
	script_loader.init(false)

	if bit.band(PlayerVars.scannedButtonsDirect, script_loader.master_key) == script_loader.master_key then
		if Time.GetRawElapsedTimeSinceStartUp() - script_loader.hold_pressed > 1 then
			script_loader.hold_pressed = Time.GetRawElapsedTimeSinceStartUp()

			for k, v in pairs(keys) do
				if bit.band(PlayerVars.scannedButtonsDirect, k) == k then
					if script_loader.playSound == "true" then
						TppMusicManager.PostJingleEvent("SingleShot", "sfx_s_title_slct_mission")
					end
					xpcall(v, script_loader.error_handler)
				end
			end

			-- press E
			if bit.band(PlayerVars.scannedButtonsDirect, script_loader.reload_key) == script_loader.reload_key then
				script_loader.init(true)
			end
		end
	else
		script_loader.hold_pressed = Time.GetRawElapsedTimeSinceStartUp()
	end
end

function script_loader.OnTerminate() end

return script_loader
