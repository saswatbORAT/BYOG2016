local _M = {}
local objectGroup 
local group_mt = { __index = _M}
local xDirection = {}
local yDirection = {}
local xVel, yVel = 500, 500
local initXDir = {}
local initYDir = {}
local groupX, groupY
local characters = {}
local bombInstance
local initX = {}
local initY = {}
local charCount
local killCount
local isPaused 

local levelData = require("classes.levelData")
local composer = require("composer")
local physics = require("physics")
physics.start()
--physics.setDrawMode("hybrid")

local characterSize ={width = 100,height = 100,numFrames = 12}
local bombSize={width = 100,height = 100,numFrames = 3}

local characterSequences = {
{name = "down",start = 1,count = 3,time = 500},
{name = "left",start = 4,count = 3,time = 500},
{name = "right",start = 7,count = 3,time = 500},
{name = "up",start = 10,count = 3,time = 500}
}
local bombSequences = {
{name = "blink",start = 1,count = 3,time = 500},
}

local function createCharacter(index, pos, xDir, yDir)
	local width, height = 100, 100
	local x = ((tonumber(pos:sub(1,2) - 1)) * width) - 750
	local y = ((tonumber(pos:sub(3,4) - 1)) * height) - 400
	
	
	local sheet = graphics.newImageSheet( "res/characters/char"..index..".png", characterSize )
	local charInstance = display.newSprite(sheet, characterSequences)
	charInstance.width, charInstance.height = width, height
	charInstance.x, charInstance.y = x, y
			
	if(xDir == 1 and yDir == 0)then
		charInstance:setSequence("right")
	elseif(xDir == 0 and yDir == 1)then
		charInstance:setSequence("down")
	elseif(xDir == -1 and yDir == 0)then
		charInstance:setSequence("left")
	elseif(xDir == 0 and yDir == -1)then
		charInstance:setSequence("up")			
	end
	
	local offsetRectParams = { halfWidth = width*0.01, halfHeight = height * 0.01, x=objectGroup.x, y=objectGroup.y}
	physics.addBody(charInstance, "kinematic",{density=1.0, friction=0.3, bounce=0.2, box = offsetRectParams})
	
	objectGroup:insert(charInstance)
	characters[charCount] = charInstance
	xDirection[charCount], yDirection[charCount] = xDir, yDir
	initXDir[charCount], initYDir[charCount] = xDir, yDir
	initX[charCount], initY[charCount] = charInstance.x, charInstance.y
	
	charCount = charCount + 1
end

local function createBomb(pos)
	local x = ((tonumber(pos:sub(1,2) - 1)) * 100) - 750
	local y = ((tonumber(pos:sub(3,4) - 1)) * 100) - 400
	
	local sheet = graphics.newImageSheet( "res/bomb_sheet.png", bombSize )
	bombInstance = display.newSprite(sheet, bombSequences)
	bombInstance.x, bombInstance.y = x, y
	bombInstance.myName = "bomb"
	bombInstance:play()
	
	local offsetRectParams = { halfWidth = bombInstance.width*0.1, halfHeight = bombInstance.height * 0.1, x=objectGroup.x, y=objectGroup.y}
	physics.addBody(bombInstance, "static",{density=1.0, friction=0.3, bounce=0.2, box = offsetRectParams})
	
	objectGroup:insert(bombInstance)
end

local function createElement(index, pos)
	local width, height = index%3 , math.ceil(index/3)
	if(width == 0)then
		width = 3
	end
	
	local x = ((tonumber(pos:sub(1,2) - 1)) * 100) - 750
	local y = ((tonumber(pos:sub(3,4) - 1)) * 100) - 400
	
	local minX, minY = x - 50 , y - 50
	local maxX, maxY = x + (100 * (width - 0.5)), y + (100 * (height - 0.5))
	x,y = (maxX + minX) * 0.5, (maxY + minY) * 0.5
	
	local element = display.newImageRect("res/elements/"..index..".png", width * 100, height * 100)
	element.x, element.y = x, y
	
	objectGroup:insert(element)
	
	local offsetRectParams = { halfWidth = width*0.5, halfHeight = height * 0.5, x=objectGroup.x, y=objectGroup.y}
	physics.addBody(element, "static",{density=1.0, friction=0.3, bounce=0.2, box = offsetRectParams})
end

function _M:moveChar()
	isPaused = false
	for i = 1, charCount - 1, 1 do
		characters[i]:setLinearVelocity(xVel * xDirection[i], yVel * yDirection[i])
		characters[i]:play()
	end

end

function _M:reset()
	isPaused = true
	
	for i = 1, charCount - 1, 1 do
		characters[i]:pause()
		xDirection[i], yDirection[i] = initXDir[i], initYDir[i]
		if(initXDir[i] == 1 and initYDir[i] == 0)then
			characters[i]:setSequence("right")
		elseif(initXDir[i] == 0 and initYDir[i] == 1)then
			characters[i]:setSequence("down")
		elseif(initXDir[i] == -1 and initYDir[i] == 0)then
			characters[i]:setSequence("left")
		elseif(initXDir[i] == 0 and initYDir[i] == -1)then
			characters[i]:setSequence("up")			
		end
		characters[i]:setLinearVelocity(0,0)
		characters[i].x, characters[i].y = initX[i], initY[i]
	end
end

local function boundingBox(rect1X, rect1Y, rect1Width, rect1Height, rect2X, rect2Y, rect2Width, rect2Height)
	rect1X, rect2X = rect1X + 750, rect2X + 750
	rect1Y, rect2Y = rect1Y + 400, rect2Y + 400
	local xCollision = ((rect1X+(rect1Width*0.5)) - (rect2X + (rect2Width * 0.5))) < 0
	local yCollision = ((rect1Y+(rect1Height*0.5)) - (rect2Y + (rect2Height * 0.5))) < 0 
	if(xCollision and yCollision)then
	return 1
	else return 0
	end
end

local function update()
	if(isPaused)then
		return
	end
	
	for i = 1, charCount - 1, 1 do
		local startX, startY = characters[i].x + groupX, characters[i].y + groupY
		local endX, endY = (characters[i].x + groupX) + (xDirection[i] * 51), (characters[i].y + groupY) + (yDirection[i]*51)
		hits = physics.rayCast(startX, startY, endX, endY, "closest" )
		local ray = display.newLine(startX, startY, endX, endY)
		if ( hits ) then
			for i,hit in ipairs( hits ) do
				if(hit.object.myName == "bomb")then
				killCount = 0
					for j = 1, charCount - 1, 1 do
						characters[j]:setLinearVelocity(0,0)
						characters[j]:pause()
						killCount = killCount + boundingBox(characters[j].x, characters[j].y, 100, 100, bombInstance.x, bombInstance.y, 500,500)
					end
					
					levelData.won = killCount == charCount - 1
					composer.gotoScene('scenes.result')
					composer.removeScene('scenes.game')
				end
			end
		
		if(xDirection[i] == 1 and yDirection[i] == 0)then
			xDirection[i], yDirection[i] = 0, 1
			characters[i]:setSequence("down")
		elseif(xDirection[i] == 0 and yDirection[i] == 1)then
			xDirection[i], yDirection[i] = -1, 0
			characters[i]:setSequence("left")
		elseif(xDirection[i] == -1 and yDirection[i] == 0)then
			xDirection[i], yDirection[i] = 0, -1
			characters[i]:setSequence("up")
		elseif(xDirection[i] == 0 and yDirection[i] == -1)then
			xDirection[i], yDirection[i] = 1, 0
			characters[i]:setSequence("right")			
		end
    	
    	characters[i]:play()
    	characters[i]:setLinearVelocity(xVel * xDirection[i], yVel * yDirection[i])
		end
	end
end

local function addData(_index)
	local index = tonumber(_index)
	if(index == 1)then
		createElement(1,"0101")
		createElement(2,"0201")
		createElement(3,"0401")
		createElement(4,"0102")
		createElement(5,"0202")
		createElement(6,"0402")
		createElement(7,"0104")
		createElement(8,"0204")
		createElement(9,"0404")
		createCharacter(1, "0809", -1, 0)
		createCharacter(2, "0609", -1, 0)
		createBomb("0109")
	elseif(index == 2)then
		createCharacter(1,-750,400,100,100,0,-1)
		createElement(1,-750,-300,100,100)
		createElement(1,-650,200,100,100)
		createElement(1,-550,-100,100,100)
		createElement(1,-450,100,100,100)
		createElement(1,-350,-200,100,100)
		createElement(1,-250,300,100,100)
		createElement(1,-150,200,100,100)
		createCharacter(2,-450,400,100,100,0,-1)
		createBomb(-450,0)
	end

end

function _M.new(index)
	objectGroup = display.newGroup()
	charCount = 1
	killCount = 0
	objectGroup.x, objectGroup.y = display.contentCenterX, display.contentCenterY
	groupX, groupY = objectGroup.x, objectGroup.y
	addData(index)
	isPaused = true

			
	local plants = display.newImageRect("res/plants_background.png", 1595, 96)
	plants.x, plants.y = 0,450
	objectGroup:insert(plants)
	
	Runtime:addEventListener( "enterFrame", update )
	return setmetatable(_M, group_mt)
end

function _M.getDisableButtons(_index)
	local index = tostring(_index)
	if(index == "1")then
		return {"0906", "0907", "1308", "1006", "0706"}
	elseif(index == "2")then
		return {"0101"}
	end
end

function _M.removeSelf()
	Runtime:removeEventListener( "enterFrame", update )
	objectGroup:removeSelf()
	--objectGroup = nil
end

return _M
