local ffi_ = require("naivecgl.ffi_")

local Array = ffi_.U.array.Array
local Triangle_t = require("naivecgl.Triangle_t")

---@class naivecgl.ArrayTriangle : ffi_util.array.Array<Naive.Triangle_t>
---@field new fun(self:naivecgl.ArrayTriangle,list:number[]|naivecgl.ArrayTriangle,low?:integer):naivecgl.ArrayTriangle
---@field value fun(self:naivecgl.ArrayTriangle,index:integer):Naive.Triangle_t
---@field set_value fun(self:naivecgl.ArrayTriangle,index:integer,value:Naive.Triangle_t)
local ArrayTriangle = Array.instantiate(Triangle_t)

return ArrayTriangle
