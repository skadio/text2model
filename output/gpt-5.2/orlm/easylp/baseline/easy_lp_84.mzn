int: max_hours = 40;
int: min_output = 20;

int: cost_x = 8;
int: cost_y = 6;

var 0..max_hours: X;
var 0..max_hours: Y;

constraint X + Y <= max_hours;
constraint 2 * X + Y >= min_output;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];