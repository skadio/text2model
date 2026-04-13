% Parameters
int: min_total_hours = 10;
int: max_diff_xy = 4;
int: max_diff_yz = 5;

int: max_x = 15;
int: max_y = 20;
int: max_z = 25;

int: fatigue_x = 2;
int: fatigue_y = 3;
int: fatigue_z = 1;

% Variables
var 0..max_x: X;
var 0..max_y: Y;
var 0..max_z: Z;

var 0..(fatigue_x*max_x + fatigue_y*max_y + fatigue_z*max_z): total_fatigue;

% Constraints
constraint X + Y + Z >= min_total_hours;

constraint abs(X - Y) <= max_diff_xy;
constraint abs(Y - Z) <= max_diff_yz;

constraint total_fatigue = fatigue_x * X + fatigue_y * Y + fatigue_z * Z;

% Objective
solve minimize total_fatigue;