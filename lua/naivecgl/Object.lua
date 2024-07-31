local ffi_ = require("naivecgl.ffi_")

local Object = {}

Object.null = 0

---
---@param object integer
---@return integer code
---@return integer class
function Object.ask_class(object)
  local class = ffi_.F.new("Naive_Class_t[1]", 0)
  return ffi_.NS.Naive_Object_ask_class(object, class), class[0]
end

---
---@param object integer
---@return integer code
function Object.delete(object)
  return ffi_.NS.Naive_Object_delete(object)
end

return Object
