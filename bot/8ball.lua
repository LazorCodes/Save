local discordia = require("discordia")
local ltable = require("libs/ltable")
local token = require("../token")
local tts = true
local client = discordia.Client:new()
local as = {}
local aswhen = {}
local aswho = {}
local aswhere = {}
local aswhy = {}
local aswhatis = {}
local aswhatisto = {}
local mentions = false
local ts = {}
local tswhen = {}
local tswho = {}
local tswhere = {}
local tswhy = {}
local tswhatis = {}

local players = {}

function randomTime()
	if math.random(1,4) == 1 then
		local minute = math.random(0,59)
		if minute < 10 then
			minute = "0"..tostring(minute)
		else
			minute = tostring(minute)
		end
		if math.random(1,2) == 1 then
			minute = minute.." AM"
		else
			minute = minute.." PM"
		end
		return tostring(math.random(0,12))..":"..minute
	else
		return ltable.randomTableElement(aswhen)
	end
end

client:on("MemberLeave", function(member)
	refreshUsers(member.server)
end)

client:on("MemberJoin", function(member)
	memberJoin(member)
end)

client:on("ready", function()
	p(string.format("Logged in as %s", client.user.username))

	as[1] = "It is certain"
	as[2] = "It is decidedly so"
	as[3] = "Without a doubt"
	as[4] = "Yes, definitely"
	as[5] = "You may rely on it"
	as[6] = "As I see it, yes"
	as[7] = "Most likely"
	as[8] = "Outlook good"
	as[9] = "Yes"
	as[10] = "Signs point to yes"
	as[11] = "Reply hazy try again"
	as[12] = "Ask again later"
	as[13] = "Better not tell you now"
	as[14] = "Cannot predict now"
	as[15] = "Concentrate and ask again"
	as[16] = "Don't count on it"
	as[17] = "My reply is no"
	as[18] = "My sources say no"
	as[19] = "Outlook not so good"
	as[20] = "Very doubtful"
	as[21] = "Trust your feelings"

	aswhen[1] = "Right now"
	aswhen[2] = "At midnight"
	aswhen[3] = "Whenever you feel like it"
	aswhen[4] = "No time is better than 4:20 am"
	aswhen[5] = "Whenever the time is right"
	aswhen[6] = "When I tell you to"
	aswhen[7] = "Tomorrow"
	aswhen[8] = "A few minutes ago"
	aswhen[9] = "Yesterday"
	aswhen[0] = "Never"

	aswho[1] = "Papa franku"
	aswho[2] = "Me"
	aswho[3] = "You"
	aswho[4] = "Shrek"
	aswho[5] = "Bob the Builder"
	aswho[6] = "Lazor our Lord"
	aswho[7] = "GabeN"
	aswho[8] = "JOOOHN CEENAAAA!"
	aswho[9] = "The Doctor"
	aswho[10] = "Not me, that is for sure"
	aswho[11] = "Hugh Mungus"
	aswho[12] = "An honest man"
	aswho[13] = "An enraged feminazi"
	aswho[14] = "Alan Turing's ghost"
	aswho[15] = "A Dalek"
	aswho[16] = "Hillary Clinton"
	aswho[17] = "The leader of the loominarty"
	aswho[18] = "Chingus"
	aswho[19] = "Chase"
	aswho[20] = "Doggo"
	aswho[21] = "@deleted-role"

	aswhere[1] = "Shrek's swamp"
	aswhere[2] = "The white house"
	aswhere[3] = "The best place, but I can't tell you, it's a secret"
	aswhere[4] = "A very spooky place"
	aswhere[5] = "Dank memeville"
	aswhere[6] = "On the middle of the highway"
	aswhere[7] = "Your house"
	aswhere[8] = "The moon"
	aswhere[9] = "Jool"
	aswhere[10] = "Deep space"
	aswhere[11] = "Up here in the hollywood hills"
	aswhere[12] = "Here in my garage"
	aswhere[13] = "Bomb site B"
	aswhere[14] = "In my basement"

	aswhy[1] = "Because I say so"
	aswhy[2] = "A little ailien thought that it would be funny"
	aswhy[3] = "Why not really"
	aswhy[4] = "Because...umm...okay you stumped me"
	aswhy[5] = "It just happened"
	aswhy[6] = "Luck"
	aswhy[7] = "It was an accident"
	aswhy[8] = "Because of you"
	aswhy[9] = "Because we can"
	aswhy[10] = "Due to the butterfly effect"
	aswhy[11] = "It was destined to happen"
	aswhy[12] = "For dramatic effect"
	aswhy[13] = "Because I love you"
	aswhy[14] = "That is just how it is"

	aswhatis[1] = "A huge batch of memes"
	aswhatis[2] = "A bag of flour that you think is drugs"
	aswhatis[3] = "The souls of the innocent"
	aswhatis[4] = "A Bodypillow"
	aswhatis[5] = "Me bottle 'o scrumpy!"
	aswhatis[6] = "This lamborghini here"
	aswhatis[7] = "Knowledge"
	aswhatis[8] = "8Ball's imprisoned soul"
	aswhatis[9] = "An Aperture Science Weighted Companion Cube"
	aswhatis[10] = "A Battle Scarred P90 |  Elite Build"
	aswhatis[11] = "The hours wasted making this program"
	aswhatis[12] = "Sosig"
	aswhatis[13] = "A spooky scary skeleton"
	aswhatis[14] = "TWO NUMBAH NINES, A NUMBAH NINE LEARGE, A NUMBA SIX WITH EXTRA DIP, A NUMBAH SEVEN, TWO NUMBAH FORTY FIVES, ONE WITH CHEESE, AND A LAERGE SODAH."

	aswhatisto[1] = "Spam weeb memes"
	aswhatisto[2] = "Inhaling memes"
	aswhatisto[3] = "Get a gamer chair"
	aswhatisto[4] = "Drink vodka, win Dotka"
	aswhatisto[5] = "Install hax"
	aswhatisto[6] = "Do adderall"
	aswhatisto[8] = "T41k 1n l33t sp43k"
	aswhatisto[9] = "Vote for Trump"
	aswhatisto[10] = "Search \"Lolis\" on google"

	ts["will"] = true
	ts["is"] = true
	ts["does"] = true
	ts["do"] = true
	ts["would"] = true
	ts["can"] = true
	ts["was"] = true
	ts["should"] = true
	ts["shouldn't"] = true
	ts["shouldnt"] = true
	ts["are"] = true
	ts["am"] = true
	ts["did"] = true
	ts["were"] = true
	ts["has"] = true
	ts["have"] = true

	tswhen["when"] = true
	tswhen["what time"] = true

	tswho["who"] = true

	tswhere["where"] = true

	tswhy["why"] = true

	tswhatis["what is"] = true
	tswhatis["what's"] = true
	tswhatis["whats"] = true
	tswhatis["what do"] = true
	tswhatis["wat is"] = true
	tswhatis["wat do"] = true


end)

client:on("messageCreate", function(message)
	if message.channel ~= message.server:getChannelById("238207482789363713") then return end
	if message.author == client.user then return end
	local cmd, arg = string.match(message.content, "(%S+) (.*)")
	if arg == nil then return end
	cmd = cmd or message.content
	cmd = string.lower(cmd)
	arg = string.lower(arg)
	local whole = string.lower(message.content)
	if cmd == "test" then
		refreshUsers(message.server)
	elseif ltable.checkForEntry(ts, whole) and string.sub(arg, -1) == "?" then
		message.channel:createMessage(ltable.randomTableElement(as), mentions, tts)
	elseif ltable.checkForEntry(tswhen, whole) and arg ~= nil and string.sub(arg, -1) == "?" then
		message.channel:createMessage(randomTime(), mentions, tts)
	elseif ltable.checkForEntry(tswho, whole) and string.sub(arg, -1) == "?" then
		message.channel:createMessage(ltable.randomTableElement(aswho), mentions, tts)
	elseif ltable.checkForEntry(tswhere, whole) and string.sub(arg, -1) == "?" then
		message.channel:createMessage(ltable.randomTableElement(aswhere), mentions, tts)
	elseif ltable.checkForEntry(tswhy, whole) and string.sub(arg, -1) == "?" then
		message.channel:createMessage(ltable.randomTableElement(aswhy), mentions, tts)
	elseif ltable.checkForEntry(tswhatis, whole) and string.sub(arg, -1) == "?" then
		if string.find(whole, "to") ~= nil then
			message.channel:createMessage(ltable.randomTableElement(aswhatisto), mentions, tts)
		else
			message.channel:createMessage(ltable.randomTableElement(aswhatis), mentions, tts)
		end
	end
end)

client:run(_G.BALL_TOKEN)


