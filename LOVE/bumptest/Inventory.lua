
local Inventory = {}
Inventory.__index = Inventory

function Inventory.new(X, Y, Items)
	local _inventory = {}
	setmetatable(_inventory, Inventory)

	_inventory.x = X or 1
	_inventory.y = Y or 1
	_inventory.max = _inventory.x * _inventory.y
	_inventory.contents = Items or {}
	_inventory.count = tablelen(_inventory.contents)
	_inventory:render()

	return _inventory
end

function Inventory:give(Item, Pos)
	self.contents[Pos or emptyKey(self.contents)] = Item
	return Item
end

function Inventory:isRoom()
	return self.max < self.count
end

function Inventory:render()
	local Buf, Ts = 7, 50
	local cnvs = love.graphics.newCanvas(self.x*Ts+(self.x-1)*Buf+2, self.y*Ts+(self.y-1)*Buf+2, nil, 8)
	love.graphics.setCanvas(cnvs)
	local Num = 1
	for j = 0, self.y - 1 do
		for i = 0, self.x - 1 do
			love.graphics.setColor(200, 0, 0)
			love.graphics.rectangle("line", i*Ts+i*Buf+1, j*Ts+j*Buf+1, Ts, Ts)
			if self.contents[Num] and self.contents[Num].icon then
				love.graphics.setColor(255, 255, 255)
				if textures.item[self.contents[Num].icon] then
					love.graphics.draw(textures.item[self.contents[Num].icon], i*Ts+i*Buf+1, j*Ts+j*Buf+1)
				else
					love.graphics.setColor(255, 0, 0)
					love.graphics.rectangle("fill", i*Ts+i*Buf+1, j*Ts+j*Buf+1, Ts, Ts)
				end
			end
			Num = Num + 1
		end
	end
	love.graphics.setCanvas()
	self.canvas = cnvs
	return cnvs
end


return Inventory
