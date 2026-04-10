% Hospital budget allocation (integer units), minimize total expenditure.

int: max_total_units = 200;
int: min_x_units = 50;
int: min_y_units = 30;

int: cost_x = 5000;  % dollars per unit for Department X
int: cost_y = 8000;  % dollars per unit for Department Y

var int: x >= min_x_units;
var int: y >= min_y_units;

constraint x + y <= max_total_units;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x_units=", show(x), "\n",
  "y_units=", show(y), "\n",
  "total_cost_dollars=", show(total_cost), "\n"
];