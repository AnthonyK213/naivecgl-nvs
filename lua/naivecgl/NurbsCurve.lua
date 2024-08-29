local common_ = require("naivecgl.common_")
local ffi_ = require("naivecgl.ffi_")

local ArrayDouble = ffi_.U.array.ArrayDouble
local ArrayInt32 = ffi_.U.array.ArrayInt32
local ArrayXYZ = require("naivecgl.ArrayXYZ")
local NurbsCurve_sf_t = require("naivecgl.NurbsCurve_sf_t")
local Object = require("naivecgl.Object")

local NurbsCurve = {}

---
---@param nurbs_curve integer
---@param t number
---@param mult integer
---@return integer code
function NurbsCurve.add_knot(nurbs_curve, t, mult)
  return ffi_.NS.Naive_NurbsCurve_add_knot(nurbs_curve, t, mult)
end

---
---@param nurbs_curve integer
---@return integer code
---@return Naive.NurbsCurve_sf_t nurbs_curve_sf
function NurbsCurve.ask(nurbs_curve)
  local nurbs_curve_sf = NurbsCurve_sf_t()
  return ffi_.NS.Naive_NurbsCurve_ask(nurbs_curve, ffi_.U.oop.get_data(nurbs_curve_sf)), nurbs_curve_sf:update_cache()
end

---
---@param nurbs_curve integer
---@return integer code
---@return ffi_util.array.ArrayDouble knots
---@return ffi_util.array.ArrayInt32 multiplicities
function NurbsCurve.ask_knots(nurbs_curve)
  local n_knots = ffi_.F.new("int[1]", 0)
  local knots = ffi_.F.new("double*[1]")
  local multiplicities = ffi_.F.new("int*[1]")
  local options = { free = ffi_.NS.Naive_Memory_free }
  return ffi_.NS.Naive_NurbsCurve_ask_knots(nurbs_curve, n_knots, knots, multiplicities),
      ArrayDouble:take(knots[0], n_knots[0], options),
      ArrayInt32:take(multiplicities[0], n_knots[0], options)
end

---
---@param nurbs_curve_sf Naive.NurbsCurve_sf_t
---@return integer code
---@return integer nurbs_curve
function NurbsCurve.create(nurbs_curve_sf)
  local nurbs_curve = ffi_.F.new("Naive_NurbsCurve_t[1]", Object.null)
  return ffi_.NS.Naive_NurbsCurve_create(ffi_.U.oop.get_data(nurbs_curve_sf), nurbs_curve), nurbs_curve[0]
end

return ffi_.U.oop.make_readonly(NurbsCurve)
