local util = {}

function util.split(str, delimiter)
  local result = {}
  for chunk in str:gmatch('[^' .. delimiter .. ']+') do
    table.insert(result, chunk)
  end
  return result
end

function util.map(items, mapper)
  local result = {}
  for i = 1, #items do
    result[i] = mapper(items[i], i)
  end
  return result
end

function util.filter(items, predicate)
  local result = {}
  for i, item in ipairs(items) do
    if predicate(item, i) then
      table.insert(result, item)
    end
  end
  return result
end

return util
