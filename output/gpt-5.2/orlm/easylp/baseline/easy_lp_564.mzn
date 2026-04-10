% Funding allocation optimization for programs X, Y, Z

int: BUDGET_MAX = 1000;

int: minX = 300;
int: minY = 200;
int: minZ = 100;

int: costX = 500;
int: costY = 300;
int: costZ = 200;

var int: X;
var int: Y;
var int: Z;

constraint X >= minX /\ X <= BUDGET_MAX;
constraint Y >= minY /\ Y <= BUDGET_MAX;
constraint Z >= minZ /\ Z <= BUDGET_MAX;

constraint X + Y + Z <= BUDGET_MAX;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];