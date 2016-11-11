local _M = {}

function _M.new(index, x, y, width, height)
	local element = display.newImageRect("res/Highlight/"..index..".png", width, height)
	element.x = x
	element.y = y

	physics.addBody(element, "static",{density=1.0, friction=0.3, bounce=0.2})
	
	return element
end

return _M
