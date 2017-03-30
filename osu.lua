local util = require 'util'

local function parseMapFile(content)
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

local function parseNote(line)
  local chunks = util.split(line, ',')
  local x, _, time, objectType = unpack(chunks)
  local column = math.floor(x / 128)
  local length = 0

  if objectType == '128' then
    local holdEnd = chunks[6]:match('%d+')
    length = tonumber(holdEnd) - time
  end

  return {
    time = tonumber(time) / 1000,
    column = column,
    length = length / 1000,
  }
end

local function loadMapFile(mapfile)
  local content = assert(love.filesystem.read('map/' .. mapfile))
  local mapData = parseMapFile(content)

  local notes = {}
  for _, hitObjectData in ipairs(mapData.HitObjects) do
    table.insert(notes, parseNote(hitObjectData))
  end

  return {
    notes = notes,
    columns = tonumber(mapData.Difficulty.CircleSize),
  }
end

return {
  loadMapFile = loadMapFile
}
