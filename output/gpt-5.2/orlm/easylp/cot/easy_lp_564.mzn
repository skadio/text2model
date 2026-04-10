% Parameters (with values embedded)
int: budget = 1000;
int: minX = 300;
int: minY = 200;
int: minZ = 100;

int: costX = 500;
int: costY = 300;
int: costZ = 200;

% Variables
var minX..budget: X;
var minY..budget: Y;
var minZ..budget: Z;

var 0..(costX*budget + costY*budget + costZ*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];