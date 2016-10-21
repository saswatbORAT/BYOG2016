local _M = {}
local options =
{
    width = 64,
    height = 64,
    numFrames = 9
}

local sheet = graphics.newImageSheet( "res/walk.png", options )

local sequences = {
    {
        name = "up",
        start = 1,
        count = 9,
        time = 1000
    }--[[,
    {
        name = "left",
        start = 10,
        count = 18,
        time = 1000
    },
    {
    	name = "down",
        start = 19,
        count = 27,
        time = 1000
    },
    {
    	name = "right",
        start = 28,
        count = 36,
        time = 1000
    }]]--
}

function _M.new(index, x, y, width, height)
	local char = display.newSprite(sheet, sequences)
	char.width = width
	char.height = height
	char.x, xPos = x, x
	char.y, yPos = y, y
	char:setSequence("up")
	char:play()
	
	return char
end


return _M
