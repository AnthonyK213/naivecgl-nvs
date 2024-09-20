local ffi_ = require("naivecgl.ffi_")

local Object = require("naivecgl.Object")
local Point_sf_t = require("naivecgl.Point_sf_t")

local Point = {}

---
---@param point integer
---@return integer code
---@return Naive.Point_sf_t point_sf
function Point.ask(point)
  local point_sf = Point_sf_t()
  return ffi_.NS.Naive_Point_ask(point, ffi_.U.oop.get_data(point_sf)), point_sf
end

---
---@param point_sf Naive.Point_sf_t
---@return integer code
---@return integer point
function Point.create(point_sf)
  local point = ffi_.F.new("Naive_Point_t[1]", Object.null)
  return ffi_.NS.Naive_Point_create(ffi_.U.oop.get_data(point_sf), point), point[0]
end

return ffi_.U.oop.make_readonly(Point)
