local M = {}

local cfgdir = "C:/Program Files (x86)/Steam/steamapps/common//Team Fortress 2/tf/cfg/source.cfg"
local condir = "C:/Program Files (x86)/Steam/steamapps/common//Team Fortress 2/tf/condump000.txt"

local function fileExists(Path)
   local file = io.open(Path, "r")
   if file ~= nil then
	   io.close(file)
	   return true
   else
	   return false
   end
end

local function remove()
	local file = io.open(cfgdir, "r")
	io.output(file)
	local txt = io.read("*a")
	io.close(file)
	os.remove(condir)
	os.remove(cfgdir)
	return txt
end

local function run(Command)
	local txt = remove()
	file = io.open(cfgdir, "w")
	io.output(file)
	io.write(string.format("condump;%s", Command))
	io.close(file)

	while true do
		if fileExists(condir) then
			txt = txt..remove()
			break
		end
	end
	return txt
end

local function move(Direction, Time)
	run(string.format("+%s;wait %d;-%s", Direction, Time, Direction))
end

local function kill()
	run("kill")
end

local function explode()
	run("explode")
end

local function taunt(Taunt)
	if tonumber(Taunt) ~= nil then
		run("taunt "..Taunt)
	else
		run("taunt_by_name Taunt: "..Taunt)
	end
end

local function jump()
	run("+jump;wait 4;-jump")
end

local function crouch(Time)
	run(string.format("+duck;wait %d;-duck", Time))
end

local function say(String)
	if string.sub(String, 1, 1) == "!" then return end
	if string.sub(String, 1, 1) == "/" then return end
	run("say "..String)
end

local function sayTeam(String)
	if string.sub(String, 1, 1) == "!" then return end
	if string.sub(String, 1, 1) == "/" then return end
	run("say_team "..String)
end

local classes = {
	scout = "1",
	soldier = "2",
	pyro = "3",
	demo = "4",
	demoman = "4",
	heavy = "5",
	heavyweapons = "5",
	engineer = "6",
	medic = "7",
	sniper = "8",
	spy = "9"
}

local function addtarget(String)
	target = String or "random"
	if tonumber(target) ~= nil then
		run("sm_addtarget "..target)
	elseif classes[target] ~= nil then
		run("sm_addtarget "..classes[target])
	elseif target == "random" then
		run("sm_addtarget")
	end
end

local function changeClass(String)
	class = String or "random"
	if classes[class] ~= nil then
		run("join_class "..class)
	elseif class == "random" then
		run("sm_addtarget "..classes[math.random(1, 9)])
	end
end

local function fov(Fov)
	run("fov_desired "..Fov)
end

local function viewmodelFov(Fov)
	run("viewmodel_fov "..Fov)
end

local function sensitivity(Sensitivity)
	run("sensitivity "..Sensitivity)
end

local function rtd()
	run("sm_rtd")
end

local function bonkme(Time)
	if tonumber(target) ~= nil then
		run("sm_bonkme "..Time)
	end
end

M = {
	run = run,
	remove = remove,
	move = move,
	kill = kill,
	explode = explode,
	taunt = taunt,
	jump = jump,
	crouch = crouch,
	say = say,
	sayTeam = sayTeam,
	addtarget = addtarget,
	changeClass = changeClass,
	fov = fov,
	viewmodelFov = viewmodelFov,
	sensitivity = sensitivity,
	rtd = rtd,
	bonkme = bonkme
}

return M
