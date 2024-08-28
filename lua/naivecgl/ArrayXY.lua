local ffi_ = require("naivecgl.ffi_")

local Array = ffi_.U.array.Array
local XY_t = require("naivecgl.XY_t")

---@class naivecgl.ArrayXY : ffi_util.array.Array<Naive.XY_t>
---@field new fun(self:naivecgl.ArrayXY,list:number[]|naivecgl.ArrayXY,low?:integer):naivecgl.ArrayXY
---@field value fun(self:naivecgl.ArrayXY,index:integer):Naive.XY_t
---@field set_value fun(self:naivecgl.ArrayXY,index:integer,value:Naive.XY_t)
local ArrayXY = Array.instantiate(XY_t)

return ArrayXY
