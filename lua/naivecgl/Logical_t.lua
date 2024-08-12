local ffi_ = require("naivecgl.ffi_")

local Logical_t = {}

Logical_t.true_ = true
Logical_t.false_ = false

return ffi_.U.oop.make_readonly(Logical_t)
