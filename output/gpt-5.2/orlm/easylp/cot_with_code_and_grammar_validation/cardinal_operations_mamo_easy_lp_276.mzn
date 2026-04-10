% Parameters
int: total_hours_max = 30;
int: x_at_least_y_plus = 5;
int: z_minus_x_abs_max = 10;

int: fatigue_x = 10;
int: fatigue_y = 15;
int: fatigue_z = 20;

% Variables
var 0..total_hours_max: X;
var 0..total_hours_max: Y;
var 0..total_hours_max: Z;

var 0..(fatigue_x*total_hours_max + fatigue_y*total_hours_max + fatigue_z*total_hours_max): total_fatigue;

% Constraints
constraint X + Y + Z <= total_hours_max;

constraint X >= Y + x_at_least_y_plus;

constraint abs(Z - X) <= z_minus_x_abs_max;

constraint total_fatigue = fatigue_x * X + fatigue_y * Y + fatigue_z * Z;

% Objective
solve minimize total_fatigue;