local Weapon = {}
Weapon.__index = Weapon

function Weapon.new(Link, Special)
	local _weapon = {}
	Special = Special or {}
	data = weapons[Link] or {}
	setmetatable(_weapon, Weapon)

	_weapon.damage = Special.damage or data.damage or 1
	_weapon.attackrate = Special.attackrate or data.attackrate or 1
	_weapon.knockback = Special.knockback or data.knockback or 100
	_weapon.attacktime  = Special.attacktime or data.attacktime or 0.5
	_weapon.texture = Special.texture or data.texture or "errorweapon.png"
	_weapon.x = Special.x or data.x or 25
	_weapon.y = Special.y or data.y or 25
	_weapon.w = Special.w or data.w or 25
	_weapon.h = Special.h or data.h or 25

	return _weapon
end

function Weapon:changeData(Data)
	for k, v in pairs(Data) do
		self[k] = v
	end
end

return Weapon
