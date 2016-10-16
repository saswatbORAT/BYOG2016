local background = display.newImageRect( "Icon.png", 57, 57)
background.x = display.contentCenterX
background.y = display.contentCenterY
background.alpha = 0.5

local bg = display.newImageRect( "Icon.png", 570, 57)
bg.x = display.contentCenterX
bg.y = display.contentCenterY + display.contentHeight*0.25
bg.alpha = 0.0

local physics = require( "physics" )
physics.start()
--physics.setDrawMode("hybrid")

physics.addBody(background, "dynamic", { radius=50, bounce=0.3 } )
physics.addBody(bg, "static")

local function kill(event)
	if(event.phase == "began")then
		bg.alpha = 1.0
	elseif(event.phase == "moved")then
		bg.alpha = 0.5
	elseif(event.phase == "ended")then
		bg.alpha = 0.0
	end
		return true
end

local function createEntity(event)
	if(event.phase == "moved")then
		print("create")
		local menu = require("menu")
	end
	return true
end

Runtime:addEventListener( "touch", kill )

background:addEventListener("touch", createEntity)