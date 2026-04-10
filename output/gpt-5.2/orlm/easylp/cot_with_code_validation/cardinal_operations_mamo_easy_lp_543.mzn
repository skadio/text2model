% Parameters
int: max_total_hours = 40;
int: min_diff_XY = 5;
int: min_diff_YZ = 10;

int: max_X = 15;
int: max_Y = 20;
int: max_Z = 30;

int: fatigue_X = 2;
int: fatigue_Y = 3;
int: fatigue_Z = 1;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..max_Z: Z;

var 0..(fatigue_X*max_X + fatigue_Y*max_Y + fatigue_Z*max_Z): total_fatigue;

% Constraints
constraint X + Y + Z <= max_total_hours;

constraint X >= Y + min_diff_XY;
constraint Y >= Z + min_diff_YZ;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y + fatigue_Z*Z;

% Objective
solve minimize total_fatigue;