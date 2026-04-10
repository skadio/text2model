% Parameters (with values embedded)
int: capacity = 1000;
int: demand_min = 800;
int: balance_max_diff = 200;
int: costX = 2;
int: costY = 3;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var 0..(costX*capacity + costY*capacity): total_cost;

% Constraints
constraint X + Y <= capacity;
constraint 2*X + Y >= demand_min;
constraint abs(X - 2*Y) <= balance_max_diff;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];