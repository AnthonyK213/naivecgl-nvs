local ArrayXYZ = require("naivecgl.ArrayXYZ")
local XYZ_t = require("naivecgl.XYZ_t")
local ffi_ = require("naivecgl.ffi_")

local Curve = {}

---
---@param curve integer
---@return integer code
---@return number t0
---@return number t1
function Curve.ask_bound(curve)
  local aBound = ffi_.F.new("Naive_Interval_t", { 0, 0 })
  return ffi_.NS.Naive_Curve_ask_bound(curve, aBound), aBound.t0, aBound.t1
end

---
---@param curve integer
---@param t number
---@param n_deriv integer
---@return integer code
---@return naivecgl.ArrayXYZ result
function Curve.eval(curve, t, n_deriv)
  local n_p = n_deriv + 1
  local p = ffi_.F.new("Naive_Vec3d_t[?]", n_p)
  return ffi_.NS.Naive_Curve_eval(curve, t, n_deriv, p), ArrayXYZ:take(p, n_p)
end

---
---@param curve integer
---@param t number
---@return integer code
---@return Naive.XYZ_t curvature
function Curve.eval_curvature(curve, t)
  local curvature = ffi_.F.new("Naive_Vec3d_t", { 0, 0, 0 })
  return ffi_.NS.Naive_Curve_eval_curvature(curve, t, curvature), ffi_.U.oop.take(XYZ_t, curvature)
end

return Curve
