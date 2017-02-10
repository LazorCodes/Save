function love.load()
	Inventory = require("Inventory")
	Weapon = require("Weapon")
	Item = require("Item")
	Player = require("Player")
	Enemy = require("Enemy")
	bump = require("bump")
	gamera = require("gamera")

	players = {}
	mobs = {}
	o = {}
	drops = {}
	love.window.setMode(800, 600, { resizable = true, vsync = false, minwidth = 301, minheight = 600 })
	Wx, Wy = love.window.getMode()
	camera = gamera.new(0, 0, 2000, 2000)
	camera:setWindow(300, 0, Wx - 300, 600)

	map = require("world1")
	enemiesTemplate = require("enemies")
	weapons = require("weapons")
	ai = require("ai")
	items = require("items")
	droptables = require("droptables")

	require("functions")


	curweapon = "wepon"
	lastAttack = 0
	attdir = "nothing"
	lastDmg = 0
	inventory = {}

	debug = 0
	maxspeed = 10000

	world = bump.newWorld(50)

	love.keyboard.setKeyRepeat(true)
	textures = {}

	Hw, Hh = 300, 25
	healthbar = love.graphics.newCanvas(Hw, Hh)
	maxitms = 30

	for k, v in pairs(map) do
		addBlock(v)
	end

	player = Player.new()
	player:changeHealth(-50)
	initTextures()
	renderScene()
	renderUi()
end

function love.draw()
	camera:setPosition(player.x + player.w/2, player.y + player.h/2)
	camera:draw(function(l,t,w,h)
			love.graphics.draw(scene)
			renderEnemies()
			renderDrops()
			drawPlayer()
			if player:isAttacking() then
				local wep = player.equipped.weapon.func
				if attdir == "left" then
					love.graphics.rectangle("line", player.x, player.y + wep.y, -wep.w, wep.h)
				elseif attdir == "right" then
					love.graphics.rectangle("line", player.x + wep.x, player.y + wep.y, wep.w, wep.h)
				end
			end
		end)
	love.graphics.print("FPS:"..tostring(love.timer.getFPS()).." Slimes:"..tostring(debug))
	love.graphics.draw(healthbar, 0, 25)
	love.graphics.draw(player.inv.canvas, 10, 250)
end

function love.keypressed(Key)
	if Key == "w" then
		if canJump(player) then
			player.yvel = -300
		end
	elseif Key == "v" then
		addEnemy(enemiesTemplate.zombie, 1000, 1000)
	elseif Key == "space" then
		Enemy.new("basicslime", { x = 1000, y = 1000 })
	elseif Key == "b" then
		addEnemy(enemiesTemplate.basicslime2, 1000, 1000)
	elseif Key == "z" then
	end
end

function love.update(Dt)
	player.yvel = player.yvel + 600 * Dt
	if love.keyboard.isDown("d") and canJump(player) then
		player.friction = 0
		player.xvel = math.clamp(player.xvel + player.speed * Dt, -maxspeed, maxspeed)
	elseif love.keyboard.isDown("a") and canJump(player) then
		player.friction = 0
		player.xvel = math.clamp(player.xvel - player.speed * Dt, -maxspeed, maxspeed)
	else
		player.friction = 3
	end
	moveDrops(Dt)
	moveEnemies(Dt)
	runAi(Dt)
	player.dt = Dt
	local actualX, actualY, cols, len = world:move(player, player.x + player.xvel * Dt, player.y + player.yvel * Dt, filter)
	player.x, player.y = actualX, actualY
end

function love.resize(Nx, Ny)
	Wx, Wy = Nx, Ny
	camera:setWindow(300, 0, Wx - 300, Ny)
end

function love.mousepressed(Xp, Yp, Button, IsTouch)
	if Button == 1 then
		if player:canAttack() then
			local wep = player.equipped.weapon.func
			local pcx, pcy = camera:toScreen(player.x, player.y)
			local items, len = {}, 0
			if Xp > pcx then
				attdir = "right"
				items, len = world:queryRect(player.x + wep.x, player.y + wep.y, wep.w, wep.h, isEnemy)
			else
				attdir = "left"
				items, len = world:queryRect(player.x - wep.w, player.y + wep.y, wep.w, wep.h, isEnemy)
			end
			for k, v in pairs(items) do
				if v.health <= wep.damage then
					killedEnemy(v)
				else
					v.health = v.health - wep.damage
					if attdir == "right" then
						v.xvel = v.xvel + wep.knockback
					elseif attdir == "left" then
						v.xvel = v.xvel - wep.knockback
					end
				end
			end
		end
	end
end
