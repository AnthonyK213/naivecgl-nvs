local ffi_ = require("naivecgl.ffi_")

local Geometry = {}

---comment
---@param geometry integer
---@return integer code
---@return integer clone
function Geometry.clone(geometry)
  local clone = ffi_.F.new("Naive_Geometry_t[1]", 0)
  return ffi_.NS.Naive_Geometry_clone(geometry, clone), clone[0]
end

---comment
---@param geometry integer
---@return integer code
---@return boolean is_valid
function Geometry.is_valid(geometry)
  local is_valid = ffi_.F.new("Naive_Logical_t[1]", 0)
  return ffi_.NS.Naive_Geometry_is_valid(geometry, is_valid), is_valid[0] == 1
end

return ffi_.U.oop.make_readonly(Geometry)
