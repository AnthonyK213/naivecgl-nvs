local ffi_ = require("naivecgl.ffi_")

local Array = ffi_.U.array.Array
local XYZ_t = require("naivecgl.XYZ_t")

---@class naivecgl.ArrayXYZ : ffi_util.array.Array<Naive.XYZ_t>
local ArrayXYZ = Array.instantiate(XYZ_t)

return ArrayXYZ
