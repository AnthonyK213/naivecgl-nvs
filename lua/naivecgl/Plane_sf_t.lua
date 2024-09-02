local ffi_ = require("naivecgl.ffi_")

local Ax2_sf_t = require("naivecgl.Ax2_sf_t")

---@class Naive.Plane_sf_t
---@field private m_type any
---@field private m_data any
---@overload fun(basis_set:Naive.Ax2_sf_t):Naive.Plane_sf_t
local Plane_sf_t = ffi_.U.oop.def_class("Naive_Plane_sf_t", {
  ctor = function(o, basis_set)
    local handle = ffi_.F.new(o.m_type, {
      basis_set = ffi_.U.oop.get_data(basis_set)
    })
    return ffi_.U.oop.take(o, handle)
  end
})

---
---@return Naive.Ax2_sf_t
function Plane_sf_t:basis_set()
  return ffi_.U.oop.get_field(self.m_data, "basis_set", Ax2_sf_t)
end

return Plane_sf_t
