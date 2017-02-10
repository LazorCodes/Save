local discordia = require("discordia")
local client = discordia.Client()
local token = require("../token")
local source = require("./libs/source")

local banned = {}

client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	if banned[message.member.id] == true then return end
	if cmd == "!ban" then
		for member in message.mentionedUsers do
			banned[member.id] = true
		end
	elseif cmd == "!kill" then
		source.kill()
	elseif cmd == "!taunt" then
		if not arg then return end
		source.taunt(arg)
	elseif cmd == "!class" then
		if not arg then return end
		source.changeClass(arg)
	elseif cmd == "!jump" then
		source.jump()
	elseif cmd == "!crouch" then
		if not arg then return end
		source.crouch(arg)
	elseif cmd == "!explode" then
		source.explode()
	elseif cmd == "!say" then
		if not arg then return end
		source.say(message.author.name..": "..arg)
	elseif cmd == "!sayteam" then
		if not arg then return end
		source.sayTeam(arg)
	elseif cmd == "!rtd" then
		source.rtd()
	elseif cmd == "!bonkme" then
		if not arg then return end
		source.bonkme(arg)
	end
end)


client:run(_G.BALL_TOKEN)
