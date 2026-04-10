int: max_total_hires = 10;

int: min_x = 3;
int: min_y = 2;

int: max_x = 7;
int: max_y = 8;

int: cost_x = 50000;
int: cost_y = 40000;

var min_x..max_x: x;
var min_y..max_y: y;

constraint x + y <= max_total_hires;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];