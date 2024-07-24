local Array = require("ffi_util").Array
local XYZ = require("naivecgl_XYZ")

---@class naivecgl.ArrayXYZ : ffi_util.Array<naivecgl.XYZ>
local ArrayXYZ = Array.instantiate(XYZ)

return ArrayXYZ
