% Telecom resource allocation: minimize total cost subject to linear constraints.
% All data embedded as requested.

int: max_total_units = 2000;
int: min_diff = 500;          % x - 2*y >= 500
int: min_x_units = 750;

int: cost_x = 50;
int: cost_y = 100;

% Decision variables (whole number units)
var 0..max_total_units: x;    % units allocated to Project X
var 0..max_total_units: y;    % units allocated to Project Y

% Constraints
constraint x + y <= max_total_units;
constraint x - 2 * y >= min_diff;
constraint x >= min_x_units;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = $", show(total_cost), "\n"
];