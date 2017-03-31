local receptorPosition = 600
local scrollSpeed = 15

local gameplay = {}

function gameplay:enter(_, map)
  self.map = map
  self.songTime = 0
end

function gameplay:update(dt)
  self.songTime = self.songTime + dt
end

function gameplay:draw()
  local sh = love.graphics.getHeight()
  if self.map then
    local noteScale = 100 * scrollSpeed

    for _, note in ipairs(self.map.notes) do
      local x = note.column * 64
      local y = receptorPosition - (note.time - self.songTime) * noteScale
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
    love.graphics.rectangle('fill', 0, receptorPosition, 64 * self.map.columns, 32)
  end
end

return gameplay
