% Tourism company resource allocation across projects X, Y, Z
% Minimize total cost subject to budget and bounds. Integer allocations.

int: max_total_alloc = 500;

int: minX = 100;
int: minY = 50;
int: minZ = 20;

int: maxX = 300;
int: maxY = 200;
int: maxZ = 100;

int: costX = 40;
int: costY = 60;
int: costZ = 100;

var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

constraint X + Y + Z <= max_total_alloc;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total allocation = ", show(X + Y + Z), "\n",
  "Minimum total cost (rounded) = $", show(total_cost), "\n"
];