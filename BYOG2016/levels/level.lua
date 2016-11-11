local _M = {}
local objectGroup 
local group_mt = { __index = _M}
local xDirection
local yDirection
local xVel, yVel = 500, 500
local initXDir
local initYDir
local groupX, groupY
local characters
local bombInstance
local initX = {}
local initY = {}
local charCount
local killCount
local isPaused
local disabledButtonCount
local bgMusic, channel
_M.disabledButtons = {}

local levelData = require("classes.levelData")
local composer = require("composer")
local physics = require("physics")
physics.start()
--physics.setDrawMode("hybrid")

local characterSize ={width = 100,height = 100,numFrames = 12}
local bombSize={width = 100,height = 100,numFrames = 8}

local characterSequences = {
{name = "down",start = 1,count = 3,time = 500},
{name = "left",start = 4,count = 3,time = 500},
{name = "right",start = 7,count = 3,time = 500},
{name = "up",start = 10,count = 3,time = 500}
}

local bombSequences = {
{name = "blink",start = 1,count = 8,time = 500}
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
	_M.disabledButtons[disabledButtonCount] = pos
	disabledButtonCount = disabledButtonCount + 1
		
	characters[charCount] = charInstance
	xDirection[charCount], yDirection[charCount] = xDir, yDir
	initXDir[charCount], initYDir[charCount] = xDir, yDir
	initX[charCount], initY[charCount] = charInstance.x, charInstance.y
	charCount = charCount + 1
end

local function createBomb(pos)
	local x = ((tonumber(pos:sub(1,2) - 1)) * 100) - 750
	local y = ((tonumber(pos:sub(3,4) - 1)) * 100) - 400
	
	local sheet = graphics.newImageSheet( "res/phone_sheet.png", bombSize )
	bombInstance = display.newSprite(sheet, bombSequences)
	bombInstance.x, bombInstance.y = x, y
	bombInstance.myName = "bomb"
	bombInstance:play()
	
	local offsetRectParams = { halfWidth = bombInstance.width*0.1, halfHeight = bombInstance.height * 0.1, x=objectGroup.x, y=objectGroup.y}
	physics.addBody(bombInstance, "static",{density=1.0, friction=0.3, bounce=0.2, box = offsetRectParams})
	
	objectGroup:insert(bombInstance)
	_M.disabledButtons[disabledButtonCount] = pos
	disabledButtonCount = disabledButtonCount + 1

end

local function createElement(index, pos)
	local width, height = index%3 , math.ceil(index/3)
	if(width == 0)then
		width = 3
	end
	local gridX, gridY = tonumber(pos:sub(1,2)), tonumber(pos:sub(3,4))
	local tempX, tempY = gridX, gridY
	local x = ((gridX - 1) * 100) - 750
	local y = ((gridY - 1) * 100) - 400
	
	local minX, minY = x - 50 , y - 50
	local maxX, maxY = x + (100 * (width - 0.5)), y + (100 * (height - 0.5))
	x,y = (maxX + minX) * 0.5, (maxY + minY) * 0.5
	
	local element = display.newImageRect("res/Objects/"..index..".png", width * 100, height * 100)
	element.x, element.y = x, y
	
	objectGroup:insert(element)
	
	for i =1, width, 1 do
		for j = 1, height, 1 do
			_M.disabledButtons[disabledButtonCount] = string.format("%02d%02d", tempX, tempY)
			disabledButtonCount = disabledButtonCount + 1
			tempY = tempY + 1
		end
		tempX = tempX + 1
		tempY = gridY
	end

	local offsetRectParams = { halfWidth = width*50, halfHeight = height * 50, x=objectGroup.x, y=objectGroup.y}
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
	local obj1 = display.newRect(rect1X, rect1Y, rect1Width,rect1Height)
	objectGroup:insert(obj1) 
	obj1.alpha = 0.0
	local obj2 = display.newRect(rect2X, rect2Y, rect2Width,rect2Height)
	objectGroup:insert(obj2) 
	obj2.alpha = 0.0
	
	local left = obj1.contentBounds.xMin <= obj2.contentBounds.xMin and obj1.contentBounds.xMax >= obj2.contentBounds.xMin
    local right = obj1.contentBounds.xMin >= obj2.contentBounds.xMin and obj1.contentBounds.xMin <= obj2.contentBounds.xMax
    local up = obj1.contentBounds.yMin <= obj2.contentBounds.yMin and obj1.contentBounds.yMax >= obj2.contentBounds.yMin
    local down = obj1.contentBounds.yMin >= obj2.contentBounds.yMin and obj1.contentBounds.yMin <= obj2.contentBounds.yMax
 
    if(left or right) and (up or down) then return 1
    else return 0
    end
    
end

local function changeScene( event )
	composer.gotoScene('scenes.result')
	composer.removeScene('scenes.game')
end



local function update()
	if(isPaused)then
		return
	end
	
	for i = 1, charCount - 1, 1 do
		local startX, startY = characters[i].x + groupX, characters[i].y + groupY
		local endX, endY = (characters[i].x + groupX) + (xDirection[i] * 51), (characters[i].y + groupY) + (yDirection[i]*51)
		hits = physics.rayCast(startX, startY, endX, endY, "closest" )
		if ( hits ) then
			for i,hit in ipairs( hits ) do
				if(hit.object.myName == "bomb")then
				killCount = 0
					for j = 1, charCount - 1, 1 do
						characters[j]:setLinearVelocity(0,0)
						characters[j]:pause()
						killCount = killCount + boundingBox(characters[j].x, characters[j].y, 1*100, 1*100, bombInstance.x, bombInstance.y, 5*100,5*100)
					
					end
				
					levelData.won = killCount == charCount - 1
					
					local blastSize={width = 120, height = 120,numFrames = 12}
					local blastSequences = {{name = "blink",start = 1,count = 12,time = 500}}
					local sheet = graphics.newImageSheet( "res/blast_sheet.png", blastSize )
					local blastInstance = display.newSprite(sheet, blastSequences)
					blastInstance.x, blastInstance.y = bombInstance.x, bombInstance.y
					blastInstance:play()
					objectGroup:insert(blastInstance)
					transition.scaleTo( blastInstance, { xScale=6.0, yScale=6.0, time=100} )

					
					timer.performWithDelay(400, changeScene)
					Runtime:removeEventListener( "enterFrame", update )
					return
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

local function addData(index)
	if(index == "1")then 
		createCharacter(10,"0202",1,0)
		createBomb("0805")
		
		createElement(3,"0203")
		createElement(3,"0503")
		createElement(3,"1003")
		createElement(3,"1006")
		createElement(4,"0903")
		createElement(4,"0905")	
		createElement(4,"1303")
		createElement(4,"1305")
		createElement(4,"0704")
		createElement(4,"0706")
		createElement(7,"1502")
		createElement(7,"1505")
		createElement(3,"1308")
		createElement(3,"1008")
		createElement(3,"0708")
		createElement(7,"0101")
		createElement(3,"0201")
		createElement(3,"0501")
		createElement(3,"0801")
		createElement(3,"1101")
		createElement(3,"1401")

	elseif(index == "2")then 
		createCharacter(10,"0202",1,0)
		createBomb("0805")
		
		createElement(3,"0203")
		createElement(3,"0503")
		createElement(3,"1003")
		createElement(3,"1006")
		createElement(4,"0903")
		createElement(4,"0905")	
		createElement(4,"1303")
		createElement(4,"1305")
		createElement(4,"0704")
		--createElement(4,"0706")
		createElement(7,"1502")
		createElement(7,"1505")
		createElement(3,"1308")
		createElement(3,"1008")
		createElement(3,"0708")
		createElement(7,"0101")
		createElement(3,"0201")
		createElement(3,"0501")
		createElement(3,"0801")
		createElement(3,"1101")
		createElement(3,"1401")	

	elseif(index == "3")then
		createCharacter(6,"0503",1,0)
		createElement(1,"0406")
		--createElement(1,"0502")
		createElement(1,"1107")
		createElement(1,"1203")

		createElement(7,"1204")
		createElement(1,"1207")
		createElement(3,"0807")
		createElement(3,"0507")
		createElement(1,"0407")
		createElement(7,"0403")
		createElement(1,"0402")
		createElement(1,"0502")
		createElement(3,"0602")
		createElement(3,"0902")
		createElement(1,"1202")
		createBomb("0805")

	elseif(index == "4")then
		createCharacter(1,"1509",-1,0)
	
		createBomb("1205")
		--createElement(7,"1605")
		createElement(6,"1307")
		createElement(6,"0907")
		createElement(5,"0202")
		createElement(5,"0502")
		createElement(5,"0205")
		createElement(5,"0505")
		createElement(5,"0208")
		createElement(1,"1105")
		createElement(1,"1305")
		createElement(6,"0702")
		createElement(1,"0404")
		createElement(1,"0407")
		
	elseif(index == "5")then -- keep one 1x1 object
		createCharacter(1,"0804",1,0)
		--createElement(1,"1203")
		--createElement(1,"1107")
		createElement(9,"1303")
		createElement(9,"1307")
		createElement(9,"0207")
		createElement(9,"0203")

		createElement(5,"1108")
		createElement(5,"0908")
		createElement(5,"0708")
		createElement(5,"0508")

		createElement(5,"1101")
		createElement(5,"0901")
		createElement(5,"0701")
		createElement(5,"0501")

		createElement(1,"0507")
		createElement(1,"0503")
		createElement(1,"1203")
		createBomb("0706")


		
	elseif(index == "6")then --keep one 2x2 object
		createCharacter(2,"0401",0,1)
		createElement(3,"0309")
		--createElement(5,"0101")
		createElement(7,"0202")
		createElement(7,"0205")
		createElement(7,"1202")
		createElement(7,"1205")
		createElement(7,"1002")
		createElement(7,"1005")
		createElement(1,"1201")
		createElement(1,"1001")
		createElement(7,"1402")
		createElement(7,"1405")
		createElement(7,"1602")
		createElement(7,"1605")
		createElement(1,"1401")
		createElement(1,"1601")
		createElement(7,"0802")
		createElement(7,"0805")
		createElement(7,"0602")
		createElement(7,"0605")
		createElement(1,"0801")
		createElement(1,"0601")
		--createElement(4,"1507")
		createBomb("0109")
	
	elseif(index == "7")then --keep two 2x2 objects
		createCharacter(9, "0302", 1, 0)
		createCharacter(3, "1308", -1, 0)
		--createElement()
		--createElement(7,"1407")
		createElement(3,"0603")
		createElement(7,"0604")
		createElement(3,"0807")
		createElement(7,"1004")
		--createElement(3,"1104")
		createElement(4,"0607")
		createElement(4,"1002")
		createBomb("0805")
	
	elseif(index == "8")then --keep two 2x2 objects
		createCharacter(9, "0508", 0, -1)
		createCharacter(3, "1302", 0, 1)
		createElement(6,"0806")
		createElement(6,"0803")
		createBomb("0905")
		--createElement(1,"0704")

		createElement(3,"0509")
		createElement(3,"1109")
		createElement(3,"0501")
		createElement(3,"1101")
		createElement(7,"0402")
		createElement(7,"0406")
		createElement(7,"1402")
		createElement(7,"1406")
		
	elseif(index == "9")then --keep two 1x1 objects
		createCharacter(2,"0205",0,1)
		createCharacter(3,"1003",1,0)
		
		createElement(1,"0209")
		createElement(1,"0204")

		createElement(1,"1503")
		createElement(1,"1408")
		createElement(1,"0907")
		createElement(1,"1002")

		createBomb("1205")

	elseif(index == "10")then
		createCharacter(8,"0503",1,0)
		createCharacter(2,"1207",0,-1)
		createElement(1,"1201")
		createElement(1,"1402")
	--	createElement(1,"1105")
		createElement(2,"0905")
		createElement(2,"1006")

		createElement(1,"0502")
		createElement(1,"0803")
		createElement(1,"0706")
		createElement(1,"0405")

		createElement(6,"0601")
		createBomb("0604")
		createElement(9,"1304")

	elseif(index == "11")then
		createCharacter(6,"0504",1,0)
		createCharacter(1,"0908",0,-1)
		createCharacter(9,"1104",0,1)

		createElement(1,"0506")
		createElement(1,"0603")

		createElement(5,"0903")
		createElement(1,"0807")
		createElement(3,"1008")
		createElement(1,"1205")

		createBomb("1006")

	elseif(index == "12")then
		createCharacter(5,"0101",1,0)
		createCharacter(7,"0305",1,0)
		createCharacter(3,"1305",-1,0)
		createCharacter(4,"1509",-1,0)

		createElement(1,"0506")
		createElement(1,"0607")
		createElement(1,"0603")
		createElement(1,"1003")
		createElement(1,"1007")
		createElement(1,"1104")

		createBomb("0805")
	
	elseif(index == "13")then
		createCharacter(7,"1107",0,-1)
		createCharacter(4,"0803",0,1)
		createElement(1,"1405")
		createElement(1,"1308")
		createElement(1,"1007")
		createElement(1,"1104")
		
		createElement(7,"0903")
		createElement(7,"0703")
		
		createElement(6,"0701")
		createElement(6,"0707")
		--createElement(2,"0106")
		createElement(9,"0202")
		createElement(9,"0207")
		createBomb("1206")
	elseif(index == "14")then
	
		createCharacter(6,"0202",1,0)
		createCharacter(2,"1104",-1,0)
		createElement(3,"0201")
		createElement(1,"0305")
		createElement(1,"0206")
		createElement(9,"0507")
		createElement(4,"0702")
		createElement(2,"0704")
		createElement(8,"1105")
		createElement(1,"0901")
		createElement(1,"1202")
		
		createBomb("1003")
		
	
	elseif(index == "15")then
	
		createCharacter(8,"1207",0,-1)
		createCharacter(5,"0608",-1,0)
		createElement(1,"1202	")
		createElement(5,"1304")
		createElement(1,"1403")
		createElement(7,"0306")
		createElement(2,"0305")
		createElement(7,"0706")
		createElement(2,"0609")
		createElement(2,"0501")
		createBomb("0507")
	
	end

end


function _M.new(index)
	characters = {}
	xDirection = {}
	yDirection = {}
	initXDir = {}
	initYDir = {}
	_M.disabledButtons = {}
	disabledButtonCount = 1

	bgMusic = audio.loadStream( "res/bgMusic.mp3" )
	channel = audio.play( bgMusic, { channel=1, loops=-1, fadein=5000 } )
	objectGroup = display.newGroup()
	charCount = 1
	killCount = 0
	objectGroup.x, objectGroup.y = display.contentCenterX, display.contentCenterY
	groupX, groupY = objectGroup.x, objectGroup.y
	addData(index)
	isPaused = true

			
--[[	local plants = display.newImageRect("res/plants_background.png", 1595, 96)
	plants.x, plants.y = 0,450
	objectGroup:insert(plants)]]--
	
	Runtime:addEventListener( "enterFrame", update )
	return setmetatable(_M, group_mt)
end

function _M.getDisableButtons(index)
	return _M.disabledButtons
end

function _M.removeSelf()
	Runtime:removeEventListener( "enterFrame", update )
	audio.stop(channel)
	objectGroup:removeSelf()
end

return _M
