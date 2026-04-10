% Shipping allocation between Port X and Port Y
% All data embedded as per instructions.

% Parameters
int: total_capacity = 2000;
int: cap_per_x = 4;
int: cap_per_y = 5;

int: min_diff_xy = 50;          % x - y >= 50
int: max_x_plus_2y = 1500;      % x + 2y <= 1500

int: cost_x = 2;
int: cost_y = 3;

% Decision variables (whole numbers of shipments)
var 0..total_capacity div cap_per_x: x;  % shipments to Port X
var 0..total_capacity div cap_per_y: y;  % shipments to Port Y

% Constraints
constraint cap_per_x * x + cap_per_y * y <= total_capacity;
constraint x - y >= min_diff_xy;
constraint x + 2 * y <= max_x_plus_2y;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];