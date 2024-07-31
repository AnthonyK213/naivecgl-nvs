local Plane_sf_t = require("naivecgl.Plane_sf_t")
local ffi_ = require("naivecgl.ffi_")

local Plane = {}

---
---@param plane integer
---@return integer code
---@return Naive.Plane_sf_t plane_sf
function Plane.ask(plane)
  local plane_sf = ffi_.F.new(ffi_.U.oop.get_type(Plane_sf_t))
  return ffi_.NS.Naive_Plane_ask(plane, plane_sf), ffi_.U.oop.take(Plane_sf_t, plane_sf)
end

---
---@param plane_sf Naive.Plane_sf_t
---@return integer code
---@return integer plane
function Plane.create(plane_sf)
  local plane = ffi_.F.new("Naive_Plane_t[1]", 0)
  return ffi_.NS.Naive_Plane_create(ffi_.U.oop.get_data(plane_sf), plane), plane[0]
end

---
---@param plane integer
---@param point Naive.XYZ_t
---@return integer code
---@return number distance
function Plane.distance(plane, point)
  local distance = ffi_.F.new("double[1]", 0)
  return ffi_.NS.Naive_Plane_distance(plane, ffi_.U.oop.get_data(point), distance), distance[0]
end

return Plane
