local ffi_ = require("naivecgl.ffi_")

local Array = require("naivecgl.Array")
local Object = require("naivecgl.Object")

local Edge = {}

---This function returns the vertices bounding the given edge.
---@param edge integer An edge.
---@return integer code
---@return integer[] vertices Vertices (possibly both Naive.Object.null).
function Edge.ask_vertices(edge)
  local vertices = ffi_.F.new("Naive_Vertex_t[2]", { Object.null, Object.null })
  return ffi_.NS.Naive_Edge_ask_vertices(edge, vertices), { vertices[0], vertices[1] }
end

return ffi_.U.oop.make_readonly(Edge)
