% Maximal inscribed circle in a convex polygon (Chebyshev center)
% Polygon vertices (in order): (0,1), (0,6), (4,10), (8,10), (11,7), (11,4), (7,0), (1,0)
% We maximize the radius r; area = pi*r^2. (r itself is linear objective)

include "globals.mzn";

int: n = 8;

array[1..n] of float: x = [0.0, 0.0, 4.0, 8.0, 11.0, 11.0, 7.0, 1.0];
array[1..n] of float: y = [1.0, 6.0, 10.0, 10.0, 7.0, 4.0, 0.0, 0.0];

% Decision variables: circle center (cx, cy) and radius r
var float: cx;
var float: cy;
var float: r;

% For each edge i -> j, ensure the circle is inside:
% If polygon is CCW, interior is to the left of each directed edge.
% Constraint: cross((dx,dy),(P - Pi)) >= r * ||edge||
% where dx = xj-xi, dy = yj-yi and ||edge|| = sqrt(dx^2+dy^2)
constraint r >= 0.0;

constraint
  forall(i in 1..n) (
    let {
      int: j = if i < n then i+1 else 1 endif,
      float: dx = x[j] - x[i],
      float: dy = y[j] - y[i],
      float: len = sqrt(dx*dx + dy*dy)
    } in
      dx*(cy - y[i]) - dy*(cx - x[i]) >= r * len
  );

solve maximize r;

% Report maximal area and radius; area required to 4 significant digits (approx via formatting)
float: pi = 3.14159265358979323846;
output [
  "Center = (", show(cx), ", ", show(cy), ")\n",
  "Radius = ", show(r), "\n",
  "Area = ", show(pi * r * r), "\n"
];