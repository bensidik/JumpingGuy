



--player table

player = {
    x = 50,
    y = 300,
    width = 48,
    height = 48,
    speed = 200,
    yVelocity = 0,
    jumpHeight = -400,
    gravity = -500,
    onGround = false,
    images = {},
    currentFrame = 1,
    animationTimer = 0,
    animationInterval = 0.2
}


function love.load()
    love.graphics.setBackgroundColor(0.4, 0.6, 0.9)
    player.images[1] = love.graphics.newImage("IdleNoob.png")
    player.images[2] = love.graphics.newImage("Walk1.png")
    platformImage = love.graphics.newImage("platform.png")
    Walking = love.audio.newSource("step_1.wav", "static")
    Walking:setLooping(false)
    Walking:setVolume(1.0)
    BackgroundMusic = love.audio.newSource("GameBackgroundMusic.mp3", "stream")
    BackgroundMusic:setLooping(true)
    BackgroundMusic:setVolume(0.5)

     -- Define platforms
    platforms = {
        {x = 0, y = 400, width = 800, height = 50},
        {x = 200, y = 300, width = 100, height = 20},
        {x = 350, y = 250, width = 100, height = 20},
        {x = 500, y = 300, width = 100, height = 30}
    }


end

function love.update(dt)
    BackgroundMusic:play()
-- Gravity
    if not player.onGround then
        player.yVelocity = player.yVelocity - player.gravity * dt
    end
    -- Movement
    local moving = false
    if love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        player.x = player.x - player.speed * dt
        if moving then
        WalkSound() 
        end
        moving = true
    elseif love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        player.x = player.x + player.speed * dt
        if moving then
        WalkSound()
        end
        moving = true
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
--animation update
    if moving then
        player.animationTimer = player.animationTimer + dt
        if player.animationTimer >= player.animationInterval then
            player.animationTimer = 0
            player.currentFrame = player.currentFrame % #player.images + 1
        end
    else
        player.currentFrame = 1 --Reset to idle frame
    end

end
function love.keypressed(key)
    if key == "space" and player.onGround then
        player.yVelocity = player.jumpHeight
        player.onGround = true
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
    love.graphics.draw(player.images[player.currentFrame], player.x, player.y)


end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

function WalkSound()
Walking:play()
wait(0.1)

end

function wait(seconds)
    local start = love.timer.getTime()
    while love.timer.getTime() - start < seconds do end
end