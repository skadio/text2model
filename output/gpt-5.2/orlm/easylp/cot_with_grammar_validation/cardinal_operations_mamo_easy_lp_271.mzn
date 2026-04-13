% Parameters
int: fatigue_X = 10;
int: fatigue_Y = 15;
int: fatigue_Z = 5;

int: min_XY = 8;
int: max_YZ = 20;
int: diff_XZ = 3;

% Bounds on training hours (not explicitly given in the description, so use safe nonnegative bounds)
int: UB = 100;

% Variables
var 0..UB: X; % hours for group X (strength)
var 0..UB: Y; % hours for group Y (skill)
var 0..UB: Z; % hours for group Z (strategy)

var 0..(fatigue_X*UB + fatigue_Y*UB + fatigue_Z*UB): total_fatigue;

% Constraints
constraint X + Y >= min_XY;
constraint Y + Z <= max_YZ;
constraint X >= Z + diff_XZ;

constraint total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;

% Objective
solve minimize total_fatigue;