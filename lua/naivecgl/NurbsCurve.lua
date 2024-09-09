local common_ = require("naivecgl.common_")
local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local NurbsCurve_sf_t = require("naivecgl.NurbsCurve_sf_t")
local Object = require("naivecgl.Object")

local NurbsCurve = {}

---This function modifies the given 'nurbs_curve' by inserting knots with the quantity of 'mult' at the given split parameter.
---@param nurbs_curve integer NURBS curve.
---@param t number Split parameter.
---@param mult integer Multiplicity.
---@return integer code Code.
function NurbsCurve.add_knot(nurbs_curve, t, mult)
  return ffi_.NS.Naive_NurbsCurve_add_knot(nurbs_curve, t, mult)
end

---This function returns the standard form for a NURBS curve.
---@param nurbs_curve integer NURBS curve.
---@return integer code Code.
---@return Naive.NurbsCurve_sf_t nurbs_curve_sf NURBS curve standard form.
function NurbsCurve.ask(nurbs_curve)
  local nurbs_curve_sf = NurbsCurve_sf_t()
  return ffi_.NS.Naive_NurbsCurve_ask(nurbs_curve, ffi_.U.oop.get_data(nurbs_curve_sf)), nurbs_curve_sf:update_cache()
end

---This function returns the uniques knots and the multiplicities of a given NURBS curve.
---@param nurbs_curve integer NURBS curve to query.
---@return integer code Code.
---@return Naive.Array.Double knots Knot values.
---@return Naive.Array.Int32 multiplicities Corresponding multiplicities.
function NurbsCurve.ask_knots(nurbs_curve)
  local n_knots = ffi_.F.new("int[1]", 0)
  local knots = ffi_.F.new("double*[1]")
  local multiplicities = ffi_.F.new("int*[1]")
  local options = { free = ffi_.NS.Naive_Memory_free }
  return ffi_.NS.Naive_NurbsCurve_ask_knots(nurbs_curve, n_knots, knots, multiplicities),
      Array.Double:take(knots[0], n_knots[0], options),
      Array.Int32:take(multiplicities[0], n_knots[0], options)
end

---This function creates a NURBS curve from the standard form.
---@param nurbs_curve_sf Naive.NurbsCurve_sf_t NURBS curve standard form.
---@return integer code Code.
---@return integer nurbs_curve NURBS curve.
function NurbsCurve.create(nurbs_curve_sf)
  local nurbs_curve = ffi_.F.new("Naive_NurbsCurve_t[1]", Object.null)
  return ffi_.NS.Naive_NurbsCurve_create(ffi_.U.oop.get_data(nurbs_curve_sf), nurbs_curve), nurbs_curve[0]
end

return ffi_.U.oop.make_readonly(NurbsCurve)
