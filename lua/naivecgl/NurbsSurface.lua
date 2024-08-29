local ffi_ = require("naivecgl.ffi_")

local ArrayDouble = ffi_.U.array.ArrayDouble
local ArrayInt32 = ffi_.U.array.ArrayInt32
local ArrayXYZ = require("naivecgl.ArrayXYZ")
local NurbsSurface_sf_t = require("naivecgl.NurbsSurface_sf_t")
local Object = require("naivecgl.Object")

local NurbsSurface = {}

---
---@param nurbs_surface integer
---@return integer code
---@return Naive.NurbsSurface_sf_t nurbs_surface_sf
function NurbsSurface.ask(nurbs_surface)
  local nurbs_surface_sf = NurbsSurface_sf_t()
  return ffi_.NS.Naive_NurbsSurface_ask(nurbs_surface, ffi_.U.oop.get_data(nurbs_surface_sf)),
      nurbs_surface_sf:update_cache()
end

---
---@param nurbs_surface_sf Naive.NurbsSurface_sf_t
---@return integer code
---@return integer nurbs_surface
function NurbsSurface.create(nurbs_surface_sf)
  local nurbs_surface = ffi_.F.new("Naive_NurbsSurface_t[1]", Object.null)
  return ffi_.NS.Naive_NurbsSurface_create(ffi_.U.oop.get_data(nurbs_surface_sf), nurbs_surface), nurbs_surface[0]
end

return ffi_.U.oop.make_readonly(NurbsSurface)
