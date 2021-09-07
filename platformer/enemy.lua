enemies = {}        -- creates enemies table

function spawnEnemy(x, y)       
    local enemy = world:newRectangleCollider(x, y, 70, 90, {collision_class = "Danger"})        -- function create a collider of type "danger" and storing direction, speed and it's animations in the enemies table as an entry
    enemy.direction = 1
    enemy.speed = 100
    enemy.animations = animations.enemy
    table.insert(enemies, enemy)
end



function updateEnemies(dt)
    for i,e in ipairs(enemies) do          -- updates enemies animation via the love.update function using dt as parameter.
        e.animations:update(dt)
        local ex, ey = e:getPosition()

        local colliders = world:queryRectangleArea(ex + (40 * e.direction), ey + 40, 10, 10, {'Platform'}) -- creating a collider query that checks the distance of the enemies collider with the platforms edge and
        if #colliders == 0 then                                                                            -- if the collider is 0, meaning its at the end of the platform, the direction of the enemy will change
            e.direction = e.direction * -1
        end

        e:setX(ex + e.speed * dt * e.direction)         
    end
end

function drawEnemies()
    for i,e in ipairs(enemies) do
        local ex, ey = e:getPosition()
        e.animations:draw(sprites.enemySheet, ex, ey, nil, e.direction, 1, 50, 65)
    end
end
