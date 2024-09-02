local XYZ_t = require("naivecgl.XYZ_t")
local ffi_ = require("naivecgl.ffi_")

---@class Naive.Ax2_sf_t
---@field private m_type any
---@field private m_data any
---@overload fun(location:Naive.XYZ_t,axis:Naive.XYZ_t,ref_direction:Naive.XYZ_t):Naive.Ax2_sf_t
local Ax2_sf_t = ffi_.U.oop.def_class("Naive_Ax2_sf_t", {
  ctor = function(o, location, axis, ref_direction)
    local handle = ffi_.F.new(o.m_type, {
      location = ffi_.U.oop.get_data(location),
      axis = ffi_.U.oop.get_data(axis),
      ref_direction = ffi_.U.oop.get_data(ref_direction),
    })
    return ffi_.U.oop.take(o, handle)
  end
})

---
---@return Naive.XYZ_t
function Ax2_sf_t:location()
  return ffi_.U.oop.get_field(self.m_data, "location", XYZ_t)
end

---
---@return Naive.XYZ_t
function Ax2_sf_t:axis()
  return ffi_.U.oop.get_field(self.m_data, "axis", XYZ_t)
end

---
---@return Naive.XYZ_t
function Ax2_sf_t:ref_direction()
  return ffi_.U.oop.get_field(self.m_data, "ref_direction", XYZ_t)
end

return Ax2_sf_t
