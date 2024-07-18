local naivecgl = {}

naivecgl.Class = {}
naivecgl.Curve = {}
naivecgl.Geometry = {}
naivecgl.NurbsCurve = {}
naivecgl.NurbsSurface = {}
naivecgl.Object = {}
naivecgl.Surface = {}
naivecgl.Triangulation = {}
naivecgl.enum = {}
naivecgl.geom2dapi = {}
naivecgl.tessellation = {}
naivecgl.util = {}

--------------------------------------------------------------------------------
--                                  FFI                                       --
--------------------------------------------------------------------------------

local ffi = require("ffi")

---@private
---@type ffi.namespace*
naivecgl.NS = nil

---Get absolute/relative path of the library.
---@param theName string The base name of the library.
---@return string
local function get_dylib_path(theName)
  local aPath

  if jit.os == "Windows" then
    aPath = theName .. ".dll"
  elseif jit.os == "Linux" then
    aPath = "lib" .. theName .. ".so"
  else
    error("Unsupported system!")
  end

  if Naivis then
    local ext = Naivis.NaiveApp.ExtensionMgr:Find("naivecgl-nvs")
    if ext and ext:IsValid() then
      aPath = ext:Path() .. "/lib/" .. aPath
    end
  end

  return aPath
end

---@private
function naivecgl:init()
  if self.NS then
    return
  end

  -- NaiveCGL_c_types.h
  ffi.cdef [[
typedef enum {
  Naive_Code_ok = 0,
  Naive_Code_err,
  Naive_Code_not_implemented,
  Naive_Code_initialized = 1000,
  Naive_Code_null_arg_address = 1500,
  Naive_Code_invalid_value,
  Naive_Code_invalid_object,
  Naive_Code_invalid_tag,
  Naive_Code_still_referenced,
  Naive_Code_no_intersection = 2000,
  Naive_Code_points_are_collinear,
  Naive_Code_points_are_coplanar,
  Naive_Code_index_out_of_range,
  Naive_Code_value_out_of_range,
  Naive_Code_insufficient_points,
  Naive_Code_insufficient_knots,
  Naive_Code_zero_interval,
  Naive_Code_periodic_open,
  Naive_Code_periodic_not_smooth,
  Naive_Code_cant_make_nurbs,
  Naive_Code_weight_le_0,
  Naive_Code_bad_knots,
  Naive_Code_poles_weights_not_match,
  Naive_Code_knots_mults_not_match,
  Naive_Code_invalid_mults,
} Naive_Code;

/* Naive_Code_t */

typedef int Naive_Code_t;

/* TYPEDEFS */

typedef int Naive_Body_t;
typedef int Naive_Curve_t;
typedef int Naive_Edge_t;
typedef int Naive_Face_t;
typedef int Naive_Fin_t;
typedef int Naive_Geometry_t;
typedef int Naive_Line_t;
typedef int Naive_Loop_t;
typedef int Naive_Mesh_t;
typedef int Naive_NurbsCurve_t;
typedef int Naive_NurbsSurface_t;
typedef int Naive_Object_t;
typedef int Naive_Plane_t;
typedef int Naive_Shell_t;
typedef int Naive_Solid_t;
typedef int Naive_Surface_t;
typedef int Naive_Transform3d_t;
typedef int Naive_Triangulation_t;
typedef int Naive_Vertex_t;

/* Naive_Logical_t */

typedef unsigned char Naive_Logical_t;

/* Naive_XY_t */

typedef struct Naive_XY_s {
  double x, y;
} Naive_XY_t;

/* Naive_XYZ_t */

typedef struct Naive_XYZ_s {
  double x, y, z;
} Naive_XYZ_t;

/* Naive_Vector2d_t */

typedef Naive_XY_t Naive_Vector2d_t;

/* Naive_Point2d_t */

typedef Naive_XY_t Naive_Point2d_t;

/* Naive_Vector3d_t */

typedef Naive_XYZ_t Naive_Vector3d_t;

/* Naive_Point3d_t */

typedef Naive_XYZ_t Naive_Point3d_t;

/* Naive_Interval_t */

typedef struct Naive_Interval_s {
  double t0, t1;
} Naive_Interval_t;

/* Naive_Triangle_t */

typedef struct Naive_Triangle_s {
  int n0, n1, n2;
} Naive_Triangle_t;

/* Naive_Transform3d_sf_t */

typedef struct Naive_Transform3d_sf_s {
  double matrix[3][4];
} Naive_Transform3d_sf_t;

/* Naive_Axis1_sf_t */

typedef struct Naive_Axis1_sf_s {
  Naive_Point3d_t location;
  Naive_Vector3d_t axis;
} Naive_Axis1_sf_t;

/* Naive_Axis2_sf_t */

typedef struct Naive_Axis2_sf_s {
  Naive_Point3d_t location;
  Naive_Vector3d_t axis;
  Naive_Vector3d_t ref_direction;
} Naive_Axis2_sf_t;

/* Naive_Axis2d_sf_t */

typedef struct Naive_Axis2d_sf_s {
  Naive_Point2d_t location;
  Naive_Vector2d_t axis;
} Naive_Axis2d_sf_t;

/* Naive_Axis22d_sf_t */

typedef struct Naive_Axis22d_sf_s {
  Naive_Point2d_t location;
  Naive_Vector2d_t x_axis;
  Naive_Vector2d_t y_axis;
} Naive_Axis22d_sf_t;

/* Naive_Line_sf_t */

typedef struct Naive_Line_sf_s {
  Naive_Axis1_sf_t basis_set;
} Naive_Line_sf_t;

/* Naive_Circle_sf_t */

typedef struct Naive_Circle_sf_s {
  Naive_Axis2_sf_t basis_set;
  double radius;
} Naive_Circle_sf_t;

/* Naive_Plane_sf_t */

typedef struct Naive_Plane_sf_s {
  Naive_Axis2_sf_t basis_set;
} Naive_Plane_sf_t;

/* Naive_Line2d_sf_t */

typedef struct Naive_Line2d_sf_s {
  Naive_Axis2d_sf_t basis_set;
} Naive_Line2d_sf_t;

/* Naive_Circle2d_sf_t */

typedef struct Naive_Circle2d_sf_s {
  Naive_Axis22d_sf_t basis_set;
  double radius;
} Naive_Circle2d_sf_t;

/* Naive_Class */

typedef enum {
  Naive_Class_null = 0,

  Naive_Class_object,
  Naive_Class_class,

  Naive_Class_geometry2d,
  Naive_Class_point2d,
  Naive_Class_vector2d,
  Naive_Class_curve2d,
  Naive_Class_bounded_curve2d,
  Naive_Class_nurbs_curve2d,
  Naive_Class_trimmed_curve2d,
  Naive_Class_conic2d,
  Naive_Class_circle2d,
  Naive_Class_ellipse2d,
  Naive_Class_hyperbola2d,
  Naive_Class_parabola2d,
  Naive_Class_line2d,
  Naive_Class_offset_curve2d,

  Naive_Class_geometry,
  Naive_Class_point3d,
  Naive_Class_vector3d,
  Naive_Class_transform3d,
  Naive_Class_curve,
  Naive_Class_bounded_curve,
  Naive_Class_nurbs_curve,
  Naive_Class_trimmed_curve,
  Naive_Class_conic,
  Naive_Class_circle,
  Naive_Class_ellipse,
  Naive_Class_hyperbola,
  Naive_Class_parabola,
  Naive_Class_line,
  Naive_Class_offset_curve,
  Naive_Class_surface,
  Naive_Class_bounded_surface,
  Naive_Class_nurbs_surface,
  Naive_Class_rectangular_trimmed_surface,
  Naive_Class_elementary_surface,
  Naive_Class_conical_surface,
  Naive_Class_cylindrical_surface,
  Naive_Class_spherical_surface,
  Naive_Class_toroidal_surface,
  Naive_Class_plane,
  Naive_Class_offset_surface,

  Naive_Class_mesh,
  Naive_Class_triangulation,

  Naive_Class_topol,
  Naive_Class_body,
  Naive_Class_solid,
  Naive_Class_shell,
  Naive_Class_face,
  Naive_Class_loop,
  Naive_Class_fin,
  Naive_Class_edge,
  Naive_Class_vertex,
} Naive_Class;

/* Naive_Class_t */

typedef int Naive_Class_t;

/* Naive_Orientation */

typedef enum {
  Naive_Orientation_forward_c = 0,
  Naive_Orientation_reversed_c,
  Naive_Orientation_internal_c,
  Naive_Orientation_external_c,
} Naive_Orientation;

/* Naive_Orientation_t */

typedef int Naive_Orientation_t;

/* Naive_Algorithm */

typedef enum {
  Naive_Algorithm_quick_hull_c = 0,
  Naive_Algorithm_incremental_c,
  Naive_Algorithm_graham_scan_c,
  Naive_Algorithm_divide_and_conquer_c,
} Naive_Algorithm;

/* Naive_Algorithm_t */

typedef int Naive_Algorithm_t;

/* Naive_Loop_type */

typedef enum {
  Naive_Loop_type_vertex_c = 0,
  Naive_Loop_type_outer_c = 0,
  Naive_Loop_type_inner_c = 0,
} Naive_Loop_type;

/* Naive_Loop_type_t */

typedef int Naive_Loop_type_t;

/* Naive_boolean_function */

typedef enum {
  Naive_boolean_intersect_c = 0,
  Naive_boolean_subtract_c,
  Naive_boolean_unite_c,
} Naive_boolean_function;

/* Naive_boolean_function_t */

typedef int Naive_boolean_function_t;

/* Naive_Body_boolean_o_t */

typedef struct Naive_Body_boolean_o_s {
  Naive_boolean_function_t function;
} Naive_Body_boolean_o_t;
]]

  -- NaiveCGL_c.h
  ffi.cdef [[
/* Naive_Body */

Naive_Code_t Naive_Body_ask_location(
    Naive_Body_t /* body */, Naive_Transform3d_t *const /* location */);

Naive_Code_t Naive_Body_ask_orientation(
    Naive_Body_t /* body */, Naive_Orientation_t *const /* orientation */);

Naive_Code_t Naive_Body_ask_edges(Naive_Body_t /* body */,
                                            int *const /* n_edges */,
                                            Naive_Edge_t *const /* edges */);

Naive_Code_t Naive_Body_ask_faces(Naive_Body_t /* body */,
                                            int *const /* n_faces */,
                                            Naive_Face_t *const /* faces */);

Naive_Code_t Naive_Body_ask_fins(Naive_Body_t /* body */,
                                           int *const /* n_fins */,
                                           Naive_Fin_t *const /* fins */);

Naive_Code_t Naive_Body_ask_loops(Naive_Body_t /* body */,
                                            int *const /* n_loops */,
                                            Naive_Loop_t *const /* loops */);

Naive_Code_t Naive_Body_ask_shells(Naive_Body_t /* body */,
                                             int *const /* n_shells */,
                                             Naive_Shell_t *const /* shells */);

Naive_Code_t
Naive_Body_ask_vertices(Naive_Body_t /* body */, int *const /* n_vertices */,
                        Naive_Vertex_t *const /* vertices */);

Naive_Code_t Naive_Body_boolean(
    Naive_Body_t /* target */, const int /* n_tools */,
    const Naive_Body_t * /* tools */,
    const Naive_Body_boolean_o_t * /* options */
);

/* Naive_Class */

Naive_Code_t Naive_Class_ask_superclass(
    Naive_Class_t /* class */, Naive_Class_t *const /* superclass */);

Naive_Code_t Naive_Class_is_subclass(
    Naive_Class_t /* may_be_subclass */, Naive_Class_t /* class */,
    Naive_Logical_t *const /* is_subclass */);

/* Naive_Curve */

Naive_Code_t Naive_Curve_ask_bound(
    Naive_Curve_t /* curve */, Naive_Interval_t *const /* bound */);

Naive_Code_t
Naive_Curve_evaluate(Naive_Curve_t /* curve */, const double /* t */,
                     const int /* n_derivative */, int *const /* n_result */,
                     Naive_Vector3d_t *const /* result */);

Naive_Code_t
Naive_Curve_curvature_at(Naive_Curve_t /* curve */, const double /* t */,
                         Naive_Vector3d_t *const /* curvature */);

/* Naive_Geom2dAPI */

Naive_Code_t Naive_Geom2dAPI_convex_hull(
    int /* n_points */, const Naive_Point2d_t * /* points */,
    Naive_Algorithm_t /* algo */, int *const /* n_convex_points */,
    int **const /* convex_indices */,
    Naive_Point2d_t **const /* convex_points */);

Naive_Code_t Naive_Geom2dAPI_enclosing_disc(
    const int /* n_points */, const Naive_Point2d_t * /* points */,
    Naive_Point2d_t *const /* origin */, double *const /* radius */);

/* Naive_Geometry */

Naive_Code_t Naive_Geometry_is_valid(
    Naive_Geometry_t /* geometry */, Naive_Logical_t *const /* is_valid */);

Naive_Code_t Naive_Geometry_clone(
    Naive_Geometry_t /* geometry */, Naive_Geometry_t *const /* clone */);

/* Naive_Line */

Naive_Code_t Naive_Line_new(const Naive_Line_sf_t * /* line_sf */,
                                      Naive_Line_t *const /* line */);

/* Naive_Memory */

Naive_Code_t Naive_Memory_free(void * /* pointer */);

/* Naive_NurbsCurve */

Naive_Code_t Naive_NurbsCurve_new(
    const int /* n_poles */, const Naive_Point3d_t * /* poles */,
    const int /* n_weights */, const double * /* weights */,
    const int /* n_knots */, const double * /* knots */,
    const int /* n_mults */, const int * /* mults */, const int /* degree */,
    Naive_NurbsCurve_t *const /* nurbs_curve */);

Naive_Code_t Naive_NurbsCurve_ask_degree(
    Naive_NurbsCurve_t /* nurbs_curve */, int *const /* degree */);

Naive_Code_t Naive_NurbsCurve_ask_poles(
    Naive_NurbsCurve_t /* nurbs_curve */, int *const /* n_poles */,
    Naive_Point3d_t *const /* poles */);

Naive_Code_t Naive_NurbsCurve_ask_weights(
    Naive_NurbsCurve_t /* nurbs_curve */, int *const /* n_weights */,
    double *const /* weights */);

Naive_Code_t
Naive_NurbsCurve_ask_knots(Naive_NurbsCurve_t /* nurbs_curve */,
                           int *const /* n_knots */, double *const /* knots */);

Naive_Code_t
Naive_NurbsCurve_ask_mults(Naive_NurbsCurve_t /* nurbs_curve */,
                           int *const /* n_mults */, int *const /* mults */);

Naive_Code_t Naive_NurbsCurve_increase_degree(
    Naive_NurbsCurve_t /* nurbs_curve */, const int /* degree */);

Naive_Code_t Naive_NurbsCurve_increase_multiplicity(
    Naive_NurbsCurve_t /* nurbs_curve */, const int /* index */,
    const int /* mult */);

Naive_Code_t
Naive_NurbsCurve_insert_knot(Naive_NurbsCurve_t /* nurbs_curve */,
                             const double /* t */, const int /* mult */);

/* Reduces the multiplicity of the knot of index |index| to |mult|. */
Naive_Code_t
Naive_NurbsCurve_remove_knot(Naive_NurbsCurve_t /* nurbs_curve */,
                             const int /* index */, const int /* mult */);

/* Naive_NurbsSurface */

Naive_Code_t Naive_NurbsSurface_new(
    const int /* n_poles_u */, const int /* n_poles_v */,
    const Naive_Point3d_t * /* poles */, const int /* n_weights_u */,
    const int /* n_weights_v */, const double * /* weights */,
    const int /* n_knots_u */, const double * /* knots_u */,
    const int /* n_knots_v */, const double * /* knots_v */,
    const int /* n_mults_u */, const int * /* mults_u */,
    const int /* n_mults_v */, const int * /* mults_v */,
    const int /* degree_u */, const int /* degree_v */,
    Naive_NurbsSurface_t *const /* nurbs_surface */);

Naive_Code_t Naive_NurbsSurface_ask_degree(
    Naive_NurbsSurface_t /* nurbs_surface */, int *const /* degree_u */,
    int *const /* degree_v */);

/* Naive_Object */

Naive_Code_t Naive_Object_ask_class(Naive_Object_t /* object */,
                                              Naive_Class_t *const /* class */);

Naive_Code_t Naive_Object_delete(Naive_Object_t /* object */);

/* Naive_Plane */

Naive_Code_t Naive_Plane_new(const Naive_Plane_sf_t * /* plane_sf */,
                                       Naive_Plane_t *const /* plane */);

Naive_Code_t Naive_Plane_ask(Naive_Plane_t /* plane */,
                                       Naive_Plane_sf_t *const /* plane_sf */);

Naive_Code_t Naive_Plane_distance(Naive_Plane_t /* plane */,
                                            const Naive_Point3d_t * /* point */,
                                            double *const /* distance */);

/* Naive_Triangulation */

Naive_Code_t Naive_Triangulation_new(
    const int /* n_vertices */, const Naive_Point3d_t * /* vertices */,
    const int /* n_triangles */, const Naive_Triangle_t * /* triangles */,
    const int /* i_offset */, Naive_Triangulation_t *const /* triangulation */);

Naive_Code_t
Naive_Triangulation_is_valid(Naive_Triangulation_t /* triangulation */,
                             Naive_Logical_t *const /* is_valid */);

Naive_Code_t
Naive_Triangulation_clone(Naive_Triangulation_t /* triangulation */,
                          Naive_Triangulation_t *const /* clone */);

Naive_Code_t Naive_Triangulation_ask_vertices(
    Naive_Triangulation_t /* triangulation */, int *const /* n_vertices */,
    Naive_Point3d_t *const /* vertices */);

Naive_Code_t Naive_Triangulation_ask_triangles(
    Naive_Triangulation_t /* triangulation */, int *const /* n_triangles */,
    Naive_Triangle_t *const /* triangles */);

/* Naive_Surface */

Naive_Code_t Naive_Surface_evaluate(
    Naive_Surface_t /* surface */, const double /* u */, const double /* v */,
    const int /* n_derivative */, int *const /* n_result */,
    Naive_Vector3d_t *const /* result */);

/* Naive_Tessellation */

Naive_Code_t Naive_Tessellation_make_tetrasphere(
    const Naive_Point3d_t * /* center */, const double /* radius */,
    const int /* level */, Naive_Triangulation_t *const /* triangulation */);
]]

  self.NS = ffi.load(get_dylib_path("NaiveCGL"))

  if not self.NS then
    error("Failed to initialize NaiveCGL")
  end
end

setmetatable(naivecgl.enum, {
  __index = function(_, enum_class)
    return setmetatable({ __ec__ = enum_class }, {
      __index = function(o, enum_name)
        return naivecgl.NS["Naive_" .. o.__ec__ .. "_" .. enum_name]
      end
    })
  end
})

--------------------------------------------------------------------------------
--                                Primitive                                   --
--------------------------------------------------------------------------------

---
---@param object any
---@return ffi.cdata*
local function get_ffi_type(object)
  if type(object) == "table" then
    return object.m_type
  elseif type(object) == "string" then
    return object
  else
    error("Unknown ffi type")
  end
end

---
---@param object any
---@return any
local function get_ffi_data(object)
  if type(object) == "table" then
    return object:data()
  else
    return object
  end
end

---
---@generic T
---@param array2 T[][]
---@return integer
---@return integer
---@return T[]
local function flatten_array2(array2)
  if #array2 == 0 then
    return 0, 0, {}
  end

  local n_u = #array2
  local n_v = #(array2[1])

  local result = {}
  for i = 1, n_u, 1 do
    if #(array2[i]) ~= n_v then
      return 0, 0, {}
    end

    for j = 1, n_v, 1 do
      table.insert(result, array2[i][j])
    end
  end

  return n_u, n_v, result
end

---
---@param tag integer
---@param method string
---@param type_ naivecgl.Array
---@param low? integer
---@return integer code
---@return naivecgl.Array array
local function ask_array(tag, method, type_, low)
  local n_array = ffi.new("int[1]")
  local code = naivecgl.NS[method](tag, n_array, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local array = ffi.new(ffi.typeof(get_ffi_type(type_.m_type) .. "[?]"), n_array[0])
  code = naivecgl.NS[method](tag, n_array, array)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, type_:take(array, n_array[0], low)
end

---@class naivecgl.XY
---@field private m_h ffi.cdata*
---@operator call:naivecgl.XY
naivecgl.XY = { m_type = "Naive_XY_t" }

---@private
naivecgl.XY.__index = naivecgl.XY

---Constructor.
---@param coord_x? number
---@param coord_y? number
---@return naivecgl.XY
function naivecgl.XY.new(coord_x, coord_y)
  return naivecgl.XY.take(ffi.new(naivecgl.XY.m_type, {
    x = coord_x or 0, y = coord_y or 0
  }))
end

setmetatable(naivecgl.XY, {
  __call = function(o, ...)
    return o.new(...)
  end
})

function naivecgl.XY.take(handle)
  local vec = { m_h = handle }
  setmetatable(vec, naivecgl.XY)
  return vec
end

---
---@return number
function naivecgl.XY:x()
  return self.m_h.x
end

---
---@return number
function naivecgl.XY:y()
  return self.m_h.y
end

---
---@return ffi.cdata*
function naivecgl.XY:data()
  return self.m_h
end

---@class naivecgl.XYZ
---@field private m_h ffi.cdata*
---@operator call:naivecgl.XYZ
naivecgl.XYZ = { m_type = "Naive_XYZ_t" }

---@private
naivecgl.XYZ.__index = naivecgl.XYZ

---Constructor.
---@param coord_x? number
---@param coord_y? number
---@param coord_z? number
---@return naivecgl.XYZ
function naivecgl.XYZ.new(coord_x, coord_y, coord_z)
  local handle = ffi.new(naivecgl.XYZ.m_type, {
    x = coord_x or 0, y = coord_y or 0, z = coord_z or 0
  })
  return naivecgl.XYZ.take(handle)
end

setmetatable(naivecgl.XYZ, {
  __call = function(o, ...)
    return o.new(...)
  end
})

---
---@param handle ffi.cdata*
---@return naivecgl.XYZ
function naivecgl.XYZ.take(handle)
  local pnt = { m_h = handle }
  setmetatable(pnt, naivecgl.XYZ)
  return pnt
end

---
---@return number
function naivecgl.XYZ:x()
  return self.m_h.x
end

---
---@return number
function naivecgl.XYZ:y()
  return self.m_h.y
end

---
---@return number
function naivecgl.XYZ:z()
  return self.m_h.z
end

---
---@return ffi.cdata*
function naivecgl.XYZ:data()
  return self.m_h
end

function naivecgl.XYZ:magnitude()
  return math.sqrt(self:x() ^ 2 + self:y() ^ 2 + self:z() ^ 2)
end

---@class naivecgl.Triangle
---@field private m_h ffi.cdata*
---@operator call:naivecgl.XYZ
naivecgl.Triangle = { m_type = "Naive_Triangle_t" }

---@private
naivecgl.Triangle.__index = naivecgl.Triangle

---
---@param n0? integer
---@param n1? integer
---@param n2? integer
---@return naivecgl.Triangle
function naivecgl.Triangle.new(n0, n1, n2)
  local handle = ffi.new(naivecgl.Triangle.m_type, {
    n0 = n0 or 0, n1 = n1 or 0, z = n2 or 0
  })
  return naivecgl.Triangle.take(handle)
end

setmetatable(naivecgl.Triangle, {
  __call = function(o, ...)
    return o.new(...)
  end
})

---
---@param handle ffi.cdata*
---@return naivecgl.Triangle
function naivecgl.Triangle.take(handle)
  local tri = { m_h = handle }
  setmetatable(tri, naivecgl.Triangle)
  return tri
end

---
---@return integer
function naivecgl.Triangle:n0()
  return self.m_h.n0
end

---
---@return number
function naivecgl.Triangle:n1()
  return self.m_h.n1
end

---
---@return number
function naivecgl.Triangle:n2()
  return self.m_h.n2
end

---
---@return ffi.cdata*
function naivecgl.Triangle:data()
  return self.m_h
end

--------------------------------------------------------------------------------
--                               Collections                                  --
--------------------------------------------------------------------------------

---
---@class naivecgl.Array<T>
---@field private m_type any
---@field private m_h ffi.cdata*
---@field private m_size integer
---@field private m_low integer
naivecgl.Array = {}

---@private
naivecgl.Array.__index = naivecgl.Array

---Constructor.
---@generic T
---@param list T[]
---@param low? integer
---@return naivecgl.Array
function naivecgl.Array:new(list, low)
  local size = #list
  local handle = ffi.new(ffi.typeof(get_ffi_type(self.m_type) .. "[?]"), size)
  for i = 1, size do
    handle[i - 1] = get_ffi_data(list[i])
  end
  return self:take(handle, size, low)
end

---
---@param handle ffi.cdata*?
---@param size integer
---@param low? integer
---@return naivecgl.Array
function naivecgl.Array:take(handle, size, low)
  local arr = { m_h = handle, m_size = size, m_low = low or 1 }
  setmetatable(arr, self)
  return arr
end

---
---@return integer
function naivecgl.Array:size()
  return self.m_size
end

---
---@return integer
function naivecgl.Array:lower()
  return self.m_low
end

---
---@return integer
function naivecgl.Array:upper()
  return self.m_low + self.m_size - 1
end

---
---@return ffi.cdata*
function naivecgl.Array:data()
  return self.m_h
end

---
---@generic T
---@param index integer
---@return T
function naivecgl.Array:value(index)
  if index < self:lower() or index > self:upper() then
    error("Out of range")
  end
  if type(self.m_type) == "table" then
    return self.m_type.take(self.m_h[index - self.m_low])
  else
    return self.m_h[index - self.m_low]
  end
end

function naivecgl.Array:unset()
  return self:take(nil, 0)
end

---
---@param type_ table|string
local function array_instantiate(type_)
  local arr = { m_type = type_ }
  setmetatable(arr, naivecgl.Array)
  arr.__index = arr
  return arr
end

---@class naivecgl.ArrayInt32 : naivecgl.Array<integer>
naivecgl.ArrayInt32 = array_instantiate("int")

---@class naivecgl.ArrayDouble : naivecgl.Array<number>
naivecgl.ArrayDouble = array_instantiate("double")

---@class naivecgl.ArrayXY : naivecgl.Array<naivecgl.XY>
naivecgl.ArrayXY = array_instantiate(naivecgl.XY)

---@class naivecgl.ArrayXYZ : naivecgl.Array<naivecgl.XYZ>
naivecgl.ArrayXYZ = array_instantiate(naivecgl.XYZ)

---@class naivecgl.ArrayTriangle : naivecgl.Array<naivecgl.Triangle>
naivecgl.ArrayTriangle = array_instantiate(naivecgl.Triangle)

--------------------------------------------------------------------------------
--                                Naive_Class                                 --
--------------------------------------------------------------------------------

---
---@param class integer
---@return integer code
---@return integer superclass
function naivecgl.Class.ask_superclass(class)
  local superclass = ffi.new("Naive_Class_t[1]", 0)
  return naivecgl.NS.Naive_Class_ask_superclass(class, superclass), superclass[0]
end

---
---@param may_be_subclass integer
---@param class integer
---@return integer code
---@return boolean is_subclass
function naivecgl.Class.is_subclass(may_be_subclass, class)
  local is_subclass = ffi.new("Naive_Logical_t[1]", 0)
  return naivecgl.NS.Naive_Class_is_subclass(may_be_subclass, class, is_subclass), is_subclass[0] == 1
end

--------------------------------------------------------------------------------
--                                Naive_Curve                                 --
--------------------------------------------------------------------------------

---
---@param curve integer
---@return integer code
---@return number t0
---@return number t1
function naivecgl.Curve.ask_bound(curve)
  local aBound = ffi.new("Naive_Interval_t", { 0, 0 })
  return naivecgl.NS.Naive_Curve_ask_bound(curve, aBound), aBound.t0, aBound.t1
end

---
---@param curve integer
---@param t number
---@param n_derivative integer
---@return integer code
---@return naivecgl.ArrayXYZ result
function naivecgl.Curve.evaluate(curve, t, n_derivative)
  local n_result = ffi.new("int[1]", 0)
  local code = naivecgl.NS.Naive_Curve_evaluate(curve, t, n_derivative, n_result, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local result = ffi.new("Naive_Vector3d_t[?]", n_result[0])
  code = naivecgl.NS.Naive_Curve_evaluate(curve, t, n_derivative, n_result, result)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, naivecgl.ArrayXYZ:take(result, n_result[0])
end

---
---@param curve integer
---@param t number
---@return integer code
---@return naivecgl.XYZ curvature
function naivecgl.Curve.curvature_at(curve, t)
  local curvature = ffi.new("Naive_Vector3d_t", { 0, 0, 0 })
  return naivecgl.NS.Naive_Curve_curvature_at(curve, t, curvature), naivecgl.XYZ.take(curvature)
end

--------------------------------------------------------------------------------
--                              Naive_Geometry                                --
--------------------------------------------------------------------------------

---comment
---@param geometry integer
---@return integer code
---@return integer clone
function naivecgl.Geometry.clone(geometry)
  local clone = ffi.new("Naive_Geometry_t[1]", 0)
  return naivecgl.NS.Naive_Geometry_clone(geometry, clone), clone[0]
end

---comment
---@param geometry integer
---@return integer code
---@return boolean is_valid
function naivecgl.Geometry.is_valid(geometry)
  local is_valid = ffi.new("Naive_Logical_t[1]", 0)
  return naivecgl.NS.Naive_Geometry_is_valid(geometry, is_valid), is_valid[0] == 1
end

--------------------------------------------------------------------------------
--                             Naive_NurbsCurve                               --
--------------------------------------------------------------------------------

---
---@param poles naivecgl.XYZ[]
---@param weights number[]
---@param knots number[]
---@param mults integer[]
---@param degree integer
---@return integer code
---@return integer nurbs_curve
function naivecgl.NurbsCurve.new(poles, weights, knots, mults, degree)
  local aPoles = naivecgl.ArrayXYZ:new(poles)
  local aWeights = naivecgl.ArrayDouble:new(weights)
  local aKnots = naivecgl.ArrayDouble:new(knots)
  local aMults = naivecgl.ArrayInt32:new(mults)
  local nurbs_curve = ffi.new("Naive_NurbsCurve_t[1]", 0)
  return naivecgl.NS.Naive_NurbsCurve_new(
    aPoles:size(), aPoles:data(), aWeights:size(), aWeights:data(),
    aKnots:size(), aKnots:data(), aMults:size(), aMults:data(),
    degree, nurbs_curve), nurbs_curve[0]
end

---
---@param nurbs_curve integer
---@return integer code
---@return integer degree
function naivecgl.NurbsCurve.ask_degree(nurbs_curve)
  local degree = ffi.new("int[1]")
  return naivecgl.NS.Naive_NurbsCurve_ask_degree(nurbs_curve, degree), degree[0]
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.ArrayXYZ poles
function naivecgl.NurbsCurve.ask_poles(nurbs_curve)
  return ask_array(nurbs_curve, "Naive_NurbsCurve_ask_poles", naivecgl.ArrayXYZ)
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.ArrayDouble weights
function naivecgl.NurbsCurve.ask_weights(nurbs_curve)
  return ask_array(nurbs_curve, "Naive_NurbsCurve_ask_weights", naivecgl.ArrayDouble)
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.ArrayDouble
function naivecgl.NurbsCurve.ask_knots(nurbs_curve)
  return ask_array(nurbs_curve, "Naive_NurbsCurve_ask_knots", naivecgl.ArrayDouble)
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.ArrayInt32 mults
function naivecgl.NurbsCurve.ask_mults(nurbs_curve)
  return ask_array(nurbs_curve, "Naive_NurbsCurve_ask_mults", naivecgl.ArrayInt32)
end

---
---@param nurbs_curve integer
---@param index integer
---@param mult integer
---@return integer code
function naivecgl.NurbsCurve.increase_multiplicity(nurbs_curve, index, mult)
  return naivecgl.NS.Naive_NurbsCurve_increase_multiplicity(nurbs_curve, index, mult)
end

---
---@param nurbs_curve integer
---@param t number
---@param mult integer
---@return integer code
function naivecgl.NurbsCurve.insert_knot(nurbs_curve, t, mult)
  return naivecgl.NS.Naive_NurbsCurve_insert_knot(nurbs_curve, t, mult)
end

--------------------------------------------------------------------------------
--                            Naive_NurbsSurface                              --
--------------------------------------------------------------------------------

---
---@param poles naivecgl.XYZ[][]
---@param weights number[][]
---@param knots_u number[]
---@param knots_v number[]
---@param mults_u integer[]
---@param mults_v integer[]
---@param degree_u integer
---@param degree_v integer
---@return integer code
---@return integer nurbs_surface
function naivecgl.NurbsSurface.new(poles, weights, knots_u, knots_v, mults_u, mults_v, degree_u, degree_v)
  local nbUP, nbVP, aFlatPoles = flatten_array2(poles)
  local aPoles = naivecgl.ArrayXYZ:new(aFlatPoles)
  local nbUW, nbVW, aFlatWeights = flatten_array2(weights)
  local aWeights = naivecgl.ArrayDouble:new(aFlatWeights)
  local aUKnots = naivecgl.ArrayDouble:new(knots_u)
  local aVKnots = naivecgl.ArrayDouble:new(knots_v)
  local aUMults = naivecgl.ArrayInt32:new(mults_u)
  local aVMults = naivecgl.ArrayInt32:new(mults_v)
  local nurbs_surface = ffi.new("Naive_NurbsSurface_t[1]", 0)
  return naivecgl.NS.Naive_NurbsSurface_new(
    nbUP, nbVP, aPoles:data(),
    nbUW, nbVW, aWeights:data(),
    aUKnots:size(), aUKnots:data(), aVKnots:size(), aVKnots:data(),
    aUMults:size(), aUMults:data(), aVMults:size(), aVMults:data(),
    degree_u, degree_v, nurbs_surface), nurbs_surface[0]
end

--------------------------------------------------------------------------------
--                               Naive_Object                                 --
--------------------------------------------------------------------------------

---
---@param object integer
---@return integer code
---@return integer class
function naivecgl.Object.ask_class(object)
  local class = ffi.new("Naive_Class_t[1]", 0)
  return naivecgl.NS.Naive_Object_ask_class(object, class), class[0]
end

---
---@param object integer
---@return integer code
function naivecgl.Object.delete(object)
  return naivecgl.NS.Naive_Object_delete(object)
end

--------------------------------------------------------------------------------
--                            Naive_Surface                                   --
--------------------------------------------------------------------------------

---
---@param surface integer
---@param u number
---@param v number
---@param n_derivative integer
---@return integer code
---@return naivecgl.ArrayXYZ result
function naivecgl.Surface.evaluate(surface, u, v, n_derivative)
  local n_result = ffi.new("int[1]", 0)
  local code = naivecgl.NS.Naive_Surface_evaluate(surface, u, v, n_derivative, n_result, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local result = ffi.new("Naive_Vector3d_t[?]", n_result[0])
  code = naivecgl.NS.Naive_Surface_evaluate(surface, u, v, n_derivative, n_result, result)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, naivecgl.ArrayXYZ:take(result, n_result[0])
end

--------------------------------------------------------------------------------
--                            Naive_Triangulation                             --
--------------------------------------------------------------------------------

---Constructor.
---@param vertices naivecgl.XYZ[]
---@param triangles naivecgl.Triangle[]
---@return integer code
---@return integer triangulation
function naivecgl.Triangulation.new(vertices, triangles)
  local aVerts = naivecgl.ArrayXYZ:new(vertices)
  local aTris = naivecgl.ArrayTriangle:new(triangles)
  local triangulation = ffi.new("Naive_Triangulation_t[1]", 0)
  return naivecgl.NS.Naive_Triangulation_new(aVerts:size(), aVerts, aTris:size(), aTris, 1, triangulation),
      triangulation[0]
end

---
---@param triangulation integer
---@return integer code
---@return naivecgl.ArrayXYZ
function naivecgl.Triangulation.ask_vertices(triangulation)
  return ask_array(triangulation, "Naive_Triangulation_ask_vertices", naivecgl.ArrayXYZ, 0)
end

---
---@return integer code
---@return naivecgl.ArrayTriangle triangles
function naivecgl.Triangulation.ask_triangles(triangulation)
  return ask_array(triangulation, "Naive_Triangulation_ask_triangles", naivecgl.ArrayTriangle, 0)
end

--------------------------------------------------------------------------------
--                           naivecgl::geom2dapi                              --
--------------------------------------------------------------------------------

---
---@param points naivecgl.XY[]
---@param algo? any
---@return integer code
---@return integer[] convex_indices
function naivecgl.geom2dapi.convex_hull(points, algo)
  local point_array = naivecgl.ArrayXY:new(points)
  local n_convex_points = ffi.new("int[1]")
  local convex_indices = ffi.new("int*[1]")
  local code = naivecgl.NS.Naive_Geom2dAPI_convex_hull(point_array:size(), point_array:data(),
    algo or naivecgl.NS.Naive_Algorithm_quick_hull_c, n_convex_points, convex_indices, nil)

  local result = {}
  if code == naivecgl.NS.Naive_Code_ok then
    for i = 1, n_convex_points[0] do
      result[i] = convex_indices[0][i - 1] + 1
    end
  end

  naivecgl.NS.Naive_Memory_free(convex_indices[0])
  return code, result
end

---
---@param points naivecgl.XY[]
---@return integer code
---@return naivecgl.XY origin
---@return number radius
function naivecgl.geom2dapi.enclosing_disc(points)
  local aPoints = naivecgl.ArrayXY:new(points)
  local o = ffi.new("Naive_Point2d_t")
  local r = ffi.new("double[1]", 0)
  return naivecgl.NS.Naive_Geom2dAPI_enclosing_disc(aPoints:size(), aPoints:data(), o, r),
      naivecgl.XY.take(o), r[0]
end

--------------------------------------------------------------------------------
--                        naivecgl::tessellation                              --
--------------------------------------------------------------------------------

---Calculates the tetrasphere with a tessellation level.
---@param center naivecgl.XYZ
---@param radius number
---@param level integer
---@return integer code
---@return integer triangulation
function naivecgl.tessellation.make_tetrasphere(center, radius, level)
  local triangulation = ffi.new("Naive_Triangulation_t[1]", 0)
  return naivecgl.NS.Naive_Tessellation_make_tetrasphere(center:data(), radius, level, triangulation), triangulation[0]
end

--------------------------------------------------------------------------------
--                                 Utility                                    --
--------------------------------------------------------------------------------

---
---@generic T
---@param code integer
---@param ... T
---@return T
function naivecgl.util.unwrap(code, ...)
  if code ~= naivecgl.NS.Naive_Code_ok then
    error(code)
  end
  return ...
end

--------------------------------------------------------------------------------
--                                 Export                                     --
--------------------------------------------------------------------------------

naivecgl:init()

return naivecgl
