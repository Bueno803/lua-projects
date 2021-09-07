playerStartX = 360      -- Globally set start coordinance for player
playerStartY = 100

player = world:newRectangleCollider(playerStartX, playerStartY, 50, 110, {collision_class = "Player"})      -- creates a player collider of shape rectangle and collision class player with parameters taking the 
player:setFixedRotation(true)                                                                               -- coordinance of player start location and width and hieght of player picture scale
player.speed = 240
player.animation = animations.idle
player.isMoving = false
player.direction = 1
player.isGrounded = true

function playerUpdate(dt)       -- 
    if player.body then
        local colliders = world:queryRectangleArea(player:getX() - 25, player:getY() + 55, 50, 2, {'Platform'})     --creates a collision collider that query checks if player is colliding with a platform
        
        if #colliders > 0 then
            player.isGrounded = true
        else
            player.isGrounded = false
        end

        player.isMoving = false
        local px, py = player:getPosition()

        if love.keyboard.isDown('right') then          -- checks if keyboard button is pressed for movement left and right, which then changes direction accordingly
            player:setX(px + player.speed * dt)
            player.isMoving = true
            player.direction = 1
        end

        if love.keyboard.isDown('left') then
            player:setX(px - player.speed * dt)
            player.isMoving = true
            player.direction = -1
        end

        if player:enter('Danger') then                      -- Checks if player object collids with any object of collision class "danger" and resets player position accordingly
            player:setPosition(playerStartX, playerStartY)
        end
    end

    if player.isGrounded then                               -- boolean check for player's object collision detection to platforms
        if player.isMoving then
            player.animation = animations.run
        else
            player.animation = animations.idle
        end
    else
        player.animation = animations.jump
    end
    player.animation:update(dt)
end

function drawPlayer()
    local px, py = player:getPosition()
    player.animation:draw(sprites.playerSheet, px, py, nil, 0.25 * player.direction, 0.25, 130, 282)        -- draws player sprite back on position of object player
end