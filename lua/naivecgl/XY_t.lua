local ffi_ = require("naivecgl.ffi_")

---@class Naive.XY_t
---@field private m_type any
---@field private m_data any
---@overload fun(x?:number,y?:number):Naive.XY_t
local XY_t = ffi_.U.oop.def_class("Naive_XY_t", {
  ctor = function(o, x, y)
    local handle = ffi_.F.new(o.m_type, {
      x = x or 0, y = y or 0
    })
    return ffi_.U.oop.take(o, handle)
  end
})

---
---@return number
function XY_t:x()
  return self.m_data.x
end

---
---@return number
function XY_t:y()
  return self.m_data.y
end

---
---@param value number
function XY_t:set_x(value)
  self.m_data.x = value
end

---
---@param value number
function XY_t:set_y(value)
  self.m_data.y = value
end

---
---@return number
function XY_t:magnitude()
  return math.sqrt(self:x() ^ 2 + self:y() ^ 2)
end

return XY_t
