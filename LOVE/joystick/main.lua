function love.load()
	debug1 = ""
	debug2 = ""
end

function love.draw()
	love.graphics.print(tostring(debug1)..", "..tostring(debug2))
end

-- function love.keypressed(Key, Scan)
-- 	debug1 = Key
-- 	debug2 = Scan
-- end

function love.joystickpressed(Key, Scan)
	debug1 = Key
	debug2 = Scan
end