% Supply chain resource allocation (integer linear optimization)

int: max_total = 1000;
int: min_service = 500;

int: costX = 5;
int: costY = 7;

% Decision variables (whole units)
var 0..max_total: x;  % allocation to center X
var 0..max_total: y;  % allocation to center Y

% Constraints
constraint x + y <= max_total;
constraint 2*x + y >= min_service;

% Objective: minimize total cost
var 0..(costX*max_total + costY*max_total): total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];