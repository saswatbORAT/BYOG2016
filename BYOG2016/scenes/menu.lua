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

local logoSize ={width = 1100,height = 400,numFrames = 2}

local logoSequences = {
{name = "blink",start = 1,count = 2,time = 500},
}

function scene:create()
	mainGroup.x, mainGroup.y = 0, 0
	
	display.setDefault("background", 0,0,0)
	
	local sheet = graphics.newImageSheet( "res/logo_sheet.png", logoSize )
	local logo = display.newSprite(sheet, logoSequences)
	logo.x, logo.y = display.contentCenterX, 200
	logo:play()
	mainGroup:insert(logo)
	
	playBtn = widget.newButton({
					x = display.contentCenterX,
					y = 500,
					width = 400,
					height = 160,
					defaultFile = "res/buttons/playBtn.png",
					overFile = "res/buttons/playBtn.png",
					label = "",
					onEvent = btnCallback
				})
	playBtn.carta = "play"
	
	exitBtn = widget.newButton({
					x = display.contentCenterX,
					y = 900,
					width = 400,
					height = 160,
					defaultFile = "res/buttons/exitBtn.png",
					overFile = "res/buttons/exitBtn.png",
					label = "",
					onEvent = btnCallback
				})
	exitBtn.carta = "exit"
	
	learnBtn = widget.newButton({
					x = display.contentCenterX,
					y = 700,
					width = 400,
					height = 160,
					defaultFile = "res/buttons/learnBtn.png",
					overFile = "res/buttons/learnBtn.png",
					label = "",
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