local ArrayXYZ = require("naivecgl_ArrayXYZ")
local XYZ = require("naivecgl_XYZ")
local ffi = require("ffi")
local naivecgl_ffi = require("naivecgl_ffi")

local Curve = {}

---
---@param curve integer
---@return integer code
---@return number t0
---@return number t1
function Curve.ask_bound(curve)
  local aBound = ffi.new("Naive_Interval_t", { 0, 0 })
  return naivecgl_ffi.NS.Naive_Curve_ask_bound(curve, aBound), aBound.t0, aBound.t1
end

---
---@param curve integer
---@param t number
---@param n_deriv integer
---@return integer code
---@return naivecgl.ArrayXYZ result
function Curve.eval(curve, t, n_deriv)
  local n_p = n_deriv + 1
  local p = ffi.new("Naive_Vector3d_t[?]", n_p)
  return naivecgl_ffi.NS.Naive_Curve_eval(curve, t, n_deriv, p), ArrayXYZ:take(p, n_p)
end

---
---@param curve integer
---@param t number
---@return integer code
---@return naivecgl.XYZ curvature
function Curve.eval_curvature(curve, t)
  local curvature = ffi.new("Naive_Vector3d_t", { 0, 0, 0 })
  return naivecgl_ffi.NS.Naive_Curve_eval_curvature(curve, t, curvature), XYZ.take(curvature)
end

return Curve
