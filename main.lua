io.stdout:setvbuf('no')

local inspect = require('inspect')

local function split(str, delimiter)
  local result = {}
  for chunk in str:gmatch('[^' .. delimiter .. ']+') do
    table.insert(result, chunk)
  end
  return result
end

local function parseIniContent(content)
  local data = {}
  local currentSection = {}

  for line in content:gmatch('[^\r\n]+') do
    -- capture a header
    -- if one is found, set it as our current section to add onto
    local section = line:match('^%s*%[([^%]]+)%]%s*$')
    if section then
      data[section] = data[section] or {}
      currentSection = data[section]
      goto continue
    end

    -- capture a key/value pair
    -- if one is found, assign it to the current section
    local name, value = line:match('^%s*(%a+)%s*:%s*(.*)$')
    if name and value then
      currentSection[name] = value
      goto continue
    end

    -- if it's not a valid header or key/value pair, just add the line into
    -- the section table
    table.insert(currentSection, line)

    ::continue::
  end

  return data
end

local function parseHitObject(line)
  local chunks = split(line, ',')
  local x, y, time, objectType = unpack(chunks)
  return {
    x = tonumber(x),
    y = tonumber(y),
    time = tonumber(time) / 1000,
    type = objectType,
  }
end

local function toManiaNote(hitObject)
  local column = math.floor(hitObject.x / 128)
  return {
    time = hitObject.time,
    column = column,
  }
end

local function loadMapFile(mapfile)
  local content = assert(love.filesystem.read('map/' .. mapfile))
  local mapData = parseIniContent(content)

  local notes = {}
  for _, hitObjectData in ipairs(mapData.HitObjects) do
    local hitObject = parseHitObject(hitObjectData)
    local note = toManiaNote(hitObject)
    table.insert(notes, note)
  end

  print(inspect(mapData))

  return {
    notes = notes,
    columns = tonumber(mapData.Difficulty.CircleSize),
  }
end

local map
local songTime = 0
local receptorPosition = 550

function love.load()
  love.filesystem.createDirectory('maps')

  for _, mapfolder in ipairs(love.filesystem.getDirectoryItems('maps')) do
    if love.filesystem.mount('maps/' .. mapfolder, 'map') then
      for _, mapfile in ipairs(love.filesystem.getDirectoryItems('map')) do
        if mapfile:match('%.osu$') then
          map = loadMapFile(mapfile)
          break
        end
      end
      love.filesystem.unmount('maps/' .. mapfolder)
    end
  end
end

function love.update(dt)
  songTime = songTime + dt
end

function love.draw()
  if map then
    love.graphics.setColor(255, 255, 255)
    for _, note in ipairs(map.notes) do
      local x = note.column * 64
      local y = receptorPosition - (note.time - songTime) * 100 * 20
      if y > -32 and y < 800 then
        love.graphics.rectangle('fill', x, y, 64, 32)
      end
    end

    love.graphics.setColor(255, 255, 255, 120)
    love.graphics.rectangle('fill', 0, receptorPosition, 64 * map.columns, 32)
  end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
end
