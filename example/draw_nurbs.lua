local Naivis = Naivis
local nvs = nvs
local naivecgl = require("naivecgl")

local BRepBuilderAPI_MakeEdge = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeEdge
local BRepBuilderAPI_MakeFace = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeFace
local BRepBuilderAPI_MakeVertex = nvs.occ.BRepBuilderAPI.BRepBuilderAPI_MakeVertex
local BRepPrimAPI_MakeSphere = nvs.occ.BRepPrimAPI.BRepPrimAPI_MakeSphere
local Geom_BSplineCurve = nvs.occ.Geom.Geom_BSplineCurve
local Geom_BSplineSurface = nvs.occ.Geom.Geom_BSplineSurface
local Ghost_AttrOfVector = Naivis.Ghost.Ghost_AttrOfVector
local Ghost_Attribute = Naivis.Ghost.Ghost_Attribute
local LODoc_Attribute = nvs.occ.LODoc.LODoc_Attribute
local Quantity_Color = nvs.occ.Quantity.Quantity_Color
local gp_Pnt = nvs.occ.gp.gp_Pnt
local gp_Vec = nvs.occ.gp.gp_Vec

local XYZ_t = naivecgl.XYZ_t
local unwrap = naivecgl.util.unwrap

local doc = Naivis.NaiveDoc.ActiveDoc
doc:Objects():Clear(false)
if not _G.__ghost__ then _G.__ghost__ = Naivis.Ghost.NewDocument() end
__ghost__:Clear(false)

if Naivis then
  Naivis.NaiveApp.Clear()
end

---
---@param xyz Naive.XYZ_t
---@return gp_Pnt
local function xyz_to_pnt(xyz)
  return gp_Pnt(xyz:x(), xyz:y(), xyz:z())
end

---comment
---@param curve integer
---@param t number
---@return integer
---@return Naive.XYZ_t
local function curve_point_at(curve, t)
  local code, result = naivecgl.Curve.eval(curve, t, 0)
  return code, result:value(1)
end

---
---@param nurbs_curve integer
---@param n_div? integer
local function display_nurbs_curve(nurbs_curve, n_div)
  n_div = n_div or 64

  local nurbs_curve_sf = unwrap(naivecgl.NurbsCurve.ask(nurbs_curve)) --[[@as Naive.NurbsCurve_sf_t]]
  local vertex = nurbs_curve_sf:get_vertex()
  local vertex_dim = nurbs_curve_sf:get_vertex_dim()
  local poles = {}
  local ptr = vertex:lower()
  while ptr < vertex:upper() do
    if vertex_dim == 3 then
      local xyz = XYZ_t(vertex:value(ptr), vertex:value(ptr + 1), vertex:value(ptr + 2))
      table.insert(poles, xyz)
    elseif vertex_dim == 4 then
      local w = vertex:value(ptr + 3)
      local xyz = XYZ_t(vertex:value(ptr) / w, vertex:value(ptr + 1) / w, vertex:value(ptr + 2) / w)
      table.insert(poles, xyz)
    else
      error("Nope!")
    end
    ptr = ptr + vertex_dim
  end
  local n_poles = #poles
  local t0, t1 = unwrap(naivecgl.Curve.ask_bound(nurbs_curve))

  local p_attr = Ghost_Attribute()
  p_attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_CYAN))

  -- Draw control points.

  for i = 1, n_poles do
    local aPole = poles[i]
    local pole = BRepPrimAPI_MakeSphere(xyz_to_pnt(aPole), 0.3):Shape()
    __ghost__:AddShape(pole, p_attr, false)
  end

  -- Draw control polygon.

  local cp_attr = Ghost_Attribute()
  cp_attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_MAGENTA))
  for i = 1, n_poles - 1 do
    local a_this = poles[i]
    local a_next = poles[i + 1]
    local cp = BRepBuilderAPI_MakeEdge(xyz_to_pnt(a_this), xyz_to_pnt(a_next)):Edge()
    __ghost__:AddShape(cp, cp_attr, false)
  end

  -- Draw curve.

  local prev_pnt = xyz_to_pnt(unwrap(curve_point_at(nurbs_curve, 0)))
  local seg_attr = Ghost_Attribute()
  seg_attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_BLACK))
  for i = 1, n_div do
    local pnt = xyz_to_pnt(unwrap(curve_point_at(nurbs_curve, t0 + i * (t1 - t0) / n_div)))
    if pnt then
      local seg = BRepBuilderAPI_MakeEdge(prev_pnt, pnt):Shape()
      __ghost__:AddShape(seg, seg_attr, false)
      prev_pnt = pnt
    else
      error("Invalid point?")
    end
  end

  local knots, mults = unwrap(naivecgl.NurbsCurve.ask_knots(nurbs_curve))

  -- Draw knots.
  for i = 1, knots:size() do
    local pnt = xyz_to_pnt(unwrap(curve_point_at(nurbs_curve, knots:value(i))))
    if pnt then
      local vert = BRepBuilderAPI_MakeVertex(pnt):Shape()
      __ghost__:AddShape(vert, Ghost_Attribute(), false)
    end
  end
end

---
---@param poles Naive.XYZ_t[]
---@param weights number[]
---@param knots number[]
---@param mults integer[]
---@param degree integer
---@param check boolean?
---@param n_div integer?
---@return integer
---@return Geom_BSplineCurve?
local function make_nurbs_curve(poles, weights, knots, mults, degree, check, n_div)
  local nurbs_curve_sf = naivecgl.NurbsCurve_sf_t()
  local vertex = {}
  for i, pole in ipairs(poles) do
    table.insert(vertex, pole:x() * weights[i])
    table.insert(vertex, pole:y() * weights[i])
    table.insert(vertex, pole:z() * weights[i])
    table.insert(vertex, weights[i])
  end

  nurbs_curve_sf:set_degree(degree)
  nurbs_curve_sf:set_vertex_dim(4)
  nurbs_curve_sf:set_is_rational(true)
  nurbs_curve_sf:set_vertex(vertex)
  nurbs_curve_sf:set_knot(knots)
  nurbs_curve_sf:set_knot_mult(mults)

  local nurbs_curve = unwrap(naivecgl.NurbsCurve.create(nurbs_curve_sf))
  display_nurbs_curve(nurbs_curve, n_div)

  if check then
    local poles_ = {}
    for i, p in ipairs(poles) do
      poles_[i] = gp_Pnt(p:x(), p:y(), p:z())
    end
    local bs = Geom_BSplineCurve(poles_, weights, knots, mults, degree, false, false)
    local shape = BRepBuilderAPI_MakeEdge(bs):Edge()
    local attr = Ghost_Attribute()
    attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_RED));
    __ghost__:AddShape(shape, attr, false)

    return nurbs_curve, bs
  end

  return nurbs_curve, nil
end

local function draw_nurbs_curve(n_div)
  n_div = n_div or 64
  local S = math.sqrt(0.5)

  local poles = {
    XYZ_t(10, 0, 0),
    XYZ_t(10, 10, 0),
    XYZ_t(0, 10, 0),
    XYZ_t(-10, 10, 0),
    XYZ_t(-10, 0, 0),
    XYZ_t(-10, -10, 0),
    XYZ_t(0, -10, 0),
    XYZ_t(10, -10, 0),
    XYZ_t(10, 0, 0)
  }
  local weights = { 1, S, 1, S, 1, S, 1, S, 1 }
  local knots = { 0, 0.25, 0.5, 0.75, 1 }
  local mults = { 3, 2, 2, 2, 3 }
  local degree = 2
  local nurbs_curve = naivecgl.Object.null
  local bs

  naivecgl.util.try(function()
    nurbs_curve, bs = make_nurbs_curve(poles, weights, knots, mults, degree, true)
    local vec_ratio = 0.1
    local t = 0.42
    local result = unwrap(naivecgl.Curve.eval(nurbs_curve, t, 2))
    local point = gp_Pnt(result:value(1):x(), result:value(1):y(), result:value(1):z())

    local vec_attr = Ghost_AttrOfVector()
    vec_attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_BLUE))
    for i = 2, result:size() do
      local aV = gp_Vec(result:value(i):x(), result:value(i):y(), result:value(i):z())
      __ghost__:AddVector(aV:Multiplied(vec_ratio), point, vec_attr, false)
    end

    -- Check!
    if bs then
      local shape = BRepBuilderAPI_MakeEdge(bs):Edge()
      local attr = Ghost_Attribute()
      attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_RED));
      local bs_d2 = bs:DN(t, 2)
      __ghost__:AddShape(shape, attr, false)
      __ghost__:AddVector(bs_d2:Multiplied(vec_ratio), bs:Value(t), Ghost_AttrOfVector(), false)
    end
  end).catch(function(ex)
    nvs.print(ex)
  end).finally(function()
    naivecgl.Object.delete(nurbs_curve)
  end)
end

local function draw_nurbs_surface(n_div)
  n_div = n_div or 16

  local degree_u = 2
  local degree_v = 2
  local poles = {
    { XYZ_t(15, -10, 3),  XYZ_t(15, 0, 9), XYZ_t(15, 10, 2) },
    { XYZ_t(25, -10, 1),  XYZ_t(25, 0, 0), XYZ_t(25, 10, -6) },
    { XYZ_t(35, -10, -4), XYZ_t(35, 0, 1), XYZ_t(35, 10, 5) },
  }
  local weights = {
    { 0.3, 1.4, 2.9 },
    { 1.2, 1.2, 1.2 },
    { 0.8, 1.1, 1.8 },
  }
  local knots_u = { 0, 1 }
  local knots_v = { 0, 1 }
  local mults_u = { 3, 3 }
  local mults_v = { 3, 3 }
  local nurbs_surface = naivecgl.Object.null

  naivecgl.util.try(function()
    local nurbs_surface_sf = naivecgl.NurbsSurface_sf_t()
    local vertex = {}
    for u = 1, #poles do
      local vp = poles[u]
      for v = 1, #vp do
        table.insert(vertex, vp[v]:x() * weights[u][v])
        table.insert(vertex, vp[v]:y() * weights[u][v])
        table.insert(vertex, vp[v]:z() * weights[u][v])
        table.insert(vertex, weights[u][v])
      end
    end

    nurbs_surface_sf:set_u_degree(degree_u)
    nurbs_surface_sf:set_v_degree(degree_v)
    nurbs_surface_sf:set_vertex_dim(4)
    nurbs_surface_sf:set_is_rational(true)
    nurbs_surface_sf:set_vertex(vertex, #poles * 4, #poles[1] * 4)
    nurbs_surface_sf:set_u_knot_mult(mults_u)
    nurbs_surface_sf:set_v_knot_mult(mults_v)
    nurbs_surface_sf:set_u_knot(knots_u)
    nurbs_surface_sf:set_v_knot(knots_v)

    nurbs_surface = unwrap(naivecgl.NurbsSurface.create(nurbs_surface_sf))

    local pAttr = Ghost_Attribute()
    pAttr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_CYAN))

    for _, c in ipairs(poles) do
      for _, p in ipairs(c) do
        local pole = BRepPrimAPI_MakeSphere(gp_Pnt(p:x(), p:y(), p:z()), 0.3):Shape()
        __ghost__:AddShape(pole, pAttr, false)
      end
    end

    local cp_attr = Ghost_Attribute()
    cp_attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_MAGENTA))
    for i = 1, #poles do
      local col_this = poles[i]
      local col_next = poles[i + 1]
      for j = 1, #col_this do
        local a_this = col_this[j]
        local a_next = col_this[j + 1]
        if a_next then
          local cp = BRepBuilderAPI_MakeEdge(
            gp_Pnt(a_this:x(), a_this:y(), a_this:z()),
            gp_Pnt(a_next:x(), a_next:y(), a_next:z())):Edge()
          __ghost__:AddShape(cp, cp_attr, false)
        end
        if col_next then
          a_next = col_next[j]
          local cp = BRepBuilderAPI_MakeEdge(
            gp_Pnt(a_this:x(), a_this:y(), a_this:z()),
            gp_Pnt(a_next:x(), a_next:y(), a_next:z())):Edge()
          __ghost__:AddShape(cp, cp_attr, false)
        end
      end
    end

    for i = 0, n_div do
      for j = 0, n_div do
        local pnt = unwrap(naivecgl.Surface.eval(nurbs_surface, i / n_div, j / n_div, 0, 0)):value(1)
        if pnt then
          local vert = BRepBuilderAPI_MakeVertex(gp_Pnt(pnt:x(), pnt:y(), pnt:z())):Vertex()
          doc:Objects():AddShape(vert, LODoc_Attribute(), false)
        end
      end
    end

    local u = 0.1
    local v = 0.4
    local d2 = unwrap(naivecgl.Surface.eval(nurbs_surface, u, v, 1, 1))
    local p = gp_Pnt(d2:value(1):x(), d2:value(1):y(), d2:value(1):z())

    local attr = Ghost_AttrOfVector()
    attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_BLUE))
    for i = 2, d2:size() do
      local aV = gp_Vec(d2:value(i):x(), d2:value(i):y(), d2:value(i):z())
      __ghost__:AddVector(aV, p, attr, false)
    end

    -- Check!
    local poles_ = {}
    for i, col in ipairs(poles) do
      local c = {}
      for j, item in ipairs(col) do
        c[j] = xyz_to_pnt(item)
      end
      poles_[i] = c
    end
    local bs = Geom_BSplineSurface(poles_, weights, knots_u, knots_v, mults_u, mults_v, degree_u, degree_v, false, false)
    local shape = BRepBuilderAPI_MakeFace(bs, 1e-2):Face()
    local bs_attr = Ghost_Attribute()
    bs_attr:SetColor(Quantity_Color(nvs.occ.Quantity.Quantity_NameOfColor.Quantity_NOC_RED));
    local bs_d2 = bs:DN(u, v, 1, 1)
    __ghost__:AddShape(shape, bs_attr, false)
    __ghost__:AddVector(bs_d2, bs:Value(u, v), Ghost_AttrOfVector(), false)
  end).catch(function(ex)
    nvs.print(ex)
  end).finally(function()
    naivecgl.Object.delete(nurbs_surface)
  end)
end

local function nurbs_curve_insert_knot()
  local poles = {
    XYZ_t(-10, 34, 6),
    XYZ_t(-9, 15, -6),
    XYZ_t(-6, 20, 1),
    XYZ_t(0, 26, 2),
    XYZ_t(4, 17, -3),
    XYZ_t(10, 21, 10),
  }
  local weights = { 1.5, 2, 0.5, 1.1, 0.1, 1 }
  local knots = { 0, 1, 2, 3 }
  local mults = { 4, 1, 1, 4 }
  local degree = 3
  local nurbs_curve = naivecgl.Object.null

  naivecgl.util.try(function()
    nurbs_curve = make_nurbs_curve(poles, weights, knots, mults, degree)
    local _ = naivecgl.NurbsCurve.add_knot(nurbs_curve, 0.7, 2)
    -- nurbs_curve:IncreaseMultiplicity(2, 2)
    -- __ghost__:Clear(false)
    display_nurbs_curve(nurbs_curve)

    local t = 0.7
    local curvature = unwrap(naivecgl.Curve.eval_curvature(nurbs_curve, t))
    local point = unwrap(curve_point_at(nurbs_curve, t))
    local cvt_vec = gp_Vec(curvature:x(), curvature:y(), curvature:z())
    local cvt_o = xyz_to_pnt(point)
    local cvt_r = 1 / cvt_vec:Magnitude()
    cvt_vec:Multiply(cvt_r * cvt_r)
    cvt_o:Translate(cvt_vec)
    local shape = BRepPrimAPI_MakeSphere(cvt_o, cvt_r):Shape()
    __ghost__:AddShape(shape, Ghost_Attribute(), false)
  end).catch(function(ex)
    nvs.print(ex)
  end).finally(function()
    naivecgl.Object.delete(nurbs_curve)
  end)
end

local function nurbs_curve_rtti()
  local poles = {
    XYZ_t(-10, 34, 6),
    XYZ_t(-9, 15, -6),
    XYZ_t(-6, 20, 1),
    XYZ_t(0, 26, 2),
    XYZ_t(4, 17, -3),
    XYZ_t(10, 21, 10),
  }
  local weights = { 1.5, 2, 0.5, 1.1, 0.1, 1 }
  local knots = { 0, 1, 2, 3 }
  local mults = { 4, 1, 1, 4 }
  local degree = 3
  local nurbs_curve = naivecgl.Object.null

  naivecgl.util.try(function()
    nurbs_curve = make_nurbs_curve(poles, weights, knots, mults, degree)

    local code, class, superclass, is_subclass
    code, class = naivecgl.Object.ask_class(nurbs_curve)
    assert(code == naivecgl.enum.Code.ok)
    assert(class == naivecgl.enum.Class.nurbs_curve)

    code, superclass = naivecgl.Class.ask_superclass(class)
    assert(code == naivecgl.enum.Code.ok)
    assert(superclass == naivecgl.enum.Class.bounded_curve)

    code, is_subclass = naivecgl.Class.is_subclass(class, naivecgl.enum.Class.curve)
    assert(code == naivecgl.enum.Code.ok)
    assert(is_subclass)

    code, is_subclass = naivecgl.Class.is_subclass(class, naivecgl.enum.Class.bounded_surface)
    assert(code == naivecgl.enum.Code.ok)
    assert(not is_subclass)
  end).catch(function(ex)
    nvs.print(ex)
  end).finally(function()
    naivecgl.Object.delete(nurbs_curve)
  end)
end

draw_nurbs_curve()
draw_nurbs_surface()
nurbs_curve_insert_knot()
nurbs_curve_rtti()

doc:UpdateView()
