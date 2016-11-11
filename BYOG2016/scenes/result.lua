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
	
	local bg = display.newImage("res/MainMenu/bg.png", 2016, 1136)
	bg.x , bg.y =  display.contentCenterX, display.contentCenterY
	mainGroup:insert(bg)
		
	nextBtn = widget.newButton({
					x = display.contentCenterX,
					y = 900,
					width = 264,
					height = 382,
					defaultFile = "res/over/next.png",
					overFile = "res/over/next.png",
					label = "",
					onEvent = btnCallback
				})
	nextBtn.carta = "next"
	
	menuBtn = widget.newButton({
					x = 0,
					y = 900,
					width = 256,
					height = 334,
					defaultFile = "res/over/Menu.png",
					overFile = "res/over/Menu.png",
					label = "",
					onEvent = btnCallback
				})
	menuBtn.carta = "menu"
	
	restartBtn = widget.newButton({
					x = 650,
					y = 900,
					width = 256,
					height = 334,
					defaultFile = "res/over/retry.png",
					overFile = "res/over/retry.png",
					label = "",
					onEvent = btnCallback
				})
	restartBtn.carta = "restart"
	
	if(levelData.index == "14" or levelData.index == 14)then
		nextBtn.alpha = 0
	end
	
	local _text
	if(levelData.won)then
		_text = "Level Complete!"
	else
		_text = "Level Failed!"
	end
	
	local textDetails = 
	{
    	text = _text,
    	x = display.contentCenterX,
    	y = 400,
    	width = 1200,
    	height = 400,     --required for multi-line and alignment
    	font = "res/arial.ttf",
    	fontSize = 150,
    	align = "center"
	}
	local text = display.newText( textDetails )
--[[	if(levelData.won)then
	text:setFillColor( 0, 1, 0 )
	else
	text:setFillColor( 1, 0, 0 )
	end]]--
	
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