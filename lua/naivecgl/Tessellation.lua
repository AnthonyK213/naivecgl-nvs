local ffi_ = require("naivecgl.ffi_")

local Object = require("naivecgl.Object")

local Tessellation = {}

---This function creates a triangulated sphere with tetrahedral pattern.
---@param center Naive.XYZ_t Center of the sphere.
---@param radius number Radius of the sphere.
---@param level integer Tessellation level.
---@return integer code Code.
---@return integer triangulation The tetrsphere.
function Tessellation.create_tetrasphere(center, radius, level)
  local triangulation = ffi_.F.new("Naive_Triangulation_t[1]", Object.null)
  return ffi_.NS.Naive_Tessellation_create_tetrasphere(ffi_.U.oop.get_data(center), radius, level, triangulation),
      triangulation[0]
end

return ffi_.U.oop.make_readonly(Tessellation)
