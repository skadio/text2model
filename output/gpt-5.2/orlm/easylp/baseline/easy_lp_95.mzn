int: max_total = 1000;
int: min_service = 500;

int: costX = 5;
int: costY = 7;

var 0..max_total: x;
var 0..max_total: y;

constraint x + y <= max_total;
constraint 2*x + y >= min_service;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];