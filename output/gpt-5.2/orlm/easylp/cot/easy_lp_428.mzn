% Parameters (with values embedded)
int: total_capacity = 2000;
int: min_x = 800;
int: min_y = 500;
int: cost_x = 50;
int: cost_y = 30;

% Variables
var min_x..total_capacity: x;  % allocation to route X (whole units)
var min_y..total_capacity: y;  % allocation to route Y (whole units)
var 0..(cost_x*total_capacity + cost_y*total_capacity): total_cost;

% Constraints
constraint x + y <= total_capacity;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];