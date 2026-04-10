% Parameters
int: n = 8;
set of int: V = 1..n;

array[V] of float: x = [0.0, 0.0, 4.0, 8.0, 11.0, 11.0, 7.0, 1.0];
array[V] of float: y = [1.0, 6.0, 10.0, 10.0, 7.0, 4.0, 0.0, 0.0];

% Big-M bounds for center coordinates (safe loose bounds around the polygon)
float: xmin = 0.0;
float: xmax = 11.0;
float: ymin = 0.0;
float: ymax = 10.0;

% Upper bound for radius (cannot exceed max bbox half-diagonal, loose)
float: r_ub = 20.0;

% Variables
var xmin..xmax: cx;
var ymin..ymax: cy;
var 0.0..r_ub: r;

% Constraints
% For a convex polygon, the largest inscribed circle satisfies:
% distance(center, each edge) >= r
% Here we assume the given polygon is convex and vertices are in CCW order.

constraint
  forall(i in V) (
    let {
      int: j = if i = n then 1 else i + 1 endif,
      float: dx = x[j] - x[i],
      float: dy = y[j] - y[i],
      float: len = sqrt(dx*dx + dy*dy)
    } in
      % Signed distance to directed edge (i -> j) for CCW polygon:
      (dx*(cy - y[i]) - dy*(cx - x[i])) / len >= r
  );

% Objective
solve maximize r;