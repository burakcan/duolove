local HC = require "lib.HC"
local gfx, rand, rad = love.graphics, love.math.random, math.rad
local window_width, window_height = gfx.getDimensions()

local quads = {}
local canvas = gfx.newCanvas(window_width, window_height)
local tile_img = gfx.newImage('resources/obstacle_tile_1.png')
tile_img:setWrap("repeat")

local obstacles = {items = {}}

local obs_width = 16
local obs_segment_size = 16
local obs_max_segments = 6
local obs_spacing = 96
local obs_edge_spacing = 10
local obs_max_displacement = 30
local obs_max_angle = 25
local obs_speed = 110

local function get_obstacle_values(i)
    local rnd_type = rand(0, 7)
    local x, y, width, height, angle

    x = i * obs_spacing + window_width;
    width = obs_width
    angle = rad(rand(obs_max_angle, -obs_max_angle))

    if rnd_type == 4 then -- center tile
        height = obs_segment_size * rand(2, obs_max_segments - 2)
        y = (window_height / 2) - (height / 2)
    elseif rnd_type < 4 then -- top
        height = obs_segment_size * obs_max_segments
        y = obs_edge_spacing + rand(obs_max_displacement)
    else -- bottom
        height = obs_segment_size * obs_max_segments
        y = window_height - height - obs_edge_spacing -
                rand(obs_max_displacement)
    end

    return x, y, width, height, angle
end

local function reuse_obstacle(i, pass_i)
    local x, y, width, height, angle = get_obstacle_values(pass_i and i or 1)

    obstacles.items[i].x = x
    obstacles.items[i].y = y
    obstacles.items[i].width = width
    obstacles.items[i].height = height
    obstacles.items[i].angle = angle

    HC.remove(obstacles.items[i].body);

    obstacles.items[i].body = HC.rectangle(x, y, width, height)
    obstacles.items[i].body:setRotation(angle)
    obstacles.items[i].body.type = "obstacle"
end

local function create_obstacle(i)
    local x, y, width, height, angle = get_obstacle_values(i)

    local obs = {
        x = x,
        y = y,
        width = width,
        height = height,
        angle = angle,
        body = HC.rectangle(x, y, width, height)
    }

    obs.body:setRotation(obs.angle)
    obs.body.type = "obstacle"

    return obs
end

local function draw_obstacle(obs)
    local x, y, width, height, angle = obs.x, obs.y, obs.width, obs.height,
                                       obs.angle

    local quad = quads[height / obs_segment_size]

    gfx.setColor(BLACK)

    gfx.push()
    gfx.translate(x + width / 2, y + height / 2)
    gfx.rotate(angle)
    gfx.rectangle("fill", -width / 2 - 2, -height / 2 - 2, width + 4,
                  height + 4, 2)

    gfx.setColor(1, 1, 1, 1)
    gfx.draw(tile_img, quad, -width / 2, -height / 2)
    gfx.pop()
end

function obstacles.load()
    for i = 1, obs_max_segments do
        table.insert(quads, gfx.newQuad(0, 0, obs_width, i * obs_segment_size,
                                        tile_img:getDimensions()))
    end

    for i = 1, 5 do table.insert(obstacles.items, create_obstacle(i)) end
end

function obstacles.reset()
    for i = 1, table.getn(obstacles.items) do reuse_obstacle(i, true) end
end

function obstacles.update(dt)
    for i = 1, table.getn(obstacles.items) do
        if obstacles.items[i].x <= 0 then
            reuse_obstacle(i)
        else
            obstacles.items[i].x = obstacles.items[i].x - (obs_speed * dt)
            obstacles.items[i].body:move(-(obs_speed * dt), 0)
        end
    end
end

function obstacles.draw()
    local prevCanvas = gfx.getCanvas()
    gfx.setCanvas(canvas)

    gfx.clear()

    table.foreach(obstacles.items,
                  function(i, obstacle) draw_obstacle(obstacle) end)

    gfx.setCanvas(prevCanvas)
    gfx.setColor(1, 1, 1, 1)
    gfx.draw(canvas, 0, 0)
end

return obstacles
