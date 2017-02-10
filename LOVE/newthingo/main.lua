--You're too slow!

function love.load()
	paused = false
	love.window.setMode(500, 1000, { resizable = false })
	wx, wy = love.window.getMode()
	Xp, Yp = wx / 2, wy - 20
	Speed = 7
	Radius = 10
	tiles = {}
	ntiles = 1
	function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
		return
		x1 < x2 + w2 and
		x2 < x1 + w1 and
		y1 < y2 + h2 and
		y2 < y1 + h1
	end
	score = 0
	interval = 0.1
	time = 0

	function addTile(X, Y, Col)
		Y = Y or 0
		Col = Col or { math.random(100, 255), math.random(100, 255), math.random(100, 255) }
		ntiles = ntiles + 1
		tiles[ntiles] = {
			x = X,
			y = Y,
			col =  Col
		}
	end

	function rain(x1, x2, It, Ti)
		local Col = { math.random(100, 255), math.random(100, 255), math.random(100, 255) }
		local sep = (x2 - x1) / It
		for i = 0, It - 1 do
			addTile(x1+sep*i, -i*Ti, Col)
		end
	end
end

function love.draw()
	love.graphics.rectangle("fill", Xp, Yp, Radius, Radius)
	for k, v in pairs(tiles) do
		love.graphics.setColor(v.col)
		love.graphics.rectangle("fill", v.x, v.y, 7, 7)
	end
	love.graphics.print(tostring(score).." "..tostring(math.floor(interval*100)/100))
end

function love.update(Dt)
	if not paused then
		time = time + Dt
		if time >= interval then
			addTile(math.random(0, wx - 7))
			if math.random(1, 10) == 1 then
				rain(math.random(0, wx), math.random(0, wx), math.random(2, 10), math.random(20, 100))
			end
			time = time - interval
		end
		if love.keyboard.isDown("a") then
			if Xp > Speed then
				Xp = Xp - Speed
			else
				Xp = 0
			end
		elseif love.keyboard.isDown("d") then
			if Xp < wx - Radius then
				Xp = Xp + Speed
			end
		end
		for k, v in pairs(tiles) do
			if checkCollision(v.x, v.y, 7, 7, Xp, Yp, Radius, Radius) then
				paused = true
			elseif v.y > wy then
				tiles[k] = nil
				score = score + 1
				interval = interval * 0.99
			else
				v.y = v.y + Dt * 600
			end
		end
	end
end

function love.resize(Nx, Ny)
	wx, wy = Nx, Ny
	Yp = wy - 20
	if Xp > wx - Radius then
		Xp = wx - Radius
	end
end

function love.keypressed(Key)
	if Key == "space" then
		rain(math.random(0, wx - 20), 0, math.random(2, 6), 50)
	end
end
