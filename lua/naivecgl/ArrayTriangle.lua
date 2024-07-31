local ffi_ = require("naivecgl.ffi_")

local Array = ffi_.U.array.Array
local Triangle_t = require("naivecgl.Triangle_t")

---@class naivecgl.ArrayTriangle : ffi_util.array.Array<Naive.Triangle_t>
local ArrayTriangle = Array.instantiate(Triangle_t)

return ArrayTriangle
