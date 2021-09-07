function love.load()
  require('gameMenu')
  require('library/show')
  init()

    
 
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
    drawMain()    
end

function love.mousepressed( x, y, button, istouch, presses)
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
            timer = 30
        elseif x > 449 and x < 626 and y > 399 and y < 476 then
            gameDifficulty = 2
            gameOn = 2
            score = 0
            timer = 30
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
    uLeaderBoard(sessionScore)
end

function distanceForm(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function leaderBoardShiftDown(boardPlace) --  meant to shift leaderboard down when new highscore is reached (Incomplete)
    lBoardShift(boardPlace)
end