local base = 15000
local mul = 4410

local function lwrite(String)
	local file = io.open("./ranks.txt", "a")
	io.output(file)
	io.write(String.."\n")
	io.close(file)
end
local num = base
for i = 1, 120 do
	lwrite(tostring(tostring(num)..","))
	p(i,(num/60)/60, 31536000-num)
	num = num + mul * i
end
