local ffi_ = require("naivecgl.ffi_")

local Logical_t = {}

Logical_t.true_ = 1
Logical_t.false_ = 0

return ffi_.U.oop.make_readonly(Logical_t)
