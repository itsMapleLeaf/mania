local function getExtension(file)
  return file:match('[^%.]+$')
end

return {
  getExtension = getExtension
}
