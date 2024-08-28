local common_ = require("naivecgl.common_")
local ffi_ = require("naivecgl.ffi_")

local ArrayInt32 = require("ffi_util.array.ArrayInt32")
local Object = require("naivecgl.Object")

local Body = {}

---@class Naive.Body.boolean_o_t
---@operator call:Naive.Body.boolean_o_t
Body.boolean_o_t = ffi_.U.oop.def_class("Naive_Body_boolean_o_t", {
  ctor = ffi_.U.oop.def_ctor {
    ["function"] = ffi_.NS.Naive_boolean_unite_c,
  }
})

---
---@param field "function"
---@param value any
function Body.boolean_o_t:set(field, value)
  ffi_.U.oop.set_field(self.m_data, field, value)
end

---
---@param body integer
---@return integer code
---@return ffi_util.array.ArrayInt32 edges
function Body.ask_edges(body)
  return common_.ask_array(body, "Naive_Body_ask_edges", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return ffi_util.array.ArrayInt32 faces
function Body.ask_faces(body)
  return common_.ask_array(body, "Naive_Body_ask_faces", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return ffi_util.array.ArrayInt32 fins
function Body.ask_fins(body)
  return common_.ask_array(body, "Naive_Body_ask_fins", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return ffi_util.array.ArrayInt32 loops
function Body.ask_loops(body)
  return common_.ask_array(body, "Naive_Body_ask_loops", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return ffi_util.array.ArrayInt32 shells
function Body.ask_shells(body)
  return common_.ask_array(body, "Naive_Body_ask_shells", ArrayInt32)
end

---
---@param body integer
---@return integer code
---@return ffi_util.array.ArrayInt32 vertices
function Body.ask_vertices(body)
  return common_.ask_array(body, "Naive_Body_ask_vertices", ArrayInt32)
end

---
---@param target integer
---@param tools integer[]|ffi_util.array.ArrayInt32
---@param options Naive.Body.boolean_o_t
---@return integer code
function Body.boolean(target, tools, options)
  local tool_arr = ArrayInt32:new(tools)
  return ffi_.NS.Naive_Body_boolean(target, tool_arr:size(), tool_arr:data(), ffi_.U.oop.get_data(options))
end

---
---@param x number
---@param y number
---@param z number
---@param basis_set Naive.Ax2_sf_t
---@return integer code
---@return integer body
function Body.create_solid_block(x, y, z, basis_set)
  local body = ffi_.F.new("Naive_Body_t[1]", Object.null)
  return ffi_.NS.Naive_Body_create_solid_block(x, y, z, ffi_.U.oop.get_data(basis_set), body), body[0]
end

return ffi_.U.oop.make_readonly(Body)
