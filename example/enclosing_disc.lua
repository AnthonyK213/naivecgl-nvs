local Naivis = Naivis
local nvs = nvs
local naivecgl = require("naivecgl")

local BRepBuilderAPI_MakeEdge = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeEdge
local BRepBuilderAPI_MakeVertex = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeVertex
local Geom_Circle = nvs.occ.Geom.Geom_Circle
local Ghost_Attribute = Naivis.Ghost.Ghost_Attribute
local LODoc_Attribute = nvs.occ.LODoc.LODoc_Attribute
local Quantity_Color = nvs.occ.Quantity.Quantity_Color
local gp = nvs.occ.gp.gp
local gp_Ax2 = nvs.occ.gp.gp_Ax2
local gp_Pnt = nvs.occ.gp.gp_Pnt

local XY = naivecgl.XY

local doc = Naivis.NaiveDoc.ActiveDoc
doc:Objects():Clear(false)
if not _G.__ghost__ then _G.__ghost__ = Naivis.Ghost.NewDocument() end
__ghost__:Clear(false)

local n_points = 100
local points = {}

for i = 1, n_points do
  local x = math.random() * 20 - 10
  local y = math.random() * 20 - 10
  points[i] = XY(x, y)
  doc:Objects():AddShape(BRepBuilderAPI_MakeVertex(gp_Pnt(x, y, 0)):Vertex(), LODoc_Attribute(), false)
end

local o, r = naivecgl.util.unwrap(naivecgl.geom2dapi.enclosing_disc(points))

local circle = Geom_Circle(gp_Ax2(gp_Pnt(o:x(), o:y(), 0), gp.DZ()), r)
local edge = BRepBuilderAPI_MakeEdge(circle):Edge()
local attr = Ghost_Attribute()
attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_RED))
__ghost__:AddShape(edge, attr, false)

doc:UpdateView()
