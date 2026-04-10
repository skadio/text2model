% Parameters (with values embedded)
int: max_total_hours = 24;
int: min_x = 6;
int: min_y = 4;
int: min_z = 2;

int: cost_x = 8;
int: cost_y = 5;
int: cost_z = 7;

% Variables
var 0..max_total_hours: x_hours;
var 0..max_total_hours: y_hours;
var 0..max_total_hours: z_hours;

var 0..100000: total_cost;

% Constraints
constraint x_hours >= min_x;
constraint y_hours >= min_y;
constraint z_hours >= min_z;

constraint x_hours + y_hours + z_hours <= max_total_hours;

constraint total_cost = cost_x * x_hours + cost_y * y_hours + cost_z * z_hours;

% Objective
solve minimize total_cost;

output [
  "x_hours=", show(x_hours), "\n",
  "y_hours=", show(y_hours), "\n",
  "z_hours=", show(z_hours), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];