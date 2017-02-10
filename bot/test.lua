local discordia = require("discordia")
local perm = require("./libs/perm")
local client = discordia.Client:new()
dofile("./libs/tableToXml.lua")
local token = require("../token")
local httpfunctions = require("./libs/httpFunctions")

local function getRole(Table)
	for k, v in pairs(Table) do
		thing = v
		break
	end
	return thing
end



client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content

	local doggo = {}
	if cmd == "playerlist" then
		local str = ""
		for k, v in pairs(message.author.roles) do
			str = str..k.."\n"
			for kr, vr in pairs(v) do
				str = str..kr.."---\n"
			end
		end
		message.channel:sendMessage(str)
	end
	if cmd == "!setdoggo" then
		local thing2 = getRole(message.mentions.roles)
		doggo = getRole(message.mentions.roles)
		message.channel:sendMessage("Pupper")
	end
	if cmd == "!doggo" then
		message.channel:sendMessage("OhMyDog")
		message.author:setRoles(doggo)
	end
end)

client:run(_G.DOGGO_TOKEN)