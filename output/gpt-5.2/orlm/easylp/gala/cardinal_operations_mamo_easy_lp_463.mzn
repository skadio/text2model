% Supply chain resource allocation between warehouses X and Y
% All data embedded as per instructions.

int: total_limit = 5000;
int: min_x = 1000;
int: max_y = 3000;

int: cost_x = 50;
int: cost_y = 75;

% Decision variables (whole units)
var 0..total_limit: x;  % allocation to warehouse X
var 0..total_limit: y;  % allocation to warehouse Y

% Constraints
constraint x + y <= total_limit;
constraint x >= min_x;
constraint y <= max_y;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];