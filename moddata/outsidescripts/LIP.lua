--[[
	Copyright (c) 2012 Carreras Nicolas
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
--]]
--- Lua INI Parser.
-- It has never been that simple to use INI files with Lua.
--@author Dynodzzo

-- https://github.com/Dynodzzo/Lua_INI_Parser/blob/533d48746a5c4688fc21e8583a61ac6590d12e8b/LIP.lua
-- modified to work without asserts and file:lines()

local LIP = {};

--- Returns a table containing all the data from the INI file.
--@param fileName The name of the INI file to parse. [string]
--@return The table containing all data from the INI file. [table]
function LIP.load(fileName)
    local file = io.open(fileName, 'r')
    local content = file:read("*all")
    file:close()

    local data = {}
    local section
    for line in content:gmatch("([^\r\n]+)[\r\n]*") do
        local tempSection = line:match('^%[([^%[%]]+)%]$')
        if (tempSection) then
            section = tonumber(tempSection) and tonumber(tempSection) or tempSection
            data[section] = data[section] or {}
        end
        local param, value = line:match('^([%w|_]+)%s-=%s-(.+)$')
        if (param and value ~= nil) then
            if (tonumber(value)) then
                value = tonumber(value)
            elseif (value == 'true') then
                value = true;
            elseif (value == 'false') then
                value = false;
            end
            if (tonumber(param)) then
                param = tonumber(param)
            end
            data[section][param] = value
        end
    end

    return data
end

return LIP;