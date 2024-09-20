local ffi = require("ffi")
local ffi_util = require("ffi_util")

local ffi_ = {}

---@type ffi.namespace*
ffi_.NS = nil

---Get absolute/relative path of the library.
---@param name string The base name of the library.
---@return string
local function get_dylib_path(name)
  local path

  if jit.os == "Windows" then
    path = name .. ".dll"
  elseif jit.os == "Linux" then
    path = "lib" .. name .. ".so"
  else
    error("Unsupported system!")
  end

  if Naivis then
    local ext = Naivis.NaiveApp.ExtensionMgr:Find("naivecgl-nvs")
    if ext and ext:IsValid() then
      path = ext:Path() .. "/lib/" .. path
    end
  end

  return path
end

function ffi_:init()
  if self.NS then
    return
  end

  self.NS = ffi.load(get_dylib_path("NaiveCGL"))

  if not self.NS then
    error("Failed to initialize NaiveCGL")
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
  Naive_Class_class,
  Naive_Class_object,
  Naive_Class_geometry2d,
  Naive_Class_point2d,
  Naive_Class_cartesian_point2d,
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
  Naive_Class_cartesian_point3d,
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
  Naive_Class_point_rep,
  Naive_Class_point_on_curve,
  Naive_Class_point_on_surface,
  Naive_Class_curve_rep,
  Naive_Class_curve_on_surface,
  Naive_Class_topol,
  Naive_Class_body,
  Naive_Class_region,
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
  Naive_Code_initialized,
  Naive_Code_null_arg_address,
  Naive_Code_invalid_value,
  Naive_Code_invalid_object,
  Naive_Code_invalid_tag,
  Naive_Code_still_referenced,
  Naive_Code_no_intersection,
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
  Naive_Code_bad_dimension,
  Naive_Code_bad_knots,
  Naive_Code_poles_weights_not_match,
  Naive_Code_knots_mults_not_match,
  Naive_Code_invalid_mults,
  Naive_Code_geom_not_needed,
} Naive_Code;

/* Naive_Loop_type */

typedef enum {
  Naive_Loop_type_vertex_c = 0,
  Naive_Loop_type_outer_c,
  Naive_Loop_type_inner_c,
} Naive_Loop_type;

/* Naive_NurbsCurve_form */

typedef enum {
  Naive_NurbsCurve_form_unset_c = 0,
  Naive_NurbsCurve_form_arbitrary_c,
  Naive_NurbsCurve_form_polyline_c,
  Naive_NurbsCurve_form_circular_c,
  Naive_NurbsCurve_form_elliptic_c,
  Naive_NurbsCurve_form_parabolic_c,
  Naive_NurbsCurve_form_hyperbolic_c,
} Naive_NurbsCurve_form;

/* Naive_NurbsSurface_form */

typedef enum {
  Naive_NurbsSurface_form_unset_c = 0,
  Naive_NurbsSurface_form_arbitrary_c,
  Naive_NurbsSurface_form_planar_c,
  Naive_NurbsSurface_form_cylindrical_c,
  Naive_NurbsSurface_form_conical_c,
  Naive_NurbsSurface_form_spherical_c,
  Naive_NurbsSurface_form_toroidal_c,
  Naive_NurbsSurface_form_revolved_c,
  Naive_NurbsSurface_form_ruled_c,
  Naive_NurbsSurface_form_gen_cone_c,
  Naive_NurbsSurface_form_quadric_c,
  Naive_NurbsSurface_form_swept_c,
} Naive_NurbsSurface_form;

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
typedef int Naive_Point_t;
typedef int Naive_Shell_t;
typedef int Naive_Region_t;
typedef int Naive_Surface_t;
typedef int Naive_Transform3d_t;
typedef int Naive_Triangulation_t;
typedef int Naive_Vertex_t;

typedef int Naive_Algorithm_t;
typedef int Naive_Class_t;
typedef int Naive_Code_t;
typedef int Naive_Loop_type_t;
typedef int Naive_NurbsCurve_form_t;
typedef int Naive_NurbsSurface_form_t;
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

/* Naive_Pnt2d_t */

typedef Naive_XY_t Naive_Pnt2d_t;

/* Naive_Vec2d_t */

typedef Naive_XY_t Naive_Vec2d_t;

/* Naive_UV_t */

typedef Naive_XY_t Naive_UV_t;

/* Naive_Pnt3d_t */

typedef Naive_XYZ_t Naive_Pnt3d_t;

/* Naive_Vec3d_t */

typedef Naive_XYZ_t Naive_Vec3d_t;

/* Naive_Interval_t */

typedef struct Naive_Interval_s {
  double t0, t1;
} Naive_Interval_t;

/* Naive_Triangle_t */

typedef struct Naive_Triangle_s {
  int n0, n1, n2;
} Naive_Triangle_t;

/* Naive_Ax2d_sf_t */

typedef struct Naive_Ax2d_sf_s {
  Naive_Pnt2d_t location;
  Naive_Vec2d_t axis;
} Naive_Ax2d_sf_t;

/* Naive_Ax22d_sf_t */

typedef struct Naive_Ax22d_sf_s {
  Naive_Pnt2d_t location;
  Naive_Vec2d_t x_axis;
  Naive_Vec2d_t y_axis;
} Naive_Ax22d_sf_t;

/* Naive_Ax1_sf_t */

typedef struct Naive_Ax1_sf_s {
  Naive_Pnt3d_t location;
  Naive_Vec3d_t axis;
} Naive_Ax1_sf_t;

/* Naive_Ax2_sf_t */

typedef struct Naive_Ax2_sf_s {
  Naive_Pnt3d_t location;
  Naive_Vec3d_t axis;
  Naive_Vec3d_t ref_direction;
} Naive_Ax2_sf_t;

/* Naive_Circle2d_sf_t */

typedef struct Naive_Circle2d_sf_s {
  Naive_Ax22d_sf_t basis_set;
  double radius;
} Naive_Circle2d_sf_t;

/* Naive_Line2d_sf_t */

typedef struct Naive_Line2d_sf_s {
  Naive_Ax2d_sf_t basis_set;
} Naive_Line2d_sf_t;

/* Naive_Circle_sf_t */

typedef struct Naive_Circle_sf_s {
  Naive_Ax2_sf_t basis_set;
  double radius;
} Naive_Circle_sf_t;

/* Naive_Line_sf_t */

typedef struct Naive_Line_sf_s {
  Naive_Ax1_sf_t basis_set;
} Naive_Line_sf_t;

/* Naive_NurbsCurve_sf_t */

typedef struct Naive_NurbsCurve_sf_s {
  int degree;
  int n_vertices;
  int vertex_dim;
  Naive_Logical_t is_rational;
  double *vertex;
  Naive_NurbsCurve_form_t form;
  int n_knots;
  int *knot_mult;
  double *knot;
  Naive_Logical_t is_periodic;
  Naive_Logical_t is_closed;
} Naive_NurbsCurve_sf_t;

/* Naive_NurbsSurface_sf_t */

typedef struct Naive_NurbsSurface_sf_s {
  int u_degree;
  int v_degree;
  int n_u_vertices;
  int n_v_vertices;
  int vertex_dim;
  Naive_Logical_t is_rational;
  double *vertex;
  Naive_NurbsSurface_form_t form;
  int n_u_knots;
  int n_v_knots;
  int *u_knot_mult;
  int *v_knot_mult;
  double *u_knot;
  double *v_knot;
  Naive_Logical_t is_u_periodic;
  Naive_Logical_t is_v_periodic;
  Naive_Logical_t is_u_closed;
  Naive_Logical_t is_v_closed;
} Naive_NurbsSurface_sf_t;

/* Naive_Point_sf_t */

typedef struct Naive_Point_sf_s {
  Naive_Pnt3d_t position;
} Naive_Point_sf_t;

/* Naive_Plane_sf_t */

typedef struct Naive_Plane_sf_s {
  Naive_Ax2_sf_t basis_set;
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

/**
 * @brief This function returns the set of edges in the given body.
 *
 * @param body [I] A body.
 * @param n_edges [O] Number of edges (>= 0).
 * @param edges [O] Edges (optional).
 * @return Code.
 */
 Naive_Code_t Naive_Body_ask_edges(Naive_Body_t body,
 int *const n_edges,
 Naive_Edge_t **const edges);

/**
* @brief This function returns the set of faces in the given body.
*
* @param body [I] A body.
* @param n_faces [O] Number of faces (>= 0).
* @param faces [O] Faces (optional).
* @return Code.
*/
Naive_Code_t Naive_Body_ask_faces(Naive_Body_t body,
 int *const n_faces,
 Naive_Face_t **const faces);

/**
* @brief This function returns the set of fins in the given body.
*
* @param body [I] A body.
* @param n_fins [O] Number of fins (>= 0).
* @param fins [O] Fins (optional).
* @return Code.
*/
Naive_Code_t Naive_Body_ask_fins(Naive_Body_t body, int *const n_fins,
Naive_Fin_t **const fins);

/**
* @brief This function return the set of loops in the given body.
*
* @param body [I] A body.
* @param n_loops [O] Number of loops (>= 0).
* @param loops [O] Loops (optional).
* @return Code.
*/
Naive_Code_t Naive_Body_ask_loops(Naive_Body_t body,
 int *const n_loops,
 Naive_Loop_t **const loops);

/**
* @brief This function returns the compound body containing `body`, if any.
* Otherwise it returns Naive_Object_null.
*
* @param body [I] Body.
* @param parent [O] Parent (possibly Naive_Object_null).
* @return Code.
*/
Naive_Code_t Naive_Body_ask_parent(Naive_Body_t body,
  Naive_Body_t *const parent);

/**
* @brief This function returns the set of regions in the given body.
*
* @param body [I] A body.
* @param n_regions [O] Number of regions (>= 0).
* @param regions [O] regions (optional).
* @return Code.
*/
Naive_Code_t Naive_Body_ask_regions(Naive_Body_t body,
   int *const n_regions,
   Naive_Region_t **const regions);

/**
* @brief This function returns the set of shells in the given body.
*
* @param body [I] A body.
* @param n_shells [O] Number of shells (>= 0).
* @param shells [O] Shells (optional).
* @return Code.
*/
Naive_Code_t Naive_Body_ask_shells(Naive_Body_t body,
  int *const n_shells,
  Naive_Shell_t **const shells);

/**
* @brief This function returns the set of vertices in the given body.
*
* @param body [I] A body.
* @param n_vertices [O] Number of vertices (>= 0).
* @param vertices [O] Vertices (optional).
* @return Code.
*/
Naive_Code_t Naive_Body_ask_vertices(Naive_Body_t body,
    int *const n_vertices,
    Naive_Vertex_t **const vertices);

/**
* @brief This function performs a boolean operation between the target body and
* the list of tool bodies.
*
* @param target [I] Target body.
* @param n_tools [I] Number of tool bodies.
* @param tools [I] Tool bodies.
* @param options [I] Boolean options.
* @return Code.
*/
Naive_Code_t
Naive_Body_boolean(Naive_Body_t target, int n_tools, const Naive_Body_t *tools,
const Naive_Body_boolean_o_t *options);

/**
* @brief This function creates a solid block.
*
* @param x [I] Block extent in local x direction (>0).
* @param y [I] Block extent in local y direction (>0).
* @param z [I] Block extent in local z direction (>0).
* @param basis_set [I] Position and orientation (may be NULL).
* @param body [O] Solid body returned.
* @return Code.
*/
Naive_Code_t Naive_Body_create_solid_block(
double x, double y, double z, const Naive_Ax2_sf_t *basis_set,
Naive_Body_t *const body);

/* Naive_Class */

/**
* @brief This function return the class token of the given class's immediate
* superclass.
*
* @param class_ [I] A class.
* @param superclass [O] Immediate superclass of class.
* @return Code.
*/
Naive_Code_t Naive_Class_ask_superclass(
Naive_Class_t class_, Naive_Class_t *const superclass);

/**
* @brief This function returns whether `may_be_subclass` is a subclass of
* `class_`.
*
* @param may_be_subclass [I] A potential subclass.
* @param class_ [I] A class.
* @param is_subclass [O] Whether it was a subclass.
* @return Code.
*/
Naive_Code_t
Naive_Class_is_subclass(Naive_Class_t may_be_subclass, Naive_Class_t class_,
Naive_Logical_t *const is_subclass);

/* Naive_Curve */

/**
* @brief This function returns an interval indicating the parametric bounds of
* the given curve.
*
* @param curve [I] A curve.
* @param interval [O] Parametric bounds of the curve.
* @return Code.
*/
Naive_Code_t
Naive_Curve_ask_interval(Naive_Curve_t curve, Naive_Interval_t *const interval);

/**
* @brief This function evaluates a point and derivatives at a given parameter
* on the given curve.
*
* @param curve [I] Curve.
* @param t [I] Curve parameter.
* @param n_derivs [I] Number of derivatives.
* @param p [O] Point and derivatives.
* @return Code.
*/
Naive_Code_t Naive_Curve_eval(Naive_Curve_t curve, double t,
int n_derivs, Naive_Vec3d_t p[]);

/**
* @brief
*
* @param curve
* @param t
* @param curvature
* @return Code.
*/
Naive_Code_t Naive_Curve_eval_curvature(
Naive_Curve_t curve, double t, Naive_Vec3d_t *const curvature);

/**
* @brief This function creates a wire body from an array of curves and
* intervals. The curves do not need to be ordered (unless specified otherwise)
* or directed.
*
* @param n_curves [I] Number of curves.
* @param curves [I] Curves to create a wire.
* @param bounds [I] Bounds of each curve.
* @param options [I] Options structure.
* @param body [O] The created wire body.
* @param n_new_edges [O] Number of new edges.
* @param new_edges [O] New edges.
* @param edge_index [O] Pos in original array.
* @return Code.
*/
Naive_Code_t Naive_Curve_make_wire_body(
int n_curves, const Naive_Curve_t curves[], const Naive_Interval_t bounds[],
const Naive_Curve_make_wire_body_o_t *options, Naive_Body_t *const body,
int *const n_new_edges, Naive_Edge_t **const new_edges,
int **const edge_index);

/* Naive_Edge */

/**
* @brief This function returns the vertices bounding the given edge.
*
* @param edge [I] An edge.
* @param vertices [O] Vertices (possibly both Naive_Object_null).
* @return Code.
*/
Naive_Code_t Naive_Edge_ask_vertices(Naive_Edge_t edge,
    Naive_Vertex_t vertices[2]);

/* Naive_Geom2dAPI */

/**
* @brief This function calculates the convex hull of a set of 2d points.
*
* @param n_points [I] Number of points.
* @param points [I] Points.
* @param algo [I] Algorithm.
* @param n_convex_points [O] Number of vertex in the convex hull.
* @param convex_indices [O] Index of vertex in the convex hull.
* @param convex_points [O] Convex vertex.
* @return Code.
*/
Naive_Code_t Naive_Geom2dAPI_convex_hull(
int n_points, const Naive_Pnt2d_t *points, Naive_Algorithm_t algo,
int *const n_convex_points, int **const convex_indices,
Naive_Pnt2d_t **const convex_points);

/**
* @brief This function calculates the enclosing disc of a set of 2d 2d points.
*
* @param n_points [I] Number of points.
* @param points [I] Points.
* @param origin [O] The origin of the disc.
* @param radius [O] The radius of the disc.
* @return Code.
*/
Naive_Code_t Naive_Geom2dAPI_enclosing_disc(
int n_points, const Naive_Pnt2d_t *points, Naive_Pnt2d_t *const origin,
double *const radius);

/* Naive_Geometry */

/**
* @brief
*
* @param geometry
* @param clone
* @return Code.
*/
Naive_Code_t Naive_Geometry_clone(Naive_Geometry_t geometry,
 Naive_Geometry_t *const clone);

/**
* @brief
*
* @param geometry
* @param is_valid
* @return Code.
*/
Naive_Code_t Naive_Geometry_is_valid(Naive_Geometry_t geometry,
    Naive_Logical_t *const is_valid);

/* Naive_Line */

/**
* @brief This function writes the standard form of a line at the given address.
*
* @param line [I] Line.
* @param line_sf [O] Line standard form.
* @return Code.
*/
Naive_Code_t Naive_Line_ask(Naive_Line_t line,
Naive_Line_sf_t *const line_sf);

/**
* @brief This function creates a line from the given standard form.
*
* @param line_sf [I] Line standard form.
* @param line [O] Line.
* @return Code.
*/
Naive_Code_t Naive_Line_create(const Naive_Line_sf_t *line_sf,
Naive_Line_t *const line);

/* Naive_Memory */

/**
* @brief
*
* @param nbytes
* @param pointer
* @return Code.
*/
Naive_Code_t Naive_Memory_alloc(size_t nbytes, void **const pointer);

/**
* @brief
*
* @param pointer
* @return Code.
*/
Naive_Code_t Naive_Memory_free(void *pointer);

/* Naive_NurbsCurve */

/**
* @brief This function modifies the given 'nurbs_curve' by inserting knots
* with the quantity of 'mult' at the given split parameter.
*
* @param nurbs_curve [I] NURBS curve.
* @param t [I] Split parameter.
* @param mult [I] Multiplicity.
* @return Code.
*/
Naive_Code_t Naive_NurbsCurve_add_knot(Naive_NurbsCurve_t nurbs_curve,
      double t, int mult);

/**
* @brief This function returns the standard form for a NURBS curve.
*
* @param nurbs_curve [I] NURBS curve.
* @param nurbs_curve_sf [O] NURBS curve standard form.
* @return Code.
*/
Naive_Code_t
Naive_NurbsCurve_ask(Naive_NurbsCurve_t nurbs_curve,
Naive_NurbsCurve_sf_t *const nurbs_curve_sf);

/**
* @brief This function returns the uniques knots and the multiplicities of a
* given NURBS curve.
*
* @param nurbs_curve [I] NURBS curve to query.
* @param n_knots [O] Number of knots.
* @param knots [O] Knot values.
* @param multiplicities [O] Corresponding multiplicities.
* @return Code.
*/
Naive_Code_t
Naive_NurbsCurve_ask_knots(Naive_NurbsCurve_t nurbs_curve, int *const n_knots,
double **const knots, int **const multiplicities);

/**
* @brief This function creates a NURBS curve from the standard form.
*
* @param nurbs_curve_sf [I] NURBS curve standard form.
* @param nurbs_curve [O] NURBS curve.
* @return Code.
*/
Naive_Code_t
Naive_NurbsCurve_create(const Naive_NurbsCurve_sf_t *nurbs_curve_sf,
Naive_NurbsCurve_t *const nurbs_curve);

/**
* @brief This function modifies the given 'bcurve' by raising its degree by
* 'increment'.
*
* @param nurbs_curve [I] NURBS curve.
* @param degree [I] How much to raise by.
* @return Code.
*/
Naive_Code_t
Naive_NurbsCurve_raise_degree(Naive_NurbsCurve_t nurbs_curve, int increment);

/**
* @brief This function reduces the multiplicity of the knot of index 'index' to
* 'mult'.
*
* @param nurbs_curve [I] NURBS curve.
* @param index [I] Index of the knot.
* @param mult [I] Multiplicity to reduce to.
* @return Code.
*/
Naive_Code_t Naive_NurbsCurve_remove_knot(
Naive_NurbsCurve_t nurbs_curve, int index, int mult);

/* Naive_NurbsSurface */

/**
* @brief This function returns the standard form for a NURBS surface.
*
* @param nurbs_surface [I] NURBS surface.
* @param nurbs_surface_sf [O] NURBS surface standard form.
* @return Code.
*/
Naive_Code_t
Naive_NurbsSurface_ask(Naive_NurbsSurface_t nurbs_surface,
Naive_NurbsSurface_sf_t *const nurbs_surface_sf);

/**
* @brief This function creates a NURBS surface from the standard form.
*
* @param nurbs_surface_sf [I] NURBS surface standard form.
* @param nurbs_surface [O] NURBS surface.
* @return Code.
*/
Naive_Code_t
Naive_NurbsSurface_create(const Naive_NurbsSurface_sf_t *nurbs_surface_sf,
Naive_NurbsSurface_t *const nurbs_surface);

/* Naive_Object */

/**
* @brief This function returns the given object's concrete class.
*
* @param object [I] Object.
* @param class_ [O] Class of object.
* @return Code.
*/
Naive_Code_t Naive_Object_ask_class(Naive_Object_t object,
   Naive_Class_t *const class_);

/**
* @brief This function deletes the given object.
*
* @param object [I] Object.
* @return Code.
*/
Naive_Code_t Naive_Object_delete(Naive_Object_t object);

/* Naive_Plane */

/**
* @brief This function returns the standard form of the given plane.
*
* @param plane [I] A plane.
* @param plane_sf [O] The standard form of the plane
* @return Code.
*/
Naive_Code_t Naive_Plane_ask(Naive_Plane_t plane,
Naive_Plane_sf_t *const plane_sf);

/**
* @brief This function creates a plane from the given standard form.
*
* @param plane_sf [I] Standard form of a plane.
* @param plane [O] The plane.
* @return Code.
*/
Naive_Code_t Naive_Plane_create(const Naive_Plane_sf_t *plane_sf,
Naive_Plane_t *const plane);

/**
* @brief
*
* @param plane
* @param point
* @param distance
* @return Code.
*/
Naive_Code_t Naive_Plane_distance(Naive_Plane_t plane,
 const Naive_Pnt3d_t *point,
 double *const distance);

/* Naive_Point */

/**
* @brief This function returns the standard form of the given point.
*
* @param point [I] Point.
* @param point_sf [O] Point standard form.
* @return Code.
*/
Naive_Code_t Naive_Point_ask(Naive_Point_t point,
Naive_Point_sf_t *const point_sf);

/**
* @brief This function creates a point from the given standard form.
*
* @param point_sf [I] Point standard form.
* @param point [O] Created point.
* @return Code.
*/
Naive_Code_t Naive_Point_create(const Naive_Point_sf_t *point_sf,
Naive_Point_t *const point);

/* Naive_Surface */

/**
* @brief This function evaluates a point and derivatives at a parameter pair on
* the given surface.
*
* @param surface [I] Surface.
* @param uv [I] u and v parameter pair.
* @param n_u_derivs [I] Number of u derivatives.
* @param n_v_derivs [I] Number of v derivatives.
* @param p [O] Point and derivatives.
* @return Code.
*/
Naive_Code_t Naive_Surface_eval(Naive_Surface_t surface,
Naive_UV_t uv, int n_u_derivs,
int n_v_derivs, Naive_Vec3d_t p[]);

/* Naive_Tessellation */

/**
* @brief This function creates a triangulated sphere with tetrahedral pattern.
*
* @param center [I] Center of the sphere.
* @param radius [I] Radius of the sphere.
* @param level [I] Tessellation level.
* @param triangulation [O] The tetrsphere.
* @return Code.
*/
Naive_Code_t Naive_Tessellation_create_tetrasphere(
const Naive_Pnt3d_t *center, double radius, int level,
Naive_Triangulation_t *const triangulation);

/* Naive_Triangulation */

/**
* @brief
*
* @param triangulation
* @param n_triangles
* @param triangles
* @return Code.
*/
Naive_Code_t Naive_Triangulation_ask_triangles(
Naive_Triangulation_t triangulation, int *const n_triangles,
Naive_Triangle_t **const triangles);

/**
* @brief
*
* @param triangulation
* @param n_vertices
* @param vertices
* @return Code.
*/
Naive_Code_t Naive_Triangulation_ask_vertices(
Naive_Triangulation_t triangulation, int *const n_vertices,
Naive_Pnt3d_t **const vertices);

/**
* @brief
*
* @param n_vertices
* @param vertices
* @param n_triangles
* @param triangles
* @param i_offset
* @param triangulation
* @return Code.
*/
Naive_Code_t Naive_Triangulation_create(
int n_vertices, const Naive_Pnt3d_t *vertices, int n_triangles,
const Naive_Triangle_t *triangles, int i_offset,
Naive_Triangulation_t *const triangulation);

/* Naive_Vertex */

/**
* @brief This function returns the point at the given vertex, if one exists,
* otherwise Naive_Object_null.
*
* @param vertex [I] A vertex.
* @param point [O] Its point (possibly Naive_Object_null).
* @return Code.
*/
Naive_Code_t Naive_Vertex_ask_point(Naive_Vertex_t vertex,
   Naive_Point_t *const point);

/**
* @brief This function attaches points to vertices.
*
* @param n_vertices [I] Number of vertices.
* @param vertices [I] Vertices to have points attached.
* @param points [I] Points to be attached to vertices.
* @return Code.
*/
Naive_Code_t
Naive_Vertex_attach_points(int n_vertices, const Naive_Vertex_t vertices[],
const Naive_Point_t points[]);
]]
end

ffi_.F = ffi
ffi_.U = ffi_util

return ffi_
