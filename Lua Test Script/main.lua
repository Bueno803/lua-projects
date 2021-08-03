message = 0

testScores = {}

testScores[1] = 12
testScores[2] = 24
testScores[3] = 35

testScores.subject = "science"

for i,s in ipairs(testScores) do
    message = message + s
end

function love.draw()  
   love.graphics.setFont(love.graphics.newFont(50))
   love.graphics.print(testScores.subject)
end


