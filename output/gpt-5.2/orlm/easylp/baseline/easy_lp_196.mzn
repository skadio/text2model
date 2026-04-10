% Portfolio cost minimization with embedded data

int: budget = 500;

int: minX = 100;
int: minY = 50;
int: minZ = 30;

int: costX = 1000;
int: costY = 1500;
int: costZ = 2000;

var int: X;
var int: Y;
var int: Z;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= budget;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost (USD) = ", show(total_cost), "\n"
];