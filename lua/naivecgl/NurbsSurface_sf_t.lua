local ffi_ = require("naivecgl.ffi_")

local Logical_t = require("naivecgl.Logical_t")

local ArrayDouble = ffi_.U.array.ArrayDouble
local ArrayInt32 = ffi_.U.array.ArrayInt32

---@class Naive.NurbsSurface_sf_t
---@field private m_data any
---@field private _vertex ffi_util.array.ArrayDouble
---@field private _u_knot_mult ffi_util.array.ArrayInt32
---@field private _v_knot_mult ffi_util.array.ArrayInt32
---@field private _u_knot ffi_util.array.ArrayDouble
---@field private _v_knot ffi_util.array.ArrayDouble
---@operator call:Naive.NurbsSurface_sf_t
local NurbsSurface_sf_t = ffi_.U.oop.def_class("Naive_NurbsSurface_sf_t", {
  ctor = ffi_.U.oop.def_ctor {
    u_degree = 0,
    v_degree = 0,
    n_u_vertices = 0,
    n_v_vertices = 0,
    vertex_dim = 0,
    is_rational = Logical_t.false_,
    vertex = nil,
    form = ffi_.NS.Naive_NurbsSurface_form_unset_c,
    n_u_knots = 0,
    n_v_knots = 0,
    u_knot_mult = nil,
    v_knot_mult = nil,
    u_knot = nil,
    v_knot = nil,
    is_u_periodic = Logical_t.false_,
    is_v_periodic = Logical_t.false_,
    is_u_closed = Logical_t.false_,
    is_v_closed = Logical_t.false_,
  }
})

---
---@return integer
function NurbsSurface_sf_t:get_u_degree()
  return self.m_data.u_degree
end

---
---@return integer
function NurbsSurface_sf_t:get_v_degree()
  return self.m_data.v_degree
end

---
---@return integer
function NurbsSurface_sf_t:get_vertex_dim()
  return self.m_data.vertex_dim
end

---
---@return boolean
function NurbsSurface_sf_t:get_is_rational()
  return Logical_t.to_bool(self.m_data.is_rational)
end

---
---@return ffi_util.array.ArrayDouble
---@return integer
---@return integer
function NurbsSurface_sf_t:get_vertex()
  local n_u_vertices = self.m_data.n_u_vertices
  local n_v_vertices = self.m_data.n_v_vertices
  return self._vertex, n_u_vertices, n_v_vertices
end

---
---@return integer
function NurbsSurface_sf_t:get_form()
  return self.m_data.form
end

---
---@return ffi_util.array.ArrayInt32
function NurbsSurface_sf_t:get_u_knot_mult()
  return self._u_knot_mult
end

---
---@return ffi_util.array.ArrayInt32
function NurbsSurface_sf_t:get_v_knot_mult()
  return self._v_knot_mult
end

---
---@return ffi_util.array.ArrayDouble
function NurbsSurface_sf_t:get_u_knot()
  return self._u_knot
end

---
---@return ffi_util.array.ArrayDouble
function NurbsSurface_sf_t:get_v_knot()
  return self._v_knot
end

---
---@return boolean
function NurbsSurface_sf_t:get_is_u_periodic()
  return Logical_t.to_bool(self.m_data.is_u_periodic)
end

---
---@return boolean
function NurbsSurface_sf_t:get_is_v_periodic()
  return Logical_t.to_bool(self.m_data.is_v_periodic)
end

---
---@return boolean
function NurbsSurface_sf_t:get_is_u_closed()
  return Logical_t.to_bool(self.m_data.is_u_closed)
end

---
---@return boolean
function NurbsSurface_sf_t:get_is_v_closed()
  return Logical_t.to_bool(self.m_data.is_v_closed)
end

---
---@param value integer
function NurbsSurface_sf_t:set_u_degree(value)
  self.m_data.u_degree = value
end

---
---@param value integer
function NurbsSurface_sf_t:set_v_degree(value)
  self.m_data.v_degree = value
end

---
---@param value integer
function NurbsSurface_sf_t:set_vertex_dim(value)
  self.m_data.vertex_dim = value
end

---
---@param value boolean
function NurbsSurface_sf_t:set_is_rational(value)
  self.m_data.is_rational = Logical_t.from_bool(value)
end

---
---@param value number[]|ffi_util.array.ArrayDouble
---@param n_u_vertices integer
---@param n_v_vertices integer
function NurbsSurface_sf_t:set_vertex(value, n_u_vertices, n_v_vertices)
  self._vertex = ArrayDouble:new(value)
  self.m_data.n_u_vertices = n_u_vertices
  self.m_data.n_v_vertices = n_v_vertices
  self.m_data.vertex = self._vertex:data()
end

---
---@param value integer
function NurbsSurface_sf_t:set_form(value)
  self.m_data.form = value
end

---
---@param value integer[]|ffi_util.array.ArrayInt32
function NurbsSurface_sf_t:set_u_knot_mult(value)
  self._u_knot_mult = ArrayInt32:new(value)
  self.m_data.u_knot_mult = self._u_knot_mult:data()
end

---
---@param value integer[]|ffi_util.array.ArrayInt32
function NurbsSurface_sf_t:set_v_knot_mult(value)
  self._v_knot_mult = ArrayInt32:new(value)
  self.m_data.v_knot_mult = self._v_knot_mult:data()
end

---
---@param value number[]|ffi_util.array.ArrayDouble
function NurbsSurface_sf_t:set_u_knot(value)
  self._u_knot = ArrayDouble:new(value)
  self.m_data.n_u_knots = self._u_knot:size()
  self.m_data.u_knot = self._u_knot:data()
end

---
---@param value number[]|ffi_util.array.ArrayDouble
function NurbsSurface_sf_t:set_v_knot(value)
  self._v_knot = ArrayDouble:new(value)
  self.m_data.n_v_knots = self._v_knot:size()
  self.m_data.v_knot = self._v_knot:data()
end

---
---@param value boolean
function NurbsSurface_sf_t:set_is_u_periodic(value)
  self.m_data.is_u_periodic = Logical_t.from_bool(value)
end

---
---@param value boolean
function NurbsSurface_sf_t:set_is_v_periodic(value)
  self.m_data.is_v_periodic = Logical_t.from_bool(value)
end

---
---@param value boolean
function NurbsSurface_sf_t:set_is_u_closed(value)
  self.m_data.is_u_closed = Logical_t.from_bool(value)
end

---
---@param value boolean
function NurbsSurface_sf_t:set_is_v_closed(value)
  self.m_data.is_v_closed = Logical_t.from_bool(value)
end

---@private
---
---@return Naive.NurbsSurface_sf_t
function NurbsSurface_sf_t:update_cache()
  local n_vertices = self.m_data.n_u_vertices * self.m_data.n_v_vertices / self.m_data.vertex_dim
  local options = { free = ffi_.NS.Naive_Memory_free }
  self._vertex = ArrayDouble:take(self.m_data.vertex, n_vertices, options)
  self._u_knot_mult = ArrayInt32:take(self.m_data.u_knot_mult, self.m_data.n_u_knots, options)
  self._v_knot_mult = ArrayInt32:take(self.m_data.v_knot_mult, self.m_data.n_v_knots, options)
  self._u_knot = ArrayDouble:take(self.m_data.u_knot, self.m_data.n_u_knots, options)
  self._v_knot = ArrayDouble:take(self.m_data.v_knot, self.m_data.n_v_knots, options)
  return self
end

return NurbsSurface_sf_t
