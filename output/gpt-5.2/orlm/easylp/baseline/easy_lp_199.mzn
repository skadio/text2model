% Portfolio investment minimization (all data embedded)

int: budget = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 250;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

var minX..budget: X;
var minY..budget: Y;
var minZ..budget: Z;

constraint X + Y + Z <= budget;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost (nearest dollar) = $", show(total_cost), "\n"
];