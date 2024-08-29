local ffi_ = require("naivecgl.ffi_")

local Logical_t = require("naivecgl.Logical_t")

local ArrayDouble = ffi_.U.array.ArrayDouble
local ArrayInt32 = ffi_.U.array.ArrayInt32

---@class Naive.NurbsCurve_sf_t
---@field private _vertex ffi_util.array.ArrayDouble
---@field private _knot ffi_util.array.ArrayDouble
---@field private _knot_mult ffi_util.array.ArrayInt32
---@operator call:Naive.NurbsCurve_sf_t
local NurbsCurve_sf_t = ffi_.U.oop.def_class("Naive_NurbsCurve_sf_t", {
  ctor = ffi_.U.oop.def_ctor {
    degree = 3,
    n_vertices = 0,
    vertex_dim = 3,
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
  return ffi_.U.oop.get_field(self.m_data, "degree")
end

---
---@return integer
function NurbsCurve_sf_t:get_vertex_dim()
  return ffi_.U.oop.get_field(self.m_data, "vertex_dim")
end

---
---@return ffi_util.array.ArrayDouble
function NurbsCurve_sf_t:get_vertex()
  return self._vertex
end

---
---@return ffi_util.array.ArrayDouble
function NurbsCurve_sf_t:get_knot()
  return self._knot
end

---
---@return ffi_util.array.ArrayInt32
function NurbsCurve_sf_t:get_knot_mult()
  return self._knot_mult
end

---
---@return boolean
function NurbsCurve_sf_t:get_is_periodic()
  return Logical_t.to_bool(ffi_.U.oop.get_field(self.m_data, "is_periodic"))
end

---
---@return boolean
function NurbsCurve_sf_t:get_is_closed()
  return Logical_t.to_bool(ffi_.U.oop.get_field(self.m_data, "is_closed"))
end

---
---@param value integer
function NurbsCurve_sf_t:set_degree(value)
  ffi_.U.oop.set_field(self.m_data, "degree", value)
end

---
---@param value integer
function NurbsCurve_sf_t:set_vertex_dim(value)
  ffi_.U.oop.set_field(self.m_data, "vertex_dim", value)
end

---
---@param value boolean
function NurbsCurve_sf_t:set_is_rational(value)
  ffi_.U.oop.set_field(self.m_data, "is_rational", Logical_t.from_bool(value))
end

---
---@param value number[]|ffi_util.array.ArrayDouble
function NurbsCurve_sf_t:set_vertex(value)
  self._vertex = ArrayDouble:new(value)
  ffi_.U.oop.set_field(self.m_data, "n_vertices", self._vertex:size())
  ffi_.U.oop.set_field(self.m_data, "vertex", self._vertex:data())
end

---
---@param value number[]|ffi_util.array.ArrayDouble
function NurbsCurve_sf_t:set_knot(value)
  self._knot = ArrayDouble:new(value)
  ffi_.U.oop.set_field(self.m_data, "n_knots", self._knot:size())
  ffi_.U.oop.set_field(self.m_data, "knot", self._knot:data())
end

---
---@param value integer[]|ffi_util.array.ArrayInt32
function NurbsCurve_sf_t:set_knot_mult(value)
  self._knot_mult = ArrayInt32:new(value)
  ffi_.U.oop.set_field(self.m_data, "knot_mult", self._knot_mult:data())
end

---@private
---
---@return Naive.NurbsCurve_sf_t self
function NurbsCurve_sf_t:init_cache()
  self._vertex = ArrayDouble:take(self.m_data.vertex, self.m_data.n_vertices, {
    free = ffi_.NS.Naive_Memory_free
  })
  self._knot = ArrayDouble:take(self.m_data.knot, self.m_data.n_knots, {
    free = ffi_.NS.Naive_Memory_free
  })
  self._knot_mult = ArrayInt32:take(self.m_data.knot_mult, self.m_data.n_knots, {
    free = ffi_.NS.Naive_Memory_free
  })
  return self
end

return NurbsCurve_sf_t
