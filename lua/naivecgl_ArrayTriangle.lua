local Array = require("naivecgl_Array")
local Triangle = require("naivecgl_Triangle")

---@class naivecgl.ArrayTriangle : naivecgl.Array<naivecgl.Triangle>
local ArrayTriangle = Array.instantiate(Triangle)

return ArrayTriangle
