local ffi_ = require("naivecgl.ffi_")

---@class Naive.Interval_t
---@field private m_type any
---@field private m_data any
---@overload fun(t0?:number,t1?:number):Naive.Interval_t
local Interval_t = ffi_.U.oop.def_class("Naive_Interval_t", {
  ctor = function(o, t0, t1)
    local t = {}
    t.t0 = t0 or 0
    t.t1 = t1 or t.t0
    local handle = ffi_.F.new(o.m_type, t)
    return ffi_.U.oop.take(o, handle)
  end
})

---
---@return number
function Interval_t:t0()
  return self.m_data.t0
end

---
---@return number
function Interval_t:t1()
  return self.m_data.t1
end

---
---@param value number
function Interval_t:set_t0(value)
  self.m_data.t0 = value
end

---
---@param value number
function Interval_t:set_t1(value)
  self.m_data.t1 = value
end

return Interval_t
