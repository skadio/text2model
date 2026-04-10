% Resource allocation minimization for areas X, Y, Z

int: max_total_units = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 250;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

var int: X;
var int: Y;
var int: Z;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;
constraint X + Y + Z <= max_total_units;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "TotalCost=", show(total_cost), "\n",
  "MinimumTotalCostRounded=", show(total_cost), "\n"
];