local XYZ = require("naivecgl.XYZ")
local ffi_ = require("naivecgl.ffi_")

---@class naivecgl.Ax2_sf_t
---@field private m_type any
---@field private m_data ffi.cdata*
---@operator call:naivecgl.Ax2_sf_t
local Ax2_sf_t = ffi_.oop.def_class("Naive_Ax2_sf_t", function(o, location, axis, ref_direction)
  local handle = ffi_.new(o.m_type, {
    location = ffi_.oop.get_data(location),
    axis = ffi_.oop.get_data(axis),
    ref_direction = ffi_.oop.get_data(ref_direction),
  })
  return ffi_.oop.take(o, handle)
end)

---
---@return naivecgl.XYZ
function Ax2_sf_t:location()
  return ffi_.oop.get_field(self.m_data, "location", XYZ)
end

---
---@return naivecgl.XYZ
function Ax2_sf_t:axis()
  return ffi_.oop.get_field(self.m_data, "axis", XYZ)
end

---
---@return naivecgl.XYZ
function Ax2_sf_t:ref_direction()
  return ffi_.oop.get_field(self.m_data, "ref_direction", XYZ)
end

return Ax2_sf_t
