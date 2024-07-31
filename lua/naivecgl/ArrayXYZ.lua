local ffi_ = require("naivecgl.ffi_")

local Array = ffi_.U.array.Array
local XYZ = require("naivecgl.XYZ_t")

---@class naivecgl.ArrayXYZ : ffi_util.array.Array<naivecgl.XYZ>
local ArrayXYZ = Array.instantiate(XYZ)

return ArrayXYZ
