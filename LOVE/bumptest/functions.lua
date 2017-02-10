function getWall(X, Y, H, W)
	local items, len = world:queryRect(X, Y, H, W)
	for k, v in pairs(items) do
		if v.jumpable == true then
			return true
		end
	end
	return false
end

function addItem(Item, X, Y)
	if Item == nil then print("Attempted to add invalid item.") return end
	if Item == false then return end
	local itm = { class = "item", x = X, y = Y, link = Item.link, yvel = -50, xvel = 0}
	drops[emptyKey(drops)] = itm
	world:add(itm, X, Y, 25, 25)
end


--Functions for counting tables and such
function emptyKey(Tbl)
	for i = 1, 10000 do
		if Tbl[i] == nil then
			return i
		end
	end
end

function tablelen(Tbl)
	local num = 0
	for k, v in pairs(Tbl) do
		num = num + 1
	end
	return num
end

function tabletot(Tbl)
	local num = 0
	for k, v in pairs(Tbl) do
		num = num + v
	end
	return num
end


--Functions for getting drops and giving items
function getDrop(Table)
	if droptables[Table] ~= nil then
		local tbl = droptables[Table]
		local total = tabletot(tbl)
		local drop = math.random(0, total-1)
		local cur = 0
		for i, w in pairs(tbl) do
			cur = cur + w
			if cur > drop then
				if i == "nothing" then
					return false
				else
					return items[i]
				end
			end
		end
	end
end

function giveItem(Item)
	itms[emptyKey(itms)] = items[Item]
	inv = makeInv(5, 6, 7, 50, itms)
end

function removeItem(Num)
	if itms[Num] ~= nil then
		itms[Num] = nil
		for i = Num + 1, 30 do
			if itms[i] == nil then
				break
			else
				itms[i-1] = itms[i]
				itms[i] = nil
			end
		end
	end
	inv = makeInv(5, 6, 7, 50, itms)
end

function moveDrops(Dt)
	for k, v in pairs(drops) do
		if world:hasItem(v) then
			v.yvel = v.yvel + 600 * Dt
			local actualX, actualY, cols, len = world:move(v, v.x + v.xvel * Dt, v.y + v.yvel * Dt, itemFilter)
			v.x, v.y = actualX, actualY
			for i = 1, len do
				if cols[i].other.class == "player" and #itms < maxitms then
					if cols[i].other.inv:isRoom() then
						cols[i].other.inv:give(Item.new(v.link))
						world:remove(v)
					end
				end
			end
		end
	end
end

function initTextures()
	textures.enemy = {}
	for k, v in pairs(enemiesTemplate) do
		if v.texture ~= nil then
			if textures.enemy[k] == nil then
				textures.enemy[v.texture] = love.graphics.newImage(v.texture)
			else
				print("MULTIPLE TEXTURES FOR "..v.texture)
			end
		end
	end
	textures.item = {}
	for k, v in pairs(items) do
		if v.icon ~= nil then
			if textures.item[k] == nil then
				textures.item[v.icon] = love.graphics.newImage(v.icon)
			else
				print("MULTIPLE TEXTURES FOR "..v.icon)
			end
		end
	end
end

function canJump(Ent)
	local items, len = world:queryRect(Ent.x, Ent.y + Ent.h + 1, Ent.w, 1)
	for k, v in pairs(items) do
		if v.jumpable == true then
			return true
		end
	end
	return false
end

function getWall(X, Y, H, W)
	local items, len = world:queryRect(X, Y, H, W)
	for k, v in pairs(items) do
		if v.jumpable == true then
			return true
		end
	end
	return false
end


function drawBox(box)
	love.graphics.setColor(box.color)
	love.graphics.rectangle("line", box.x, box.y, box.w, box.h)
end

function isEnemy(item)
	return item.class == "enemy"
end

function filter(item, other)
	return other.phystype
end

function enemyFilter(item, other)
	if other.class == "enemy" then
		return false
	elseif other.class == "player" then
		return "cross"
	else
		return other.phystype
	end
end

function itemFilter(item, other)
	if other.class == "player" then
		return "cross"
	else
		return other.phystype
	end
end

function killedEnemy(Nmy)
	if Nmy.droptable ~= nil then
		local drp = getDrop(Nmy.droptable)
		if Nmy.h < 25 then
			addItem(drp, Nmy.x, Nmy.y - 25)
		else
			addItem(drp, Nmy.x, Nmy.y)
		end
	end
	world:remove(Nmy)
	Nmy = nil
end

function math.clamp(n, low, high)
	return math.min(math.max(n, low), high)
end

function renderUi()
	renderHealthBar()
end

function renderEnemies()
	for k, v in pairs(mobs) do
		if world:hasItem(v) then
			love.graphics.setColor(v.color)
			if enemiesTemplate[v.type].texture ~= nil then
				love.graphics.draw(textures.enemy[enemiesTemplate[v.type].texture], v.x, v.y)
			else
				love.graphics.rectangle("fill", v.x, v.y, v.w, v.h)
			end
			love.graphics.print(tostring(v.health).."/"..tostring(v.maxhealth), v.x, v.y - 15)
		end
	end
end

function renderDrops()
	for k, v in pairs(drops) do
		if world:hasItem(v) then
			love.graphics.setColor(255, 255, 255)
			if textures.item[items[v.link].icon] ~= nil then
				love.graphics.draw(textures.item[items[v.link].icon], v.x, v.y, 0, 0.5, 0.5)
			else
				love.graphics.setColor(255, 0, 0)
				love.graphics.rectangle("fill", v.x, v.y, 10, 10)
			end
		end
	end
end

function renderScene()
	local cx, cy, cw, ch = camera:getWorld()
	cx, cy = cx + cw, cy + ch
	scene = love.graphics.newCanvas(cx, cy)
	love.graphics.setCanvas(scene)
	for k, v in pairs(map) do
		if v.render == true then
			love.graphics.setColor(255, 255, 255)
			local img = love.graphics.newImage(v.texture)
			img:setWrap("repeat", "repeat")
			local quad = love.graphics.newQuad(0, 0, v.w, v.h, img:getDimensions())
			love.graphics.draw(img, quad, v.x, v.y)
		end
	end
	love.graphics.setCanvas()
	return scene
end

function addBlock(Tbl)
	local block = { class = Tbl.class, x = Tbl.x, y = Tbl.y, w = Tbl.w, h = Tbl.h, phystype = Tbl.phystype, friction = Tbl.friction, jumpable = Tbl.jumpable, color = Tbl.color }
	o[emptyKey(o)] = block
	world:add(block, Tbl.x ,Tbl.y, Tbl.w, Tbl.h)
end

function drawPlayer()
	drawBox(player, 0, 255, 0)
	love.graphics.setColor(255, 255, 255)
end

function addEnemy(Enemy, X, Y)
	if Enemy == nil then print("Attempted to add invalid enemy.") return end
	local nmy = { droptable = Enemy.droptable, type = Enemy.type, name = Enemy.name, damage = Enemy.damage, maxhealth = Enemy.health, health = Enemy.health, class = Enemy.class, gravity = Enemy.gravity, mvdt = 0, lastatt = 0, xvel = 0, yvel = 0, x = X, y = Y, w = Enemy.w, h = Enemy.h, phystype = Enemy.phystype, friction = Enemy.friction, jumpable = false, color = Enemy.color, mvcooldown = Enemy.mvcooldown, attcooldown = Enemy.attcooldown, ai = Enemy.ai }
	mobs[emptyKey(mobs)] = nmy
	world:add(nmy, X, Y, Enemy.w, Enemy.h)
end

function moveEnemies(Dt)
	local renderHealth = false
	local dmgtaken = 0
	for k, v in pairs(mobs) do
		if world:hasItem(v) then
			v.dt = Dt
			if v.gravity == true then
				v.yvel = v.yvel + 600 * Dt
			end
			local actualX, actualY, cols, len = world:move(v, v.x + v.xvel * Dt, v.y + v.yvel * Dt, enemyFilter)
			v.x, v.y = actualX, actualY
			for i = 1, len do
				if cols[i].other.class == "player" then
					if cols[i].item.lastatt + cols[i].item.attrate <= os.clock() then
						cols[i].item.lastatt = os.clock()
						player:changeHealth(-cols[i].item.damage)
						dmgtaken = dmgtaken + cols[i].item.damage
						renderHealth = true
					end
				end
			end
		end
	end
	if renderHealth then
		lastDmg = dmgtaken
		renderHealthBar()
	end
end

function runAi(Dt)
	for k, v in pairs(mobs) do
		if v:canMove() then
			if ai[v.ai] ~= nil then
				ai[v.ai](v, Dt)
			else
				print("Attempted to run bad AI: "..v.ai)
			end
		end
	end
end

function renderHealthBar()
	love.graphics.setCanvas(healthbar)
	love.graphics.clear()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", 0, 0, (player.health / player.maxhealth) * Hw, Hh)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("-"..tostring(lastDmg))
	love.graphics.setCanvas()
end
