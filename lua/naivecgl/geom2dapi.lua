local ArrayXY = require("naivecgl.ArrayXY")
local XY = require("naivecgl.XY")
local ffi_ = require("naivecgl.ffi_")

local geom2dapi = {}

---
---@param points naivecgl.XY[]
---@param algo? any
---@return integer code
---@return integer[] convex_indices
function geom2dapi.convex_hull(points, algo)
  local point_array = ArrayXY:new(points)
  local n_convex_points = ffi_.new("int[1]", 0)
  local convex_indices = ffi_.new("int*[1]")
  local code = ffi_.NS.Naive_Geom2dAPI_convex_hull(point_array:size(), point_array:data(),
    algo or ffi_.NS.Naive_Algorithm_quick_hull_c, n_convex_points, convex_indices, nil)

  local result = {}
  if code == ffi_.NS.Naive_Code_ok then
    for i = 1, n_convex_points[0] do
      result[i] = convex_indices[0][i - 1] + 1
    end
  end

  ffi_.NS.Naive_Memory_free(convex_indices[0])
  return code, result
end

---
---@param points naivecgl.XY[]
---@return integer code
---@return naivecgl.XY origin
---@return number radius
function geom2dapi.enclosing_disc(points)
  local aPoints = ArrayXY:new(points)
  local o = ffi_.new("Naive_Point2d_t")
  local r = ffi_.new("double[1]", 0)
  return ffi_.NS.Naive_Geom2dAPI_enclosing_disc(aPoints:size(), aPoints:data(), o, r),
      XY.take(o), r[0]
end

return geom2dapi
