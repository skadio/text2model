int: max_XY = 1000;
int: max_YZ = 800;
int: min_XZ = 500;

int: costX = 5;
int: costY = 4;
int: costZ = 3;

var 0..max_XY: X;
var 0..max(max_YZ, min_XZ): Y;
var 0..max(max_YZ, min_XZ): Z;

constraint X + Y <= max_XY;
constraint Y + Z <= max_YZ;
constraint X + Z >= min_XZ;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "Minimum total cost ($)=", show(total_cost), "\n"
];