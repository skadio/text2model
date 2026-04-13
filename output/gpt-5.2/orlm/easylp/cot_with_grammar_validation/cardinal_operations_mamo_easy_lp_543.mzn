% Parameters
int: max_total_hours = 40;
int: max_x = 15;
int: max_y = 20;
int: max_z = 30;

int: min_diff_xy = 5;   % X >= Y + 5
int: min_diff_yz = 10;  % Y >= Z + 10

int: fatigue_x = 2;
int: fatigue_y = 3;
int: fatigue_z = 1;

% Variables
var 0..max_x: x;
var 0..max_y: y;
var 0..max_z: z;

var 0..(fatigue_x*max_x + fatigue_y*max_y + fatigue_z*max_z): total_fatigue;

% Constraints
constraint x + y + z <= max_total_hours;
constraint x >= y + min_diff_xy;
constraint y >= z + min_diff_yz;

constraint total_fatigue = fatigue_x*x + fatigue_y*y + fatigue_z*z;

% Objective
solve minimize total_fatigue;