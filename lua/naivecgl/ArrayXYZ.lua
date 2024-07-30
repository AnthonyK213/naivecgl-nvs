local Array = require("ffi_util").array.Array
local XYZ = require("naivecgl.XYZ")

---@class naivecgl.ArrayXYZ : ffi_util.array.Array<naivecgl.XYZ>
local ArrayXYZ = Array.instantiate(XYZ)

return ArrayXYZ
