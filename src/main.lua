io.stdout:setvbuf('no')

-- local gameplay = require 'states.gameplay'
local osu = require 'lib.osu'
local util = require 'lib.util'

-- local state

local maps = {}

function love.load()
  if not love.filesystem.isDirectory('maps') then
    love.filesystem.createDirectory('maps')
  end

  local function isOSZ(file)
    return file:match('%.osz$')
  end

  local oszFiles = util.filter(love.filesystem.getDirectoryItems('maps'), isOSZ)
  util.map(oszFiles, osu.extractOSZ)

  for _, file in ipairs(love.filesystem.getDirectoryItems('maps')) do
    local path = 'maps/' .. file
    if love.filesystem.isDirectory(path) then
      for _, mapFile in ipairs(love.filesystem.getDirectoryItems(path)) do
        local mapFilePath = path .. '/' .. mapFile
        if love.filesystem.isFile(mapFilePath) and mapFile:match('%.osu$') then
          table.insert(maps, mapFilePath)
        end
      end
    end
  end

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
