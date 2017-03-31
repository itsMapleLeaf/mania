local osu = require 'lib.osu'

return function ()
  local maps = osu.loadMaps()

  local function draw()
    for i, map in ipairs(maps) do
      local x = 10
      local y = 10 + (i - 1) * 30
      love.graphics.print(map, x, y)
    end
  end

  return { draw = draw }
end
