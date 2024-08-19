local ffi_ = require("naivecgl.ffi_")

local ArrayXYZ = require("naivecgl.ArrayXYZ")

local Surface = {}

---
---@param surface integer
---@param u number
---@param v number
---@param n_u_deriv integer
---@param n_v_deriv integer
---@return integer code
---@return naivecgl.ArrayXYZ result
function Surface.eval(surface, u, v, n_u_deriv, n_v_deriv)
  local n_p = (n_u_deriv + 1) * (n_v_deriv + 1)
  local p = ffi_.F.new("Naive_Vec3d_t[?]", n_p)
  return ffi_.NS.Naive_Surface_eval(surface, u, v, n_u_deriv, n_v_deriv, p), ArrayXYZ:take(p, n_p)
end

return ffi_.U.oop.make_readonly(Surface)
