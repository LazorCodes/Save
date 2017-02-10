function love.load()
	canvas = love.graphics.newCanvas()
	Color = { 0 , 0 , 0 }
	X, Y = 0, 0
	love.keyboard.setKeyRepeat(true)

	function rainbow(t)
		local t2 = t
		if t2.1  == 0 then
			t2.2 = t2.2 - 1
			t2.3 = t2.3 + 1
			if t2.3 == 256 then
				t2.3 = 255
				t2.1 = 1
			end
		elseif t2.2 == 0 then
			t2.3 = t2.3 - 1
			t2.1 = t2.1 + 1
			if t2.1 == 256 then
				t2.1 = 255
				t2.2 = 1
			end
		else
			t2.1 = t2.1 - 1
			t2.2 = t2.2 + 1
			if t2.2 == 255 then
				t2.2 = 255
				t2.3 = 1
			end
		end
	end
end

function love.draw()
	if Color == 255 then
		Color = 0
	else
		Color = Color + 1
	end
	love.graphics.setCanvas(canvas)
	love.graphics.setColor(100, 100, Color)
	love.graphics.circle("fill", X, Y, 20)
	love.graphics.setCanvas()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(canvas)
end

function love.keypressed(Key)
	if Key == "a" then
		X = X -10
	elseif Key == "d" then
		X = X + 10
	elseif Key == "w" then
		Y = Y - 10
	elseif Key == "s" then
		Y = Y + 10
	end
end
