local discordia = require("discordia")
local client = discordia.Client()
local token = require("../token")
local msg = nil

client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	msg = message
	if cmd == "!start" then
		local stime = os.time()
		local num = 1
		while true do
			msg = message.channel:sendMessage(tostring(num))
			if num == 20 then
				print(os.time()-stime)
				break
			end
			num = num + 1
		end
	end
end)

client:run(_G.SPOOKY_TOKEN)
