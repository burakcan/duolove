local gfx, rand, cos, sin, rad = love.graphics, love.math.random, math.cos,
                                 math.sin, math.rad

local window_width, window_height = gfx.getDimensions()

local canvas = gfx.newCanvas(window_width, window_height)

local last_min_x = 0
local last_max_x = window_width
local last_min_y = 0
local last_max_y = window_height

local function draw_duo(center_x, center_y, radius, dot_radius, rotation)
    local prevCanvas = gfx.getCanvas()
    gfx.setCanvas(canvas)

    local radians = rad(rotation)
    local cos_radians = cos(radians)
    local sin_radians = sin(radians)

    local x1 = center_x + radius * cos_radians
    local y1 = center_y + radius * sin_radians
    local x2 = center_x + radius * -cos_radians
    local y2 = center_y + radius * -sin_radians

    -- Particle effect
    gfx.setColor(0, 0, 0, 0)
    gfx.setBlendMode("replace")
    for i = 1, 1024 do
        gfx.rectangle("fill", rand(last_min_x, last_max_x),
                      rand(last_min_y, last_max_y), 2, 2)

        last_min_x = center_x - radius - dot_radius - 100
        last_max_x = center_x + radius + dot_radius + 100
        last_min_y = center_y - radius - dot_radius
        last_max_y = center_y + radius + dot_radius
    end
    gfx.setBlendMode("alpha")

    -- Draw dots
    gfx.setColor(BLACK)
    gfx.circle("fill", x1, y1, dot_radius)
    gfx.circle("fill", x2, y2, dot_radius)

    -- Draw border to one of the dots
    gfx.setColor(WHITE)
    gfx.circle("fill", x1, y1, dot_radius - 4)

    -- Flip the canvas to screen
    gfx.setCanvas(prevCanvas)
    gfx.setColor(1, 1, 1, 1)
    gfx.draw(canvas, 0, 0)
end

return draw_duo, duo_force_clean
