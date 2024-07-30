local ArrayDouble = require("ffi_util").array.ArrayDouble
local ArrayInt32 = require("ffi_util").array.ArrayInt32
local ArrayXYZ = require("naivecgl.ArrayXYZ")
local ffi_ = require("naivecgl.ffi_")

local NurbsSurface = {}

---
---@param poles naivecgl.XYZ[][]
---@param weights number[][]
---@param knots_u number[]
---@param knots_v number[]
---@param mults_u integer[]
---@param mults_v integer[]
---@param degree_u integer
---@param degree_v integer
---@return integer code
---@return integer nurbs_surface
function NurbsSurface.create(poles, weights, knots_u, knots_v, mults_u, mults_v, degree_u, degree_v)
  local nbUP, nbVP, aFlatPoles = ffi_.util.flatten_array2(poles)
  local aPoles = ArrayXYZ:new(aFlatPoles)
  local nbUW, nbVW, aFlatWeights = ffi_.util.flatten_array2(weights)
  local aWeights = ArrayDouble:new(aFlatWeights)
  local aUKnots = ArrayDouble:new(knots_u)
  local aVKnots = ArrayDouble:new(knots_v)
  local aUMults = ArrayInt32:new(mults_u)
  local aVMults = ArrayInt32:new(mults_v)
  local nurbs_surface = ffi_.new("Naive_NurbsSurface_t[1]", 0)
  return ffi_.NS.Naive_NurbsSurface_create(
    nbUP, nbVP, aPoles:data(),
    nbUW, nbVW, aWeights:data(),
    aUKnots:size(), aUKnots:data(), aVKnots:size(), aVKnots:data(),
    aUMults:size(), aUMults:data(), aVMults:size(), aVMults:data(),
    degree_u, degree_v, nurbs_surface), nurbs_surface[0]
end

return NurbsSurface
