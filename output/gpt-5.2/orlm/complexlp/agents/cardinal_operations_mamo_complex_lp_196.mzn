% Parameters
% Polygon vertices in counter-clockwise order (embedded data as required)
int: n = 8;                              % number of vertices
set of int: V = 1..n;                    % vertex index set
array[V] of float: px = [0.0, 0.0, 4.0, 8.0, 11.0, 11.0, 7.0, 1.0];  % x-coordinates
array[V] of float: py = [1.0, 6.0, 10.0, 10.0, 7.0, 4.0, 0.0, 0.0]; % y-coordinates

% Precomputed edge differences (for linear halfspace constraints)
array[V] of float: ex = [ px[if i < n then i+1 else 1 endif] - px[i] | i in V ];
array[V] of float: ey = [ py[if i < n then i+1 else 1 endif] - py[i] | i in V ];

% Variables
% Conservative bounding box bounds for center to keep search bounded/numerically stable.
var 0.0..11.0: cx;                       % x-coordinate of circle center
var 0.0..10.0: cy;                       % y-coordinate of circle center
var 0.0..20.0: r;                        % circle radius (to be maximized)
var 0.0..(pi*20.0*20.0): area;           % reported area = pi * r^2

% Constraints
% --- Nonnegativity / basic feasibility of radius ---
constraint r >= 0.0;

% --- Circle must lie inside the (CCW) polygon: distance from center to each edge >= r ---
% For each directed edge i -> i+1, interior is to the left.
% Halfspace: (cy - py[i]) * ex[i] - (cx - px[i]) * ey[i] >= r * sqrt(ex[i]^2 + ey[i]^2)
constraint
  forall(i in V) (
    (cy - py[i]) * ex[i] - (cx - px[i]) * ey[i]
    >= r * sqrt(ex[i]*ex[i] + ey[i]*ey[i])
  );

% --- Define reported area (not an objective) ---
constraint area = pi * r * r;

% Objective
solve maximize r;