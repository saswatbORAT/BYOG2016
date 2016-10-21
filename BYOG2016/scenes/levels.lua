local composer = require("composer")
local widget = require("widget")
local levelData = require("classes.levelData")

local scene = composer.newScene()

local mainGroup = display.newGroup()
local backBtn
local constX, constY = 0,300
local startX, startY = constX, constY
local btnWidth, btnHeight, btnSpaceX, btnSpaceY = 100, 100, 200, 200
local btnCount = 10

local function btnCallback(event)
	if(event.phase == "ended")then
		if(event.target.carta == "back")then
		composer.gotoScene('scenes.menu')
		composer.removeScene('scenes.levels')
		else
		levelData.index = event.target.carta
		composer.gotoScene('scenes.game')
		composer.removeScene('scenes.levels')
		end
	end
end

function scene:create()
	mainGroup.x, mainGroup.y = 0, 0
	local background = display.newImageRect("res/bg.png",2016, 1136)
	background.x, background.y = display.contentCenterX, display.contentCenterY
	mainGroup:insert(background)
	
	backBtn = widget.newButton({
					x = -320,
					y = 100,
					width = 123,
					height = 63,
					defaultFile = "box.png",
					overFile = "box.png",
					label = "back",
					onEvent = btnCallback
				})
	backBtn.carta = "back"
	
	mainGroup:insert(backBtn)
	
	for i =1, btnCount, 1 do
		local btn = widget.newButton({
					x = startX,
					y = startY,
					width = btnWidth,
					height = btnHeight,
					defaultFile = "box.png",
					overFile = "box.png",
					label = tostring(i),
					onEvent = btnCallback
				})
		btn.carta = tostring(i)
		mainGroup:insert(btn)
		startX = startX + btnSpaceX
		if(i%5 == 0)then
			startY = startY + btnSpaceX
			startX = constX
		end
	end
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