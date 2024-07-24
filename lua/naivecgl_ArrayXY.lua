local Array = require("naivecgl_Array")
local XY = require("naivecgl_XY")

---@class naivecgl.ArrayXY : naivecgl.Array<naivecgl.XY>
ArrayXY = Array.instantiate(XY)

return ArrayXY
