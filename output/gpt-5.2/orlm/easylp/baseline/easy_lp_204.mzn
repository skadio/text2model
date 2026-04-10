% Investment allocation optimization (all data embedded)

int: budget = 1000;

int: minX = 300;
int: maxY = 500;
int: minZ = 200;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

var minX..budget: X;
var 0..maxY: Y;
var minZ..budget: Z;

constraint X + Y + Z <= budget;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = $", show(X), "\n",
  "Y = $", show(Y), "\n",
  "Z = $", show(Z), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];