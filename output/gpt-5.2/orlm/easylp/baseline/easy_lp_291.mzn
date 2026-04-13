% University resource allocation across departments X, Y, Z
% Minimize total cost subject to minimum allocations and total budget.

int: total_budget = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 120;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

var int: X;
var int: Y;
var int: Z;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= total_budget;

% Nonnegative, integral allocations
constraint X >= 0 /\ Y >= 0 /\ Z >= 0;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_allocation=", show(X + Y + Z), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];