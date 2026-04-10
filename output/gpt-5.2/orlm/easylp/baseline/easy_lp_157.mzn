var 0..1000: X; % number of type X properties purchased
var 0..1000: Y; % number of type Y properties purchased

constraint X + Y <= 1000;
constraint X >= 3 * Y;

var int: total_cost = 300000 * X + 200000 * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];