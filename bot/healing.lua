local xml = require("./libs/httpFunctions")

file = io.open("players.xml", "r")
io.input(file)
string = io.read("*a")
io.close(file)

table = xml.xmlToTable(string)
table2 = {}
num = 1

for k, v in pairs(table.root.gameME.playerlist.player) do
	table2[num] = {name = v.name, heal = v.healedpoints, id = v.uniqueid}
	num = num + 1
end

table3 = {}
num = 1
repeat
	maxheal = 0
	id = nil
	for k, v in pairs(table2) do
		if tonumber(v.heal) > maxheal then
			maxheal = tonumber(v.heal)
			id = v.id
			sname = v.name
			delete = k
		end
	end
	table3[num] = {sid = id, name = sname, total = maxheal}
	table2[delete] = nil
	num = num + 1
until num == 1000

local file = io.open("healedstats.txt", "w+")
io.output(file)

for k, v in ipairs(table3) do
	if v.sid == nil then idd = "nothing" else idd = v.sid end
	io.write(k..","..v.name..","..idd..","..tostring(v.total).."\n")
end
