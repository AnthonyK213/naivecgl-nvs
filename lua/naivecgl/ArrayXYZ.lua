local Array = require("ffi_util").Array
local XYZ = require("naivecgl.XYZ")

---@class naivecgl.ArrayXYZ : ffi_util.Array<naivecgl.XYZ>
local ArrayXYZ = Array.instantiate(XYZ)

return ArrayXYZ
