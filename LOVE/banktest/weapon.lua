Weapon = {}
Weapon.__index = Weapon

function Weapon.new(Damage, Speed, Type)
	local wep = {
		damage = Damage or 10,
		speed = Speed or 5,
		type = Type or "undefined"
	}
	setmetatable(wep, Weapon)
	return wep
end

function Weapon:getInfo()
	return tostring(self.damage)..","..tostring(self.speed)..","..self.type
end

return Weapon
