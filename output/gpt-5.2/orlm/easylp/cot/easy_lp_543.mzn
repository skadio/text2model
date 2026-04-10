% Parameters (with values embedded)
int: total_hours_max = 40;
int: x_max = 15;
int: y_max = 20;
int: z_max = 30;

int: x_ge_y_plus = 5;
int: y_ge_z_plus = 10;

int: fatigue_x = 2;
int: fatigue_y = 3;
int: fatigue_z = 1;

% Variables
var 0..x_max: x_hours;
var 0..y_max: y_hours;
var 0..z_max: z_hours;

var 0..(fatigue_x*x_max + fatigue_y*y_max + fatigue_z*z_max): total_fatigue;

% Constraints
constraint x_hours + y_hours + z_hours <= total_hours_max;
constraint x_hours >= y_hours + x_ge_y_plus;
constraint y_hours >= z_hours + y_ge_z_plus;

constraint total_fatigue = fatigue_x * x_hours + fatigue_y * y_hours + fatigue_z * z_hours;

% Objective
solve minimize total_fatigue;

output [
  "x_hours = ", show(x_hours), "\n",
  "y_hours = ", show(y_hours), "\n",
  "z_hours = ", show(z_hours), "\n",
  "minimum_total_fatigue = ", show(total_fatigue), "\n"
];