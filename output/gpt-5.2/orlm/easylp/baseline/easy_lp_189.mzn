int: costX = 10;
int: costY = 15;
int: costZ = 20;

var 0..5000: X;
var 0..5000: Y;
var 0..4000: Z;

constraint X + Y <= 5000;
constraint Y + Z <= 4000;
constraint X + Z >= 2000;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];