local ffi = require("ffi")
local ffi_util = require("ffi_util")

---@class naivecgl.XYZ
---@field private m_type any
---@field private m_data ffi.cdata*
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
function XYZ:new(coord_x, coord_y, coord_z)
  local handle = ffi.new(self.m_type, {
    x = coord_x or 0, y = coord_y or 0, z = coord_z or 0
  })
  return self:take(handle)
end

ffi_util.util.def_ctor(XYZ)

---
---@param handle ffi.cdata*
---@return naivecgl.XYZ
function XYZ:take(handle)
  return ffi_util.util.take(XYZ, handle)
end

---
---@return number
function XYZ:x()
  return self.m_data.x
end

---
---@return number
function XYZ:y()
  return self.m_data.y
end

---
---@return number
function XYZ:z()
  return self.m_data.z
end

---
---@return ffi.cdata*
function XYZ:data()
  return self.m_data
end

function XYZ:magnitude()
  return math.sqrt(self:x() ^ 2 + self:y() ^ 2 + self:z() ^ 2)
end

return XYZ
