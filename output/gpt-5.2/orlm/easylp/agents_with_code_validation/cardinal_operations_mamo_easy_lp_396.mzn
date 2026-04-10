% Parameters
% Cost coefficients (units of cost per unit resource)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Constraint right-hand sides
int: rhs_x1_x2_max = 1000;   % x1 + x2 <= 1000
int: rhs_2x3_x4_min = 500;   % 2*x3 + x4 >= 500
int: rhs_x1_3x4_max = 1200;  % x1 + 3*x4 <= 1200
int: rhs_x2_2x3_diff = 300;  % x2 - 2*x3 <= 300

% Variables
% Resource allocations (whole numbers, non-negative)
var 0..1000: x1;   % bounded by x1 + x2 <= 1000
var 0..1000: x2;   % bounded by x1 + x2 <= 1000
var 0..600:  x3;   % safe upper bound from 2*x3 + x4 >= 500 and x4 >= 0
var 0..400:  x4;   % safe upper bound from x1 + 3*x4 <= 1200 and x1 >= 0

% Total cost to minimize
var 0..(c1*1000 + c2*1000 + c3*600 + c4*400): total_cost;

% Constraints
% Total cost definition (linear combination of allocations)
constraint
  total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Budget limitation: combined allocation for x1 and x2
constraint
  x1 + x2 <= rhs_x1_x2_max;

% Strategic minimum requirement: 2*x3 + x4 must reach at least the threshold
constraint
  2 * x3 + x4 >= rhs_2x3_x4_min;

% Budget limitation: x1 combined with 3 times x4
constraint
  x1 + 3 * x4 <= rhs_x1_3x4_max;

% Difference constraint: x2 - 2*x3 must not exceed the allowed maximum
constraint
  x2 - 2 * x3 <= rhs_x2_2x3_diff;

% Objective
solve minimize total_cost;

% Optional output (helps see optimal plan and minimum cost)
output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];