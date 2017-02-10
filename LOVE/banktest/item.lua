Item = {}
Item.__index = Item

function Item.new(Name, Description, Value, Img)
	local wep = {
		name = Name,
		description = Description or  "an item",
		value = Value or 0,
		img = Img or "error.png"
	}
	setmetatable(wep, Weapon)
	return wep
end

return Item
