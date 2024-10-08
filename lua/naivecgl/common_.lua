local ffi_ = require("naivecgl.ffi_")

local common_ = {}

---
---@generic T
---@param tag integer
---@param method string
---@param type_ T
---@param low? integer
---@return integer code
---@return T array
function common_.ask_array(tag, method, type_, low)
  local n_array = ffi_.F.new("int[1]", 0)
  local array = ffi_.F.new(ffi_.F.typeof(ffi_.U.oop.get_type(type_.m_type) .. "*[1]"))
  return ffi_.NS[method](tag, n_array, array), type_:take(array[0], n_array[0], {
    low = low,
    free = ffi_.NS.Naive_Memory_free,
  })
end

return common_
