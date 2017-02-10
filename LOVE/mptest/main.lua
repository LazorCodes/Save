-- LOVE2D Networking example for /u/Dankpex and /r/love2d

math.randomseed(os.time())
socket = require "socket"

love.window.setTitle("LOVE Networking example")
love.window.setMode(400,200)

hosting = false
joined = false
lastpacket = ""


function love.draw()

    if hosting then
        love.graphics.setColor(255,80,80)
        love.graphics.print("Hosting Mode",0,0)
        love.graphics.print("Received packets will be sent back with 1 added",0,15)

    elseif joined then
        love.graphics.setColor(80,100,255)
        love.graphics.print("Sending Mode",0,0)
        love.graphics.print("Press space bar to send random number to host",0,15)

    else
        love.graphics.print("Press h to host",0,0)
        love.graphics.print("Press j to join on 127.0.0.1",0,15)
    end

    love.graphics.print("Last received packet: "..lastpacket,0,45)

end

function love.update(dt)

    if hosting then
        get,ip,port = udp:receivefrom()
        if get ~= nil then
            lastpacket = get
            udp:sendto(tostring(get)+1,ip,port) -- send packet back with 1 added
        end

    elseif joined then
        get,ip,port = udp:receivefrom()
        if get ~= nil then
            lastpacket = get
        end
    end

end

function love.keypressed(k)
    if k == "h" then
        host()

    elseif k == "j" then
        join()

    elseif k == "space" then
        if joined then
            udp:sendto(math.random(0,100),"127.0.0.1",2222) -- send a random number when space is pressed
        end

    elseif k == "escape" then
        love.event.quit()
    end
end

function host()
    hosting = true

    udp = socket.udp()
    udp:setsockname("*",2222)
    udp:settimeout(0)
end

function join()
    joined = true

    udp = socket.udp()
    udp:setsockname("*",math.random(1000,9999))
    udp:settimeout(0)
end