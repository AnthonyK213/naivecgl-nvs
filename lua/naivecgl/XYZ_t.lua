local ffi_ = require("naivecgl.ffi_")

---@class Naive.XYZ_t
---@field private m_type any
---@field private m_data any
---@overload fun(x?:number,y?:number,z?:number):Naive.XYZ_t
local XYZ_t = ffi_.U.oop.def_class("Naive_XYZ_t", {
  ctor = function(o, x, y, z)
    local handle = ffi_.F.new(o.m_type, {
      x = x or 0, y = y or 0, z = z or 0
    })
    return ffi_.U.oop.take(o, handle)
  end
})

---
---@return number
function XYZ_t:x()
  return self.m_data.x
end

---
---@return number
function XYZ_t:y()
  return self.m_data.y
end

---
---@return number
function XYZ_t:z()
  return self.m_data.z
end

---
---@param value number
function XYZ_t:set_x(value)
  self.m_data.x = value
end

---
---@param value number
function XYZ_t:set_y(value)
  self.m_data.y = value
end

---
---@param value number
function XYZ_t:set_z(value)
  self.m_data.z = value
end

---
---@return number
function XYZ_t:magnitude()
  return math.sqrt(self:x() ^ 2 + self:y() ^ 2 + self:z() ^ 2)
end

return XYZ_t
