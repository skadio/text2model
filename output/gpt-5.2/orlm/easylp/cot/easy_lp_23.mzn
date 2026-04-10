% Parameters (with values embedded)
int: capacity = 200;
int: demand = 400;
int: costX = 500;
int: costY = 300;

% Variables
var 0..capacity: X;
var 0..capacity: Y;
var int: total_cost;

% Constraints
constraint X + Y <= capacity;
constraint 3 * X + 2 * Y >= demand;
constraint total_cost = costX * X + costY * Y;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];