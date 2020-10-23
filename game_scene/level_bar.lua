local gfx = love.graphics
local window_width, window_height = gfx.getDimensions()
local margin = 10
local height = 6
local border = 1

function draw_level_bar(y, percentage)
    gfx.setColor(BLACK)
    gfx.rectangle("fill", margin, y, window_width - margin * 2, height, 2)

    gfx.setColor(WHITE)
    gfx.rectangle("fill", margin + border, y + border,
                  window_width - margin * 2 - border * 2, height - border * 2, 2)

    gfx.setColor(BLACK)
    gfx.rectangle("fill", margin, y,
                  (window_width - margin * 2) * (percentage / 100), height, 2)

    gfx.setColor(WHITE)
end

return draw_level_bar
