% Costs per unit
int: c1 = 10;
int: c2 = 15;
int: c3 = 25;
int: c4 = 35;

% Bounds (not provided in the prompt). To avoid an unbounded model (which can
% cause solvers to hang/time out), we enforce non-negativity and add safe
% implied upper bounds from the given constraints.
var 0..60: x1;
var 0..60: x2;
var 0..40: x3;
var 0..40: x4;

% Constraints
constraint x1 + x2 >= 20;
constraint x3 + x4 <= 40;
constraint x1 - 2 * x3 >= 5;
constraint x4 - x2 <= 10;

% Objective
var int: total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];