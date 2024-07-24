local ffi = require("ffi")
local naivecgl_ffi = require("naivecgl_ffi")

local Geometry = {}

---comment
---@param geometry integer
---@return integer code
---@return integer clone
function Geometry.clone(geometry)
  local clone = ffi.new("Naive_Geometry_t[1]", 0)
  return naivecgl_ffi.NS.Naive_Geometry_clone(geometry, clone), clone[0]
end

---comment
---@param geometry integer
---@return integer code
---@return boolean is_valid
function Geometry.is_valid(geometry)
  local is_valid = ffi.new("Naive_Logical_t[1]", 0)
  return naivecgl_ffi.NS.Naive_Geometry_is_valid(geometry, is_valid), is_valid[0] == 1
end

return Geometry
