

--player table

player = {
    x = 50,
    y = 300,
    width = 48,
    height = 48,
    speed = 200,
    yVelocity = 0,
    jumpHeight = -500,
    gravity = -800,
    onGround = false
}

function love.load()
    love.graphics.setBackgroundColor(0.4, 0.6, 0.9)
    player.image = love.graphics.newImage("IdleNoob.png")
    platformImage = love.graphics.newImage("platform.png")

     -- Define platforms
    platforms = {
        {x = 0, y = 400, width = 800, height = 50},
        {x = 200, y = 300, width = 100, height = 20},
        {x = 350, y = 250, width = 100, height = 20},
        {x = 500, y = 300, width = 100, height = 30}
    }


end

function love.update(dt)
-- Gravity
    if not player.onGround then
        player.yVelocity = player.yVelocity - player.gravity * dt
    end
    -- Movement
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
    end
    -- Apply vertical velocity
    player.y = player.y + player.yVelocity * dt
    player.onGround = false
    -- Collision with platforms
    for _, plat in ipairs(platforms) do
        if checkCollision(player, plat) then
            if player.y + player.height <= plat.y + player.yVelocity * dt then
                player.y = plat.y - (player.height)
                player.yVelocity = 1
                player.onGround = true
            end
        end
    end


end
function love.keypressed(key)
    if key == "space" and player.onGround then
        player.yVelocity = player.jumpHeight
        player.onGround = false
    end
end

function love.draw()
  -- Draw platforms
    for _, plat in ipairs(platforms) do
        if platformImage then
            love.graphics.draw(platformImage, plat.x, plat.y, 0,
                plat.width / platformImage:getWidth(),
                plat.height / platformImage:getHeight())
        else
            love.graphics.setColor(0, 0.8, 0)
            love.graphics.rectangle("fill", plat.x, plat.y, plat.width, plat.height)
        end
    end
    -- Draw player
    love.graphics.setColor(1, 1, 1) -- Reset color
    love.graphics.draw(player.image, player.x, player.y)


end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end