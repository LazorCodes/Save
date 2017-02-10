local discordia = require("discordia")
local client = discordia.Client()
-- local token = require("../token")
local json = require("json")

local sendlist = {
	"184262286058323968",
	"176992954412433408"
}

local games = {}

local realgames = {
	["World of Warcraft"] = true,
	["Garry's Mod"] = true,
	["Team Fortress 2"] = true,
	["Counter-Strike: Global Offensive"] = true,
	["DOTA 2"] = true,
	["GarrysMod"] = true,
	["Borderlands 2"] = true,
	["Nuclear Throne"] = true,
	["Grand Theft Auto V"] = true,
	["Overwatch"] = true,
	["Warframe"] = true,
	["Insurgency"] = true,
	["RuneScape"] = true,
	["League of Legends"] = true,
	["Battlefield 1"] = true,
	["Grand Theft Auto: San Andreas"] = true,
	["Rust"] = true,
	["osu!"] = true,
	["Hotline Miami 2"] = true,
	["ASTRONEER Early Access"] = true,
	["ROBLOX"] = true,
	["Half-Life 2"] = true,
	["Miscreated"] = true,
	["Counter-Strike Source"] = true,
	["Ballistic"] = true,
	["Rocket League"] = true,
	["The Binding of Isaac: Rebirth"] = true,
	["Goat Simulator"] = true,
	["Killing Floor 2"] = true,
	["Call of Duty: Modern Warfare 2"] = true,
	["INSIDE"] = true,
	["War Thunder"] = true,
	["Left 4 Dead 2"] = true,
	["Tom Clancy's Rainbow Six Siege"] = true,
	["Minecraft"] = true,
	["Call of Duty: World at War"] = true,
	["Tower Unite"] = true,
	["bittriprunner2"] = true,
	["Call of Duty Black Ops"] = true,
	["Guns of Icarus - Online"] = true,
	["TY the Tasmanian Tiger"] = true,
	["Dying Light"] = true,
	["PAYDAY: The Heist"] = true,
	["Killing Floor"] = true,
	["OrcsMustDieUnchained"] = true,
	["Gotham City Impostors F2P"] = true,
	["DiRT 3"] = true,
	["Fallout New Vegas"] = true,
	["Destination Sol"] = true,
	["brainbread2"] = true,
	["Brawlhalla"] = true,
	["Fallout 4"] = true,
	["Block n Load"] = true,
	["Portal 2"] = true,
	["Age Of Empires 3"] = true,
	["X-Blades"] = true,
	["Just Cause 3"] = true,
	["Trine 2"] = true,
	["Factorio"] = true,
	["ClusterTruck"] = true,
	["ManiaPlanet"] = true,
	["Terrorhedron"] = true,
	["Starbound"] = true,
	["star conflict"] = true,
	["Space Engineers"] = true,
	["ShellShock Live"] = true,
	["Reassembly"] = true,
	["Evolve"] = true,
	["Unturned"] = true,
	["Don't Starve"] = true,
	["Cloudbuilt"] = true,
	["FadingHearts"] = true,
	["FTL: Faster Than Light"] = true,
	["skyrim"] = true,
	["GearUp"] = true,
}

local blacklist = {
	["Rambo 6: Succ"] = true,
	["Chromium"] = true,
	["Msg me on Yahoo instead"] = true,
	["nothing "] = true,
	["ok"] = true,
	["CPUCores"] = true,
	["Anime"] = true,
	["nothing, making Videos."] = true,
}

local file = io.open("games.json", "r")
io.input(file)
local allgames = io.read("*a")
io.close(file)

local gamedata = json.decode(allgames) or {}

local file = io.open("ugames.json", "r")
io.input(file)
local allugames = io.read("*a")
io.close(file)

ukgames = {}

local unknowngames = json.decode(allugames) or {}

function getTotal(Tbl)
	local num = 0
	for k, v in pairs(Tbl) do
		for i, j in pairs(v) do
			num = num + 1
		end
	end
	return num
end

for k, v in pairs(realgames) do
	if gamedata[k] == nil then
		gamedata[k] = {}
	end
end
local file = io.open("games.json", "w+")
io.output(file)
io.write(json.encode(gamedata))
io.close(file)


client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
	local changestr = "```Changes:\n"
	local changes = 0
	for guild in client.guilds do
		for member in guild.members do
			if not member.bot then
				if member.gameName ~= nil and not blacklist[member.gameName] then
					if realgames[member.gameName] ~= nil then
						if gamedata[member.gameName][member.id] ~= member.username then
							 gamedata[member.gameName][member.id] = member.username
							 changes = changes + 1
							 changestr = changestr..member.username.." > "..member.gameName.."\n"
						end
					else
						ukgames[member.gameName] = true
						unknowngames[member.gameName] = true
					end
				end
			end
		end
	end
	local file = io.open("games.json", "w+")
	io.output(file)
	io.write(json.encode(gamedata))
	io.close(file)
	local file = io.open("ugames.json", "w+")
	io.output(file)
	io.write(json.encode(unknowngames))
	io.close(file)
	local str = "```\nUnrecognised games:\n"
	for k, v in pairs(ukgames) do
		str = str..k.."\n"
	end
	str = str.."```"
	changestr = changestr.."```"
	for k, v in pairs(sendlist) do
		client:getUser(v):sendMessage(str)
		client:getUser(v):sendMessage("```Done. "..tostring(changes).." change(s) made.\nThere are now "..tostring(getTotal(gamedata)).." total users/games registered.\n```")
		if changes > 0 then
			client:getUser(v):sendMessage(changestr)
		end
		client:getUser(v):sendMessage("`##########################################`")
	end
	if client.user.gameName ~= tostring(getTotal(gamedata)).." ("..tostring(changes)..")" then
		client:setGameName(tostring(getTotal(gamedata)).." ("..tostring(changes)..")")
	end
	client:stop(true)
end)

-- client:on("messageCreate", function(message)
-- 	if message.author == client.user then return end
-- 	local cmd, arg = string.match(message.content, "(%S+) (.*)")
-- 	cmd = cmd or message.content
-- end)

client:run("MjM5Mzk5NzU2MTM5MzMxNTg0.Cu-2sg.3CVNC_nXrsJSSTr7NKnc86C-tZw")
