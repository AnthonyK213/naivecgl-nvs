local ffi_ = require("naivecgl.ffi_")

local Array = ffi_.U.array.Array
local XYZ_t = require("naivecgl.XYZ_t")

---@class naivecgl.ArrayXYZ : ffi_util.array.Array<Naive.XYZ_t>
---@field new fun(self:naivecgl.ArrayXYZ,list:number[]|naivecgl.ArrayXYZ,low?:integer):naivecgl.ArrayXYZ
---@field value fun(self:naivecgl.ArrayXYZ,index:integer):Naive.XYZ_t
---@field set_value fun(self:naivecgl.ArrayXYZ,index:integer,value:Naive.XYZ_t)
local ArrayXYZ = Array.instantiate(XYZ_t)

return ArrayXYZ
