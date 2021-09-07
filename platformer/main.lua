function love.load()
    love.window.setMode(1000,768)                           -- set window dimensions to parameters provided



    anim8 = require 'libraries/anim8/anim8'
    sti = require 'libraries/Simple-Tiled-Implementation/sti'       -- files and extra functions required for animation and camera controll functions
    cameraFile = require 'libraries/hump/camera'

    cam = cameraFile()          -- Creating a camera object

    sounds = {}         -- creating a table to store sound properties in

    sounds.jump = love.audio.newSource("audio/jump.wav", "static")
    sounds.music = love.audio.newSource("audio/music.mp3", "stream")    -- sounds, and their properties (game audio, jump sound)
    sounds.music:setLooping(true)
    sounds.music:setVolume(0.2)

    sounds.music:play()         -- function that starts the game sound to play as soon as the love.load function runs

    sprites = {}        -- a table containing all sprites (images)
    sprites.playerSheet = love.graphics.newImage('sprites/playerSheet.png')
    sprites.enemySheet = love.graphics.newImage('sprites/enemySheet.png')       -- all Sprites (Images) used in the game
    sprites.background = love.graphics.newImage('sprites/background.png')

    local grid = anim8.newGrid(614, 564, sprites.playerSheet:getWidth(), sprites.playerSheet:getHeight())       -- creates a grid that takes in our sprites image to divides it in sections per parameter dimensions  
    local enemyGrid = anim8.newGrid(100, 79, sprites.enemySheet:getWidth(), sprites.enemySheet:getHeight())     -- This is basically the lay out of the animation for player running, jumping and idle stance (same for enemy)

    animations = {}     -- a table containing all animation
    animations.idle = anim8.newAnimation(grid('1-15', 1), 0.05)
    animations.jump = anim8.newAnimation(grid('1-7', 2), 0.05)      -- each animation is played like a flip book across the grid and parameters defined are, number of columns, row number and time frame each picture displays 
    animations.run = anim8.newAnimation(grid('1-15', 3), 0.05)
    animations.enemy = anim8.newAnimation(enemyGrid('1-2',1), 0.03)

    wf = require 'libraries/windfield/windfield'        -- this is the physics of the game world, includes gravity and collision of objects
    world = wf.newWorld(0, 800, false)      -- gravity of world, with parameters being x direction of gravity, y direction of gravity, and sleep mode (object becomes motionless while stationary so uneffected by gravity)
    world:setQueryDebugDrawing(false)        -- Sets query debug drawing to be active or not. If active, then collider queries will be drawn to the screen for 10 frames. This is used for debugging purposes and incurs a performance penalty. (can be disabled)

    world:addCollisionClass('Platform')     -- this physics function native to windfield, requires you to import a collision class when dealing with your objects
    world:addCollisionClass('Player')
    world:addCollisionClass('Danger')

    require('player')   -- requiring other .lua file that stores player data
    require('enemy')     -- requiring other .lua file that stores enemy data   
    require('libraries/show')       -- Script imported for saving data
    
    dangerZone = world:newRectangleCollider(-500, 800, 5000, 50, {collision_class = "Danger"})     -- defines the collider that uses collusion class 'danger' that is later used as death for player
    dangerZone:setType('static')

    platforms = {}

    flagx = 0
    flagy = 0

    saveData = {}   -- creating a table for the save data level name

    saveData.currentLevel = "level1"        --creates an entry in the saveData table that is of string type

    if love.filesystem.getInfo("data.lua") then     -- if statment that uses the function that finds the file "data.lua" in a predefined file destination, and loads the data, or level name, from the saved data in data.lua file
        local data = love.filesystem.load("data.lua")
        data()
    end


    loadMap(saveData.currentLevel)      -- calls function to load map with the saveData string input as parameter
end

function love.update(dt)    -- constantly updating function that checks for world, map, player, enemies, camera placement and collision with flag at end to update the current level
    world:update(dt)
    gameMap:update(dt)
    playerUpdate(dt)
    updateEnemies(dt)

    local px, py = player:getPosition()     
    cam:lookAt(px, love.graphics.getHeight()/2)

    local colliders = world:queryCircleArea(flagX, flagY, 10, {'Player'})
    if #colliders > 0 then
        if saveData.currentLevel == "level1" then
            loadMap("level2")
        elseif saveData.currentLevel == "level2" then
            loadMap("level1")
        end
    end
end

function love.draw()        -- function that draws the background, create the camera then draws the player, enemies inside of the camera's angles so that the camera does not extend outside of these things drawn within it
    love.graphics.draw(sprites.background, 0, 0)
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
    --    world:draw()
        drawPlayer()
        drawEnemies()
    cam:detach()
end

function love.keypressed(key)       -- constantly updating function that check if key is pressed to update
    if key == 'up' then
        if player.isGrounded then
            player:applyLinearImpulse(0, -5000)     -- whenever the up arrow key is pressed, you jump, but only if you are grounded
            sounds.jump:play()
         end
    end
end

function love.mousepressed(x, y, button)        -- constantly updating function that checks if a mouse button is pressed with parameters of the x and y coordinate of the mouse button
    if button == 1 then
        local colliders = world:queryCircleArea(x, y, 200, {'Platform', 'Danger'}) -- if mouse 1 is pressed then we create a query in a circle with radius 200 to destroy all objects of type platform and danger
        for i,c in ipairs(colliders) do
            c:destroy()
        end
    end
end

function spawnPlatform(x, y, width, height)     
    local platform = world:newRectangleCollider(x, y, width, height, {collision_class = "Platform"}) -- we create a collider of collision class type "platform" in the shape of a rectangle
    platform: setType('static')
    table.insert(platforms, platform) -- insert the platform into our table
end

function destroyAll()       -- function to destroy the table of platforms and enemies
    local i = #platforms
    while i > -1 do
        if platforms[i] ~= nil then
            platforms[i]:destroy()
        end
        table.remove(platforms, i)
        i = i - 1
    end

    local i = #enemies
    while i > -1 do
        if enemies[i] ~= nil then
            enemies[i]:destroy()
        end
        table.remove(enemies, i)
        i = i - 1
    end
end

function loadMap(mapName)
    saveData.currentLevel = mapName
    love.filesystem.write("data.lua", table.show(saveData, "saveData"))     -- function called to load the map, that uses filesystem to write to the data.lua file whatever current level the player is on
    destroyAll()

    gameMap = sti("maps/" .. mapName .. ".lua")                             -- loading the level based on whatever leveling the player makes it to or stops at

    for i, obj in pairs(gameMap.layers["Start"].objects) do                 -- loops and creates objects for however many layers are in said object of Tiled application (player start position, platforms, enemies, flag)
        playerStartX = obj.x
        playerStartY = obj.y
    end
    player:setPosition(playerStartX, playerStartY)
    for i, obj in pairs(gameMap.layers["Platforms"].objects) do
        spawnPlatform(obj.x, obj.y, obj.width, obj.height)
    end

    for i, obj in pairs(gameMap.layers["Enemies"].objects) do
        spawnEnemy(obj.x, obj.y)
    end

    for i, obj in pairs(gameMap.layers["Flag"].objects) do
        flagX = obj.x
        flagY = obj.y
    end
end