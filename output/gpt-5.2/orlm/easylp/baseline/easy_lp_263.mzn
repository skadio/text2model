% Hiring optimization for departments X, Y, Z (all data embedded)

var int: X;
var int: Y;
var int: Z;

% Costs per hire
int: costX = 5000;
int: costY = 7000;
int: costZ = 10000;

% Constraints
constraint X >= 10;
constraint Y >= 15;
constraint Z >= 20;
constraint X + Y + Z <= 50;

% Objective: minimize total cost
var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total hiring cost = $", show(total_cost), "\n"
];