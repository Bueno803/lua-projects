function love.load()
    math.randomseed(os.time())

    sprites = {}
    sprites.background = love.graphics.newImage('sprites/background.png')
    sprites.bullet = love.graphics.newImage('sprites/bullet.png')
    sprites.player = love.graphics.newImage('sprites/player.png')
    sprites.zombie = love.graphics.newImage('sprites/zombie.png')

    player = {}
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.speed = 180

    zombies = {}
    bullets = {}

    gameFont = love.graphics.newFont(40)
    gameFontT = love.graphics.newFont(30)
    gameScores = love.graphics.newFont(10)

    gameState = 1 -- game state 1 = main menu, game state 2 = main menu
    gameDifficulty = 1 -- game difficulty 1 = easy, 2 = hard

    score = 0
    maxTime = 2
    timer = maxTime
    realTime = 0
    injury = 0 -- injury 1 = player injured, injury 2 = player dead game over
end

function love.update(dt)
    if gameState == 2 then 
        if love.keyboard.isDown("d") and player.x < love.graphics.getWidth() then
            player.x = player.x + player.speed*dt
        end
        if love.keyboard.isDown("a") and player.x > 0 then
            player.x = player.x - player.speed*dt
        end
        if love.keyboard.isDown("w") and player.y > 0 then
            player.y = player.y - player.speed*dt
        end
        if love.keyboard.isDown("s") and player.y < love.graphics.getHeight() then
            player.y = player.y + player.speed*dt
        end
    end

    for i,z in ipairs(zombies) do
        z.x = z.x + math.cos(zombiePlayerAngle(z)) * z.speed * dt
        z.y = z.y + math.sin(zombiePlayerAngle(z)) * z.speed * dt

        if distanceBetween(z.x, z.y, player.x, player.y) < 30 and gameDifficulty == 1 then
            injury = injury + 1
            for i,z in ipairs(zombies) do
                zombies[i] = nil
                if injury == 2 then
                    gameState = 1
                end
            end
        elseif distanceBetween(z.x, z.y, player.x, player.y) < 30 and gameDifficulty == 2 then
            injury = injury + 2
            for i,z in ipairs(zombies) do
                zombies[i] = nil
                if injury == 2 then
                    gameState = 1
                end
            end
        end
    end

    for i,b in ipairs(bullets) do
        b.x = b.x + (math.cos( b.direction )* b.speed * dt)
        b.y = b.y + (math.sin( b.direction )* b.speed * dt)
    end

    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.x < 0 or b.y < 0 or b.x > love.graphics.getWidth() or b.y > love.graphics.getHeight() then
            table.remove(bullets, i)
        end
    end

    for i,z in ipairs(zombies) do
        for j,b in ipairs(bullets) do
            if distanceBetween(z.x, z.y, b.x, b.y) < 20 then
                z.dead = true
                b.dead = true
            end
        end
    end

    for i=#zombies, 1, -1 do
        local z = zombies[i]
        if z.dead == true then
            table.remove(zombies, i)
            score = score + 1
        end
    end

    for i=#bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then
            table.remove(bullets, i)
        end
    end

    if gameState == 2 then
        timer = timer - dt
        realTime = realTime + dt
        if timer <= 0 then 
            maxTime = 0.95 * maxTime
           timer = maxTime
            spawnZombie()
        end
    end

end

function love.draw()
    love.graphics.draw(sprites.background, 0, 0)
    if injury == 1 then
        love.graphics.setColor(.5, 0, 0)
    end

    love.graphics.draw(sprites.player, player.x, player.y, playerMouseAngle(), nil, nil, sprites.player:getWidth()/2, sprites.player:getHeight()/2)
    
    love.graphics.setColor(1, 1, 1)
    if gameState == 1 then
        love.graphics.setFont(gameFont)
        love.graphics.print("Score: " .. score,0,0)
        love.graphics.print("Time: " .. math.ceil(realTime),300,0)

        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", 150, 400, 175, 75)
        love.graphics.rectangle("fill", 450, 400, 175, 75)

        love.graphics.setColor(1,1,1)
        love.graphics.printf("Easy", 190, 410, love.graphics.getWidth(), "left")
        love.graphics.printf("Hard", 490, 410, love.graphics.getWidth(), "left")
        love.graphics.setFont(gameFontT)
    
    elseif gameState == 2 then
        love.graphics.setFont(gameFont)
        love.graphics.print("Score: " .. score,0,0)
        love.graphics.print("Time: " .. math.ceil(realTime),300,0)
    end

    for i,z in ipairs(zombies) do 
        love.graphics.draw(sprites.zombie, z.x, z.y, zombiePlayerAngle(z), nil, nil, sprites.zombie:getWidth()/2, sprites.zombie:getHeight()/2)
    end

    for i,b in ipairs(bullets) do
        love.graphics.draw(sprites.bullet, b.x, b.y, nil, .5, .5, sprites.bullet:getWidth()/2, sprites.bullet:getHeight()/2)
    end
end

function love.keypressed (key)
    if key == "space" then
        spawnZombie()
    end
end

function love.mousepressed(x ,y, button)
    if button == 1 and gameState == 2 then
        spawnBullet()
    elseif button == 1 and gameState == 1 then
        if x > 149 and x < 326 and y > 399 and y < 476 then
            gameDifficulty = 1
            gameState = 2
            maxTime = 2
            realTime = 0
            score = 0
            injury = 0
        elseif x > 449 and x < 626 and y > 399 and y < 476 then
            gameDifficulty = 2
            gameState = 2
            maxTime = 2
            realTime = 0
            score = 0
            injury = 0
        end
    end
end

function playerMouseAngle()
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function zombiePlayerAngle(enemy)
    return math.atan2(player.y - enemy.y, player.x - enemy.x)
end

function spawnZombie()
    local zombie = {}

    zombie.x = 0
    zombie.y = 0

    zombie.speed = 140
    if gameDifficulty == 2 then
        zombie.speed = 180
    end

    zombie.dead = false

    local side = math.random(1, 4)

    if side == 1 then
        zombie.x = -30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 2 then
        zombie.x = love.graphics.getWidth() + 30
        zombie.y = math.random(0, love.graphics.getHeight())
    elseif side == 3 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = -30
    elseif side == 4 then
        zombie.x = math.random(0, love.graphics.getWidth())
        zombie.y = love.graphics.getHeight() + 30
    end
    table.insert(zombies, zombie)
end

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y

    bullet.speed = 500

    bullet.dead = false

    bullet.direction = playerMouseAngle()

    table.insert(bullets, bullet)
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end