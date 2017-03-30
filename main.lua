io.stdout:setvbuf('no')

-- local inspect = require('inspect')
local gameplay = require 'gameplay'
local osu = require 'osu'

local state

function love.load()
  if not love.filesystem.isDirectory('maps') then
    love.filesystem.createDirectory('maps')
  end

  local map
  for _, mapfolder in ipairs(love.filesystem.getDirectoryItems('maps')) do
    if love.filesystem.mount('maps/' .. mapfolder, 'map') then
      for _, mapfile in ipairs(love.filesystem.getDirectoryItems('map')) do
        if mapfile:match('%.osu$') then
          map = osu.loadMapFile(mapfile)
          break
        end
      end
      love.filesystem.unmount('maps/' .. mapfolder)
      break
    end
  end

  state = gameplay(map)
end

function love.update(dt)
  state:update(dt)
end

function love.draw()
  state:draw()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
