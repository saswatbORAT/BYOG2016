local composer = require("composer")
local widget = require("widget")
local levelData = require("classes.levelData")

local scene = composer.newScene()
local mainGroup = display.newGroup()

local nextBtn, restartBtn, menuBtn, resultText

local function btnCallback(event)
	if(event.phase == "ended")then
		if(event.target.carta == "next")then
		levelData.index = (levelData.index + 1)
		composer.gotoScene('scenes.game')
		composer.removeScene('scenes.result')
		elseif(event.target.carta == "restart")then
		composer.gotoScene('scenes.game')
		composer.removeScene('scenes.result')
		elseif(event.target.carta == "menu")then
		composer.gotoScene('scenes.menu')
		composer.removeScene('scenes.result')
		end
	end
end

function scene:create()
	mainGroup.x, mainGroup.y = 0, 0
	
	display.setDefault("background", 0,0,0)
		
	nextBtn = widget.newButton({
					x = display.contentCenterX,
					y = 500,
					width = 400,
					height = 160,
					defaultFile = "res/buttons/nextBtn.png",
					overFile = "res/buttons/nextBtn.png",
					label = "",
					onEvent = btnCallback
				})
	nextBtn.carta = "next"
	
	menuBtn = widget.newButton({
					x = display.contentCenterX,
					y = 900,
					width = 400,
					height = 160,
					defaultFile = "res/buttons/menuBtn.png",
					overFile = "res/buttons/menuBtn.png",
					label = "",
					onEvent = btnCallback
				})
	menuBtn.carta = "menu"
	
	restartBtn = widget.newButton({
					x = display.contentCenterX,
					y = 700,
					width = 400,
					height = 160,
					defaultFile = "res/buttons/restartBtn.png",
					overFile = "res/buttons/restartBtn.png",
					label = "",
					onEvent = btnCallback
				})
	restartBtn.carta = "restart"
	
	if(levelData.index == "9" or levelData.index == 9)then
		nextBtn.alpha = 0
	end
	
	local _text
	if(levelData.won)then
		_text = "  You successfully killed \nall the characters!"
	else
		_text = "  You failed to kill \n    all the characters!"
	end
	
	local textDetails = 
	{
    	text = _text,
    	x = display.contentCenterX,
    	y = 400,
    	width = 1200,
    	height = 400,     --required for multi-line and alignment
    	font = "res/8bit.TTF",
    	fontSize = 50
	}
	local text = display.newText( textDetails )
	if(levelData.won)then
	text:setFillColor( 0, 1, 0 )
	else
	text:setFillColor( 1, 0, 0 )
	end
	
	mainGroup:insert(text)
	mainGroup:insert(nextBtn)
	mainGroup:insert(menuBtn)
	mainGroup:insert(restartBtn)	
end

function scene:show()
end

function scene:hide()
end

function scene:destroy()
	mainGroup:removeSelf()
end

scene:addEventListener("create")
scene:addEventListener("show")
scene:addEventListener("hide")
scene:addEventListener("destroy")

return scene