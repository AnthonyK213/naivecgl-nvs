local ffi_ = require("naivecgl.ffi_")

---@class naivecgl.XY
---@field private m_type any
---@field private m_data ffi.cdata*
---@operator call:naivecgl.XY
local XY = ffi_.oop.def_class("Naive_XY_t", {
  ctor = function(o, x, y)
    local handle = ffi_.new(o.m_type, {
      x = x or 0, y = y or 0
    })
    return ffi_.oop.take(o, handle)
  end
})

---
---@return number
function XY:x()
  return ffi_.oop.get_field(self.m_data, "x")
end

---
---@return number
function XY:y()
  return ffi_.oop.get_field(self.m_data, "y")
end

---
---@param value number
function XY:set_x(value)
  ffi_.oop.set_field(self.m_data, "x", value)
end

---
---@param value number
function XY:set_y(value)
  ffi_.oop.set_field(self.m_data, "y", value)
end

---
---@return number
function XY:magnitude()
  return math.sqrt(self:x() ^ 2 + self:y() ^ 2)
end

return XY
