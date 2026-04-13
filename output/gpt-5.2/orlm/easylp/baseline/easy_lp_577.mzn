int: costX = 5;
int: costY = 4;
int: costZ = 3;

int: maxX = 100;
int: maxY = 120;
int: maxZ = 90;

var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

constraint X + Y <= 200;
constraint Y + Z >= 150;
constraint X - Z = 30;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];