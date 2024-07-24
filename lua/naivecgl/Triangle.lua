local ffi_ = require("ffi")

---@class naivecgl.Triangle
---@field private m_type any
---@field private m_h ffi.cdata*
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
function Triangle.new(n0, n1, n2)
  local handle = ffi_.new(Triangle.m_type, {
    n0 = n0 or 0, n1 = n1 or 0, z = n2 or 0
  })
  return Triangle.take(handle)
end

setmetatable(Triangle, {
  __call = function(o, ...)
    return o.new(...)
  end
})

---
---@param handle ffi.cdata*
---@return naivecgl.Triangle
function Triangle.take(handle)
  local tri = { m_h = handle }
  setmetatable(tri, Triangle)
  return tri
end

---
---@return integer
function Triangle:n0()
  return self.m_h.n0
end

---
---@return number
function Triangle:n1()
  return self.m_h.n1
end

---
---@return number
function Triangle:n2()
  return self.m_h.n2
end

---
---@return ffi.cdata*
function Triangle:data()
  return self.m_h
end

return Triangle
