% Parameters (with values embedded)
int: n = 8;
array[1..n] of float: px = [0.0, 0.0, 4.0, 8.0, 11.0, 11.0, 7.0, 1.0];
array[1..n] of float: py = [1.0, 6.0, 10.0, 10.0, 7.0, 4.0, 0.0, 0.0];

float: PI = 3.141592653589793;

% Precompute edge coefficients for inequalities a*x + b*y <= c (polygon given in order)
array[1..n] of float: a = [ py[2]-py[1], py[3]-py[2], py[4]-py[3], py[5]-py[4],
                            py[6]-py[5], py[7]-py[6], py[8]-py[7], py[1]-py[8] ];
array[1..n] of float: b = [ -(px[2]-px[1]), -(px[3]-px[2]), -(px[4]-px[3]), -(px[5]-px[4]),
                            -(px[6]-px[5]), -(px[7]-px[6]), -(px[8]-px[7]), -(px[1]-px[8]) ];
array[1..n] of float: c = [ a[1]*px[1] + b[1]*py[1], a[2]*px[2] + b[2]*py[2],
                            a[3]*px[3] + b[3]*py[3], a[4]*px[4] + b[4]*py[4],
                            a[5]*px[5] + b[5]*py[5], a[6]*px[6] + b[6]*py[6],
                            a[7]*px[7] + b[7]*py[7], a[8]*px[8] + b[8]*py[8] ];

% Lower bounds for signed-distance constraints (if a*x+b*y >= c)
array[1..n] of float: d2 = [ a[i]*px[ (i mod n) + 1 ] + b[i]*py[ (i mod n) + 1 ] - c[i] | i in 1..n ];
array[1..n] of float: dmin = [ if d2[i] < 0.0 then d2[i] else 0.0 endif | i in 1..n ];

% Big-M for inside/outside orientation selection
float: M = 1.0e5;

% Variables
var float: x;
var float: y;
var float: r;                 % radius
array[1..n] of var 0..1: s;    % selects inequality direction per edge (0: <= , 1: >=)

% Constraints
constraint r >= 0.0;

% (optional) loose bounds for numerical stability
constraint x >= -100.0 /\ x <= 100.0;
constraint y >= -100.0 /\ y <= 100.0;
constraint r <= 100.0;

% Maximal inscribed circle (linear formulation via halfspaces):
% For each edge i, enforce either:
%   a_i*x + b_i*y <= c_i - r*||n||   (when s[i]=0)
% or
%   a_i*x + b_i*y >= c_i + r*||n||   (when s[i]=1)
% Using big-M linearization (with precomputed dmin bounds for the >= side)
array[1..n] of float: normn = [ sqrt(a[i]*a[i] + b[i]*b[i]) | i in 1..n ];

constraint forall(i in 1..n)(
  (a[i]*x + b[i]*y) <= (c[i] - r*normn[i]) + M*s[i]
);

constraint forall(i in 1..n)(
  (a[i]*x + b[i]*y) >= (c[i] + r*normn[i]) + (dmin[i] - M)*(1.0 - s[i])
);

% Fix polygon orientation choice consistently by pinning one edge to its natural inward side.
% The given vertex order is clockwise; inward is a*x+b*y >= c for each edge.
constraint s[1] = 1;

% Objective
% Maximizing area is equivalent to maximizing r (since area = PI*r^2, PI>0)
solve maximize r;

% Report maximal area (4 significant digits requested)
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "r = ", show(r), "\n",
  "area = ", show(PI*r*r), "\n"
];