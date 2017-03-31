io.stdout:setvbuf('no')

-- local gameplay = require 'states.gameplay'
local osu = require 'lib.osu'
local fsutil = require 'lib.fsutil'

-- local state

local maps = {}

function love.load()
  if not love.filesystem.isDirectory('maps') then
    love.filesystem.createDirectory('maps')
  end

  for _, file in ipairs(love.filesystem.getDirectoryItems('maps')) do
    if fsutil.getExtension(file) == 'osz' then
      osu.extractOSZ(file)
    end
  end

  maps = osu.loadMaps()

  -- state = gameplay(map)
end

-- function love.update(dt)
--   -- state:update(dt)
-- end

function love.draw()
  for i, map in ipairs(maps) do
    local x = 10
    local y = 10 + (i - 1) * 30
    love.graphics.print(map, x, y)
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
