local ffi_ = require("naivecgl.ffi_")
local ffi_util = require("ffi_util")

---@class naivecgl.Ax2_sf_t
---@field private m_type any
---@field private m_data ffi.cdata*
---@operator call:naivecgl.Ax2_sf_t
local Ax2_sf_t = {}

---@private
Ax2_sf_t.__index = Ax2_sf_t
Ax2_sf_t.m_type = "Naive_Ax2_sf_t"

---
---@param location naivecgl.XYZ
---@param axis naivecgl.XYZ
---@param ref_direction naivecgl.XYZ
function Ax2_sf_t:new(location, axis, ref_direction)
  local handle = ffi_.new(self.m_type, {
    location = location:data(),
    axis = axis:data(),
    ref_direction = ref_direction:data(),
  })
  return self:take(handle)
end

ffi_util.util.def_ctor(Ax2_sf_t)

---
---@param handle ffi.cdata*
---@return naivecgl.Ax2_sf_t
function Ax2_sf_t:take(handle)
  return ffi_util.util.take(self, handle)
end

return Ax2_sf_t
