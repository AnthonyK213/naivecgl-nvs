local Array = require("ffi_util").array.Array
local Triangle = require("naivecgl.Triangle")

---@class naivecgl.ArrayTriangle : ffi_util.array.Array<naivecgl.Triangle>
local ArrayTriangle = Array.instantiate(Triangle)

return ArrayTriangle
