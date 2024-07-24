local ffi = require("ffi")

---@class naivecgl.XY
---@field private m_type any
---@field private m_h ffi.cdata*
---@operator call:naivecgl.XY
local XY = {}

---@private
XY.__index = XY
XY.m_type = "Naive_XY_t"

---Constructor.
---@param coord_x? number
---@param coord_y? number
---@return naivecgl.XY
function XY.new(coord_x, coord_y)
  local handle = ffi.new(XY.m_type, {
    x = coord_x or 0, y = coord_y or 0
  })
  return XY.take(handle)
end

setmetatable(XY, {
  __call = function(o, ...)
    return o.new(...)
  end
})

---
---@param handle ffi.cdata*
---@return naivecgl.XY
function XY.take(handle)
  local vec = { m_h = handle }
  setmetatable(vec, XY)
  return vec
end

---
---@return number
function XY:x()
  return self.m_h.x
end

---
---@return number
function XY:y()
  return self.m_h.y
end

---
---@return ffi.cdata*
function XY:data()
  return self.m_h
end

return XY
