local ltable = require("./ltable")

local weapons = {}
weapons["dagger"] = {}
weapons["hammer"] = {}
weapons["broadsword"] = {}
weapons["axe"] = {}
weapons["shortsword"] = {}
weapons["spear"] = {}
local num = 1

while true do
	print("Enter weapon type")
	local wep = string.lower(io.read())
	if wep == "done" then
		break
	end
	print("Enter weapon damage")
	local dmg = tonumber(io.read())
	print("Enter weapon speed")
	local spd = tonumber(io.read())
	local pwr = nil

	if wep == "d" or wep == "dagger" then
		wep = "dagger"
	elseif wep == "h" or wep == "hammer" then
		wep = "hammer"
	elseif wep == "b" or wep == "broadsword" then
		wep = "broadsword"
	elseif wep == "a" or wep == "axe" then
		wep = "axe"
	elseif wep == "s" or wep == "shortsword" then
		wep = "shortsword"
	elseif wep == "p" or wep == "spear" then
		wep = "spear"
	else
		print("Enter weapon power")
		pwr = tonumber(io.read())
	end

	weapons[wep][num].damage = dmg * 0.1
	weapons[wep][num].speed = spd * 0.1
	weapons[wep][num].power = pwr * 0.1

	weapons[wep][num].score = dmg * spd
	if pwr ~= nil then
		weapons[wep][num].pwrdmg = dmg / pwr
		weapons[wep][num].spdclip = spd * pwr
	else
		weapons[wep][num].pwrdmg = nil
		weapons[wep][num].spdclip = nil
	end
end

local file = io.open("weapons.txt", "w")
io.output(file)
io.write(ltable.tableJson(weapons))
io.close(file)
