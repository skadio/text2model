int: maxXY = 100;
int: maxXZ = 80;
int: minYZ = 70;

int: costX = 2;
int: costY = 3;
int: costZ = 1;

var 0..max(maxXY, maxXZ): X;
var 0..max(maxXY, maxXZ): Y;
var 0..max(maxXY, maxXZ): Z;

constraint X + Y <= maxXY;
constraint X + Z <= maxXZ;
constraint Y + Z >= minYZ;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];