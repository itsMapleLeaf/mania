io.stdout:setvbuf('no')

local gameplay = require 'states.gameplay'
local osu = require 'lib.osu'
local util = require 'lib.util'

local state

function love.load()
  if not love.filesystem.isDirectory('maps') then
    love.filesystem.createDirectory('maps')
  end

  local function isOSZ(file)
    return file:match('%.osz$')
  end

  local oszFiles = util.filter(love.filesystem.getDirectoryItems('maps'), isOSZ)
  util.map(oszFiles, osu.extractOSZ)

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
