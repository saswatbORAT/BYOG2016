local composer = require("composer")
local widget = require("widget")
local levelData = require("classes.levelData")

local physics = require("physics")
physics.start()
physics.setGravity(0,0)

local bg
local mainGroup = display.newGroup()
local gridGroup = display.newGroup()
local scene = composer.newScene()
local ratioX, ratioY = display.contentWidth/1136, display.contentHeight/640
local totalColumns, totalRows = 16,9
local btnWidth, btnHeight = 100, 100
local gridWidth, gridHeight = btnWidth * totalColumns, btnHeight * totalRows
local constX, constY = btnWidth * 0.5,btnHeight * 0.5
local startPosX, startPosY = constX, constY
local x, y = 0, 0
local gridX, gridY = 0,0
local blocks = {}
local btnsGroup = display.newGroup()
local element = require("classes.element")
local elementGroup = display.newGroup()
local level = require("levels.level")
local currentLevel
local scrollView, scroll_bg, playImg, recImg
local playBtn, backBtn, upBody, downBody, leftBody, rightBody
local limit = {}


local function addBoundary()
	upBody = display.newRect(display.contentCenterX, display.contentCenterY - gridHeight * 0.5, gridWidth, 10)
	physics.addBody(upBody, "static")
	upBody.myName = "up"
	upBody:setFillColor( 0.0, 0.0, 0.0, 0.01 )
	
	downBody = display.newRect(display.contentCenterX, display.contentCenterY + gridHeight * 0.5, gridWidth, 10)
	physics.addBody(downBody, "static")
	downBody.myName = "down"
	downBody:setFillColor( 0.0, 0.0, 0.0, 0.01 )
	
	leftBody = display.newRect(display.contentCenterX - gridWidth * 0.5 , display.contentCenterY, 10, gridHeight)
	physics.addBody(leftBody, "static")
	leftBody.myName = "left"
	leftBody:setFillColor( 0.0, 0.0, 0.0, 0.01 )
	
	rightBody = display.newRect(display.contentCenterX + gridWidth * 0.5, display.contentCenterY, 10, gridHeight)
	physics.addBody(rightBody, "static")
	rightBody.myName = "right"
	rightBody:setFillColor( 0.0, 0.0, 0.0, 0.01 )
end

local function removeImg(event)
	if(event.numTaps > 1 and scrollView.alpha >= 0.5)then
		local coordinates, strX, strY = "", "", ""
		local x,y = 0,0
		event.target:removeSelf()
		for loop = 1, event.target.myName:len() - 1, 4 do
			coordinates = event.target.myName:sub(loop, loop+3)
			strX, strY = coordinates:sub(1,2), coordinates:sub(3,4)
			x = tonumber(strX)
			y = tonumber(strY)
			blocks[x][y].alpha = 0.1
		end

		local index =  tonumber(event.target.myName:sub(event.target.myName:len()))
		limit[index] = limit[index] + 1

	end
end

local function handleButtonEvent( event)
    if ( "ended" == event.phase and scrollView.alpha >= 0.5) then
    	local btnIndex = (gridY*3) + (gridX + 1)
    	if(limit[btnIndex] <= 0)then
    		return
    	end
    	
 		local x = tonumber(event.target.carta:sub(1,2))
 		local y = tonumber(event.target.carta:sub(3,4))
 		local name = ""
		
		for c =0, gridX, 1 do
			for r = 0, gridY, 1 do
				if(x+c >totalColumns or y+r > totalRows or blocks[x+c][y+r].alpha <= 0.01)then
				return
				end
			end	
		end
		
		for column =0, gridX, 1 do
			for row = 0, gridY, 1 do
				blocks[x+column][y+row].alpha = 0.01
				name = name..string.format("%02d%02d", x+column,y+row)
			end	
		end
		
		local posX, posY = 0,0
		local minX, minY = blocks[x][y].x, blocks[x][y].y
		local maxX, maxY = blocks[x+gridX][y+gridY].x, blocks[x+gridX][y+gridY].y
		posX, posY = (maxX + minX) * 0.5, (maxY + minY) * 0.5
		
		local ele = element.new(btnIndex, posX + gridGroup.x, posY + gridGroup.y, btnWidth * (gridX+1), btnHeight * (gridY+1))
		ele.myName = name..btnIndex
		physics.addBody(ele, "static",{density=1.0, friction=0.3, bounce=0.2})
		ele:addEventListener("tap", removeImg)
		elementGroup:insert(ele)
		limit[btnIndex] = limit[btnIndex] - 1
    end
end

local function addGridButtons()
	for column = 1, totalColumns,1 do
		blocks[column] = {}
			for row = 1, totalRows, 1 do
				local btn = widget.newButton({
					x = startPosX,
					y = startPosY,
					width = btnWidth,
					height = btnHeight,
					defaultFile = "box.png",
					overFile = "box.png",
					label = "",
					onEvent = handleButtonEvent
				})
			btn.carta = string.format("%02d%02d", column, row)
			btn.alpha = 0.1
			gridGroup:insert(btn)
			blocks[column][row] = btn
			startPosY = startPosY + btnWidth
			end
	startPosX = startPosX + btnHeight
	startPosY = constY
	end
end

local function playGame(event)
	if ( "ended" == event.phase ) then
		if(event.target.carta == "play")then
			currentLevel:moveChar()
			recImg.alpha = 1.0
			playImg.alpha = 0.0
			event.target.carta = "stop"
			scrollView.alpha = 0
		elseif(event.target.carta == "stop")then
			currentLevel:reset()
			currentLevel:reset()
			playImg.alpha = 1.0
			recImg.alpha = 0.0
			event.target.carta = "play"
			scrollView.alpha = 1
		elseif(event.target.carta == "back")then
			composer.gotoScene('scenes.levels')
			composer.removeScene('scenes.game')
		end
	end
end

local function elementBtnCallback(event)
	if(event.phase == "ended")then
		if(event.target.carta == "1")then
			gridX, gridY = 0, 0
		elseif(event.target.carta == "2")then
			gridX, gridY = 1, 0 
		elseif(event.target.carta == "3")then
			gridX, gridY = 2, 0 
		elseif(event.target.carta == "4")then
			gridX, gridY = 0, 1 
		elseif(event.target.carta == "5")then
			gridX, gridY = 1, 1 
		elseif(event.target.carta == "6")then
			gridX, gridY = 2, 1 
		elseif(event.target.carta == "7")then
			gridX, gridY = 0, 2 
		elseif(event.target.carta == "8")then
			gridX, gridY = 1, 2
		elseif(event.target.carta == "9")then
			gridX, gridY = 2, 2 
		end
	end
end

local elementYPos = 100
local function getButton(index, _limit)
	local btn = widget.newButton({
					x = 100,
					y = elementYPos,
					width = 150,
					height = 150,
					defaultFile = "res/btn.png",
					overFile = "box.png",
					label = index,
					onEvent = elementBtnCallback
			})
	elementYPos = elementYPos + 300
	btn.carta = index
	limit[tonumber(index)] = _limit
	scrollView:insert(btn)
end

local function addElementButtons(index)
	if(index == "1")then
		getButton("1", 3)
		getButton("2", 3)
		getButton("3", 3)
		getButton("4", 3)
		getButton("5", 3)
		getButton("6", 3)
		getButton("7", 3)
		getButton("8", 3)
		getButton("9", 3)
	elseif(index == "2")then
			
	end
end

local recSize ={width = 100,height = 50,numFrames = 2}
local recSequences = {
{name = "blink",start = 1,count = 2,time = 1000},
}

function scene:create()
	mainGroup:insert(elementGroup)
	gridGroup.x, gridGroup.y = display.contentCenterX - gridWidth * 0.5, display.contentCenterY - gridHeight * 0.5
	elementGroup.x, elementGroup.y = 0,0
	bg = display.newImageRect("res/main_background.png", 2016, 1136)
	bg.x, bg.y = display.contentCenterX, display.contentCenterY
	elementGroup:insert(1, bg)
	addGridButtons()
	addElementButtons(levelData.index)
	addBoundary()
	currentLevel = level.new(levelData.index)
	local coordinates = currentLevel.getDisableButtons(levelData.index)
	for i = 1, #coordinates, 1 do
		local str = coordinates[i]
		local x, y = tonumber(coordinates[i]:sub(1,2)), tonumber(coordinates[i]:sub(3,4))
		blocks[x][y].alpha = 0.01
	end
	
	playBtn = widget.newButton({x = -620,y = 750,width = 100,height = 50,defaultFile = "box.png",overFile = "box.png",label = "",onEvent = playGame})
	playBtn.carta = "play"
	playBtn.alpha = 0.1

	backBtn = widget.newButton({x = -620,y = 250,width = 100,height = 50,defaultFile = "res/backButton.png",overFile = "res/backButton.png",label = "",onEvent = playGame})
	backBtn.carta = "back"
	
	playImg = display.newImageRect("res/playImage.png", 100, 50)
	playImg.x, playImg.y = -620, 750
	elementGroup:insert(playImg)
	
	local sheet = graphics.newImageSheet( "res/recImage.png", recSize )
	recImg = display.newSprite(sheet, recSequences)
	recImg.x, recImg.y = -620, 750
	elementGroup:insert(recImg)
	recImg:play()
	recImg.alpha = 0.0
	
	scroll_bg = display.newImageRect( "res/scrollbar_background.png", 200, 2000 )
	scroll_bg.x, scroll_bg.y = 100, 1000
	scrollView:insert(1,scroll_bg)
end

scrollView = widget.newScrollView(
    {
        x = display.contentWidth * 1.92,
        y = display.contentHeight * 0.46,
        width = 200,
        height = 780,
        scrollWidth = 2000,
        scrollHeight = 200,
        listener = scrollListener
    }
)



function scene:show()
end

function scene:hide()
end

function scene:destroy()
	scrollView:removeSelf()
	backBtn:removeSelf()
	playBtn:removeSelf()
	gridGroup:removeSelf()
	upBody:removeSelf()
	downBody:removeSelf()
	rightBody:removeSelf()
	leftBody:removeSelf()
   	currentLevel:removeSelf()
   	elementGroup:removeSelf()
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene