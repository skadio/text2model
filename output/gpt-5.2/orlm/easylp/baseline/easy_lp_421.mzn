int: max_total_units = 5000;

int: min_x_units = 1000;
int: min_y_units = 1500;

int: cost_x_per_unit = 100;
int: cost_y_per_unit = 75;

var min_x_units..max_total_units: x;
var min_y_units..max_total_units: y;

constraint x + y <= max_total_units;

var int: total_cost = cost_x_per_unit * x + cost_y_per_unit * y;

solve minimize total_cost;

output [
  "x_units = ", show(x), "\n",
  "y_units = ", show(y), "\n",
  "total_units = ", show(x + y), "\n",
  "total_cost = $", show(total_cost), "\n"
];