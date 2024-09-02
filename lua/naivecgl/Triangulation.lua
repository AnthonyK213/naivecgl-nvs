local common_ = require("naivecgl.common_")
local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local Object = require("naivecgl.Object")

local Triangulation = {}

---0-indexed.
---@return integer code
---@return Naive.Array.Triangle_t triangles
function Triangulation.ask_triangles(triangulation)
  return common_.ask_array(triangulation, "Naive_Triangulation_ask_triangles", Array.Triangle_t, 0)
end

---0-indexed.
---@param triangulation integer
---@return integer code
---@return Naive.Array.XYZ_t
function Triangulation.ask_vertices(triangulation)
  return common_.ask_array(triangulation, "Naive_Triangulation_ask_vertices", Array.XYZ_t, 0)
end

---Constructor.
---@param vertices Naive.XYZ_t[]
---@param triangles Naive.Triangle_t[]
---@return integer code
---@return integer triangulation
function Triangulation.create(vertices, triangles)
  local aVerts = Array.XYZ_t:new(vertices)
  local aTris = Array.Triangle_t:new(triangles)
  local triangulation = ffi_.F.new("Naive_Triangulation_t[1]", Object.null)
  return ffi_.NS.Naive_Triangulation_create(aVerts:size(), aVerts, aTris:size(), aTris, 1, triangulation),
      triangulation[0]
end

return ffi_.U.oop.make_readonly(Triangulation)
