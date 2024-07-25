local Ax2_sf_t = require("naivecgl.Ax2_sf_t")
local ffi_ = require("naivecgl.ffi_")

---@class naivecgl.Plane_sf_t
---@field private m_type any
---@field private m_data ffi.cdata*
---@operator call:naivecgl.Plane_sf_t
local Plane_sf_t = ffi_.oop.def_class("Naive_Plane_sf_t", {
  ctor = function(o, basis_set)
    local handle = ffi_.new(o.m_type, {
      basis_set = ffi_.oop.get_data(basis_set)
    })
    return ffi_.oop.take(o, handle)
  end
})

---
---@return naivecgl.Ax2_sf_t
function Plane_sf_t:basis_set()
  return ffi_.oop.get_field(self.m_data, "basis_set", Ax2_sf_t)
end

return Plane_sf_t
