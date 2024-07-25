local ffi_ = require("ffi")
local ffi_util = require("ffi_util")

---@class naivecgl.Triangle
---@field private m_type any
---@field private m_data ffi.cdata*
---@operator call:naivecgl.Triangle
local Triangle = {}

---@private
Triangle.__index = Triangle
Triangle.m_type = "Naive_Triangle_t"

---
---@param n0? integer
---@param n1? integer
---@param n2? integer
---@return naivecgl.Triangle
function Triangle:new(n0, n1, n2)
  local handle = ffi_.new(self.m_type, {
    n0 = n0 or 0, n1 = n1 or 0, z = n2 or 0
  })
  return self:take(handle)
end

ffi_util.util.def_ctor(Triangle)

---
---@param handle ffi.cdata*
---@return naivecgl.Triangle
function Triangle:take(handle)
  return ffi_util.util.take(self, handle)
end

---
---@return integer
function Triangle:n0()
  return self.m_data.n0
end

---
---@return number
function Triangle:n1()
  return self.m_data.n1
end

---
---@return number
function Triangle:n2()
  return self.m_data.n2
end

---
---@return ffi.cdata*
function Triangle:data()
  return self.m_data
end

return Triangle
