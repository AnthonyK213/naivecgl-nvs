local naivecgl = require("naivecgl")

local Ax2_sf_t = naivecgl.Ax2_sf_t
local Plane_sf_t = naivecgl.Plane_sf_t
local XYZ_t = naivecgl.XYZ_t

local BRepBuilderAPI_MakeVertex = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeVertex
local LODoc_Attribute = nvs.occ.LODoc.LODoc_Attribute
local gp_Pnt = nvs.occ.gp.gp_Pnt

local doc = Naivis.NaiveDoc.ActiveDoc
doc:Objects():Clear(false)
if not _G.__ghost__ then _G.__ghost__ = Naivis.Ghost.NewDocument() end
__ghost__:Clear(false)

Naivis.NaiveApp.Clear()

local basis_set = Ax2_sf_t(XYZ_t(1, 1, 4), XYZ_t(5, 1, 4), XYZ_t(8, 1, 0))
local plane_sf = Plane_sf_t(basis_set)
local plane = naivecgl.Object.null

naivecgl.util.try(function()
  plane = naivecgl.util.unwrap(naivecgl.Plane.create(plane_sf))

  local test_point = XYZ_t()
  local dist = naivecgl.util.unwrap(naivecgl.Plane.distance(plane, test_point))

  print(dist)

  local code, p0, p1, p2, p3, p4

  code, p0 = naivecgl.Surface.eval(plane, 0, 0, 0, 0)
  code, p1 = naivecgl.Surface.eval(plane, -10, -10, 0, 0)
  code, p2 = naivecgl.Surface.eval(plane, 10, -10, 0, 0)
  code, p3 = naivecgl.Surface.eval(plane, 10, 10, 0, 0)
  code, p4 = naivecgl.Surface.eval(plane, -10, 10, 0, 0)

  local points = {
    gp_Pnt(p0:value(1):x(), p0:value(1):y(), p0:value(1):z()),
    gp_Pnt(p1:value(1):x(), p1:value(1):y(), p1:value(1):z()),
    gp_Pnt(p2:value(1):x(), p2:value(1):y(), p2:value(1):z()),
    gp_Pnt(p3:value(1):x(), p3:value(1):y(), p3:value(1):z()),
    gp_Pnt(p4:value(1):x(), p4:value(1):y(), p4:value(1):z()),
  }

  for _, p in ipairs(points) do
    local vert = BRepBuilderAPI_MakeVertex(p):Shape()
    doc:Objects():AddShape(vert, LODoc_Attribute(), false)
  end

  local plane_sf_get
  code, plane_sf_get = naivecgl.Plane.ask(plane)
  local location = plane_sf_get:basis_set():location()
  print(location:x(), location:y(), location:z())
end).catch(function(ex)
  nvs.print(ex)
end).finally(function()
  naivecgl.Object.delete(plane)
end)

doc:UpdateView()
