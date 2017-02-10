local discordia = require("discordia")
local client = discordia.Client()
local token = require("../token")


client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	if cmd == "N" then
		message.author:sendMessage(message.guild.owner.avatar)
	end
end)

client:run(_G.SKUFS_TOKEN)
