local Naivis = Naivis
local nvs = nvs
local Naive = require("naivecgl")

local BRepBuilderAPI_MakeEdge = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeEdge
local BRepBuilderAPI_MakeVertex = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeVertex
local Ghost_Attribute = Naivis.Ghost.Ghost_Attribute
local gp_Pnt = nvs.occ.gp.gp_Pnt
local gp = nvs.occ.gp.gp

local doc = Naivis.NaiveDoc.ActiveDoc
doc:Objects():Clear(false)
if not _G.__ghost__ then _G.__ghost__ = Naivis.Ghost.NewDocument() end
__ghost__:Clear(false)

local code, basis_set, solid_block, edges

basis_set = Naive.Ax2_sf_t(Naive.XYZ_t(), Naive.XYZ_t(0, 1, 1), Naive.XYZ_t(1, -1, 0))

code, solid_block = Naive.Body.create_solid_block(10, 10, 10, basis_set)

code, edges = Naive.Body.ask_edges(solid_block)

__ghost__:AddShape(BRepBuilderAPI_MakeVertex(gp.Origin()):Vertex(), Ghost_Attribute(), false)

for i = edges:lower(), edges:upper() do
  local vertices, p1, p2, p1_sf, p2_sf
  code, vertices = Naive.Edge.ask_vertices(edges:value(i))
  code, p1 = Naive.Vertex.ask_point(vertices[1])
  code, p2 = Naive.Vertex.ask_point(vertices[2])
  code, p1_sf = Naive.Point.ask(p1)
  code, p2_sf = Naive.Point.ask(p2)
  local pos1, pos2 = p1_sf:position(), p2_sf:position()
  local aPnt1 = gp_Pnt(pos1:x(), pos1:y(), pos1:z())
  local aPnt2 = gp_Pnt(pos2:x(), pos2:y(), pos2:z())
  __ghost__:AddShape(BRepBuilderAPI_MakeEdge(aPnt1, aPnt2):Edge(), Ghost_Attribute(), false)
end

doc:UpdateView()
