local composer = require("composer")
local widget = require("widget")
local levelData = require("classes.levelData")

local scene = composer.newScene()

local mainGroup = display.newGroup()
local backBtn
local constX, constY = -300,400
local startX, startY = constX, constY
local btnWidth, btnHeight, btnSpaceX, btnSpaceY = 150, 150, 300, 300
local btnCount = 15

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
	display.setDefault("background", 0,0,0)
	
			
		local bg = display.newImage("res/MainMenu/bg.png", 2016, 1136)
		bg.x , bg.y =  display.contentCenterX, display.contentCenterY
		mainGroup:insert(bg)
		
	backBtn = widget.newButton({
					x = -500,
					y = 150,
					width = 120,
					height = 180,
					defaultFile = "res/backButton.png",
					overFile = "res/backButton.png",
					label = "",
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
					defaultFile = "res/Chips/"..tostring(math.random(1,7))..".png",
					overFile = "res/Chips/"..tostring(math.random(1,7))..".png",
					label = tostring(i),
					labelColor = { default={ 0,0,0 }, over={ 0,0,0 } },
					font = "res/arial.ttf",
					fontSize = 70,
					onEvent = btnCallback
				})
	--[[	if(i == 10)then
			btn:setLabel("1O")
		end]]--
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