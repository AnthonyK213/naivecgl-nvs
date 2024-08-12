local ArrayTriangle = require("naivecgl.ArrayTriangle")
local ArrayXYZ = require("naivecgl.ArrayXYZ")
local common_ = require("naivecgl.common_")
local ffi_ = require("naivecgl.ffi_")

local Triangulation = {}

---0-indexed.
---@return integer code
---@return naivecgl.ArrayTriangle triangles
function Triangulation.ask_triangles(triangulation)
  return common_.ask_array(triangulation, "Naive_Triangulation_ask_triangles", ArrayTriangle, 0)
end

---0-indexed.
---@param triangulation integer
---@return integer code
---@return naivecgl.ArrayXYZ
function Triangulation.ask_vertices(triangulation)
  return common_.ask_array(triangulation, "Naive_Triangulation_ask_vertices", ArrayXYZ, 0)
end

---Constructor.
---@param vertices Naive.XYZ_t[]
---@param triangles Naive.Triangle_t[]
---@return integer code
---@return integer triangulation
function Triangulation.create(vertices, triangles)
  local aVerts = ArrayXYZ:new(vertices)
  local aTris = ArrayTriangle:new(triangles)
  local triangulation = ffi_.F.new("Naive_Triangulation_t[1]", 0)
  return ffi_.NS.Naive_Triangulation_create(aVerts:size(), aVerts, aTris:size(), aTris, 1, triangulation),
      triangulation[0]
end

return ffi_.U.oop.make_readonly(Triangulation)
