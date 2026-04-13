% Parameters
int: N = 8;
set of int: V = 1..N;

array[V] of float: px = [0.0, 0.0, 4.0, 8.0, 11.0, 11.0, 7.0, 1.0];
array[V] of float: py = [1.0, 6.0, 10.0, 10.0, 7.0, 4.0, 0.0, 0.0];

% A big-M valid for all half-plane constraints over bounds [0,11]x[0,10]
float: M = 1000.0;

% Bounding box (from given vertices)
float: xmin = 0.0;
float: xmax = 11.0;
float: ymin = 0.0;
float: ymax = 10.0;

% Variables
var float: cx;
var float: cy;
var float: r;

% Constraints
% Bounds on center and radius
constraint cx >= xmin /\ cx <= xmax;
constraint cy >= ymin /\ cy <= ymax;
constraint r >= 0.0 /\ r <= min(xmax - xmin, ymax - ymin);

% Enforce circle inside polygon using linearized distance to each edge:
% For each directed edge i->j (with j = i+1, and N->1), the inward constraint is:
% (dy)*cx + (-dx)*cy - (dy)*xi + (dx)*yi >= r*sqrt(dx^2+dy^2)
% Since sqrt is nonlinear, we use a piecewise linear outer approximation:
% Replace sqrt(dx^2+dy^2) with a constant L (precomputed per edge) and keep linear.
%
% Precomputed edge normals (a,b) and offsets c such that a*cx + b*cy + c >= r*L
array[V] of float: a = [ 5.0,  4.0,  0.0, -3.0, -3.0, -4.0,  0.0,  1.0];
array[V] of float: b = [ 0.0, -4.0, -4.0, -3.0,  0.0,  4.0,  6.0,  1.0];
array[V] of float: c = [ 0.0, 24.0, 40.0, 54.0, 33.0,-60.0,  0.0, -1.0];

% Edge lengths
array[V] of float: L = [
  5.0,                 % (0,1)->(0,6)
  5.65685424949238,    % (0,6)->(4,10)
  4.0,                 % (4,10)->(8,10)
  4.24264068711929,    % (8,10)->(11,7)
  3.0,                 % (11,7)->(11,4)
  5.65685424949238,    % (11,4)->(7,0)
  7.21110255092798,    % (7,0)->(1,0)
  1.41421356237310     % (1,0)->(0,1)
];

constraint forall(i in V) (
  a[i]*cx + b[i]*cy + c[i] >= r * L[i]
);

% Objective
solve maximize (r);