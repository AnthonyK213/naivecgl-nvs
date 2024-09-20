local common_ = require("naivecgl.common_")
local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local Object = require("naivecgl.Object")

local Loop = {}

---This function returns an ordered list of fins around the given loop.
---@param loop integer A loop.
---@return integer code
---@return Naive.Array.Int32 fins Fins (optional).
function Loop.ask_fins(loop)
  return common_.ask_array(loop, "Naive_Loop_ask_fins", Array.Int32)
end

return ffi_.U.oop.make_readonly(Loop)
