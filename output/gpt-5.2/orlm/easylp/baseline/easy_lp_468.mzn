int: budget_limit = 100;

int: min_x = 30;
int: min_y = 20;

int: cost_x = 50;
int: cost_y = 60;

var int: x;
var int: y;

constraint x >= min_x;
constraint y >= min_y;
constraint x + y <= budget_limit;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];