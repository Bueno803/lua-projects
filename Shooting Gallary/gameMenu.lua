
function init()
  target = {}
  target.x = 300
  target.y = 300
  target.rad = 50

  saveData = {}
  saveData.keepScoreEz = {0, 0, 0, 0, 0}
  
  saveData.keepScoreH = {0, 0, 0, 0, 0}

  if love.filesystem.getInfo("GallaryHighScores.json") then
    local data = love.filesystem.load("GallaryHighScores.json")
    data()
  end

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

function drawMain()
    love.graphics.draw(sprites.sky, 0, 0)
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
        love.graphics.printf("1. " .. saveData.keepScoreEz[1], 205, 160, love.graphics.getWidth(), "left")
        love.graphics.printf("2. " .. saveData.keepScoreEz[2], 205, 200, love.graphics.getWidth(), "left")
        love.graphics.printf("3. " .. saveData.keepScoreEz[3], 205, 240, love.graphics.getWidth(), "left")
        love.graphics.printf("4. " .. saveData.keepScoreEz[4], 205, 280, love.graphics.getWidth(), "left")
        love.graphics.printf("5. " .. saveData.keepScoreEz[5], 205, 320, love.graphics.getWidth(), "left")

        love.graphics.printf("Hard Mode", 445, 110, love.graphics.getWidth(), "left")
        love.graphics.printf("1. " .. saveData.keepScoreH[1], 455, 160, love.graphics.getWidth(), "left")
        love.graphics.printf("2. " .. saveData.keepScoreH[2], 455, 200, love.graphics.getWidth(), "left")
        love.graphics.printf("3. " .. saveData.keepScoreH[3], 455, 240, love.graphics.getWidth(), "left")
        love.graphics.printf("4. " .. saveData.keepScoreH[4], 455, 280, love.graphics.getWidth(), "left")
        love.graphics.printf("5. " .. saveData.keepScoreH[5], 455, 320, love.graphics.getWidth(), "left")
    end

    love.graphics.setColor(1,1,1)
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - 20, love.mouse.getY() - 20)
end

function uLeaderBoard(sessionScore)
    if gameDifficulty == 1 then
        for i=1, 5, 1 do
            if saveData.keepScoreEz[i] == 0 then -- Empty space in leader board
                saveData.keepScoreEz[i] = sessionScore
                love.filesystem.write("GallaryHighScores.json", table.show(saveData, "saveData"))
                break
            elseif saveData.keepScoreEz[i] < sessionScore then -- Player current score is greater than current place in leader board
                leaderBoardShiftDown(i)
                saveData.keepScoreEz[i] = sessionScore
                love.filesystem.write("GallaryHighScores.json", table.show(saveData, "saveData"))
                break
            end
        end
    elseif gameDifficulty == 2 then
        for i=1, 5, 1 do
            if saveData.keepScoreH[i] == 0 then -- Empty space in leader board
                saveData.keepScoreH[i] = sessionScore 
                love.filesystem.write("GallaryHighScores.json", table.show(saveData, "saveData"))
                break
            elseif saveData.keepScoreH[i] < sessionScore then -- Player current score is greater than current place in leader board
                leaderBoardShiftDown(i)
                saveData.keepScoreH[i] = sessionScore
                love.filesystem.write("GallaryHighScores.json", table.show(saveData, "saveData"))
                break
            end
        end
    end
end

function lBoardShift(boardPlace) --  meant to shift leaderboard down when new highscore is reached (Incomplete)
    for i=4, 1, -1 do
        if boardPlace < i+1 and gameDifficulty == 1 then
            saveData.keepScoreEz[i+1] = saveData.keepScoreEz[i]
        elseif boardPlace < i+1 and gameDifficulty == 2 then
            saveData.keepScoreH[i+1] = saveData.keepScoreH[i]
        end       
    end
end