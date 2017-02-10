local discordia = require("discordia")
local client = discordia.Client()
local token = require("../token")
local source = require("./libs/source")


client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	if message.author.id ~= message.channel.guild.owner.id then return end

	if cmd == "!test" then
		message.channel:sendMessage(source.remove())
	end
end)

client:run(_G.SPOOKY_TOKEN)
