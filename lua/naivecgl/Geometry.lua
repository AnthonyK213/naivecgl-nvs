local ffi_ = require("naivecgl.ffi_")

local Logical_t = require("naivecgl.Logical_t")
local Object = require("naivecgl.Object")

local Geometry = {}

---comment
---@param geometry integer
---@return integer code
---@return integer clone
function Geometry.clone(geometry)
  local clone = ffi_.F.new("Naive_Geometry_t[1]", Object.null)
  return ffi_.NS.Naive_Geometry_clone(geometry, clone), clone[0]
end

---comment
---@param geometry integer
---@return integer code
---@return boolean is_valid
function Geometry.is_valid(geometry)
  local is_valid = ffi_.F.new("Naive_Logical_t[1]", Logical_t.false_)
  return ffi_.NS.Naive_Geometry_is_valid(geometry, is_valid), is_valid[0] == Logical_t.true_
end

return ffi_.U.oop.make_readonly(Geometry)
