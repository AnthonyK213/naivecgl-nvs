local ffi_ = require("naivecgl.ffi_")

local Logical_t = require("naivecgl.Logical_t")

local ArrayDouble = ffi_.U.array.ArrayDouble
local ArrayInt32 = ffi_.U.array.ArrayInt32

---@class Naive.NurbsSurface_sf_t
---@operator call:Naive.NurbsSurface_sf_t
local NurbsSurface_sf_t = ffi_.U.oop.def_class("Naive_NurbsSurface_sf_t", {
  ctor = ffi_.U.oop.def_ctor {}
})

return NurbsSurface_sf_t
