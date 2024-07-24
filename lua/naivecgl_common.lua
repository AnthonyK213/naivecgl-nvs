local ffi = require("ffi")
local ffi_util = require("ffi_util")
local naivecgl_ffi = require("naivecgl_ffi")

local naivecgl_common = {}

---
---@param tag integer
---@param method string
---@param type_ ffi_util.Array
---@param low? integer
---@return integer code
---@return ffi_util.Array array
function naivecgl_common.ask_array(tag, method, type_, low)
  local n_array = ffi.new("int[1]", 0)
  local array = ffi.new(ffi.typeof(ffi_util.func.get_ffi_type(type_.m_type) .. "*[1]"))
  return naivecgl_ffi.NS[method](tag, n_array, array), type_:take(array[0], n_array[0], {
    low = low,
    free = naivecgl_ffi.NS.Naive_Memory_free,
  })
end

return naivecgl_common
