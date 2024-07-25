local ArrayInt32 = require("naivecgl.ArrayInt32")
local common_ = require("naivecgl.common_")
local ffi_ = require("naivecgl.ffi_")

local Body = {}

---
---@param body integer
---@return integer code
---@return naivecgl.ArrayInt32 edges
function Body.ask_edges(body)
  return common_.ask_array(body, "Naive_Body_ask_edges", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return naivecgl.ArrayInt32 faces
function Body.ask_faces(body)
  return common_.ask_array(body, "Naive_Body_ask_faces", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return naivecgl.ArrayInt32 fins
function Body.ask_fins(body)
  return common_.ask_array(body, "Naive_Body_ask_fins", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return naivecgl.ArrayInt32 loops
function Body.ask_loops(body)
  return common_.ask_array(body, "Naive_Body_ask_loops", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return naivecgl.ArrayInt32 shells
function Body.ask_shells(body)
  return common_.ask_array(body, "Naive_Body_ask_shells", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return naivecgl.ArrayInt32 vertices
function Body.ask_vertices(body)
  return common_.ask_array(body, "Naive_Body_ask_vertices", ArrayInt32)
end

return Body
