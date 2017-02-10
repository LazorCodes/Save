local discordia = require("discordia")
local client = discordia.Client()
local token = require("../token")
local SPLITTER = "§"

local responses = {}
responses["is"] = {}

local qs = {}

function loadAns(String)
	local file = io.open("./ans/"..String..".txt", "r")
	if file == nil then return end
	io.input(file)
	local num = 1
	for line in io.lines() do
		local splt = string.find(line, SPLITTER)
		responses.is[num] = string.sub(line, 1, splt - 1)
		num = num + 1
	end
end

function addAns(String, Ans, User)
	if string == nil then return end
	local file = io.open("./ans/"..String..".txt", "a")
	io.output(file)
	io.write("\n"..Ans.."§ ID: "..User.id.." Name: "..User.name)
	loadAns(String)
end

function splt(String, Match)
	if String == nil or Match == nil then return end
	local tbl = {}
	local num = 1
	for word in string.gmatch(String, "[^"..Match.."]") do
		tbl[num] = word
		num = num + 1
	end
	return tbl
end
client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
	if responses ~= nil then
		for k, v in pairs(responses) do
			loadAns(k)
		end
	end
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	cmd = string.lower(cmd)
	local argw = splt(arg, "%s")


	if string.sub(cmd, 1, 4) == "!add" then
		addAns(string.sub(cmd, 5), arg, message.author)
	end
end)

client:run(_G.BALL_TOKEN)
