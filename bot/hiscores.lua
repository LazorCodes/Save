
local discordia = require("discordia")
local client = discordia.Client()
local token = require("../token")
local http = require("coro-http")
local json = require("./libs/json")
tradeable = dofile("./tradeable.lua")

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function tablelen(Table)
	local num = 0
	for k, v in pairs(Table) do
		num = num + 1
	end
	return num
end

skills = {
	"Overall",
	"Attack",
	"Defence",
	"Strength",
	"Constitution",
	"Ranged",
	"Prayer",
	"Magic",
	"Cooking",
	"Woodcutting",
	"Fletching",
	"Fishing",
	"Firemaking",
	"Crafting",
	"Smithing",
	"Mining",
	"Herblore",
	"Agility",
	"Thieving",
	"Slayer",
	"Farming",
	"Runecrafting",
	"Hunter",
	"Construction",
	"Summoning",
	"Dungeoneering",
	"Divination",
	"Invention"
}

function searchItem(String)
	local items = {}
	String = string.lower(String)
	for k, v in pairs(tradeable) do
		local fm, lm = string.find(string.lower(v.name), String)
		if fm ~= nil then
			if fm == 1 and lm == string.len(v.name) then
				items = {}
				items[k] = v
				break
			end
			items[k] = v
		end
	end
	return items
end



function rsCsv(String)
	local data = split(String, ",\n")
	local stats = {}
	for i = 1, 28 do
		stats[skills[i]] = {
			rank = data[(i-1) * 3 + 1],
			level = data[(i-1) * 3 + 2],
			xp = data[(i-1) * 3 + 3]
		}
	end
	return stats
end

client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content

	if cmd == "!levels" then
		if not arg then return end
		local res, data = http.request("GET", "http://services.runescape.com/m=hiscore/index_lite.ws?player="..arg)
		local skls = rsCsv(data)
		if tonumber(skls.Overall.xp) == nil then return end
		local prt = "```\nPlayer: "..arg.."\n\n    SKILL      LEVEL    XP\n"
		for k, v in pairs(skills) do
			prt = prt..v..string.rep(" ", 15 - string.len(v))..tostring(skls[v].level)..string.rep(" ", 5 - string.len(tostring(skls[v].level)))..tostring(skls[v].xp).."\n"
		end
		prt = prt.."```"
		message.channel:sendMessage(prt)
	elseif cmd == "!debug" then
		if not arg then return end
		local items = searchItem(arg)
		local titems = tablelen(items)
		if titems == 0 then
			message.channel:sendMessage(string.format("Item '%s' was not found or is not tradeable.", arg))
		elseif titems == 1 then
			message.channel:sendMessage(json.encode(item))
		elseif titems > 1 then
			local returnstr = "Multiple matches found:"
			for k, v in pairs(items) do
				returnstr = returnstr..json.encode(v).."\n"
			end
			message.channel:sendMessage(returnstr)
		end
	elseif cmd == "!ge" then
		local items = searchItem(arg)
		local titems = tablelen(items)
		if not arg then return end
		if titems == 0 then
			message.channel:sendMessage(string.format("```\nItem '%s' was not found or is not tradeable.```", arg))
		elseif titems == 1 then
			local item, id = {}, nil
			for k, v in pairs(items) do item, id = v, k break end
			local res, data = http.request("GET", "http://services.runescape.com/m=itemdb_rs/api/catalogue/detail.json?item="..tostring(id))
			local idata = json.decode(data)
			item = idata.item
			message.channel:sendMessage(string.format("```\n%s:\n%s (ID:%d)\nMembers item: %s\nPrice:%sGP (%sGP Today)\nPast 30 days: %s\nPast 90 days: %s\nPast 180 days:%s```", item.name, item.type, tostring(item.id), item.members, item.current.price, item.today.price, item.day30.change, item.day90.change, item.day180.change))
		elseif titems > 1 then
			local returnstr = nil
			if titems > 50 then
				returnstr = "```\nFound "..tostring(titems).." matches, but can only display 50.\nPlease refine your search and try again.```"
			else
				returnstr = "```Multiple matches found:\n"
				for k, v in pairs(items) do
					returnstr = returnstr..v.name.."\n"
				end
				returnstr = returnstr.."Please specify for GE price```"
			end
			message.channel:sendMessage(returnstr)
		end --id, type, name, description, current, today, day30, day90, day180, members
	elseif cmd == "!activity" then
		if not arg then return end
		arg = string.gsub(arg, "%s", "_")
		local res, data = http.request("GET", "https://apps.runescape.com/runemetrics/profile/profile?user="..arg.."&activities=20")
		local temp_ = json.decode(data)
		if temp_.error ~= nil then
			if temp_.error == "NO_PROFILE" then
				message.channel:sendMessage("`Error: Player does not exist.`")
			elseif temp_.error == "PROFILE_PRIVATE" then
				message.channel:sendMessage("`Error: Player's profile is private.`")
			else
				message.channel:sendMessage("`Unknown error: '"..temp_.error.."'. Please contact lazor`")
			end
			return nil
		end
		activity = temp_.activities
		local returnstr = "```\nRecent activity for "..temp_.name..":\n"
		for k, v in pairs(activity) do
			returnstr = returnstr..string.sub(v.date, 1, 6).."   "..v.text.."\n"
		end
		returnstr = returnstr.."```"
		message.channel:sendMessage(returnstr)
	end
end)

client:run(_G.SPOOKY_TOKEN)
local res, data = http.request('GET', Url)
