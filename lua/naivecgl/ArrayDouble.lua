local Array = require("ffi_util").Array

---@class naivecgl.ArrayDouble : ffi_util.Array<number>
ArrayDouble = Array.instantiate("double")

return ArrayDouble
