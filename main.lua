local gfx = love.graphics
local scene_manager = require "scene_manager"
local intro_scene = require "intro_scene.intro_scene"
local game_scene = require "game_scene.game_scene"

BLACK = {50 / 255, 47 / 255, 41 / 255, 1}
WHITE = {177 / 255, 174 / 255, 168 / 255, 1}

function love.load()
    gfx.setBackgroundColor(1, 1, 1, 1)
    scene_manager.load()

    scene_manager.register_scene("intro", intro_scene)
    scene_manager.register_scene("game", game_scene)

    scene_manager.enter_to("intro")

    gfx.setLineStyle('rough')
    gfx.setDefaultFilter("nearest", "nearest", 1)
    gfx.setBackgroundColor(WHITE)
end

function love.update(dt)
    scene_manager.update(dt)
end

function love.draw()
    scene_manager.draw()
end
