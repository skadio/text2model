% Fleet allocation between routes X and Y (all data embedded)

int: max_total = 1000;
int: min_x = 400;
int: min_y = 300;
int: cost_x = 50;
int: cost_y = 60;

var min_x..max_total: x;   % vehicles on route X
var min_y..max_total: y;   % vehicles on route Y

constraint x + y <= max_total;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "Vehicles on X = ", show(x), "\n",
  "Vehicles on Y = ", show(y), "\n",
  "Minimum daily cost ($) = ", show(total_cost), "\n"
];