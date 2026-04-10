% Parameters
int: min_total_hours = 10;
int: max_diff_XY = 4;
int: max_diff_YZ = 5;

int: fatigue_X = 2;
int: fatigue_Y = 3;
int: fatigue_Z = 1;

int: ub_X = 15;
int: ub_Y = 20;
int: ub_Z = 25;

% Variables
var 0..ub_X: X;
var 0..ub_Y: Y;
var 0..ub_Z: Z;

var 0..(fatigue_X*ub_X + fatigue_Y*ub_Y + fatigue_Z*ub_Z): total_fatigue;

% Constraints
constraint X + Y + Z >= min_total_hours;

constraint abs(X - Y) <= max_diff_XY;
constraint abs(Y - Z) <= max_diff_YZ;

constraint total_fatigue = fatigue_X*X + fatigue_Y*Y + fatigue_Z*Z;

% Objective
solve minimize total_fatigue;