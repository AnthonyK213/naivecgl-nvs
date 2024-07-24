local Array = require("ffi_util").Array

---@class naivecgl.ArrayInt32 : ffi_util.Array<integer>
local ArrayInt32 = Array.instantiate("int")

return ArrayInt32
