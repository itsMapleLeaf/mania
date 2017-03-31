local receptorPosition = 600
local scrollSpeed = 15

return function (map)
  local songTime = 0

  local function update(dt)
    songTime = songTime + dt
  end

  local function draw()
    local sh = love.graphics.getHeight()
    if map then
      local noteScale = 100 * scrollSpeed

      for _, note in ipairs(map.notes) do
        local x = note.column * 64
        local y = receptorPosition - (note.time - songTime) * noteScale
        if y > -32 and y < sh then
          love.graphics.setColor(255, 255, 255)
          love.graphics.rectangle('fill', x, y, 64, 32)
        end

        if note.length > 0 then
          local height = note.length * noteScale * -1
          if y > 0 or y + height < sh then
            love.graphics.setColor(255, 255, 255, 120)
            love.graphics.rectangle('fill', x, y, 64, height)
          end
        end
      end

      love.graphics.setColor(255, 255, 255, 120)
      love.graphics.rectangle('fill', 0, receptorPosition, 64 * map.columns, 32)
    end
  end

  return { update = update, draw = draw }
end
