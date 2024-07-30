local Array = require("ffi_util").array.Array
local XY = require("naivecgl.XY")

---@class naivecgl.ArrayXY : ffi_util.array.Array<naivecgl.XY>
ArrayXY = Array.instantiate(XY)

return ArrayXY
