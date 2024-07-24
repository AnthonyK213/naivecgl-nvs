local Array = require("naivecgl_Array")
local XYZ = require("naivecgl_XYZ")

---@class naivecgl.ArrayXYZ : naivecgl.Array<naivecgl.XYZ>
local ArrayXYZ = Array.instantiate(XYZ)

return ArrayXYZ
