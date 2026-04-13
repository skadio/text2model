% Parameters (with values embedded)
int: capacity = 300;
int: demand_rhs = 800;
int: demand_x_coeff = 3;
int: demand_y_coeff = 4;
int: cost_x = 50;
int: cost_y = 70;

% Variables
var 0..capacity: x; % units of product X (integer)
var 0..capacity: y; % units of product Y (integer)

% Constraints
constraint x + y <= capacity;
constraint demand_x_coeff * x + demand_y_coeff * y >= demand_rhs;
constraint x >= y;

% Objective
var int: total_cost = cost_x * x + cost_y * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];