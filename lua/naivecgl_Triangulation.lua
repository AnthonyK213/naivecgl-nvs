local ArrayTriangle = require("naivecgl_ArrayTriangle")
local ArrayXYZ = require("naivecgl_ArrayXYZ")
local ffi = require("ffi")
local naivecgl_common = require("naivecgl_common")
local naivecgl_ffi = require("naivecgl_ffi")

local Triangulation = {}

---0-indexed.
---@return integer code
---@return naivecgl.ArrayTriangle triangles
function Triangulation.ask_triangles(triangulation)
  return naivecgl_common.ask_array(triangulation, "Naive_Triangulation_ask_triangles", ArrayTriangle, 0)
end

---0-indexed.
---@param triangulation integer
---@return integer code
---@return naivecgl.ArrayXYZ
function Triangulation.ask_vertices(triangulation)
  return naivecgl_common.ask_array(triangulation, "Naive_Triangulation_ask_vertices", ArrayXYZ, 0)
end

---Constructor.
---@param vertices naivecgl.XYZ[]
---@param triangles naivecgl.Triangle[]
---@return integer code
---@return integer triangulation
function Triangulation.create(vertices, triangles)
  local aVerts = ArrayXYZ:new(vertices)
  local aTris = ArrayTriangle:new(triangles)
  local triangulation = ffi.new("Naive_Triangulation_t[1]", 0)
  return naivecgl_ffi.NS.Naive_Triangulation_create(aVerts:size(), aVerts, aTris:size(), aTris, 1, triangulation),
      triangulation[0]
end

return Triangulation
