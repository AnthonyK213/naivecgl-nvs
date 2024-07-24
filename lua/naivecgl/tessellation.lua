local ffi_ = require("naivecgl.ffi_")

local tessellation = {}

---Calculates the tetrasphere with a tessellation level.
---@param center naivecgl.XYZ
---@param radius number
---@param level integer
---@return integer code
---@return integer triangulation
function tessellation.make_tetrasphere(center, radius, level)
  local triangulation = ffi_.new("Naive_Triangulation_t[1]", 0)
  return ffi_.NS.Naive_Tessellation_make_tetrasphere(center:data(), radius, level, triangulation),
      triangulation[0]
end

return tessellation
