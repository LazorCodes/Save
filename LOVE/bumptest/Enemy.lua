local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(Link, Special)
	local _enemy = {}
	data = enemiesTemplate[Link] or {}
	Special = Special or {}
	setmetatable(_enemy, Enemy)

	_enemy.health = Special.health or data.health or 50
	_enemy.maxhealth = Special.maxhealth or data.maxhealth or 50
	_enemy.type = Link or "UNDEFINED TYPE"
	_enemy.texture = data.texture or "errorenemy.png"
	_enemy.droptable = data.droptable or nil
	_enemy.damage = data.damage or 5
	_enemy.ai = data.ai or nil
	_enemy.phystype = data.phystype or "cross"
	_enemy.friction = data.friction or 3
	_enemy.attrate = Special.moverate or data.moverate or 0
	_enemy.lastatt = 0
	_enemy.movrate = data.movrate or 1
	_enemy.lastmov = 0
	_enemy.lastdmg = 0
	_enemy.gravity = data.gravity or true
	_enemy.color = data.color or { 255, 255, 255 }
	_enemy.x = Special.x or data.x or 0
	_enemy.y = Special.y or data.y or 0
	_enemy.w = data.w or 0
	_enemy.h = data.h or 0
	_enemy.xvel = data.xvel or 0
	_enemy.yvel = data.yvel or 0

	mobs[emptyKey(mobs)] = _enemy
	world:add(_enemy, _enemy.x, _enemy.y, _enemy.w, _enemy.h)
	return _enemy
end

function Enemy:changeHealth(Delta, OverrideMax)
	OverrideMax = OverrideMax or false
	if not OverrideMax then
		if self.health + Delta >= self.maxhealth then
			self.health = self.maxhealth
		else
			self.health = self.health + Delta
		end
	else
		self.health = self.health + Delta
	end
	if self.health <= 0 then
	end
end

function Enemy:changeData(Data)
	for k, v in pairs(Data) do
		self[k] = v
	end
end

function Enemy:canMove()
	if self.movrate <= 0 then
		return true
	end
	if self.lastmov + self.movrate < os.clock() then
		self.lastmov = os.clock()
		return true
	else
		return false
	end
end

function Enemy:canAttack()
	if self.attrate <= 0 then
		return true
	end
	if self.lastatt + self.attrate < os.clock() then
		self.lastatt = os.clock()
		return true
	else
		return false
	end
end


return Enemy
