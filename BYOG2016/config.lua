local normalW, normalH = 1136, 640

if not display then return end -- This is needed for dekstop app

local w, h = display.pixelWidth, display.pixelHeight
local scale = math.max(normalW / w, normalH / h)
w, h = w * scale, h * scale

application = {
    content = {
		width = 1136,
        height = 640,
        scale = 'letterbox',
        fps = 60
    }
}