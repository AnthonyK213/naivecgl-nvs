local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local Interval_t = require("naivecgl.Interval_t")
local XYZ_t = require("naivecgl.XYZ_t")

local Curve = {}

---
---@param curve integer
---@return integer code
---@return Naive.Interval_t interval
function Curve.ask_interval(curve)
  local interval = Interval_t()
  return ffi_.NS.Naive_Curve_ask_interval(curve, ffi_.U.oop.get_data(interval)), interval
end

---
---@param curve integer
---@param t number
---@param n_derivs integer
---@return integer code
---@return Naive.Array.XYZ_t result
function Curve.eval(curve, t, n_derivs)
  local n_p = n_derivs + 1
  local p = ffi_.F.new("Naive_Vec3d_t[?]", n_p)
  return ffi_.NS.Naive_Curve_eval(curve, t, n_derivs, p), Array.XYZ_t:take(p, n_p)
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

return ffi_.U.oop.make_readonly(Curve)
