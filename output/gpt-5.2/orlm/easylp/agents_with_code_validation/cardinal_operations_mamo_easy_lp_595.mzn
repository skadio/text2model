% Parameters
% Cost coefficients for projects X1..X4
array[1..4] of int: cost = [4, 5, 6, 7];

% Constraint bounds/requirements
int: max_x1_x2 = 1000;              % X1 + X2 <= 1000
int: min_x2_x3 = 800;               % X2 + X3 >= 800
int: diff_x3_x4 = 200;              % X3 - X4 = 200
int: max_half_x4_minus_x1 = 300;    % (X4/2) - X1 <= 300

% Project indices (not strictly required, but kept for clarity/consistency)
set of int: PROJECTS = 1..4;

% Variables
% Resource allocations for each project (integer, nonnegative)
var 0..10000: x1;
var 0..10000: x2;
var 0..10000: x3;
var 0..10000: x4;

% Total cost (to be minimized)
var int: total_cost;

% Constraints
% Cost aggregation constraint
constraint
  total_cost = cost[1] * x1 + cost[2] * x2 + cost[3] * x3 + cost[4] * x4;

% Budgetary / investment strategy limits
constraint x1 + x2 <= max_x1_x2;
constraint x2 + x3 >= min_x2_x3;

% Exact difference requirement (X3 vs X4)
constraint x3 - x4 = diff_x3_x4;

% Half-allocation constraint, linearized to avoid fractional division:
% (x4/2) - x1 <= 300  <=>  x4 - 2*x1 <= 600
constraint x4 - 2 * x1 <= 2 * max_half_x4_minus_x1;

% Objective
solve minimize total_cost;

% Optional output
output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];