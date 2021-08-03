function love.load()
  target = {}
  target.x = 300
  target.y = 300
  target.rad = 50

  keepScoreEz = {0, 0, 0, 0, 0}
  keepScoreEz[1] = 0
  keepScoreEz[2] = 0
  keepScoreEz[3] = 0
  keepScoreEz[4] = 0
  keepScoreEz[5] = 0

  keepScoreH = {0, 0, 0, 0, 0}
  keepScoreH[1] = 0
  keepScoreH[2] = 0
  keepScoreH[3] = 0
  keepScoreH[4] = 0
  keepScoreH[5] = 0

  score = 0
  timer = 0
  gameOn = 1 -- Game on 1 = main menu, Game on 2 = game in sessions, Game on 3 = HighScore boards

  gameDifficulty = 1 -- Difficulty 1 = Easy, 2 = Hard

  gameFont = love.graphics.newFont(40)
  gameFontT = love.graphics.newFont(30)
  gameScores = love.graphics.newFont(10)

  sprites = {}
  sprites.sky = love.graphics.newImage('sprites/sky.png')
  sprites.target = love.graphics.newImage('sprites/target.png')
  sprites.smalltarget = love.graphics.newImage('sprites/smalltarget.png')
  sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')
  sprites.backarrow = love.graphics.newImage('sprites/backarrow.png')
  
  love.mouse.setVisible(false)
end

function love.update(dt)
    if timer > 0 and gameOn == 2 then
        timer = timer - dt
    end

    if timer < 0 then
        timer = 0
        updateLeaderBoard(score)
        gameOn = 1
    end
end

function love.draw()
--    love.graphics.setColor(1,0,0)
--    love.graphics.circle("fill", target.x, target.y, target.rad)

    love.graphics.draw(sprites.sky, 0, 0)

 --   if gameOn == 1 then
 --       love.graphics.printf("Click anywhere to begin!", 0, 250, love.graphics.getWidth(), "center")
 --   end

    if gameOn == 2 and gameDifficulty == 1 then
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(gameFont)
        love.graphics.print("Score: " .. score,0,0)
        love.graphics.print("Time: " .. math.ceil(timer),300,0)
        love.graphics.draw(sprites.target, target.x - target.rad, target.y - target.rad)
    elseif gameOn == 2 and gameDifficulty == 2 then
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(gameFont)
        love.graphics.print("Score: " .. score,0,0)
        love.graphics.print("Time: " .. math.ceil(timer),300,0)
        love.graphics.draw(sprites.smalltarget, target.x - target.rad, target.y - target.rad)
    elseif gameOn == 1 then

        love.graphics.setFont(gameFont)
        love.graphics.print("Score: " .. score,0,0)
        love.graphics.print("Time: " .. math.ceil(timer),300,0)

        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", 150, 400, 175, 75)
        love.graphics.rectangle("fill", 450, 400, 175, 75)
        love.graphics.rectangle("fill", 300, 500, 175, 75)

        love.graphics.setColor(1,1,1)
        love.graphics.printf("Easy", 190, 410, love.graphics.getWidth(), "left")
        love.graphics.printf("Hard", 490, 410, love.graphics.getWidth(), "left")
        love.graphics.setFont(gameFontT)
        love.graphics.printf("HighScores", 304, 520, love.graphics.getWidth(), "left")
    elseif gameOn == 3 then
    --    love.graphics.rectangle("fill", 0, 0, 50, 50)
        love.graphics.draw(sprites.backarrow, 0, 0)
        love.graphics.rectangle("line", 200, 150, 150, 400)
        love.graphics.rectangle("line", 450, 150, 150, 400)
        love.graphics.printf("Top 5 Leader Boards", 0, 50, love.graphics.getWidth(), "center")

        love.graphics.setFont(gameFontT)
        love.graphics.printf("Easy Mode", 195, 110, love.graphics.getWidth(), "left")
        love.graphics.printf("1. " .. keepScoreEz[1], 205, 160, love.graphics.getWidth(), "left")
        love.graphics.printf("2. " .. keepScoreEz[2], 205, 200, love.graphics.getWidth(), "left")
        love.graphics.printf("3. " .. keepScoreEz[3], 205, 240, love.graphics.getWidth(), "left")
        love.graphics.printf("4. " .. keepScoreEz[4], 205, 280, love.graphics.getWidth(), "left")
        love.graphics.printf("5. " .. keepScoreEz[5], 205, 320, love.graphics.getWidth(), "left")

        love.graphics.printf("Hard Mode", 445, 110, love.graphics.getWidth(), "left")
        love.graphics.printf("1. " .. keepScoreH[1], 455, 160, love.graphics.getWidth(), "left")
        love.graphics.printf("2. " .. keepScoreH[2], 455, 200, love.graphics.getWidth(), "left")
        love.graphics.printf("3. " .. keepScoreH[3], 455, 240, love.graphics.getWidth(), "left")
        love.graphics.printf("4. " .. keepScoreH[4], 455, 280, love.graphics.getWidth(), "left")
        love.graphics.printf("5. " .. keepScoreH[5], 455, 320, love.graphics.getWidth(), "left")
        
    end
    love.graphics.setColor(1,1,1)
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function love. mousepressed( x, y, button, istouch, presses)
    if button == 1 and gameOn == 2 and gameDifficulty == 1 then
        local mouseToTarget = distanceForm(x, y, target.x, target.y)

        if mouseToTarget < target.rad then
            score = score + 1
            target.x = math.random(target.rad, love.graphics.getWidth() - target.rad)
            target.y = math.random(target.rad, love.graphics.getHeight() - target.rad)
        end
    elseif button == 1 and gameOn == 2 and gameDifficulty == 2 then
        local mouseToTarget = distanceForm(x, y, target.x, target.y)
    
        if mouseToTarget < target.rad then
            score = score + 1
            target.x = math.random(target.rad, love.graphics.getWidth() - target.rad)
            target.y = math.random(target.rad, love.graphics.getHeight() - target.rad)
        else
            if score > 0 then
                score = score - 1
            end
        end
        
    elseif button == 1 and gameOn == 1 then
        if x > 149 and x < 326 and y > 399 and y < 476 then
            gameDifficulty = 1
            gameOn = 2
            score = 0
            timer = 5
        elseif x > 449 and x < 626 and y > 399 and y < 476 then
            gameDifficulty = 2
            gameOn = 2
            score = 0
            timer = 5
        elseif x > 299 and x < 476 and y > 499 and y < 576 then
            gameOn = 3
        end
    elseif button == 1 and gameOn == 3 then
        if x > 0 and x < 51 and y > 0 and y < 51 then
            gameOn = 1
        end
    end
end

function updateLeaderBoard(sessionScore)
    if gameDifficulty == 1 then
        for i=1, 5, 1 do
            if keepScoreEz[i] == 0 then -- Empty space in leader board
                keepScoreEz[i] = sessionScore  
                break
            elseif keepScoreEz[i] < sessionScore then -- Player current score is greater than current place in leader board
                leaderBoardShiftDown(i)
                keepScoreEz[i] = sessionScore
                break
            end
        end
    elseif gameDifficulty == 2 then
        for i=1, 5, 1 do
            if keepScoreH[i] == 0 then -- Empty space in leader board
                keepScoreH[i] = sessionScore  
                break
            elseif keepScoreH[i] < sessionScore then -- Player current score is greater than current place in leader board
                leaderBoardShiftDown(i)
                keepScoreH[i] = sessionScore
                break
            end
        end
    end
end

function distanceForm(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function leaderBoardShiftDown(boardPlace) --  meant to shift leaderboard down when new highscore is reached (Incomplete)
    for i=4, 1, -1 do
        if boardPlace < i+1 and gameDifficulty == 1 then
            keepScoreEz[i+1] = keepScoreEz[i]
        elseif boardPlace < i+1 and gameDifficulty == 2 then
            keepScoreH[i+1] = keepScoreH[i]
        end       
    end
end