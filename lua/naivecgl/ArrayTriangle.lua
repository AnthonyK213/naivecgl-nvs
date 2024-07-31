local ffi_ = require("naivecgl.ffi_")

local Array = ffi_.U.array.Array
local Triangle = require("naivecgl.Triangle_t")

---@class naivecgl.ArrayTriangle : ffi_util.array.Array<naivecgl.Triangle>
local ArrayTriangle = Array.instantiate(Triangle)

return ArrayTriangle
