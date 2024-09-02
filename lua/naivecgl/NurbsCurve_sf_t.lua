local ffi_ = require("naivecgl.ffi_")

local Logical_t = require("naivecgl.Logical_t")

local Array = require("naivecgl.Array")

---@class Naive.NurbsCurve_sf_t
---@field private m_data any
---@field private _vertex Naive.Array.Double
---@field private _knot Naive.Array.Double
---@field private _knot_mult Naive.Array.Int32
---@operator call:Naive.NurbsCurve_sf_t
local NurbsCurve_sf_t = ffi_.U.oop.def_class("Naive_NurbsCurve_sf_t", {
  ctor = ffi_.U.oop.def_ctor {
    degree = 0,
    n_vertices = 0,
    vertex_dim = 0,
    is_rational = Logical_t.false_,
    vertex = nil,
    form = ffi_.NS.Naive_NurbsCurve_form_unset_c,
    n_knots = 0,
    knot_mult = nil,
    knot = nil,
    is_periodic = Logical_t.false_,
    is_closed = Logical_t.false_,
  }
})

---
---@return integer
function NurbsCurve_sf_t:get_degree()
  return self.m_data.degree
end

---
---@return integer
function NurbsCurve_sf_t:get_vertex_dim()
  return self.m_data.vertex_dim
end

---
---@return boolean
function NurbsCurve_sf_t:get_is_rational()
  return Logical_t.to_bool(self.m_data.is_rational)
end

---
---@return Naive.Array.Double
function NurbsCurve_sf_t:get_vertex()
  return self._vertex
end

---
---@return integer
function NurbsCurve_sf_t:get_form()
  return self.m_data.form
end

---
---@return Naive.Array.Int32
function NurbsCurve_sf_t:get_knot_mult()
  return self._knot_mult
end

---
---@return Naive.Array.Double
function NurbsCurve_sf_t:get_knot()
  return self._knot
end

---
---@return boolean
function NurbsCurve_sf_t:get_is_periodic()
  return Logical_t.to_bool(self.m_data.is_periodic)
end

---
---@return boolean
function NurbsCurve_sf_t:get_is_closed()
  return Logical_t.to_bool(self.m_data.is_closed)
end

---
---@param value integer
function NurbsCurve_sf_t:set_degree(value)
  self.m_data.degree = value
end

---
---@param value integer
function NurbsCurve_sf_t:set_vertex_dim(value)
  self.m_data.vertex_dim = value
end

---
---@param value boolean
function NurbsCurve_sf_t:set_is_rational(value)
  self.m_data.is_rational = Logical_t.from_bool(value)
end

---
---@param value number[]|Naive.Array.Double
function NurbsCurve_sf_t:set_vertex(value)
  self._vertex = Array.Double:new(value)
  self.m_data.n_vertices = self._vertex:size()
  self.m_data.vertex = self._vertex:data()
end

---
---@param value integer
function NurbsCurve_sf_t:set_form(value)
  self.m_data.form = value
end

---
---@param value integer[]|Naive.Array.Int32
function NurbsCurve_sf_t:set_knot_mult(value)
  self._knot_mult = Array.Int32:new(value)
  self.m_data.knot_mult = self._knot_mult:data()
end

---
---@param value number[]|Naive.Array.Double
function NurbsCurve_sf_t:set_knot(value)
  self._knot = Array.Double:new(value)
  self.m_data.n_knots = self._knot:size()
  self.m_data.knot = self._knot:data()
end

---
---@param value boolean
function NurbsCurve_sf_t:set_is_periodic(value)
  self.m_data.is_periodic = Logical_t.from_bool(value)
end

---
---@param value boolean
function NurbsCurve_sf_t:set_is_closed(value)
  self.m_data.is_closed = Logical_t.from_bool(value)
end

---@private
---
---@return Naive.NurbsCurve_sf_t self
function NurbsCurve_sf_t:update_cache()
  local options = { free = ffi_.NS.Naive_Memory_free }
  self._vertex = Array.Double:take(self.m_data.vertex, self.m_data.n_vertices, options)
  self._knot = Array.Double:take(self.m_data.knot, self.m_data.n_knots, options)
  self._knot_mult = Array.Int32:take(self.m_data.knot_mult, self.m_data.n_knots, options)
  return self
end

return NurbsCurve_sf_t
