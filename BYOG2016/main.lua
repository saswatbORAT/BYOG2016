local element = require( "element" )

local box = require("box")

local widget = require( "widget" )

local totalColumns, totalRows = 16,9
local constX, constY = 0,50
local btnWidth, btnHeight = 80, 80
local startPosX, startPosY = constX, constY
local x, y = 0, 0
local gridX, gridY = 1,1
local buttons = {}

local function handleButtonEvent( event)
    if ( "ended" == event.phase ) then
 
    	local index = string.find(event.target.carta,"_")
		local x = tonumber(event.target.carta:sub(0,index-1))
		local y = tonumber(event.target.carta:sub(index+1))
		
		for c =0, gridX, 1 do
			for r = 0, gridY, 1 do
				if(x+c >totalColumns or y+r > totalRows or buttons[x+c][y+r].alpha <= 0.1)then
				return
				end
			end	
		end
		
		for column =0, gridX, 1 do
			for row = 0, gridY, 1 do
				buttons[x+column][y+row].alpha = 0.1
			end	
		end
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
			buttons[column][row] = btn
			startPosY = startPosY + btnWidth
			end
	startPosX = startPosX + btnHeight
	startPosY = constY
	end