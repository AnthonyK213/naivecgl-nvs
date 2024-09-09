local ffi_ = require("naivecgl.ffi_")

local Object = {}

Object.null = 0

---This function returns the given object's concrete class.
---@param object integer Object.
---@return integer code Code.
---@return integer class Class of object.
function Object.ask_class(object)
  local class = ffi_.F.new("Naive_Class_t[1]", 0)
  return ffi_.NS.Naive_Object_ask_class(object, class), class[0]
end

---This function deletes the given object.
---@param object integer Object.
---@return integer code Code.
function Object.delete(object)
  return ffi_.NS.Naive_Object_delete(object)
end

return ffi_.U.oop.make_readonly(Object)
