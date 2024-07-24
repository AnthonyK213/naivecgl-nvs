local naivecgl = {}

require("naivecgl_ffi"):init()

naivecgl.Class = require("naivecgl_Class")
naivecgl.Curve = require("naivecgl_Curve")
naivecgl.Geometry = require("naivecgl_Geometry")
naivecgl.NurbsCurve = require("naivecgl_NurbsCurve")
naivecgl.NurbsSurface = require("naivecgl_NurbsSurface")
naivecgl.Object = require("naivecgl_Object")
naivecgl.Surface = require("naivecgl_Surface")
naivecgl.Triangle = require("naivecgl_Triangle")
naivecgl.Triangulation = require("naivecgl_Triangulation")
naivecgl.XY = require("naivecgl_XY")
naivecgl.XYZ = require("naivecgl_XYZ")
naivecgl.enum = require("naivecgl_enum")
naivecgl.geom2dapi = require("naivecgl_geom2dapi")
naivecgl.macro = require("naivecgl_macro")
naivecgl.tessellation = require("naivecgl_tessellation")
naivecgl.util = require("naivecgl_util")

return naivecgl
