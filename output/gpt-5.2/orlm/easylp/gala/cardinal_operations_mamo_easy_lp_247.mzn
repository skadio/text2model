include "globals.mzn";

/*** Data (embedded as requested) ***/
int: max_total_hours = 24;

int: min_x = 6;
int: min_y = 4;
int: min_z = 2;

int: cost_x = 8;
int: cost_y = 5;
int: cost_z = 7;

/*** Decision variables (integer hours) ***/
var min_x..max_total_hours: x_hours;
var min_y..max_total_hours: y_hours;
var min_z..max_total_hours: z_hours;

/*** Constraints ***/
constraint x_hours + y_hours + z_hours <= max_total_hours;

/*** Objective ***/
var int: total_cost = cost_x * x_hours + cost_y * y_hours + cost_z * z_hours;

solve minimize total_cost;

/*** Output ***/
output [
  "x_hours = ", show(x_hours), "\n",
  "y_hours = ", show(y_hours), "\n",
  "z_hours = ", show(z_hours), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];