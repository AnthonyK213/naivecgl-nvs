local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local XY_t = require("naivecgl.XY_t")

local Geom2dAPI = {}

---This function calculates the convex hull of a set of 2d points.
---@param points Naive.XY_t[]|Naive.Array.XY_t Points.
---@param algo? any Algorithm.
---@return integer code Code.
---@return integer[] convex_indices Index of vertex in the convex hull.
function Geom2dAPI.convex_hull(points, algo)
  local point_array = Array.XY_t:new(points)
  local n_convex_points = ffi_.F.new("int[1]", 0)
  local convex_indices = ffi_.F.new("int*[1]")
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

---This function calculates the enclosing disc of a set of 2d 2d points.
---@param points Naive.XY_t[]|Naive.Array.XY_t Points.
---@return integer code Code.
---@return Naive.XY_t origin The origin of the disc.
---@return number radius The radius of the disc.
function Geom2dAPI.enclosing_disc(points)
  local aPoints = Array.XY_t:new(points)
  local o = ffi_.F.new("Naive_Pnt2d_t")
  local r = ffi_.F.new("double[1]", 0)
  return ffi_.NS.Naive_Geom2dAPI_enclosing_disc(aPoints:size(), aPoints:data(), o, r),
      ffi_.U.oop.take(XY_t, o), r[0]
end

return ffi_.U.oop.make_readonly(Geom2dAPI)
