local ffi = require("ffi")
local naivecgl_ffi = require("naivecgl_ffi")

local naivecgl_common = {}

---
---@generic T
---@param array2 T[][]
---@return integer
---@return integer
---@return T[]
function naivecgl_common.flatten_array2(array2)
  if #array2 == 0 then
    return 0, 0, {}
  end

  local n_u = #array2
  local n_v = #(array2[1])

  local result = {}
  for i = 1, n_u, 1 do
    if #(array2[i]) ~= n_v then
      return 0, 0, {}
    end

    for j = 1, n_v, 1 do
      table.insert(result, array2[i][j])
    end
  end

  return n_u, n_v, result
end

---
---@param tag integer
---@param method string
---@param type_ naivecgl.Array
---@param low? integer
---@return integer code
---@return naivecgl.Array array
function naivecgl_common.ask_array(tag, method, type_, low)
  local n_array = ffi.new("int[1]", 0)
  local array = ffi.new(ffi.typeof(naivecgl_ffi.get_ffi_type(type_.m_type) .. "*[1]"))
  return naivecgl_ffi.NS[method](tag, n_array, array), type_:take(array[0], n_array[0], {
    low = low,
    free = naivecgl_ffi.NS.Naive_Memory_free,
  })
end

return naivecgl_common
