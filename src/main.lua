io.stdout:setvbuf('no')

-- local gameplay = require 'states.gameplay'
local osu = require 'lib.osu'
local fsutil = require 'lib.fsutil'
local mapselect = require 'states.mapselect'

local state

function love.load()
  if not love.filesystem.isDirectory('maps') then
    love.filesystem.createDirectory('maps')
  end

  for _, file in ipairs(love.filesystem.getDirectoryItems('maps')) do
    if fsutil.getExtension(file) == 'osz' then
      osu.extractOSZ(file)
    end
  end

  state = mapselect()
end

function love.update(dt)
  if state.update then state.update(dt) end
end

function love.draw()
  if state.draw then state.draw() end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
