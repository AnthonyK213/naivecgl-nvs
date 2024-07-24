local ffi = require("ffi")

---@class naivecgl.XYZ
---@field private m_type any
---@field private m_h ffi.cdata*
---@operator call:naivecgl.XYZ
local XYZ = {}

---@private
XYZ.__index = XYZ
XYZ.m_type = "Naive_XYZ_t"

---Constructor.
---@param coord_x? number
---@param coord_y? number
---@param coord_z? number
---@return naivecgl.XYZ
function XYZ.new(coord_x, coord_y, coord_z)
  local handle = ffi.new(XYZ.m_type, {
    x = coord_x or 0, y = coord_y or 0, z = coord_z or 0
  })
  return XYZ.take(handle)
end

setmetatable(XYZ, {
  __call = function(o, ...)
    return o.new(...)
  end
})

---
---@param handle ffi.cdata*
---@return naivecgl.XYZ
function XYZ.take(handle)
  local xyz = { m_h = handle }
  setmetatable(xyz, XYZ)
  return xyz
end

---
---@return number
function XYZ:x()
  return self.m_h.x
end

---
---@return number
function XYZ:y()
  return self.m_h.y
end

---
---@return number
function XYZ:z()
  return self.m_h.z
end

---
---@return ffi.cdata*
function XYZ:data()
  return self.m_h
end

function XYZ:magnitude()
  return math.sqrt(self:x() ^ 2 + self:y() ^ 2 + self:z() ^ 2)
end

return XYZ
