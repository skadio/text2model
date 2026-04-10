var 0..50: X;
var 0..50: Y;

constraint 2 * X + 3 * Y <= 50;
constraint X + Y >= 10;
constraint abs(X - Y) <= 20;

var int: total_cost = 100 * X + 200 * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];