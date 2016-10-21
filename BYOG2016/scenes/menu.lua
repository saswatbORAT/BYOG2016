local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local mainGroup = display.newGroup()
local exitBtn, playBtn, learnBtn

local function btnCallback(event)
	if(event.phase == "ended")then
		if(event.target.carta == "play")then
		composer.gotoScene('scenes.levels')
		composer.removeScene('scenes.menu')
		elseif(event.target.carta == "exit")then
		os.exit()
		elseif(event.target.carta == "learn")then
		composer.gotoScene('scenes.instructions')
		composer.removeScene('scenes.menu')
		end
	end
end

function scene:create()
	mainGroup.x, mainGroup.y = 0, 0
	local background = display.newImageRect("res/bg.png",2016, 1136)
	background.x, background.y = display.contentCenterX, display.contentCenterY
	mainGroup:insert(background)
	
	playBtn = widget.newButton({
					x = display.contentCenterX,
					y = display.contentCenterY * 0.5,
					width = 123,
					height = 63,
					defaultFile = "box.png",
					overFile = "box.png",
					label = "play",
					onEvent = btnCallback
				})
	playBtn.carta = "play"
	
	exitBtn = widget.newButton({
					x = display.contentCenterX,
					y = display.contentCenterY * 1.5,
					width = 123,
					height = 63,
					defaultFile = "box.png",
					overFile = "box.png",
					label = "exit",
					onEvent = btnCallback
				})
	exitBtn.carta = "exit"
	
	learnBtn = widget.newButton({
					x = display.contentCenterX,
					y = display.contentCenterY,
					width = 123,
					height = 63,
					defaultFile = "box.png",
					overFile = "box.png",
					label = "Learn",
					onEvent = btnCallback
				})
	learnBtn.carta = "learn"
	
	mainGroup:insert(playBtn)
	mainGroup:insert(exitBtn)
	mainGroup:insert(learnBtn)
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