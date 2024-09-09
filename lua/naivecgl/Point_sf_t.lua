local ffi_ = require("naivecgl.ffi_")

local XYZ_t = require("naivecgl.XYZ_t")

---@class Naive.Point_sf_t
---@field private m_type any
---@field private m_data any
---@overload fun(position:Naive.XYZ_t):Naive.Point_sf_t
local Point_sf_t = ffi_.U.oop.def_class("Naive_Point_sf_t", {
  ctor = function(o, position)
    local handle = ffi_.F.new(o.m_type, {
      position = ffi_.U.oop.get_data(position)
    })
    return ffi_.U.oop.take(o, handle)
  end
})

---
---@return Naive.XYZ_t
function Point_sf_t:position()
  return ffi_.U.oop.get_field(self.m_data, "position", XYZ_t)
end

return Point_sf_t
