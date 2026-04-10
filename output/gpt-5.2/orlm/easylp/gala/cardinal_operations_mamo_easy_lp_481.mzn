include "globals.mzn";

% Data embedded from the description
int: total_limit = 500;
int: min_diff = 100;
int: x_max = 350;

int: cost_x = 20;
int: cost_y = 10;

% Decision variables (whole-number allocations)
var 0..x_max: x;                 % resources for initiative X
var 0..total_limit: y;           % resources for initiative Y (upper bound tightened by total_limit)

% Constraints
constraint x + y <= total_limit;
constraint x >= y + min_diff;
constraint x <= x_max;

% Objective: minimize total cost
var 0..(cost_x*x_max + cost_y*total_limit): total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n",
  "minimum_total_cost_rounded = ", show(total_cost), "\n"
];