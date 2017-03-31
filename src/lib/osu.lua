local util = require 'lib.util'
local fsutil = require 'lib.fsutil'

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

local function parseNote(line, columns)
  local chunks = util.split(line, ',')
  local x, _, time, objectType = unpack(chunks)
  local column = math.floor(x / (512 / columns))
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
  local content = assert(love.filesystem.read(mapfile))
  local mapData = parseMapFile(content)
  local columns = tonumber(mapData.Difficulty.CircleSize)

  local notes = {}
  for _, hitObjectData in ipairs(mapData.HitObjects) do
    table.insert(notes, parseNote(hitObjectData, columns))
  end

  return {
    title = mapData.Metadata.Title,
    artist = mapData.Metadata.Artist,
    difficulty = mapData.Metadata.Version,
    creator = mapData.Metadata.Creator,
    notes = notes,
    columns = columns,
  }
end

local function extractOSZ(osz)
  if love.filesystem.mount(osz, 'temp') then
    local outputPath = osz:sub(1, -5)
    love.filesystem.createDirectory(outputPath)

    for _, file in ipairs(love.filesystem.getDirectoryItems('temp')) do
      local content = love.filesystem.read('temp/' .. file)
      love.filesystem.write(outputPath .. '/' .. file, content)
    end

    love.filesystem.unmount(osz)
    love.filesystem.remove(osz)
  end
end

local function loadMaps()
  local maps = {}
  for _, file in ipairs(love.filesystem.getDirectoryItems('maps')) do
    local path = 'maps/' .. file
    if love.filesystem.isDirectory(path) then
      for _, mapFile in ipairs(love.filesystem.getDirectoryItems(path)) do
        local mapFilePath = path .. '/' .. mapFile
        if love.filesystem.isFile(mapFilePath)
        and fsutil.getExtension(mapFile) == 'osu' then
          table.insert(maps, mapFilePath)
        end
      end
    end
  end
  return maps
end

return {
  extractOSZ = extractOSZ,
  loadMapFile = loadMapFile,
  loadMaps = loadMaps,
}
