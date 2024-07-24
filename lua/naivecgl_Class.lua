local ffi = require("ffi")
local naivecgl_ffi = require("naivecgl_ffi")

local Class = {}

---
---@param class integer
---@return integer code
---@return integer superclass
function Class.ask_superclass(class)
  local superclass = ffi.new("Naive_Class_t[1]", 0)
  return naivecgl_ffi.NS.Naive_Class_ask_superclass(class, superclass), superclass[0]
end

---
---@param may_be_subclass integer
---@param class integer
---@return integer code
---@return boolean is_subclass
function Class.is_subclass(may_be_subclass, class)
  local is_subclass = ffi.new("Naive_Logical_t[1]", 0)
  return naivecgl_ffi.NS.Naive_Class_is_subclass(may_be_subclass, class, is_subclass), is_subclass[0] == 1
end

return Class
