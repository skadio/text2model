int: min_total_allocation = 50;

int: costX = 4;
int: costY = 3;

var 0..1000: x; % allocation to project X (integer)
var 0..1000: y; % allocation to project Y (integer)

constraint x + y >= min_total_allocation;
constraint 2*x - y <= 30;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];