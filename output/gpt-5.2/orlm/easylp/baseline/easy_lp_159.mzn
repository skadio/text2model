int: max_units = 1000;
int: min_diverse = 500;
int: max_diff = 200;

int: cost_x = 200;
int: cost_y = 300;

var 0..max_units: x;
var 0..max_units: y;

constraint x + y <= max_units;
constraint 2 * x + y >= min_diverse;
constraint abs(x - y) <= max_diff;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];