local Array = require("ffi_util").Array
local Triangle = require("naivecgl.Triangle")

---@class naivecgl.ArrayTriangle : ffi_util.Array<naivecgl.Triangle>
local ArrayTriangle = Array.instantiate(Triangle)

return ArrayTriangle
