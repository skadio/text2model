% Tour operator trips X, Y, Z: minimize total cost subject to minimum tourists
% and a maximum total tourists constraint. All data embedded as requested.

int: maxTotal = 50;

int: minX = 10;
int: minY = 5;
int: minZ = 8;

int: costX = 100;
int: costY = 80;
int: costZ = 150;

var minX..maxTotal: X;
var minY..maxTotal: Y;
var minZ..maxTotal: Z;

constraint X + Y + Z <= maxTotal;

var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(totalCost), "\n"
];