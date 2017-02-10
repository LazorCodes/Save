local discordia = require("discordia")
local ltable = require("./libs/ltable")
local client = discordia.Client()
local token = require("../token")


client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content

	if cmd == "!permissions" then
		if message.member == message.guild.owner then
			for role in message.member.roles do
				message.channel:sendMessage(role.name.."\n"..ltable.tableJson(role.permissions:toTable()))
			end
		end
	end

end)

client:run(_G.SPOOKY_TOKEN)
