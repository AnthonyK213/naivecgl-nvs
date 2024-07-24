local ArrayXY = require("naivecgl_ArrayXY")
local XY = require("naivecgl_XY")
local ffi = require("ffi")
local naivecgl_ffi = require("naivecgl_ffi")

local geom2dapi = {}

---
---@param points naivecgl.XY[]
---@param algo? any
---@return integer code
---@return integer[] convex_indices
function geom2dapi.convex_hull(points, algo)
  local point_array = ArrayXY:new(points)
  local n_convex_points = ffi.new("int[1]", 0)
  local convex_indices = ffi.new("int*[1]")
  local code = naivecgl_ffi.NS.Naive_Geom2dAPI_convex_hull(point_array:size(), point_array:data(),
    algo or naivecgl_ffi.NS.Naive_Algorithm_quick_hull_c, n_convex_points, convex_indices, nil)

  local result = {}
  if code == naivecgl_ffi.NS.Naive_Code_ok then
    for i = 1, n_convex_points[0] do
      result[i] = convex_indices[0][i - 1] + 1
    end
  end

  naivecgl_ffi.NS.Naive_Memory_free(convex_indices[0])
  return code, result
end

---
---@param points naivecgl.XY[]
---@return integer code
---@return naivecgl.XY origin
---@return number radius
function geom2dapi.enclosing_disc(points)
  local aPoints = ArrayXY:new(points)
  local o = ffi.new("Naive_Point2d_t")
  local r = ffi.new("double[1]", 0)
  return naivecgl_ffi.NS.Naive_Geom2dAPI_enclosing_disc(aPoints:size(), aPoints:data(), o, r),
      XY.take(o), r[0]
end

return geom2dapi
