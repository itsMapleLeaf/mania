local osu = require 'lib.osu'
local util = require 'lib.util'
local gamestate = require 'lib.hump.gamestate'
local gameplay = require 'states.gameplay'
-- local inspect = require 'lib.inspect'

local mapselect = {}

function mapselect:enter()
  local mapFiles = osu.loadMaps()
  self.maps = util.map(mapFiles, osu.loadMapFile)
  self.current = 1
end

function mapselect:keypressed(key)
  if key == 'up' and self.current > 1 then
    self.current = self.current - 1
  end
  if key == 'down' and self.current < #self.maps then
    self.current = self.current + 1
  end
  if key == 'return' then
    gamestate.switch(gameplay, self.maps[self.current])
  end
  if key == 'escape' then
    love.event.quit()
  end
end

function mapselect:draw()
  for i, map in ipairs(self.maps) do
    local x = 10
    local y = 10 + (i - 1) * 30
    local text = string.format('%s - %s [%s] // %s',
      map.artist, map.title, map.difficulty, map.creator)

    love.graphics.setColor(255, 255, 255, 100)
    if i == self.current then
      love.graphics.setColor(255, 255, 255)
    end

    love.graphics.print(text, x, y)
  end
end

return mapselect
