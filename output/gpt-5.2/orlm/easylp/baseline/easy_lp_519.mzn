% Transportation capacity allocation problem (all data embedded)

int: total_cap = 500;

int: minX = 100;
int: minY = 150;
int: minZ = 200;

int: maxX = 300;
int: maxY = 400;
int: maxZ = 600;

int: costX = 5;
int: costY = 10;
int: costZ = 15;

var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

constraint X + Y + Z <= total_cap;
constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(total_cost), "\n",
  "Minimum total cost (rounded to nearest dollar): ", show(total_cost), "\n"
];