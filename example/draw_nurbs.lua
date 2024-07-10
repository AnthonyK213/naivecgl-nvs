local Naivis = Naivis
local nvs = nvs
local naivecgl = require("naivecgl")

local BRepBuilderAPI_MakeEdge = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeEdge
local BRepBuilderAPI_MakeVertex = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeVertex
local BRepBuilderAPI_MakeFace = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeFace
local BRepPrimAPI_MakeSphere = nvs.occ.BRepPrimAPI.BRepPrimAPI_MakeSphere
local Geom_BSplineCurve = nvs.occ.Geom.Geom_BSplineCurve
local Geom_BSplineSurface = nvs.occ.Geom.Geom_BSplineSurface
local gp = nvs.occ.gp.gp
local gp_Ax2 = nvs.occ.gp.gp_Ax2
local gp_Pnt = nvs.occ.gp.gp_Pnt
local gp_Vec = nvs.occ.gp.gp_Vec
local LODoc_Attribute = nvs.occ.LODoc.LODoc_Attribute
local Quantity_Color = nvs.occ.Quantity.Quantity_Color
local Ghost_Attribute = Naivis.Ghost.Ghost_Attribute
local Ghost_AttrOfVector = Naivis.Ghost.Ghost_AttrOfVector
local P3 = naivecgl.Naive_XYZ

local doc = Naivis.NaiveDoc.ActiveDoc
doc:Objects():Clear(false)
if not _G.__ghost__ then _G.__ghost__ = Naivis.Ghost.NewDocument() end
__ghost__:Clear(false)

if Naivis then
  Naivis.NaiveApp.Clear()
end

---
---@param theXYZ naivecgl.Naive_XYZ
---@return gp_Pnt
local function xyz_to_pnt(theXYZ)
  return gp_Pnt(theXYZ:x(), theXYZ:y(), theXYZ:z())
end

---
---@param theCrv naivecgl.Naive_NurbsCurve
local function display_nurbs_curve(theCrv, theN)
  theN = theN or 64
  local aPoles = theCrv:ask_poles()
  local nbPoles = aPoles:size()
  local t0, t1 = theCrv:ask_bound()

  local pAttr = Ghost_Attribute()
  pAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_CYAN))

  -- Draw control points.

  for i = 1, nbPoles do
    local aPole = aPoles:value(i)
    local pole = BRepPrimAPI_MakeSphere(xyz_to_pnt(aPole), 0.3):Shape()
    __ghost__:AddShape(pole, pAttr, false)
  end

  -- Draw control polygon.

  local cpAttr = Ghost_Attribute()
  cpAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_MAGENTA))
  for i = 1, nbPoles - 1 do
    local aThis = aPoles:value(i)
    local aNext = aPoles:value(i + 1)
    local cp = BRepBuilderAPI_MakeEdge(xyz_to_pnt(aThis), xyz_to_pnt(aNext)):Edge()
    __ghost__:AddShape(cp, cpAttr, false)
  end

  -- Draw curve.

  local prevPnt = xyz_to_pnt(theCrv:evaluate(t0, 0):value(1))
  local segAttr = Ghost_Attribute()
  segAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_BLACK))
  for i = 1, theN do
    local aPnt = xyz_to_pnt(theCrv:evaluate(t0 + i * (t1 - t0) / theN, 0):value(1))
    if aPnt then
      local aSeg = BRepBuilderAPI_MakeEdge(prevPnt, aPnt):Shape()
      __ghost__:AddShape(aSeg, segAttr, false)
      prevPnt = aPnt
    else
      error("Invalid point?")
    end
  end

  local aKnots = theCrv:ask_knots()

  -- Draw knots.
  for i = 1, aKnots:size() do
    local aPnt = xyz_to_pnt(theCrv:evaluate(aKnots:value(i), 0):value(1))
    if aPnt then
      local aVert = BRepBuilderAPI_MakeVertex(aPnt):Shape()
      __ghost__:AddShape(aVert, Ghost_Attribute(), false)
    end
  end
end

---
---@param thePoles naivecgl.Naive_XYZ[]
---@param theWeights number[]
---@param theKnots number[]
---@param theMults integer[]
---@param theDegree integer
---@param theCheck boolean?
---@param theN integer?
---@return naivecgl.Naive_NurbsCurve
---@return Geom_BSplineCurve?
local function make_nurbs_curve(thePoles, theWeights, theKnots, theMults, theDegree, theCheck, theN)
  local aNurbsCurve = naivecgl.Naive_NurbsCurve.new(thePoles, theWeights, theKnots, theMults, theDegree)
  display_nurbs_curve(aNurbsCurve, theN)

  if theCheck then
    local poles = {}
    for i, p in ipairs(thePoles) do
      poles[i] = gp_Pnt(p:x(), p:y(), p:z())
    end
    local aBS = Geom_BSplineCurve(poles, theWeights, theKnots, theMults, theDegree, false, false)
    local aShape = BRepBuilderAPI_MakeEdge(aBS):Edge()
    local anAttr = Ghost_Attribute()
    anAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_RED));
    __ghost__:AddShape(aShape, anAttr, false)

    return aNurbsCurve, aBS
  end

  return aNurbsCurve, nil
end

local function draw_nurbs_curve(N)
  N = N or 64
  local S = math.sqrt(0.5)

  local aPoles = {
    P3(10, 0, 0),
    P3(10, 10, 0),
    P3(0, 10, 0),
    P3(-10, 10, 0),
    P3(-10, 0, 0),
    P3(-10, -10, 0),
    P3(0, -10, 0),
    P3(10, -10, 0),
    P3(10, 0, 0)
  }
  local aWeights = { 1, S, 1, S, 1, S, 1, S, 1 }
  local aKnots = { 0, 0.25, 0.5, 0.75, 1 }
  local aMults = { 3, 2, 2, 2, 3 }
  local aDegree = 2
  local aNurbsCurve, aBS = make_nurbs_curve(aPoles, aWeights, aKnots, aMults, aDegree, true)

  local vecRatio = 0.1
  local t = 0.42
  local aD = aNurbsCurve:evaluate(t, 2)
  local aP = gp_Pnt(aD:value(1):x(), aD:value(1):y(), aD:value(1):z())

  local anVecAttr = Ghost_AttrOfVector()
  anVecAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_BLUE))
  for i = 2, aD:size() do
    local aV = gp_Vec(aD:value(i):x(), aD:value(i):y(), aD:value(i):z())
    __ghost__:AddVector(aV:Multiplied(vecRatio), aP, anVecAttr, false)
  end

  -- Check!
  local poles = {}
  for i, p in ipairs(aPoles) do
    poles[i] = gp_Pnt(p:x(), p:y(), p:z())
  end

  if aBS then
    local aShape = BRepBuilderAPI_MakeEdge(aBS):Edge()
    local anAttr = Ghost_Attribute()
    anAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_RED));
    local aBS_2 = aBS:DN(t, 2)
    __ghost__:AddShape(aShape, anAttr, false)
    __ghost__:AddVector(aBS_2:Multiplied(vecRatio), aBS:Value(t), Ghost_AttrOfVector(), false)
  end
end

local function draw_nurbs_surface(N)
  N = N or 16

  local aUDegree = 2
  local aVDegree = 2
  local aPoles = {
    { P3(15, -10, 3),  P3(15, 0, 9), P3(15, 10, 2) },
    { P3(25, -10, 1),  P3(25, 0, 0), P3(25, 10, -6) },
    { P3(35, -10, -4), P3(35, 0, 1), P3(35, 10, 5) },
  }
  local aWeights = {
    { 0.3, 1.4, 2.9 },
    { 1.2, 1.2, 1.2 },
    { 0.8, 1.1, 1.8 },
  }
  local aUKnots = { 0, 1 }
  local aVKnots = { 0, 1 }
  local aUMults = { 3, 3 }
  local aVMults = { 3, 3 }
  local aNurbsSurface = naivecgl.Naive_NurbsSurface.new(
    aPoles, aWeights,
    aUKnots, aVKnots, aUMults, aVMults,
    aUDegree, aVDegree)

  local pAttr = Ghost_Attribute()
  pAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_CYAN))

  for _, c in ipairs(aPoles) do
    for _, p in ipairs(c) do
      local pole = BRepPrimAPI_MakeSphere(gp_Pnt(p:x(), p:y(), p:z()), 0.3):Shape()
      __ghost__:AddShape(pole, pAttr, false)
    end
  end

  local cpAttr = Ghost_Attribute()
  cpAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_MAGENTA))
  for i = 1, #aPoles do
    local aColThis = aPoles[i]
    local aColNext = aPoles[i + 1]
    for j = 1, #aColThis do
      local aThis = aColThis[j]
      local aNext = aColThis[j + 1]
      if aNext then
        local cp = BRepBuilderAPI_MakeEdge(
          gp_Pnt(aThis:x(), aThis:y(), aThis:z()),
          gp_Pnt(aNext:x(), aNext:y(), aNext:z())):Edge()
        __ghost__:AddShape(cp, cpAttr, false)
      end
      if aColNext then
        aNext = aColNext[j]
        local cp = BRepBuilderAPI_MakeEdge(
          gp_Pnt(aThis:x(), aThis:y(), aThis:z()),
          gp_Pnt(aNext:x(), aNext:y(), aNext:z())):Edge()
        __ghost__:AddShape(cp, cpAttr, false)
      end
    end
  end

  for i = 0, N do
    for j = 0, N do
      local aPnt = aNurbsSurface:evaluate(i / N, j / N, 0):value(1)
      if aPnt then
        local aVert = BRepBuilderAPI_MakeVertex(gp_Pnt(aPnt:x(), aPnt:y(), aPnt:z())):Vertex()
        doc:Objects():AddShape(aVert, LODoc_Attribute(), false)
      end
    end
  end

  local u = 0.1
  local v = 0.4
  local aD = aNurbsSurface:evaluate(u, v, 2)
  local aP = gp_Pnt(aD:value(1):x(), aD:value(1):y(), aD:value(1):z())

  local anAttr = Ghost_AttrOfVector()
  anAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_BLUE))
  for i = 2, aD:size() do
    local aV = gp_Vec(aD:value(i):x(), aD:value(i):y(), aD:value(i):z())
    __ghost__:AddVector(aV, aP, anAttr, false)
  end

  -- Check!
  local poles = {}
  for i, col in ipairs(aPoles) do
    local c = {}
    for j, item in ipairs(col) do
      c[j] = gp_Pnt(item:x(), item:y(), item:z())
    end
    poles[i] = c
  end
  local aBS = Geom_BSplineSurface(poles, aWeights, aUKnots, aVKnots, aUMults, aVMults, aUDegree, aVDegree, false, false)
  local aShape = BRepBuilderAPI_MakeFace(aBS, 1e-2):Face()
  local anAttr = Ghost_Attribute()
  anAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_RED));
  local aBS_2 = aBS:DN(u, v, 1, 1)
  __ghost__:AddShape(aShape, anAttr, false)
  __ghost__:AddVector(aBS_2, aBS:Value(u, v), Ghost_AttrOfVector(), false)
end

local function nurbs_curve_insert_knot()
  local aPoles = {
    P3(-10, 34, 6),
    P3(-9, 15, -6),
    P3(-6, 20, 1),
    P3(0, 26, 2),
    P3(4, 17, -3),
    P3(10, 21, 10),
  }
  local aWeights = { 1.5, 2, 0.5, 1.1, 0.1, 1 }
  local aKnots = { 0, 1, 2, 3 }
  local aMults = { 4, 1, 1, 4 }
  local aDegree = 3
  local aNurbsCurve, aBS = make_nurbs_curve(aPoles, aWeights, aKnots, aMults, aDegree)
  aNurbsCurve:Insert_knot(0.7, 2)
  -- aNurbsCurve:IncreaseMultiplicity(2, 2)
  -- __ghost__:Clear(false)
  display_nurbs_curve(aNurbsCurve)

  local t = 0.7
  local aC = aNurbsCurve:curvature_at(t)
  local aP = aNurbsCurve:evaluate(t, 0):value(1)
  if aC and aP then
    local aV = gp_Vec(aC:x(), aC:y(), aC:z())
    local o = xyz_to_pnt(aP)
    local r = 1 / aV:Magnitude()
    aV:Multiply(r * r)
    o:Translate(aV)
    local aS = BRepPrimAPI_MakeSphere(o, r):Shape()
    __ghost__:AddShape(aS, Ghost_Attribute(), false)
  end
end

draw_nurbs_curve()
draw_nurbs_surface()
nurbs_curve_insert_knot()

doc:UpdateView()
