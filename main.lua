local inspect = require('inspect')

io.stdout:setvbuf('no')

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

function love.load()
  love.filesystem.createDirectory('maps')

  for _, mapfolder in ipairs(love.filesystem.getDirectoryItems('maps')) do
    assert(love.filesystem.mount('maps/' .. mapfolder, 'map'))
    for _, mapfile in ipairs(love.filesystem.getDirectoryItems('map')) do
      if mapfile:match('%.osu$') then
        local content = assert(love.filesystem.read('map/' .. mapfile))
        print(inspect(parseIniContent(content)))
        break
      end
    end
  end

  love.event.quit()
end
