local M = {}
local json = require("./json")

local function randomTableElement(Table)
	return Table[math.random(1, #Table)]
end
M.randomTableElement = randomTableElement

local function numKeys(Table)
	local num = 0
	for _ in pairs(Table) do
		num = num + 1
	end
	return num
end
M.numKeys = numKeys

local function containsKey(Table, Key)
	return Table[Key] ~= nil
end
M.containsKey = containsKey

local function checkForEntry(Table, String)
	local found = false
	for k, v in pairs(Table) do
		if string.find(String, k) == 1 then
			found = true
			break
		end
	end
	return found
end
M.checkForEntry = checkForEntry

local function printKeys(Table)
	if type(Table) ~= "table" then return end
	for k, v in pairs(Table) do
		print(k)
	end
end
M.printKeys = printKeys

local function printTableData(Table)
	local spacing = 20
	if type(Table) ~= "table" then return end
	for k, v in pairs(Table) do
		if type(v) == "number" then
			v = tonumber(v)
		elseif type(v) == "boolean" then
			if v then
				v = "true"
			else
				v = "false"
			end
		elseif type(v) == "table" then
			local vd = v
			v = ""
			for kr, vr in pairs(vd) do
				if type(vr) == "number" then
					vr = tonumber(vr)
				elseif type(vr) == "boolean" then
					if vr then
						vr = "true"
					else
						vr = "false"
					end
				elseif type(vr) ~= "string" then
					vr = type(vr)
				end
				v = v.."   "..kr..":"..vr
			end
		elseif type(v) ~= "string" then
			v = type(v)
		end
		if type(k) == "string" then
			print(k..string.rep(" ", spacing - string.len(k))..v)
		else
			print(k..string.rep(" ", spacing - string.len(tostring(k)))..v)
		end
	end
end
M.printTableData = printTableData

local function lstring(Val)
	local kind = type(Val)
	if kind == "string" then
		return Val
	elseif kind == "number" then
		return tostring(Val)
	else
		return nil
	end
end

--[[
local function printTable(Table)
	local spacing = 20
	local str = ""
	for k, v in pairs(Table) do
		local key = lstring(k)
		local start = key..string.rep(" ", spacing - key:len())
		if type(v) == "string" then
			str = str..start..v.."\n"
		elseif type(v) == "number" then
			str = str..start..tostring(v).."\n"
		elseif type(v) == "boolean" then
			str = str..start..tostring(v).."\n"
		elseif type(v) == "table" then
			for kr, vr in pairs(v) dov
				local keyr = lstring(kr)
				local tblstr = ""
				if type(vr) == "string"

--]]




local function tableJson(Table)
	local str = "```json\n"..json.encode(Table, { indent = true }).."\n```"
	if str:len() > 2000 then
		return "`String too long.`"
	else
		return str
	end
end
M.tableJson = tableJson

return M
