local gfx = love.graphics
local scene_manager = {}
local scenes = {}
local transition = {from = nil, current = nil}

local scene_metatable = {
    __index = {
        update = function() end,
        draw = function() end,
        on_enter = function() end,
        on_exit = function() end,
        on_exit_complete = function() end
    }
}

function scene_manager.load() end

function scene_manager.update(dt)
    for k, scene in pairs(transition) do scene.update(dt) end
end

function scene_manager.draw()
    for k, scene in pairs(transition) do
        gfx.setCanvas(scene.canvas)
        scene.draw()
        gfx.setCanvas()
        gfx.setColor(1, 1, 1, 1)
        gfx.draw(scene.canvas, 0, 0)
    end
end

function scene_manager.register_scene(name, scene)
    setmetatable(scene, scene_metatable)
    scenes[name] = scene
    return scene
end

function scene_manager.enter_to(name)
    local entering_scene = scenes[name]
    local exiting_scene = transition.current;

    love.keypressed = nil
    love.keyreleased = nil

    if exiting_scene then exiting_scene.on_exit() end

    entering_scene.on_enter(function()
        if exiting_scene then exiting_scene.on_exit_complete() end
        transition.from = nil
    end)

    transition.current = entering_scene
    transition.from = exiting_scene
end

return scene_manager
