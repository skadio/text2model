int: costX = 5;
int: costY = 6;
int: costZ = 3;

var 0..700: X;
var 0..500: Y;
var 0..600: Z;

constraint X + Y <= 1000;
constraint Y + Z <= 1200;
constraint abs(X - Z) >= 200;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n",
  "total_cost_rounded=", show(total_cost), "\n"
];