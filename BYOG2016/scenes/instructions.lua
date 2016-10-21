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
	local background = display.newImageRect("res/bg.png",2016, 1136)
	background.x, background.y = display.contentCenterX, display.contentCenterY

	
	backBtn = widget.newButton({
					x = display.contentCenterX,
					y = display.contentCenterY * 0.5,
					width = 123,
					height = 63,
					defaultFile = "box.png",
					overFile = "box.png",
					label = "back",
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

	mainGroup:insert(background)
	mainGroup:insert(text)
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