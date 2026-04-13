% Production planning: minimize cost with capacity and demand constraints

% Parameters (embedded from problem statement)
int: costX = 5000;
int: costY = 3000;
int: capacity = 1000;
int: demand = 2000;          % requirement: 3*X + 2*Y >= 2000
int: minDiff = 150;          % requirement: X - Y >= 150

% Decision variables (integers)
var 0..capacity: x;          % units of product X
var 0..capacity: y;          % units of product Y

% Constraints
constraint x + y <= capacity;
constraint 3*x + 2*y >= demand;
constraint x - y >= minDiff;

% Objective: minimize total cost
var int: total_cost = costX * x + costY * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];