function love.load()
	love.window.setMode(1500, 900, { vsync = false, borderless = true, resizable = true })
	firetexture = love.graphics.newCanvas(1, 1)
	love.graphics.setCanvas(firetexture)
	love.graphics.setColor(255, 0, 0)
	love.keyboard.setKeyRepeat(enable)
	love.graphics.rectangle("fill", 0, 0, 2, 2)
	particlespread = 1
	planets = {}
	fire = love.graphics.newParticleSystem(firetexture, 10000)
	fire:setEmissionRate(0)
	fire:setSpread(particlespread)
	fire:setParticleLifetime(3)
	fire:setSizes(10, 0)
	fire:setSizeVariation(1)
	fire:setSpeed(300)
	fire:start()
	wx, wy = love.window.getMode()
	renderdistance = math.sqrt(((wx/2)^2) + ((wy/2)^2))
	bullets = {}
	weapons = {
		default = {
			speed = 5000,
			multifire = 10,
			spread = 0.3,
			damage = 1
		}
	}
	totbullets = 0

	DEG90 = math.rad(90)

	function randomFloat(lower, greater)
    	return lower + math.random()  * (greater - lower)
	end

	function firew(Ent, Weapon)
		for i = 1, Weapon.multifire do
			bullets[totbullets] = {
				x = Ent.X,
				y = Ent.Y,
				speed = Weapon.speed,
				dir = ply.rot + math.rad(180) + randomFloat(-Weapon.spread, Weapon.spread),
				time = os.time()
			}
			totbullets = totbullets + 1
		end
	end


	function col(r, g, b, a)
		r = r or 255
		g = g or 255
		b = b or 255
		a = a or 255
		love.graphics.setColor(r, g, b, a)
	end

	function distance(x1, y1, x2, y2)
		local dx, dy = x1 - x2, y1 - y2
		return math.sqrt((dx^2)+(dy^2))
	end

	ply = {
		weapon = "default",
		velx = 0,
		vely = 0,
		speed = 500,
		X = 0,
		Y = 0,
		scale = 1,
		rot = 0,
		model = love.graphics.newCanvas(50, 50, nil, 8)
	}
	for i = 1, 50000 do
		local id = tostring(i)
		local lcol = math.random(100, 255)
		planets[id] = {
			col = { lcol, lcol, lcol },
			x = math.random(-10000, 10000),
			y = math.random(-10000, 10000),
			size = math.random(1,3)
		}
	end
	bullet = love.graphics.newCanvas(50, 50, nil, 8)
	love.graphics.setCanvas(bullet)
	col()
	love.graphics.polygon("fill", 0, 0, 25, 50, 50, 0, 25, 10, 0, 0)
	love.keyboard.setKeyRepeat(true)
	rotspeed = 3
	love.graphics.setCanvas(ply.model)
	love.graphics.setColor(255, 0, 0)
	love.graphics.line(0, 0, 25, 50, 50, 0, 25, 10, 0, 0)
	love.graphics.setCanvas()
end

function love.draw()
	love.graphics.print(tostring(ply.X).." "..tostring(ply.Y))
	love.graphics.translate(ply.X + wx/2, ply.Y + wy/2)
	for k, v in pairs(planets) do
		if distance(-ply.X, -ply.Y, v.x, v.y) < renderdistance then
			love.graphics.setColor(v.col)
			love.graphics.circle("fill", v.x, v.y, v.size)
		end
	end
	col(255, 0, 0)
	for k, v in pairs(bullets) do
		if v.time + 30 < os.time() then
			bullets[k] = nil
		end
		love.graphics.draw(bullet, -v.x, -v.y, v.dir + DEG90, 0.2, 0.2, 25, -200)
	end

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(fire)
	love.graphics.draw(ply.model, -ply.X, -ply.Y, math.rad(-90) + ply.rot, ply.scale, ply.scale, 25, 3)
end

function love.update(Dt)
	fire:update(Dt)
	ply.X = ply.X - ply.velx * Dt
	ply.Y = ply.Y - ply.vely * Dt
	if love.keyboard.isDown("a") then
		ply.rot = ply.rot + rotspeed * Dt
	elseif love.keyboard.isDown("d") then
		ply.rot = ply.rot - rotspeed * Dt
	end
	for k, v in pairs(bullets) do
		v.x = v.x + math.cos(v.dir) * v.speed * Dt
		v.y = v.y + math.sin(v.dir) * v.speed * Dt
	end
	if love.keyboard.isDown("w") then
		fire:setPosition(-ply.X, -ply.Y)
		fire:setDirection(ply.rot + math.deg(180) + particlespread / 2)
		fire:emit(1)
		ply.velx = ply.velx + math.cos(ply.rot) * ply.speed * Dt
		ply.vely = ply.vely + math.sin(ply.rot) * ply.speed * Dt
	end
	-- elseif love.keyboard.isDown("s") then
	-- 	ply.velx = ply.velx - (math.abs(ply.velx) * 0.1) * Dt
	-- 	ply.vely = ply.velx - (math.abs(ply.vely) * 0.1) * Dt
	-- end
end


function love.keypressed(Key)
	if Key == "escape" then
		love.event.quit()
	end
	if Key == "space" then
		firew(ply, weapons[ply.weapon])
	end
end

function love.resize(Nx, Ny)
	wx, wy = Nx, Ny
	renderdistance = math.sqrt(((wx/2)^2) + ((wy/2)^2))
end
