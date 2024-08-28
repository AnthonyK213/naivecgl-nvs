local ffi_ = require("naivecgl.ffi_")

local Logical_t = {}

Logical_t.true_ = 1
Logical_t.false_ = 0

---
---@param l integer
---@return boolean
function Logical_t.to_bool(l)
  return l == Logical_t.true_
end

---
---@param b boolean
---@return integer
function Logical_t.from_bool(b)
  if b then
    return Logical_t.true_
  else
    return Logical_t.false_
  end
end

return ffi_.U.oop.make_readonly(Logical_t)
