local composer = require("composer")
local widget = require("widget")

local scene = composer.newScene()

local mainGroup = display.newGroup()
local backBtn

local function btnCallback(event)
	if(event.phase == "ended")then
		if(event.target.carta == "back")then
		composer.gotoScene('scenes.menu')
		composer.removeScene('scenes.instructions')
		end
	end
end

function scene:create()
	mainGroup.x, mainGroup.y = 0, 0
	display.setDefault("background", 0,0,0)
	
	local learn = display.newImageRect("res/learn.png", 2016, 1136)
	learn.x, learn.y = display.contentCenterX, display.contentCenterY
			
	backBtn = widget.newButton({
					x = -400,
					y = 100,
					width = 400,
					height = 160,
					defaultFile = "res/buttons/backBtn.png",
					overFile = "res/buttons/backBtn.png",
					label = "",
					onEvent = btnCallback
				})
	backBtn.carta = "back"
	
	local textDetails = 
	{
    	text = "Instructions",
    	x = 500,
    	y = 500,
    	width = 120,     --required for multi-line and alignment
    	font = native.systemFont,
    	fontSize = 40
	}
	local text = display.newText( textDetails )
	text:setFillColor( 1, 0, 0 )

	mainGroup:insert(text)
	mainGroup:insert(learn)
	mainGroup:insert(backBtn)

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