% Parameters (with values embedded)
int: max_total_hours = 30;
int: min_diff_XY = 5;
int: max_diff_ZX = 10;

int: fatigue_X = 10;
int: fatigue_Y = 15;
int: fatigue_Z = 20;

% Variables
var 0..max_total_hours: X; % cardio hours (integer)
var 0..max_total_hours: Y; % strength hours (integer)
var 0..max_total_hours: Z; % flexibility hours (integer)

var 0..(fatigue_X*max_total_hours + fatigue_Y*max_total_hours + fatigue_Z*max_total_hours): total_fatigue;

% Constraints
constraint X + Y + Z <= max_total_hours;
constraint X >= Y + min_diff_XY;
constraint abs(Z - X) <= max_diff_ZX;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y + fatigue_Z*Z;

% Objective
solve minimize total_fatigue;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "minimum_total_fatigue=", show(total_fatigue), "\n"
];