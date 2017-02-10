local Item = {}
Item.__index = Item

function Item.new(Link, Special)
	local _item = {}
	Special = Special or {}
	data = items[Link] or {}
	setmetatable(_item, Item)

	_item.name = Special.name or data.name or "NO NAME"
	_item.description = Special.description or data.description or "NO DESCRIPTION"
	_item.type = Special.type or data.type or "UNDEFINED TYPE"
	_item.price = Special.price or data.price or 0
	_item.link = Special.link or data.link or Link or "UNLINKED ITEM"
	_item.icon = Special.icon or data.icon or "error.png"
	_item.func = Special.func or data.func or {}

	return _item
end

function Item:changeData(Data)
	for k, v in pairs(Data) do
		self[k] = v
	end
end

return Item
