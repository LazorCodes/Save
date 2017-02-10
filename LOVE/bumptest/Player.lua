local Player = {}
Player.__index = Player

function Player.new(Special)
	local _player = {}
	Special = Special or {}
	setmetatable(_player, Player)

	_player.health = Special.health or 100
	_player.maxhealth = Special.maxhealth or 100
	_player.invmax = Special.invmax or 30
	_player.x = Special.x or 1000
	_player.y = Special.y or 1000
	_player.w = 25
	_player.h = 50
	_player.xvel = Special.xvel or 0
	_player.yvel = Special.yvel or 0
	_player.friction = Special.friction or 3
	_player.class = "player"
	_player.color = Special.color or { 255, 255, 255 }
	_player.speed = Special.speed or 1000
	_player.invx = 5
	_player.invy = 6
	_player.inv = Inventory.new(_player.invx, _player.invy)
	_player.lastAttack = 0
	_player.equipped = Special.equipped or { weapon = Item.new("gun") }


	players[emptyKey(players)] = _player
	world:add(_player, _player.x, _player.y, _player.w, _player.h)
	return _player
end

function Player:changeHealth(Delta, Source, OverrideMax)
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
		self:died(Source)
	end
end

function Player:died(Source)
end

function Player:changeData(Data)
	for k, v in pairs(Data) do
		self[k] = v
	end
end

function Player:isAttacking()
	if self.equipped.weapon ~= nil and self.lastAttack + self.equipped.weapon.func.attackrate > os.clock() then
		return true
	else
		return false
	end
end

function Player:canAttack()
	if self.equipped.weapon ~= nil and self.lastAttack + self.equipped.weapon.func.attackrate < os.clock() then
		self.lastAttack = os.clock()
		return true
	else
		return false
	end
end

return Player
