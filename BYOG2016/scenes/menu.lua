local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local mainGroup = display.newGroup()
local exitBtn, playBtn, learnBtn, bg, logoText

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

local logoSize ={width = 843,height = 384,numFrames = 2}

local logoSequences = {
{name = "blink",start = 1,count = 2,time = 500},
}

function scene:create()
	mainGroup.x, mainGroup.y = 0, 0
	
	display.setDefault("background", 0,0,0)
	
	local sheet = graphics.newImageSheet( "res/MainMenu/Logo.png", logoSize )
	local logo = display.newSprite(sheet, logoSequences)
	logo.x, logo.y = display.contentCenterX, 300
	logo:play()
	
	logoText = display.newImage("res/MainMenu/CasinoLogo.png", 843, 348)
	logoText.x , logoText.y =  display.contentCenterX, 300

	
	playBtn = widget.newButton({
					x = display.contentCenterX,
					y = 900,
					width = 264,
					height = 382,
					defaultFile = "res/MainMenu/Play.png",
					overFile = "res/MainMenu/Play.png",
					label = "",
					onEvent = btnCallback
				})
	playBtn.carta = "play"
	
	exitBtn = widget.newButton({
					x = 650,
					y = 900,
					width = 256,
					height = 334,
					defaultFile = "res/MainMenu/Exit.png",
					overFile = "res/MainMenu/Exit.png",
					label = "",
					onEvent = btnCallback
				})
	exitBtn.carta = "exit"
	
	learnBtn = widget.newButton({
					x = 0,
					y = 900,
					width = 256,
					height = 334,
					defaultFile = "res/MainMenu/Learn.png",
					overFile = "res/MainMenu/Learn.png",
					label = "",
					onEvent = btnCallback
				})
	learnBtn.carta = "learn"

		
	bg = display.newImage("res/MainMenu/bg.png", 2016, 1136)
	bg.x , bg.y =  display.contentCenterX, display.contentCenterY
	
	mainGroup:insert(bg)
	mainGroup:insert(logo)
	mainGroup:insert(logoText)
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