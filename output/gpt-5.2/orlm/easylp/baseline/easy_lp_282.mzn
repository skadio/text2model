% Tourism budget allocation: minimize total cost subject to budget and minimums

int: BUDGET = 5000;

int: minX = 1500;
int: minY = 800;
int: minZ = 700;

int: costX = 100;
int: costY = 200;
int: costZ = 50;

var int: X;
var int: Y;
var int: Z;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= BUDGET;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(total_cost), "\n"
];