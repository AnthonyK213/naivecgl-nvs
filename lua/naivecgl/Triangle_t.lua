local ffi_ = require("naivecgl.ffi_")

---@class Naive.Triangle_t
---@field private m_type any
---@field private m_data ffi.cdata*
---@operator call:Naive.Triangle_t
local Triangle_t = ffi_.U.oop.def_class("Naive_Triangle_t", {
  ctor = function(o, n0, n1, n2)
    local handle = ffi_.F.new(o.m_type, {
      n0 = n0 or 0, n1 = n1 or 0, n2 = n2 or 0
    })
    return ffi_.U.oop.take(o, handle)
  end
})

---
---@return integer
function Triangle_t:n0()
  return ffi_.U.oop.get_field(self.m_data, "n0")
end

---
---@return integer
function Triangle_t:n1()
  return ffi_.U.oop.get_field(self.m_data, "n1")
end

---
---@return integer
function Triangle_t:n2()
  return ffi_.U.oop.get_field(self.m_data, "n2")
end

return Triangle_t
