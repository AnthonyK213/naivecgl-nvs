local ffi_ = require("naivecgl.ffi_")

local Tessellation = {}

---Calculates the tetrasphere with a tessellation level.
---@param center Naive.XYZ_t
---@param radius number
---@param level integer
---@return integer code
---@return integer triangulation
function Tessellation.make_tetrasphere(center, radius, level)
  local triangulation = ffi_.F.new("Naive_Triangulation_t[1]", 0)
  return ffi_.NS.Naive_Tessellation_make_tetrasphere(ffi_.U.oop.get_data(center), radius, level, triangulation),
      triangulation[0]
end

return ffi_.U.oop.make_readonly(Tessellation)
