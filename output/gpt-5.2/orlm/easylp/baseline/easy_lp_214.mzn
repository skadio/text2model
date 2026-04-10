% Resource allocation across departments X, Y, Z
% Minimize total cost subject to budget and minimum allocation constraints.

int: max_total_alloc = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 50;
int: costY = 60;
int: costZ = 70;

var minX..max_total_alloc: X;
var minY..max_total_alloc: Y;
var minZ..max_total_alloc: Z;

constraint X + Y + Z <= max_total_alloc;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total allocation = ", show(X + Y + Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];