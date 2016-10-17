local widget = require( "widget" )

local totalColumns, totalRows = 16,9
local constX, constY = 0,100
local btnWidth, btnHeight = 80, 80
local startPosX, startPosY = constX, constY
local x, y = 0, 0
local gridX, gridY = 0,0
local buttons = {}
local btns = {}
local blocks = {}
local btnsGroup = display.newGroup()
local characters = {}
local btnGroup = display.newGroup()
btnGroup.x = -284
btnGroup.y = 160
btnGroup.isVisible = true

local physics = require( "physics" )
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")

local character = display.newRect(0,320, 100, 100)

local leftBody = display.newRect(-330,580, 10, 720)
physics.addBody(leftBody, "static")
leftBody.myName = "leftwall"
local rightBody = display.newRect(963,580, 10, 720)
physics.addBody(rightBody, "static")
rightBody.myName = "rightwall"
local upBody = display.newRect(320, 215, 1280, 10)
physics.addBody(upBody, "static")
upBody.myName = "upwall"
local downBody = display.newRect(320, 947, 1280, 10)
physics.addBody(downBody, "static")
downBody.myName = "downwall"

local xVel, yVel = 300, 300
local xDir, yDir = 1, 0
local value = 90

local function onLocalCollision( self, event )

    if ( event.phase == "began" ) then
    	if(self.myName ==  "char")then
    	--character.rotation = character.rotation + 90
    	xDir = math.round(math.sin(value * math.pi/180))
    	yDir = math.round(math.cos(value * math.pi/180))
    --	print(xDir.."    "..yDir)
    	character:setLinearVelocity(xVel * xDir, yVel * yDir)
    	value = value + 90
    	end
    end
end

character:setFillColor(1.0,1.0,0.0,1.0)
--transition.to(character, {time = 5000, x = 1500, y = character.y}
character.myName = "char"
physics.addBody(character, "dynamic",{density=0.0, friction=0.0, bounce=0.00})
--character.collision = onLocalCollision
--character:addEventListener( "collision" )
character:setLinearVelocity(xVel * xDir, yVel * yDir)

local hits = {} 
local function removeImg(event)
	if(event.numTaps > 1)then
		local coordinates, strX, strY = "", "", ""
		local x,y = 0,0
		event.target:removeSelf()
		for loop = 1, event.target.myName:len(), 4 do
			coordinates = event.target.myName:sub(loop, loop+3)
			strX = coordinates:sub(1,2)
			strY = coordinates:sub(3,4)
			x = tonumber(strX)
			y = tonumber(strY)
			buttons[x][y].alpha = 1
		end
	end
end


local function handleButtonEvent( event)
    if ( "ended" == event.phase ) then
 		
    	local index = string.find(event.target.carta,"_")
		local x = tonumber(event.target.carta:sub(0,index-1))
		local y = tonumber(event.target.carta:sub(index+1))
		local name = ""
		
		for c =0, gridX, 1 do
			for r = 0, gridY, 1 do
				if(x+c >totalColumns or y+r > totalRows or buttons[x+c][y+r].alpha <= 0.01)then
				return
				end
			end	
		end
		
		for column =0, gridX, 1 do
			for row = 0, gridY, 1 do
				buttons[x+column][y+row].alpha = 0.01
				name = name..string.format("%02d%02d", x+column,y+row)
			end	
		end
		
		local posX, posY = 0,0
		local minX, minY = buttons[x][y].x, buttons[x][y].y
		local maxX, maxY = buttons[x+gridX][y+gridY].x, buttons[x+gridX][y+gridY].y
		posX, posY = (maxX + minX) * 0.5, (maxY + minY) * 0.5

		local img = display.newRect(posX, posY, btnWidth * (gridX+1), btnHeight * (gridY+1))
		img:setFillColor(1.0, 0.0, 0.0, 1.0)
		img.myName = name
		physics.addBody(img, "static",{density=1.0, friction=0.3, bounce=0.2})
		img.x = img.x + btnGroup.x
		img.y = img.y + btnGroup.y
		img:addEventListener("tap", removeImg)
    end
end

local lastBtn = 1
local function highlight(event)
	if(event.phase == "ended")then
		
		local index = string.find(event.target.carta,"_")
		local x = tonumber(event.target.carta:sub(0,index-1))
		local y = tonumber(event.target.carta:sub(index+1))
		local index = (x-1) * 3 + y

		btns[index].alpha = 0.1
		btns[lastBtn].alpha = 1.0
		lastBtn = index
		
		gridX = math.floor((index-1)/3)
		gridY = math.floor((index-1)%3)
		
	end
end


for column = 1, totalColumns,1 do
	buttons[column] = {}
		for row = 1, totalRows, 1 do
			local btn = widget.newButton({
				x = startPosX,
				y = startPosY,
				width = btnWidth,
				height = btnHeight,
				defaultFile = "box.png",
				overFile = "box.png",
				label = tostring(column) .."x".. tostring(row),
				onEvent = handleButtonEvent
			})
			btn.carta = tostring(column).."_"..tostring(row)
			btnGroup:insert(btn)
			buttons[column][row] = btn
			startPosY = startPosY + btnWidth
			end
	startPosX = startPosX + btnHeight
	startPosY = constY
	end
	
local function spawnCharacter(type)

end

local function update(event)
	hits = physics.rayCast(character.x, character.y, character.x + (xDir * 60), character.y + (yDir*60), "closest" )

	if ( hits ) then
		if(xDir == 1 and yDir == 0)then
			xDir, yDir = 0, 1
		elseif(xDir == 0 and yDir == 1)then
			xDir, yDir = -1, 0
		elseif(xDir == -1 and yDir == 0)then
			xDir, yDir = 0, -1
		elseif(xDir == 0 and yDir == -1)then
			xDir, yDir = 1, 0			
		end
    	
    	character:setLinearVelocity(xVel * xDir, yVel * yDir)
	end
end

-- ScrollView listener
local function scrollListener( event )

    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    -- In the event a scroll limit is reached...
    if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "down" ) then print( "Reached top limit" )
        elseif ( event.direction == "left" ) then print( "Reached right limit" )
        elseif ( event.direction == "right" ) then print( "Reached left limit" )
        end
    end

    return true
end

local scrollView = widget.newScrollView(
    {
        x = 320,
        y = 1050,
        width = 1500,
        height = 200,
        scrollWidth = 2000,
        scrollHeight = 200,
        listener = scrollListener
    }
)

btnsGroup.x = 0
btnsGroup.y = 0
scrollView:insert(btnsGroup)
--scrollView.isVisible = false
local xPos = btnWidth
for column = 1, 3,1 do
	btns[column] = {}
		for row = 1, 3, 1 do
			local btn = widget.newButton({
				x = xPos,
				y = btnHeight,
				width = btnWidth * column,
				height = btnHeight * row,
				defaultFile = "box.png",
				overFile = "box.png",
				label = tostring(column) .."x".. tostring(row),
				onEvent = highlight
			})
			btn.carta = tostring(column).."_"..tostring(row)
			btnsGroup:insert(btn)
			btns[((column-1)*3)+row]= btn
			xPos = xPos + btnWidth * row
			end
	end
	
	
Runtime:addEventListener( "enterFrame", update )