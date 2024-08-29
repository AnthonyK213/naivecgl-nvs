local ffi_ = require("naivecgl.ffi_")

local ArrayDouble = ffi_.U.array.ArrayDouble
local ArrayInt32 = ffi_.U.array.ArrayInt32
local ArrayXYZ = require("naivecgl.ArrayXYZ")
local Object = require("naivecgl.Object")

local NurbsSurface = {}

---
---@param nurbs_surface_sf Naive.NurbsSurface_sf_t
---@return integer code
---@return integer nurbs_surface
function NurbsSurface.create(nurbs_surface_sf)
  local nurbs_surface = ffi_.F.new("Naive_NurbsSurface_t[1]", Object.null)
  return ffi_.NS.Naive_NurbsSurface_create(ffi_.U.oop.get_data(nurbs_surface_sf), nurbs_surface), nurbs_surface[0]
end

return ffi_.U.oop.make_readonly(NurbsSurface)
