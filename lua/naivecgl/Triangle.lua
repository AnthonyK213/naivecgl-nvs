local ffi_ = require("naivecgl.ffi_")

---@class naivecgl.Triangle
---@field private m_type any
---@field private m_data ffi.cdata*
---@operator call:naivecgl.Triangle
local Triangle = ffi_.oop.def_class("Naive_Triangle_t", function(o, n0, n1, n2)
  local handle = ffi_.new(o.m_type, {
    n0 = n0 or 0, n1 = n1 or 0, n2 = n2 or 0
  })
  return ffi_.oop.take(o, handle)
end)

---
---@return integer
function Triangle:n0()
  return ffi_.oop.get_field(self.m_data, "n0")
end

---
---@return integer
function Triangle:n1()
  return ffi_.oop.get_field(self.m_data, "n1")
end

---
---@return integer
function Triangle:n2()
  return ffi_.oop.get_field(self.m_data, "n2")
end

return Triangle
