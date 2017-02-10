function love.load()
	Item = require("item")

	ICONS = {}
	function getIcons(Dir)
		local dir = love.filesystem.getDirectoryItems(Dir)
		for k, v in pairs(dir) do
			if dir[k]:sub(-4) == ".png" then
				if not ICONS[dir[k]] then
					ICONS[dir[k]] = love.graphics.newImage(Dir.."/"..dir[k])
				else
					print(dir[k], "HAS MULTIPLE ICONS")
				end
			end
		end
	end

	getIcons("test")

	col = love.graphics.setColor
	testo = love.graphics.newCanvas(50, 50)
	love.graphics.setCanvas(testo)
	love.graphics.rectangle("fill", 3, 3, 45, 25)
	love.graphics.setCanvas()

	Bulet = Item.new("Bulet", "an bulet. shoted from wepon", 420)
	Wepon = Item.new("Wepon", "us the bulet wit thise", 69, "wepon.png")

	Inventory = {
		Bulet,
		Wepon,
		Bulet,
		Bulet
	}

	Menuy = 0

	function makeInv(X, Y, Buf, Ts, Inv)
		local cnvs = love.graphics.newCanvas(X*Ts+(X-1)*Buf+1, Y*Ts+(Y-1)*Buf+1, nil, 8)
		love.graphics.setCanvas(cnvs)
		local Or, Og, Ob, Oa = love.graphics.getColor()
		local Num = 1
		for j = 0, Y - 1 do
			for i = 0, X - 1 do
				love.graphics.rectangle("line", i*Ts+i*Buf+1, j*Ts+j*Buf+1, Ts, Ts)
				if Inv[Num] and Inv[Num].img then
					love.graphics.setColor(255, 255, 255)
					if ICONS[Inv[Num].img] then
						love.graphics.draw(ICONS[Inv[Num].img], i*Ts+i*Buf+1, j*Ts+j*Buf+1)
					else
						love.graphics.draw(ICONS["error.png"], i*Ts+i*Buf+1, j*Ts+j*Buf+1)
					end
					love.graphics.setColor(Or, Og, Ob, Oa)
				end
				Num = Num + 1
			end
		end
		love.graphics.setCanvas()
		return cnvs
	end

	bank = makeInv(5, 8, 7, 50, Inventory)
end

function love.draw()
	love.graphics.draw(bank, 0, Menuy)
end

function love.wheelmoved(x, y)
	Menuy = Menuy + y * 10
end
