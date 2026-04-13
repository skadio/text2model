int: max_total_hours = 24;
int: min_x_hours = 4;
int: min_y_hours = 6;

int: cost_x_per_hour = 8;
int: cost_y_per_hour = 10;

var 0..max_total_hours: x_hours;
var 0..max_total_hours: y_hours;

constraint x_hours >= min_x_hours;
constraint y_hours >= min_y_hours;
constraint x_hours + y_hours <= max_total_hours;

var int: total_cost = cost_x_per_hour * x_hours + cost_y_per_hour * y_hours;

solve minimize total_cost;

output [
  "Team X hours: ", show(x_hours), "\n",
  "Team Y hours: ", show(y_hours), "\n",
  "Minimum total cost ($): ", show(total_cost), "\n"
];