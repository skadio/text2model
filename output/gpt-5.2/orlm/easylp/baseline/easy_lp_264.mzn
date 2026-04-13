% Human resources allocation: minimize total cost with minimum staffing and total headcount cap.

int: total_cap = 200;

int: minX = 50;
int: minY = 30;
int: minZ = 20;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

var minX..total_cap: X;
var minY..total_cap: Y;
var minZ..total_cap: Z;

constraint X + Y + Z <= total_cap;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];