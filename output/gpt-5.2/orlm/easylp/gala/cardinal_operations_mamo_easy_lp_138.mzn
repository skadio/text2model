% Military logistics allocation (integer optimization)
% Minimize support points (cost) with constraints on total units and combined strength.

int: min_total_units = 100;
int: max_strength = 600;

int: strength_x = 5;
int: strength_y = 3;

int: cost_x = 5000;
int: cost_y = 3000;

% Decision variables (whole numbers)
var 0..10000: x;   % units of type X
var 0..10000: y;   % units of type Y

% Constraints
constraint x + y >= min_total_units;
constraint strength_x * x + strength_y * y <= max_strength;

% Objective: minimize total support points
var 0..int_max: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_support_points = $", show(total_cost), "\n"
];