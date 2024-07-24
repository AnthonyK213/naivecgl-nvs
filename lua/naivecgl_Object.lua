local ffi = require("ffi")
local naivecgl_ffi = require("naivecgl_ffi")

local Object = {}

---
---@param object integer
---@return integer code
---@return integer class
function Object.ask_class(object)
  local class = ffi.new("Naive_Class_t[1]", 0)
  return naivecgl_ffi.NS.Naive_Object_ask_class(object, class), class[0]
end

---
---@param object integer
---@return integer code
function Object.delete(object)
  return naivecgl_ffi.NS.Naive_Object_delete(object)
end

return Object
