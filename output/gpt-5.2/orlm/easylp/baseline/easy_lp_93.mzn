int: capacity = 1000;
int: demand = 800;
int: balance = 200;

int: costX = 2;
int: costY = 3;

var 0..capacity: X;
var 0..capacity: Y;

constraint X + Y <= capacity;
constraint 2*X + Y >= demand;
constraint X - 2*Y <= balance;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total distribution cost ($) = ", show(total_cost), "\n"
];