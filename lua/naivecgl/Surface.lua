local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")

local Surface = {}

---
---@param surface integer
---@param uv Naive.XY_t
---@param n_u_derivs integer
---@param n_v_derivs integer
---@return integer code
---@return Naive.Array.XYZ_t result
function Surface.eval(surface, uv, n_u_derivs, n_v_derivs)
  local n_p = (n_u_derivs + 1) * (n_v_derivs + 1)
  local p = ffi_.F.new("Naive_Vec3d_t[?]", n_p)
  return ffi_.NS.Naive_Surface_eval(surface, ffi_.U.oop.get_data(uv), n_u_derivs, n_v_derivs, p),
      Array.XYZ_t:take(p, n_p)
end

return ffi_.U.oop.make_readonly(Surface)
