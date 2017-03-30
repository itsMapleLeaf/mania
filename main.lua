local inspect = require('inspect')

io.stdout:setvbuf('no')

local function parseIniContent(content)
  local data = {}
  local currentSection = {}

  for line in content:gmatch('[^\r\n]+') do
    local section = line:match('^%s*%[([^%]]+)%]%s*$')
    if section then
      data[section] = data[section] or {}
      currentSection = data[section]
      goto continue
    end

    local name, value = line:match('^%s*(%a+)%s*:%s*(.*)$')
    if name and value then
      currentSection[name] = value
      goto continue
    end

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
