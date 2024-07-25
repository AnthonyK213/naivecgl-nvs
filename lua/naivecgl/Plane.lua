local Plane_sf_t = require("naivecgl.Plane_sf_t")
local ffi_ = require("naivecgl.ffi_")
local ffi_util = require("ffi_util")

local Plane = {}

---
---@param plane integer
---@return integer code
---@return naivecgl.Plane_sf_t plane_sf
function Plane.ask(plane)
  local plane_sf = ffi_.new(ffi_util.util.get_ffi_type(Plane_sf_t))
  return ffi_.NS.Naive_Plane_ask(plane, plane_sf), Plane_sf_t:take(plane_sf)
end

---
---@param plane_sf naivecgl.Plane_sf_t
---@return integer code
---@return integer plane
function Plane.create(plane_sf)
  local plane = ffi_.new("Naive_Plane_t[1]", 0)
  return ffi_.NS.Naive_Plane_create(ffi_util.util.get_ffi_data(plane_sf), plane), plane[0]
end

---
---@param plane integer
---@param point naivecgl.XYZ
---@return integer code
---@return number distance
function Plane.distance(plane, point)
  local distance = ffi_.new("double[1]", 0)
  return ffi_.NS.Naive_Plane_distance(plane, point:data(), distance), distance[0]
end

return Plane
