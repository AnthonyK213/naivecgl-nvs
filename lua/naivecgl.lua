local naivecgl = {}

naivecgl.Naive_Object = {}
naivecgl.Naive_Geometry = {}
naivecgl.Naive_Curve = {}
naivecgl.Naive_BoundedCurve = {}
naivecgl.Naive_NurbsCurve = {}
naivecgl.Naive_Surface = {}
naivecgl.Naive_NurbsSurface = {}
naivecgl.Naive_Poly = {}
naivecgl.enum = {}
naivecgl.geom2dapi = {}
naivecgl.tessellation = {}

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
/* Naive_Code */

typedef enum {
  Naive_Code_ok = 0,
  Naive_Code_err,
  Naive_Code_not_implemented,
  Naive_Code_initialized = 1000,
  Naive_Code_null_arg_address = 1500,
  Naive_Code_invalid_value,
  Naive_Code_invalid_object,
  Naive_Code_invalid_tag,
  Naive_Code_no_intersection,
  Naive_Code_points_are_collinear = 2000,
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
typedef int Naive_NurbsCurve_t;
typedef int Naive_NurbsSurface_t;
typedef int Naive_Object_t;
typedef int Naive_Plane_t;
typedef int Naive_Poly_t;
typedef int Naive_Shell_t;
typedef int Naive_Solid_t;
typedef int Naive_Surface_t;
typedef int Naive_Transform3d_t;
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
  Naive_Class_body = 0,
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
  Naive_Algorithm_quick_hull = 0,
  Naive_Algorithm_incremental,
  Naive_Algorithm_graham_scan,
  Naive_Algorithm_divide_and_conquer,
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

Naive_Code_t Naive_Object_delete(Naive_Object_t /* object */);

/* Naive_Plane */

Naive_Code_t Naive_Plane_new(const Naive_Plane_sf_t * /* plane_sf */,
                                       Naive_Plane_t *const /* plane */);

Naive_Code_t Naive_Plane_ask(Naive_Plane_t /* plane */,
                                       Naive_Plane_sf_t *const /* plane_sf */);

Naive_Code_t Naive_Plane_distance(Naive_Plane_t /* plane */,
                                            const Naive_Point3d_t * /* point */,
                                            double *const /* distance */);

/* Naive_Poly */

Naive_Code_t Naive_Poly_new(const int /* n_vertices */,
                                      const Naive_Point3d_t * /* vertices */,
                                      const int /* n_triangles */,
                                      const Naive_Triangle_t * /* triangles */,
                                      Naive_Poly_t *const /* poly */);

Naive_Code_t Naive_Poly_is_valid(
    Naive_Poly_t /* poly */, Naive_Logical_t *const /* is_valid */);

Naive_Code_t Naive_Poly_clone(Naive_Poly_t /* poly */,
                                        Naive_Poly_t *const /* clone */);

Naive_Code_t
Naive_Poly_ask_vertices(Naive_Poly_t /* poly */, int *const /* n_vertices */,
                        Naive_Point3d_t *const /* vertices */);

Naive_Code_t
Naive_Poly_ask_triangles(Naive_Poly_t /* poly */, int *const /* n_triangles */,
                         Naive_Triangle_t *const /* triangles */);

/* Naive_Surface */

Naive_Code_t Naive_Surface_evaluate(
    Naive_Surface_t /* surface */, const double /* u */, const double /* v */,
    const int /* n_derivative */, int *const /* n_result */,
    Naive_Vector3d_t *const /* result */);

/* Naive_Tessellation */

Naive_Code_t Naive_Tessellation_make_tetrasphere(
    const Naive_Point3d_t * /* center */, const double /* radius */,
    const int /* level */, Naive_Poly_t *const /* poly */);
]]

  self.NS = ffi.load(get_dylib_path("NaiveCGL"))

  if not self.NS then
    error("Failed to initialize NaiveCGL")
  end
end

setmetatable(naivecgl.enum, {
  __index = function(_, e)
    return naivecgl.NS[e]
  end
})

--------------------------------------------------------------------------------
--                                Primitive                                   --
--------------------------------------------------------------------------------

---
---@param theObj any
---@return ffi.cdata*
local function get_ffi_type(theObj)
  if type(theObj) == "table" then
    return theObj.myType
  elseif type(theObj) == "string" then
    return theObj
  else
    error("Unknown ffi type")
  end
end

---
---@param theObj any
---@return any
local function get_ffi_data(theObj)
  if type(theObj) == "table" then
    return theObj:data()
  else
    return theObj
  end
end

local function check_code(theCode)
  if theCode and theCode ~= naivecgl.NS.Naive_Code_ok then
    error(theCode)
  end
end

---
---@generic T
---@param theArr2 T[][]
---@return integer
---@return integer
---@return T[]
local function flatten_array2(theArr2)
  if #theArr2 == 0 then
    return 0, 0, {}
  end

  local nbU = #theArr2
  local nbV = #(theArr2[1])

  local aRes = {}
  for i = 1, nbU, 1 do
    if #(theArr2[i]) ~= nbV then
      return 0, 0, {}
    end

    for j = 1, nbV, 1 do
      table.insert(aRes, theArr2[i][j])
    end
  end

  return nbU, nbV, aRes
end

---@class naivecgl.Naive_XY
---@field private myH ffi.cdata*
---@operator call:naivecgl.Naive_XY
naivecgl.Naive_XY = { myType = "Naive_XY_t" }

---@private
naivecgl.Naive_XY.__index = naivecgl.Naive_XY

---Constructor.
---@param theX number?
---@param theY number?
---@return naivecgl.Naive_XY
function naivecgl.Naive_XY.new(theX, theY)
  return naivecgl.Naive_XY.take(ffi.new(naivecgl.Naive_XY.myType, {
    x = theX or 0, y = theY or 0
  }))
end

setmetatable(naivecgl.Naive_XY, {
  __call = function(o, ...)
    return o.new(...)
  end
})

function naivecgl.Naive_XY.take(theH)
  local vec = { myH = theH }
  setmetatable(vec, naivecgl.Naive_XY)
  return vec
end

---
---@return number
function naivecgl.Naive_XY:x()
  return self.myH.x
end

---
---@return number
function naivecgl.Naive_XY:y()
  return self.myH.y
end

---
---@return ffi.cdata*
function naivecgl.Naive_XY:data()
  return self.myH
end

---@class naivecgl.Naive_XYZ
---@field private myH ffi.cdata*
---@operator call:naivecgl.Naive_XYZ
naivecgl.Naive_XYZ = { myType = "Naive_XYZ_t" }

---@private
naivecgl.Naive_XYZ.__index = naivecgl.Naive_XYZ

---Constructor.
---@param theX number?
---@param theY number?
---@param theZ number?
---@return naivecgl.Naive_XYZ
function naivecgl.Naive_XYZ.new(theX, theY, theZ)
  local aH = ffi.new(naivecgl.Naive_XYZ.myType, {
    x = theX or 0, y = theY or 0, z = theZ or 0
  })
  return naivecgl.Naive_XYZ.take(aH)
end

setmetatable(naivecgl.Naive_XYZ, {
  __call = function(o, ...)
    return o.new(...)
  end
})

---
---@param theH ffi.cdata*
---@return naivecgl.Naive_XYZ
function naivecgl.Naive_XYZ.take(theH)
  local pnt = { myH = theH }
  setmetatable(pnt, naivecgl.Naive_XYZ)
  return pnt
end

---
---@return number
function naivecgl.Naive_XYZ:x()
  return self.myH.x
end

---
---@return number
function naivecgl.Naive_XYZ:y()
  return self.myH.y
end

---
---@return number
function naivecgl.Naive_XYZ:z()
  return self.myH.z
end

---
---@return ffi.cdata*
function naivecgl.Naive_XYZ:data()
  return self.myH
end

function naivecgl.Naive_XYZ:magnitude()
  return math.sqrt(self:x() ^ 2 + self:y() ^ 2 + self:z() ^ 2)
end

--------------------------------------------------------------------------------
--                               Collections                                  --
--------------------------------------------------------------------------------

---1-indexed
---@class naivecgl.Naive_Array<T>
---@field private myType any
---@field private myH ffi.cdata*
---@field private mySize integer
naivecgl.Naive_Array = {}

---@private
naivecgl.Naive_Array.__index = naivecgl.Naive_Array

---Constructor.
---@generic T
---@param theList T[]
---@return naivecgl.Naive_Array
function naivecgl.Naive_Array:new(theList)
  local aSize = #theList
  local aH = ffi.new(ffi.typeof(get_ffi_type(self.myType) .. "[?]"), aSize)
  for i = 1, aSize do
    aH[i - 1] = get_ffi_data(theList[i])
  end
  return self:take(aH, aSize)
end

---
---@param theH ffi.cdata*?
---@param theSize integer
---@return naivecgl.Naive_Array
function naivecgl.Naive_Array:take(theH, theSize)
  local arr = { myH = theH, mySize = theH == nil and 0 or theSize }
  setmetatable(arr, self)
  return arr
end

---
---@return integer
function naivecgl.Naive_Array:size()
  return self.mySize
end

---
---@return ffi.cdata*
function naivecgl.Naive_Array:data()
  return self.myH
end

---
---@generic T
---@param theIndex integer
---@return T
function naivecgl.Naive_Array:value(theIndex)
  if theIndex < 1 or theIndex > self.mySize then
    error("Out of range")
  end
  if type(self.myType) == "table" then
    return self.myType.take(self.myH[theIndex - 1])
  else
    return self.myH[theIndex - 1]
  end
end

function naivecgl.Naive_Array:unset()
  return self:take(nil, 0)
end

---
---@param theType table|string
local function array_instantiate(theType)
  local arr = { myType = theType }
  setmetatable(arr, naivecgl.Naive_Array)
  arr.__index = arr
  return arr
end

---@class naivecgl.Naive_Int32Array : naivecgl.Naive_Array<integer>
naivecgl.Naive_Int32Array = array_instantiate("int")

---@class naivecgl.Naive_DoubleArray : naivecgl.Naive_Array<number>
naivecgl.Naive_DoubleArray = array_instantiate("double")

---@class naivecgl.Naive_XYArray : naivecgl.Naive_Array<naivecgl.Naive_XY>
naivecgl.Naive_XYArray = array_instantiate(naivecgl.Naive_XY)

---@class naivecgl.Naive_XYZArray : naivecgl.Naive_Array<naivecgl.Naive_XYZ>
naivecgl.Naive_XYZArray = array_instantiate(naivecgl.Naive_XYZ)

--------------------------------------------------------------------------------
--                                Naive_Curve                                 --
--------------------------------------------------------------------------------

---
---@param curve integer
---@return integer code
---@return number t0
---@return number t1
function naivecgl.Naive_Curve.ask_bound(curve)
  local aBound = ffi.new("Naive_Interval_t", { 0, 0 })
  return naivecgl.NS.Naive_Curve_ask_bound(curve, aBound), aBound.t0, aBound.t1
end

---
---@param curve integer
---@param t number
---@param n_derivative integer
---@return integer code
---@return naivecgl.Naive_XYZArray result
function naivecgl.Naive_Curve.evaluate(curve, t, n_derivative)
  local n_result = ffi.new("int[1]", 0)
  local code = naivecgl.NS.Naive_Curve_evaluate(curve, t, n_derivative, n_result, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local result = ffi.new("Naive_Vector3d_t[?]", n_result[0])
  code = naivecgl.NS.Naive_Curve_evaluate(curve, t, n_derivative, n_result, result)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, naivecgl.Naive_XYZArray:take(result, n_result[0])
end

---
---@param curve integer
---@param t number
---@return integer code
---@return naivecgl.Naive_XYZ curvature
function naivecgl.Naive_Curve.curvature_at(curve, t)
  local curvature = ffi.new("Naive_Vector3d_t", { 0, 0, 0 })
  return naivecgl.NS.Naive_Curve_curvature_at(curve, t, curvature), naivecgl.Naive_XYZ.take(curvature)
end

--------------------------------------------------------------------------------
--                              Naive_Geometry                                --
--------------------------------------------------------------------------------

---comment
---@param geometry integer
---@return integer code
---@return integer clone
function naivecgl.Naive_Geometry.clone(geometry)
  local aClone = ffi.new("Naive_Geometry_t[1]", 0)
  return naivecgl.NS.Naive_Geometry_clone(geometry, aClone), aClone[0]
end

---comment
---@param geometry integer
---@return integer code
---@return boolean is_valid
function naivecgl.Naive_Geometry.is_valid(geometry)
  local aRes = ffi.new("Naive_Logical_t[1]", 0)
  return naivecgl.NS.Naive_Geometry_is_valid(geometry, aRes), aRes[0] == 1
end

--------------------------------------------------------------------------------
--                             Naive_NurbsCurve                               --
--------------------------------------------------------------------------------

---
---@param pole naivecgl.Naive_XYZ[]
---@param weight number[]
---@param knots number[]
---@param mults integer[]
---@param degree integer
---@return integer code
---@return integer nurbs_curve
function naivecgl.Naive_NurbsCurve.new(pole, weight, knots, mults, degree)
  local aPoles = naivecgl.Naive_XYZArray:new(pole)
  local aWeights = naivecgl.Naive_DoubleArray:new(weight)
  local aKnots = naivecgl.Naive_DoubleArray:new(knots)
  local aMults = naivecgl.Naive_Int32Array:new(mults)
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
function naivecgl.Naive_NurbsCurve.ask_degree(nurbs_curve)
  local degree = ffi.new("int[1]")
  return naivecgl.NS.Naive_NurbsCurve_ask_degree(nurbs_curve, degree), degree[0]
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.Naive_XYZArray poles
function naivecgl.Naive_NurbsCurve.ask_poles(nurbs_curve)
  local n_poles = ffi.new("int[1]")
  local code = naivecgl.NS.Naive_NurbsCurve_ask_poles(nurbs_curve, n_poles, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local poles = ffi.new("Naive_Point3d_t[?]", n_poles[0])
  code = naivecgl.NS.Naive_NurbsCurve_ask_poles(nurbs_curve, n_poles, poles)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, naivecgl.Naive_XYZArray:take(poles, n_poles[0])
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.Naive_DoubleArray weights
function naivecgl.Naive_NurbsCurve.ask_weights(nurbs_curve)
  local n_weights = ffi.new("int[1]")
  local code = naivecgl.NS.Naive_NurbsCurve_ask_weights(nurbs_curve, n_weights, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local weights = ffi.new("double[?]", n_weights[0])
  code = naivecgl.NS.Naive_NurbsCurve_ask_weights(nurbs_curve, n_weights, weights)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, naivecgl.Naive_DoubleArray:take(weights, n_weights[0])
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.Naive_DoubleArray
function naivecgl.Naive_NurbsCurve.ask_knots(nurbs_curve)
  local n_knots = ffi.new("int[1]")
  local code = naivecgl.NS.Naive_NurbsCurve_ask_knots(nurbs_curve, n_knots, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local knots = ffi.new("double[?]", n_knots[0])
  code = naivecgl.NS.Naive_NurbsCurve_ask_knots(nurbs_curve, n_knots, knots)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, naivecgl.Naive_DoubleArray:take(knots, n_knots[0])
end

---
---@param nurbs_curve integer
---@return integer code
---@return naivecgl.Naive_Int32Array mults
function naivecgl.Naive_NurbsCurve.ask_mults(nurbs_curve)
  local n_mults = ffi.new("int[1]")
  local code = naivecgl.NS.Naive_NurbsCurve_ask_mults(nurbs_curve, n_mults, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local mults = ffi.new("double[?]", n_mults[0])
  code = naivecgl.NS.Naive_NurbsCurve_ask_mults(nurbs_curve, n_mults, mults)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, naivecgl.Naive_Int32Array:take(mults, n_mults[0])
end

---
---@param nurbs_curve integer
---@param index integer
---@param mult integer
---@return integer code
function naivecgl.Naive_NurbsCurve.increase_multiplicity(nurbs_curve, index, mult)
  return naivecgl.NS.Naive_NurbsCurve_increase_multiplicity(nurbs_curve, index, mult)
end

---
---@param nurbs_curve integer
---@param t number
---@param mult integer
---@return integer code
function naivecgl.Naive_NurbsCurve.insert_knot(nurbs_curve, t, mult)
  return naivecgl.NS.Naive_NurbsCurve_insert_knot(nurbs_curve, t, mult)
end

--------------------------------------------------------------------------------
--                            Naive_NurbsSurface                              --
--------------------------------------------------------------------------------

---
---@param poles naivecgl.Naive_XYZ[][]
---@param weights number[][]
---@param knots_u number[]
---@param knots_v number[]
---@param mults_u integer[]
---@param mults_v integer[]
---@param degree_u integer
---@param degree_v integer
---@return integer code
---@return integer nurbs_surface
function naivecgl.Naive_NurbsSurface.new(poles, weights, knots_u, knots_v, mults_u, mults_v, degree_u, degree_v)
  local nbUP, nbVP, aFlatPoles = flatten_array2(poles)
  local aPoles = naivecgl.Naive_XYZArray:new(aFlatPoles)
  local nbUW, nbVW, aFlatWeights = flatten_array2(weights)
  local aWeights = naivecgl.Naive_DoubleArray:new(aFlatWeights)
  local aUKnots = naivecgl.Naive_DoubleArray:new(knots_u)
  local aVKnots = naivecgl.Naive_DoubleArray:new(knots_v)
  local aUMults = naivecgl.Naive_Int32Array:new(mults_u)
  local aVMults = naivecgl.Naive_Int32Array:new(mults_v)
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
function naivecgl.Naive_Object.delete(object)
  return naivecgl.NS.Naive_Object_delete(object)
end

--------------------------------------------------------------------------------
--                               Naive_Poly                                   --
--------------------------------------------------------------------------------

---Constructor.
---@param vertices naivecgl.Naive_XYZ[]
---@param triangles integer[][] 1-indexed
---@return integer code
---@return integer poly
function naivecgl.Naive_Poly.new(vertices, triangles)
  local aVerts = naivecgl.Naive_XYZArray:new(vertices)

  local nbTris = #triangles
  local aTris = ffi.new("Naive_Triangle_t[?]", nbTris)
  for i = 1, nbTris do
    aTris[i - 1].n0 = triangles[i][1] - 1
    aTris[i - 1].n1 = triangles[i][2] - 1
    aTris[i - 1].n2 = triangles[i][3] - 1
  end

  local poly = ffi.new("Naive_Poly_t[1]", 0)
  return naivecgl.NS.Naive_Poly_new(aVerts:size(), aVerts, nbTris, aTris, poly), poly[0]
end

---
---@param poly integer
---@return integer code
---@return naivecgl.Naive_XYZArray
function naivecgl.Naive_Poly.ask_vertices(poly)
  local n_vertices = ffi.new("int[1]")
  local code = naivecgl.NS.Naive_Poly_ask_vertices(poly, n_vertices, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local vertices = ffi.new("Naive_Point3d_t[?]", n_vertices[0])
  code = naivecgl.NS.Naive_Poly_ask_vertices(poly, n_vertices, vertices)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, naivecgl.Naive_XYZArray:take(vertices, n_vertices[0])
end

---Triangles (1-indexed).
---@return integer code
---@return integer[][] triangles
function naivecgl.Naive_Poly.ask_triangles(poly)
  local n_triangles = ffi.new("int[1]")
  local code = naivecgl.NS.Naive_Poly_ask_triangles(poly, n_triangles, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local triangles = ffi.new("Naive_Triangle_t[?]", n_triangles[0])
  code = naivecgl.NS.Naive_Poly_ask_triangles(poly, n_triangles, triangles)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end

  local result = {}
  for i = 1, n_triangles[0] do
    result[i] = {
      triangles[i - 1].n0 + 1,
      triangles[i - 1].n1 + 1,
      triangles[i - 1].n2 + 1,
    }
  end

  return code, result
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
---@return naivecgl.Naive_XYZArray result
function naivecgl.Naive_Surface.evaluate(surface, u, v, n_derivative)
  local n_result = ffi.new("int[1]", 0)
  local code = naivecgl.NS.Naive_Surface_evaluate(surface, u, v, n_derivative, n_result, nil)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  local result = ffi.new("Naive_Vector3d_t[?]", n_result[0])
  code = naivecgl.NS.Naive_Surface_evaluate(surface, u, v, n_derivative, n_result, result)
  if code ~= naivecgl.NS.Naive_Code_ok then return code end
  return code, naivecgl.Naive_XYZArray:take(result, n_result[0])
end

--------------------------------------------------------------------------------
--                           naivecgl::geom2dapi                              --
--------------------------------------------------------------------------------

---
---@param points naivecgl.Naive_XY[]
---@param algo? any
---@return integer code
---@return integer[] convex_indices
function naivecgl.geom2dapi.convex_hull(points, algo)
  algo = algo or naivecgl.NS.Naive_Algorithm_quick_hull
  local aPoints = naivecgl.Naive_XYArray:new(points)
  local n_convex_points = ffi.new("int[1]")
  local convex_indices = ffi.new("int*[1]")
  local code = naivecgl.NS.Naive_Geom2dAPI_convex_hull(aPoints:size(), aPoints:data(), algo,
    n_convex_points, convex_indices, nil)

  local ci = {}
  if code == naivecgl.NS.Naive_Code_ok then
    for i = 1, n_convex_points[0] do
      ci[i] = convex_indices[0][i - 1] + 1
    end
  end

  naivecgl.NS.Naive_Memory_free(convex_indices[0])
  return code, ci
end

---
---@param points naivecgl.Naive_XY[]
---@return integer code
---@return naivecgl.Naive_XY origin
---@return number radius
function naivecgl.geom2dapi.enclosing_disc(points)
  local aPoints = naivecgl.Naive_XYArray:new(points)
  local o = ffi.new("Naive_Point2d_t")
  local r = ffi.new("double[1]", 0)
  return naivecgl.NS.Naive_Geom2dAPI_enclosing_disc(aPoints:size(), aPoints:data(), o, r),
      naivecgl.Naive_XY.take(o), r[0]
end

--------------------------------------------------------------------------------
--                        naivecgl::tessellation                              --
--------------------------------------------------------------------------------

---Calculates the tetrasphere with a tessellation level.
---@param center naivecgl.Naive_XYZ
---@param radius number
---@param level integer
---@return integer code
---@return integer poly
function naivecgl.tessellation.make_tetrasphere(center, radius, level)
  local poly = ffi.new("Naive_Poly_t[1]")
  return naivecgl.NS.Naive_Tessellation_make_tetrasphere(center:data(), radius, level, poly), poly[0]
end

--------------------------------------------------------------------------------
--                                 Export                                     --
--------------------------------------------------------------------------------

naivecgl:init()

return naivecgl
