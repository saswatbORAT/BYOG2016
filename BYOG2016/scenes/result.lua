local composer = require("composer")
local widget = require("widget")
local levelData = require("classes.levelData")

local scene = composer.newScene()
local mainGroup = display.newGroup()

local nextBtn, restartBtn, menuBtn, resultText

local function btnCallback(event)
	if(event.phase == "ended")then
		if(event.target.carta == "next")then
		levelData.index = (tonumber(levelData.index) + 1)
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
	local background = display.newImageRect("res/bg.png",2016, 1136)
	background.x, background.y = display.contentCenterX, display.contentCenterY

	
	nextBtn = widget.newButton({
					x = display.contentCenterX,
					y = display.contentCenterY * 0.5,
					width = 123,
					height = 63,
					defaultFile = "box.png",
					overFile = "box.png",
					label = "next",
					onEvent = btnCallback
				})
	nextBtn.carta = "next"
	
	menuBtn = widget.newButton({
					x = display.contentCenterX,
					y = display.contentCenterY * 1.5,
					width = 123,
					height = 63,
					defaultFile = "box.png",
					overFile = "box.png",
					label = "menu",
					onEvent = btnCallback
				})
	menuBtn.carta = "menu"
	
	restartBtn = widget.newButton({
					x = display.contentCenterX,
					y = display.contentCenterY,
					width = 123,
					height = 63,
					defaultFile = "box.png",
					overFile = "box.png",
					label = "restart",
					onEvent = btnCallback
				})
	restartBtn.carta = "restart"
	
	local _text
	if(levelData.won)then
		_text = "Level Complete"
	else
		_text = "Level Failed"
	end
	
	local textDetails = 
	{
    	text = _text,
    	x = 500,
    	y = 500,
    	width = 120,     --required for multi-line and alignment
    	font = native.systemFont,
    	fontSize = 40
	}
	local text = display.newText( textDetails )
	text:setFillColor( 1, 0, 0 )
	
	mainGroup:insert(background)	
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