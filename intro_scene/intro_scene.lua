local draw_duo = require "duo"
local scene_manager = require "scene_manager"
local flux = require "lib.flux"
local gfx, rand = love.graphics, math.random
local width, height = gfx.getDimensions()

local tile_img = gfx.newImage('resources/obstacle_tile_1.png')
local bg_quad = gfx.newQuad(0, 0, width + 64, height, tile_img:getDimensions())
tile_img:setWrap("repeat")

local logoFont = gfx.newFont("resources/AncientModernTales.ttf", 66)
local textFont = gfx.newFont("resources/EightBitDragon-anqx.ttf", 18)

local intro_scene = {canvas = gfx.newCanvas(width, height)}

local duo = {rotation = 0, x = width / 2}

local text_canvas = gfx.newCanvas(width, height)
local starting = false

local function bordered_text(font, text, y)
    gfx.setFont(font)

    gfx.setColor(WHITE)
    love.graphics.printf(text, 2, y + 2, width, "center")
    love.graphics.printf(text, -2, y - 2, width, "center")

    gfx.setColor(BLACK)
    love.graphics.printf(text, 0, y, width, "center")
end

function intro_scene.update(dt)
    flux:update(dt)

    if not (starting) then duo.rotation = (duo.rotation + dt * 50) % 360 end
end

function intro_scene.draw()
    gfx.clear()
    gfx.setBackgroundColor(BLACK)
    gfx.setColor(1, 1, 1, 1)
    gfx.draw(tile_img, bg_quad, 0, 0)

    draw_duo(duo.x, height / 2, 50, 10, duo.rotation)

    local prevCanvas = gfx.getCanvas()
    gfx.setCanvas(text_canvas)

    if not (starting) then
        bordered_text(logoFont, "DUO", 50)
        bordered_text(textFont, "Press any key to start", 186)
    else
        -- Particle effect
        gfx.setColor(0, 0, 0, 0)
        gfx.setBlendMode("replace")
        for i = 1, 512 do
            gfx.rectangle("fill", rand(70, width - 70), rand(50, height - 30),
                          2, 2)
        end
        gfx.setBlendMode("alpha")
    end

    gfx.setCanvas(prevCanvas)
    gfx.setColor(1, 1, 1, 1)
    gfx.draw(text_canvas, 0, 0)

end

function intro_scene.on_enter(callback)
    function love.keypressed(key, scancode, is_repeat)
        if not (is_repeat) and not (starting) then
            starting = true
            flux.to(duo, (450 - duo.rotation) / 360, {x = 80, rotation = 450}):ease(
                "quadout"):oncomplete(function()
                scene_manager.enter_to("game")
            end)
        end
    end

    callback()
end

return intro_scene
