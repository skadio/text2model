int: max_budget = 100;
int: min_effectiveness = 20;

int: cost_x = 2;
int: cost_y = 3;

var 0..max_budget: x;
var 0..max_budget: y;

constraint x + y <= max_budget;
constraint x + y >= min_effectiveness;

var 0..max_budget*(max(cost_x, cost_y)): total_resource = cost_x * x + cost_y * y;

solve minimize total_resource;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_resource = ", show(total_resource), "\n"
];