local util = {}

function util.split(str, delimiter)
  local result = {}
  for chunk in str:gmatch('[^' .. delimiter .. ']+') do
    table.insert(result, chunk)
  end
  return result
end

return util
