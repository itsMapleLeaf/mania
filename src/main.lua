io.stdout:setvbuf('no')

-- local gameplay = require 'states.gameplay'
local osu = require 'lib.osu'
local fsutil = require 'lib.fsutil'
local gamestate = require 'lib.hump.gamestate'
local mapselect = require 'states.mapselect'

function love.load()
  if not love.filesystem.isDirectory('maps') then
    love.filesystem.createDirectory('maps')
  end

  for _, file in ipairs(love.filesystem.getDirectoryItems('maps')) do
    local path = 'maps/' .. file
    if love.filesystem.isFile(path) and fsutil.getExtension(path) == 'osz' then
      print('Extracting ' .. file)
      osu.extractOSZ(path)
    end
  end

  gamestate.registerEvents()
  gamestate.switch(mapselect)
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
