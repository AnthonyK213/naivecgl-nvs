local ffi_ = require("naivecgl.ffi_")

local Logical_t = require("naivecgl.Logical_t")

local Class = {}

---
---@param class integer
---@return integer code
---@return integer superclass
function Class.ask_superclass(class)
  local superclass = ffi_.F.new("Naive_Class_t[1]", 0)
  return ffi_.NS.Naive_Class_ask_superclass(class, superclass), superclass[0]
end

---
---@param may_be_subclass integer
---@param class integer
---@return integer code
---@return boolean is_subclass
function Class.is_subclass(may_be_subclass, class)
  local is_subclass = ffi_.F.new("Naive_Logical_t[1]", 0)
  return ffi_.NS.Naive_Class_is_subclass(may_be_subclass, class, is_subclass), is_subclass[0] == Logical_t.true_
end

return ffi_.U.oop.make_readonly(Class)
