items = require("tradeable")
highest = 0
for k, v in pairs(items) do
	if tonumber(k) > highest then
		highest = tonumber(k)
	end
end
print(highest)