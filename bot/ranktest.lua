local discordia = require("discordia")
local client = discordia.Client()
local token = require("../token")




local rankxp = {
	0,
	15000,
	19410,
	28230,
	41460,
	59100,
	81150,
	107610,
	138480,
	173760,
	213450,
	257550,
	306060,
	358980,
	416310,
	478050,
	544200,
	614760,
	689730,
	769110,
	852900,
	941100,
	1033710,
	1130730,
	1232160,
	1338000,
	1448250,
	1562910,
	1681980,
	1805460,
	1933350,
	2065650,
	2202360,
	2343480,
	2489010,
	2638950,
	2793300,
	2952060,
	3115230,
	3282810,
	3454800,
	3631200,
	3812010,
	3997230,
	4186860,
	4380900,
	4579350,
	4782210,
	4989480,
	5201160,
	5417250,
	5637750,
	5862660,
	6091980,
	6325710,
	6563850,
	6806400,
	7053360,
	7304730,
	7560510,
	7820700,
	8085300,
	8354310,
	8627730,
	8905560,
	9187800,
	9474450,
	9765510,
	10060980,
	10360860,
	10665150,
	10973850,
	11286960,
	11604480,
	11926410,
	12252750,
	12583500,
	12918660,
	13258230,
	13602210,
	13950600,
	14303400,
	14660610,
	15022230,
	15388260,
	15758700,
	16133550,
	16512810,
	16896480,
	17284560,
	17677050,
	18073950,
	18475260,
	18880980,
	19291110,
	19705650,
	20124600,
	20547960,
	20975730,
	21407910,
	21844500,
	22285500,
	22730910,
	23180730,
	23634960,
	24093600,
	24556650,
	25024110,
	25495980,
	25972260,
	26452950,
	26938050,
	27427560,
	27921480,
	28419810,
	28922550,
	29429700,
	29941260,
	30457230,
	30977610
}

local levels = {}

local function diffdate(Date)
	local d1 = {
		year = tonumber(string.sub(os.date("%F"), 1, 4)),
		month = tonumber(string.sub(os.date("%F"), 6, 7)),
		day = tonumber(string.sub(os.date("%F"), 9, 10))
	}
	local d2 = {
		year = tonumber(string.sub(Date, 1, 4)),
		month = tonumber(string.sub(Date, 6, 7)),
		day = tonumber(string.sub(Date, 9, 10))
	}
	print(string.format("Member joined at %d, it is now %d. They have been here for %d", os.time(d2), os.time(d1), os.difftime(os.time(d1), os.time(d2))))
	return os.difftime(os.time(d1), os.time(d2))
end

local function maxlevel(Number)
	local level = 120
	local levelxp = 0
	for i = 1, 120 do
		if rankxp[i] > Number then
			level = i - 1
			levelxp = rankxp[i - 1]
			nextlevelxp = rankxp[i]
			break
		end
	end
	print(string.format("Member had a total of %d xp, bringing them over %d required to get them to level %d", Number, levelxp, level))
	return level, Number, nextlevelxp - Number
end

local function removeroles(Guild)
	for role in Guild.roles  do
		if string.sub(role.name, 1, 5) == "Level" then
			print("Deleted role "..role.name)
			role:delete()
		end
	end
end

local function lwrite(String)
	local file = io.open("./levels.txt", "a")
	io.output(file)
	io.write(String)
	io.close(file)
end

local function createroles(Guild)
	local file = io.open("./levels.txt", "w+")
	io.close(file)
	for i = 1, 120 do
		levels[i] = Guild:createRole()
		levels[i].position = i + 7
		levels[i].name = "Level "..tonumber(i)
		levels[i].color = discordia.Color(math.floor(i * 2.125), 0, 255 - math.floor(i * 2.125))
		levels[i].hoist = true
		levels[i].mentionable = false
		print(string.format("Creating role %d of 120 (%f procent):%s", i, i/1.2, levels[i].name))
		lwrite(levels[i].id.."\n")
	end
end

local function giveroles(Guild)
	for member in Guild.members do
		print("Calculating level for "..member.name.."...")
		member:addRoles(levels[maxlevel(diffdate(member.joinedAt))])
	end
end

function fileExists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local function loadroles(Guild)
	local num = 1
	for line in io.lines("./levels.txt") do
		levels[num] = Guild:getRole(line)
		print(string.format("Loaded role with id %s. Name: %s. Role %d#", line, levels[num].name, num))
		num = num + 1
	end
end

local levels = {}

local function gettime(Message)
	local level, number, nextlevelxp = maxlevel(diffdate(Message.member.joinedAt))
	return string.format("`You have %d xp, bringing you to level %d. Next level in %d xp.`", number, level, nextlevelxp)
end

client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))
end)

client:on("messageCreate", function(message)
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	cmd = cmd or message.content

	if cmd == "!test" then
		for user in message.guild.members do
			print(user.name.."   "..tonumber(diffdate(user.joinedAt)))
		end
	end

	if cmd == "!createroles" then
		if message.author.id ~= message.guild.owner.id then return end
		if true then
			createroles(message.guild)
		end
	end
	if cmd == "!deleteroles" then
		if message.author.id ~= message.guild.owner.id then return end
		removeroles(message.guild)
	end

	if cmd == "!test2" then
		if message.author.id ~= message.guild.owner.id then return end
		for roles in message.guild.roles do
			print(roles.name.."  "..tostring(roles.position))
		end
	elseif cmd == "!pos" then
		if message.author.id ~= message.guild.owner.id then return end
		for role in message.mentionedRoles do
			role.position = 9
		end
	elseif cmd == "!giveroles" then
		if message.author.id ~= message.guild.owner.id then return end
		giveroles(message.guild)
	elseif cmd == "!loadroles" then
		loadroles(message.guild)
	elseif cmd == "!time" then
		message.channel:sendMessage(gettime(message))
	end
end)

client:run(_G.SPOOKY_TOKEN)
