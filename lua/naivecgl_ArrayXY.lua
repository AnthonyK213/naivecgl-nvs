local Array = require("ffi_util").Array
local XY = require("naivecgl_XY")

---@class naivecgl.ArrayXY : ffi_util.Array<naivecgl.XY>
ArrayXY = Array.instantiate(XY)

return ArrayXY
