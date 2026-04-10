int: max_total = 1000;

int: costX = 5;
int: costY = 2;
int: costZ = 3;

var 0..max_total: X;
var 0..max_total: Y;
var 0..max_total: Z;

constraint X + Y + Z <= max_total;
constraint X - Y >= 10;
constraint Z - Y <= 20;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(total_cost), "\n"
];