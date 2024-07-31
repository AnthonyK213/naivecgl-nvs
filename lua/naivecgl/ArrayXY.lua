local ffi_ = require("naivecgl.ffi_")

local Array = ffi_.U.array.Array
local XY = require("naivecgl.XY_t")

---@class naivecgl.ArrayXY : ffi_util.array.Array<naivecgl.XY>
ArrayXY = Array.instantiate(XY)

return ArrayXY
