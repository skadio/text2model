int: costX = 300000;
int: costY = 200000;

var 1..10: x; % number of properties X
var 1..10: y; % number of properties Y

constraint x + y <= 10;
constraint x >= 5 * y;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];