include "globals.mzn";

% Data (embedded from the problem description)
int: total_time_max = 20;
int: x_min_over_y = 5;

int: x_max = 15;
int: y_max = 10;

int: fatigue_x = 2;
int: fatigue_y = 3;

% Decision variables (whole hours)
var 0..x_max: x_hours;
var 0..y_max: y_hours;

% Constraints
constraint x_hours + y_hours <= total_time_max;
constraint x_hours >= y_hours + x_min_over_y;

% Objective: minimize total fatigue
var 0..(fatigue_x*x_max + fatigue_y*y_max): total_fatigue =
  fatigue_x * x_hours + fatigue_y * y_hours;

solve minimize total_fatigue;

output [
  "x_hours = ", show(x_hours), "\n",
  "y_hours = ", show(y_hours), "\n",
  "minimum_total_fatigue = ", show(total_fatigue), "\n"
];