local flux = require "lib.flux"
local draw_duo = require "duo"
local obstacles = require "game_scene.obstacles"
local draw_level_bar = require "game_scene.level_bar"
local background = require "game_scene.background"
local gfx, kbd = love.graphics, love.keyboard
local width, height = gfx.getDimensions()

local game_scene = {canvas = gfx.newCanvas(width, height)}

local entering_delay = {t = 0}
local duo = {rotation = 90, y = height / 2}
local level_bar = {y = height, completion = 0}

function game_scene.update(dt)
    flux:update(dt)
    background.update(dt)
    obstacles.update(dt)

    level_bar.completion = math.min(
                               math.max(level_bar.completion + 0.5 * dt, 0), 100)

    if kbd.isDown("left") then
        duo.rotation = duo.rotation - 5
    elseif kbd.isDown("right") then
        duo.rotation = duo.rotation + 5
    end
end

function game_scene.draw()
    gfx.clear()
    gfx.setBackgroundColor(BLACK)

    background.draw()
    draw_duo(80, duo.y, 50, 10, duo.rotation)
    obstacles.draw()
    draw_level_bar(level_bar.y, level_bar.completion)
end

function game_scene.on_enter(callback)
    flux.to(entering_delay, 0, {t = 1}):oncomplete(
        function()
            obstacles.load()
            callback()
        end)

    flux.to(level_bar, 0.5, {y = height - 16})
end

return game_scene
