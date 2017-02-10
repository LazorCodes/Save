local discordia = require("discordia")
local client = discordia.Client:new()
local ROOT_USER = "184262286058323968"
local ROOT_ROLE = "184295756163710976"
local LOG = true
local commands = {}
local token = require("../token")


function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function containsKey(Table, Key)
	return Table[Key] ~= nil
end

function tableToString(Table)
	local keynum = 1
	local tablestring = ""
	for k, v in pairs(Table) do
		tablestring = tablestring..keynum.."   "..v.name.."\n"
		keynum = keynum + 1
	end
	return tablestring
end

function codeblock(String, Arg)
	local language = ""
	if Arg ~=nil then language = Arg end
	return "```"..language.."\n"..String.."\n```"
end

function tableContents(T)
	for k, v in pairs(T) do
		print(k, v)
	end
end

function canUse(User, Command)
	local auth = false
	for k, v in pairs(commands[Command]) do
		if containsKey(User.roles, k) then
			auth =  true
			break
		end
	end
	return auth
end



client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
	local gamen = "Weeb simulator 1"..tostring(math.random(800, 999))
	client:setGameName(gamen)

	commands["doihave"] = {["184295756163710976"] = true}
	commands["roles"] = {["184295756163710976"] = true}
	commands["exit"] = {["184295756163710976"] = true}

	for k, v in pairs(commands) do
		commands[k][ROOT_ROLE] = true
	end

end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content
	cmd = string.sub(cmd, 2)

	if not containsKey(commands, cmd) then return end

	if canUse(message.author, cmd) then
		if cmd == "roles" then
			if not arg then
				message.channel:sendMessage(codeblock(tableToString(message.author.roles), nil))
			else
				if message.server:getMemberByName(arg) ~=nil then
					message.channel:sendMessage(codeblock(tableToString(message.server:getMemberByName(arg).roles), nil))
				else
					message.channel:sendMessage(codeblock("No matching user found"), nil)
				end
			end
		end
		if cmd == "doihave" then
			message.channel:sendMessage(containsKey(message.author.roles, message.server:getRoleByName(arg).id))
		end
		if message.author.id == ROOT_USER then
			if cmd == "exit" then
				client:stop()
			end
		end
	else
		message.channel:sendMessage("You do not have permission to use that command.")
		if LOG then
			local wcmd = ""
			if arg ~= nil then
				wcmd = cmd.." "..arg
			else
				wcmd = cmd
			end
			print(string.format("User %s attempted to call %s in #%s. Failed (Insufficient permissions)", message.author.name, wcmd, message.channel.name))
		end
	end
end
)

client:run(_G.CHINGUS_TOKEN)