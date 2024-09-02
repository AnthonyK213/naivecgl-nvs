local ffi_ = require("naivecgl.ffi_")

local A = ffi_.U.array.Array

---@class Naive.Array.Double : ffi_util.array.ArrayDouble
---@field new fun(self:Naive.Array.Double,list:number[]|Naive.Array.Double,low?:integer):Naive.Array.Double
local Double = ffi_.U.array.ArrayDouble

---@class Naive.Array.Int32 : ffi_util.array.ArrayInt32
---@field new fun(self:Naive.Array.Int32,list:integer[]|Naive.Array.Int32,low?:integer):Naive.Array.Int32
local Int32 = ffi_.U.array.ArrayInt32

---@class Naive.Array.Triangle_t : ffi_util.array.Array<Naive.Triangle_t>
---@field new fun(self:Naive.Array.Triangle_t,list:Naive.Triangle_t[]|Naive.Array.Triangle_t,low?:integer):Naive.Array.Triangle_t
---@field value fun(self:Naive.Array.Triangle_t,index:integer):Naive.Triangle_t
---@field set_value fun(self:Naive.Array.Triangle_t,index:integer,value:Naive.Triangle_t)
local Triangle_t = A.instantiate(require("naivecgl.Triangle_t"))

---@class Naive.Array.XYZ_t : ffi_util.array.Array<Naive.XYZ_t>
---@field new fun(self:Naive.Array.XYZ_t,list:Naive.XYZ_t[]|Naive.Array.XYZ_t,low?:integer):Naive.Array.XYZ_t
---@field value fun(self:Naive.Array.XYZ_t,index:integer):Naive.XYZ_t
---@field set_value fun(self:Naive.Array.XYZ_t,index:integer,value:Naive.XYZ_t)
local XYZ_t = A.instantiate(require("naivecgl.XYZ_t"))

---@class Naive.Array.XY_t : ffi_util.array.Array<Naive.XY_t>
---@field new fun(self:Naive.Array.XY_t,list:Naive.XY_t[]|Naive.Array.XY_t,low?:integer):Naive.Array.XY_t
---@field value fun(self:Naive.Array.XY_t,index:integer):Naive.XY_t
---@field set_value fun(self:Naive.Array.XY_t,index:integer,value:Naive.XY_t)
local XY_t = A.instantiate(require("naivecgl.XY_t"))

local Array = {
  Double = Double,
  Int32 = Int32,
  Triangle_t = Triangle_t,
  XYZ_t = XYZ_t,
  XY_t = XY_t,
}

return ffi_.U.oop.make_readonly(Array)
