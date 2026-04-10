int: costX = 50;
int: costY = 80;

var 0..250: X;
var 0..250: Y;

constraint X + Y >= 100;
constraint 2*X + Y <= 250;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];