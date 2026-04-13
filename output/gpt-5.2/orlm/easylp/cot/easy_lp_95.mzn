% Parameters (with values embedded)
int: max_total = 1000;
int: min_service = 500;
int: cost_x = 5;
int: cost_y = 7;

% Variables
var 0..max_total: x;          % allocation to center X (integer units)
var 0..max_total: y;          % allocation to center Y (integer units)
var 0..(cost_x*max_total + cost_y*max_total): total_cost;

% Constraints
constraint x + y <= max_total;
constraint 2*x + y >= min_service;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];