% Maximal inscribed circle in a given polygon (linear formulation via halfspaces)
% Polygon vertices in CCW order:
% (0,1),(0,6),(4,10),(8,10),(11,7),(11,4),(7,0),(1,0)
%
% Maximize area = pi * r^2. Since pi is constant and r >= 0, maximizing area
% is equivalent to maximizing r (radius).
%
% Linear constraints: for each polygon edge, center (cx,cy) must be at least r
% away from the supporting line towards the inside:
%   n_i · (c - p_i) >= r
% where n_i is inward unit normal of the directed edge p_i -> p_{i+1}.
% For a CCW polygon, inward normal of edge (dx,dy) is (-dy, dx), then normalized.

int: n = 8;

array[1..n] of float: px = [0.0, 0.0, 4.0, 8.0, 11.0, 11.0, 7.0, 1.0];
array[1..n] of float: py = [1.0, 6.0,10.0,10.0,  7.0,  4.0, 0.0, 0.0];

array[1..n] of float: dx = [ px[if i<n then i+1 else 1] - px[i] | i in 1..n ];
array[1..n] of float: dy = [ py[if i<n then i+1 else 1] - py[i] | i in 1..n ];
array[1..n] of float: len = [ sqrt(dx[i]*dx[i] + dy[i]*dy[i]) | i in 1..n ];

% Inward unit normals (CCW polygon)
array[1..n] of float: nx = [ (-dy[i]) / len[i] | i in 1..n ];
array[1..n] of float: ny = [ ( dx[i]) / len[i] | i in 1..n ];

% Center and radius
var float: cx;
var float: cy;
var float: r;

constraint r >= 0.0;

% Keep center within a reasonable bounding box (helps numerics)
constraint cx >= 0.0 /\ cx <= 11.0;
constraint cy >= 0.0 /\ cy <= 10.0;

% Halfspace constraints: distance to each edge >= r
constraint
  forall(i in 1..n)(
    nx[i]*(cx - px[i]) + ny[i]*(cy - py[i]) >= r
  );

solve maximize r;

% Report maximal area in 4 significant digits
float: pi = 3.14159265358979323846;
var float: area = pi * r * r;

output [
  "cx = ", show(cx), "\n",
  "cy = ", show(cy), "\n",
  "r  = ", show(r), "\n",
  "area = ", show_float(4, area), "\n"
];