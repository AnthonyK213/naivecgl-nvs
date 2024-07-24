local Naivis = Naivis
local nvs = nvs
local naivecgl = require("naivecgl")

local BRepBuilderAPI_MakeEdge = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeEdge
local BRepBuilderAPI_MakeVertex = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeVertex
local Ghost_Attribute = Naivis.Ghost.Ghost_Attribute
local LODoc_Attribute = nvs.occ.LODoc.LODoc_Attribute
local Quantity_Color = nvs.occ.Quantity.Quantity_Color
local gp_Pnt = nvs.occ.gp.gp_Pnt

local P2 = naivecgl.XY

local doc = Naivis.NaiveDoc.ActiveDoc
doc:Objects():Clear(false)
if not _G.__ghost__ then _G.__ghost__ = Naivis.Ghost.NewDocument() end
__ghost__:Clear(false)

local n_points = 100
local points = {}

for i = 1, n_points do
  local x = math.random() * 20 - 10
  local y = math.random() * 20 - 10
  points[i] = P2(x, y)
  doc:Objects():AddShape(BRepBuilderAPI_MakeVertex(gp_Pnt(x, y, 0)):Vertex(), LODoc_Attribute(), false)
end

local convex_indices = naivecgl.util.unwrap(naivecgl.geom2dapi.convex_hull(points))
local n_convex_points = #convex_indices

for i = 1, n_convex_points do
  local i_this = convex_indices[i]
  local i_next = convex_indices[i % n_convex_points + 1]

  local p1 = gp_Pnt(points[i_this]:x(), points[i_this]:y(), 0)
  local p2 = gp_Pnt(points[i_next]:x(), points[i_next]:y(), 0)

  local attr = Ghost_Attribute()
  attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_RED))
  __ghost__:AddShape(BRepBuilderAPI_MakeEdge(p1, p2):Edge(), attr, false)
end

doc:UpdateView()
