local naivecgl = {}
naivecgl.geom2dapi = {}
naivecgl.tessellation = {}

--------------------------------------------------------------------------------
--                                  FFI                                       --
--------------------------------------------------------------------------------

local ffi = require("ffi")

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
--                            Naive_NurbsCurve                                --
--------------------------------------------------------------------------------

---@class naivecgl.Naive_NurbsCurve
---@field private myH integer
naivecgl.Naive_NurbsCurve = {}

---@private
naivecgl.Naive_NurbsCurve.__index = naivecgl.Naive_NurbsCurve

---Constructor.
---@param thePoles naivecgl.Naive_XYZ[]
---@param theWeights number[]
---@param theKnots number[]
---@param theMults integer[]
---@param theDegree integer
---@return naivecgl.Naive_NurbsCurve
function naivecgl.Naive_NurbsCurve.new(thePoles, theWeights, theKnots, theMults, theDegree)
  local aPoles = naivecgl.Naive_XYZArray:new(thePoles)
  local aWeights = naivecgl.Naive_DoubleArray:new(theWeights)
  local aKnots = naivecgl.Naive_DoubleArray:new(theKnots)
  local aMults = naivecgl.Naive_Int32Array:new(theMults)

  local aH = ffi.new("Naive_NurbsCurve_t[1]")
  check_code(naivecgl.NS.Naive_NurbsCurve_new(
    aPoles:size(), aPoles:data(), aWeights:size(), aWeights:data(),
    aKnots:size(), aKnots:data(), aMults:size(), aMults:data(),
    theDegree, aH))

  local nurbsCurve = { myH = aH[0] }
  setmetatable(nurbsCurve, naivecgl.Naive_NurbsCurve)
  return nurbsCurve
end

---
---@return integer
function naivecgl.Naive_NurbsCurve:ask_degree()
  local aDegree = ffi.new("int[1]")
  check_code(naivecgl.NS.Naive_NurbsCurve_ask_degree(self.myH, aDegree))
  return aDegree[0]
end

---
---@return naivecgl.Naive_XYZArray
function naivecgl.Naive_NurbsCurve:ask_poles()
  local nbPoles = ffi.new("int[1]")
  check_code(naivecgl.NS.Naive_NurbsCurve_ask_poles(self.myH, nbPoles, nil))
  local aP = ffi.new("Naive_Point3d_t[?]", nbPoles[0])
  check_code(naivecgl.NS.Naive_NurbsCurve_ask_poles(self.myH, nbPoles, aP))
  return naivecgl.Naive_XYZArray:take(aP, nbPoles[0])
end

---
---@return naivecgl.Naive_DoubleArray
function naivecgl.Naive_NurbsCurve:ask_weights()
  local nbWeights = ffi.new("int[1]")
  check_code(naivecgl.NS.Naive_NurbsCurve_ask_weights(self.myH, nbWeights, nil))
  local aW = ffi.new("double[?]", nbWeights[0])
  check_code(naivecgl.NS.Naive_NurbsCurve_ask_weights(self.myH, nbWeights, aW))
  return naivecgl.Naive_DoubleArray:take(aW, nbWeights[0])
end

---
---@return naivecgl.Naive_DoubleArray
function naivecgl.Naive_NurbsCurve:ask_knots()
  local nbKnots = ffi.new("int[1]")
  check_code(naivecgl.NS.Naive_NurbsCurve_ask_knots(self.myH, nbKnots, nil))
  local aK = ffi.new("double[?]", nbKnots[0])
  check_code(naivecgl.NS.Naive_NurbsCurve_ask_knots(self.myH, nbKnots, aK))
  return naivecgl.Naive_DoubleArray:take(aK, nbKnots[0])
end

---
---@param theI integer
---@return integer
function naivecgl.Naive_NurbsCurve:ask_mults(theI)
  local aMult = ffi.new("int[1]")
  check_code(naivecgl.NS.Naive_NurbsCurve_ask_mults(self.myH, theI, aMult))
  return aMult[0]
end

---
---@return number T0
---@return number T1
function naivecgl.Naive_NurbsCurve:ask_bound()
  local aBound = ffi.new("Naive_Interval_t")
  check_code(naivecgl.NS.Naive_Curve_ask_bound(self.myH, aBound))
  return aBound.t0, aBound.t1
end

---
---@param theT number
---@param theN integer
---@return naivecgl.Naive_XYZArray
function naivecgl.Naive_NurbsCurve:evaluate(theT, theN)
  local nbD = ffi.new("int[1]", 0)
  check_code(naivecgl.NS.Naive_Curve_evaluate(self.myH, theT, theN, nbD, nil))
  local aD = ffi.new("Naive_Vector3d_t[?]", nbD[0])
  check_code(naivecgl.NS.Naive_Curve_evaluate(self.myH, theT, theN, nbD, aD))
  return naivecgl.Naive_XYZArray:take(aD, nbD[0])
end

---
---@param theT number
---@return naivecgl.Naive_XYZ
function naivecgl.Naive_NurbsCurve:curvature_at(theT)
  local aV = ffi.new("Naive_Vector3d_t")
  check_code(naivecgl.NS.Naive_Curve_curvature_at(self.myH, theT, aV))
  return naivecgl.Naive_XYZ.take(aV)
end

---
---@param theI integer
---@param theM integer
---@return integer code
function naivecgl.Naive_NurbsCurve:increase_multiplicity(theI, theM)
  return naivecgl.NS.Naive_NurbsCurve_increase_multiplicity(self.myH, theI, theM)
end

---
---@param theT number
---@param theM integer
---@return integer code
function naivecgl.Naive_NurbsCurve:Insert_knot(theT, theM)
  return naivecgl.NS.Naive_NurbsCurve_insert_knot(self.myH, theT, theM)
end

---
function naivecgl.Naive_NurbsCurve:delete()
  if self.myH then
    local code = naivecgl.NS.Naive_Object_delete(self.myH)
    self.myH = 0
    return code
  end
  return naivecgl.NS.Naive_Code_invalid_object
end

--------------------------------------------------------------------------------
--                            Naive_NurbsCurve                                --
--------------------------------------------------------------------------------

---@class naivecgl.Naive_NurbsSurface
---@field private myH integer
naivecgl.Naive_NurbsSurface = {}

---@private
naivecgl.Naive_NurbsSurface.__index = naivecgl.Naive_NurbsSurface

---Constructor.
---@param thePoles naivecgl.Naive_XYZ[][]
---@param theWeights number[][]
---@param theUKnots number[]
---@param theVKnots number[]
---@param theUMults integer[]
---@param theVMults integer[]
---@param theUDegree integer
---@param theVDegree integer
---@return naivecgl.Naive_NurbsSurface
function naivecgl.Naive_NurbsSurface.new(thePoles, theWeights,
                                         theUKnots, theVKnots,
                                         theUMults, theVMults,
                                         theUDegree, theVDegree)
  local nbUP, nbVP, aFlatPoles = flatten_array2(thePoles)
  local aPoles = naivecgl.Naive_XYZArray:new(aFlatPoles)

  local nbUW, nbVW, aFlatWeights = flatten_array2(theWeights)
  local aWeights = naivecgl.Naive_DoubleArray:new(aFlatWeights)

  local aUKnots = naivecgl.Naive_DoubleArray:new(theUKnots)
  local aVKnots = naivecgl.Naive_DoubleArray:new(theVKnots)
  local aUMults = naivecgl.Naive_Int32Array:new(theUMults)
  local aVMults = naivecgl.Naive_Int32Array:new(theVMults)

  local aH = ffi.new("Naive_NurbsSurface_t[1]")
  check_code(naivecgl.NS.Naive_NurbsSurface_new(
    nbUP, nbVP, aPoles:data(),
    nbUW, nbVW, aWeights:data(),
    aUKnots:size(), aUKnots:data(), aVKnots:size(), aVKnots:data(),
    aUMults:size(), aUMults:data(), aVMults:size(), aVMults:data(),
    theUDegree, theVDegree, aH))

  local nurbsSurface = { myH = aH[0] }
  setmetatable(nurbsSurface, naivecgl.Naive_NurbsSurface)
  return nurbsSurface
end

---
---@param theU number
---@param theV number
---@param theN integer
---@return naivecgl.Naive_XYZArray
function naivecgl.Naive_NurbsSurface:evaluate(theU, theV, theN)
  local nbD = ffi.new("int[1]", 0)
  check_code(naivecgl.NS.Naive_Surface_evaluate(self.myH, theU, theV, theN, nbD, nil))
  local aD = ffi.new("Naive_Vector3d_t[?]", nbD[0])
  check_code(naivecgl.NS.Naive_Surface_evaluate(self.myH, theU, theV, theN, nbD, aD))
  return naivecgl.Naive_XYZArray:take(aD, nbD[0])
end

--------------------------------------------------------------------------------
--                               Naive_Object                                 --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--                               Naive_Poly                                   --
--------------------------------------------------------------------------------

---@class naivecgl.Naive_Poly
---@field private myH integer
naivecgl.Naive_Poly = {}

---@private
naivecgl.Naive_Poly.__index = naivecgl.Naive_Poly

---Constructor.
---@param theNodes naivecgl.Naive_XYZ[]
---@param theTris integer[][] 1-indexed
---@return naivecgl.Naive_Poly
function naivecgl.Naive_Poly.new(theNodes, theTris)
  local nbNodes = #theNodes
  local aNodes = ffi.new("Naive_Point3d_t[?]", nbNodes)
  for i = 1, nbNodes do
    aNodes[i - 1] = theNodes[i]:data()
  end

  local nbTris = #theTris
  local aTris = ffi.new("Naive_Triangle_t[?]", nbTris)
  for i = 1, nbTris do
    aTris[i - 1].n0 = theTris[i][1] - 1
    aTris[i - 1].n1 = theTris[i][2] - 1
    aTris[i - 1].n2 = theTris[i][3] - 1
  end

  local aH = ffi.new("Naive_Poly_t[1]")
  check_code(naivecgl.NS.Naive_Poly_new(nbNodes, aNodes, nbTris, aTris, aH))
  return naivecgl.Naive_Poly.take(aH[0])
end

---@param theH integer
---@return naivecgl.Naive_Poly
function naivecgl.Naive_Poly.take(theH)
  local poly = { myH = theH }
  setmetatable(poly, naivecgl.Naive_Poly)
  return poly
end

---Vertices.
---@return naivecgl.Naive_XYZArray
function naivecgl.Naive_Poly:ask_vertices()
  local nbVerts = ffi.new("int[1]")
  check_code(naivecgl.NS.Naive_Poly_ask_vertices(self.myH, nbVerts, nil))
  local aVertices = ffi.new("Naive_Point3d_t[?]", nbVerts[0])
  check_code(naivecgl.NS.Naive_Poly_ask_vertices(self.myH, nbVerts, aVertices))
  return naivecgl.Naive_XYZArray:take(aVertices, nbVerts[0])
end

---Triangles (1-indexed).
---@return integer[][]
function naivecgl.Naive_Poly:ask_triangles()
  local nbTris = ffi.new("int[1]")
  check_code(naivecgl.NS.Naive_Poly_ask_triangles(self.myH, nbTris, nil))
  local aTriangles = ffi.new("Naive_Triangle_t[?]", nbTris[0])
  naivecgl.NS.Naive_Poly_ask_triangles(self.myH, nbTris, aTriangles)

  local aRes = {}
  for i = 1, nbTris[0] do
    aRes[i] = {
      aTriangles[i - 1].n0 + 1,
      aTriangles[i - 1].n1 + 1,
      aTriangles[i - 1].n2 + 1,
    }
  end

  return aRes
end

--------------------------------------------------------------------------------
--                           naivecgl::geom2dapi                              --
--------------------------------------------------------------------------------

---
---@param thePoints naivecgl.Naive_XY[]
---@param theAlgo? any
---@return integer[]
function naivecgl.geom2dapi.convex_hull(thePoints, theAlgo)
  theAlgo = theAlgo or naivecgl.NS.Naive_Algorithm_quick_hull
  local aPoints = naivecgl.Naive_XYArray:new(thePoints)
  local nbRes = ffi.new("int[1]")
  local indices = ffi.new("int*[1]")
  check_code(naivecgl.NS.Naive_Geom2dAPI_convex_hull(aPoints:size(), aPoints:data(), theAlgo, nbRes, indices, nil))

  local aRes = {}
  for i = 1, nbRes[0] do
    aRes[i] = indices[0][i - 1] + 1
  end

  naivecgl.NS.Naive_Memory_free(indices[0])

  return aRes
end

---
---@param thePoints naivecgl.Naive_XY[]
---@return naivecgl.Naive_XY origin
---@return number radius
function naivecgl.geom2dapi.enclosing_disc(thePoints)
  local aPoints = naivecgl.Naive_XYArray:new(thePoints)
  local anOrigin = ffi.new("Naive_Point2d_t")
  local aRadius = ffi.new("double[1]", 0)
  check_code(naivecgl.NS.Naive_Geom2dAPI_enclosing_disc(aPoints:size(), aPoints:data(), anOrigin, aRadius))
  return naivecgl.Naive_XY.take(anOrigin), aRadius[0]
end

--------------------------------------------------------------------------------
--                    naivecgl::tessellation::Sphere                          --
--------------------------------------------------------------------------------

---Calculates the tetrasphere with a tessellation level.
---@param theCenter naivecgl.Naive_XYZ
---@param theRadius number
---@param theLevel integer
---@return naivecgl.Naive_Poly
function naivecgl.tessellation.make_tetrasphere(theCenter, theRadius, theLevel)
  local aPoly = ffi.new "Naive_Poly_t[1]"
  check_code(naivecgl.NS.Naive_Tessellation_make_tetrasphere(theCenter:data(), theRadius, theLevel, aPoly))
  return naivecgl.Naive_Poly.take(aPoly[0])
end

--------------------------------------------------------------------------------
--                                 Export                                     --
--------------------------------------------------------------------------------

naivecgl:init()

return naivecgl
