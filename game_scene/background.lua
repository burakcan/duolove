local gfx = love.graphics
local width, height = gfx.getDimensions()
local tile_img = gfx.newImage('resources/bg_tile.png')
tile_img:setWrap("repeat")

local background = {speed = 32, x = 0}

local canvas = gfx.newCanvas(width, height)
local bg_quad = gfx.newQuad(0, 0, width + 64, height, tile_img:getDimensions())

function background.update(dt)
    background.x = background.x - dt * background.speed
    background.x = background.x <= -32 and 0 or background.x
end

function background.draw()
    local prevCanvas = gfx.getCanvas()
    gfx.setCanvas(canvas)
    gfx.clear()

    gfx.setColor(1, 1, 1, 1)
    gfx.draw(tile_img, bg_quad, background.x, 0)

    gfx.setCanvas(prevCanvas)
    gfx.setColor(1, 1, 1, 1)
    gfx.draw(canvas, 0, 0)
end

return background
