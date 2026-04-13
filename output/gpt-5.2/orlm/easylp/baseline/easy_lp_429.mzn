int: max_total = 1000;

int: min_x = 200;
int: min_y = 300;

int: max_x = 500;
int: max_y = 700;

int: cost_x = 50;
int: cost_y = 70;

var min_x..max_x: x;
var min_y..max_y: y;

constraint x + y <= max_total;

var int: total_support = cost_x * x + cost_y * y;

solve minimize total_support;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_support_points=", show(total_support), "\n"
];