-- client.lua
print("client")
require "enet"
local host = enet.host_create()
local server = host:connect("localhost:6789")

local done = false
while not done do
  local event = host:service(100)
  if event then
    if event.type == "connect" then
      print("Connected to", event.peer)
      event.peer:send("hello world")
    elseif event.type == "receive" then
      print("Got message: ", event.data, event.peer)
      done = true
    end
  end
end

server:disconnect()
host:flush()