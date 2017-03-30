io.stdout:setvbuf('no')

local gameplay = require 'states.gameplay'
local osu = require 'lib.osu'

local state

function love.load()
  if not love.filesystem.isDirectory('maps') then
    love.filesystem.createDirectory('maps')
  end

  for _, osz in ipairs(love.filesystem.getDirectoryItems('maps')) do
    if osz:match('%.osz$') then
      print('Extracting ' .. osz)
      osu.extractOSZ(osz)
    end
  end

  local map

  -- state = gameplay(map)
end

function love.update(dt)
  -- state:update(dt)
end

function love.draw()
  -- state:draw()
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
