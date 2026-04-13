int: budget = 50000;
int: target = 10000;

int: costX = 5000;
int: costY = 7000;

int: maxX = 40;
int: maxY = 20;

var 0..maxX: x; % number of employees trained in group X
var 0..maxY: y; % number of employees trained in group Y

constraint costX * x + costY * y <= budget;
constraint 3 * (costX * x) - (costY * y) >= target;

var 0..budget: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];