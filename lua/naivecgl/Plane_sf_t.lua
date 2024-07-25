local Ax2_sf_t = require("naivecgl.Ax2_sf_t")
local ffi_ = require("naivecgl.ffi_")
local ffi_util = require("ffi_util")

---@class naivecgl.Plane_sf_t
---@field private m_type any
---@field private m_data ffi.cdata*
---@operator call:naivecgl.Plane_sf_t
local Plane_sf_t = {}

---@private
Plane_sf_t.__index = Plane_sf_t
Plane_sf_t.m_type = "Naive_Plane_sf_t"

---
---@param basis_set naivecgl.Ax2_sf_t
function Plane_sf_t:new(basis_set)
  local handle = ffi_.new(self.m_type, {
    basis_set = ffi_util.util.get_ffi_data(basis_set)
  })
  return self:take(handle)
end

ffi_util.util.def_ctor(Plane_sf_t)

---
---@param handle ffi.cdata*
---@return naivecgl.Plane_sf_t
function Plane_sf_t:take(handle)
  return ffi_util.util.take(self, handle)
end

---
---@return naivecgl.Ax2_sf_t
function Plane_sf_t:basis_set()
  return ffi_util.util.get_field(self.m_data, "basis_set", Ax2_sf_t)
end

return Plane_sf_t
