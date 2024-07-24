local naivecgl = {}

require("naivecgl.ffi_"):init()

naivecgl.Class = require("naivecgl.Class")
naivecgl.Curve = require("naivecgl.Curve")
naivecgl.Geometry = require("naivecgl.Geometry")
naivecgl.NurbsCurve = require("naivecgl.NurbsCurve")
naivecgl.NurbsSurface = require("naivecgl.NurbsSurface")
naivecgl.Object = require("naivecgl.Object")
naivecgl.Surface = require("naivecgl.Surface")
naivecgl.Triangle = require("naivecgl.Triangle")
naivecgl.Triangulation = require("naivecgl.Triangulation")
naivecgl.XY = require("naivecgl.XY")
naivecgl.XYZ = require("naivecgl.XYZ")
naivecgl.enum = require("naivecgl.enum")
naivecgl.geom2dapi = require("naivecgl.geom2dapi")
naivecgl.macro = require("naivecgl.macro")
naivecgl.tessellation = require("naivecgl.tessellation")
naivecgl.util = require("naivecgl.util")

return naivecgl
