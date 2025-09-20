local this = {}

local MainOnAllocate = TppMain.OnAllocate
local MainOnInitialize = TppMain.OnInitialize
local MainOnReload = TppMain.OnReload
local MainOnUpdate = TppMain.OnUpdate
local MainOnChangeSVars = TppMain.OnChangeSVars
local MainOnMessage = TppMain.OnMessage
local MainOnTerminate = TppMain.OnTerminate

local helpers = require("helpers")

this.OnAllocate = function(subScripts)
	return MainOnAllocate(subScripts)
end

this.OnInitialize = function(subScripts)
	return MainOnInitialize(subScripts)
end

this.OnReload = function(subScripts)
	return MainOnReload(subScripts)
end

this.OnUpdate = function(subScripts)
	return MainOnUpdate(subScripts)
end

this.OnChangeSVars = function(subScripts, varName, key)
	return MainOnChangeSVars(subScripts, varName, key)
end

this.OnMessage = function(subScripts, sender, messageId, arg0, arg1, arg2, arg3)
	helpers.log(
		"OnMessage: "
			.. ", mgsid: "
			.. tostring(messageId)
			.. ", sender: "
			.. tostring(sender)
			.. ", arg0: "
			.. tostring(arg0)
			.. ", arg1: "
			.. tostring(arg1)
			.. ", arg2: "
			.. tostring(arg2)
			.. ", arg3: "
			.. tostring(arg3)
	)
	return MainOnMessage(subScripts, sender, messageId, arg0, arg1, arg2, arg3)
end

this.OnTerminate = function(subScripts)
	return MainOnTerminate(subScripts)
end

return this
