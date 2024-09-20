local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local Object = require("naivecgl.Object")
local Point_sf_t = require("naivecgl.Point_sf_t")

local Vertex = {}

--- This function returns the point at the given vertex, if one exists, otherwise Naive.Object.null.
---@param vertex integer An vertex.
---@return integer code
---@return integer point Its point (possibly Naive.Object.null).
function Vertex.ask_point(vertex)
  local point = ffi_.F.new("Naive_Point_t[1]", Object.null)
  return ffi_.NS.Naive_Vertex_ask_point(vertex, point), point[0]
end

---This function attaches points to vertices.
---@param vertices Naive.Array.Int32|integer[] Vertices to have points attached.
---@param points Naive.Array.Int32|integer[] Points to be attached to vertices.
---@return integer code Code.
function Vertex.attach_points(vertices, points)
  if vertices:size() ~= points:size() then
    return ffi_.NS.Naive_Code_err --[[@as integer]]
  end
  return ffi_.NS.Naive_Vertex_attach_points(vertices:size(), ffi_.U.oop.get_data(vertices), ffi_.U.oop.get_data(points))
end

return ffi_.U.oop.make_readonly(Vertex)
