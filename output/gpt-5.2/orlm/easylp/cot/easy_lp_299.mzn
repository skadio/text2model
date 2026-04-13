% Parameters (with values embedded)
int: max_total_alloc = 1000;
int: costX = 5;
int: costY = 2;
int: costZ = 3;

% Variables
var 0..max_total_alloc: X;
var 0..max_total_alloc: Y;
var 0..max_total_alloc: Z;

% Constraints
constraint X + Y + Z <= max_total_alloc;
constraint X - Y >= 10;
constraint Z - Y <= 20;

% Objective
var int: total_cost = costX * X + costY * Y + costZ * Z;
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];