local naivecgl = {}

require("naivecgl.ffi_"):init()

naivecgl.Ax2_sf_t = require("naivecgl.Ax2_sf_t")
naivecgl.Class = require("naivecgl.Class")
naivecgl.Curve = require("naivecgl.Curve")
naivecgl.Geom2dAPI = require("naivecgl.Geom2dAPI")
naivecgl.Geometry = require("naivecgl.Geometry")
naivecgl.Logical_t = require("naivecgl.Logical_t")
naivecgl.NurbsCurve = require("naivecgl.NurbsCurve")
naivecgl.NurbsSurface = require("naivecgl.NurbsSurface")
naivecgl.Object = require("naivecgl.Object")
naivecgl.Plane = require("naivecgl.Plane")
naivecgl.Plane_sf_t = require("naivecgl.Plane_sf_t")
naivecgl.Surface = require("naivecgl.Surface")
naivecgl.Tessellation = require("naivecgl.Tessellation")
naivecgl.Triangle_t = require("naivecgl.Triangle_t")
naivecgl.Triangulation = require("naivecgl.Triangulation")
naivecgl.XY_t = require("naivecgl.XY_t")
naivecgl.XYZ_t = require("naivecgl.XYZ_t")
naivecgl.enum = require("naivecgl.enum")
naivecgl.util = require("naivecgl.util")

return naivecgl
