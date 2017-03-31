local osu = require 'lib.osu'
local util = require 'lib.util'
-- local inspect = require 'lib.inspect'

local mapselect = {}

function mapselect:enter()
  local mapFiles = osu.loadMaps()
  self.maps = util.map(mapFiles, osu.loadMapFile)
end

function mapselect:draw()
  for i, map in ipairs(self.maps) do
    local x = 10
    local y = 10 + (i - 1) * 30
    love.graphics.print(map.artist .. ' - ' .. map.title, x, y)
  end
end

return mapselect
