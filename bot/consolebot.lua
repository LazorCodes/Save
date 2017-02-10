local discordia = require("discordia")
local client = discordia.Client()
local token = require("../token")

local function capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end


client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	if cmd == "!console" then
		if message.author.id ~= message.guild.owner.id then return end
		if not arg then return end
		local str = capture(arg, false)
		message.channel:sendMessage("```\n"..str.."\n```")
	elseif cmd == "luarun" then
		if not arg then return end
		if message.author.id ~= message.guild.owner.id then return end
		local file = io.open("./cfile.lua", "w+")
		io.output(file)
		io.write(arg)
		io.close(file)
		os.execute("lua cfile.lua > test.txt 2>&1", false)
		local file = io.open("./test.txt")
		io.input(file)
		message.channel:sendMessage("```lua\n"..arg.."\n```")
		message.channel:sendMessage("```Output:\n"..io.read("*a").."\n```")
		message:delete()
		io.close(file)
	elseif cmd == "lua" then
end)

client:run(_G.SPOOKY_TOKEN)
