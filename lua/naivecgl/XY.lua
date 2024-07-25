local ffi = require("ffi")
local ffi_util = require("ffi_util")

---@class naivecgl.XY
---@field private m_type any
---@field private m_data ffi.cdata*
---@operator call:naivecgl.XY
local XY = {}

---@private
XY.__index = XY
XY.m_type = "Naive_XY_t"

---Constructor.
---@param coord_x? number
---@param coord_y? number
---@return naivecgl.XY
function XY:new(coord_x, coord_y)
  local handle = ffi.new(self.m_type, {
    x = coord_x or 0, y = coord_y or 0
  })
  return self:take(handle)
end

ffi_util.util.def_ctor(XY)

---
---@param handle ffi.cdata*
---@return naivecgl.XY
function XY:take(handle)
  return ffi_util.util.take(self, handle)
end

---
---@return number
function XY:x()
  return ffi_util.util.get_field(self.m_data, "x")
end

---
---@return number
function XY:y()
  return ffi_util.util.get_field(self.m_data, "y")
end

---
---@param value number
function XY:set_x(value)
  ffi_util.util.set_field(self.m_data, "x", value)
end

---
---@param value number
function XY:set_y(value)
  ffi_util.util.set_field(self.m_data, "y", value)
end

---
---@return ffi.cdata*
function XY:data()
  return self.m_data
end

---
---@return number
function XY:magnitude()
  return math.sqrt(self:x() ^ 2 + self:y() ^ 2)
end

return XY
