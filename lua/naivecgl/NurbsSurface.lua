local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local NurbsSurface_sf_t = require("naivecgl.NurbsSurface_sf_t")
local Object = require("naivecgl.Object")

local NurbsSurface = {}

---This function returns the standard form for a NURBS surface.
---@param nurbs_surface integer NURBS surface.
---@return integer code Code.
---@return Naive.NurbsSurface_sf_t nurbs_surface_sf NURBS surface standard form.
function NurbsSurface.ask(nurbs_surface)
  local nurbs_surface_sf = NurbsSurface_sf_t()
  return ffi_.NS.Naive_NurbsSurface_ask(nurbs_surface, ffi_.U.oop.get_data(nurbs_surface_sf)),
      nurbs_surface_sf:update_cache()
end

---This function creates a NURBS surface from the standard form.
---@param nurbs_surface_sf Naive.NurbsSurface_sf_t NURBS surface standard form.
---@return integer code Code.
---@return integer nurbs_surface NURBS surface.
function NurbsSurface.create(nurbs_surface_sf)
  local nurbs_surface = ffi_.F.new("Naive_NurbsSurface_t[1]", Object.null)
  return ffi_.NS.Naive_NurbsSurface_create(ffi_.U.oop.get_data(nurbs_surface_sf), nurbs_surface), nurbs_surface[0]
end

return ffi_.U.oop.make_readonly(NurbsSurface)
