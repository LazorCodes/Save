function love.load()
	love.window.setMode(1500, 900, { resizable = true, vsync = false })
	wx, wy = love.window.getMode()
	love.keyboard.setKeyRepeat(true)
	X, Y = 0, 0
	speed = 600
	spread = 1.5
	turnspeed = 3
	Xvel, Yvel = 0, 0
	fireptcl = love.graphics.newCanvas(1, 1)
	love.graphics.setCanvas(fireptcl)
	love.graphics.setColor(255, 100, 0)
	love.graphics.points(0, 0)
	fire = love.graphics.newParticleSystem(fireptcl, 10000)
	fire:setParticleLifetime(3)
	fire:setEmissionRate(0)
	fire:setSizes(7, 0)
	fire:setSpeed(400)
	fire:setSpread(spread)
	fire:setPosition(0, 0)
	fire:setColors(255, 0, 0, 255, 255, 100, 0, 255)
	fire:setSizeVariation(1)
	fire:start()
	canvas = love.graphics.newCanvas(50, 50, nil, 16)
	love.graphics.setColor(255, 255, 255)
	love.graphics.setCanvas(canvas)
	love.graphics.line(0, 0, 25, 50, 50, 0, 25, 10, 0, 0)
	love.graphics.setCanvas()
	rot = 0
end

function love.draw()
	love.graphics.translate(wx/2, wy/2)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(fire)
	love.graphics.draw(canvas, X, Y, rot + math.rad(-90), 1, 1, 25, 5)
	love.graphics.setColor(0, 255, 0)
	love.graphics.print(love.timer.getFPS())
end

function love.resize(Nx, Ny)
	wx, wy = Nx, Ny
end

function love.update(Dt)
	fire:update(Dt)
	X, Y = X + Xvel * Dt, Y + Yvel * Dt
	if love.keyboard.isDown("d") then
		rot = rot + turnspeed * Dt
	elseif love.keyboard.isDown("a") then
		rot = rot - turnspeed * Dt
	end
	if love.keyboard.isDown("w") then
		fire:setPosition(X, Y)
		fire:setDirection(rot - math.deg(180) - spread / 2)
		fire:emit(1)
		Xvel = Xvel + math.cos(rot) * speed * Dt
		Yvel = Yvel + math.sin(rot) * speed * Dt
	elseif love.keyboard.isDown("s") then
		if math.abs(Xvel) < 0.1 then
			Xvel = 0
		else
			Xvel = Xvel - 1
		end
		if math.abs(Yvel) < 0.1 then
			Yvel = 0
		else
			Yvel = Yvel - 1
		end
	end
end
