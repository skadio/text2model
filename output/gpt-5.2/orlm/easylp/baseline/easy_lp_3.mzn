int: BUDGET = 1000;

int: costX = 4;
int: costY = 3;

var 0..BUDGET: x;
var 0..BUDGET: y;

constraint x + y <= BUDGET;
constraint x >= 2 * y + 300;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];