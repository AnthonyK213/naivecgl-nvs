local ffi_ = require("naivecgl.ffi_")

local naivecgl = {}

ffi_:init()

naivecgl._VERSION          = "naivecgl.lua 0.0.1"
naivecgl._URL              = "https://github.com/AnthonyK213/naivecgl-nvs"

naivecgl.Logical_t         = require("naivecgl.Logical_t")
naivecgl.Triangle_t        = require("naivecgl.Triangle_t")
naivecgl.XYZ_t             = require("naivecgl.XYZ_t")
naivecgl.XY_t              = require("naivecgl.XY_t")

naivecgl.Ax2_sf_t          = require("naivecgl.Ax2_sf_t")
naivecgl.NurbsCurve_sf_t   = require("naivecgl.NurbsCurve_sf_t")
naivecgl.NurbsSurface_sf_t = require("naivecgl.NurbsSurface_sf_t")
naivecgl.Plane_sf_t        = require("naivecgl.Plane_sf_t")
naivecgl.Point_sf_t        = require("naivecgl.Point_sf_t")

naivecgl.Body              = require("naivecgl.Body")
naivecgl.Class             = require("naivecgl.Class")
naivecgl.Curve             = require("naivecgl.Curve")
naivecgl.Geom2dAPI         = require("naivecgl.Geom2dAPI")
naivecgl.Geometry          = require("naivecgl.Geometry")
naivecgl.NurbsCurve        = require("naivecgl.NurbsCurve")
naivecgl.NurbsSurface      = require("naivecgl.NurbsSurface")
naivecgl.Object            = require("naivecgl.Object")
naivecgl.Plane             = require("naivecgl.Plane")
naivecgl.Point             = require("naivecgl.Point")
naivecgl.Surface           = require("naivecgl.Surface")
naivecgl.Tessellation      = require("naivecgl.Tessellation")
naivecgl.Topol             = require("naivecgl.Topol")
naivecgl.Triangulation     = require("naivecgl.Triangulation")
naivecgl.Vertex            = require("naivecgl.Vertex")

naivecgl.Array             = require("naivecgl.Array")

naivecgl.enum              = require("naivecgl.enum")
naivecgl.util              = require("naivecgl.util")

return ffi_.U.oop.make_readonly(naivecgl)
