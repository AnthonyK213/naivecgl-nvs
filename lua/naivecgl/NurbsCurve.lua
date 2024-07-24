local ArrayDouble = require("naivecgl.ArrayDouble")
local ArrayInt32 = require("naivecgl.ArrayInt32")
local ArrayXYZ = require("naivecgl.ArrayXYZ")
local common_ = require("naivecgl.common_")
local ffi_ = require("naivecgl.ffi_")

local NurbsCurve = {}

---
---@param nurbs_curve integer
---@return integer code
---@return integer degree
function NurbsCurve.ask_degree(nurbs_curve)
  local degree = ffi_.new("int[1]", 0)
  return ffi_.NS.Naive_NurbsCurve_ask_degree(nurbs_curve, degree), degree[0]
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.ArrayDouble
function NurbsCurve.ask_knots(nurbs_curve)
  return common_.ask_array(nurbs_curve, "Naive_NurbsCurve_ask_knots", ArrayDouble)
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.ArrayInt32 mults
function NurbsCurve.ask_mults(nurbs_curve)
  return common_.ask_array(nurbs_curve, "Naive_NurbsCurve_ask_mults", ArrayInt32)
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.ArrayXYZ poles
function NurbsCurve.ask_poles(nurbs_curve)
  return common_.ask_array(nurbs_curve, "Naive_NurbsCurve_ask_poles", ArrayXYZ)
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.ArrayDouble weights
function NurbsCurve.ask_weights(nurbs_curve)
  return common_.ask_array(nurbs_curve, "Naive_NurbsCurve_ask_weights", ArrayDouble)
end

---
---@param poles naivecgl.XYZ[]
---@param weights number[]
---@param knots number[]
---@param mults integer[]
---@param degree integer
---@return integer code
---@return integer nurbs_curve
function NurbsCurve.create(poles, weights, knots, mults, degree)
  local aPoles = ArrayXYZ:new(poles)
  local aWeights = ArrayDouble:new(weights)
  local aKnots = ArrayDouble:new(knots)
  local aMults = ArrayInt32:new(mults)
  local nurbs_curve = ffi_.new("Naive_NurbsCurve_t[1]", 0)
  return ffi_.NS.Naive_NurbsCurve_create(
    aPoles:size(), aPoles:data(), aWeights:size(), aWeights:data(),
    aKnots:size(), aKnots:data(), aMults:size(), aMults:data(),
    degree, nurbs_curve), nurbs_curve[0]
end

---
---@param nurbs_curve integer
---@param index integer
---@param mult integer
---@return integer code
function NurbsCurve.increase_multiplicity(nurbs_curve, index, mult)
  return ffi_.NS.Naive_NurbsCurve_increase_multiplicity(nurbs_curve, index, mult)
end

---
---@param nurbs_curve integer
---@param t number
---@param mult integer
---@return integer code
function NurbsCurve.insert_knot(nurbs_curve, t, mult)
  return ffi_.NS.Naive_NurbsCurve_insert_knot(nurbs_curve, t, mult)
end

return NurbsCurve
