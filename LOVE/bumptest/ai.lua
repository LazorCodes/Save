require("functions")
return {
	slime = function(v, dt)
		if canJump(v) then
			v.yvel = -250 + math.random(-10, 10)
			if player.x > v.x then
				v.xvel = v.xvel + 130 + math.random(-10, 10)
			else
				v.xvel = v.xvel - 130 + math.random(-10, 10)
			end
		end
	end,
	zombie = function(v, dt)
		if canJump(v) then
			if player.x > v.x then
				v.xvel = v.xvel + 300 * dt
				if getWall(v.x + v.w + 1, v.y, 1, v.h) then
					v.yvel = -250
				end
			else
				v.xvel = v.xvel - 300 * dt
				if getWall(v.x - 1, v.y, 1, v.h) then
					v.yvel = -250
				end
			end
		end
	end
}
