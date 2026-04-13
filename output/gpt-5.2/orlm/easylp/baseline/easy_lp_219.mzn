% Retail store stocking - minimize cost with integer quantities

int: capacity = 500;

int: minX = 100;
int: minY = 80;
int: minZ = 120;

int: costX = 5;
int: costY = 4;
int: costZ = 6;

var minX..capacity: X;
var minY..capacity: Y;
var minZ..capacity: Z;

constraint X + Y + Z <= capacity;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n",
  "minimum_total_cost_rounded=", show(total_cost), "\n"
];