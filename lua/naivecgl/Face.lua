local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local Object = require("naivecgl.Object")

local Face = {}

---This function returns the first loop in the given face.
---@param face integer A face.
---@return integer code
---@return integer first_loop The first loop (possibly Naive.Object.null).
function Face.ask_first_loop(face)
  local first_loop = ffi_.F.new("Naive_Loop_t[1]", Object.null)
  return ffi_.NS.Naive_Face_ask_first_loop(face, first_loop), first_loop[0]
end

return ffi_.U.oop.make_readonly(Face)
