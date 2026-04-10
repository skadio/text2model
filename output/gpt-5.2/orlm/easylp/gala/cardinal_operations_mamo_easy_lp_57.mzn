% Budget allocation between goods X and Y
% Embed all data directly (no .dzn)

int: max_budget = 2000;

int: x_min = 0;
int: x_max = 1500;

int: y_min = 0;
int: y_max = 1000;

int: cost_x = 2;
int: cost_y = 3;

% Decision variables: allocations are whole numbers
var x_min..x_max: x;
var y_min..y_max: y;

% Constraints
constraint x + y <= max_budget;

% "X must be at least half of Y plus 500": x >= 0.5*y + 500
% Use integer-safe form:
constraint 2 * x >= y + 1000;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];