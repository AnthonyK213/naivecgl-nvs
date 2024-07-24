local ffi = require("ffi")
local naivecgl_ffi = require("naivecgl_ffi")

local tessellation = {}

---Calculates the tetrasphere with a tessellation level.
---@param center naivecgl.XYZ
---@param radius number
---@param level integer
---@return integer code
---@return integer triangulation
function tessellation.make_tetrasphere(center, radius, level)
  local triangulation = ffi.new("Naive_Triangulation_t[1]", 0)
  return naivecgl_ffi.NS.Naive_Tessellation_make_tetrasphere(center:data(), radius, level, triangulation),
      triangulation[0]
end

return tessellation
