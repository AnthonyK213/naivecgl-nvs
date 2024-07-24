local ffi = require("ffi")

local ffi_ = {}

---@type ffi.namespace*
ffi_.NS = nil

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

function ffi_:init()
  if self.NS then
    return
  end

  -- NaiveCGL_c_enums.h
  ffi.cdef [[
/* Naive_Algorithm */

typedef enum {
  Naive_Algorithm_quick_hull_c = 0,
  Naive_Algorithm_incremental_c,
  Naive_Algorithm_graham_scan_c,
  Naive_Algorithm_divide_and_conquer_c,
} Naive_Algorithm;

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

/* Naive_Loop_type */

typedef enum {
  Naive_Loop_type_vertex_c = 0,
  Naive_Loop_type_outer_c,
  Naive_Loop_type_inner_c,
} Naive_Loop_type;

/* Naive_Orientation */

typedef enum {
  Naive_Orientation_forward_c = 0,
  Naive_Orientation_reversed_c,
  Naive_Orientation_internal_c,
  Naive_Orientation_external_c,
} Naive_Orientation;

/* Naive_boolean_function */

typedef enum {
  Naive_boolean_intersect_c = 0,
  Naive_boolean_subtract_c,
  Naive_boolean_unite_c,
} Naive_boolean_function;
]]

  -- NaiveCGL_c_types.h
  ffi.cdef [[
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

typedef int Naive_Algorithm_t;
typedef int Naive_Class_t;
typedef int Naive_Code_t;
typedef int Naive_Loop_type_t;
typedef int Naive_Orientation_t;
typedef int Naive_boolean_function_t;

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

/* Naive_Point2d_t */

typedef Naive_XY_t Naive_Point2d_t;

/* Naive_Vector2d_t */

typedef Naive_XY_t Naive_Vector2d_t;

/* Naive_Point3d_t */

typedef Naive_XYZ_t Naive_Point3d_t;

/* Naive_Vector3d_t */

typedef Naive_XYZ_t Naive_Vector3d_t;

/* Naive_Interval_t */

typedef struct Naive_Interval_s {
  double t0, t1;
} Naive_Interval_t;

/* Naive_Triangle_t */

typedef struct Naive_Triangle_s {
  int n0, n1, n2;
} Naive_Triangle_t;

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

/* Naive_Circle2d_sf_t */

typedef struct Naive_Circle2d_sf_s {
  Naive_Axis22d_sf_t basis_set;
  double radius;
} Naive_Circle2d_sf_t;

/* Naive_Line2d_sf_t */

typedef struct Naive_Line2d_sf_s {
  Naive_Axis2d_sf_t basis_set;
} Naive_Line2d_sf_t;

/* Naive_Circle_sf_t */

typedef struct Naive_Circle_sf_s {
  Naive_Axis2_sf_t basis_set;
  double radius;
} Naive_Circle_sf_t;

/* Naive_Line_sf_t */

typedef struct Naive_Line_sf_s {
  Naive_Axis1_sf_t basis_set;
} Naive_Line_sf_t;

/* Naive_Plane_sf_t */

typedef struct Naive_Plane_sf_s {
  Naive_Axis2_sf_t basis_set;
} Naive_Plane_sf_t;

/* Naive_Transform3d_sf_t */

typedef struct Naive_Transform3d_sf_s {
  double matrix[3][4];
} Naive_Transform3d_sf_t;

/* Naive_Curve_make_wire_body_o_t */

typedef struct Naive_Curve_make_wire_body_o_s {
  double tolerance;
} Naive_Curve_make_wire_body_o_t;

/* Naive_Body_boolean_o_t */

typedef struct Naive_Body_boolean_o_s {
  Naive_boolean_function_t function;
} Naive_Body_boolean_o_t;
]]

  -- NaiveCGL_c.h
  ffi.cdef [[
/* Naive_Body */

Naive_Code_t Naive_Body_ask_edges(Naive_Body_t /* body */,
                                            int *const /* n_edges */,
                                            Naive_Edge_t **const /* edges */);

Naive_Code_t Naive_Body_ask_faces(Naive_Body_t /* body */,
                                            int *const /* n_faces */,
                                            Naive_Face_t **const /* faces */);

Naive_Code_t Naive_Body_ask_fins(Naive_Body_t /* body */,
                                           int *const /* n_fins */,
                                           Naive_Fin_t **const /* fins */);

Naive_Code_t Naive_Body_ask_location(
    Naive_Body_t /* body */, Naive_Transform3d_t *const /* location */);

Naive_Code_t Naive_Body_ask_loops(Naive_Body_t /* body */,
                                            int *const /* n_loops */,
                                            Naive_Loop_t **const /* loops */);

Naive_Code_t Naive_Body_ask_orient(
    Naive_Body_t /* body */, Naive_Orientation_t *const /* orientation */);

Naive_Code_t
Naive_Body_ask_shells(Naive_Body_t /* body */, int *const /* n_shells */,
                      Naive_Shell_t **const /* shells */);

Naive_Code_t
Naive_Body_ask_vertices(Naive_Body_t /* body */, int *const /* n_vertices */,
                        Naive_Vertex_t **const /* vertices */);

Naive_Code_t Naive_Body_boolean(
    Naive_Body_t /* target */, int /* n_tools */,
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

Naive_Code_t Naive_Curve_eval(Naive_Curve_t /* curve */,
                                        double /* t */, int /* n_deriv */,
                                        Naive_Vector3d_t /* p */[]);

Naive_Code_t
Naive_Curve_eval_curvature(Naive_Curve_t /* curve */, double /* t */,
                           Naive_Vector3d_t *const /* curvature */);

Naive_Code_t Naive_Curve_make_wire_body(
    int /* n_curves */, const Naive_Curve_t /* curves */[],
    const Naive_Interval_t /* bounds */[],
    const Naive_Curve_make_wire_body_o_t * /* options */,
    Naive_Body_t *const /* body */, int *const /* n_new_edges */,
    Naive_Edge_t **const /* new_edges */, int **const /* edge_index */);

/* Naive_Geom2dAPI */

Naive_Code_t Naive_Geom2dAPI_convex_hull(
    int /* n_points */, const Naive_Point2d_t * /* points */,
    Naive_Algorithm_t /* algo */, int *const /* n_convex_points */,
    int **const /* convex_indices */,
    Naive_Point2d_t **const /* convex_points */);

Naive_Code_t Naive_Geom2dAPI_enclosing_disc(
    int /* n_points */, const Naive_Point2d_t * /* points */,
    Naive_Point2d_t *const /* origin */, double *const /* radius */);

/* Naive_Geometry */

Naive_Code_t Naive_Geometry_clone(
    Naive_Geometry_t /* geometry */, Naive_Geometry_t *const /* clone */);

Naive_Code_t Naive_Geometry_is_valid(
    Naive_Geometry_t /* geometry */, Naive_Logical_t *const /* is_valid */);

/* Naive_Line */

Naive_Code_t Naive_Line_create(const Naive_Line_sf_t * /* line_sf */,
                                         Naive_Line_t *const /* line */);

/* Naive_Memory */

Naive_Code_t Naive_Memory_alloc(size_t /* nbytes */,
                                          void **const /* pointer */);

Naive_Code_t Naive_Memory_free(void * /* pointer */);

/* Naive_NurbsCurve */

Naive_Code_t Naive_NurbsCurve_ask_degree(
    Naive_NurbsCurve_t /* nurbs_curve */, int *const /* degree */);

Naive_Code_t Naive_NurbsCurve_ask_knots(
    Naive_NurbsCurve_t /* nurbs_curve */, int *const /* n_knots */,
    double **const /* knots */);

Naive_Code_t
Naive_NurbsCurve_ask_mults(Naive_NurbsCurve_t /* nurbs_curve */,
                           int *const /* n_mults */, int **const /* mults */);

Naive_Code_t Naive_NurbsCurve_ask_poles(
    Naive_NurbsCurve_t /* nurbs_curve */, int *const /* n_poles */,
    Naive_Point3d_t **const /* poles */);

Naive_Code_t Naive_NurbsCurve_ask_weights(
    Naive_NurbsCurve_t /* nurbs_curve */, int *const /* n_weights */,
    double **const /* weights */);

Naive_Code_t Naive_NurbsCurve_create(
    int /* n_poles */, const Naive_Point3d_t * /* poles */, int /* n_weights */,
    const double * /* weights */, int /* n_knots */, const double * /* knots */,
    int /* n_mults */, const int * /* mults */, int /* degree */,
    Naive_NurbsCurve_t *const /* nurbs_curve */);

Naive_Code_t Naive_NurbsCurve_increase_degree(
    Naive_NurbsCurve_t /* nurbs_curve */, int /* degree */);

Naive_Code_t Naive_NurbsCurve_increase_multiplicity(
    Naive_NurbsCurve_t /* nurbs_curve */, int /* index */, int /* mult */);

Naive_Code_t Naive_NurbsCurve_insert_knot(
    Naive_NurbsCurve_t /* nurbs_curve */, double /* t */, int /* mult */);

/* Reduces the multiplicity of the knot of index |index| to |mult|. */
Naive_Code_t Naive_NurbsCurve_remove_knot(
    Naive_NurbsCurve_t /* nurbs_curve */, int /* index */, int /* mult */);

/* Naive_NurbsSurface */

Naive_Code_t Naive_NurbsSurface_ask_degree(
    Naive_NurbsSurface_t /* nurbs_surface */, int *const /* degree_u */,
    int *const /* degree_v */);

Naive_Code_t Naive_NurbsSurface_create(
    int /* n_poles_u */, int /* n_poles_v */,
    const Naive_Point3d_t * /* poles */, int /* n_weights_u */,
    int /* n_weights_v */, const double * /* weights */, int /* n_knots_u */,
    const double * /* knots_u */, int /* n_knots_v */,
    const double * /* knots_v */, int /* n_mults_u */,
    const int * /* mults_u */, int /* n_mults_v */, const int * /* mults_v */,
    int /* degree_u */, int /* degree_v */,
    Naive_NurbsSurface_t *const /* nurbs_surface */);

/* Naive_Object */

Naive_Code_t Naive_Object_ask_class(Naive_Object_t /* object */,
                                              Naive_Class_t *const /* class */);

Naive_Code_t Naive_Object_delete(Naive_Object_t /* object */);

/* Naive_Plane */

Naive_Code_t Naive_Plane_ask(Naive_Plane_t /* plane */,
                                       Naive_Plane_sf_t *const /* plane_sf */);

Naive_Code_t Naive_Plane_create(
    const Naive_Plane_sf_t * /* plane_sf */, Naive_Plane_t *const /* plane */);

Naive_Code_t Naive_Plane_distance(Naive_Plane_t /* plane */,
                                            const Naive_Point3d_t * /* point */,
                                            double *const /* distance */);

/* Naive_Surface */

Naive_Code_t Naive_Surface_eval(Naive_Surface_t /* surface */,
                                          double /* u */, double /* v */,
                                          int /* n_u_deriv */,
                                          int /* n_v_deriv */,
                                          Naive_Vector3d_t /* p */[]);

/* Naive_Tessellation */

Naive_Code_t Naive_Tessellation_make_tetrasphere(
    const Naive_Point3d_t * /* center */, double /* radius */, int /* level */,
    Naive_Triangulation_t *const /* triangulation */);

/* Naive_Triangulation */

Naive_Code_t Naive_Triangulation_ask_triangles(
    Naive_Triangulation_t /* triangulation */, int *const /* n_triangles */,
    Naive_Triangle_t **const /* triangles */);

Naive_Code_t Naive_Triangulation_ask_vertices(
    Naive_Triangulation_t /* triangulation */, int *const /* n_vertices */,
    Naive_Point3d_t **const /* vertices */);

Naive_Code_t Naive_Triangulation_create(
    int /* n_vertices */, const Naive_Point3d_t * /* vertices */,
    int /* n_triangles */, const Naive_Triangle_t * /* triangles */,
    int /* i_offset */, Naive_Triangulation_t *const /* triangulation */);
]]

  self.NS = ffi.load(get_dylib_path("NaiveCGL"))

  if not self.NS then
    error("Failed to initialize NaiveCGL")
  end
end

ffi_.cdef = ffi.cdef
ffi_.gc = ffi.gc
ffi_.new = ffi.new
ffi_.typeof = ffi.typeof

return ffi_
