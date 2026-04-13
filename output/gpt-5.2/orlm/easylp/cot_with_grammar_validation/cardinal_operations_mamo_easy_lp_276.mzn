% Parameters
int: max_total_hours = 30;
int: min_x_minus_y = 5;
int: max_z_minus_x_abs = 10;

int: fatigue_x = 10;
int: fatigue_y = 15;
int: fatigue_z = 20;

% Variables
var 0..max_total_hours: X;
var 0..max_total_hours: Y;
var 0..max_total_hours: Z;

var 0..(fatigue_x*max_total_hours + fatigue_y*max_total_hours + fatigue_z*max_total_hours): total_fatigue;

% Constraints
constraint X + Y + Z <= max_total_hours;
constraint X - Y >= min_x_minus_y;
constraint abs(Z - X) <= max_z_minus_x_abs;

constraint total_fatigue = fatigue_x * X + fatigue_y * Y + fatigue_z * Z;

% Objective
solve minimize total_fatigue;