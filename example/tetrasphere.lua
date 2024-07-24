local Naivis = Naivis
local nvs = nvs
local naivecgl = require("naivecgl")

local LODoc_Attribute = nvs.occ.LODoc.LODoc_Attribute
local Poly_Triangle = nvs.occ.Poly.Poly_Triangle
local Poly_Triangulation = nvs.occ.Poly.Poly_Triangulation
local gp_Pnt = nvs.occ.gp.gp_Pnt

local doc = Naivis.NaiveDoc.ActiveDoc
doc:Objects():Clear(false)
if not _G.__ghost__ then _G.__ghost__ = Naivis.Ghost.NewDocument() end
__ghost__:Clear(false)

local code, tetrasphere, is_valid, vertices, triangles

code, tetrasphere = naivecgl.tessellation.make_tetrasphere(naivecgl.XYZ(), 10, 13)
code, is_valid = naivecgl.Geometry.is_valid(tetrasphere)

if is_valid then
  code, vertices = naivecgl.Triangulation.ask_vertices(tetrasphere)
  code, triangles = naivecgl.Triangulation.ask_triangles(tetrasphere)

  local offset_v = vertices:lower() - 1
  local offset_t = triangles:lower() - 1

  local vert_list = {}
  for i = vertices:lower(), vertices:upper() do
    vert_list[i - offset_v] = gp_Pnt(vertices:value(i):x(), vertices:value(i):y(), vertices:value(i):z())
  end

  local triangle_list = {}
  for i = triangles:lower(), triangles:upper() do
    local triangle = triangles:value(i)
    triangle_list[i - offset_t] = Poly_Triangle(
      triangle:n0() - offset_v,
      triangle:n1() - offset_v,
      triangle:n2() - offset_v)
  end

  doc:Objects():AddMesh(Poly_Triangulation(vert_list, triangle_list), LODoc_Attribute(), false)
end

naivecgl.Object.delete(tetrasphere)

doc:UpdateView()
